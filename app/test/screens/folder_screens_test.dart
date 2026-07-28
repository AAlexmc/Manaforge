/// Pantallas de carpetas: elegir cartas y la tarjeta de la portada.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/folder_pick_screen.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/ui/collection/widgets/folder_tile.dart';

OwnedCard _card(String name, {String colors = 'G', String type = 'Creature'}) =>
    OwnedCard(
      oracleId: 'o-$name',
      name: name,
      colors: colors,
      typeLine: type,
      cmc: 1,
      qty: 1,
    );

void main() {
  testWidgets('el selector marca cartas y devuelve los ids elegidos',
      (tester) async {
    final collection = CollectionStore()
      ..add(_card('Llanowar Elves'))
      ..add(_card('Counterspell', colors: 'U', type: 'Instant'));
    Set<String>? result;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () async {
            result = await Navigator.of(context).push<Set<String>>(
              MaterialPageRoute(
                  builder: (_) => FolderPickScreen(collection: collection)),
            );
          },
          child: const Text('abrir'),
        ),
      ),
    ));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.text('Llanowar Elves'), findsOneWidget);
    expect(find.text('Counterspell'), findsOneWidget);
    expect(find.text('Guardar (0)'), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Guardar (1)'), findsOneWidget);

    await tester.tap(find.text('Guardar (1)'));
    await tester.pumpAndSettle();
    expect(result, hasLength(1));
  });

  testWidgets('"Marcar todas" solo marca lo que pasa el filtro',
      (tester) async {
    final collection = CollectionStore()
      ..add(_card('Llanowar Elves'))
      ..add(_card('Counterspell', colors: 'U', type: 'Instant'));

    await tester.pumpWidget(MaterialApp(
      home: FolderPickScreen(collection: collection),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'U'));
    await tester.pumpAndSettle();
    expect(find.text('1 cartas a la vista'), findsOneWidget);

    await tester.tap(find.text('Marcar todas'));
    await tester.pumpAndSettle();
    expect(find.text('Guardar (1)'), findsOneWidget);
  });

  testWidgets('la tarjeta de carpeta enseña nombre, cartas y valor',
      (tester) async {
    final folder = CardFolder(
      id: '1',
      name: 'Para vender',
      colorValue: kDefaultFolderColor,
      icon: 'sell',
      cardIds: {'a', 'b'},
      createdAt: '',
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FolderCard(
          folder: folder,
          presentCount: 2,
          value: 12.5,
          approximate: false,
          onTap: () {},
        ),
      ),
    ));
    expect(find.text('Para vender'), findsOneWidget);
    expect(find.text('2 cartas'), findsOneWidget);
    expect(find.text('12.50 €'), findsOneWidget);
    expect(find.byIcon(Icons.sell), findsOneWidget);
  });

  testWidgets('valor aproximado se marca con ~', (tester) async {
    final folder = CardFolder(
      id: '1',
      name: 'X',
      colorValue: kDefaultFolderColor,
      icon: 'folder',
      cardIds: {'a'},
      createdAt: '',
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FolderCard(
          folder: folder,
          presentCount: 1,
          value: 3,
          approximate: true,
          onTap: () {},
        ),
      ),
    ));
    expect(find.text('~3.00 €'), findsOneWidget);
    expect(find.text('1 carta'), findsOneWidget);
  });
}
