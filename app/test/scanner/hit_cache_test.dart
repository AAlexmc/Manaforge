/// `precacheHits` es la precarga compartida entre escáner por foto y
/// escáner en vivo: rellena el caché de fichas de los candidatos de un
/// escaneo en UN viaje a la base, no uno por candidato.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/hit_cache.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

ScanMatch _match(String oracleId, String scryfallId, String name) => ScanMatch(
      HashEntry(
        scryfallId: scryfallId,
        oracleId: oracleId,
        name: name,
        setCode: 'blb',
        collectorNumber: '1',
      ),
      2,
    );

Directory _dbConDosCartas() {
  final dir = Directory.systemTemp.createTempSync('mf-hitcache');
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
  db.execute("INSERT INTO cards VALUES ('sol-ring','Sol Ring','{1}',1,'','C',"
      "'Artifact','','','','[]','{}',NULL,NULL)");
  db.execute("INSERT INTO cards VALUES ('mox-pearl','Mox Pearl','{0}',0,'W',"
      "'W','Artifact','','','','[]','{}',NULL,NULL)");
  db.execute("INSERT INTO printings VALUES ('s-sol','sol-ring','blb','B','1',"
      "'en','Sol Ring','common',null,null,null,'1.00','2024-01-01',"
      "null,null,null,null)");
  db.execute("INSERT INTO printings VALUES ('s-mox','mox-pearl','blb','B',"
      "'2','en','Mox Pearl','common',null,null,null,'2.00','2024-01-01',"
      "null,null,null,null)");
  db.dispose();
  return dir;
}

void main() {
  test('rellena el caché con lo que falte, en un solo lote', () async {
    final dir = _dbConDosCartas();
    final db = CardDatabase(dataDir: dir);
    final cache = <String, CardHit?>{};

    await precacheHits(
        db, cache, [_match('sol-ring', 's-sol', 'Sol Ring')]);
    db.close();

    expect(cache.keys, ['s-sol']);
    expect(cache['s-sol']!.name, 'Sol Ring');
  });

  test('no vuelve a pedir lo que ya está en caché', () async {
    final dir = _dbConDosCartas();
    final db = CardDatabase(dataDir: dir);
    final cache = <String, CardHit?>{'s-sol': null}; // ya "consultado" antes

    await precacheHits(
        db, cache, [_match('sol-ring', 's-sol', 'Sol Ring')]);
    db.close();

    expect(cache['s-sol'], isNull,
        reason: 'ya estaba en caché (aunque fuera null): no se pisa');
  });

  test('varios candidatos de una vez quedan todos cacheados', () async {
    final dir = _dbConDosCartas();
    final db = CardDatabase(dataDir: dir);
    final cache = <String, CardHit?>{};

    await precacheHits(db, cache, [
      _match('sol-ring', 's-sol', 'Sol Ring'),
      _match('mox-pearl', 's-mox', 'Mox Pearl'),
    ]);
    db.close();

    expect(cache.keys, unorderedEquals(['s-sol', 's-mox']));
    expect(cache['s-mox']!.name, 'Mox Pearl');
  });

  test('un candidato que la base no conoce queda en null, no revienta',
      () async {
    final dir = _dbConDosCartas();
    final db = CardDatabase(dataDir: dir);
    final cache = <String, CardHit?>{};

    await precacheHits(
        db, cache, [_match('fantasma', 's-fantasma', '???')]);
    db.close();

    expect(cache.keys, ['s-fantasma']);
    expect(cache['s-fantasma'], isNull);
  });

  test('sin base de cartas, los candidatos quedan en null en vez de reventar',
      () async {
    final dir = Directory.systemTemp.createTempSync('mf-hitcache-sindb');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = CardDatabase(dataDir: dir);
    final cache = <String, CardHit?>{};

    await precacheHits(
        db, cache, [_match('sol-ring', 's-sol', 'Sol Ring')]);
    db.close();

    expect(cache.keys, ['s-sol']);
    expect(cache['s-sol'], isNull);
  });
}
