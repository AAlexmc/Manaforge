/// Mercado tiene que aprender de quién es cada impresión ANTES de valorar,
/// igual que ya hace Colección — si no, una colección de antes de esta
/// versión (sabe qué impresiones tiene, no de qué carta es cada una) sale
/// marcada aproximada (~) en Mercado mientras Colección enseña el mismo
/// número sin `~`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/mercado_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/market_prefs.dart';
import 'package:manaforge_app/services/price_series_database.dart';
import 'package:manaforge_app/services/wishlist_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConUnaImpresion() {
  final dir = Directory.systemTemp.createTempSync('mf-mercado-backfill');
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

void main() {
  testWidgets(
      'colección legacy (printings sin owner): Mercado no marca aproximado',
      (tester) async {
    final dbDir = _dbConUnaImpresion();
    final collectionDir =
        Directory.systemTemp.createTempSync('mf-mercado-col');
    addTearDown(() {
      if (collectionDir.existsSync()) {
        collectionDir.deleteSync(recursive: true);
      }
    });
    // formato legacy: se sabe qué impresiones hay (`printings`) pero NO de
    // qué carta es cada una (sin `printingOwner`, como antes de la v3)
    File(p.join(collectionDir.path, 'collection.json')).writeAsStringSync(
        jsonEncode({
      'cards': [
        {'oracleId': 'o1', 'name': 'Bolt', 'colors': 'R', 'qty': 2}
      ],
      'printings': {'aer|1': 2},
    }));
    final collection = CollectionStore(dataDir: collectionDir);
    // dart:io de verdad: el reloj falso de testWidgets no lo hace avanzar
    // (ver trampas de test conocidas), así que se precarga con runAsync
    await tester.runAsync(() => collection.load());
    expect(collection.printingOwner, isEmpty,
        reason: 'legacy: aún no sabe de quién es la impresión');

    await tester.pumpWidget(MaterialApp(
      home: MercadoScreen(
        db: CardDatabase(dataDir: dbDir),
        collection: collection,
        wishlist: WishlistStore(),
        prices: PriceSeriesDatabase(
            directory: Directory.systemTemp.createTempSync('mf-mercado-prc')),
        market: MarketPreference(dataDir: collectionDir),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(collection.printingOwner['aer|1'], 'o1',
        reason: 'Mercado tiene que aprenderlo, igual que Colección');
    expect(find.textContaining('valor aproximado'), findsNothing);
    expect(find.textContaining('por tus ediciones exactas'), findsOneWidget);
  });
}
