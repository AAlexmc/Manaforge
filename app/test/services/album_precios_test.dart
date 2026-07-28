/// Precios del álbum de una expansión.
///
/// Los precios se guardan como TEXTO en la base (así los da Scryfall), así
/// que hay que castearlos: sin `CAST`, sqlite devuelve un String y la
/// pantalla revienta con "type 'String' is not a subtype of type 'num?'" —
/// y el mínimo se calcularía comparando textos, donde "10.00" es menor que
/// "9.00".
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/services/markets.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _dbConPrecios() {
  final dir = Directory.systemTemp.createTempSync('mf-album');
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
      price_eur TEXT, released_at TEXT, price_eur_foil TEXT,
      price_usd TEXT, price_usd_foil TEXT, price_tix TEXT)
  ''');
  db.execute("INSERT INTO cards VALUES ('o1','Ornithopter','{0}',0,'','C',"
      "'Artifact Creature','Flying','0','2','[]','{}')");
  db.execute("INSERT INTO cards VALUES ('o2','Shock','{R}',1,'R','R',"
      "'Instant','2 damage','','','[]','{}')");
  // misma carta en dos idiomas: el álbum agrupa por número y el precio no
  // puede depender de cuál caiga primero
  db.execute("INSERT INTO printings VALUES ('s1','o1','aer','Aether Revolt',"
      "'167','en','Ornithopter','uncommon',null,null,null,"
      "'9.00','2017-01-20','1','2.50','3','0.02')");
  db.execute("INSERT INTO printings VALUES ('s2','o1','aer','Aether Revolt',"
      "'167','es','Ornitóptero','uncommon',null,null,null,"
      "'10.00','2017-01-20','1','2.50','3','0.02')");
  db.execute("INSERT INTO printings VALUES ('s3','o2','aer','Aether Revolt',"
      "'117','en','Shock','common',null,null,null,"
      "null,'2017-01-20',null,'0.30',null,null)");
  db.dispose();
  return dir;
}

void main() {
  test('el precio del álbum es un número, no el texto de la base', () async {
    final db = CardDatabase(dataDir: _dbConPrecios());

    final cards = await db.setCards('aer');

    final orni = cards.firstWhere((c) => c.collectorNumber == '167');
    expect(orni.price, isA<double>());
    expect(orni.price, closeTo(9.00, 0.001),
        reason: 'el mínimo es 9, no "10" por comparar textos');
  });

  test('sin precio en la base, la carta se queda sin precio', () async {
    final db = CardDatabase(dataDir: _dbConPrecios());

    final cards = await db.setCards('aer');

    expect(cards.firstWhere((c) => c.collectorNumber == '117').price, isNull);
  });

  test('el precio sigue al mercado elegido', () async {
    final db = CardDatabase(dataDir: _dbConPrecios());

    final enDolares = await db.setCards('aer', market: Market.tcgplayer);

    expect(enDolares.firstWhere((c) => c.collectorNumber == '167').price,
        closeTo(2.50, 0.001));
    expect(enDolares.firstWhere((c) => c.collectorNumber == '117').price,
        closeTo(0.30, 0.001));
  });

  test('un mercado sin precio por edición no revienta: deja el precio vacío',
      () async {
    final db = CardDatabase(dataDir: _dbConPrecios());

    // Card Kingdom no publica precio por edición en la base
    final cards = await db.setCards('aer', market: Market.cardkingdom);

    expect(cards, isNotEmpty);
    expect(cards.every((c) => c.price == null), isTrue);
  });

  test('cambiar de mercado NO cambia el arte: la fila del álbum es la misma',
      () async {
    final db = CardDatabase(dataDir: _dbConPrecios());

    final euros = await db.setCards('aer', market: Market.cardmarket);
    final dolares = await db.setCards('aer', market: Market.tcgplayer);

    final orniEur = euros.firstWhere((c) => c.collectorNumber == '167');
    final orniUsd = dolares.firstWhere((c) => c.collectorNumber == '167');
    // preferencia inglesa determinista: siempre la impresión 'en'
    expect(orniEur.printedName, 'Ornithopter');
    expect(orniUsd.printedName, orniEur.printedName,
        reason: 'con dos agregados en el GROUP BY la fila era arbitraria '
            'y el arte podía cambiar con el mercado');
  });
}
