/// Añadir una carta desde "Todas las cartas" (el buscador) tiene que dejar
/// apuntada TAMBIÉN su edición exacta.
///
/// Bug real: `_add` no pasaba `printingKey` aunque `CardHit` lo tiene. La
/// carta añadida así valía 0 € para siempre y la valoración no la marcaba
/// como aproximada (`~`), a diferencia del valor de una carpeta, que sí
/// detecta este caso.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/all_cards_screen.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConUnaImpresion() {
  final dir = Directory.systemTemp.createTempSync('mf-buscador');
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
  db.execute("INSERT INTO cards VALUES ('o1','Lightning Bolt','{R}',1,'R',"
      "'R','Instant','3 damage','','','[]','{}')");
  db.execute("INSERT INTO printings VALUES ('s1','o1','lea','Limited "
      "Edition Alpha','162','en','Lightning Bolt','common',null,null,null,"
      "'20.00','1993-08-05')");
  db.dispose();
  return dir;
}

void main() {
  testWidgets(
      'añadir desde el buscador guarda también la impresión exacta',
      (tester) async {
    final dbDir = _dbConUnaImpresion();
    final collection = CollectionStore();

    await tester.pumpWidget(MaterialApp(
      home: AllCardsScreen(
        db: CardDatabase(dataDir: dbDir),
        collection: collection,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(find.byType(TextField), 'Lightning Bolt');
    // el buscador tiene debounce: hay que dejar pasar la pausa antes de que
    // dispare la consulta
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Lightning Bolt'), findsWidgets);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();

    expect(collection.qtyByOracle['o1'], 1);
    expect(collection.printingQty['lea|162'], 1,
        reason: 'sin esto la carta vale 0 € para siempre y sin marcar ~');
  });
}
