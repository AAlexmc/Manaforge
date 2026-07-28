/// Visor de carta a pantalla completa: pasar a la siguiente y a la anterior
/// sin cerrarlo. Con 274 cartas en un álbum, cerrar y volver a abrir para ver
/// la de al lado es un peaje que se paga 273 veces.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';

List<ZoomCard> _tres() => const [
      ZoomCard(name: 'Sol Ring'),
      ZoomCard(name: 'Mox Pearl'),
      ZoomCard(name: 'Black Lotus'),
    ];

Future<void> _abrir(WidgetTester tester, List<ZoomCard> cards,
    {int index = 0}) async {
  await tester.pumpWidget(MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () =>
                showCardZoomList(context, cards: cards, index: index),
            child: const Text('abrir'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
}

Future<void> _cerrar(WidgetTester tester) async {
  await tester.tapAt(const Offset(5, 5));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('arrastrando a la izquierda sale la siguiente carta',
      (tester) async {
    await _abrir(tester, _tres());
    expect(find.text('Sol Ring'), findsWidgets);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Mox Pearl'), findsWidgets);
    expect(find.text('Sol Ring'), findsNothing);
    await _cerrar(tester);
  });

  testWidgets('arrastrando a la derecha vuelve la anterior', (tester) async {
    await _abrir(tester, _tres(), index: 2);
    expect(find.text('Black Lotus'), findsWidgets);

    await tester.drag(find.byType(PageView), const Offset(400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Mox Pearl'), findsWidgets);
    await _cerrar(tester);
  });

  testWidgets('las flechas del teclado también pasan carta', (tester) async {
    await _abrir(tester, _tres());

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Mox Pearl'), findsWidgets);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('Sol Ring'), findsWidgets);
    await _cerrar(tester);
  });

  testWidgets('dice por dónde vas, y en los extremos no hay flecha',
      (tester) async {
    await _abrir(tester, _tres());

    expect(find.text('1 / 3'), findsOneWidget);
    // en la primera no hay "anterior"
    expect(find.byIcon(Icons.chevron_left), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    await _cerrar(tester);
  });

  testWidgets('con una sola carta no hay nada que pasar', (tester) async {
    await _abrir(tester, const [ZoomCard(name: 'Sol Ring')]);

    expect(find.text('Sol Ring'), findsWidgets);
    expect(find.byIcon(Icons.chevron_left), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.text('1 / 1'), findsNothing);
    await _cerrar(tester);
  });

  testWidgets('la ficha completa es la de la carta que estás viendo',
      (tester) async {
    final vistas = <String>[];
    await _abrir(tester, [
      ZoomCard(name: 'Sol Ring', onDetails: () => vistas.add('Sol Ring')),
      ZoomCard(name: 'Mox Pearl', onDetails: () => vistas.add('Mox Pearl')),
    ]);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Ver ficha completa'));
    await tester.pumpAndSettle();

    expect(vistas, ['Mox Pearl']);
  });
}
