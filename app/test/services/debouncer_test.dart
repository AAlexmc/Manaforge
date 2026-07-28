/// El buscador (Mercado, "Todas las cartas") lanza un `LIKE` sin índice
/// sobre ~110k filas por cada pulsación: sin debounce, escribir una palabra
/// entera son tantas consultas como letras.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/debouncer.dart';

void main() {
  test('varias llamadas seguidas: solo UNA ejecución, con el último valor',
      () async {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 30));
    var runs = 0;
    String? last;

    debouncer.run(() {
      runs++;
      last = 'a';
    });
    debouncer.run(() {
      runs++;
      last = 'ab';
    });
    debouncer.run(() {
      runs++;
      last = 'abc';
    });

    expect(runs, 0, reason: 'nadie corre todavía: sigue esperando la pausa');

    await Future<void>.delayed(const Duration(milliseconds: 60));

    expect(runs, 1,
        reason: 'las de en medio se cancelan, solo queda la última');
    expect(last, 'abc');
  });

  test('dispose cancela lo pendiente: no dispara sobre una pantalla cerrada',
      () async {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 30));
    var runs = 0;
    debouncer.run(() => runs++);

    debouncer.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    expect(runs, 0);
  });
}
