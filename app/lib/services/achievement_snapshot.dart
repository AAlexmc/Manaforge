/// De la colección a la foto que comen los logros.
///
/// Está partido en dos: [buildSnapshot] es puro (datos dentro, foto fuera) y
/// se testea sin nada montado; [gatherSnapshot] es el que va a la base de
/// cartas a por lo que no está en la colección (rareza, año, precios).
library;

import 'achievement_store.dart';
import 'achievements.dart';
import 'card_database.dart';
import 'collection_sets.dart';
import 'collection_store.dart';
import 'collection_value.dart';
import 'deck_store.dart';
import 'folder_store.dart';
import 'folder_value.dart';

export 'achievements.dart' show AchievementSnapshot;

/// Lo que la base de cartas sabe de una carta y la colección no.
class CardFacts {
  final String rarity; // common · uncommon · rare · mythic
  final int year; // año de la impresión más antigua

  const CardFacts({required this.rarity, required this.year});
}

const _basicLands = ['Plains', 'Island', 'Swamp', 'Mountain', 'Forest'];
const _typeKeys = [
  'Creature',
  'Instant',
  'Sorcery',
  'Artifact',
  'Enchantment',
  'Land',
  'Planeswalker',
];

/// Cuenta todo lo que miran los logros. Función pura.
AchievementSnapshot buildSnapshot({
  required List<OwnedCard> cards,
  required Map<String, int> printingQty,
  required int foilCopies,
  required Map<String, CardFacts> facts,
  required Map<String, int> ownedBySet,
  required Map<String, int> setTotals,
  required double totalValue,
  required double bestCardValue,
  required double bestFoilValue,
  required List<SavedDeck> decks,
  required List<CardFolder> folders,
  required Map<String, double> folderValues,
  required AchievementStore progress,
  required int wishlistCards,
}) {
  final byColor = <String, int>{};
  final byType = <String, int>{};
  final byRarity = <String, int>{};
  final years = <int>{};
  var totalCopies = 0;
  var playsets = 0;
  var multicolor = 0;
  var fiveColor = 0;
  var maxPower = 0;
  var maxCmc = 0;
  var zeroCost = 0;
  var foreign = 0;
  var from90s = 0;
  final basics = <String>{};

  for (final c in cards) {
    totalCopies += c.qty;
    if (c.qty >= 4) playsets++;
    if (c.colors.isEmpty) {
      byColor['C'] = (byColor['C'] ?? 0) + 1;
    } else {
      for (final letter in c.colors.split('')) {
        byColor[letter] = (byColor[letter] ?? 0) + 1;
      }
      if (c.colors.length > 1) multicolor++;
      if (c.colors.length >= 5) fiveColor++;
    }
    for (final t in _typeKeys) {
      if (c.typeLine.contains(t)) byType[t] = (byType[t] ?? 0) + 1;
    }
    final isLand = c.typeLine.contains('Land');
    if (c.typeLine.startsWith('Basic')) {
      for (final land in _basicLands) {
        if (c.typeLine.contains(land)) basics.add(land);
      }
    }
    if ((c.power ?? 0) > maxPower) maxPower = c.power!;
    if (c.cmc > maxCmc) maxCmc = c.cmc;
    // una tierra no "cuesta 0": no se lanza
    if (c.cmc == 0 && !isLand) zeroCost++;
    final printed = c.printedName;
    if (printed != null && printed.isNotEmpty && printed != c.name) foreign++;

    final fact = facts[c.oracleId];
    if (fact != null) {
      byRarity[fact.rarity] = (byRarity[fact.rarity] ?? 0) + 1;
      if (fact.year > 0) {
        years.add(fact.year);
        if (fact.year < 2000) from90s++;
      }
    }
  }

  final sets = <String>{
    for (final key in printingQty.keys)
      if (key.contains('|')) key.split('|').first
  };
  var setsCompleted = 0;
  setTotals.forEach((code, total) {
    if (total > 0 && (ownedBySet[code] ?? 0) >= total) setsCompleted++;
  });

  var biggestFolder = 0;
  var richestFolder = 0.0;
  for (final f in folders) {
    if (f.count > biggestFolder) biggestFolder = f.count;
    final value = folderValues[f.id] ?? 0;
    if (value > richestFolder) richestFolder = value;
  }

  var bestScore = 0.0;
  var maxDeckColors = 0;
  var monoDecks = 0;
  var commanderDecks = 0;
  for (final d in decks) {
    if (d.score > bestScore) bestScore = d.score;
    final colors = d.colors.replaceAll(RegExp(r'[^WUBRG]'), '').length;
    if (colors > maxDeckColors) maxDeckColors = colors;
    if (colors == 1) monoDecks++;
    // el motor construye Commander a 100 cartas
    if (d.totalSpells + d.totalLands >= 100) commanderDecks++;
  }

  return AchievementSnapshot(
    totalCopies: totalCopies,
    distinctCards: cards.length,
    byColor: byColor,
    byRarity: byRarity,
    byType: byType,
    multicolorCards: multicolor,
    fiveColorCards: fiveColor,
    playsets: playsets,
    maxPower: maxPower,
    maxCmc: maxCmc,
    zeroCostCards: zeroCost,
    basicLandTypes: basics.length,
    distinctSets: sets.length,
    setsCompleted: setsCompleted,
    distinctYears: years.length,
    cardsFrom90s: from90s,
    totalValue: totalValue,
    bestCardValue: bestCardValue,
    foilCopies: foilCopies,
    bestFoilValue: bestFoilValue,
    decksSaved: decks.length,
    bestDeckScore: bestScore,
    maxDeckColors: maxDeckColors,
    monoColorDecks: monoDecks,
    commanderDecks: commanderDecks,
    foldersCreated: folders.length,
    biggestFolderCards: biggestFolder,
    richestFolderValue: richestFolder,
    cardsScanned: progress.counter(AchievementCounters.cardsScanned),
    bestPhotoCards: progress.counter(AchievementCounters.bestPhotoCards),
    perfectScans: progress.counter(AchievementCounters.perfectScans),
    activeDays: progress.activeDays,
    longestStreak: progress.longestStreak,
    weeksInARow: progress.weeksInARow,
    wishlistCards: wishlistCards,
    foreignCards: foreign,
  );
}

/// Reúne lo que hace falta (incluidas las consultas a la base de cartas) y
/// devuelve la foto. Si la base no está lista, devuelve la foto con lo que se
/// pueda: los logros que dependen de precios o rarezas se quedan a 0 hasta
/// que la haya.
Future<AchievementSnapshot> gatherSnapshot({
  required CardDatabase db,
  required CollectionStore collection,
  required DeckStore decks,
  required FolderStore folders,
  required AchievementStore progress,
  int wishlistCards = 0,
}) async {
  final cards = collection.cards;
  var facts = <String, CardFacts>{};
  var ownedBySet = <String, int>{};
  var setTotals = <String, int>{};
  var totalValue = 0.0;
  var bestCard = 0.0;
  var bestFoil = 0.0;
  final folderValues = <String, double>{};

  try {
    final raw = await db.factsForOracles(cards.map((c) => c.oracleId));
    facts = {
      for (final e in raw.entries)
        e.key: CardFacts(rarity: e.value.rarity, year: e.value.year)
    };
    ownedBySet = await ownedCardsBySet(db, collection);
    setTotals = {for (final s in await db.sets()) s.code: s.total};

    final valuation = await computeCollectionValue(
      cards: cards,
      byPrinting: collection.hasPrintingData,
      printingQty: collection.printingQty,
      oraclePrices: db.pricesForOracles,
      printingPrices: db.pricesForPrintings,
    );
    totalValue = valuation.total;
    for (final v in valuation.valued) {
      if (v.unitPrice > bestCard) bestCard = v.unitPrice;
    }

    if (collection.foilPrintings.isNotEmpty) {
      final foilPrices =
          await db.foilPricesForPrintings(collection.foilPrintings.keys);
      for (final p in foilPrices.values) {
        if (p > bestFoil) bestFoil = p;
      }
    }

    final owners = collection.hasPrintingData
        ? await db.oracleByPrintings(collection.printingQty.keys)
        : const <String, String>{};
    for (final f in folders.folders) {
      final v = await computeFolderValue(
        folderCardIds: f.cardIds,
        cards: cards,
        byPrinting: collection.hasPrintingData,
        printingQty: collection.printingQty,
        oracleByPrintings: (_) async => owners,
        oraclePrices: db.pricesForOracles,
        printingPrices: db.pricesForPrintings,
      );
      folderValues[f.id] = v.total;
    }
  } catch (_) {
    // sin base de cartas: la foto sale igual con lo que hay en local
  }

  return buildSnapshot(
    cards: cards,
    printingQty: collection.printingQty,
    foilCopies: collection.foilCopies,
    facts: facts,
    ownedBySet: ownedBySet,
    setTotals: setTotals,
    totalValue: totalValue,
    bestCardValue: bestCard,
    bestFoilValue: bestFoil,
    decks: decks.decks,
    folders: folders.folders,
    folderValues: folderValues,
    progress: progress,
    wishlistCards: wishlistCards,
  );
}
