/// Reset de fábrica: deja la carpeta de datos como recién instalada.
///
/// Dos mitades a propósito: entre la copia previa y el barrido, quien orquesta
/// (HomeShell) cierra los sqlite abiertos y limpia el fondo. Si la copia
/// falla, se aborta ANTES de tocar nada.
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
  const FactoryResetReport(
      {required this.backupFile, required this.deleted, required this.failed});
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
  return writeBackupFile(dataDir, prefix: 'pre-reset', now: now);
}

/// Borra TODO el contenido de la carpeta de datos salvo `backups/`.
/// Los fallos sueltos no paran el resto: se acumulan en el informe.
Future<FactoryResetReport> wipeDataDir(Directory dataDir,
    {File? backup}) async {
  final deleted = <String>[];
  final failed = <String>[];
  await for (final entry in dataDir.list()) {
    final name = p.basename(entry.path);
    if (name == kBackupDirName) continue;
    try {
      await entry.delete(recursive: true);
      deleted.add(name);
    } catch (_) {
      failed.add(name);
    }
  }
  deleted.sort();
  failed.sort();
  return FactoryResetReport(
      backupFile: backup, deleted: deleted, failed: failed);
}
