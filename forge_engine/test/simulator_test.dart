import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests del Modo Test: el simulador es una heurística, pero debe ser
/// determinista y dar resultados con sentido direccional.
void main() {
  Card creature(String name, int cmc, int p, int t, {int qty = 4}) => Card(
      name: name,
      qty: qty,
      manaCost: '{$cmc}',
      cmc: cmc,
      colors: 'R',
      types: const ['Creature'],
      oracle: '',
      power: p,
      toughness: t);

  Card land(String name, {int qty = 24}) => Card(
      name: name,
      qty: qty,
      manaCost: '',
      cmc: 0,
      colors: '',
      types: const ['Basic', 'Land'],
      oracle: '');

  // mazo agresivo: bichos baratos y eficientes
  final aggroPool = {
    'Raider': creature('Raider', 1, 2, 1),
    'Brawler': creature('Brawler', 2, 3, 2),
    'Crusher': creature('Crusher', 3, 4, 3),
    'Mountain': land('Mountain'),
  };
  final aggro = Deck(
    name: 'Aggro',
    colors: 'R',
    archetype: Archetype.aggro,
    cards: const {'Raider': 4, 'Brawler': 4, 'Crusher': 4},
    lands: const {'Mountain': 21},
  );

  // mazo pasivo: caro y sin apenas presión
  final durdlePool = {
    'Slug': creature('Slug', 6, 1, 1),
    'Mountain': land('Mountain'),
  };
  final durdle = Deck(
    name: 'Durdle',
    colors: 'R',
    archetype: Archetype.midrange,
    cards: const {'Slug': 4},
    lands: const {'Mountain': 24},
  );

  test('determinista: misma semilla, mismo resultado', () {
    final r1 = simulateMatch(aggro, aggroPool, durdle, durdlePool,
        games: 60, seed: 3);
    final r2 = simulateMatch(aggro, aggroPool, durdle, durdlePool,
        games: 60, seed: 3);
    expect(r1, r2);
  });

  test('el aggro machaca al mazo pasivo', () {
    final rate = simulateMatch(aggro, aggroPool, durdle, durdlePool,
        games: 100, seed: 5);
    expect(rate, greaterThan(0.7));
  });

  test('el espejo queda equilibrado', () {
    final rate = simulateMatch(aggro, aggroPool, aggro, aggroPool,
        games: 200, seed: 9);
    expect(rate, inInclusiveRange(0.3, 0.7));
  });

  test('los colores importan: sin tierras azules no se lanzan hechizos UU',
      () {
    // mismo cuerpo, pero coste {U}{U} con solo Montañas: incastable
    final uuPool = {
      'Wrong Colors': const Card(
          name: 'Wrong Colors',
          qty: 4,
          manaCost: '{U}{U}',
          cmc: 2,
          colors: 'U',
          types: ['Creature'],
          oracle: '',
          power: 3,
          toughness: 2),
      'Mountain': land('Mountain'),
    };
    final uuDeck = Deck(
      name: 'UU sin islas',
      colors: 'U',
      archetype: Archetype.midrange,
      cards: const {'Wrong Colors': 4},
      lands: const {'Mountain': 20},
    );
    final rate = simulateMatch(aggro, aggroPool, uuDeck, uuPool,
        games: 100, seed: 11);
    expect(rate, greaterThan(0.85)); // el rival nunca puede jugar nada
  });

  test('volar gana al mismo cuerpo sin evasión', () {
    Card flyer(String name) => Card(
        name: name,
        qty: 4,
        manaCost: '{2}',
        cmc: 2,
        colors: 'W',
        types: const ['Creature'],
        oracle: 'Flying',
        power: 2,
        toughness: 2);
    final flyPool = {
      'Pegasus': flyer('Pegasus'),
      'Plains': land('Plains'),
    };
    final flyDeck = Deck(
      name: 'Volar',
      colors: 'W',
      archetype: Archetype.aggro,
      cards: const {'Pegasus': 4},
      lands: const {'Plains': 21},
    );
    final groundPool = {
      'Bear': creature('Bear', 2, 2, 2),
      'Plains': land('Plains'),
    };
    final groundDeck = Deck(
      name: 'Suelo',
      colors: 'R',
      archetype: Archetype.aggro,
      cards: const {'Bear': 4},
      lands: const {'Plains': 21},
    );
    final rate = simulateMatch(flyDeck, flyPool, groundDeck, groundPool,
        games: 200, seed: 13);
    expect(rate, greaterThan(0.5)); // la evasión debe notarse
  });

  group('Task 12: cementerio + tierras reales', () {
    Card swamp({int qty = 24}) => Card(
        name: 'Swamp',
        qty: qty,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: const ['Basic', 'Land'],
        oracle: '({T}: Add {B}.)');

    // Prisa: para que conecte al menos un golpe antes de que la maten (el
    // removal instantáneo del rival actúa al FINAL del turno en el que
    // entra, después del combate).
    const fatty = Card(
        name: 'Zombie Titan',
        qty: 4,
        manaCost: '{5}{B}{B}',
        cmc: 7,
        colors: 'B',
        types: ['Creature'],
        oracle: 'Haste',
        power: 10,
        toughness: 10);

    const exhume = Card(
        name: 'Exhume',
        qty: 4,
        manaCost: '{B}',
        cmc: 1,
        colors: 'B',
        types: ['Sorcery'],
        oracle:
            'Return target creature card from your graveyard to the battlefield.');

    const millSpell = Card(
        name: 'Tome Scour',
        qty: 8,
        manaCost: '{B}',
        cmc: 1,
        colors: 'B',
        types: ['Sorcery'],
        oracle: 'Mill 5 cards.');

    Card filler(String name, int cmc, int p, int t) => Card(
        name: name,
        qty: 4,
        manaCost: '{$cmc}',
        cmc: cmc,
        colors: '',
        types: const ['Creature'],
        oracle: '',
        power: p,
        toughness: t);

    const fillerCurve = [1, 1, 2, 2, 3, 3, 4, 5];

    Map<String, Card> fillerPool(int names) => {
          for (var i = 0; i < names; i++)
            'Filler $i': filler('Filler $i', fillerCurve[i % fillerCurve.length],
                fillerCurve[i % fillerCurve.length], fillerCurve[i % fillerCurve.length]),
        };

    // deckReanimator: SOLO gorda + Exhume + mill (nada de criaturas baratas
    // que le ganen la prioridad al mill en el greedy del turno): busca la
    // tumba a toda prisa y desentierra la gorda con prisa.
    final poolReanimator = {
      'Swamp': swamp(),
      'Zombie Titan': fatty,
      'Exhume': exhume,
      'Tome Scour': millSpell,
    };
    final deckReanimator = Deck(
      name: 'Reanimator',
      colors: 'B',
      archetype: Archetype.midrange,
      cards: const {'Zombie Titan': 4, 'Exhume': 4, 'Tome Scour': 8},
      // pocas tierras a propósito: la baraja apenas necesita maná (todo
      // cuesta {B}) y sobran tierras en mano estorban el plan de mill.
      lands: const {'Swamp': 14},
    );

    // deckTwin: mismas gordas, pero SIN mill ni Exhume — hay que lanzarlas a
    // pelo (7 manas) — el gemelo de control negativo del brief. Lleva bichos
    // baratos de verdad para presionar mientras tanto.
    final poolTwin = {
      'Swamp': swamp(),
      'Zombie Titan': fatty,
      ...fillerPool(8),
    };
    final deckTwin = Deck(
      name: 'Twin sin reanimación',
      colors: 'B',
      archetype: Archetype.midrange,
      cards: {
        'Zombie Titan': 4,
        for (var i = 0; i < 8; i++) 'Filler $i': 4,
      },
      lands: const {'Swamp': 24},
    );

    test('reanimator gana >55% a su gemelo sin reanimación (semilla fija)',
        () {
      final wr = simulateMatch(deckReanimator, poolReanimator, deckTwin,
          poolTwin, games: 200, seed: 7);
      expect(wr, greaterThan(0.55));
    });

    test('determinismo se conserva', () {
      final r1 = simulateMatch(deckReanimator, poolReanimator, deckTwin,
          poolTwin, games: 200, seed: 7);
      final r2 = simulateMatch(deckReanimator, poolReanimator, deckTwin,
          poolTwin, games: 200, seed: 7);
      expect(r1, r2);
    });

    Card taplandR({int qty = 8}) => Card(
        name: 'Slow Mountain',
        qty: qty,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: const ['Land'],
        oracle: 'Slow Mountain enters the battlefield tapped.\n{T}: Add {R}.');

    // curva larga (hasta 5) para que el maná de más siga importando mucho
    // más allá del turno 3: si toda la curva cupiera en 3 manas, un turno
    // de tierra tapada de más no se notaría pasado ese punto.
    final aggroCards = {'Raider': 4, 'Brawler': 4, 'Crusher': 4, 'Behemoth': 4};
    final poolTapA = {
      'Raider': creature('Raider', 1, 2, 1),
      'Brawler': creature('Brawler', 2, 3, 2),
      'Crusher': creature('Crusher', 3, 4, 3),
      'Behemoth': creature('Behemoth', 5, 6, 5),
      'Mountain': land('Mountain'),
      'Slow Mountain': taplandR(),
    };
    final deckTapA = Deck(
      name: 'Aggro con taplands',
      colors: 'R',
      archetype: Archetype.aggro,
      cards: aggroCards,
      lands: const {'Mountain': 16, 'Slow Mountain': 8},
    );
    final poolTapB = {
      'Raider': creature('Raider', 1, 2, 1),
      'Brawler': creature('Brawler', 2, 3, 2),
      'Crusher': creature('Crusher', 3, 4, 3),
      'Behemoth': creature('Behemoth', 5, 6, 5),
      'Mountain': land('Mountain'),
    };
    final deckTapB = Deck(
      name: 'Aggro sin taplands',
      colors: 'R',
      archetype: Archetype.aggro,
      cards: aggroCards,
      lands: const {'Mountain': 24},
    );

    test('taplands cuestan tempo: aggro con 8 taplands pierde el espejo', () {
      final wr = simulateMatch(deckTapA, poolTapA, deckTapB, poolTapB,
          games: 200, seed: 7);
      expect(wr, lessThan(0.45));
    });

    group('los muertos van al cementerio y el mill llena la tumba', () {
      // (a) el mill llena la tumba: mismo paquete que arriba, pero SIN
      // Exhume, contra un rival pasivo (sin remover ni presionar apenas).
      // Si el mill no llenara la tumba de verdad, esta variante y la que sí
      // desentierra rendirían igual.
      final deckMillSinExhume = Deck(
        name: 'Solo mill, sin Exhume',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {'Zombie Titan': 4, 'Tome Scour': 8},
        lands: const {'Swamp': 24},
      );
      final poolPassive = {
        'Swamp': swamp(),
        for (var i = 0; i < 4; i++) 'Weenie $i': filler('Weenie $i', 1, 1, 1),
      };
      final deckPassive = Deck(
        name: 'Rival pasivo',
        colors: 'B',
        archetype: Archetype.aggro,
        cards: const {
          'Weenie 0': 4,
          'Weenie 1': 4,
          'Weenie 2': 4,
          'Weenie 3': 4,
        },
        lands: const {'Swamp': 24},
      );

      test('con Exhume desentierra lo que el mill encontró y gana mucho más',
          () {
        final conExhume = simulateMatch(deckReanimator, poolReanimator,
            deckPassive, poolPassive, games: 150, seed: 7);
        final sinExhume = simulateMatch(deckMillSinExhume, poolReanimator,
            deckPassive, poolPassive, games: 150, seed: 7);
        expect(conExhume, greaterThan(sinExhume));
      });

      // (b) los muertos (por removal, no por mill) van al cementerio y de
      // ahí también se puede reanimar: la gorda se lanza a pelo, el rival
      // la mata, y solo el mazo con Exhume la recupera para pegar otra vez.
      const doomBlade = Card(
          name: 'Doom Blade',
          qty: 8,
          manaCost: '{2}',
          cmc: 2,
          colors: '',
          types: ['Instant'],
          oracle: 'Destroy target creature.');
      final grinder = creature('Grinder', 2, 2, 2, qty: 8);
      final poolRemoval = {
        'Swamp': swamp(),
        'Doom Blade': doomBlade,
        'Grinder': grinder,
      };
      final deckRemoval = Deck(
        name: 'Removal + presión',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {'Doom Blade': 8, 'Grinder': 8},
        lands: const {'Swamp': 24},
      );
      // UNA sola copia de la gorda: sin Exhume, en cuanto la maten no hay
      // vuelta atrás. Con Exhume, la MISMA copia vuelve del cementerio.
      final poolDeathExhume = {
        'Swamp': swamp(),
        'Zombie Titan': fatty,
        'Exhume': exhume,
      };
      final deckDeathExhume = Deck(
        name: 'Gorda a pelo + Exhume',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {'Zombie Titan': 1, 'Exhume': 4},
        lands: const {'Swamp': 20},
      );
      final poolDeathSolo = {'Swamp': swamp(), 'Zombie Titan': fatty};
      final deckDeathSolo = Deck(
        name: 'Gorda a pelo, sin Exhume',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {'Zombie Titan': 1},
        lands: const {'Swamp': 24},
      );

      test('con Exhume, la gorda que mató el removal vuelve a pegar', () {
        final conExhume = simulateMatch(deckDeathExhume, poolDeathExhume,
            deckRemoval, poolRemoval, games: 150, seed: 7);
        final sinExhume = simulateMatch(deckDeathSolo, poolDeathSolo,
            deckRemoval, poolRemoval, games: 150, seed: 7);
        expect(conExhume, greaterThan(sinExhume));
      });
    });
  });
}
