/// Detección MULTI-carta: una foto de página de álbum (o varias cartas
/// sobre la mesa) debe devolver TODAS las cartas, cada una rectificada,
/// sin que la página contenedora cuele como carta.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/card_detector.dart';

/// Foto sintética con varios cuadriláteros rellenos, pintados en orden
/// (los últimos tapan a los primeros). Cada quad: (esquinas, gris).
RgbImage _scene(int w, int h, List<(List<Pt>, int)> quads, {int bg = 25}) {
  final px = Uint8List(w * h * 3);
  bool inside(List<Pt> quad, double x, double y) {
    var sign = 0;
    for (var i = 0; i < 4; i++) {
      final a = quad[i];
      final b = quad[(i + 1) % 4];
      final cr = (b.x - a.x) * (y - a.y) - (b.y - a.y) * (x - a.x);
      final s = cr > 0 ? 1 : (cr < 0 ? -1 : 0);
      if (s == 0) continue;
      if (sign == 0) {
        sign = s;
      } else if (s != sign) {
        return false;
      }
    }
    return true;
  }

  final rnd = math.Random(7);
  var i = 0;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      var v = bg + rnd.nextInt(10);
      for (final (quad, tone) in quads) {
        if (inside(quad, x.toDouble(), y.toDouble())) {
          v = tone + rnd.nextInt(16);
        }
      }
      px[i++] = v;
      px[i++] = v;
      px[i++] = v;
    }
  }
  return RgbImage(px, w, h);
}

/// Rectángulo de carta (ratio 63:88) como quad tl→tr→br→bl.
List<Pt> _cardRect(double x, double y, {double w = 126, double h = 176}) =>
    [Pt(x, y), Pt(x + w, y), Pt(x + w, y + h), Pt(x, y + h)];

Pt _center(DetectedCard d) {
  var cx = 0.0, cy = 0.0;
  for (final p in d.corners) {
    cx += p.x / 4;
    cy += p.y / 4;
  }
  return Pt(cx, cy);
}

bool _hasNear(List<DetectedCard> dets, double x, double y, double tol) =>
    dets.any((d) {
      final c = _center(d);
      return (c.x - x).abs() < tol && (c.y - y).abs() < tol;
    });

void main() {
  test('tres cartas sueltas en una foto: las encuentra las tres', () {
    final photo = _scene(640, 480, [
      (_cardRect(40, 60), 210),
      (_cardRect(250, 40), 210),
      (_cardRect(470, 80), 210),
    ]);
    final dets = detectCards(photo);
    expect(dets, hasLength(3));
    expect(_hasNear(dets, 40 + 63, 60 + 88, 20), isTrue);
    expect(_hasNear(dets, 250 + 63, 40 + 88, 20), isTrue);
    expect(_hasNear(dets, 470 + 63, 80 + 88, 20), isTrue);
    // cada una rectificada al tamaño estándar
    for (final d in dets) {
      expect(d.warped.width, warpedWidth);
      expect(d.warped.height, warpedHeight);
      expect(d.usedFallback, isFalse);
    }
  });

  test('una sola carta: una detección centrada donde toca', () {
    final photo = _scene(400, 440, [
      (_cardRect(80, 50, w: 240, h: 335), 210),
    ]);
    final dets = detectCards(photo);
    expect(dets, hasLength(1));
    expect(_hasNear(dets, 80 + 120, 50 + 167.5, 15), isTrue);
  });

  test('la página contenedora con cartas dentro NO cuela como carta', () {
    final photo = _scene(
      640,
      480,
      [
        // "página" grande con proporción de carta (contenedor)
        ([const Pt(120, 10), const Pt(460, 10), const Pt(460, 470), const Pt(120, 470)], 60),
        // dos cartas dentro
        (_cardRect(140, 70), 210),
        (_cardRect(310, 230), 210),
      ],
      bg: 230,
    );
    final dets = detectCards(photo);
    expect(dets, hasLength(2));
    expect(_hasNear(dets, 140 + 63, 70 + 88, 20), isTrue);
    expect(_hasNear(dets, 310 + 63, 230 + 88, 20), isTrue);
  });

  test('foto sin cartas: lista vacía, sin fallback de imagen entera', () {
    final photo = _scene(400, 300, const []);
    expect(detectCards(photo), isEmpty);
  });

  test('página con UNA sola carta dentro: sale la carta, no la página', () {
    // página A4-ish (ratio ~0.71, cuela como carta por proporción) con una
    // única carta dentro — el caso que antes exigía ≥2 hijos para suprimir
    final photo = _scene(
      640,
      480,
      [
        ([const Pt(170, 20), const Pt(490, 20), const Pt(490, 466), const Pt(170, 466)], 60),
        (_cardRect(260, 140), 210),
      ],
      bg: 230,
    );
    final dets = detectCards(photo);
    expect(dets, hasLength(1));
    expect(_hasNear(dets, 260 + 63, 140 + 88, 20), isTrue);
  });

  test('la ventana del ARTE dentro de una carta no la convierte en página',
      () {
    // carta con su ilustración marcada (quad interior a proporciones del
    // arte MTG): la carta NO debe suprimirse como contenedora
    const cx = 100.0, cy = 50.0, cw = 240.0, ch = 335.0;
    final art = [
      Pt(cx + 0.077 * cw, cy + 0.117 * ch),
      Pt(cx + 0.923 * cw, cy + 0.117 * ch),
      Pt(cx + 0.923 * cw, cy + 0.545 * ch),
      Pt(cx + 0.077 * cw, cy + 0.545 * ch),
    ];
    final photo = _scene(440, 440, [
      (_cardRect(cx, cy, w: cw, h: ch), 210),
      (art, 120),
    ]);
    final dets = detectCards(photo);
    expect(dets, hasLength(1));
    expect(_hasNear(dets, cx + cw / 2, cy + ch / 2, 15), isTrue);
  });
}
