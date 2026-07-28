/// Descargar una base (cartas, huellas, histórico de precios) con barra de
/// progreso: 5 pantallas hacían el mismo `await for` + try/catch a mano.
///
/// Solo el ESQUELETO se comparte aquí — qué pasa al terminar o al fallar
/// (snackbar, texto inline, qué más se recalcula...) sigue siendo cosa de
/// cada pantalla: no es lo mismo en las 5, y los textos visibles no cambian.
library;

/// Consume [download] reportando cada paso por [onProgress] (ya
/// normalizado: `null` = indeterminado, sin Content-Length — el progreso
/// negativo NO llega tal cual). Al terminar ESPERA a [onDone] (alguna
/// pantalla recarga datos ahí antes de avisar); si algo revienta, a
/// [onError] con la excepción TAL CUAL: cada pantalla decide cómo se
/// traduce.
Future<void> runDownload(
  Stream<double> download, {
  required void Function(double? progress) onProgress,
  required Future<void> Function() onDone,
  required void Function(Object error) onError,
}) async {
  try {
    await for (final p in download) {
      onProgress(p < 0 ? null : p);
    }
    await onDone();
  } catch (e) {
    onError(e);
  }
}
