/// El buscador ENSEÑA el nombre en español, no solo lo encuentra.
///
/// Bug real (review): `hit.printedName ?? cardDisplayName(...)` dejaba el
/// helper como código muerto — printed_name no es NULL jamás en la DB
/// publicada (build_card_db.py escribe `printed_name or name`), así que
/// buscar «Ornitóptero» encontraba la carta pero la fila decía
/// «Ornithopter». El fixture usa printed_name NO nulo a propósito: es el
/// dato real que rompía.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/all_cards_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../helpers/app_l10n.dart';

Directory _dbV5() {
  final dir = Directory.systemTemp.createTempSync('mf-buscador-es');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  final db = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
  db.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
  db.execute("INSERT INTO meta VALUES ('schema_version', '5')");
  db.execute('''
    CREATE TABLE cards (
      oracle_id TEXT PRIMARY KEY, name TEXT, mana_cost TEXT, cmc REAL,
      colors TEXT, color_identity TEXT, type_line TEXT, oracle_text TEXT,
      power TEXT, toughness TEXT, keywords TEXT, legalities TEXT,
      name_es TEXT, name_es_fold TEXT)
  ''');
  db.execute('''
    CREATE TABLE printings (
      scryfall_id TEXT PRIMARY KEY, oracle_id TEXT, set_code TEXT,
      set_name TEXT, collector_number TEXT, lang TEXT, printed_name TEXT,
      rarity TEXT, image_small TEXT, image_normal TEXT, image_png TEXT,
      price_eur TEXT, released_at TEXT)
  ''');
  db.execute("INSERT INTO cards VALUES ('o1','Ornithopter','{0}',0,'','C',"
      "'Artifact Creature','','0','2','[]','{}','Ornitóptero','ornitoptero')");
  // printed_name NO nulo y en inglés: el caso real de la DB publicada
  db.execute("INSERT INTO printings VALUES ('s1','o1','fdn','Foundations',"
      "'1','en','Ornithopter','common',null,null,null,'0.10','2024-11-01')");
  db.dispose();
  return dir;
}

void main() {
  testWidgets('buscar «ornitoptero» (sin tilde) con UI en es enseña el '
      'nombre español aunque la impresión sea inglesa', (tester) async {
    await tester.pumpWidget(appDePrueba(
      home: AllCardsScreen(
        db: CardDatabase(dataDir: _dbV5()),
        collection: CollectionStore(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(find.byType(TextField), 'ornitoptero');
    // el buscador tiene debounce: hay que dejar pasar la pausa antes de que
    // dispare la consulta
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Ornitóptero'), findsWidgets);
    expect(find.text('Ornithopter'), findsNothing);
  });

  testWidgets('con UI en inglés la misma fila sigue en inglés',
      (tester) async {
    await tester.pumpWidget(appDePrueba(
      locale: const Locale('en'),
      home: AllCardsScreen(
        db: CardDatabase(dataDir: _dbV5()),
        collection: CollectionStore(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(find.byType(TextField), 'Ornithopter');
    // el buscador tiene debounce: hay que dejar pasar la pausa antes de que
    // dispare la consulta
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Ornithopter'), findsWidgets);
    expect(find.text('Ornitóptero'), findsNothing);
  });
}
