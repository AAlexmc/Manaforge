/// Tests del orden de la colección: lo recién escaneado va primero, y el
/// resto de criterios siguen disponibles.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
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

final _t = AppLocalizationsEs();

/// El getter `cardsByRecent` no existe en producción (se borró por muerto):
/// aquí replicamos su semántica con lo que sí usa la app de verdad.
/// `.reversed` a propósito: `store.cards` ya sale ordenado por nombre y, con
/// input alfabético, el test del desempate por nombre pasaría aunque el
/// desempate de [compareByRecent] desapareciera (verde por construcción).
List<OwnedCard> _byRecent(CollectionStore store) =>
    store.cards.reversed.toList()..sort(compareByRecent);

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
      expect([for (final c in sortCollection(cards, CollectionSort.alpha)) c.name],
          ['Alfa', 'Beta', 'Gamma']);
      expect([for (final c in sortCollection(cards, CollectionSort.cmc)) c.name],
          ['Gamma', 'Beta', 'Alfa']);
      expect([for (final c in sortCollection(cards, CollectionSort.qty)) c.name],
          ['Alfa', 'Gamma', 'Beta']);
    });

    test('no modifica la lista que le pasan', () {
      final original = [_card('Beta'), _card('Alfa')];
      sortCollection(original, CollectionSort.alpha);
      expect(original.first.name, 'Beta');
    });

    test('lista vacía: no revienta', () {
      expect(sortCollection(const [], CollectionSort.recent), isEmpty);
    });
  });

  group('addedLabel', () {
    final hoy = DateTime(2026, 7, 21, 15);

    test('hoy, ayer y esta semana se dicen en cristiano', () {
      expect(addedLabel(_t, _ms(2026, 7, 21), now: hoy), 'hoy');
      expect(addedLabel(_t, _ms(2026, 7, 20), now: hoy), 'ayer');
      expect(addedLabel(_t, _ms(2026, 7, 18), now: hoy), 'hace 3 días');
    });

    test('más de una semana: la fecha', () {
      expect(addedLabel(_t, _ms(2026, 6, 3), now: hoy), '03/06/2026');
    });

    test('sin fecha lo dice, no inventa una', () {
      expect(addedLabel(_t, null, now: hoy), 'sin fecha');
    });

    test('la frontera de la semana: 6 días en cristiano, 7 ya con fecha',
        () {
      expect(addedLabel(_t, _ms(2026, 7, 15), now: hoy), 'hace 6 días');
      expect(addedLabel(_t, _ms(2026, 7, 14), now: hoy), '14/07/2026');
    });

    test('el cambio de hora no adelanta un día', () {
      // el 29-mar de 2026 el día dura 23 h en Madrid: contando en hora
      // local, "ayer" salía como "hoy"
      expect(addedLabel(_t, _ms(2026, 3, 29), now: DateTime(2026, 3, 30, 12)),
          'ayer');
      expect(addedLabel(_t, _ms(2026, 10, 25), now: DateTime(2026, 10, 26, 12)),
          'ayer');
    });

    test('una fecha futura (reloj torcido) dice "hoy", no días negativos',
        () {
      expect(addedLabel(_t, _ms(2027, 1, 1), now: hoy), 'hoy');
    });
  });

  group('CollectionStore', () {
    test('añadir sella la fecha y la deja arriba en cardsByRecent', () {
      final store = CollectionStore();
      store.add(_card('Primera'), at: DateTime(2026, 7, 1));
      store.add(_card('Segunda'), at: DateTime(2026, 7, 20));
      expect([for (final c in _byRecent(store)) c.name],
          ['Segunda', 'Primera']);
    });

    test('añadir OTRA copia de una carta vieja la sube arriba', () {
      final store = CollectionStore();
      store.add(_card('Vieja'), at: DateTime(2026, 1, 1));
      store.add(_card('Reciente'), at: DateTime(2026, 7, 1));
      store.add(_card('Vieja'), at: DateTime(2026, 7, 21));
      expect(_byRecent(store).first.name, 'Vieja');
      expect(_byRecent(store).first.qty, 2);
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
      expect(_byRecent(store).first.name, 'Reciente');
    });

    test('añadir una carta no toca la fecha de las demás', () {
      final store = CollectionStore();
      store.add(_card('Primera'), at: DateTime(2026, 7, 1));
      final antes = _byRecent(store).first.addedAt;
      store.add(_card('Segunda'), at: DateTime(2026, 7, 20));
      final primera =
          _byRecent(store).firstWhere((c) => c.name == 'Primera');
      expect(primera.addedAt, antes);
    });

    test('REIMPORTAR el CSV no re-sella lo que ya tenías: lo escaneado '
        'sigue arriba', () {
      final store = CollectionStore();
      store.add(_card('Antigua'), at: DateTime(2026, 1, 1));
      store.add(_card('Escaneada hoy'), at: DateTime(2026, 7, 21));
      // el importador vuelve a meter la antigua (bump: false)
      store.add(_card('Antigua'),
          at: DateTime(2026, 7, 21, 23), bump: false);
      expect(_byRecent(store).first.name, 'Escaneada hoy');
      expect(_byRecent(store).last.qty, 2, reason: 'sí suma la copia');
    });

    test('un lote con el mismo sello sale por nombre, no en orden inverso',
        () {
      final store = CollectionStore();
      final at = DateTime(2026, 7, 21);
      for (final name in ['Zorro', 'Alce', 'Mula']) {
        store.add(_card(name), at: at);
      }
      expect([for (final c in _byRecent(store)) c.name],
          ['Alce', 'Mula', 'Zorro']);
    });

    test('round-trip JSON completo: no se pierde ningún campo', () {
      final json = {
        'oracleId': 'o1',
        'name': 'Bolt',
        'printedName': 'Rayo',
        // URLs de Scryfall de verdad: las de otro host se descartan al leer
        // (una copia restaurada no puede hacerte pedir imágenes de un tercero)
        'imageSmall': 'https://cards.scryfall.io/small/front/a/b/x.jpg',
        'imageNormal': 'https://cards.scryfall.io/normal/front/a/b/x.jpg',
        'colors': 'R',
        'typeLine': 'Instant',
        'cmc': 1,
        'power': null,
        'toughness': null,
        'qty': 3,
        'addedAt': _ms(2026, 7, 21),
      };
      expect(OwnedCard.fromJson(json).toJson(), json);
    });

    test('una carta sin fecha vuelve a guardarse SIN la clave', () {
      final json = OwnedCard.fromJson({
        'oracleId': 'o1',
        'name': 'Bolt',
        'colors': 'R',
        'qty': 1,
      }).toJson();
      expect(json.containsKey('addedAt'), isFalse);
    });

    test('un addedAt corrupto se ignora en vez de reventar al pintarlo', () {
      // fichero editado a mano / escrito por otra versión
      for (final raw in [9000000000000000, -9000000000000000, 'ayer', true]) {
        final card = OwnedCard.fromJson({
          'oracleId': 'o1',
          'name': 'Bolt',
          'colors': 'R',
          'qty': 1,
          'addedAt': raw,
        });
        expect(card.addedAt, isNull, reason: 'con $raw');
        expect(() => addedLabel(_t, card.addedAt), returnsNormally);
      }
    });

    test('un addedAt en coma flotante (JSON de otra herramienta) se lee '
        'como entero', () {
      final card = OwnedCard.fromJson({
        'oracleId': 'o1',
        'name': 'Bolt',
        'colors': 'R',
        'qty': 1,
        'addedAt': 1753056000000.0,
      });
      expect(card.addedAt, 1753056000000);
    });
  });
}
