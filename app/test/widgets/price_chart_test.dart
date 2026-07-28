/// Tests de la gráfica de precio: qué enseña con pocos datos, el selector
/// de rango y el resumen de variación.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/ui/core/widgets/price_chart.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: SizedBox(width: 500, child: child)));

/// [n] días consecutivos terminando HOY, con los precios dados.
List<PricePoint> _daily(List<double> values) {
  final today = DateTime.now();
  two(int x) => x < 10 ? '0$x' : '$x';
  return [
    for (var i = 0; i < values.length; i++)
      () {
        final d = today.subtract(Duration(days: values.length - 1 - i));
        return PricePoint(
            '${d.year}-${two(d.month)}-${two(d.day)}', values[i]);
      }()
  ];
}

void main() {
  testWidgets('sin historial explica que aún no hay datos, no una gráfica '
      'vacía', (tester) async {
    await tester.pumpWidget(
        _wrap(const PriceChart(points: [], currentPrice: 3.5)));
    expect(find.textContaining('Precio de hoy: 3.50 €'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets); // solo el icono/vacío
  });

  testWidgets('con un solo día tampoco dibuja gráfica', (tester) async {
    await tester.pumpWidget(
        _wrap(PriceChart(points: _daily([2.0]), currentPrice: 2.0)));
    expect(find.textContaining('en cuanto haya varios días'), findsOneWidget);
  });

  testWidgets('con varios días enseña la variación del tramo',
      (tester) async {
    await tester.pumpWidget(_wrap(PriceChart(points: _daily([2.0, 3.0]))));
    expect(find.textContaining('+1.00 € (50.0%)'), findsOneWidget);
    expect(find.textContaining('mín 2.00 €'), findsOneWidget);
  });

  testWidgets('una bajada se marca en negativo', (tester) async {
    await tester.pumpWidget(_wrap(PriceChart(points: _daily([4.0, 3.0]))));
    expect(find.textContaining('-1.00 € (-25.0%)'), findsOneWidget);
  });

  testWidgets('cambiar a Semana recorta el tramo (y su resumen)',
      (tester) async {
    // 10 días: 1 € el primero y 5 € el resto. En Semana entran hoy y los 6
    // anteriores (7 puntos), que ya arrancan a 5 € → variación 0; en Mes
    // entra el de 1 € y la subida es del 400 %
    await tester.pumpWidget(_wrap(PriceChart(
        points: _daily([1, 5, 5, 5, 5, 5, 5, 5, 5, 5]))));
    expect(find.textContaining('+4.00 € (400.0%)'), findsOneWidget);
    expect(find.textContaining('10 días'), findsOneWidget);
    await tester.tap(find.text('Semana'));
    await tester.pump();
    expect(find.textContaining('+0.00 € (0.0%)'), findsOneWidget);
    expect(find.textContaining('7 días'), findsOneWidget);
  });

  testWidgets('historial solo antiguo: enseña la gráfica en vez de decir '
      'que no hay datos', (tester) async {
    // dos puntos de hace más de un mes: el rango Mes (por defecto) los
    // dejaría fuera, pero historia SÍ hay
    final old = [
      const PricePoint('2020-01-01', 2.0),
      const PricePoint('2020-01-05', 3.0),
    ];
    await tester.pumpWidget(_wrap(PriceChart(points: old)));
    expect(find.textContaining('en cuanto haya varios días'), findsNothing);
    expect(find.textContaining('+1.00 € (50.0%)'), findsOneWidget);
  });

  testWidgets('tocar la gráfica marca un punto y no revienta el pintado',
      (tester) async {
    await tester.pumpWidget(_wrap(PriceChart(
        points: _daily([for (var i = 0; i < 30; i++) 1.0 + i * 0.1]))));
    final chart = find.byType(CustomPaint).last;
    await tester.tapAt(tester.getCenter(chart));
    await tester.pump();
    // el pintado con tooltip corre sin excepciones y el arrastre también
    await tester.drag(chart, const Offset(60, 0));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('MiniPriceLine no dibuja nada con menos de dos puntos',
      (tester) async {
    await tester.pumpWidget(_wrap(const MiniPriceLine(points: [])));
    expect(
        find.descendant(
            of: find.byType(MiniPriceLine), matching: find.byType(CustomPaint)),
        findsNothing);
  });

  testWidgets('MiniPriceLine dibuja con dos puntos o más', (tester) async {
    await tester.pumpWidget(_wrap(MiniPriceLine(points: _daily([1, 2]))));
    expect(
        find.descendant(
            of: find.byType(MiniPriceLine), matching: find.byType(CustomPaint)),
        findsOneWidget);
  });
}
