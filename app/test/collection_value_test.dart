// Valoración de colección compartida: Home y Mercado deben dar el MISMO
// total. La fórmula canónica es la de Mercado (precio de tu edición exacta
// cuando hay datos de printing; a nivel carta si no los hay).
import 'package:flutter_test/flutter_test.dart';

import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/collection_value.dart';

OwnedCard _card(String oracle, String name, int qty) => OwnedCard(
    oracleId: oracle, name: name, colors: '', qty: qty);

void main() {
  final cards = [
    _card('o1', 'Bolt', 2),
    _card('o2', 'Ophidian', 1),
  ];
  const oraclePrices = {'o1': 3.0, 'o2': 0.5};
  // o1: una copia AER (1€) y otra M25 (5€); o2 sin precio de printing
  const printingPrices = {'aer|100': 1.0, 'm25|60': 5.0};
  final printingQty = {'aer|100': 1, 'm25|60': 1, 'xxx|1': 1};

  Future<Map<String, double>> oracleFn(Iterable<String> ids) async =>
      {for (final id in ids) if (oraclePrices.containsKey(id)) id: oraclePrices[id]!};
  Future<Map<String, double>> printingFn(Iterable<String> keys) async =>
      {for (final k in keys) if (printingPrices.containsKey(k)) k: printingPrices[k]!};

  test('con datos de printing: total por edición exacta, sin aproximar', () async {
    final v = await computeCollectionValue(
      cards: cards,
      byPrinting: true,
      printingQty: printingQty,
      oraclePrices: oracleFn,
      printingPrices: printingFn,
    );
    // 1×1€ + 1×5€ + printing sin precio (xxx|1) = 0 → 6€
    expect(v.total, 6.0);
    expect(v.approximate, isFalse);
    // el top por carta se valora a nivel oracle (edición más cara que hay)
    expect(v.valued.first.oracleId, 'o1'); // 2×3€ = 6 > 1×0.5
    expect(v.valued.first.unitPrice, 3.0);
  });

  test('sin datos de printing: total a nivel carta, marcado aproximado',
      () async {
    final v = await computeCollectionValue(
      cards: cards,
      byPrinting: false,
      printingQty: const {},
      oraclePrices: oracleFn,
      printingPrices: printingFn,
    );
    // 2×3€ + 1×0.5€ = 6.5€
    expect(v.total, 6.5);
    expect(v.approximate, isTrue);
    expect(v.valued.map((c) => c.oracleId).toList(), ['o1', 'o2']);
  });

  group('printingOwner: aproximado si alguna carta no tiene edición conocida',
      () {
    // o1 tiene dos ediciones conocidas (aer|100, m25|60); o2 no tiene
    // ninguna (se añadió desde el buscador sin printingKey)
    const owner = {'aer|100': 'o1', 'm25|60': 'o1'};

    test('sin pasar printingOwner, se mantiene el criterio antiguo',
        () async {
      final v = await computeCollectionValue(
        cards: cards,
        byPrinting: true,
        printingQty: printingQty,
        oraclePrices: oracleFn,
        printingPrices: printingFn,
      );
      expect(v.approximate, isFalse);
    });

    test('con printingOwner, una carta sin cobertura marca aproximado',
        () async {
      final v = await computeCollectionValue(
        cards: cards, // o1 cubierta, o2 no
        byPrinting: true,
        printingQty: printingQty,
        oraclePrices: oracleFn,
        printingPrices: printingFn,
        printingOwner: owner,
      );
      expect(v.approximate, isTrue);
    });

    test('con TODAS las cartas cubiertas, no aproximado', () async {
      final v = await computeCollectionValue(
        cards: [_card('o1', 'Bolt', 2)],
        byPrinting: true,
        printingQty: printingQty,
        oraclePrices: oracleFn,
        printingPrices: printingFn,
        printingOwner: owner,
      );
      expect(v.approximate, isFalse);
    });

    test(
        'la cobertura cuenta COPIAS, no "tiene alguna impresión": 3 copias '
        'con solo 1 conocida sigue siendo aproximado', () async {
      final v = await computeCollectionValue(
        cards: [_card('o1', 'Bolt', 3)], // tienes 3 copias
        byPrinting: true,
        printingQty: const {'aer|100': 1}, // pero solo 1 impresión conocida
        oraclePrices: oracleFn,
        printingPrices: printingFn,
        printingOwner: const {'aer|100': 'o1'},
      );
      expect(v.approximate, isTrue,
          reason: 'las otras 2 copias no tienen edición conocida');
    });
  });

  test('colección vacía: total 0 y lista vacía', () async {
    final v = await computeCollectionValue(
      cards: const [],
      byPrinting: false,
      printingQty: const {},
      oraclePrices: oracleFn,
      printingPrices: printingFn,
    );
    expect(v.total, 0);
    expect(v.valued, isEmpty);
  });
}
