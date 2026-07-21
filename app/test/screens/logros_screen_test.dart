/// Pantalla de Logros: nivel, progreso y medallas bloqueadas.
///
/// Dos trampas de este fichero:
///  - `refresh()` toca ficheros y base de datos, así que va dentro de
///    `tester.runAsync`: el reloj falso de `testWidgets` no deja que se
///    resuelvan las llamadas de plataforma y el test se colgaría;
///  - nada de `pumpAndSettle`: las barras de progreso de Material 3 animan
///    siempre y nunca se quedan quietas.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/logros_screen.dart';
import 'package:manaforge_app/services/achievement_store.dart';
import 'package:manaforge_app/services/achievements.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/services/wishlist_store.dart';

AchievementsController _controller(CollectionStore collection) =>
    AchievementsController(
      db: CardDatabase(), // sin base descargada: la foto sale igual
      collection: collection,
      decks: DeckStore(),
      folders: FolderStore(),
      wishlist: WishlistStore(),
      progress: AchievementStore(),
    );

/// Monta la pantalla con el progreso ya calculado.
Future<void> _open(WidgetTester tester, AchievementsController c) async {
  await tester.runAsync(() => c.refresh());
  await tester.pumpWidget(MaterialApp(home: LogrosScreen(achievements: c)));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('sin colección: nivel 1 y ningún logro', (tester) async {
    final c = _controller(CollectionStore());
    await _open(tester, c);

    expect(find.text('Aprendiz'), findsOneWidget);
    expect(find.text('0 de ${kAchievements.length} logros · 0 XP'),
        findsOneWidget);
    expect(c.level.level, 1);
  });

  testWidgets('con una carta cae el primer logro y suma XP', (tester) async {
    final collection = CollectionStore()
      ..add(OwnedCard(
          oracleId: 'o1', name: 'Llanowar Elves', colors: 'G', qty: 1));
    final c = _controller(collection);
    await _open(tester, c);

    expect(c.unlockedCount, greaterThan(0));
    expect(c.xp, greaterThan(0));
    expect(c.progress.unlockedAt.containsKey('copias-1'), isTrue);
    expect(find.text('La primera'), findsOneWidget);
  });

  testWidgets('el filtro "Me faltan" esconde lo conseguido', (tester) async {
    final collection = CollectionStore()
      ..add(OwnedCard(oracleId: 'o1', name: 'X', colors: 'G', qty: 1));
    final c = _controller(collection);
    await _open(tester, c);

    expect(find.text('La primera'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilterChip, 'Me faltan'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('La primera'), findsNothing);
  });

  testWidgets('los logros secretos no se chivan hasta conseguirlos',
      (tester) async {
    final c = _controller(CollectionStore());
    await _open(tester, c);
    // los secretos están en Curiosidades: hay que ir a su categoría y bajar,
    // porque la lista es perezosa y no pinta las 104 medallas de golpe
    await tester.tap(find.widgetWithText(FilterChip, 'Curiosidades'));
    await tester.pump(const Duration(milliseconds: 300));
    final secret = find.text('Logro secreto');
    for (var i = 0; i < 10 && secret.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(secret, findsWidgets);
  });

  testWidgets('recalcular quita los logros que ya no se cumplen',
      (tester) async {
    final collection = CollectionStore()
      ..add(OwnedCard(oracleId: 'o1', name: 'X', colors: 'G', qty: 1));
    final c = _controller(collection);
    // un logro guardado a mano que la colección NO cumple (lo que pasaba
    // con las míticas: la rareza salía de todas las impresiones)
    c.progress.unlockAll(['miticas-10']);
    await tester.runAsync(() => c.refresh());
    expect(c.progress.unlockedAt.containsKey('miticas-10'), isTrue);

    final removed = await tester.runAsync(() => c.recalculate());
    expect(removed, 1);
    expect(c.progress.unlockedAt.containsKey('miticas-10'), isFalse);
    // lo que sí se cumple se queda
    expect(c.progress.unlockedAt.containsKey('copias-1'), isTrue);
  });

  testWidgets('un escaneo cuenta para los logros del escáner',
      (tester) async {
    final c = _controller(CollectionStore());
    // dentro de runAsync: recordScan dispara su propio refresco y con el
    // reloj falso se quedaría a medias
    await tester.runAsync(() async {
      c.recordScan(copies: 9, distinct: 9, perfect: true);
      await c.refresh();
    });
    await _open(tester, c);

    expect(c.progress.counter(AchievementCounters.cardsScanned), 9);
    expect(c.progress.counter(AchievementCounters.bestPhotoCards), 9);
    expect(c.progress.unlockedAt.containsKey('escaneadas-1'), isTrue);
    expect(c.progress.unlockedAt.containsKey('foto-9'), isTrue);
  });
}
