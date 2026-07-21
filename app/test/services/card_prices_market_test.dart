/// Precios por EDICIÓN según el mercado elegido: al cambiar de Cardmarket a
/// TCGplayer (o a Cardhoarder) la lista de versiones tiene que traer los
/// precios de esa página, no los euros de siempre.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/markets.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// Base con el mismo esquema que genera scripts/build_card_db.py (schema 4).
void _writeCardsDb(Directory dir) {
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
  db.execute(
      "INSERT INTO cards VALUES ('o1','Enduring Curiosity','{2}{U}',3,'U','U',"
      "'Enchantment Creature','texto','2','3','[]','{}')");
  // dos ediciones con precios distintos en cada mercado
  db.execute("INSERT INTO printings VALUES ('s1','o1','dsk','Duskmourn','51',"
      "'en','Enduring Curiosity','rare',null,null,null,"
      "'6.17','2024-09-27','12.00','6.13','13.50','0.02')");
  db.execute("INSERT INTO printings VALUES ('s2','o1','plst','The List','200',"
      "'en','Enduring Curiosity','rare',null,null,null,"
      "'8.00','2025-01-10','15.00','9.90','16.00','0.03')");
  db.dispose();
}

void main() {
  late Directory dir;
  late CardDatabase db;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('mf_cards');
    _writeCardsDb(dir);
    db = CardDatabase(dataDir: dir);
  });
  tearDown(() {
    db.close();
    dir.deleteSync(recursive: true);
  });

  test('las versiones traen el precio del mercado que se pide', () async {
    final eur = await db.versionsOf('o1');
    expect(eur.map((v) => v.price), [8.00, 6.17]); // más nueva primero
    expect(eur.first.priceFoil, 15.00);

    final usd = await db.versionsOf('o1', market: Market.tcgplayer);
    expect(usd.map((v) => v.price), [9.90, 6.13]);
    expect(usd.first.priceFoil, 16.00);

    final tix = await db.versionsOf('o1', market: Market.cardhoarder);
    expect(tix.map((v) => v.price), [0.03, 0.02]);
    expect(tix.first.priceFoil, isNull); // MTGO no tiene foil aparte
  });

  test('los mercados sin precio por edición dejan las versiones sin precio',
      () async {
    for (final market in [Market.cardkingdom, Market.manapool]) {
      final versions = await db.versionsOf('o1', market: market);
      expect(versions, hasLength(2), reason: '${market.label} pierde ediciones');
      expect(versions.every((v) => v.price == null), isTrue,
          reason: '${market.label} no publica precio por edición');
    }
  });

  test('el mercado de una expansión también cambia de precios', () async {
    final eur = await db.setCardsWithPrices('dsk');
    expect(eur.single.price, 6.17);
    final usd = await db.setCardsWithPrices('dsk', market: Market.tcgplayer);
    expect(usd.single.price, 6.13);
    expect(usd.single.priceFoil, 13.50);
    final ck = await db.setCardsWithPrices('dsk', market: Market.cardkingdom);
    expect(ck.single.price, isNull);
  });

  test('los precios de hoy por carta y por edición siguen al mercado',
      () async {
    expect((await db.pricesForOracles(['o1']))['o1'], 6.17);
    expect(
        (await db.pricesForOracles(['o1'], market: Market.tcgplayer))['o1'],
        6.13);
    expect((await db.pricesForPrintings(['dsk|51']))['dsk|51'], 6.17);
    expect(
        (await db.pricesForPrintings(['dsk|51'],
            market: Market.cardhoarder))['dsk|51'],
        0.02);
    // Card Kingdom no tiene columna: vacío, no euros disfrazados
    expect(await db.pricesForOracles(['o1'], market: Market.cardkingdom),
        isEmpty);
  });

  test('una base vieja sin columnas de dólares no revienta', () async {
    final old = Directory.systemTemp.createTempSync('mf_cards_old');
    addTearDown(() => old.deleteSync(recursive: true));
    final raw = sqlite3.open(p.join(old.path, 'manaforge_cards.sqlite'));
    raw.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
    raw.execute('CREATE TABLE cards (oracle_id TEXT PRIMARY KEY, name TEXT, '
        'mana_cost TEXT, cmc REAL, colors TEXT, color_identity TEXT, '
        'type_line TEXT, oracle_text TEXT, power TEXT, toughness TEXT, '
        'keywords TEXT, legalities TEXT)');
    raw.execute('CREATE TABLE printings (scryfall_id TEXT PRIMARY KEY, '
        'oracle_id TEXT, set_code TEXT, set_name TEXT, collector_number TEXT, '
        'lang TEXT, printed_name TEXT, rarity TEXT, image_small TEXT, '
        'image_normal TEXT, image_png TEXT, price_eur TEXT)');
    raw.execute("INSERT INTO cards VALUES ('o1','X','',0,'','','','','','',"
        "'[]','{}')");
    raw.execute("INSERT INTO printings VALUES ('s1','o1','dsk','D','1','en',"
        "'X','rare',null,null,null,'6.17')");
    raw.dispose();

    final oldDb = CardDatabase(dataDir: old);
    addTearDown(oldDb.close);
    expect((await oldDb.versionsOf('o1')).single.price, 6.17);
    expect(
        (await oldDb.versionsOf('o1', market: Market.tcgplayer)).single.price,
        isNull);
    expect(await oldDb.pricesForOracles(['o1'], market: Market.tcgplayer),
        isEmpty);
  });
}
