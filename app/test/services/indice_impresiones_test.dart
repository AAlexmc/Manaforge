/// Las bases descargadas hasta la v5 vienen SIN índice compuesto sobre
/// printings(set_code, collector_number): toda consulta de precios por
/// impresión (Inicio, Mercado, logros) era un full scan de ~110k filas con
/// 150 ORs. Con la colección creciendo durante una importación, eso es
/// O(n²) y 308 cartas tardaban minutos. La app crea el índice al abrir la
/// base (idempotente, ~0,1 s la primera vez); si el fichero no se puede
/// escribir, se abre igual en solo-lectura y funciona (lenta).
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbSinIndice() {
  final dir = Directory.systemTemp.createTempSync('mf-indice');
  addTearDown(() {
    if (dir.existsSync()) {
      // por si un test dejó el fichero en solo-lectura
      for (final f in dir.listSync()) {
        try {
          Process.runSync('chmod', ['u+w', f.path]);
        } catch (_) {}
      }
      dir.deleteSync(recursive: true);
    }
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
  db.execute("INSERT INTO printings VALUES ('s1','o1','fdn','F','1','en',"
      "'Ornithopter','common',null,null,null,'0.10','2024-11-01',"
      "null,null,null,null)");
  db.dispose();
  return dir;
}

bool _tieneIndice(Directory dir) {
  final raw = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'),
      mode: OpenMode.readOnly);
  final rows = raw.select("SELECT name FROM sqlite_master WHERE "
      "type='index' AND name='idx_printings_set_num'");
  raw.dispose();
  return rows.isNotEmpty;
}

void main() {
  test('abrir la base crea idx_printings_set_num si falta', () async {
    final dir = _dbSinIndice();
    expect(_tieneIndice(dir), isFalse, reason: 'la fixture nace sin índice');
    final db = CardDatabase(dataDir: dir);
    final hit = await db.byScryfallId('s1'); // fuerza el _open()
    db.close();
    expect(hit, isNotNull);
    expect(_tieneIndice(dir), isTrue);
  });

  test('con la base en solo-lectura se abre igual (sin índice, pero va)',
      () async {
    final dir = _dbSinIndice();
    final file = File(p.join(dir.path, 'manaforge_cards.sqlite'));
    Process.runSync('chmod', ['444', file.path]);
    final db = CardDatabase(dataDir: dir);
    final hit = await db.byScryfallId('s1');
    db.close();
    expect(hit, isNotNull, reason: 'sin permiso de escritura no se rompe');
    expect(_tieneIndice(dir), isFalse);
  });

  test('sin base descargada NO se crea un fichero fantasma', () async {
    // sqlite3.open en modo escritura CREA el fichero si no existe: si eso
    // pasara antes de la primera descarga, isReady() daría true con una
    // base vacía y el arranque se saltaría la descarga de verdad
    final dir = Directory.systemTemp.createTempSync('mf-indice-vacio');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = CardDatabase(dataDir: dir);
    try {
      await db.byScryfallId('s1'); // no hay base: reventará, y está bien
    } catch (_) {}
    db.close();
    expect(File(p.join(dir.path, 'manaforge_cards.sqlite')).existsSync(),
        isFalse, reason: 'crear la base vacía envenena el primer arranque');
    expect(await db.isReady(), isFalse);
  });

  test('crear el índice NO cambia el mtime de la base', () async {
    // downloadedAt() (frescura de la base, kCardsMaxAgeDays) ES el mtime
    // del fichero: si crearlo lo pusiera a "ahora", el arranque de la
    // migración daría la base por al día y se saltaría la descarga
    final dir = _dbSinIndice();
    final file = File(p.join(dir.path, 'manaforge_cards.sqlite'));
    final antes = DateTime(2026, 7, 20, 12, 0, 0);
    file.setLastModifiedSync(antes);
    final db = CardDatabase(dataDir: dir);
    await db.byScryfallId('s1');
    db.close();
    expect(_tieneIndice(dir), isTrue);
    expect(file.lastModifiedSync(), antes);
  });

  test('abrir dos veces no duplica ni revienta (IF NOT EXISTS)', () async {
    final dir = _dbSinIndice();
    final db = CardDatabase(dataDir: dir);
    await db.byScryfallId('s1');
    db.close();
    final db2 = CardDatabase(dataDir: dir);
    await db2.byScryfallId('s1');
    db2.close();
    expect(_tieneIndice(dir), isTrue);
  });
}
