/// Tests del orden de la colección: lo recién escaneado va primero, y el
/// resto de criterios siguen disponibles.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/coleccion_screen.dart';
import 'package:manaforge_app/services/collection_store.dart';

OwnedCard _card(String name,
        {int? addedAt, int qty = 1, int cmc = 1, String colors = 'G'}) =>
    OwnedCard(
      oracleId: 'o-$name',
      name: name,
      colors: colors,
      cmc: cmc,
      qty: qty,
      addedAt: addedAt,
    );

int _ms(int year, int month, int day) =>
    DateTime(year, month, day).millisecondsSinceEpoch;

void main() {
  group('sortCollection', () {
    test('recientes: la última añadida sale la primera', () {
      final list = sortCollection([
        _card('Vieja', addedAt: _ms(2026, 1, 1)),
        _card('Nueva', addedAt: _ms(2026, 7, 21)),
        _card('Media', addedAt: _ms(2026, 5, 5)),
      ], CollectionSort.recent);
      expect([for (final c in list) c.name], ['Nueva', 'Media', 'Vieja']);
    });

    test('las de colecciones antiguas (sin fecha) van al final, por nombre',
        () {
      final list = sortCollection([
        _card('Zorro'),
        _card('Escaneada', addedAt: _ms(2026, 7, 21)),
        _card('Alce'),
      ], CollectionSort.recent);
      expect([for (final c in list) c.name], ['Escaneada', 'Alce', 'Zorro']);
    });

    test('dos añadidas a la vez (un lote) se ordenan por nombre', () {
      final t = _ms(2026, 7, 21);
      final list = sortCollection([
        _card('Beta', addedAt: t),
        _card('Alfa', addedAt: t),
      ], CollectionSort.recent);
      expect([for (final c in list) c.name], ['Alfa', 'Beta']);
    });

    test('nombre, coste y cantidad siguen funcionando', () {
      final cards = [
        _card('Beta', cmc: 3, qty: 1),
        _card('Alfa', cmc: 5, qty: 4),
        _card('Gamma', cmc: 1, qty: 2),
      ];
      expect([for (final c in sortCollection(cards, CollectionSort.name)) c.name],
          ['Alfa', 'Beta', 'Gamma']);
      expect([for (final c in sortCollection(cards, CollectionSort.cmc)) c.name],
          ['Gamma', 'Beta', 'Alfa']);
      expect([for (final c in sortCollection(cards, CollectionSort.qty)) c.name],
          ['Alfa', 'Gamma', 'Beta']);
    });

    test('no modifica la lista que le pasan', () {
      final original = [_card('Beta'), _card('Alfa')];
      sortCollection(original, CollectionSort.name);
      expect(original.first.name, 'Beta');
    });

    test('lista vacía: no revienta', () {
      expect(sortCollection(const [], CollectionSort.recent), isEmpty);
    });
  });

  group('addedLabel', () {
    final hoy = DateTime(2026, 7, 21, 15);

    test('hoy, ayer y esta semana se dicen en cristiano', () {
      expect(addedLabel(_ms(2026, 7, 21), now: hoy), 'hoy');
      expect(addedLabel(_ms(2026, 7, 20), now: hoy), 'ayer');
      expect(addedLabel(_ms(2026, 7, 18), now: hoy), 'hace 3 días');
    });

    test('más de una semana: la fecha', () {
      expect(addedLabel(_ms(2026, 6, 3), now: hoy), '03/06/2026');
    });

    test('sin fecha lo dice, no inventa una', () {
      expect(addedLabel(null, now: hoy), 'sin fecha');
    });
  });

  group('CollectionStore', () {
    test('añadir sella la fecha y la deja arriba en cardsByRecent', () {
      final store = CollectionStore();
      store.add(_card('Primera'), at: DateTime(2026, 7, 1));
      store.add(_card('Segunda'), at: DateTime(2026, 7, 20));
      expect([for (final c in store.cardsByRecent) c.name],
          ['Segunda', 'Primera']);
    });

    test('añadir OTRA copia de una carta vieja la sube arriba', () {
      final store = CollectionStore();
      store.add(_card('Vieja'), at: DateTime(2026, 1, 1));
      store.add(_card('Reciente'), at: DateTime(2026, 7, 1));
      store.add(_card('Vieja'), at: DateTime(2026, 7, 21));
      expect(store.cardsByRecent.first.name, 'Vieja');
      expect(store.cardsByRecent.first.qty, 2);
    });

    test('la fecha sobrevive al guardar y releer', () {
      final card = _card('Bolt', addedAt: _ms(2026, 7, 21));
      final vuelta = OwnedCard.fromJson(card.toJson());
      expect(vuelta.addedAt, card.addedAt);
    });

    test('una carta guardada por la versión anterior (sin fecha) se lee '
        'igual', () {
      final json = {
        'oracleId': 'o1',
        'name': 'Bolt',
        'colors': 'R',
        'qty': 2,
      };
      final card = OwnedCard.fromJson(json);
      expect(card.addedAt, isNull);
      expect(card.qty, 2);
    });

    test('cambiar la cantidad a mano NO la mueve de sitio', () {
      final store = CollectionStore();
      store.add(_card('Vieja'), at: DateTime(2026, 1, 1));
      store.add(_card('Reciente'), at: DateTime(2026, 7, 1));
      store.setQty('o-Vieja', 5);
      expect(store.cardsByRecent.first.name, 'Reciente');
    });
  });
}
