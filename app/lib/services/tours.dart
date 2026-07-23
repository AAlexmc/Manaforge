import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import '../widgets/tour_overlay.dart';

/// GlobalKeys de los botones que los tours señalan. Viven en HomeShell y se
/// pasan a las pantallas que los tienen, para poder medir su rectángulo.
class TourKeys {
  final editarInicio = GlobalKey();
  final ajustesIdioma = GlobalKey();
  final ajustesFondo = GlobalKey();
}

/// Un tour con nombre, para el menú de guías ("?").
class Tour {
  final String id;
  final String Function(AppLocalizations t) name;
  final List<TourStep> Function(AppLocalizations t, TourKeys keys) build;

  const Tour({required this.id, required this.name, required this.build});
}

// Índices de PANTALLA (el IndexedStack de main): Home 0, Colección 1, Álbum 2,
// Forge 3, Mazos 4, Mercado 5, Ajustes 6. "Escanear" NO es pantalla: se empuja.
const int _home = 0;
const int _ajustes = 6;

// Índices en la BARRA de abajo (para señalar un destino por fracción):
// Inicio 0, Colección 1, Álbum 2, Escanear 3, Forge 4, Mazos 5, Mercado 6,
// Ajustes 7.
const int _barColeccion = 1;
const int _barScan = 3;
const int _barForge = 4;
const int _barMazos = 5;

/// El catálogo de tours. El primero ('welcome') es el del primer arranque.
final List<Tour> kTours = [
  Tour(
    id: 'welcome',
    name: (t) => t.tourWelcomeName,
    build: (t, k) => [
      TourStep(
          goToScreen: _home,
          targetKey: k.editarInicio,
          title: t.onbEditHomeTitle,
          body: t.onbEditHomeBody),
      TourStep(
          navBarIndex: _barColeccion,
          title: t.onbCollectionTitle,
          body: t.onbCollectionBody),
      TourStep(
          navBarIndex: _barScan,
          title: t.onbScanTitle,
          body: t.onbScanBody),
      TourStep(
          navBarIndex: _barForge,
          title: t.onbForgeTitle,
          body: t.onbForgeBody),
      TourStep(
          navBarIndex: _barMazos,
          title: t.onbDecksTitle,
          body: t.onbDecksBody),
    ],
  ),
  Tour(
    id: 'home',
    name: (t) => t.tourHomeName,
    build: (t, k) => [
      TourStep(
          goToScreen: _home,
          targetKey: k.editarInicio,
          title: t.onbEditHomeTitle,
          body: t.onbEditHomeBody),
    ],
  ),
  Tour(
    id: 'settings',
    name: (t) => t.tourSettingsName,
    build: (t, k) => [
      TourStep(
          goToScreen: _ajustes,
          targetKey: k.ajustesIdioma,
          title: t.onbLangTitle,
          body: t.onbLangBody),
      TourStep(
          goToScreen: _ajustes,
          targetKey: k.ajustesFondo,
          title: t.onbLookTitle,
          body: t.onbLookBody),
    ],
  ),
];
