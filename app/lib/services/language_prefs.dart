/// En qué idioma se ve la app.
///
/// Por defecto, el del sistema: quien abre la app en un ordenador en japonés
/// no tiene por qué saber dónde se cambia. Y si el idioma del sistema no está
/// entre los que hay, Flutter cae al primero de la lista (el español, que es
/// el idioma de casa).
///
/// Los idiomas son los OFICIALES de Magic —los que Wizards imprime en las
/// cartas— más nada inventado: inglés, español, japonés, chino simplificado,
/// coreano, alemán, francés, italiano, portugués y ruso.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/services/json_store_io.dart';

/// Un idioma que se puede elegir, con su nombre EN SU PROPIO idioma: quien
/// busca "日本語" no está leyendo "japonés".
class AppLanguage {
  final String code;
  final String nativeName;

  const AppLanguage(this.code, this.nativeName);
}

/// El español va primero porque es el idioma en el que está escrita la app y
/// el que se usa cuando el del sistema no está en la lista.
const List<AppLanguage> kAppLanguages = [
  AppLanguage('es', 'Español'),
  AppLanguage('en', 'English'),
  AppLanguage('ja', '日本語'),
  AppLanguage('zh', '简体中文'),
  AppLanguage('ko', '한국어'),
  AppLanguage('de', 'Deutsch'),
  AppLanguage('fr', 'Français'),
  AppLanguage('it', 'Italiano'),
  AppLanguage('pt', 'Português'),
  AppLanguage('ru', 'Русский'),
];

class LanguagePreference extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  LanguagePreference({this.dataDir});

  Locale? _locale;
  Future<void>? _loading;

  /// ¿Se le ha preguntado ya al usuario en qué idioma quiere la app? Se
  /// pregunta UNA vez, al primer arranque; después se cambia en Ajustes.
  bool _asked = false;

  bool get asked => _asked;

  /// Idioma elegido a mano. `null` = el del sistema.
  Locale? get locale => _locale;

  String? get code => _locale?.languageCode;

  /// Mientras se lee el disco se comparte la ESPERA, no un booleano puesto de
  /// antemano: con el `bool` marcado ANTES de leer, un segundo `load()`
  /// mientras el primero sigue leyendo volvía enseguida y con todo vacío —
  /// aquí eso era `asked == false` y volver a preguntar el idioma en cada
  /// arranque.
  ///
  /// Cuando ya está leído se devuelve un futuro nuevo en vez de el de la
  /// lectura: el de la lectura nació en la zona de quien llamó primero, y
  /// esperarlo desde otra (el reloj falso de `testWidgets`) no vuelve.
  Future<void> load() => _cargado ? Future.value() : (_loading ??= _load());

  bool _cargado = false;

  Future<void> _load() async {
    try {
      await _leer();
    } finally {
      _cargado = true;
    }
  }

  Future<void> _leer() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return;
      _asked = decoded['asked'] == true;
      final code = decoded['language'];
      // solo se acepta un idioma de la lista: un código cualquiera en el
      // fichero dejaría la app en un idioma que no existe
      if (code is String && kAppLanguages.any((l) => l.code == code)) {
        _locale = Locale(code);
        notifyListeners();
      }
    } catch (_) {
      // fichero raro: el del sistema, que es como estaba
    }
  }

  /// Da por hecha la pregunta del primer arranque (aunque no elija nada:
  /// cerrar el diálogo también es una respuesta).
  Future<void> markAsked() async {
    if (_asked) return;
    _asked = true;
    await _save();
  }

  /// [code] null = volver al idioma del sistema.
  Future<void> select(String? code) async {
    if (code != null && !kAppLanguages.any((l) => l.code == code)) return;
    final nuevo = code == null ? null : Locale(code);
    if (nuevo?.languageCode == _locale?.languageCode) return;
    _locale = nuevo;
    _asked = true; // elegir ya es haber contestado
    notifyListeners();
    await _save();
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'language.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  /// Los guardados van en fila india: al primer arranque `select()` y
  /// `markAsked()` caen casi a la vez, y dos escrituras sueltas sobre el mismo
  /// `.tmp` se entrelazan (una renombra lo que la otra está escribiendo).
  ///
  /// La fila NO arranca con un `Future.value()` guardado en un campo, que es
  /// como la hacen los almacenes viejos: ese futuro nace al construir el
  /// objeto, o sea en la zona del reloj falso de `testWidgets`, y esperarlo
  /// desde `runAsync` no vuelve nunca (la zona falsa no corre sus microtareas
  /// mientras `runAsync` está dentro). Aquí la fila nace en la primera
  /// escritura, en la zona de quien la pide.
  Future<void>? _fila;

  Future<void> _save() {
    final anterior = _fila;
    final actual =
        anterior == null ? _write() : anterior.then((_) => _write());
    _fila = actual;
    return actual;
  }

  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    try {
      await writeJsonFile(
          file,
          jsonEncode({
            if (_locale != null) 'language': _locale!.languageCode,
            'asked': _asked,
          }));
    } catch (_) {
      // no poder guardar el idioma no puede tumbar la app
    }
  }
}
