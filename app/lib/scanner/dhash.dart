/// Huella perceptual del escáner: puerto EXACTO a Dart de
/// `scripts/build_hash_db.py` (dhash_pair) y de las dos operaciones de
/// Pillow de las que depende:
///
/// - `convert("L")`  → [rgbToL] (convert.c: ITU-R 601-2 entera con redondeo)
/// - `resize(LANCZOS)` → [resampleLanczosL] (Resample.c: coeficientes
///   enteros con PRECISION_BITS = 22, pasada horizontal y luego vertical)
///
/// La paridad bit a bit con Python la vigilan dos espejos:
/// - `scripts/tests/test_pil_port.py` (la referencia pura coincide con Pillow)
/// - `app/test/scanner/dhash_parity_test.dart` (este código coincide con las
///   huellas calculadas por Python en los fixtures)
///
/// Los hashes son de 64 bits EXACTOS y se guardan/leen tal cual como
/// INTEGER firmado de SQLite: el `int` de Dart (VM, 64 bits en escritorio)
/// tiene la misma representación en complemento a dos, así que no hay
/// conversión ninguna. (Ojo: esto NO funcionaría en dart2js/web.)
library;

import 'dart:math' as math;
import 'dart:typed_data';

const _precisionBits = 32 - 8 - 2; // Resample.c PRECISION_BITS = 22

/// convert.c rgb2l: L24(rgb) = R*19595 + G*38470 + B*7471 + 0x8000; L >> 16.
int rgbToL(int r, int g, int b) =>
    (r * 19595 + g * 38470 + b * 7471 + 0x8000) >> 16;

double _sinc(double x) {
  if (x == 0.0) return 1.0;
  final y = x * math.pi;
  return math.sin(y) / y;
}

/// Filtro Lanczos de Pillow: soporte 3.0, sinc(x)·sinc(x/3).
double _lanczosFilter(double x) {
  if (-3.0 <= x && x < 3.0) return _sinc(x) * _sinc(x / 3.0);
  return 0.0;
}

const double _lanczosSupport = 3.0;

class _Coeffs {
  final Int32List xmin;
  final Int32List xmax;
  final List<Int32List> kk; // coeficientes enteros por píxel de salida

  _Coeffs(this.xmin, this.xmax, this.kk);
}

/// Resample.c precompute_coeffs + normalize_coeffs_8bpc, calcados.
_Coeffs _precomputeCoeffs(int inSize, int outSize) {
  final scale = inSize / outSize;
  var filterscale = scale;
  if (filterscale < 1.0) filterscale = 1.0;
  final support = _lanczosSupport * filterscale;
  final ksize = (support.ceil()) * 2 + 1;
  final xminOut = Int32List(outSize);
  final xmaxOut = Int32List(outSize);
  final kkOut = <Int32List>[];
  for (var xx = 0; xx < outSize; xx++) {
    final center = (xx + 0.5) * scale;
    var ww = 0.0;
    final ss = 1.0 / filterscale;
    // (int) trunca hacia cero, igual que .toInt()
    var xmin = (center - support + 0.5).toInt();
    if (xmin < 0) xmin = 0;
    var xmax = (center + support + 0.5).toInt();
    if (xmax > inSize) xmax = inSize;
    xmax -= xmin;
    final k = List<double>.filled(ksize, 0.0);
    for (var x = 0; x < xmax; x++) {
      final w = _lanczosFilter((x + xmin - center + 0.5) * ss) * ss;
      k[x] = w;
      ww += w;
    }
    for (var x = 0; x < xmax; x++) {
      if (ww != 0.0) k[x] /= ww;
    }
    // normalize_coeffs_8bpc: double → entero con PRECISION_BITS
    final ki = Int32List(ksize);
    for (var x = 0; x < ksize; x++) {
      final w = k[x];
      ki[x] = w < 0
          ? (-0.5 + w * (1 << _precisionBits)).toInt()
          : (0.5 + w * (1 << _precisionBits)).toInt();
    }
    xminOut[xx] = xmin;
    xmaxOut[xx] = xmax;
    kkOut.add(ki);
  }
  return _Coeffs(xminOut, xmaxOut, kkOut);
}

int _clip8(int ss) {
  final v = ss >> _precisionBits; // aritmético, como en C y Python
  if (v < 0) return 0;
  if (v > 255) return 255;
  return v;
}

/// Resample.c ImagingResample para modo L (8 bits), filtro LANCZOS:
/// pasada horizontal primero (si cambia el ancho) y vertical después.
Uint8List resampleLanczosL(
    Uint8List px, int w, int h, int outW, int outH) {
  var cur = px;
  var curW = w;
  final needH = outW != w;
  final needV = outH != h;

  if (needH) {
    final c = _precomputeCoeffs(w, outW);
    final mid = Uint8List(outW * h);
    for (var yy = 0; yy < h; yy++) {
      for (var xx = 0; xx < outW; xx++) {
        final xmin = c.xmin[xx];
        final xmax = c.xmax[xx];
        final k = c.kk[xx];
        var ss = 1 << (_precisionBits - 1);
        for (var x = 0; x < xmax; x++) {
          ss += cur[yy * curW + xmin + x] * k[x];
        }
        mid[yy * outW + xx] = _clip8(ss);
      }
    }
    cur = mid;
    curW = outW;
  }

  if (needV) {
    final c = _precomputeCoeffs(h, outH);
    final out = Uint8List(curW * outH);
    for (var yy = 0; yy < outH; yy++) {
      final ymin = c.xmin[yy];
      final ymax = c.xmax[yy];
      final k = c.kk[yy];
      for (var xx = 0; xx < curW; xx++) {
        var ss = 1 << (_precisionBits - 1);
        for (var y = 0; y < ymax; y++) {
          ss += cur[(ymin + y) * curW + xx] * k[y];
        }
        out[yy * curW + xx] = _clip8(ss);
      }
    }
    cur = out;
  }

  return cur;
}

/// La firma de una carta: dHash doble (horizontal + vertical), 64 bits cada
/// uno, con los MISMOS bits (complemento a dos) que guarda scan-db en SQLite.
class DHashPair {
  final int h;
  final int v;

  const DHashPair(this.h, this.v);

  /// Distancia total contra otra firma (0..128).
  int distanceTo(DHashPair other) =>
      hamming64(h, other.h) + hamming64(v, other.v);

  @override
  String toString() => 'DHashPair(h: $h, v: $v)';
}

/// dhash_pair de build_hash_db.py sobre una imagen ya en escala de grises.
DHashPair dhashPairFromGrey(Uint8List grey, int w, int h) {
  // horizontal: 9x8, compara columnas vecinas (MSB primero)
  var small = resampleLanczosL(grey, w, h, 9, 8);
  var hh = 0;
  for (var row = 0; row < 8; row++) {
    for (var col = 0; col < 8; col++) {
      final left = small[row * 9 + col];
      final right = small[row * 9 + col + 1];
      hh = (hh << 1) | (left > right ? 1 : 0);
    }
  }
  // vertical: 8x9, compara filas vecinas
  small = resampleLanczosL(grey, w, h, 8, 9);
  var vv = 0;
  for (var col = 0; col < 8; col++) {
    for (var row = 0; row < 8; row++) {
      final top = small[row * 8 + col];
      final bottom = small[(row + 1) * 8 + col];
      vv = (vv << 1) | (top > bottom ? 1 : 0);
    }
  }
  return DHashPair(hh, vv);
}

/// dhash_pair desde RGB entrelazado (r,g,b,r,g,b,…), como convert("L")+hash.
DHashPair dhashPairFromRgb(Uint8List rgb, int w, int h) {
  final grey = Uint8List(w * h);
  for (var i = 0, j = 0; i < grey.length; i++, j += 3) {
    grey[i] = rgbToL(rgb[j], rgb[j + 1], rgb[j + 2]);
  }
  return dhashPairFromGrey(grey, w, h);
}

/// Firmas MULTI-RECORTE del arte de una carta rectificada (480x670 RGB):
/// la ventana del arte se prueba con pequeños desplazamientos y escalas
/// (rejilla ±2 % / ±1.5 %) y el matching se queda con la mejor distancia.
/// Compensa el error de esquinas del detector: en las pruebas de banco
/// bajó la distancia de la carta correcta de ~20 a ~7 bits sin apenas
/// acercar a las incorrectas.
/// Con [compact] se emite una rejilla reducida (9 firmas, solo ±2 % sin
/// escala): para los grupos de HIPÓTESIS de posición del detector de
/// rejilla, donde el desplazamiento grueso ya lo aporta la hipótesis y 75
/// variantes por grupo serían prohibitivas.
List<DHashPair> artSignatures(Uint8List warpedRgb, int w, int h,
    {bool compact = false}) {
  // gris una sola vez; cada variante recorta y hashea sobre el gris
  final grey = Uint8List(w * h);
  for (var i = 0, j = 0; i < grey.length; i++, j += 3) {
    grey[i] = rgbToL(warpedRgb[j], warpedRgb[j + 1], warpedRgb[j + 2]);
  }
  const artL = 0.077, artR = 0.923, artT = 0.117, artB = 0.545;
  final sigs = <DHashPair>[];
  // la variante CENTRAL (sin desplazamiento) va PRIMERO: el matching la
  // usa para la preselección rápida antes de refinar con el resto
  final dxs = compact
      ? const [0.0, -0.02, 0.02]
      : const [0.0, -0.02, -0.01, 0.01, 0.02];
  final dys = compact
      ? const [0.0, -0.02, 0.02]
      : const [0.0, -0.02, -0.01, 0.01, 0.02];
  final scales = compact ? const [0.0] : const [0.0, 0.015, -0.015];
  for (final dx in dxs) {
    for (final dy in dys) {
      for (final s in scales) {
        final x0 = ((artL + dx + s) * w).round().clamp(0, w - 2).toInt();
        final x1 = ((artR + dx - s) * w).round().clamp(x0 + 1, w).toInt();
        final y0 =
            ((artT + dy + s * 0.66) * h).round().clamp(0, h - 2).toInt();
        final y1 =
            ((artB + dy - s * 0.66) * h).round().clamp(y0 + 1, h).toInt();
        final cw = x1 - x0;
        final ch = y1 - y0;
        final crop = Uint8List(cw * ch);
        for (var y = 0; y < ch; y++) {
          crop.setRange(
              y * cw, (y + 1) * cw, grey, (y0 + y) * w + x0);
        }
        sigs.add(dhashPairFromGrey(crop, cw, ch));
      }
    }
  }
  return sigs;
}

/// Distancia de Hamming entre dos enteros de 64 bits (popcount del XOR).
int hamming64(int a, int b) {
  var x = a ^ b;
  x = x - ((x >>> 1) & 0x5555555555555555);
  x = (x & 0x3333333333333333) + ((x >>> 2) & 0x3333333333333333);
  x = (x + (x >>> 4)) & 0x0F0F0F0F0F0F0F0F;
  return (x * 0x0101010101010101) >>> 56;
}
