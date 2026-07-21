// Puerta de presencia del escaneo en vivo: reconocer SOLO cuando se pone
// una carta delante (y se asienta), no cada X ms. También detecta retirada
// (permite pasar dos copias iguales seguidas) y cambio de carta sin vaciar.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:manaforge_app/scanner/presence_gate.dart';

/// Frame sintético uniforme (mesa o carta "plana" de un gris dado).
Uint8List _flat(int value, [int n = 64]) =>
    Uint8List.fromList(List.filled(n, value));

void main() {
  group('PresenceGate', () {
    late PresenceGate gate;

    setUp(() {
      gate = PresenceGate();
      // arranque: mesa vacía estable (fija la línea base)
      expect(gate.feed(_flat(50)), PresenceEvent.none);
      expect(gate.feed(_flat(50)), PresenceEvent.none);
      expect(gate.feed(_flat(50)), PresenceEvent.none);
    });

    test('mesa vacía quieta: nunca dispara', () {
      for (var i = 0; i < 10; i++) {
        expect(gate.feed(_flat(50)), PresenceEvent.none);
      }
      expect(gate.cardPresent, isFalse);
    });

    test('carta puesta y asentada dispara cardPlaced UNA vez', () {
      // la mano entra con la carta: movimiento, aún no dispara
      expect(gate.feed(_flat(120)), PresenceEvent.none);
      // se asienta (frames iguales seguidos) → dispara
      expect(gate.feed(_flat(120)), PresenceEvent.none);
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);
      expect(gate.cardPresent, isTrue);
      // quieta encima de la mesa: NO se re-dispara
      for (var i = 0; i < 10; i++) {
        expect(gate.feed(_flat(120)), PresenceEvent.none);
      }
    });

    test('retirar la carta dispara cardRemoved y rearma la puerta', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);
      // se retira: vuelve la mesa
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      expect(gate.feed(_flat(50)), PresenceEvent.cardRemoved);
      expect(gate.cardPresent, isFalse);
    });

    test('dos copias IGUALES seguidas: dispara dos veces', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      expect(gate.feed(_flat(50)), PresenceEvent.cardRemoved);
      // segunda copia idéntica
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);
    });

    test('cambiar la carta sin vaciar la mesa dispara cardChanged', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);
      // swap: movimiento y se asienta otra carta distinta
      expect(gate.feed(_flat(200)), PresenceEvent.none);
      expect(gate.feed(_flat(200)), PresenceEvent.none);
      expect(gate.feed(_flat(200)), PresenceEvent.cardChanged);
      // y quieta: sin re-disparos
      expect(gate.feed(_flat(200)), PresenceEvent.none);
    });

    test('mano pasando por delante (sin asentarse) no dispara', () {
      expect(gate.feed(_flat(120)), PresenceEvent.none);
      expect(gate.feed(_flat(180)), PresenceEvent.none); // sigue moviéndose
      expect(gate.feed(_flat(90)), PresenceEvent.none);
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      for (var i = 0; i < 5; i++) {
        expect(gate.feed(_flat(50)), PresenceEvent.none);
      }
      expect(gate.cardPresent, isFalse);
    });

    // --- El bug de la carta quieta (2026-07-21) --------------------------

    test('un cambio de brillo pequeño sobre la MISMA carta no es un cambio '
        'de carta', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);

      // algo se mueve delante (una mano, una sombra): marca movimiento
      expect(gate.feed(_flat(140)), PresenceEvent.none);
      // y la escena se asienta otra vez con la MISMA carta, solo que la
      // autoexposición ha subido un poco el brillo
      expect(gate.feed(_flat(128)), PresenceEvent.none);
      expect(gate.feed(_flat(128)), PresenceEvent.none,
          reason: 'sigue siendo la misma carta: no puede contar otra vez');
    });

    test('una sombra que cruza y se va deja la carta como estaba', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);

      // sombra: baja el brillo y vuelve
      gate.feed(_flat(100));
      gate.feed(_flat(100));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.none);
      expect(gate.feed(_flat(120)), PresenceEvent.none);
      expect(gate.cardPresent, isTrue);
    });

    test('una carta quieta un buen rato con la luz cambiando despacio no '
        'dispara ni una vez más', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);

      // una hora bajo la cámara = muchos frames con deriva de exposición
      var brillo = 120;
      for (var i = 0; i < 200; i++) {
        brillo += (i ~/ 20).isEven ? 1 : -1; // sube y baja despacio
        expect(gate.feed(_flat(brillo)), PresenceEvent.none,
            reason: 'frame $i (brillo $brillo) no debería disparar nada');
      }
    });

    test('un frame suelto que parece mesa vacía no rearma la puerta', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);

      // parpadeo: un frame asentado que se parece a la mesa, y vuelta
      gate.feed(_flat(51));
      expect(gate.feed(_flat(51)), PresenceEvent.none,
          reason: 'hace falta más de un frame para dar la carta por retirada');
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.none,
          reason: 'la carta nunca se fue: no puede volver a contar');
    });

    test('retirar la carta de verdad (varios frames) sí rearma', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);

      gate.feed(_flat(50));
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      expect(gate.cardPresent, isFalse);
    });

    test('la línea base no se toca con una carta delante', () {
      gate.feed(_flat(120));
      gate.feed(_flat(120));
      expect(gate.feed(_flat(120)), PresenceEvent.cardPlaced);
      // muchos frames con la carta puesta: si la base se fuera adaptando a
      // la carta, al retirarla la mesa parecería "algo puesto"
      for (var i = 0; i < 50; i++) {
        gate.feed(_flat(120));
      }
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      gate.feed(_flat(50));
      gate.feed(_flat(50));

      expect(gate.cardPresent, isFalse);
      for (var i = 0; i < 5; i++) {
        expect(gate.feed(_flat(50)), PresenceEvent.none);
      }
    });
  });

  group('presenceThumbFromJpeg', () {
    test('decodifica y reduce a la miniatura gris esperada', () {
      // imagen sintética 128x72 gris medio; decodeImage traga PNG igual
      // que el JPEG del pipeline real
      final im = img.Image(width: 128, height: 72);
      img.fill(im, color: img.ColorRgb8(128, 128, 128));
      final thumb =
          presenceThumbFromJpeg(Uint8List.fromList(img.encodePng(im)));
      expect(thumb, isNotNull);
      expect(thumb!.length, PresenceGate.thumbW * PresenceGate.thumbH);
      // luma de un gris (128,128,128) es 128
      expect(thumb.every((p) => (p - 128).abs() <= 2), isTrue);
    });

    test('bytes corruptos devuelven null sin lanzar', () {
      expect(presenceThumbFromJpeg(Uint8List.fromList([1, 2, 3])), isNull);
    });
  });
}
