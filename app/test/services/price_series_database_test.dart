/// Tests del lector del histórico descargable: que el BLOB de float32 que
/// escribe scripts/build_price_history_db.py se decodifique a las fechas y
/// precios correctos, y que la ausencia de base no rompa nada.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/price_series_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// Crea una base con el mismo esquema que genera el script de CI.
void _writeDb(Directory dir,
    {required String start,
    required String end,
    required Map<String, List<double>> series}) {
  final db = sqlite3.open(p.join(dir.path, 'manaforge_prices.sqlite'));
  db.execute('CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
  db.execute('CREATE TABLE price_series ('
      'oracle_id TEXT PRIMARY KEY, values_f32 BLOB NOT NULL)');
  for (final e in {'start_date': start, 'end_date': end}.entries) {
    db.execute('INSERT INTO meta VALUES (?, ?)', [e.key, e.value]);
  }
  series.forEach((oracle, values) {
    db.execute('INSERT INTO price_series VALUES (?, ?)',
        [oracle, Float32List.fromList(values).buffer.asUint8List()]);
  });
  db.dispose();
}

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mf_pricedb'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('sin base descargada: ni series ni tramo, y no revienta', () async {
    final db = PriceSeriesDatabase(directory: dir);
    expect(await db.isReady(), isFalse);
    expect(await db.covered(), isNull);
    expect(await db.seriesFor(['bolt']), isEmpty);
  });

  test('decodifica el blob a un punto por día desde start_date', () async {
    _writeDb(dir,
        start: '2026-07-01',
        end: '2026-07-04',
        series: {
          'bolt': [1.0, 1.5, 2.0, 2.5]
        });
    final series = await PriceSeriesDatabase(directory: dir)
        .seriesFor(['bolt']);
    final bolt = series['bolt']!;
    expect([for (final pt in bolt) pt.date],
        ['2026-07-01', '2026-07-02', '2026-07-03', '2026-07-04']);
    expect(bolt.last.value, closeTo(2.5, 0.001));
  });

  test('los días sin dato (NaN) no son puntos: la línea no baja a cero',
      () async {
    _writeDb(dir,
        start: '2026-07-01',
        end: '2026-07-04',
        series: {
          'bolt': [1.0, double.nan, double.nan, 2.0]
        });
    final bolt = (await PriceSeriesDatabase(directory: dir)
        .seriesFor(['bolt']))['bolt']!;
    expect([for (final pt in bolt) pt.date], ['2026-07-01', '2026-07-04']);
  });

  test('cartas que no están en la base simplemente no salen', () async {
    _writeDb(dir,
        start: '2026-07-01',
        end: '2026-07-01',
        series: {
          'bolt': [1.0]
        });
    final series = await PriceSeriesDatabase(directory: dir)
        .seriesFor(['bolt', 'desconocida']);
    expect(series.keys, ['bolt']);
  });

  test('covered devuelve el tramo cubierto', () async {
    _writeDb(dir,
        start: '2026-04-21',
        end: '2026-07-20',
        series: {
          'bolt': [1.0]
        });
    expect(await PriceSeriesDatabase(directory: dir).covered(),
        ('2026-04-21', '2026-07-20'));
  });

  test('base corrupta: se ignora en vez de tumbar el Mercado', () async {
    File(p.join(dir.path, 'manaforge_prices.sqlite'))
        .writeAsStringSync('esto no es una sqlite');
    final db = PriceSeriesDatabase(directory: dir);
    expect(await db.covered(), isNull);
    expect(await db.seriesFor(['bolt']), isEmpty);
  });
}
