import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/services/backup.dart';
import 'package:path/path.dart' as p;

/// Directorio de datos de mentira con los almacenes que se le pidan.
Directory _dataDir(Map<String, String> files) {
  final dir = Directory.systemTemp.createTempSync('mfbak');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  files.forEach((name, content) {
    File(p.join(dir.path, name)).writeAsStringSync(content);
  });
  return dir;
}

Map<String, dynamic> _payload(List<int> bytes) =>
    jsonDecode(utf8.decode(gzip.decode(bytes))) as Map<String, dynamic>;

void main() {
  test('la copia lleva los almacenes que existen y ninguno más', () async {
    final dir = _dataDir({
      'collection.json': '{"cards":[{"oracleId":"a"},{"oracleId":"b"}]}',
      'decks.json': '[{"name":"Mono rojo"}]',
      'manaforge_cards.sqlite': 'esto no debe entrar',
    });

    final bytes = await buildBackup(dir, now: DateTime.utc(2026, 7, 21, 20, 15));
    final payload = _payload(bytes);
    final stores = payload['stores'] as Map<String, dynamic>;

    expect(stores.keys, unorderedEquals(['collection.json', 'decks.json']));
    expect(stores['decks.json'], '[{"name":"Mono rojo"}]');
    expect(payload['format'], kBackupFormatVersion);
    expect(payload['createdAt'], '2026-07-21T20:15:00.000Z');
  });

  test('el manifiesto cuenta cartas, mazos y carpetas para poder enseñarlo',
      () async {
    final dir = _dataDir({
      'collection.json': '{"cards":[{"oracleId":"a"},{"oracleId":"b"}]}',
      'decks.json': '[{"name":"Mono rojo"}]',
      'folders.json': '[{"name":"Vintage"},{"name":"Regalos"}]',
      'achievements.json': '{"unlocked":["primera-carta"]}',
    });

    final payload = _payload(await buildBackup(dir));
    final counts = payload['counts'] as Map<String, dynamic>;

    expect(counts['cartas'], 2);
    expect(counts['mazos'], 1);
    expect(counts['carpetas'], 2);
    expect(counts['logros'], 1);
  });

  test(
      'un almacén con JSON roto no revienta la copia: cuenta 0 y se guarda tal cual',
      () async {
    final dir = _dataDir({'decks.json': 'esto no es json'});

    final payload = _payload(await buildBackup(dir));

    expect((payload['counts'] as Map<String, dynamic>)['mazos'], 0);
    expect((payload['stores'] as Map<String, dynamic>)['decks.json'],
        'esto no es json');
  });

  test('leer el manifiesto describe la copia sin tocar disco', () async {
    final dir = _dataDir({
      'collection.json': '{"cards":[{"oracleId":"a"}]}',
      'decks.json': '[{"name":"Mono rojo"}]',
    });

    final manifest =
        readManifest(await buildBackup(dir, now: DateTime.utc(2026, 7, 21)));

    expect(manifest.formatVersion, kBackupFormatVersion);
    expect(manifest.createdAt, DateTime.utc(2026, 7, 21));
    expect(manifest.counts['cartas'], 1);
    expect(manifest.stores, unorderedEquals(['collection.json', 'decks.json']));
  });

  test('un fichero que no es una copia da error entendible', () {
    expect(
      () => readManifest(Uint8List.fromList(utf8.encode('hola'))),
      throwsA(isA<BackupError>()),
    );
  });

  test('una copia gzip pero sin almacenes dentro da error', () {
    final bytes = Uint8List.fromList(
        gzip.encode(utf8.encode(jsonEncode({'format': 1}))));

    expect(() => readManifest(bytes), throwsA(isA<BackupError>()));
  });

  test('una copia de una versión más nueva se rechaza en vez de medio leerla',
      () {
    final bytes = Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
      'format': kBackupFormatVersion + 1,
      'createdAt': '2026-07-21T00:00:00.000Z',
      'stores': <String, dynamic>{'decks.json': '[]'},
    }))));

    expect(
      () => readManifest(bytes),
      throwsA(isA<BackupError>()
          .having((e) => e.message, 'message', contains('más nueva'))),
    );
  });

  test('restaurar deja los almacenes exactamente como estaban', () async {
    final origen = _dataDir({
      'collection.json': '{"cards":[{"oracleId":"a"}]}',
      'decks.json': '[{"name":"Mono rojo"}]',
    });
    final copia = await buildBackup(origen);
    final destino = _dataDir({'collection.json': '{"cards":[]}'});

    final report = await restoreBackup(copia, destino);

    expect(File(p.join(destino.path, 'collection.json')).readAsStringSync(),
        '{"cards":[{"oracleId":"a"}]}');
    expect(File(p.join(destino.path, 'decks.json')).readAsStringSync(),
        '[{"name":"Mono rojo"}]');
    expect(report.written, unorderedEquals(['collection.json', 'decks.json']));
  });

  test('lo que la copia no traía se borra: restaurar es dejarlo como ese día',
      () async {
    final origen = _dataDir({'collection.json': '{"cards":[]}'});
    final copia = await buildBackup(origen);
    final destino = _dataDir({
      'collection.json': '{"cards":[]}',
      'decks.json': '[{"name":"Mazo de después"}]',
    });

    final report = await restoreBackup(copia, destino);

    expect(File(p.join(destino.path, 'decks.json')).existsSync(), isFalse);
    expect(report.removed, ['decks.json']);
  });

  test('antes de aplicar se guarda el estado de ahora, para poder deshacer',
      () async {
    final origen = _dataDir({'collection.json': '{"cards":[]}'});
    final copia = await buildBackup(origen);
    final destino = _dataDir({'decks.json': '[{"name":"Lo que había"}]'});

    final report = await restoreBackup(copia, destino,
        now: DateTime.utc(2026, 7, 21, 20, 15));

    expect(report.previous, isNotNull);
    expect(
        p.basename(report.previous!.path), 'pre-restore-2026-07-21-201500.mfbak');
    final anterior = readManifest(await report.previous!.readAsBytes());
    expect(anterior.stores, ['decks.json']);
  });

  test('una copia corrupta no escribe NADA en el directorio de datos',
      () async {
    final destino =
        _dataDir({'collection.json': '{"cards":[{"oracleId":"a"}]}'});
    final antes = destino.listSync().map((e) => p.basename(e.path)).toList();

    await expectLater(
      restoreBackup(Uint8List.fromList(utf8.encode('hola')), destino),
      throwsA(isA<BackupError>()),
    );

    expect(destino.listSync().map((e) => p.basename(e.path)),
        unorderedEquals(antes));
    expect(File(p.join(destino.path, 'collection.json')).readAsStringSync(),
        '{"cards":[{"oracleId":"a"}]}');
  });

  test('un nombre de almacén inventado se ignora en vez de escribirlo',
      () async {
    final bytes = Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
      'format': kBackupFormatVersion,
      'createdAt': '2026-07-21T00:00:00.000Z',
      'stores': <String, dynamic>{
        'decks.json': '[]',
        'no-soy-un-almacen.json': 'x',
      },
    }))));
    final destino = _dataDir({});

    final report = await restoreBackup(bytes, destino);

    expect(report.written, ['decks.json']);
    expect(
        File(p.join(destino.path, 'no-soy-un-almacen.json')).existsSync(),
        isFalse);
  });

  test('no quedan ficheros temporales tirados tras restaurar', () async {
    final origen = _dataDir({'collection.json': '{"cards":[]}'});
    final destino = _dataDir({});

    await restoreBackup(await buildBackup(origen), destino);

    final sueltos = destino
        .listSync()
        .map((e) => p.basename(e.path))
        .where((n) => n.endsWith('.restore-tmp'));
    expect(sueltos, isEmpty);
  });

  test('la primera vez siempre hace copia automática', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});

    final file = await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 21));

    expect(file, isNotNull);
    expect(p.basename(file!.path), 'auto-2026-07-21-000000.mfbak');
  });

  test('no repite copia si la última es de hace menos de 7 días', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 21));

    final segunda = await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 25));

    expect(segunda, isNull);
  });

  test('pasados 7 días vuelve a copiar', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 21));

    final segunda = await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 29));

    expect(segunda, isNotNull);
  });

  test('solo se guardan las 5 automáticas más nuevas', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    for (var i = 0; i < 7; i++) {
      await autoBackupIfStale(dir, now: DateTime.utc(2026, 1, 1 + i * 8));
    }

    final quedan = Directory(p.join(dir.path, kBackupDirName))
        .listSync()
        .map((e) => p.basename(e.path))
        .toList()
      ..sort();

    expect(quedan.length, 5);
    // 1 ene + 6 saltos de 8 días = 18 feb, la más nueva de las siete
    expect(quedan.last, 'auto-2026-02-18-000000.mfbak');
  });

  test('la rotación de automáticas no se lleva por delante las pre-restore',
      () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    await writeBackupFile(dir, prefix: 'pre-restore', now: DateTime.utc(2025));
    for (var i = 0; i < 7; i++) {
      await autoBackupIfStale(dir, now: DateTime.utc(2026, 1, 1 + i * 8));
    }

    final nombres = Directory(p.join(dir.path, kBackupDirName))
        .listSync()
        .map((e) => p.basename(e.path));

    expect(nombres, contains('pre-restore-2025-01-01-000000.mfbak'));
  });

  test('listBackups devuelve las copias de la más nueva a la más vieja',
      () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    await autoBackupIfStale(dir, now: DateTime.utc(2026, 1, 1));
    await autoBackupIfStale(dir, now: DateTime.utc(2026, 3, 1));

    final copias = await listBackups(dir);

    expect(copias.map((f) => p.basename(f.path)),
        ['auto-2026-03-01-000000.mfbak', 'auto-2026-01-01-000000.mfbak']);
  });

  test('cada copia se enseña con su tipo y su fecha, no con el nombre crudo',
      () {
    final t = AppLocalizationsEs();
    expect(backupLabel(File('/x/auto-2026-07-21-201500.mfbak'), t),
        startsWith('automática · 21/07/2026'));
    expect(backupLabel(File('/x/pre-restore-2026-07-21-201500.mfbak'), t),
        startsWith('antes de restaurar · 21/07/2026'));
    expect(backupLabel(File('/x/pre-reset-2026-07-21-201500.mfbak'), t),
        startsWith('Antes del reset de fábrica · 21/07/2026'));
  });

  test(
      'listBackups ordena por fecha del sello, no por nombre: mezclar '
      'prefijos no descuadra el orden', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    // "auto-..." va antes que "pre-restore-..." alfabéticamente aunque sea
    // más reciente: si se ordenara por basename, saldría en el sitio malo
    await writeBackupFile(dir, prefix: 'pre-restore', now: DateTime.utc(2026, 1, 1));
    await writeBackupFile(dir, prefix: 'auto', now: DateTime.utc(2026, 6, 1));
    await writeBackupFile(dir, prefix: 'pre-reset', now: DateTime.utc(2026, 3, 1));

    final copias = await listBackups(dir);

    expect(copias.map((f) => p.basename(f.path)), [
      'auto-2026-06-01-000000.mfbak',
      'pre-reset-2026-03-01-000000.mfbak',
      'pre-restore-2026-01-01-000000.mfbak',
    ]);
  });

  test('rotateBackupsWithPrefix deja como mucho `keep` copias de ese prefijo',
      () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    for (var i = 0; i < 3; i++) {
      await writeBackupFile(dir,
          prefix: 'pre-reset', now: DateTime.utc(2026, 1, 1 + i));
    }

    await rotateBackupsWithPrefix(dir, 'pre-reset', keep: 2);

    final quedan = (await listBackups(dir))
        .map((f) => p.basename(f.path))
        .toList();
    expect(quedan.length, 2);
    expect(quedan.first, 'pre-reset-2026-01-03-000000.mfbak');
  });

  // --- regresiones cazadas en revisión (bugs reales, reproducidos) ---

  test('dos restaurar en el mismo segundo NO se pisan la copia de deshacer',
      () async {
    final destino = _dataDir({'collection.json': '{"cards":[{"oracleId":"ORIG"}]}'});
    final copiaA = await buildBackup(
        _dataDir({'collection.json': '{"cards":[{"oracleId":"A"}]}'}));
    final copiaB = await buildBackup(
        _dataDir({'collection.json': '{"cards":[{"oracleId":"B"}]}'}));
    final t = DateTime.utc(2026, 7, 21, 20, 15, 30);

    final r1 = await restoreBackup(copiaA, destino, now: t);
    final r2 = await restoreBackup(copiaB, destino, now: t);

    expect(r1.previous!.path, isNot(r2.previous!.path));
    // la PRIMERA red sigue teniendo lo que había de verdad al principio
    final original = _payload(await r1.previous!.readAsBytes());
    expect((original['stores'] as Map<String, dynamic>)['collection.json'],
        '{"cards":[{"oracleId":"ORIG"}]}');
    expect((await listBackups(destino)).length, 2);
  });

  test('un almacén conocido con contenido que no es texto para el restaurar '
      'en seco, en vez de borrarlo', () async {
    final bytes = Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
      'format': kBackupFormatVersion,
      'createdAt': '2026-07-21T00:00:00.000Z',
      'stores': <String, dynamic>{
        'collection.json': {'no': 'soy texto'},
        'decks.json': '[]',
      },
    }))));
    final destino =
        _dataDir({'collection.json': '{"cards":[{"oracleId":"a"}]}'});

    await expectLater(
      restoreBackup(bytes, destino),
      throwsA(isA<BackupError>()
          .having((e) => e.message, 'message', contains('dañada'))),
    );

    expect(File(p.join(destino.path, 'collection.json')).readAsStringSync(),
        '{"cards":[{"oracleId":"a"}]}');
  });

  test('deshacer un restaurar equivocado devuelve los ficheros a su contenido',
      () async {
    final destino =
        _dataDir({'collection.json': '{"cards":[{"oracleId":"ORIG"}]}'});
    final otra = await buildBackup(
        _dataDir({'collection.json': '{"cards":[{"oracleId":"OTRA"}]}'}));

    final report = await restoreBackup(otra, destino);
    expect(File(p.join(destino.path, 'collection.json')).readAsStringSync(),
        '{"cards":[{"oracleId":"OTRA"}]}');

    await restoreBackup(await report.previous!.readAsBytes(), destino);

    expect(File(p.join(destino.path, 'collection.json')).readAsStringSync(),
        '{"cards":[{"oracleId":"ORIG"}]}');
  });

  test('un almacén con bytes que no son UTF-8 no impide copiar ni restaurar',
      () async {
    final destino = _dataDir({'collection.json': '{"cards":[]}'});
    // 0xFF no es UTF-8 válido: es lo que deja un guardado cortado a mitad
    File(p.join(destino.path, 'decks.json'))
        .writeAsBytesSync([0x5b, 0xff, 0x5d]);

    final copia = await buildBackup(destino);
    final report = await restoreBackup(copia, destino);

    expect(report.previous, isNotNull, reason: 'la red se pudo construir');
    expect(report.previousError, isNull);
  });

  test('si un renombre falla, se dice a medias que quedó y dónde volver',
      () async {
    final origen = _dataDir({
      'collection.json': '{"cards":[{"oracleId":"NUEVA"}]}',
      'wishlist.json': '[]',
    });
    final copia = await buildBackup(origen);
    final destino = _dataDir({});
    // un directorio donde debería ir un fichero: el rename no puede
    Directory(p.join(destino.path, 'wishlist.json')).createSync();

    await expectLater(
      restoreBackup(copia, destino),
      throwsA(isA<BackupError>()
          .having((e) => e.message, 'message', contains('a medias'))
          .having((e) => e.message, 'message', contains('pre-restore'))),
    );

    final sueltos = destino
        .listSync()
        .map((e) => p.basename(e.path))
        .where((n) => n.endsWith('.restore-tmp'));
    expect(sueltos, isEmpty, reason: 'los temporales se barren al fallar');
  });

  test('una copia automática con fecha futura no apaga las copias para siempre',
      () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    // reloj adelantado en un arranque (pila de la placa, NTP sin sincronizar)
    await autoBackupIfStale(dir, now: DateTime.utc(2035, 1, 1));

    final ahora = await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 21));

    expect(ahora, isNotNull);
    expect(ahora!.existsSync(), isTrue);
  });

  test('keep a 0 no borra la copia que se acaba de escribir', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});

    final file =
        await autoBackupIfStale(dir, keep: 0, now: DateTime.utc(2026, 7, 21));

    expect(file, isNotNull);
    expect(file!.existsSync(), isTrue,
        reason: 'si devuelvo un fichero, ese fichero existe');
  });

  test('campos del manifiesto con tipos raros dan BackupError o valor por '
      'defecto, nunca un error de tipos en la cara del usuario', () {
    final bytes = Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
      'format': kBackupFormatVersion,
      'createdAt': 12345,
      'appVersion': ['raro'],
      'counts': ['tampoco toca'],
      'stores': <String, dynamic>{'decks.json': '[]'},
    }))));

    final manifest = readManifest(bytes);

    expect(manifest.appVersion, 'desconocida');
    expect(manifest.stores, ['decks.json']);
  });

  test('los recuentos que se enseñan salen de los datos, no de lo que diga la '
      'copia', () {
    // copia que PRESUME de 283 cartas con una colección vacía dentro
    final bytes = Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode({
      'format': kBackupFormatVersion,
      'createdAt': '2026-07-21T00:00:00.000Z',
      'counts': {'cartas': 283, 'mazos': 4},
      'stores': <String, dynamic>{'collection.json': '{"cards":[]}'},
    }))));

    final manifest = readManifest(bytes);

    expect(manifest.counts['cartas'], 0);
    expect(manifest.summary(AppLocalizationsEs()), 'copia vacía');
  });

  test('el historial de precios (jsonl y el formato viejo) también se copia',
      () async {
    final dir = _dataDir({
      'price_history.jsonl': '{"o":"a","d":"2026-07-01","v":1.5}\n',
      'price_history.json': '{"a":[]}',
    });

    final manifest = readManifest(await buildBackup(dir));

    expect(manifest.stores,
        unorderedEquals(['price_history.jsonl', 'price_history.json']));
  });

  test('los .restore-tmp de un restaurar interrumpido se barren al siguiente',
      () async {
    final origen = _dataDir({'collection.json': '{"cards":[]}'});
    final destino = _dataDir({});
    File(p.join(destino.path, 'decks.json$kRestoreTmpSuffix'))
        .writeAsStringSync('basura de un apagón');

    await restoreBackup(await buildBackup(origen), destino);

    expect(
        File(p.join(destino.path, 'decks.json$kRestoreTmpSuffix')).existsSync(),
        isFalse);
  });
}
