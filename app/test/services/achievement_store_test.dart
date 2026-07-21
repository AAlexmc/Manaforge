/// Lo que hay que guardar de los logros: qué está desbloqueado, contadores
/// que no se pueden deducir de la colección (escaneos) y los días de uso.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/achievement_store.dart';

DateTime _d(int y, int m, int d) => DateTime(y, m, d, 12);

void main() {
  test('desbloquear guarda la fecha y no la pisa al repetir', () {
    final store = AchievementStore();
    store.unlockAll(['copias-1'], at: _d(2026, 7, 1));
    store.unlockAll(['copias-1'], at: _d(2026, 8, 1));
    expect(store.unlockedAt['copias-1']!.startsWith('2026-07-01'), isTrue);
    expect(store.unlockedCount, 1);
  });

  test('contadores: sumar y quedarse con el récord', () {
    final store = AchievementStore();
    store.bump(AchievementCounters.cardsScanned, 3);
    store.bump(AchievementCounters.cardsScanned);
    expect(store.counter(AchievementCounters.cardsScanned), 4);

    store.raise(AchievementCounters.bestPhotoCards, 9);
    store.raise(AchievementCounters.bestPhotoCards, 4); // peor: no baja
    expect(store.counter(AchievementCounters.bestPhotoCards), 9);
  });

  test('días de uso: el mismo día dos veces cuenta una', () {
    final store = AchievementStore();
    store.markDayActive(now: _d(2026, 7, 20));
    store.markDayActive(now: _d(2026, 7, 20));
    expect(store.activeDays, 1);
    expect(store.longestStreak, 1);
  });

  test('racha: días seguidos cuentan, un hueco la rompe', () {
    final store = AchievementStore();
    for (final d in [18, 19, 20]) {
      store.markDayActive(now: _d(2026, 7, d));
    }
    store.markDayActive(now: _d(2026, 7, 25)); // hueco
    store.markDayActive(now: _d(2026, 7, 26));
    expect(store.activeDays, 5);
    expect(store.longestStreak, 3);
    expect(store.currentStreak(now: _d(2026, 7, 26)), 2);
    expect(store.currentStreak(now: _d(2026, 8, 30)), 0); // racha vieja
  });

  test('la racha cruza el cambio de mes y de año', () {
    final store = AchievementStore();
    store.markDayActive(now: _d(2025, 12, 31));
    store.markDayActive(now: _d(2026, 1, 1));
    expect(store.longestStreak, 2);
  });

  test('semanas seguidas con actividad', () {
    final store = AchievementStore();
    store.markDayActive(now: _d(2026, 7, 6)); // lunes
    store.markDayActive(now: _d(2026, 7, 15));
    store.markDayActive(now: _d(2026, 7, 21));
    expect(store.weeksInARow, 3);
  });

  test('ida y vuelta a JSON', () {
    final store = AchievementStore();
    store.unlockAll(['copias-1'], at: _d(2026, 7, 1));
    store.bump(AchievementCounters.cardsScanned, 7);
    store.markDayActive(now: _d(2026, 7, 20));
    store.rememberLevel(4);

    final back = AchievementStore()..restore(store.toJson());
    expect(back.unlockedAt.keys, ['copias-1']);
    expect(back.counter(AchievementCounters.cardsScanned), 7);
    expect(back.activeDays, 1);
    expect(back.lastSeenLevel, 4);
  });

  test('un JSON roto no revienta: se queda vacío', () {
    final store = AchievementStore()
      ..restore({'unlocked': 'esto no es un mapa', 'days': 42});
    expect(store.unlockedAt, isEmpty);
    expect(store.activeDays, 0);
  });
}
