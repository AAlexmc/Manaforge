/// La impresión que representa a una carta en el buscador es DETERMINISTA.
///
/// Con `GROUP BY` a secas, sqlite elegía una impresión arbitraria: la misma
/// búsqueda podía apuntar una Alpha de cientos de euros o una reimpresión de
/// céntimos, y ese precio se presentaba como exacto. Criterio fijado: la más
/// barata CON precio (conservador), empates por set y número.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

Directory _db(List<String> printings) {
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
      price_eur TEXT, released_at TEXT, price_eur_foil TEXT,
      price_usd TEXT, price_usd_foil TEXT, price_tix TEXT)
  ''');
  db.execute("INSERT INTO cards VALUES ('o1','Black Lotus','{0}',0,'','C',"
      "'Artifact','','','','[]','{}')");
  for (final sql in printings) {
    db.execute(sql);
  }
  db.dispose();
  return dir;
}

void main() {
  test('el buscador apunta la impresión más barata con precio, no una al azar',
      () async {
    final dir = _db([
      // Alpha carísima primero en la tabla: no puede ganar por orden físico
      "INSERT INTO printings VALUES ('s1','o1','lea','Alpha','232','en',"
          "'Black Lotus','rare',null,null,null,'50000.00','1993-08-05',"
          "null,null,null,null)",
      "INSERT INTO printings VALUES ('s2','o1','30a','30th','1','en',"
          "'Black Lotus','rare',null,null,null,'900.00','2022-11-28',"
          "null,null,null,null)",
      // y una sin precio, que va la última en el criterio
      "INSERT INTO printings VALUES ('s3','o1','cei','Collectors','1','en',"
          "'Black Lotus','rare',null,null,null,null,'1993-12-01',"
          "null,null,null,null)",
    ]);
    final db = CardDatabase(dataDir: dir);
    final hits = await db.search('Black Lotus');
    db.close();

    expect(hits.single.printingKey, '30a|1');
  });

  test('con precios "10.00" vs "9.00" gana el 9 (CAST, no orden de texto)',
      () async {
    final dir = _db([
      "INSERT INTO printings VALUES ('s1','o1','aaa','A','1','en',"
          "'Black Lotus','rare',null,null,null,'10.00','2020-01-01',"
          "null,null,null,null)",
      "INSERT INTO printings VALUES ('s2','o1','bbb','B','2','en',"
          "'Black Lotus','rare',null,null,null,'9.00','2021-01-01',"
          "null,null,null,null)",
    ]);
    final db = CardDatabase(dataDir: dir);
    final hits = await db.search('Black Lotus');
    db.close();

    expect(hits.single.printingKey, 'bbb|2');
  });
}
