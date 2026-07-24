import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'markets.dart';
import 'price_history.dart';
import 'download_check.dart';
import 'safe_input.dart';
import 'database_download_error.dart';

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
  Future<Database?>? _opening;
  String? _startDate;

  /// ¿La base descargada distingue mercados? Las de la primera versión solo
  /// traían Cardmarket y no tienen la columna `provider`.
  bool _hasProvider = false;

  /// Mercados que trae la base descargada.
  Set<String> _providers = const {'cardmarket'};

  Set<Market> get markets => {
        for (final m in Market.values)
          if (_providers.contains(m.id)) m
      };

  Future<File> _dbFile() async {
    final dir = _dir ?? await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'manaforge_prices.sqlite'));
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
      return false; // sin plugin de rutas (tests)
    }
  }

  /// Descarga y descomprime la base, emitiendo progreso 0..1 (-1 = indet.).
  /// La base que ya funcionaba NO se toca hasta que la nueva está entera y
  /// descomprimida: una descarga cortada deja el histórico anterior intacto.
  Stream<double> download() async* {
    final dbFile = await _dbFile();
    final gzFile = File('${dbFile.path}.gz');
    final tmpFile = File('${dbFile.path}.tmp');
    final client = http.Client();
    IOSink? gzSink;
    try {
      final response = await secureSend(client, Uri.parse(releaseUrl));
      if (response.statusCode != 200) {
        throw DatabaseDownloadError(
            DownloadedDatabase.priceHistory,
            response.statusCode,
            'No se pudo descargar el histórico de precios '
            '(HTTP ${response.statusCode}). ¿Se ha ejecutado ya el workflow '
            '"Build price history database"?');
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
      gzSink = gzFile.openWrite();
      await for (final chunk in response.stream) {
        gzSink.add(chunk);
        huella.add(chunk);
        received += chunk.length;
        ensureDownloadSize(received);
        yield total > 0 ? received / total : -1;
      }
      huella.close();
      // si la release publica huella y no cuadra, aquí se corta: nada de
      // descomprimir ni sustituir la base buena
      ensureSha256(expected: esperada, actual: digest!);
      await gzSink.close();
      gzSink = null;
      await gzFile.openRead().transform(gzip.decoder).pipe(tmpFile.openWrite());
      // solo ahora se sustituye la buena (rename es atómico en POSIX)
      close();
      await tmpFile.rename(dbFile.path);
      yield 1.0;
    } finally {
      client.close();
      try {
        await gzSink?.close();
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

  /// Cierra la base (al traer una nueva, o al terminar).
  void close() {
    _db?.dispose();
    _db = null;
    _opening = null;
    _startDate = null;
    _covered = null;
  }

  Future<Database?> _open() {
    final cached = _db;
    if (cached != null) return Future.value(cached);
    // dedupe: _load() del Mercado corre por cada cambio de la colección, y
    // sin esto varias llamadas concurrentes abrirían (y fugarían) handles
    return _opening ??= _doOpen().whenComplete(() => _opening = null);
  }

  Future<Database?> _doOpen() async {
    Database? db;
    try {
      final file = await _dbFile();
      if (!await file.exists()) return null;
      db = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final rows = db.select("SELECT value FROM meta WHERE key = 'start_date'");
      if (rows.isEmpty) {
        db.dispose();
        return null;
      }
      _startDate = rows.first['value'] as String;
      _hasProvider = db
          .select('PRAGMA table_info(price_series)')
          .any((r) => r['name'] == 'provider');
      _providers = _hasProvider
          ? {
              for (final r
                  in db.select('SELECT DISTINCT provider FROM price_series'))
                r['provider'] as String
            }
          : const {'cardmarket'};
      _db = db;
      return db;
    } catch (_) {
      // base ausente o corrupta: se sigue sin histórico previo, pero el
      // handle ya abierto hay que soltarlo (si no, uno por intento)
      db?.dispose();
      return null;
    }
  }

  (String, String)? _covered;

  /// Tramo cubierto por la base descargada ("2026-04-21 → 2026-07-20"), o
  /// null si no está. Se cachea: solo cambia al traer una base nueva.
  Future<(String, String)?> covered() async {
    final cached = _covered;
    if (cached != null) return cached;
    try {
      final db = await _open();
      if (db == null) return null;
      final rows = db.select("SELECT key, value FROM meta "
          "WHERE key IN ('start_date', 'end_date')");
      final meta = {
        for (final r in rows) r['key'] as String: r['value'] as String
      };
      final start = meta['start_date'];
      final end = meta['end_date'];
      if (start == null || end == null) return null;
      return _covered = (start, end);
    } catch (_) {
      return null; // un fallo del histórico no debe tumbar el Mercado
    }
  }

  /// Series históricas de varias cartas. Las que no estén en la base (o si
  /// no está descargada) simplemente no salen en el mapa.
  Future<Map<String, List<PricePoint>>> seriesFor(Iterable<String> oracleIds,
      {Market market = Market.cardmarket}) async {
    final db = await _open();
    final start = _startDate;
    if (db == null || start == null) return const {};
    final ids = oracleIds.toSet().toList();
    if (ids.isEmpty) return const {};
    // base vieja (solo Cardmarket): pedir otro mercado no devuelve nada, y
    // es mejor eso que enseñar precios de Cardmarket con la etiqueta de
    // TCGplayer
    if (!_hasProvider && market != Market.cardmarket) return const {};
    if (_hasProvider && !_providers.contains(market.id)) return const {};
    final out = <String, List<PricePoint>>{};
    final first = DateTime.parse(start);
    two(int n) => n < 10 ? '0$n' : '$n';
    // día de CALENDARIO, no 86400·n segundos: sumar Duration cruzando el
    // cambio de hora repite o se salta un día (probado con TZ=Europe/Madrid
    // a finales de octubre), y la ventana de ~90 días lo cruza medio año
    String dayAt(int i) {
      final d = DateTime(first.year, first.month, first.day + i);
      return '${d.year}-${two(d.month)}-${two(d.day)}';
    }

    const chunkSize = 400;
    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk =
          ids.sublist(i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
          'SELECT oracle_id, values_f32 FROM price_series '
          'WHERE oracle_id IN ($marks)'
          '${_hasProvider ? ' AND provider = ?' : ''}',
          [...chunk, if (_hasProvider) market.id]);
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
          points.add(PricePoint(dayAt(d), v));
        }
        if (points.isNotEmpty) out[row['oracle_id'] as String] = points;
      }
    }
    return out;
  }
}
