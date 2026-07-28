import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/backup.dart';
import 'package:manaforge_app/data/services/factory_reset.dart';
import 'package:path/path.dart' as p;

Future<Directory> _dataDir(Map<String, String> files) async {
  final dir = await Directory.systemTemp.createTemp('mf_reset');
  addTearDown(() async {
    if (await dir.exists()) await dir.delete(recursive: true);
  });
  for (final e in files.entries) {
    final f = File(p.join(dir.path, e.key));
    await f.parent.create(recursive: true);
    await f.writeAsString(e.value);
  }
  return dir;
}

void main() {
  test('la copia pre-reset se escribe en backups/ y es legible', () async {
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'decks.json': '[]',
    });
    final copia = await preResetBackup(dir);
    expect(copia, isNotNull);
    expect(p.basename(copia!.parent.path), 'backups');
    final contents = readBackup(await copia.readAsBytes());
    expect(contents.stores.keys,
        containsAll(['collection.json', 'decks.json']));
  });

  test('sin datos que copiar: devuelve null en vez de reventar', () async {
    final dir = await _dataDir({'algo.tmp': 'restos'});
    expect(await preResetBackup(dir), isNull);
  });

  test('si la copia no se puede escribir, lanza (y nadie borra nada)',
      () async {
    // un FICHERO llamado backups impide crear la carpeta
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'backups': 'soy un fichero, no una carpeta',
    });
    await expectLater(preResetBackup(dir), throwsA(anything));
    expect(File(p.join(dir.path, 'collection.json')).existsSync(), isTrue);
  });

  test('wipeDataDir borra todo salvo backups/', () async {
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'decks.json': '[]',
      'language.json': '{}',
      'manaforge_cards.sqlite': 'sqlite falsa',
      'collection.json.roto': 'x',
      'collection.1.tmp': 'x',
      'background_123.jpg': 'img',
      'backups/auto-viejo.mfbak': 'copia vieja',
    });
    final report = await wipeDataDir(dir);
    final quedan =
        dir.listSync().map((e) => p.basename(e.path)).toList()..sort();
    expect(quedan, ['backups']);
    expect(File(p.join(dir.path, 'backups', 'auto-viejo.mfbak')).existsSync(),
        isTrue);
    expect(report.failed, isEmpty);
    expect(report.deleted, isNot(contains('backups')));
    expect(report.deleted, contains('manaforge_cards.sqlite'));
  });

  test('wipeDataDir arrastra el backupFile al informe', () async {
    final dir = await _dataDir({'collection.json': '{"cards":[]}'});
    final copia = await preResetBackup(dir);
    final report = await wipeDataDir(dir, backup: copia);
    expect(report.backupFile, copia);
    expect(await copia!.exists(), isTrue);
  });

  test('un .roto se rescata a backups/ en vez de borrarse', () async {
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'collection.json.roto': 'datos rescatables',
    });
    final report = await wipeDataDir(dir);
    expect(
        File(p.join(dir.path, 'backups', 'collection.json.roto'))
            .existsSync(),
        isTrue);
    expect(File(p.join(dir.path, 'collection.json.roto')).existsSync(),
        isFalse);
    expect(report.rescued, contains('collection.json.roto'));
    expect(report.deleted, isNot(contains('collection.json.roto')));
  });

  test('dos .roto con el mismo nombre no se pisan al rescatar', () async {
    final dir = await _dataDir({'collection.json.roto': 'primero'});
    await Directory(p.join(dir.path, 'backups')).create();
    await File(p.join(dir.path, 'backups', 'collection.json.roto'))
        .writeAsString('ya había uno');
    final report = await wipeDataDir(dir);
    expect(
        await File(p.join(dir.path, 'backups', 'collection.json.roto'))
            .readAsString(),
        'ya había uno');
    final rescatado =
        File(p.join(dir.path, 'backups', 'collection.json-2.roto'));
    expect(await rescatado.exists(), isTrue);
    expect(report.rescued, contains('collection.json-2.roto'));
  });

  group('factoryReset (orquestación)', () {
    test('si la copia falla, closeDbs NO se invoca y nada se borra', () async {
      final dir = await _dataDir({
        'collection.json': '{"cards":[]}',
        'backups': 'soy un fichero, no una carpeta',
      });
      var closes = 0;
      await expectLater(
          factoryReset(dir,
              closeDbs: () => closes++, clearBackground: () async {}),
          throwsA(anything));
      expect(closes, 0);
      expect(File(p.join(dir.path, 'collection.json')).existsSync(), isTrue);
    });

    test(
        'un fallo DESPUÉS de la copia se convierte en FactoryResetHalfDone y '
        'la copia pre-reset existe', () async {
      final dir = await _dataDir({'collection.json': '{"cards":[]}'});
      Object? capturado;
      try {
        await factoryReset(dir,
            closeDbs: () {},
            clearBackground: () async => throw Exception('fondo roto'));
      } catch (e) {
        capturado = e;
      }
      expect(capturado, isA<FactoryResetHalfDone>());
      final copias = Directory(p.join(dir.path, 'backups'))
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('pre-reset-'));
      expect(copias, isNotEmpty);
      // nada se ha barrido: la mitad de la copia es la única que ha corrido
      expect(File(p.join(dir.path, 'collection.json')).existsSync(), isTrue);
    });

    test('éxito limpio: cierra bases una vez y devuelve el informe',
        () async {
      final dir = await _dataDir({'collection.json': '{"cards":[]}'});
      var closes = 0;
      var fondoLimpiado = false;
      final report = await factoryReset(dir,
          closeDbs: () => closes++,
          clearBackground: () async => fondoLimpiado = true);
      expect(closes, 1);
      expect(fondoLimpiado, isTrue);
      expect(report.failed, isEmpty);
      expect(report.deleted, contains('collection.json'));
    }, skip: Platform.isWindows);

    test(
        'un fallo de barrido persistente (segunda pasada incluida) se '
        'devuelve en el informe y no se pierde',
        () async {
      final dir = await _dataDir({'collection.json': '{"cards":[]}'});
      final bloqueada = Directory(p.join(dir.path, 'bloqueada'))
        ..createSync();
      File(p.join(bloqueada.path, 'dentro.txt')).writeAsStringSync('x');
      await Process.run('chmod', ['0500', bloqueada.path]);
      addTearDown(() async {
        await Process.run('chmod', ['0700', bloqueada.path]);
      });
      // root ignora el chmod (contenedores CI): si aún se puede escribir
      // dentro, el escenario no se puede montar y el test no aplica
      try {
        File(p.join(bloqueada.path, 'sonda.txt')).writeAsStringSync('x');
        markTestSkipped('chmod no frena a este usuario (¿root?)');
        return;
      } on FileSystemException {
        // bien: la carpeta está bloqueada de verdad
      }

      var closes = 0;
      final report = await factoryReset(dir,
          closeDbs: () => closes++, clearBackground: () async {});

      // dos pasadas: la primera y el reintento porque `failed` no venía vacío
      expect(closes, 2);
      expect(report.failed, contains('bloqueada'));
      expect(report.deleted, contains('collection.json'));
    }, skip: Platform.isWindows);
  });
}
