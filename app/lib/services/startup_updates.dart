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
  if (lastDate == null || lastDate.isEmpty) return UpdateNeed.missing;
  final built = DateTime.tryParse(lastDate);
  final today = now ?? DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);
  if (built != null) {
    final days = midnight
        .difference(DateTime(built.year, built.month, built.day))
        .inDays;
    if (days < maxAgeDays) return UpdateNeed.fresh;
  }
  // el contenido es viejo (o su fecha ilegible): solo se rebaja a "hay una
  // nueva" si además hace tiempo que no se comprueba
  if (downloadedAt != null) {
    final days = midnight
        .difference(DateTime(
            downloadedAt.year, downloadedAt.month, downloadedAt.day))
        .inDays;
    if (days < maxAgeDays) return UpdateNeed.fresh;
  }
  return UpdateNeed.stale;
}

/// Texto corto para la pantalla de arranque.
String updateLabel(UpdateNeed need) => switch (need) {
      UpdateNeed.missing => 'falta, la traigo',
      UpdateNeed.stale => 'hay una nueva',
      UpdateNeed.fresh => 'al día',
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
