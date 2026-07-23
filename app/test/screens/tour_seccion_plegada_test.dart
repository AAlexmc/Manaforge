/// El tour despliega la sección plegada antes de señalar lo que hay dentro.
///
/// La copia de seguridad vive en Ajustes → "Datos", que nace PLEGADA: sin
/// abrirla, la tarjeta no está en pantalla y el paso se quedaría sin diana.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/main.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/services/language_prefs.dart';

Future<void> _arrancar(WidgetTester tester) async {
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
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }
}

Future<void> _pumps(WidgetTester tester, {int veces = 10}) async {
  for (var i = 0; i < veces; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('el tour de Ajustes abre "Datos" para enseñar la copia',
      (tester) async {
    await _arrancar(tester);

    await tester.tap(find.byIcon(Icons.help_outline));
    await _pumps(tester, veces: 12); // la hoja entra deslizándose
    await tester.tap(find.text('Personalizar la app'));
    await _pumps(tester);

    // paso 1: enseña el botón de Ajustes en la barra; "Datos" sigue plegada
    expect(find.textContaining('Pulsa aquí'), findsOneWidget);
    expect(find.text('Guardar copia'), findsNothing);

    // 2 idioma · 3 aspecto · 4 editar inicio · 5 Datos (despliega)
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Siguiente'));
      await _pumps(tester, veces: 14); // + la animación de la sección
    }
    expect(find.text('Base de datos de cartas'), findsWidgets); // desplegada

    // 6 base de cartas · 7 copia de seguridad
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Siguiente'));
      await _pumps(tester, veces: 12);
    }
    expect(find.text('Copia de seguridad'), findsWidgets); // burbuja y tarjeta
    expect(find.text('Guardar copia'), findsOneWidget);

    // 8 La app: la última sección también se despliega sola
    await tester.tap(find.text('Siguiente'));
    await _pumps(tester, veces: 14);
    expect(find.text('Cómo funciona'), findsWidgets);

    // 9 cómo funciona · 10 versión (el final del recorrido)
    await tester.tap(find.text('Siguiente'));
    await _pumps(tester, veces: 12);
    await tester.tap(find.text('Siguiente'));
    await _pumps(tester, veces: 12);
    expect(find.text('Versión de ManaForge'), findsWidgets);
    expect(find.text('Entendido'), findsOneWidget); // último paso
  });
}
