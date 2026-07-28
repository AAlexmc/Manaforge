import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/data/services/json_store_io.dart';

/// Contadores que NO se pueden deducir mirando la colección: pasan una vez y
/// hay que apuntarlos cuando pasan.
abstract final class AchievementCounters {
  static const cardsScanned = 'cardsScanned';
  static const bestPhotoCards = 'bestPhotoCards';
  static const perfectScans = 'perfectScans';
}

/// Qué logros has conseguido, los contadores de actividad y qué días has
/// usado la app. Fichero propio `achievements.json`.
///
/// Un logro conseguido NO se pierde: se guarda con su fecha aunque luego
/// vendas las cartas.
class AchievementStore extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  AchievementStore({this.dataDir});

  final Map<String, String> _unlocked = {}; // id -> ISO-8601
  final Map<String, int> _counters = {};
  final Set<String> _days = {}; // 'YYYY-MM-DD' (día local)
  int _lastSeenLevel = 1;
  Future<void>? _loading;

  Map<String, String> get unlockedAt => Map.unmodifiable(_unlocked);
  int get unlockedCount => _unlocked.length;
  int counter(String key) => _counters[key] ?? 0;
  int get lastSeenLevel => _lastSeenLevel;

  /// El nivel que el usuario ya ha visto celebrado (para no repetir el aviso).
  void rememberLevel(int level) {
    if (level == _lastSeenLevel) return;
    _lastSeenLevel = level;
    notifyListeners();
    _save();
  }

  // --- días de uso ---------------------------------------------------------

  /// Días distintos con actividad.
  int get activeDays => _days.length;

  List<DateTime> get _sortedDays {
    final list = [
      for (final d in _days)
        if (_parseDay(d) != null) _parseDay(d)!
    ]..sort();
    return list;
  }

  /// Racha más larga de días seguidos.
  int get longestStreak => _streaks().$1;

  /// Racha que sigue viva AHORA: si el último día activo no es hoy ni ayer,
  /// la racha está rota y vale 0.
  int currentStreak({DateTime? now}) {
    final days = _sortedDays;
    if (days.isEmpty) return 0;
    final today = _parseDay(_dayKey(now ?? DateTime.now()));
    if (today == null) return 0;
    final gap = today.difference(days.last).inDays;
    if (gap > 1) return 0;
    return _streaks().$2;
  }

  (int, int) _streaks() {
    final days = _sortedDays;
    if (days.isEmpty) return (0, 0);
    var best = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      // en UTC: sumar/restar días en local se descuadra con el cambio de hora
      final gap = days[i].difference(days[i - 1]).inDays;
      run = gap == 1 ? run + 1 : 1;
      if (run > best) best = run;
    }
    return (best, run);
  }

  /// Semanas seguidas (de lunes a domingo) en las que hubo actividad.
  int get weeksInARow {
    final weeks = <DateTime>{
      for (final d in _sortedDays) d.subtract(Duration(days: d.weekday - 1))
    }.toList()
      ..sort();
    if (weeks.isEmpty) return 0;
    var best = 1;
    var run = 1;
    for (var i = 1; i < weeks.length; i++) {
      run = weeks[i].difference(weeks[i - 1]).inDays == 7 ? run + 1 : 1;
      if (run > best) best = run;
    }
    return best;
  }

  /// Apunta que hoy has usado la app.
  void markDayActive({DateTime? now}) {
    final key = _dayKey(now ?? DateTime.now());
    if (!_days.add(key)) return; // ya estaba: no reescribir el fichero
    notifyListeners();
    _save();
  }

  // --- logros y contadores -------------------------------------------------

  /// Guarda logros nuevos. Los que ya estaban conservan su fecha original.
  void unlockAll(Iterable<String> ids, {DateTime? at}) {
    final stamp = (at ?? DateTime.now()).toIso8601String();
    var changed = false;
    for (final id in ids) {
      if (_unlocked.containsKey(id)) continue;
      _unlocked[id] = stamp;
      changed = true;
    }
    if (!changed) return;
    notifyListeners();
    _save();
  }

  /// Olvida logros guardados. Solo lo usa "recalcular": sirve para tirar
  /// los que se dieron por un cálculo equivocado, y por eso NUNCA pasa sola.
  void forget(Iterable<String> ids) {
    var changed = false;
    for (final id in ids) {
      if (_unlocked.remove(id) != null) changed = true;
    }
    if (!changed) return;
    notifyListeners();
    _save();
  }

  /// Suma al contador (cartas escaneadas, carpetas creadas…).
  void bump(String key, [int by = 1]) {
    if (by == 0) return;
    _counters[key] = counter(key) + by;
    notifyListeners();
    _save();
  }

  /// Deja el contador en [value] solo si mejora el récord.
  void raise(String key, int value) {
    if (value <= counter(key)) return;
    _counters[key] = value;
    notifyListeners();
    _save();
  }

  // --- persistencia --------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'unlocked': _unlocked,
        'counters': _counters,
        'days': _days.toList()..sort(),
        'lastSeenLevel': _lastSeenLevel,
      };

  /// Carga desde un mapa ya decodificado. Tolera basura: si un trozo no tiene
  /// la forma esperada, se ignora ESE trozo en vez de perderlo todo.
  void restore(Map<String, dynamic> json) {
    _unlocked.clear();
    _counters.clear();
    _days.clear();
    final unlocked = json['unlocked'];
    if (unlocked is Map) {
      unlocked.forEach((k, v) {
        if (k is String && v is String) _unlocked[k] = v;
      });
    }
    final counters = json['counters'];
    if (counters is Map) {
      counters.forEach((k, v) {
        if (k is String && v is int) _counters[k] = v;
      });
    }
    final days = json['days'];
    if (days is List) {
      for (final d in days) {
        if (d is String && _parseDay(d) != null) _days.add(d);
      }
    }
    final level = json['lastSeenLevel'];
    _lastSeenLevel = level is int && level > 0 ? level : 1;
    notifyListeners();
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'achievements.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  /// Carga (una sola vez) y deja el futuro a mano: quien vaya a evaluar
  /// logros DEBE esperarlo, o evaluaría con cero desbloqueos y guardaría un
  /// fichero que se come los logros viejos.
  Future<void> load() => _loading ??= _load();

  /// Lo mismo que [load], pensado para hacer `await store.ready`.
  Future<void> get ready => load();

  Future<void> _load() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    // el try cubre SOLO la lectura y el decode: `restore()` no puede
    // apartar como roto un fichero que se ha leído perfectamente solo
    // porque algo DESPUÉS del decode (un listener, por ejemplo) revienta
    Map<String, dynamic>? decoded;
    try {
      final raw = jsonDecode(await file.readAsString());
      if (raw is Map<String, dynamic>) decoded = raw;
    } catch (_) {
      // fichero corrupto: apartarlo con otro nombre en vez de arrancar vacío
      // y escribirle encima — así no se pierden sin rastro la racha y los
      // logros desbloqueados
      await setAsideBroken(file);
      return;
    }
    if (decoded != null) restore(decoded);
  }

  /// Cola de escrituras: desbloquear varios logros de golpe llamaba a varios
  /// guardados a la vez y se pisaban el fichero temporal (el segundo
  /// `rename` reventaba porque el primero ya se lo había llevado).
  Future<void> _queue = Future.value();
  bool _pendingSave = false;

  void _save() {
    // si ya hay una escritura encolada, esa verá el estado FINAL: encolar
    // otra solo repetiría el mismo JSON (importar 300 cartas encolaba 300)
    if (_pendingSave) return;
    _pendingSave = true;
    _queue = _queue.then((_) {
      _pendingSave = false;
      return _write();
    }).catchError((Object _) {
      _pendingSave = false; // la cola sigue viva si una escritura falla
    });
  }

  /// Espera a que la cola de guardado vacíe. Los `_save()` son
  /// fire-and-forget: sin esto, un test que mira el fichero puede llegar
  /// antes que la escritura (y fallar solo a veces, en la máquina lenta de
  /// turno).
  @visibleForTesting
  Future<void> get pendingSave => _queue;

  /// Temporal + rename: un corte a media escritura no debe borrar años de
  /// logros.
  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(toJson()), flush: true);
    await tmp.rename(file.path);
  }
}

/// 'YYYY-MM-DD' del día LOCAL (el día del usuario), pero guardado como fecha
/// sin hora para que las restas se hagan en UTC y el cambio de hora no
/// invente ni se coma días.
String _dayKey(DateTime when) {
  two(int n) => n < 10 ? '0$n' : '$n';
  return '${when.year}-${two(when.month)}-${two(when.day)}';
}

DateTime? _parseDay(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  if (m < 1 || m > 12 || d < 1 || d > 31) return null;
  return DateTime.utc(y, m, d);
}
