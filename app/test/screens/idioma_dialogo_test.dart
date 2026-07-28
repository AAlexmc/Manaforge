/// El pop-up de idioma del primer arranque.
///
/// Sale UNA vez. La segunda vez que abres la app no puede volver a salir, o
/// se convierte en un peaje.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/services/language_prefs.dart';
import 'package:manaforge_app/ui/settings/widgets/language_picker_dialog.dart';

Widget _app(LanguagePreference prefs) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => maybeAskLanguage(context, prefs),
            child: const Text('arrancar'),
          ),
        ),
      ),
    );

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mf-idioma-ui'));
  tearDown(() => dir.deleteSync(recursive: true));

  testWidgets('la primera vez pregunta, y en su propio idioma cada uno',
      (tester) async {
    final prefs = LanguagePreference(dataDir: dir);
    // el estado se lee del disco ANTES: dentro del reloj falso de
    // testWidgets una lectura de verdad no avanza nunca
    await tester.runAsync(() => prefs.load());
    await tester.pumpWidget(_app(prefs));

    await tester.tap(find.text('arrancar'));
    await tester.pumpAndSettle();

    expect(find.text('日本語'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
  });

  testWidgets('elegir cierra el diálogo y deja el idioma puesto',
      (tester) async {
    final prefs = LanguagePreference(dataDir: dir);
    await tester.runAsync(() => prefs.load());
    await tester.pumpWidget(_app(prefs));
    await tester.tap(find.text('arrancar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();

    expect(prefs.code, 'ja');
    expect(find.text('한국어'), findsNothing); // se cerró
  });

  testWidgets('la segunda vez ya no pregunta', (tester) async {
    final prefs = LanguagePreference(dataDir: dir);
    await tester.runAsync(() => prefs.markAsked());

    await tester.pumpWidget(_app(prefs));
    await tester.tap(find.text('arrancar'));
    await tester.pumpAndSettle();

    expect(find.text('日本語'), findsNothing);
  });
}
