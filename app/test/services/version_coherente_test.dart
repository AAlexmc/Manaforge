/// La app tiene que saber qué versión es.
///
/// `kAppVersion` se quedó en 0.1.0 mientras la release publicada era la
/// v0.2.0: el manifiesto de las copias de seguridad mentía, y un aviso de
/// "hay versión nueva" comparando contra 0.1.0 saltaría siempre.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/backup.dart';

void main() {
  test('kAppVersion coincide con la de pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final linea = pubspec
        .split('\n')
        .firstWhere((l) => l.startsWith('version:'), orElse: () => '');
    expect(linea, isNotEmpty, reason: 'pubspec.yaml sin version:');

    // "0.3.0+3" -> "0.3.0": el +N es el número de compilación
    final version = linea.split(':')[1].trim().split('+').first;

    expect(kAppVersion, version,
        reason: 'Sube las dos a la vez, y la etiqueta app-v$version de la '
            'release también.');
  });
}
