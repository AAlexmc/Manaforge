/// Carátula de cada expansión en la home: es la imagen de la carta más cara
/// del set. Los sets nuevos aún sin precio de Cardmarket se quedaban con el
/// mosaico gris; ahora caen a una carta representativa (la de rareza más alta
/// con imagen), para que la carátula no salga vacía.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// Base con el esquema de scripts/build_card_db.py (schema 4).
void _writeDb(Directory dir, void Function(Database db) seed) {
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
  seed(db);
  db.dispose();
}

/// Rellena un set con [count] cartas (para superar el HAVING total >= 25).
/// [special] permite fijar rareza/imagen/precio de un número concreto.
void _seedSet(
  Database db, {
  required String code,
  required String name,
  required String released,
  int count = 25,
  Map<int, ({String rarity, String? image, String? price})> special =
      const {},
}) {
  for (var i = 1; i <= count; i++) {
    final s = special[i];
    final rarity = s?.rarity ?? 'common';
    final image = s?.image; // por defecto sin imagen
    final price = s?.price;
    db.execute(
      'INSERT INTO printings VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
      [
        '$code-$i', 'o-$code-$i', code, name, '$i', 'en', 'Card $i',
        rarity, null, image, null,
        price, released, null, null, null, null,
      ],
    );
  }
}

void main() {
  late Directory dir;
  late CardDatabase db;

  tearDown(() {
    db.close();
    dir.deleteSync(recursive: true);
  });

  test('el set con precios usa la imagen de la carta más cara', () async {
    dir = Directory.systemTemp.createTempSync('mf_cover');
    _writeDb(dir, (raw) {
      _seedSet(raw, code: 'dsk', name: 'Duskmourn', released: '2024-09-27',
          special: {
            10: (rarity: 'rare', image: 'CARA.jpg', price: '99.00'),
            11: (rarity: 'rare', image: 'BARATA.jpg', price: '1.00'),
          });
    });
    db = CardDatabase(dataDir: dir);

    final sets = await db.marketSets();
    final dskCard = sets.firstWhere((s) => s.code == 'dsk');
    expect(dskCard.imageNormal, 'CARA.jpg'); // la más cara manda
  });

  test('el set nuevo sin precios cae a la carta de rareza más alta', () async {
    dir = Directory.systemTemp.createTempSync('mf_cover');
    _writeDb(dir, (raw) {
      // Ninguna carta tiene price_eur: como Star Trek/HOC/PANA recién salidos.
      _seedSet(raw, code: 'trk', name: 'Star Trek', released: '2026-05-01',
          special: {
            3: (rarity: 'common', image: 'COMUN.jpg', price: null),
            7: (rarity: 'mythic', image: 'MITICA.jpg', price: null),
            9: (rarity: 'rare', image: 'RARA.jpg', price: null),
          });
    });
    db = CardDatabase(dataDir: dir);

    final sets = await db.marketSets();
    final trk = sets.firstWhere((s) => s.code == 'trk');
    expect(trk.imageNormal, isNotNull,
        reason: 'set sin precio no debe quedar con carátula vacía');
    expect(trk.imageNormal, 'MITICA.jpg',
        reason: 'prefiere la rareza más alta con imagen');
  });

  test('el set sin ninguna imagen se queda sin carátula (sin fabricar)',
      () async {
    dir = Directory.systemTemp.createTempSync('mf_cover');
    _writeDb(dir, (raw) {
      _seedSet(raw, code: 'xxx', name: 'Sin Arte', released: '2026-01-01');
    });
    db = CardDatabase(dataDir: dir);

    final sets = await db.marketSets();
    final xxx = sets.firstWhere((s) => s.code == 'xxx');
    expect(xxx.imageNormal, isNull);
  });
}
