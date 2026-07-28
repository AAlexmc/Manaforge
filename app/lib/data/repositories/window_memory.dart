/// El puente entre la ventana de verdad y lo que se guarda de ella.
///
/// Va aparte de `window_prefs.dart` a propósito: aquí se habla con el sistema
/// de ventanas (plugin `window_manager`) y eso no se puede probar sin una
/// ventana de verdad. Lo de decidir qué tamaño y qué sitio valen —que es
/// donde están las trampas— vive en `window_prefs.dart` y sí tiene tests.
///
/// Todo lo de aquí es a prueba de fallos: si el plugin no está, o el sistema
/// dice que no, la app abre con la ventana de siempre. Recordar dónde estaba
/// es una comodidad, no un requisito para arrancar.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

import 'package:manaforge_app/data/repositories/window_prefs.dart';

/// Cuánto se espera antes de apuntar el cambio. Arrastrar una ventana suelta
/// decenas de avisos por segundo; apuntar el último y no los cuarenta de en
/// medio.
const Duration kWindowSaveDelay = Duration(milliseconds: 600);

/// Tamaño con el que se abre la primera vez.
const Size kDefaultWindowSize = Size(1280, 840);

class WindowMemory with WindowListener {
  final WindowPreference prefs;

  /// Solo para tests: el sistema de ventanas.
  final WindowManager manager;

  WindowMemory(this.prefs, {WindowManager? manager})
      : manager = manager ?? windowManager;

  Timer? _espera;

  /// Deja la ventana donde estaba y se queda apuntando los cambios.
  ///
  /// Se llama desde `main()` ANTES de `runApp`: colocar la ventana después de
  /// que se vea es un salto en la cara del usuario.
  Future<void> start() async {
    try {
      await manager.ensureInitialized();
      await prefs.load();
      final guardado = prefs.bounds;
      final opciones = WindowOptions(
        size: guardado == null
            ? kDefaultWindowSize
            : Size(guardado.width, guardado.height),
        minimumSize: const Size(kMinWindowWidth, kMinWindowHeight),
        title: 'ManaForge',
      );
      await manager.waitUntilReadyToShow(opciones, () async {
        if (guardado?.maximized == true) {
          await manager.maximize();
        } else if (guardado?.x != null && guardado?.y != null) {
          await manager.setPosition(Offset(guardado!.x!, guardado.y!));
        } else {
          await manager.center();
        }
        await manager.show();
        await manager.focus();
      });
      manager.addListener(this);
    } catch (_) {
      // sin plugin o sin sistema de ventanas: la app abre igual
    }
  }

  Future<void> stop() async {
    _espera?.cancel();
    try {
      manager.removeListener(this);
    } catch (_) {/* nunca llegó a engancharse */}
  }

  @override
  void onWindowResized() => _apuntarLuego();

  @override
  void onWindowMoved() => _apuntarLuego();

  @override
  void onWindowMaximize() => _apuntarLuego();

  @override
  void onWindowUnmaximize() => _apuntarLuego();

  /// Al cerrar se apunta YA: esperando los 600 ms no da tiempo.
  @override
  void onWindowClose() => unawaited(_apuntar());

  void _apuntarLuego() {
    _espera?.cancel();
    _espera = Timer(kWindowSaveDelay, () => unawaited(_apuntar()));
  }

  Future<void> _apuntar() async {
    try {
      final maximizada = await manager.isMaximized();
      // maximizada, el tamaño que devuelve el sistema es el de la pantalla:
      // guardar ESO sería perder el tamaño "de verdad" al que volver
      if (maximizada) {
        final anterior = prefs.bounds;
        await prefs.remember(WindowBounds(
          width: anterior?.width ?? kDefaultWindowSize.width,
          height: anterior?.height ?? kDefaultWindowSize.height,
          x: anterior?.x,
          y: anterior?.y,
          maximized: true,
        ));
        return;
      }
      final size = await manager.getSize();
      final pos = await manager.getPosition();
      await prefs.remember(WindowBounds(
        width: size.width,
        height: size.height,
        x: pos.dx,
        y: pos.dy,
        maximized: false,
      ));
    } catch (_) {
      // el sistema no dice dónde está: se queda lo de antes
    }
  }
}
