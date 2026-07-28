/// Qué se ve en Inicio y en qué orden.
///
/// Inicio era una lista fija: valor de la colección, nivel, accesos y cinco
/// tiras. Aquí el usuario decide QUÉ secciones quiere y en qué ORDEN. Lo único
/// que no entra es el héroe (el valor de la colección / la bienvenida) y la
/// cabecera: son el ancla de la pantalla y el camino del primer uso.
///
/// Se guarda por NOMBRE, no por índice: así el fichero se puede retocar sin
/// romper lo guardado, un id que no existe se ignora, y una versión nueva con
/// una sección nueva la enseña sin que el usuario tenga que tocar nada (las
/// secciones conocidas que falten en el fichero se añaden al final).
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/services/json_store_io.dart';

/// Las secciones del Inicio que se pueden encender/apagar y reordenar, en su
/// orden por defecto. El héroe y la cabecera NO están: son fijos.
const List<String> kHomeSections = [
  'nivel',
  'accesos',
  'resumen',
  'recientes',
  'mazos',
  'meta',
  'expansiones',
  'joyas',
];

/// Una sección con si está visible, para pintar el editor.
class HomeSectionState {
  final String id;
  final bool visible;

  const HomeSectionState(this.id, this.visible);
}

/// El layout de Inicio, persistido en `home_layout.json`.
class HomeLayoutPreference extends ChangeNotifier {
  /// Solo para tests: dónde vive el JSON.
  final Directory? dataDir;

  HomeLayoutPreference({this.dataDir});

  List<String> _orden = List.of(kHomeSections);
  final Set<String> _ocultas = {};
  Future<void>? _loading;
  bool _cargado = false;

  /// Se comparte la ESPERA, no un `bool` puesto antes de leer: con el booleano
  /// marcado de antemano, un segundo `load()` simultáneo volvía con el layout
  /// vacío. Ya leído, un futuro nuevo — ver la explicación larga en
  /// `language_prefs.dart`.
  Future<void> load() => _cargado ? Future.value() : (_loading ??= _load());

  Future<void> _load() async {
    try {
      await _leer();
    } finally {
      _cargado = true;
    }
  }

  /// Ids visibles, en el orden del usuario. Esto es lo que pinta Inicio.
  List<String> get ordenVisible =>
      [for (final id in _orden) if (!_ocultas.contains(id)) id];

  /// Todas las secciones en orden, con si están visibles. Para el editor.
  List<HomeSectionState> get todas =>
      [for (final id in _orden) HomeSectionState(id, !_ocultas.contains(id))];

  bool esVisible(String id) => !_ocultas.contains(id);

  /// Enciende o apaga una sección. Un id que no es del catálogo se ignora.
  Future<void> toggle(String id) async {
    if (!kHomeSections.contains(id)) return;
    if (!_ocultas.remove(id)) _ocultas.add(id);
    notifyListeners();
    await _save();
  }

  /// Mueve la sección de [desde] a la posición final [hasta] (ya descontado el
  /// hueco que deja al salir: el widget hace el `-1` de `ReorderableListView`).
  Future<void> reordenar(int desde, int hasta) async {
    if (desde < 0 || desde >= _orden.length) return;
    if (hasta < 0) hasta = 0;
    if (hasta >= _orden.length) hasta = _orden.length - 1;
    if (hasta == desde) return;
    final id = _orden.removeAt(desde);
    _orden.insert(hasta, id);
    notifyListeners();
    await _save();
  }

  /// Vuelve al orden de fábrica y enciende todo.
  Future<void> restablecer() async {
    _orden = List.of(kHomeSections);
    _ocultas.clear();
    notifyListeners();
    await _save();
  }

  Future<void> _leer() async {
    final file = await _prefsFile();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return;
      final orden = <String>[];
      final vistos = <String>{};
      final rawOrden = decoded['orden'];
      if (rawOrden is List) {
        for (final x in rawOrden) {
          // solo ids del catálogo, sin repetir: un fichero manipulado no mete
          // secciones que la app no sabría pintar
          if (x is String && kHomeSections.contains(x) && vistos.add(x)) {
            orden.add(x);
          }
        }
      }
      // las secciones conocidas que falten (fichero viejo, versión nueva) van
      // al final en su orden por defecto
      for (final id in kHomeSections) {
        if (vistos.add(id)) orden.add(id);
      }
      _orden = orden;
      _ocultas.clear();
      final rawOcultas = decoded['ocultas'];
      if (rawOcultas is List) {
        for (final x in rawOcultas) {
          if (x is String && kHomeSections.contains(x)) _ocultas.add(x);
        }
      }
      notifyListeners();
    } catch (_) {
      // fichero raro: el layout de siempre, que es como estaba
    }
  }

  Future<Directory?> _dir() async {
    try {
      return dataDir ?? await getApplicationSupportDirectory();
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  Future<File?> _prefsFile() async {
    final dir = await _dir();
    return dir == null ? null : File(p.join(dir.path, 'home_layout.json'));
  }

  /// En fila india, y la fila nace en la primera escritura (no en un campo):
  /// la misma trampa del reloj falso de `testWidgets` que en `language_prefs`.
  Future<void>? _fila;

  Future<void> _save() {
    final anterior = _fila;
    final actual =
        anterior == null ? _write() : anterior.then((_) => _write());
    _fila = actual;
    return actual;
  }

  Future<void> _write() async {
    final file = await _prefsFile();
    if (file == null) return;
    try {
      await writeJsonFile(
          file,
          jsonEncode({
            'orden': _orden,
            'ocultas': _ocultas.toList(),
          }));
    } catch (_) {
      // no poder guardar el layout no puede tumbar la app
    }
  }
}
