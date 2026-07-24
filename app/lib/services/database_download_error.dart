/// Un fallo al bajarse una de las bases de datos que la app usa sin conexión.
///
/// Las tres bases (cartas, huellas del escáner, histórico de precios) se piden
/// a una release de GitHub y las tres pueden fallar igual, así que el fallo se
/// cuenta de una sola forma. El [message] está en español y va al registro; lo
/// que ve la persona sale de [databaseDownloadErrorText].
library;

import '../l10n/app_localizations.dart';

/// Qué base es la que no ha bajado.
enum DownloadedDatabase {
  /// Todas las cartas de Magic (la gorda).
  cards,

  /// Las huellas visuales que usa el escáner.
  scannerHashes,

  /// El histórico de precios.
  priceHistory,
}

class DatabaseDownloadError implements Exception {
  final DownloadedDatabase database;

  /// El código HTTP con el que respondió GitHub.
  final int statusCode;

  final String message;

  const DatabaseDownloadError(this.database, this.statusCode, this.message);

  @override
  String toString() => message;
}

/// El fallo, en el idioma del usuario.
String databaseDownloadErrorText(
        AppLocalizations t, DatabaseDownloadError e) =>
    switch (e.database) {
      DownloadedDatabase.cards => t.dbErrCards('${e.statusCode}'),
      DownloadedDatabase.scannerHashes => t.dbErrHashes('${e.statusCode}'),
      DownloadedDatabase.priceHistory => t.dbErrPrices('${e.statusCode}'),
    };

/// El texto de cualquier fallo que pueda salir de una descarga, ya sea uno de
/// los nuestros o algo que no habíamos previsto.
///
/// Está aquí para que ninguna pantalla se invente su propia versión: las
/// descargas fallan en cinco sitios distintos y todas tienen que contarlo
/// igual.
String downloadErrorText(AppLocalizations t, Object error) =>
    error is DatabaseDownloadError
        ? databaseDownloadErrorText(t, error)
        : '$error';
