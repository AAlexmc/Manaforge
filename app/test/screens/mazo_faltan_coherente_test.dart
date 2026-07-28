/// El mismo mazo tiene que decir lo mismo se abra por donde se abra.
///
/// Un mazo guardado se abre desde Inicio y desde Mazos. Las dos pantallas
/// rellenan el pool con las cartas que ya NO tienes (para poder pintarlas),
/// así que si el detalle mira el pool en vez de tus copias reales, Inicio
/// decía "las tienes todas" y Mazos "te faltan N" del mismo mazo.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/domain/deck_shortfall.dart';

fe.Card _carta(String nombre, int qty) => fe.Card(
      name: nombre,
      qty: qty,
      manaCost: '{R}',
      cmc: 1,
      colors: 'R',
      types: const ['Instant'],
      oracle: '',
    );

void main() {
  test('el pool relleno miente; las copias reales no', () {
    final deck = fe.Deck(
      name: 'Mazo vendido',
      colors: 'R',
      archetype: fe.Archetype.aggro,
      cards: const {'Shock': 4, 'Ragavan': 2},
      lands: const {},
    );
    // así queda el pool en Inicio y en Mazos: tus cartas + las del mazo que
    // ya no tienes, metidas con la cantidad que el mazo pide
    final poolRelleno = {
      'Shock': _carta('Shock', 4),
      'Ragavan': _carta('Ragavan', 2), // vendida: entra "de relleno"
    };
    final propias = {'Shock': 4}; // Ragavan ya no está

    final porElPool = missingCopies(
        deck, {for (final e in poolRelleno.entries) e.key: e.value.qty});
    final porLasTuyas = missingCopies(deck, propias);

    expect(porElPool, 0); // lo que decía Inicio
    expect(porLasTuyas, 2); // la verdad, que es lo que dice Mazos
  });
}
