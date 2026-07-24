/// "Qué hay de nuevo" al abrir una versión que aún no habías visto.
///
/// Las novedades van AQUÍ dentro, no se piden a GitHub: la app tiene que
/// poder contarte lo que ha cambiado aunque estés sin conexión, y quien se
/// baja el zip no siempre pasa por la página de la release.
///
/// Al publicar una versión: añade su entrada arriba del todo y sube
/// `kAppVersion` (hay un test que ata la versión al `pubspec.yaml`).
library;

import '../l10n/app_localizations.dart';
import 'backup.dart' show kAppVersion;

/// Novedades de una versión: qué cambia y por qué te importa, no el número de
/// PR. El texto vive en las traducciones, así que las novedades se leen en el
/// idioma que tenga puesto el usuario; aquí solo queda a qué versión van.
class VersionNews {
  final String version;
  final String Function(AppLocalizations t) headline;
  final List<String> Function(AppLocalizations t) bullets;

  const VersionNews({
    required this.version,
    required this.headline,
    required this.bullets,
  });
}

String _headline030(AppLocalizations t) => t.wn030Headline;

List<String> _bullets030(AppLocalizations t) => [
      t.wn030Forge,
      t.wn030Pnl,
      t.wn030PhotoFolder,
      t.wn030Album,
      t.wn030Background,
      t.wn030Window,
      t.wn030Achievements,
      t.wn030Update,
      t.wn030Shortcuts,
      t.wn030Linux,
      t.wn030License,
    ];

/// De la más nueva a la más vieja.
const List<VersionNews> kWhatsNew = [
  VersionNews(
    version: '0.3.0',
    headline: _headline030,
    bullets: _bullets030,
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
