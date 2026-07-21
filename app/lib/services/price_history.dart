/// Historial LOCAL de precio por carta (nivel oracle, mismo criterio que
/// pricesForOracles: la edición más barata), para la gráfica de evolución
/// estilo mercado de Steam en la ficha de carta. Sin nube: un punto por
/// día y carta, apuntado cada vez que el Mercado cruza precios (colección
/// + wishlist) o se abre la ficha de una carta con precio. La historia se
/// construye con el uso — Scryfall solo publica el precio de HOY.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Un punto de la evolución de precio de UNA carta.
class PricePoint {
  final String date; // YYYY-MM-DD
  final double value;

  const PricePoint(this.date, this.value);

  Map<String, dynamic> toJson() => {'d': date, 'v': value};

  factory PricePoint.fromJson(Map<String, dynamic> json) =>
      PricePoint(json['d'] as String, (json['v'] as num).toDouble());
}

/// Los puntos de [points] dentro de los últimos [days] días (para los
/// rangos Semana/Mes/Todo de la gráfica). Función pura para testear.
List<PricePoint> filterRange(List<PricePoint> points, int? days,
    {DateTime? now}) {
  if (days == null) return points;
  final cutoff = (now ?? DateTime.now()).subtract(Duration(days: days));
  two(int n) => n < 10 ? '0$n' : '$n';
  final cut =
      '${cutoff.year}-${two(cutoff.month)}-${two(cutoff.day)}';
  return [
    for (final pt in points)
      if (pt.date.compareTo(cut) >= 0) pt
  ];
}

class PriceHistoryStore {
  static const _maxPointsPerCard = 365;

  Map<String, List<PricePoint>>? _cache;

  Future<File?> _file() async {
    try {
      final dir = await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'price_history.json'));
    } catch (_) {
      return null; // sin plugin de rutas (tests): solo memoria
    }
  }

  Future<Map<String, List<PricePoint>>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;
    final out = <String, List<PricePoint>>{};
    final file = await _file();
    if (file != null && await file.exists()) {
      try {
        final map =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        map.forEach((oracle, list) {
          out[oracle] = [
            for (final item in list as List<dynamic>)
              PricePoint.fromJson(item as Map<String, dynamic>)
          ];
        });
      } catch (_) {/* fichero corrupto: se empieza de cero */}
    }
    _cache = out;
    return out;
  }

  Future<void> _save(Map<String, List<PricePoint>> data) async {
    final file = await _file();
    if (file == null) return;
    await file.writeAsString(jsonEncode({
      for (final e in data.entries)
        e.key: [for (final pt in e.value) pt.toJson()]
    }));
  }

  String _today() {
    final now = DateTime.now();
    two(int n) => n < 10 ? '0$n' : '$n';
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }

  /// Historial de una carta, ordenado por fecha ascendente.
  Future<List<PricePoint>> forCard(String oracleId) async =>
      (await _load())[oracleId] ?? const [];

  /// Historiales de varias cartas de golpe (listas de Mercado/wishlist);
  /// solo las que tienen algún punto.
  Future<Map<String, List<PricePoint>>> forCards(
      Iterable<String> oracleIds) async {
    final data = await _load();
    return {
      for (final id in oracleIds)
        if (data[id] != null && data[id]!.isNotEmpty) id: data[id]!
    };
  }

  /// Apunta el precio de HOY de cada carta (sustituye la foto del día si
  /// ya existía). Ignora precios nulos/cero: "sin precio" no es un punto.
  Future<void> recordAll(Map<String, double> pricesByOracle) async {
    if (pricesByOracle.isEmpty) return;
    final data = await _load();
    final today = _today();
    var dirty = false;
    pricesByOracle.forEach((oracle, price) {
      if (price <= 0) return;
      final history = data.putIfAbsent(oracle, () => []);
      if (history.isNotEmpty &&
          history.last.date == today &&
          history.last.value == price) {
        return; // ya apuntado idéntico hoy: no reescribir el fichero
      }
      history.removeWhere((pt) => pt.date == today);
      history.add(PricePoint(today, price));
      while (history.length > _maxPointsPerCard) {
        history.removeAt(0);
      }
      dirty = true;
    });
    if (dirty) await _save(data);
  }

  /// Apunta una sola carta (al abrir su ficha: cualquier carta consultada
  /// empieza a acumular historia, no solo colección y wishlist).
  Future<void> recordOne(String oracleId, double price) =>
      recordAll({oracleId: price});
}

/// Instancia compartida (mismo patrón que recentsStore).
final priceHistoryStore = PriceHistoryStore();
