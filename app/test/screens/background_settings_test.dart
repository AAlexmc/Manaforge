/// La tarjeta de Ajustes del fondo de pantalla.
///
/// Los colores solo tienen sentido con una imagen debajo: sin fondo puesto no
/// hay nada que dejar pasar y el tema de siempre ya está pensado para leerse.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/widgets/background_settings.dart';
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

  setUp(() => datos = Directory.systemTemp.createTempSync('mf-fondo-ajustes'));
  tearDown(() => datos.deleteSync(recursive: true));

  // en la app la tarjeta vive dentro del ListView de Ajustes; aquí hace falta
  // el scroll o la tarjeta con colores no cabe en la ventana de pruebas
  Widget tarjeta(BackgroundPreference prefs) => appDePrueba(
      home: Scaffold(
          body: SingleChildScrollView(
              child: BackgroundSettingsCard(prefs: prefs))));

  testWidgets('sin fondo puesto no se ofrecen colores', (tester) async {
    final prefs = BackgroundPreference(dataDir: datos);

    await tester.pumpWidget(tarjeta(prefs));

    expect(find.text('Color de las tarjetas'), findsNothing);
    expect(find.text('Color de la letra'), findsNothing);
  });

  testWidgets('con fondo puesto se eligen los colores y se guardan',
      (tester) async {
    final prefs = BackgroundPreference(dataDir: datos);
    final origen = File(p.join(datos.path, 'origen.png'))
      ..writeAsBytesSync(_png);
    await tester.runAsync(() => prefs.select(origen));

    await tester.pumpWidget(tarjeta(prefs));

    expect(find.text('Color de las tarjetas'), findsOneWidget);
    expect(find.text('Color de la letra'), findsOneWidget);
    // los dos nuevos: pestañas e iconos
    expect(find.text('Color de las pestañas'), findsOneWidget);
    expect(find.text('Color de los iconos'), findsOneWidget);

    // el círculo del color 'vino' de las tarjetas
    await tester.tap(find.bySemanticsLabel('vino'));
    await tester.pump();

    expect(prefs.cardColorId, 'vino');
  });
}
