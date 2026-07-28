/// Si el usuario ya vio el tour de bienvenida: las burbujas que, en el primer
/// arranque, señalan la barra de abajo (colección, escanear, forge, mazos).
///
/// Se enseña UNA vez. Aquí solo viven el dato y su guardado en `onboarding.json`,
/// para poder probarlo sin plugin; quien pinta las burbujas es la pantalla.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/data/services/json_store_io.dart';

class OnboardingPreference extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  OnboardingPreference({this.dataDir});

  bool _seen = false;

  /// ¿Ya se vio el tour? Antes de [load] se asume que no, pero la pantalla
  /// espera a [cargado] para no enseñarlo y quitarlo con un parpadeo.
  bool get seen => _seen;

  bool _cargado = false;

  /// ¿Se ha leído ya el disco? Hasta que no, no se decide si hay tour.
  bool get cargado => _cargado;

  Future<void>? _loading;

  /// Se comparte la ESPERA mientras se lee el disco — ver la explicación larga
  /// en `language_prefs.dart`.
  Future<void> load() => _cargado ? Future.value() : (_loading ??= _load());

  Future<void> _load() async {
    try {
      await _leer();
    } finally {
      _cargado = true;
      notifyListeners();
    }
  }

  Future<void> _leer() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map && decoded['seen'] == true) _seen = true;
    } catch (_) {
      // fichero raro: como si no se hubiera visto (peor es no volver a verlo)
    }
  }

  /// Marca el tour como visto y lo guarda. Idempotente.
  Future<void> markSeen() async {
    if (_seen) return;
    _seen = true;
    notifyListeners();
    await _save();
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'onboarding.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  Future<void> _save() async {
    final file = await _file();
    if (file == null) return;
    try {
      await writeJsonFile(file, jsonEncode({'seen': _seen}));
    } catch (_) {
      // si no se puede guardar, peor caso: el tour vuelve a salir. No pasa nada.
    }
  }
}
