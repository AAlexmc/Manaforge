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
}
