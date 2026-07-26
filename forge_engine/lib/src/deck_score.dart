import 'classify.dart';
import 'hypergeometric.dart';
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

final RegExp _symbolRe = RegExp(r'\{([^}]+)\}');

/// Grupos de color por símbolo: {B/G}{B/G} -> {'BG': 2}, {W}{W}{U} ->
/// {'W': 2, 'U': 1}. Los símbolos pagables sin color ({2/W}, {W/P},
/// genéricos, X, {C}) no exigen fuente y quedan fuera.
Map<String, int> _colorGroups(String cost) {
  final groups = <String, int>{};
  for (final m in _symbolRe.allMatches(cost)) {
    final sym = m.group(1)!.toUpperCase();
    if (sym.contains('2') || sym.contains('P')) continue; // pago alternativo
    final colors = [
      for (final ch in ['W', 'U', 'B', 'R', 'G'])
        if (sym.contains(ch)) ch
    ];
    if (colors.isEmpty) continue;
    final key = colors.join();
    groups[key] = (groups[key] ?? 0) + 1;
  }
  return groups;
}

/// Castabilidad de una copia: mínimo entre sus grupos de color de P(fuentes
/// suficientes al turno de su coste). Un híbrido {B/G} se paga con
/// CUALQUIERA de los dos: sus fuentes son la unión, aproximada como la suma
/// de fuentes de los colores del grupo capada al total de tierras (las
/// duales cuentan en ambos colores y la cota evita el doble conteo). Sin
/// símbolos de color -> 1.0.
double _castability(Card card, Map<String, int> sourcesByColor, int deckSize,
    int nLands) {
  final groups = _colorGroups(card.manaCost);
  if (groups.isEmpty) return 1.0;
  final turn = card.cmc < 1 ? 1 : (card.cmc > 6 ? 6 : card.cmc);
  var worst = 1.0;
  groups.forEach((group, k) {
    var sources = 0;
    for (var i = 0; i < group.length; i++) {
      sources += sourcesByColor[group[i]] ?? 0;
    }
    if (sources > nLands) sources = nLands;
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
  final nLands = deck.lands.values.fold(0, (a, b) => a + b);
  var spellCount = 0;
  var effSum = 0.0;
  var castSum = 0.0;
  final hist = <int, int>{};
  deck.cards.forEach((name, qty) {
    final card = pool[name];
    if (card == null) return;
    spellCount += qty;
    effSum += efficiency(card) * qty;
    castSum += _castability(card, sourcesByColor, deckSize, nLands) * qty;
    final cmc = card.cmc < 0 ? 0 : (card.cmc > 6 ? 6 : card.cmc);
    hist[cmc] = (hist[cmc] ?? 0) + qty;
  });
  if (spellCount == 0) spellCount = 1;

  final keepable = pKeepableHand(nLands, deckSize);
  final castability = castSum / spellCount;
  final consistency = 10 * (0.6 * keepable + 0.4 * castability);

  var curveSum = 0.0;
  for (var t = 1; t <= 4; t++) {
    var sT = 0;
    // coste 0 (Ornithopter, Memnite…) también es jugada de turno t
    for (var cmc = 0; cmc <= t; cmc++) {
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
