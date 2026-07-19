import 'dart:math';

import 'classify.dart';
import 'deck_validator.dart';
import 'generator.dart';
import 'models.dart';

/// Modo Test: simulador de enfrentamientos y optimizador contra un mazo
/// objetivo (p. ej. un mazo del meta).
///
/// HONESTIDAD ANTE TODO: las partidas son MUY simplificadas (maná sin
/// colores, combate por fuerza/resistencia, contramagia tratada como
/// respuesta a la mayor amenaza, sin habilidades). El % de victoria es una
/// ESTIMACIÓN comparativa entre mazos, no una predicción real. Determinista
/// con semilla para poder testearlo.

/// Carta precocinada para simular rápido.
class _SimCard {
  final String name;
  final int cmc;
  final bool isLand;
  final bool isCreature;
  final int power;
  final int toughness;
  final bool isRemoval; // removal puntual, counterspell o burn a criatura
  final bool isSweeper;
  final int burnFace; // daño directo posible a cara (0 = no es burn)
  final int draws; // roba N cartas
  final bool isRamp; // acelera: cuenta como tierra extra

  const _SimCard({
    required this.name,
    required this.cmc,
    required this.isLand,
    required this.isCreature,
    required this.power,
    required this.toughness,
    required this.isRemoval,
    required this.isSweeper,
    required this.burnFace,
    required this.draws,
    required this.isRamp,
  });

  static final _dmg = RegExp(r'deals? (\d+) damage');

  factory _SimCard.fromCard(Card c) {
    final tags = classify(c);
    final oracle = c.oracle.toLowerCase();
    var burn = 0;
    if (tags.contains('burn')) {
      final m = _dmg.firstMatch(oracle);
      burn = m == null ? 2 : int.parse(m.group(1)!);
    }
    final targetsFace = oracle.contains('any target') ||
        oracle.contains('target player') ||
        oracle.contains('each opponent');
    return _SimCard(
      name: c.name,
      cmc: c.cmc,
      isLand: c.isLand,
      isCreature: c.isCreature,
      power: c.power ?? 0,
      toughness: c.toughness ?? 0,
      isRemoval: tags.contains('removal') ||
          tags.contains('counterspell') ||
          (burn > 0 && !targetsFace),
      isSweeper: tags.contains('sweeper'),
      burnFace: targetsFace ? burn : 0,
      draws: tags.contains('draw') ? 1 : 0,
      isRamp: tags.contains('ramp') && !c.isCreature,
    );
  }
}

class _Permanent {
  final int power;
  final int toughness;
  bool sick; // mareo de invocación

  _Permanent(this.power, this.toughness, {this.sick = true});
}

class _Player {
  final List<_SimCard> library;
  final List<_SimCard> hand = [];
  final List<_Permanent> board = [];
  int lands = 0;
  int life = 20;

  _Player(this.library);

  void draw([int n = 1]) {
    for (var i = 0; i < n && library.isNotEmpty; i++) {
      hand.add(library.removeLast());
    }
  }
}

List<_SimCard> _expand(Deck deck, Map<String, Card> pool) {
  final out = <_SimCard>[];
  void addAll(Map<String, int> cards) {
    cards.forEach((name, qty) {
      final card = pool[name];
      if (card == null) return; // carta desconocida: fuera de la simulación
      final sim = _SimCard.fromCard(card);
      for (var i = 0; i < qty; i++) {
        out.add(sim);
      }
    });
  }

  addAll(deck.cards);
  addAll(deck.lands);
  return out;
}

/// Juega un turno del jugador [me] contra [foe].
void _takeTurn(_Player me, _Player foe, {required bool skipDraw}) {
  if (!skipDraw) me.draw();

  // tierra del turno
  final landIdx = me.hand.indexWhere((c) => c.isLand);
  if (landIdx >= 0) {
    me.hand.removeAt(landIdx);
    me.lands++;
  }

  // fase principal: gastar el maná en lo más útil
  var mana = me.lands;
  var acted = true;
  while (acted && mana > 0) {
    acted = false;
    _SimCard? pick;
    int Function(_SimCard) worth = (c) => 0;

    List<_SimCard> affordable(bool Function(_SimCard) test) =>
        me.hand.where((c) => !c.isLand && c.cmc <= mana && test(c)).toList();

    // 1) barrer si el rival tiene la mesa mucho mejor
    final sweepers = affordable((c) => c.isSweeper);
    if (sweepers.isNotEmpty &&
        foe.board.length >= me.board.length + 2 &&
        foe.board.length >= 3) {
      pick = sweepers.first;
      me.board.clear();
      foe.board.clear();
    }
    // 2) matar la mayor amenaza
    if (pick == null && foe.board.isNotEmpty) {
      final removals = affordable((c) => c.isRemoval);
      final biggest = foe.board.reduce(
          (a, b) => a.power >= b.power ? a : b);
      if (removals.isNotEmpty && biggest.power >= 2) {
        pick = removals.first;
        foe.board.remove(biggest);
      }
    }
    // 3) bajar la mayor criatura pagable
    if (pick == null) {
      final creatures = affordable((c) => c.isCreature);
      if (creatures.isNotEmpty) {
        worth = (c) => c.power + c.toughness;
        creatures.sort((a, b) => worth(b).compareTo(worth(a)));
        pick = creatures.first;
        me.board.add(_Permanent(pick.power, pick.toughness));
      }
    }
    // 4) quemar la cara si acerca la victoria
    if (pick == null) {
      final burns = affordable((c) => c.burnFace > 0);
      if (burns.isNotEmpty) {
        pick = burns.first;
        foe.life -= pick.burnFace;
      }
    }
    // 5) robar cartas / rampa
    if (pick == null) {
      final utils = affordable((c) => c.draws > 0 || c.isRamp);
      if (utils.isNotEmpty) {
        pick = utils.first;
        if (pick.draws > 0) me.draw(pick.draws);
        if (pick.isRamp) me.lands++;
      }
    }

    if (pick != null) {
      me.hand.remove(pick);
      mana -= pick.cmc;
      acted = true;
    }
  }

  // combate: atacan todas las que pueden
  final attackers =
      me.board.where((p) => !p.sick && p.power > 0).toList()
        ..sort((a, b) => b.power.compareTo(a.power));
  if (attackers.isNotEmpty) {
    final blockers = List<_Permanent>.from(foe.board)
      ..sort((a, b) => b.toughness.compareTo(a.toughness));
    final blocked = <_Permanent, _Permanent>{}; // atacante -> bloqueador
    for (final blocker in blockers) {
      _Permanent? target;
      for (final a in attackers) {
        if (blocked.containsKey(a)) continue;
        final kills = blocker.power >= a.toughness;
        final survives = blocker.toughness > a.power;
        final favorable = kills && survives;
        final trade = kills && !survives;
        if (favorable || (trade && foe.life <= 12)) {
          target = a;
          break;
        }
      }
      if (target != null) blocked[target] = blocker;
    }
    for (final a in attackers) {
      final blocker = blocked[a];
      if (blocker == null) {
        foe.life -= a.power;
      } else {
        if (blocker.power >= a.toughness) me.board.remove(a);
        if (a.power >= blocker.toughness) foe.board.remove(blocker);
      }
    }
  }

  // fin de turno: se quita el mareo
  for (final p in me.board) {
    p.sick = false;
  }
}

/// Juega UNA partida. Devuelve 1 si gana A, 0 si gana B, 0.5 si se atasca.
double _playGame(
    List<_SimCard> deckA, List<_SimCard> deckB, Random rng, bool aFirst) {
  final a = _Player(List.of(deckA)..shuffle(rng));
  final b = _Player(List.of(deckB)..shuffle(rng));
  a.draw(7);
  b.draw(7);
  final order = aFirst ? [a, b] : [b, a];
  for (var turn = 0; turn < 30; turn++) {
    for (var i = 0; i < 2; i++) {
      final me = order[i];
      final foe = order[i == 0 ? 1 : 0];
      _takeTurn(me, foe, skipDraw: turn == 0 && i == 0);
      if (a.life <= 0 && b.life <= 0) return 0.5;
      if (b.life <= 0) return 1.0;
      if (a.life <= 0) return 0.0;
    }
  }
  if (a.life == b.life) return 0.5;
  return a.life > b.life ? 1.0 : 0.0;
}

/// % de victoria estimado del mazo A contra el B (0..1). Determinista con
/// [seed]; alterna quién empieza.
double simulateMatch(
  Deck deckA,
  Map<String, Card> poolA,
  Deck deckB,
  Map<String, Card> poolB, {
  int games = 200,
  int seed = 7,
}) {
  final simA = _expand(deckA, poolA);
  final simB = _expand(deckB, poolB);
  if (simA.isEmpty || simB.isEmpty) return 0.5;
  final rng = Random(seed);
  var wins = 0.0;
  for (var g = 0; g < games; g++) {
    wins += _playGame(simA, simB, rng, g.isEven);
  }
  return wins / games;
}

/// Resultado del Modo Test.
class OptimizeResult {
  final GeneratedDeck deck;
  final double winRate; // 0..1 contra el mazo objetivo
  final int gamesPerEval;
  final int decksTried;

  const OptimizeResult({
    required this.deck,
    required this.winRate,
    required this.gamesPerEval,
    required this.decksTried,
  });
}

/// Busca en la colección el mazo con mayor % de victoria contra [meta]:
/// evalúa las propuestas de Forge y luego afina con cambios de carta
/// (hill-climbing) que solo se quedan si mejoran el % simulado.
OptimizeResult? optimizeAgainst(
  Map<String, Card> pool,
  Deck meta,
  Map<String, Card> metaPool, {
  int games = 160,
  int climbs = 30,
  int seed = 7,
}) {
  final proposals = generateProposals(pool, maxProposals: 10);
  if (proposals.isEmpty) return null;

  final rng = Random(seed);
  var tried = 0;

  double eval(Deck d) {
    tried++;
    return simulateMatch(d, pool, meta, metaPool,
        games: games, seed: seed + tried);
  }

  GeneratedDeck best = proposals.first;
  var bestRate = -1.0;
  for (final gen in proposals) {
    final rate = eval(gen.deck);
    if (rate > bestRate) {
      bestRate = rate;
      best = gen;
    }
  }

  // hill-climbing: prueba cambios de una copia y quédate con lo que gane más
  final candidateNames = pool.values
      .where((c) =>
          !c.isLand &&
          c.colors
              .split('')
              .toSet()
              .difference(best.deck.colors.split('').toSet())
              .isEmpty)
      .map((c) => c.name)
      .toList();

  var current = best.deck;
  for (var i = 0; i < climbs && candidateNames.isNotEmpty; i++) {
    final cards = Map<String, int>.from(current.cards);
    final names = cards.keys.toList();
    final out = names[rng.nextInt(names.length)];
    final inName = candidateNames[rng.nextInt(candidateNames.length)];
    if (inName == out) continue;
    final owned = pool[inName]!.qty;
    final limit = owned < 4 ? owned : 4;
    if ((cards[inName] ?? 0) >= limit) continue;

    cards[out] = cards[out]! - 1;
    if (cards[out] == 0) cards.remove(out);
    cards[inName] = (cards[inName] ?? 0) + 1;

    final candidate = Deck(
      name: current.name,
      colors: current.colors,
      archetype: current.archetype,
      cards: cards,
      lands: current.lands,
    );
    if (DeckValidator.validate(candidate, pool).isNotEmpty) continue;

    final rate = eval(candidate);
    if (rate > bestRate) {
      bestRate = rate;
      current = candidate;
    }
  }

  return OptimizeResult(
    deck: GeneratedDeck(current, best.theme, best.score),
    winRate: bestRate,
    gamesPerEval: games,
    decksTried: tried,
  );
}
