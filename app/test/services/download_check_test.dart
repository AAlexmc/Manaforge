/// Comprobar que lo descargado es lo publicado.
///
/// Las bases las abre sqlite, que es código nativo. Y hay una regla de
/// convivencia que importa tanto como la comprobación: una release SIN huella
/// (las de antes de julio de 2026) tiene que seguir bajándose, o la app se
/// rompe para quien ya la tiene instalada.
library;

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/download_check.dart';
import 'package:manaforge_app/utils/safe_input.dart';

const _asset =
    'https://github.com/AAlexmc/Manaforge/releases/download/card-db-latest/'
    'manaforge_cards.sqlite.gz';

void main() {
  group('dónde está la huella', () {
    test('el SHA256SUMS.txt vive al lado del fichero', () {
      expect(
          sumsUrlFor(_asset).toString(),
          'https://github.com/AAlexmc/Manaforge/releases/download/'
          'card-db-latest/SHA256SUMS.txt');
    });

    test('el nombre del fichero sale de la URL', () {
      expect(assetNameOf(_asset), 'manaforge_cards.sqlite.gz');
    });
  });

  group('leer el SHA256SUMS.txt', () {
    const huella =
        '3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b';

    test('coge la línea de SU fichero, no la primera', () {
      final fichero = '${'0' * 64}  ManaForge-Linux.zip\n'
          '$huella  manaforge_cards.sqlite.gz\n';

      expect(sha256ForAsset(fichero, 'manaforge_cards.sqlite.gz'), huella);
    });

    test('acepta el modo binario de sha256sum (*fichero)', () {
      expect(sha256ForAsset('$huella *manaforge_cards.sqlite.gz',
              'manaforge_cards.sqlite.gz'),
          huella);
    });

    test('si su fichero no está, no hay huella', () {
      expect(sha256ForAsset('$huella  otra-cosa.zip', 'manaforge_cards.sqlite.gz'),
          isNull);
    });

    test('media huella es no tener huella', () {
      expect(sha256ForAsset('abc123  manaforge_cards.sqlite.gz',
              'manaforge_cards.sqlite.gz'),
          isNull);
      expect(sha256ForAsset('', 'manaforge_cards.sqlite.gz'), isNull);
      expect(sha256ForAsset('basura sin sentido', 'x'), isNull);
    });
  });

  group('comparar', () {
    final digest = sha256.convert('hola'.codeUnits);

    test('cuadra: no pasa nada', () {
      expect(
          () => ensureSha256(expected: digest.toString(), actual: digest),
          returnsNormally);
    });

    test('mayúsculas o minúsculas dan igual', () {
      expect(
          () => ensureSha256(
              expected: digest.toString().toUpperCase(), actual: digest),
          returnsNormally);
    });

    test('no cuadra: se corta con un mensaje entendible', () {
      expect(
          () => ensureSha256(expected: '0' * 64, actual: digest),
          throwsA(isA<InputRejected>()));
    });

    test('release SIN huella: se sigue bajando como siempre', () {
      // esta es la que evita romperle la app a quien ya la tiene instalada
      expect(() => ensureSha256(expected: null, actual: digest),
          returnsNormally);
    });
  });
}
