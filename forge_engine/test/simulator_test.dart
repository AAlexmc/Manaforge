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
}
