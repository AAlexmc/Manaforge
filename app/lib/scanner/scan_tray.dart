/// Bandeja de la sesión de escaneo en vivo: acumula lo reconocido agrupando
/// las copias IGUALES en una sola línea con cantidad (×N), igual que ManaBox.
/// Lógica pura (sin UI) para testearla en CI.
///
/// La agrupación es por IMPRESIÓN exacta (set + número de coleccionista): dos
/// ediciones distintas de la misma carta valen distinto, así que van en
/// líneas separadas. Editar la versión de una línea después no la fusiona con
/// otra (caso raro; se prioriza no perder cantidades).
library;

import 'dart:typed_data';

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

  /// SIN identificar: no hubo match creíble, así que la línea NO propone
  /// carta (proponer una equivocada es peor que no decir nada). Enseña el
  /// recorte [artPng] y los candidatos quedan como "mejores apuestas" para
  /// la elección manual; al elegir una, la línea pasa a reconocida.
  bool unrecognized;

  /// Recorte del arte de la celda/foto, para enseñar QUÉ no se reconoció.
  final Uint8List? artPng;

  TrayLine(this.candidates,
      {this.selected = 0,
      this.qty = 1,
      this.confidence = ScanConfidence.confident,
      this.reviewed = false})
      : unrecognized = false,
        artPng = null;

  TrayLine.unrecognized(this.candidates, this.artPng)
      : selected = 0,
        qty = 1,
        confidence = ScanConfidence.none,
        reviewed = false,
        unrecognized = true;

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

  /// Total a añadir: las líneas sin reconocer no cuentan (no se sabe QUÉ
  /// añadir hasta que el usuario elija carta a mano).
  int get totalQty =>
      lines.where((l) => !l.unrecognized).fold(0, (s, l) => s + l.qty);

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
/// lotes), cada una con su recorte de arte para poder enseñarlo. Cada foto
/// pasa por el gate de confianza:
///  - confident, o ambiguous con top-1 creíble (< [kUntrustedMin]) →
///    entra agrupando copias iguales en ×N;
///  - el resto (none, o ambiguous con top-1 en zona de error) → línea
///    "sin reconocer" con el recorte y elección manual. Antes estas celdas
///    entraban con el top-1 (casi seguro erróneo) y el chip "revisar", o
///    se perdían en silencio.
ScanTray buildBatchTray(Iterable<(List<ScanMatch>, Uint8List?)> perPhoto) {
  final tray = ScanTray();
  for (final (matches, artPng) in perPhoto) {
    final decision = decideScan(matches);
    final credible = decision.confidence == ScanConfidence.confident ||
        (decision.confidence == ScanConfidence.ambiguous &&
            matches.first.distance < kUntrustedMin);
    if (credible) {
      tray.add(Recognition(matches, decision.confidence));
    } else {
      tray.lines.add(TrayLine.unrecognized(matches, artPng));
    }
  }
  return tray;
}
