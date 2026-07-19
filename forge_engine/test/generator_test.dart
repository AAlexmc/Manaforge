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
}
