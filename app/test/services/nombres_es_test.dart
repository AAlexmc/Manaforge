/// Nombres de carta en español (schema v5, cards.name_es).
///
/// La DB v4 del usuario NO tiene la columna: todo debe funcionar igual que
/// hoy (fallback a inglés, cero errores) hasta que re-descargue la base.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _db({required bool conNameEs}) {
  final dir = Directory.systemTemp.createTempSync('mf-nombres-es');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  final db = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
  db.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
  db.execute("INSERT INTO meta VALUES ('schema_version', "
      "'${conNameEs ? 5 : 4}')");
  db.execute('''
    CREATE TABLE cards (
      oracle_id TEXT PRIMARY KEY, name TEXT, mana_cost TEXT, cmc REAL,
      colors TEXT, color_identity TEXT, type_line TEXT, oracle_text TEXT,
      power TEXT, toughness TEXT, keywords TEXT, legalities TEXT
      ${conNameEs ? ', name_es TEXT, name_es_fold TEXT' : ''})
  ''');
  db.execute('''
    CREATE TABLE printings (
      scryfall_id TEXT PRIMARY KEY, oracle_id TEXT, set_code TEXT,
      set_name TEXT, collector_number TEXT, lang TEXT, printed_name TEXT,
      rarity TEXT, image_small TEXT, image_normal TEXT, image_png TEXT,
      price_eur TEXT, released_at TEXT, price_eur_foil TEXT,
      price_usd TEXT, price_usd_foil TEXT, price_tix TEXT)
  ''');
  if (conNameEs) {
    db.execute("INSERT INTO cards VALUES ('o1','Ornithopter','{0}',0,'','C',"
        "'Artifact Creature','','0','2','[]','{}','Ornitóptero',"
        "'ornitoptero')");
    db.execute("INSERT INTO cards VALUES ('o2','Murder','{1}{B}{B}',3,'B','B',"
        "'Instant','Destroy target creature.','','','[]','{}',NULL,NULL)");
  } else {
    db.execute("INSERT INTO cards VALUES ('o1','Ornithopter','{0}',0,'','C',"
        "'Artifact Creature','','0','2','[]','{}')");
    db.execute("INSERT INTO cards VALUES ('o2','Murder','{1}{B}{B}',3,'B','B',"
        "'Instant','Destroy target creature.','','','[]','{}')");
  }
  db.execute("INSERT INTO printings VALUES ('s1','o1','fdn','F','1','en',"
      "'Ornithopter','common',null,null,null,'0.10','2024-11-01',"
      "null,null,null,null)");
  db.execute("INSERT INTO printings VALUES ('s2','o2','fdn','F','2','en',"
      "'Murder','common',null,null,null,'0.05','2024-11-01',"
      "null,null,null,null)");
  db.dispose();
  return dir;
}

void main() {
  test('namesEsFor devuelve el español de las que lo tienen (v5)', () async {
    final db = CardDatabase(dataDir: _db(conNameEs: true));
    final map = await db.namesEsFor(['Ornithopter', 'Murder', 'NoExiste']);
    db.close();
    expect(map, {'Ornithopter': 'Ornitóptero'});
  });

  test('namesEsFor con DB v4 (sin columna) devuelve vacío sin reventar',
      () async {
    final db = CardDatabase(dataDir: _db(conNameEs: false));
    final map = await db.namesEsFor(['Ornithopter']);
    db.close();
    expect(map, isEmpty);
  });

  test('la búsqueda encuentra por nombre español y el hit lo trae', () async {
    final db = CardDatabase(dataDir: _db(conNameEs: true));
    final hits = await db.search('Ornitóptero');
    db.close();
    expect(hits, hasLength(1));
    expect(hits.single.name, 'Ornithopter');
    expect(hits.single.nameEs, 'Ornitóptero');
  });

  test('la búsqueda con DB v4 sigue funcionando como siempre', () async {
    final db = CardDatabase(dataDir: _db(conNameEs: false));
    final hits = await db.search('Ornithopter');
    db.close();
    expect(hits, hasLength(1));
    expect(hits.single.nameEs, isNull);
  });

  test('la búsqueda pliega tildes y mayúsculas: ORNITÓPTERO y Ornitoptero '
      'encuentran (columna fold)', () async {
    final db = CardDatabase(dataDir: _db(conNameEs: true));
    for (final q in ['ORNITÓPTERO', 'Ornitoptero', 'ornitóptero', 'tóptero']) {
      final hits = await db.search(q);
      expect(hits, hasLength(1), reason: 'query: $q');
      expect(hits.single.name, 'Ornithopter', reason: 'query: $q');
    }
    db.close();
  });

  test('byScryfallId trae nameEs con v5 y null con v4, sin romper', () async {
    final v5 = CardDatabase(dataDir: _db(conNameEs: true));
    final hit5 = await v5.byScryfallId('s1');
    v5.close();
    expect(hit5!.name, 'Ornithopter');
    expect(hit5.nameEs, 'Ornitóptero');

    final v4 = CardDatabase(dataDir: _db(conNameEs: false));
    final hit4 = await v4.byScryfallId('s1');
    v4.close();
    expect(hit4!.name, 'Ornithopter');
    expect(hit4.nameEs, isNull);
  });

  test('cardDetail trae nameEs con v5 y null con v4', () async {
    final v5 = CardDatabase(dataDir: _db(conNameEs: true));
    final d5 = await v5.cardDetail(byName: 'Ornithopter');
    v5.close();
    expect(d5!.nameEs, 'Ornitóptero');

    final v4 = CardDatabase(dataDir: _db(conNameEs: false));
    final d4 = await v4.cardDetail(byName: 'Ornithopter');
    v4.close();
    expect(d4!.nameEs, isNull);
  });
}
