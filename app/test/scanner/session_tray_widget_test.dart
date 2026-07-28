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
import 'package:manaforge_app/ui/scan/widgets/session_tray.dart';

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

Widget _host(ScanTray tray,
        {VoidCallback? onEdit,
        void Function(TrayLine, int)? onQty,
        String? onTableKey,
        String? folderName,
        VoidCallback? onPickFolder}) =>
    MaterialApp(
      home: Scaffold(
        body: SessionTray(
          tray: tray,
          hitCache: const <String, CardHit?>{},
          quickMode: true,
          onEdit: (_) => onEdit?.call(),
          onRemove: (_) {},
          onQty: (line, delta) => onQty?.call(line, delta),
          onTableKey: onTableKey,
          folderName: folderName,
          onPickFolder: onPickFolder,
          onConfirm: () {},
          onClear: () {},
        ),
      ),
    );

void main() {
  testWidgets('sin carpetas a mano, la bandeja no ofrece elegir carpeta',
      (tester) async {
    final tray = ScanTray()..add(_rec('bolt'));
    await tester.pumpWidget(_host(tray));

    expect(find.text('Sin carpeta'), findsNothing);
  });

  testWidgets('con carpetas, la bandeja dice a cuál van y deja cambiarla',
      (tester) async {
    final tray = ScanTray()..add(_rec('bolt'));
    var abierto = 0;
    await tester.pumpWidget(
        _host(tray, onPickFolder: () => abierto++));

    expect(find.text('Sin carpeta'), findsOneWidget);
    await tester.tap(find.text('Sin carpeta'));
    expect(abierto, 1);

    // ya elegida: se dice que ADEMÁS van ahí, no que vayan ahí en vez de a la
    // colección (una carpeta es una etiqueta, no una caja)
    await tester.pumpWidget(_host(tray,
        folderName: 'Caja de la tienda', onPickFolder: () {}));
    expect(find.text('Y además a: Caja de la tienda'), findsOneWidget);
    // el botón cuenta también la carpeta: es lo último que lees antes de
    // pulsarlo
    expect(find.text('Añadir 1 a la colección y a Caja de la tienda'),
        findsOneWidget);
  });

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

  testWidgets('el contador de la ficha suma copias con un toque',
      (tester) async {
    final tray = ScanTray()..add(_rec('sol', set: 'lea', num: '270'));
    final cambios = <int>[];

    await tester.pumpWidget(_host(tray, onQty: (_, d) => cambios.add(d)));
    await tester.tap(find.byTooltip('Otra igual'));
    await tester.pump();

    expect(cambios, [1]);
  });

  testWidgets('el contador también resta', (tester) async {
    final tray = ScanTray()..add(_rec('sol', set: 'lea', num: '270'));
    final cambios = <int>[];

    await tester.pumpWidget(_host(tray, onQty: (_, d) => cambios.add(d)));
    await tester.tap(find.byTooltip('Una menos'));
    await tester.pump();

    expect(cambios, [-1]);
  });

  testWidgets('la carta que está sobre la mesa se marca', (tester) async {
    final tray = ScanTray()..add(_rec('sol', set: 'lea', num: '270'));
    final linea = tray.lines.single;

    await tester.pumpWidget(_host(tray, onTableKey: linea.key));

    expect(find.text('en mesa'), findsOneWidget);
  });

  testWidgets('sin nada en la mesa no se marca ninguna ficha', (tester) async {
    final tray = ScanTray()..add(_rec('sol', set: 'lea', num: '270'));

    await tester.pumpWidget(_host(tray));

    expect(find.text('en mesa'), findsNothing);
  });
}
