/// La tarjeta del P&L.
///
/// Lo que se prueba es la letra pequeña: un porcentaje sin decir sobre
/// cuántas cartas está medido engaña, y las compras en otra divisa tienen que
/// verse SIN sumarse.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/markets.dart';
import 'package:manaforge_app/services/pnl.dart';
import 'package:manaforge_app/widgets/pnl_view.dart';

Future<void> _pump(WidgetTester tester, PnL pnl) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PnlView(pnl: pnl, market: Market.cardmarket),
        ),
      ),
    );

void main() {
  testWidgets('ganancia: importe, porcentaje y sobre cuántas copias',
      (tester) async {
    await _pump(
      tester,
      const PnL(
        currency: 'EUR',
        paid: 100,
        value: 150,
        copies: 200,
        totalCopies: 283,
        copiesWithoutPrice: 0,
        otherCurrencies: {},
        copiesAssumedCurrency: 0,
      ),
    );

    expect(find.text('Pagaste 100.00 € · hoy valen 150.00 €'), findsOneWidget);
    expect(find.text('+50.00 € (+50.0 %)'), findsOneWidget);
    expect(
        find.text('sobre 200 de 283 copias '
            '(las demás no tienen precio de compra apuntado)'),
        findsOneWidget);
  });

  testWidgets('pérdida: se ve el signo, no un menos escondido',
      (tester) async {
    await _pump(
      tester,
      const PnL(
        currency: 'EUR',
        paid: 200,
        value: 150,
        copies: 10,
        totalCopies: 10,
        copiesWithoutPrice: 0,
        otherCurrencies: {},
        copiesAssumedCurrency: 0,
      ),
    );

    expect(find.text('−50.00 € (−25.0 %)'), findsOneWidget);
    expect(find.text('sobre las 10 copias de tu colección'), findsOneWidget);
  });

  testWidgets('las otras divisas se enseñan sin sumarse', (tester) async {
    await _pump(
      tester,
      const PnL(
        currency: 'EUR',
        paid: 10,
        value: 12,
        copies: 2,
        totalCopies: 5,
        copiesWithoutPrice: 1,
        otherCurrencies: {'USD': 34.1},
        copiesAssumedCurrency: 2,
      ),
    );

    expect(find.textContaining('también pagaste 34.10 USD'), findsOneWidget);
    expect(find.textContaining('no tienen precio de hoy'), findsOneWidget);
    expect(find.textContaining('se suponen EUR'), findsOneWidget);
  });

  testWidgets('sin compras dice cómo conseguirlas, no un 0 grande',
      (tester) async {
    await _pump(
      tester,
      const PnL(
        currency: 'EUR',
        paid: 0,
        value: 0,
        copies: 0,
        totalCopies: 40,
        copiesWithoutPrice: 0,
        otherCurrencies: {},
        copiesAssumedCurrency: 0,
      ),
    );

    expect(find.textContaining('Purchase price'), findsOneWidget);
    expect(find.textContaining('%'), findsNothing);
  });
}
