import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/app_localizations.dart';
import 'l10n/t.dart';
import 'screens/logros_screen.dart';
import 'screens/screens.dart';
import 'services/achievement_store.dart';
import 'services/app_update.dart';
import 'services/achievements_controller.dart';
import 'services/backup.dart';
import 'services/background_prefs.dart';
import 'services/card_database.dart';
import 'services/certificate_store.dart';
import 'services/collection_store.dart';
import 'services/language_prefs.dart';
import 'services/market_prefs.dart';
import 'services/deck_store.dart';
import 'services/onboarding_prefs.dart';
import 'services/folder_store.dart';
import 'services/home_layout_prefs.dart';
import 'services/markets.dart';
import 'services/price_history.dart';
import 'services/price_series_database.dart';
import 'services/restore_reset.dart';
import 'services/scanner_database.dart';
import 'services/window_memory.dart';
import 'services/window_prefs.dart';
import 'services/wishlist_store.dart';
import 'theme/mf_theme.dart';
import 'widgets/app_background.dart';
import 'widgets/app_shortcuts.dart';
import 'widgets/language_picker_dialog.dart';
import 'widgets/onboarding_coachmarks.dart';
import 'widgets/whats_new_dialog.dart';

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

  const ManaForgeApp({super.key, this.background, this.language});

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
                  child: child ?? const SizedBox.shrink()),
            ),
          ),
          home: HomeShell(
            key: ValueKey(_session),
            background: _background,
            language: _language,
            onRestored: () {
              // los dos almacenes compartidos NO se recrean con la app: si no
              // se vacían aquí, siguen con lo de antes en memoria y lo
              // reescriben encima de lo que se acaba de restaurar
              resetSharedStores();
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

  const HomeShell(
      {super.key,
      required this.onRestored,
      required this.background,
      required this.language});

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
  final _collection = CollectionStore();
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
      await _collection.load();
      if (!mounted) return;
      // primero el idioma (es CÓMO se lee todo lo demás), y solo la primera
      // vez; después se cambia en Ajustes
      await maybeAskLanguage(context, widget.language);
      if (!mounted) return;
      await maybeShowWhatsNew(context,
          checker: _updates,
          hasExistingData: _collection.totalCopies > 0);
      if (!mounted) return;
      // y el tour de bienvenida, DESPUÉS de idioma y novedades para no
      // amontonar cosas encima. Solo la primera vez.
      await _onboarding.load();
      if (mounted) setState(() {});
    });
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
            db: _db, prices: _prices, scanner: _scanner),
        collection: _collection,
        onReady: () => setState(() => _started = true),
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
          onGoToTab: (i) => setState(() => _index = i)),
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
          onScan: _abrirEscaner),
      AlbumScreen(
          db: _db,
          collection: _collection,
          market: _market,
          prices: _prices,
          search: _search,
          tabIndex: 2),
      ForgeScreen(db: _db, collection: _collection, decks: _decks),
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
          market: _market),
      AjustesScreen(
          db: _db,
          onRestored: widget.onRestored,
          updates: _updates,
          background: widget.background,
          language: widget.language,
          homeLayout: _homeLayout),
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
    // el tour de bienvenida, la primera vez: burbujas sobre la barra. Los
    // índices son POSICIONES en la barra (0 = Inicio): colección, escanear,
    // forge, mazos.
    final mostrarTour = _onboarding.cargado && !_onboarding.seen;
    final tour = [
      CoachStep(
          barIndex: 1,
          title: t.onbCollectionTitle,
          body: t.onbCollectionBody),
      CoachStep(barIndex: 3, title: t.onbScanTitle, body: t.onbScanBody),
      CoachStep(barIndex: 4, title: t.onbForgeTitle, body: t.onbForgeBody),
      CoachStep(barIndex: 5, title: t.onbDecksTitle, body: t.onbDecksBody),
    ];

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
        child: Stack(
          children: [
            Scaffold(
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
            if (mostrarTour)
              Positioned.fill(
                child: OnboardingCoachmarks(
                  steps: tour,
                  itemCount: destinos.length,
                  onDone: () {
                    _onboarding.markSeen();
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
