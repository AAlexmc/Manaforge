/// Reset de fábrica: deja la carpeta de datos como recién instalada.
///
/// [factoryReset] compone las dos mitades a propósito: `preResetBackup`
/// primero (si falla, se aborta ANTES de tocar nada) y, envuelto en un try que
/// convierte cualquier fallo en [FactoryResetHalfDone], cerrar los sqlite
/// abiertos, limpiar el fondo y barrer.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'backup.dart';

/// Qué pasó en un reset: la copia guardada y qué se borró (o no se pudo).
class FactoryResetReport {
  /// La copia pre-reset, o null si no había nada que copiar.
  final File? backupFile;
  final List<String> deleted;
  final List<String> failed;

  /// Ficheros `.roto` (datos rescatables, no basura) que se han movido a
  /// `backups/` en vez de borrarse. No cuentan como `deleted`.
  final List<String> rescued;

  const FactoryResetReport(
      {required this.backupFile,
      required this.deleted,
      required this.failed,
      this.rescued = const []});
}

/// La fase POSTERIOR a la copia se quedó a medias: algo entre cerrar las
/// bases, limpiar el fondo o barrer ha lanzado. La copia previa (si la hubo)
/// ya está a salvo en `backups/`; lo demás puede estar en cualquier estado.
class FactoryResetHalfDone implements Exception {
  final Object cause;
  FactoryResetHalfDone(this.cause);

  @override
  String toString() => 'FactoryResetHalfDone: $cause';
}

/// Guarda la copia `pre-reset` en `backups/` antes de borrar nada.
/// Devuelve null si no hay datos que copiar; cualquier otro fallo LANZA,
/// y en ese caso el reset no debe seguir.
///
/// `writeBackupFile` no comprueba si hay algo que copiar (construye la copia
/// igual, con almacenes vacíos): por eso la comprobación de "nada que copiar"
/// se hace aquí mirando `presentStores`, antes de escribir.
Future<File?> preResetBackup(Directory dataDir, {DateTime? now}) async {
  if ((await presentStores(dataDir)).isEmpty) return null;
  final file = await writeBackupFile(dataDir, prefix: 'pre-reset', now: now);
  await rotateBackupsWithPrefix(dataDir, 'pre-reset', keep: kKeepPreRestore);
  return file;
}

/// Todo el reset, de un tirón: copia previa → cerrar bases → limpiar fondo →
/// barrer, con reintento si el primer barrido deja algo `failed`.
///
/// Si [preResetBackup] lanza, se propaga TAL CUAL y nada más se ejecuta (no
/// se ha tocado nada). Cualquier fallo a partir de ahí (cerrar bases, limpiar
/// fondo, barrer) se envuelve en [FactoryResetHalfDone]: la copia ya está a
/// salvo, pero el resto puede haberse quedado a medias.
Future<FactoryResetReport> factoryReset(
  Directory dataDir, {
  required void Function() closeDbs,
  required Future<void> Function() clearBackground,
  DateTime? now,
}) async {
  final copia = await preResetBackup(dataDir, now: now);

  try {
    closeDbs();
    await clearBackground();
    var report = await wipeDataDir(dataDir, backup: copia);
    if (report.failed.isNotEmpty) {
      // una segunda pasada: lo que fallara por estar en uso puede haberse
      // soltado ya (un sqlite recién cerrado, un fichero que se libera solo)
      closeDbs();
      final segunda = await wipeDataDir(dataDir, backup: copia);
      report = FactoryResetReport(
        backupFile: copia,
        deleted: [...report.deleted, ...segunda.deleted]..sort(),
        failed: segunda.failed,
        rescued: [...report.rescued, ...segunda.rescued]..sort(),
      );
    }
    return report;
  } catch (e) {
    throw FactoryResetHalfDone(e);
  }
}

/// Borra TODO el contenido de la carpeta de datos salvo `backups/`.
/// Los fallos sueltos no paran el resto: se acumulan en el informe.
///
/// Los `.roto` (almacenes ilegibles apartados por `setAsideBroken`) son datos
/// rescatables, no basura: se MUEVEN a `backups/` en vez de borrarse.
Future<FactoryResetReport> wipeDataDir(Directory dataDir,
    {File? backup}) async {
  final deleted = <String>[];
  final failed = <String>[];
  final rescued = <String>[];
  // materializado ANTES de borrar: mutar la carpeta mientras `list()` la
  // recorre es comportamiento no especificado (POSIX y Windows por igual)
  final entries = await dataDir.list().toList();
  for (final entry in entries) {
    final name = p.basename(entry.path);
    if (name == kBackupDirName) continue;
    if (entry is File && name.endsWith('.roto')) {
      try {
        rescued.add(await _rescue(entry, dataDir, name));
      } catch (_) {
        failed.add(name);
      }
      continue;
    }
    try {
      await entry.delete(recursive: true);
      deleted.add(name);
    } catch (_) {
      failed.add(name);
    }
  }
  deleted.sort();
  failed.sort();
  rescued.sort();
  return FactoryResetReport(
      backupFile: backup, deleted: deleted, failed: failed, rescued: rescued);
}

/// Mueve un `.roto` a `backups/`, sin pisar uno que ya estuviera ahí (mismo
/// patrón `-2`, `-3`… que `writeBackupFile`).
Future<String> _rescue(File entry, Directory dataDir, String name) async {
  final backupsDir = Directory(p.join(dataDir.path, kBackupDirName));
  await backupsDir.create(recursive: true);
  var dest = File(p.join(backupsDir.path, name));
  if (await dest.exists()) {
    final ext = p.extension(name);
    final base = p.basenameWithoutExtension(name);
    var n = 2;
    while (await dest.exists()) {
      dest = File(p.join(backupsDir.path, '$base-$n$ext'));
      n++;
    }
  }
  await entry.rename(dest.path);
  return p.basename(dest.path);
}
