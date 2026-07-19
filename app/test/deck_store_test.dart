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
}
