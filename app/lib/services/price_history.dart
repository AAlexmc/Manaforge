/// Historial LOCAL de precio por carta (nivel oracle, mismo criterio que
/// pricesForOracles: la edición más barata), para la gráfica de evolución
/// estilo mercado de Steam en la ficha de carta. Sin nube: un punto por
/// día y carta, apuntado cada vez que el Mercado cruza precios (colección
/// + wishlist) o se abre la ficha de una carta con precio. La historia se
/// construye con el uso — Scryfall solo publica el precio de HOY, así que
/// un apunte perdido no se puede recuperar.
///
/// Por eso el almacenamiento es un LOG (JSONL, una línea por punto) en vez
/// de un JSON monolítico reescrito entero:
///  - apuntar cuesta lo que ocupan los puntos NUEVOS, no toda la historia
///    (el Mercado apunta en cada cambio de la colección: importar un CSV
///    de 500 filas reescribía 30 MB por fila);
///  - una línea rota (corte de luz a mitad de escritura) se salta sola en
///    vez de tumbar el fichero entero;
///  - la compactación, que sí reescribe, va por fichero temporal + rename
///    (atómico en POSIX) y solo de vez en cuando.
///
/// Todas las operaciones pasan por una cola: dos pantallas apuntando a la
/// vez (Mercado al abrir + wishlist + ficha) no pueden pisarse.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'markets.dart';

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
/// rangos Semana/Mes/Todo de la gráfica). Función pura para testear. El
/// corte se calcula sobre el DÍA (no sobre la hora), para que un cambio de
/// horario no mueva la frontera; "7 días" incluye hoy y los 6 anteriores.
List<PricePoint> filterRange(List<PricePoint> points, int? days,
    {DateTime? now}) {
  if (days == null) return points;
  final today = now ?? DateTime.now();
  final cutoff = DateTime(today.year, today.month, today.day)
      .subtract(Duration(days: days - 1));
  two(int n) => n < 10 ? '0$n' : '$n';
  final cut = '${cutoff.year}-${two(cutoff.month)}-${two(cutoff.day)}';
  return [
    for (final pt in points)
      if (pt.date.compareTo(cut) >= 0) pt
  ];
}

class PriceHistoryStore {
  /// Días guardados por carta.
  static const _maxPointsPerCard = 365;

  /// Techo de cartas con historial: cada ficha que abres apunta la suya, y
  /// sin tope el fichero (y la RAM) crecen para siempre. Al pasarse, se
  /// tiran las de apunte más antiguo en la siguiente compactación.
  static const _maxCards = 5000;

  /// Se compacta cuando el log tiene bastantes más líneas que puntos
  /// vivos (los apuntes diarios repetidos de la misma carta se acumulan).
  static const _compactFactor = 3;
  static const _compactMinLines = 20000;

  /// Directorio de datos; inyectable para poder testear el disco.
  final Directory? _dir;

  PriceHistoryStore({Directory? directory}) : _dir = directory;

  /// Histórico previo (los ~90 días reales de Cardmarket que trae la base
  /// descargable): se usa de BASE y lo apuntado en local manda en los días
  /// que tenga. Si no se enchufa nada, solo hay historial local.
  Future<Map<String, List<PricePoint>>> Function(Iterable<String>, Market)?
      baseSeriesProvider;

  Map<String, List<PricePoint>>? _cache;
  Future<Map<String, List<PricePoint>>>? _loading;
  int _lines = 0; // líneas del log en disco (para decidir compactación)

  /// Cola de operaciones: todo lo que toca caché o disco se encadena aquí,
  /// así dos llamadas concurrentes no construyen dos cachés ni escriben a
  /// la vez (el apunte diario de la colección se perdía por esto).
  Future<void> _queue = Future.value();

  Future<T> _serialize<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    // la cola sigue viva aunque una operación falle
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  Future<File?> _file() async {
    try {
      final dir = _dir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'price_history.jsonl'));
    } catch (_) {
      return null; // sin plugin de rutas (tests): solo memoria
    }
  }

  Future<Map<String, List<PricePoint>>> _load() {
    final cached = _cache;
    if (cached != null) return Future.value(cached);
    // dedupe del future en vuelo: dos _load() simultáneos comparten mapa
    return _loading ??= _loadFromDisk().whenComplete(() => _loading = null);
  }

  Future<Map<String, List<PricePoint>>> _loadFromDisk() async {
    final out = <String, List<PricePoint>>{};
    var lines = 0;
    final file = await _file();
    if (file != null && !await file.exists()) {
      final migrated = await _importLegacyJson(file);
      if (migrated != null) {
        _cache = migrated.$1;
        _lines = migrated.$2;
        return migrated.$1;
      }
    }
    if (file != null && await file.exists()) {
      // por (carta, día) gana la última línea: el log es append-only y un
      // apunte nuevo del mismo día sustituye al anterior
      final byCard = <String, Map<String, double>>{};
      try {
        for (final line in await file.readAsLines()) {
          if (line.isEmpty) continue;
          lines++;
          try {
            final m = jsonDecode(line) as Map<String, dynamic>;
            final oracle = m['o'] as String;
            final date = m['d'] as String;
            final value = (m['v'] as num).toDouble();
            (byCard[oracle] ??= {})[date] = value;
          } catch (_) {
            // línea rota (escritura cortada a medias): se salta ESA, no se
            // tira la historia entera
          }
        }
      } catch (_) {/* fichero ilegible: se empieza de cero */}
      byCard.forEach((oracle, days) {
        final dates = days.keys.toList()..sort();
        out[oracle] = [
          for (final d in dates) PricePoint(d, days[d]!)
        ];
      });
    }
    _cache = out;
    _lines = lines;
    return out;
  }

  /// La primera versión guardaba un JSON monolítico `price_history.json`.
  /// Si está y aún no hay log, se pasa a JSONL y se aparta el original —
  /// los apuntes ya hechos no se pueden recuperar de ninguna otra parte.
  Future<(Map<String, List<PricePoint>>, int)?> _importLegacyJson(
      File target) async {
    final legacy = File(p.join(p.dirname(target.path), 'price_history.json'));
    if (!await legacy.exists()) return null;
    final data = <String, List<PricePoint>>{};
    try {
      final map = jsonDecode(await legacy.readAsString())
          as Map<String, dynamic>;
      map.forEach((oracle, list) {
        data[oracle] = [
          for (final item in list as List<dynamic>)
            PricePoint.fromJson(item as Map<String, dynamic>)
        ];
      });
    } catch (_) {
      return null; // formato viejo ilegible: se empieza de cero
    }
    final buffer = StringBuffer();
    var lines = 0;
    data.forEach((oracle, history) {
      for (final pt in history) {
        buffer.writeln(
            jsonEncode({'o': oracle, 'd': pt.date, 'v': pt.value}));
        lines++;
      }
    });
    final tmp = File('${target.path}.tmp');
    await tmp.writeAsString(buffer.toString());
    await tmp.rename(target.path);
    await legacy.rename('${legacy.path}.migrado');
    return (data, lines);
  }

  String _today() {
    final now = DateTime.now();
    two(int n) => n < 10 ? '0$n' : '$n';
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }

  /// Historial de una carta, ordenado por fecha ascendente: el histórico
  /// descargado como base + lo apuntado en local encima.
  Future<List<PricePoint>> forCardIn(String oracleId, Market market) async {
    if (market == Market.cardmarket) return forCard(oracleId);
    final base = await _base([oracleId], market);
    return List<PricePoint>.unmodifiable(base[oracleId] ?? const []);
  }

  Future<List<PricePoint>> forCard(String oracleId) async {
    final local = await _serialize(() async {
      final data = await _load();
      return List<PricePoint>.from(data[oracleId] ?? const []);
    });
    final base = await _base([oracleId], Market.cardmarket);
    return List<PricePoint>.unmodifiable(
        _merge(base[oracleId] ?? const [], local));
  }

  /// Historiales de varias cartas de golpe (listas de Mercado/wishlist);
  /// solo las que tienen algún punto.
  ///
  /// El apunte diario que hace la app es de Scryfall en EUROS, o sea
  /// Cardmarket: en cualquier otro mercado NO se mezcla (sumarle euros a una
  /// serie en dólares sería inventarse la gráfica) y solo sale el histórico
  /// descargado de ese mercado.
  Future<Map<String, List<PricePoint>>> forCards(Iterable<String> oracleIds,
      {Market market = Market.cardmarket}) async {
    final ids = oracleIds.toSet();
    if (market != Market.cardmarket) {
      final base = await _base(ids, market);
      return {
        for (final e in base.entries)
          if (e.value.isNotEmpty) e.key: List<PricePoint>.unmodifiable(e.value)
      };
    }
    final local = await _serialize(() async {
      final data = await _load();
      return {
        for (final id in ids)
          if (data[id] != null) id: List<PricePoint>.from(data[id]!)
      };
    });
    final base = await _base(ids, market);
    final out = <String, List<PricePoint>>{};
    for (final id in ids) {
      final merged = _merge(base[id] ?? const [], local[id] ?? const []);
      if (merged.isNotEmpty) out[id] = List<PricePoint>.unmodifiable(merged);
    }
    return out;
  }

  Future<Map<String, List<PricePoint>>> _base(
      Iterable<String> ids, Market market) async {
    final provider = baseSeriesProvider;
    if (provider == null) return const {};
    try {
      return await provider(ids, market);
    } catch (_) {
      return const {}; // sin histórico previo se sigue con el local
    }
  }

  /// Une base + local por fecha; para un día presente en los dos manda el
  /// apunte LOCAL (es el precio que la app vio de verdad ese día).
  static List<PricePoint> _merge(
      List<PricePoint> base, List<PricePoint> local) {
    if (base.isEmpty && local.isEmpty) return const [];
    // siempre por la misma vía: el contrato es "ordenado por fecha" y el
    // painter une los puntos en el orden de la lista
    final byDate = <String, double>{
      for (final pt in base) pt.date: pt.value,
      for (final pt in local) pt.date: pt.value,
    };
    final dates = byDate.keys.toList()..sort();
    return [for (final d in dates) PricePoint(d, byDate[d]!)];
  }

  /// Apunta el precio de HOY de cada carta (sustituye la foto del día si
  /// ya existía). Ignora precios nulos/cero: "sin precio" no es un punto.
  Future<void> recordAll(Map<String, double> pricesByOracle) {
    if (pricesByOracle.isEmpty) return Future.value();
    return _serialize(() async {
      final data = await _load();
      final today = _today();
      final fresh = <String, double>{};
      pricesByOracle.forEach((oracle, price) {
        if (price <= 0 || !price.isFinite) return;
        final history = data.putIfAbsent(oracle, () => []);
        if (history.isNotEmpty &&
            history.last.date == today &&
            history.last.value == price) {
          return; // idéntico a lo ya apuntado hoy: nada que escribir
        }
        history.removeWhere((pt) => pt.date == today);
        history.add(PricePoint(today, price));
        if (history.length > _maxPointsPerCard) {
          history.removeRange(0, history.length - _maxPointsPerCard);
        }
        fresh[oracle] = price;
      });
      if (fresh.isEmpty) return;
      await _append(fresh, today);
      if (_needsCompaction(data)) await _compact(data);
    });
  }

  /// Apunta una sola carta (al abrir su ficha: cualquier carta consultada
  /// empieza a acumular historia, no solo colección y wishlist).
  Future<void> recordOne(String oracleId, double price) =>
      recordAll({oracleId: price});

  /// Añade al log SOLO los puntos nuevos (coste proporcional a lo que
  /// cambia, no a toda la historia).
  Future<void> _append(Map<String, double> fresh, String today) async {
    final file = await _file();
    if (file == null) return;
    final buffer = StringBuffer();
    fresh.forEach((oracle, value) {
      buffer.writeln(jsonEncode({'o': oracle, 'd': today, 'v': value}));
    });
    await file.writeAsString(buffer.toString(), mode: FileMode.append);
    _lines += fresh.length;
  }

  bool _needsCompaction(Map<String, List<PricePoint>> data) {
    if (_lines < _compactMinLines) return false;
    var points = 0;
    for (final list in data.values) {
      points += list.length;
    }
    return _lines > points * _compactFactor || data.length > _maxCards;
  }

  /// Reescribe el log con un punto por (carta, día) y tira las cartas más
  /// viejas si se pasa del techo. Va por fichero temporal + rename, que es
  /// atómico: un corte a media escritura deja el log anterior intacto.
  Future<void> _compact(Map<String, List<PricePoint>> data) async {
    final file = await _file();
    if (file == null) return;
    if (data.length > _maxCards) {
      // se quedan las de apunte más reciente (la fecha del último punto)
      final byRecency = data.keys.toList()
        ..sort((a, b) =>
            (data[b]!.last.date).compareTo(data[a]!.last.date));
      for (final oracle in byRecency.skip(_maxCards)) {
        data.remove(oracle);
      }
    }
    final buffer = StringBuffer();
    var lines = 0;
    data.forEach((oracle, history) {
      for (final pt in history) {
        buffer.writeln(
            jsonEncode({'o': oracle, 'd': pt.date, 'v': pt.value}));
        lines++;
      }
    });
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(buffer.toString());
    await tmp.rename(file.path);
    _lines = lines;
  }
}

/// Instancia compartida (mismo patrón que recentsStore).
final priceHistoryStore = PriceHistoryStore();
