// ignore_for_file: avoid_print
// Debug puntual del refinado de celdas sobre la página sintética del test.
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:manaforge_app/scanner/card_detector.dart';

RgbImage binderPage(int rows, int cols,
    {double cardW = 120,
    double cardH = 168,
    double gap = 10,
    double pad = 30,
    List<(double, double)>? jitter}) {
  final w = (pad * 2 + cols * cardW + (cols - 1) * gap).round();
  final h = (pad * 2 + rows * cardH + (rows - 1) * gap).round();
  final px = Uint8List(w * h * 3);
  final rnd = math.Random(11);
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
          final v = onFrame ? 15 : 60 + rnd.nextInt(150);
          setP(x0 + xx, y0 + yy, v);
        }
      }
    }
  }
  return RgbImage(px, w, h);
}

void main() {
  const jit = [
    (-7.0, 4.0), (5.0, -6.0), (0.0, 7.0),
    (6.0, 5.0), (-1.0, -7.0), (7.0, 0.0),
    (-6.0, -4.0), (4.0, 6.0), (-4.0, -5.0),
  ];
  final page = binderPage(3, 3, jitter: jit);
  final dets = detectCardGrid(page);
  print('${dets.length} celdas');
  for (var i = 0; i < dets.length; i++) {
    final d = dets[i];
    var minX = double.infinity, minY = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity;
    for (final p in d.corners) {
      minX = math.min(minX, p.x);
      minY = math.min(minY, p.y);
      maxX = math.max(maxX, p.x);
      maxY = math.max(maxY, p.y);
    }
    final r = i ~/ 3, c = i % 3;
    final (jx, jy) = jit[r * 3 + c];
    final ex0 = 30 + c * 130 + jx, ey0 = 30 + r * 178 + jy;
    print('celda ($r,$c): bbox '
        '(${minX.toStringAsFixed(1)},${minY.toStringAsFixed(1)})-'
        '(${maxX.toStringAsFixed(1)},${maxY.toStringAsFixed(1)})  '
        'esperado ($ex0,$ey0)-(${ex0 + 120},${ey0 + 168})  '
        'err L=${(minX - ex0).toStringAsFixed(1)} '
        'T=${(minY - ey0).toStringAsFixed(1)} '
        'R=${(maxX - ex0 - 120).toStringAsFixed(1)} '
        'B=${(maxY - ey0 - 168).toStringAsFixed(1)}');
  }
}
