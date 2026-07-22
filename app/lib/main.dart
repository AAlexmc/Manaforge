import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/logros_screen.dart';
import 'screens/screens.dart';
import 'services/achievement_store.dart';
import 'services/achievements_controller.dart';
import 'services/backup.dart';
import 'services/card_database.dart';
import 'services/certificate_store.dart';
import 'services/collection_store.dart';
import 'services/market_prefs.dart';
import 'services/deck_store.dart';
import 'services/folder_store.dart';
import 'services/markets.dart';
import 'services/price_history.dart';
import 'services/price_series_database.dart';
import 'services/restore_reset.dart';
import 'services/scanner_database.dart';
import 'services/wishlist_store.dart';
import 'theme/mf_theme.dart';

void main() => runApp(const ManaForgeApp());

class ManaForgeApp extends StatefulWidget {
  const ManaForgeApp({super.key});

  @override
  State<ManaForgeApp> createState() => _ManaForgeAppState();
}

class _ManaForgeAppState extends State<ManaForgeApp> {
  /// Sube al restaurar una copia. Cambia la Key de `HomeShell`, así que
  /// Flutter tira su State y construye otro: los almacenes se crean de cero y
  /// releen el disco nuevo. Más simple y más difícil de romper que inventar
  /// un `reload()` en cada uno de los diez.
  int _session = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManaForge',
      debugShowCheckedModeBanner: false,
      theme: mfTheme(Brightness.light),
      darkTheme: mfTheme(Brightness.dark),
      themeMode: ThemeMode.dark, // oscuro por defecto (decisión de diseño)
      home: HomeShell(
        key: ValueKey(_session),
        onRestored: () {
          // los dos almacenes compartidos NO se recrean con la app: si no se
          // vacían aquí, siguen con lo de antes en memoria y lo reescriben
          // encima de lo que se acaba de restaurar
          resetSharedStores();
          setState(() => _session++);
        },
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  /// Se ha restaurado una copia: la app entera vuelve a empezar.
  final VoidCallback onRestored;

  const HomeShell({super.key, required this.onRestored});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  /// La barra de abajo, en orden. "Escanear" NO es una pestaña: abre el
  /// escáner y vuelve. Su sitio se saca de ESTA lista y no se escribe a mano
  /// en ningún otro lado — escribirlo a mano ya salió mal una vez (Escanear
  /// abría Mazos y Mazos abría el escáner).
  static const List<NavigationDestination> _destinos = [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style),
              label: 'Colección'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories),
              label: 'Álbum'),
          NavigationDestination(
              icon: Icon(Icons.qr_code_scanner, color: MFColors.manaRed),
              selectedIcon: Icon(Icons.qr_code_scanner,
                  color: MFColors.manaRed),
              label: 'Escanear'),
          NavigationDestination(
              icon: Icon(Icons.layers_outlined),
              selectedIcon: Icon(Icons.layers),
              label: 'Mazos'),
          NavigationDestination(
              icon: ForgeTabIcon(selected: false),
              selectedIcon: ForgeTabIcon(selected: true),
              label: 'Forge'),
          NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Mercado'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes'),
  ];

  /// Dónde está "Escanear" dentro de la barra.
  static final int _escanear =
      _destinos.indexWhere((d) => d.label == 'Escanear');

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
          onGoToTab: (i) => setState(() => _index = i)),
      ColeccionScreen(
          db: _db,
          collection: _collection,
          scanner: _scanner,
          folders: _folders,
          achievements: _achievements,
          market: _market,
          prices: _prices),
      AlbumScreen(
          db: _db,
          collection: _collection,
          market: _market,
          prices: _prices),
      MazosScreen(db: _db, collection: _collection, decks: _decks),
      ForgeScreen(db: _db, collection: _collection, decks: _decks),
      MercadoScreen(
          db: _db,
          collection: _collection,
          wishlist: _wishlist,
          prices: _prices,
          market: _market),
      AjustesScreen(db: _db, onRestored: widget.onRestored),
    ];
    // "Escanear" va EN la barra, en el centro: es lo que más se usa y estaba
    // suelto en una esquina de una sola pantalla. No es una pestaña —abre el
    // escáner y vuelve— así que el índice de la barra no es el de la pantalla.
    int barraDePantalla(int pantalla) =>
        pantalla < _escanear ? pantalla : pantalla + 1;
    int pantallaDeBarra(int barra) =>
        barra < _escanear ? barra : barra - 1;

    return Scaffold(
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
        destinations: _destinos,
      ),
    );
  }
}
