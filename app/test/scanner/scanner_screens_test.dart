/// Tests de arranque de las pantallas del escáner (sin plugins nativos:
/// deben degradar con elegancia a la puerta de descarga de la base).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/scan/live_scan_screen.dart';
import 'package:manaforge_app/ui/scan/scan_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/scanner_database.dart';

/// isReady() de verdad hace IO (path_provider + File.exists): en la zona
/// FakeAsync de flutter test ese future JAMÁS se resuelve y la puerta se
/// queda en el spinner. Este doble responde al instante: "no descargada".
class _ScannerSinBase extends ScannerDatabase {
  @override
  Future<bool> isReady() async => false;
}

void main() {
  testWidgets('ScanScreen (foto) arranca y pide la base de huellas',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ScanScreen(
          db: CardDatabase(),
          collection: CollectionStore(),
          scanner: _ScannerSinBase()),
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
          scanner: _ScannerSinBase()),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Escanear en vivo'), findsOneWidget);
    expect(find.text('El ojo del escáner'), findsOneWidget);
    expect(find.text('Descargar base de huellas'), findsOneWidget);
  });
}
