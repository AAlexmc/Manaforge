/// El tour por encima de las pantallas EMPUJADAS (Logros, Certificados).
///
/// Logros y Certificados no son pestañas: se abren con Navigator.push y se
/// pintan por encima de HomeShell. Mientras el tour vivía en el Stack de
/// HomeShell, un paso que las abriera se quedaba tapado por la pantalla que
/// acababa de abrir. Ahora lo pinta el builder del MaterialApp, que envuelve
/// al Navigator entero.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/main.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/services/language_prefs.dart';

/// Arranca la app de verdad y deja la pantalla de Inicio delante.
Future<void> _arrancar(WidgetTester tester) async {
  tester.platformDispatcher.localesTestValue = const [Locale('es')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  tester.view.physicalSize = const Size(1200, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // las preferencias piden la carpeta de datos por el canal de plataforma, y
  // ese canal no avanza dentro del reloj falso de testWidgets
  final idioma = LanguagePreference();
  final fondo = BackgroundPreference();
  await tester.runAsync(() async {
    await idioma.load();
    await fondo.load();
  });

  await tester.pumpWidget(ManaForgeApp(language: idioma, background: fondo));
  await tester.pump(const Duration(milliseconds: 100));
  // pantalla de arranque: sin carpeta de datos no hay nada que descargar
  await tester.pump(const Duration(seconds: 4));
  await tester.pump(const Duration(milliseconds: 100));

  // primer arranque: pregunta el idioma UNA vez
  if (find.text('Español').evaluate().isNotEmpty) {
    await tester.tap(find.text('Español'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }
}

/// Elige un tour en el menú "?" de Inicio.
Future<void> _lanzarTour(WidgetTester tester, String nombre) async {
  await tester.tap(find.byIcon(Icons.help_outline));
  // la hoja entra deslizándose: hasta que no termina, sus botones están
  // dibujados FUERA de la pantalla y el toque no los alcanza
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.tap(find.text(nombre));
  // el bottom sheet se cierra, el tour entra y da dos frames para cambiar de
  // pantalla y medir
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('el tour abre Logros y se ve POR ENCIMA de ella',
      (tester) async {
    await _arrancar(tester);
    await _lanzarTour(tester, 'Logros y certificados');

    // la pantalla empujada está abierta…
    expect(find.text('Logros'), findsWidgets);
    // …y la burbuja del tour se ve encima, con sus botones
    expect(find.text('Logros y nivel'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);
  });

  testWidgets('siguiente cierra Logros y abre Certificados (no se apilan)',
      (tester) async {
    await _arrancar(tester);
    await _lanzarTour(tester, 'Logros y certificados');

    // si la burbuja estuviera DEBAJO de la pantalla empujada, este toque no
    // llegaría al botón y el tour no avanzaría
    await tester.tap(find.text('Siguiente'));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Certificados'), findsWidgets);
    expect(find.textContaining('diploma'), findsOneWidget); // la burbuja
    // la de antes se ha cerrado: no quedan dos pantallas apiladas
    expect(find.text('Logros y nivel'), findsNothing);
  });

  testWidgets('al terminar, el tour cierra la pantalla que abrió',
      (tester) async {
    await _arrancar(tester);
    await _lanzarTour(tester, 'Logros y certificados');

    await tester.tap(find.text('Siguiente')); // paso 2: Certificados
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(find.text('Entendido')); // último paso: termina
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // de vuelta en Inicio, sin tour y sin la pantalla empujada
    expect(find.textContaining('diploma'), findsNothing);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });
}
