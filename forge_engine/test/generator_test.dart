import 'dart:convert';
import 'dart:io';

import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests del generador (fase 3) contra la colección real de los fixtures —
/// espejo de `engine-reference/tests/test_generator.py`.
void main() {
  late Map<String, Card> pool;

  setUpAll(() {
    final raw = jsonDecode(
            File('../engine-reference/fixtures/pool.json').readAsStringSync())
        as Map<String, dynamic>;
    pool = raw.map((name, json) =>
        MapEntry(name, Card.fromJson(name, json as Map<String, dynamic>)));
  });

  test('clasifica cartas conocidas', () {
    expect(classify(pool['Murder']!), contains('removal'));
    expect(classify(pool['Counterspell']!), contains('counterspell'));
    expect(classify(pool['Llanowar Elves']!), contains('ramp'));
  });

  test('roles de tema: lifegain', () {
    expect(themeRoles(pool['Marauding Blight-Priest']!)['lifegain'], 'payoff');
    expect(themeRoles(pool["Healer's Hawk"]!)['lifegain'], 'enabler');
  });

  test('todo mazo generado pasa el validador (regla 6)', () {
    final proposals = generateProposals(pool);
    expect(proposals.length, greaterThanOrEqualTo(2),
        reason: 'la colección real da para varias propuestas');
    for (final gen in proposals) {
      expect(DeckValidator.validate(gen.deck, pool), isEmpty,
          reason: gen.deck.name);
    }
  });

  test('en WB el tema natural es lifegain', () {
    final gen = generateDeck(pool, 'WB');
    expect(gen, isNotNull);
    expect(gen!.theme, 'lifegain');
  });

  test('respeta tierras escasas: RG imposible => null, nunca defectuoso', () {
    // Solo hay 2 Mountains y 4 Forests en la colección.
    expect(generateDeck(pool, 'RG'), isNull);
  });

  test('las propuestas tienen identidades distintas', () {
    final proposals = generateProposals(pool);
    final colors = proposals.map((g) => g.deck.colors).toSet();
    expect(colors.length, proposals.length);
  });

  test('un pool de respuestas sin criaturas se lee como control', () {
    final cands = {
      for (var i = 0; i < 10; i++)
        'Removal $i': Card(
            name: 'Removal $i',
            qty: 4,
            manaCost: '{2}{B}',
            cmc: 3,
            colors: 'B',
            types: const ['Instant'],
            oracle: 'Destroy target creature.'),
      for (var i = 0; i < 12; i++)
        'Filler $i': Card(
            name: 'Filler $i',
            qty: 4,
            manaCost: '{3}{B}',
            cmc: 4,
            colors: 'B',
            types: const ['Sorcery'],
            oracle: 'Each player discards a card.'),
    };
    expect(pickArchetype(cands), 'control');
  });

  test('archetypeFor encuentra perfil para combos sanos y rechaza locuras', () {
    expect(archetypeFor(2.9, 24), isNotNull);
    expect(archetypeFor(1.2, 27), isNull); // curva agresiva con 27 tierras
  });

  test('reforgeWithCurve respeta la curva pedida y las reglas duras', () {
    final base = generateDeck(pool, 'WB');
    expect(base, isNotNull);
    final hist =
        ManaCurve.curveHistogram(base!.deck.cards, pool, cap: 6);
    final result = reforgeWithCurve(pool, 'WB', hist);
    expect(result.deck, isNotNull, reason: result.reason ?? '');
    final deck = result.deck!.deck;
    expect(DeckValidator.validate(deck, pool), isEmpty);
    expect(deck.totalCards, ManaCurve.deckSize);
  });

  test('reforgeWithCurve avisa cuando la curva no da mazo sano', () {
    // 45 hechizos => solo 15 tierras: fuera de todo rango.
    final result = reforgeWithCurve(pool, 'WB', {1: 20, 2: 15, 3: 10});
    expect(result.deck, isNull);
    expect(result.reason, isNotEmpty);
  });

  group('detectTheme: color pie desempata (Task 8)', () {
    Map<String, Card> tiedPool() => {
          for (var i = 0; i < 3; i++)
            'Lifegain Payoff $i': Card(
                name: 'Lifegain Payoff $i',
                qty: 1,
                manaCost: '{2}{W}',
                cmc: 3,
                colors: 'W',
                types: const ['Creature'],
                oracle: 'Whenever you gain life, draw a card.'),
          for (var i = 0; i < 3; i++)
            'Spells Payoff $i': Card(
                name: 'Spells Payoff $i',
                qty: 1,
                manaCost: '{1}{U}',
                cmc: 2,
                colors: 'U',
                types: const ['Creature'],
                oracle: 'Whenever you cast an instant or sorcery spell, '
                    'draw a card.'),
        };

    test('empate lifegain/spells: en WB gana lifegain (su color pie)', () {
      final (theme, _) = detectTheme(tiedPool(), colors: 'WB');
      expect(theme, 'lifegain');
    });

    test('empate lifegain/spells: en UR gana spells (su color pie)', () {
      final (theme, _) = detectTheme(tiedPool(), colors: 'UR');
      expect(theme, 'spells');
    });

    test('sin colores, el peso crudo decide (sin multiplicador)', () {
      final (theme, _) = detectTheme(tiedPool());
      // pesos crudos empatados (9 y 9): gana el primero en iterar el mapa
      // (lifegain, declarado antes que spells en _themes) — determinista,
      // y el espejo Python da lo mismo.
      expect(theme, 'lifegain');
    });
  });

  group('efficiency: pesos de combate (Task 7)', () {
    Card creature(String name, String oracle,
            {int power = 2, int toughness = 2, int cmc = 2}) =>
        Card(
            name: name,
            qty: 1,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: '',
            types: const ['Creature'],
            oracle: oracle,
            power: power,
            toughness: toughness);

    test('volador vale más que arrollador pequeño a igualdad de stats', () {
      final flier = creature('Flier', 'Flying');
      final trampler = creature('Trampler', 'Trample');
      expect(efficiency(flier), greaterThan(efficiency(trampler)));
    });

    test('arrollar escala con el poder', () {
      final bigTrampler =
          creature('Big Trampler', 'Trample', power: 6, toughness: 6, cmc: 6);
      final bigReacher =
          creature('Big Reacher', 'Reach', power: 6, toughness: 6, cmc: 6);
      expect(efficiency(bigTrampler), greaterThan(efficiency(bigReacher)));
    });

    test('prisa vale más en aggro', () {
      final hasty = creature('Hasty', 'Haste');
      expect(efficiency(hasty, archetype: 'aggro'),
          greaterThan(efficiency(hasty)));
    });

    test('tope +2.0: keyword soup no rompe la escala', () {
      final kitchenSink = creature(
          'Kitchen Sink',
          'Flying, double strike, menace, haste, deathtouch, lifelink, '
          'first strike, vigilance, reach, trample',
          power: 6,
          toughness: 6,
          cmc: 6);
      expect(efficiency(kitchenSink), lessThanOrEqualTo(10));
    });

    test('sin columna keywords cae al oracle (double strike cuenta como '
        'first strike no)', () {
      final ds = creature('Double Strike Guy', 'Double strike', cmc: 3);
      final plain =
          creature('Plain Guy', 'Vanilla creature with no abilities.', cmc: 3);
      // Solo pesa double strike (0.9): si first strike también contara por
      // el fallback, la diferencia sería 0.9+0.5.
      expect(
          efficiency(ds) - efficiency(plain), closeTo(0.9, 1e-9));
    });
  });

  group('tema reanimator (Task 10)', () {
    int copiasCmc5oMas(Map<String, Card> pool, Deck deck) {
      var n = 0;
      deck.cards.forEach((name, qty) {
        if ((pool[name]?.cmc ?? 0) >= 5) n += qty;
      });
      return n;
    }

    // Pool control (interacción+gordas, sin payoff de reanimación) para
    // hacer control negativo: mismo perfil de arquetipo, distinto tema.
    Map<String, Card> basePool({bool withPayoff = true}) {
      final p = <String, Card>{
        'Swamp': const Card(
            name: 'Swamp',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {B}.'),
        'Charnel Scavenger': const Card(
            name: 'Charnel Scavenger',
            qty: 4,
            manaCost: '{1}{B}',
            cmc: 2,
            colors: 'B',
            types: ['Sorcery'],
            oracle: 'Discard a card, then mill 3 cards.'),
        'Read the Bones': const Card(
            name: 'Read the Bones',
            qty: 4,
            manaCost: '{2}{B}',
            cmc: 3,
            colors: 'B',
            types: ['Sorcery'],
            oracle: 'Draw two cards.'),
      };
      if (withPayoff) {
        p['Raise from the Grave'] = const Card(
            name: 'Raise from the Grave',
            qty: 4,
            manaCost: '{2}{B}',
            cmc: 3,
            colors: 'B',
            types: ['Sorcery'],
            oracle:
                'Return target creature card from your graveyard to the battlefield.');
      }
      for (var i = 0; i < 3; i++) {
        final name = 'Grave Titan Clone $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{3}{B}{B}',
            cmc: 5,
            colors: 'B',
            types: const ['Creature'],
            oracle: '',
            power: 7,
            toughness: 7);
      }
      for (var i = 0; i < 5; i++) {
        final name = 'Removal $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{1}{B}',
            cmc: 2,
            colors: 'B',
            types: const ['Instant'],
            oracle: 'Destroy target creature.');
      }
      for (var i = 0; i < 2; i++) {
        final name = 'Sweeper $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{3}{B}',
            cmc: 4,
            colors: 'B',
            types: const ['Sorcery'],
            oracle: 'Destroy all creatures.');
      }
      const curveCmc = [1, 2, 3, 4];
      for (var i = 0; i < curveCmc.length; i++) {
        final cmc = curveCmc[i];
        final name = 'Filler Creature $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: '',
            types: const ['Creature'],
            oracle: '',
            power: cmc,
            toughness: cmc);
      }
      return p;
    }

    test(
        'pool con reanimación+mill+gordas detecta reanimator y mete gordas',
        () {
      final pool = basePool();
      final gen = generateDeck(pool, 'B')!;
      expect(gen.theme, 'reanimator');
      expect(copiasCmc5oMas(pool, gen.deck), greaterThanOrEqualTo(4));
    });

    test(
        'control negativo: sin hechizos de reanimación las gordas se quedan '
        'fuera', () {
      final gen = generateDeck(basePool(withPayoff: false), 'B');
      expect(gen == null || gen.theme != 'reanimator', isTrue);
    });

    test('el validador sigue mandando: coste medio dentro del arquetipo', () {
      final pool = basePool();
      final gen = generateDeck(pool, 'B')!;
      expect(DeckValidator.validate(gen.deck, pool), isEmpty);
    });
  });

  group('temas tribales (Task 11)', () {
    int copiasDelSubtipo(
        Map<String, Card> pool, Deck deck, String subtype) {
      var n = 0;
      deck.cards.forEach((name, qty) {
        if ((pool[name]?.subtypes ?? const []).contains(subtype)) n += qty;
      });
      return n;
    }

    // 14 elfos + 4 payoffs («Other Elves you control get…», el plural
    // irregular real de Magic) en G.
    Map<String, Card> elfPool({bool withPayoff = true}) {
      final p = <String, Card>{
        'Forest': const Card(
            name: 'Forest',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {G}.'),
      };
      const elfQty = [4, 4, 3, 3];
      for (var i = 0; i < elfQty.length; i++) {
        final name = 'Elf Warrior $i';
        p[name] = Card(
            name: name,
            qty: elfQty[i],
            manaCost: '{G}',
            cmc: 1,
            colors: 'G',
            types: const ['Creature'],
            subtypes: const ['Elf'],
            oracle: '',
            power: 1,
            toughness: 1);
      }
      if (withPayoff) {
        p['Elvish Chieftain'] = const Card(
            name: 'Elvish Chieftain',
            qty: 4,
            manaCost: '{1}{G}',
            cmc: 2,
            colors: 'G',
            types: ['Creature'],
            subtypes: ['Elf'],
            oracle: 'Other Elves you control get +1/+1.',
            power: 2,
            toughness: 2);
      }
      const curveCmc = [1, 2, 2, 3, 3, 4];
      for (var i = 0; i < curveCmc.length; i++) {
        final cmc = curveCmc[i];
        final name = 'Filler Beast $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: 'G',
            types: const ['Creature'],
            oracle: '',
            power: cmc,
            toughness: cmc);
      }
      return p;
    }

    test('14 elfos + payoffs en G detecta tribal:Elf y mete elfos de sobra',
        () {
      final pool = elfPool();
      final gen = generateDeck(pool, 'G')!;
      expect(gen.theme, 'tribal:Elf');
      expect(copiasDelSubtipo(pool, gen.deck, 'Elf'), greaterThanOrEqualTo(10));
    });

    test('control: 14 elfos SIN payoffs no hacen tema tribal', () {
      final gen = generateDeck(elfPool(withPayoff: false), 'G');
      expect(gen == null || gen.theme != 'tribal:Elf', isTrue);
    });

    test('tribalRole reconoce plurales irregulares (-f/-fe -> -ves), no '
        'solo el +s regular', () {
      Card payoff(String oracle) => Card(
          name: 'Payoff',
          qty: 1,
          manaCost: '{1}{G}',
          cmc: 2,
          colors: 'G',
          types: const ['Creature'],
          oracle: oracle);
      // El literal del brief: "Elves" no contiene "elf" ni "elfs" como
      // substring (no hay 'f' en "elves"), solo el irregular "-ves" lo pilla.
      expect(tribalRole(payoff('Other Elves you control get +1/+1.'), 'Elf'),
          'payoff');
      expect(
          tribalRole(
              payoff('Other Dwarves you control get +1/+1.'), 'Dwarf'),
          'payoff');
      expect(
          tribalRole(payoff('Other Wolves you control get +1/+1.'), 'Wolf'),
          'payoff');
      // Regular +s sigue funcionando (no es un caso irregular).
      expect(
          tribalRole(
              payoff('Other Goblins you control get +1/+1.'), 'Goblin'),
          'payoff');
    });

    test('tribalRole no confunde subcadenas: rather/rat, duplicate/cat, '
        'changeling/angel, itself/elf (C1)', () {
      Card payoff(String oracle) => Card(
          name: 'Trap',
          qty: 1,
          manaCost: '{1}{G}',
          cmc: 2,
          colors: 'G',
          types: const ['Creature'],
          oracle: oracle);
      expect(
          tribalRole(
              payoff("You may pay 4 life rather than pay this spell's mana "
                  'cost. Whenever you cast a spell this way, draw a card.'),
              'Rat'),
          isNull);
      expect(
          tribalRole(
              payoff('Whenever you duplicate a token, each opponent loses '
                  '1 life.'),
              'Cat'),
          isNull);
      expect(
          tribalRole(
              payoff('Changeling. Whenever this creature attacks, each '
                  'opponent loses 1 life.'),
              'Angel'),
          isNull);
      expect(
          tribalRole(
              payoff('Whenever this creature deals damage to itself, each '
                  'player draws a card.'),
              'Elf'),
          isNull);
    });
  });

  group('selector de Estilo: themeOverride (Task 13b)', () {
    int copiasConSubtipo(Map<String, Card> pool, Deck deck, String subtype) {
      var n = 0;
      deck.cards.forEach((name, qty) {
        if ((pool[name]?.subtypes ?? const []).contains(subtype)) n += qty;
      });
      return n;
    }

    // G: 14 elfos + payoff (masa tribal de sobra) MÁS un tema 'tokens' más
    // pesado (payoffs y color pie propio): sin override el motor elegiría
    // 'tokens', no la tribu.
    Map<String, Card> poolMixto() {
      final p = <String, Card>{
        'Forest': const Card(
            name: 'Forest',
            qty: 40,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {G}.'),
      };
      const elfQty = [4, 4, 3, 3];
      for (var i = 0; i < elfQty.length; i++) {
        final name = 'Elf Warrior $i';
        p[name] = Card(
            name: name,
            qty: elfQty[i],
            manaCost: '{G}',
            cmc: 1,
            colors: 'G',
            types: const ['Creature'],
            subtypes: const ['Elf'],
            oracle: '',
            power: 1,
            toughness: 1);
      }
      p['Elvish Chieftain'] = const Card(
          name: 'Elvish Chieftain',
          qty: 4,
          manaCost: '{1}{G}',
          cmc: 2,
          colors: 'G',
          types: ['Creature'],
          subtypes: ['Elf'],
          oracle: 'Other Elves you control get +1/+1.',
          power: 2,
          toughness: 2);
      for (var i = 0; i < 4; i++) {
        final name = 'Token Maker $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{2}',
            cmc: 2,
            colors: 'G',
            types: const ['Creature'],
            oracle:
                'When this creature enters, create a 1/1 green Elemental creature token.',
            power: 2,
            toughness: 2);
      }
      for (var i = 0; i < 4; i++) {
        final name = 'Token Payoff $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{3}{G}',
            cmc: 4,
            colors: 'G',
            types: const ['Creature'],
            oracle:
                'Whenever another creature you control enters, you gain 1 life.',
            power: 3,
            toughness: 3);
      }
      const curveCmc = [1, 2, 3, 3, 4];
      for (var i = 0; i < curveCmc.length; i++) {
        final cmc = curveCmc[i];
        final name = 'Filler Beast $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: 'G',
            types: const ['Creature'],
            oracle: '',
            power: cmc,
            toughness: cmc);
      }
      return p;
    }

    test('sin override, el pool mixto pesa más tokens que tribal:Elf', () {
      // control: confirma que el peso natural es de verdad otro tema, para
      // que el test de abajo demuestre que el override lo pisa. Se mira
      // detectTheme directamente (no generateDeck): con el pool sesgado a
      // pagar el tema tokens, el arquetipo auto-detectado (aggro) puede no
      // encajar con esa curva — algo aparte de lo que aquí se prueba.
      final pool = poolMixto();
      final cands = Map.fromEntries(
          pool.entries.where((e) => !e.value.types.contains('Land')));
      final (theme, _) = detectTheme(cands, colors: 'G');
      expect(theme, isNot('tribal:Elf'));
    });

    test('themeOverride tribal fuerza elfos aunque el peso natural sea otro',
        () {
      final pool = poolMixto();
      final gen =
          generateDeck(pool, 'G', themeOverride: 'tribal:Elf')!;
      expect(gen.theme, 'tribal:Elf');
      expect(copiasConSubtipo(pool, gen.deck, 'Elf'), greaterThanOrEqualTo(12));
    });

    // W: un solo payoff de lifegain con 2 copias — por debajo del mínimo de
    // 3 que exige detectTheme para elegirlo solo.
    Map<String, Card> poolPocoLifegain() {
      final p = <String, Card>{
        'Plains': const Card(
            name: 'Plains',
            qty: 40,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {W}.'),
        'Lifegain Payoff': const Card(
            name: 'Lifegain Payoff',
            qty: 2,
            manaCost: '{2}{W}',
            cmc: 3,
            colors: 'W',
            types: ['Creature'],
            oracle:
                'Whenever you gain life, put a +1/+1 counter on this creature.',
            power: 2,
            toughness: 2),
      };
      // suficientes nombres (>= lo que pide un mazo de 60 con esta identidad)
      // para que el greedy pueda llenar el mazo entero, no solo el tema.
      const curveCmc = [1, 2, 2, 2, 3, 3, 3, 4, 4, 5];
      for (var i = 0; i < curveCmc.length; i++) {
        final cmc = curveCmc[i];
        final name = 'Filler $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: 'W',
            types: const ['Creature'],
            oracle: '',
            power: cmc,
            toughness: cmc);
      }
      return p;
    }

    test('override mecánico salta el gate de payoffs (mejor-esfuerzo)', () {
      expect(
          generateDeck(poolPocoLifegain(), 'W', themeOverride: 'lifegain'),
          isNotNull);
    });

    // U: nada de elfos, pero SÍ cartas trampa (item 11): una que un scanner
    // de subcadena confundiría con payoff de Elf ("itself" contiene "elf"
    // sin frontera de palabra — C1) y otra con payoff léxicamente REAL
    // ("Elves" con frontera de palabra) pero sin un solo cuerpo Elf en el
    // pool (el guard debe rechazar igual — C2). Demuestran los dos bugs a
    // la vez: el test de abajo falla sin los fixes y pasa con ellos.
    Map<String, Card> poolSinElfos() {
      final p = <String, Card>{
        'Island': const Card(
            name: 'Island',
            qty: 40,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {U}.'),
        'Reflexive Striker': const Card(
            name: 'Reflexive Striker',
            qty: 4,
            manaCost: '{2}{U}',
            cmc: 3,
            colors: 'U',
            types: ['Creature'],
            oracle: 'Whenever this creature blocks, it deals damage to '
                'itself. Each opponent loses 1 life this turn.',
            power: 2,
            toughness: 2),
        'Fake Elf Payoff': const Card(
            name: 'Fake Elf Payoff',
            qty: 4,
            manaCost: '{1}{U}',
            cmc: 2,
            colors: 'U',
            types: ['Creature'],
            oracle: 'Other Elves you control get +1/+1.',
            power: 2,
            toughness: 2),
      };
      const curveCmc = [1, 1, 2, 2, 3, 3, 4, 4, 5];
      for (var i = 0; i < curveCmc.length; i++) {
        final cmc = curveCmc[i];
        final name = 'Filler $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: 'U',
            types: const ['Creature'],
            oracle: '',
            power: cmc,
            toughness: cmc);
      }
      return p;
    }

    test('estilo imposible en ese color => null', () {
      expect(
          generateDeck(poolSinElfos(), 'U', themeOverride: 'tribal:Elf'),
          isNull);
    });

    // G: la tribu entera son lords — criaturas del subtipo cuyo texto
    // TAMBIÉN es payoff («Other Elves you control…»). tribalRole las
    // clasifica 'payoff' (ese check va primero), así que un guard que solo
    // contase rol 'enabler' rechazaría en falso un mazo tribal legítimo:
    // la masa de cuerpos se cuenta por subtipo, no por rol.
    Map<String, Card> poolSoloLords() {
      final p = <String, Card>{
        'Forest': const Card(
            name: 'Forest',
            qty: 40,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {G}.'),
      };
      const lordCmc = [1, 2, 2, 3, 4];
      for (var i = 0; i < lordCmc.length; i++) {
        final cmc = lordCmc[i];
        final name = 'Elf Lord $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{${cmc - 1}}{G}',
            cmc: cmc,
            colors: 'G',
            types: const ['Creature'],
            subtypes: const ['Elf'],
            oracle: 'Other Elves you control get +1/+1.',
            power: cmc,
            toughness: cmc);
      }
      const curveCmc = [1, 2, 3, 3, 4];
      for (var i = 0; i < curveCmc.length; i++) {
        final cmc = curveCmc[i];
        final name = 'Filler Beast $i';
        p[name] = Card(
            name: name,
            qty: 4,
            manaCost: '{$cmc}',
            cmc: cmc,
            colors: 'G',
            types: const ['Creature'],
            oracle: '',
            power: cmc,
            toughness: cmc);
      }
      return p;
    }

    test('lords (cuerpo + texto payoff) cuentan como masa tribal, no se '
        'rechaza el mazo', () {
      final pool = poolSoloLords();
      final gen = generateDeck(pool, 'G', themeOverride: 'tribal:Elf');
      expect(gen, isNotNull);
      expect(copiasConSubtipo(pool, gen!.deck, 'Elf'),
          greaterThanOrEqualTo(minTribeMembersInDeck));
    });

    test('generateProposals propaga themeOverride a todas las identidades',
        () {
      final proposals = generateProposals(poolMixto(),
          allowedColors: 'GW', themeOverride: 'tribal:Elf');
      expect(proposals, isNotEmpty);
      for (final gen in proposals) {
        expect(gen.theme, 'tribal:Elf');
      }
    });
  });
}
