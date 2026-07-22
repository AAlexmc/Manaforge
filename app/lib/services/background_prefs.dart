/// El fondo de pantalla de la app: una imagen TUYA.
///
/// Por qué "tuya" y no un catálogo dentro de la app: los fondos oficiales de
/// Magic son arte con derechos de Wizards of the Coast. Que la app los
/// descargue en bloque y los reparta dentro de sus releases sería
/// redistribuirlos, y eso no lo cubre la Fan Content Policy. Lo que sí es
/// normal y legal: tú te bajas de la web oficial el que te guste y lo eliges
/// aquí. La app guarda una copia en su carpeta de datos —para que el fondo no
/// desaparezca si mueves el fichero— y nada de eso sale de tu máquina.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'json_store_io.dart';
import 'safe_input.dart';

/// Página oficial de fondos de pantalla de Magic.
const String kOfficialWallpapersUrl =
    'https://magic.wizards.com/es/news?category=wallpapers';

/// Formatos que se aceptan como fondo.
const Set<String> kBackgroundExtensions = {'.jpg', '.jpeg', '.png', '.webp'};

/// Tope de una imagen de fondo. Un 4K en JPG no llega a 5 MB; el tope está
/// para que elegir por error un TIFF gigante (o un vídeo renombrado) no
/// deje la app comiéndose la memoria al pintar cada pantalla.
const int kMaxBackgroundBytes = 25 * 1024 * 1024;

/// Cuánto se oscurece la imagen para que se siga leyendo el texto encima.
/// 0 = imagen tal cual (ilegible), 1 = negro total (como no tener fondo).
const double kMinDim = 0.2;
const double kMaxDim = 0.92;
const double kDefaultDim = 0.72;

/// Fondo elegido, persistido en `background.json`.
class BackgroundPreference extends ChangeNotifier {
  /// Solo para tests: dónde viven el JSON y la copia de la imagen.
  final Directory? dataDir;

  BackgroundPreference({this.dataDir});

  File? _image;
  double _dim = kDefaultDim;
  Future<void>? _loading;

  /// La imagen de fondo, si hay una y sigue existiendo.
  File? get image => _image;

  bool get hasImage => _image != null;

  /// Cuánto se oscurece (0..1).
  double get dim => _dim;

  /// Mientras se lee el disco se comparte la ESPERA, no un booleano puesto de
  /// antemano (que hacía que un segundo `load()` simultáneo volviese sin
  /// fondo). Ya leído, se devuelve un futuro nuevo — ver la explicación larga
  /// en `language_prefs.dart`.
  Future<void> load() => _cargado ? Future.value() : (_loading ??= _load());

  bool _cargado = false;

  Future<void> _load() async {
    try {
      await _leer();
    } finally {
      _cargado = true;
    }
  }

  Future<void> _leer() async {
    final file = await _prefsFile();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return;
      final ruta = decoded['image'];
      if (ruta is String && ruta.isNotEmpty) {
        final imagen = File(ruta);
        // la ruta guardada solo vale si apunta DENTRO de la carpeta de datos:
        // este JSON es un fichero de disco y podría venir manipulado, y una
        // ruta cualquiera haría que la app pintase de fondo un fichero
        // arbitrario del sistema
        final dir = await _dir();
        final dentro = dir != null &&
            p.equals(p.dirname(imagen.path), dir.path) &&
            kBackgroundExtensions.contains(p.extension(imagen.path).toLowerCase());
        // y si el fichero ya no está (limpieza de disco), tampoco se arrastra
        // una ruta muerta
        if (dentro && await imagen.exists()) _image = imagen;
      }
      final dim = decoded['dim'];
      if (dim is num) _dim = dim.toDouble().clamp(kMinDim, kMaxDim);
      notifyListeners();
    } catch (_) {
      // fichero raro: sin fondo, que es como estaba antes de esto
    }
  }

  /// Elige [source] como fondo. Se copia a la carpeta de datos: si mueves o
  /// borras el original, el fondo sigue estando.
  ///
  /// Lanza [InputRejected] si el fichero no tiene pinta de imagen o es
  /// desproporcionado — es un fichero que elige el usuario, y lo que entra de
  /// fuera se acota.
  Future<void> select(File source) async {
    final ext = p.extension(source.path).toLowerCase();
    if (!kBackgroundExtensions.contains(ext)) {
      throw const InputRejected(
          'Elige una imagen (.jpg, .png o .webp) como fondo.');
    }
    final bytes = await source.length();
    if (bytes > kMaxBackgroundBytes) {
      throw const InputRejected(
          'Esa imagen es demasiado grande para usarla de fondo.');
    }
    final dir = await _dir();
    if (dir == null) return; // sin carpeta de datos (tests): no hay dónde
    final destino = File(p.join(dir.path, 'background$ext'));
    // copia a un temporal y rename: si la app muere copiando, no se queda un
    // fondo a medias que luego no se puede pintar
    final tmp = File('${destino.path}.tmp');
    await source.copy(tmp.path);
    await tmp.rename(destino.path);
    // el fondo anterior, si era de otro formato, sobra
    for (final otra in kBackgroundExtensions) {
      if (otra == ext) continue;
      final vieja = File(p.join(dir.path, 'background$otra'));
      if (await vieja.exists()) {
        try {
          await vieja.delete();
        } catch (_) {/* si no se puede borrar, tampoco pasa nada */}
      }
    }
    _image = destino;
    notifyListeners();
    await _save();
  }

  /// Quita el fondo y borra la copia.
  Future<void> clear() async {
    final anterior = _image;
    _image = null;
    notifyListeners();
    await _save();
    if (anterior != null && await anterior.exists()) {
      try {
        await anterior.delete();
      } catch (_) {/* la preferencia ya está quitada, que es lo que importa */}
    }
  }

  Future<void> setDim(double value) async {
    final nuevo = value.clamp(kMinDim, kMaxDim);
    if (nuevo == _dim) return;
    _dim = nuevo;
    notifyListeners();
    await _save();
  }

  Future<Directory?> _dir() async {
    try {
      return dataDir ?? await getApplicationSupportDirectory();
    } catch (_) {
      return null; // sin plugin (tests)
    }
  }

  Future<File?> _prefsFile() async {
    final dir = await _dir();
    return dir == null ? null : File(p.join(dir.path, 'background.json'));
  }

  /// En fila india: arrastrar el mando del velo dispara un `setDim()` por
  /// frame, y sin fila son decenas de escrituras a la vez sobre el mismo
  /// `.tmp`. La fila nace en la primera escritura y no en un campo — ver la
  /// explicación larga en `language_prefs.dart`.
  Future<void>? _fila;

  Future<void> _save() {
    final anterior = _fila;
    final actual =
        anterior == null ? _write() : anterior.then((_) => _write());
    _fila = actual;
    return actual;
  }

  Future<void> _write() async {
    final file = await _prefsFile();
    if (file == null) return;
    try {
      await writeJsonFile(
          file,
          jsonEncode({
            if (_image != null) 'image': _image!.path,
            'dim': _dim,
          }));
    } catch (_) {
      // no poder guardar la preferencia no puede tumbar la app
    }
  }
}
