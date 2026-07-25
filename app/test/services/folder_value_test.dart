import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/folder_value.dart';

OwnedCard _card(String id, {int qty = 1}) =>
    OwnedCard(oracleId: id, name: id, colors: '', qty: qty);

void main() {
  final cards = [_card('a', qty: 2), _card('b'), _card('c')];
  const printingQty = {'aer|1': 2, 'aer|2': 1, 'kld|9': 1};
  const oracleOf = {'aer|1': 'a', 'aer|2': 'b', 'kld|9': 'c'};
  const printingPrices = {'aer|1': 3.0, 'aer|2': 10.0, 'kld|9': 100.0};
  const oraclePrices = {'a': 2.5, 'b': 9.0, 'c': 90.0};

  Future<Map<String, String>> oracles(Iterable<String> keys) async =>
      {for (final k in keys) if (oracleOf[k] != null) k: oracleOf[k]!};
  Future<Map<String, double>> prices(Iterable<String> keys) async =>
      {for (final k in keys) if (printingPrices[k] != null) k: printingPrices[k]!};
  Future<Map<String, double>> byOracle(Iterable<String> ids) async =>
      {for (final id in ids) if (oraclePrices[id] != null) id: oraclePrices[id]!};

  test('con datos de edición, la carpeta vale sus printings (misma fórmula)',
      () async {
    final v = await computeFolderValue(
      folderCardIds: {'a', 'b'},
      cards: cards,
      byPrinting: true,
      printingQty: printingQty,
      oracleByPrintings: oracles,
      oraclePrices: byOracle,
      printingPrices: prices,
    );
    expect(v.total, closeTo(3.0 * 2 + 10.0, 0.001)); // la de 100 € no entra
    expect(v.approximate, isFalse);
    expect(v.valued.map((c) => c.oracleId), ['b', 'a']); // más caras primero
  });

  test('las carpetas nunca suman más que la colección entera', () async {
    Future<double> totalOf(Set<String> ids) async => (await computeFolderValue(
          folderCardIds: ids,
          cards: cards,
          byPrinting: true,
          printingQty: printingQty,
          oracleByPrintings: oracles,
          oraclePrices: byOracle,
          printingPrices: prices,
        ))
        .total;
    final whole = await totalOf({'a', 'b', 'c'});
    final part1 = await totalOf({'a'});
    final part2 = await totalOf({'b', 'c'});
    expect(part1 + part2, closeTo(whole, 0.001));
  });

  test('las copias foil valen a precio foil (fallback al normal si no hay)',
      () async {
    // 2 copias de aer|1 (3 €), una de ellas foil a 20 €; kld|9 tiene una
    // foil pero el mercado no publica precio foil → cuenta al normal
    Future<Map<String, double>> foilPrices(Iterable<String> keys) async =>
        {for (final k in keys) if (k == 'aer|1') k: 20.0};
    final v = await computeFolderValue(
      folderCardIds: {'a', 'b', 'c'},
      cards: cards,
      byPrinting: true,
      printingQty: printingQty,
      oracleByPrintings: oracles,
      oraclePrices: byOracle,
      printingPrices: prices,
      foilQty: const {'aer|1': 1, 'kld|9': 1},
      foilPrices: foilPrices,
    );
    // aer|1: 1 normal (3) + 1 foil (20); aer|2: 10; kld|9: 1 foil sin
    // precio foil → 100 normal
    expect(v.total, closeTo(3.0 + 20.0 + 10.0 + 100.0, 0.001));
  });

  test('sin datos de edición el valor es a nivel carta y aproximado',
      () async {
    final v = await computeFolderValue(
      folderCardIds: {'a', 'c'},
      cards: cards,
      byPrinting: false,
      printingQty: const {},
      oracleByPrintings: oracles,
      oraclePrices: byOracle,
      printingPrices: prices,
    );
    expect(v.total, closeTo(2.5 * 2 + 90.0, 0.001));
    expect(v.approximate, isTrue);
  });

  test(
      'copias conocidas insuficientes marcan la carpeta como aproximada '
      '(mismo criterio que computeCollectionValue)', () async {
    final soloParcial = [_card('d', qty: 3)];
    Future<Map<String, String>> ownerD(Iterable<String> keys) async =>
        {'aer|9': 'd'};
    Future<Map<String, double>> priceD(Iterable<String> keys) async =>
        {'aer|9': 2.0};
    Future<Map<String, double>> oracleD(Iterable<String> ids) async =>
        {'d': 1.5};

    final v = await computeFolderValue(
      folderCardIds: {'d'},
      cards: soloParcial,
      byPrinting: true,
      printingQty: const {'aer|9': 1}, // solo 1 de las 3 copias conocida
      oracleByPrintings: ownerD,
      oraclePrices: oracleD,
      printingPrices: priceD,
    );
    expect(v.approximate, isTrue,
        reason: 'las otras 2 copias de "d" no tienen edición conocida');
  });

  test('carpeta vacía o con cartas que ya no tienes vale 0', () async {
    final v = await computeFolderValue(
      folderCardIds: {'fantasma'},
      cards: cards,
      byPrinting: true,
      printingQty: printingQty,
      oracleByPrintings: oracles,
      oraclePrices: byOracle,
      printingPrices: prices,
    );
    expect(v.total, 0);
    expect(v.valued, isEmpty);
  });
}
