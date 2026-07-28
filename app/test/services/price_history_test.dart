/// Tests del historial de precio por carta: qué se apunta, qué se ignora,
/// cómo se recortan los rangos y —lo que de verdad duele si falla— que el
/// camino de DISCO no pierda ni corrompa apuntes (Scryfall solo publica el
/// precio de hoy: un apunte perdido no se recupera).
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/price_history.dart';
import 'package:path/path.dart' as p;

void main() {
  group('filterRange', () {
    final points = [
      const PricePoint('2026-06-01', 1.0),
      const PricePoint('2026-07-01', 2.0),
      const PricePoint('2026-07-15', 3.0),
      const PricePoint('2026-07-21', 4.0),
    ];
    final now = DateTime(2026, 7, 21);

    test('null = todo el historial', () {
      expect(filterRange(points, null, now: now), hasLength(4));
    });

    test('semana = hoy y los 6 días anteriores', () {
      final week = filterRange(points, 7, now: now);
      expect([for (final pt in week) pt.date], ['2026-07-15', '2026-07-21']);
    });

    test('mes deja los últimos 30 días', () {
      final month = filterRange(points, 30, now: now);
      expect(month, hasLength(3)); // fuera el de junio
      expect(month.first.date, '2026-07-01');
    });

    test('el corte va por día, no por hora (una tarde no recorta menos '
        'que una mañana)', () {
      final manana = filterRange(points, 7, now: DateTime(2026, 7, 21, 8));
      final noche = filterRange(points, 7, now: DateTime(2026, 7, 21, 23));
      expect([for (final pt in manana) pt.date],
          [for (final pt in noche) pt.date]);
    });

    test('un rango sin puntos devuelve lista vacía, no revienta', () {
      expect(filterRange(const [], 7, now: now), isEmpty);
    });
  });

  group('PriceHistoryStore sin disco (sin plugin de rutas)', () {
    test('apunta el precio de hoy y lo devuelve por carta', () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 1.5, 'sol': 40.0});
      expect((await store.forCard('bolt')).single.value, 1.5);
      expect((await store.forCard('sol')).single.value, 40.0);
    });

    test('precio 0, negativo o no finito no es un punto', () async {
      final store = PriceHistoryStore();
      await store.recordAll(
          {'bolt': 0, 'shock': -1, 'nan': double.nan, 'sol': 2.0});
      expect(await store.forCard('bolt'), isEmpty);
      expect(await store.forCard('shock'), isEmpty);
      expect(await store.forCard('nan'), isEmpty);
      expect(await store.forCard('sol'), hasLength(1));
    });

    test('dos apuntes el mismo día → un punto, el último precio', () async {
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
      expect((await store.forCards(['bolt', 'desconocida'])).keys, ['bolt']);
    });

    test('la lista devuelta no se puede mutar por fuera', () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 1.0});
      final history = await store.forCard('bolt');
      expect(() => history.add(const PricePoint('2020-01-01', 9)),
          throwsUnsupportedError);
    });

    test('carta sin apuntes devuelve historial vacío', () async {
      expect(await PriceHistoryStore().forCard('nunca-vista'), isEmpty);
    });
  });

  group('fusión con el histórico descargado (Cardmarket vía MTGJSON)', () {
    test('la base rellena los días que el local no tiene', () async {
      final store = PriceHistoryStore()
        ..baseSeriesProvider = (ids, market) async => {
              'bolt': const [
                PricePoint('2026-07-01', 1.0),
                PricePoint('2026-07-02', 1.1),
              ]
            };
      await store.recordAll({'bolt': 2.0}); // hoy, en local
      final history = await store.forCard('bolt');
      expect(history.length, 3);
      expect(history.first.date, '2026-07-01');
      expect(history.last.value, 2.0); // el apunte local es el más nuevo
    });

    test('para un mismo día manda el apunte LOCAL (es lo que vio la app)',
        () async {
      final store = PriceHistoryStore();
      await store.recordAll({'bolt': 9.0});
      final today = (await store.forCard('bolt')).single.date;
      store.baseSeriesProvider =
          (ids, market) async => {'bolt': [PricePoint(today, 1.0)]};
      final history = await store.forCard('bolt');
      expect(history.single.value, 9.0);
    });

    test('carta sin apuntes locales sale con la serie de la base', () async {
      final store = PriceHistoryStore()
        ..baseSeriesProvider = (ids, market) async => {
              'sol': const [
                PricePoint('2026-06-01', 5.0),
                PricePoint('2026-06-02', 6.0),
              ]
            };
      expect(await store.forCard('sol'), hasLength(2));
      expect((await store.forCards(['sol']))['sol'], hasLength(2));
    });

    test('si la base falla, el historial local sigue saliendo', () async {
      final store = PriceHistoryStore()
        ..baseSeriesProvider = (ids, market) async => throw Exception('sin base');
      await store.recordAll({'bolt': 3.0});
      expect(await store.forCard('bolt'), hasLength(1));
    });

    test('el resultado fusionado va ordenado por fecha', () async {
      final store = PriceHistoryStore()
        ..baseSeriesProvider = (ids, market) async => {
              'bolt': const [
                PricePoint('2026-05-02', 2.0),
                PricePoint('2026-05-01', 1.0), // base desordenada
              ]
            };
      await store.recordAll({'bolt': 4.0});
      final dates = [for (final pt in await store.forCard('bolt')) pt.date];
      final sorted = [...dates]..sort();
      expect(dates, sorted);
    });
  });

  group('PriceHistoryStore con disco', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('mf_price'));
    tearDown(() => dir.deleteSync(recursive: true));

    File log() => File(p.join(dir.path, 'price_history.jsonl'));

    test('guarda en disco y otra instancia lo lee', () async {
      await PriceHistoryStore(directory: dir)
          .recordAll({'bolt': 1.5, 'sol': 40.0});
      expect(log().existsSync(), isTrue);

      final otra = PriceHistoryStore(directory: dir);
      expect((await otra.forCard('bolt')).single.value, 1.5);
      expect((await otra.forCard('sol')).single.value, 40.0);
    });

    test('apuntes concurrentes: NO se pierde ninguno (ni en memoria ni en '
        'disco)', () async {
      final store = PriceHistoryStore(directory: dir);
      // sin await entre ellas: es justo lo que hace el Mercado al abrirse
      // (wishlist + colección) y lo que perdía la foto diaria
      await Future.wait([
        store.recordAll({'coleccion': 3.0}),
        store.recordAll({'wishlist': 5.0}),
        store.recordOne('ficha', 7.0),
      ]);
      for (final id in ['coleccion', 'wishlist', 'ficha']) {
        expect(await store.forCard(id), hasLength(1), reason: id);
      }
      final recargado = PriceHistoryStore(directory: dir);
      for (final id in ['coleccion', 'wishlist', 'ficha']) {
        expect(await recargado.forCard(id), hasLength(1), reason: '$id disco');
      }
    });

    test('una línea rota solo se pierde a sí misma: el resto sobrevive',
        () async {
      await PriceHistoryStore(directory: dir)
          .recordAll({'bolt': 1.0, 'sol': 2.0});
      log().writeAsStringSync('{"o":"roto","d":"2026-0\n',
          mode: FileMode.append);

      final store = PriceHistoryStore(directory: dir);
      expect((await store.forCard('bolt')).single.value, 1.0);
      expect((await store.forCard('sol')).single.value, 2.0);
      expect(await store.forCard('roto'), isEmpty);
    });

    test('apuntar sobre un log existente lo AÑADE, no lo reescribe',
        () async {
      final store = PriceHistoryStore(directory: dir);
      await store.recordAll({'bolt': 1.0});
      final antes = log().readAsStringSync();
      await store.recordAll({'sol': 2.0});
      final despues = log().readAsStringSync();
      expect(despues.startsWith(antes), isTrue);
      expect(despues.length, greaterThan(antes.length));
    });

    test('migra el JSON monolítico de la primera versión y lo aparta',
        () async {
      File(p.join(dir.path, 'price_history.json')).writeAsStringSync(
          jsonEncode({
        'bolt': [
          {'d': '2026-07-20', 'v': 1.0},
          {'d': '2026-07-21', 'v': 1.4},
        ]
      }));
      final store = PriceHistoryStore(directory: dir);
      final history = await store.forCard('bolt');
      expect(history, hasLength(2));
      expect(history.last.value, 1.4);
      expect(log().existsSync(), isTrue);
      expect(File(p.join(dir.path, 'price_history.json')).existsSync(),
          isFalse);
      expect(File(p.join(dir.path, 'price_history.json.migrado')).existsSync(),
          isTrue);
    });

    test('historial ordenado por fecha aunque el log llegue desordenado',
        () async {
      log().writeAsStringSync([
        jsonEncode({'o': 'bolt', 'd': '2026-07-21', 'v': 3.0}),
        jsonEncode({'o': 'bolt', 'd': '2026-07-19', 'v': 1.0}),
        jsonEncode({'o': 'bolt', 'd': '2026-07-20', 'v': 2.0}),
      ].join('\n'));
      final history = await PriceHistoryStore(directory: dir).forCard('bolt');
      expect([for (final pt in history) pt.date],
          ['2026-07-19', '2026-07-20', '2026-07-21']);
    });

    test('el último apunte del día gana al releer del log', () async {
      log().writeAsStringSync([
        jsonEncode({'o': 'bolt', 'd': '2026-07-21', 'v': 1.0}),
        jsonEncode({'o': 'bolt', 'd': '2026-07-21', 'v': 9.0}),
      ].join('\n'));
      final history = await PriceHistoryStore(directory: dir).forCard('bolt');
      expect(history.single.value, 9.0);
    });
  });
}
