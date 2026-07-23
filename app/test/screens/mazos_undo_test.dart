/// Borrar un mazo se puede deshacer: se borra ya, pero un SnackBar con
/// DESHACER lo vuelve a meter en su sitio durante unos segundos.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/mazos_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';

SavedDeck _mazo(String id, String name) => SavedDeck(
      id: id,
      name: name,
      colors: 'W',
      archetype: 'aggro',
      theme: 'x',
      score: 1.0,
      cards: const {'A': 4},
      lands: const {'Plains': 20},
      savedAt: '2026-07-01T00:00:00.000',
    );

void main() {
  testWidgets('borrar un mazo ofrece deshacer y lo restaura', (tester) async {
    final decks = DeckStore()..add(_mazo('a', 'Mi mono-blanco'));

    await tester.pumpWidget(MaterialApp(
      home: MazosScreen(
          db: CardDatabase(), collection: CollectionStore(), decks: decks),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Mi mono-blanco'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump(); // que salga el SnackBar

    // el mazo ya no está en la lista, pero se avisa y se puede deshacer
    expect(decks.decks, isEmpty);
    expect(find.text('Mazo "Mi mono-blanco" borrado'), findsOneWidget);
    expect(find.text('DESHACER'), findsOneWidget);

    // el SnackBar cae al borde inferior y en el viewport de test no siempre
    // recibe el toque; se dispara su acción directamente para probar el cableado
    final accion = tester.widget<SnackBarAction>(find.byType(SnackBarAction));
    accion.onPressed();
    await tester.pump();

    expect(decks.decks.single.id, 'a', reason: 'vuelve el mazo');
    expect(find.text('Mi mono-blanco'), findsOneWidget);
  });
}
