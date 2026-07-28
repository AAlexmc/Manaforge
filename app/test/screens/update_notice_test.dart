/// Lo que se ve del aviso de versión nueva.
///
/// La app no se actualiza sola, así que el aviso tiene que decir DOS cosas:
/// que hay una versión nueva y que no va a hacer nada por su cuenta. Y tiene
/// que poder apartarse: un cartel que no se va es un cartel que estorba.
///
/// Ojo con los tiempos: comprobar versión toca disco y red de mentira, y eso
/// no avanza dentro del reloj falso de `testWidgets` — va todo por
/// `tester.runAsync`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manaforge_app/data/services/app_update.dart';
import 'package:manaforge_app/ui/core/widgets/update_notice.dart';

String _json(String tag) => jsonEncode([
      {
        'tag_name': tag,
        'html_url': 'https://github.com/AAlexmc/Manaforge/releases/tag/$tag',
        'name': 'ManaForge $tag',
        'body': 'Licencia nueva y Forge por expansiones',
        'draft': false,
        'prerelease': false,
      }
    ]);

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mf-update-ui'));
  tearDown(() => dir.deleteSync(recursive: true));

  Future<AppUpdateChecker> conVersionNueva(WidgetTester tester) async {
    final checker = AppUpdateChecker(
      dataDir: dir,
      currentVersion: '0.2.0',
      clientFactory: () =>
          MockClient((_) async => http.Response(_json('app-v0.3.0'), 200)),
    );
    await tester.runAsync(() => checker.checkIfDue());
    return checker;
  }

  testWidgets('la tira dice la versión y que no se actualiza sola',
      (tester) async {
    final checker = await conVersionNueva(tester);
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: UpdateBanner(checker: checker))));

    expect(find.text('Hay ManaForge 0.3.0.'), findsOneWidget);
    expect(find.textContaining('no se actualiza sola'), findsOneWidget);
  });

  testWidgets('la tira se puede apartar', (tester) async {
    final checker = await conVersionNueva(tester);
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: UpdateBanner(checker: checker))));

    await tester.tap(find.byTooltip('Ahora no'));
    await tester.pump();

    expect(find.text('Hay ManaForge 0.3.0.'), findsNothing);
  });

  testWidgets('sin versión nueva no hay tira', (tester) async {
    final checker = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: UpdateBanner(checker: checker))));

    expect(find.textContaining('Hay ManaForge'), findsNothing);
  });

  testWidgets('Ajustes: el interruptor apaga el aviso', (tester) async {
    final checker = await conVersionNueva(tester);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: UpdateSettingsCard(checker: checker))));

    expect(find.textContaining('Hay ManaForge 0.3.0.'), findsOneWidget);

    await tester.tap(find.text('Avisarme de versiones nuevas'));
    await tester.pump();

    expect(checker.enabled, isFalse);
    expect(find.textContaining('Hay ManaForge 0.3.0.'), findsNothing);
  });

  testWidgets('Ajustes: "Buscar ahora" pregunta aunque no toque todavía',
      (tester) async {
    var llamadas = 0;
    final checker = AppUpdateChecker(
      dataDir: dir,
      currentVersion: '0.3.0', // al día: no habrá aviso, sale el botón
      clientFactory: () => MockClient((_) async {
        llamadas++;
        return http.Response(_json('app-v0.3.0'), 200);
      }),
    );
    await tester.runAsync(() => checker.checkIfDue()); // ya mirado hoy
    expect(llamadas, 1);

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: UpdateSettingsCard(checker: checker))));

    await tester.tap(find.text('Buscar ahora'));
    await tester.pump();

    expect(llamadas, 2); // a mano se pregunta igual, sin esperar a mañana
    // y mientras busca lo enseña: el botón se apaga y sale el giro
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // (el texto del resultado no se puede comprobar aquí: la respuesta pasa
    // por disco, y una escritura de verdad no avanza en el reloj falso de
    // testWidgets. Lo que hace el servicio ya está en app_update_test.dart)
  });

  testWidgets('Ajustes dice qué versión tienes', (tester) async {
    final checker = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: UpdateSettingsCard(checker: checker))));

    expect(find.text('Tienes la 0.3.0.'), findsOneWidget);
  });
}
