/// Un trabajo async que nunca corre dos veces a la vez.
///
/// Mercado e Inicio recalculan su pipeline entero (precios, P&L, gráfica…)
/// cada vez que la colección avisa. Confirmar una bandeja de 20 cartas avisa
/// 20 veces seguidas: sin guarda, eso son 20 pipelines corriendo A LA VEZ,
/// cada uno pisando el `setState` del anterior.
///
/// Mismo patrón que ya usan a mano Colección (`_computing`/`_needsRecompute`
/// en coleccion_screen.dart) y el detalle de carpeta, aquí sacado a una
/// clase reutilizable: si llega una petición mientras [run] está en curso,
/// no lanza un segundo trabajo — apunta que hace falta otra pasada y la
/// corre UNA vez, en cuanto la actual termine.
library;

import 'dart:async';

class SerialTask {
  SerialTask({this.onError});

  /// Recibe las excepciones que lance el job (una pasada que falla no se
  /// come la pasada pendiente). Sin él, la primera excepción se re-lanza
  /// cuando [run] termina, también sin perder la pendiente.
  final void Function(Object error, StackTrace stack)? onError;

  bool _running = false;
  bool _pending = false;
  bool _disposed = false;
  Completer<void>? _pendingDone;
  Future<void> Function()? _nextJob;

  /// Corre [job]. Si ya hay uno en marcha, no lo duplica: apunta la pasada
  /// pendiente y devuelve un future que se completa cuando ESA pasada haya
  /// corrido (así `await _load()` tras una acción espera a datos frescos,
  /// no al instante). Cada pasada corre el job de la petición MÁS reciente.
  Future<void> run(Future<void> Function() job) async {
    if (_disposed) return;
    _nextJob = job;
    if (_running) {
      _pending = true;
      _pendingDone ??= Completer<void>();
      return _pendingDone!.future;
    }
    _running = true;
    Object? firstError;
    StackTrace? firstStack;
    try {
      do {
        _pending = false;
        final currentJob = _nextJob!;
        // quién esperaba la pasada coalescida: se resuelve cuando SU job
        // termina, no cuando alguien la apuntó
        final done = _pendingDone;
        _pendingDone = null;
        try {
          await currentJob();
        } catch (e, s) {
          if (onError != null) {
            onError!(e, s);
          } else {
            firstError ??= e;
            firstStack ??= s;
          }
        }
        done?.complete();
      } while (_pending && !_disposed);
    } finally {
      _running = false;
      // dispose a mitad: que nadie se quede colgado en un await eterno
      _pendingDone?.complete();
      _pendingDone = null;
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError, firstStack!);
    }
  }

  /// Al cerrar la pantalla: la pasada en curso acaba (sus guardas `mounted`
  /// ya la protegen), pero no se arranca ninguna más — sin esto, una pasada
  /// pendiente ejecutaba el pipeline entero (y escribía a disco) con el
  /// State ya desmontado.
  void dispose() {
    _disposed = true;
  }
}
