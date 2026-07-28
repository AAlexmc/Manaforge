/// La colección con la base ya descargada pero sin cartas ofrece por dónde
/// empezar (escanear o importar), en vez de una portada de carpetas vacías.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/coleccion_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/services/scanner_database.dart';

/// isReady() de verdad hace IO y en flutter test no se resuelve nunca. Este
/// doble dice "base lista". El recálculo de valor de la portada sí intenta
/// abrir la base, pero al no existir en el test el error se traga en el
/// `catch` de _computeValuesOnce, así que la portada se pinta sin precios.
class _BaseLista extends CardDatabase {
  @override
  Future<bool> isReady() async => true;
}

void main() {
  testWidgets('la colección vacía ofrece escanear o importar', (tester) async {
    var escaneado = false;
    await tester.pumpWidget(MaterialApp(
      home: ColeccionScreen(
        db: _BaseLista(),
        collection: CollectionStore(),
        folders: FolderStore(),
        scanner: ScannerDatabase(),
        onScan: () => escaneado = true,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Aquí empieza tu colección'), findsOneWidget);
    expect(find.text('Escanear mis cartas'), findsOneWidget);
    expect(find.text('Importar CSV'), findsOneWidget);

    await tester.tap(find.text('Escanear mis cartas'));
    expect(escaneado, isTrue, reason: 'el botón dispara onScan');
  });

  testWidgets('sin onScan no aparece el botón de escanear, sí el de importar',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ColeccionScreen(
        db: _BaseLista(),
        collection: CollectionStore(),
        folders: FolderStore(),
        scanner: ScannerDatabase(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Escanear mis cartas'), findsNothing);
    expect(find.text('Importar CSV'), findsOneWidget);
  });

  testWidgets('con cartas la portada NO enseña el CTA de colección vacía',
      (tester) async {
    final collection = CollectionStore()
      ..add(OwnedCard(oracleId: 'x', name: 'Shivan Dragon', colors: 'R', qty: 1));
    await tester.pumpWidget(MaterialApp(
      home: ColeccionScreen(
        db: _BaseLista(),
        collection: collection,
        folders: FolderStore(),
        scanner: ScannerDatabase(),
        onScan: () {},
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Aquí empieza tu colección'), findsNothing);
    expect(find.text('Escanear mis cartas'), findsNothing);
  });
}
