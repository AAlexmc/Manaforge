/// Gate de confianza del escáner: dado el top-k del matching, decide si hay
/// un ganador CLARO — para enseñar UNA sola carta como ManaBox en Quick Mode
/// en vez de la lista de "¿cuál es?".
///
/// La clave (misma idea que el umbral 4σ de tmikonen y el Quick Mode de
/// ManaBox): NO basta con que el mejor esté cerca; tiene que ganar por
/// MARGEN al siguiente candidato distinto. Un arte que casa casi igual con
/// dos cartas no se auto-acepta: eso es justo cuando hay que preguntar.
///
/// Lógica pura (sin cámara, sin UI) para poder testearla en CI.
library;

import 'hash_index.dart';

/// Cuánta confianza tiene el escáner en el top-1.
enum ScanConfidence {
  /// Ganador claro: enseñar UNA carta (auto-aceptable).
  confident,

  /// Algo plausible pero sin ganador claro: enseñar la lista para elegir.
  ambiguous,

  /// Nada lo bastante cerca: no reconozco carta.
  none,
}

/// Veredicto del gate para un conjunto de candidatos.
class ScanDecision {
  final ScanConfidence confidence;

  /// Los candidatos tal cual (ordenados, el primero es el mejor). Se
  /// conservan siempre, incluso en [ScanConfidence.none], por si el
  /// llamador quiere enseñarlos como "mejores apuestas".
  final List<ScanMatch> candidates;

  const ScanDecision(this.confidence, this.candidates);

  /// El mejor candidato SOLO si hay algo reconocido (confident/ambiguous);
  /// null cuando [confidence] es none.
  ScanMatch? get best =>
      confidence == ScanConfidence.none || candidates.isEmpty
          ? null
          : candidates.first;
}

/// Distancia máxima del top-1 para poder auto-aceptarlo (0..128). Por debajo
/// de esto y con margen, se muestra una sola carta. "alta" (≤14) y "media"
/// (≤26) entran; la carta real de la captura de Ale casaba a ~18 ("media").
const int kAcceptMax = 26;

/// Margen mínimo (d2 − d1) sobre el siguiente candidato DISTINTO para dar el
/// top-1 por ganador claro. Sin este margen, dos cartas de arte parecido se
/// confundirían: mejor preguntar.
const int kMinMargin = 8;

/// Por encima de esta distancia ni el mejor candidato es creíble: no
/// reconozco nada (evita "alucinar" una carta con cualquier foto).
const int kNoMatchMax = 40;

/// Decide qué enseñar a partir del top-k del matching (candidatos distintos
/// por carta, ordenados por distancia ascendente).
ScanDecision decideScan(
  List<ScanMatch> matches, {
  int acceptMax = kAcceptMax,
  int minMargin = kMinMargin,
  int noMatchMax = kNoMatchMax,
}) {
  if (matches.isEmpty) {
    return const ScanDecision(ScanConfidence.none, []);
  }
  final d1 = matches.first.distance;
  if (d1 > noMatchMax) {
    return ScanDecision(ScanConfidence.none, matches);
  }
  // Sin segundo candidato, no hay rival: el margen es "infinito".
  final d2 = matches.length > 1 ? matches[1].distance : 128;
  if (d1 <= acceptMax && (d2 - d1) >= minMargin) {
    return ScanDecision(ScanConfidence.confident, matches);
  }
  return ScanDecision(ScanConfidence.ambiguous, matches);
}
