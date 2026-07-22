import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'download_check.dart';
import 'safe_input.dart';

import '../scanner/hash_index.dart';

// El núcleo de matching (HashEntry, ScanMatch, HashIndex) vive en
// hash_index.dart (sin Flutter). Se re-exporta para que quien importe esta
// base de huellas siga viendo esos tipos sin un import extra.
export '../scanner/hash_index.dart';

/// Base de huellas del escáner (generada por scripts/build_hash_db.py y
/// publicada como release scanner-db-latest). Descarga con progreso,
/// matching offline. Mismo patrón que CardDatabase.
class ScannerDatabase {
  static const releaseUrl =
      'https://github.com/AAlexmc/Manaforge/releases/download/scanner-db-latest/manaforge_hashes.sqlite.gz';

  HashIndex? _index;

  Future<File> _dbFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'manaforge_hashes.sqlite'));
  }

  /// Cuándo se trajo la copia local (para no re-descargar cada arranque
  /// cuando la fecha del contenido nunca alcanza al día de hoy).
  Future<DateTime?> lastDownloaded() async {
    try {
      final file = await _dbFile();
      if (!await file.exists()) return null;
      return file.lastModified();
    } catch (_) {
      return null;
    }
  }

  Future<bool> isReady() async {
    try {
      return await (await _dbFile()).exists();
    } catch (_) {
      return false; // sin plugin (tests) => no hay DB
    }
  }

  /// Descarga y descomprime la base, emitiendo progreso 0..1 (-1 = indet.).
  /// Como en CardDatabase: la base buena solo se sustituye al final, y una
  /// cancelación a media descarga no deja sinks abiertos ni restos.
  Stream<double> download() async* {
    final dbFile = await _dbFile();
    final gzFile = File('${dbFile.path}.gz');
    final tmpFile = File('${dbFile.path}.tmp');
    final client = http.Client();
    IOSink? sink;
    try {
      final response = await secureSend(client, Uri.parse(releaseUrl));
      if (response.statusCode != 200) {
        throw HttpException(
            'No se pudo descargar la base de huellas (HTTP ${response.statusCode}). '
            '¿Se ha ejecutado ya el workflow "Build scanner hash database"?');
      }
      // ¿publica esta release su SHA-256? Las de antes de 2026-07-22
      // no lo hacen, y en ese caso se baja igual que siempre
      final esperada = await fetchPublishedSha256(client, releaseUrl);
      final total = response.contentLength ?? -1;
      var received = 0;
      // la huella se calcula MIENTRAS se baja: pasar otra vez por cientos de
      // MB al terminar sería leerlo todo dos veces
      Digest? digest;
      final huella = sha256.startChunkedConversion(
          ChunkedConversionSink<Digest>.withCallback((d) => digest = d.single));
      sink = gzFile.openWrite();
      await for (final chunk in response.stream) {
        sink.add(chunk);
        huella.add(chunk);
        received += chunk.length;
        ensureDownloadSize(received);
        yield total > 0 ? received / total : -1;
      }
      huella.close();
      // si la release publica huella y no cuadra, aquí se corta: nada de
      // descomprimir ni sustituir la base buena
      ensureSha256(expected: esperada, actual: digest!);
      await sink.close();
      sink = null;
      await gzFile.openRead().transform(gzip.decoder).pipe(tmpFile.openWrite());
      _index = null;
      await tmpFile.rename(dbFile.path);
      yield 1.0;
    } finally {
      client.close();
      try {
        await sink?.close();
      } catch (_) {/* ya estaba rota */}
      for (final leftover in [gzFile, tmpFile]) {
        if (await leftover.exists()) {
          try {
            await leftover.delete();
          } catch (_) {/* nada que hacer */}
        }
      }
    }
  }

  /// Carga (una vez) todas las huellas en memoria.
  Future<HashIndex> loadIndex() async {
    final cached = _index;
    if (cached != null) return cached;
    final file = await _dbFile();
    final db = sqlite3.open(file.path, mode: OpenMode.readOnly);
    try {
      final rows = db.select(
          'SELECT scryfall_id, oracle_id, name, set_code, collector_number, '
          'hash_h, hash_v FROM art_hashes');
      final hh = Int64List(rows.length);
      final vv = Int64List(rows.length);
      final entries = <HashEntry>[];
      for (var i = 0; i < rows.length; i++) {
        final r = rows[i];
        hh[i] = r['hash_h'] as int;
        vv[i] = r['hash_v'] as int;
        entries.add(HashEntry(
          scryfallId: r['scryfall_id'] as String,
          oracleId: r['oracle_id'] as String,
          name: r['name'] as String,
          setCode: (r['set_code'] as String?) ?? '',
          collectorNumber: (r['collector_number'] as String?) ?? '',
        ));
      }
      final index = HashIndex(hh, vv, entries);
      _index = index;
      return index;
    } finally {
      db.dispose();
    }
  }

  /// Fecha de generación de la base descargada (meta 'updated'), o null.
  Future<String?> updatedDate() async {
    try {
      final file = await _dbFile();
      final db = sqlite3.open(file.path, mode: OpenMode.readOnly);
      try {
        final rows =
            db.select("SELECT value FROM meta WHERE key = 'updated'");
        return rows.isEmpty ? null : rows.first['value'] as String?;
      } finally {
        db.dispose();
      }
    } catch (_) {
      return null;
    }
  }
}
