/// Espera a que el usuario pare de teclear antes de disparar la acción.
///
/// El buscador de Mercado y el de "Todas las cartas" lanzan un `LIKE '%q%'`
/// sin índice sobre ~110k filas, en el hilo de la interfaz. Sin esto,
/// escribir "bolt" son 4 consultas completas; con el Timer, solo la última.
library;

import 'dart:async';

/// Cuánto se espera desde la última pulsación antes de correr la acción.
const Duration kDebounceDelay = Duration(milliseconds: 280);

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = kDebounceDelay});

  /// Cancela lo pendiente (si lo hay) y programa [action] dentro de [delay].
  /// Una tecla más antes de que pase el tiempo empieza la cuenta de cero.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Descarta lo pendiente sin programar nada nuevo (p.ej. al vaciar el
  /// buscador: el borrado se aplica al instante y no debe revivir la
  /// búsqueda anterior 280 ms después).
  void cancel() {
    _timer?.cancel();
  }

  /// Al cerrar la pantalla: sin esto, un Timer vivo dispara la acción sobre
  /// un State ya desmontado.
  void dispose() => cancel();
}
