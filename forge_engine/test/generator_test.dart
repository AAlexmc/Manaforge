import 'dart:convert';
import 'dart:io';

import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests del generador (fase 3) contra la colección real de los fixtures —
/// espejo de `engine-reference/tests/test_generator.py`.
void main() {
  late Map<String, Card> pool;

  setUpAll(() {
    final raw = jsonDecode(
            File('../engine-reference/fixtures/pool.json').readAsStringSync())
        as Map<String, dynamic>;
    pool = raw.map((name, json) =>
        MapEntry(name, Card.fromJson(name, json as Map<String, dynamic>)));
  });

  test('clasifica cartas conocidas', () {
    expect(classify(pool['Murder']!), contains('removal'));
    expect(classify(pool['Counterspell']!), contains('counterspell'));
    expect(classify(pool['Llanowar Elves']!), contains('ramp'));
  });

  test('roles de tema: lifegain', () {
    expect(themeRoles(pool['Marauding Blight-Priest']!)['lifegain'], 'payoff');
    expect(themeRoles(pool["Healer's Hawk"]!)['lifegain'], 'enabler');
  });

  test('todo mazo generado pasa el validador (regla 6)', () {
    final proposals = generateProposals(pool);
    expect(proposals.length, greaterThanOrEqualTo(2),
        reason: 'la colección real da para varias propuestas');
    for (final gen in proposals) {
      expect(DeckValidator.validate(gen.deck, pool), isEmpty,
          reason: gen.deck.name);
    }
  });

  test('en WB el tema natural es lifegain', () {
    final gen = generateDeck(pool, 'WB');
    expect(gen, isNotNull);
    expect(gen!.theme, 'lifegain');
  });

  test('respeta tierras escasas: RG imposible => null, nunca defectuoso', () {
    // Solo hay 2 Mountains y 4 Forests en la colección.
    expect(generateDeck(pool, 'RG'), isNull);
  });

  test('las propuestas tienen identidades distintas', () {
    final proposals = generateProposals(pool);
    final colors = proposals.map((g) => g.deck.colors).toSet();
    expect(colors.length, proposals.length);
  });

  test('un pool de respuestas sin criaturas se lee como control', () {
    final cands = {
      for (var i = 0; i < 10; i++)
        'Removal $i': Card(
            name: 'Removal $i',
            qty: 4,
            manaCost: '{2}{B}',
            cmc: 3,
            colors: 'B',
            types: const ['Instant'],
            oracle: 'Destroy target creature.'),
      for (var i = 0; i < 12; i++)
        'Filler $i': Card(
            name: 'Filler $i',
            qty: 4,
            manaCost: '{3}{B}',
            cmc: 4,
            colors: 'B',
            types: const ['Sorcery'],
            oracle: 'Each player discards a card.'),
    };
    expect(pickArchetype(cands), 'control');
  });

  test('archetypeFor encuentra perfil para combos sanos y rechaza locuras', () {
    expect(archetypeFor(2.9, 24), isNotNull);
    expect(archetypeFor(1.2, 27), isNull); // curva agresiva con 27 tierras
  });

  test('reforgeWithCurve respeta la curva pedida y las reglas duras', () {
    final base = generateDeck(pool, 'WB');
    expect(base, isNotNull);
    final hist =
        ManaCurve.curveHistogram(base!.deck.cards, pool, cap: 6);
    final result = reforgeWithCurve(pool, 'WB', hist);
    expect(result.deck, isNotNull, reason: result.reason ?? '');
    final deck = result.deck!.deck;
    expect(DeckValidator.validate(deck, pool), isEmpty);
    expect(deck.totalCards, ManaCurve.deckSize);
  });

  test('reforgeWithCurve avisa cuando la curva no da mazo sano', () {
    // 45 hechizos => solo 15 tierras: fuera de todo rango.
    final result = reforgeWithCurve(pool, 'WB', {1: 20, 2: 15, 3: 10});
    expect(result.deck, isNull);
    expect(result.reason, isNotEmpty);
  });

  group('detectTheme: color pie desempata (Task 8)', () {
    Map<String, Card> tiedPool() => {
          for (var i = 0; i < 3; i++)
            'Lifegain Payoff $i': Card(
                name: 'Lifegain Payoff $i',
                qty: 1,
                manaCost: '{2}{W}',
                cmc: 3,
                colors: 'W',
                types: const ['Creature'],
                oracle: 'Whenever you gain life, draw a card.'),
          for (var i = 0; i < 3; i++)
            'Spells Payoff $i': Card(
                name: 'Spells Payoff $i',
                qty: 1,
                manaCost: '{1}{U}',
                cmc: 2,
                colors: 'U',
                types: const ['Creature'],
                oracle: 'Whenever you cast an instant or sorcery spell, '
                    'draw a card.'),
        };

    test('empate lifegain/spells: en WB gana lifegain (su color pie)', () {
      final (theme, _) = detectTheme(tiedPool(), colors: 'WB');
      expect(theme, 'lifegain');
    });

    test('empate lifegain/spells: en UR gana spells (su color pie)', () {
      final (theme, _) = detectTheme(tiedPool(), colors: 'UR');
      expect(theme, 'spells');
    });

    test('sin colores, el peso crudo decide (sin multiplicador)', () {
      final (theme, _) = detectTheme(tiedPool());
      // pesos crudos empatados (9 y 9): gana el primero en iterar el mapa
      // (lifegain, declarado antes que spells en _themes) — determinista,
      // y el espejo Python da lo mismo.
      expect(theme, 'lifegain');
    });
  });

  group('efficiency: pesos de combate (Task 7)', () {
    Card creature(String name, String oracle,
            {int power = 2, int toughness = 2, int cmc = 2}) =>
        Card(
            name: name,
            qty: 1,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: '',
            types: const ['Creature'],
            oracle: oracle,
            power: power,
            toughness: toughness);

    test('volador vale más que arrollador pequeño a igualdad de stats', () {
      final flier = creature('Flier', 'Flying');
      final trampler = creature('Trampler', 'Trample');
      expect(efficiency(flier), greaterThan(efficiency(trampler)));
    });

    test('arrollar escala con el poder', () {
      final bigTrampler =
          creature('Big Trampler', 'Trample', power: 6, toughness: 6, cmc: 6);
      final bigReacher =
          creature('Big Reacher', 'Reach', power: 6, toughness: 6, cmc: 6);
      expect(efficiency(bigTrampler), greaterThan(efficiency(bigReacher)));
    });

    test('prisa vale más en aggro', () {
      final hasty = creature('Hasty', 'Haste');
      expect(efficiency(hasty, archetype: 'aggro'),
          greaterThan(efficiency(hasty)));
    });

    test('tope +2.0: keyword soup no rompe la escala', () {
      final kitchenSink = creature(
          'Kitchen Sink',
          'Flying, double strike, menace, haste, deathtouch, lifelink, '
          'first strike, vigilance, reach, trample',
          power: 6,
          toughness: 6,
          cmc: 6);
      expect(efficiency(kitchenSink), lessThanOrEqualTo(10));
    });

    test('sin columna keywords cae al oracle (double strike cuenta como '
        'first strike no)', () {
      final ds = creature('Double Strike Guy', 'Double strike', cmc: 3);
      final plain =
          creature('Plain Guy', 'Vanilla creature with no abilities.', cmc: 3);
      // Solo pesa double strike (0.9): si first strike también contara por
      // el fallback, la diferencia sería 0.9+0.5.
      expect(
          efficiency(ds) - efficiency(plain), closeTo(0.9, 1e-9));
    });
  });
}
