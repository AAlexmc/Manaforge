/// Inicio respeta el layout: una sección apagada no sale, y el icono de la
/// cabecera abre el editor.
///
/// No se llama a `load()` ni se espera a los guardados: tocan disco y el reloj
/// falso de `testWidgets` no hace avanzar la E/S real (ver `language_prefs`).
/// El estado por defecto del layout ("todo visible") ya vale; el `toggle` se
/// deja sin esperar porque su parte síncrona ya muta y avisa.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/home/home_screen.dart';
import 'package:manaforge_app/data/repositories/achievement_store.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/repositories/certificate_store.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/deck_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/data/repositories/home_layout_prefs.dart';
import 'package:manaforge_app/data/repositories/wishlist_store.dart';

/// Base que no existe: alguien que aún no la ha descargado, sin depender de
/// plugins (en test no hay path_provider).
CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));

Widget _inicio(HomeLayoutPreference layout) {
  final collection = CollectionStore();
  final decks = DeckStore();
  return MaterialApp(
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
      layout: layout,
      onGoToTab: (_) {},
    ),
  );
}

void main() {
  late Directory datos;

  setUp(() => datos = Directory.systemTemp.createTempSync('mf-inicio'));
  tearDown(() {
    if (datos.existsSync()) datos.deleteSync(recursive: true);
  });

  testWidgets('apagar "accesos" lo quita de Inicio en vivo', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final layout = HomeLayoutPreference(dataDir: datos);
    await tester.pumpWidget(_inicio(layout));
    await tester.pump(const Duration(milliseconds: 100));

    // los accesos rápidos salen
    expect(find.text('Forjar mazos'), findsOneWidget);

    unawaited(layout.toggle('accesos')); // la parte síncrona ya muta y avisa
    await tester.pump();
    expect(find.text('Forjar mazos'), findsNothing);
  });

  testWidgets('el icono de la cabecera abre el editor', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final layout = HomeLayoutPreference(dataDir: datos);
    await tester.pumpWidget(_inicio(layout));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // la transición de la ruta

    expect(find.text('Editar inicio'), findsOneWidget);
    expect(find.text('Restablecer'), findsOneWidget);
  });
}
