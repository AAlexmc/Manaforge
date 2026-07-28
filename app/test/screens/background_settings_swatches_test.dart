/// Muestras guardadas y presets en pestañas/iconos, en la tarjeta de Ajustes
/// del fondo. Ver `background_settings_test.dart` para lo de siempre
/// (colores de tarjetas/letra sin lo nuevo del diseño).
library;

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/ui/settings/widgets/background_settings.dart';
import 'package:path/path.dart' as p;

import '../helpers/app_l10n.dart';

final _png = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
];

void main() {
  late Directory datos;

  setUp(
      () => datos = Directory.systemTemp.createTempSync('mf-fondo-muestras'));
  tearDown(() => datos.deleteSync(recursive: true));

  Widget tarjeta(BackgroundPreference prefs) => appDePrueba(
      home: Scaffold(
          body: SingleChildScrollView(
              child: BackgroundSettingsCard(prefs: prefs))));

  Future<BackgroundPreference> conFondo(WidgetTester tester) async {
    final prefs = BackgroundPreference(dataDir: datos);
    final origen = File(p.join(datos.path, 'origen.png'))
      ..writeAsBytesSync(_png);
    await tester.runAsync(() => prefs.select(origen));
    return prefs;
  }

  testWidgets(
      'una muestra guardada sale en las cuatro filas y tocarla la aplica',
      (tester) async {
    final prefs = await conFondo(tester);
    await tester.runAsync(() => prefs.addSwatch(const Color(0xFF59F7FF)));

    await tester.pumpWidget(tarjeta(prefs));

    final muestras = find.bySemanticsLabel('Muestra guardada');
    expect(muestras, findsNWidgets(4));

    // la primera es la de la fila de las tarjetas
    await tester.tap(muestras.first);
    await tester.pump();

    expect(prefs.cardIsCustom, isTrue);
    expect(prefs.cardCustomColor, const Color(0xFF59F7FF));
  });

  testWidgets('pulsación larga sobre una muestra + Borrar la quita',
      (tester) async {
    final prefs = await conFondo(tester);
    await tester.runAsync(() => prefs.addSwatch(const Color(0xFF59F7FF)));

    await tester.pumpWidget(tarjeta(prefs));

    await tester.longPress(find.bySemanticsLabel('Muestra guardada').first);
    await tester.pump();

    expect(find.text('¿Borrar esta muestra?'), findsOneWidget);
    await tester.tap(find.text('Borrar'));
    await tester.pump();

    expect(prefs.savedSwatches, isEmpty);
  });

  testWidgets('clic derecho sobre una muestra + Borrar también la quita',
      (tester) async {
    // en escritorio nadie descubre la pulsación larga con el ratón: el
    // clic derecho es el gesto natural para "quitar esto de aquí"
    final prefs = await conFondo(tester);
    await tester.runAsync(() => prefs.addSwatch(const Color(0xFF59F7FF)));

    await tester.pumpWidget(tarjeta(prefs));

    await tester.tap(find.bySemanticsLabel('Muestra guardada').first,
        buttons: kSecondaryButton);
    await tester.pump();

    expect(find.text('¿Borrar esta muestra?'), findsOneWidget);
    await tester.tap(find.text('Borrar'));
    await tester.pump();

    expect(prefs.savedSwatches, isEmpty);
  });

  testWidgets('el tooltip de la muestra explica cómo borrarla',
      (tester) async {
    final prefs = await conFondo(tester);
    await tester.runAsync(() => prefs.addSwatch(const Color(0xFF59F7FF)));

    await tester.pumpWidget(tarjeta(prefs));

    final tooltip = tester
        .widget<Tooltip>(find
            .ancestor(
                of: find.bySemanticsLabel('Muestra guardada').first,
                matching: find.byType(Tooltip))
            .first)
        .message;
    expect(tooltip, contains('clic derecho'),
        reason: 'sin pista, nadie descubre cómo borrar una muestra');
  });

  testWidgets('cancelar en la confirmación no borra la muestra',
      (tester) async {
    final prefs = await conFondo(tester);
    await tester.runAsync(() => prefs.addSwatch(const Color(0xFF59F7FF)));

    await tester.pumpWidget(tarjeta(prefs));

    await tester.longPress(find.bySemanticsLabel('Muestra guardada').first);
    await tester.pump();
    await tester.tap(find.text('Cancelar'));
    await tester.pump();

    expect(prefs.savedSwatches, [const Color(0xFF59F7FF)]);
  });

  testWidgets(
      'los presets de tarjetas salen también en pestañas e iconos, y elegir '
      'uno los aplica', (tester) async {
    final prefs = await conFondo(tester);

    await tester.pumpWidget(tarjeta(prefs));

    // 'vino' ahora sale en tarjetas, pestañas e iconos: tres círculos
    final vino = find.bySemanticsLabel('vino');
    expect(vino, findsNWidgets(3));

    // el segundo es el de la fila de pestañas
    await tester.tap(vino.at(1));
    await tester.pump();

    expect(
        prefs.chipColor, kCardColors.firstWhere((c) => c.id == 'vino').color);

    // el tercero es el de la fila de iconos
    await tester.tap(find.bySemanticsLabel('vino').at(2));
    await tester.pump();

    expect(
        prefs.iconColor, kCardColors.firstWhere((c) => c.id == 'vino').color);
  });

  testWidgets(
      'guardar como muestra desde el selector aplica el color Y lo añade a '
      'la paleta', (tester) async {
    final prefs = await conFondo(tester);

    await tester.pumpWidget(tarjeta(prefs));

    await tester.tap(find.bySemanticsLabel('Elegir un color a medida').first);
    await tester.pump();

    await tester.tap(find.text('Guardar como muestra'));
    await tester.pump();

    expect(prefs.savedSwatches, hasLength(1));
    expect(prefs.cardIsCustom, isTrue);
    expect(prefs.cardCustomColor, prefs.savedSwatches.single);
  });
}
