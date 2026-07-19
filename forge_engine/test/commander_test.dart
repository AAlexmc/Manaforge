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
    pool['Plains'] = const Card(
      name: 'Plains',
      qty: 40,
      manaCost: '',
      cmc: 0,
      colors: '',
      colorIdentity: '',
      types: ['Basic', 'Land'],
      oracle: '',
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
