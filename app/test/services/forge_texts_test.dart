/// Los microcopys de Forge hablan el idioma de la app, incluidos los temas
/// nuevos con hueco dinámico: tribu ({tribe}, el subtipo EN INGLÉS) y
/// reanimator (sin hueco).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/app_localizations_de.dart';
import 'package:manaforge_app/l10n/app_localizations_en.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/l10n/app_localizations_fr.dart';
import 'package:manaforge_app/l10n/app_localizations_it.dart';
import 'package:manaforge_app/l10n/app_localizations_ja.dart';
import 'package:manaforge_app/l10n/app_localizations_ko.dart';
import 'package:manaforge_app/l10n/app_localizations_pt.dart';
import 'package:manaforge_app/l10n/app_localizations_ru.dart';
import 'package:manaforge_app/l10n/app_localizations_zh.dart';
import 'package:manaforge_app/services/forge_texts.dart';

void main() {
  final locales = <String, AppLocalizations>{
    'de': AppLocalizationsDe(),
    'en': AppLocalizationsEn(),
    'es': AppLocalizationsEs(),
    'fr': AppLocalizationsFr(),
    'it': AppLocalizationsIt(),
    'ja': AppLocalizationsJa(),
    'ko': AppLocalizationsKo(),
    'pt': AppLocalizationsPt(),
    'ru': AppLocalizationsRu(),
    'zh': AppLocalizationsZh(),
  };

  test('tribal:Elf produce texto con "Elf" en los 10 idiomas', () {
    for (final entry in locales.entries) {
      final name = themeName(entry.value, 'tribal:Elf');
      expect(name, contains('Elf'), reason: entry.key);
    }
  });

  test('reanimator tiene nombre propio en los 10 idiomas', () {
    for (final entry in locales.entries) {
      expect(themeName(entry.value, 'reanimator'), isNotEmpty,
          reason: entry.key);
    }
  });

  test('un tema que el motor no mapea cae a su clave cruda', () {
    expect(themeName(locales['es']!, 'algo-inventado'), 'algo-inventado');
  });

  test('tribu con otro subtipo interpola el que toca (no queda fijo)', () {
    final t = locales['es']!;
    expect(themeName(t, 'tribal:Goblin'), contains('Goblin'));
    expect(themeName(t, 'tribal:Elf'), isNot(contains('Goblin')));
  });
}
