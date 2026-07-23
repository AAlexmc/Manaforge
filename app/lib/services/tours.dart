import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import '../widgets/tour_overlay.dart';

/// GlobalKeys de los botones que los tours señalan. Viven en HomeShell y se
/// pasan a las pantallas que los tienen, para poder medir su rectángulo.
class TourKeys {
  final editarInicio = GlobalKey();
  final homeNivel = GlobalKey();
  final logrosNivel = GlobalKey();
  final logrosCertificados = GlobalKey();
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
  final ajustesEditarInicio = GlobalKey();
  final ajustesDatos = GlobalKey();
  final ajustesBaseDatos = GlobalKey();
  final ajustesCopia = GlobalKey();
  final ajustesLaApp = GlobalKey();
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
  final Future<void> Function(TourPrep? prep) onPrepare;
  final VoidCallback onDone;

  const TourRequest({
    required this.id,
    required this.steps,
    required this.navItemCount,
    required this.onGoToScreen,
    required this.onPush,
    required this.onPrepare,
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
const int _barAlbum = 2;
const int _barScan = 3;
const int _barForge = 4;
const int _barMazos = 5;
const int _barMercado = 6;
const int _barAjustes = 7;

// Los pasos de cada pantalla, en funciones sueltas: el gran tour y el tour por
// tema enseñan EXACTAMENTE los mismos, así arreglar un texto o mover una diana
// vale para los dos y no se van separando con el tiempo.
//
// REGLA (pedida por Ale): primero se SEÑALA el botón que lleva a un sitio y se
// dice que hay que pulsarlo, y solo en el paso siguiente se abre. Nada de
// aparecer ya dentro de una pantalla sin haber enseñado por dónde se llega.

/// "Pulsa aquí para abrir X" sobre el destino X de la barra de abajo.
TourStep _pasoBarra(AppLocalizations t, int barra, String nombre) => TourStep(
      navBarIndex: barra,
      title: nombre,
      body: t.onbTapHere(nombre),
    );

List<TourStep> _pasosInicio(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _home,
          targetKey: k.editarInicio,
          title: t.onbEditHomeTitle,
          body: t.onbEditHomeBody),
    ];

// Logros y Certificados NO son pestañas: se empujan. Se enseña primero la
// puerta (la tarjeta de nivel de Inicio, el botón de Certificados dentro de
// Logros) y después se abre.
List<TourStep> _pasosLogros(AppLocalizations t, TourKeys k) => [
      TourStep(
          goToScreen: _home,
          targetKey: k.homeNivel,
          title: t.onbAchievementsName,
          body: t.onbTapHere(t.onbAchievementsName)),
      TourStep(
          goToScreen: _home,
          push: TourPush.logros,
          targetKey: k.logrosNivel,
          title: t.onbAchievementsTitle,
          body: t.onbAchievementsBody),
      TourStep(
          goToScreen: _home,
          push: TourPush.logros,
          targetKey: k.logrosCertificados,
          title: t.onbCertificatesTitle,
          body: t.onbTapHere(t.onbCertificatesTitle)),
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
      TourStep(
          goToScreen: _ajustes,
          targetKey: k.ajustesEditarInicio,
          title: t.onbEditHomeTitle,
          body: t.onbEditHomeBody),
      // "Datos" y "La app" nacen plegadas: el paso las despliega (prepare) y
      // solo entonces se puede medir lo que hay dentro
      TourStep(
          goToScreen: _ajustes,
          prepare: TourPrep.ajustesDatos,
          targetKey: k.ajustesDatos,
          title: t.onbDataSectionTitle,
          body: t.onbDataSectionBody),
      TourStep(
          goToScreen: _ajustes,
          prepare: TourPrep.ajustesDatos,
          targetKey: k.ajustesBaseDatos,
          title: t.onbCardDbTitle,
          body: t.onbCardDbBody),
      TourStep(
          goToScreen: _ajustes,
          prepare: TourPrep.ajustesDatos,
          targetKey: k.ajustesCopia,
          title: t.onbBackupTitle,
          body: t.onbBackupBody),
      TourStep(
          goToScreen: _ajustes,
          prepare: TourPrep.ajustesLaApp,
          targetKey: k.ajustesLaApp,
          title: t.onbAboutTitle,
          body: t.onbAboutBody),
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
  // La vuelta completa: antes de cada pantalla, el botón que la abre. Escanear
  // se queda en "mira este botón": abrirlo encendería la cámara en mitad del
  // tour.
  Tour(
    id: 'full',
    name: (t) => t.tourFullName,
    build: (t, k) => [
      ..._pasosInicio(t, k),
      ..._pasosLogros(t, k),
      _pasoBarra(t, _barColeccion, t.tabCollection),
      ..._pasosColeccion(t, k),
      _pasoBarra(t, _barAlbum, t.tabAlbum),
      ..._pasosAlbum(t, k),
      TourStep(
          navBarIndex: _barScan, title: t.onbScanTitle, body: t.onbScanBody),
      _pasoBarra(t, _barForge, t.tabForge),
      ..._pasosForge(t, k),
      _pasoBarra(t, _barMazos, t.tabDecks),
      TourStep(
          goToScreen: _mazos, title: t.onbDecksTitle, body: t.onbDecksBody),
      _pasoBarra(t, _barMercado, t.tabMarket),
      ..._pasosMercado(t, k),
      _pasoBarra(t, _barAjustes, t.tabSettings),
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
    build: (t, k) => [
      _pasoBarra(t, _barColeccion, t.tabCollection),
      ..._pasosColeccion(t, k),
      _pasoBarra(t, _barAlbum, t.tabAlbum),
      ..._pasosAlbum(t, k),
    ],
  ),
  Tour(
    id: 'forge',
    name: (t) => t.tourForgeName,
    build: (t, k) => [
      _pasoBarra(t, _barForge, t.tabForge),
      ..._pasosForge(t, k),
    ],
  ),
  Tour(
    id: 'market',
    name: (t) => t.tourMarketName,
    build: (t, k) => [
      _pasoBarra(t, _barMercado, t.tabMarket),
      ..._pasosMercado(t, k),
    ],
  ),
  Tour(
    id: 'settings',
    name: (t) => t.tourSettingsName,
    build: (t, k) => [
      _pasoBarra(t, _barAjustes, t.tabSettings),
      ..._pasosAjustes(t, k),
    ],
  ),
];
