/// Tests del historial de precio por carta: qué se apunta, qué se ignora y
/// cómo se recortan los rangos de la gráfica.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/price_history.dart';

void main() {
  group('filterRange', () {
    final points = [
      const PricePoint('2026-06-01', 1.0),
      const PricePoint('2026-07-01', 2.0),
      const PricePoint('2026-07-18', 3.0),
      const PricePoint('2026-07-21', 4.0),
    ];
    final now = DateTime(2026, 7, 21);

    test('null = todo el historial', () {
      expect(filterRange(points, null, now: now), hasLength(4));
    });

    test('semana deja solo los últimos 7 días', () {
      final week = filterRange(points, 7, now: now);
      expect([for (final p in week) p.date],
          ['2026-07-18', '2026-07-21']);
    });

    test('mes deja los últimos 30 días', () {
      final month = filterRange(points, 30, now: now);
      expect(month, hasLength(3)); // fuera el de junio
      expect(month.first.date, '2026-07-01');
    });

    test('un rango sin puntos devuelve lista vacía, no revienta', () {
      expect(filterRange(const [], 7, now: now), isEmpty);
    });
  });

  group('PriceHistoryStore (sin plugin de rutas: solo memoria)', () {
    test('apunta el precio de hoy y lo devuelve por carta', () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 1.5, 'sol': 40.0});
      expect(await store.forCard('bolt'), hasLength(1));
      expect((await store.forCard('bolt')).single.value, 1.5);
      expect((await store.forCard('sol')).single.value, 40.0);
    });

    test('precio 0 o negativo no es un punto ("sin precio" ≠ vale 0)',
        () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 0, 'shock': -1, 'sol': 2.0});
      expect(await store.forCard('bolt'), isEmpty);
      expect(await store.forCard('shock'), isEmpty);
      expect(await store.forCard('sol'), hasLength(1));
    });

    test('dos apuntes el mismo día → un solo punto, el último precio',
        () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 1.0});
      await store.recordAll({'bolt': 1.8});
      final history = await store.forCard('bolt');
      expect(history, hasLength(1));
      expect(history.single.value, 1.8);
    });

    test('forCards solo devuelve las que tienen historial', () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 1.0});
      final map = await store.forCards(['bolt', 'desconocida']);
      expect(map.keys, ['bolt']);
    });

    test('carta sin apuntes devuelve historial vacío', () async {
      final store = PriceHistoryStore();
      expect(await store.forCard('nunca-vista'), isEmpty);
    });
  });
}
