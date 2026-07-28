/// La hoja para elegir expansiones.
///
/// Con ~900 sets en la base, lo que decide si esto se puede usar es el filtro
/// "solo las mías" y el buscador. Y cerrar sin tocar nada NO puede ser lo
/// mismo que "ninguna expansión".
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/ui/forge/widgets/set_picker.dart';

const _sets = [
  SetInfo(code: 'blb', name: 'Bloomburrow', total: 261),
  SetInfo(code: 'kld', name: 'Kaladesh', total: 264),
  SetInfo(code: 'mh3', name: 'Modern Horizons 3', total: 303),
];

Future<Set<String>?> _abrir(
  WidgetTester tester, {
  Set<String> selected = const {},
  Map<String, int> owned = const {'blb': 12, 'kld': 3},
}) async {
  Set<String>? resultado;
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            resultado = await showSetPickerSheet(context,
                sets: _sets, selected: selected, owned: owned);
          },
          child: const Text('abrir'),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
  return resultado;
}

void main() {
  testWidgets('empieza por las tuyas, y la que más tienes primero',
      (tester) async {
    await _abrir(tester);

    expect(find.text('Bloomburrow'), findsOneWidget);
    expect(find.text('Kaladesh'), findsOneWidget);
    // MH3 no es tuya: no sale hasta quitar el filtro
    expect(find.text('Modern Horizons 3'), findsNothing);

    final y = tester.getTopLeft(find.text('Bloomburrow')).dy;
    final y2 = tester.getTopLeft(find.text('Kaladesh')).dy;
    expect(y, lessThan(y2)); // 12 tuyas antes que 3
  });

  testWidgets('quitando "solo las mías" salen todas', (tester) async {
    await _abrir(tester);

    await tester.tap(find.text('Solo las mías'));
    await tester.pumpAndSettle();

    expect(find.text('Modern Horizons 3'), findsOneWidget);
  });

  testWidgets('el buscador va por nombre y por código', (tester) async {
    await _abrir(tester);
    await tester.tap(find.text('Solo las mías')); // ver todas
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'mh3');
    await tester.pumpAndSettle();

    expect(find.text('Modern Horizons 3'), findsOneWidget);
    expect(find.text('Bloomburrow'), findsNothing);
  });

  testWidgets('elegir una y confirmar la devuelve', (tester) async {
    Set<String>? elegidas;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              elegidas = await showSetPickerSheet(context,
                  sets: _sets,
                  selected: const {},
                  owned: const {'blb': 12});
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bloomburrow'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar 1 expansión'));
    await tester.pumpAndSettle();

    expect(elegidas, {'blb'});
  });

  testWidgets('cancelar no es lo mismo que "ninguna expansión"',
      (tester) async {
    Set<String>? elegidas = {'sentinela'};
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              elegidas = await showSetPickerSheet(context,
                  sets: _sets,
                  selected: const {'blb'},
                  owned: const {'blb': 12});
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(elegidas, isNull); // null = no toques nada
  });

  testWidgets('una expansión elegida sigue viéndose aunque no sea tuya',
      (tester) async {
    await _abrir(tester, selected: const {'mh3'});

    // con "solo las mías" puesto, la elegida no puede desaparecer: si no,
    // no habría forma de quitarla desde aquí
    expect(find.text('Modern Horizons 3'), findsOneWidget);
  });
}
