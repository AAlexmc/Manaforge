/// Lo que entra de fuera: ficheros que abre el usuario, datos que llegan de
/// una copia restaurada y descargas de red. Todo eso se acota AQUÍ, en
/// funciones puras y testeables, en vez de confiar en que cada pantalla se
/// acuerde.
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';

/// Algo de fuera que no se acepta.
///
/// El [message] está en español y sirve de registro y de red de seguridad; lo
/// que ve el usuario sale de [inputRejectedText], que sí sabe en qué idioma
/// tiene la app.
class InputRejected implements Exception {
  final String message;
  final InputRejectedCode code;

  const InputRejected(this.message, {this.code = InputRejectedCode.other});

  @override
  String toString() => message;
}

/// Por qué se ha rechazado algo de fuera.
enum InputRejectedCode {
  /// El CSV que se quiere importar es enorme.
  importTooBig,

  /// La descarga acabó en una dirección que no es https.
  insecureDownload,

  /// Una redirección sin destino.
  redirectNowhere,

  /// Demasiados saltos de redirección.
  tooManyRedirects,

  /// La descarga pesa mucho más de lo que debería.
  downloadTooBig,

  /// Lo descargado no cuadra con la huella publicada.
  badHash,

  /// El fichero elegido de fondo no es una imagen de las aceptadas.
  backgroundNotImage,

  /// La imagen de fondo es demasiado grande.
  backgroundTooBig,

  /// Cualquier otro: se enseña [InputRejected.message] tal cual.
  other,
}

/// El texto de un rechazo, en el idioma del usuario.
String inputRejectedText(AppLocalizations t, InputRejected e) =>
    switch (e.code) {
      InputRejectedCode.importTooBig => t.siImportTooBig,
      InputRejectedCode.insecureDownload => t.siInsecureDownload,
      InputRejectedCode.redirectNowhere => t.siRedirectNowhere,
      InputRejectedCode.tooManyRedirects => t.siTooManyRedirects,
      InputRejectedCode.downloadTooBig => t.siDownloadTooBig,
      InputRejectedCode.badHash => t.siBadHash,
      InputRejectedCode.backgroundNotImage => t.siBackgroundNotImage,
      InputRejectedCode.backgroundTooBig => t.siBackgroundTooBig,
      InputRejectedCode.other => e.message,
    };

/// Tope de un CSV importable. Una colección enorme de 100.000 cartas no llega
/// a 20 MB; el tope está para que arrastrar un fichero equivocado (un vídeo,
/// una imagen de disco) no cuelgue la app leyéndolo entero a memoria y encima
/// metiéndolo en un cuadro de texto.
const int kMaxImportBytes = 50 * 1024 * 1024;

void ensureImportFileSize(int bytes) {
  if (bytes > kMaxImportBytes) {
    throw const InputRejected(
        'Ese archivo es demasiado grande para ser una lista de cartas.',
        code: InputRejectedCode.importTooBig);
  }
}

/// Descargas: la URL con la que se ACABA (tras las redirecciones) tiene que
/// seguir siendo `https`.
///
/// Las bases se piden a una URL fija de GitHub, pero una descarga de release
/// SIEMPRE redirige a su CDN, y `package:http` sigue esas redirecciones a
/// donde le digan — incluido bajar a `http` en claro, sin decir nada. Los
/// ficheros que se bajan los abre después sqlite, que es código nativo: no es
/// un sitio donde valga la pena ahorrarse la comprobación.
void ensureSecureDownload(Uri? finalUrl) {
  if (finalUrl != null && finalUrl.scheme != 'https') {
    throw const InputRejected(
        'La descarga acabó en una dirección insegura y se ha cancelado.',
        code: InputRejectedCode.insecureDownload);
  }
}

const Set<int> _redirectCodes = {301, 302, 303, 307, 308};

/// GET siguiendo las redirecciones A MANO, comprobando cada salto.
///
/// `package:http` no deja ver a dónde acabó la petición (`response.request`
/// sigue siendo la original), así que la única forma de saber que no se ha
/// bajado a `http` es seguirlas uno mismo.
Future<http.StreamedResponse> secureSend(http.Client client, Uri url,
    {int maxRedirects = 5, Map<String, String> headers = const {}}) async {
  var actual = url;
  for (var salto = 0; salto <= maxRedirects; salto++) {
    ensureSecureDownload(actual);
    final request = http.Request('GET', actual)
      ..followRedirects = false
      ..headers.addAll(headers);
    final response = await client.send(request);
    // por código Y por la marca: no todos los clientes marcan `isRedirect`
    if (!response.isRedirect && !_redirectCodes.contains(response.statusCode)) {
      return response;
    }
    final destino = response.headers['location'];
    // el cuerpo de una redirección no interesa, pero hay que consumirlo para
    // no dejar la conexión colgada
    unawaited(response.stream.drain<void>().catchError((Object _) {}));
    if (destino == null) {
      throw const InputRejected(
          'La descarga redirige a ninguna parte y se ha cancelado.',
          code: InputRejectedCode.redirectNowhere);
    }
    actual = actual.resolve(destino);
  }
  throw const InputRejected(
      'La descarga da demasiadas vueltas y se ha cancelado.',
      code: InputRejectedCode.tooManyRedirects);
}

/// Tope de lo que puede ocupar una base descargada. La más gorda (las cartas)
/// ronda los 100 MB comprimidos; con 1 GB hay margen de sobra para años.
const int kMaxDownloadBytes = 1024 * 1024 * 1024;

void ensureDownloadSize(int received) {
  if (received > kMaxDownloadBytes) {
    throw const InputRejected(
        'La descarga es mucho más grande de lo que debería y se ha '
        'cancelado.',
        code: InputRejectedCode.downloadTooBig);
  }
}

/// Hosts de los que se acepta una imagen de carta. Todas las imágenes salen de
/// Scryfall, que es de donde vienen los datos.
const Set<String> kCardImageHosts = {
  'cards.scryfall.io',
  'c1.scryfall.com',
  'c2.scryfall.com',
  'img.scryfall.com',
};

/// La URL de imagen, si es aceptable; null si no.
///
/// Importa porque estas URLs se guardan en `collection.json`, y ese fichero
/// puede venir de una copia restaurada que te haya pasado otra persona: sin
/// filtro, una copia manipulada hace que la app pida sola direcciones
/// arbitrarias al pintar el álbum (delata tu IP) y encima por `http` en claro.
String? safeCardImageUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  if (uri.scheme != 'https') return null;
  if (!kCardImageHosts.contains(uri.host)) return null;
  return url;
}

/// Lee un cuerpo de respuesta PEQUEÑO con tope de verdad, en BYTES.
///
/// Está aquí porque el error es fácil de cometer y difícil de ver: hacer
/// `response.stream.take(64 * 1024)` no limita a 64 KB, limita a 64.000
/// TROZOS, y un trozo puede ser de cualquier tamaño. El tope entonces no
/// existe. Esto corta de verdad, y devuelve null si se pasa: media respuesta
/// no es una respuesta.
Future<String?> readCappedBody(http.StreamedResponse response, int maxBytes) async {
  final buffer = <int>[];
  await for (final chunk in response.stream) {
    buffer.addAll(chunk);
    if (buffer.length > maxBytes) return null;
  }
  try {
    return utf8.decode(buffer, allowMalformed: true);
  } catch (_) {
    return null;
  }
}
