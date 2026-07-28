/// El detalle de mazo enseña los nombres en español (UI es + DB v5) y la
/// EXPORTACIÓN sigue en inglés siempre — Moxfield/Arena no entienden
/// «Ornitóptero».
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/ui/decks/deck_detail_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../helpers/app_l10n.dart';

Directory _dbV5() {
  final dir = Directory.systemTemp.createTempSync('mf-dd-es');
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
      name_es TEXT)
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
      "'Artifact Creature','','0','2','[]','{}','Ornitóptero')");
  db.execute("INSERT INTO cards VALUES ('o2','Forest','',0,'','G',"
      "'Basic Land — Forest','','','','[]','{}','Bosque')");
  db.dispose();
  return dir;
}

fe.GeneratedDeck _gen() => const fe.GeneratedDeck(
      fe.Deck(
        name: 'Forge C test',
        colors: 'C',
        archetype: fe.Archetype.midrange,
        cards: {'Ornithopter': 4},
        lands: {'Forest': 20},
      ),
      'artifacts',
      5.0,
    );

Map<String, fe.Card> _pool() => {
      'Ornithopter': const fe.Card(
          name: 'Ornithopter',
          qty: 4,
          manaCost: '{0}',
          cmc: 0,
          colors: '',
          types: ['Artifact', 'Creature'],
          oracle: '',
          power: 0,
          toughness: 2),
      'Forest': const fe.Card(
          name: 'Forest',
          qty: 20,
          manaCost: '',
          cmc: 0,
          colors: '',
          types: ['Basic', 'Land'],
          oracle: '{T}: Add {G}.'),
    };

Future<void> _pump(WidgetTester tester,
    {required Locale locale, CardDatabase? db}) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(appDePrueba(
    locale: locale,
    home: DeckDetailScreen(gen: _gen(), pool: _pool(), db: db),
  ));
  // carga async de precios/nombres: unos pumps discretos, sin pumpAndSettle
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('con UI en español y DB v5, la lista dice Ornitóptero y Bosque',
      (tester) async {
    final db = CardDatabase(dataDir: _dbV5());
    addTearDown(db.close);
    await _pump(tester, locale: const Locale('es'), db: db);

    // lista + pie del banner sin imagen: las DOS superficies en español
    expect(find.text('Ornitóptero'), findsWidgets);
    expect(find.text('Bosque'), findsWidgets);
    expect(find.text('Ornithopter'), findsNothing);
  });

  testWidgets('con UI en inglés, la lista sigue en inglés', (tester) async {
    final db = CardDatabase(dataDir: _dbV5());
    addTearDown(db.close);
    await _pump(tester, locale: const Locale('en'), db: db);

    expect(find.text('Ornithopter'), findsWidgets);
    expect(find.text('Ornitóptero'), findsNothing);
  });

  testWidgets('sin DB (pool suelto) no revienta y enseña inglés',
      (tester) async {
    await _pump(tester, locale: const Locale('es'));
    expect(find.text('Ornithopter'), findsWidgets);
  });

  testWidgets('la exportación copia SIEMPRE los nombres ingleses',
      (tester) async {
    final db = CardDatabase(dataDir: _dbV5());
    addTearDown(db.close);

    String? copiado;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copiado = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await _pump(tester, locale: const Locale('es'), db: db);
    await tester.tap(find.byIcon(Icons.copy_all));
    await tester.pump();

    expect(copiado, isNotNull);
    expect(copiado, contains('4 Ornithopter'));
    expect(copiado, contains('20 Forest'));
    expect(copiado, isNot(contains('Ornitóptero')));
  });
}
