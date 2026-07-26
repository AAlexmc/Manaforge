import 'generator.dart';
import 'models.dart';
import 'simulator.dart';

/// Forja profunda — fase 4: las mejores propuestas de `generateProposals`
/// juegan un round-robin simulado entre sí antes de enseñarse, y el orden
/// final pesa cómo rinden de verdad tanto como su score estático.
///
/// Solo-Dart, sin espejo Python — es Modo Test/ranking de la app de
/// escritorio, igual que `simulator.dart` (ver su cabecera): no forma parte
/// del generador, que sí debe coincidir 1:1 con la referencia.

/// Reordena las [top] mejores [proposals] por round-robin simulado: cada una
/// contra todas las demás del top, [games] partidas por cruce. El resto (si
/// [proposals] tiene más de [top]) se queda detrás, en su orden original —
/// nunca entraron a jugar. Ranking final por propuesta del top:
/// `0.6 * winrate medio + 0.4 * (score estático / 10)`. Determinista con
/// [seed] (cada cruce usa una semilla derivada fija, nunca `Random` suelto).
List<GeneratedDeck> rankBySimulation(
    List<GeneratedDeck> proposals, Map<String, Card> pool,
    {int games = 40, int seed = 7, int top = 6}) {
  if (proposals.length <= 1) return proposals;
  final n = proposals.length < top ? proposals.length : top;
  final contenders = proposals.sublist(0, n);
  final rest = proposals.sublist(n);

  final winRateSum = List<double>.filled(n, 0.0);
  var pairSeed = seed;
  for (var i = 0; i < n; i++) {
    for (var j = i + 1; j < n; j++) {
      final wr = simulateMatch(contenders[i].deck, pool, contenders[j].deck,
          pool, games: games, seed: pairSeed);
      winRateSum[i] += wr;
      winRateSum[j] += 1 - wr;
      pairSeed++;
    }
  }
  final divisor = n > 1 ? n - 1 : 1;
  double rankOf(int i) =>
      0.6 * (winRateSum[i] / divisor) + 0.4 * (contenders[i].score / 10);

  final order = List<int>.generate(n, (i) => i)
    ..sort((a, b) => rankOf(b).compareTo(rankOf(a)));
  return [for (final i in order) contenders[i], ...rest];
}
