/// Lo que le falta a un mazo.
///
/// La misma cuenta la enseñan dos pantallas (la tarjeta de Forge y el detalle
/// del mazo): si cada una la hiciera por su cuenta, un mazo podría decir "te
/// faltan 7" y en la pantalla siguiente "las tienes todas".
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/domain/deck_shortfall.dart';

fe.Deck _deck({Map<String, int>? cards, Map<String, int>? lands}) => fe.Deck(
      name: 'Prueba',
      colors: 'R',
      archetype: fe.Archetype.aggro,
      cards: cards ?? const {},
      lands: lands ?? const {},
    );

void main() {
  test('sin copias tuyas, falta el mazo entero', () {
    final falta = missingCards(
        _deck(cards: {'Shock': 4}, lands: {'Mountain': 20}), const {});

    expect(falta, {'Shock': 4, 'Mountain': 20});
    expect(missingCopies(_deck(cards: {'Shock': 4}), const {}), 4);
  });

  test('solo falta la diferencia, no la carta entera', () {
    final falta = missingCards(_deck(cards: {'Shock': 4}), {'Shock': 3});

    expect(falta, {'Shock': 1});
  });

  test('tener de más no resta a lo que falta de otras', () {
    final falta = missingCards(
        _deck(cards: {'Shock': 2, 'Counterspell': 4}),
        {'Shock': 9, 'Counterspell': 1});

    expect(falta, {'Counterspell': 3});
    expect(falta.containsKey('Shock'), isFalse);
  });

  test('las tierras cuentan igual que los hechizos', () {
    final falta = missingCards(
        _deck(cards: {'Shock': 1}, lands: {'Mountain': 20}),
        {'Shock': 1, 'Mountain': 8});

    expect(falta, {'Mountain': 12});
  });

  test('el coste suma precio × copias que faltan', () {
    final falta = {'Shock': 2, 'Ragavan': 1};

    expect(missingCost(falta, {'Shock': 0.25, 'Ragavan': 40.0}), 40.5);
  });

  test('una carta sin precio conocido suma 0, no se inventa', () {
    expect(missingCost({'Rara': 3}, const {}), 0);
  });
}
