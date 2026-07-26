import 'models.dart';

/// Clasificación funcional y detección de temas — espejo 1:1 de
/// `engine-reference/forge/classify.py`.

/// Cuotas funcionales por arquetipo (mínimos entre los ~36-37 hechizos).
const Map<String, Map<String, int>> quotas = {
  'aggro': {'creatures': 20, 'interaction': 4, 'draw': 0},
  'tempo': {'creatures': 14, 'interaction': 8, 'draw': 2},
  'midrange': {'creatures': 16, 'interaction': 6, 'draw': 2},
  'control': {'creatures': 8, 'interaction': 12, 'draw': 4},
};

class _Theme {
  final RegExp? payoff;
  final RegExp? enabler;
  const _Theme(this.payoff, this.enabler);
}

final Map<String, _Theme> _themes = {
  'lifegain': _Theme(
    RegExp(r'whenever you gain life'),
    RegExp(r'you gain \d+ life|lifelink|gain that much life'),
  ),
  'sacrifice': _Theme(
    RegExp(r'whenever .* (creature|permanent) (you control )?dies'),
    RegExp(r'sacrifice (a|another) creature|sacrifice this creature'),
  ),
  'spells': _Theme(
    RegExp(
        r'whenever you cast (an instant|a noncreature|an instant or sorcery)|prowess'),
    null, // el enabler son los propios instantáneos/conjuros baratos
  ),
  'artifacts': _Theme(
    // Payoff = premia tener/lanzar artefactos. Improvisar NO es payoff
    // (consume artefactos): tratarlo como tal hacía que los artefactos
    // incoloros convirtieran cualquier identidad en mazo de artefactos.
    RegExp(
        r'whenever you cast an artifact|whenever (an|another) artifact|artifact you control enters|affinity for artifacts|enchanted artifact is a creature'),
    RegExp(r'improvise'),
  ),
  'counters': _Theme(
    RegExp(r'if one or more counters would be put|proliferate'),
    RegExp(r'\+1/\+1 counter'),
  ),
  'tokens': _Theme(
    RegExp(r'whenever (a|another) creature (you control )?enters'),
    RegExp(r'create .* creature token'),
  ),
  'graveyard': _Theme(
    RegExp(r'delirium|threshold|for each creature card in your graveyard'),
    RegExp(r'mill|return .* from your graveyard'),
  ),
  'reanimator': _Theme(
    RegExp(
        r'return .*creature.* from your graveyard to the battlefield|unearth|disturb|embalm|eternalize'),
    RegExp(
        r'mill (a card|\d+|up to)|surveil \d+|discard(s)? (a|two|three|your hand)'),
  ),
};

final _removal = RegExp(r'destroy (target|up to)|exile (target|up to)');
final _sweeper = RegExp(r'destroy all|each creature.*(-\d+/-\d+|destroy)');
final _burn = RegExp(
    r'deals? \d+ damage to (any target|target creature|target player|each opponent)');
final _counterspell = RegExp(r'counter target .*spell');
final _draw = RegExp(r'draws? (a|two|three|x) cards?');
final _ramp = RegExp(r'\{t\}: add \{|search your library for a .*land');
final _recursion =
    RegExp(r'return .* from your graveyard to (your hand|the battlefield)');
final _lifegain = RegExp(r'gains? \d+ life|lifelink');
final _pump = RegExp(r'target creature gets \+\d+');

/// Pesos de keywords de combate (sustituye el +0.8 plano). Suma con tope +2.0.
const Map<String, double> kwWeight = {
  'flying': 1.2,
  'double strike': 0.9,
  'menace': 0.8,
  'haste': 0.7,
  'deathtouch': 0.6,
  'lifelink': 0.6,
  'first strike': 0.5,
  'vigilance': 0.3,
  'reach': 0.2,
  'trample': 0.2,
};

/// Etiquetas funcionales de una carta: creature, removal, sweeper, burn,
/// counterspell, draw, ramp, recursion, lifegain, pump, land.
Set<String> classify(Card card) {
  final text = card.oracle.toLowerCase();
  final tags = <String>{};

  if (card.types.contains('Land')) return {'land'};
  if (card.types.contains('Creature')) tags.add('creature');
  if (_removal.hasMatch(text)) tags.add('removal');
  if (_sweeper.hasMatch(text)) tags.add('sweeper');
  if (_burn.hasMatch(text)) {
    tags.add('burn');
    if (!tags.contains('creature')) tags.add('removal');
  }
  if (_counterspell.hasMatch(text)) tags.add('counterspell');
  if (_draw.hasMatch(text)) tags.add('draw');
  if (_ramp.hasMatch(text)) tags.add('ramp');
  if (_recursion.hasMatch(text)) tags.add('recursion');
  if (_lifegain.hasMatch(text)) tags.add('lifegain');
  if (_pump.hasMatch(text)) tags.add('pump');
  return tags;
}

final _tribalPayoffSecondary = RegExp(r'other |you control|whenever|each ');

/// Formas plurales plausibles de un subtipo tribal (ya en minúsculas): el
/// +s regular y, para los -f/-fe clásicos de Magic (Elf, Dwarf, Wolf...),
/// el irregular -ves (Elves, Dwarves, Wolves) — el oracle real casi nunca
/// usa "Elfs". Si acaba en s/x/ch/sh también el +es regular (Fox->Foxes).
Iterable<String> _tribalPlurals(String tribeLower) sync* {
  yield '${tribeLower}s';
  if (tribeLower.endsWith('fe')) {
    yield '${tribeLower.substring(0, tribeLower.length - 2)}ves';
  } else if (tribeLower.endsWith('f')) {
    yield '${tribeLower.substring(0, tribeLower.length - 1)}ves';
  }
  if (tribeLower.endsWith('s') ||
      tribeLower.endsWith('x') ||
      tribeLower.endsWith('ch') ||
      tribeLower.endsWith('sh')) {
    yield '${tribeLower}es';
  }
}

/// Rol tribal de una carta para una tribu concreta ([tribe], el subtipo en
/// inglés: "Elf", "Goblin"…). Payoff: menciona la tribu (singular o
/// plural, regular o irregular) y trae una palabra de anthem/trigger
/// tribal. Enabler: criatura de ese subtipo — el propio cuerpo de la tribu.
String? tribalRole(Card card, String tribe) {
  final text = card.oracle.toLowerCase();
  final t = tribe.toLowerCase();
  // Frontera de palabra: `contains` crudo confunde "Rat" con "rather",
  // "Cat" con "duplicate", "Angel" con "changeling", "Elf" con "itself"
  // (C1) — medido contra la colección real, 21,6% de los payoffs tribales
  // de las 24 tribus curadas eran falsos positivos por esta subcadena.
  bool asWord(String form) =>
      RegExp('\\b' + RegExp.escape(form) + '\\b').hasMatch(text);
  final mentionsTribe = asWord(t) || _tribalPlurals(t).any(asWord);
  if (mentionsTribe && _tribalPayoffSecondary.hasMatch(text)) {
    return 'payoff';
  }
  if (card.types.contains('Creature') && card.subtypes.contains(tribe)) {
    return 'enabler';
  }
  return null;
}

/// Para cada tema, si la carta es 'payoff' o 'enabler' de ese tema.
Map<String, String> themeRoles(Card card) {
  final text = card.oracle.toLowerCase();
  final roles = <String, String>{};
  _themes.forEach((theme, pats) {
    if (pats.payoff != null && pats.payoff!.hasMatch(text)) {
      roles[theme] = 'payoff';
    } else if (pats.enabler != null && pats.enabler!.hasMatch(text)) {
      roles[theme] = 'enabler';
    }
  });
  // enablers estructurales (por tipo de carta, no por texto)
  if (card.types.contains('Artifact') && !roles.containsKey('artifacts')) {
    roles['artifacts'] = 'enabler';
  }
  final isCheapSpell =
      (card.types.contains('Instant') || card.types.contains('Sorcery')) &&
          card.cmc <= 3;
  if (isCheapSpell && !roles.containsKey('spells')) {
    roles['spells'] = 'enabler';
  }
  return roles;
}

/// Puntuación de eficiencia individual (0-10, heurística). [archetype]
/// sube el peso de la prisa: pegar ya vale más en un mazo agresivo.
double efficiency(Card card, {String archetype = ''}) {
  final cmc = card.cmc < 1 ? 1 : card.cmc;
  var score = 5.0;
  if (card.types.contains('Creature')) {
    final pt = (card.power != null && card.toughness != null)
        ? card.power! + card.toughness!
        : cmc * 2; // poder variable (*/*), neutral
    score = 5.0 + (pt - 2 * cmc) * 0.8; // 2*cmc de stats totales = media
    var kwBonus = 0.0;
    kwWeight.forEach((k, w) {
      if (card.hasKeyword(k)) {
        if (k == 'haste' && archetype == 'aggro') w *= 1.5;
        kwBonus += w;
      }
    });
    // arrollar solo paga en gordas: un 6/6 arrollador pega de verdad.
    if (card.power != null && card.power! >= 4 && card.hasKeyword('trample')) {
      kwBonus += 0.15 * (card.power! - 3);
    }
    score += kwBonus > 2.0 ? 2.0 : kwBonus;
    if (card.oracle.isNotEmpty) score += 0.4; // tiene texto: algo hace
  } else {
    final tags = classify(card);
    if (tags.contains('removal') ||
        tags.contains('counterspell') ||
        tags.contains('sweeper')) {
      score = 7.0 - (cmc - 2) * 0.5;
    } else if (tags.contains('draw')) {
      score = 6.0 - (cmc - 2) * 0.4;
    } else if (tags.contains('pump')) {
      score = 4.0;
    }
  }
  if (score < 0) return 0;
  if (score > 10) return 10;
  return score;
}
