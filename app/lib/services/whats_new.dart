/// "Qué hay de nuevo" al abrir una versión que aún no habías visto.
///
/// Las novedades van AQUÍ dentro, no se piden a GitHub: la app tiene que
/// poder contarte lo que ha cambiado aunque estés sin conexión, y quien se
/// baja el zip no siempre pasa por la página de la release.
///
/// Al publicar una versión: añade su entrada arriba del todo y sube
/// `kAppVersion` (hay un test que ata la versión al `pubspec.yaml`).
library;

import 'backup.dart' show kAppVersion;

/// Novedades de una versión, en el idioma de la casa: qué cambia y por qué
/// te importa, no el número de PR.
class VersionNews {
  final String version;
  final String headline;
  final List<String> bullets;

  const VersionNews({
    required this.version,
    required this.headline,
    required this.bullets,
  });
}

/// De la más nueva a la más vieja.
const List<VersionNews> kWhatsNew = [
  VersionNews(
    version: '0.3.0',
    headline: 'Forge por expansiones, precio de compra y avisos de versión',
    bullets: [
      'Forge: elige de qué expansiones salen las cartas. Y si activas '
          '"incluir cartas que no tengo", te monta el mazo con toda la '
          'colección elegida y te dice cuántas te faltan y cuánto cuestan.',
      'Precio de compra y P&L: si tu CSV de ManaBox trae "Purchase price", '
          'el Mercado te dice lo que pagaste, lo que vale hoy y la '
          'diferencia. Las divisas no se mezclan.',
      'Escanear por foto también deja elegir carpeta, como el escáner en '
          'vivo.',
      'Álbum: lo que te falta de cada expansión, con lo que costaría.',
      'Fondo de pantalla: pon detrás la imagen que quieras, con velo '
          'regulable.',
      'La app avisa cuando hay versión nueva (no se actualiza sola) y '
          'comprueba la huella SHA-256 de las bases que se descarga.',
      'Atajos de teclado: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, y Escape.',
      'En Linux, un instalador deja ManaForge en el menú de aplicaciones '
          'con su icono.',
      'Licencia PolyForm Noncommercial: compártela y tócala lo que quieras, '
          'pero no se vende.',
    ],
  ),
];

/// Las novedades de la versión que corre ahora, si están escritas.
VersionNews? newsFor(String version) {
  for (final n in kWhatsNew) {
    if (n.version == version) return n;
  }
  return null;
}

/// ¿Hay que enseñar las novedades? Solo cuando la versión que corre es
/// distinta de la última que el usuario vio Y hay algo escrito para ella.
///
/// [seen] null = primera vez que se abre la app: ahí no se enseña nada, que
/// bastante tiene con empezar de cero.
bool shouldShowWhatsNew({
  required String current,
  required String? seen,
  bool firstRun = false,
}) {
  if (firstRun || seen == null) return false;
  if (seen == current) return false;
  return newsFor(current) != null;
}

/// Las novedades de esta versión (atajo para la interfaz).
VersionNews? get currentNews => newsFor(kAppVersion);
