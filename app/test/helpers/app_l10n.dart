/// MaterialApp de pruebas con las traducciones puestas.
///
/// Sin los delegados, `AppLocalizations.of(context)` revienta: la app real
/// los tiene y los tests también deben tenerlos, o se prueba algo que no es
/// la app.
library;

import 'package:flutter/material.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';

MaterialApp appDePrueba({required Widget home, Locale locale = const Locale('es')}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
