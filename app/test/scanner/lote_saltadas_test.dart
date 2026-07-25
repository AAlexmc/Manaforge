/// Lote del escáner por foto: una foto que no pasa el tope de tamaño no
/// puede desaparecer en silencio del recuento — el resto del lote sigue
/// adelante, pero se avisa de cuántas se saltaron.
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

/// Índice de huellas SIN ninguna entrada: no reconoce nada, pero no
/// revienta — para este test solo importa que el lote PROCESE las fotos
/// buenas y CUENTE la saltada, no que acierte la carta.
class _ScannerListaSinHuellas extends ScannerDatabase {
  @override
  Future<bool> isReady() async => true;

  @override
  Future<HashIndex> loadIndex() async =>
      HashIndex(Int64List(0), Int64List(0), const []);
}

void main() {
  testWidgets(
      'lote con 2 fotos buenas y 1 demasiado grande: bandeja con 2 y avisa '
      'de 1 saltada', (tester) async {
    // una escena de UNA sola carta: processScanPhotoAll saca exactamente 1
    // resultado (una imagen sintética plana dispara el detector de rejilla
    // y devuelve muchos más, rompiendo el recuento de este test)
    final fixture =
        File('test/scanner/fixtures/escena_manta.jpg').readAsBytesSync();

    await tester.pumpWidget(MaterialApp(
      home: ScanScreen(
        db: CardDatabase(),
        collection: CollectionStore(),
        scanner: _ScannerListaSinHuellas(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    final dropTarget = tester.widget<DropTarget>(find.byType(DropTarget));

    await tester.runAsync(() async {
      dropTarget.onDragDone!(DropDoneDetails(
        files: [
          XFile.fromData(fixture, path: 'buena1.png', length: fixture.length),
          XFile.fromData(fixture, path: 'buena2.png', length: fixture.length),
          // el contenido da igual: el tamaño se mira ANTES de leerlo
          XFile.fromData(Uint8List(4),
              path: 'gorda.png', length: kMaxScanFileBytes + 1),
        ],
        localPosition: Offset.zero,
        globalPosition: Offset.zero,
      ));
      // el pipeline real (isolate de compute() + IO) no avanza con el reloj
      // falso de testWidgets
      await Future<void>.delayed(const Duration(seconds: 3));
    });
    await tester.pump();

    // las 2 buenas entran a la bandeja (sin reconocer, índice vacío, pero
    // CONTADAS) y se avisa de la que se saltó
    expect(find.textContaining('2 cartas'), findsOneWidget);
    expect(find.textContaining('1 foto saltada'), findsOneWidget);
  });
}
