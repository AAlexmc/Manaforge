# Bloque A · Copia de seguridad y restaurar — plan de implementación

> **Para agentes:** SUB-SKILL OBLIGATORIA: usar `superpowers:subagent-driven-development`
> (recomendado) o `superpowers:executing-plans` para ejecutar tarea a tarea.
> Los pasos usan casillas (`- [ ]`) para llevar la cuenta.

**Objetivo:** que el usuario pueda exportar todos sus datos a un fichero y
volver a meterlos, incluso desde la pantalla de carga cuando la app está rota.

**Arquitectura:** un módulo puro `lib/services/backup.dart` que trabaja sobre un
`Directory` y no sabe nada de UI: construye la copia, la valida y la aplica. La
copia es **un JSON comprimido con gzip**, no un zip — `dart:io` ya trae `gzip`,
así que no hace falta ninguna dependencia nueva (la spec decía `archive`; esto es
más simple y hace lo mismo). Encima, tres puntos de UI: Ajustes, pantalla de
carga y un reinicio de sesión en memoria tras restaurar.

**Stack:** Dart/Flutter, `dart:io` (`gzip`), `file_selector` (ya está),
`path_provider` (ya está). Sin dependencias nuevas.

## Restricciones globales

- Nada de dependencias nuevas en `app/pubspec.yaml`.
- Las bases `manaforge_cards.sqlite` y `manaforge_prices.sqlite` NO entran en la
  copia (~95 MB, se descargan solas). `meta_decks.json` tampoco (caché de red).
- Los almacenes que entran son exactamente estos diez: `collection.json`,
  `folders.json`, `decks.json`, `achievements.json`, `wishlist.json`,
  `certificates.json`, `market.json`, `recents.json`, `value_history.json`,
  `price_history.jsonl`.
- Textos de la UI en español y en el tono del resto de la app (tuteo, directo,
  sin jerga técnica).
- Toda función que dependa de la fecha recibe un parámetro `now` opcional: los
  tests no pueden usar el reloj real.
- Comentarios en español, explicando **por qué**, como el resto del repo.
- Los tests comprueban **el disco**, no solo el valor devuelto.
- `flutter analyze` sin avisos y `flutter test` en verde antes de cada commit.
- Rama: `feat/copia-seguridad`, creada desde `main` **después** de mergear el
  PR #4.

---

## Estructura de ficheros

| Fichero | Responsabilidad |
|---|---|
| `app/lib/services/backup.dart` (nuevo) | Construir, validar, aplicar y rotar copias. Lógica pura sobre un `Directory` |
| `app/test/services/backup_test.dart` (nuevo) | Tests del módulo, contra un directorio temporal real |
| `app/lib/screens/backup_screen.dart` (nuevo) | Diálogos y flujo de exportar/restaurar reutilizables desde Ajustes y desde la carga |
| `app/test/screens/backup_screen_test.dart` (nuevo) | Test de widget de la tarjeta y del diálogo de confirmación |
| `app/lib/screens/screens.dart` (modificar) | Tarjeta "Copia de seguridad" en `AjustesScreen` + export del nuevo fichero |
| `app/lib/screens/startup_screen.dart` (modificar) | Enlace "Restaurar copia" |
| `app/lib/main.dart` (modificar) | Reinicio de sesión en memoria tras restaurar |

---

### Tarea 1: Construir la copia (`buildBackup`)

**Ficheros:**
- Crear: `app/lib/services/backup.dart`
- Test: `app/test/services/backup_test.dart`

**Interfaces:**
- Consume: nada.
- Produce: `kBackupFormatVersion`, `kAppVersion`, `kBackupStores`,
  `kBackupDirName`, `BackupError`, `Future<Uint8List> buildBackup(Directory
  dataDir, {DateTime? now})`.

- [ ] **Paso 1: escribir el test que falla**

Crear `app/test/services/backup_test.dart`:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
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

  test('un almacén con JSON roto no revienta la copia: cuenta 0 y se guarda tal cual',
      () async {
    final dir = _dataDir({'decks.json': 'esto no es json'});

    final payload = _payload(await buildBackup(dir));

    expect((payload['counts'] as Map<String, dynamic>)['mazos'], 0);
    expect((payload['stores'] as Map<String, dynamic>)['decks.json'],
        'esto no es json');
  });
}
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: FALLA compilando — `Target of URI doesn't exist: 'package:manaforge_app/services/backup.dart'`.

- [ ] **Paso 3: escribir el módulo mínimo**

Crear `app/lib/services/backup.dart`:

```dart
/// Copia de seguridad de los datos del usuario: UN fichero `.mfbak` con todos
/// los almacenes locales dentro (JSON comprimido con gzip).
///
/// Se usa gzip de `dart:io` y no un zip para no meter una dependencia nueva
/// por algo que el SDK ya hace.
///
/// NO entran las bases sqlite (~95 MB, se descargan solas) ni
/// `meta_decks.json` (caché de red, no dato del usuario).
///
/// Lógica pura sobre un `Directory`: sin UI y testeable en CI.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// Versión del formato de la copia. Una copia con versión MAYOR que esta no se
/// restaura: la escribió una app más nueva y podría traer campos que aquí se
/// perderían sin que nadie se entere.
const int kBackupFormatVersion = 1;

/// Versión de la app que se guarda en el manifiesto, solo informativa.
/// Mantener a la par de `version:` en `pubspec.yaml`.
const String kAppVersion = '0.1.0';

/// Los almacenes del usuario, y solo esos. La lista es también la lista
/// blanca al restaurar: cualquier otro nombre dentro de una copia se ignora
/// (un fichero manipulado no va a escribir donde le apetezca).
const List<String> kBackupStores = [
  'collection.json',
  'folders.json',
  'decks.json',
  'achievements.json',
  'wishlist.json',
  'certificates.json',
  'market.json',
  'recents.json',
  'value_history.json',
  'price_history.jsonl',
];

/// Carpeta, dentro del directorio de datos, con las copias automáticas y las
/// de seguridad previas a un restaurar.
const String kBackupDirName = 'backups';

/// Fallo con mensaje ya escrito para enseñárselo al usuario tal cual.
class BackupError implements Exception {
  final String message;
  const BackupError(this.message);
  @override
  String toString() => message;
}

/// Construye la copia en memoria. Los almacenes que no existan simplemente no
/// van (una colección sin mazos es perfectamente válida).
Future<Uint8List> buildBackup(Directory dataDir, {DateTime? now}) async {
  final stores = <String, String>{};
  for (final name in kBackupStores) {
    final file = File(p.join(dataDir.path, name));
    if (!await file.exists()) continue;
    stores[name] = await file.readAsString();
  }
  final payload = <String, dynamic>{
    'format': kBackupFormatVersion,
    'createdAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
    'appVersion': kAppVersion,
    'counts': backupCounts(stores),
    'stores': stores,
  };
  return Uint8List.fromList(
      gzip.encode(utf8.encode(jsonEncode(payload))));
}

/// Recuentos para poder enseñar "283 cartas · 4 mazos · 12 carpetas" antes de
/// restaurar. Son ORIENTATIVOS: se sacan a ojo del JSON y no se usan jamás
/// para validar ni para decidir nada.
Map<String, int> backupCounts(Map<String, String> stores) => {
      'cartas': _count(stores['collection.json'], 'cards'),
      'mazos': _count(stores['decks.json'], null),
      'carpetas': _count(stores['folders.json'], null),
      'logros': _count(stores['achievements.json'], 'unlocked'),
      'wishlist': _count(stores['wishlist.json'], null),
      'certificados': _count(stores['certificates.json'], 'earnedAt'),
    };

/// Cuenta elementos de un JSON que puede ser una lista suelta o un objeto con
/// la colección bajo [key]. Cualquier sorpresa cuenta 0.
int _count(String? raw, String? key) {
  if (raw == null) return 0;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) return decoded.length;
    if (decoded is Map<String, dynamic> && key != null) {
      final value = decoded[key];
      if (value is List) return value.length;
      if (value is Map) return value.length;
    }
  } catch (_) {
    // almacén ilegible: se copia igual (los datos del usuario no se tiran),
    // pero no hay nada que contar
  }
  return 0;
}
```

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: 3 tests en verde.

- [ ] **Paso 5: commit**

```bash
git add app/lib/services/backup.dart app/test/services/backup_test.dart
git commit -m "Copia de seguridad: construir el fichero .mfbak"
```

---

### Tarea 2: Leer y validar una copia (`readManifest`)

**Ficheros:**
- Modificar: `app/lib/services/backup.dart`
- Test: `app/test/services/backup_test.dart`

**Interfaces:**
- Consume: `buildBackup`, `BackupError`, `kBackupFormatVersion`.
- Produce: `class BackupManifest` con campos `int formatVersion`,
  `DateTime createdAt`, `String appVersion`, `Map<String, int> counts`,
  `List<String> stores`; y `BackupManifest readManifest(Uint8List bytes)`.

- [ ] **Paso 1: escribir el test que falla**

Añadir a `app/test/services/backup_test.dart`, dentro de `main()`:

```dart
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
      throwsA(isA<BackupError>().having((e) => e.message, 'message',
          contains('más nueva'))),
    );
  });
```

Añadir `import 'dart:typed_data';` a la cabecera del test.

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: FALLA — `readManifest` y `BackupManifest` no están definidos.

- [ ] **Paso 3: implementar**

Añadir a `app/lib/services/backup.dart`:

```dart
/// Lo que una copia dice de sí misma, para poder enseñárselo al usuario ANTES
/// de aplicarla. Leerlo no toca disco.
class BackupManifest {
  final int formatVersion;
  final DateTime createdAt;
  final String appVersion;
  final Map<String, int> counts;
  final List<String> stores;

  const BackupManifest({
    required this.formatVersion,
    required this.createdAt,
    required this.appVersion,
    required this.counts,
    required this.stores,
  });

  /// Resumen de una línea para el diálogo de confirmación.
  String get summary {
    final partes = <String>[];
    void añadir(String clave, String uno, String varios) {
      final n = counts[clave] ?? 0;
      if (n > 0) partes.add('$n ${n == 1 ? uno : varios}');
    }

    añadir('cartas', 'carta', 'cartas');
    añadir('mazos', 'mazo', 'mazos');
    añadir('carpetas', 'carpeta', 'carpetas');
    añadir('logros', 'logro', 'logros');
    return partes.isEmpty ? 'copia vacía' : partes.join(' · ');
  }
}

/// Descomprime y valida la copia. Todo lo que pueda salir mal sale aquí, antes
/// de que nadie escriba nada en disco.
BackupManifest readManifest(Uint8List bytes) => _manifestOf(_decode(bytes));

Map<String, dynamic> _decode(Uint8List bytes) {
  final Object? decoded;
  try {
    decoded = jsonDecode(utf8.decode(gzip.decode(bytes)));
  } catch (_) {
    throw const BackupError(
        'Ese fichero no es una copia de seguridad de ManaForge.');
  }
  if (decoded is! Map<String, dynamic>) {
    throw const BackupError(
        'Ese fichero no es una copia de seguridad de ManaForge.');
  }
  final format = decoded['format'];
  if (format is! int) {
    throw const BackupError(
        'Ese fichero no es una copia de seguridad de ManaForge.');
  }
  if (format > kBackupFormatVersion) {
    throw const BackupError(
        'Esa copia la hizo una versión más nueva de ManaForge. Actualiza la '
        'app y vuelve a intentarlo.');
  }
  if (decoded['stores'] is! Map<String, dynamic>) {
    throw const BackupError('Esa copia está incompleta: no trae tus datos.');
  }
  return decoded;
}

BackupManifest _manifestOf(Map<String, dynamic> payload) {
  final stores = _storesOf(payload);
  final createdAt = DateTime.tryParse(payload['createdAt'] as String? ?? '');
  return BackupManifest(
    formatVersion: payload['format'] as int,
    createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    appVersion: payload['appVersion'] as String? ?? 'desconocida',
    counts: {
      for (final e in (payload['counts'] as Map<String, dynamic>? ?? {}).entries)
        if (e.value is int) e.key: e.value as int,
    },
    stores: stores.keys.toList()..sort(),
  );
}

/// Los almacenes de la copia, filtrados por la lista blanca: un fichero
/// manipulado con un nombre como `../../.bashrc` se ignora en vez de escribir
/// fuera del directorio de datos.
Map<String, String> _storesOf(Map<String, dynamic> payload) {
  final raw = payload['stores'] as Map<String, dynamic>;
  return {
    for (final e in raw.entries)
      if (kBackupStores.contains(e.key) && e.value is String)
        e.key: e.value as String,
  };
}
```

Si el manifiesto no trae `counts` (copia antigua o a mano), `readManifest` los
deja vacíos y `summary` dice "copia vacía": es información, no validación.

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: 7 tests en verde.

- [ ] **Paso 5: commit**

```bash
git add app/lib/services/backup.dart app/test/services/backup_test.dart
git commit -m "Copia de seguridad: leer y validar una copia antes de aplicarla"
```

---

### Tarea 3: Restaurar sin poder romper nada (`restoreBackup`)

**Ficheros:**
- Modificar: `app/lib/services/backup.dart`
- Test: `app/test/services/backup_test.dart`

**Interfaces:**
- Consume: `_decode`, `_storesOf`, `buildBackup`, `kBackupStores`.
- Produce: `String backupStamp(DateTime t)`,
  `class RestoreReport {List<String> written; List<String> removed; File? previous;}`,
  `Future<RestoreReport> restoreBackup(Uint8List bytes, Directory dataDir, {DateTime? now})`.

- [ ] **Paso 1: escribir el test que falla**

Añadir a `app/test/services/backup_test.dart`:

```dart
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

    final report =
        await restoreBackup(copia, destino, now: DateTime.utc(2026, 7, 21, 20, 15));

    expect(report.previous, isNotNull);
    expect(p.basename(report.previous!.path),
        'pre-restore-2026-07-21-2015.mfbak');
    final anterior = readManifest(await report.previous!.readAsBytes());
    expect(anterior.stores, ['decks.json']);
  });

  test('una copia corrupta no escribe NADA en el directorio de datos',
      () async {
    final destino = _dataDir({'collection.json': '{"cards":[{"oracleId":"a"}]}'});
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
    expect(File(p.join(destino.path, 'no-soy-un-almacen.json')).existsSync(),
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
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: FALLA — `restoreBackup` y `RestoreReport` no están definidos.

- [ ] **Paso 3: implementar**

Añadir a `app/lib/services/backup.dart`:

```dart
/// Marca de tiempo de los nombres de fichero: ordena igual alfabéticamente que
/// cronológicamente, que es de lo que se aprovecha la rotación.
String backupStamp(DateTime t) {
  final u = t.toUtc();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${u.year}-${dos(u.month)}-${dos(u.day)}-${dos(u.hour)}${dos(u.minute)}';
}

/// Qué ha hecho un restaurar, para poder contarlo.
class RestoreReport {
  final List<String> written;
  final List<String> removed;

  /// La copia del estado ANTERIOR. Deshacer un restaurar equivocado es
  /// restaurar este fichero.
  final File? previous;

  const RestoreReport(
      {required this.written, required this.removed, this.previous});
}

/// Aplica una copia. El orden importa y es este a propósito:
///  1. validar entera (si la copia es mala, aquí se acaba y no se ha tocado
///     nada);
///  2. guardar el estado de AHORA, que es el botón de deshacer;
///  3. escribir TODO a ficheros temporales;
///  4. y solo cuando están todos, renombrarlos al sitio bueno — un corte a
///     mitad deja los originales intactos, no una mezcla de los dos;
///  5. borrar lo que la copia no traía.
Future<RestoreReport> restoreBackup(Uint8List bytes, Directory dataDir,
    {DateTime? now}) async {
  final stores = _storesOf(_decode(bytes));

  final previous = await writeBackupFile(dataDir, prefix: 'pre-restore', now: now);

  final temporales = <String, File>{};
  try {
    for (final entry in stores.entries) {
      final tmp = File(p.join(dataDir.path, '${entry.key}.restore-tmp'));
      await tmp.writeAsString(entry.value, flush: true);
      temporales[entry.key] = tmp;
    }
  } catch (e) {
    // si un temporal falla, se limpian todos y no se ha movido nada
    for (final tmp in temporales.values) {
      try {
        await tmp.delete();
      } catch (_) {/* si no se puede borrar, tampoco hay más que hacer */}
    }
    throw BackupError('No he podido escribir en la carpeta de datos: $e');
  }

  final written = <String>[];
  for (final entry in temporales.entries) {
    await entry.value.rename(p.join(dataDir.path, entry.key));
    written.add(entry.key);
  }

  final removed = <String>[];
  for (final name in kBackupStores) {
    if (stores.containsKey(name)) continue;
    final file = File(p.join(dataDir.path, name));
    if (await file.exists()) {
      await file.delete();
      removed.add(name);
    }
  }

  return RestoreReport(
      written: written, removed: removed, previous: previous);
}

/// Escribe una copia del estado actual en `<datos>/backups/<prefijo>-<sello>.mfbak`.
Future<File> writeBackupFile(Directory dataDir,
    {required String prefix, DateTime? now}) async {
  final at = now ?? DateTime.now();
  final dir = Directory(p.join(dataDir.path, kBackupDirName));
  await dir.create(recursive: true);
  final file =
      File(p.join(dir.path, '$prefix-${backupStamp(at)}.mfbak'));
  await file.writeAsBytes(await buildBackup(dataDir, now: at), flush: true);
  return file;
}
```

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: 13 tests en verde.

- [ ] **Paso 5: commit**

```bash
git add app/lib/services/backup.dart app/test/services/backup_test.dart
git commit -m "Copia de seguridad: restaurar de forma atómica y con vuelta atrás"
```

---

### Tarea 4: Copia automática y rotación

**Ficheros:**
- Modificar: `app/lib/services/backup.dart`
- Test: `app/test/services/backup_test.dart`

**Interfaces:**
- Consume: `writeBackupFile`, `backupStamp`, `kBackupDirName`.
- Produce: `Future<File?> autoBackupIfStale(Directory dataDir, {Duration maxAge,
  int keep, DateTime? now})` y `Future<List<File>> listBackups(Directory dataDir)`.

- [ ] **Paso 1: escribir el test que falla**

Añadir a `app/test/services/backup_test.dart`:

```dart
  test('la primera vez siempre hace copia automática', () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});

    final file = await autoBackupIfStale(dir, now: DateTime.utc(2026, 7, 21));

    expect(file, isNotNull);
    expect(p.basename(file!.path), 'auto-2026-07-21-0000.mfbak');
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
    expect(quedan.last, 'auto-2026-02-19-0000.mfbak');
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

    expect(nombres, contains('pre-restore-2025-01-01-0000.mfbak'));
  });

  test('listBackups devuelve las copias de la más nueva a la más vieja',
      () async {
    final dir = _dataDir({'collection.json': '{"cards":[]}'});
    await autoBackupIfStale(dir, now: DateTime.utc(2026, 1, 1));
    await autoBackupIfStale(dir, now: DateTime.utc(2026, 3, 1));

    final copias = await listBackups(dir);

    expect(copias.map((f) => p.basename(f.path)),
        ['auto-2026-03-01-0000.mfbak', 'auto-2026-01-01-0000.mfbak']);
  });

  test('cada copia se enseña con su tipo y su fecha, no con el nombre crudo',
      () {
    expect(backupLabel(File('/x/auto-2026-07-21-2015.mfbak')),
        startsWith('automática · 21/07/2026'));
    expect(backupLabel(File('/x/pre-restore-2026-07-21-2015.mfbak')),
        startsWith('antes de restaurar · 21/07/2026'));
  });
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: FALLA — `autoBackupIfStale` y `listBackups` no están definidos.

- [ ] **Paso 3: implementar**

Añadir a `app/lib/services/backup.dart`:

```dart
/// Copia automática si la última tiene ya sus días: la red que no depende de
/// que nadie se acuerde de pulsar un botón. Devuelve el fichero escrito, o
/// null si no tocaba.
///
/// La antigüedad se saca del NOMBRE, no de la fecha del fichero: copiar la
/// carpeta de datos a otro sitio cambia las fechas del sistema de ficheros y
/// entonces "hace 7 días" dejaría de significar nada.
Future<File?> autoBackupIfStale(Directory dataDir,
    {Duration maxAge = const Duration(days: 7),
    int keep = 5,
    DateTime? now}) async {
  final at = (now ?? DateTime.now()).toUtc();
  final dir = Directory(p.join(dataDir.path, kBackupDirName));
  final automaticas = await _backupsWithPrefix(dir, 'auto');
  if (automaticas.isNotEmpty) {
    final ultima = _stampOf(p.basename(automaticas.first.path));
    if (ultima != null && at.difference(ultima) < maxAge) return null;
  }

  final file = await writeBackupFile(dataDir, prefix: 'auto', now: at);

  // la rotación solo mira las automáticas: las `pre-restore` son el botón de
  // deshacer de un restaurar y no se tocan aquí
  final todas = await _backupsWithPrefix(dir, 'auto');
  for (final viejo in todas.skip(keep)) {
    try {
      await viejo.delete();
    } catch (_) {/* si no se puede borrar, se queda: no es grave */}
  }
  return file;
}

/// Todas las copias del directorio, de la más nueva a la más vieja.
Future<List<File>> listBackups(Directory dataDir) =>
    _backupsWithPrefix(Directory(p.join(dataDir.path, kBackupDirName)), null);

Future<List<File>> _backupsWithPrefix(Directory dir, String? prefix) async {
  if (!await dir.exists()) return [];
  final files = <File>[];
  await for (final entry in dir.list()) {
    if (entry is! File) continue;
    final name = p.basename(entry.path);
    if (!name.endsWith('.mfbak')) continue;
    if (prefix != null && !name.startsWith('$prefix-')) continue;
    files.add(entry);
  }
  // el sello ordena igual alfabéticamente que cronológicamente
  files.sort((a, b) => p.basename(b.path).compareTo(p.basename(a.path)));
  return files;
}

/// Nombre legible de una copia para la UI: el nombre de fichero crudo no le
/// dice nada a nadie.
String backupLabel(File file) {
  final name = p.basename(file.path);
  final tipo =
      name.startsWith('pre-restore-') ? 'antes de restaurar' : 'automática';
  final stamp = _stampOf(name);
  if (stamp == null) return '$tipo · $name';
  final t = stamp.toLocal();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '$tipo · ${dos(t.day)}/${dos(t.month)}/${t.year} '
      '${dos(t.hour)}:${dos(t.minute)}';
}

/// Fecha de un nombre `<prefijo>-YYYY-MM-DD-HHmm.mfbak`, o null si no encaja.
DateTime? _stampOf(String filename) {
  final m = RegExp(r'-(\d{4})-(\d{2})-(\d{2})-(\d{2})(\d{2})\.mfbak$')
      .firstMatch(filename);
  if (m == null) return null;
  return DateTime.utc(
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!),
    int.parse(m.group(4)!),
    int.parse(m.group(5)!),
  );
}
```

Ojo con la ordenación de `_backupsWithPrefix` cuando se mezclan prefijos:
`auto-` y `pre-restore-` ordenan por nombre completo, así que `listBackups`
agrupa por prefijo antes que por fecha. Es aceptable porque la UI enseña la
fecha de cada una; la rotación, que sí depende del orden cronológico, siempre
filtra por un prefijo.

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `cd app && flutter test test/services/backup_test.dart`
Esperado: 20 tests en verde.

- [ ] **Paso 5: `flutter analyze` y commit**

```bash
cd app && flutter analyze
git add app/lib/services/backup.dart app/test/services/backup_test.dart
git commit -m "Copia de seguridad: copia automática semanal con rotación"
```

Esperado de `flutter analyze`: `No issues found!`

---

### Tarea 5: Pantalla de copia de seguridad (exportar y restaurar)

**Ficheros:**
- Crear: `app/lib/screens/backup_screen.dart`
- Test: `app/test/screens/backup_screen_test.dart`
- Modificar: `app/lib/screens/screens.dart` (export + tarjeta en `AjustesScreen`)

**Interfaces:**
- Consume: `buildBackup`, `readManifest`, `restoreBackup`, `BackupManifest`,
  `BackupError`, `RestoreReport`.
- Produce: `class BackupCard extends StatefulWidget` con
  `BackupCard({Key? key, required Future<Directory?> Function() dataDir,
  required VoidCallback onRestored})`, y
  `Future<bool> confirmRestore(BuildContext context, BackupManifest manifest)`.

**Por qué un widget y no código dentro de Ajustes:** el mismo flujo hace falta
en la pantalla de carga (tarea 6), y duplicarlo es garantizar que uno de los dos
se quede atrás.

- [ ] **Paso 1: escribir el test que falla**

Crear `app/test/screens/backup_screen_test.dart`:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/backup_screen.dart';
import 'package:manaforge_app/services/backup.dart';

void main() {
  testWidgets('la tarjeta ofrece exportar y restaurar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BackupCard(dataDir: () async => null, onRestored: () {}),
      ),
    ));

    expect(find.text('Copia de seguridad'), findsOneWidget);
    expect(find.text('Guardar copia'), findsOneWidget);
    expect(find.text('Restaurar copia'), findsOneWidget);
  });

  testWidgets('confirmar un restaurar dice QUÉ trae la copia y avisa de que '
      'reemplaza lo de ahora', (tester) async {
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
}
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `cd app && flutter test test/screens/backup_screen_test.dart`
Esperado: FALLA compilando — no existe `backup_screen.dart`.

- [ ] **Paso 3: implementar**

Crear `app/lib/screens/backup_screen.dart`:

```dart
import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../services/backup.dart';

// `Uint8List` llega por `material.dart` (reexporta `foundation`): importar
// `dart:typed_data` a mano dispararía el aviso `unnecessary_import`.

/// Tarjeta de copia de seguridad, reutilizable: va en Ajustes y en la pantalla
/// de carga (que es justo donde acabas cuando algo se ha roto).
///
/// [dataDir] se pasa como función y puede devolver null: en un test no hay
/// plugin de rutas, y la tarjeta tiene que poder pintarse igual.
/// [onRestored] avisa a la app de que los datos de disco han cambiado y hay que
/// releerlos.
class BackupCard extends StatefulWidget {
  final Future<Directory?> Function() dataDir;
  final VoidCallback onRestored;

  const BackupCard(
      {super.key, required this.dataDir, required this.onRestored});

  @override
  State<BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends State<BackupCard> {
  bool _busy = false;
  String? _status;

  /// Las copias automáticas que hay en la carpeta de datos. Se enseñan porque
  /// si no, no existen para nadie: viven en `~/.local/share/...`, que no es un
  /// sitio al que nadie vaya a navegar con un selector de ficheros justo el
  /// día que se le ha roto la colección.
  List<File> _autos = const [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadAutos());
  }

  Future<void> _loadAutos() async {
    try {
      final dir = await widget.dataDir();
      if (dir == null) return;
      final copias = await listBackups(dir);
      if (mounted) setState(() => _autos = copias.take(5).toList());
    } catch (_) {/* sin lista: los botones de arriba siguen funcionando */}
  }

  Future<void> _export() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) throw const BackupError('No encuentro tus datos.');
      final bytes = await buildBackup(dir);
      final nombre = 'manaforge-${backupStamp(DateTime.now())}.mfbak';
      final destino = await getSaveLocation(suggestedName: nombre);
      if (destino == null) {
        setState(() => _busy = false);
        return; // cancelado
      }
      await File(destino.path).writeAsBytes(bytes, flush: true);
      final manifest = readManifest(bytes);
      if (mounted) {
        setState(() => _status = '✓ Copia guardada · ${manifest.summary}');
      }
    } catch (e) {
      if (mounted) setState(() => _status = 'No he podido guardarla: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) throw const BackupError('No encuentro tus datos.');
      final origen = await openFile(acceptedTypeGroups: const [
        XTypeGroup(label: 'Copia de ManaForge', extensions: ['mfbak'])
      ]);
      if (origen == null) {
        setState(() => _busy = false);
        return; // cancelado
      }
      await _apply(await origen.readAsBytes(), dir);
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = e.message);
    } catch (e) {
      if (mounted) setState(() => _status = 'No he podido restaurarla: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Restaurar una de las copias automáticas de la lista.
  Future<void> _restoreAuto(File file) async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) throw const BackupError('No encuentro tus datos.');
      await _apply(await file.readAsBytes(), dir);
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = e.message);
    } catch (e) {
      if (mounted) setState(() => _status = 'No he podido restaurarla: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// El camino común de los dos: validar, preguntar y aplicar. Uno solo para
  /// que el aviso de "esto reemplaza lo de ahora" no pueda faltar en una vía.
  Future<void> _apply(Uint8List bytes, Directory dir) async {
    // se valida ANTES de preguntar: no tiene sentido pedir confirmación de
    // algo que no se va a poder aplicar
    final manifest = readManifest(bytes);
    if (!mounted) return;
    if (!await confirmRestore(context, manifest)) return;
    await restoreBackup(bytes, dir);
    if (!mounted) return;
    setState(() => _status =
        '✓ Restaurado · ${manifest.summary}. Lo que tenías antes está '
        'guardado en la carpeta backups.');
    widget.onRestored();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Copia de seguridad',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(
                'Tus cartas, mazos, carpetas y logros viven solo en este '
                'ordenador. Guarda una copia de vez en cuando y déjala en '
                'otro sitio: un disco, la nube, lo que quieras.',
                style: TextStyle(fontSize: 12.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : _export,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Guardar copia'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _restore,
                  icon: const Icon(Icons.settings_backup_restore),
                  label: const Text('Restaurar copia'),
                ),
              ],
            ),
            if (_status != null) ...[
              const SizedBox(height: 10),
              Text(_status!, style: const TextStyle(fontSize: 12.5)),
            ],
            if (_autos.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Copias que he guardado yo solo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              const Text(
                  'Una cada semana, me quedo con las cinco últimas.',
                  style: TextStyle(fontSize: 12)),
              for (final file in _autos)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history, size: 20),
                  title: Text(backupLabel(file),
                      style: const TextStyle(fontSize: 12.5)),
                  trailing: TextButton(
                    onPressed: _busy ? null : () => _restoreAuto(file),
                    child: const Text('Restaurar'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pregunta antes de aplicar una copia, diciendo QUÉ trae y qué va a pasar con
/// lo que hay ahora. Devuelve true solo si el usuario lo confirma.
Future<bool> confirmRestore(
    BuildContext context, BackupManifest manifest) async {
  final fecha = manifest.createdAt.toLocal();
  final cuando = '${fecha.day}/${fecha.month}/${fecha.year}';
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Restaurar esta copia?'),
      content: Text(
          'Copia del $cuando · ${manifest.summary}.\n\n'
          'Esto reemplaza tu colección, mazos, carpetas y logros de ahora '
          'por los de esa copia. Antes de hacerlo guardo lo que tienes en la '
          'carpeta backups, por si quieres volver.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Restaurar'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
```

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `cd app && flutter test test/screens/backup_screen_test.dart`
Esperado: 2 tests en verde.

- [ ] **Paso 5: engancharlo en Ajustes**

En `app/lib/screens/screens.dart`, añadir junto a los demás export:

```dart
export 'backup_screen.dart';
```

y añadir estos imports arriba del fichero:

```dart
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'backup_screen.dart';
```

En `_AjustesScreenState`, añadir el método:

```dart
  /// Dónde viven los datos. Devuelve null si no hay plugin de rutas (tests):
  /// la tarjeta se pinta igual y solo falla al pulsar.
  Future<Directory?> _dataDir() async {
    try {
      return await getApplicationSupportDirectory();
    } catch (_) {
      return null;
    }
  }
```

y, dentro de la lista `children:` del `ListView` de `build`, justo después del
`Card` de "Base de datos de cartas", insertar:

```dart
            const SizedBox(height: 16),
            BackupCard(dataDir: _dataDir, onRestored: widget.onRestored),
```

Para que `AjustesScreen` pueda avisar, añadir el campo a su constructor:

```dart
class AjustesScreen extends StatefulWidget {
  final CardDatabase db;

  /// Los datos de disco han cambiado (se ha restaurado una copia): hay que
  /// releerlo todo.
  final VoidCallback onRestored;

  const AjustesScreen({super.key, required this.db, required this.onRestored});
```

- [ ] **Paso 6: arreglar la llamada en main.dart**

En `app/lib/main.dart`, línea 135, cambiar:

```dart
      AjustesScreen(db: _db),
```

por:

```dart
      AjustesScreen(db: _db, onRestored: () {}),
```

(el reinicio de verdad llega en la tarea 7; de momento que compile).

- [ ] **Paso 7: suite entera y commit**

Ejecutar: `cd app && flutter analyze && flutter test`
Esperado: `No issues found!` y todos los tests en verde.

```bash
git add app/lib/screens/backup_screen.dart app/lib/screens/screens.dart \
        app/lib/main.dart app/test/screens/backup_screen_test.dart
git commit -m "Ajustes: guardar y restaurar copia de seguridad"
```

---

### Tarea 6: Restaurar desde la pantalla de carga

**Ficheros:**
- Modificar: `app/lib/screens/startup_screen.dart`
- Test: `app/test/screens/startup_backup_test.dart` (nuevo)

**Interfaces:**
- Consume: `BackupCard`.
- Produce: `StartupScreen` con un parámetro nuevo
  `final VoidCallback onRestored;` (obligatorio).

**Por qué aquí:** es la pantalla en la que acabas cuando algo se ha roto. Si el
único sitio para restaurar estuviera dentro de la app, una app que no arranca
bien dejaría la copia inservible.

- [ ] **Paso 1: escribir el test que falla**

Crear `app/test/screens/startup_backup_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/startup_screen.dart';
import 'package:manaforge_app/services/collection_store.dart';

void main() {
  testWidgets('la pantalla de carga deja restaurar una copia', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: StartupScreen(
        sources: const [],
        collection: CollectionStore(),
        canDownload: () async => false,
        onReady: () {},
        onRestored: () {},
      ),
    ));
    // NADA de pumpAndSettle: la pantalla tiene barras de progreso que animan
    // para siempre y la prueba no terminaría nunca
    await tester.pump();

    expect(find.text('Restaurar copia'), findsOneWidget);
  });
}
```

La firma actual de `StartupScreen` (comprobada en
`app/lib/screens/startup_screen.dart:79-87`) es `sources`, `collection` y
`onReady` obligatorios, más `settleDelay`, `canDownload` y `downloadTimeout` con
valor por defecto. El test de arriba pasa `canDownload: () async => false` para
que no intente descargar nada.

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `cd app && flutter test test/screens/startup_backup_test.dart`
Esperado: FALLA — `onRestored` no es un parámetro de `StartupScreen`.

- [ ] **Paso 3: implementar**

En `app/lib/screens/startup_screen.dart`:

1. Añadir el import: `import 'backup_screen.dart';` y
   `import 'dart:io';` + `import 'package:path_provider/path_provider.dart';`
2. Añadir a `StartupScreen` el campo obligatorio:

```dart
  /// Se ha restaurado una copia desde aquí: la app tiene que releerlo todo.
  final VoidCallback onRestored;
```

y sumarlo al constructor como `required this.onRestored`.

3. En `_StartupScreenState`, añadir:

```dart
  bool _showBackup = false;

  Future<Directory?> _dataDir() async {
    try {
      return await getApplicationSupportDirectory();
    } catch (_) {
      return null;
    }
  }
```

4. En `build`, debajo del botón "Entrar"/"Entrar ya", añadir:

```dart
                TextButton(
                  onPressed: () =>
                      setState(() => _showBackup = !_showBackup),
                  child: const Text('Restaurar copia'),
                ),
                if (_showBackup)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: BackupCard(
                      dataDir: _dataDir,
                      onRestored: widget.onRestored,
                    ),
                  ),
```

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `cd app && flutter test test/screens/startup_backup_test.dart`
Esperado: 1 test en verde.

- [ ] **Paso 5: arreglar la llamada en main.dart**

En `app/lib/main.dart`, en el `StartupScreen(...)` de `build`, añadir
`onRestored: () {},` (el reinicio de verdad es la tarea 7).

- [ ] **Paso 6: suite entera y commit**

Ejecutar: `cd app && flutter analyze && flutter test`
Esperado: `No issues found!` y todo verde.

```bash
git add app/lib/screens/startup_screen.dart app/lib/main.dart \
        app/test/screens/startup_backup_test.dart
git commit -m "Pantalla de carga: restaurar una copia sin entrar en la app"
```

---

### Tarea 7: Releer todo tras restaurar (reinicio de sesión) y copia automática al arrancar

**Ficheros:**
- Modificar: `app/lib/main.dart`
- Test: `app/test/screens/restart_session_test.dart` (nuevo)

**Interfaces:**
- Consume: `autoBackupIfStale`, `AjustesScreen.onRestored`,
  `StartupScreen.onRestored`.
- Produce: `ManaForgeApp` pasa a `StatefulWidget` con un contador de sesión que
  se usa como `Key` de `HomeShell`.

**Por qué así:** los almacenes (`CollectionStore`, `FolderStore`…) son campos
`final` de `_HomeShellState` y su `load()` solo corre una vez (`_loaded`).
Recrear el `State` entero cambiando la `Key` los construye de cero y los vuelve
a cargar del disco nuevo, sin tocar ninguno de los diez almacenes ni inventar un
`reload()` en cada uno. Es un cambio de tres líneas y no puede dejar a medias
una recarga parcial.

- [ ] **Paso 1: escribir el test que falla**

Crear `app/test/screens/restart_session_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Comprueba la idea del reinicio de sesión: cambiar la Key de un hijo
/// destruye su State y crea uno nuevo (que es lo que hace que los almacenes
/// se relean del disco tras restaurar).
void main() {
  testWidgets('cambiar la key de sesión reconstruye el estado del hijo',
      (tester) async {
    var construcciones = 0;
    late void Function() reiniciar;

    await tester.pumpWidget(MaterialApp(
      home: _Sesion(
        onBuildChild: () => construcciones++,
        onReady: (fn) => reiniciar = fn,
      ),
    ));
    expect(construcciones, 1);

    reiniciar();
    await tester.pump();

    expect(construcciones, 2);
  });
}

class _Sesion extends StatefulWidget {
  final VoidCallback onBuildChild;
  final void Function(void Function()) onReady;

  const _Sesion({required this.onBuildChild, required this.onReady});

  @override
  State<_Sesion> createState() => _SesionState();
}

class _SesionState extends State<_Sesion> {
  int _session = 0;

  @override
  Widget build(BuildContext context) {
    widget.onReady(() => setState(() => _session++));
    return _Hijo(key: ValueKey(_session), onInit: widget.onBuildChild);
  }
}

class _Hijo extends StatefulWidget {
  final VoidCallback onInit;
  const _Hijo({super.key, required this.onInit});

  @override
  State<_Hijo> createState() => _HijoState();
}

class _HijoState extends State<_Hijo> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
```

- [ ] **Paso 2: comprobar que pasa (este test es del patrón, no del código nuevo)**

Ejecutar: `cd app && flutter test test/screens/restart_session_test.dart`
Esperado: 1 test en verde. Si falla, el patrón no sirve y hay que parar y
replantear la tarea antes de tocar `main.dart`.

- [ ] **Paso 3: aplicar el patrón en main.dart**

Sustituir la clase `ManaForgeApp` de `app/lib/main.dart` por:

```dart
class ManaForgeApp extends StatefulWidget {
  const ManaForgeApp({super.key});

  @override
  State<ManaForgeApp> createState() => _ManaForgeAppState();
}

class _ManaForgeAppState extends State<ManaForgeApp> {
  /// Sube al restaurar una copia. Cambia la Key de `HomeShell`, así que Flutter
  /// tira su State y construye otro: los almacenes se crean de cero y releen
  /// el disco nuevo. Más simple y más difícil de romper que un `reload()` en
  /// cada uno de los diez.
  int _session = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManaForge',
      debugShowCheckedModeBanner: false,
      theme: mfTheme(Brightness.light),
      darkTheme: mfTheme(Brightness.dark),
      themeMode: ThemeMode.dark, // oscuro por defecto (decisión de diseño)
      home: HomeShell(
        key: ValueKey(_session),
        onRestored: () => setState(() => _session++),
      ),
    );
  }
}
```

En `HomeShell`, añadir el campo:

```dart
class HomeShell extends StatefulWidget {
  /// Se ha restaurado una copia: la app entera vuelve a empezar.
  final VoidCallback onRestored;

  const HomeShell({super.key, required this.onRestored});
```

y pasarlo a las dos pantallas:

```dart
      return StartupScreen(
        sources: defaultUpdateSources(
            db: _db, prices: _prices, scanner: _scanner),
        collection: _collection,
        onReady: () => setState(() => _started = true),
        onRestored: widget.onRestored,
      );
```

```dart
      AjustesScreen(db: _db, onRestored: widget.onRestored),
```

- [ ] **Paso 4: copia automática al arrancar**

En `_HomeShellState.initState`, después de `_progress.load()...`, añadir:

```dart
    // red de seguridad semanal, en segundo plano: si algo falla (disco lleno,
    // permisos), la app arranca igual — una copia que no sale no es motivo
    // para no dejarte entrar
    unawaited(_autoBackup());
```

y el método:

```dart
  Future<void> _autoBackup() async {
    try {
      await autoBackupIfStale(await getApplicationSupportDirectory());
    } catch (_) {/* sin copia automática esta vez; se reintenta al siguiente
      arranque */}
  }
```

Añadir los imports que falten en `main.dart`:

```dart
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'services/backup.dart';
```

- [ ] **Paso 5: suite entera y análisis**

Ejecutar: `cd app && flutter analyze && flutter test`
Esperado: `No issues found!` y todos los tests en verde (los 334 anteriores más
los nuevos).

- [ ] **Paso 6: commit**

```bash
git add app/lib/main.dart app/test/screens/restart_session_test.dart
git commit -m "Restaurar recarga la app entera y copia automática al arrancar"
```

---

### Tarea 8: Prueba a mano con datos reales

**Ficheros:** ninguno (verificación).

Esta tarea no se marca hecha con tests: se marca con la app delante y los 283
cartas reales de Ale.

- [ ] **Paso 1: arrancar la app**

```bash
tmux send-keys -t manaforge R
```

- [ ] **Paso 2: guardar una copia**

Ajustes → Copia de seguridad → *Guardar copia*. Guardar en `~/Descargas`.
Comprobar en terminal que el fichero existe y pesa algo razonable:

```bash
ls -la ~/Descargas/manaforge-*.mfbak
```

Esperado: un fichero de decenas o cientos de KB (no 0 bytes, no 90 MB).

- [ ] **Paso 3: comprobar que la copia se puede leer sin la app**

```bash
cd /home/ale/Manaforge && python3 -c "
import gzip, json, sys, glob
f = sorted(glob.glob('/home/ale/Descargas/manaforge-*.mfbak'))[-1]
d = json.loads(gzip.decompress(open(f,'rb').read()))
print(f)
print('formato', d['format'], '·', d['createdAt'])
print('recuentos', d['counts'])
print('almacenes', sorted(d['stores']))
"
```

Esperado: `recuentos` con las 283 cartas (o las que haya) y la lista de
almacenes; **ninguna base sqlite dentro**.

- [ ] **Paso 4: romper algo a propósito y restaurar**

```bash
cp ~/.local/share/com.example.manaforge/collection.json /tmp/collection.bak
echo '{"cards":[]}' > ~/.local/share/com.example.manaforge/collection.json
tmux send-keys -t manaforge R
```

En la app: la colección sale vacía. Ajustes → Copia de seguridad → *Restaurar
copia* → elegir el `.mfbak` → el diálogo dice el número de cartas y la fecha →
Restaurar.

Esperado: la app vuelve a la pantalla de carga y entra con las 283 cartas.
Comprobar además carpetas, mazos y logros.

- [ ] **Paso 5: comprobar la red de seguridad**

```bash
ls -la ~/.local/share/com.example.manaforge/backups/
```

Esperado: un `pre-restore-*.mfbak` (el estado roto, por si el restaurar hubiera
sido el error) y un `auto-*.mfbak` del arranque.

- [ ] **Paso 6: restaurar desde la pantalla de carga**

Cerrar la app, arrancarla, y en la pantalla de carga pulsar *Restaurar copia*
antes de entrar. Comprobar que funciona igual.

- [ ] **Paso 7: commit del registro**

Anotar en `docs/plans/2026-07-21-tanda-backup-escaneo-ocr.md` que el bloque A
queda validado a mano, con la fecha.

---

## Al terminar

- `flutter analyze` limpio y `flutter test` en verde.
- Abrir PR contra `main` con título **"Copia de seguridad y restaurar"**.
- Esperar CI verde antes de mergear.
- Siguiente: bloque B (escaneo: no duplicar + velocidad).
