import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/screens/certificados_screen.dart';
import 'package:manaforge_app/screens/logros_screen.dart';
import 'package:manaforge_app/screens/screens.dart';
import 'package:manaforge_app/services/achievement_store.dart';
import 'package:manaforge_app/services/app_update.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/services/backup.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/certificate_store.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/language_prefs.dart';
import 'package:manaforge_app/services/market_prefs.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/services/factory_reset.dart';
import 'package:manaforge_app/services/onboarding_prefs.dart';
import 'package:manaforge_app/ui/core/tours/tours.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/services/home_layout_prefs.dart';
import 'package:manaforge_app/services/markets.dart';
import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/services/price_series_database.dart';
import 'package:manaforge_app/services/restore_reset.dart';
import 'package:manaforge_app/services/scanner_database.dart';
import 'package:manaforge_app/services/window_memory.dart';
import 'package:manaforge_app/services/window_prefs.dart';
import 'package:manaforge_app/services/wishlist_store.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';
import 'package:manaforge_app/ui/core/widgets/app_background.dart';
import 'package:manaforge_app/ui/core/widgets/app_shortcuts.dart';
import 'package:manaforge_app/ui/settings/widgets/language_picker_dialog.dart';
import 'package:manaforge_app/ui/core/tours/tour_overlay.dart';
import 'package:manaforge_app/ui/core/widgets/whats_new_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // datos de fechas para todos los idiomas: los certificados escriben la fecha
  // en el idioma de la app (intl DateFormat) y sin esto reventaría en un
  // idioma cuyos símbolos no estén cargados
  await initializeDateFormatting();
  // la ventana se coloca ANTES de pintar nada: colocarla después es un salto
  // en la cara. Si algo falla, abre con la de siempre (ver WindowMemory)
  await WindowMemory(WindowPreference()).start();
  runApp(const ManaForgeApp());
}

class ManaForgeApp extends StatefulWidget {
  /// Solo para tests: preferencias YA cargadas.
  ///
  /// El reloj falso de `testWidgets` no hace avanzar el canal de plataforma
  /// (`path_provider`), así que una carga que empiece DENTRO del test no
  /// termina nunca. El test las carga antes con `runAsync` y las pasa hechas.
  final BackgroundPreference? background;
  final LanguagePreference? language;

  /// Solo para tests: colección YA cargada (mismo motivo que arriba —
  /// `getApplicationSupportDirectory` no completa en el reloj falso, así que
  /// el `load()` que lanza `HomeShell` internamente no termina nunca si el
  /// test no la precarga con `runAsync` y la pasa hecha).
  final CollectionStore? collection;

  const ManaForgeApp(
      {super.key, this.background, this.language, this.collection});

  @override
  State<ManaForgeApp> createState() => _ManaForgeAppState();
}

class _ManaForgeAppState extends State<ManaForgeApp> {
  /// Sube al restaurar una copia. Cambia la Key de `HomeShell`, así que
  /// Flutter tira su State y construye otro: los almacenes se crean de cero y
  /// releen el disco nuevo. Más simple y más difícil de romper que inventar
  /// un `reload()` en cada uno de los diez.
  int _session = 0;

  /// Fondo de pantalla elegido por el usuario. Vive aquí arriba porque tiene
  /// que pintarse DETRÁS de todas las pantallas.
  late final BackgroundPreference _background =
      widget.background ?? BackgroundPreference();

  /// Para poder cerrar con Escape desde encima del navegador.
  final _navigator = GlobalKey<NavigatorState>();

  /// En qué idioma se ve todo. Por defecto, el del sistema.
  late final LanguagePreference _language =
      widget.language ?? LanguagePreference();

  /// El tour que se está enseñando, si hay. Vive AQUÍ ARRIBA y no en
  /// HomeShell porque se pinta en el `builder` del MaterialApp, que envuelve
  /// al Navigator entero: así el tour tapa y explica también las pantallas
  /// empujadas (Logros, Certificados), que se dibujan encima de HomeShell.
  final ValueNotifier<TourRequest?> _tour = ValueNotifier(null);

  @override
  void dispose() {
    _tour.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_background.load());
    unawaited(_language.load());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_background, _language]),
      builder: (context, _) {
        // con fondo puesto, las pantallas dejan de pintar su color opaco y
        // las tarjetas y la letra pueden llevar el color que se haya elegido
        // en Ajustes (ver `mfThemeSobreFondo`)
        ThemeData conFondo(Brightness brillo) {
          final base = mfTheme(brillo);
          return _background.hasImage
              ? mfThemeSobreFondo(base,
                  card: _background.cardColor,
                  text: _background.textColor,
                  chip: _background.chipColor,
                  icon: _background.iconColor,
                  cardOpacity: _background.cardOpacity)
              : base;
        }

        return MaterialApp(
          navigatorKey: _navigator,
          title: 'ManaForge',
          locale: _language.locale, // null = el del sistema
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: conFondo(Brightness.light),
          darkTheme: conFondo(Brightness.dark),
          themeMode: ThemeMode.dark, // oscuro por defecto (decisión de diseño)
          builder: (context, child) => CallbackShortcuts(
            // Escape cierra fichas y detalles empujados con push: los
            // diálogos ya se cierran solos, las pantallas no
            bindings: escapeCloses(_navigator),
            // el Focus es lo que hace que la tecla llegue: sin un nodo
            // enfocado dentro, el atajo no se dispara nunca
            child: Focus(
              autofocus: true,
              child: AppBackground(
                prefs: _background,
                child: ValueListenableBuilder<TourRequest?>(
                  valueListenable: _tour,
                  // el Navigator entero entra como `child`: no se reconstruye
                  // porque empiece o termine un tour
                  child: child ?? const SizedBox.shrink(),
                  builder: (context, tour, navegador) => Stack(
                    children: [
                      navegador!,
                      if (tour != null)
                        Positioned.fill(
                          child: TourOverlay(
                            // key por tour: al cambiar de tour, empieza del 1
                            key: ValueKey(tour.tour.id),
                            // los pasos se construyen AQUÍ, con el idioma de
                            // ahora: cambiarlo a media guía cambia las
                            // burbujas sin salir del paso en el que estás
                            steps: tour.tour.build(tr(context), tour.keys),
                            navItemCount: tour.navItemCount,
                            onGoToScreen: tour.onGoToScreen,
                            onPush: tour.onPush,
                            onPrepare: tour.onPrepare,
                            onDone: tour.onDone,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          home: HomeShell(
            key: ValueKey(_session),
            background: _background,
            language: _language,
            collection: widget.collection,
            tour: _tour,
            onRestored: () {
              // los dos almacenes compartidos NO se recrean con la app: si no
              // se vacían aquí, siguen con lo de antes en memoria y lo
              // reescriben encima de lo que se acaba de restaurar
              resetSharedStores();
              // y si había un tour, se cae con el HomeShell que lo lanzó: sus
              // botones apuntarían a una pantalla que ya no existe
              _tour.value = null;
              setState(() => _session++);
            },
          ),
        );
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  /// Se ha restaurado una copia: la app entera vuelve a empezar.
  final VoidCallback onRestored;

  /// Fondo de pantalla, para poder cambiarlo desde Ajustes.
  final BackgroundPreference background;

  /// Idioma, por lo mismo.
  final LanguagePreference language;

  /// Solo para tests: colección YA cargada (ver `ManaForgeApp.collection`).
  final CollectionStore? collection;

  /// Dónde se deja el tour que hay que enseñar. Lo pinta el `builder` del
  /// MaterialApp, por encima del Navigator (ver `_ManaForgeAppState._tour`).
  final ValueNotifier<TourRequest?> tour;

  const HomeShell(
      {super.key,
      required this.onRestored,
      required this.background,
      required this.language,
      this.collection,
      required this.tour});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  /// La barra de abajo, en orden. "Escanear" NO es una pestaña: abre el
  /// escáner y vuelve. Su sitio se saca de ESTA lista y no se escribe a mano
  /// en ningún otro lado — escribirlo a mano ya salió mal una vez (Escanear
  /// abría Mazos y Mazos abría el escáner).
  /// Las pestañas. Se construyen con el contexto porque sus nombres están
  /// traducidos: una lista `const` no puede saber en qué idioma estás.
  List<NavigationDestination> _destinos(AppLocalizations t) => [
        NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: t.tabHome),
        NavigationDestination(
            icon: const Icon(Icons.style_outlined),
            selectedIcon: const Icon(Icons.style),
            label: t.tabCollection),
        NavigationDestination(
            icon: const Icon(Icons.auto_stories_outlined),
            selectedIcon: const Icon(Icons.auto_stories),
            label: t.tabAlbum),
        NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner, color: MFColors.manaRed),
            selectedIcon:
                const Icon(Icons.qr_code_scanner, color: MFColors.manaRed),
            label: t.tabScan),
        const NavigationDestination(
            icon: ForgeTabIcon(selected: false),
            selectedIcon: ForgeTabIcon(selected: true),
            label: 'Forge'),
        NavigationDestination(
            icon: const Icon(Icons.layers_outlined),
            selectedIcon: const Icon(Icons.layers),
            label: t.tabDecks),
        NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront),
            label: t.tabMarket),
        NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: t.tabSettings),
      ];

  /// Dónde está "Escanear" dentro de la barra. Es una POSICIÓN, no un
  /// nombre: buscarlo por su texto se rompía en cuanto el texto cambiaba de
  /// idioma.
  static const int _escanear = 3;

  int _index = 0;

  /// El proveedor de series base que enchufa ESTA instancia, para no anular en
  /// dispose el que haya puesto otra posterior.
  Future<Map<String, List<PricePoint>>> Function(Iterable<String>, Market)?
      _seriesProvider;

  bool _started = false; // false = pantalla de arranque (puesta al día)
  final _db = CardDatabase();
  late final _collection = widget.collection ?? CollectionStore();
  final _decks = DeckStore();
  final _folders = FolderStore();
  final _scanner = ScannerDatabase();
  final _wishlist = WishlistStore();
  final _prices = PriceSeriesDatabase();
  final _market = MarketPreference();
  final _progress = AchievementStore();
  final _certificates = CertificateStore();

  /// Qué se ve en Inicio y en qué orden. Lo comparten Inicio (que lo pinta) y
  /// Ajustes (que abre el editor): el mismo objeto, para que editar desde un
  /// sitio se vea en el otro.
  final _homeLayout = HomeLayoutPreference();

  /// Mira una vez al día si hay versión nueva de la app. No descarga nada:
  /// avisa y lleva a la página de descargas.
  final _updates = AppUpdateChecker();

  /// Ctrl+F: aviso de "quiero buscar" para la pestaña que esté delante.
  final _search = SearchFocusBus();

  /// Si ya se vio el tour de bienvenida (las burbujas sobre la barra).
  final _onboarding = OnboardingPreference();

  /// La bienvenida (idioma → novedades → tour) tocaba correr mientras
  /// `StartupScreen` seguía delante (`!_started`): diálogos pintados sobre
  /// la descarga y burbujas señalando huecos de una pantalla que el usuario
  /// aún no ve. Se pospone entera hasta que `onReady` deja pasar.
  bool _bienvenidaPendiente = false;

  /// GlobalKeys de los botones que los tours señalan.
  final _tourKeys = TourKeys();

  /// La pantalla empujada que ha abierto el tour (Logros, Certificados) y
  /// cuál es, para cerrarla al pasar de paso y no apilar pantallas.
  Route<void>? _rutaTour;
  TourPush? _rutaTourCual;

  /// Mandos de las secciones plegadas de Ajustes: el tour las abre antes de
  /// señalar lo que vive dentro (la base de cartas, la copia, los créditos).
  final _seccionDatos = ExpansibleController();
  final _seccionLaApp = ExpansibleController();
  late final AchievementsController _achievements = AchievementsController(
    db: _db,
    collection: _collection,
    decks: _decks,
    folders: _folders,
    wishlist: _wishlist,
    progress: _progress,
  );

  @override
  void initState() {
    super.initState();
    // el historial local se apoya en los ~90 días reales de Cardmarket que
    // trae la base descargable (si el usuario la ha traído)
    _seriesProvider =
        (ids, market) => _prices.seriesFor(ids, market: market);
    priceHistoryStore.baseSeriesProvider = _seriesProvider;
    _achievements.addListener(_onAchievements);
    // los logros necesitan lo que hay guardado antes de evaluar nada
    _progress.load().then((_) {
      _achievements.markActive(); // un día más de racha
    });
    // red de seguridad semanal, en segundo plano: si algo falla (disco lleno,
    // permisos), la app arranca igual — una copia que no sale no es motivo
    // para no dejarte entrar
    unawaited(_autoBackup());
    // ¿hay versión nueva? Como mucho una pregunta al día, en segundo plano y
    // sin ruido: si no hay red, no pasa nada
    unawaited(_updates.checkIfDue());
    // qué se ve en Inicio: se lee del disco en segundo plano; hasta que llega,
    // el layout por defecto (todo, en orden) ya está puesto
    unawaited(_homeLayout.load());
    // y si el que ha cambiado es ESTE ejecutable, contar qué trae. Después
    // del primer frame: antes no hay ni Navigator donde enseñarlo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // un fallo de disco al leer la colección no puede llevarse por delante
      // el diálogo de idioma, las novedades y el tour: sin colección se sigue
      await _collection.load().catchError((_) {});
      if (!mounted) return;
      if (_started) {
        // mismo frame de cortesía que el camino de onReady: que Inicio y su
        // barra hagan layout antes de diálogos y de medir burbujas
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_bienvenida());
        });
      } else {
        // `StartupScreen` sigue delante (el primer arranque descarga
        // MINUTOS): idioma, novedades y tour se aplazan enteros y `onReady`
        // los dispara al entrar de verdad. Antes salían pintados encima de
        // la descarga, y las novedades se daban por vistas con la colección
        // aún vacía — gastadas para siempre para quien venía de 0.2.0
        _bienvenidaPendiente = true;
      }
    });
  }

  /// Idioma → novedades → tour de bienvenida, en ese orden (el idioma es
  /// CÓMO se lee todo lo demás; el tour va el último para no amontonar).
  /// Solo se llama con la app de verdad delante (`_started`).
  Future<void> _bienvenida() async {
    if (!mounted) return;
    await maybeAskLanguage(context, widget.language);
    if (!mounted) return;
    await maybeShowWhatsNew(context,
        checker: _updates, hasExistingData: _collection.totalCopies > 0);
    if (!mounted) return;
    await _onboarding.load();
    if (!mounted || _onboarding.seen) return;
    // la vuelta completa, no las 5 burbujas: pedido expreso (27-07)
    _lanzarTour(kTourPrimerArranque);
  }

  @override
  void dispose() {
    // solo si sigue siendo el NUESTRO: al restaurar, el HomeShell nuevo nace
    // antes de que este muera, así que anular a ciegas dejaba la app recién
    // reconstruida sin los 90 días de Cardmarket hasta reiniciarla
    if (identical(priceHistoryStore.baseSeriesProvider, _seriesProvider)) {
      priceHistoryStore.baseSeriesProvider = null;
    }
    _achievements.removeListener(_onAchievements);
    _achievements.dispose();
    _prices.close();
    super.dispose();
  }

  Future<void> _autoBackup() async {
    try {
      await autoBackupIfStale(await getApplicationSupportDirectory());
    } catch (_) {/* sin copia automática esta vez; se reintenta al siguiente
      arranque */}
  }

  /// Reset de fábrica: copia previa, cerrar los sqlite (en Windows un handle
  /// abierto bloquea el borrado), limpiar el fondo (en memoria y sus ficheros,
  /// ANTES del barrido para que no re-escriba nada después) y barrer. Toda la
  /// orquestación (incluido el reintento si algo queda `failed`) vive en
  /// `factoryReset` (services/factory_reset.dart), testeable sin UI. El
  /// session bump lo dispara la tarjeta vía onDone al terminar.
  Future<FactoryResetReport> _factoryReset() async {
    final dir = await getApplicationSupportDirectory();
    return factoryReset(
      dir,
      closeDbs: () {
        _db.close();
        _prices.close();
      },
      clearBackground: () => widget.background.resetAll(),
    );
  }

  /// Abre el escáner en vivo. Vive en la barra de abajo, no dentro de
  /// Colección: es la acción que más se usa de toda la app.
  void _abrirEscaner() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LiveScanScreen(
        db: _db,
        collection: _collection,
        scanner: _scanner,
        achievements: _achievements,
        folders: _folders,
      ),
    ));
  }

  /// El menú de guías (botón "?" de Inicio): elige un tour y lo lanza.
  Future<void> _menuTours() async {
    final t = tr(context);
    final elegido = await showModalBottomSheet<Tour>(
      context: context,
      builder: (ctx) => SafeArea(
        // lista con scroll y no Column: la hoja no puede pasar de 9/16 de la
        // pantalla, y con cada tour nuevo la lista crece — en una ventana
        // pequeña los últimos quedaban FUERA, dibujados donde no se pueden
        // ni ver ni tocar
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(t.tourMenuTitle,
                  style: Theme.of(ctx).textTheme.titleMedium),
            ),
            for (final tour in kTours)
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(tour.name(t)),
                onTap: () => Navigator.of(ctx).pop(tour),
              ),
          ],
        ),
      ),
    );
    if (elegido != null && mounted) {
      _lanzarTour(elegido);
    }
  }

  /// Deja el tour donde lo pinta la app (por encima del Navigator) con todo
  /// lo que necesita: los pasos ya construidos con las keys de esta pantalla y
  /// qué hacer al cambiar de pestaña, al abrir una pantalla o al terminar.
  void _lanzarTour(Tour tour) {
    widget.tour.value = TourRequest(
      tour: tour,
      keys: _tourKeys,
      navItemCount: _destinos(tr(context)).length,
      onGoToScreen: (s) {
        if (mounted) setState(() => _index = s);
      },
      onPush: _rutaDelTour,
      onPrepare: _prepararPaso,
      onDone: () {
        _rutaDelTour(null);
        _onboarding.markSeen();
        widget.tour.value = null;
      },
    );
  }

  /// Deja listo lo que pide el paso antes de que el tour mida su diana.
  Future<void> _prepararPaso(TourPrep? prep) async {
    if (prep == null) return;
    final seccion = switch (prep) {
      TourPrep.ajustesDatos => _seccionDatos,
      TourPrep.ajustesLaApp => _seccionLaApp,
    };
    try {
      if (seccion.isExpanded) return; // ya abierta: ni animación que esperar
      seccion.expand();
    } catch (_) {
      // la sección aún no está construida (lista perezosa): el paso sale sin
      // diana, que es mejor que reventar
      return;
    }
    // la sección se abre con animación: medir antes daría un rectángulo a
    // medio crecer
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  /// Abre la pantalla empujada que pide el paso, o cierra la que hubiera
  /// (null). Las pantallas empujadas no son pestañas: el IndexedStack no las
  /// tiene, así que el tour las abre y las cierra él.
  void _rutaDelTour(TourPush? cual) {
    if (!mounted || cual == _rutaTourCual) return;
    final nav = Navigator.of(context);
    final abierta = _rutaTour;
    _rutaTour = null;
    _rutaTourCual = null;
    // sin animación de vuelta: el tour ya está pintado encima y el usuario
    // no ha pedido "atrás", solo ha pasado de paso
    if (abierta != null) nav.removeRoute(abierta);
    if (cual == null) return;
    final ruta = MaterialPageRoute<void>(
      builder: (_) => switch (cual) {
        // las keys SOLO van en la pantalla que abre el tour: la que abre el
        // usuario desde Inicio no las lleva, y así nunca hay dos GlobalKey
        // iguales montadas a la vez
        TourPush.logros => LogrosScreen(
            achievements: _achievements,
            db: _db,
            collection: _collection,
            certificates: _certificates,
            nivelKey: _tourKeys.logrosNivel,
            certificadosKey: _tourKeys.logrosCertificados),
        TourPush.certificados => CertificadosScreen(
            db: _db, collection: _collection, certificates: _certificates),
        // entrar aquí ENCIENDE la cámara, igual que si lo abriera el usuario:
        // el tour enseña los mandos de arriba sobre el escáner de verdad
        TourPush.escaner => LiveScanScreen(
            db: _db,
            collection: _collection,
            scanner: _scanner,
            achievements: _achievements,
            folders: _folders,
            setKey: _tourKeys.escanerSet,
            modoKey: _tourKeys.escanerModo,
            fotoKey: _tourKeys.escanerFoto),
      },
    );
    _rutaTour = ruta;
    _rutaTourCual = cual;
    // si la cierra el usuario (Escape, atrás), que no quede apuntada: cerrarla
    // otra vez reventaría
    ruta.popped.whenComplete(() {
      if (identical(_rutaTour, ruta)) {
        _rutaTour = null;
        _rutaTourCual = null;
      }
    });
    nav.push(ruta);
  }

  /// Avisa de los logros nuevos caigan donde caigan (escáner, importador,
  /// carpetas…): el aviso sale sobre la pestaña en la que estés.
  void _onAchievements() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showAchievementToasts(context, _achievements);
      if (_achievements.leveledUp) {
        showLevelUpDialog(context, _achievements);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return StartupScreen(
        sources: defaultUpdateSources(
            t: tr(context), db: _db, prices: _prices, scanner: _scanner),
        collection: _collection,
        onReady: () {
          setState(() => _started = true);
          if (_bienvenidaPendiente) {
            _bienvenidaPendiente = false;
            // un frame para que se pinte la app de verdad (Inicio y su
            // barra) antes de los diálogos y de medir dónde van las burbujas
            WidgetsBinding.instance.addPostFrameCallback((_) {
              unawaited(_bienvenida());
            });
          }
        },
      );
    }
    final screens = [
      HomeScreen(
          db: _db,
          collection: _collection,
          decks: _decks,
          achievements: _achievements,
          certificates: _certificates,
          updates: _updates,
          layout: _homeLayout,
          onScan: _abrirEscaner,
          onGoToTab: (i) => setState(() => _index = i),
          editarInicioKey: _tourKeys.editarInicio,
          nivelKey: _tourKeys.homeNivel,
          onHelp: _menuTours),
      ColeccionScreen(
          db: _db,
          collection: _collection,
          scanner: _scanner,
          folders: _folders,
          achievements: _achievements,
          market: _market,
          prices: _prices,
          search: _search,
          tabIndex: 1,
          onScan: _abrirEscaner,
          todasKey: _tourKeys.coleccionTodas,
          carpetasKey: _tourKeys.coleccionCarpetas),
      AlbumScreen(
          db: _db,
          collection: _collection,
          market: _market,
          prices: _prices,
          search: _search,
          tabIndex: 2,
          miasKey: _tourKeys.albumMias),
      ForgeScreen(
          db: _db,
          collection: _collection,
          decks: _decks,
          basicasKey: _tourKeys.forgeBasicas,
          expansionesKey: _tourKeys.forgeExpansiones,
          queNoTengoKey: _tourKeys.forgeQueNoTengo,
          deepForgeKey: _tourKeys.forgeDeepForge,
          forjarKey: _tourKeys.forgeForjar,
          modoTestKey: _tourKeys.forgeModoTest),
      MazosScreen(
          db: _db,
          collection: _collection,
          decks: _decks,
          onGoToForge: () => setState(() => _index = 3)),
      MercadoScreen(
          db: _db,
          collection: _collection,
          wishlist: _wishlist,
          prices: _prices,
          market: _market,
          selectorKey: _tourKeys.mercadoSelector,
          wishlistKey: _tourKeys.mercadoWishlist,
          buscarKey: _tourKeys.mercadoBuscar),
      AjustesScreen(
          db: _db,
          onRestored: widget.onRestored,
          onFactoryReset: _factoryReset,
          updates: _updates,
          background: widget.background,
          language: widget.language,
          homeLayout: _homeLayout,
          idiomaKey: _tourKeys.ajustesIdioma,
          fondoKey: _tourKeys.ajustesFondo,
          copiaKey: _tourKeys.ajustesCopia,
          datosController: _seccionDatos,
          editarInicioKey: _tourKeys.ajustesEditarInicio,
          datosKey: _tourKeys.ajustesDatos,
          baseDatosKey: _tourKeys.ajustesBaseDatos,
          laAppKey: _tourKeys.ajustesLaApp,
          laAppController: _seccionLaApp,
          comoFuncionaKey: _tourKeys.ajustesComoFunciona,
          versionKey: _tourKeys.ajustesVersion,
          sugerenciasKey: _tourKeys.ajustesSugerencias,
          apoyarKey: _tourKeys.ajustesApoyar),
    ];
    // "Escanear" va EN la barra, en el centro: es lo que más se usa y estaba
    // suelto en una esquina de una sola pantalla. No es una pestaña —abre el
    // escáner y vuelve— así que el índice de la barra no es el de la pantalla.
    int barraDePantalla(int pantalla) =>
        pantalla < _escanear ? pantalla : pantalla + 1;
    int pantallaDeBarra(int barra) =>
        barra < _escanear ? barra : barra - 1;

    final t = tr(context);
    final destinos = _destinos(t);

    return CallbackShortcuts(
      bindings: mainShortcuts(
        screenCount: screens.length,
        onTab: (i) => setState(() => _index = i),
        onScan: _abrirEscaner,
        // Ctrl+F no sabe cómo busca cada pantalla: avisa a la que esté
        // delante y que se apañe (el Álbum enfoca su buscador, Colección
        // abre "Todas las cartas", que es donde se busca de verdad)
        onSearch: () => _search.request(_index),
        onSettings: () => setState(() => _index = screens.length - 1),
      ),
      child: Focus(
        autofocus: true,
        // el tour NO se pinta aquí: lo pinta el builder del MaterialApp, por
        // encima del Navigator, para que tape también lo que se empuja
        child: Scaffold(
          body: IndexedStack(index: _index, children: screens),
          bottomNavigationBar: NavigationBar(
            selectedIndex: barraDePantalla(_index),
            onDestinationSelected: (i) {
              if (i == _escanear) {
                _abrirEscaner();
                return;
              }
              setState(() => _index = pantallaDeBarra(i));
            },
            destinations: destinos,
          ),
        ),
      ),
    );
  }
}
