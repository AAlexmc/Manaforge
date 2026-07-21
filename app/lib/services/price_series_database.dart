import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'price_history.dart';

/// Histórico REAL de precios de Cardmarket (~90 días por carta), generado
/// por scripts/build_price_history_db.py a partir de los datos abiertos de
/// MTGJSON y publicado como release price-db-latest. Pesa ~4 MB.
///
/// Hace falta porque Scryfall —de donde salen los precios de la app— solo
/// publica el de HOY: sin esto la gráfica de una carta tarda meses en tener
/// forma. Es el mismo criterio que el resto del Mercado (el precio de la
/// edición más barata de cada día) y se combina con lo que ManaForge apunta
/// en local, que manda para los días que ya tiene.
///
/// Mismo patrón que ScannerDatabase: descarga con progreso, consulta
/// offline, y si no está descargada la app funciona igual (sin histórico
/// previo, solo el que se va acumulando).
class PriceSeriesDatabase {
  static const releaseUrl =
      'https://github.com/AAlexmc/Manaforge/releases/download/price-db-latest/manaforge_prices.sqlite.gz';

  /// Directorio de datos; inyectable para poder testear con una base real.
  final Directory? _dir;

  PriceSeriesDatabase({Directory? directory}) : _dir = directory;

  Database? _db;
  String? _startDate;

  Future<File> _dbFile() async {
    final dir = _dir ?? await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'manaforge_prices.sqlite'));
  }

  Future<bool> isReady() async {
    try {
      return await (await _dbFile()).exists();
    } catch (_) {
      return false; // sin plugin de rutas (tests)
    }
  }

  /// Descarga y descomprime la base, emitiendo progreso 0..1 (-1 = indet.).
  Stream<double> download() async* {
    _close();
    final dbFile = await _dbFile();
    final gzFile = File('${dbFile.path}.gz');
    final client = http.Client();
    try {
      final response =
          await client.send(http.Request('GET', Uri.parse(releaseUrl)));
      if (response.statusCode != 200) {
        throw HttpException(
            'No se pudo descargar el histórico de precios '
            '(HTTP ${response.statusCode}). ¿Se ha ejecutado ya el workflow '
            '"Build price history database"?');
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

  void _close() {
    _db?.dispose();
    _db = null;
    _startDate = null;
  }

  Future<Database?> _open() async {
    final cached = _db;
    if (cached != null) return cached;
    try {
      final file = await _dbFile();
      if (!await file.exists()) return null;
      final db = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final rows = db.select("SELECT value FROM meta WHERE key = 'start_date'");
      if (rows.isEmpty) {
        db.dispose();
        return null;
      }
      _startDate = rows.first['value'] as String;
      _db = db;
      return db;
    } catch (_) {
      return null; // base ausente o corrupta: se sigue sin histórico previo
    }
  }

  /// Tramo cubierto por la base descargada ("2026-04-21 → 2026-07-20"), o
  /// null si no está.
  Future<(String, String)?> covered() async {
    final db = await _open();
    if (db == null) return null;
    final rows = db.select(
        "SELECT key, value FROM meta WHERE key IN ('start_date', 'end_date')");
    final meta = {
      for (final r in rows) r['key'] as String: r['value'] as String
    };
    final start = meta['start_date'];
    final end = meta['end_date'];
    return (start == null || end == null) ? null : (start, end);
  }

  /// Series históricas de varias cartas. Las que no estén en la base (o si
  /// no está descargada) simplemente no salen en el mapa.
  Future<Map<String, List<PricePoint>>> seriesFor(
      Iterable<String> oracleIds) async {
    final db = await _open();
    final start = _startDate;
    if (db == null || start == null) return const {};
    final ids = oracleIds.toSet().toList();
    if (ids.isEmpty) return const {};
    final out = <String, List<PricePoint>>{};
    final first = DateTime.parse(start);
    const chunkSize = 400;
    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk =
          ids.sublist(i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
          'SELECT oracle_id, values_f32 FROM price_series '
          'WHERE oracle_id IN ($marks)',
          chunk);
      for (final row in rows) {
        final blob = row['values_f32'] as Uint8List;
        // ByteData y NO buffer.asFloat32List: el blob que devuelve sqlite3
        // puede ser una vista con offset no múltiplo de 4, y ahí
        // asFloat32List lanza. El script escribe little-endian.
        final data = ByteData.sublistView(blob);
        final days = blob.lengthInBytes ~/ 4;
        final points = <PricePoint>[];
        for (var d = 0; d < days; d++) {
          final v = data.getFloat32(d * 4, Endian.little);
          if (v.isNaN || v <= 0) continue; // día sin dato
          final day = first.add(Duration(days: d));
          two(int n) => n < 10 ? '0$n' : '$n';
          points.add(PricePoint(
              '${day.year}-${two(day.month)}-${two(day.day)}', v));
        }
        if (points.isNotEmpty) out[row['oracle_id'] as String] = points;
      }
    }
    return out;
  }
}
