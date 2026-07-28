/// "Ya no tengo esta carta" no es lo mismo que "quitar de la carpeta".
///
/// Contrato acordado:
///  - quitar de una carpeta solo DESETIQUETA: la carta se sigue teniendo;
///  - dejar de tener la carta la saca de la colección y de TODAS las
///    carpetas (si no, quedan cartas fantasma en las carpetas);
///  - los mazos NO pierden la carta: se queda en la lista marcada como "ya no
///    la tienes". Vender un Sol Ring no puede deshacer un mazo que costó una
///    tarde montar.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/collection_cascade.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';

CollectionStore _conCartas() {
  final c = CollectionStore();
  c.add(OwnedCard(oracleId: 'sol-ring', name: 'Sol Ring', colors: '', qty: 1),
      printingKey: 'lea|270');
  c.add(OwnedCard(oracleId: 'mox', name: 'Mox Pearl', colors: '', qty: 2),
      qty: 2, printingKey: 'lea|264');
  return c;
}

void main() {
  test('dejar de tener una carta la saca de TODAS las carpetas', () {
    final collection = _conCartas();
    final folders = FolderStore();
    final caja = folders.create(name: 'Caja', cardIds: {'sol-ring', 'mox'});
    final venta = folders.create(name: 'Para vender', cardIds: {'sol-ring'});

    forgetCard(collection: collection, folders: folders, oracleId: 'sol-ring');

    expect(collection.qtyByOracle.containsKey('sol-ring'), isFalse);
    expect(folders.byId(caja.id)!.cardIds, {'mox'});
    expect(folders.byId(venta.id)!.cardIds, isEmpty);
  });

  test('no toca las demás cartas', () {
    final collection = _conCartas();
    final folders = FolderStore();
    final caja = folders.create(name: 'Caja', cardIds: {'sol-ring', 'mox'});

    forgetCard(collection: collection, folders: folders, oracleId: 'sol-ring');

    expect(collection.qtyByOracle['mox'], 2);
    expect(folders.byId(caja.id)!.cardIds, contains('mox'));
  });

  test('sus copias por edición también se van', () {
    final collection = _conCartas();

    forgetCard(collection: collection, oracleId: 'sol-ring');

    expect(collection.printingQty.containsKey('lea|270'), isFalse,
        reason: 'si no, su precio seguiría sumando en el total');
  });

  test('quitar de UNA carpeta no toca la colección ni las otras carpetas', () {
    final collection = _conCartas();
    final folders = FolderStore();
    final caja = folders.create(name: 'Caja', cardIds: {'sol-ring'});
    final venta = folders.create(name: 'Para vender', cardIds: {'sol-ring'});

    folders.toggleCard(caja.id, 'sol-ring');

    expect(collection.qtyByOracle['sol-ring'], 1, reason: 'la sigues teniendo');
    expect(folders.byId(venta.id)!.cardIds, {'sol-ring'});
  });

  test('sin carpetas a mano tampoco falla', () {
    final collection = _conCartas();

    forgetCard(collection: collection, oracleId: 'mox');

    expect(collection.qtyByOracle.containsKey('mox'), isFalse);
  });

  group('los mazos conservan la carta', () {
    test('cuenta cuántas del mazo ya no tienes', () {
      final tengo = {'sol-ring': 1, 'island': 10};

      final faltan = missingFromDeck(
          deckCards: {'sol-ring': 1, 'black-lotus': 1, 'mox': 2},
          deckLands: {'island': 10},
          ownedByOracle: tengo);

      expect(faltan, 3, reason: 'el Lotus (1) y los dos Mox');
    });

    test('tener menos copias de las que pide el mazo también cuenta', () {
      final faltan = missingFromDeck(
          deckCards: {'sol-ring': 4},
          deckLands: const {},
          ownedByOracle: {'sol-ring': 1});

      expect(faltan, 3);
    });

    test('un mazo entero en tu colección no falta nada', () {
      final faltan = missingFromDeck(
          deckCards: {'sol-ring': 1},
          deckLands: {'island': 10},
          ownedByOracle: {'sol-ring': 2, 'island': 20});

      expect(faltan, 0);
    });
  });
}
