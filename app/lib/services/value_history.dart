import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'json_store_io.dart';

/// Un punto de la evolución del valor de la colección.
class ValuePoint {
  final String date; // YYYY-MM-DD
  final double value;
  final int cards;

  const ValuePoint(this.date, this.value, this.cards);

  Map<String, dynamic> toJson() => {'d': date, 'v': value, 'c': cards};

  factory ValuePoint.fromJson(Map<String, dynamic> json) => ValuePoint(
        json['d'] as String,
        (json['v'] as num).toDouble(),
        (json['c'] as int?) ?? 0,
      );
}

/// Historial local del valor de la colección: una foto por día, sin nube.
/// Con esto el Mercado puede enseñar "+X € (+Y%)" de verdad.
class ValueHistory {
  /// Solo para tests: dónde guardar el JSON (por defecto, la carpeta de datos
  /// de la app).
  final Directory? dataDir;

  ValueHistory({this.dataDir});

  static const _maxPoints = 365;

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'value_history.json'));
    } catch (_) {
      return null;
    }
  }

  Future<List<ValuePoint>> load() async {
    final file = await _file();
    if (file == null || !await file.exists()) return const [];
    try {
      final list = jsonDecode(await file.readAsString()) as List<dynamic>;
      return [
        for (final item in list)
          ValuePoint.fromJson(item as Map<String, dynamic>)
      ];
    } catch (_) {
      // ilegible: apartarlo antes de que `record()` escriba encima un
      // historial de un solo punto y se lleve por delante el año entero
      await setAsideBroken(file);
      return const [];
    }
  }

  /// Registra el valor de HOY (sustituye la foto del día si ya existía)
  /// y devuelve el historial actualizado.
  Future<List<ValuePoint>> record(double value, int cards) async {
    final now = DateTime.now();
    two(int n) => n < 10 ? '0$n' : '$n';
    final today = '${now.year}-${two(now.month)}-${two(now.day)}';
    final history = List<ValuePoint>.from(await load())
      ..removeWhere((pt) => pt.date == today)
      ..add(ValuePoint(today, value, cards))
      // el reloj hacia atrás (o un fichero ya desordenado) no puede descolocar
      // la serie: se recorta por el FRENTE asumiendo orden ascendente
      ..sort((a, b) => a.date.compareTo(b.date));
    while (history.length > _maxPoints) {
      history.removeAt(0);
    }
    final file = await _file();
    if (file != null) {
      await writeJsonFile(
          file, jsonEncode([for (final pt in history) pt.toJson()]));
    }
    return history;
  }
}
