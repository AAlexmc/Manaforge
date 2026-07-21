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

void main() {
  testWidgets('la tarjeta ofrece guardar y restaurar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BackupCard(dataDir: () async => null, onRestored: () {}),
      ),
    ));

    expect(find.text('Copia de seguridad'), findsOneWidget);
    expect(find.text('Guardar copia'), findsOneWidget);
    expect(find.text('Restaurar copia'), findsOneWidget);
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

    expect(find.textContaining('automática · 20/07/2026'), findsOneWidget);
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

    expect(find.text('Copias que he guardado yo solo'), findsNothing);
  });
}
