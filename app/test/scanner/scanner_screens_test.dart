/// Tests de arranque de las pantallas del escáner (sin plugins nativos:
/// deben degradar con elegancia a la puerta de descarga de la base).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/live_scan_screen.dart';
import 'package:manaforge_app/screens/scan_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/scanner_database.dart';

void main() {
  testWidgets('ScanScreen (foto) arranca y pide la base de huellas',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ScanScreen(
          db: CardDatabase(),
          collection: CollectionStore(),
          scanner: ScannerDatabase()),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Escanear'), findsOneWidget);
    expect(find.text('El ojo del escáner'), findsOneWidget);
    expect(find.text('Descargar base de huellas'), findsOneWidget);
  });

  testWidgets('LiveScanScreen (cámara) arranca y pide la base de huellas',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LiveScanScreen(
          db: CardDatabase(),
          collection: CollectionStore(),
          scanner: ScannerDatabase()),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Escanear en vivo'), findsOneWidget);
    expect(find.text('El ojo del escáner'), findsOneWidget);
    expect(find.text('Descargar base de huellas'), findsOneWidget);
  });
}
