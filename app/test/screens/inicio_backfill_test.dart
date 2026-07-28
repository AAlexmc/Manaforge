/// Inicio tiene que marcar el total aproximado (~) exactamente en el mismo
/// caso en que lo marca Mercado: con copias que no tienen NINGUNA edición
/// conocida, aunque el resto de la colección sí la tenga (y se backfillee).
/// Antes Inicio ni siquiera pasaba `printingOwner` a `computeCollectionValue`
/// (ni tenía el prólogo de backfill de Mercado/Colección): el total nunca se
/// marcaba, aunque tocara — ver `mercado_backfill_test.dart` como plantilla.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/home_screen.dart';
import 'package:manaforge_app/services/achievement_store.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/certificate_store.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/services/wishlist_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConUnaImpresion() {
  final dir = Directory.systemTemp.createTempSync('mf-inicio-backfill');
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
  db.execute("INSERT INTO cards VALUES ('o1','Bolt','{R}',1,'R','R',"
      "'Instant','3 damage','','','[]','{}')");
  db.execute("INSERT INTO printings VALUES ('s1','o1','aer','Aether "
      "Revolt','1','en','Bolt','common',null,null,null,'5.00','2017-01-20')");
  db.dispose();
  return dir;
}

Widget _inicio(
        {required CardDatabase db, required CollectionStore collection}) =>
    MaterialApp(
      home: HomeScreen(
        db: db,
        collection: collection,
        decks: DeckStore(),
        achievements: AchievementsController(
          db: db,
          collection: collection,
          decks: DeckStore(),
          folders: FolderStore(),
          wishlist: WishlistStore(),
          progress: AchievementStore(),
        ),
        certificates: CertificateStore(),
        onGoToTab: (_) {},
      ),
    );

void main() {
  testWidgets(
      'copias sin NINGUNA edición conocida: Inicio marca aproximado, '
      'igual que Mercado', (tester) async {
    final dbDir = _dbConUnaImpresion();
    final collectionDir =
        Directory.systemTemp.createTempSync('mf-inicio-col');
    addTearDown(() {
      if (collectionDir.existsSync()) {
        collectionDir.deleteSync(recursive: true);
      }
    });
    // 3 copias de Bolt, pero solo 1 impresión conocida (aer|1): aunque el
    // backfill aprenda de quién es esa, las otras 2 copias siguen sin
    // edición — el mismo caso que en collection_value_test.dart
    File(p.join(collectionDir.path, 'collection.json')).writeAsStringSync(
        jsonEncode({
      'cards': [
        {'oracleId': 'o1', 'name': 'Bolt', 'colors': 'R', 'qty': 3}
      ],
      'printings': {'aer|1': 1},
    }));
    final collection = CollectionStore(dataDir: collectionDir);
    await tester.runAsync(() => collection.load());

    await tester.pumpWidget(_inicio(
        db: CardDatabase(dataDir: dbDir), collection: collection));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(collection.printingOwner['aer|1'], 'o1',
        reason: 'Inicio también tiene que aprenderlo (mismo prólogo)');
    expect(find.textContaining('~5.00 €'), findsOneWidget);
  });
}
