import 'dart:convert';
import 'dart:io';

import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests de la forja profunda (Task 13): reordenar propuestas por cómo
/// rinden entre sí de verdad, no solo por su score estático.
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

  final pool = {
    'Raider': creature('Raider', 1, 2, 1),
    'Brawler': creature('Brawler', 2, 3, 2),
    'Crusher': creature('Crusher', 3, 4, 3),
    'Slug': creature('Slug', 6, 1, 1),
    'Mountain': land('Mountain'),
  };

  Deck deck(String name, Map<String, int> cards, Map<String, int> lands) =>
      Deck(
          name: name,
          colors: 'R',
          archetype: Archetype.midrange,
          cards: cards,
          lands: lands);

  test('el mazo que gana el round-robin sube al puesto 1', () {
    // dos "durdles" con score estático inflado a mano (pierden goleados en
    // la sim) y un aggro real con score bajo a mano que los machaca.
    final durdleA =
        deck('Durdle A', const {'Slug': 4}, const {'Mountain': 24});
    final durdleB =
        deck('Durdle B', const {'Slug': 4}, const {'Mountain': 23});
    final aggro = deck('Aggro real',
        const {'Raider': 4, 'Brawler': 4, 'Crusher': 4}, const {'Mountain': 21});

    final proposals = [
      GeneratedDeck(durdleA, 'goodstuff', 6.0),
      GeneratedDeck(durdleB, 'goodstuff', 5.5),
      GeneratedDeck(aggro, 'goodstuff', 1.0),
    ];

    final ranked =
        rankBySimulation(proposals, pool, games: 60, seed: 7, top: 3);
    expect(ranked.first.deck.name, 'Aggro real');
  });

  test('con top menor que el total, los que sobran quedan detrás sin tocar',
      () {
    final durdleA =
        deck('Durdle A', const {'Slug': 4}, const {'Mountain': 24});
    final aggro = deck('Aggro real',
        const {'Raider': 4, 'Brawler': 4, 'Crusher': 4}, const {'Mountain': 21});
    final sobra = deck('Sobra', const {'Slug': 4}, const {'Mountain': 24});

    final proposals = [
      GeneratedDeck(durdleA, 'goodstuff', 5.0),
      GeneratedDeck(aggro, 'goodstuff', 1.0),
      GeneratedDeck(sobra, 'goodstuff', 0.5),
    ];
    final ranked =
        rankBySimulation(proposals, pool, games: 40, seed: 7, top: 2);
    expect(ranked.length, 3);
    expect(ranked.last.deck.name, 'Sobra'); // no entró al round-robin
  });

  test('determinista: misma semilla, mismo orden', () {
    final durdleA =
        deck('Durdle A', const {'Slug': 4}, const {'Mountain': 24});
    final aggro = deck('Aggro real',
        const {'Raider': 4, 'Brawler': 4, 'Crusher': 4}, const {'Mountain': 21});
    final proposals = [
      GeneratedDeck(durdleA, 'goodstuff', 5.0),
      GeneratedDeck(aggro, 'goodstuff', 1.0),
    ];
    final r1 = rankBySimulation(proposals, pool, games: 40, seed: 7);
    final r2 = rankBySimulation(proposals, pool, games: 40, seed: 7);
    expect(r1.map((g) => g.deck.name).toList(),
        r2.map((g) => g.deck.name).toList());
  });

  test(
      'presupuesto: 6 propuestas x games por defecto (400, M5) da un '
      'presupuesto de verdad, no 15s sobre algo que tarda <1s (M2)', () {
    final raw = jsonDecode(File('../engine-reference/fixtures/pool.json')
            .readAsStringSync()) as Map<String, dynamic>;
    final realPool = raw.map((name, json) =>
        MapEntry(name, Card.fromJson(name, json as Map<String, dynamic>)));
    // generateProposals (~1,5s con la colección real) queda FUERA del
    // Stopwatch a propósito: lo lento de la suite es el generador, no el
    // round-robin — este test presupuesta solo rankBySimulation.
    final proposals = generateProposals(realPool, maxProposals: 6);
    final sw = Stopwatch()..start();
    rankBySimulation(proposals, realPool);
    // Medido: ~0,96s en local con games:400 (default post-M5); el runner
    // de GitHub Actions superó los 2000ms del primer umbral (CI run #453).
    // Margen ~5x sobre lo medido en local para cubrir runners lentos, pero
    // MUY por debajo de los 15s previos (que no presupuestaban nada real).
    expect(sw.elapsed.inMilliseconds, lessThan(5000));
  });
}
