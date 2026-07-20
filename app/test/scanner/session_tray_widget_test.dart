/// Test de render de la bandeja del escaneo en vivo: verifica que agrupa con
/// ×N, marca las dudosas y cuenta bien el total (lo que aquí no se puede ver
/// porque la cámara no tiene plugin en escritorio Linux).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/burst_controller.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/scanner_database.dart';
import 'package:manaforge_app/widgets/session_tray.dart';

Recognition _rec(String oracle,
        {String set = 'tst',
        String num = '1',
        ScanConfidence conf = ScanConfidence.confident}) =>
    Recognition([
      ScanMatch(
          HashEntry(
              scryfallId: '$oracle-$set-$num',
              oracleId: oracle,
              name: oracle,
              setCode: set,
              collectorNumber: num),
          5)
    ], conf);

Widget _host(ScanTray tray, {VoidCallback? onEdit}) => MaterialApp(
      home: Scaffold(
        body: SessionTray(
          tray: tray,
          hitCache: const <String, CardHit?>{},
          quickMode: true,
          onEdit: (_) => onEdit?.call(),
          onRemove: (_) {},
          onConfirm: () {},
          onClear: () {},
        ),
      ),
    );

void main() {
  testWidgets('bandeja vacía muestra la pista de uso', (tester) async {
    await tester.pumpWidget(_host(ScanTray()));
    expect(find.textContaining('Pasa cartas'), findsOneWidget);
  });

  testWidgets('agrupa copias con ×N y cuenta el total', (tester) async {
    final tray = ScanTray();
    tray.add(_rec('bolt'));
    tray.add(_rec('bolt'));
    tray.add(_rec('bolt')); // ×3
    tray.add(_rec('shock', num: '2')); // otra carta
    await tester.pumpWidget(_host(tray));

    expect(find.text('×3'), findsOneWidget);
    expect(find.text('Añadir 4 a la colección'), findsOneWidget);
  });

  testWidgets('una línea dudosa muestra el icono de revisión', (tester) async {
    final tray = ScanTray();
    tray.add(_rec('bolt', conf: ScanConfidence.ambiguous));
    await tester.pumpWidget(_host(tray));
    expect(find.byIcon(Icons.help), findsOneWidget);
  });

  testWidgets('tocar una carta llama a onEdit', (tester) async {
    var edited = false;
    final tray = ScanTray()..add(_rec('bolt'));
    await tester.pumpWidget(_host(tray, onEdit: () => edited = true));
    await tester.tap(find.text('bolt'));
    expect(edited, isTrue);
  });
}
