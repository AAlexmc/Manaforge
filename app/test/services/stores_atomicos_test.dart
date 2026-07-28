/// Los almacenes que faltaban por escribir SIN poder perder lo anterior.
///
/// Se testea el DISCO, no la memoria: el fallo que se persigue (dos guardados
/// que se pisan, un fichero truncado que al arrancar se lee vacío y se
/// sobrescribe con dos líneas) solo existe en el fichero.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/deck_store.dart';
import 'package:manaforge_app/data/repositories/recents_store.dart';
import 'package:manaforge_app/data/repositories/value_history.dart';
import 'package:manaforge_app/data/repositories/wishlist_store.dart';
import 'package:path/path.dart' as p;

Directory _tmpDir() {
  final dir = Directory.systemTemp.createTempSync('mf-stores');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

SavedDeck _deck(String id) => SavedDeck(
      id: id,
      name: 'Mazo $id',
      colors: 'UR',
      archetype: 'tempo',
      theme: '',
      score: 0.5,
      cards: const {'sol-ring': 1},
      lands: const {'island': 10},
      savedAt: '2026-07-22T10:00:00.000',
    );

WishItem _wish(String oracleId, String name) => WishItem(
      oracleId: oracleId,
      name: name,
      colors: 'C',
      targetPrice: 2,
    );

void main() {
  group('mazos', () {
    test('guardar muchos mazos seguidos deja un JSON entero, no a medias',
        () async {
      final dir = _tmpDir();
      final store = DeckStore(dataDir: dir);

      for (var i = 0; i < 30; i++) {
        store.add(_deck('d$i'));
      }
      await store.pendingSave;

      final file = File(p.join(dir.path, 'decks.json'));
      final leido = jsonDecode(await file.readAsString()) as List<dynamic>;
      expect(leido.length, 30);
      expect(File('${file.path}.tmp').existsSync(), isFalse,
          reason: 'el temporal no se queda por ahí');
    });

    test('un decks.json ilegible se aparta como .roto en vez de perderse',
        () async {
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'decks.json'));
      // esto es justo lo que deja un corte a media escritura sin temporal
      await file.writeAsString('[{"id":"d1","name":"Mazo bue');

      final store = DeckStore(dataDir: dir);
      await store.load();

      expect(store.decks, isEmpty);
      expect(File('${file.path}.roto').existsSync(), isTrue,
          reason: 'se puede recuperar a mano: no se borra');
      expect(file.existsSync(), isFalse);
    });

    test('un mazo con un campo raro no se lleva los demás por delante',
        () async {
      // regresión: `_decks..clear()..addAll([for (...) fromJson(...)])`
      // limpiaba la lista ANTES de evaluar el comprensión de lista; si un
      // mazo a mitad reventaba, los buenos (antes Y después) se perdían
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'decks.json'));
      await file.writeAsString(jsonEncode([
        _deck('d1').toJson(),
        {'id': 'd-malo'}, // sin name/cards/lands: fromJson revienta
        _deck('d3').toJson(),
      ]));

      final store = DeckStore(dataDir: dir);
      await store.load();

      expect(store.decks.map((d) => d.id), ['d1', 'd3']);
      expect(File('${file.path}.roto').existsSync(), isFalse);
    });
  });

  group('lista de deseos', () {
    test('dos guardados a la vez no se pisan', () async {
      final dir = _tmpDir();
      final store = WishlistStore(dataDir: dir);

      store.add(_wish('sol-ring', 'Sol Ring'));
      store.add(_wish('mox-pearl', 'Mox Pearl'));
      store.updatePrices(const {'sol-ring': 1.5});
      await store.pendingSave;

      final file = File(p.join(dir.path, 'wishlist.json'));
      final leido = jsonDecode(await file.readAsString()) as List<dynamic>;
      expect(leido.length, 2);
    });

    test('un wishlist.json ilegible se aparta como .roto', () async {
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'wishlist.json'));
      await file.writeAsString('[{"oracleId":');

      final store = WishlistStore(dataDir: dir);
      await store.load();

      expect(File('${file.path}.roto').existsSync(), isTrue);
    });

    test('un item con un campo raro no se lleva los demás de la lista',
        () async {
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'wishlist.json'));
      await file.writeAsString(jsonEncode([
        _wish('o1', 'Bolt').toJson(),
        {'oracleId': 'o-malo'}, // sin targetPrice: fromJson revienta
        _wish('o3', 'Zur').toJson(),
      ]));

      final store = WishlistStore(dataDir: dir);
      await store.load();

      expect(store.items.map((i) => i.oracleId).toSet(), {'o1', 'o3'});
      expect(File('${file.path}.roto').existsSync(), isFalse);
    });
  });

  group('cartas vistas hace poco', () {
    test('guardar seguido deja un JSON entero', () async {
      final dir = _tmpDir();
      final store = RecentsStore(dataDir: dir);

      for (var i = 0; i < 30; i++) {
        store.record(RecentCard(oracleId: 'c$i', name: 'Carta $i'));
      }
      await store.pendingSave;

      final file = File(p.join(dir.path, 'recents.json'));
      final leido = jsonDecode(await file.readAsString()) as List<dynamic>;
      expect(leido, isNotEmpty);
    });

    test('un recents.json ilegible se aparta como .roto', () async {
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'recents.json'));
      await file.writeAsString('no soy json');

      final store = RecentsStore(dataDir: dir);
      await store.load();

      expect(File('${file.path}.roto').existsSync(), isTrue);
    });

    test('una carta con un campo raro no se lleva las demás vistas',
        () async {
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'recents.json'));
      await file.writeAsString(jsonEncode([
        const RecentCard(oracleId: 'c1', name: 'Buena').toJson(),
        {'o': 'c-malo'}, // sin 'n': fromJson revienta
        const RecentCard(oracleId: 'c3', name: 'También buena').toJson(),
      ]));

      final store = RecentsStore(dataDir: dir);
      await store.load();

      expect(store.cards.map((c) => c.oracleId), ['c1', 'c3']);
      expect(File('${file.path}.roto').existsSync(), isFalse);
    });
  });

  group('historial del valor', () {
    test('apuntar el valor de hoy escribe por temporal', () async {
      final dir = _tmpDir();
      final history = ValueHistory(dataDir: dir);

      await history.record(120.5, 283);
      await history.record(121.0, 284); // mismo día: sustituye

      final file = File(p.join(dir.path, 'value_history.json'));
      final leido = jsonDecode(await file.readAsString()) as List<dynamic>;
      expect(leido.length, 1);
      expect((leido.first as Map)['v'], 121.0);
      expect(File('${file.path}.tmp').existsSync(), isFalse);
    });

    test('un value_history.json ilegible se aparta antes de escribir encima',
        () async {
      final dir = _tmpDir();
      final file = File(p.join(dir.path, 'value_history.json'));
      await file.writeAsString('[{"date":"2026-01-01","valu');

      final history = ValueHistory(dataDir: dir);
      await history.load();

      expect(File('${file.path}.roto').existsSync(), isTrue,
          reason: 'un año de valores no se tira sin dejar copia');
    });
  });
}
