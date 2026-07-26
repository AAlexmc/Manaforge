import 'dart:math';

import 'classify.dart';
import 'deck_score.dart';
import 'deck_validator.dart';
import 'generator.dart';
import 'lands.dart';
import 'mana_curve.dart';
import 'models.dart';

/// Modo Test: simulador de enfrentamientos y optimizador contra un mazo
/// objetivo (p. ej. un mazo del meta).
///
/// v2 — más fiel que la v1: colores de maná reales (las tierras producen
/// colores y los costes coloreados se comprueban), mulligan sencillo,
/// evasión y combate con keywords (volar, alcance, arrollar, toque mortal,
/// vínculo vital, iniciativa, prisa, amenaza), removal instantáneo en el
/// turno del rival y contramagia de verdad (contrarresta la amenaza gorda).
///
/// v3 — cementerio real: lo que muere (combate, removal, sweeper) o se
/// descarta (loot) va a la tumba; `mill N` la llena directamente; una gorda
/// (cmc>=5) reanimable de la tumba se juega si hay hechizo de reanimación
/// pagable. Tierras: `LandProfile` (fase 1) da colores/tapped reales — una
/// tierra `entersTapped` no cuenta para maná hasta el turno siguiente.
///
/// Solo-Dart, sin espejo Python (igual que el resto de este archivo — ver
/// cabecera de `generator.dart`): es Modo Test de la app de escritorio, no
/// parte del motor de generación que sí debe coincidir 1:1 con la referencia.
///
/// Sigue siendo una SIMULACIÓN simplificada: sin habilidades activadas ni
/// texto de reglas completo. El % es comparativo, no una predicción exacta.
/// Determinista con semilla para poder testearlo.

class _SimCard {
  final String name;
  final int cmc;
  final String manaCost;
  final bool isLand;
  final bool isCreature;
  final bool isInstant;
  final int power;
  final int toughness;
  final bool isRemoval; // destruye/exilia la mayor amenaza
  final bool isCounter; // contramagia
  final bool isSweeper;
  final int burn; // daño del hechizo (regex "deals N damage")
  final bool burnAnyTarget; // puede ir a la cara
  final int draws;
  final bool isRamp;
  // keywords de combate
  final bool flying;
  final bool reach;
  final bool trample;
  final bool deathtouch;
  final bool lifelink;
  final bool firstStrike;
  final bool haste;
  final bool menace;
  final Set<String> produces; // colores que da esta tierra (de LandProfile)
  final bool entersTapped; // LandProfile.tapped == always (conditional cuenta untapped)
  final int millSelf; // "mill N cards" propio
  final bool loot; // roba y descarta
  final bool reanimates; // return ... creature ... graveyard -> battlefield

  const _SimCard({
    required this.name,
    required this.cmc,
    required this.manaCost,
    required this.isLand,
    required this.isCreature,
    required this.isInstant,
    required this.power,
    required this.toughness,
    required this.isRemoval,
    required this.isCounter,
    required this.isSweeper,
    required this.burn,
    required this.burnAnyTarget,
    required this.draws,
    required this.isRamp,
    required this.flying,
    required this.reach,
    required this.trample,
    required this.deathtouch,
    required this.lifelink,
    required this.firstStrike,
    required this.haste,
    required this.menace,
    required this.produces,
    required this.entersTapped,
    required this.millSelf,
    required this.loot,
    required this.reanimates,
  });

  static final _dmg = RegExp(r'deals? (\d+) damage');
  static final _mill = RegExp(
      r'mills? (a|one|two|three|four|five|six|seven|eight|nine|ten|\d+) cards?');
  static const _millNumberWords = {
    'a': 1,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
  };
  static final _loot = RegExp(r'draws? a card,? then discards? a card');
  static final _reanimate =
      RegExp(r'return .*creature.* from your graveyard to the battlefield');

  /// "mill N cards" PROPIO: el oracle real casi nunca escribe el número en
  /// dígitos ("mills two cards", no "mills 2 cards"), y "target player
  /// mills"/"each opponent mills" no es tu tumba — puede llenar la del
  /// rival. Solo cuenta el mill sin sujeto ajeno en la misma cláusula
  /// (imperativo "Mill N cards." o "you mill N cards", los templates de
  /// autotumba reales tipo Stitcher's Supplier).
  static int _selfMill(String oracle) {
    for (final clause in oracle.split(RegExp(r'[.\n]'))) {
      final m = _mill.firstMatch(clause);
      if (m == null) continue;
      if (clause.contains('target player') ||
          clause.contains('target opponent') ||
          clause.contains('opponent')) {
        continue; // mill ajeno: no es tu cementerio
      }
      final word = m.group(1)!;
      return _millNumberWords[word] ?? int.parse(word);
    }
    return 0;
  }

  factory _SimCard.fromCard(Card c) {
    final tags = classify(c);
    final oracle = c.oracle.toLowerCase();
    var burn = 0;
    if (tags.contains('burn')) {
      final m = _dmg.firstMatch(oracle);
      burn = m == null ? 2 : int.parse(m.group(1)!);
    }
    final anyTarget = oracle.contains('any target') ||
        oracle.contains('target player') ||
        oracle.contains('each opponent');
    var produces = const <String>{};
    var entersTapped = false;
    if (c.isLand) {
      final profile = LandProfile.fromCard(c);
      produces = profile.produces;
      entersTapped = profile.tapped == TappedKind.always;
    }
    final millSelf = _selfMill(oracle);
    bool kw(String k) => oracle.contains(k);
    return _SimCard(
      name: c.name,
      cmc: c.cmc,
      manaCost: c.manaCost,
      isLand: c.isLand,
      isCreature: c.isCreature,
      isInstant: c.types.contains('Instant'),
      power: c.power ?? 0,
      toughness: c.toughness ?? 0,
      isRemoval:
          tags.contains('removal') || (burn > 0 && !anyTarget),
      isCounter: tags.contains('counterspell'),
      isSweeper: tags.contains('sweeper'),
      burn: burn,
      burnAnyTarget: anyTarget && burn > 0,
      draws: tags.contains('draw') ? 1 : 0,
      isRamp: tags.contains('ramp') && !c.isCreature,
      millSelf: millSelf,
      loot: _loot.hasMatch(oracle),
      reanimates: _reanimate.hasMatch(oracle),
      flying: kw('flying'),
      reach: kw('reach'),
      trample: kw('trample'),
      deathtouch: kw('deathtouch'),
      lifelink: kw('lifelink'),
      firstStrike: kw('first strike') || kw('double strike'),
      haste: kw('haste'),
      menace: kw('menace'),
      produces: produces,
      entersTapped: entersTapped,
    );
  }
}

class _Permanent {
  final _SimCard card;
  bool sick;

  _Permanent(this.card, {required this.sick});

  int get power => card.power;
  int get toughness => card.toughness;
}

/// Una tierra en mesa: los colores que da y si aún no cuenta porque entró
/// tapped este mismo turno.
class _LandInPlay {
  final Set<String> produces;
  bool tappedNew;

  _LandInPlay(this.produces, {this.tappedNew = false});
}

class _Player {
  final List<_SimCard> library;
  final List<_SimCard> hand = [];
  final List<_Permanent> board = [];
  final List<_SimCard> graveyard = [];
  final List<_LandInPlay> lands = [];
  int life;
  bool usedResponse = false; // una respuesta instantánea por turno rival

  _Player(this.library, {this.life = 20});

  void draw([int n = 1]) {
    for (var i = 0; i < n && library.isNotEmpty; i++) {
      hand.add(library.removeLast());
    }
  }

  /// Maná disponible este turno: las tierras que no acaban de entrar tapped.
  int get availableMana => lands.where((l) => !l.tappedNew).length;

  /// ¿Puede pagar este coste con sus tierras (colores incluidos)? Empareja
  /// cada símbolo con la tierra disponible que produce MENOS colores (guarda
  /// las duales/comodín para lo que de verdad las necesite).
  bool canPay(_SimCard c, int manaLeft) {
    if (c.cmc > manaLeft) return false;
    final syms = ManaCurve.colorSymbols(c.manaCost);
    if (syms.isEmpty) return true;
    final avail = <Set<String>>[
      for (final l in lands)
        if (!l.tappedNew) l.produces
    ]..sort((a, b) => a.length.compareTo(b.length));
    for (final e in syms.entries) {
      for (var k = 0; k < e.value; k++) {
        final i = avail.indexWhere((p) => p.contains(e.key));
        if (i < 0) return false;
        avail.removeAt(i);
      }
    }
    return true;
  }

  /// Mulligan sencillo: si la mano inicial tiene <2 o >5 tierras, roba una
  /// nueva de 7 y descarta la carta más cara (mano de 6).
  void openingHand(Random rng) {
    draw(7);
    final landCount = hand.where((c) => c.isLand).length;
    if (landCount >= 2 && landCount <= 5) return;
    library.addAll(hand);
    hand.clear();
    library.shuffle(rng);
    draw(7);
    if (hand.isNotEmpty) {
      _SimCard worst = hand.first;
      for (final c in hand) {
        if (!c.isLand && c.cmc > worst.cmc) worst = c;
      }
      hand.remove(worst);
      library.insert(0, worst);
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

/// El rival intenta contrarrestar una amenaza gorda (cmc>=3 o bicho gordo).
bool _tryCounter(_Player foe, _SimCard spell) {
  if (foe.usedResponse) return false;
  final big = spell.cmc >= 3 || (spell.isCreature && spell.power >= 4);
  if (!big) return false;
  for (final c in foe.hand) {
    if (c.isCounter && foe.canPay(c, foe.availableMana)) {
      foe.hand.remove(c);
      foe.usedResponse = true;
      return true;
    }
  }
  return false;
}

/// Removal instantáneo del rival al final del turno del jugador activo.
void _foeInstantResponse(_Player me, _Player foe) {
  if (foe.usedResponse || me.board.isEmpty) return;
  final biggest =
      me.board.reduce((a, b) => a.power >= b.power ? a : b);
  if (biggest.power < 3) return;
  for (final c in foe.hand) {
    final canKill = c.isInstant &&
        (c.isRemoval || (c.burn >= biggest.toughness && c.burn > 0));
    if (canKill && foe.canPay(c, foe.availableMana)) {
      foe.hand.remove(c);
      foe.usedResponse = true;
      me.board.remove(biggest);
      me.graveyard.add(biggest.card);
      return;
    }
  }
}

void _takeTurn(_Player me, _Player foe, {required bool skipDraw}) {
  me.usedResponse = false; // sus respuestas se renuevan en mi turno
  // las tierras que entraron tapped el turno pasado ya cuentan hoy
  for (final l in me.lands) {
    l.tappedNew = false;
  }
  if (!skipDraw) me.draw();

  // tierra del turno: la del color más pedido por la mano
  final landsInHand = me.hand.where((c) => c.isLand).toList();
  if (landsInHand.isNotEmpty) {
    final needed = <String, int>{};
    for (final c in me.hand) {
      ManaCurve.colorSymbols(c.manaCost).forEach((color, k) {
        needed[color] = (needed[color] ?? 0) + k;
      });
    }
    int score(_SimCard land) {
      var s = 0;
      for (final color in land.produces) {
        s += needed[color] ?? 0;
      }
      if (land.produces.length > 1) s += 1; // flexibilidad desempata
      return s;
    }

    landsInHand.sort((a, b) => score(b).compareTo(score(a)));
    final land = landsInHand.first;
    me.hand.remove(land);
    me.lands.add(_LandInPlay(land.produces, tappedNew: land.entersTapped));
  }

  // fase principal
  var mana = me.availableMana;
  var acted = true;
  while (acted && mana > 0) {
    acted = false;
    _SimCard? pick;
    var pickRemoved = false;

    List<_SimCard> affordable(bool Function(_SimCard) test) => me.hand
        .where((c) => !c.isLand && c.cmc <= mana && me.canPay(c, mana) && test(c))
        .toList();

    // 1: barrer una mesa rival muy superior
    final sweepers = affordable((c) => c.isSweeper);
    if (sweepers.isNotEmpty &&
        foe.board.length >= me.board.length + 2 &&
        foe.board.length >= 3) {
      pick = sweepers.first;
      if (!_tryCounter(foe, pick)) {
        for (final p in me.board) {
          me.graveyard.add(p.card);
        }
        for (final p in foe.board) {
          foe.graveyard.add(p.card);
        }
        me.board.clear();
        foe.board.clear();
      }
    }
    // 2: matar la mayor amenaza rival
    if (pick == null && foe.board.isNotEmpty) {
      final removals =
          affordable((c) => c.isRemoval || (c.burn > 0 && !c.isCounter));
      if (removals.isNotEmpty) {
        final biggest =
            foe.board.reduce((a, b) => a.power >= b.power ? a : b);
        if (biggest.power >= 2) {
          final usable = removals.where((c) =>
              c.isRemoval || c.burn >= biggest.toughness);
          if (usable.isNotEmpty) {
            pick = usable.first;
            foe.board.remove(biggest);
            foe.graveyard.add(biggest.card);
          }
        }
      }
    }
    // 2.5: reanimar una gorda del cementerio si hay alguna digna
    if (pick == null && me.graveyard.isNotEmpty) {
      final reanimateSpells = affordable((c) => c.reanimates);
      if (reanimateSpells.isNotEmpty) {
        final targets = me.graveyard
            .where((c) => c.isCreature && c.cmc >= 5)
            .toList();
        if (targets.isNotEmpty) {
          targets.sort((a, b) => b.power.compareTo(a.power));
          final target = targets.first;
          pick = reanimateSpells.first;
          if (!_tryCounter(foe, pick)) {
            me.graveyard.remove(target);
            me.board.add(_Permanent(target, sick: !target.haste));
            // el hechizo de reanimación puede ser él mismo una criatura
            // (Karmic Guide / Sun Titan: ETB reanima) — si es así, TAMBIÉN
            // entra en juego. No excluir `reanimates` para criaturas (como
            // sí hace `isRamp`) porque eso las tiraría a la basura: se
            // pagarían y desaparecerían sin dejar cuerpo ni target en mesa.
            if (pick.isCreature) {
              me.board.add(_Permanent(pick, sick: !pick.haste));
            }
          }
        }
      }
    }
    // 3: bajar la mayor criatura pagable
    if (pick == null) {
      final creatures = affordable((c) => c.isCreature);
      if (creatures.isNotEmpty) {
        creatures.sort((a, b) =>
            (b.power + b.toughness).compareTo(a.power + a.toughness));
        pick = creatures.first;
        if (!_tryCounter(foe, pick)) {
          me.board.add(_Permanent(pick, sick: !pick.haste));
        }
      }
    }
    // 4: quemar la cara
    if (pick == null) {
      final burns = affordable((c) => c.burnAnyTarget);
      if (burns.isNotEmpty) {
        pick = burns.first;
        if (!_tryCounter(foe, pick)) foe.life -= pick.burn;
      }
    }
    // 5: robar / rampa / cementerio (loot, mill)
    if (pick == null) {
      final utils = affordable(
          (c) => c.draws > 0 || c.isRamp || c.loot || c.millSelf > 0);
      if (utils.isNotEmpty) {
        pick = utils.first;
        // Fuera de la mano ANTES de resolver el efecto (M4): si no, el loot
        // puede escogerse a sí mismo como "peor carta" a descartar (`_expand`
        // comparte la MISMA instancia entre copias, así que `List.remove` por
        // identidad borraría el propio loot aquí Y otra vez abajo, comiéndose
        // dos cartas por una). `pickRemoved` evita que el remove común de
        // abajo borre una SEGUNDA copia cuando hay 2+ en mano.
        me.hand.remove(pick);
        pickRemoved = true;
        if (pick.draws > 0) me.draw(pick.draws);
        if (pick.isRamp) me.lands.add(_LandInPlay(const {'W', 'U', 'B', 'R', 'G'}));
        if (pick.loot) {
          me.draw(1);
          if (me.hand.isNotEmpty) {
            final nonland = me.hand.where((c) => !c.isLand).toList();
            final candidates = nonland.isNotEmpty ? nonland : me.hand;
            var worst = candidates.first;
            for (final c in candidates) {
              final betterCmc = c.cmc > worst.cmc;
              final tieCreature = c.cmc == worst.cmc && c.isCreature && !worst.isCreature;
              if (betterCmc || tieCreature) worst = c;
            }
            me.hand.remove(worst);
            me.graveyard.add(worst);
          }
        }
        if (pick.millSelf > 0) {
          for (var i = 0; i < pick.millSelf && me.library.isNotEmpty; i++) {
            me.graveyard.add(me.library.removeLast());
          }
        }
      }
    }

    if (pick != null) {
      if (!pickRemoved) me.hand.remove(pick);
      mana -= pick.cmc;
      acted = true;
    }
  }

  // combate
  final attackers = me.board
      .where((p) => !p.sick && p.power > 0)
      .toList()
    ..sort((a, b) => b.power.compareTo(a.power));
  if (attackers.isNotEmpty) {
    final blockers = List<_Permanent>.from(foe.board)
      ..sort((a, b) => b.toughness.compareTo(a.toughness));
    final blocked = <_Permanent, _Permanent>{};
    for (final blocker in blockers) {
      _Permanent? target;
      for (final a in attackers) {
        if (blocked.containsKey(a)) continue;
        // evasión: volar solo lo bloquean volar/alcance; amenaza pide 2
        if (a.card.flying && !(blocker.card.flying || blocker.card.reach)) {
          continue;
        }
        if (a.card.menace) continue; // simplificación: amenaza no se bloquea
        final kills = blocker.card.deathtouch
            ? blocker.power >= 1
            : blocker.power >= a.toughness;
        final survives = a.card.deathtouch
            ? false
            : blocker.toughness > a.power;
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
        if (a.card.lifelink) me.life += a.power;
      } else {
        var attackerKills = a.card.deathtouch
            ? a.power >= 1
            : a.power >= blocker.toughness;
        var blockerKills = blocker.card.deathtouch
            ? blocker.power >= 1
            : blocker.power >= a.toughness;
        // iniciativa: el rápido mata antes de recibir daño
        if (a.card.firstStrike && !blocker.card.firstStrike && attackerKills) {
          blockerKills = false;
        } else if (blocker.card.firstStrike &&
            !a.card.firstStrike &&
            blockerKills) {
          attackerKills = false;
        }
        if (attackerKills) {
          foe.board.remove(blocker);
          foe.graveyard.add(blocker.card);
          if (a.card.trample) {
            final excess = a.power - blocker.toughness;
            if (excess > 0) foe.life -= excess;
          }
          if (a.card.lifelink) me.life += a.power;
        }
        if (blockerKills) {
          me.board.remove(a);
          me.graveyard.add(a.card);
        }
      }
    }
  }

  // el rival puede responder al final del turno (removal instantáneo)
  _foeInstantResponse(me, foe);

  for (final p in me.board) {
    p.sick = false;
  }
}

/// Juega UNA partida. 1 = gana A · 0 = gana B · 0.5 = tablas.
double _playGame(
    List<_SimCard> deckA, List<_SimCard> deckB, Random rng, bool aFirst,
    {int startingLife = 20}) {
  final a = _Player(List.of(deckA)..shuffle(rng), life: startingLife);
  final b = _Player(List.of(deckB)..shuffle(rng), life: startingLife);
  a.openingHand(rng);
  b.openingHand(rng);
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
  int startingLife = 20, // 40 para enfrentamientos tipo Commander
}) {
  final simA = _expand(deckA, poolA);
  final simB = _expand(deckB, poolB);
  if (simA.isEmpty || simB.isEmpty) return 0.5;
  final rng = Random(seed);
  var wins = 0.0;
  for (var g = 0; g < games; g++) {
    wins += _playGame(simA, simB, rng, g.isEven, startingLife: startingLife);
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
  int startingLife = 20,
}) {
  final proposals = generateProposals(pool, maxProposals: 10);
  if (proposals.isEmpty) return null;

  final rng = Random(seed);
  var tried = 0;

  double eval(Deck d) {
    tried++;
    return simulateMatch(d, pool, meta, metaPool,
        games: games, seed: seed + tried, startingLife: startingLife);
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

  // El hill-climbing cambió hechizos: el score de `best` ya no describe a
  // `current`. Se reevalúa con las fuentes reales de sus tierras.
  final sources = <String, int>{};
  for (final c in current.colors.split('')) {
    var n = 0;
    current.lands.forEach((name, qty) {
      final land = pool[name];
      if (land != null &&
          LandProfile.fromCard(land).sourceOf(c, current.colors)) {
        n += qty;
      }
    });
    sources[c] = n;
  }
  final finalEval = evaluateDeck(current, pool, sources);

  return OptimizeResult(
    deck: GeneratedDeck(
        current, best.theme, finalEval.total, best.manabase, finalEval),
    winRate: bestRate,
    gamesPerEval: games,
    decksTried: tried,
  );
}
