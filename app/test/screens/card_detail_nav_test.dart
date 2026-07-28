/// Pasar de carta DENTRO de la ficha completa (precios, legalidades,
/// ediciones): mirar un set entero era salir y entrar una vez por carta.
///
/// Aquí no hay base de cartas descargada, así que el cuerpo de la ficha no
/// llega a pintarse: lo que se comprueba es la navegación, que vive en la
/// barra de arriba y en el teclado.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/card_detail_screen.dart';
import 'package:manaforge_app/services/card_database.dart';

Future<void> _abrir(WidgetTester tester,
    {List<String>? siblings, int index = 0}) async {
  await tester.pumpWidget(MaterialApp(
    home: CardDetailScreen(
      db: CardDatabase(),
      oracleId: (siblings ?? const ['sol-ring'])[index],
      siblings: siblings,
      siblingIndex: index,
    ),
  ));
  await tester.pump();
}

const _tres = ['sol-ring', 'mox-pearl', 'black-lotus'];

void main() {
  testWidgets('con cartas al lado, la ficha dice por dónde vas', (tester) async {
    await _abrir(tester, siblings: _tres, index: 1);

    expect(find.text('2 / 3'), findsOneWidget);
  });

  testWidgets('los botones pasan a la siguiente y a la anterior',
      (tester) async {
    await _abrir(tester, siblings: _tres);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();
    expect(find.text('2 / 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pump();
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('las flechas del teclado también pasan carta', (tester) async {
    await _abrir(tester, siblings: _tres);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(find.text('2 / 3'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('en los extremos, el botón que no lleva a ningún sitio se apaga',
      (tester) async {
    await _abrir(tester, siblings: _tres);

    final atras = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left));
    expect(atras.onPressed, isNull, reason: 'en la primera no hay anterior');

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();
    expect(find.text('3 / 3'), findsOneWidget);

    final alante = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right));
    expect(alante.onPressed, isNull, reason: 'en la última no hay siguiente');
  });

  testWidgets('abierta suelta (sin lista), no sale nada de pasar cartas',
      (tester) async {
    await _abrir(tester);

    expect(find.byIcon(Icons.chevron_left), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.textContaining(' / '), findsNothing);
  });
}
