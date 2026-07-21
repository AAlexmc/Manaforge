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

  /// Warps ALTERNATIVOS para celdas de rejilla donde el refinado no
  /// encontró la carta (borde débil, carta muy descentrada en la funda):
  /// hipótesis de posición desplazadas. El matching prueba cada una y se
  /// queda con la que mejor casa contra la base — la geometría no supo
  /// decidir, decide el reconocimiento.
  final List<RgbImage> altWarps;

  const DetectedCard({
    required this.corners,
    required this.warped,
    required this.artCrop,
    required this.usedFallback,
    this.altWarps = const [],
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

  return _rectify(photo, corners, fallback);
}

/// Detecta VARIAS cartas en una foto (página de álbum, cartas sobre la
/// mesa): candidatos puntuados como siempre, se suprimen los CONTENEDORES
/// (un quad con ≥2 candidatos más pequeños dentro es la página, no una
/// carta) y se eligen sin solapes por puntuación. Vacía si nada creíble —
/// aquí NO hay fallback de imagen entera (eso es cosa de [detectCard]).
List<DetectedCard> detectCards(RgbImage photo, {int maxCards = 12}) {
  final maxDim = math.max(photo.width, photo.height);
  final scale = maxDim > 640 ? maxDim / 640 : 1.0;
  final sw = (photo.width / scale).round().clamp(2, photo.width).toInt();
  final sh = (photo.height / scale).round().clamp(2, photo.height).toInt();
  final grey = _greyDownscale(photo, sw, sh);

  // cartas de página de álbum son pequeñas: umbral de área más permisivo
  final scored = _scoredQuads(grey, sw, sh, minAreaFrac: 0.025);
  if (scored.isEmpty) return const [];

  final kept = <(double, List<Pt>)>[];
  for (final c in scored) {
    final area = _quadArea(c.$2);
    final box = _bbox(c.$2);
    var contained = 0;
    for (final other in scored) {
      if (identical(other, c)) continue;
      if (_quadArea(other.$2) >= area * 0.5) continue;
      if (!_bboxHasPoint(box, _quadCenter(other.$2))) continue;
      // la ventana del ARTE de una carta también es un quad interior con
      // proporción de carta: no convierte a su carta en "contenedora"
      if (_looksLikeArtWindow(_bbox(other.$2), box)) continue;
      contained++;
    }
    if (contained == 0) kept.add(c);
  }
  kept.sort((a, b) => b.$1.compareTo(a.$1));

  final picked = <List<Pt>>[];
  for (final (_, q) in kept) {
    if (picked.length >= maxCards) break;
    if (picked.any((p) => _bboxIou(_bbox(p), _bbox(q)) > 0.2)) continue;
    picked.add(q);
  }

  final fx = photo.width / sw;
  final fy = photo.height / sh;
  return [
    for (final q in picked)
      _rectify(photo, [for (final p in q) Pt(p.x * fx, p.y * fy)], false),
  ];
}

/// Detección de REJILLA para páginas de carpeta (binder): 9 cartas 3×3 (o
/// 4×3, etc.) pegadas en fundas. La detección por contornos fusiona cartas
/// contiguas en un blob y las pierde; aquí en cambio se localizan las
/// separaciones entre bolsillos por los VALLES de energía de gradiente
/// (el interior de una carta tiene arte/texto = mucho detalle; el hueco
/// entre cartas es funda lisa = poco), lo que separa cartas pegadas.
///
/// Devuelve las celdas con proporción de carta, rectificadas. Vacío si no
/// se ve una rejilla creíble (≥2 columnas y ≥2 filas).
/// Traza de diagnóstico por celda de la última llamada a [detectCardGrid]
/// ('pass1'/'pass2'/'pass3'/'fallback'). Solo para herramientas de tool/;
/// la app no la lee.
List<String>? gridRefineTrace;

List<DetectedCard> detectCardGrid(RgbImage photo, {int maxCards = 24}) {
  final g = _gridProfiles(photo);
  final colLines = _gridLines(g.gxCol);
  final rowLines = _gridLines(g.gyRow);
  // hace falta al menos un eje con ≥3 líneas (≥2 celdas) regularmente
  // espaciadas para hablar de rejilla
  final colReg = _axisRegularity(colLines);
  final rowReg = _axisRegularity(rowLines);
  if (colReg == null && rowReg == null) return const [];

  // eje ANCLA: el de gaps más regulares. Sus líneas SON las fronteras de
  // celda (las cartas no tienen divisores fuertes en ese eje). Del otro
  // eje solo fío el principio y el fin; el número de celdas y su tamaño
  // los deriva la proporción 63:88.
  const cardRatio = 63 / 88; // ancho/alto
  final bool colIsAnchor;
  if (colReg == null) {
    colIsAnchor = false;
  } else if (rowReg == null) {
    colIsAnchor = true;
  } else {
    colIsAnchor = colReg.cv <= rowReg.cv;
  }

  List<double> xs; // fronteras verticales (columnas)
  List<double> ys; // fronteras horizontales (filas)
  if (colIsAnchor) {
    xs = [for (final l in colLines) l.toDouble()];
    final cellW = colReg!.step;
    final cellH = cellW / cardRatio;
    ys = _deriveLines(rowLines, g.sh, cellH);
  } else {
    ys = [for (final l in rowLines) l.toDouble()];
    final cellH = rowReg!.step;
    final cellW = cellH * cardRatio;
    xs = _deriveLines(colLines, g.sw, cellW);
  }
  if (xs.length < 2 || ys.length < 2) return const [];

  final fx = photo.width / g.sw;
  final fy = photo.height / g.sh;

  // fase 1: refinar cada celda por su cuenta (pasadas 1-3)
  final rects = <List<double>>[]; // cx0, cy0, cx1, cy1 por celda
  final quads = <List<Pt>?>[];
  final passes = <String>[];
  for (var r = 0; r + 1 < ys.length; r++) {
    for (var c = 0; c + 1 < xs.length; c++) {
      if (rects.length >= maxCards) break;
      // la celda es solo APROXIMADA: la carta baila dentro de su funda y la
      // página sale inclinada, así que se afina al contorno real de la carta
      if (debugCellRefine) dbgRejCounts.clear();
      final refined = _refineCellQuad(
          photo, xs[c] * fx, ys[r] * fy, xs[c + 1] * fx, ys[r + 1] * fy);
      if (debugCellRefine) {
        // ignore: avoid_print
        print('  celda ${rects.length}: '
            '${refined == null ? "FALLBACK" : _lastRefinePass} '
            'rej=$dbgRejCounts');
      }
      rects.add([xs[c] * fx, ys[r] * fy, xs[c + 1] * fx, ys[r + 1] * fy]);
      quads.add(refined);
      passes.add(refined == null ? 'fallback' : _lastRefinePass);
    }
  }

  // fase 2: para las celdas donde la geometría NO encontró la carta con
  // confianza (fallback, o el snap amplio de pass3 que a veces se agarra
  // a un borde falso), la posición real es indecidible desde los píxeles
  // de la celda (borde débil, blanco sobre blanco, foto oscura). En vez
  // de apostar por un quad, se emiten HIPÓTESIS: la celda encogida
  // desplazada en rejilla (±4/8/12 % del tamaño de celda) más la plantilla
  // de CONSENSO de las celdas fiables (mediana de sus quads normalizados:
  // captura inclinación de página y tamaño de carta en funda). El matching
  // prueba cada warp contra la base y gana el que mejor casa.
  final anchors = <List<double>>[];
  for (var i = 0; i < quads.length; i++) {
    if (quads[i] == null) continue;
    if (passes[i] != 'pass1' && passes[i] != 'pass2') continue;
    anchors.add(_normQuad(quads[i]!, rects[i]));
  }
  List<double>? template;
  if (anchors.length >= 3) {
    template = List<double>.generate(8, (k) {
      final vals = [for (final a in anchors) a[k]]..sort();
      return vals[vals.length ~/ 2];
    });
  }

  final out = <DetectedCard>[];
  for (var i = 0; i < quads.length; i++) {
    final rc = rects[i];
    final cw = rc[2] - rc[0];
    final ch = rc[3] - rc[1];
    final mx = cw * 0.04;
    final my = ch * 0.04;
    List<Pt> shrunk(double dx, double dy) => [
          Pt(rc[0] + mx + dx * cw, rc[1] + my + dy * ch),
          Pt(rc[2] - mx + dx * cw, rc[1] + my + dy * ch),
          Pt(rc[2] - mx + dx * cw, rc[3] - my + dy * ch),
          Pt(rc[0] + mx + dx * cw, rc[3] - my + dy * ch),
        ];

    final confident = passes[i] == 'pass1' || passes[i] == 'pass2';
    if (confident) {
      gridRefineTrace?.add(passes[i]);
      out.add(_rectify(photo, quads[i]!, false));
      continue;
    }
    final alts = <List<Pt>>[
      for (final d in [-0.08, -0.04, 0.0, 0.04, 0.08])
        for (final e in [-0.08, -0.04, 0.0, 0.04, 0.08])
          if (d != 0.0 || e != 0.0) shrunk(d, e),
      shrunk(0.12, 0), shrunk(-0.12, 0), shrunk(0, 0.12), shrunk(0, -0.12),
      if (template != null) _denormQuad(template, rc),
    ];
    if (quads[i] != null) {
      // pass3: su quad de primaria, y la celda encogida como hipótesis más
      alts.add(shrunk(0, 0));
      gridRefineTrace?.add('pass3+alt');
      out.add(_rectify(photo, quads[i]!, false, altQuads: alts));
    } else {
      gridRefineTrace?.add('fallback+alt');
      out.add(_rectify(photo, shrunk(0, 0), false, altQuads: alts));
    }
  }
  return out;
}

/// Quad en coordenadas normalizadas de su celda [rc] = (cx0,cy0,cx1,cy1):
/// 8 valores (x,y por esquina) en unidades de tamaño de celda.
List<double> _normQuad(List<Pt> q, List<double> rc) {
  final cw = rc[2] - rc[0];
  final ch = rc[3] - rc[1];
  return [
    for (final p in q) ...[(p.x - rc[0]) / cw, (p.y - rc[1]) / ch]
  ];
}

List<Pt> _denormQuad(List<double> n, List<double> rc) {
  final cw = rc[2] - rc[0];
  final ch = rc[3] - rc[1];
  return [
    for (var i = 0; i < 4; i++)
      Pt(rc[0] + n[i * 2] * cw, rc[1] + n[i * 2 + 1] * ch)
  ];
}

/// Afina una celda de rejilla al contorno REAL de su carta: busca el mejor
/// cuadrilátero "con pinta de carta" dentro de la celda expandida un 12%.
/// El desplazamiento de la carta dentro de la funda (±10% es normal) mueve
/// el recorte del arte y arruina el dHash aunque la rejilla sea correcta.
/// Devuelve null si no hay quad creíble (el llamador usa la celda tal cual).
String _lastRefinePass = '';

List<Pt>? _refineCellQuad(
    RgbImage photo, double cx0, double cy0, double cx1, double cy1) {
  _lastRefinePass = 'pass1';
  final cw = cx1 - cx0;
  final ch = cy1 - cy0;
  if (cw < 8 || ch < 8) return null;
  final x0 = (cx0 - cw * 0.12).floor().clamp(0, photo.width - 2);
  final y0 = (cy0 - ch * 0.12).floor().clamp(0, photo.height - 2);
  final x1 = (cx1 + cw * 0.12).ceil().clamp(x0 + 2, photo.width);
  final y1 = (cy1 + ch * 0.12).ceil().clamp(y0 + 2, photo.height);
  final sub = _crop(photo, x0, y0, x1 - x0, y1 - y0);
  final maxDim = math.max(sub.width, sub.height);
  final scale = maxDim > 360 ? maxDim / 360 : 1.0;
  // mínimo 4: _scoredQuads necesita ≥3 px por eje para su Sobel interior
  final sw = (sub.width / scale).round().clamp(4, sub.width).toInt();
  final sh = (sub.height / scale).round().clamp(4, sub.height).toInt();
  final grey = _greyDownscale(sub, sw, sh);

  // pasada 1: sub tal cual. La carta llena ~65% de la celda expandida; se
  // exige ≥55% para no aceptar el borde INTERIOR del marco (~48%).
  // cobertura relajada respecto al detector de foto completa: en la celda
  // hay UNA carta casi centrada seguro, y en fotos oscuras el borde real
  // queda por debajo del 0.45 (el ruido de textura fija el percentil 92)
  var best = _plausibleCardQuad(
      _scoredQuads(grey, sw, sh,
          minAreaFrac: 0.30, covMinSide: 0.30, covMinMean: 0.45),
      sw,
      sh,
      0.55);
  if (best == null) {
    // pasada 2: los trozos de cartas VECINAS que entran por la expansión
    // contaminan las máscaras (el componente toca el borde del sub y el
    // candidato muere por cobertura). Se pinta el anillo fuera de la celda
    // con el tono de la funda y se reintenta sobre el sub limpio.
    final cleaned = Uint8List.fromList(grey);
    final rx0 = ((cx0 - x0) / scale).round().clamp(0, sw - 1).toInt();
    final ry0 = ((cy0 - y0) / scale).round().clamp(0, sh - 1).toInt();
    final rx1 = ((cx1 - x0) / scale).round().clamp(rx0 + 1, sw).toInt();
    final ry1 = ((cy1 - y0) / scale).round().clamp(ry0 + 1, sh).toInt();
    final ring = <int>[];
    for (var yy = 0; yy < sh; yy++) {
      for (var xx = 0; xx < sw; xx++) {
        if (xx >= rx0 && xx < rx1 && yy >= ry0 && yy < ry1) continue;
        ring.add(cleaned[yy * sw + xx]);
      }
    }
    if (ring.isNotEmpty) {
      _lastRefinePass = 'pass2';
      ring.sort();
      final sleeve = ring[ring.length ~/ 2];
      for (var yy = 0; yy < sh; yy++) {
        for (var xx = 0; xx < sw; xx++) {
          if (xx >= rx0 && xx < rx1 && yy >= ry0 && yy < ry1) continue;
          cleaned[yy * sw + xx] = sleeve;
        }
      }
      best = _plausibleCardQuad(
          _scoredQuads(cleaned, sw, sh,
              minAreaFrac: 0.30, covMinSide: 0.30, covMinMean: 0.45),
          sw,
          sh,
          0.50);
    }
  }
  if (best == null) {
    // pasada 3: la carta puede estar tan descentrada que se sale de la
    // celda expandida (o las máscaras no dan quad). Se parte de la CELDA
    // y se desliza cada lado hasta la pared real con el snap de signo
    // (rango amplio); el signo descarta bordes de vecinos y del interior.
    _lastRefinePass = 'pass3';
    return _snapSearchFromCell(photo, cx0, cy0, cx1, cy1);
  }
  best = _snapQuadToEdges(grey, sw, sh, best, strict: true);
  final fx = sub.width / sw;
  final fy = sub.height / sh;
  return [for (final p in best) Pt(x0 + p.x * fx, y0 + p.y * fy)];
}

/// Pasada de rescate: sub grande (celda +30%), quad inicial = la celda tal
/// cual, y snap de signo con rango ±22% del tamaño de celda. Solo se
/// acepta si el resultado mantiene la proporción de carta (±12%).
List<Pt>? _snapSearchFromCell(
    RgbImage photo, double cx0, double cy0, double cx1, double cy1) {
  final cw = cx1 - cx0;
  final ch = cy1 - cy0;
  if (cw < 8 || ch < 8) return null;
  final x0 = (cx0 - cw * 0.30).floor().clamp(0, photo.width - 2);
  final y0 = (cy0 - ch * 0.30).floor().clamp(0, photo.height - 2);
  final x1 = (cx1 + cw * 0.30).ceil().clamp(x0 + 2, photo.width);
  final y1 = (cy1 + ch * 0.30).ceil().clamp(y0 + 2, photo.height);
  final sub = _crop(photo, x0, y0, x1 - x0, y1 - y0);
  final maxDim = math.max(sub.width, sub.height);
  final scale = maxDim > 420 ? maxDim / 420 : 1.0;
  final sw = (sub.width / scale).round().clamp(4, sub.width).toInt();
  final sh = (sub.height / scale).round().clamp(4, sub.height).toInt();
  final grey = _greyDownscale(sub, sw, sh);
  final cell = [
    Pt((cx0 - x0) / scale, (cy0 - y0) / scale),
    Pt((cx1 - x0) / scale, (cy0 - y0) / scale),
    Pt((cx1 - x0) / scale, (cy1 - y0) / scale),
    Pt((cx0 - x0) / scale, (cy1 - y0) / scale),
  ];
  final range = (math.min(cw, ch) * 0.22 / scale).round().clamp(6, 60);
  final snapped =
      _snapQuadToEdges(grey, sw, sh, cell, range: range, strict: true);
  final wBox = _dist(snapped[0], snapped[1]);
  final hBox = _dist(snapped[1], snapped[2]);
  if (hBox < 8) return null;
  final ratio = wBox / hBox;
  if (ratio < 0.716 * 0.88 || ratio > 0.716 * 1.12) return null;
  // consistencia: la carta descentrada DESPLAZA la caja (lados opuestos se
  // mueven igual, suma ≈ 0); un lado solo que se mete hacia dentro es una
  // trampa (el borde de la ventana del arte también es oscuro→claro)
  final ds = List<double>.generate(4, (i) {
    final c0 = cell[i];
    final c1 = cell[(i + 1) % 4];
    final len = _dist(c0, c1);
    if (len < 1) return 0.0;
    final nx = (c1.y - c0.y) / len;
    final ny = -(c1.x - c0.x) / len;
    return (snapped[i].x - c0.x) * nx + (snapped[i].y - c0.y) * ny;
  });
  if ((ds[0] + ds[2]).abs() > 0.06 * ch / scale) return null;
  if ((ds[1] + ds[3]).abs() > 0.06 * cw / scale) return null;
  final fx = sub.width / sw;
  final fy = sub.height / sh;
  return [for (final p in snapped) Pt(x0 + p.x * fx, y0 + p.y * fy)];
}

/// Pulido fino: desliza cada lado del quad por su normal (±12 px) hasta el
/// gradiente perpendicular más fuerte con el SIGNO correcto (de dentro
/// oscuro a fuera claro: marco → funda). El signo descarta el borde
/// interior del marco y los bordes de cartas vecinas (van al revés).
List<Pt> _snapQuadToEdges(Uint8List grey, int sw, int sh, List<Pt> q,
    {int range = 12, bool strict = false}) {
  double sobelDot(double px, double py, double nx, double ny) {
    final x = px.round();
    final y = py.round();
    if (x < 1 || x >= sw - 1 || y < 1 || y >= sh - 1) return 0;
    final i = y * sw + x;
    final gx = -grey[i - sw - 1] - 2 * grey[i - 1] - grey[i + sw - 1] +
        grey[i - sw + 1] + 2 * grey[i + 1] + grey[i + sw + 1];
    final gy = -grey[i - sw - 1] - 2 * grey[i - sw] - grey[i - sw + 1] +
        grey[i + sw - 1] + 2 * grey[i + sw] + grey[i + sw + 1];
    return gx * nx + gy * ny;
  }

  final out = [...q];
  for (var i = 0; i < 4; i++) {
    final p0 = out[i];
    final p1 = out[(i + 1) % 4];
    final dx = p1.x - p0.x;
    final dy = p1.y - p0.y;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len < 4) continue;
    final nx = dy / len; // normal hacia FUERA (quad en orden horario)
    final ny = -dx / len;
    var bestD = 0.0;
    var bestScore = 0.0;
    var zeroScore = 0.0;
    for (var d = -range; d <= range; d++) {
      var score = 0.0;
      var strong = 0;
      const samples = 16;
      for (var s = 0; s < samples; s++) {
        final t = 0.1 + 0.8 * s / (samples - 1); // evita las esquinas
        final dot = sobelDot(
            p0.x + dx * t + nx * d, p0.y + dy * t + ny * d, nx, ny);
        if (dot > 0) score += dot; // solo oscuro→claro hacia fuera
        if (dot > 60) strong++;
      }
      if (d == 0) zeroScore = score;
      // en modo estricto (búsqueda a rango amplio) solo cuenta una
      // posición con borde CONSISTENTE a lo largo del lado: evita que un
      // reflejo o textura puntual arrastre el lado lejos de la celda
      if (strict && strong < 10) continue;
      if (score > bestScore ||
          (score == bestScore && d.abs() < bestD.abs())) {
        bestScore = score;
        bestD = d.toDouble();
      }
    }
    if (strict && bestScore < zeroScore * 1.3) continue;
    if (bestD != 0) {
      out[i] = Pt(p0.x + nx * bestD, p0.y + ny * bestD);
      out[(i + 1) % 4] = Pt(p1.x + nx * bestD, p1.y + ny * bestD);
    }
  }
  return out;
}

/// El mejor quad "que es LA carta de la celda": grande (≥ [minFrac] del
/// sub), centrado, y de entre los válidos el MAYOR (el borde exterior del
/// marco, no el interior; la ventana del arte queda fuera por tamaño).
List<Pt>? _plausibleCardQuad(
    List<(double, List<Pt>)> scored, int sw, int sh, double minFrac) {
  List<Pt>? best;
  var bestArea = 0.0;
  for (final (_, q) in scored) {
    final area = _quadArea(q);
    if (area < minFrac * sw * sh) {
      _rej('plaus-small');
      continue;
    }
    final ctr = _quadCenter(q);
    if ((ctr.x - sw / 2).abs() > 0.15 * sw) {
      _rej('plaus-offx');
      continue;
    }
    if ((ctr.y - sh / 2).abs() > 0.15 * sh) {
      _rej('plaus-offy');
      continue;
    }
    if (area > bestArea) {
      bestArea = area;
      best = q;
    }
  }
  return best;
}

class _AxisReg {
  final double step; // paso mediano entre líneas (tamaño de celda)
  final double cv; // coeficiente de variación de los pasos (0 = perfecto)
  _AxisReg(this.step, this.cv);
}

/// Regularidad del espaciado de un conjunto de líneas: null si hay menos
/// de 3 (no forman rejilla) o si los pasos son demasiado irregulares.
_AxisReg? _axisRegularity(List<int> lines) {
  if (lines.length < 3) return null;
  final gaps = [for (var i = 1; i < lines.length; i++) lines[i] - lines[i - 1]];
  var mean = 0.0;
  for (final gp in gaps) {
    mean += gp / gaps.length;
  }
  if (mean <= 0) return null;
  var varSum = 0.0;
  for (final gp in gaps) {
    varSum += (gp - mean) * (gp - mean);
  }
  final cv = math.sqrt(varSum / gaps.length) / mean;
  if (cv > 0.25) return null; // gaps muy dispares: no es una rejilla limpia
  final sorted = [...gaps]..sort();
  return _AxisReg(sorted[sorted.length ~/ 2].toDouble(), cv);
}

/// Fronteras del eje DERIVADO: del primer al último borde detectado,
/// equiespaciadas por el nº de celdas que predice la proporción de carta.
List<double> _deriveLines(List<int> lines, int extent, double cellSize) {
  final top = lines.isEmpty ? 0.0 : lines.first.toDouble();
  final bottom = lines.isEmpty ? extent.toDouble() : lines.last.toDouble();
  final span = bottom - top;
  final n = (span / cellSize).round();
  if (n < 1) return const [];
  return [for (var k = 0; k <= n; k++) top + span * k / n];
}

/// Salida de diagnóstico de [debugGridProfiles].
class GridDebug {
  final Float64List colE, rowE;
  final double colMin, colMax, rowMin, rowMax;
  final List<(double, double)> colBands, rowBands;
  GridDebug(this.colE, this.rowE, this.colMin, this.colMax, this.rowMin,
      this.rowMax, this.colBands, this.rowBands);
}

/// Expone los perfiles y líneas del detector de rejilla (solo para el
/// harness `tool/grid_debug.dart`).
GridDebug debugGridProfiles(RgbImage photo) {
  final g = _gridProfiles(photo);
  double lo(Float64List p) => p.reduce(math.min);
  double hi(Float64List p) => p.reduce(math.max);
  final cl = _gridLines(g.gxCol);
  final rl = _gridLines(g.gyRow);
  return GridDebug(
      g.gxCol,
      g.gyRow,
      lo(g.gxCol),
      hi(g.gxCol),
      lo(g.gyRow),
      hi(g.gyRow),
      [for (final x in cl) (x.toDouble(), x.toDouble())],
      [for (final y in rl) (y.toDouble(), y.toDouble())]);
}

class _GridProfiles {
  final Float64List gxCol, gyRow;
  final int sw, sh;
  _GridProfiles(this.gxCol, this.gyRow, this.sw, this.sh);
}

/// Perfiles DIRECCIONALES: |gx| por columna (marca los bordes verticales
/// = separadores de columnas) y |gy| por fila (bordes horizontales).
_GridProfiles _gridProfiles(RgbImage photo) {
  final maxDim = math.max(photo.width, photo.height);
  final scale = maxDim > 600 ? maxDim / 600 : 1.0;
  final sw = (photo.width / scale).round().clamp(2, photo.width).toInt();
  final sh = (photo.height / scale).round().clamp(2, photo.height).toInt();
  final grey = _blur3(_greyDownscale(photo, sw, sh), sw, sh);
  final gxCol = Float64List(sw);
  final gyRow = Float64List(sh);
  for (var y = 1; y < sh - 1; y++) {
    for (var x = 1; x < sw - 1; x++) {
      final i = y * sw + x;
      final gx = -grey[i - sw - 1] - 2 * grey[i - 1] - grey[i + sw - 1] +
          grey[i - sw + 1] + 2 * grey[i + 1] + grey[i + sw + 1];
      final gy = -grey[i - sw - 1] - 2 * grey[i - sw] - grey[i - sw + 1] +
          grey[i + sw - 1] + 2 * grey[i + sw] + grey[i + sw + 1];
      gxCol[x] += gx.abs() / sh;
      gyRow[y] += gy.abs() / sw;
    }
  }
  _smooth(gxCol, (sw * 0.01).round().clamp(1, sw));
  _smooth(gyRow, (sh * 0.01).round().clamp(1, sh));
  return _GridProfiles(gxCol, gyRow, sw, sh);
}

/// Posiciones de las LÍNEAS de rejilla en un perfil direccional: máximos
/// locales fuertes (media + 0.6·desv) separados al menos un ~7% del largo
/// (dos separadores de carta no caen más juntos que eso).
List<int> _gridLines(Float64List p) {
  final n = p.length;
  var mean = 0.0;
  for (final v in p) {
    mean += v / n;
  }
  var varSum = 0.0;
  for (final v in p) {
    varSum += (v - mean) * (v - mean);
  }
  final std = math.sqrt(varSum / n);
  final thr = mean + 0.6 * std;
  final minGap = (n * 0.07).round();
  final peaks = <int>[];
  for (var i = 1; i < n - 1; i++) {
    if (p[i] < thr) continue;
    if (p[i] < p[i - 1] || p[i] < p[i + 1]) continue;
    if (peaks.isNotEmpty && i - peaks.last < minGap) {
      if (p[i] > p[peaks.last]) peaks[peaks.length - 1] = i;
      continue;
    }
    peaks.add(i);
  }
  return peaks;
}

/// Media móvil en sitio (radio [r]) para alisar un perfil 1-D.
void _smooth(Float64List p, int r) {
  if (r < 1) return;
  final src = Float64List.fromList(p);
  for (var i = 0; i < p.length; i++) {
    var sum = 0.0;
    var n = 0;
    for (var d = -r; d <= r; d++) {
      final j = i + d;
      if (j < 0 || j >= src.length) continue;
      sum += src[j];
      n++;
    }
    p[i] = sum / n;
  }
}

/// Esquinas (en coordenadas de la foto) → carta rectificada + arte.
DetectedCard _rectify(RgbImage photo, List<Pt> corners, bool fallback,
    {List<List<Pt>> altQuads = const []}) {
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
    corners: corners,
    warped: warped,
    artCrop: art,
    usedFallback: fallback,
    altWarps: [
      for (final q in altQuads) _warp(photo, q, warpedWidth, warpedHeight)
    ],
  );
}

/// Caja envolvente (minX, minY, maxX, maxY) de un cuadrilátero.
(double, double, double, double) _bbox(List<Pt> q) {
  var minX = q.first.x, minY = q.first.y, maxX = q.first.x, maxY = q.first.y;
  for (final p in q) {
    minX = math.min(minX, p.x);
    minY = math.min(minY, p.y);
    maxX = math.max(maxX, p.x);
    maxY = math.max(maxY, p.y);
  }
  return (minX, minY, maxX, maxY);
}

Pt _quadCenter(List<Pt> q) {
  var cx = 0.0, cy = 0.0;
  for (final p in q) {
    cx += p.x / q.length;
    cy += p.y / q.length;
  }
  return Pt(cx, cy);
}

bool _bboxHasPoint((double, double, double, double) b, Pt p) =>
    p.x >= b.$1 && p.x <= b.$3 && p.y >= b.$2 && p.y <= b.$4;

/// ¿[inner] tiene la pinta de la VENTANA DEL ARTE de la carta [outer]?
/// (centrada, pegada arriba, ~36% del área, casi todo el ancho — las
/// proporciones artLeft/artRight/artTop/artBottom con margen). Sirve para
/// no confundir una carta con una "página contenedora" por culpa de su
/// propia ilustración.
bool _looksLikeArtWindow((double, double, double, double) inner,
    (double, double, double, double) outer) {
  final ow = outer.$3 - outer.$1;
  final oh = outer.$4 - outer.$2;
  if (ow <= 0 || oh <= 0) return false;
  final iw = inner.$3 - inner.$1;
  final ih = inner.$4 - inner.$2;
  final areaRatio = (iw * ih) / (ow * oh);
  final cxOff =
      ((inner.$1 + inner.$3) / 2 - (outer.$1 + outer.$3) / 2).abs() / ow;
  final topOff = (inner.$2 - outer.$2) / oh;
  return areaRatio > 0.25 &&
      areaRatio < 0.48 &&
      cxOff < 0.08 &&
      topOff > 0.05 &&
      topOff < 0.22 &&
      iw / ow > 0.70 &&
      iw / ow < 0.95;
}

double _bboxIou(
    (double, double, double, double) a, (double, double, double, double) b) {
  final ix = math.max(
      0.0, math.min(a.$3, b.$3) - math.max(a.$1, b.$1));
  final iy = math.max(
      0.0, math.min(a.$4, b.$4) - math.max(a.$2, b.$2));
  final inter = ix * iy;
  final areaA = (a.$3 - a.$1) * (a.$4 - a.$2);
  final areaB = (b.$3 - b.$1) * (b.$4 - b.$2);
  final union = areaA + areaB - inter;
  return union <= 0 ? 0 : inter / union;
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
bool debugCellRefine = false;
final Map<String, int> dbgRejCounts = {};
void _rej(String r) {
  if (debugCellRefine) dbgRejCounts[r] = (dbgRejCounts[r] ?? 0) + 1;
}

double? _scoreQuad(List<Pt> q, int compSize, int w, int h, Int32List gxa,
    Int32List gya, Uint16List mag, double edgeThr,
    {double minAreaFrac = 0.06,
    double covMinSide = 0.45,
    double covMinMean = 0.60}) {
  final area = _quadArea(q);
  final imgArea = w * h;
  if (area < minAreaFrac * imgArea || area > 0.92 * imgArea) {
    _rej(area < minAreaFrac * imgArea ? 'area<' : 'area>');
    return null;
  }
  final sides = [for (var i = 0; i < 4; i++) _dist(q[i], q[(i + 1) % 4])];
  if (sides.reduce(math.min) < 0.12 * math.min(w, h)) {
    _rej('side-short');
    return null;
  }
  final top = sides[0], right = sides[1], bottom = sides[2], left = sides[3];
  final aLen = (top + bottom) / 2;
  final bLen = (left + right) / 2;
  final ratio = math.min(aLen, bLen) / math.max(aLen, bLen);
  if (ratio < 0.50 || ratio > 0.95) {
    _rej('ratio');
    return null;
  }
  if (math.min(top, bottom) / math.max(top, bottom) < 0.55) {
    _rej('parallel-h');
    return null;
  }
  if (math.min(left, right) / math.max(left, right) < 0.55) {
    _rej('parallel-v');
    return null;
  }
  final fill = compSize / area;
  if (fill < 0.08) {
    _rej('fill');
    return null;
  }
  final covs = [
    for (var i = 0; i < 4; i++)
      _sideCoverage(q[i], q[(i + 1) % 4], gxa, gya, mag, w, h, edgeThr)
  ];
  if (covs.reduce(math.min) < covMinSide) {
    _rej('cov-min');
    return null; // cada lado, borde real
  }
  final meanCov = covs.reduce((a, b) => a + b) / 4;
  if (meanCov < covMinMean) {
    _rej('cov-mean');
    return null;
  }
  // proporción: penalización cuadrática centrada en 63:88 = 0.716
  final dev = (ratio - 0.716).abs() / 0.15;
  final aspectFit = math.max(0.05, 1.0 - dev * dev);
  return area * aspectFit * meanCov;
}

/// Detección multi-hipótesis: candidatos por segmentación de intensidad
/// (Otsu ±, máscaras oscura y clara) y por bordes (Sobel con umbral por
/// percentil), validados y puntuados; gana el mejor. null si nada creíble.
List<Pt>? _findQuad(Uint8List grey, int w, int h) {
  final scored = _scoredQuads(grey, w, h);
  return scored.isEmpty ? null : scored.first.$2;
}

/// Todos los cuadriláteros "con pinta de carta", puntuados y ordenados de
/// mejor a peor (pueden venir casi-duplicados de máscaras distintas: el
/// llamador deduplica por solape si le importa).
List<(double, List<Pt>)> _scoredQuads(Uint8List grey, int w, int h,
    {double minAreaFrac = 0.06,
    double covMinSide = 0.45,
    double covMinMean = 0.60}) {
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
      final s = _scoreQuad(q, comp.length, w, h, gxa, gya, mag, coverageThr,
          minAreaFrac: minAreaFrac,
          covMinSide: covMinSide,
          covMinMean: covMinMean);
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

  candidates.sort((a, b) => b.$1.compareTo(a.$1));
  return candidates;
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
