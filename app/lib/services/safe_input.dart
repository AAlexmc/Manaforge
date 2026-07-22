/// Lo que entra de fuera: ficheros que abre el usuario, datos que llegan de
/// una copia restaurada y descargas de red. Todo eso se acota AQUÍ, en
/// funciones puras y testeables, en vez de confiar en que cada pantalla se
/// acuerde.
library;

import 'dart:async';

import 'package:http/http.dart' as http;

/// Algo de fuera que no se acepta, con el mensaje ya escrito para el usuario.
class InputRejected implements Exception {
  final String message;

  const InputRejected(this.message);

  @override
  String toString() => message;
}

/// Tope de un CSV importable. Una colección enorme de 100.000 cartas no llega
/// a 20 MB; el tope está para que arrastrar un fichero equivocado (un vídeo,
/// una imagen de disco) no cuelgue la app leyéndolo entero a memoria y encima
/// metiéndolo en un cuadro de texto.
const int kMaxImportBytes = 50 * 1024 * 1024;

void ensureImportFileSize(int bytes) {
  if (bytes > kMaxImportBytes) {
    throw const InputRejected(
        'Ese archivo es demasiado grande para ser una lista de cartas.');
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
        'La descarga acabó en una dirección insegura y se ha cancelado.');
  }
}

const Set<int> _redirectCodes = {301, 302, 303, 307, 308};

/// GET siguiendo las redirecciones A MANO, comprobando cada salto.
///
/// `package:http` no deja ver a dónde acabó la petición (`response.request`
/// sigue siendo la original), así que la única forma de saber que no se ha
/// bajado a `http` es seguirlas uno mismo.
Future<http.StreamedResponse> secureSend(http.Client client, Uri url,
    {int maxRedirects = 5}) async {
  var actual = url;
  for (var salto = 0; salto <= maxRedirects; salto++) {
    ensureSecureDownload(actual);
    final request = http.Request('GET', actual)..followRedirects = false;
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
          'La descarga redirige a ninguna parte y se ha cancelado.');
    }
    actual = actual.resolve(destino);
  }
  throw const InputRejected(
      'La descarga da demasiadas vueltas y se ha cancelado.');
}

/// Tope de lo que puede ocupar una base descargada. La más gorda (las cartas)
/// ronda los 100 MB comprimidos; con 1 GB hay margen de sobra para años.
const int kMaxDownloadBytes = 1024 * 1024 * 1024;

void ensureDownloadSize(int received) {
  if (received > kMaxDownloadBytes) {
    throw const InputRejected(
        'La descarga es mucho más grande de lo que debería y se ha '
        'cancelado.');
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
