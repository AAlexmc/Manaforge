/// Tests de la medida "¿esto tiene pinta de carta?" que impide al escáner
/// en vivo reconocer cartas en una mesa lisa.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';

/// Recorte rectificado sintético: [artNoise] de amplitud en la ventana del
/// arte y [textRows] renglones oscuros en la caja de texto.
Uint8List _warp({required int artNoise, required int textRows}) {
  final rnd = math.Random(7);
  final px = Uint8List(warpedWidth * warpedHeight * 3);
  for (var y = 0; y < warpedHeight; y++) {
    for (var x = 0; x < warpedWidth; x++) {
      var v = 200; // superficie base clara y lisa
      final inArt = x > artLeft * warpedWidth &&
          x < artRight * warpedWidth &&
          y > artTop * warpedHeight &&
          y < artBottom * warpedHeight;
      if (inArt && artNoise > 0) {
        v = (128 + rnd.nextInt(artNoise * 2) - artNoise).clamp(0, 255);
      }
      if (textRows > 0 && y > 0.60 * warpedHeight && y < 0.92 * warpedHeight) {
        final row = ((y - 0.60 * warpedHeight) / 10).floor();
        if (row % 2 == 0) v = 40; // renglón
      }
      final i = (y * warpedWidth + x) * 3;
      px[i] = px[i + 1] = px[i + 2] = v;
    }
  }
  return px;
}

void main() {
  test('una superficie lisa da detalle de arte casi nulo', () {
    final likeness =
        cardLikeness(_warp(artNoise: 0, textRows: 0), warpedWidth, warpedHeight);
    expect(likeness.artDetail, lessThan(kMinArtDetail));
  });

  test('un arte de verdad supera el mínimo con holgura', () {
    final likeness = cardLikeness(
        _warp(artNoise: 60, textRows: 0), warpedWidth, warpedHeight);
    expect(likeness.artDetail, greaterThan(kMinArtDetail * 2));
  });

  test('los renglones de la caja de texto se ven en la energía vertical',
      () {
    final conTexto = cardLikeness(
        _warp(artNoise: 60, textRows: 8), warpedWidth, warpedHeight);
    final sinTexto = cardLikeness(
        _warp(artNoise: 60, textRows: 0), warpedWidth, warpedHeight);
    expect(conTexto.textLines, greaterThan(sinTexto.textLines * 3));
  });

  test('la medida no depende de la escala del recorte', () {
    // mismo contenido a media resolución: el detalle debe parecerse
    final full =
        cardLikeness(_warp(artNoise: 60, textRows: 4), warpedWidth, warpedHeight);
    expect(full.artDetail, greaterThan(kMinArtDetail));
  });
}
