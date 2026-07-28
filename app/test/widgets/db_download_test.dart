/// `runDownload` es el esqueleto compartido por las 5 pantallas que
/// descargan una base con progreso (cartas, huellas, histórico de precios):
/// consumir el stream, avisar de cada paso y de cómo termina. Lo que pasa al
/// terminar o al fallar sigue siendo de cada pantalla.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/widgets/db_download.dart';

void main() {
  test('reporta cada paso del progreso', () async {
    final pasos = <double?>[];
    await runDownload(
      Stream.fromIterable([0.0, 0.5, 1.0]),
      onProgress: pasos.add,
      onDone: () async {},
      onError: (_) {},
    );
    expect(pasos, [0.0, 0.5, 1.0]);
  });

  test('progreso negativo (sin Content-Length) llega como null', () async {
    final pasos = <double?>[];
    await runDownload(
      Stream.fromIterable([0.2, -1.0, 0.9]),
      onProgress: pasos.add,
      onDone: () async {},
      onError: (_) {},
    );
    expect(pasos, [0.2, null, 0.9]);
  });

  test('al terminar el stream llama a onDone, no a onError', () async {
    var done = false;
    var errored = false;
    await runDownload(
      Stream.fromIterable([1.0]),
      onProgress: (_) {},
      onDone: () async => done = true,
      onError: (_) => errored = true,
    );
    expect(done, isTrue);
    expect(errored, isFalse);
  });

  test('si el stream revienta, llama a onError con la excepción TAL CUAL',
      () async {
    Object? capturada;
    var done = false;
    await runDownload(
      Stream<double>.error(Exception('sin conexión')),
      onProgress: (_) {},
      onDone: () async => done = true,
      onError: (e) => capturada = e,
    );
    expect(done, isFalse, reason: 'no se llega a terminar');
    expect(capturada.toString(), contains('sin conexión'));
  });

  test('si onDone revienta (p.ej. recargar tras la descarga), se trata '
      'como fallo de la descarga', () async {
    Object? capturada;
    await runDownload(
      Stream.fromIterable([1.0]),
      onProgress: (_) {},
      onDone: () async => throw Exception('recarga rota'),
      onError: (e) => capturada = e,
    );
    expect(capturada.toString(), contains('recarga rota'));
  });

  test('stream vacío: no reporta progreso pero sí llama a onDone', () async {
    final pasos = <double?>[];
    var done = false;
    await runDownload(
      const Stream<double>.empty(),
      onProgress: pasos.add,
      onDone: () async => done = true,
      onError: (_) {},
    );
    expect(pasos, isEmpty);
    expect(done, isTrue);
  });
}
