/// El pool de Forge acotado por expansiones (que en esta app son los
/// álbumes), y el pool de "cartas que no tengo".
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConDosSets() {
  final dir = Directory.systemTemp.createTempSync('mf-forge-sets');
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
  db.execute("INSERT INTO cards VALUES ('o2','Counterspell','{U}{U}',2,'U',"
      "'U','Instant','Counter','','','[]','{}')");
  db.execute("INSERT INTO cards VALUES ('o3','Llanowar Elves','{G}',1,'G',"
      "'G','Creature — Elf','Tap: add G','1','1','[]','{}')");
  db.execute("INSERT INTO cards VALUES ('o4','Brazen Borrower','{1}{U}',2,'U',"
      "'U','Creature — Faerie Wizard // Instant — Adventure',"
      "'Flying','3','1','[\"Flying\"]','{}')");
  // o1 sale en blb y en kld; o2 solo en blb; o3 solo en kld
  db.execute("INSERT INTO printings VALUES ('s1','o1','blb','Bloomburrow',"
      "'72','en','Shock','common',null,null,null,'0.10','2024-08-02')");
  db.execute("INSERT INTO printings VALUES ('s2','o1','kld','Kaladesh',"
      "'5','en','Shock','common',null,null,null,'0.20','2016-09-30')");
  db.execute("INSERT INTO printings VALUES ('s3','o2','blb','Bloomburrow',"
      "'40','en','Counterspell','common',null,null,null,'1.00','2024-08-02')");
  db.execute("INSERT INTO printings VALUES ('s4','o3','kld','Kaladesh',"
      "'99','en','Llanowar Elves','common',null,null,null,'0.30',"
      "'2016-09-30')");
  db.dispose();
  return dir;
}

OwnedCard _carta(String oracleId, String name) =>
    OwnedCard(oracleId: oracleId, name: name, colors: '', qty: 1);

void main() {
  group('tu colección, acotada a unas expansiones', () {
    test('solo cuenta las copias de esas expansiones', () {
      final store = CollectionStore();
      store.add(_carta('o1', 'Shock'), qty: 2, printingKey: 'blb|72');
      store.add(_carta('o1', 'Shock'), qty: 1, printingKey: 'kld|5');
      store.add(_carta('o3', 'Llanowar Elves'), qty: 4,
          printingKey: 'kld|99');

      final soloBlb = store.qtyByOracleInSets({'blb'});

      expect(soloBlb, {'o1': 2});
    });

    test('sin expansiones elegidas, es la colección entera', () {
      final store = CollectionStore();
      store.add(_carta('o1', 'Shock'), qty: 2, printingKey: 'blb|72');
      store.add(_carta('o3', 'Llanowar Elves'), qty: 1,
          printingKey: 'kld|99');

      expect(store.qtyByOracleInSets(const {}), {'o1': 2, 'o3': 1});
    });

    test('el código de expansión no distingue mayúsculas', () {
      final store = CollectionStore();
      store.add(_carta('o1', 'Shock'), qty: 1, printingKey: 'blb|72');

      expect(store.qtyByOracleInSets({'BLB'}), {'o1': 1});
    });

    test('nunca promete más copias de las que tienes de verdad', () {
      final store = CollectionStore();
      store.add(_carta('o1', 'Shock'), qty: 3, printingKey: 'blb|72');
      // vender dos: la colección baja, y el filtro no puede seguir en 3
      store.setQty('o1', 1);

      final acotada = store.qtyByOracleInSets({'blb'});

      expect(acotada['o1'], 1);
    });

    test('una impresión sin dueño conocido no se cuela', () {
      final store = CollectionStore();
      // colección antigua: hay cantidades por edición pero no se sabe de
      // quién son (el mapa de dueños se rellena al abrir Colección)
      store.add(_carta('o1', 'Shock'), qty: 1); // sin printingKey

      expect(store.qtyByOracleInSets({'blb'}), isEmpty);
    });
  });

  group('cartas que NO tengo', () {
    test('devuelve todo lo impreso en esas expansiones', () async {
      final db = CardDatabase(dataDir: _dbConDosSets());

      final pool = await db.oraclesInSets({'blb'});

      expect(pool.keys.toSet(), {'o1', 'o2'});
      expect(pool['o1'], 4); // 4 copias: el máximo de una lista de 60
    });

    test('varias expansiones se suman sin duplicar la carta', () async {
      final db = CardDatabase(dataDir: _dbConDosSets());

      final pool = await db.oraclesInSets({'blb', 'kld'});

      expect(pool.keys.toSet(), {'o1', 'o2', 'o3'});
    });

    test('sin expansiones no devuelve nada (no es un catálogo)', () async {
      final db = CardDatabase(dataDir: _dbConDosSets());

      expect(await db.oraclesInSets(const {}), isEmpty);
    });

    test('el pool del motor se construye con esas cartas', () async {
      final db = CardDatabase(dataDir: _dbConDosSets());

      final ids = await db.oraclesInSets({'kld'});
      final pool = await db.buildPool(ids, assumeBasics: false);

      expect(pool.keys.toSet(), {'Shock', 'Llanowar Elves'});
      expect(pool['Shock']!.qty, 4);
    });

    test('subtipos de la cara delantera y keywords de la columna JSON',
        () async {
      final db = CardDatabase(dataDir: _dbConDosSets());

      final pool = await db.buildPool({'o4': 1}, assumeBasics: false);

      final card = pool['Brazen Borrower']!;
      expect(card.types, ['Creature']);
      expect(card.subtypes, ['Faerie', 'Wizard']); // la cara Adventure no contamina
      expect(card.keywords, ['flying']);
    });

    test('DB anterior al schema v4 (sin columna keywords) igual da el pool',
        () async {
      final dir = Directory.systemTemp.createTempSync('mf-forge-sin-kw');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final raw = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
      raw.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
      raw.execute('''
        CREATE TABLE cards (
          oracle_id TEXT PRIMARY KEY, name TEXT, mana_cost TEXT, cmc REAL,
          colors TEXT, color_identity TEXT, type_line TEXT, oracle_text TEXT,
          power TEXT, toughness TEXT, legalities TEXT)
      ''');
      raw.execute('''
        CREATE TABLE printings (
          scryfall_id TEXT PRIMARY KEY, oracle_id TEXT, set_code TEXT,
          set_name TEXT, collector_number TEXT, lang TEXT, printed_name TEXT,
          rarity TEXT, image_small TEXT, image_normal TEXT, image_png TEXT,
          price_eur TEXT, released_at TEXT)
      ''');
      raw.execute("INSERT INTO cards VALUES ('o1','Shock','{R}',1,'R','R',"
          "'Instant','2 damage','','','{}')");
      raw.execute("INSERT INTO printings VALUES ('s1','o1','blb',"
          "'Bloomburrow','72','en','Shock','common',null,null,null,'0.10',"
          "'2024-08-02')");
      raw.dispose();

      final db = CardDatabase(dataDir: dir);

      final pool = await db.buildPool({'o1': 3}, assumeBasics: false);

      expect(pool['Shock']!.qty, 3);
      expect(pool['Shock']!.keywords, isEmpty);
    });

    test('más cartas que el tamaño de un lote: todas entran con su cantidad',
        () async {
      final dir = Directory.systemTemp.createTempSync('mf-forge-lote');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final raw = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
      raw.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
      raw.execute('''
        CREATE TABLE cards (
          oracle_id TEXT PRIMARY KEY, name TEXT, mana_cost TEXT, cmc REAL,
          colors TEXT, color_identity TEXT, type_line TEXT, oracle_text TEXT,
          power TEXT, toughness TEXT, keywords TEXT, legalities TEXT)
      ''');
      raw.execute('''
        CREATE TABLE printings (
          scryfall_id TEXT PRIMARY KEY, oracle_id TEXT, set_code TEXT,
          set_name TEXT, collector_number TEXT, lang TEXT, printed_name TEXT,
          rarity TEXT, image_small TEXT, image_normal TEXT, image_png TEXT,
          price_eur TEXT, released_at TEXT)
      ''');
      // más de 400 (el tamaño del lote troceado): confirma que ninguna se
      // queda fuera y que cada una arrastra la qty que le toca, no la de
      // cualquier otra
      const total = 420;
      final owned = <String, int>{};
      for (var i = 0; i < total; i++) {
        final id = 'o$i';
        raw.execute(
            'INSERT INTO cards VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
            [id, 'Carta $i', '{R}', 1, 'R', 'R', 'Instant', '', '', '',
              '[]', '{}']);
        raw.execute(
            'INSERT INTO printings VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
            ['s$i', id, 'blb', 'Bloomburrow', '$i', 'en', 'Carta $i',
              'common', null, null, null, '0.10', '2024-08-02']);
        owned[id] = i + 1;
      }
      raw.dispose();

      final db = CardDatabase(dataDir: dir);

      final pool = await db.buildPool(owned, assumeBasics: false);

      expect(pool.keys.length, total);
      expect(pool['Carta 0']!.qty, 1);
      expect(pool['Carta 419']!.qty, 420);
    });

    test('dos oracles con el mismo nombre: gana el orden de la colección, '
        'no el orden en que sqlite devuelva el IN (...)', () async {
      // pasa de verdad en la BD publicada (Un-sets: 'Sly Spy' ×6 variantes) y
      // el orden del pool es observable: rompe empates del generador
      final dir = Directory.systemTemp.createTempSync('mf-forge-dup');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final raw = sqlite3.open(p.join(dir.path, 'manaforge_cards.sqlite'));
      raw.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
      raw.execute('''
        CREATE TABLE cards (
          oracle_id TEXT PRIMARY KEY, name TEXT, mana_cost TEXT, cmc REAL,
          colors TEXT, color_identity TEXT, type_line TEXT, oracle_text TEXT,
          power TEXT, toughness TEXT, keywords TEXT, legalities TEXT)
      ''');
      raw.execute('''
        CREATE TABLE printings (
          scryfall_id TEXT PRIMARY KEY, oracle_id TEXT, set_code TEXT,
          set_name TEXT, collector_number TEXT, lang TEXT, printed_name TEXT,
          rarity TEXT, image_small TEXT, image_normal TEXT, image_png TEXT,
          price_eur TEXT, released_at TEXT)
      ''');
      // 'zzz' va ANTES en la colección pero DESPUÉS en orden de oracle_id:
      // sqlite devuelve el IN (...) ordenado por la clave, no por la lista
      raw.execute("INSERT INTO cards VALUES ('zzz','Sly Spy','{U}',1,'U','U',"
          "'Creature — Spy','variante A','1','1','[]','{}')");
      raw.execute("INSERT INTO cards VALUES ('aaa','Sly Spy','{U}',2,'U','U',"
          "'Creature — Spy','variante B','2','2','[]','{}')");
      raw.dispose();

      final db = CardDatabase(dataDir: dir);

      final pool = await db.buildPool({'zzz': 1, 'aaa': 1},
          assumeBasics: false);

      // semántica de siempre: el último del recorrido de la colección pisa
      // al anterior en pool[nombre]
      expect(pool['Sly Spy']!.cmc, 2, reason: "gana 'aaa', el último");
    });
  });
}
