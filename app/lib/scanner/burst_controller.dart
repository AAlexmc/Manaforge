/// Cerebro del escaneo en vivo (fase C): decide cuándo lo que ve la cámara
/// se convierte en una carta RECONOCIDA para la cola de confirmación.
///
/// Es lógica pura (sin cámara, sin UI) para poder testearla en CI:
/// la pantalla le da los candidatos de cada frame y él aplica las reglas
/// del modo ráfaga:
///
/// 1. Un frame solo cuenta si su mejor candidato está lo bastante cerca
///    (distancia Hamming ≤ [maxDistance]).
/// 2. Hacen falta [stableFrames] frames SEGUIDOS con la misma carta para
///    reconocerla (evita falsos positivos al mover la carta).
/// 3. Tras reconocer una carta no se vuelve a reconocer LA MISMA hasta que
///    haya pasado por delante otra cosa ([gapFrames] frames sin ella:
///    mesa vacía, otra carta…). Así puedes dejar la carta quieta sin que
///    se añada veinte veces, y escanear 4 copias pasándolas una a una.
library;

import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';

/// Una carta reconocida en vivo, lista para la cola de confirmación.
class Recognition {
  /// Candidatos del frame que disparó el reconocimiento (top-3): el
  /// primero es el elegido por defecto, el resto alternativas en la cola.
  final List<ScanMatch> candidates;

  /// Confianza del gate: [ScanConfidence.confident] = ganador claro (se
  /// puede auto-añadir); [ScanConfidence.ambiguous] = reconocida pero hay
  /// que revisar la versión. Nunca es none (esos frames no disparan).
  final ScanConfidence confidence;

  const Recognition(this.candidates, this.confidence);

  ScanMatch get best => candidates.first;
}

class BurstController {
  /// Distancia Hamming del top-1 por encima de la cual no se reconoce nada
  /// (ruido, mesa vacía). Se pasa a [decideScan] como su noMatchMax.
  final int noMatchMax;

  /// Umbral de auto-aceptación del gate (ver [decideScan]).
  final int acceptMax;

  /// Margen mínimo sobre el 2º candidato para dar por claro el ganador.
  final int minMargin;

  /// Frames seguidos con la misma carta para darla por reconocida.
  final int stableFrames;

  /// Frames sin ver una carta para poder volver a reconocerla.
  final int gapFrames;

  BurstController({
    this.noMatchMax = kNoMatchMax,
    this.acceptMax = kAcceptMax,
    this.minMargin = kMinMargin,
    this.stableFrames = 2,
    this.gapFrames = 3,
  })  : assert(stableFrames >= 1),
        assert(gapFrames >= 1);

  String? _streakOracle; // carta vista en frames consecutivos
  int _streak = 0;
  String? _lastRecognized; // última reconocida (bloqueada hasta el gap)
  int _framesSinceLastSeen = 0; // frames sin ver a _lastRecognized

  /// Procesa los candidatos de un frame. Devuelve la carta reconocida en
  /// este frame, o null (nada nuevo).
  Recognition? feed(List<ScanMatch> matches) {
    final decision = decideScan(matches,
        acceptMax: acceptMax, minMargin: minMargin, noMatchMax: noMatchMax);
    final best = decision.best;
    final seen = best != null; // best es null solo cuando confidence == none
    final oracle = seen ? best.entry.oracleId : null;

    // gestión del bloqueo anti-duplicados
    if (_lastRecognized != null) {
      if (oracle == _lastRecognized) {
        _framesSinceLastSeen = 0;
      } else {
        _framesSinceLastSeen++;
        if (_framesSinceLastSeen >= gapFrames) _lastRecognized = null;
      }
    }

    if (oracle == null) {
      _streakOracle = null;
      _streak = 0;
      return null;
    }

    // racha de frames con la misma carta
    if (oracle == _streakOracle) {
      _streak++;
    } else {
      _streakOracle = oracle;
      _streak = 1;
    }

    if (_streak < stableFrames) return null;
    if (oracle == _lastRecognized) return null; // bloqueada, sin gap aún

    _lastRecognized = oracle;
    _framesSinceLastSeen = 0;
    _streak = 0;
    _streakOracle = null;
    return Recognition(matches, decision.confidence);
  }

  /// Olvida el estado (al pausar/cerrar la cámara).
  void reset() {
    _streakOracle = null;
    _streak = 0;
    _lastRecognized = null;
    _framesSinceLastSeen = 0;
  }
}
