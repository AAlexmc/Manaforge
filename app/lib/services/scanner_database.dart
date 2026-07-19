import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../scanner/dhash.dart';

/// Una impresión de la base de huellas (una fila de art_hashes).
class HashEntry {
  final String scryfallId;
  final String oracleId;
  final String name;
  final String setCode;
  final String collectorNumber;

  const HashEntry({
    required this.scryfallId,
    required this.oracleId,
    required this.name,
    required this.setCode,
    required this.collectorNumber,
  });

  String get printingKey => '${setCode.toLowerCase()}|$collectorNumber';
}

/// Un candidato del escáner: la impresión que mejor casa + su distancia.
class ScanMatch {
  final HashEntry entry;

  /// Distancia de Hamming total (0..128); menos es mejor. Como orientación,
  /// ≤14 suele ser la misma ilustración y ≥30 otra carta.
  final int distance;

  const ScanMatch(this.entry, this.distance);
}

/// Índice de huellas EN MEMORIA: ~110k firmas de 128 bits caben en un par
/// de MB y el barrido completo por Hamming tarda milisegundos.
class HashIndex {
  final Int64List _hashH;
  final Int64List _hashV;
  final List<HashEntry> _entries;

  HashIndex(this._hashH, this._hashV, this._entries)
      : assert(_hashH.length == _entries.length),
        assert(_hashV.length == _entries.length);

  int get length => _entries.length;

  /// Los [k] mejores candidatos para las firmas [sigs] (variantes
  /// multi-recorte de la MISMA carta vista: cuenta la mejor), DISTINTOS a
  /// nivel de carta (oracle): la misma ilustración reimpresa no debe
  /// comerse el top. Para cada carta gana su impresión que mejor casa
  /// (printingKey exacta).
  List<ScanMatch> topMatches(List<DHashPair> sigs, {int k = 3}) {
    if (sigs.isEmpty) return const [];
    // Fase 1: barrido completo solo con la firma CENTRAL (artSignatures
    // pone la variante sin desplazamiento la primera) y preselección de
    // los ~1000 mejores por counting-sort de distancias (0..128).
    final center = sigs.first;
    final d0 = Uint8List(_entries.length);
    final histogram = List<int>.filled(129, 0);
    for (var i = 0; i < _entries.length; i++) {
      final d = hamming64(center.h, _hashH[i]) +
          hamming64(center.v, _hashV[i]);
      d0[i] = d;
      histogram[d]++;
    }
    var cutoff = 128;
    var cumulative = 0;
    for (var d = 0; d <= 128; d++) {
      cumulative += histogram[d];
      if (cumulative >= 1000) {
        cutoff = d;
        break;
      }
    }
    // Fase 2: refinar los preseleccionados con TODAS las variantes.
    final bestByOracle = <String, ScanMatch>{};
    for (var i = 0; i < _entries.length; i++) {
      if (d0[i] > cutoff) continue;
      final hh = _hashH[i];
      final vv = _hashV[i];
      var d = d0[i].toInt();
      for (final sig in sigs) {
        final di = hamming64(sig.h, hh) + hamming64(sig.v, vv);
        if (di < d) d = di;
      }
      final e = _entries[i];
      final current = bestByOracle[e.oracleId];
      if (current == null || d < current.distance) {
        bestByOracle[e.oracleId] = ScanMatch(e, d);
      }
    }
    final all = bestByOracle.values.toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    return all.take(k).toList();
  }
}

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

  Future<bool> isReady() async {
    try {
      return await (await _dbFile()).exists();
    } catch (_) {
      return false; // sin plugin (tests) => no hay DB
    }
  }

  /// Descarga y descomprime la base, emitiendo progreso 0..1 (-1 = indet.).
  Stream<double> download() async* {
    _index = null;
    final dbFile = await _dbFile();
    final gzFile = File('${dbFile.path}.gz');
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(releaseUrl));
      final response = await client.send(request);
      if (response.statusCode != 200) {
        throw HttpException(
            'No se pudo descargar la base de huellas (HTTP ${response.statusCode}). '
            '¿Se ha ejecutado ya el workflow "Build scanner hash database"?');
      }
      final total = response.contentLength ?? -1;
      var received = 0;
      final sink = gzFile.openWrite();
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        yield total > 0 ? received / total : -1;
      }
      await sink.close();
      await gzFile.openRead().transform(gzip.decoder).pipe(dbFile.openWrite());
      await gzFile.delete();
      yield 1.0;
    } finally {
      client.close();
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
