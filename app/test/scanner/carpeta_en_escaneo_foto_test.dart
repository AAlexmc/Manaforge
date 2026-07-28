/// Carpeta también al escanear por FOTO.
///
/// El escáner en vivo ya dejaba elegir carpeta; la pantalla de foto es otra
/// bandeja distinta y se quedó fuera. Aquí se comprueba lo que importa: que el
/// selector aparece solo cuando hay carpetas a mano, y que etiquetar significa
/// lo MISMO en las dos vías (la carta entra en la colección igual, la carpeta
/// solo la marca).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/tray_commit.dart';
import 'package:manaforge_app/ui/scan/scan_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/services/scanner_database.dart';

/// isReady() de verdad hace IO: en la zona FakeAsync ese future no se resuelve
/// nunca y la puerta se queda en el spinner. Este doble contesta al instante.
class _ScannerSinBase extends ScannerDatabase {
  @override
  Future<bool> isReady() async => false;
}

Widget _app({FolderStore? folders, String? initialFolderId}) => MaterialApp(
      home: ScanScreen(
        db: CardDatabase(),
        collection: CollectionStore(),
        scanner: _ScannerSinBase(),
        folders: folders,
        initialFolderId: initialFolderId,
      ),
    );

void main() {
  testWidgets('sin carpetas a mano, no se enseña el selector', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Sin carpeta'), findsNothing);
  });

  testWidgets('con carpetas, el selector arranca en "Sin carpeta"',
      (tester) async {
    await tester.pumpWidget(_app(folders: FolderStore()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Sin carpeta'), findsOneWidget);
  });

  testWidgets('viniendo del escáner en vivo, la carpeta elegida se mantiene',
      (tester) async {
    final folders = FolderStore();
    final caja = folders.create(name: 'Caja de la tienda');

    await tester.pumpWidget(_app(folders: folders, initialFolderId: caja.id));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Y además a: Caja de la tienda'), findsOneWidget);
  });

  testWidgets('si la carpeta se borra en otra pantalla, se cae a "Sin carpeta"',
      (tester) async {
    final folders = FolderStore();
    final caja = folders.create(name: 'Para vender');

    await tester.pumpWidget(_app(folders: folders, initialFolderId: caja.id));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Y además a: Para vender'), findsOneWidget);

    folders.remove(caja.id);
    await tester.pump();

    // el chip no puede quedarse enseñando una carpeta que ya no existe
    expect(find.text('Sin carpeta'), findsOneWidget);
  });

  group('tagScanned (la regla compartida por bandeja y carta suelta)', () {
    test('etiqueta lo que se le pasa', () {
      final folders = FolderStore();
      final caja = folders.create(name: 'Caja');

      tagScanned(folders, caja.id, {'sol-ring'});

      expect(folders.byId(caja.id)!.cardIds, {'sol-ring'});
    });

    test('sin carpeta elegida no toca nada', () {
      final folders = FolderStore();
      final caja = folders.create(name: 'Caja');

      tagScanned(folders, null, {'sol-ring'});

      expect(folders.byId(caja.id)!.cardIds, isEmpty);
    });

    test('carpeta borrada mientras escaneabas: ni etiqueta ni revienta', () {
      final folders = FolderStore();
      final caja = folders.create(name: 'Caja');
      folders.remove(caja.id);

      expect(() => tagScanned(folders, caja.id, {'sol-ring'}), returnsNormally);
    });
  });
}
