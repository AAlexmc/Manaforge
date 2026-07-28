/// `byScryfallIds` es la versión en lote de `byScryfallId`: el escáner
/// consulta hasta 3 candidatos por carta (top-3), y hacerlo uno a uno era
/// una consulta por candidato — N+1 por carta escaneada.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConVariasImpresiones() {
  final dir = Directory.systemTemp.createTempSync('mf-byids');
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
      price_eur TEXT, released_at TEXT, price_eur_foil TEXT,
      price_usd TEXT, price_usd_foil TEXT, price_tix TEXT)
  ''');
  db.execute("INSERT INTO cards VALUES ('o1','Ornithopter','{0}',0,'','C',"
      "'Artifact Creature','','0','2','[]','{}',NULL,NULL)");
  db.execute("INSERT INTO cards VALUES ('o2','Shock','{R}',1,'R','R',"
      "'Instant','2 damage','','','[]','{}',NULL,NULL)");
  db.execute("INSERT INTO printings VALUES ('s1','o1','fdn','F','1','en',"
      "'Ornithopter','common',null,null,null,'0.10','2024-11-01',"
      "null,null,null,null)");
  db.execute("INSERT INTO printings VALUES ('s2','o2','aer','Aether "
      "Revolt','1','en','Shock','common',null,null,null,'0.10',"
      "'2017-01-20',null,null,null,null)");
  db.dispose();
  return dir;
}

void main() {
  test('trae varias impresiones de una tacada, indexadas por scryfallId',
      () async {
    final dir = _dbConVariasImpresiones();
    final db = CardDatabase(dataDir: dir);
    final hits = await db.byScryfallIds(['s1', 's2']);
    db.close();
    expect(hits.keys, unorderedEquals(['s1', 's2']));
    expect(hits['s1']!.name, 'Ornithopter');
    expect(hits['s2']!.name, 'Shock');
  });

  test('un id que no existe simplemente no sale en el mapa', () async {
    final dir = _dbConVariasImpresiones();
    final db = CardDatabase(dataDir: dir);
    final hits = await db.byScryfallIds(['s1', 'no-existe']);
    db.close();
    expect(hits.keys, ['s1']);
  });

  test('lista vacía: no consulta nada y devuelve vacío', () async {
    final dir = _dbConVariasImpresiones();
    final db = CardDatabase(dataDir: dir);
    final hits = await db.byScryfallIds(const []);
    db.close();
    expect(hits, isEmpty);
  });

  test('coincide con byScryfallId carta a carta', () async {
    final dir = _dbConVariasImpresiones();
    final db = CardDatabase(dataDir: dir);
    final suelto = await db.byScryfallId('s1');
    final lote = await db.byScryfallIds(['s1']);
    db.close();
    expect(lote['s1']!.oracleId, suelto!.oracleId);
    expect(lote['s1']!.name, suelto.name);
  });
}
