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
import 'dart:ui' show Color;

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

/// Un color de la paleta, con un nombre corto que es lo que se guarda en el
/// JSON. Se guarda el NOMBRE y no el número: así un fichero manipulado no
/// puede meter un color cualquiera (ni dejar la letra del mismo color que la
/// tarjeta), y la paleta se puede retocar sin romper lo guardado.
class NamedColor {
  final String id;
  final Color color;

  const NamedColor(this.id, this.color);
}

/// Colores de las tarjetas cuando hay fondo puesto. El primero es "el de
/// siempre" y no se guarda.
const List<NamedColor> kCardColors = [
  NamedColor('piedra', Color(0xFF2A2723)),
  NamedColor('negro', Color(0xFF0E0D0B)),
  NamedColor('hueso', Color(0xFFF2EFE9)),
  NamedColor('noche', Color(0xFF14243A)),
  NamedColor('bosque', Color(0xFF122A1E)),
  NamedColor('vino', Color(0xFF2E1216)),
  NamedColor('forja', Color(0xFF241833)),
];

/// Colores de la letra cuando hay fondo puesto.
const List<NamedColor> kTextColors = [
  NamedColor('hueso', Color(0xFFF2EFE9)),
  NamedColor('blanco', Color(0xFFFFFFFF)),
  NamedColor('tinta', Color(0xFF1C1A16)),
  NamedColor('dorado', Color(0xFFE0CC8A)),
];

/// Cuánto tapan las tarjetas al fondo. Con 1 el fondo solo se ve por los
/// huecos; por debajo de 0,35 no se lee lo que hay dentro.
const double kMinCardOpacity = 0.35;
const double kMaxCardOpacity = 1;
const double kDefaultCardOpacity = 0.88;

Color? _colorDe(List<NamedColor> paleta, String? id) {
  if (id == null) return null;
  for (final c in paleta) {
    if (c.id == id) return c.color;
  }
  return null; // un nombre que no está en la paleta es "el de siempre"
}

/// Un color a `#RRGGBB` (sin alfa: la transparencia de las tarjetas va aparte).
String _hex(Color c) {
  final rgb = c.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

/// `#RRGGBB` (o `#AARRGGBB`) a Color, o null si no es un hex válido. Es un
/// valor que puede venir de un fichero manipulado, así que se valida.
Color? _parseHex(String s) {
  var h = s.trim();
  if (h.startsWith('#')) h = h.substring(1);
  if (h.length == 6) h = 'FF$h';
  // solo dígitos hex: `int.tryParse` colaría un signo ('-FFFFFFF') y pintaría
  // un color enmascarado en vez de rechazar el fichero manipulado
  if (!RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(h)) return null;
  final v = int.tryParse(h, radix: 16);
  if (v == null) return null;
  return Color(v);
}

/// Fondo elegido, persistido en `background.json`.
class BackgroundPreference extends ChangeNotifier {
  /// Solo para tests: dónde viven el JSON y la copia de la imagen.
  final Directory? dataDir;

  BackgroundPreference({this.dataDir});

  File? _image;
  double _dim = kDefaultDim;
  String? _cardColorId;
  String? _textColorId;
  // color a medida (elegido con el selector). Manda sobre el preset: si hay
  // uno puesto, el `_...ColorId` se deja en null y viceversa.
  Color? _cardCustom;
  Color? _textCustom;
  double _cardOpacity = kDefaultCardOpacity;
  Future<void>? _loading;

  /// La imagen de fondo, si hay una y sigue existiendo.
  File? get image => _image;

  bool get hasImage => _image != null;

  /// Cuánto se oscurece (0..1).
  double get dim => _dim;

  /// Nombre del preset elegido, o null = el de siempre o uno a medida.
  String? get cardColorId => _cardColorId;

  String? get textColorId => _textColorId;

  /// Color de las tarjetas, null = el del tema. El color a medida manda sobre
  /// el preset.
  Color? get cardColor => _cardCustom ?? _colorDe(kCardColors, _cardColorId);

  /// Color de la letra, null = el del tema.
  Color? get textColor => _textCustom ?? _colorDe(kTextColors, _textColorId);

  /// El color a medida (el del selector), null = no hay o se usa un preset.
  Color? get cardCustomColor => _cardCustom;

  Color? get textCustomColor => _textCustom;

  bool get cardIsCustom => _cardCustom != null;

  bool get textIsCustom => _textCustom != null;

  /// Cuánto tapan las tarjetas al fondo (0..1).
  double get cardOpacity => _cardOpacity;

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
      // los colores se guardan por NOMBRE y solo valen si están en la paleta
      final card = decoded['cardColor'];
      if (card is String && kCardColors.any((c) => c.id == card)) {
        _cardColorId = card;
      }
      final text = decoded['textColor'];
      if (text is String && kTextColors.any((c) => c.id == text)) {
        _textColorId = text;
      }
      // color a medida (hex). Si es válido, manda sobre el preset.
      final cardHex = decoded['cardColorHex'];
      if (cardHex is String) {
        final c = _parseHex(cardHex);
        if (c != null) {
          _cardCustom = c;
          _cardColorId = null;
        }
      }
      final textHex = decoded['textColorHex'];
      if (textHex is String) {
        final c = _parseHex(textHex);
        if (c != null) {
          _textCustom = c;
          _textColorId = null;
        }
      }
      final opacidad = decoded['cardOpacity'];
      if (opacidad is num) {
        _cardOpacity =
            opacidad.toDouble().clamp(kMinCardOpacity, kMaxCardOpacity);
      }
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

  /// [id] null = el color de siempre. Un nombre que no esté en la paleta se
  /// ignora (no se guarda un color que luego no se sabría pintar).
  Future<void> setCardColor(String? id) async {
    if (id != null && !kCardColors.any((c) => c.id == id)) return;
    if (id == _cardColorId && _cardCustom == null) return;
    _cardColorId = id;
    _cardCustom = null; // elegir un preset descarta el color a medida
    notifyListeners();
    await _save();
  }

  Future<void> setTextColor(String? id) async {
    if (id != null && !kTextColors.any((c) => c.id == id)) return;
    if (id == _textColorId && _textCustom == null) return;
    _textColorId = id;
    _textCustom = null;
    notifyListeners();
    await _save();
  }

  /// Un color a medida (del selector) para las tarjetas. Descarta el preset.
  Future<void> setCardColorCustom(Color color) async {
    if (_cardCustom == color && _cardColorId == null) return;
    _cardColorId = null;
    _cardCustom = color;
    notifyListeners();
    await _save();
  }

  Future<void> setTextColorCustom(Color color) async {
    if (_textCustom == color && _textColorId == null) return;
    _textColorId = null;
    _textCustom = color;
    notifyListeners();
    await _save();
  }

  Future<void> setCardOpacity(double value) async {
    final nuevo = value.clamp(kMinCardOpacity, kMaxCardOpacity);
    if (nuevo == _cardOpacity) return;
    _cardOpacity = nuevo;
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
            if (_cardColorId != null) 'cardColor': _cardColorId,
            if (_textColorId != null) 'textColor': _textColorId,
            if (_cardCustom != null) 'cardColorHex': _hex(_cardCustom!),
            if (_textCustom != null) 'textColorHex': _hex(_textCustom!),
            'cardOpacity': _cardOpacity,
          }));
    } catch (_) {
      // no poder guardar la preferencia no puede tumbar la app
    }
  }
}
