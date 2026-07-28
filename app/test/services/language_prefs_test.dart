/// El idioma de la app.
///
/// Dos reglas: se pregunta UNA vez (cerrar el diálogo también es contestar) y
/// un código que no esté en la lista no puede dejar la app en un idioma que
/// no existe.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/language_prefs.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mf-idioma'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('de fábrica: el del sistema, y sin preguntar todavía', () async {
    final prefs = LanguagePreference(dataDir: dir);
    await prefs.load();

    expect(prefs.locale, isNull);
    expect(prefs.asked, isFalse);
  });

  test('elegir idioma lo guarda y cuenta como contestado', () async {
    final uno = LanguagePreference(dataDir: dir);
    await uno.select('ja');

    final otro = LanguagePreference(dataDir: dir);
    await otro.load();

    expect(otro.code, 'ja');
    expect(otro.asked, isTrue); // no se vuelve a preguntar
  });

  test('cerrar el diálogo sin elegir también es contestar', () async {
    final uno = LanguagePreference(dataDir: dir);
    await uno.markAsked();

    final otro = LanguagePreference(dataDir: dir);
    await otro.load();

    expect(otro.asked, isTrue);
    expect(otro.locale, isNull); // sigue el del sistema
  });

  test('volver al idioma del sistema', () async {
    final prefs = LanguagePreference(dataDir: dir);
    await prefs.select('de');
    await prefs.select(null);

    expect(prefs.locale, isNull);
  });

  test('un idioma que no está en la lista no se acepta', () async {
    final prefs = LanguagePreference(dataDir: dir);
    await prefs.select('klingon');

    expect(prefs.locale, isNull);
  });

  test('un fichero manipulado no deja la app en un idioma inexistente',
      () async {
    File('${dir.path}/language.json')
        .writeAsStringSync(jsonEncode({'language': 'xx', 'asked': true}));

    final prefs = LanguagePreference(dataDir: dir);
    await prefs.load();

    expect(prefs.locale, isNull);
  });

  test('dos load() a la vez: el segundo espera al primero, no vuelve vacío',
      () async {
    // regresión: con un `bool _loaded` puesto ANTES de leer el disco, el
    // segundo load() volvía enseguida con `asked == false` y el diálogo de
    // idioma salía otra vez en un arranque en el que ya se había contestado
    File('${dir.path}/language.json')
        .writeAsStringSync(jsonEncode({'language': 'ja', 'asked': true}));

    final prefs = LanguagePreference(dataDir: dir);
    unawaited(prefs.load()); // el de main(), todavía leyendo el disco
    await prefs.load(); // el del diálogo, que da por hecho que ya está

    expect(prefs.asked, isTrue);
    expect(prefs.code, 'ja');
  });

  test('guardar dos veces seguidas no pierde ninguna de las dos cosas',
      () async {
    // regresión: `select()` y `markAsked()` caen juntos al primer arranque y
    // escribían el mismo `.tmp` a la vez
    final prefs = LanguagePreference(dataDir: dir);
    await Future.wait([prefs.select('fr'), prefs.markAsked()]);

    final otro = LanguagePreference(dataDir: dir);
    await otro.load();

    expect(otro.code, 'fr');
    expect(otro.asked, isTrue);
  });

  test('los idiomas son los oficiales de Magic, sin repetidos', () {
    final codigos = kAppLanguages.map((l) => l.code).toList();

    expect(codigos.toSet().length, codigos.length);
    expect(codigos.first, 'es'); // el idioma de casa va primero
    for (final oficial in ['en', 'ja', 'zh', 'ko', 'de', 'fr', 'it', 'pt',
      'ru']) {
      expect(codigos, contains(oficial));
    }
  });

  test('cada idioma dice su nombre en su propio idioma', () {
    for (final idioma in kAppLanguages) {
      expect(idioma.nativeName.trim(), isNotEmpty);
    }
    expect(
        kAppLanguages.firstWhere((l) => l.code == 'ja').nativeName, '日本語');
  });
}
