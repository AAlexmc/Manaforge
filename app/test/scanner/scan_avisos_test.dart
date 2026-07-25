/// El escáner por foto tiene que avisar SIEMPRE de lo que rechaza, aunque
/// sea un rechazo PARCIAL (2 fotos buenas + 1 que no lo es) o aunque ya haya
/// una bandeja delante tapando el `_error` de la pantalla vacía.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/scan_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/safe_input.dart';
import 'package:manaforge_app/services/scanner_database.dart';

class _ScannerListaSinHuellas extends ScannerDatabase {
  @override
  Future<bool> isReady() async => true;

  @override
  Future<HashIndex> loadIndex() async =>
      HashIndex(Int64List(0), Int64List(0), const []);
}

Future<DropTarget> _montar(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: ScanScreen(
      db: CardDatabase(),
      collection: CollectionStore(),
      scanner: _ScannerListaSinHuellas(),
    ),
  ));
  await tester.pump(const Duration(milliseconds: 100));
  return tester.widget<DropTarget>(find.byType(DropTarget));
}

void main() {
  testWidgets(
      'soltar 1 foto buena + 1 que no es foto: avisa aunque la buena '
      'siga adelante', (tester) async {
    final fixture =
        File('test/scanner/fixtures/escena_manta.jpg').readAsBytesSync();
    final dropTarget = await _montar(tester);

    await tester.runAsync(() async {
      dropTarget.onDragDone!(DropDoneDetails(
        files: [
          XFile.fromData(fixture, path: 'buena.jpg', length: fixture.length),
          XFile.fromData(Uint8List(4), path: 'malware.exe', length: 4),
        ],
        localPosition: Offset.zero,
        globalPosition: Offset.zero,
      ));
      await Future<void>.delayed(const Duration(seconds: 2));
    });
    await tester.pump();

    // el rechazo PARCIAL no puede quedar mudo, aunque la foto buena siga
    // reconociéndose
    expect(find.textContaining('¿es una foto válida?'), findsWidgets);
  });

  testWidgets(
      'con una bandeja ya abierta, una foto de más demasiado grande avisa '
      'igual (el _error de la pantalla vacía no se ve)', (tester) async {
    final fixture =
        File('test/scanner/fixtures/escena_manta.jpg').readAsBytesSync();
    final dropTarget = await _montar(tester);

    // primero, una bandeja de verdad (2 fotos buenas)
    await tester.runAsync(() async {
      dropTarget.onDragDone!(DropDoneDetails(
        files: [
          XFile.fromData(fixture, path: 'a.jpg', length: fixture.length),
          XFile.fromData(fixture, path: 'b.jpg', length: fixture.length),
        ],
        localPosition: Offset.zero,
        globalPosition: Offset.zero,
      ));
      await Future<void>.delayed(const Duration(seconds: 2));
    });
    await tester.pump();
    expect(find.textContaining('2 cartas'), findsOneWidget);

    // con la bandeja delante (_buildBatch(), no _buildDropZone()), soltar
    // UNA foto de más y demasiado grande: el _error no se vería, pero el
    // aviso tiene que salir igual
    await tester.runAsync(() async {
      dropTarget.onDragDone!(DropDoneDetails(
        files: [
          XFile.fromData(Uint8List(4),
              path: 'gorda.jpg', length: kMaxScanFileBytes + 1),
        ],
        localPosition: Offset.zero,
        globalPosition: Offset.zero,
      ));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();

    expect(find.textContaining('2 cartas'), findsOneWidget); // sigue la bandeja
    expect(find.textContaining('demasiado grande'), findsWidgets);
  });
}
