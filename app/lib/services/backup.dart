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

/// Los almacenes del usuario, y solo esos. La lista es también la lista blanca
/// al restaurar: cualquier otro nombre dentro de una copia se ignora (un
/// fichero manipulado no va a escribir donde le apetezca).
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
  return Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode(payload))));
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
    void agregar(String clave, String uno, String varios) {
      final n = counts[clave] ?? 0;
      if (n > 0) partes.add('$n ${n == 1 ? uno : varios}');
    }

    agregar('cartas', 'carta', 'cartas');
    agregar('mazos', 'mazo', 'mazos');
    agregar('carpetas', 'carpeta', 'carpetas');
    agregar('logros', 'logro', 'logros');
    return partes.isEmpty ? 'copia vacía' : partes.join(' · ');
  }
}

/// Descomprime y valida la copia. Todo lo que pueda salir mal sale aquí, antes
/// de que nadie escriba nada en disco.
BackupManifest readManifest(Uint8List bytes) => _manifestOf(_decode(bytes));

Map<String, dynamic> _decode(Uint8List bytes) {
  const noEsCopia =
      BackupError('Ese fichero no es una copia de seguridad de ManaForge.');
  final Object? decoded;
  try {
    decoded = jsonDecode(utf8.decode(gzip.decode(bytes)));
  } catch (_) {
    throw noEsCopia;
  }
  if (decoded is! Map<String, dynamic>) throw noEsCopia;
  final format = decoded['format'];
  if (format is! int) throw noEsCopia;
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

  final previous =
      await writeBackupFile(dataDir, prefix: 'pre-restore', now: now);

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

  return RestoreReport(written: written, removed: removed, previous: previous);
}

/// Escribe una copia del estado actual en
/// `<datos>/backups/<prefijo>-<sello>.mfbak`.
Future<File> writeBackupFile(Directory dataDir,
    {required String prefix, DateTime? now}) async {
  final at = now ?? DateTime.now();
  final dir = Directory(p.join(dataDir.path, kBackupDirName));
  await dir.create(recursive: true);
  final file = File(p.join(dir.path, '$prefix-${backupStamp(at)}.mfbak'));
  await file.writeAsBytes(await buildBackup(dataDir, now: at), flush: true);
  return file;
}

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
