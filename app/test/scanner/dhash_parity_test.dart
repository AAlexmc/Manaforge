/// TEST ESPEJO de paridad Python↔Dart de la huella del escáner.
///
/// Los fixtures (PNGs + expected_hashes.json) los genera
/// `scripts/tests/make_dart_fixtures.py` con la fórmula REAL de scan-db
/// (build_hash_db.dhash_pair, con Pillow). Aquí decodificamos los MISMOS
/// PNGs y la huella Dart debe coincidir BIT A BIT — si no, el escáner de
/// la app no casaría con la base de huellas publicada.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/dhash.dart';

Uint8List _rgbOf(img.Image im) =>
    im.convert(numChannels: 3).getBytes(order: img.ChannelOrder.rgb);

void main() {
  final fixturesDir = Directory('test/scanner/fixtures');
  final expected = jsonDecode(
          File('${fixturesDir.path}/expected_hashes.json')
              .readAsStringSync()) as Map<String, dynamic>;

  test('hay fixtures y todos tienen huella esperada', () {
    expect(expected, isNotEmpty);
    for (final name in expected.keys) {
      expect(File('${fixturesDir.path}/$name').existsSync(), isTrue,
          reason: 'falta el fixture $name');
    }
  });

  for (final entry in expected.entries) {
    test('paridad bit a bit con Python: ${entry.key}', () {
      final bytes =
          File('${fixturesDir.path}/${entry.key}').readAsBytesSync();
      final decoded = img.decodePng(bytes);
      expect(decoded, isNotNull);
      final sig = dhashPairFromRgb(
          _rgbOf(decoded!), decoded.width, decoded.height);
      final want = entry.value as Map<String, dynamic>;
      expect(sig.h, int.parse(want['h'] as String),
          reason: 'hash horizontal difiere en ${entry.key}');
      expect(sig.v, int.parse(want['v'] as String),
          reason: 'hash vertical difiere en ${entry.key}');
    });
  }

  test('rgbToL replica convert("L") de Pillow (ITU-R 601-2 con redondeo)', () {
    expect(rgbToL(0, 0, 0), 0);
    expect(rgbToL(255, 255, 255), 255);
    expect(rgbToL(128, 128, 128), 128);
    // rojo puro: (255*19595 + 0x8000) >> 16 = 76
    expect(rgbToL(255, 0, 0), 76);
    expect(rgbToL(0, 255, 0), 150);
    expect(rgbToL(0, 0, 255), 29);
  });

  test('resampleLanczosL sin cambio de tamaño devuelve la imagen tal cual',
      () {
    final px = Uint8List.fromList(List.generate(9 * 8, (i) => i * 3 % 256));
    expect(resampleLanczosL(px, 9, 8, 9, 8), px);
  });

  group('hamming64', () {
    test('casos base', () {
      expect(hamming64(0, 0), 0);
      expect(hamming64(0, 1), 1);
      expect(hamming64(-1, 0), 64); // -1 = 64 unos en complemento a dos
      expect(hamming64(-1, -1), 0);
      expect(hamming64(0x5555555555555555, 0), 32);
      // el bit del signo también cuenta
      expect(hamming64(1 << 63, 0), 1);
    });

    test('la distancia entre firmas es simétrica y acotada a 128', () {
      const a = DHashPair(0, 0);
      const b = DHashPair(-1, -1);
      expect(a.distanceTo(b), 128);
      expect(b.distanceTo(a), 128);
      expect(a.distanceTo(a), 0);
    });
  });

  test('mismo arte reescalado: huellas cercanas (Hamming ≤ 10)', () {
    final bytes =
        File('${fixturesDir.path}/art_200x150.png').readAsBytesSync();
    final original = img.decodePng(bytes)!;
    final resized =
        img.copyResize(original, width: 100, height: 75);
    final s1 = dhashPairFromRgb(
        _rgbOf(original), original.width, original.height);
    final s2 =
        dhashPairFromRgb(_rgbOf(resized), resized.width, resized.height);
    expect(s1.distanceTo(s2), lessThanOrEqualTo(10));
  });

  test('artes distintos: huellas lejanas (Hamming > 20)', () {
    final a = img.decodePng(
        File('${fixturesDir.path}/art_200x150.png').readAsBytesSync())!;
    final b = img.decodePng(
        File('${fixturesDir.path}/ruido_97x64.png').readAsBytesSync())!;
    final s1 = dhashPairFromRgb(_rgbOf(a), a.width, a.height);
    final s2 = dhashPairFromRgb(_rgbOf(b), b.width, b.height);
    expect(s1.distanceTo(s2), greaterThan(20));
  });
}
