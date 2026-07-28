// Selector de versión: diálogo CENTRADO con las cartas en grande para poder
// comparar ilustraciones, en vez del bottom sheet con miniaturas.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/ui/scan/widgets/version_picker.dart';

TrayLine _line() => TrayLine([
      const ScanMatch(
          HashEntry(
              scryfallId: 'a',
              oracleId: 'o1',
              name: 'Bleed Dry',
              setCode: 'dbl',
              collectorNumber: '361'),
          10),
      const ScanMatch(
          HashEntry(
              scryfallId: 'b',
              oracleId: 'o2',
              name: "Heliod's Pilgrim",
              setCode: 'thb',
              collectorNumber: '20'),
          22),
    ]);

void main() {
  group('versionChoicesFrom', () {
    test('usa printedName e imagen normal del hitCache, con fallback', () {
      final choices = versionChoicesFrom(_line(), {
        'a': const CardHit(
            oracleId: 'o1',
            name: 'Bleed Dry',
            printedName: 'Desangrar',
            setCode: 'dbl',
            collectorNumber: '361',
            imageNormal: 'http://img/normal.jpg',
            imageSmall: 'http://img/small.jpg',
            typeLine: 'Instant',
            colors: 'B',
            manaCost: '{2}{B}'),
      });
      expect(choices, hasLength(2));
      expect(choices[0].name, 'Desangrar');
      expect(choices[0].imageUrl, 'http://img/normal.jpg');
      expect(choices[0].setLine, 'DBL #361');
      // sin hit en caché: nombre del índice y sin imagen
      expect(choices[1].name, "Heliod's Pilgrim");
      expect(choices[1].imageUrl, isNull);
      expect(choices[1].setLine, 'THB #20');
    });
  });

  group('showVersionPicker', () {
    Future<int?> pumpAndOpen(WidgetTester tester,
        {required List<VersionChoice> choices, int? selected}) async {
      int? result;
      var done = false;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showVersionPicker(context,
                      choices: choices, selected: selected);
                  done = true;
                },
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      return Future.sync(() => done ? result : null);
    }

    final choices = [
      const VersionChoice(name: 'Bleed Dry', setLine: 'DBL #361'),
      const VersionChoice(name: "Heliod's Pilgrim", setLine: 'THB #20'),
    ];

    testWidgets('sale como diálogo centrado, no bottom sheet',
        (tester) async {
      await pumpAndOpen(tester, choices: choices, selected: 0);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('¿Cuál es?'), findsOneWidget);
      // sin imagen, el nombre sale en el placeholder Y en la etiqueta
      expect(find.text('Bleed Dry'), findsWidgets);
      expect(find.text("Heliod's Pilgrim"), findsWidgets);
    });

    testWidgets('las cartas se pintan en grande (≥240 px de alto)',
        (tester) async {
      await pumpAndOpen(tester, choices: choices, selected: 0);
      final size = tester.getSize(find.byKey(const Key('version-card-0')));
      expect(size.height, greaterThanOrEqualTo(240));
    });

    testWidgets('tocar una carta devuelve su índice', (tester) async {
      int? result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                result = await showVersionPicker(context,
                    choices: choices, selected: 0);
              },
              child: const Text('abrir'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('version-card-1')));
      await tester.pumpAndSettle();
      expect(result, 1);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('la versión ya elegida lleva su check', (tester) async {
      await pumpAndOpen(tester, choices: choices, selected: 1);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
