/// Dónde y de qué tamaño estaba la ventana la última vez.
///
/// Es una app de escritorio: quien la deja a media pantalla, en el monitor de
/// la derecha, espera encontrarla ahí al volver a abrirla. Se guarda en
/// `window.json`, al lado del resto de preferencias.
///
/// Aquí dentro NO se habla con el sistema de ventanas: esto son datos y sus
/// topes, para poder probarlos sin plugin. Quien mueve la ventana de verdad
/// es `window_memory.dart`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'json_store_io.dart';

/// Tamaño mínimo con el que la app se sigue pudiendo usar: por debajo, la
/// barra de abajo no cabe y las tarjetas se parten.
const double kMinWindowWidth = 900;
const double kMinWindowHeight = 620;

/// Tope de arriba. No es una pantalla, es un disparate: un fichero
/// manipulado (o un monitor que ya no está) no puede pedir una ventana de
/// 200.000 píxeles.
const double kMaxWindowSide = 10000;

/// Hasta dónde se acepta una posición guardada. Negativa se acepta —un
/// monitor a la izquierda del principal tiene coordenadas negativas— pero no
/// tanto como para dejar la ventana donde no la ve nadie.
const double kMinWindowPos = -4000;
const double kMaxWindowPos = 20000;

/// Tamaño y sitio de la ventana. [x]/[y] null = que lo coloque el sistema.
@immutable
class WindowBounds {
  final double width;
  final double height;
  final double? x;
  final double? y;

  /// Estaba maximizada: entonces el tamaño y el sitio dan igual, se maximiza
  /// y ya.
  final bool maximized;

  const WindowBounds({
    required this.width,
    required this.height,
    this.x,
    this.y,
    this.maximized = false,
  });

  @override
  bool operator ==(Object other) =>
      other is WindowBounds &&
      other.width == width &&
      other.height == height &&
      other.x == x &&
      other.y == y &&
      other.maximized == maximized;

  @override
  int get hashCode => Object.hash(width, height, x, y, maximized);

  @override
  String toString() =>
      'WindowBounds(${width}x$height @ $x,$y, max: $maximized)';
}

/// Deja el tamaño y el sitio en algo con lo que se pueda abrir una ventana.
///
/// Devuelve null si lo que llega no vale ni recortándolo (números que no son
/// números). Una posición imposible NO invalida el tamaño: se pierde el sitio
/// y lo coloca el sistema, que es mucho mejor que abrir la ventana fuera de
/// la pantalla y que parezca que la app no arranca.
WindowBounds? saneBounds(
    {double? width,
    double? height,
    double? x,
    double? y,
    bool maximized = false}) {
  bool numero(double? v) => v != null && v.isFinite;
  if (!numero(width) || !numero(height)) return null;
  final w = width!.clamp(kMinWindowWidth, kMaxWindowSide).toDouble();
  final h = height!.clamp(kMinWindowHeight, kMaxWindowSide).toDouble();
  final dentro = numero(x) &&
      numero(y) &&
      x! >= kMinWindowPos &&
      x <= kMaxWindowPos &&
      y! >= kMinWindowPos &&
      y <= kMaxWindowPos;
  return WindowBounds(
    width: w,
    height: h,
    x: dentro ? x : null,
    y: dentro ? y : null,
    maximized: maximized,
  );
}

class WindowPreference extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  WindowPreference({this.dataDir});

  WindowBounds? _bounds;

  /// Lo último que se guardó, o null si no hay nada (o no valía).
  WindowBounds? get bounds => _bounds;

  /// Mientras se lee el disco se comparte la ESPERA — ver la explicación
  /// larga en `language_prefs.dart`.
  Future<void> load() => _cargado ? Future.value() : (_loading ??= _load());

  bool _cargado = false;
  Future<void>? _loading;

  Future<void> _load() async {
    try {
      await _leer();
    } finally {
      _cargado = true;
    }
  }

  Future<void> _leer() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return;
      double? num_(Object? v) => v is num ? v.toDouble() : null;
      _bounds = saneBounds(
        width: num_(decoded['width']),
        height: num_(decoded['height']),
        x: num_(decoded['x']),
        y: num_(decoded['y']),
        maximized: decoded['maximized'] == true,
      );
      notifyListeners();
    } catch (_) {
      // fichero raro: ventana de fábrica
    }
  }

  /// Apunta dónde está la ventana ahora. Lo que no valga se recorta o se
  /// tira: aquí no se guarda una ventana con la que no se pueda abrir.
  Future<void> remember(WindowBounds bounds) async {
    final sano = saneBounds(
      width: bounds.width,
      height: bounds.height,
      x: bounds.x,
      y: bounds.y,
      maximized: bounds.maximized,
    );
    if (sano == null || sano == _bounds) return;
    _bounds = sano;
    notifyListeners();
    await _save();
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'window.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  /// En fila india: mover la ventana dispara muchos avisos seguidos — ver la
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
    final file = await _file();
    final b = _bounds;
    if (file == null || b == null) return;
    try {
      await writeJsonFile(
          file,
          jsonEncode({
            'width': b.width,
            'height': b.height,
            if (b.x != null) 'x': b.x,
            if (b.y != null) 'y': b.y,
            'maximized': b.maximized,
          }));
    } catch (_) {
      // no poder guardar dónde estaba la ventana no puede tumbar la app
    }
  }
}
