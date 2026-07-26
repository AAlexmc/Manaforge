import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests espejo de `engine-reference/tests/test_acceptance.py`.
void main() {
  group('Card', () {
    test('subtypes y keywords viajan y hasKeyword cae al oracle si faltan',
        () {
      final c = Card.fromJson('Siren Lookout', {
        'qty': 1, 'mana_cost': '{2}{U}', 'cmc': 3, 'colors': 'U',
        'types': ['Creature'], 'subtypes': ['Siren', 'Pirate'],
        'oracle': 'Flying\nWhen Siren Lookout enters…',
        'keywords': ['flying', 'explore'], 'power': 1, 'toughness': 2,
      });
      expect(c.subtypes, ['Siren', 'Pirate']);
      expect(c.hasKeyword('flying'), isTrue);
      expect(c.hasKeyword('trample'), isFalse);
      final sinKw = Card.fromJson('X', {
        'qty': 1, 'cmc': 1, 'types': ['Creature'],
        'oracle': 'First strike',
      });
      expect(sinKw.hasKeyword('first strike'), isTrue); // fallback regex
    });
  });

  group('ManaCurve', () {
    test('manaValue', () {
      expect(ManaCurve.manaValue('{2}{U}{U}'), 4);
      expect(ManaCurve.manaValue('{G}'), 1);
      expect(ManaCurve.manaValue('{X}{R}'), 1); // X cuenta 0
      expect(ManaCurve.manaValue('{B/G}{B/G}'), 2); // híbridos
      expect(ManaCurve.manaValue(''), 0); // tierras
    });

    test('colorSymbols', () {
      final rite = ManaCurve.colorSymbols('{1}{W}{B}{B}');
      expect(rite['W'], 1);
      expect(rite['B'], 2);
      final hybrid = ManaCurve.colorSymbols('{B/G}{B/G}');
      expect(hybrid['B'], 2); // el híbrido cuenta para ambos
      expect(hybrid['G'], 2);
    });

    // Reescrito (v2 tierras por probabilidad): antes este test fijaba un
    // número mágico ("coste medio 3.0 -> 24 tierras" de la fórmula vieja).
    // Ahora la fórmula elige, DENTRO del rango del arquetipo, el n que
    // maximiza P(caídas) - 0.5*P(inundación); con este pool (coste medio 3.0,
    // sin fuentes baratas) el máximo cae en 25 (el tope de midrange), que
    // sigue dentro del rango de la vieja fórmula (23-25) — no es un mazo
    // distinto, es el mismo pool con un n de tierras distinto y justificado.
    test(
        'las tierras elegidas maximizan P(caídas) - 0.5*P(inundación) en su rango',
        () {
      final cards = <String, int>{};
      final pool = <String, Card>{};
      for (var i = 0; i < 36; i++) {
        final name = 'Tres $i';
        cards[name] = 1;
        pool[name] = Card(
            name: name,
            qty: 1,
            manaCost: '{2}{B}',
            cmc: 3,
            colors: 'B',
            types: const ['Creature'],
            oracle: '');
      }
      final n = ManaCurve.recommendedLands(cards, pool, Archetype.midrange);
      expect(n, inInclusiveRange(23, 25));
      double util(int k) =>
          pLandDrops(k, 60, 4) - 0.5 * hypergeomAtLeast(60, k, 4 + 8, 4 + 3);
      for (var k = 23; k <= 25; k++) {
        expect(util(n) + 1e-12, greaterThanOrEqualTo(util(k)));
      }
    });

    test('aggro barato elige menos tierras que control caro', () {
      final cheapCards = <String, int>{};
      final cheapPool = <String, Card>{};
      for (var i = 0; i < 20; i++) {
        final name = 'Barata $i';
        cheapCards[name] = 1;
        cheapPool[name] = Card(
            name: name,
            qty: 1,
            manaCost: '{R}',
            cmc: 1,
            colors: 'R',
            types: const ['Creature'],
            oracle: '');
      }
      final expensiveCards = <String, int>{};
      final expensivePool = <String, Card>{};
      for (var i = 0; i < 20; i++) {
        final name = 'Cara $i';
        expensiveCards[name] = 1;
        expensivePool[name] = Card(
            name: name,
            qty: 1,
            manaCost: '{4}{U}{U}',
            cmc: 6,
            colors: 'U',
            types: const ['Creature'],
            oracle: '');
      }
      expect(
        ManaCurve.recommendedLands(cheapCards, cheapPool, Archetype.aggro),
        lessThan(ManaCurve.recommendedLands(
            expensiveCards, expensivePool, Archetype.control)),
      );
    });
  });

  group('DeckValidator', () {
    // Mini-pool sintético: números del fixture Python (Sangre y Fe v3).
    Map<String, Card> pool() {
      final p = <String, Card>{
        'Gray Merchant of Asphodel': const Card(
            name: 'Gray Merchant of Asphodel',
            qty: 3,
            manaCost: '{3}{B}{B}',
            cmc: 5,
            colors: 'B',
            types: ['Creature'],
            oracle: 'each opponent loses X life'),
        'Cruel Feeding': const Card(
            name: 'Cruel Feeding',
            qty: 4,
            manaCost: '{B}',
            cmc: 1,
            colors: 'B',
            types: ['Instant'],
            oracle: 'lifelink until end of turn'),
        'Healer\'s Hawk': const Card(
            name: 'Healer\'s Hawk',
            qty: 1,
            manaCost: '{W}',
            cmc: 1,
            colors: 'W',
            types: ['Creature'],
            oracle: 'Flying, lifelink'),
        'Llanowar Elves': const Card(
            name: 'Llanowar Elves',
            qty: 2,
            manaCost: '{G}',
            cmc: 1,
            colors: 'G',
            types: ['Creature'],
            oracle: '{T}: Add {G}.'),
        'Swamp': const Card(
            name: 'Swamp',
            qty: 12,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {B}.'),
        'Plains': const Card(
            name: 'Plains',
            qty: 14,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W}.'),
      };
      // 20 rellenos a coste 2 y 8 a coste 3: coste medio del mazo 2.33,
      // dentro del rango midrange (2.2-3.5). Con los 28 a coste 2 salía
      // 2.11 y el validador lo rechazaba — correctamente.
      for (var i = 0; i < 28; i++) {
        final name = 'Relleno $i';
        final threeDrop = i >= 20;
        p[name] = Card(
            name: name,
            qty: 1,
            manaCost: threeDrop ? '{2}{B}' : '{1}{B}',
            cmc: threeDrop ? 3 : 2,
            colors: 'B',
            types: const ['Creature'],
            oracle: '');
      }
      return p;
    }

    Deck validDeck({Map<String, int>? extraCards, List<String>? remove}) {
      final cards = <String, int>{
        'Gray Merchant of Asphodel': 3,
        'Cruel Feeding': 4,
        'Healer\'s Hawk': 1,
        for (var i = 0; i < 28; i++) 'Relleno $i': 1,
      };
      remove?.forEach(cards.remove);
      extraCards?.forEach((k, v) => cards[k] = v);
      return Deck(
          name: 'Test',
          colors: 'WB',
          archetype: Archetype.midrange,
          cards: cards,
          lands: {'Swamp': 12, 'Plains': 12});
    }

    test('un mazo válido pasa sin violaciones', () {
      expect(DeckValidator.validate(validDeck(), pool()), isEmpty);
    });

    test('la curva SIEMPRE suma los hechizos (el bug del prototipo)', () {
      final deck = validDeck();
      final hist = ManaCurve.curveHistogram(deck.cards, pool());
      expect(hist.values.fold(0, (a, b) => a + b),
          deck.cards.values.fold(0, (a, b) => a + b));
    });

    test('detecta más copias de las poseídas', () {
      final deck = validDeck(extraCards: {'Cruel Feeding': 5});
      expect(DeckValidator.validate(deck, pool()),
          anyElement(contains('Cruel Feeding')));
    });

    test('detecta cartas no poseídas', () {
      final deck = validDeck(extraCards: {'Black Lotus': 1});
      expect(DeckValidator.validate(deck, pool()),
          anyElement(contains('Black Lotus')));
    });

    test('detecta tamaño incorrecto', () {
      final deck = Deck(
          name: 'T',
          colors: 'WB',
          archetype: Archetype.midrange,
          cards: validDeck().cards,
          lands: {'Swamp': 13, 'Plains': 12});
      expect(
          DeckValidator.validate(deck, pool()), anyElement(contains('61')));
    });

    test('detecta identidad de color', () {
      final deck = validDeck(
          extraCards: {'Llanowar Elves': 1}, remove: ['Healer\'s Hawk']);
      expect(DeckValidator.validate(deck, pool()),
          anyElement(contains('identidad')));
    });
  });
}
