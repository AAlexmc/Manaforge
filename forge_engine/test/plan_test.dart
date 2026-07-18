import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

void main() {
  test('los textos de plan cubren todos los arquetipos y temas', () {
    for (final archetype in Archetype.values) {
      final gen = GeneratedDeck(
          Deck(
              name: 'T',
              colors: 'W',
              archetype: archetype,
              cards: const {},
              lands: const {}),
          'lifegain',
          5.0);
      expect(tagline(gen), isNotEmpty);
      expect(gamePlan(gen).length, 3);
    }
    expect(themeName('lifegain'), 'drenaje de vida');
    expect(themeName('desconocido'), 'desconocido');
  });

  test('whyItWorks incluye los números reales del mazo', () {
    final pool = {
      'A': const Card(
          name: 'A', qty: 4, manaCost: '{1}{W}', cmc: 2, colors: 'W',
          types: ['Creature'], oracle: 'Flying'),
      'B': const Card(
          name: 'B', qty: 4, manaCost: '{2}{W}', cmc: 3, colors: 'W',
          types: ['Instant'], oracle: 'Destroy target creature.'),
    };
    final gen = GeneratedDeck(
        Deck(
            name: 'T',
            colors: 'W',
            archetype: Archetype.midrange,
            cards: const {'A': 4, 'B': 4},
            lands: const {'Plains': 24}),
        'goodstuff',
        5.0);
    final text = whyItWorks(gen, pool);
    expect(text, contains('24'));       // tierras
    expect(text, contains('2.50'));     // coste medio
    expect(text, contains('4 criaturas'));
    expect(text, contains('4 cartas'));
  });
}
