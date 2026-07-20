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
  return CollectionValuation(
      total: total, valued: valued, approximate: !byPrinting);
}
