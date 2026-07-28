/// setQty y las impresiones por edición: subir cantidad debe ser el
/// espejo de bajarla.
///
/// Bug real: `setQty` recortaba `_printings` al BAJAR pero nunca reponía al
/// SUBIR. Bajar y volver a subir una copia la dejaba sin edición asociada
/// para siempre — esa copia vale 0 € y la valoración no la marca `~`.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';

OwnedCard _carta(String oracleId, {int qty = 1}) =>
    OwnedCard(oracleId: oracleId, name: oracleId, colors: '', qty: qty);

void main() {
  group('setQty repone la impresión al subir', () {
    test('bajar y volver a subir deja el total de impresiones igual a qty',
        () {
      final store = CollectionStore();
      store.add(_carta('o1', qty: 2), qty: 2, printingKey: 'aer|1');
      expect(store.printingQty['aer|1'], 2);

      store.setQty('o1', 1); // vendes una: la impresión baja a 1
      expect(store.printingQty['aer|1'], 1);

      store.setQty('o1', 2); // la recuperas: la impresión debe volver a 2
      expect(store.printingQty['aer|1'], 2);
      expect(store.printingQty.values.fold(0, (a, b) => a + b), 2);
    });

    test('subir varias unidades de golpe también repone la impresión', () {
      final store = CollectionStore();
      store.add(_carta('o1', qty: 3), qty: 3, printingKey: 'aer|1');
      store.setQty('o1', 1);
      store.setQty('o1', 5); // +4 de golpe
      expect(store.printingQty['aer|1'], 5);
    });

    test('con varias ediciones, repone en la que quedó viva tras el recorte',
        () {
      final store = CollectionStore();
      store.add(_carta('o1', qty: 2), qty: 2, printingKey: 'aer|1');
      store.add(_carta('o1', qty: 1), qty: 1, printingKey: 'kld|9');
      // total 3 copias: 2 de aer|1 y 1 de kld|9 (la última en tocarse)
      store.setQty('o1', 2); // vendes una: se recorta desde kld|9
      expect(store.printingQty.containsKey('kld|9'), isFalse);

      store.setQty('o1', 3); // la recuperas
      expect(store.printingQty.values.fold(0, (a, b) => a + b), 3);
      expect(store.printingQty.containsKey('kld|9'), isFalse,
          reason: 'no se inventa de vuelta una edición ya cerrada');
      expect(store.printingQty['aer|1'], 3);
    });

    test('sin ninguna impresión conocida, subir no inventa una', () {
      final store = CollectionStore();
      store.add(_carta('o1', qty: 1)); // sin printingKey
      store.setQty('o1', 3);
      expect(store.printingQty, isEmpty);
    });

    test('bajar del todo no deja nada que reponer luego', () {
      final store = CollectionStore();
      store.add(_carta('o1', qty: 1), printingKey: 'aer|1');
      store.setQty('o1', 0); // se va del todo: pierde su impresión
      expect(store.printingQty, isEmpty);
    });
  });
}
