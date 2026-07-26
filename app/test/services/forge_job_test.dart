/// `runForgeJob` es la función de nivel superior que corre en el isolate:
/// se puede testear sin isolate, llamándola directamente.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/services/forge_job.dart';

void main() {
  fe.Card land(String name, {int qty = 24}) => fe.Card(
      name: name,
      qty: qty,
      manaCost: '',
      cmc: 0,
      colors: '',
      types: const ['Basic', 'Land'],
      oracle: '');

  // >= 30 copias por color Y >= 2 identidades reales (R y G): con solo
  // Raider/Brawler/Crusher (12 copias) `generateDeck` corta en
  // totalCopies<30 y las propuestas salen vacías — los tests de abajo
  // comparaban [] con [], sin probar nada.
  fe.Card colorCreature(String name, int cmc, String colors) => fe.Card(
      name: name,
      qty: 4,
      manaCost: '{$cmc}',
      cmc: cmc,
      colors: colors,
      types: const ['Creature'],
      oracle: '',
      power: cmc,
      toughness: cmc);

  Map<String, fe.Card> richPool() {
    final p = <String, fe.Card>{
      'Mountain': land('Mountain', qty: 40),
      'Forest': land('Forest', qty: 40),
    };
    const curve = [1, 1, 2, 2, 2, 3, 3, 4, 4, 5];
    for (var i = 0; i < curve.length; i++) {
      p['R Beast $i'] = colorCreature('R Beast $i', curve[i], 'R');
      p['G Beast $i'] = colorCreature('G Beast $i', curve[i], 'G');
    }
    return p;
  }

  final pool = richPool();

  test('con deepForge=false el orden estático se conserva', () {
    final sinDeep = runForgeJob(ForgeJob(pool: pool, deepForge: false));
    final proposals = fe.generateProposals(pool);
    // con la fixture pobre de antes esto comparaba [] con []: aquí hacen
    // falta propuestas de verdad (>=2 identidades) para que compare algo.
    expect(proposals.length, greaterThanOrEqualTo(2));
    // GeneratedDeck no define `==` (identidad de objeto): comparar por
    // nombre de mazo, no por la lista de objetos completa.
    expect(sinDeep.map((g) => g.deck.name).toList(),
        proposals.map((g) => g.deck.name).toList());
  });

  test('con deepForge=true, runForgeJob no revienta y devuelve las mismas '
      'propuestas (quizá reordenadas)', () {
    final conDeep = runForgeJob(ForgeJob(pool: pool, deepForge: true));
    final proposals = fe.generateProposals(pool);
    expect(conDeep.length, proposals.length);
    expect(conDeep.length, greaterThanOrEqualTo(2));
    expect(conDeep.map((g) => g.deck.name).toSet(),
        proposals.map((g) => g.deck.name).toSet());
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
    final proposals = runForgeJob(ForgeJob(pool: pool, deepForge: false));
    final expected = fe.generateProposals(pool);
    expect(proposals.length, greaterThanOrEqualTo(2));
    // GeneratedDeck no define `==`: comparar por nombre, no por objeto.
    expect(proposals.map((g) => g.deck.name).toList(),
        expected.map((g) => g.deck.name).toList());
  });
}
