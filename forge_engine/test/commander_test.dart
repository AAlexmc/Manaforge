import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests del generador de Commander: 100 cartas, singleton, identidad.
void main() {
  Map<String, Card> bigPool() {
    final pool = <String, Card>{};
    // comandante legendario blanco
    pool['General Bright'] = const Card(
      name: 'General Bright',
      qty: 1,
      manaCost: '{2}{W}{W}',
      cmc: 4,
      colors: 'W',
      colorIdentity: 'W',
      types: ['Legendary', 'Creature'],
      oracle: 'Other creatures you control get +1/+1.',
      power: 4,
      toughness: 4,
    );
    // 70 cartas blancas/incoloras distintas con roles variados
    for (var i = 0; i < 70; i++) {
      final cmc = 1 + i % 6;
      final role = i % 5;
      pool['Filler $i'] = Card(
        name: 'Filler $i',
        qty: 1,
        manaCost: '{${cmc - 1}}{W}',
        cmc: cmc,
        colors: 'W',
        colorIdentity: 'W',
        types: role == 0 ? const ['Creature'] : const ['Instant'],
        oracle: switch (role) {
          0 => 'Vigilance',
          1 => 'Destroy target creature.',
          2 => 'Draw a card. Draw a card.',
          3 => '{T}: Add {W}. Search your library for a Plains card.',
          _ => 'Destroy all creatures.',
        },
        power: role == 0 ? 2 + i % 3 : null,
        toughness: role == 0 ? 2 + i % 3 : null,
      );
    }
    // oracle real de Plains: el clasificador de tierras (manabase v2) lee la
    // cláusula "Add {W}" para saber qué produce, ya no basta con el nombre.
    pool['Plains'] = const Card(
      name: 'Plains',
      qty: 40,
      manaCost: '',
      cmc: 0,
      colors: '',
      colorIdentity: '',
      types: ['Basic', 'Land'],
      oracle: '({T}: Add {W}.)',
    );
    // carta AZUL que jamás debe colarse en identidad W
    pool['Blue Intruder'] = const Card(
      name: 'Blue Intruder',
      qty: 4,
      manaCost: '{1}{U}',
      cmc: 2,
      colors: 'U',
      colorIdentity: 'U',
      types: ['Creature'],
      oracle: 'Flying',
      power: 2,
      toughness: 2,
    );
    return pool;
  }

  test('genera un Commander legal: 100 cartas, singleton, identidad W', () {
    final pool = bigPool();
    final gen = generateCommanderDeck(pool, 'General Bright');
    expect(gen, isNotNull);
    final deck = gen!.deck;
    expect(deck.totalCards, 100);
    expect(deck.cards['General Bright'], 1);
    expect(deck.cards.containsKey('Blue Intruder'), isFalse);
    expect(
        validateCommanderDeck(deck, pool, 'General Bright'), isEmpty);
    // singleton de verdad (salvo básicas)
    deck.cards.forEach((name, qty) => expect(qty, 1, reason: name));
  });

  test('trae eval con sourcesByColor recalculado tras el suelo de básicas '
      '(Task 9)', () {
    final pool = bigPool();
    final gen = generateCommanderDeck(pool, 'General Bright');
    expect(gen, isNotNull);
    expect(gen!.eval, isNotNull);
    expect(gen.score, closeTo(gen.eval!.total, 1e-9));
    expect(gen.manabase, isNotNull);
    // sourcesByColor del manabase final: W es el único color usado, y debe
    // reflejar las tierras que de verdad quedaron en el mazo (Plains).
    final wSources = gen.manabase!.sourcesByColor['W'] ?? 0;
    expect(wSources, gen.deck.lands['Plains']);
  });

  test('WB con duales: el suelo de básicas convierte y sourcesByColor se '
      'recalcula sobre las tierras FINALES (Task 9 review)', () {
    final pool = <String, Card>{};
    pool['Duke Grim'] = const Card(
      name: 'Duke Grim',
      qty: 1,
      manaCost: '{W}{B}',
      cmc: 2,
      colors: 'WB',
      colorIdentity: 'WB',
      types: ['Legendary', 'Creature'],
      oracle: 'Deathtouch',
      power: 2,
      toughness: 2,
    );
    // exigencia CC en ambos colores => required alto => el greedy llena casi
    // todo con duales y deja las básicas cortas => el suelo de 6 convierte.
    for (var i = 0; i < 70; i++) {
      final w = i.isEven;
      final cc = i < 4; // 4 cartas doble símbolo
      final color = w ? 'W' : 'B';
      pool['Filler $i'] = Card(
        name: 'Filler $i',
        qty: 1,
        manaCost: cc ? '{$color}{$color}' : '{${1 + i % 4}}{$color}',
        cmc: cc ? 2 : 2 + i % 4,
        colors: color,
        colorIdentity: color,
        types: i % 5 == 0 ? const ['Creature'] : const ['Instant'],
        oracle: switch (i % 5) {
          0 => 'Lifelink',
          1 => 'Destroy target creature.',
          2 => 'Draw a card. Draw a card.',
          3 => '{T}: Add {C}. Search your library for a basic land card.',
          _ => 'Destroy all creatures.',
        },
        power: i % 5 == 0 ? 2 : null,
        toughness: i % 5 == 0 ? 2 : null,
      );
    }
    for (var i = 0; i < 40; i++) {
      pool['Dual $i'] = Card(
        name: 'Dual $i',
        qty: 1,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: const ['Land'],
        oracle: '({T}: Add {W} or {B}.)',
      );
    }
    pool['Plains'] = const Card(
        name: 'Plains', qty: 6, manaCost: '', cmc: 0, colors: '',
        types: ['Basic', 'Land'], oracle: '({T}: Add {W}.)');
    pool['Swamp'] = const Card(
        name: 'Swamp', qty: 6, manaCost: '', cmc: 0, colors: '',
        types: ['Basic', 'Land'], oracle: '({T}: Add {B}.)');

    final gen = generateCommanderDeck(pool, 'Duke Grim');
    expect(gen, isNotNull);
    final lands = gen!.deck.lands;
    // la conversión del suelo ocurrió de verdad: duales presentes Y 6+6 básicas
    expect(lands.keys.any((n) => n.startsWith('Dual')), isTrue);
    expect(lands['Plains'], 6);
    expect(lands['Swamp'], 6);
    // sourcesByColor debe ser el recuento sobre las tierras FINALES (post
    // conversión), no el del greedy: si fuera el stale, este cuadre falla.
    for (final c in ['W', 'B']) {
      var manual = 0;
      lands.forEach((name, qty) {
        if (LandProfile.fromCard(pool[name]!).sourceOf(c, 'WB')) manual += qty;
      });
      expect(gen.manabase!.sourcesByColor[c], manual,
          reason: 'fuentes de $c stale tras el suelo de básicas');
    }
    expect(gen.eval, isNotNull);
    expect(gen.score, closeTo(gen.eval!.total, 1e-9));
  });

  test('propuestas: encuentra al comandante él solo', () {
    final proposals = generateCommanderProposals(bigPool());
    expect(proposals, isNotEmpty);
    expect(proposals.first.deck.name, contains('General Bright'));
  });

  test('sin masa crítica en la identidad devuelve null, nunca un mazo roto',
      () {
    final pool = <String, Card>{
      'Lonely Legend': const Card(
        name: 'Lonely Legend',
        qty: 1,
        manaCost: '{G}',
        cmc: 1,
        colors: 'G',
        colorIdentity: 'G',
        types: ['Legendary', 'Creature'],
        oracle: '',
        power: 1,
        toughness: 1,
      ),
      'Forest': const Card(
        name: 'Forest',
        qty: 40,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: ['Basic', 'Land'],
        oracle: '',
      ),
    };
    expect(generateCommanderDeck(pool, 'Lonely Legend'), isNull);
  });
}
