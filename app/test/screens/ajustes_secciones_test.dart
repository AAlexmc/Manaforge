/// Ajustes agrupado en secciones plegables en vez de una lista larga y plana.
///
/// "Apariencia" sale abierta (es lo que la gente viene a tocar) y trae la
/// entrada a "Editar inicio"; el resto sale plegado y se abre al tocarlo.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/screens.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/factory_reset.dart';
import 'package:manaforge_app/services/home_layout_prefs.dart';
import 'package:manaforge_app/services/language_prefs.dart';

import '../helpers/app_l10n.dart';

CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));

void main() {
  late Directory datos;

  setUp(() => datos = Directory.systemTemp.createTempSync('mf-ajustes'));
  tearDown(() {
    if (datos.existsSync()) datos.deleteSync(recursive: true);
  });

  Widget _ajustes() => appDePrueba(
        home: AjustesScreen(
          db: _sinBase(),
          onRestored: () {},
          language: LanguagePreference(dataDir: datos),
          homeLayout: HomeLayoutPreference(dataDir: datos),
        ),
      );

  testWidgets('salen las tres secciones', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_ajustes());
    await tester.pump();

    expect(find.text('Apariencia'), findsOneWidget);
    expect(find.text('Datos'), findsOneWidget);
    expect(find.text('La app'), findsOneWidget);
  });

  testWidgets('Apariencia sale abierta y trae "Editar inicio"',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_ajustes());
    await tester.pump();

    expect(find.text('Editar inicio'), findsOneWidget);
  });

  testWidgets('Datos sale plegado y se abre al tocarlo', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_ajustes());
    await tester.pump();

    // plegado: su contenido no se ve
    expect(find.text('Base de datos de cartas'), findsNothing);

    await tester.tap(find.text('Datos'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Base de datos de cartas'), findsOneWidget);
  });

  testWidgets('la seccion Datos lleva el reset de fabrica al final',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(appDePrueba(
      home: AjustesScreen(
        db: _sinBase(),
        onRestored: () {},
        onFactoryReset: () async => const FactoryResetReport(
            backupFile: null, deleted: [], failed: []),
      ),
    ));
    await tester.tap(find.text('Datos'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.scrollUntilVisible(find.text('Reset de fábrica'), 200);
    expect(find.text('Reset de fábrica'), findsOneWidget);
  });
}
