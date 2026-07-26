import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests de `deck_score.dart` (Task 9) — espejo de
/// `engine-reference/tests/test_deck_score.py`.
void main() {
  Card spell(String name, String manaCost, int cmc, String colors) => Card(
      name: name,
      qty: 20,
      manaCost: manaCost,
      cmc: cmc,
      colors: colors,
      types: const ['Creature'],
      oracle: '',
      power: cmc,
      toughness: cmc);

  test('mismo mazo con manabase coja puntúa menos', () {
    final pool = {
      'W Card': spell('W Card', '{W}{W}', 2, 'W'),
      'U Card': spell('U Card', '{U}{U}', 2, 'U'),
    };
    final deck = Deck(
      name: 't',
      colors: 'WU',
      archetype: Archetype.midrange,
      cards: {'W Card': 18, 'U Card': 18},
      lands: {'Plains': 12, 'Island': 12},
    );
    final bien = evaluateDeck(deck, pool, {'W': 14, 'U': 13});
    final mal = evaluateDeck(deck, pool, {'W': 14, 'U': 6});
    expect(mal.total, lessThan(bien.total));
  });

  test('curva imposible (todo cmc 6) hunde el componente curve', () {
    final poolAll6 = {
      for (var i = 0; i < 6; i++)
        'Six $i': spell('Six $i', '{5}{W}', 6, 'W'),
    };
    final deckAll6 = Deck(
      name: 'seises',
      colors: 'W',
      archetype: Archetype.control,
      cards: {for (var i = 0; i < 6; i++) 'Six $i': 6},
      lands: {'Plains': 26},
    );

    final poolSano = {
      'One': spell('One', '{W}', 1, 'W'),
      'Two': spell('Two', '{1}{W}', 2, 'W'),
      'Three': spell('Three', '{2}{W}', 3, 'W'),
      'Four': spell('Four', '{3}{W}', 4, 'W'),
    };
    final deckSano = Deck(
      name: 'sano',
      colors: 'W',
      archetype: Archetype.midrange,
      cards: {'One': 9, 'Two': 9, 'Three': 9, 'Four': 9},
      lands: {'Plains': 24},
    );

    final evalTodoSeises = evaluateDeck(deckAll6, poolAll6, {'W': 26});
    final evalCurvaSana = evaluateDeck(deckSano, poolSano, {'W': 24});
    expect(evalTodoSeises.curve, lessThan(evalCurvaSana.curve));
  });

  test('el ranking de propuestas usa total, no solo media', () {
    // "Bonito-inconsistente": gordas por encima de curva (efficiency alta)
    // pero todo cmc 6 y sin ninguna fuente de su color (consistency y curve
    // hundidas).
    final poolFlashy = {
      'Bomb': Card(
          name: 'Bomb',
          qty: 20,
          manaCost: '{4}{U}{U}',
          cmc: 6,
          colors: 'U',
          types: const ['Creature'],
          oracle: '',
          power: 7,
          toughness: 7),
    };
    final deckFlashy = Deck(
      name: 'flashy',
      colors: 'U',
      archetype: Archetype.control,
      cards: {'Bomb': 20},
      lands: {'Island': 26},
    );
    final evalFlashy = evaluateDeck(deckFlashy, poolFlashy, {'U': 0});

    // "Modesto-consistente": criaturas en curva 1-4, stats normales, fuentes
    // de sobra.
    final poolModest = {
      'One': spell('One', '{W}', 1, 'W'),
      'Two': spell('Two', '{1}{W}', 2, 'W'),
      'Three': spell('Three', '{2}{W}', 3, 'W'),
      'Four': spell('Four', '{3}{W}', 4, 'W'),
    };
    final deckModest = Deck(
      name: 'modest',
      colors: 'W',
      archetype: Archetype.midrange,
      cards: {'One': 5, 'Two': 5, 'Three': 5, 'Four': 5},
      lands: {'Plains': 24},
    );
    final evalModest = evaluateDeck(deckModest, poolModest, {'W': 24});

    // Por eficiencia sola ganaba el flashy...
    expect(evalFlashy.efficiency, greaterThan(evalModest.efficiency));

    // ...pero el ranking (mismo comparador que generateProposals) usa el
    // total, y el total lo hunde por su consistencia rota.
    final flashy = GeneratedDeck(deckFlashy, 'goodstuff', evalFlashy.total,
        null, evalFlashy);
    final modest = GeneratedDeck(deckModest, 'goodstuff', evalModest.total,
        null, evalModest);
    final proposals = [flashy, modest]
      ..sort((a, b) => b.score.compareTo(a.score));
    expect(proposals.first, same(modest));
  });
}
