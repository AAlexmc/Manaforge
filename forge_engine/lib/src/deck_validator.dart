import 'mana_curve.dart';
import 'models.dart';

/// Las reglas duras que Forge NUNCA puede violar.
/// Espejo 1:1 de `engine-reference/forge/validator.py`.
///
/// Regla de producto: si la colección no permite cumplirlas, Forge avisa y
/// explica el compromiso en lugar de generar un mazo defectuoso.
class DeckValidator {
  static const basicLands = {'Plains', 'Island', 'Swamp', 'Mountain', 'Forest'};
  static const maxCopies = 4;

  /// Devuelve la lista de violaciones (vacía = mazo válido).
  static List<String> validate(Deck deck, Map<String, Card> pool) {
    final errors = <String>[];
    final everything = <String, int>{...deck.cards};
    deck.lands.forEach((k, v) => everything[k] = (everything[k] ?? 0) + v);

    // 1-2: propiedad y límite de copias
    everything.forEach((name, qty) {
      final owned = pool[name];
      if (owned == null) {
        errors.add("'$name' no está en la colección");
        return;
      }
      if (qty > owned.qty) {
        errors.add("'$name': usa $qty, posee ${owned.qty}");
      }
      if (qty > maxCopies && !basicLands.contains(name)) {
        errors.add("'$name': $qty copias supera el límite de $maxCopies");
      }
    });

    // 3: tamaño exacto
    if (deck.totalCards != ManaCurve.deckSize) {
      errors.add(
          'el mazo tiene ${deck.totalCards} cartas, deben ser ${ManaCurve.deckSize}');
    }

    // 4: identidad de color
    final allowed = deck.colors.split('').toSet();
    for (final name in deck.cards.keys) {
      final card = pool[name];
      if (card == null) continue;
      if (card.colors.split('').toSet().difference(allowed).isNotEmpty) {
        errors.add(
            "'$name' (${card.colors}) fuera de la identidad ${deck.colors}");
      }
    }

    // 5: tierras y coste medio dentro del arquetipo
    final landCount = deck.lands.values.fold(0, (a, b) => a + b);
    if (landCount < deck.archetype.landMin ||
        landCount > deck.archetype.landMax) {
      errors.add(
          '$landCount tierras fuera del rango ${deck.archetype.landMin}-${deck.archetype.landMax} de ${deck.archetype.name}');
    }
    final knownCards = Map<String, int>.fromEntries(
        deck.cards.entries.where((e) => pool.containsKey(e.key)));
    if (knownCards.isNotEmpty) {
      final avg = ManaCurve.averageCmc(knownCards, pool);
      if (avg < deck.archetype.cmcMin || avg > deck.archetype.cmcMax) {
        errors.add(
            'coste medio ${avg.toStringAsFixed(2)} fuera del rango de ${deck.archetype.name}');
      }
    }

    return errors;
  }
}
