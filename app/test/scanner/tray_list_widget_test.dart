/// Test de la lista vertical de la bandeja (estilo escáner comercial): una fila por
/// carta con cantidad, set y controles de editar/borrar/cantidad.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/burst_controller.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/services/scanner_database.dart';
import 'package:manaforge_app/ui/scan/widgets/tray_list.dart';

Recognition _rec(String oracle,
        {String set = 'aer',
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
          10)
    ], conf);

Widget _host(ScanTray tray,
        {void Function(TrayLine)? onEdit,
        void Function(TrayLine)? onRemove,
        void Function(TrayLine, int)? onQty}) =>
    MaterialApp(
      home: Scaffold(
        body: TrayList(
          tray: tray,
          hitCache: const <String, CardHit?>{},
          onEdit: (l) => onEdit?.call(l),
          onRemove: (l) => onRemove?.call(l),
          onQty: (l, q) => onQty?.call(l, q),
        ),
      ),
    );

void main() {
  testWidgets('una fila por carta, con nombre y set', (tester) async {
    final tray = ScanTray()
      ..add(_rec('Ornithopter', num: '167'))
      ..add(_rec('Welder Automaton', num: '183'));
    await tester.pumpWidget(_host(tray));

    expect(find.text('Ornithopter'), findsOneWidget);
    expect(find.text('Welder Automaton'), findsOneWidget);
    expect(find.textContaining('AER #167'), findsOneWidget);
  });

  testWidgets('la cantidad se muestra y el + la sube', (tester) async {
    var newQty = 0;
    final tray = ScanTray()..add(_rec('Ornithopter', num: '167'));
    await tester.pumpWidget(_host(tray, onQty: (_, q) => newQty = q));

    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    expect(newQty, 2);
  });

  testWidgets('borrar una fila llama a onRemove', (tester) async {
    TrayLine? removed;
    final tray = ScanTray()..add(_rec('Ornithopter', num: '167'));
    await tester.pumpWidget(_host(tray, onRemove: (l) => removed = l));

    await tester.tap(find.byIcon(Icons.delete_outline));
    expect(removed, isNotNull);
  });

  testWidgets('una carta dudosa se marca "revisar"', (tester) async {
    final tray = ScanTray()
      ..add(_rec('Aegis', num: '141', conf: ScanConfidence.ambiguous));
    await tester.pumpWidget(_host(tray));
    expect(find.text('revisar'), findsOneWidget);
  });
}
