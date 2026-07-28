/// Primer uso: la app recién abierta, sin una sola carta.
///
/// Es la pantalla que decide si alguien se queda. Antes solo ofrecía
/// "Importar CSV", que es justo lo que casi nadie tiene a mano: el CSV sale
/// de ManaBox, otra app. Escanear es la vía natural, y Forge se puede probar
/// sin tener nada.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/home/home_screen.dart';
import 'package:manaforge_app/ui/decks/mazos_screen.dart';
import 'package:manaforge_app/services/achievement_store.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/certificate_store.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/services/wishlist_store.dart';

/// Base que no existe: el caso de alguien que aún no la ha descargado, y sin
/// depender de plugins (en test no hay path_provider).
CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));

void main() {
  testWidgets('sin colección, Inicio ofrece los TRES caminos',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final collection = CollectionStore();
    final decks = DeckStore();
    var escaneado = 0;
    var pestana = -1;

    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(
        db: _sinBase(),
        collection: collection,
        decks: decks,
        achievements: AchievementsController(
          db: _sinBase(),
          collection: collection,
          decks: decks,
          folders: FolderStore(),
          wishlist: WishlistStore(),
          progress: AchievementStore(),
        ),
        certificates: CertificateStore(),
        onScan: () => escaneado++,
        onGoToTab: (i) => pestana = i,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Escanear mis cartas'), findsOneWidget);
    expect(find.text('Importar CSV (ManaBox)'), findsOneWidget);
    expect(find.text('Probar Forge sin colección'), findsOneWidget);

    await tester.tap(find.text('Escanear mis cartas'));
    expect(escaneado, 1); // el escáner está en la barra de abajo: hay atajo

    await tester.tap(find.text('Probar Forge sin colección'));
    expect(pestana, 3); // Forge (ahora antes que Mazos en la barra)
  });

  testWidgets('Mazos vacío tiene por dónde salir', (tester) async {
    var pestana = -1;
    await tester.pumpWidget(MaterialApp(
      home: MazosScreen(
        db: _sinBase(),
        collection: CollectionStore(),
        decks: DeckStore(),
        onGoToForge: () => pestana = 4,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Ir a Forge'));
    expect(pestana, 4);
  });
}
