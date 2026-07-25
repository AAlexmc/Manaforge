import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/backup.dart';
import 'package:manaforge_app/services/factory_reset.dart';
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
}
