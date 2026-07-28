/// Un trabajo que nunca corre dos veces a la vez: si llegan peticiones
/// mientras está en marcha, se funden en UNA sola repetición al terminar.
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/serial_task.dart';

void main() {
  test(
      'las peticiones que llegan mientras corre se funden en UNA repetición, '
      'no una por petición', () async {
    final task = SerialTask();
    var runs = 0;
    final gates = <Completer<void>>[];

    Future<void> job() async {
      final gate = Completer<void>();
      gates.add(gate);
      runs++;
      await gate.future;
    }

    final first = task.run(job);
    await Future<void>.delayed(Duration.zero); // deja arrancar el job

    expect(runs, 1, reason: 'el primero ya está en marcha');

    // 3 peticiones de más mientras el primero sigue en curso: ninguna
    // dispara un job nuevo, solo dejan dicho que hace falta otra pasada
    unawaited(task.run(job));
    unawaited(task.run(job));
    unawaited(task.run(job));
    await Future<void>.delayed(Duration.zero);

    expect(runs, 1, reason: 'nadie corre en paralelo al que ya está en marcha');

    gates[0].complete(); // termina el primero
    await Future<void>.delayed(Duration.zero); // deja entrar la repetición

    expect(runs, 2,
        reason: 'las 3 peticiones de en medio se fundieron en UNA sola '
            'repetición');
    expect(gates.length, 2);

    gates[1].complete();
    await first;

    // el ciclo ya está cerrado: una petición nueva sí arranca su propio job
    var extraRuns = 0;
    await task.run(() async => extraRuns++);
    expect(extraRuns, 1);
  });

  test('un job que lanza NO se come la pasada pendiente', () async {
    final task = SerialTask();
    var runs = 0;
    final gate = Completer<void>();

    final first = task.run(() async {
      runs++;
      await gate.future;
      throw StateError('pasada 1 rota');
    });
    await Future<void>.delayed(Duration.zero);
    unawaited(task.run(() async => runs++)); // queda pendiente
    gate.completeError(StateError('pasada 1 rota'));

    // la excepción sale por el future del que arrancó el ciclo…
    await expectLater(first, throwsStateError);
    // …pero la repetición coalescida corrió igualmente
    expect(runs, 2, reason: 'la pasada pendiente sobrevive al fallo');
  });

  test('con onError la excepción se entrega ahí y run() no lanza', () async {
    Object? seen;
    final task = SerialTask(onError: (e, _) => seen = e);
    await task.run(() async => throw StateError('boom'));
    expect(seen, isA<StateError>());
  });

  test('el future de una petición coalescida espera a SU pasada, no vuelve '
      'al instante', () async {
    final task = SerialTask();
    final gate = Completer<void>();
    var freshData = false;

    unawaited(task.run(() async => gate.future));
    await Future<void>.delayed(Duration.zero);

    // "await _load()" tras una acción: debe volver con datos frescos
    final waited = task.run(() async => freshData = true);
    var resolved = false;
    unawaited(waited.then((_) => resolved = true));
    await Future<void>.delayed(Duration.zero);

    expect(resolved, isFalse, reason: 'su pasada aún no ha corrido');
    gate.complete();
    await waited;
    expect(freshData, isTrue);
  });

  test('tras dispose no arranca ninguna pasada más', () async {
    final task = SerialTask();
    var runs = 0;
    final gate = Completer<void>();

    final first = task.run(() async {
      runs++;
      await gate.future;
    });
    await Future<void>.delayed(Duration.zero);
    unawaited(task.run(() async => runs++)); // pendiente…
    task.dispose(); // …pero la pantalla se cierra antes
    gate.complete();
    await first;

    expect(runs, 1, reason: 'la pendiente no corre con el State desmontado');

    await task.run(() async => runs++);
    expect(runs, 1, reason: 'run() tras dispose es un no-op');
  });
}
