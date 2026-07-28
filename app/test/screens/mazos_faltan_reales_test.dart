/// Abrir un mazo guardado desde Mazos: "cuántas te faltan" tiene que
/// coincidir con lo que Forge acaba de decir al generarlo.
///
/// Decisión de producto: las básicas se asumen "gratis" (courtesy), COMO
/// HACE FORGE (`forge_screen.dart`: `assumeBasics: true`,
/// `basicsQty: format == 'commander' ? 40 : 25`). `SavedDeck` no guarda el
/// formato, así que Mazos lo infiere por el tamaño total del mazo: ~100
/// cartas es Commander (40 básicas asumidas), si no 25 — igual que ya cuenta
/// el total la cabecera del mazo (`deck_detail_screen.dart`, "un Commander
/// son 100 cartas, no 60").
///
/// Bug real que esto corrige: `_open` construía el pool con `basicsQty: 25`
/// fijo para CUALQUIER mazo, mientras Forge genera Commander asumiendo 40.
/// Con eso, un mazo que Forge acababa de decir "te faltan 0" se abría desde
/// Mazos diciendo "te faltan 12": la misma carta contaba dos historias.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/decks/mazos_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConCartas() {
  final dir = Directory.systemTemp.createTempSync('mf-mazos-faltan');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  final db = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
  db.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
  db.execute('''
    CREATE TABLE cards (
      oracle_id TEXT PRIMARY KEY, name TEXT, mana_cost TEXT, cmc REAL,
      colors TEXT, color_identity TEXT, type_line TEXT, oracle_text TEXT,
      power TEXT, toughness TEXT, keywords TEXT, legalities TEXT)
  ''');
  db.execute('''
    CREATE TABLE printings (
      scryfall_id TEXT PRIMARY KEY, oracle_id TEXT, set_code TEXT,
      set_name TEXT, collector_number TEXT, lang TEXT, printed_name TEXT,
      rarity TEXT, image_small TEXT, image_normal TEXT, image_png TEXT,
      price_eur TEXT, released_at TEXT)
  ''');
  db.execute("INSERT INTO cards VALUES ('o1','Shock','{R}',1,'R','R',"
      "'Instant','2 damage','','','[]','{}')");
  db.execute("INSERT INTO cards VALUES ('o2','Sol Ring','{1}',1,'',''"
      ",'Artifact','Tap: add CC','','','[]','{}')");
  db.dispose();
  return dir;
}

void main() {
  testWidgets(
      'mazo Commander (100 cartas): faltan 0, igual que Forge (40 básicas)',
      (tester) async {
    final dbDir = _dbConCartas();
    final collection = CollectionStore()
      ..add(OwnedCard(oracleId: 'o2', name: 'Sol Ring', colors: '', qty: 1),
          qty: 63);
    final decks = DeckStore()
      ..add(const SavedDeck(
        id: 'd1',
        name: 'Comandante',
        colors: 'C',
        archetype: 'midrange',
        theme: 'x',
        score: 1.0,
        cards: {'Sol Ring': 63},
        lands: {'Island': 37}, // 63 + 37 = 100 → Commander
        savedAt: '2026-07-01T00:00:00.000',
      ));

    await tester.pumpWidget(MaterialApp(
      home: MazosScreen(
        db: CardDatabase(dataDir: dbDir),
        collection: collection,
        decks: decks,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Comandante'));
    await tester.pump(); // arranca _open
    await tester.pump(const Duration(milliseconds: 50)); // buildPool/poolByNames
    await tester.pump(const Duration(milliseconds: 50)); // termina de navegar

    // Sol Ring lo tienes todo (63/63); las 37 Island no las tienes, pero
    // Commander asume 40 básicas de cortesía (>= 37): 0 te faltan.
    expect(find.text('✓ Tienes todas las cartas'), findsOneWidget);
  });

  testWidgets(
      'mazo normal (no llega a 100 cartas): sigue asumiendo solo 25 básicas',
      (tester) async {
    final dbDir = _dbConCartas();
    final collection = CollectionStore()
      ..add(OwnedCard(oracleId: 'o1', name: 'Shock', colors: 'R', qty: 1),
          qty: 4);
    final decks = DeckStore()
      ..add(const SavedDeck(
        id: 'd1',
        name: 'Mono rojo',
        colors: 'R',
        archetype: 'aggro',
        theme: 'x',
        score: 1.0,
        cards: {'Shock': 4},
        lands: {'Island': 30}, // 4 + 30 = 34 → NO es Commander
        savedAt: '2026-07-01T00:00:00.000',
      ));

    await tester.pumpWidget(MaterialApp(
      home: MazosScreen(
        db: CardDatabase(dataDir: dbDir),
        collection: collection,
        decks: decks,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Mono rojo'));
    await tester.pump(); // arranca _open
    await tester.pump(const Duration(milliseconds: 50)); // buildPool/poolByNames
    await tester.pump(const Duration(milliseconds: 50)); // termina de navegar

    // Shock lo tienes todo (4/4); de las 30 Island solo se asumen 25 de
    // cortesía (no es Commander): siguen faltando 5, igual que en un mazo de
    // toda la vida (antes de tocar nada de este arreglo).
    expect(find.textContaining('Te faltan 5 cartas'), findsOneWidget);
  });
}
