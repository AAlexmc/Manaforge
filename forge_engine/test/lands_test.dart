import 'package:test/test.dart';
import 'package:forge_engine/forge_engine.dart';

/// Tests espejo de `engine-reference/tests/test_lands.py`.
/// Fixtures reales (oracle copiado de la DB).
void main() {
  Card land(String name, String oracle, {List<String> sub = const []}) =>
      Card(
          name: name,
          qty: 4,
          manaCost: '',
          cmc: 0,
          colors: '',
          types: const ['Land'],
          subtypes: sub,
          oracle: oracle);

  test('básica', () {
    final p = LandProfile.fromCard(
        land('Plains', '({T}: Add {W}.)', sub: ['Plains']));
    expect(p.produces, {'W'});
    expect(p.tapped, TappedKind.never);
  });

  test('básica de cortesía (sin oracle ni subtipos) produce por nombre', () {
    // La app fabrica básicas "de cortesía" así (card_database.dart,
    // assumeBasics): sin oracle y sin subtipos. Si no producen color, la
    // manabase entera devuelve null en la app real.
    final cortes = Card(
        name: 'Swamp',
        qty: 25,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: const ['Basic', 'Land'],
        oracle: '');
    final p = LandProfile.fromCard(cortes);
    expect(p.isBasic, isTrue);
    expect(p.produces, {'B'});
    final nieve = Card(
        name: 'Snow-Covered Island',
        qty: 3,
        manaCost: '',
        cmc: 0,
        colors: '',
        types: const ['Basic', 'Land'],
        oracle: '');
    expect(LandProfile.fromCard(nieve).produces, {'U'});
  });

  test('dual tipada condicional (Fetching Garden)', () {
    final p = LandProfile.fromCard(land(
        'Fetching Garden',
        '({T}: Add {G} or {W}.)\nFetching Garden enters the battlefield '
            'tapped if it was played from your hand.',
        sub: ['Forest', 'Plains']));
    expect(p.produces, {'G', 'W'});
    expect(p.tapped, TappedKind.conditional);
  });

  test('tapland incondicional (Gate to Seatower)', () {
    final p = LandProfile.fromCard(land(
        'Gate to Seatower',
        '({T}: Add {U}.)\nGate to Seatower enters the battlefield tapped.\n'
            '{3}{U}, {T}: Seek a nonland card.',
        sub: ['Island', 'Gate']));
    expect(p.produces, {'U'});
    expect(p.tapped, TappedKind.always);
  });

  test('checkland: unless => conditional', () {
    final p = LandProfile.fromCard(land('Glacial Fortress',
        'Glacial Fortress enters the battlefield tapped unless you control '
            'a Plains or an Island.\n{T}: Add {W} or {U}.'));
    expect(p.produces, {'W', 'U'});
    expect(p.tapped, TappedKind.conditional);
  });

  test('fetch genérica (Evolving Wilds)', () {
    final p = LandProfile.fromCard(land('Evolving Wilds',
        '{T}, Sacrifice Evolving Wilds: Search your library for a basic '
            'land card, put it onto the battlefield tapped, then shuffle.'));
    expect(p.isFetch, isTrue);
    expect(p.fetches, isEmpty);
    expect(p.sourceOf('R', 'RG'), isTrue);
    expect(p.sourceOf('U', 'RG'), isFalse);
  });

  test('fetch tipada (Flooded Strand)', () {
    final p = LandProfile.fromCard(land('Flooded Strand',
        '{T}, Pay 1 life, Sacrifice Flooded Strand: Search your library for '
            'a Plains or Island card, put it onto the battlefield, then '
            'shuffle.'));
    expect(p.fetches, {'W', 'U'});
  });

  test('utility incolora (Field of Ruin-style) queda utility', () {
    final p = LandProfile.fromCard(land('Wastes2', '{T}: Add {C}.'));
    expect(p.isUtility, isTrue);
  });

  test('any color', () {
    final p = LandProfile.fromCard(
        land('Evolving City', '{T}: Add one mana of any color.'));
    expect(p.produces, {'W', 'U', 'B', 'R', 'G'});
  });
}
