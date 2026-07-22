import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/backup_screen.dart';
import 'package:manaforge_app/services/backup.dart';
import 'package:path/path.dart' as p;

Directory _dataDirWith(Map<String, String> files) {
  final dir = Directory.systemTemp.createTempSync('mfbak-ui');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  files.forEach((name, content) {
    File(p.join(dir.path, name)).writeAsStringSync(content);
  });
  return dir;
}

BackupManifest _manifest() => BackupManifest(
      formatVersion: kBackupFormatVersion,
      createdAt: DateTime.utc(2026, 7, 21),
      appVersion: '0.1.0',
      counts: const {'cartas': 283, 'mazos': 4},
      stores: const ['collection.json'],
    );

void main() {
  testWidgets('la tarjeta ofrece guardar y restaurar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BackupCard(dataDir: () async => null, onRestored: () {}),
      ),
    ));

    expect(find.text('Copia de seguridad'), findsOneWidget);
    expect(find.text('Guardar copia'), findsOneWidget);
    expect(find.text('Restaurar de un archivo'), findsOneWidget);
  });

  testWidgets('restaurar no se puede hacer sin escribir CONFIRMAR',
      (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }),
    ));

    bool? resultado;
    unawaited(confirmRestore(ctx, _manifest()).then((v) => resultado = v));
    await tester.pump();

    // el botón nace apagado: un clic despistado no puede borrar una colección
    final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Restaurar'));
    expect(boton.onPressed, isNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Restaurar'));
    await tester.pump();
    expect(resultado, isNull, reason: 'no debería haber restaurado nada');

    // escribir otra cosa tampoco vale
    await tester.enterText(find.byType(TextField), 'confirmar el borrado');
    await tester.pump();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Restaurar'))
            .onPressed,
        isNull);

    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Restaurar'));
    await tester.pump();

    expect(resultado, isTrue);
  });

  testWidgets('cancelar el diálogo de CONFIRMAR no restaura', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }),
    ));

    final future = confirmRestore(ctx, _manifest());
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.text('Cancelar'));
    await tester.pump();

    expect(await future, isFalse);
  });

  testWidgets('el diálogo avisa de lo que la copia NO trae y se va a borrar',
      (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }),
    ));

    unawaited(confirmRestore(ctx, _manifest(),
        willDelete: const ['tus certificados', 'el historial de precios']));
    await tester.pump();

    expect(
        find.textContaining(
            'tus certificados y el historial de precios'),
        findsOneWidget);
    expect(find.textContaining('se borra'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pump();
  });

  testWidgets('con varias copias sale un desplegable para elegir cuál',
      (tester) async {
    final dir = _dataDirWith({'collection.json': '{"cards":[]}'});
    await tester.runAsync(() async {
      await writeBackupFile(dir,
          prefix: 'auto', now: DateTime.utc(2026, 7, 13, 9, 15));
      await writeBackupFile(dir,
          prefix: 'auto', now: DateTime.utc(2026, 7, 20, 10, 30));
    });

    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BackupCard(dataDir: () async => dir, onRestored: () {}),
        ),
      ));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();

    expect(find.byType(DropdownButtonFormField<File>), findsOneWidget);
    // sin elegir copia, el botón de restaurar está apagado
    final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Restaurar la copia elegida'));
    expect(boton.onPressed, isNull);
  });

  testWidgets(
      'confirmar un restaurar dice QUÉ trae la copia y avisa de que reemplaza '
      'lo de ahora', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }),
    ));

    final manifest = BackupManifest(
      formatVersion: kBackupFormatVersion,
      createdAt: DateTime.utc(2026, 7, 21),
      appVersion: '0.1.0',
      counts: const {'cartas': 283, 'mazos': 4},
      stores: const ['collection.json'],
    );
    final future = confirmRestore(ctx, manifest);
    await tester.pump();

    expect(find.textContaining('283 cartas · 4 mazos'), findsOneWidget);
    expect(find.textContaining('reemplaza'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    expect(await future, isFalse);
  });

  testWidgets('las copias automáticas se enseñan con su fecha, no escondidas '
      'en una carpeta del sistema', (tester) async {
    final dir = _dataDirWith({'collection.json': '{"cards":[]}'});
    await tester.runAsync(() async {
      await writeBackupFile(dir,
          prefix: 'auto', now: DateTime.utc(2026, 7, 20, 10, 30));
    });

    // el listado se carga en initState leyendo el disco DE VERDAD. Con el
    // reloj falso de testWidgets esos futuros no avanzan nunca, así que el
    // widget se monta DENTRO de runAsync: así nacen en el mundo real
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BackupCard(dataDir: () async => dir, onRestored: () {}),
        ),
      ));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();

    // el desplegable dice la FECHA de cada copia: el nombre de fichero crudo
    // no le dice nada a nadie
    await tester.tap(find.byType(DropdownButtonFormField<File>));
    await tester.pumpAndSettle();

    expect(find.textContaining('automática · 20/07/2026'), findsWidgets);
  });

  testWidgets('sin copias automáticas no se enseña la lista vacía',
      (tester) async {
    final dir = _dataDirWith({'collection.json': '{"cards":[]}'});

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BackupCard(dataDir: () async => dir, onRestored: () {}),
      ),
    ));
    await tester.pump();
    await tester.pump();

    // sin copias no hay desplegable vacío ni botón que no lleve a ninguna
    // parte: solo se dice que no hay nada y queda la vía del archivo
    expect(find.byType(DropdownButtonFormField<File>), findsNothing);
    expect(find.text('Restaurar la copia elegida'), findsNothing);
    expect(find.textContaining('Aún no hay copias guardadas'), findsOneWidget);
    expect(find.text('Restaurar de un archivo'), findsOneWidget);
  });
}
