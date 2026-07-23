/// Los certificados hablan el idioma de la app: encabezados, subtítulos,
/// título del de bienvenida, "N cartas" (con plural) y la fecha.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:manaforge_app/l10n/app_localizations_en.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';

void main() {
  final es = AppLocalizationsEs();
  final en = AppLocalizationsEn();

  test('encabezados y títulos cambian con el idioma', () {
    expect(es.certHeadingSetComplete, 'CERTIFICADO DE COLECCIÓN COMPLETA');
    expect(en.certHeadingSetComplete, 'COMPLETE COLLECTION CERTIFICATE');
    expect(es.certHeadingWelcome, 'CERTIFICADO DE BIENVENIDA');
    expect(en.certHeadingWelcome, 'WELCOME CERTIFICATE');
    expect(es.certWelcomeTitle, 'Bienvenido al mundo de Magic');
    expect(en.certWelcomeTitle, 'Welcome to the world of Magic');
  });

  test('"N cartas" respeta singular/plural en cada idioma', () {
    expect(es.certCards(1), '1 carta');
    expect(es.certCards(291), '291 cartas');
    expect(en.certCards(1), '1 card');
    expect(en.certCards(291), '291 cards');
  });

  test('los nombres se insertan en el idioma', () {
    expect(es.certAwardedTo('Ale'), 'Otorgado a Ale');
    expect(en.certAwardedTo('Ale'), 'Awarded to Ale');
    expect(es.certCollectorAnon, 'Coleccionista de ManaForge');
    expect(en.certCollectorAnon, 'ManaForge collector');
  });

  test('la fecha del papel se escribe según el idioma', () async {
    await initializeDateFormatting();
    final d = DateTime(2026, 7, 21);
    expect(DateFormat.yMMMMd('es').format(d), '21 de julio de 2026');
    expect(DateFormat.yMMMMd('en').format(d), 'July 21, 2026');
  });
}
