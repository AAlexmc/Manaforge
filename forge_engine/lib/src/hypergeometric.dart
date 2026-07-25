/// Probabilidad hipergeométrica pura — espejo 1:1 de
/// `engine-reference/forge/hypergeometric.py`.
///
/// Base matemática de la fase 1 (maná): con cuántas tierras/fuentes de color
/// se cae la carta a tiempo, y qué tan keepable es una mano inicial.
double _binom(int n, int k) {
  if (k < 0 || k > n) return 0;
  var r = 1.0;
  for (var i = 0; i < k; i++) {
    r = r * (n - i) / (i + 1);
  }
  return r;
}

/// P(exactamente [k] éxitos) al robar [draws] de una población [popSize]
/// con [successes] éxitos.
double hypergeomPmf(int popSize, int successes, int draws, int k) {
  if (k < 0 || k > draws || k > successes) return 0;
  if (draws - k > popSize - successes) return 0;
  return _binom(successes, k) *
      _binom(popSize - successes, draws - k) /
      _binom(popSize, draws);
}

/// P(>= [k] éxitos) al robar [draws].
double hypergeomAtLeast(int popSize, int successes, int draws, int k) {
  var p = 0.0;
  for (var i = k; i <= draws; i++) {
    p += hypergeomPmf(popSize, successes, draws, i);
  }
  return p > 1 ? 1 : p;
}

/// P(caer tierra turnos 1..turn) = P(>=turn tierras entre las 7+turn-1
/// vistas en juego).
double pLandDrops(int nLands, int deckSize, int turn) =>
    hypergeomAtLeast(deckSize, nLands, 7 + turn - 1, turn);

/// P(mano de 2-5 tierras), con UN mulligan modelado: p + (1-p)*p.
double pKeepableHand(int nLands, int deckSize) {
  final p7 = hypergeomAtLeast(deckSize, nLands, 7, 2) -
      hypergeomAtLeast(deckSize, nLands, 7, 6);
  return p7 + (1 - p7) * p7;
}

/// P(>=symbols fuentes de un color entre las 7+turn-1 vistas).
double pColorByTurn(int sources, int deckSize, int turn, int symbols) =>
    hypergeomAtLeast(deckSize, sources, 7 + turn - 1, symbols);
