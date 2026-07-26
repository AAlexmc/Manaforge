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

import '../helpers/tour_foco.dart';

Future<void> _arrancar(WidgetTester tester,
    {Size size = const Size(1200, 1600)}) async {
  tester.platformDispatcher.localesTestValue = const [Locale('es')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  tester.view.physicalSize = size;
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

    // 9 cómo funciona · 10 versión · 11 sugerencias · 12 apoyar el proyecto
    // (el final del recorrido: no se fija el número, solo que "Siguiente"
    // sigue habiendo hasta llegar a "Entendido")
    await tester.tap(find.text('Siguiente'));
    await _pumps(tester, veces: 12);
    await tester.tap(find.text('Siguiente'));
    await _pumps(tester, veces: 12);
    expect(find.text('Versión de ManaForge'), findsWidgets);

    for (var i = 0;
        i < 20 && find.text('Entendido').evaluate().isEmpty;
        i++) {
      await tester.tap(find.text('Siguiente'));
      await _pumps(tester, veces: 12);
    }
    expect(find.text('Entendido'), findsOneWidget); // el tour TERMINA
    expect(find.text('Apoyar el proyecto'), findsWidgets); // último paso
  });

  testWidgets(
      'en ventana pequeña los 2 pasos nuevos sacan diana de verdad '
      '(el ListView de Ajustes es perezoso)', (tester) async {
    // ventana de escritorio pequeña: bastante alto para el arranque, poco
    // para que el ListView de Ajustes NO construya las tiles del final
    await _arrancar(tester, size: const Size(800, 600));

    await tester.tap(find.byIcon(Icons.help_outline));
    await _pumps(tester, veces: 12);
    // en 600px de alto el menú de guías scrollea: subirlo hasta que la
    // entrada esté DE VERDAD en pantalla (construida != visible)
    await tester.dragUntilVisible(find.text('Personalizar la app'),
        find.byType(ListView).last, const Offset(0, -100));
    await _pumps(tester, veces: 3);
    await tester.tap(find.text('Personalizar la app'));
    await _pumps(tester);

    // el tour de Ajustes tiene 12 paradas; las 2 últimas son las nuevas.
    // Avanzar hasta la 11 (10 Siguientes desde la 1):
    for (var i = 0; i < 10; i++) {
      await tester.tap(find.text('Siguiente'));
      await _pumps(tester, veces: 14);
    }
    expect(find.text('Buzón de sugerencias'), findsWidgets);
    expect(indicadorDeFoco(), findsOneWidget,
        reason: 'paso «Buzón de sugerencias» sin diana: la tile perezosa '
            'no se construyó o la medición falló');

    await tester.tap(find.text('Siguiente'));
    await _pumps(tester, veces: 14);
    expect(find.text('Apoyar el proyecto'), findsWidgets);
    expect(indicadorDeFoco(), findsOneWidget,
        reason: 'paso «Apoyar el proyecto» sin diana');
    expect(find.text('Entendido'), findsOneWidget); // última parada
  });
}
