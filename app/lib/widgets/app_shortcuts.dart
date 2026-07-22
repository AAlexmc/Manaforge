/// Atajos de teclado. Es una app de escritorio: la mano ya está en el
/// teclado y llegar al ratón para cambiar de pestaña cuesta.
///
/// Los atajos viven arriba del todo (envuelven la app entera) y las pantallas
/// se enteran de "quiero buscar" por un aviso, no por una llamada directa:
/// así el atajo no tiene que saber cómo busca cada pantalla, solo a cuál va
/// dirigido.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// "Quiero buscar en la pestaña N". Cada pantalla mira si el aviso es para
/// ella (comparando su índice) y hace lo suyo: unas enfocan su buscador,
/// otras abren la pantalla donde se busca.
class SearchFocusBus extends ChangeNotifier {
  int _tick = 0;
  int? _target;

  /// Sube con cada petición: dos peticiones seguidas a la MISMA pestaña
  /// tienen que notarse las dos (si no, pulsar Ctrl+F dos veces no haría
  /// nada la segunda).
  int get tick => _tick;

  /// Pestaña a la que va dirigida la última petición.
  int? get target => _target;

  void request(int tab) {
    _target = tab;
    _tick++;
    notifyListeners();
  }
}

/// Las teclas de los números, para "Ctrl+3 → tercera pestaña".
const List<LogicalKeyboardKey> kDigitKeys = [
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
  LogicalKeyboardKey.digit5,
  LogicalKeyboardKey.digit6,
  LogicalKeyboardKey.digit7,
  LogicalKeyboardKey.digit8,
  LogicalKeyboardKey.digit9,
];

/// Los atajos de la ventana principal.
///
/// [onTab] recibe el índice de pantalla; [onScan] abre el escáner; [onSearch]
/// es el Ctrl+F, que cada pantalla interpreta a su manera.
Map<ShortcutActivator, VoidCallback> mainShortcuts({
  required int screenCount,
  required void Function(int) onTab,
  required VoidCallback onScan,
  required VoidCallback onSearch,
  required VoidCallback onSettings,
}) =>
    {
      for (var i = 0; i < screenCount && i < kDigitKeys.length; i++)
        SingleActivator(kDigitKeys[i], control: true): () => onTab(i),
      const SingleActivator(LogicalKeyboardKey.keyE, control: true): onScan,
      const SingleActivator(LogicalKeyboardKey.keyF, control: true): onSearch,
      const SingleActivator(LogicalKeyboardKey.comma, control: true):
          onSettings,
    };

/// Cierra lo que haya abierto encima (una ficha, un detalle de mazo).
///
/// Los diálogos y las hojas ya se cierran solos con Escape; las pantallas
/// empujadas con `push` no, y en escritorio eso se nota.
///
/// Va por la LLAVE del navegador y no por el context: el atajo se pone por
/// encima de toda la app, y ahí arriba `Navigator.of(context)` no encuentra
/// ningún navegador (está más abajo).
Map<ShortcutActivator, VoidCallback> escapeCloses(
        GlobalKey<NavigatorState> navigator) =>
    {
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          navigator.currentState?.maybePop(),
    };

/// La chuleta de atajos, para enseñarla en Ajustes.
const List<(String, String)> kShortcutHelp = [
  ('Ctrl + 1…7', 'Cambiar de pestaña'),
  ('Ctrl + E', 'Abrir el escáner'),
  ('Ctrl + F', 'Buscar en la pestaña en la que estés'),
  ('Ctrl + ,', 'Ajustes'),
  ('Esc', 'Cerrar lo que tengas abierto encima'),
];
