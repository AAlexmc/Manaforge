/// El idioma de las guías sigue al de la app, también con un tour abierto.
///
/// Antes los pasos se construían UNA vez, al lanzar el tour: cambiar el idioma
/// desde Ajustes dejaba las burbujas congeladas en el idioma anterior.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/main.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/services/language_prefs.dart';

Future<void> _pumps(WidgetTester tester, {int veces = 10}) async {
  for (var i = 0; i < veces; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('cambiar de idioma cambia también las burbujas del tour',
      (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final idioma = LanguagePreference();
    final fondo = BackgroundPreference();
    await tester.runAsync(() async {
      await idioma.load();
      await fondo.load();
    });
    await tester.pumpWidget(ManaForgeApp(language: idioma, background: fondo));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 100));
    if (find.text('Español').evaluate().isNotEmpty) {
      await tester.tap(find.text('Español'));
      await _pumps(tester, veces: 6);
    }

    // un tour cualquiera, en español
    await tester.tap(find.byIcon(Icons.help_outline));
    await _pumps(tester, veces: 12);
    await tester.tap(find.text('La pantalla de inicio'));
    await _pumps(tester);
    expect(find.text('Personaliza tu inicio'), findsOneWidget);
    expect(find.text('Siguiente'), findsNothing); // un solo paso
    expect(find.text('Entendido'), findsOneWidget);

    // y ahora en inglés, SIN cerrar el tour. Sin esperar al guardado: escribe
    // en la carpeta de datos, que en un test no existe (y esperarla cuelga)
    idioma.select('en');
    await _pumps(tester);

    expect(find.text('Customize your home'), findsOneWidget);
    expect(find.text('Got it'), findsOneWidget);
  });
}
