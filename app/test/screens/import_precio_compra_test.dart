/// Importar el precio de compra del CSV.
///
/// El CSV de colección trae `Purchase price` y la app lo tiraba: sin ese dato
/// no hay P&L posible, porque la app no puede saber por sí sola lo que
/// pagaste. Aquí se comprueba que entra, que se apunta a la edición exacta
/// cuando se sabe, y que el resumen lo dice.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/scan/import_csv_screen.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';

CardHit _hit(String name) => CardHit(
      oracleId: 'o-$name',
      name: name,
      colors: 'W',
      typeLine: 'Creature',
      manaCost: '{W}',
      cmc: 1,
      setCode: 'tst',
      collectorNumber: '1',
    );

Future<void> _importar(WidgetTester tester, CollectionStore collection,
    String csv, {required bool edicionExacta}) async {
  await tester.pumpWidget(MaterialApp(
    home: ImportCsvScreen(
      db: CardDatabase(),
      collection: collection,
      resolver: (name, id) async => (_hit(name), edicionExacta),
    ),
  ));
  await tester.enterText(find.byType(TextField), csv);
  await tester.pump();
  await tester.tap(find.text('Importar'));
  await tester.pump();
  for (var i = 0; i < 40 && find.text('Importar').evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pump();
}

void main() {
  testWidgets('con edición exacta, lo pagado se apunta a esa impresión',
      (tester) async {
    final collection = CollectionStore();
    await _importar(
      tester,
      collection,
      'Name,Quantity,Scryfall ID,Purchase price,Purchase price currency\n'
      'Sol Ring,2,abc,3.50,EUR\n',
      edicionExacta: true,
    );

    final lot = collection.purchases[purchaseKey('tst|1', 'EUR')]!;
    expect(lot.qty, 2);
    expect(lot.perCopy, 3.50);
    expect(collection.totalCopies, 2);
  });

  testWidgets('sin edición exacta, se apunta a la carta', (tester) async {
    final collection = CollectionStore();
    await _importar(
      tester,
      collection,
      'Name,Quantity,Purchase price\nShock,1,0.25\n',
      edicionExacta: false,
    );

    expect(collection.purchases[purchaseKey('oracle:o-Shock', null)]!.perCopy,
        0.25);
  });

  testWidgets('el resumen dice cuántas copias traían precio', (tester) async {
    final collection = CollectionStore();
    await _importar(
      tester,
      collection,
      'Name,Quantity,Purchase price\nShock,3,0.25\nIsla,1,\n',
      edicionExacta: false,
    );

    expect(find.textContaining('3 copias con precio de compra'),
        findsOneWidget);
  });

  testWidgets('CSV sin columna de precio: lo dice, no calla', (tester) async {
    final collection = CollectionStore();
    await _importar(
      tester,
      collection,
      'Name,Quantity\nShock,1\n',
      edicionExacta: false,
    );

    expect(collection.hasPurchaseData, isFalse);
    expect(find.textContaining('Sin precio de compra en el CSV'),
        findsOneWidget);
  });
}
