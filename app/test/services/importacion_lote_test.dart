/// Importar un CSV llama a add() una vez por carta, y cada add() avisaba a
/// TODAS las pantallas vivas (el IndexedStack las mantiene montadas): Inicio
/// y Mercado recalculaban la valoración entera contra la base por CADA fila.
/// Con 308 cartas eran minutos; con 5000 serían horas. En lote: los add()
/// de dentro no avisan y al cerrar el lote sale UN solo aviso (y guardado).
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:path/path.dart' as p;

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

  test('el disco NO espera al lote: cortar a mitad no pierde lo importado',
      () async {
    // cerrar la ventana (o un apagón) a mitad de un CSV de 5000 filas
    // tiene que dejar en disco lo ya procesado, como pasaba antes del lote
    final dir = Directory.systemTemp.createTempSync('mf-lote-disco');
    addTearDown(() => dir.deleteSync(recursive: true));
    final store = CollectionStore(dataDir: dir);
    await store.importBatch(() async {
      store.add(_carta('o1'));
      await store.pendingSave; // la escritura encolada, sin cerrar el lote
      final file = File(p.join(dir.path, 'collection.json'));
      expect(file.existsSync(), isTrue,
          reason: 'a mitad de lote ya tiene que haber colección en disco');
      final cards =
          (jsonDecode(file.readAsStringSync()) as Map)['cards'] as List;
      expect(cards, hasLength(1));
    });
  });

  test('un lote anidado no cierra el de fuera', () async {
    final store = CollectionStore();
    var avisos = 0;
    store.addListener(() => avisos++);
    await store.importBatch(() async {
      store.add(_carta('o1'));
      await store.importBatch(() async {
        store.add(_carta('o2'));
      });
      expect(avisos, 0,
          reason: 'el lote interior no debe soltar los avisos del exterior');
      store.add(_carta('o3'));
    });
    expect(avisos, 1);
    expect(store.cards.length, 3);
  });
}
