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

    // redacción real de autotumba: el oracle de Magic escribe el número en
    // LETRA ("mills two cards", nunca "mills 2 cards") y "Mill N cards." a
    // secas (sin "target player") es la plantilla de autotumba real
    // (Stitcher's Supplier). Deliberado para el test de detección del
    // regex: si el fix de la review no reconociera números en letra ni
    // exigiera sujeto propio, esta fixture lo cazaría.
    const millSpell = Card(
        name: 'Cryptic Excavation',
        qty: 8,
        manaCost: '{B}',
        cmc: 1,
        colors: 'B',
        types: ['Sorcery'],
        oracle: 'Mill five cards.');

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

    // deckReanimator: SOLO gorda + Exhume + mill (nada de criaturas baratas
    // que le ganen la prioridad al mill en el greedy del turno): busca la
    // tumba a toda prisa y desentierra la gorda con prisa.
    final poolReanimator = {
      'Swamp': swamp(),
      'Zombie Titan': fatty,
      'Exhume': exhume,
      'Cryptic Excavation': millSpell,
    };
    final deckReanimator = Deck(
      name: 'Reanimator',
      colors: 'B',
      archetype: Archetype.midrange,
      cards: const {'Zombie Titan': 4, 'Exhume': 4, 'Cryptic Excavation': 8},
      // pocas tierras a propósito: la baraja apenas necesita maná (todo
      // cuesta {B}) y sobran tierras en mano estorban el plan de mill.
      lands: const {'Swamp': 14},
    );

    // hechizo vainilla de {B} que no hace nada: el relleno neutro para el
    // gemelo (mismo coste que Exhume, cero efecto).
    const doNothing = Card(
        name: 'Idle Ritual',
        qty: 4,
        manaCost: '{B}',
        cmc: 1,
        colors: 'B',
        types: ['Sorcery'],
        oracle: '');

    // deckTwin: EXACTAMENTE las mismas 30 cartas y el mismo pool que
    // deckReanimator (misma gorda, mismo mill que le llena la tumba igual),
    // con los 4 Exhume sustituidos por Idle Ritual (mismo coste, sin
    // efecto). La ÚNICA variable entre los dos mazos es "puede reanimar lo
    // que el mill encuentra" — así el >55% mide reanimación, no diferencias
    // de tamaño de mazo o de pool.
    final poolTwin = {
      'Swamp': swamp(),
      'Zombie Titan': fatty,
      'Cryptic Excavation': millSpell,
      'Idle Ritual': doNothing,
    };
    final deckTwin = Deck(
      name: 'Twin sin reanimación',
      colors: 'B',
      archetype: Archetype.midrange,
      cards: const {
        'Zombie Titan': 4,
        'Idle Ritual': 4,
        'Cryptic Excavation': 8,
      },
      lands: const {'Swamp': 14},
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

    test(
        '"target player mills" no es autotumba: reanimator con eso en vez '
        'de mill propio rinde mucho peor', () {
      // mismo número (tres) pero AJENO: "target player mills" no debe
      // contar como millSelf (podría llenar la tumba del RIVAL, no la tuya).
      const ambiguousMill = Card(
          name: 'Ambiguous Mill',
          qty: 8,
          manaCost: '{B}',
          cmc: 1,
          colors: 'B',
          types: ['Sorcery'],
          oracle: 'Target player mills three cards.');
      final poolAmbiguo = {
        'Swamp': swamp(),
        'Zombie Titan': fatty,
        'Exhume': exhume,
        'Ambiguous Mill': ambiguousMill,
      };
      final deckAmbiguo = Deck(
        name: 'Reanimator con mill ajeno',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {'Zombie Titan': 4, 'Exhume': 4, 'Ambiguous Mill': 8},
        lands: const {'Swamp': 14},
      );
      final conMillPropio = simulateMatch(
          deckReanimator, poolReanimator, deckTwin, poolTwin,
          games: 150, seed: 7);
      final conMillAjeno = simulateMatch(
          deckAmbiguo, poolAmbiguo, deckTwin, poolTwin,
          games: 150, seed: 7);
      expect(conMillPropio, greaterThan(conMillAjeno));
    });

    test(
        'una gorda cuyo propio texto reanima (Karmic Guide-style) entra '
        'ELLA TAMBIÉN al campo, no se tira a la basura', () {
      // Control aislado de verdad: Karmic Golem es EXACTAMENTE la misma
      // criatura que Karmic Guide (mismo coste, mismo cuerpo 3/3) pero SIN
      // reanimar — mismo camino de prioridad 3 disponible para las dos, así
      // que la "flexibilidad de ser criatura" no contamina la comparación
      // (con un control que fuera un hechizo no-criatura, esa flexibilidad
      // por sí sola ya habría dado ventaja a la criatura, con o sin el fix).
      //
      // El objetivo reanimado (Grave Ghoul, cmc>=5) tiene EL MISMO cuerpo
      // 3/3 que Karmic Guide: si el bug tirase a la basura el cuerpo de
      // Karmic Guide, "reanimar un 3/3 y perder el propio 3/3" da el MISMO
      // poder total en mesa (3) que "solo entrar como un 3/3" (Karmic
      // Golem) — un empate que demuestra que el fix hace falta. Arreglado,
      // Karmic Guide deja DOS cuerpos (6 de poder) por el mismo maná.
      const graveGhoul = Card(
          name: 'Grave Ghoul',
          qty: 4,
          manaCost: '{4}{B}',
          cmc: 5,
          colors: 'B',
          types: ['Creature'],
          oracle: '',
          power: 3,
          toughness: 3);
      // cmc3 (más caro que el mill de {B}): para cuando sea pagable, casi
      // siempre ya hay una gorda en la tumba y el hechizo pasa SIEMPRE por
      // la prioridad 2.5 (no por la 3) — así el test aísla justo la rama
      // que estaba rota, no la prioridad 3 (que ya añadía el cuerpo bien
      // antes del fix).
      const karmicGuide = Card(
          name: 'Karmic Guide',
          qty: 4,
          manaCost: '{2}{B}',
          cmc: 3,
          colors: 'B',
          types: ['Creature'],
          oracle:
              'When this creature enters, return target creature card from your graveyard to the battlefield.',
          power: 3,
          toughness: 3);
      const karmicGolem = Card(
          name: 'Karmic Golem',
          qty: 4,
          manaCost: '{2}{B}',
          cmc: 3,
          colors: 'B',
          types: ['Creature'],
          oracle: '', // vainilla: mismo cuerpo, sin reanimar nada
          power: 3,
          toughness: 3);

      final poolKarmic = {
        'Swamp': swamp(),
        'Grave Ghoul': graveGhoul,
        'Karmic Guide': karmicGuide,
        'Cryptic Excavation': millSpell,
      };
      final deckKarmic = Deck(
        name: 'Reanimator con cuerpo',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {
          'Grave Ghoul': 4,
          'Karmic Guide': 4,
          'Cryptic Excavation': 8,
        },
        lands: const {'Swamp': 14},
      );
      final poolGolem = {
        'Swamp': swamp(),
        'Grave Ghoul': graveGhoul,
        'Karmic Golem': karmicGolem,
        'Cryptic Excavation': millSpell,
      };
      final deckGolem = Deck(
        name: 'Control: mismo cuerpo, sin reanimar',
        colors: 'B',
        archetype: Archetype.midrange,
        cards: const {
          'Grave Ghoul': 4,
          'Karmic Golem': 4,
          'Cryptic Excavation': 8,
        },
        lands: const {'Swamp': 14},
      );

      final wrConCuerpo = simulateMatch(
          deckKarmic, poolKarmic, deckTwin, poolTwin, games: 300, seed: 7);
      final wrControl = simulateMatch(
          deckGolem, poolGolem, deckTwin, poolTwin, games: 300, seed: 7);
      // Karmic Guide deja DOS cuerpos en mesa (el suyo + el reanimado) por
      // el mismo maná que Karmic Golem deja UNO: tiene que rendir mejor. Si
      // el bug tirase su propio cuerpo a la basura, esto sería un empate
      // (mismo poder total: un 3/3 en cualquiera de los dos casos).
      expect(wrConCuerpo, greaterThan(wrControl));
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
        cards: const {'Zombie Titan': 4, 'Cryptic Excavation': 8},
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

  group('M4: el loot no se come dos cartas', () {
    Card land(String name, {int qty = 32}) => Card(
        name: name,
        qty: qty,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: const ['Basic', 'Land'],
        oracle: '');

    Card weenie() => Card(
        name: 'Weenie',
        qty: 12,
        manaCost: '{B}',
        cmc: 1,
        colors: 'B',
        types: const ['Creature'],
        oracle: '',
        power: 1,
        toughness: 1);

    // Looter es el hechizo NO-criatura más caro del mazo (cmc 2, todo lo
    // demás es tierra o Weenie cmc 1): en cuanto se acaban las Weenie por
    // jugar, casi siempre es la única/peor carta candidata en mano — el
    // escenario exacto donde `pick == worst` por identidad (M4).
    const looter = Card(
        name: 'Looter',
        qty: 16,
        manaCost: '{2}',
        cmc: 2,
        colors: 'B',
        types: ['Sorcery'],
        oracle: 'Draw a card, then discard a card.');

    // Blank: mismo coste y tipo que Looter, pero sin efecto — el gemelo de
    // control con el que comparar. Un loot que funcione bien filtra cartas
    // y por tanto debe rendir IGUAL o MEJOR que no hacer nada; si el bug se
    // come una carta de más por activación, cae por debajo de ese gemelo.
    const blank = Card(
        name: 'Blank',
        qty: 16,
        manaCost: '{2}',
        cmc: 2,
        colors: 'B',
        types: ['Sorcery'],
        oracle: '');

    final poolLoot = {
      'Swamp': land('Swamp'),
      'Weenie': weenie(),
      'Looter': looter,
    };
    final deckLoot = Deck(
      name: 'Con loot',
      colors: 'B',
      archetype: Archetype.aggro,
      cards: const {'Weenie': 12, 'Looter': 16},
      lands: const {'Swamp': 32},
    );
    final poolBlank = {
      'Swamp': land('Swamp'),
      'Weenie': weenie(),
      'Blank': blank,
    };
    final deckBlank = Deck(
      name: 'Gemelo sin loot',
      colors: 'B',
      archetype: Archetype.aggro,
      cards: const {'Weenie': 12, 'Blank': 16},
      lands: const {'Swamp': 32},
    );

    test('el loot rinde razonable contra su gemelo, no muy por debajo de '
        '"no hacer nada" (medido: 0,88 buggy vs 0,69 arreglado)', () {
      final wr = simulateMatch(deckLoot, poolLoot, deckBlank, poolBlank,
          games: 400, seed: 7);
      // Con el bug (:468+:480 borran dos copias por identidad cuando el
      // loot se elige a sí mismo como "peor carta"), este enfrentamiento da
      // ~0,88 — de más, porque encima de perder su propia carta al
      // castearse, a menudo se come UNA SEGUNDA de la mano sin que el
      // efecto de loot la cuente. Arreglado da ~0,69: sigue ganando (filtra
      // bien) pero sin la ventaja inflada por la carta de más.
      expect(wr, lessThan(0.8));
    });
  });
}
