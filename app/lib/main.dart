import 'package:flutter/material.dart';

import 'screens/logros_screen.dart';
import 'screens/screens.dart';
import 'services/achievement_store.dart';
import 'services/achievements_controller.dart';
import 'services/card_database.dart';
import 'services/collection_store.dart';
import 'services/deck_store.dart';
import 'services/folder_store.dart';
import 'services/price_history.dart';
import 'services/price_series_database.dart';
import 'services/scanner_database.dart';
import 'services/wishlist_store.dart';
import 'theme/mf_theme.dart';

void main() => runApp(const ManaForgeApp());

class ManaForgeApp extends StatelessWidget {
  const ManaForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManaForge',
      debugShowCheckedModeBanner: false,
      theme: mfTheme(Brightness.light),
      darkTheme: mfTheme(Brightness.dark),
      themeMode: ThemeMode.dark, // oscuro por defecto (decisión de diseño)
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _started = false; // false = pantalla de arranque (puesta al día)
  final _db = CardDatabase();
  final _collection = CollectionStore();
  final _decks = DeckStore();
  final _folders = FolderStore();
  final _scanner = ScannerDatabase();
  final _wishlist = WishlistStore();
  final _prices = PriceSeriesDatabase();
  final _progress = AchievementStore();
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
    priceHistoryStore.baseSeriesProvider = _prices.seriesFor;
    _achievements.addListener(_onAchievements);
    // los logros necesitan lo que hay guardado antes de evaluar nada
    _progress.load().then((_) {
      _achievements.markActive(); // un día más de racha
    });
  }

  @override
  void dispose() {
    priceHistoryStore.baseSeriesProvider = null;
    _achievements.removeListener(_onAchievements);
    _achievements.dispose();
    _prices.close();
    super.dispose();
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
          onGoToTab: (i) => setState(() => _index = i)),
      ColeccionScreen(
          db: _db,
          collection: _collection,
          scanner: _scanner,
          folders: _folders,
          achievements: _achievements),
      AlbumScreen(db: _db, collection: _collection),
      MazosScreen(db: _db, collection: _collection, decks: _decks),
      ForgeScreen(db: _db, collection: _collection, decks: _decks),
      MercadoScreen(
          db: _db,
          collection: _collection,
          wishlist: _wishlist,
          prices: _prices),
      AjustesScreen(db: _db),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
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
        ],
      ),
    );
  }
}
