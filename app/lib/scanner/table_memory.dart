/// Qué carta hay AHORA sobre la mesa, para no contar la misma dos veces.
///
/// El problema real: la puerta de presencia emite `cardChanged` cuando la
/// escena se reasienta distinta, y una carta que se mueve un solo píxel
/// (pasa una mano, se roza la mesa) ya cambia lo suficiente. La puerta NO
/// puede distinguir "la misma carta movida" de "otra carta": mira píxeles,
/// no cartas. Solo la identidad de lo reconocido puede.
///
/// De ahí la regla: **el tiempo no cuenta copias**. Solo cuentan
///  - que aparezca una impresión DISTINTA de la que está en la mesa, o
///  - que la mesa se haya quedado vacía de verdad.
///
/// Consecuencia asumida: si cambias una carta por otra IGUAL sin vaciar la
/// mesa, se cuenta una. Las dos son píxeles idénticos, no hay prueba de que
/// sean dos, y adivinar es justo lo que hacía que una carta olvidada bajo la
/// cámara se contara siete veces. Para eso está el botón de cantidad.
///
/// Lógica pura, testeable en CI.
library;

class TableMemory {
  /// Cuántos ticks seguidos con la mesa vacía hacen falta para olvidar lo que
  /// había. Más de uno a propósito: un parpadeo (una mano que tapa un
  /// momento) no puede pasar por "has quitado la carta", porque entonces la
  /// siguiente lectura contaría una copia que no existe.
  final int emptyTicksToForget;

  TableMemory({this.emptyTicksToForget = 3});

  String? _onTable;
  int _empty = 0;

  /// La impresión que está ahora sobre la mesa, si se sabe.
  String? get onTable => _onTable;

  /// ¿Hay que contar esta carta? [printingKey] identifica la impresión
  /// exacta (carta + edición), que es lo que agrupa la bandeja.
  bool shouldCount(String printingKey) {
    _empty = 0;
    if (_onTable == printingKey) return false;
    _onTable = printingKey;
    return true;
  }

  /// Un tick con la mesa vacía.
  void sawEmpty() {
    if (_onTable == null) return;
    if (++_empty >= emptyTicksToForget) {
      _onTable = null;
      _empty = 0;
    }
  }

  /// Olvidar lo que hubiera (la sesión de escaneo empieza de cero).
  void reset() {
    _onTable = null;
    _empty = 0;
  }
}
