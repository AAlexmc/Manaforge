/// La foto de la colección que comen los logros: se construye con datos ya
/// reunidos, así que se puede testear sin base de datos.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/achievement_snapshot.dart';
import 'package:manaforge_app/data/repositories/achievement_store.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';

OwnedCard _card(
  String name, {
  String colors = 'G',
  String type = 'Creature — Elf',
  int cmc = 1,
  int qty = 1,
  int? power,
  String? printedName,
}) =>
    OwnedCard(
      oracleId: 'o-$name',
      name: name,
      printedName: printedName,
      colors: colors,
      typeLine: type,
      cmc: cmc,
      power: power,
      qty: qty,
    );

void main() {
  final cards = [
    _card('Llanowar Elves', power: 1),
    _card('Counterspell', colors: 'U', type: 'Instant', cmc: 2),
    _card('Sol Ring', colors: '', type: 'Artifact', cmc: 1, qty: 4),
    _card('Plains', colors: '', type: 'Basic Land — Plains', cmc: 0),
    _card('Island', colors: '', type: 'Basic Land — Island', cmc: 0),
    _card('Niv-Mizzet Reborn',
        colors: 'WUBRG', type: 'Legendary Creature — Dragon Avatar',
        cmc: 6, power: 6),
    _card('Rayo', colors: 'R', type: 'Instant', cmc: 1,
        printedName: 'Rayo'),
  ];

  AchievementSnapshot snap({
    Map<String, CardFacts> facts = const {},
    Map<String, int> ownedBySet = const {},
    Map<String, int> setTotals = const {},
    double totalValue = 0,
    double bestCardValue = 0,
    int foilCopies = 0,
    List<CardFolder> folders = const [],
    Map<String, double> folderValues = const {},
    AchievementStore? progress,
  }) =>
      buildSnapshot(
        cards: cards,
        printingQty: const {'aer|1': 1, 'aer|2': 1, 'kld|3': 1},
        foilCopies: foilCopies,
        facts: facts,
        ownedBySet: ownedBySet,
        setTotals: setTotals,
        totalValue: totalValue,
        bestCardValue: bestCardValue,
        bestFoilValue: 0,
        foilValue: 0,
        decks: const [],
        folders: folders,
        folderValues: folderValues,
        progress: progress ?? AchievementStore(),
        wishlistCards: 0,
      );

  test('cuenta copias, distintas y playsets', () {
    final s = snap();
    expect(s.distinctCards, 7);
    expect(s.totalCopies, 10); // Sol Ring cuenta 4
    expect(s.playsets, 1);
  });

  test('reparte por color, y las incoloras van a C', () {
    final s = snap();
    expect(s.color('G'), 2); // Llanowar + Niv-Mizzet
    expect(s.color('U'), 2);
    expect(s.color('C'), 3); // Sol Ring y las dos tierras básicas
    expect(s.colorsPresent, 5);
    expect(s.multicolorCards, 1);
    expect(s.fiveColorCards, 1);
  });

  test('cuenta tipos y tierras básicas distintas', () {
    final s = snap();
    expect(s.type('Creature'), 2);
    expect(s.type('Instant'), 2);
    expect(s.type('Artifact'), 1);
    expect(s.type('Land'), 2);
    expect(s.basicLandTypes, 2); // llanura e isla
    expect(s.typesCollected, 4);
  });

  test('récords de la colección: fuerza, coste y coste 0', () {
    final s = snap();
    expect(s.maxPower, 6);
    expect(s.maxCmc, 6);
    expect(s.zeroCostCards, 0); // las tierras básicas no cuentan como coste 0
  });

  test('cartas en otro idioma', () {
    final s = snap();
    expect(s.foreignCards, 0); // "Rayo" con printedName igual al nombre no
  });

  test('rarezas y años salen de los datos de la base de cartas', () {
    final s = snap(facts: {
      'o-Llanowar Elves': const CardFacts(rarity: 'common', year: 1995),
      'o-Counterspell': const CardFacts(rarity: 'uncommon', year: 2000),
      'o-Sol Ring': const CardFacts(rarity: 'rare', year: 2020),
      'o-Niv-Mizzet Reborn': const CardFacts(rarity: 'mythic', year: 2019),
    });
    expect(s.rarity('common'), 1);
    expect(s.rarity('uncommon'), 1);
    expect(s.rarity('rare'), 1);
    expect(s.rarity('mythic'), 1);
    expect(s.distinctYears, 4);
    expect(s.cardsFrom90s, 1);
  });

  test('expansiones distintas salen de las ediciones que tienes', () {
    expect(snap().distinctSets, 2); // aer y kld
  });

  test('un set está completo cuando lo tienes entero', () {
    final s = snap(
      ownedBySet: const {'aer': 10, 'kld': 3},
      setTotals: const {'aer': 10, 'kld': 264},
    );
    expect(s.setsCompleted, 1);
  });

  test('carpetas: cuántas, la más grande y la más cara', () {
    final folders = [
      CardFolder(
          id: '1',
          name: 'A',
          colorValue: 1,
          icon: 'folder',
          cardIds: {'o-Llanowar Elves', 'o-Sol Ring'},
          createdAt: ''),
      CardFolder(
          id: '2',
          name: 'B',
          colorValue: 1,
          icon: 'folder',
          cardIds: {'o-Plains'},
          createdAt: ''),
    ];
    final s = snap(
        folders: folders, folderValues: const {'1': 12.0, '2': 130.0});
    expect(s.foldersCreated, 2);
    expect(s.biggestFolderCards, 2);
    expect(s.richestFolderValue, 130.0);
  });

  test('los contadores de escáner y los días vienen del almacén', () {
    final progress = AchievementStore()
      ..bump(AchievementCounters.cardsScanned, 12)
      ..raise(AchievementCounters.bestPhotoCards, 9)
      ..markDayActive(now: DateTime(2026, 7, 20, 12))
      ..markDayActive(now: DateTime(2026, 7, 21, 12));
    final s = snap(progress: progress);
    expect(s.cardsScanned, 12);
    expect(s.bestPhotoCards, 9);
    expect(s.activeDays, 2);
    expect(s.longestStreak, 2);
  });

  test('el valor llega ya calculado con la fórmula compartida', () {
    final s = snap(totalValue: 123.4, bestCardValue: 90);
    expect(s.totalValue, 123.4);
    expect(s.bestCardValue, 90);
  });
}
