import 'hypergeometric.dart';
import 'models.dart';

/// Turno al que cada arquetipo necesita haber caído tierra sí o sí.
const Map<String, int> landDropTurn = {
  'aggro': 3,
  'tempo': 4,
  'midrange': 4,
  'control': 5,
};

/// Matemática de la curva de maná — espejo 1:1 de `engine-reference/forge/curve.py`.
class ManaCurve {
  static const int deckSize = 60;
  static final RegExp _symbol = RegExp(r'\{([^}]+)\}');

  /// Valor de maná de un coste tipo "{2}{U}{U}". X cuenta como 0; {2/W} cuenta 2.
  static int manaValue(String cost) {
    var total = 0;
    for (final m in _symbol.allMatches(cost)) {
      final sym = m.group(1)!;
      final n = int.tryParse(sym);
      if (n != null) {
        total += n;
      } else if (const ['X', 'Y', 'Z'].contains(sym.toUpperCase())) {
        // X cuenta 0
      } else if (sym.contains('/') && sym.contains('2')) {
        total += 2;
      } else {
        total += 1;
      }
    }
    return total;
  }

  /// Símbolos de color de un coste (los híbridos cuentan para ambos colores).
  static Map<String, int> colorSymbols(String cost) {
    final out = <String, int>{};
    for (final m in _symbol.allMatches(cost)) {
      final sym = m.group(1)!.toUpperCase();
      for (final ch in ['W', 'U', 'B', 'R', 'G']) {
        if (sym.contains(ch)) out[ch] = (out[ch] ?? 0) + 1;
      }
    }
    return out;
  }

  /// Coste medio de un conjunto de hechizos {nombre: cantidad}.
  static double averageCmc(Map<String, int> cards, Map<String, Card> pool) {
    final n = cards.values.fold(0, (a, b) => a + b);
    if (n == 0) return 0;
    var total = 0;
    cards.forEach((name, qty) => total += (pool[name]?.cmc ?? 0) * qty);
    return total / n;
  }

  /// Fuentes baratas de aceleración/robo (cmc ≤ 2 que producen maná o roban).
  static int cheapSources(Map<String, int> cards, Map<String, Card> pool) {
    var count = 0;
    cards.forEach((name, qty) {
      final card = pool[name];
      if (card == null || card.cmc > 2) return;
      final text = card.oracle.toLowerCase();
      if (text.contains('add {') || text.contains('draw a card')) count += qty;
    });
    return count;
  }

  /// Tierras recomendadas: semilla Karsten (24 en coste medio 3.0, ±1 por
  /// cada ±0.5, menos descuento por fuentes baratas) para desempatar, pero el
  /// número final es el que maximiza P(caer tierra a tiempo) - 0.5*P(inundación)
  /// dentro del rango del arquetipo.
  static int recommendedLands(
      Map<String, int> cards, Map<String, Card> pool, Archetype archetype) {
    final avg = averageCmc(cards, pool);
    final raw = 24 + (avg - 3.0) * 2 - cheapSources(cards, pool) / 3.5;
    final t = landDropTurn[archetype.name]!;
    double util(int n) =>
        pLandDrops(n, deckSize, t) -
        0.5 *
            hypergeomAtLeast(
                deckSize, n, t + 8, t + 3); // inundación: >=t+3 tierras al turno t+2
    var best = archetype.landMin;
    var bestU = double.negativeInfinity;
    for (var n = archetype.landMin; n <= archetype.landMax; n++) {
      var u = util(n);
      u -= (n - raw).abs() * 0.001; // desempate estable hacia la semilla Karsten
      if (u > bestU) {
        bestU = u;
        best = n;
      }
    }
    return best;
  }

  /// Histograma de curva por CMC (agrupa 7+).
  static Map<int, int> curveHistogram(
      Map<String, int> cards, Map<String, Card> pool,
      {int cap = 7}) {
    final hist = <int, int>{};
    cards.forEach((name, qty) {
      var cmc = pool[name]?.cmc ?? 0;
      if (cmc > cap) cmc = cap;
      if (cmc < 0) cmc = 0;
      hist[cmc] = (hist[cmc] ?? 0) + qty;
    });
    return hist;
  }
}
