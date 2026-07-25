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
}) async {
  double total = 0;
  final valued = <ValuedCard>[];
  final oracle = await oraclePrices(cards.map((c) => c.oracleId));

  if (byPrinting) {
    final prices = await printingPrices(printingQty.keys);
    printingQty.forEach((key, qty) {
      total += (prices[key] ?? 0) * qty;
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
