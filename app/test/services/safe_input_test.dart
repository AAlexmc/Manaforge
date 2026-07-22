/// Lo que llega de fuera se acota antes de tocar nada.
library;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/safe_input.dart';

void main() {
  group('ficheros que abre el usuario', () {
    test('un CSV descomunal no se llega a leer', () {
      expect(() => ensureImportFileSize(kMaxImportBytes + 1),
          throwsA(isA<InputRejected>()));
      expect(() => ensureImportFileSize(2 * 1024 * 1024), returnsNormally);
    });
  });

  group('descargas', () {
    test('acabar en http después de una redirección cancela la descarga', () {
      expect(
          () => ensureSecureDownload(
              Uri.parse('http://otro-sitio.example/base.sqlite.gz')),
          throwsA(isA<InputRejected>()));
    });

    test('https sigue valiendo, aunque sea otro host (el CDN de GitHub)', () {
      expect(
          () => ensureSecureDownload(
              Uri.parse('https://objects.githubusercontent.com/x')),
          returnsNormally);
    });

    test('una descarga sin fin se corta', () {
      expect(() => ensureDownloadSize(kMaxDownloadBytes + 1),
          throwsA(isA<InputRejected>()));
    });

    test('una redirección a http se corta antes de bajar nada', () async {
      final client = MockClient((req) async {
        if (req.url.scheme == 'https') {
          return http.Response('', 302,
              headers: {'location': 'http://espejo.example/base.gz'});
        }
        return http.Response('no deberías haber llegado aquí', 200);
      });

      expect(
          () => secureSend(client, Uri.parse('https://github.com/x.gz')),
          throwsA(isA<InputRejected>()));
    });

    test('las redirecciones https normales se siguen (el CDN de GitHub)',
        () async {
      var saltos = 0;
      final client = MockClient((req) async {
        if (req.url.host == 'github.com') {
          saltos++;
          return http.Response('', 302, headers: {
            'location': 'https://objects.githubusercontent.com/base.gz'
          });
        }
        return http.Response('datos', 200);
      });

      final res =
          await secureSend(client, Uri.parse('https://github.com/x.gz'));

      expect(saltos, 1);
      expect(res.statusCode, 200);
    });

    test('un carrusel de redirecciones no da vueltas para siempre', () {
      final client = MockClient((req) async => http.Response('', 302,
          headers: {'location': 'https://vueltas.example/otra'}));

      expect(
          () => secureSend(client, Uri.parse('https://vueltas.example/x')),
          throwsA(isA<InputRejected>()));
    });
  });

  group('imágenes de carta', () {
    test('las de Scryfall por https pasan', () {
      const url = 'https://cards.scryfall.io/normal/front/a/b/abc.jpg';
      expect(safeCardImageUrl(url), url);
    });

    test('otro host no pasa: una copia manipulada no te hace pedir nada', () {
      expect(safeCardImageUrl('https://malo.example/pixel.png'), isNull);
      expect(safeCardImageUrl('http://cards.scryfall.io/x.jpg'), isNull,
          reason: 'ni siquiera Scryfall en claro');
      expect(safeCardImageUrl('file:///etc/passwd'), isNull);
      expect(safeCardImageUrl('no soy una url'), isNull);
      expect(safeCardImageUrl(null), isNull);
    });

    test('una carta restaurada con URL rara se queda sin imagen, no la pide',
        () {
      final card = OwnedCard.fromJson(const {
        'oracleId': 'x',
        'name': 'Carta rara',
        'colors': 'U',
        'qty': 1,
        'imageSmall': 'https://rastreador.example/1x1.png',
        'imageNormal': 'https://cards.scryfall.io/normal/front/a/b/abc.jpg',
      });

      expect(card.imageSmall, isNull);
      expect(card.imageNormal, isNotNull);
    });
  });

  group('leer un cuerpo pequeño con tope de verdad', () {
    http.StreamedResponse _respuesta(List<List<int>> trozos) =>
        http.StreamedResponse(Stream.fromIterable(trozos), 200);

    test('un cuerpo normal se lee entero', () async {
      final body = await readCappedBody(
          _respuesta([utf8.encode('hola '), utf8.encode('mundo')]), 1024);

      expect(body, 'hola mundo');
    });

    test('pasarse del tope devuelve null, no medio cuerpo', () async {
      final body = await readCappedBody(_respuesta([List.filled(100, 65)]), 50);

      expect(body, isNull);
    });

    test('UN trozo gigante también corta (el fallo que esto arregla)',
        () async {
      // `stream.take(64 * 1024)` limitaba a 64.000 TROZOS, no a 64 KB: un
      // solo trozo de 10 MB pasaba el "tope" tan tranquilo
      final body =
          await readCappedBody(_respuesta([List.filled(10 * 1024 * 1024, 65)]),
              64 * 1024);

      expect(body, isNull);
    });

    test('bytes que no son UTF-8 no revientan', () async {
      final body = await readCappedBody(_respuesta([
        [0xC3, 0x28, 0xA0]
      ]), 1024);

      expect(body, isNotNull);
    });
  });
}
