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
///
/// `price_history.json` es el formato viejo del historial: sigue existiendo en
/// instalaciones que aún no han arrancado desde la migración a `.jsonl`, y sus
/// apuntes no se pueden recuperar de ninguna otra parte, así que también entra.
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
  'price_history.json',
];

/// Carpeta, dentro del directorio de datos, con las copias automáticas y las
/// de seguridad previas a un restaurar.
const String kBackupDirName = 'backups';

/// Sufijo de los ficheros a medio escribir de un restaurar. Se barren al
/// empezar uno nuevo: un apagón a mitad no debe dejar basura para siempre.
const String kRestoreTmpSuffix = '.restore-tmp';

/// Tope de copias `pre-restore` guardadas. No se rotan con las automáticas
/// (son el botón de deshacer y valen más), pero tampoco pueden crecer sin fin:
/// cada una lleva el historial de precios entero dentro.
const int kKeepPreRestore = 20;

/// Fallo con mensaje ya escrito para enseñárselo al usuario tal cual.
class BackupError implements Exception {
  final String message;

  const BackupError(this.message);

  @override
  String toString() => message;
}

/// Construye la copia en memoria. Los almacenes que no existan simplemente no
/// van (una colección sin mazos es perfectamente válida).
///
/// Los almacenes se leen como BYTES y se decodifican tolerando basura: un
/// fichero cortado a mitad de un carácter (los almacenes que aún guardan sin
/// tmp+rename lo permiten) no puede impedir hacer copia — perder un carácter
/// es mejor que perder la colección entera.
Future<Uint8List> buildBackup(Directory dataDir, {DateTime? now}) async {
  final stores = <String, String>{};
  for (final name in kBackupStores) {
    final file = File(p.join(dataDir.path, name));
    if (!await file.exists()) continue;
    stores[name] = utf8.decode(await file.readAsBytes(), allowMalformed: true);
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

/// Descomprime y valida la copia. Todo lo que pueda salir mal sale aquí, en
/// forma de [BackupError], antes de que nadie escriba nada en disco.
///
/// Los recuentos que devuelve se RECALCULAN desde los datos de la copia, no se
/// creen los que el fichero traiga escritos: este resumen es lo único que mira
/// el usuario antes de aceptar un borrado sin vuelta atrás, así que tiene que
/// describir lo que realmente hay dentro.
BackupManifest readManifest(Uint8List bytes) => _manifestOf(_decode(bytes));

/// Limitación conocida y asumida: un `.mfbak` manipulado a mala idea podría
/// descomprimirse a muchos gigas y tumbar la app (bomba de descompresión). No
/// se acota porque el fichero lo elige el propio usuario en su ordenador: es
/// el mismo nivel de confianza que abrir cualquier otro fichero suyo.
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
  final creado = payload['createdAt'];
  return BackupManifest(
    formatVersion: payload['format'] as int,
    createdAt: (creado is String ? DateTime.tryParse(creado) : null) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    appVersion: payload['appVersion'] is String
        ? payload['appVersion'] as String
        : 'desconocida',
    // recalculados a propósito: ver el docstring de readManifest
    counts: backupCounts(stores),
    stores: stores.keys.toList()..sort(),
  );
}

/// Los almacenes de la copia, filtrados por la lista blanca: un fichero
/// manipulado con un nombre como `../../.bashrc` se ignora en vez de escribir
/// fuera del directorio de datos.
///
/// Un nombre CONOCIDO cuyo contenido no sea texto es otra cosa muy distinta y
/// no se ignora: si se colara, restaurar lo trataría como "esta copia no
/// llevaba ese almacén" y BORRARÍA el fichero vivo diciendo que todo ha ido
/// bien. Ahí se para en seco.
Map<String, String> _storesOf(Map<String, dynamic> payload) {
  final raw = payload['stores'] as Map<String, dynamic>;
  final stores = <String, String>{};
  for (final e in raw.entries) {
    if (!kBackupStores.contains(e.key)) continue; // nombre desconocido: fuera
    if (e.value is! String) {
      throw BackupError('Esa copia está dañada: ${e.key} no se puede leer.');
    }
    stores[e.key] = e.value as String;
  }
  return stores;
}

/// Marca de tiempo de los nombres de fichero: ordena igual alfabéticamente que
/// cronológicamente, que es de lo que se aprovecha la rotación. Con segundos,
/// porque dos restaurar seguidos caen en el mismo minuto con facilidad y no
/// pueden compartir nombre.
String backupStamp(DateTime t) {
  final u = t.toUtc();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${u.year}-${dos(u.month)}-${dos(u.day)}-'
      '${dos(u.hour)}${dos(u.minute)}${dos(u.second)}';
}

/// Qué ha hecho un restaurar, para poder contarlo.
class RestoreReport {
  final List<String> written;
  final List<String> removed;

  /// La copia del estado ANTERIOR. Deshacer un restaurar equivocado es
  /// restaurar este fichero. Null si no se pudo hacer (ver [previousError]).
  final File? previous;

  /// Por qué no hay red de seguridad, si no la hay. El restaurar se hace
  /// igual: bloquearlo dejaría tirado justo al usuario que más lo necesita,
  /// el que tiene un almacén roto.
  final String? previousError;

  const RestoreReport(
      {required this.written,
      required this.removed,
      this.previous,
      this.previousError});
}

/// Aplica una copia. El orden importa y es este a propósito:
///  1. validar entera (si la copia es mala, aquí se acaba y no se ha tocado
///     nada);
///  2. guardar el estado de AHORA, que es el botón de deshacer;
///  3. escribir TODO a ficheros temporales;
///  4. renombrarlos al sitio bueno;
///  5. borrar lo que la copia no traía.
///
/// Un corte en la fase 3 no deja nada tocado. En la 4 y la 5 SÍ puede quedar a
/// medias: renombrar diez ficheros no es una operación atómica y el sistema no
/// ofrece ninguna que lo sea. Si pasa, se lanza [BackupError] diciendo qué se
/// llegó a escribir y dónde está la copia para volver atrás — que es todo lo
/// que se puede prometer honestamente.
///
/// PRECONDICIÓN: la app no puede estar operando sobre los almacenes mientras
/// esto corre. Los stores viven en memoria y guardan solos (añadir a un mazo,
/// abrir una carta); cualquiera de esos guardados escribiría lo viejo encima
/// de lo recién restaurado. Quien llame tiene que congelar la UI durante la
/// operación y recargar los stores después.
Future<RestoreReport> restoreBackup(Uint8List bytes, Directory dataDir,
    {DateTime? now}) async {
  final stores = _storesOf(_decode(bytes));

  await _sweepRestoreTmp(dataDir);

  File? previous;
  String? previousError;
  try {
    previous = await writeBackupFile(dataDir, prefix: 'pre-restore', now: now);
    await _rotate(await _backupsWithPrefix(_backupDir(dataDir), 'pre-restore'),
        keep: kKeepPreRestore);
  } catch (e) {
    // sin red, pero se sigue: el usuario que restaura porque tiene un almacén
    // ilegible es justo el que no puede permitirse que esto le bloquee
    previousError = '$e';
  }

  final temporales = <String, File>{};
  try {
    for (final entry in stores.entries) {
      final tmp =
          File(p.join(dataDir.path, '${entry.key}$kRestoreTmpSuffix'));
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
    throw BackupError('No he podido escribir en la carpeta de datos, así que '
        'no he tocado nada: $e');
  }

  final written = <String>[];
  final removed = <String>[];
  try {
    for (final entry in temporales.entries) {
      await entry.value.rename(p.join(dataDir.path, entry.key));
      written.add(entry.key);
    }
    for (final name in kBackupStores) {
      if (stores.containsKey(name)) continue;
      final file = File(p.join(dataDir.path, name));
      if (await file.exists()) {
        await file.delete();
        removed.add(name);
      }
    }
  } catch (e) {
    await _sweepRestoreTmp(dataDir);
    final vuelta = previous == null
        ? 'No tengo copia previa de lo que había.'
        : 'Para volver atrás, restaura ${previous.path}.';
    throw BackupError(
        'El restaurar se ha quedado a medias (${written.length} de '
        '${stores.length} ficheros). $vuelta Detalle: $e');
  }

  return RestoreReport(
      written: written,
      removed: removed,
      previous: previous,
      previousError: previousError);
}

/// Barre los `.restore-tmp` que hayan quedado de un restaurar interrumpido: no
/// están en la lista blanca, así que si no los borra nadie se quedan ahí para
/// siempre.
Future<void> _sweepRestoreTmp(Directory dataDir) async {
  if (!await dataDir.exists()) return;
  try {
    await for (final entry in dataDir.list()) {
      if (entry is! File) continue;
      if (!p.basename(entry.path).endsWith(kRestoreTmpSuffix)) continue;
      try {
        await entry.delete();
      } catch (_) {/* uno que no se deja: no es motivo para abortar */}
    }
  } catch (_) {/* directorio ilegible: ya fallará más adelante con detalle */}
}

Directory _backupDir(Directory dataDir) =>
    Directory(p.join(dataDir.path, kBackupDirName));

/// Escribe una copia del estado actual en
/// `<datos>/backups/<prefijo>-<sello>.mfbak`.
///
/// Nunca sobrescribe: si ya hay una con ese sello (dos restaurar en el mismo
/// segundo), se añade `-2`, `-3`… Perder el botón de deshacer por un choque de
/// nombres es exactamente el fallo que esto evita. Y se escribe por temporal,
/// como el resto de almacenes del repo, para que un corte no deje un `.mfbak`
/// truncado con pinta de copia buena.
Future<File> writeBackupFile(Directory dataDir,
    {required String prefix, DateTime? now}) async {
  final at = now ?? DateTime.now();
  final dir = _backupDir(dataDir);
  await dir.create(recursive: true);
  final base = '$prefix-${backupStamp(at)}';
  var file = File(p.join(dir.path, '$base.mfbak'));
  for (var n = 2; await file.exists(); n++) {
    file = File(p.join(dir.path, '$base-$n.mfbak'));
  }
  final tmp = File('${file.path}.tmp');
  await tmp.writeAsBytes(await buildBackup(dataDir, now: at), flush: true);
  await tmp.rename(file.path);
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
  final dir = _backupDir(dataDir);
  final automaticas = await _backupsWithPrefix(dir, 'auto');
  if (automaticas.isNotEmpty) {
    final ultima = _stampOf(p.basename(automaticas.first.path));
    final edad = ultima == null ? null : at.difference(ultima);
    // una copia con fecha FUTURA (reloj mal, pila de la placa, portátil que
    // viene de otra zona) cuenta como caducada: si no, `edad` es negativa,
    // negativa siempre es menor que maxAge, y no se vuelve a copiar nunca
    if (edad != null && !edad.isNegative && edad < maxAge) return null;
  }

  final file = await writeBackupFile(dataDir, prefix: 'auto', now: at);

  // la rotación solo mira las automáticas: las `pre-restore` son el botón de
  // deshacer de un restaurar y tienen su propio tope, mucho más alto
  await _rotate(await _backupsWithPrefix(dir, 'auto'), keep: keep);
  return file;
}

/// Borra las copias más viejas de [files] (que viene de nueva a vieja) hasta
/// dejar [keep]. Nunca menos de una: un `keep` a 0 borraría la que se acaba de
/// escribir.
Future<void> _rotate(List<File> files, {required int keep}) async {
  final tope = keep < 1 ? 1 : keep;
  for (final viejo in files.skip(tope)) {
    try {
      await viejo.delete();
    } catch (_) {/* si no se puede borrar, se queda: no es grave */}
  }
}

/// Todas las copias del directorio, de la más nueva a la más vieja.
Future<List<File>> listBackups(Directory dataDir) =>
    _backupsWithPrefix(_backupDir(dataDir), null);

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

/// Fecha de un nombre `<prefijo>-YYYY-MM-DD-HHmmss[-N].mfbak`, o null si no
/// encaja.
DateTime? _stampOf(String filename) {
  final m =
      RegExp(r'-(\d{4})-(\d{2})-(\d{2})-(\d{2})(\d{2})(\d{2})(?:-\d+)?\.mfbak$')
          .firstMatch(filename);
  if (m == null) return null;
  return DateTime.utc(
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!),
    int.parse(m.group(4)!),
    int.parse(m.group(5)!),
    int.parse(m.group(6)!),
  );
}
