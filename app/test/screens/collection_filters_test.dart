/// Los filtros de la colección viven aparte para que los usen igual la lista
/// completa y el selector de cartas de una carpeta.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/collection_filters.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';

OwnedCard _card(
  String name, {
  String colors = 'G',
  int cmc = 1,
  String type = 'Creature — Elf',
  int? power,
  int? toughness,
}) =>
    OwnedCard(
      oracleId: 'o-$name',
      name: name,
      colors: colors,
      typeLine: type,
      cmc: cmc,
      power: power,
      toughness: toughness,
      qty: 1,
    );

void main() {
  final cards = [
    _card('Llanowar Elves', colors: 'G', cmc: 1, power: 1, toughness: 1),
    _card('Counterspell',
        colors: 'U', cmc: 2, type: 'Instant', power: null, toughness: null),
    _card('Colossus', colors: '', cmc: 8, type: 'Artifact Creature',
        power: 10, toughness: 10),
    _card('Plains', colors: '', cmc: 0, type: 'Basic Land — Plains'),
  ];

  test('sin filtros no se toca la lista', () {
    const f = CollectionFilters();
    expect(f.any, isFalse);
    expect(f.apply(cards).length, cards.length);
  });

  test('filtro por color, con incoloras como "C"', () {
    expect(const CollectionFilters(colors: {'G'}).apply(cards).map((c) => c.name),
        ['Llanowar Elves']);
    expect(const CollectionFilters(colors: {'C'}).apply(cards).length, 2);
    expect(const CollectionFilters(colors: {'G', 'U'}).apply(cards).length, 2);
  });

  test('filtro por coste: exacto y 6+', () {
    expect(const CollectionFilters(cmc: 2).apply(cards).map((c) => c.name),
        ['Counterspell']);
    expect(const CollectionFilters(cmc: 6).apply(cards).map((c) => c.name),
        ['Colossus']);
  });

  test('filtro por tipo mira la línea de tipo entera', () {
    expect(const CollectionFilters(type: 'Creature').apply(cards).length, 2);
    expect(const CollectionFilters(type: 'Land').apply(cards).map((c) => c.name),
        ['Plains']);
  });

  test('ataque y defensa mínimos dejan fuera lo que no tiene', () {
    expect(
        const CollectionFilters(minPower: 5).apply(cards).map((c) => c.name),
        ['Colossus']);
    expect(const CollectionFilters(minToughness: 1).apply(cards).length, 2);
  });

  test('cleared quita todos los filtros', () {
    const f = CollectionFilters(colors: {'G'}, cmc: 3, type: 'Creature');
    expect(f.cleared().any, isFalse);
  });

  test('copyWith puede vaciar un filtro concreto', () {
    const f = CollectionFilters(cmc: 3, type: 'Creature');
    expect(f.copyWith(cmc: null, clearCmc: true).cmc, isNull);
    expect(f.copyWith(cmc: null, clearCmc: true).type, 'Creature');
  });

  test('el orden sigue funcionando igual desde su nueva casa', () {
    final byName = sortCollection(cards, CollectionSort.alpha);
    expect(byName.first.name, 'Colossus');
    final byCmc = sortCollection(cards, CollectionSort.cmc);
    expect(byCmc.first.name, 'Plains');
  });
}
