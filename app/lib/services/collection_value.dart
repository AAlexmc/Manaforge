/// Valoración de la colección: UNA sola fórmula compartida por Home y
/// Mercado (antes cada pantalla calculaba a su manera y los totales no
/// cuadraban: Home siempre a nivel carta, Mercado por edición exacta).
///
/// Canon = el criterio de Mercado: con datos de printing, cada copia vale
/// lo que vale SU edición (una printing sin precio en la DB cuenta 0);
/// sin datos de printing (colecciones antiguas), precio a nivel carta y
/// el resultado se marca como aproximado.
library;

import 'card_database.dart';
import 'collection_store.dart';

class CollectionValuation {
  final double total;

  /// Cartas valoradas a nivel oracle (para el "top joyas"), ordenadas por
  /// valor total descendente.
  final List<ValuedCard> valued;

  /// true = sin datos de edición exacta; el total es orientativo.
  final bool approximate;

  const CollectionValuation(
      {required this.total, required this.valued, required this.approximate});
}

Future<CollectionValuation> computeCollectionValue({
  required List<OwnedCard> cards,
  required bool byPrinting,
  required Map<String, int> printingQty,
  required Future<Map<String, double>> Function(Iterable<String>)
      oraclePrices,
  required Future<Map<String, double>> Function(Iterable<String>)
      printingPrices,

  /// A qué carta pertenece cada impresión conocida ("set|nº" -> oracleId,
  /// típicamente [CollectionStore.printingOwner]). `null` = no se sabe (el
  /// llamador no lo pasa): se mantiene el criterio antiguo, solo aproximado
  /// cuando no hay datos de printing en absoluto.
  ///
  /// Con datos de printing, una carta cuyas copias CONOCIDAS (sumando las
  /// impresiones que son suyas en [printingQty]) no llegan a las que
  /// [OwnedCard.qty] dice que tienes —por ejemplo 3 copias con solo 1
  /// edición apuntada— no suma nada por las que faltan: el resultado se
  /// marca aproximado en vez de enseñar un total que parece exacto y no lo
  /// es. "Tiene ALGUNA impresión" no basta: hay que cubrir TODAS las copias.
  Map<String, String>? printingOwner,

  /// Copias FOIL por impresión ("set|nº" -> nº de foils, subconjunto de
  /// [printingQty]). Con [foilPrices], esas copias se valoran a precio foil
  /// (con fallback al normal si el mercado no lo publica): antes el total
  /// las contaba a precio normal mientras los logros las contaban a foil, y
  /// el logro de la vitrina podía superar al total entero.
  Map<String, int>? foilQty,
  Future<Map<String, double>> Function(Iterable<String>)? foilPrices,
}) async {
  double total = 0;
  final valued = <ValuedCard>[];
  final oracle = await oraclePrices(cards.map((c) => c.oracleId));

  if (byPrinting) {
    final prices = await printingPrices(printingQty.keys);
    final foils = foilQty ?? const <String, int>{};
    final foilPrecios = (foilPrices != null && foils.isNotEmpty)
        ? await foilPrices(foils.keys)
        : const <String, double>{};
    printingQty.forEach((key, qty) {
      // las foils no pueden pasar de las copias de esa impresión (la
      // colección ya lo garantiza, pero aquí no se confía)
      final nFoil = (foils[key] ?? 0).clamp(0, qty);
      final unitNormal = prices[key] ?? 0;
      final unitFoil = foilPrecios[key] ?? unitNormal;
      total += unitNormal * (qty - nFoil) + unitFoil * nFoil;
    });
  }
  for (final c in cards) {
    final unit = oracle[c.oracleId] ?? 0;
    if (!byPrinting) total += unit * c.qty;
    valued.add(ValuedCard(
      oracleId: c.oracleId,
      name: c.name,
      printedName: c.printedName,
      imageSmall: c.imageSmall,
      imageNormal: c.imageNormal,
      colors: c.colors,
      qty: c.qty,
      unitPrice: unit,
    ));
  }
  valued.sort((a, b) => b.total.compareTo(a.total));
  var approximate = !byPrinting;
  if (byPrinting && printingOwner != null) {
    // copias CONOCIDAS por carta: sumar las impresiones que son suyas, no
    // solo mirar si tiene alguna (una carta con qty 3 y 1 sola edición
    // apuntada saldría "exacta" con ese criterio, y no lo es)
    final cubiertas = <String, int>{};
    printingQty.forEach((key, qty) {
      final oracleId = printingOwner[key];
      if (oracleId == null) return;
      cubiertas[oracleId] = (cubiertas[oracleId] ?? 0) + qty;
    });
    approximate =
        cards.any((c) => c.qty > 0 && (cubiertas[c.oracleId] ?? 0) < c.qty);
  }
  return CollectionValuation(total: total, valued: valued, approximate: approximate);
}

/// Atajo con la base de cartas y la colección de verdad: valora la
/// colección ENTERA con la fórmula canónica.
///
/// Antes de valorar, aprende de quién es cada impresión que aún no lo sepa
/// (colecciones de antes de esta versión saben qué ediciones tienen pero no
/// de qué carta es cada una) y lo deja guardado en [collection] — el mismo
/// prólogo que ya hacían Mercado y Colección por su cuenta. Sin este
/// prólogo el total puede salir marcado aproximado (~) cuando en realidad
/// ya se puede saber exacto, o al revés: por eso vive aquí y no repetido en
/// cada pantalla, que es como se descuadraban entre sí.
Future<CollectionValuation> collectionValue({
  required CardDatabase db,
  required CollectionStore collection,
}) async {
  final byPrinting = collection.hasPrintingData;
  final printingQty = collection.printingQty;
  // solo las impresiones que aún no sabemos de quién son: este helper corre
  // en cada aviso del store (Inicio, Mercado, Colección, logros a la vez) y
  // sin el cortocircuito re-barría la colección ENTERA en cada notificación
  final yaSabidos = collection.printingOwner;
  final faltan = [
    for (final k in printingQty.keys)
      if (!yaSabidos.containsKey(k)) k
  ];
  if (byPrinting && faltan.isNotEmpty) {
    final owners = await db.oracleByPrintings(faltan);
    if (owners.isNotEmpty) collection.backfillPrintingOwners(owners);
  }
  return computeCollectionValue(
    cards: collection.cards,
    byPrinting: byPrinting,
    printingQty: printingQty,
    oraclePrices: db.pricesForOracles,
    printingPrices: db.pricesForPrintings,
    printingOwner: collection.printingOwner,
    foilQty: collection.foilPrintings,
    foilPrices: db.foilPricesForPrintings,
  );
}
