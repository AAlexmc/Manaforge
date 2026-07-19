import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests del Modo Test: el simulador es una heurística, pero debe ser
/// determinista y dar resultados con sentido direccional.
void main() {
  Card creature(String name, int cmc, int p, int t, {int qty = 4}) => Card(
      name: name,
      qty: qty,
      manaCost: '{$cmc}',
      cmc: cmc,
      colors: 'R',
      types: const ['Creature'],
      oracle: '',
      power: p,
      toughness: t);

  Card land(String name, {int qty = 24}) => Card(
      name: name,
      qty: qty,
      manaCost: '',
      cmc: 0,
      colors: '',
      types: const ['Basic', 'Land'],
      oracle: '');

  // mazo agresivo: bichos baratos y eficientes
  final aggroPool = {
    'Raider': creature('Raider', 1, 2, 1),
    'Brawler': creature('Brawler', 2, 3, 2),
    'Crusher': creature('Crusher', 3, 4, 3),
    'Mountain': land('Mountain'),
  };
  final aggro = Deck(
    name: 'Aggro',
    colors: 'R',
    archetype: Archetype.aggro,
    cards: const {'Raider': 4, 'Brawler': 4, 'Crusher': 4},
    lands: const {'Mountain': 21},
  );

  // mazo pasivo: caro y sin apenas presión
  final durdlePool = {
    'Slug': creature('Slug', 6, 1, 1),
    'Mountain': land('Mountain'),
  };
  final durdle = Deck(
    name: 'Durdle',
    colors: 'R',
    archetype: Archetype.midrange,
    cards: const {'Slug': 4},
    lands: const {'Mountain': 24},
  );

  test('determinista: misma semilla, mismo resultado', () {
    final r1 = simulateMatch(aggro, aggroPool, durdle, durdlePool,
        games: 60, seed: 3);
    final r2 = simulateMatch(aggro, aggroPool, durdle, durdlePool,
        games: 60, seed: 3);
    expect(r1, r2);
  });

  test('el aggro machaca al mazo pasivo', () {
    final rate = simulateMatch(aggro, aggroPool, durdle, durdlePool,
        games: 100, seed: 5);
    expect(rate, greaterThan(0.7));
  });

  test('el espejo queda equilibrado', () {
    final rate = simulateMatch(aggro, aggroPool, aggro, aggroPool,
        games: 200, seed: 9);
    expect(rate, inInclusiveRange(0.3, 0.7));
  });

  test('los colores importan: sin tierras azules no se lanzan hechizos UU',
      () {
    // mismo cuerpo, pero coste {U}{U} con solo Montañas: incastable
    final uuPool = {
      'Wrong Colors': const Card(
          name: 'Wrong Colors',
          qty: 4,
          manaCost: '{U}{U}',
          cmc: 2,
          colors: 'U',
          types: ['Creature'],
          oracle: '',
          power: 3,
          toughness: 2),
      'Mountain': land('Mountain'),
    };
    final uuDeck = Deck(
      name: 'UU sin islas',
      colors: 'U',
      archetype: Archetype.midrange,
      cards: const {'Wrong Colors': 4},
      lands: const {'Mountain': 20},
    );
    final rate = simulateMatch(aggro, aggroPool, uuDeck, uuPool,
        games: 100, seed: 11);
    expect(rate, greaterThan(0.85)); // el rival nunca puede jugar nada
  });

  test('volar gana al mismo cuerpo sin evasión', () {
    Card flyer(String name) => Card(
        name: name,
        qty: 4,
        manaCost: '{2}',
        cmc: 2,
        colors: 'W',
        types: const ['Creature'],
        oracle: 'Flying',
        power: 2,
        toughness: 2);
    final flyPool = {
      'Pegasus': flyer('Pegasus'),
      'Plains': land('Plains'),
    };
    final flyDeck = Deck(
      name: 'Volar',
      colors: 'W',
      archetype: Archetype.aggro,
      cards: const {'Pegasus': 4},
      lands: const {'Plains': 21},
    );
    final groundPool = {
      'Bear': creature('Bear', 2, 2, 2),
      'Plains': land('Plains'),
    };
    final groundDeck = Deck(
      name: 'Suelo',
      colors: 'R',
      archetype: Archetype.aggro,
      cards: const {'Bear': 4},
      lands: const {'Plains': 21},
    );
    final rate = simulateMatch(flyDeck, flyPool, groundDeck, groundPool,
        games: 200, seed: 13);
    expect(rate, greaterThan(0.5)); // la evasión debe notarse
  });
}
