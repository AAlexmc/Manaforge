/// Catálogo de logros: progreso, desbloqueo, XP y curva de niveles.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/achievements.dart';

AchievementSnapshot _snap({
  int totalCopies = 0,
  int distinctCards = 0,
  Map<String, int> byColor = const {},
  Map<String, int> byRarity = const {},
  Map<String, int> byType = const {},
  int playsets = 0,
  int maxPower = 0,
  int maxCmc = 0,
  double totalValue = 0,
  double bestCardValue = 0,
  int foilCopies = 0,
  int decksSaved = 0,
  int foldersCreated = 0,
  int cardsScanned = 0,
  int activeDays = 0,
  int longestStreak = 0,
  int setsCompleted = 0,
  int distinctSets = 0,
}) =>
    AchievementSnapshot(
      totalCopies: totalCopies,
      distinctCards: distinctCards,
      byColor: byColor,
      byRarity: byRarity,
      byType: byType,
      playsets: playsets,
      maxPower: maxPower,
      maxCmc: maxCmc,
      totalValue: totalValue,
      bestCardValue: bestCardValue,
      foilCopies: foilCopies,
      decksSaved: decksSaved,
      foldersCreated: foldersCreated,
      cardsScanned: cardsScanned,
      activeDays: activeDays,
      longestStreak: longestStreak,
      setsCompleted: setsCompleted,
      distinctSets: distinctSets,
    );

void main() {
  test('el catálogo es grande, con ids únicos y metas alcanzables', () {
    expect(kAchievements.length, greaterThanOrEqualTo(70));
    final ids = kAchievements.map((a) => a.id).toSet();
    expect(ids.length, kAchievements.length, reason: 'hay ids repetidos');
    for (final a in kAchievements) {
      expect(a.goal, greaterThan(0), reason: '${a.id} tiene meta 0');
      expect(a.title, isNotEmpty);
      expect(a.description, isNotEmpty);
    }
  });

  test('todas las categorías tienen logros', () {
    for (final c in AchievementCategory.values) {
      expect(kAchievements.where((a) => a.category == c), isNotEmpty,
          reason: 'la categoría ${c.name} está vacía');
    }
  });

  test('colección vacía: nada desbloqueado y todo a 0', () {
    final states = evaluateAchievements(_snap());
    expect(states.where((s) => s.unlocked), isEmpty);
    expect(states.every((s) => s.progress == 0), isTrue);
    expect(totalXp(states), 0);
  });

  test('la primera carta desbloquea el logro de la primera carta', () {
    final states = evaluateAchievements(_snap(totalCopies: 1, distinctCards: 1));
    final first = states.firstWhere((s) => s.achievement.id == 'copias-1');
    expect(first.unlocked, isTrue);
    expect(first.progress, 1);
  });

  test('el progreso es parcial hasta llegar justo a la meta', () {
    final a = evaluateAchievements(_snap(totalCopies: 25))
        .firstWhere((s) => s.achievement.id == 'copias-50');
    expect(a.progress, closeTo(0.5, 0.001));
    expect(a.unlocked, isFalse);
    final b = evaluateAchievements(_snap(totalCopies: 50))
        .firstWhere((s) => s.achievement.id == 'copias-50');
    expect(b.unlocked, isTrue);
    expect(b.progress, 1);
  });

  test('el XP suma solo lo desbloqueado, según la rareza del logro', () {
    final states = evaluateAchievements(_snap(totalCopies: 1, distinctCards: 1));
    final unlocked = states.where((s) => s.unlocked).toList();
    expect(totalXp(states),
        unlocked.fold<int>(0, (sum, s) => sum + s.achievement.xp));
    expect(AchievementTier.bronze.xp, lessThan(AchievementTier.mythic.xp));
  });

  test('la fecha de desbloqueo llega desde el almacén', () {
    final states = evaluateAchievements(
      _snap(totalCopies: 1),
      unlockedAt: {'copias-1': '2026-07-21T10:00:00.000'},
    );
    final s = states.firstWhere((s) => s.achievement.id == 'copias-1');
    expect(s.unlockedAt?.year, 2026);
  });

  test('curva de niveles: sube y siempre dice cuánto falta', () {
    expect(levelFor(0).level, 1);
    expect(levelFor(0).xpInLevel, 0);
    expect(levelFor(39).level, 1);
    expect(levelFor(40).level, 2);
    var last = 0;
    for (var xp = 0; xp < 20000; xp += 37) {
      final l = levelFor(xp);
      expect(l.level, greaterThanOrEqualTo(last));
      expect(l.xpForNext, greaterThan(0));
      expect(l.xpInLevel, lessThan(l.xpForNext));
      expect(l.title, isNotEmpty);
      last = l.level;
    }
  });

  test('con TODO desbloqueado el nivel queda en un rango razonable', () {
    final everything = kAchievements.fold<int>(0, (sum, a) => sum + a.xp);
    final level = levelFor(everything).level;
    expect(level, inInclusiveRange(12, 25),
        reason: 'XP total $everything da nivel $level: recalibrar la curva');
  });

  test('logros secretos no cuentan distinto para el XP', () {
    final secret = kAchievements.where((a) => a.secret);
    expect(secret, isNotEmpty);
    expect(secret.every((a) => a.xp > 0), isTrue);
  });

  test('cada escalón de una serie pide más que el anterior', () {
    final series = <String, List<Achievement>>{};
    for (final a in kAchievements) {
      final base = a.id.replaceAll(RegExp(r'-\d+$'), '');
      if (base != a.id) (series[base] ??= []).add(a);
    }
    for (final entry in series.entries) {
      final goals = entry.value.map((a) => a.goal).toList()..sort();
      expect(goals.toSet().length, goals.length,
          reason: 'la serie ${entry.key} repite meta');
    }
  });

  test('newlyUnlocked encuentra lo que se acaba de conseguir', () {
    final before = evaluateAchievements(_snap());
    final after = evaluateAchievements(_snap(totalCopies: 10));
    final fresh = newlyUnlocked(before: before, after: after);
    expect(fresh.map((a) => a.id), contains('copias-10'));
    expect(newlyUnlocked(before: after, after: after), isEmpty);
  });
}
