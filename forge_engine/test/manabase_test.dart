import 'package:forge_engine/forge_engine.dart';
import 'package:test/test.dart';

/// Tests espejo de `engine-reference/tests/test_manabase.py`.
void main() {
  group('buildManaBase', () {
    test('con duales cumple Karsten donde las básicas no llegan', () {
      // 4x doble-símbolo {W}{W} t2 y 4x {U}{U} t2 => 20+20 fuentes: imposible
      // con 24 básicas. 2 duales distintos (4 copias cada uno = 8 usables)
      // más básicas nombradas para que el desempate por nombre favorezca W
      // ('A White Land' < 'Z Blue Land'), simétrico al caso solo-básicas.
      final spellsWWyUU = {'WW Card': 4, 'UU Card': 4};
      final poolConDuales8 = <String, Card>{
        'WW Card': const Card(
            name: 'WW Card',
            qty: 4,
            manaCost: '{W}{W}',
            cmc: 2,
            colors: 'W',
            types: ['Creature'],
            oracle: ''),
        'UU Card': const Card(
            name: 'UU Card',
            qty: 4,
            manaCost: '{U}{U}',
            cmc: 2,
            colors: 'U',
            types: ['Creature'],
            oracle: ''),
        'WU Dual A': const Card(
            name: 'WU Dual A',
            qty: 4,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W} or {U}.'),
        'WU Dual B': const Card(
            name: 'WU Dual B',
            qty: 4,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W} or {U}.'),
        'A White Land': const Card(
            name: 'A White Land',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {W}.'),
        'Z Blue Land': const Card(
            name: 'Z Blue Land',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Basic', 'Land'],
            oracle: '{T}: Add {U}.'),
      };
      final poolSoloBasicas = <String, Card>{
        'WW Card': poolConDuales8['WW Card']!,
        'UU Card': poolConDuales8['UU Card']!,
        'A White Land': poolConDuales8['A White Land']!,
        'Z Blue Land': poolConDuales8['Z Blue Land']!,
      };

      final r = buildManaBase(spellsWWyUU, poolConDuales8, 'WU', 24,
          archetypeName: 'midrange')!;
      expect(
          r.sourcesByColor['W']!,
          greaterThanOrEqualTo(
              r.lands.values.fold(0, (a, b) => a + b) < 24 ? 0 : 16));
      // la manabase con duales domina a la de solo básicas en la peor fuente:
      final soloBasicas = buildManaBase(spellsWWyUU, poolSoloBasicas, 'WU', 24,
          archetypeName: 'midrange')!;
      double worst(ManabaseResult m) => ['W', 'U']
          .map((c) => m.sourcesByColor[c]! / m.requiredByColor[c]!)
          .reduce((a, b) => a < b ? a : b);
      expect(worst(r), greaterThan(worst(soloBasicas)));
    });

    test('respeta tope de taplands por arquetipo', () {
      final spells = {'R Card': 4, 'G Card': 4};
      final poolConMuchosTaplands = <String, Card>{
        'R Card': const Card(
            name: 'R Card',
            qty: 4,
            manaCost: '{R}',
            cmc: 1,
            colors: 'R',
            types: ['Creature'],
            oracle: ''),
        'G Card': const Card(
            name: 'G Card',
            qty: 4,
            manaCost: '{G}',
            cmc: 1,
            colors: 'G',
            types: ['Creature'],
            oracle: ''),
        'Tapland A': const Card(
            name: 'Tapland A',
            qty: 4,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: 'This land enters the battlefield tapped.\n'
                '{T}: Add {R} or {G}.'),
        'Tapland B': const Card(
            name: 'Tapland B',
            qty: 4,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: 'This land enters the battlefield tapped.\n'
                '{T}: Add {R} or {G}.'),
        'Tapland C': const Card(
            name: 'Tapland C',
            qty: 4,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: 'This land enters the battlefield tapped.\n'
                '{T}: Add {R} or {G}.'),
        'Mountain': const Card(
            name: 'Mountain',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {R}.'),
        'Forest': const Card(
            name: 'Forest',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {G}.'),
      };
      final r = buildManaBase(spells, poolConMuchosTaplands, 'RG', 22,
          archetypeName: 'aggro')!;
      final tap = r.lands.entries
          .where((e) =>
              LandProfile.fromCard(poolConMuchosTaplands[e.key]!).tapped ==
              TappedKind.always)
          .fold(0, (a, e) => a + e.value);
      expect(tap, lessThanOrEqualTo(2));
    });

    test('fetch cuenta como fuente de ambos colores', () {
      final spells = {'Card RW': 4};
      final pool = <String, Card>{
        'Card RW': const Card(
            name: 'Card RW',
            qty: 4,
            manaCost: '{R}{W}',
            cmc: 2,
            colors: 'RW',
            types: ['Creature'],
            oracle: ''),
        'Fetch RW': const Card(
            name: 'Fetch RW',
            qty: 4,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: 'Search your library for a Plains or Mountain land '
                'card, put it onto the battlefield, then shuffle.'),
      };
      // sin básicas de ningún color: solo el fetch tipado cubre ambos a la vez.
      final r = buildManaBase(spells, pool, 'RW', 4, archetypeName: 'midrange');
      expect(r, isNotNull);
      expect(r!.sourcesByColor['R'], greaterThan(0));
      expect(r.sourcesByColor['W'], greaterThan(0));
      expect(r.lands['Fetch RW'], greaterThan(0));
    });

    test('máx 4 copias de no-básica; básicas libres; nunca más de lo poseído',
        () {
      final spells = {'W Card': 4, 'U Card': 4};
      final pool = <String, Card>{
        'W Card': const Card(
            name: 'W Card',
            qty: 4,
            manaCost: '{W}{W}',
            cmc: 2,
            colors: 'W',
            types: ['Creature'],
            oracle: ''),
        'U Card': const Card(
            name: 'U Card',
            qty: 4,
            manaCost: '{U}{U}',
            cmc: 2,
            colors: 'U',
            types: ['Creature'],
            oracle: ''),
        'Dual WU': const Card(
            name: 'Dual WU',
            qty: 10,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W} or {U}.'),
        'Plains': const Card(
            name: 'Plains',
            qty: 3,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W}.'),
        'Island': const Card(
            name: 'Island',
            qty: 3,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {U}.'),
      };
      final r = buildManaBase(spells, pool, 'WU', 10,
          archetypeName: 'midrange')!;
      expect(r.lands['Dual WU'], 4); // tope de copyCap pese a poseer 10
      expect(r.lands['Plains'], 3); // nunca más de lo poseído
      expect(r.lands['Island'], 3);
    });

    test('monocolor sin duales = comportamiento de hoy (todo básicas)', () {
      final spellsMonoW = {'W Card': 20};
      final poolSoloBasicas = <String, Card>{
        'W Card': const Card(
            name: 'W Card',
            qty: 20,
            manaCost: '{W}',
            cmc: 1,
            colors: 'W',
            types: ['Creature'],
            oracle: ''),
        'Plains': const Card(
            name: 'Plains',
            qty: 30,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W}.'),
      };
      final r = buildManaBase(spellsMonoW, poolSoloBasicas, 'W', 24,
          archetypeName: 'midrange')!;
      expect(r.lands, {'Plains': 24});
    });

    test('color sin ninguna fuente posible => null (igual que hoy)', () {
      final spells = {'B Card': 20};
      final pool = <String, Card>{
        'B Card': const Card(
            name: 'B Card',
            qty: 20,
            manaCost: '{B}',
            cmc: 1,
            colors: 'B',
            types: ['Creature'],
            oracle: ''),
        'Plains': const Card(
            name: 'Plains',
            qty: 20,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: ['Land'],
            oracle: '{T}: Add {W}.'),
      };
      // sin Swamp en la colección: B se queda en 0 fuentes => null.
      final r =
          buildManaBase(spells, pool, 'WB', 24, archetypeName: 'midrange');
      expect(r, isNull);
    });
  });
}
