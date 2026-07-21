/// Valor de una carpeta. Reusa la MISMA fórmula que Inicio y Mercado
/// ([computeCollectionValue]) para que los totales cuadren: la carpeta es un
/// subconjunto de la colección, así que su valor es el de sus cartas con el
/// mismo criterio (por edición exacta si hay datos, si no a nivel carta y
/// marcado como aproximado).
///
/// El único trabajo extra es repartir las cantidades por edición: la carpeta
/// es a nivel oracle y `printingQty` es de toda la colección, así que hay que
/// quedarse con las impresiones cuyas cartas están en la carpeta.
library;

import 'card_database.dart';
import 'collection_store.dart';
import 'collection_value.dart';
import 'folder_store.dart';

Future<CollectionValuation> computeFolderValue({
  required Set<String> folderCardIds,
  required List<OwnedCard> cards,
  required bool byPrinting,
  required Map<String, int> printingQty,
  required Future<Map<String, String>> Function(Iterable<String>)
      oracleByPrintings,
  required Future<Map<String, double>> Function(Iterable<String>) oraclePrices,
  required Future<Map<String, double>> Function(Iterable<String>)
      printingPrices,
}) async {
  final mine = cards.where((c) => folderCardIds.contains(c.oracleId)).toList();
  if (mine.isEmpty) {
    return const CollectionValuation(
        total: 0, valued: [], approximate: false);
  }
  var printings = const <String, int>{};
  var covered = <String>{};
  if (byPrinting && printingQty.isNotEmpty) {
    final owners = await oracleByPrintings(printingQty.keys);
    printings = {
      for (final e in printingQty.entries)
        if (folderCardIds.contains(owners[e.key])) e.key: e.value,
    };
    covered = {
      for (final key in printings.keys)
        if (owners[key] != null) owners[key]!
    };
  }
  final value = await computeCollectionValue(
    cards: mine,
    byPrinting: byPrinting,
    printingQty: printings,
    oraclePrices: oraclePrices,
    printingPrices: printingPrices,
  );
  // una carta añadida a mano desde el buscador no tiene edición conocida: no
  // suma nada al valor por edición, así que el total se marca orientativo en
  // vez de enseñar un 0,00 € que parece exacto
  final missing = mine.any((c) => !covered.contains(c.oracleId));
  if (!value.approximate && missing) {
    return CollectionValuation(
        total: value.total, valued: value.valued, approximate: true);
  }
  return value;
}

/// Atajo con la base de cartas y la colección de verdad.
Future<CollectionValuation> folderValue({
  required CardFolder folder,
  required CollectionStore collection,
  required CardDatabase db,
}) =>
    computeFolderValue(
      folderCardIds: folder.cardIds,
      cards: collection.cards,
      byPrinting: collection.hasPrintingData,
      printingQty: collection.printingQty,
      oracleByPrintings: db.oracleByPrintings,
      oraclePrices: db.pricesForOracles,
      printingPrices: db.pricesForPrintings,
    );
