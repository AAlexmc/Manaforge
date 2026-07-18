import 'package:flutter/material.dart';

import 'screens/screens.dart';
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

  static const _screens = [
    ColeccionScreen(),
    MazosScreen(),
    ForgeScreen(),
    TradesScreen(),
    AjustesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style),
              label: 'Colección'),
          const NavigationDestination(
              icon: Icon(Icons.layers_outlined),
              selectedIcon: Icon(Icons.layers),
              label: 'Mazos'),
          NavigationDestination(
              icon: const ForgeTabIcon(selected: false),
              selectedIcon: const ForgeTabIcon(selected: true),
              label: 'Forge'),
          const NavigationDestination(
              icon: Icon(Icons.swap_horiz_outlined),
              selectedIcon: Icon(Icons.swap_horiz),
              label: 'Trades'),
          const NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes'),
        ],
      ),
    );
  }
}
