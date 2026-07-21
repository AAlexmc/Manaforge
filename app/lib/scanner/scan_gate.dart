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

/// Una propuesta AMBIGUA cuyo top-1 está a esta distancia o más tampoco es
/// creíble como carta concreta (los matches ERRÓNEOS de fotos reales caen
/// en 28-34): la bandeja la enseña como "sin reconocer" — recorte + elegir
/// a mano — en vez de proponer una carta casi seguro equivocada. Mejor no
/// decir nada que decir mentira.
const int kUntrustedMin = 28;

/// Detalle mínimo (desviación típica de la luminancia) de la ventana del
/// arte para que un recorte pueda ser una carta. Medido sobre fotos reales:
/// las cartas dan 17-57 y una mesa/servilleta 6. Por debajo de esto es una
/// superficie lisa, no un arte — y el índice SIEMPRE devuelve su vecino más
/// cercano, así que una servilleta "casaba" a 25 bits.
const double kMinArtDetail = 12;

/// Veredicto para un frame de VÍDEO, que es un problema distinto al de una
/// foto: en la foto el usuario ha decidido que ahí hay una carta, mientras
/// que la cámara está casi siempre enfocando una mesa vacía.
///
/// Tres reglas de más, las tres por lo mismo — el escáner en vivo se
/// llenaba de cartas inventadas apuntando a un pañuelo:
///  - si el detector NO ha encontrado carta ([cardDetected] false, es decir
///    ha tenido que usar la foto entera), no hay carta que reconocer;
///  - si lo que ha encontrado no tiene detalle de arte ([artDetail] por
///    debajo de [kMinArtDetail]), es un pliegue de tela o una sombra con
///    forma de rectángulo;
///  - una ambigua con el top-1 en zona de error (≥ [kUntrustedMin]) es
///    ruido que se parece vagamente a un arte, no una carta.
ScanDecision decideLiveScan(
  List<ScanMatch> matches, {
  required bool cardDetected,
  double artDetail = double.infinity,
  double minArtDetail = kMinArtDetail,
  int untrustedMin = kUntrustedMin,
}) {
  if (!cardDetected) return ScanDecision(ScanConfidence.none, matches);
  if (artDetail < minArtDetail) {
    return ScanDecision(ScanConfidence.none, matches);
  }
  final decision = decideScan(matches);
  if (decision.confidence == ScanConfidence.ambiguous &&
      matches.first.distance >= untrustedMin) {
    return ScanDecision(ScanConfidence.none, matches);
  }
  return decision;
}

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
