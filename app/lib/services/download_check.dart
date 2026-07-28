/// Comprobar que una base descargada es la que se publicó.
///
/// Las bases (cartas, huellas, precios) se bajan de una release de GitHub y
/// las abre **sqlite**, que es código nativo: no es un sitio donde valga la
/// pena confiar en que por el camino no ha pasado nada. Desde 2026-07-22 cada
/// release publica un `SHA256SUMS.txt` al lado del fichero.
///
/// Regla de convivencia: si la release **no** trae huella (las publicadas
/// antes de esa fecha), la descarga sigue como siempre. Romper la app a quien
/// ya la tiene instalada, por una huella que aún no existe, sería peor que el
/// problema que se quiere evitar. En cuanto el workflow vuelve a correr, la
/// huella está y se comprueba.
library;

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:manaforge_app/services/safe_input.dart';

/// La URL del `SHA256SUMS.txt` que acompaña a [assetUrl] (mismo release).
///
/// `.../download/card-db-latest/manaforge_cards.sqlite.gz`
///   -> `.../download/card-db-latest/SHA256SUMS.txt`
Uri sumsUrlFor(String assetUrl) {
  final uri = Uri.parse(assetUrl);
  final segments = [...uri.pathSegments];
  if (segments.isEmpty) return uri;
  segments[segments.length - 1] = 'SHA256SUMS.txt';
  return uri.replace(pathSegments: segments);
}

/// El nombre de fichero de una URL de descarga.
String assetNameOf(String assetUrl) {
  final segments = Uri.parse(assetUrl).pathSegments;
  return segments.isEmpty ? '' : segments.last;
}

/// Busca en un `SHA256SUMS.txt` la huella de [assetName].
///
/// El formato es el de `sha256sum`: `<64 hex>  <nombre>`. Se acepta también
/// el modo binario (`*nombre`). Devuelve null si no está o si la línea no
/// tiene pinta de huella — media huella es no tener huella.
String? sha256ForAsset(String sumsFile, String assetName) {
  for (final linea in sumsFile.split('\n')) {
    final limpia = linea.trim();
    if (limpia.isEmpty) continue;
    final partes = limpia.split(RegExp(r'\s+'));
    if (partes.length < 2) continue;
    final huella = partes.first.toLowerCase();
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(huella)) continue;
    final nombre = partes.sublist(1).join(' ').replaceFirst(RegExp(r'^\*'), '');
    if (nombre == assetName) return huella;
  }
  return null;
}

/// La huella publicada para [assetUrl], o null si la release no la trae.
///
/// No lanza: quedarse sin huella no puede impedir descargar (ver la regla de
/// arriba). Lo que sí lanza es que la huella exista y NO cuadre, pero eso lo
/// decide [ensureSha256].
Future<String?> fetchPublishedSha256(
    http.Client client, String assetUrl) async {
  try {
    final response = await secureSend(client, sumsUrlFor(assetUrl))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;
    // el fichero son cuatro líneas: tope en BYTES (ver readCappedBody)
    final texto = await readCappedBody(response, 64 * 1024);
    return texto == null ? null : sha256ForAsset(texto, assetNameOf(assetUrl));
  } catch (_) {
    return null; // sin huella publicada, o sin red para pedirla
  }
}

/// Compara la huella calculada con la publicada. [expected] null = la release
/// no publica huella y no hay nada que comparar.
void ensureSha256({required String? expected, required Digest actual}) {
  if (expected == null) return;
  if (actual.toString().toLowerCase() == expected.toLowerCase()) return;
  throw const InputRejected(
      'Lo descargado no coincide con la huella publicada en GitHub. No se '
      'ha instalado nada. Vuelve a intentarlo; si sigue pasando, avisa.',
      code: InputRejectedCode.badHash);
}

/// Sustituye la base buena por la recién descargada. En Windows un handle
/// abierto (una consulta que reabra justo ahora) bloquea el rename con
/// sharing violation: reintento corto antes de rendirse — rendirse a la
/// primera tiraba la descarga entera a la papelera.
Future<void> renameDownloaded(File tmp, String destino) async {
  for (var intento = 0; ; intento++) {
    try {
      await tmp.rename(destino);
      return;
    } on FileSystemException {
      if (intento >= 3) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }
}
