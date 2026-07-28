/// Dónde y de qué tamaño estaba la ventana.
///
/// Lo que se prueba aquí es el filtro: una ventana guardada mal (un fichero
/// manipulado, un monitor que ya no está, un reloj de otro sistema) no puede
/// dejar la app abierta donde no la ve nadie, que desde fuera se parece
/// mucho a "la app no arranca".
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/window_prefs.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mf-ventana'));
  tearDown(() => dir.deleteSync(recursive: true));

  group('lo que se acepta', () {
    test('una ventana normal pasa tal cual', () {
      final b = saneBounds(width: 1400, height: 900, x: 120, y: 60);

      expect(b!.width, 1400);
      expect(b.height, 900);
      expect(b.x, 120);
      expect(b.y, 60);
    });

    test('una ventana enana se sube al mínimo con el que se puede usar', () {
      final b = saneBounds(width: 200, height: 100);

      expect(b!.width, kMinWindowWidth);
      expect(b.height, kMinWindowHeight);
    });

    test('una ventana disparatada se recorta', () {
      final b = saneBounds(width: 200000, height: 999999);

      expect(b!.width, kMaxWindowSide);
      expect(b.height, kMaxWindowSide);
    });

    test('un monitor a la izquierda tiene coordenadas negativas y vale', () {
      final b = saneBounds(width: 1200, height: 800, x: -1900, y: 40);

      expect(b!.x, -1900);
    });

    test('una posición imposible pierde el SITIO, no el tamaño', () {
      // el monitor de al lado ya no está: la ventana se abriría donde no la
      // ve nadie. Mejor que la coloque el sistema
      final b = saneBounds(width: 1200, height: 800, x: 99999, y: 0);

      expect(b!.x, isNull);
      expect(b.y, isNull);
      expect(b.width, 1200);
    });

    test('sin tamaño no hay nada que recordar', () {
      expect(saneBounds(width: null, height: 800), isNull);
      expect(saneBounds(width: double.nan, height: 800), isNull);
      expect(saneBounds(width: double.infinity, height: 800), isNull);
    });
  });

  group('guardar y volver', () {
    test('el tamaño y el sitio sobreviven a cerrar la app', () async {
      final uno = WindowPreference(dataDir: dir);
      await uno.remember(
          const WindowBounds(width: 1440, height: 910, x: 30, y: 12));

      final otro = WindowPreference(dataDir: dir);
      await otro.load();

      expect(otro.bounds,
          const WindowBounds(width: 1440, height: 910, x: 30, y: 12));
    });

    test('maximizada se recuerda como maximizada', () async {
      final uno = WindowPreference(dataDir: dir);
      await uno.remember(const WindowBounds(
          width: 1200, height: 800, x: 0, y: 0, maximized: true));

      final otro = WindowPreference(dataDir: dir);
      await otro.load();

      expect(otro.bounds!.maximized, isTrue);
      // y el tamaño de antes de maximizar, que es al que se vuelve
      expect(otro.bounds!.width, 1200);
    });

    test('un fichero manipulado no abre la ventana en el limbo', () async {
      File('${dir.path}/window.json').writeAsStringSync(
          '{"width":1200,"height":800,"x":999999,"y":-999999}');

      final prefs = WindowPreference(dataDir: dir);
      await prefs.load();

      expect(prefs.bounds!.x, isNull);
      expect(prefs.bounds!.y, isNull);
    });

    test('un fichero que no es JSON no tumba nada', () async {
      File('${dir.path}/window.json').writeAsStringSync('esto no es json');

      final prefs = WindowPreference(dataDir: dir);
      await prefs.load();

      expect(prefs.bounds, isNull);
    });

    test('arrastrar la ventana escribe en cola y queda el último sitio',
        () async {
      final prefs = WindowPreference(dataDir: dir);
      for (var i = 0; i < 8; i++) {
        // como arrastrar: un aviso detrás de otro, sin esperar
        prefs.remember(
            WindowBounds(width: 1200, height: 800, x: 100 + i * 10, y: 50));
      }
      await prefs.remember(
          const WindowBounds(width: 1200, height: 800, x: 999, y: 50));

      final otro = WindowPreference(dataDir: dir);
      await otro.load();

      expect(otro.bounds!.x, 999);
    });
  });
}
