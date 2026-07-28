/// De la colección a la foto que comen los logros.
///
/// Está partido en dos: [buildSnapshot] es puro (datos dentro, foto fuera) y
/// se testea sin nada montado; [gatherSnapshot] es el que va a la base de
/// cartas a por lo que no está en la colección (rareza, año, precios).
library;

import 'package:manaforge_app/data/repositories/achievement_store.dart';
import 'package:manaforge_app/services/achievements.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_sets.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/services/collection_value.dart';
import 'package:manaforge_app/data/repositories/deck_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/services/folder_value.dart';

export 'package:manaforge_app/services/achievements.dart' show AchievementSnapshot;

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
  required double foilValue,
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
    foilValue: foilValue,
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
  var foilTotal = 0.0;
  final folderValues = <String, double>{};

  try {
    facts = collection.hasPrintingData
        // lo honesto: la rareza y el año de las ediciones que TIENES. Mirando
        // todas las impresiones de la carta, un común reimpreso alguna vez
        // como mítico te contaba como mítico (y un Counterspell moderno como
        // carta de los 90)
        ? await _factsFromOwnedPrintings(db, collection)
        : await _factsFromAllPrintings(db, cards);
    ownedBySet = await ownedCardsBySet(db, collection);
    // "expansión completa" solo se puede afirmar sabiendo las ediciones
    // exactas: en el modo aproximado, `ownedCardsBySet` no cuenta básicas y
    // los totales de `sets()` sí, así que nunca cuadrarían
    setTotals = collection.hasPrintingData
        ? {for (final s in await db.sets()) s.code: s.total}
        : const <String, int>{};

    // mismo atajo que Inicio/Mercado/Colección (con su backfill de
    // printingOwner incluido): sin la cuenta foil, la vitrina (a precio
    // foil) podía superar al total (que iba a precio normal)
    final valuation = await collectionValue(db: db, collection: collection);
    totalValue = valuation.total;
    if (collection.hasPrintingData) {
      // "tu carta más cara" = la EDICIÓN más cara que tienes, con el mismo
      // criterio que el total. A nivel carta se usaba el precio de su
      // impresión más barata, que no es la que tienes en la mano.
      final prices =
          await db.pricesForPrintings(collection.printingQty.keys);
      prices.forEach((key, price) {
        if ((collection.printingQty[key] ?? 0) > 0 && price > bestCard) {
          bestCard = price;
        }
      });
    } else {
      for (final v in valuation.valued) {
        if (v.unitPrice > bestCard) bestCard = v.unitPrice;
      }
    }

    if (collection.foilPrintings.isNotEmpty) {
      final foilPrices =
          await db.foilPricesForPrintings(collection.foilPrintings.keys);
      foilPrices.forEach((printing, price) {
        if (price > bestFoil) bestFoil = price;
        // el valor de la vitrina foil entera: precio por las copias que hay
        // de ESA impresión foil, no una por carta
        foilTotal += price * (collection.foilPrintings[printing] ?? 0);
      });
    }

    // collectionValue (arriba) ya consultó y backfilleó los dueños que
    // faltaban: las carpetas reusan lo aprendido, sin repetir la consulta
    final owners = collection.hasPrintingData
        ? collection.printingOwner
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
        foilQty: collection.foilPrintings,
        foilPrices: db.foilPricesForPrintings,
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
    foilValue: foilTotal,
    decks: decks.decks,
    folders: folders.folders,
    folderValues: folderValues,
    progress: progress,
    wishlistCards: wishlistCards,
  );
}

const _rarityOrder = {'common': 0, 'uncommon': 1, 'rare': 2, 'mythic': 3};

/// Rareza/año de las ediciones exactas que tiene el usuario. Si tiene la
/// misma carta en dos ediciones, manda la rareza más alta DE LAS SUYAS y el
/// año de la más antigua DE LAS SUYAS.
Future<Map<String, CardFacts>> _factsFromOwnedPrintings(
    CardDatabase db, CollectionStore collection) async {
  final owned = await db.factsForPrintings(collection.printingQty.keys);
  final out = <String, CardFacts>{};
  owned.forEach((key, fact) {
    if ((collection.printingQty[key] ?? 0) <= 0) return;
    final old = out[fact.oracleId];
    if (old == null) {
      out[fact.oracleId] = CardFacts(rarity: fact.rarity, year: fact.year);
      return;
    }
    final rarity =
        (_rarityOrder[fact.rarity] ?? -1) > (_rarityOrder[old.rarity] ?? -1)
            ? fact.rarity
            : old.rarity;
    final year = old.year == 0
        ? fact.year
        : (fact.year > 0 && fact.year < old.year ? fact.year : old.year);
    out[fact.oracleId] = CardFacts(rarity: rarity, year: year);
  });
  return out;
}

/// Sin datos de edición (colecciones viejas): lo mejor que se puede hacer es
/// mirar todas las impresiones de la carta.
Future<Map<String, CardFacts>> _factsFromAllPrintings(
    CardDatabase db, List<OwnedCard> cards) async {
  final raw = await db.factsForOracles(cards.map((c) => c.oracleId));
  return {
    for (final e in raw.entries)
      e.key: CardFacts(rarity: e.value.rarity, year: e.value.year)
  };
}
