import 'package:flutter/material.dart';

import 'screens/screens.dart';
import 'services/card_database.dart';
import 'services/collection_store.dart';
import 'services/deck_store.dart';
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
  final _db = CardDatabase();
  final _collection = CollectionStore();
  final _decks = DeckStore();
  final _scanner = ScannerDatabase();
  final _wishlist = WishlistStore();
  final _prices = PriceSeriesDatabase();

  @override
  void initState() {
    super.initState();
    // el historial local se apoya en los ~90 días reales de Cardmarket que
    // trae la base descargable (si el usuario la ha traído)
    priceHistoryStore.baseSeriesProvider = _prices.seriesFor;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
          db: _db,
          collection: _collection,
          decks: _decks,
          onGoToTab: (i) => setState(() => _index = i)),
      ColeccionScreen(db: _db, collection: _collection, scanner: _scanner),
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
