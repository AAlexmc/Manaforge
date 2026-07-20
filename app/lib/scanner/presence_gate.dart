/// Puerta de presencia del escaneo en vivo: en vez de reconocer cada X ms,
/// el pipeline pesado SOLO corre cuando pones una carta delante y se
/// asienta. También avisa al retirarla (rearma la puerta, así dos copias
/// iguales seguidas cuentan como dos) y al cambiarla sin vaciar la mesa.
///
/// Trabaja sobre miniaturas grises minúsculas (64×36): compararlas cuesta
/// microsegundos, así el muestreo continuo es gratis y el detector+dHash
/// solo corre en los momentos que importan. Lógica pura, testeable en CI.
library;

import 'dart:typed_data';

import 'package:image/image.dart' as img;

enum PresenceEvent {
  none,

  /// Una carta acaba de asentarse sobre la mesa vacía: reconocer AHORA.
  cardPlaced,

  /// Había una carta y se ha cambiado por otra sin vaciar la mesa.
  cardChanged,

  /// La carta se ha retirado: la puerta queda rearmada.
  cardRemoved,
}

class PresenceGate {
  static const int thumbW = 64;
  static const int thumbH = 36;

  /// Diferencia media (0-255) entre frames seguidos para considerar que
  /// algo se MUEVE delante de la cámara.
  final double motionThresh;

  /// Diferencia media contra la mesa vacía para considerar que HAY algo.
  final double presenceThresh;

  /// Frames seguidos sin movimiento para dar la escena por asentada.
  final int settleFrames;

  PresenceGate(
      {this.motionThresh = 6, this.presenceThresh = 10, this.settleFrames = 2});

  List<double>? _baseline; // la mesa vacía (EMA lenta)
  Uint8List? _prev;
  Uint8List? _snapshot; // la carta asentada actual (para detectar swap)
  int _stable = 0;
  bool _present = false;
  bool _movedSinceSettle = false;

  bool get cardPresent => _present;

  PresenceEvent feed(Uint8List gray) {
    final prev = _prev;
    _prev = gray;
    if (prev == null) {
      _baseline = [for (final p in gray) p.toDouble()];
      return PresenceEvent.none;
    }
    final motion = _diff(gray, prev);
    if (motion > motionThresh) {
      _stable = 0;
      if (_present) _movedSinceSettle = true;
      return PresenceEvent.none;
    }
    _stable++;
    if (_stable < settleFrames) return PresenceEvent.none;

    final presence = _diffBaseline(gray);
    if (!_present) {
      if (presence > presenceThresh) {
        _present = true;
        _movedSinceSettle = false;
        _snapshot = gray;
        return PresenceEvent.cardPlaced;
      }
      // mesa vacía y quieta: refrescar la línea base despacio (luz que
      // cambia, autoexposición de la cámara…)
      _updateBaseline(gray);
      return PresenceEvent.none;
    }
    // había carta:
    if (presence < presenceThresh * 0.5) {
      _present = false;
      _snapshot = null;
      return PresenceEvent.cardRemoved;
    }
    if (_movedSinceSettle) {
      _movedSinceSettle = false;
      final snapshot = _snapshot;
      if (snapshot != null && _diff(gray, snapshot) > presenceThresh) {
        _snapshot = gray;
        return PresenceEvent.cardChanged;
      }
    }
    return PresenceEvent.none;
  }

  double _diff(Uint8List a, Uint8List b) {
    final n = a.length < b.length ? a.length : b.length;
    if (n == 0) return 0;
    var sum = 0;
    for (var i = 0; i < n; i++) {
      sum += (a[i] - b[i]).abs();
    }
    return sum / n;
  }

  double _diffBaseline(Uint8List a) {
    final base = _baseline;
    if (base == null || base.isEmpty) return 0;
    final n = a.length < base.length ? a.length : base.length;
    var sum = 0.0;
    for (var i = 0; i < n; i++) {
      sum += (a[i] - base[i]).abs();
    }
    return sum / n;
  }

  void _updateBaseline(Uint8List gray) {
    const alpha = 0.1;
    final base = _baseline;
    if (base == null || base.length != gray.length) {
      _baseline = [for (final p in gray) p.toDouble()];
      return;
    }
    for (var i = 0; i < base.length; i++) {
      base[i] += alpha * (gray[i] - base[i]);
    }
  }
}

/// JPEG (o cualquier imagen) → miniatura gris para la puerta. Función de
/// nivel superior para poder correrla con compute() fuera del hilo de UI.
Uint8List? presenceThumbFromJpeg(Uint8List bytes) {
  final img.Image? decoded;
  try {
    decoded = img.decodeImage(bytes);
  } catch (_) {
    return null;
  }
  if (decoded == null) return null;
  final small = img.copyResize(decoded,
      width: PresenceGate.thumbW,
      height: PresenceGate.thumbH,
      interpolation: img.Interpolation.average);
  final out = Uint8List(PresenceGate.thumbW * PresenceGate.thumbH);
  var i = 0;
  for (final p in small) {
    out[i++] = img.getLuminance(p).round().clamp(0, 255);
  }
  return out;
}
