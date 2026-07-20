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

/// Página de carpeta sintética: rejilla rows×cols de "cartas" (marco
/// oscuro + relleno con textura ruidosa para dar energía de gradiente),
/// separadas por finos huecos de funda clara. Reproduce el caso real de
/// binder: cartas pegadas que la detección por contornos fusiona.
RgbImage _binderPage(int rows, int cols,
    {double cardW = 120,
    double cardH = 168,
    double gap = 10,
    double pad = 30,
    List<(double, double)>? jitter}) {
  final w = (pad * 2 + cols * cardW + (cols - 1) * gap).round();
  final h = (pad * 2 + rows * cardH + (rows - 1) * gap).round();
  final px = Uint8List(w * h * 3);
  final rnd = math.Random(11);
  // fondo de funda: claro y liso (poca energía → separa las cartas)
  for (var i = 0; i < px.length; i++) {
    px[i] = 205 + rnd.nextInt(8);
  }
  void setP(int x, int y, int v) {
    if (x < 0 || x >= w || y < 0 || y >= h) return;
    final i = (y * w + x) * 3;
    px[i] = v;
    px[i + 1] = v;
    px[i + 2] = v;
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      final (jx, jy) = jitter?[r * cols + c] ?? (0.0, 0.0);
      final x0 = (pad + c * (cardW + gap) + jx).round();
      final y0 = (pad + r * (cardH + gap) + jy).round();
      for (var yy = 0; yy < cardH; yy++) {
        for (var xx = 0; xx < cardW; xx++) {
          final onFrame =
              xx < 5 || yy < 5 || xx >= cardW - 5 || yy >= cardH - 5;
          // marco oscuro + interior con textura fuerte (arte)
          final v = onFrame ? 15 : 60 + rnd.nextInt(150);
          setP(x0 + xx, y0 + yy, v);
        }
      }
    }
  }
  return RgbImage(px, w, h);
}

void main() {
  test('página de carpeta 3x3: la rejilla saca las 9 cartas', () {
    final page = _binderPage(3, 3);
    final dets = detectCardGrid(page);
    expect(dets, hasLength(9));
    for (final d in dets) {
      expect(d.warped.width, warpedWidth);
      expect(d.usedFallback, isFalse);
    }
  });

  test('página 4x3: saca 12', () {
    expect(detectCardGrid(_binderPage(4, 3)), hasLength(12));
  });

  test('cartas descentradas en su funda: la caja se ajusta a CADA carta', () {
    // caso real de binder: cada carta baila unos px dentro de su funda; la
    // celda uniforme de la rejilla recorta el arte desplazado y el hash no
    // casa. La caja final debe clavarse al borde de la carta, no a la celda.
    const jit = [
      (-7.0, 4.0), (5.0, -6.0), (0.0, 7.0),
      (6.0, 5.0), (-1.0, -7.0), (7.0, 0.0),
      (-6.0, -4.0), (4.0, 6.0), (-4.0, -5.0),
    ];
    final page = _binderPage(3, 3, jitter: jit);
    final dets = detectCardGrid(page);
    expect(dets, hasLength(9));
    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 3; c++) {
        final (jx, jy) = jit[r * 3 + c];
        final x0 = 30 + c * 130 + jx;
        final y0 = 30 + r * 178 + jy;
        final tc = Pt(x0 + 60, y0 + 84);
        DetectedCard best = dets.first;
        var bestD = double.infinity;
        for (final d in dets) {
          final ct = _center(d);
          final dd = (ct.x - tc.x) * (ct.x - tc.x) +
              (ct.y - tc.y) * (ct.y - tc.y);
          if (dd < bestD) {
            bestD = dd;
            best = d;
          }
        }
        var minX = double.infinity, minY = double.infinity;
        var maxX = -double.infinity, maxY = -double.infinity;
        for (final p in best.corners) {
          minX = math.min(minX, p.x);
          minY = math.min(minY, p.y);
          maxX = math.max(maxX, p.x);
          maxY = math.max(maxY, p.y);
        }
        const tol = 6.0;
        expect((minX - x0).abs(), lessThan(tol),
            reason: 'celda ($r,$c) borde izquierdo');
        expect((minY - y0).abs(), lessThan(tol),
            reason: 'celda ($r,$c) borde superior');
        expect((maxX - (x0 + 120)).abs(), lessThan(tol),
            reason: 'celda ($r,$c) borde derecho');
        expect((maxY - (y0 + 168)).abs(), lessThan(tol),
            reason: 'celda ($r,$c) borde inferior');
      }
    }
  });

  test('una sola carta NO dispara la rejilla (menos de 2x2)', () {
    final photo = _scene(400, 440, [
      (_cardRect(80, 50, w: 240, h: 335), 210),
    ]);
    expect(detectCardGrid(photo), isEmpty);
  });

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
