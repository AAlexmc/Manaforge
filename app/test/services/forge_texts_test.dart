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
import 'package:manaforge_app/ui/forge/forge_texts.dart';

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

  // I1: themeName es lo que enseñan la tarjeta de resultado
  // (forge_screen.dart), el detalle del mazo (deck_detail_screen.dart) y
  // Modo Test (test_screen.dart) — no solo el selector de Estilo. Antes del
  // fix interpolaba el subtipo EN INGLÉS crudo ("Elf") en TODOS los
  // idiomas, tribeName (24 traducciones de esta rama) solo se usaba en la
  // hoja del selector y el chip.
  test('themeName tribal usa tribeName traducido en los 10 idiomas, no el '
      'subtipo crudo en inglés (I1)', () {
    for (final entry in locales.entries) {
      final t = entry.value;
      expect(themeName(t, 'tribal:Elf'), t.fxThemeTribal(tribeName(t, 'Elf')),
          reason: entry.key);
    }
  });

  test('themeName tribal en japonés no enseña el subtipo inglés crudo (I1)',
      () {
    // Antes del fix: "Elf部族" en TODOS los idiomas (el motor solo sabe el
    // subtipo en inglés). Con el fix: tribeName lo traduce a "エルフ".
    final ja = locales['ja']!;
    expect(themeName(ja, 'tribal:Elf'), isNot(contains('Elf')));
    expect(themeName(ja, 'tribal:Elf'), contains('エルフ'));
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
    expect(themeName(t, 'tribal:Goblin'), contains('Trasgos')); // fgTribeGoblin
    expect(themeName(t, 'tribal:Elf'), isNot(contains('Trasgos')));
  });

  test('tribu fuera de la lista curada cae al subtipo tal cual (fallback)',
      () {
    final t = locales['es']!;
    expect(themeName(t, 'tribal:Ooze'), contains('Ooze'));
  });
}
