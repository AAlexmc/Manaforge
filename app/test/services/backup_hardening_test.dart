/// Un `.mfbak` puede venir de fuera: la tarjeta invita a dejar la copia "en un
/// disco, en la nube", así que circula. Lo que llega de fuera se acota.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/data/services/backup.dart';
import 'package:path/path.dart' as p;

Directory _dataDirWith(Map<String, String> files) {
  final dir = Directory.systemTemp.createTempSync('mfbak-dur');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  files.forEach((name, content) {
    File(p.join(dir.path, name)).writeAsStringSync(content);
  });
  return dir;
}

void main() {
  test('una copia que se hincha al descomprimir se para en seco', () {
    // 20 MB de ceros comprimen a unos pocos KB: es la bomba de descompresión
    // en pequeño. Con el tope a 64 KB se para igual que se pararía la de
    // gigas, y el test tarda milisegundos.
    final gordo = jsonEncode({
      'format': kBackupFormatVersion,
      'createdAt': '2026-07-22T10:00:00.000Z',
      'stores': {'collection.json': 'x' * (20 * 1024 * 1024)},
    });
    final bytes = Uint8List.fromList(gzip.encode(utf8.encode(gordo)));

    expect(bytes.length, lessThan(200 * 1024), reason: 'comprime muchísimo');
    expect(
      () => readBackup(bytes, maxBytes: 64 * 1024),
      throwsA(isA<BackupError>().having((e) => e.message, 'mensaje',
          contains('demasiado grande'))),
    );
  });

  test('una copia normal se lee entera con el tope de verdad', () async {
    final dir = _dataDirWith({'collection.json': '{"cards":[]}'});
    final bytes = await buildBackup(dir);

    final copia = readBackup(bytes);

    expect(copia.manifest.formatVersion, kBackupFormatVersion);
    expect(copia.stores.keys, contains('collection.json'));
  });

  test('restaurar no vuelve a descomprimir lo que ya se leyó', () async {
    final origen = _dataDirWith({'collection.json': '{"cards":[1,2,3]}'});
    final bytes = await buildBackup(origen);
    final copia = readBackup(bytes);

    // se pasan BYTES VACÍOS a propósito: si restaurar volviera a
    // descomprimir, esto reventaría. Con la copia ya leída, no la toca.
    final destino = _dataDirWith({'collection.json': '{"cards":[]}'});
    final report =
        await restoreBackup(Uint8List(0), destino, contents: copia);

    expect(report.written, contains('collection.json'));
    expect(
        File(p.join(destino.path, 'collection.json')).readAsStringSync(),
        '{"cards":[1,2,3]}');
  });

  test('un fichero demasiado grande ni se llega a leer', () {
    expect(
      () => ensureBackupFileSize(kMaxBackupFileBytes + 1),
      throwsA(isA<BackupError>()),
    );
    expect(() => ensureBackupFileSize(1024), returnsNormally);
  });

  test('qué se va a BORRAR por no venir en la copia, dicho en cristiano', () {
    final copia = BackupManifest(
      formatVersion: kBackupFormatVersion,
      createdAt: DateTime.utc(2026, 7, 22),
      appVersion: '0.1.0',
      counts: const {'cartas': 500},
      stores: const ['collection.json'],
    );

    final borra = storesToDelete(copia, present: const [
      'collection.json',
      'certificates.json',
      'price_history.jsonl',
      'decks.json',
    ]);

    expect(borra, contains('certificates.json'));
    expect(borra, contains('price_history.jsonl'));
    expect(borra, contains('decks.json'));
    expect(borra, isNot(contains('collection.json')),
        reason: 'la colección SÍ viene en la copia');

    // y cada uno se sabe decir en cristiano, que es de lo que va el aviso
    final t = AppLocalizationsEs();
    final dicho = borra.map((s) => backupStoreName(t, s)).toList();
    expect(dicho, contains('tus certificados'));
    expect(dicho, contains('el historial de precios'));
    expect(dicho, contains('tus mazos'));
  });
}
