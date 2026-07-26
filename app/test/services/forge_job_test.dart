/// `runForgeJob` es la función de nivel superior que corre en el isolate:
/// se puede testear sin isolate, llamándola directamente.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/services/forge_job.dart';

void main() {
  fe.Card creature(String name, int cmc, int p, int t, {int qty = 4}) =>
      fe.Card(
          name: name,
          qty: qty,
          manaCost: '{$cmc}',
          cmc: cmc,
          colors: 'R',
          types: const ['Creature'],
          oracle: '',
          power: p,
          toughness: t);

  fe.Card land(String name, {int qty = 24}) => fe.Card(
      name: name,
      qty: qty,
      manaCost: '',
      cmc: 0,
      colors: '',
      types: const ['Basic', 'Land'],
      oracle: '');

  final pool = {
    'Raider': creature('Raider', 1, 2, 1),
    'Brawler': creature('Brawler', 2, 3, 2),
    'Crusher': creature('Crusher', 3, 4, 3),
    'Mountain': land('Mountain', qty: 40),
  };

  test('con deepForge=false el orden estático se conserva', () {
    final sinDeep = runForgeJob(ForgeJob(pool: pool));
    final proposals = fe.generateProposals(pool);
    expect(sinDeep.map((g) => g.deck.colors).toList(),
        proposals.map((g) => g.deck.colors).toList());
  });

  test('con deepForge=true, runForgeJob no revienta y devuelve las mismas '
      'propuestas (quizá reordenadas)', () {
    final conDeep = runForgeJob(ForgeJob(pool: pool, deepForge: true));
    final proposals = fe.generateProposals(pool);
    expect(conDeep.length, proposals.length);
    expect(conDeep.map((g) => g.deck.colors).toSet(),
        proposals.map((g) => g.deck.colors).toSet());
  });

  test('deepForge por defecto es true (el switch de la UI arranca ON)', () {
    expect(const ForgeJob(pool: {}).deepForge, isTrue);
  });

  test('theme viaja al motor: fuerza el estilo en las propuestas', () {
    final elfPool = <String, fe.Card>{
      'Forest': land('Forest', qty: 40),
      for (var i = 0; i < 4; i++)
        'Elf $i': fe.Card(
            name: 'Elf $i',
            qty: 4,
            manaCost: '{G}',
            cmc: 1,
            colors: 'G',
            types: const ['Creature'],
            subtypes: const ['Elf'],
            oracle: i == 0 ? 'Other Elves you control get +1/+1.' : '',
            power: 1,
            toughness: 1),
      for (var i = 0; i < 8; i++)
        'Filler $i': fe.Card(
            name: 'Filler $i',
            qty: 4,
            manaCost: '{${1 + i % 4}}',
            cmc: 1 + i % 4,
            colors: 'G',
            types: const ['Creature'],
            oracle: '',
            power: 1 + i % 4,
            toughness: 1 + i % 4),
    };
    final proposals = runForgeJob(ForgeJob(
        pool: elfPool,
        allowedColors: 'G',
        theme: 'tribal:Elf',
        deepForge: false));
    expect(proposals, isNotEmpty);
    for (final gen in proposals) {
      expect(gen.theme, 'tribal:Elf');
    }
  });

  test('theme null deja decidir al motor (comportamiento de siempre)', () {
    final proposals =
        runForgeJob(ForgeJob(pool: pool, deepForge: false));
    expect(proposals, fe.generateProposals(pool));
  });
}
