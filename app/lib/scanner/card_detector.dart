/// Detección de la carta en una foto: contornos + rectificación de
/// perspectiva + recorte del arte. Fase B del escáner.
///
/// Pipeline (sin OpenCV, Dart puro sobre buffers de píxeles):
/// 1. reducir la foto (lado mayor ≤ 480 px) y pasar a gris
/// 2. suavizado 3x3 + gradiente de Sobel + umbral adaptativo → bordes
/// 3. dilatación + componente conexa mayor → el contorno dominante
/// 4. envolvente convexa → 4 esquinas (extremos x±y)
/// 5. homografía 4 puntos → carta rectificada en vertical (ratio 63:88)
/// 6. recorte de la ventana del arte (la zona que hashea scan-db, que usa
///    el art_crop de Scryfall)
///
/// Si no aparece ningún cuadrilátero creíble (p. ej. la foto YA es un
/// escaneo recortado de la carta) se usa la imagen entera como carta.
library;

import 'dart:math' as math;
import 'dart:typed_data';

/// Imagen de trabajo mínima: RGB entrelazado + dimensiones.
/// (Independiente de `package:image` para poder testear el detector puro.)
class RgbImage {
  final Uint8List pixels; // r,g,b,r,g,b…
  final int width;
  final int height;

  const RgbImage(this.pixels, this.width, this.height);

  int r(int x, int y) => pixels[(y * width + x) * 3];
  int g(int x, int y) => pixels[(y * width + x) * 3 + 1];
  int b(int x, int y) => pixels[(y * width + x) * 3 + 2];
}

/// Una esquina o punto en coordenadas de la foto original.
class Pt {
  final double x;
  final double y;

  const Pt(this.x, this.y);

  @override
  String toString() =>
      'Pt(${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)})';
}

/// Resultado de la detección.
class DetectedCard {
  /// Esquinas en la foto original: TL, TR, BR, BL (orden de lectura).
  final List<Pt> corners;

  /// Carta rectificada en vertical (63:88).
  final RgbImage warped;

  /// Recorte del arte (la ventana que compara el escáner).
  final RgbImage artCrop;

  /// true si no hubo contorno creíble y se usó la foto entera.
  final bool usedFallback;

  const DetectedCard({
    required this.corners,
    required this.warped,
    required this.artCrop,
    required this.usedFallback,
  });
}

/// Tamaño de la carta rectificada (ratio 63:88 de una carta Magic real).
const warpedWidth = 480;
const warpedHeight = 670;

/// Ventana del arte dentro del marco moderno, como fracción de la carta
/// (aproximación del art_crop de Scryfall; el dHash 9x8 tolera el margen).
const artLeft = 0.077;
const artRight = 0.923;
const artTop = 0.117;
const artBottom = 0.545;

/// Detecta la carta de [photo] y devuelve carta rectificada + arte.
DetectedCard detectCard(RgbImage photo) {
  // 1. reducir + gris
  final maxDim = math.max(photo.width, photo.height);
  final scale = maxDim > 480 ? maxDim / 480 : 1.0;
  final sw = (photo.width / scale).round().clamp(2, photo.width).toInt();
  final sh = (photo.height / scale).round().clamp(2, photo.height).toInt();
  final grey = _greyDownscale(photo, sw, sh);

  // 2-4. bordes → componente mayor → esquinas
  final quad = _findQuad(grey, sw, sh);

  List<Pt> corners;
  bool fallback;
  if (quad == null) {
    corners = [
      const Pt(0, 0),
      Pt(photo.width - 1.0, 0),
      Pt(photo.width - 1.0, photo.height - 1.0),
      Pt(0, photo.height - 1.0),
    ];
    fallback = true;
  } else {
    final fx = photo.width / sw;
    final fy = photo.height / sh;
    corners = [for (final p in quad) Pt(p.x * fx, p.y * fy)];
    fallback = false;
  }

  // la carta se rectifica en VERTICAL: el lado corto debe ser el de arriba;
  // si el cuadrilátero está tumbado, rotamos el orden de esquinas
  final topLen = _dist(corners[0], corners[1]) + _dist(corners[3], corners[2]);
  final sideLen = _dist(corners[0], corners[3]) + _dist(corners[1], corners[2]);
  if (topLen > sideLen) {
    corners = [corners[1], corners[2], corners[3], corners[0]];
  }

  // 5. homografía destino→origen y muestreo bilineal
  final warped = _warp(photo, corners, warpedWidth, warpedHeight);

  // 6. ventana del arte
  final x0 = (artLeft * warpedWidth).round();
  final x1 = (artRight * warpedWidth).round();
  final y0 = (artTop * warpedHeight).round();
  final y1 = (artBottom * warpedHeight).round();
  final art = _crop(warped, x0, y0, x1 - x0, y1 - y0);

  return DetectedCard(
      corners: corners, warped: warped, artCrop: art, usedFallback: fallback);
}

double _dist(Pt a, Pt b) {
  final dx = a.x - b.x;
  final dy = a.y - b.y;
  return math.sqrt(dx * dx + dy * dy);
}

/// Gris + reducción en un paso (media de caja: aquí no hace falta paridad
/// con Pillow, esto es solo para DETECTAR; el hash se calcula aparte).
Uint8List _greyDownscale(RgbImage src, int outW, int outH) {
  final out = Uint8List(outW * outH);
  for (var y = 0; y < outH; y++) {
    final sy0 = y * src.height ~/ outH;
    var sy1 = (y + 1) * src.height ~/ outH;
    if (sy1 <= sy0) sy1 = sy0 + 1;
    for (var x = 0; x < outW; x++) {
      final sx0 = x * src.width ~/ outW;
      var sx1 = (x + 1) * src.width ~/ outW;
      if (sx1 <= sx0) sx1 = sx0 + 1;
      var sum = 0;
      var n = 0;
      for (var sy = sy0; sy < sy1; sy++) {
        for (var sx = sx0; sx < sx1; sx++) {
          final i = (sy * src.width + sx) * 3;
          sum += (src.pixels[i] * 19595 +
                  src.pixels[i + 1] * 38470 +
                  src.pixels[i + 2] * 7471 +
                  0x8000) >>
              16;
          n++;
        }
      }
      out[y * outW + x] = sum ~/ n;
    }
  }
  return out;
}

/// Suavizado 3x3 (media de caja).
Uint8List _blur3(Uint8List grey, int w, int h) {
  final out = Uint8List(w * h);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      var sum = 0;
      var n = 0;
      for (var dy = -1; dy <= 1; dy++) {
        final yy = y + dy;
        if (yy < 0 || yy >= h) continue;
        for (var dx = -1; dx <= 1; dx++) {
          final xx = x + dx;
          if (xx < 0 || xx >= w) continue;
          sum += grey[yy * w + xx];
          n++;
        }
      }
      out[y * w + x] = sum ~/ n;
    }
  }
  return out;
}

/// Umbral de Otsu del histograma (separa carta de fondo por intensidad).
int _otsu(Uint8List grey) {
  final hist = List<int>.filled(256, 0);
  for (final v in grey) {
    hist[v]++;
  }
  final total = grey.length;
  var totalSum = 0;
  for (var i = 0; i < 256; i++) {
    totalSum += i * hist[i];
  }
  var sumB = 0;
  var wB = 0;
  var bestT = 127;
  var bestVar = -1.0;
  for (var t = 0; t < 256; t++) {
    wB += hist[t];
    if (wB == 0) continue;
    final wF = total - wB;
    if (wF == 0) break;
    sumB += t * hist[t];
    final mB = sumB / wB;
    final mF = (totalSum - sumB) / wF;
    final v = wB * wF * (mB - mF) * (mB - mF);
    if (v > bestVar) {
      bestVar = v;
      bestT = t;
    }
  }
  return bestT;
}

/// Componentes conexas (8-conexas) de una máscara binaria, de mayor a
/// menor, hasta [maxComponents] con al menos [minSize] píxeles.
List<List<int>> _components(Uint8List mask, int w, int h,
    {int minSize = 40, int maxComponents = 3}) {
  final label = Int32List(w * h);
  final comps = <List<int>>[];
  var next = 1;
  final stack = <int>[];
  for (var start = 0; start < mask.length; start++) {
    if (mask[start] == 0 || label[start] != 0) continue;
    final comp = <int>[];
    stack.add(start);
    label[start] = next;
    while (stack.isNotEmpty) {
      final i = stack.removeLast();
      comp.add(i);
      final x = i % w;
      final y = i ~/ w;
      for (var dy = -1; dy <= 1; dy++) {
        final yy = y + dy;
        if (yy < 0 || yy >= h) continue;
        for (var dx = -1; dx <= 1; dx++) {
          final xx = x + dx;
          if (xx < 0 || xx >= w) continue;
          final j = yy * w + xx;
          if (mask[j] != 0 && label[j] == 0) {
            label[j] = next;
            stack.add(j);
          }
        }
      }
    }
    next++;
    if (comp.length >= minSize) comps.add(comp);
  }
  comps.sort((a, b) => b.length.compareTo(a.length));
  return comps.length > maxComponents
      ? comps.sublist(0, maxComponents)
      : comps;
}

/// Envolvente convexa del componente → 4 esquinas por extremos x±y.
List<Pt>? _quadFromComponent(List<int> comp, int w) {
  final pts = <Pt>[
    for (final i in comp) Pt((i % w).toDouble(), (i ~/ w).toDouble())
  ];
  final hull = _convexHull(pts);
  if (hull.length < 4) return null;
  var tl = hull.first, tr = hull.first, br = hull.first, bl = hull.first;
  for (final p in hull) {
    if (p.x + p.y < tl.x + tl.y) tl = p;
    if (p.x - p.y > tr.x - tr.y) tr = p;
    if (p.x + p.y > br.x + br.y) br = p;
    if (p.x - p.y < bl.x - bl.y) bl = p;
  }
  return [tl, tr, br, bl];
}

/// Fracción de UN lado del cuadrilátero con gradiente fuerte Y
/// PERPENDICULAR al lado. En fondos con textura (una manta, madera) hay
/// gradiente por todas partes, pero solo el borde real de la carta lo
/// tiene alineado con la normal del lado — este es el discriminador que
/// tumba a los cuadriláteros de textura/sombras.
double _sideCoverage(Pt p0, Pt p1, Int32List gxa, Int32List gya,
    Uint16List mag, int w, int h, double threshold) {
  final nx = -(p1.y - p0.y);
  final ny = p1.x - p0.x;
  final nlen2 = nx * nx + ny * ny;
  if (nlen2 == 0) return 0;
  var covered = 0;
  const samples = 24;
  for (var s = 0; s < samples; s++) {
    final t = (s + 0.5) / samples;
    final x = (p0.x + (p1.x - p0.x) * t).toInt();
    final y = (p0.y + (p1.y - p0.y) * t).toInt();
    var hit = false;
    for (var dy = -2; dy <= 2 && !hit; dy++) {
      final yy = y + dy;
      if (yy < 0 || yy >= h) continue;
      for (var dx = -2; dx <= 2; dx++) {
        final xx = x + dx;
        if (xx < 0 || xx >= w) continue;
        final i = yy * w + xx;
        if (mag[i] <= threshold) continue;
        final gx = gxa[i];
        final gy = gya[i];
        final dot = (gx * nx + gy * ny).toDouble();
        final g2 = (gx * gx + gy * gy).toDouble();
        if (dot * dot >= 0.5 * g2 * nlen2) {
          // |cos| >= ~0.71: el gradiente apunta como la normal del lado
          hit = true;
          break;
        }
      }
    }
    if (hit) covered++;
  }
  return covered / samples;
}

/// Puntuación de "parecido a carta" de un cuadrilátero candidato, o null
/// si no cuela (área, lados, proporción 63:88, relleno, bordes por lado).
double? _scoreQuad(List<Pt> q, int compSize, int w, int h, Int32List gxa,
    Int32List gya, Uint16List mag, double edgeThr) {
  final area = _quadArea(q);
  final imgArea = w * h;
  if (area < 0.06 * imgArea || area > 0.92 * imgArea) return null;
  final sides = [for (var i = 0; i < 4; i++) _dist(q[i], q[(i + 1) % 4])];
  if (sides.reduce(math.min) < 0.12 * math.min(w, h)) return null;
  final top = sides[0], right = sides[1], bottom = sides[2], left = sides[3];
  final aLen = (top + bottom) / 2;
  final bLen = (left + right) / 2;
  final ratio = math.min(aLen, bLen) / math.max(aLen, bLen);
  if (ratio < 0.50 || ratio > 0.95) return null;
  if (math.min(top, bottom) / math.max(top, bottom) < 0.55) return null;
  if (math.min(left, right) / math.max(left, right) < 0.55) return null;
  final fill = compSize / area;
  if (fill < 0.08) return null;
  final covs = [
    for (var i = 0; i < 4; i++)
      _sideCoverage(q[i], q[(i + 1) % 4], gxa, gya, mag, w, h, edgeThr)
  ];
  if (covs.reduce(math.min) < 0.45) return null; // cada lado, borde real
  final meanCov = covs.reduce((a, b) => a + b) / 4;
  if (meanCov < 0.60) return null;
  // proporción: penalización cuadrática centrada en 63:88 = 0.716
  final dev = (ratio - 0.716).abs() / 0.15;
  final aspectFit = math.max(0.05, 1.0 - dev * dev);
  return area * aspectFit * meanCov;
}

/// Detección multi-hipótesis: candidatos por segmentación de intensidad
/// (Otsu ±, máscaras oscura y clara) y por bordes (Sobel con umbral por
/// percentil), validados y puntuados; gana el mejor. null si nada creíble.
List<Pt>? _findQuad(Uint8List grey, int w, int h) {
  final blurred = _blur3(grey, w, h);

  // Sobel: magnitud + dirección; umbral por percentil 92 (con la media,
  // como el v1, la textura del fondo cegaba al detector)
  final mag = Uint16List(w * h);
  final gxa = Int32List(w * h);
  final gya = Int32List(w * h);
  final mags = <int>[];
  for (var y = 1; y < h - 1; y++) {
    for (var x = 1; x < w - 1; x++) {
      final i = y * w + x;
      final gx = -blurred[i - w - 1] - 2 * blurred[i - 1] -
          blurred[i + w - 1] +
          blurred[i - w + 1] +
          2 * blurred[i + 1] +
          blurred[i + w + 1];
      final gy = -blurred[i - w - 1] - 2 * blurred[i - w] -
          blurred[i - w + 1] +
          blurred[i + w - 1] +
          2 * blurred[i + w] +
          blurred[i + w + 1];
      final m = math.min(gx.abs() + gy.abs(), 1020);
      mag[i] = m;
      gxa[i] = gx;
      gya[i] = gy;
      mags.add(m);
    }
  }
  mags.sort();
  final threshold = math.max(40, mags[(mags.length * 0.92).toInt()]);
  final coverageThr = threshold * 0.75;

  final candidates = <(double, List<Pt>)>[];

  void consider(List<List<int>> comps) {
    for (final comp in comps) {
      final q = _quadFromComponent(comp, w);
      if (q == null) continue;
      final s =
          _scoreQuad(q, comp.length, w, h, gxa, gya, mag, coverageThr);
      if (s != null) candidates.add((s, q));
    }
  }

  // 1) máscaras de intensidad alrededor de Otsu (carta oscura sobre fondo
  //    claro y carta clara sobre fondo oscuro)
  final t0 = _otsu(blurred);
  for (final factor in const [0.65, 0.85, 1.0]) {
    final t = (t0 * factor).toInt().clamp(1, 254).toInt();
    final dark = Uint8List(w * h);
    for (var i = 0; i < blurred.length; i++) {
      if (blurred[i] < t) dark[i] = 1;
    }
    consider(_components(dark, w, h));
  }
  final tLight = (t0 * 1.15).toInt().clamp(1, 254).toInt();
  final light = Uint8List(w * h);
  for (var i = 0; i < blurred.length; i++) {
    if (blurred[i] > tLight) light[i] = 1;
  }
  consider(_components(light, w, h));

  // 2) componentes de los propios bordes (dilatados)
  final edge = Uint8List(w * h);
  for (var i = 0; i < mag.length; i++) {
    if (mag[i] > threshold) edge[i] = 1;
  }
  final dil = Uint8List(w * h);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      var on = 0;
      for (var dy = -1; dy <= 1 && on == 0; dy++) {
        final yy = y + dy;
        if (yy < 0 || yy >= h) continue;
        for (var dx = -1; dx <= 1; dx++) {
          final xx = x + dx;
          if (xx < 0 || xx >= w) continue;
          if (edge[yy * w + xx] != 0) {
            on = 1;
            break;
          }
        }
      }
      dil[y * w + x] = on;
    }
  }
  consider(_components(dil, w, h));

  if (candidates.isEmpty) return null;
  candidates.sort((a, b) => b.$1.compareTo(a.$1));
  return candidates.first.$2;
}

double _quadArea(List<Pt> q) {
  var a = 0.0;
  for (var i = 0; i < q.length; i++) {
    final p1 = q[i];
    final p2 = q[(i + 1) % q.length];
    a += p1.x * p2.y - p2.x * p1.y;
  }
  return a.abs() / 2;
}

List<Pt> _convexHull(List<Pt> pts) {
  final sorted = [...pts]..sort((a, b) =>
      a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
  double cross(Pt o, Pt a, Pt b) =>
      (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
  final lower = <Pt>[];
  for (final p in sorted) {
    while (lower.length >= 2 &&
        cross(lower[lower.length - 2], lower.last, p) <= 0) {
      lower.removeLast();
    }
    lower.add(p);
  }
  final upper = <Pt>[];
  for (final p in sorted.reversed) {
    while (upper.length >= 2 &&
        cross(upper[upper.length - 2], upper.last, p) <= 0) {
      upper.removeLast();
    }
    upper.add(p);
  }
  lower.removeLast();
  upper.removeLast();
  return [...lower, ...upper];
}

/// Homografía 4 puntos: del rectángulo destino (0,0)-(w,h) al cuadrilátero
/// origen, y muestreo bilineal de la foto.
RgbImage _warp(RgbImage src, List<Pt> corners, int outW, int outH) {
  // resolver H (8 incógnitas) tal que H·(destino) = origen
  final dst = [
    const Pt(0, 0),
    Pt(outW - 1.0, 0),
    Pt(outW - 1.0, outH - 1.0),
    Pt(0, outH - 1.0),
  ];
  final hm = _homography(dst, corners);

  final out = Uint8List(outW * outH * 3);
  for (var y = 0; y < outH; y++) {
    for (var x = 0; x < outW; x++) {
      final d = hm[6] * x + hm[7] * y + 1.0;
      final sx = (hm[0] * x + hm[1] * y + hm[2]) / d;
      final sy = (hm[3] * x + hm[4] * y + hm[5]) / d;
      final o = (y * outW + x) * 3;
      _bilinear(src, sx, sy, out, o);
    }
  }
  return RgbImage(out, outW, outH);
}

/// Resuelve la homografía que lleva [from] a [to] (8 DOF, h33 = 1) por
/// eliminación gaussiana con pivoteo parcial.
List<double> _homography(List<Pt> from, List<Pt> to) {
  final a = List.generate(8, (_) => List<double>.filled(9, 0));
  for (var i = 0; i < 4; i++) {
    final x = from[i].x, y = from[i].y;
    final u = to[i].x, v = to[i].y;
    a[i * 2]
      ..[0] = x
      ..[1] = y
      ..[2] = 1
      ..[6] = -u * x
      ..[7] = -u * y
      ..[8] = u;
    a[i * 2 + 1]
      ..[3] = x
      ..[4] = y
      ..[5] = 1
      ..[6] = -v * x
      ..[7] = -v * y
      ..[8] = v;
  }
  for (var col = 0; col < 8; col++) {
    var pivot = col;
    for (var row = col + 1; row < 8; row++) {
      if (a[row][col].abs() > a[pivot][col].abs()) pivot = row;
    }
    final tmp = a[col];
    a[col] = a[pivot];
    a[pivot] = tmp;
    final pv = a[col][col];
    if (pv.abs() < 1e-12) continue; // degenerado: quedará identidad parcial
    for (var row = 0; row < 8; row++) {
      if (row == col) continue;
      final f = a[row][col] / pv;
      if (f == 0) continue;
      for (var k = col; k < 9; k++) {
        a[row][k] -= f * a[col][k];
      }
    }
  }
  final hm = List<double>.filled(8, 0);
  for (var i = 0; i < 8; i++) {
    hm[i] = a[i][i].abs() < 1e-12 ? 0 : a[i][8] / a[i][i];
  }
  return hm;
}

void _bilinear(RgbImage src, double sx, double sy, Uint8List out, int o) {
  final x0 = sx.floor();
  final y0 = sy.floor();
  final fx = sx - x0;
  final fy = sy - y0;
  final cx0 = x0.clamp(0, src.width - 1).toInt();
  final cx1 = (x0 + 1).clamp(0, src.width - 1).toInt();
  final cy0 = y0.clamp(0, src.height - 1).toInt();
  final cy1 = (y0 + 1).clamp(0, src.height - 1).toInt();
  for (var c = 0; c < 3; c++) {
    final p00 = src.pixels[(cy0 * src.width + cx0) * 3 + c];
    final p10 = src.pixels[(cy0 * src.width + cx1) * 3 + c];
    final p01 = src.pixels[(cy1 * src.width + cx0) * 3 + c];
    final p11 = src.pixels[(cy1 * src.width + cx1) * 3 + c];
    final top = p00 + (p10 - p00) * fx;
    final bottom = p01 + (p11 - p01) * fx;
    out[o + c] = (top + (bottom - top) * fy).round().clamp(0, 255).toInt();
  }
}

RgbImage _crop(RgbImage src, int x0, int y0, int w, int h) {
  final out = Uint8List(w * h * 3);
  for (var y = 0; y < h; y++) {
    final srcOff = ((y0 + y) * src.width + x0) * 3;
    out.setRange(y * w * 3, (y + 1) * w * 3,
        src.pixels.sublist(srcOff, srcOff + w * 3));
  }
  return RgbImage(out, w, h);
}
