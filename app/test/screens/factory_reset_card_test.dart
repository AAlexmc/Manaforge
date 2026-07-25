import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/factory_reset_card.dart';
import 'package:manaforge_app/services/backup.dart';
import 'package:manaforge_app/services/factory_reset.dart';

import '../helpers/app_l10n.dart';

void main() {
  var wipes = 0;
  var dones = 0;
  Widget carta({Future<FactoryResetReport> Function()? wipe}) {
    return appDePrueba(
      home: Scaffold(
        body: FactoryResetCard(
          wipe: wipe ??
              () async {
                wipes++;
                return const FactoryResetReport(
                    backupFile: null, deleted: [], failed: []);
              },
          onDone: () => dones++,
        ),
      ),
    );
  }

  setUp(() {
    wipes = 0;
    dones = 0;
  });

  testWidgets('no se borra sin escribir ELIMINAR', (tester) async {
    await tester.pumpWidget(carta());
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    // el botón de seguir nace apagado
    final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continuar'));
    expect(boton.onPressed, isNull);
    // una palabra que no es, no lo enciende
    await tester.enterText(find.byType(TextField), 'BORRAR');
    await tester.pump();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Continuar'))
            .onPressed,
        isNull);
    expect(wipes, 0);
  });

  testWidgets('cancelar en el segundo diálogo tampoco borra', (tester) async {
    await tester.pumpWidget(carta());
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), ' eliminar ');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(find.text('Última confirmación'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    expect(wipes, 0);
    expect(dones, 0);
  });

  testWidgets('ELIMINAR + CONFIRMAR ejecuta el borrado y avisa al terminar',
      (tester) async {
    await tester.pumpWidget(carta());
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'ELIMINAR');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.text('Borrar definitivamente'));
    await tester.pump(); // arranca el trabajo
    await tester.pump(); // la barrera se cierra
    expect(wipes, 1);
    expect(dones, 1);
  });

  testWidgets('si la copia previa falla, no llama a onDone y enseña el motivo',
      (tester) async {
    await tester.pumpWidget(carta(
        wipe: () async => throw const BackupError(
            'No he podido escribir en la carpeta de datos.',
            code: BackupErrorCode.writeFailed)));
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'ELIMINAR');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.text('Borrar definitivamente'));
    await tester.pump();
    await tester.pump();
    expect(dones, 0);
    expect(find.textContaining('NO se ha borrado nada'), findsOneWidget);
  });

  /// Los tres flujos de abajo comparten los dos primeros diálogos (ELIMINAR
  /// + CONFIRMAR); solo cambia qué hace `wipe` y qué pasa después.
  Future<void> _hastaElBorrado(WidgetTester tester) async {
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'ELIMINAR');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.text('Borrar definitivamente'));
    await tester.pump(); // arranca el trabajo
    await tester.pump(); // la barrera se cierra
  }

  testWidgets(
      'éxito con `failed` no vacío: enseña qué queda y llama a onDone tras '
      'cerrar el diálogo', (tester) async {
    await tester.pumpWidget(carta(
        wipe: () async => const FactoryResetReport(
            backupFile: null,
            deleted: ['collection.json'],
            failed: ['decks.json', 'wishlist.json'])));
    await _hastaElBorrado(tester);

    expect(find.textContaining('decks.json, wishlist.json'), findsOneWidget);
    expect(dones, 0); // el diálogo sigue abierto: onDone todavía no

    await tester.tap(find.text('Entendido'));
    await tester.pump();

    expect(dones, 1);
  });

  testWidgets('FactoryResetHalfDone: enseña el aviso y SÍ llama a onDone',
      (tester) async {
    await tester.pumpWidget(carta(
        wipe: () async =>
            throw FactoryResetHalfDone(Exception('fondo roto'))));
    await _hastaElBorrado(tester);

    expect(find.textContaining('a medias'), findsOneWidget);
    expect(dones, 0);

    await tester.tap(find.text('Entendido'));
    await tester.pump();

    expect(dones, 1);
  });

  testWidgets(
      'un fallo que no es BackupError (disco lleno) tampoco borra nada: '
      'mensaje visible y el botón sigue vivo', (tester) async {
    await tester.pumpWidget(carta(
        wipe: () async =>
            throw const FileSystemException('disco lleno')));
    await _hastaElBorrado(tester);

    expect(dones, 0);
    expect(find.textContaining('NO se ha borrado nada'), findsOneWidget);
    expect(find.textContaining('disco lleno'), findsOneWidget);
    // _busy liberado: se puede reintentar sin reconstruir la pantalla
    final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Borrar todo'));
    expect(boton.onPressed, isNotNull);
  });
}
