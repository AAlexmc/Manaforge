import 'package:flutter/material.dart';

import 'screens/screens.dart';
import 'services/card_database.dart';
import 'services/collection_store.dart';
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      ColeccionScreen(db: _db, collection: _collection),
      const MazosScreen(),
      ForgeScreen(db: _db, collection: _collection),
      const TradesScreen(),
      const AjustesScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style),
              label: 'Colección'),
          NavigationDestination(
              icon: Icon(Icons.layers_outlined),
              selectedIcon: Icon(Icons.layers),
              label: 'Mazos'),
          NavigationDestination(
              icon: ForgeTabIcon(selected: false),
              selectedIcon: ForgeTabIcon(selected: true),
              label: 'Forge'),
          NavigationDestination(
              icon: Icon(Icons.swap_horiz_outlined),
              selectedIcon: Icon(Icons.swap_horiz),
              label: 'Trades'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes'),
        ],
      ),
    );
  }
}
