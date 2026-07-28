/// El overlay de tours: avanza/retrocede/salta, cambia de pantalla y puede
/// señalar un botón concreto por su GlobalKey.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/core/tours/tour_overlay.dart';

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

  testWidgets('avisa de la pantalla que hay que abrir, y de cerrarla al salir',
      (tester) async {
    final pedidas = <TourPush?>[];
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: TourOverlay(
          steps: const [
            TourStep(push: TourPush.logros, title: 'Logros', body: 'a'),
            TourStep(title: 'Otra cosa', body: 'b'),
          ],
          navItemCount: 8,
          onPush: pedidas.add,
          onDone: () {},
        ),
      ),
    ));
    await tester.pump();
    expect(pedidas, [TourPush.logros]);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump();
    // el paso que no pide pantalla CIERRA la de antes (null), no la deja
    expect(pedidas, [TourPush.logros, null]);
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

  testWidgets('lleva a la vista un botón que está fuera de pantalla (scroll)',
      (tester) async {
    final k = GlobalKey();
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: Stack(
          children: [
            // Column (no ListView perezoso) para que el objetivo, aun fuera de
            // pantalla, esté montado y se pueda llevar a la vista
            SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < 40; i++)
                    SizedBox(height: 60, child: Text('fila $i')),
                  Container(
                      key: k,
                      height: 40,
                      color: Colors.red,
                      child: const Text('objetivo')),
                ],
              ),
            ),
            TourOverlay(
              steps: [TourStep(targetKey: k, title: 'Abajo', body: 'x')],
              navItemCount: 8,
              onDone: () {},
            ),
          ],
        ),
      ),
    ));
    await tester.pump(); // postFrame: mide y dispara ensureVisible
    await tester.pumpAndSettle(); // termina el scroll animado

    expect(find.text('Abajo'), findsOneWidget);
    expect(find.text('objetivo'), findsOneWidget); // se hizo scroll hasta él
    expect(tester.takeException(), isNull);
  });
}
