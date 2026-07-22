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
  bool _loaded = false;

  /// ¿Se le ha preguntado ya al usuario en qué idioma quiere la app? Se
  /// pregunta UNA vez, al primer arranque; después se cambia en Ajustes.
  bool _asked = false;

  bool get asked => _asked;

  /// Idioma elegido a mano. `null` = el del sistema.
  Locale? get locale => _locale;

  String? get code => _locale?.languageCode;

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
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

  Future<void> _save() async {
    final file = await _file();
    if (file == null) return;
    try {
      final tmp = File('${file.path}.tmp');
      await tmp.writeAsString(
          jsonEncode({
            if (_locale != null) 'language': _locale!.languageCode,
            'asked': _asked,
          }),
          flush: true);
      await tmp.rename(file.path);
    } catch (_) {
      // no poder guardar el idioma no puede tumbar la app
    }
  }
}
