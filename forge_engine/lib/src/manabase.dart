import 'lands.dart';
import 'mana_curve.dart';
import 'models.dart';

/// Manabase con no-básicas — espejo 1:1 de `engine-reference/forge/manabase.py`.
///
/// Sustituye el reparto proporcional de solo-básicas: un greedy determinista
/// llena [nLands] cubriendo primero los déficits de fuentes de color contra
/// la tabla Karsten (`karstenSources`), usando duales/fetches del pool antes
/// que básicas de relleno.

/// Tabla Karsten (mazo 60, ~90%): fuentes de UN color requeridas por (nº
/// símbolos, turno del coste). Clave: symbols*10 + turn.
const Map<int, int> karstenSources = {
  11: 14, 12: 13, 13: 12, 14: 11, 15: 10, 16: 9,
  22: 20, 23: 18, 24: 16, 25: 15, 26: 14,
  33: 23, 34: 22, 35: 21, 36: 20,
};

/// Tope de tierras que entran giradas ("always"), por arquetipo.
const Map<String, int> tappedBudget = {
  'aggro': 2,
  'tempo': 3,
  'midrange': 4,
  'control': 6,
};

const List<String> _wubrg = ['W', 'U', 'B', 'R', 'G'];

class ManabaseResult {
  final Map<String, int> lands;
  final Map<String, int> sourcesByColor; // fuentes efectivas (duales/fetch cuentan)
  final Map<String, int> requiredByColor; // objetivo Karsten por color

  const ManabaseResult({
    required this.lands,
    required this.sourcesByColor,
    required this.requiredByColor,
  });
}

class _Candidate {
  final String name;
  final LandProfile profile;
  final bool isBasic;
  final int owned;
  _Candidate(this.name, this.profile, this.isBasic, this.owned);
}

/// Fuentes de UN color requeridas por la tabla Karsten para los hechizos
/// dados: earliest = primer turno con un símbolo de ese color, maxSym = más
/// símbolos del mismo color en un solo coste (un {C}{C} no se juega antes
/// del t2, de ahí `turn = max(earliest, maxSym)`).
Map<String, int> _requiredByColor(Map<String, int> spells,
    Map<String, Card> pool, String colors, int deckSize) {
  final maxSymByColor = <String, int>{};
  final earliestByColor = <String, int>{};
  spells.forEach((name, qty) {
    final card = pool[name];
    if (card == null) return;
    final cmc = card.cmc < 1 ? 1 : (card.cmc > 6 ? 6 : card.cmc);
    ManaCurve.colorSymbols(card.manaCost).forEach((c, k) {
      if (!colors.contains(c)) return;
      if (k > (maxSymByColor[c] ?? 0)) maxSymByColor[c] = k;
      if (earliestByColor[c] == null || cmc < earliestByColor[c]!) {
        earliestByColor[c] = cmc;
      }
    });
  });
  final required = <String, int>{};
  maxSymByColor.forEach((c, rawMaxSym) {
    final maxSym = rawMaxSym > 3 ? 3 : rawMaxSym;
    final earliest = earliestByColor[c] ?? 1;
    var turn = earliest > maxSym ? earliest : maxSym;
    if (turn > 6) turn = 6;
    final base = karstenSources[maxSym * 10 + turn]!;
    // karstenSources está tabulada para mazos de 60; para otros tamaños
    // (Commander, 100) se escala proporcionalmente (aprox. suficiente).
    required[c] = (base * deckSize / 60).ceil();
  });
  return required;
}

/// Candidatas del pool: no-básicas que producen solo colores del mazo (o
/// fetches buscables dentro de él) + básicas de los colores del mazo.
/// Utility (incoloras sin fetch) fuera. Orden de calidad: nº de colores que
/// produce desc, tapped never<conditional<always, nombre asc.
List<_Candidate> _candidates(Map<String, Card> pool, String colors) {
  final deckColors = colors.split('').toSet();
  final out = <_Candidate>[];
  pool.forEach((name, card) {
    if (!card.isLand) return;
    final profile = LandProfile.fromCard(card);
    if (profile.isBasic) {
      if (profile.produces.any(deckColors.contains)) {
        out.add(_Candidate(name, profile, true, card.qty));
      }
      return;
    }
    if (profile.isUtility) return;
    if (profile.isFetch) {
      final ok = profile.fetches.isEmpty ||
          profile.fetches.any(deckColors.contains);
      if (ok) out.add(_Candidate(name, profile, false, card.qty));
      return;
    }
    if (profile.produces.isNotEmpty &&
        profile.produces.difference(deckColors).isEmpty) {
      out.add(_Candidate(name, profile, false, card.qty));
    }
  });
  out.sort((a, b) {
    final byColors =
        b.profile.produces.length.compareTo(a.profile.produces.length);
    if (byColors != 0) return byColors;
    final byTapped = a.profile.tapped.index.compareTo(b.profile.tapped.index);
    if (byTapped != 0) return byTapped;
    return a.name.compareTo(b.name);
  });
  return out;
}

/// Construye la manabase de [nLands] para una identidad [colors] a partir de
/// [pool], cubriendo primero los déficits de fuentes Karsten de los
/// [spells]. Null si algún color usado se queda sin NINGUNA fuente.
ManabaseResult? buildManaBase(
  Map<String, int> spells,
  Map<String, Card> pool,
  String colors,
  int nLands, {
  required String archetypeName,
  int copyCap = 4,
  int deckSize = 60,
}) {
  final requiredByColor = _requiredByColor(spells, pool, colors, deckSize);
  final candidates = _candidates(pool, colors);
  final sourcesByColor = <String, int>{
    for (final c in requiredByColor.keys) c: 0
  };
  final taken = <String, int>{};
  var tappedUsed = 0;
  final budget = tappedBudget[archetypeName] ?? 0;
  final lands = <String, int>{};

  int gainOf(_Candidate cand) {
    var g = 0;
    for (final c in requiredByColor.keys) {
      if (sourcesByColor[c]! < requiredByColor[c]! &&
          cand.profile.sourceOf(c, colors)) {
        g++;
      }
    }
    return g;
  }

  for (var i = 0; i < nLands; i++) {
    final available = candidates.where((c) {
      final cap = c.isBasic
          ? c.owned
          : (copyCap < c.owned ? copyCap : c.owned);
      if ((taken[c.name] ?? 0) >= cap) return false;
      if (c.profile.tapped == TappedKind.always && tappedUsed >= budget) {
        return false;
      }
      return true;
    }).toList();
    if (available.isEmpty) break;

    final gains = {for (final c in available) c.name: gainOf(c)};
    final bestGain = gains.values.reduce((a, b) => a > b ? a : b);

    _Candidate pick;
    if (bestGain > 0) {
      final tied = available.where((c) => gains[c.name] == bestGain).toList();
      final basics = tied.where((c) => c.isBasic).toList();
      // empate → orden de calidad (ya viene ordenado); no-básica vs básica
      // empatadas en gain → gana la básica (más barata de girar y de poseer).
      pick = (basics.isNotEmpty ? basics : tied).first;
    } else {
      // sin déficits: básica del color con menor sources/required; empate WUBRG.
      final ranked = requiredByColor.keys.toList()
        ..sort((a, b) {
          final ra = sourcesByColor[a]! / requiredByColor[a]!;
          final rb = sourcesByColor[b]! / requiredByColor[b]!;
          final cmp = ra.compareTo(rb);
          if (cmp != 0) return cmp;
          return _wubrg.indexOf(a).compareTo(_wubrg.indexOf(b));
        });
      _Candidate? chosen;
      for (final c in ranked) {
        final basicHere =
            available.where((cand) => cand.isBasic && cand.profile.produces.contains(c));
        if (basicHere.isNotEmpty) {
          chosen = basicHere.first;
          break;
        }
      }
      pick = chosen ?? available.first;
    }

    lands[pick.name] = (lands[pick.name] ?? 0) + 1;
    taken[pick.name] = (taken[pick.name] ?? 0) + 1;
    if (pick.profile.tapped == TappedKind.always) tappedUsed++;
    for (final c in requiredByColor.keys) {
      if (pick.profile.sourceOf(c, colors)) {
        sourcesByColor[c] = (sourcesByColor[c] ?? 0) + 1;
      }
    }
  }

  for (final c in requiredByColor.keys) {
    if ((sourcesByColor[c] ?? 0) == 0) return null;
  }

  return ManabaseResult(
    lands: lands,
    sourcesByColor: sourcesByColor,
    requiredByColor: requiredByColor,
  );
}
