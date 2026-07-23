import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/services/deck_store.dart';

void main() {
  test('SavedDeck: ida y vuelta a JSON y reconstrucción del GeneratedDeck',
      () {
    final gen = fe.GeneratedDeck(
      const fe.Deck(
        name: 'Forge WU spells',
        colors: 'WU',
        archetype: fe.Archetype.midrange,
        cards: {'Counterspell': 2, 'Ornithopter': 2},
        lands: {'Island': 15, 'Plains': 8},
      ),
      'spells',
      4.2,
    );
    final saved = SavedDeck.fromGenerated(gen);
    final restored = SavedDeck.fromJson(saved.toJson()).toGenerated();
    expect(restored.deck.name, 'Forge WU spells');
    expect(restored.deck.archetype, fe.Archetype.midrange);
    expect(restored.deck.cards['Counterspell'], 2);
    expect(restored.deck.lands['Island'], 15);
    expect(restored.theme, 'spells');
    expect(saved.totalSpells, 4);
    expect(saved.totalLands, 23);
  });

  test('DeckStore añade y borra (en memoria, sin plugin)', () {
    final store = DeckStore();
    final gen = fe.GeneratedDeck(
      const fe.Deck(
          name: 'T',
          colors: 'W',
          archetype: fe.Archetype.aggro,
          cards: {'A': 4},
          lands: {'Plains': 20}),
      'goodstuff',
      1.0,
    );
    store.add(SavedDeck.fromGenerated(gen));
    expect(store.decks.length, 1);
    store.remove(store.decks.first.id);
    expect(store.decks, isEmpty);
  });

  test('restore vuelve a meter el mazo en su sitio y no lo duplica', () {
    SavedDeck mk(String id) => SavedDeck(
          id: id,
          name: 'Mazo $id',
          colors: 'W',
          archetype: 'aggro',
          theme: 'x',
          score: 1.0,
          cards: const {'A': 4},
          lands: const {'Plains': 20},
          savedAt: '2026-07-01T00:00:00.000',
        );
    final store = DeckStore();
    final a = mk('a'), b = mk('b'), c = mk('c');
    // add inserta arriba: [c] -> [b,c] -> [a,b,c]
    store..add(c)..add(b)..add(a);
    final idxB = store.decks.indexWhere((d) => d.id == 'b'); // 1

    store.remove('b');
    expect(store.decks.map((d) => d.id), ['a', 'c']);

    store.restore(b, idxB);
    expect(store.decks.map((d) => d.id), ['a', 'b', 'c'],
        reason: 'vuelve exactamente a su hueco');

    // doble deshacer no duplica
    store.restore(b, idxB);
    expect(store.decks.where((d) => d.id == 'b').length, 1);
  });

  test('restore con índice fuera de rango lo acota', () {
    final store = DeckStore();
    const a = SavedDeck(
        id: 'a',
        name: 'A',
        colors: 'W',
        archetype: 'aggro',
        theme: 'x',
        score: 1.0,
        cards: {'A': 4},
        lands: {'Plains': 20},
        savedAt: '2026-07-01T00:00:00.000');
    store.restore(a, 999);
    expect(store.decks.single.id, 'a');
  });
}
