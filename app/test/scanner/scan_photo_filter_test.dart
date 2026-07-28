/// Arrastrar y soltar en el escáner por foto: solo entran ficheros con
/// pinta de foto (mismo criterio que el selector de fotos).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/scan/scan_screen.dart';

void main() {
  group('looksLikePhotoFile', () {
    test('acepta las extensiones de foto', () {
      expect(looksLikePhotoFile('carta.jpg'), isTrue);
      expect(looksLikePhotoFile('carta.JPEG'), isTrue);
      expect(looksLikePhotoFile('carta.png'), isTrue);
      expect(looksLikePhotoFile('carta.webp'), isTrue);
      expect(looksLikePhotoFile('carta.bmp'), isTrue);
    });

    test('rechaza lo que no es una foto', () {
      expect(looksLikePhotoFile('pelicula.mp4'), isFalse);
      expect(looksLikePhotoFile('coleccion.csv'), isFalse);
      expect(looksLikePhotoFile('sin_extension'), isFalse);
    });
  });
}
