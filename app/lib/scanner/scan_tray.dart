/// Bandeja de la sesión de escaneo en vivo: acumula lo reconocido agrupando
/// las copias IGUALES en una sola línea con cantidad (×N), igual que ManaBox.
/// Lógica pura (sin UI) para testearla en CI.
///
/// La agrupación es por IMPRESIÓN exacta (set + número de coleccionista): dos
/// ediciones distintas de la misma carta valen distinto, así que van en
/// líneas separadas. Editar la versión de una línea después no la fusiona con
/// otra (caso raro; se prioriza no perder cantidades).
library;

import 'burst_controller.dart';
import 'hash_index.dart';
import 'scan_gate.dart';

/// Una línea de la bandeja: una impresión con su cantidad y sus candidatos
/// (por si hay que corregir cuál es).
class TrayLine {
  final List<ScanMatch> candidates;
  int selected;
  int qty;
  final ScanConfidence confidence;

  /// El usuario ya confirmó/corrigió esta línea → deja de pedir revisión.
  bool reviewed;

  TrayLine(this.candidates,
      {this.selected = 0,
      this.qty = 1,
      this.confidence = ScanConfidence.confident,
      this.reviewed = false});

  ScanMatch get chosen => candidates[selected];

  /// Clave de agrupación: carta + impresión elegida (oracle|set|número). Dos
  /// ediciones distintas de la misma carta NO se agrupan (valen distinto).
  String get key => '${chosen.entry.oracleId}|${chosen.entry.printingKey}';

  /// Reconocida sin ganador claro y aún sin confirmar: hay que verificarla.
  bool get needsReview =>
      confidence == ScanConfidence.ambiguous && !reviewed;
}

class ScanTray {
  final List<TrayLine> lines = [];

  int get totalQty => lines.fold(0, (s, l) => s + l.qty);

  /// Añade una carta reconocida. Si ya hay una línea con la misma impresión,
  /// incrementa su cantidad; si no, crea una línea nueva. Devuelve la línea
  /// afectada (para el feedback visual).
  TrayLine add(Recognition rec) {
    final key =
        '${rec.best.entry.oracleId}|${rec.best.entry.printingKey}';
    for (final l in lines) {
      if (l.key == key) {
        l.qty++;
        return l;
      }
    }
    final line = TrayLine(rec.candidates, confidence: rec.confidence);
    lines.add(line);
    return line;
  }

  /// Cambia la cantidad de una línea; a 0 (o menos) la elimina.
  void setQty(TrayLine line, int qty) {
    if (qty <= 0) {
      lines.remove(line);
    } else {
      line.qty = qty;
    }
  }

  void remove(TrayLine line) => lines.remove(line);

  void clear() => lines.clear();
}

/// Construye una bandeja a partir del top-k de VARIAS fotos (escaneo por
/// lotes): cada foto pasa por el gate de confianza; las reconocidas
/// (confident o ambiguous) entran agrupando copias iguales en ×N, las no
/// reconocidas (none) se saltan.
ScanTray buildBatchTray(Iterable<List<ScanMatch>> perPhoto) {
  final tray = ScanTray();
  for (final matches in perPhoto) {
    final decision = decideScan(matches);
    if (decision.confidence != ScanConfidence.none) {
      tray.add(Recognition(matches, decision.confidence));
    }
  }
  return tray;
}
