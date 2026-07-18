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
}
