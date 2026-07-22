/// Elegir carpeta al escanear, incluido el primer uso: cuando aún NO hay
/// ninguna carpeta creada, que es como llega todo el mundo la primera vez.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/widgets/folder_target.dart';

/// Abre la hoja como la abre la pantalla de verdad: con un toque. Devuelve un
/// cierre para leer lo elegido cuando la hoja se cierre.
Future<FolderTarget? Function()> _open(
    WidgetTester tester, FolderStore folders,
    {String? selectedId}) async {
  FolderTarget? elegida;
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () async {
              elegida = await showFolderTargetSheet(context,
                  folders: folders, selectedId: selectedId);
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
  return () => elegida;
}

/// Cierra la hoja eligiendo "Ninguna" (una hoja abierta al acabar el test deja
/// el árbol a medio desmontar y revienta el tearDown).
Future<void> _close(WidgetTester tester) async {
  await tester.tap(find.text('Ninguna'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sin ninguna carpeta creada, se puede crear una ahí mismo',
      (tester) async {
    final folders = FolderStore();
    final elegida = await _open(tester, folders);

    expect(find.text('Ninguna'), findsOneWidget);
    expect(find.text('Carpeta nueva…'), findsOneWidget);

    await tester.tap(find.text('Carpeta nueva…'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Caja de la tienda');
    await tester.tap(find.text('Crear'));
    await tester.pumpAndSettle();

    expect(folders.folders.single.name, 'Caja de la tienda');
    expect(elegida()?.id, folders.folders.single.id,
        reason: 'la carpeta recién creada queda elegida');
  });

  testWidgets('una carpeta sin nombre no se crea', (tester) async {
    final folders = FolderStore();
    await _open(tester, folders);

    await tester.tap(find.text('Carpeta nueva…'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Crear'));
    await tester.pumpAndSettle();

    expect(folders.folders, isEmpty);
    await _close(tester);
  });

  testWidgets('las carpetas que ya hay salen con su cuenta de cartas',
      (tester) async {
    final folders = FolderStore();
    folders.create(name: 'Para vender', cardIds: {'a', 'b'});
    await _open(tester, folders);

    expect(find.text('Para vender'), findsOneWidget);
    expect(find.text('2 cartas'), findsOneWidget);
    await _close(tester);
  });

  testWidgets('el texto deja claro que la carpeta NO sustituye a la colección',
      (tester) async {
    final folders = FolderStore();
    await _open(tester, folders);

    expect(find.textContaining('Entran en tu colección igual'), findsOneWidget);
    await _close(tester);
  });
}
