/// El tour de bienvenida: avanza paso a paso, se puede saltar y al terminar
/// avisa (para marcarlo como visto).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/widgets/onboarding_coachmarks.dart';

import '../helpers/app_l10n.dart';

const _pasos = [
  CoachStep(barIndex: 1, title: 'Uno', body: 'Cuerpo uno'),
  CoachStep(barIndex: 3, title: 'Dos', body: 'Cuerpo dos'),
];

void main() {
  testWidgets('avanza paso a paso y termina en el último', (tester) async {
    var terminado = false;
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: OnboardingCoachmarks(
          steps: _pasos,
          itemCount: 8,
          onDone: () => terminado = true,
        ),
      ),
    ));

    expect(find.text('Uno'), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();

    expect(find.text('Dos'), findsOneWidget);
    expect(find.text('2 / 2'), findsOneWidget);
    // en el último paso, el botón cambia y ya no hay 'Saltar'
    expect(find.text('Entendido'), findsOneWidget);
    expect(find.text('Saltar'), findsNothing);

    await tester.tap(find.text('Entendido'));
    expect(terminado, isTrue);
  });

  testWidgets('saltar termina el tour de golpe', (tester) async {
    var terminado = false;
    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: OnboardingCoachmarks(
          steps: _pasos,
          itemCount: 8,
          onDone: () => terminado = true,
        ),
      ),
    ));

    await tester.tap(find.text('Saltar'));
    expect(terminado, isTrue);
  });

  testWidgets('en inglés los botones salen traducidos', (tester) async {
    await tester.pumpWidget(appDePrueba(
      locale: const Locale('en'),
      home: Scaffold(
        body: OnboardingCoachmarks(
          steps: _pasos,
          itemCount: 8,
          onDone: () {},
        ),
      ),
    ));

    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
