import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

void main() {
  test('los temas que sabe detectar el motor están todos nombrados', () {
    // el TEXTO de cada tema vive en la app (se lee en diez idiomas); aquí solo
    // se comprueba que la lista no se queda coja ni repite
    expect(kThemes, contains('lifegain'));
    expect(kThemes, contains('goodstuff'));
    expect(kThemes.toSet().length, kThemes.length);
  });

  test('whyItWorksFacts cuenta los números reales del mazo', () {
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
    final f = whyItWorksFacts(gen, pool);
    expect(f.lands, 24);
    expect(f.avgCmc.toStringAsFixed(2), '2.50');
    expect(f.creatures, 4);
    expect(f.interaction, 4);
  });
}
