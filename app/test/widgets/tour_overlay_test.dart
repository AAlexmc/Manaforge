/// El overlay de tours: avanza/retrocede/salta, cambia de pantalla y puede
/// señalar un botón concreto por su GlobalKey.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/widgets/tour_overlay.dart';

import '../helpers/app_l10n.dart';

void main() {
  testWidgets('avanza, retrocede y termina en el último', (tester) async {
    var terminado = false;
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: TourOverlay(
          steps: const [
            TourStep(navBarIndex: 1, title: 'Uno', body: 'a'),
            TourStep(navBarIndex: 3, title: 'Dos', body: 'b'),
          ],
          navItemCount: 8,
          onDone: () => terminado = true,
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('Uno'), findsOneWidget);
    expect(find.text('Atrás'), findsNothing); // primer paso: sin Atrás

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    expect(find.text('Dos'), findsOneWidget);
    expect(find.text('Atrás'), findsOneWidget);

    await tester.tap(find.text('Atrás'));
    await tester.pump();
    expect(find.text('Uno'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    expect(find.text('Entendido'), findsOneWidget);
    await tester.tap(find.text('Entendido'));
    expect(terminado, isTrue);
  });

  testWidgets('un paso que cambia de pantalla avisa por onGoToScreen',
      (tester) async {
    final visitadas = <int>[];
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: TourOverlay(
          steps: const [TourStep(goToScreen: 3, title: 'Forge', body: 'x')],
          navItemCount: 8,
          onGoToScreen: visitadas.add,
          onDone: () {},
        ),
      ),
    ));
    await tester.pump();

    expect(visitadas, [3]);
    expect(find.text('Forge'), findsOneWidget);
  });

  testWidgets('señala un botón por GlobalKey sin reventar', (tester) async {
    final k = GlobalKey();
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 40,
              top: 40,
              child: Container(key: k, width: 60, height: 30, color: Colors.red),
            ),
            TourOverlay(
              steps: [TourStep(targetKey: k, title: 'Botón', body: 'este')],
              navItemCount: 8,
              onDone: () {},
            ),
          ],
        ),
      ),
    ));
    await tester.pump(); // se mide el rect del botón en el postFrame
    await tester.pump();

    expect(find.text('Botón'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
