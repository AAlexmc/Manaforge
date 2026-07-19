/// Tests del detector de cartas (contornos + perspectiva + recorte de arte).
///
/// Incluye las ESCENAS de regresión (escena_manta = la foto real de Ale que
/// tumbó al detector v1; escena_madera): fotos compuestas generadas por
/// scripts/tests/make_scene_fixtures.py con esquinas verdaderas y huella
/// del arte prístino en escenas_expected.json.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';

/// Foto sintética: fondo oscuro con una "carta" clara (cuadrilátero convexo
/// definido por sus 4 esquinas), rellena por test de punto-en-polígono.
RgbImage _syntheticPhoto(int w, int h, List<Pt> quad,
    {int bg = 25, int card = 210}) {
  final px = Uint8List(w * h * 3);
  bool inside(double x, double y) {
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

  var i = 0;
  final rnd = math.Random(7);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final v = inside(x.toDouble(), y.toDouble())
          ? card + rnd.nextInt(20)
          : bg + rnd.nextInt(10);
      px[i++] = v;
      px[i++] = v;
      px[i++] = v;
    }
  }
  return RgbImage(px, w, h);
}

void main() {
  test('carta recta: encuentra las 4 esquinas con pocos píxeles de error',
      () {
    const quad = [Pt(80, 50), Pt(320, 50), Pt(320, 385), Pt(80, 385)];
    final photo = _syntheticPhoto(400, 440, quad);
    final result = detectCard(photo);

    expect(result.usedFallback, isFalse);
    for (var i = 0; i < 4; i++) {
      final dx = (result.corners[i].x - quad[i].x).abs();
      final dy = (result.corners[i].y - quad[i].y).abs();
      expect(dx, lessThan(10), reason: 'esquina $i, x');
      expect(dy, lessThan(10), reason: 'esquina $i, y');
    }
  });

  test('carta girada: detecta el cuadrilátero y rectifica en vertical', () {
    // carta rotada ~15°: TL, TR, BR, BL a mano (convexa)
    const quad = [Pt(120, 60), Pt(330, 115), Pt(255, 400), Pt(45, 345)];
    final photo = _syntheticPhoto(420, 460, quad);
    final result = detectCard(photo);

    expect(result.usedFallback, isFalse);
    expect(result.warped.width, warpedWidth);
    expect(result.warped.height, warpedHeight);
    // el interior de la carta rectificada debe ser claro (el material de
    // la carta), no fondo: muestreamos el centro
    final cx = warpedWidth ~/ 2;
    final cy = warpedHeight ~/ 2;
    expect(result.warped.r(cx, cy), greaterThan(150));
  });

  test('carta tumbada (apaisada en la foto): sale rectificada en vertical',
      () {
    const quad = [Pt(40, 90), Pt(380, 90), Pt(380, 330), Pt(40, 330)];
    final photo = _syntheticPhoto(420, 420, quad);
    final result = detectCard(photo);

    expect(result.usedFallback, isFalse);
    expect(result.warped.width, warpedWidth);
    expect(result.warped.height, warpedHeight);
  });

  test('sin carta (imagen plana): cae al fallback con la foto entera', () {
    final px = Uint8List(200 * 150 * 3);
    for (var i = 0; i < px.length; i++) {
      px[i] = 120;
    }
    final result = detectCard(RgbImage(px, 200, 150));

    expect(result.usedFallback, isTrue);
    expect(result.warped.width, warpedWidth);
    expect(result.warped.height, warpedHeight);
  });

  test('el recorte del arte tiene las proporciones de la ventana del arte',
      () {
    const quad = [Pt(80, 50), Pt(320, 50), Pt(320, 385), Pt(80, 385)];
    final result = detectCard(_syntheticPhoto(400, 440, quad));

    final expectedW =
        (artRight * warpedWidth).round() - (artLeft * warpedWidth).round();
    final expectedH =
        (artBottom * warpedHeight).round() - (artTop * warpedHeight).round();
    expect(result.artCrop.width, expectedW);
    expect(result.artCrop.height, expectedH);
  });

  group('escenas de regresión (fotos compuestas realistas)', () {
    const dir = 'test/scanner/fixtures';
    final expected = jsonDecode(File('$dir/escenas_expected.json')
        .readAsStringSync()) as Map<String, dynamic>;

    for (final entry in expected.entries) {
      final e = entry.value as Map<String, dynamic>;

      test('${entry.key}: encuentra la carta donde está', () {
        final decoded =
            img.decodeImage(File('$dir/${entry.key}').readAsBytesSync())!;
        final rgb = decoded.convert(numChannels: 3);
        final photo = RgbImage(
            rgb.getBytes(order: img.ChannelOrder.rgb),
            rgb.width,
            rgb.height);
        final result = detectCard(photo);

        expect(result.usedFallback, isFalse,
            reason: 'no vio la carta en ${entry.key} (el fallo original)');
        final want = [
          for (final c in e['corners'] as List)
            Pt((c[0] as num).toDouble(), (c[1] as num).toDouble())
        ];
        final tol = (e['corner_tolerance'] as num).toDouble();
        // la orientación puede rotar el orden de esquinas: vale cualquiera
        var best = double.infinity;
        for (var r = 0; r < 4; r++) {
          var worst = 0.0;
          for (var i = 0; i < 4; i++) {
            final p = result.corners[(i + r) % 4];
            final dx = (p.x - want[i].x).abs();
            final dy = (p.y - want[i].y).abs();
            worst = math.max(worst, math.max(dx, dy));
          }
          best = math.min(best, worst);
        }
        expect(best, lessThan(tol),
            reason: 'esquinas a $best px de las reales en ${entry.key}');
      });

      test('${entry.key}: la huella del arte detectado casa con la de la DB',
          () {
        final decoded =
            img.decodeImage(File('$dir/${entry.key}').readAsBytesSync())!;
        final rgb = decoded.convert(numChannels: 3);
        final photo = RgbImage(
            rgb.getBytes(order: img.ChannelOrder.rgb),
            rgb.width,
            rgb.height);
        final result = detectCard(photo);
        final sigs = artSignatures(result.warped.pixels,
            result.warped.width, result.warped.height);
        final db = DHashPair(int.parse(e['art_h'] as String),
            int.parse(e['art_v'] as String));
        var bestDist = 999;
        for (final sig in sigs) {
          bestDist = math.min(bestDist, sig.distanceTo(db));
        }
        expect(bestDist,
            lessThanOrEqualTo((e['max_multi_distance'] as num).toInt()),
            reason: 'distancia $bestDist en ${entry.key}: el escáner no '
                'reconocería esta carta');
      });
    }
  });
}
