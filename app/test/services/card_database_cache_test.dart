/// `_hasColumn` (PRAGMA table_info) y `sets()` (GROUP BY sobre ~110k
/// impresiones) se llaman una y otra vez desde varias pantallas: se
/// cachean por apertura de handle. La base solo cambia de verdad con una
/// re-descarga, que pasa siempre por [CardDatabase.close]; por eso la
/// caché se vacía ahí y en ningún otro sitio.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbSinNameEs() {
  final dir = Directory.systemTemp.createTempSync('mf-cache-hascolumn');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  final db = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
  db.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
  db.execute("INSERT INTO meta VALUES ('schema_version', '4')");
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
  db.execute("INSERT INTO cards VALUES ('o1','Ornithopter','{0}',0,'','C',"
      "'Artifact Creature','','0','2','[]','{}')");
  db.execute("INSERT INTO printings VALUES ('s1','o1','fdn','Foundations',"
      "'1','en','Ornithopter','common',null,null,null,'0.10',"
      "'2024-11-01')");
  db.dispose();
  return dir;
}

Directory _dbUnSet() {
  final dir = Directory.systemTemp.createTempSync('mf-cache-sets');
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
  db.execute("INSERT INTO printings VALUES ('s1','o1','aer','Aether "
      "Revolt','1','en','Shock','common',null,null,null,'0.10',"
      "'2017-01-20')");
  db.dispose();
  return dir;
}

void main() {
  test(
      '_hasColumn cachea: una columna añadida en caliente no se ve hasta '
      'cerrar y reabrir el handle', () async {
    final dir = _dbSinNameEs();
    final db = CardDatabase(dataDir: dir);

    final antes = await db.search('Ornithopter');
    expect(antes.single.nameEs, isNull, reason: 'la v4 no trae name_es');

    // columna añadida en caliente, con una conexión aparte
    final raw = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
    raw.execute('ALTER TABLE cards ADD COLUMN name_es TEXT');
    raw.execute(
        "UPDATE cards SET name_es = 'Ornitóptero' WHERE oracle_id = 'o1'");
    raw.dispose();

    final mientrasVive = await db.search('Ornithopter');
    expect(mientrasVive.single.nameEs, isNull,
        reason: 'la caché de _hasColumn no se entera sin reabrir el handle');

    db.close();
    final trasReabrir = await db.search('Ornithopter');
    expect(trasReabrir.single.nameEs, 'Ornitóptero',
        reason: 'close() vacía la caché: la próxima apertura ve la '
            'columna nueva');
  });

  test(
      'sets() cachea: una expansión añadida en caliente no aparece hasta '
      'cerrar y reabrir el handle', () async {
    final dir = _dbUnSet();
    final db = CardDatabase(dataDir: dir);

    final antes = await db.sets();
    expect(antes.map((s) => s.code), ['aer']);

    final raw = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
    raw.execute("INSERT INTO cards VALUES ('o2','Bolt','{R}',1,'R','R',"
        "'Instant','3 damage','','','[]','{}')");
    raw.execute("INSERT INTO printings VALUES ('s2','o2','blb',"
        "'Bloomburrow','1','en','Bolt','common',null,null,null,'0.20',"
        "'2024-08-02')");
    raw.dispose();

    final mientrasVive = await db.sets();
    expect(mientrasVive.map((s) => s.code), ['aer'],
        reason: 'cacheado: no ve el set nuevo sin reabrir el handle');

    db.close();
    final trasReabrir = await db.sets();
    expect(trasReabrir.map((s) => s.code), containsAll(['aer', 'blb']));
  });
}
