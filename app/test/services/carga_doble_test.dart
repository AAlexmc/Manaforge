/// Dos `load()` a la vez, en los almacenes que lo marcaban con un `bool`
/// puesto ANTES de leer el disco.
///
/// Regresión: con `if (_loaded) return; _loaded = true;` al principio de
/// `load()`, la primera llamada deja la marca puesta y suspende en el primer
/// `await`; una segunda llamada mientras tanto ve la marca ya puesta y
/// vuelve con el almacén vacío en vez de esperar a la lectura de verdad
/// (quien decide algo con eso — p. ej. "hay datos previos" al actualizar de
/// versión — se queda con un "no hay nada" falso). El mismo bug que ya se
/// arregló en `language_prefs.dart`.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/deck_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/data/repositories/recents_store.dart';
import 'package:manaforge_app/data/repositories/wishlist_store.dart';
import 'package:path/path.dart' as p;

Directory _tmpDir() {
  final dir = Directory.systemTemp.createTempSync('mf-carga-doble');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

void main() {
  test('CollectionStore: el segundo load() no vuelve vacío', () async {
    final dir = _tmpDir();
    File(p.join(dir.path, 'collection.json')).writeAsStringSync(jsonEncode({
      'cards': [
        {'oracleId': 'o1', 'name': 'A', 'colors': 'G', 'qty': 1}
      ],
    }));
    final store = CollectionStore(dataDir: dir);

    unawaited(store.load()); // el de main(), todavía leyendo el disco
    await store.load(); // el de la pantalla, que da por hecho que ya está

    expect(store.distinctCards, 1);
  });

  test('DeckStore: el segundo load() no vuelve vacío', () async {
    final dir = _tmpDir();
    File(p.join(dir.path, 'decks.json')).writeAsStringSync(jsonEncode([
      {
        'id': 'd1',
        'name': 'Mazo',
        'colors': 'W',
        'archetype': 'aggro',
        'theme': 'x',
        'score': 1.0,
        'cards': {'A': 4},
        'lands': {'Plains': 20},
        'savedAt': '2026-07-01T00:00:00.000',
      }
    ]));
    final store = DeckStore(dataDir: dir);

    unawaited(store.load());
    await store.load();

    expect(store.decks, hasLength(1));
  });

  test('FolderStore: el segundo load() no vuelve vacío', () async {
    final dir = _tmpDir();
    File(p.join(dir.path, 'folders.json')).writeAsStringSync(jsonEncode([
      {'id': '1', 'name': 'Rares', 'cards': ['a']}
    ]));
    final store = FolderStore(dataDir: dir);

    unawaited(store.load());
    await store.load();

    expect(store.folders, hasLength(1));
  });

  test('WishlistStore: el segundo load() no vuelve vacío', () async {
    final dir = _tmpDir();
    File(p.join(dir.path, 'wishlist.json')).writeAsStringSync(jsonEncode([
      {'oracleId': 'o1', 'name': 'Bolt', 'colors': 'R', 'targetPrice': 2.0}
    ]));
    final store = WishlistStore(dataDir: dir);

    unawaited(store.load());
    await store.load();

    expect(store.items, hasLength(1));
  });

  test('RecentsStore: el segundo load() no vuelve vacío', () async {
    final dir = _tmpDir();
    File(p.join(dir.path, 'recents.json')).writeAsStringSync(jsonEncode([
      {'o': 'o1', 'n': 'Bolt', 'i': null, 'c': 'R'}
    ]));
    final store = RecentsStore(dataDir: dir);

    unawaited(store.load());
    await store.load();

    expect(store.cards, hasLength(1));
  });
}
