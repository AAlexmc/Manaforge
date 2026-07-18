import 'models.dart';

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

  /// Tierras recomendadas: 24 en coste medio 3.0, ±1 por cada ±0.5, menos
  /// descuento por fuentes baratas; acotado al rango del arquetipo.
  static int recommendedLands(
      Map<String, int> cards, Map<String, Card> pool, Archetype archetype) {
    final avg = averageCmc(cards, pool);
    final raw = 24 + (avg - 3.0) * 2 - cheapSources(cards, pool) / 3.5;
    return raw.round().clamp(archetype.landMin, archetype.landMax);
  }

  /// Histograma de curva por CMC (agrupa 7+).
  static Map<int, int> curveHistogram(
      Map<String, int> cards, Map<String, Card> pool,
      {int cap = 7}) {
    final hist = <int, int>{};
    cards.forEach((name, qty) {
      final cmc = (pool[name]?.cmc ?? 0).clamp(0, cap);
      hist[cmc] = (hist[cmc] ?? 0) + qty;
    });
    return hist;
  }
}
