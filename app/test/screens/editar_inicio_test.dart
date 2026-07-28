/// El editor de Inicio: encender/apagar secciones y reordenarlas.
///
/// Un interruptor apaga la sección al momento (la UI escucha el layout);
/// "Restablecer" las vuelve a encender todas. No se llama a `load()` ni se
/// espera a `_save()`: los dos tocan disco, y el reloj falso de `testWidgets`
/// no hace avanzar la E/S real (ver `language_prefs.dart`). El estado por
/// defecto ya es "todo visible", que es lo que se prueba aquí. La persistencia
/// se cubre en `test/services/home_layout_prefs_test.dart`.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/home/editar_inicio_screen.dart';
import 'package:manaforge_app/services/home_layout_prefs.dart';

import '../helpers/app_l10n.dart';

void main() {
  late Directory datos;

  setUp(() => datos = Directory.systemTemp.createTempSync('mf-editor'));
  tearDown(() {
    if (datos.existsSync()) datos.deleteSync(recursive: true);
  });

  Finder switchDe(String etiqueta) => find.descendant(
        of: find.ancestor(
            of: find.text(etiqueta), matching: find.byType(ListTile)),
        matching: find.byType(Switch),
      );

  testWidgets('salen todas las secciones, con su interruptor', (tester) async {
    final layout = HomeLayoutPreference(dataDir: datos);
    await tester
        .pumpWidget(appDePrueba(home: EditarInicioScreen(layout: layout)));
    await tester.pump();

    expect(find.text('El meta ahora'), findsOneWidget);
    expect(find.text('Tus joyas'), findsOneWidget);
    expect(find.text('Resumen de la colección'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(kHomeSections.length));
  });

  testWidgets('apagar el interruptor oculta la sección', (tester) async {
    final layout = HomeLayoutPreference(dataDir: datos);
    await tester
        .pumpWidget(appDePrueba(home: EditarInicioScreen(layout: layout)));
    await tester.pump();

    await tester.tap(switchDe('El meta ahora'));
    await tester.pump();
    expect(layout.esVisible('meta'), isFalse);
  });

  testWidgets('Restablecer vuelve a encender todo', (tester) async {
    final layout = HomeLayoutPreference(dataDir: datos);
    await tester
        .pumpWidget(appDePrueba(home: EditarInicioScreen(layout: layout)));
    await tester.pump();

    await tester.tap(switchDe('El meta ahora'));
    await tester.pump();
    expect(layout.esVisible('meta'), isFalse);

    await tester.tap(find.text('Restablecer'));
    await tester.pump();
    expect(layout.esVisible('meta'), isTrue);
  });
}
