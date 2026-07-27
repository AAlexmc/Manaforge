/// Importar un CSV llama a add() una vez por carta, y cada add() avisaba a
/// TODAS las pantallas vivas (el IndexedStack las mantiene montadas): Inicio
/// y Mercado recalculaban la valoración entera contra la base por CADA fila.
/// Con 308 cartas eran minutos; con 5000 serían horas. En lote: los add()
/// de dentro no avisan y al cerrar el lote sale UN solo aviso (y guardado).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/collection_store.dart';

OwnedCard _carta(String id) =>
    OwnedCard(oracleId: id, name: id, colors: '', qty: 1);

void main() {
  test('importBatch: los add() de dentro no avisan; al cerrar, UN aviso',
      () async {
    final store = CollectionStore();
    var avisos = 0;
    store.addListener(() => avisos++);
    await store.importBatch(() async {
      store.add(_carta('o1'));
      await Future<void>.delayed(Duration.zero); // como el await de sqlite
      store.add(_carta('o2'));
      expect(avisos, 0, reason: 'dentro del lote nadie recalcula nada');
    });
    expect(avisos, 1);
    expect(store.cards.length, 2);
  });

  test('importBatch: el clear() del modo sustituir tampoco avisa', () async {
    final store = CollectionStore();
    store.add(_carta('viejo'));
    var avisos = 0;
    store.addListener(() => avisos++);
    await store.importBatch(() async {
      store.clear();
      store.add(_carta('nuevo'));
      expect(avisos, 0);
    });
    expect(avisos, 1);
    expect(store.cards.single.oracleId, 'nuevo');
  });

  test('importBatch sin ningún cambio dentro no avisa a nadie', () async {
    final store = CollectionStore();
    var avisos = 0;
    store.addListener(() => avisos++);
    await store.importBatch(() async {});
    expect(avisos, 0);
  });

  test('si el lote peta a mitad, el aviso final sale igual (finally)',
      () async {
    final store = CollectionStore();
    var avisos = 0;
    store.addListener(() => avisos++);
    await expectLater(
      store.importBatch(() async {
        store.add(_carta('o1'));
        throw StateError('CSV roto a mitad');
      }),
      throwsStateError,
    );
    expect(avisos, 1, reason: 'lo ya añadido tiene que verse (y guardarse)');
    // y el lote queda cerrado: un add() posterior avisa normal
    store.add(_carta('o2'));
    expect(avisos, 2);
  });

  test('devuelve lo que devuelva el cuerpo', () async {
    final store = CollectionStore();
    final n = await store.importBatch(() async => 42);
    expect(n, 42);
  });
}
