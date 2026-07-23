import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import '../widgets/tour_overlay.dart';

/// GlobalKeys de los botones que los tours señalan. Viven en HomeShell y se
/// pasan a las pantallas que los tienen, para poder medir su rectángulo.
class TourKeys {
  final editarInicio = GlobalKey();
  final coleccionTodas = GlobalKey();
  final coleccionCarpetas = GlobalKey();
  final albumMias = GlobalKey();
  final forgeBasicas = GlobalKey();
  final forgeExpansiones = GlobalKey();
  final forgeQueNoTengo = GlobalKey();
  final forgeForjar = GlobalKey();
  final forgeModoTest = GlobalKey();
  final mercadoSelector = GlobalKey();
  final mercadoWishlist = GlobalKey();
  final mercadoBuscar = GlobalKey();
  final ajustesIdioma = GlobalKey();
  final ajustesFondo = GlobalKey();
}

/// Lo que HomeShell le pide a la app para enseñar un tour.
///
/// El overlay NO puede vivir en el Stack de HomeShell: una pantalla empujada
/// (Logros, Certificados) se pinta por encima de él y taparía el tour. Lo
/// pinta `MaterialApp.builder`, que envuelve al Navigator entero, y HomeShell
/// —que es quien tiene las keys y sabe cambiar de pestaña— le pasa aquí los
/// pasos ya construidos y qué hacer en cada caso.
class TourRequest {
  /// Identidad del tour: cambiarla reinicia el recorrido desde el paso 1.
  final String id;
  final List<TourStep> steps;

  /// Cuántos destinos tiene la barra de abajo (foco por fracción del ancho).
  final int navItemCount;
  final void Function(int screen) onGoToScreen;
  final void Function(TourPush? push) onPush;
  final VoidCallback onDone;

  const TourRequest({
    required this.id,
    required this.steps,
    required this.navItemCount,
    required this.onGoToScreen,
    required this.onPush,
    required this.onDone,
  });
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
const int _coleccion = 1;
const int _album = 2;
const int _forge = 3;
const int _mazos = 4;
const int _mercado = 5;
const int _ajustes = 6;

// Índices en la BARRA de abajo (para señalar un destino por fracción):
// Inicio 0, Colección 1, Álbum 2, Escanear 3, Forge 4, Mazos 5, Mercado 6,
// Ajustes 7.
const int _barColeccion = 1;
const int _barScan = 3;
const int _barForge = 4;
const int _barMazos = 5;

// Los pasos de cada pantalla, en funciones sueltas: el gran tour y el tour por
// tema enseñan EXACTAMENTE los mismos, así arreglar un texto o mover una diana
// vale para los dos y no se van separando con el tiempo.

List<TourStep> _pasosInicio(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _home,
          targetKey: k.editarInicio,
          title: t.onbEditHomeTitle,
          body: t.onbEditHomeBody),
    ];

// Logros y Certificados NO son pestañas: se empujan desde Inicio. El tour las
// abre él (push) y la burbuja va centrada: dentro de una pantalla empujada
// todavía no se señalan botones sueltos.
List<TourStep> _pasosLogros(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _home,
          push: TourPush.logros,
          title: t.onbAchievementsTitle,
          body: t.onbAchievementsBody),
      TourStep(
          goToScreen: _home,
          push: TourPush.certificados,
          title: t.onbCertificatesTitle,
          body: t.onbCertificatesBody),
    ];

List<TourStep> _pasosColeccion(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _coleccion,
          targetKey: k.coleccionTodas,
          title: t.onbAllCardsTitle,
          body: t.onbAllCardsBody),
      TourStep(
          goToScreen: _coleccion,
          targetKey: k.coleccionCarpetas,
          title: t.onbFoldersTitle,
          body: t.onbFoldersBody),
    ];

List<TourStep> _pasosAlbum(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _album,
          targetKey: k.albumMias,
          title: t.onbAlbumMineTitle,
          body: t.onbAlbumMineBody),
    ];

List<TourStep> _pasosForge(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _forge,
          targetKey: k.forgeBasicas,
          title: t.onbForgeBasicsTitle,
          body: t.onbForgeBasicsBody),
      TourStep(
          goToScreen: _forge,
          targetKey: k.forgeExpansiones,
          title: t.onbForgeSetsTitle,
          body: t.onbForgeSetsBody),
      TourStep(
          goToScreen: _forge,
          targetKey: k.forgeQueNoTengo,
          title: t.onbForgeMissingTitle,
          body: t.onbForgeMissingBody),
      TourStep(
          goToScreen: _forge,
          targetKey: k.forgeForjar,
          title: t.onbForgeGoTitle,
          body: t.onbForgeGoBody),
      TourStep(
          goToScreen: _forge,
          targetKey: k.forgeModoTest,
          title: t.onbForgeTestTitle,
          body: t.onbForgeTestBody),
    ];

List<TourStep> _pasosMercado(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _mercado,
          targetKey: k.mercadoSelector,
          title: t.onbMarketPickTitle,
          body: t.onbMarketPickBody),
      TourStep(
          goToScreen: _mercado,
          targetKey: k.mercadoWishlist,
          title: t.onbWishlistTitle,
          body: t.onbWishlistBody),
      TourStep(
          goToScreen: _mercado,
          targetKey: k.mercadoBuscar,
          title: t.onbPriceAlertTitle,
          body: t.onbPriceAlertBody),
    ];

List<TourStep> _pasosAjustes(AppLocalizations t, TourKeys k) => [
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
    ];

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
  // La vuelta completa: recorre las pantallas en el orden de la barra y va
  // señalando botón a botón. Escanear se señala EN la barra (no es pestaña: se
  // empuja, y el tour todavía no sabe conducir pantallas empujadas).
  Tour(
    id: 'full',
    name: (t) => t.tourFullName,
    build: (t, k) => [
      ..._pasosInicio(t, k),
      ..._pasosLogros(t, k),
      ..._pasosColeccion(t, k),
      ..._pasosAlbum(t, k),
      TourStep(
          navBarIndex: _barScan, title: t.onbScanTitle, body: t.onbScanBody),
      ..._pasosForge(t, k),
      TourStep(
          goToScreen: _mazos, title: t.onbDecksTitle, body: t.onbDecksBody),
      ..._pasosMercado(t, k),
      ..._pasosAjustes(t, k),
    ],
  ),
  Tour(
    id: 'home',
    name: (t) => t.tourHomeName,
    build: _pasosInicio,
  ),
  Tour(
    id: 'progress',
    name: (t) => t.tourProgressName,
    build: _pasosLogros,
  ),
  Tour(
    id: 'collection',
    name: (t) => t.tourCollectionName,
    build: (t, k) => [..._pasosColeccion(t, k), ..._pasosAlbum(t, k)],
  ),
  Tour(
    id: 'forge',
    name: (t) => t.tourForgeName,
    build: _pasosForge,
  ),
  Tour(
    id: 'market',
    name: (t) => t.tourMarketName,
    build: _pasosMercado,
  ),
  Tour(
    id: 'settings',
    name: (t) => t.tourSettingsName,
    build: _pasosAjustes,
  ),
];
