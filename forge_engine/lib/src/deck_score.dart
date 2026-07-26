import 'classify.dart';
import 'hypergeometric.dart';
import 'mana_curve.dart';
import 'models.dart';

/// Evaluación de un mazo completo — espejo 1:1 de
/// `engine-reference/forge/deck_score.py`.
///
/// El score de un mazo deja de ser solo la media de eficiencia: también
/// cuenta si sus tierras llegan a tiempo (consistencia) y si tiene jugada
/// pronto (curva), con las probabilidades hipergeométricas de la fase 1.
/// Un mazo bonito que no roba sus tierras a tiempo baja en el ranking.
class DeckEvaluation {
  final double efficiency; // 0-10, media ponderada como hoy
  final double consistency; // 0-10: 6·pKeepableHand + 4·castabilidad media
  final double curve; // 0-10: media t=1..4 de P(jugada de coste<=t al turno t)

  const DeckEvaluation({
    required this.efficiency,
    required this.consistency,
    required this.curve,
  });

  double get total => 0.5 * efficiency + 0.25 * consistency + 0.25 * curve;
}

/// Castabilidad de una copia: mínimo entre sus colores de P(fuentes
/// suficientes al turno de su coste). Sin símbolos de color -> 1.0 (una
/// carta incolora siempre es "castable").
double _castability(
    Card card, Map<String, int> sourcesByColor, int deckSize) {
  final symbols = ManaCurve.colorSymbols(card.manaCost);
  if (symbols.isEmpty) return 1.0;
  final turn = card.cmc < 1 ? 1 : (card.cmc > 6 ? 6 : card.cmc);
  var worst = 1.0;
  symbols.forEach((c, k) {
    final sources = sourcesByColor[c] ?? 0;
    final p = pColorByTurn(sources, deckSize, turn, k);
    if (p < worst) worst = p;
  });
  return worst;
}

/// Evalúa un mazo: eficiencia media, consistencia (manos keepable +
/// castabilidad con las fuentes reales de [sourcesByColor]) y curva jugable
/// (P de tener jugada de coste <=t al turno t, t=1..4).
DeckEvaluation evaluateDeck(
    Deck deck, Map<String, Card> pool, Map<String, int> sourcesByColor,
    {int deckSize = 60}) {
  var spellCount = 0;
  var effSum = 0.0;
  var castSum = 0.0;
  final hist = <int, int>{};
  deck.cards.forEach((name, qty) {
    final card = pool[name];
    if (card == null) return;
    spellCount += qty;
    effSum += efficiency(card) * qty;
    castSum += _castability(card, sourcesByColor, deckSize) * qty;
    final cmc = card.cmc < 0 ? 0 : (card.cmc > 6 ? 6 : card.cmc);
    hist[cmc] = (hist[cmc] ?? 0) + qty;
  });
  if (spellCount == 0) spellCount = 1;

  final nLands = deck.lands.values.fold(0, (a, b) => a + b);
  final keepable = pKeepableHand(nLands, deckSize);
  final castability = castSum / spellCount;
  final consistency = 10 * (0.6 * keepable + 0.4 * castability);

  var curveSum = 0.0;
  for (var t = 1; t <= 4; t++) {
    var sT = 0;
    for (var cmc = 1; cmc <= t; cmc++) {
      sT += hist[cmc] ?? 0;
    }
    curveSum += hypergeomAtLeast(deckSize, sT, 6 + t, 1);
  }
  final curve = 10 * (curveSum / 4);

  return DeckEvaluation(
    efficiency: effSum / spellCount,
    consistency: consistency,
    curve: curve,
  );
}
