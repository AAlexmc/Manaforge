import 'classify.dart';
import 'deck_score.dart';
import 'mana_curve.dart';
import 'manabase.dart';
import 'models.dart';
import 'deck_validator.dart';

/// Generador de mazos — fase 3. Basado en `engine-reference/forge/generator.py`
/// (la reforja con curva personalizada y la detección de control son
/// extensiones propias de la app de escritorio, aún sin espejo Python).

const Map<String, String> basicForColor = {
  'W': 'Plains',
  'U': 'Island',
  'B': 'Swamp',
  'R': 'Mountain',
  'G': 'Forest',
};

/// Perfil de curva objetivo (proporción deseada de hechizos por CMC 1..6+).
const Map<String, Map<int, double>> curveTarget = {
  'aggro': {1: .30, 2: .35, 3: .20, 4: .10, 5: .04, 6: .01},
  'tempo': {1: .20, 2: .35, 3: .25, 4: .12, 5: .06, 6: .02},
  'midrange': {1: .12, 2: .28, 3: .26, 4: .18, 5: .12, 6: .04},
  'control': {1: .08, 2: .20, 3: .25, 4: .22, 5: .17, 6: .08},
};

/// Sin masa crítica de payoffs no hay tema.
const int minPayoffCopies = 3;

/// Colores naturales de cada tema (color pie). '' = cualquier color.
const Map<String, String> themeColors = {
  'lifegain': 'WB',
  'sacrifice': 'BR',
  'spells': 'UR',
  'artifacts': 'WU',
  'counters': 'GW',
  'tokens': 'WG',
  'graveyard': 'BG',
};

/// Multiplicador de color pie por tema: 1.25 si [colors] solapa con el color
/// natural del tema, 0.8 si le es ajeno, 1.0 si el tema es de cualquier color
/// o no se conocen los colores del mazo todavía.
Map<String, double> _themeColorMultiplier(String colors) {
  final out = <String, double>{};
  themeColors.forEach((theme, natural) {
    if (natural.isEmpty || colors.isEmpty) {
      out[theme] = 1.0;
    } else {
      out[theme] = natural.split('').any(colors.contains) ? 1.25 : 0.8;
    }
  });
  return out;
}

/// Mazo generado: el Deck validable + metadatos de la generación.
class GeneratedDeck {
  final Deck deck;
  final String theme;
  final double score;

  /// Detalle de la manabase (fuentes por color, objetivo Karsten). Nullable:
  /// Commander la recalcula aparte tras el suelo de básicas.
  final ManabaseResult? manabase;

  /// Desglose del score (eficiencia, consistencia, curva). Nullable: solo
  /// null si el mazo no llegó a evaluarse (no debería pasar hoy).
  final DeckEvaluation? eval;
  const GeneratedDeck(this.deck, this.theme, this.score,
      [this.manabase, this.eval]);
}

Map<String, Card> _candidatePool(Map<String, Card> pool, String colors) {
  final allowed = colors.split('').toSet();
  return Map.fromEntries(pool.entries.where((e) =>
      !e.value.types.contains('Land') &&
      e.value.colors.split('').toSet().difference(allowed).isEmpty));
}

/// Tema dominante y rol de cada carta. Un tema solo es elegible con
/// >= minPayoffCopies copias de payoffs en estos colores. [colors] desempata
/// por color pie: un tema natural de la identidad pesa 1.25x, uno ajeno 0.8x.
(String, Map<String, Map<String, String>>) detectTheme(
    Map<String, Card> cands, {String colors = ''}) {
  final mult = _themeColorMultiplier(colors);
  final weights = <String, double>{};
  final payoffCopies = <String, int>{};
  final rolesByCard = <String, Map<String, String>>{};
  cands.forEach((name, card) {
    final roles = themeRoles(card);
    rolesByCard[name] = roles;
    roles.forEach((theme, role) {
      final m = mult[theme] ?? 1.0;
      if (role == 'payoff') {
        payoffCopies[theme] = (payoffCopies[theme] ?? 0) + card.qty;
        weights[theme] = (weights[theme] ?? 0) + card.qty * 3 * m;
      } else {
        weights[theme] = (weights[theme] ?? 0) + card.qty * m;
      }
    });
  });
  String best = 'goodstuff';
  var bestWeight = -1.0;
  weights.forEach((theme, w) {
    if ((payoffCopies[theme] ?? 0) >= minPayoffCopies && w > bestWeight) {
      best = theme;
      bestWeight = w;
    }
  });
  return (best, rolesByCard);
}

/// Arquetipo según el perfil del pool disponible.
String pickArchetype(Map<String, Card> cands) {
  var cheap = 0;
  var total = 0;
  var interaction = 0;
  var creatures = 0;
  cands.forEach((_, c) {
    total += c.qty;
    if (c.cmc <= 2) cheap += c.qty;
    if (c.isCreature) creatures += c.qty;
    final tags = classify(c);
    if (tags.contains('removal') ||
        tags.contains('counterspell') ||
        tags.contains('burn') ||
        tags.contains('sweeper')) {
      interaction += c.qty;
    }
  });
  if (total == 0) total = 1;
  final cheapShare = cheap / total;
  final interactionShare = interaction / total;
  final creatureShare = creatures / total;
  if (cheapShare > 0.55) {
    return interactionShare < 0.25 ? 'aggro' : 'tempo';
  }
  // pool cargado de respuestas y corto de criaturas => control
  if (interactionShare > 0.30 && creatureShare < 0.45) return 'control';
  return 'midrange';
}

/// Arquetipo cuyo perfil (tierras y coste medio) encaja con un mazo dado.
/// Null si ninguno encaja: la curva pedida no da un mazo sano.
Archetype? archetypeFor(double avgCmc, int nLands) {
  for (final a in Archetype.values) {
    if (nLands >= a.landMin &&
        nLands <= a.landMax &&
        avgCmc >= a.cmcMin &&
        avgCmc <= a.cmcMax) {
      return a;
    }
  }
  return null;
}

double _score(Card card, String theme, Map<String, String> roles,
    Map<int, double> curveNeed, String archetypeName) {
  var s = efficiency(card, archetype: archetypeName);
  final role = roles[theme];
  if (role == 'payoff') s += 3.0;
  if (role == 'enabler') s += 1.5;
  final cmc = card.cmc > 6 ? 6 : card.cmc;
  s += (curveNeed[cmc] ?? 0.0) * 4.0;
  return s;
}

Archetype _archetypeByName(String name) =>
    Archetype.values.firstWhere((a) => a.name == name);

/// Construye el mejor mazo de 60 para una identidad de color. Null si no da.
/// [archetypeOverride] fuerza el arquetipo ('aggro'|'tempo'|'midrange'|
/// 'control') en vez de detectarlo del pool.
GeneratedDeck? generateDeck(Map<String, Card> pool, String colors,
    {String? name, String? archetypeOverride}) {
  final cands = _candidatePool(pool, colors);
  var totalCopies = 0;
  cands.forEach((_, c) => totalCopies += c.qty);
  if (totalCopies < 30) return null;

  final (theme, rolesByCard) = detectTheme(cands, colors: colors);
  final archetypeName = archetypeOverride ?? pickArchetype(cands);
  final archetype = _archetypeByName(archetypeName);
  final target = curveTarget[archetypeName]!;

  // nº de tierras estimado en dos pasadas (depende del coste medio final)
  var nLands = (archetype.landMin + archetype.landMax) ~/ 2;
  var chosen = <String, int>{};
  for (var pass = 0; pass < 2; pass++) {
    chosen = _greedyFill(
        cands, rolesByCard, theme, archetypeName, target, ManaCurve.deckSize - nLands);
    nLands = ManaCurve.recommendedLands(chosen, pool, archetype);
  }
  chosen = _greedyFill(
      cands, rolesByCard, theme, archetypeName, target, ManaCurve.deckSize - nLands);

  final manabase = _manaBase(chosen, pool, colors, nLands, archetypeName);
  if (manabase == null) return null;

  final deck = Deck(
    name: name ?? 'Forge $colors $theme',
    colors: colors,
    archetype: archetype,
    cards: chosen,
    lands: manabase.lands,
  );
  if (DeckValidator.validate(deck, pool).isNotEmpty) return null;

  final eval = evaluateDeck(deck, pool, manabase.sourcesByColor,
      deckSize: ManaCurve.deckSize);
  return GeneratedDeck(deck, theme, eval.total, manabase, eval);
}

Map<String, int> _greedyFill(
    Map<String, Card> cands,
    Map<String, Map<String, String>> rolesByCard,
    String theme,
    String archetypeName,
    Map<int, double> target,
    int nSpells) {
  final quota = Map<String, int>.from(quotas[archetypeName]!);
  final chosen = <String, int>{};
  final counts = {'creatures': 0, 'interaction': 0, 'draw': 0};

  List<String> bucket(Card card) {
    final tags = classify(card);
    final out = <String>[];
    if (tags.contains('creature')) out.add('creatures');
    if (tags.contains('removal') ||
        tags.contains('counterspell') ||
        tags.contains('burn') ||
        tags.contains('sweeper')) {
      out.add('interaction');
    }
    if (tags.contains('draw')) out.add('draw');
    return out;
  }

  Map<int, double> curveNeed() {
    var total = 0;
    chosen.forEach((_, q) => total += q);
    if (total == 0) total = 1;
    final hist = <int, int>{};
    chosen.forEach((n, q) {
      final cmc = cands[n]!.cmc > 6 ? 6 : cands[n]!.cmc;
      hist[cmc] = (hist[cmc] ?? 0) + q;
    });
    final need = <int, double>{};
    for (var cmc = 0; cmc <= 6; cmc++) {
      need[cmc] = (target[cmc] ?? 0) - (hist[cmc] ?? 0) / total;
    }
    return need;
  }

  var totalChosen = 0;
  while (totalChosen < nSpells) {
    final need = curveNeed();
    final pending = <String>{};
    quota.forEach((b, minimum) {
      if (counts[b]! < minimum) pending.add(b);
    });
    String? bestName;
    var bestScore = -1e9;
    cands.forEach((n, card) {
      final limit = card.qty < 4 ? card.qty : 4;
      if ((chosen[n] ?? 0) >= limit) return;
      var s = _score(card, theme, rolesByCard[n]!, need, archetypeName);
      final buckets = bucket(card);
      if (pending.isNotEmpty && !pending.any(buckets.contains)) {
        s -= 3.0; // aún caben, pero prioriza cubrir cuotas
      }
      if (s > bestScore) {
        bestName = n;
        bestScore = s;
      }
    });
    if (bestName == null) break;
    chosen[bestName!] = (chosen[bestName!] ?? 0) + 1;
    totalChosen += 1;
    for (final b in bucket(cands[bestName!]!)) {
      counts[b] = counts[b]! + 1;
    }
  }
  return chosen;
}

/// Manabase con no-básicas por objetivos Karsten (duales/fetches/taplands del
/// pool antes que básicas de relleno). Null si la colección no da (avisar,
/// no forzar). Ver `manabase.dart` para el algoritmo completo.
ManabaseResult? _manaBase(Map<String, int> cards, Map<String, Card> pool,
        String colors, int nLands, String archetypeName) =>
    buildManaBase(cards, pool, colors, nLands, archetypeName: archetypeName);

/// Resultado de una reforja con curva personalizada: mazo o motivo del "no".
/// Por qué no se puede reforjar con la curva pedida. El motor es Dart puro y
/// no tiene traducciones: dice el MOTIVO y los números, y el texto lo pone la
/// app (`forge_texts.dart`), que sí sabe en qué idioma va.
enum ReforgeRefusal {
  /// La curva deja un número de tierras fuera de todo rango sano.
  /// `args`: tierras, mínimo, máximo.
  landsOutOfRange,

  /// No hay cartas suficientes de esos colores para llenar la curva.
  notEnoughCards,

  /// La curva no encaja en ningún arquetipo. `args`: coste medio, tierras.
  curveHasNoProfile,

  /// No hay tierras básicas suficientes en la colección.
  notEnoughBasics,

  /// El mazo resultante rompe una regla dura. `args`: el detalle.
  hardRule,
}

class ReforgeResult {
  final GeneratedDeck? deck;

  /// El motivo en español: registro y red de seguridad.
  final String? reason;

  /// El motivo en máquina, para poder contarlo en otro idioma.
  final ReforgeRefusal? refusal;

  /// Lo que va en los huecos del motivo, en orden.
  final List<String> args;

  const ReforgeResult.ok(GeneratedDeck this.deck)
      : reason = null,
        refusal = null,
        args = const [];
  const ReforgeResult.no(String this.reason,
      {required ReforgeRefusal this.refusal, this.args = const []})
      : deck = null;
}

/// Reforja un mazo para una curva objetivo ABSOLUTA {cmc: nº de hechizos}
/// (0..6, el 6 agrupa 6+). Las tierras salen solas: 60 − hechizos.
/// Respeta las reglas duras: si la curva pedida no da un mazo sano, explica
/// el porqué en vez de fabricar un mazo defectuoso.
ReforgeResult reforgeWithCurve(
    Map<String, Card> pool, String colors, Map<int, int> desired,
    {String? name}) {
  final cands = _candidatePool(pool, colors);
  final nSpells = desired.values.fold(0, (a, b) => a + b);
  final nLands = ManaCurve.deckSize - nSpells;
  if (nLands < Archetype.aggro.landMin || nLands > Archetype.control.landMax) {
    return ReforgeResult.no(
        'Con esa curva salen $nLands tierras: fuera del rango sano '
        '(${Archetype.aggro.landMin}-${Archetype.control.landMax}). '
        'Ajusta el total de hechizos.',
        refusal: ReforgeRefusal.landsOutOfRange,
        args: [
          '$nLands',
          '${Archetype.aggro.landMin}',
          '${Archetype.control.landMax}'
        ]);
  }

  final (theme, rolesByCard) = detectTheme(cands, colors: colors);

  // Relleno por huecos de coste: para cada CMC pedido, las mejores cartas de
  // ese coste; si un hueco se queda corto, se cubre con costes vecinos.
  final chosen = <String, int>{};
  int effCmc(Card c) => c.cmc > 6 ? 6 : c.cmc;

  String? bestAt(int cmc) {
    String? bestName;
    var bestScore = -1e9;
    cands.forEach((n, card) {
      if (effCmc(card) != cmc) return;
      final limit = card.qty < 4 ? card.qty : 4;
      if ((chosen[n] ?? 0) >= limit) return;
      var s = efficiency(card);
      final role = rolesByCard[n]![theme];
      if (role == 'payoff') s += 3.0;
      if (role == 'enabler') s += 1.5;
      if (s > bestScore) {
        bestName = n;
        bestScore = s;
      }
    });
    return bestName;
  }

  var shortfall = 0;
  for (var cmc = 0; cmc <= 6; cmc++) {
    for (var k = 0; k < (desired[cmc] ?? 0); k++) {
      final pick = bestAt(cmc);
      if (pick == null) {
        shortfall++;
        continue;
      }
      chosen[pick] = (chosen[pick] ?? 0) + 1;
    }
  }
  // huecos sin cartas de ese coste: rellenar con los costes vecinos
  if (shortfall > 0) {
    final order = [1, 2, 3, 0, 4, 5, 6];
    var guard = 0;
    while (shortfall > 0 && guard < 200) {
      guard++;
      String? pick;
      for (final cmc in order) {
        pick = bestAt(cmc);
        if (pick != null) break;
      }
      if (pick == null) break;
      chosen[pick] = (chosen[pick] ?? 0) + 1;
      shortfall--;
    }
    if (shortfall > 0) {
      return ReforgeResult.no(
          'Tu colección no tiene suficientes cartas de estos colores para '
          'llenar esa curva. Prueba con menos hechizos o con otros costes.',
          refusal: ReforgeRefusal.notEnoughCards);
    }
  }

  final avg = ManaCurve.averageCmc(chosen, pool);
  final archetype = archetypeFor(avg, nLands);
  if (archetype == null) {
    return ReforgeResult.no(
        'Esa curva (coste medio ${avg.toStringAsFixed(1)} con $nLands '
        'tierras) no encaja en ningún perfil sano: un mazo barato quiere '
        'menos tierras y uno caro quiere más. Acércalos.',
        refusal: ReforgeRefusal.curveHasNoProfile,
        args: [avg.toStringAsFixed(1), '$nLands']);
  }

  final manabase = _manaBase(chosen, pool, colors, nLands, archetype.name);
  if (manabase == null) {
    return const ReforgeResult.no(
        'No hay tierras básicas suficientes en la colección para esa curva.',
        refusal: ReforgeRefusal.notEnoughBasics);
  }

  final deck = Deck(
    name: name ?? 'Forge $colors $theme',
    colors: colors,
    archetype: archetype,
    cards: chosen,
    lands: manabase.lands,
  );
  final errors = DeckValidator.validate(deck, pool);
  if (errors.isNotEmpty) {
    return ReforgeResult.no(
        'La curva pedida rompe una regla dura: ${errors.first}',
        refusal: ReforgeRefusal.hardRule,
        args: [errors.first]);
  }

  final eval = evaluateDeck(deck, pool, manabase.sourcesByColor,
      deckSize: ManaCurve.deckSize);
  return ReforgeResult.ok(
      GeneratedDeck(deck, theme, eval.total, manabase, eval));
}

/// Las mejores propuestas entre monocolor y pares de colores.
/// [allowedColors] (p. ej. "WU") limita las identidades a ese subconjunto;
/// [archetypeOverride] fuerza el arquetipo de todas las propuestas.
List<GeneratedDeck> generateProposals(Map<String, Card> pool,
    {int maxProposals = 5, String? allowedColors, String? archetypeOverride}) {
  const wubrg = ['W', 'U', 'B', 'R', 'G'];
  final singles = allowedColors == null || allowedColors.isEmpty
      ? wubrg
      : wubrg.where(allowedColors.contains).toList();
  final identities = <String>[...singles];
  for (var i = 0; i < singles.length; i++) {
    for (var j = i + 1; j < singles.length; j++) {
      identities.add(singles[i] + singles[j]);
    }
  }
  final proposals = <GeneratedDeck>[];
  for (final colors in identities) {
    final gen =
        generateDeck(pool, colors, archetypeOverride: archetypeOverride);
    if (gen != null) proposals.add(gen);
  }
  proposals.sort((a, b) => b.score.compareTo(a.score));
  return proposals.length > maxProposals
      ? proposals.sublist(0, maxProposals)
      : proposals;
}
