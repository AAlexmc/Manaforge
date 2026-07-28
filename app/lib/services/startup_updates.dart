/// Reglas de "¿hay que ponerlo al día?" para las bases que ManaForge se
/// descarga. Lógica pura (sin red ni disco) para poder testearla.
///
/// Cada base se reconstruye a un ritmo distinto y pesa distinto, así que
/// no se refrescan todas igual de seguido: los precios cambian a diario y
/// la base de cartas los trae dentro (22 MB), el histórico se publica una
/// vez por semana (3 MB) y las huellas del escáner solo cambian cuando
/// sale una colección nueva (11 MB).
library;

import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';

/// ¿Existe carpeta de datos donde guardar las bases? En tests (y en un
/// entorno sin el plugin de rutas) no, y ahí no hay nada que descargar.
Future<bool> storageAvailable() async {
  try {
    await getApplicationSupportDirectory();
    return true;
  } catch (_) {
    return false;
  }
}

/// Qué hay que hacer con una base al arrancar.
enum UpdateNeed {
  /// No está: hay que traerla sí o sí (la app no funciona sin ella).
  missing,

  /// Está pero es vieja: se refresca en segundo plano.
  stale,

  /// Al día: no se toca.
  fresh,
}

/// Días máximos antes de refrescar cada base.
const int kCardsMaxAgeDays = 1; // los precios del Mercado salen de aquí
const int kPricesMaxAgeDays = 7; // el workflow del histórico va semanal
const int kHashesMaxAgeDays = 21; // solo cambian con colecciones nuevas

/// [lastDate] es la fecha ('YYYY-MM-DD') que trae la base descargada;
/// null = no está. La comparación va por DÍA de calendario, no por horas,
/// para que no dependa de a qué hora abras la app.
/// [downloadedAt] es cuándo se trajo la copia local. Importa porque la
/// fecha del CONTENIDO puede no alcanzar nunca al día de hoy (el bulk de
/// Scryfall se publica con la fecha de la víspera): sin esto la app se
/// bajaría 22 MB en cada arranque para acabar con el mismo fichero.
UpdateNeed updateNeed(String? lastDate,
    {required int maxAgeDays, DateTime? now, DateTime? downloadedAt}) {
  // "no sé su fecha" NO es lo mismo que "no está": una base descargada
  // puede no tener la fila de meta que se le pide (esquemas antiguos). Si
  // el fichero existe (hay downloadedAt) se juzga por cuándo se trajo; sin
  // fichero, falta y punto.
  final hasContentDate = lastDate != null && lastDate.isNotEmpty;
  if (!hasContentDate && downloadedAt == null) return UpdateNeed.missing;

  final today = now ?? DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);
  int? daysSince(DateTime? d) => d == null
      ? null
      : midnight.difference(DateTime(d.year, d.month, d.day)).inDays;

  if (hasContentDate) {
    final days = daysSince(DateTime.tryParse(lastDate));
    if (days != null && days < maxAgeDays) return UpdateNeed.fresh;
  }
  // el contenido es viejo (o su fecha ilegible): solo se deja pasar si
  // además se trajo hace poco. El >= 0 descarta un mtime en el FUTURO
  // (reloj torcido, restaurar un backup), que si no dejaría la base
  // marcada al día para siempre.
  final since = daysSince(downloadedAt);
  if (since != null && since >= 0 && since < maxAgeDays) {
    return UpdateNeed.fresh;
  }
  return UpdateNeed.stale;
}

/// Texto corto para la pantalla de arranque.
String updateLabel(AppLocalizations t, UpdateNeed need) => switch (need) {
      UpdateNeed.missing => t.suNeedMissing,
      UpdateNeed.stale => t.suNeedStale,
      UpdateNeed.fresh => t.suNeedFresh,
    };

/// Una base descargable, vista por la pantalla de arranque. Se pasa como
/// datos (no como la clase concreta) para poder probar la pantalla sin red.
class UpdateSource {
  final String name;

  /// Tamaño aproximado de la descarga, para avisar antes de tirar de datos.
  final String size;

  /// Qué es, en una línea, cuando no hay nada que contar.
  final String what;

  /// Fecha de la copia local ('YYYY-MM-DD'), o null si no está.
  final Future<String?> Function() lastDate;

  /// Descarga con progreso 0..1 (-1 = indeterminado).
  final Stream<double> Function() download;

  /// Cuándo se trajo la copia local (null = no se sabe).
  final Future<DateTime?> Function()? downloadedAt;

  final int maxAgeDays;

  const UpdateSource({
    required this.name,
    required this.size,
    required this.what,
    required this.lastDate,
    required this.download,
    required this.maxAgeDays,
    this.downloadedAt,
  });
}
