/// Logros y niveles. Todo aquí es Dart puro y SIN estado: se le pasa una foto
/// de la colección ([AchievementSnapshot]) y devuelve qué está conseguido y
/// cuánto falta para lo demás. Así la pantalla no calcula nada y los logros se
/// pueden testear sin base de datos ni ficheros.
library;

import 'package:manaforge_app/l10n/app_localizations.dart';

/// Rareza del logro; de ella sale el XP que da.
enum AchievementTier {
  bronze(10),
  silver(25),
  gold(60),
  mythic(150);

  final int xp;
  const AchievementTier(this.xp);
}

/// Cómo se llama cada rareza en el idioma del usuario.
String tierLabel(AppLocalizations t, AchievementTier tier) => switch (tier) {
      AchievementTier.bronze => t.achTierBronze,
      AchievementTier.silver => t.achTierSilver,
      AchievementTier.gold => t.achTierGold,
      AchievementTier.mythic => t.achTierMythic,
    };

enum AchievementCategory {
  coleccion,
  rareza,
  color,
  expansiones,
  valor,
  foils,
  forge,
  escaner,
  dedicacion,
  carpetas,
  curiosidades,
}

/// Cómo se llama cada categoría en el idioma del usuario.
String categoryLabel(AppLocalizations t, AchievementCategory c) =>
    switch (c) {
      AchievementCategory.coleccion => t.achCatCollection,
      AchievementCategory.rareza => t.achCatRarity,
      AchievementCategory.color => t.achCatColor,
      AchievementCategory.expansiones => t.achCatSets,
      AchievementCategory.valor => t.achCatValue,
      AchievementCategory.foils => t.achCatFoils,
      AchievementCategory.forge => t.achCatForge,
      AchievementCategory.escaner => t.achCatScanner,
      AchievementCategory.dedicacion => t.achCatDedication,
      AchievementCategory.carpetas => t.achCatFolders,
      AchievementCategory.curiosidades => t.achCatCuriosities,
    };

/// Un logro: una meta numérica sobre la foto de la colección.
class Achievement {
  final String id;

  /// El nombre y la explicación salen de las traducciones: los logros se leen
  /// en el idioma que tenga puesto la app, y cambian con él.
  final String Function(AppLocalizations t) title;
  final String Function(AppLocalizations t) description;
  final AchievementCategory category;
  final AchievementTier tier;

  /// Cuánto hay que llegar para conseguirlo.
  final num goal;

  /// Cuánto llevas ahora mismo.
  final num Function(AchievementSnapshot) value;

  /// Secreto: no se enseña la descripción hasta que cae.
  final bool secret;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    required this.goal,
    required this.value,
    this.secret = false,
  });

  int get xp => tier.xp;
}

/// Foto de la colección en un momento dado. Todo con valor por defecto para
/// que los tests pidan solo lo que miran.
class AchievementSnapshot {
  final int totalCopies;
  final int distinctCards;

  /// 'W','U','B','R','G' y 'C' (incoloras) -> cartas distintas.
  final Map<String, int> byColor;

  /// 'common','uncommon','rare','mythic' -> cartas distintas.
  final Map<String, int> byRarity;

  /// 'Creature','Instant','Sorcery','Artifact','Enchantment','Land',
  /// 'Planeswalker' -> cartas distintas.
  final Map<String, int> byType;

  final int multicolorCards;
  final int fiveColorCards;
  final int playsets; // cartas con 4 copias o más
  final int maxPower;
  final int maxCmc;
  final int zeroCostCards;
  final int basicLandTypes; // 0..5
  final int distinctSets;
  final int setsCompleted;
  final int distinctYears;
  final int cardsFrom90s;
  final double totalValue;
  final double bestCardValue;
  final int foilCopies;
  final double bestFoilValue;

  /// Lo que valen TODAS tus foils juntas (no la mejor): es otra forma de
  /// coleccionar y merece su propia serie de logros.
  final double foilValue;
  final int decksSaved;
  final double bestDeckScore;
  final int maxDeckColors;
  final int monoColorDecks;
  final int commanderDecks;
  final int foldersCreated;
  final int biggestFolderCards;
  final double richestFolderValue;
  final int cardsScanned;
  final int bestPhotoCards;
  final int perfectScans;
  final int activeDays;
  final int longestStreak;
  final int weeksInARow;
  final int wishlistCards;
  final int foreignCards;

  const AchievementSnapshot({
    this.totalCopies = 0,
    this.distinctCards = 0,
    this.byColor = const {},
    this.byRarity = const {},
    this.byType = const {},
    this.multicolorCards = 0,
    this.fiveColorCards = 0,
    this.playsets = 0,
    this.maxPower = 0,
    this.maxCmc = 0,
    this.zeroCostCards = 0,
    this.basicLandTypes = 0,
    this.distinctSets = 0,
    this.setsCompleted = 0,
    this.distinctYears = 0,
    this.cardsFrom90s = 0,
    this.totalValue = 0,
    this.bestCardValue = 0,
    this.foilCopies = 0,
    this.bestFoilValue = 0,
    this.foilValue = 0,
    this.decksSaved = 0,
    this.bestDeckScore = 0,
    this.maxDeckColors = 0,
    this.monoColorDecks = 0,
    this.commanderDecks = 0,
    this.foldersCreated = 0,
    this.biggestFolderCards = 0,
    this.richestFolderValue = 0,
    this.cardsScanned = 0,
    this.bestPhotoCards = 0,
    this.perfectScans = 0,
    this.activeDays = 0,
    this.longestStreak = 0,
    this.weeksInARow = 0,
    this.wishlistCards = 0,
    this.foreignCards = 0,
  });

  int color(String c) => byColor[c] ?? 0;
  int rarity(String r) => byRarity[r] ?? 0;
  int type(String t) => byType[t] ?? 0;

  /// De cuántos colores tienes al menos una carta (0..5).
  int get colorsPresent =>
      const ['W', 'U', 'B', 'R', 'G'].where((c) => color(c) > 0).length;

  /// De cuántos tipos distintos tienes al menos una carta (0..7).
  int get typesCollected => const [
        'Creature',
        'Instant',
        'Sorcery',
        'Artifact',
        'Enchantment',
        'Land',
        'Planeswalker',
      ].where((t) => type(t) > 0).length;
}

/// Un logro con lo que llevas hecho.
class AchievementState {
  final Achievement achievement;

  /// 0..1
  final double progress;
  final bool unlocked;
  final DateTime? unlockedAt;
  final num current;

  const AchievementState({
    required this.achievement,
    required this.progress,
    required this.unlocked,
    required this.current,
    this.unlockedAt,
  });

  /// "34/50" para pintarlo debajo de la medalla. Los logros de dinero llevan
  /// decimales mientras son pequeños: "6,91/20 €" dice mucho más que "6/20".
  String get progressLabel {
    final goal = achievement.goal;
    final money = achievement.category == AchievementCategory.valor ||
        achievement.id.startsWith('foiljoya') ||
        achievement.id.startsWith('carpetavalor');
    if (money) {
      final shown = current < 100
          ? current.toStringAsFixed(2)
          : current.toStringAsFixed(0);
      return '$shown/${goal.toStringAsFixed(0)} €';
    }
    return '${current.toStringAsFixed(0)}/${goal.toStringAsFixed(0)}';
  }
}

/// Evalúa todo el catálogo. [unlockedAt] son los logros ya guardados
/// (id -> fecha ISO): una vez conseguido, un logro NO se pierde aunque
/// vendas las cartas.
List<AchievementState> evaluateAchievements(
  AchievementSnapshot snapshot, {
  Map<String, String> unlockedAt = const {},
}) {
  return [
    for (final a in kAchievements)
      () {
        final current = a.value(snapshot);
        final stored = unlockedAt[a.id];
        final unlocked = current >= a.goal || stored != null;
        final ratio = a.goal == 0 ? 1.0 : current / a.goal;
        return AchievementState(
          achievement: a,
          current: current,
          progress: unlocked ? 1.0 : ratio.clamp(0.0, 1.0).toDouble(),
          unlocked: unlocked,
          unlockedAt: stored == null ? null : DateTime.tryParse(stored),
        );
      }(),
  ];
}

/// XP conseguido (solo lo desbloqueado).
int totalXp(List<AchievementState> states) => states
    .where((s) => s.unlocked)
    .fold(0, (sum, s) => sum + s.achievement.xp);

/// Lo que se acaba de conseguir entre dos evaluaciones (para avisar UNA vez).
List<Achievement> newlyUnlocked({
  required List<AchievementState> before,
  required List<AchievementState> after,
}) {
  final had = {
    for (final s in before)
      if (s.unlocked) s.achievement.id
  };
  return [
    for (final s in after)
      if (s.unlocked && !had.contains(s.achievement.id)) s.achievement
  ];
}

/// XP acumulado necesario para LLEGAR al nivel [level] (nivel 1 = 0 XP).
/// Curva suave: nivel 2 a los 40, nivel 5 a los 400, nivel 10 a los 1.800.
int xpToReach(int level) => level <= 1 ? 0 : 20 * level * (level - 1);

/// Título del rango según el nivel. Los cortes están puestos para que el
/// último rango SEA alcanzable con el catálogo de hoy (3.395 XP = nivel 13):
/// si se añaden logros, se suben los cortes.
String levelTitle(AppLocalizations t, int level) {
  if (level >= 13) return t.achRankPlaneswalker;
  if (level >= 10) return t.achRankMaster;
  if (level >= 7) return t.achRankArchmage;
  if (level >= 5) return t.achRankMage;
  if (level >= 3) return t.achRankSummoner;
  return t.achRankApprentice;
}

/// Nivel actual, cuánto llevas dentro del nivel y cuánto vale el nivel. El
/// título del rango no va aquí: lo pone [levelTitle], que sabe el idioma.
({int level, int xpInLevel, int xpForNext}) levelFor(int xp) {
  var level = 1;
  while (xp >= xpToReach(level + 1)) {
    level++;
  }
  final floor = xpToReach(level);
  final ceil = xpToReach(level + 1);
  return (
    level: level,
    xpInLevel: xp - floor,
    xpForNext: ceil - floor,
  );
}

// ---------------------------------------------------------------------------
// Catálogo
// ---------------------------------------------------------------------------

/// Construye una serie de logros escalonados con el mismo criterio
/// ("10 cartas", "50 cartas", "100 cartas"…).
List<Achievement> _series({
  required String id,
  required AchievementCategory category,
  required String Function(AppLocalizations t, num goal) title,
  required String Function(AppLocalizations t, num goal) description,
  required List<(num, AchievementTier)> steps,
  required num Function(AchievementSnapshot) value,
  bool secret = false,
}) =>
    [
      for (final (goal, tier) in steps)
        Achievement(
          id: '$id-${goal.toStringAsFixed(0)}',
          title: (t) => title(t, goal),
          description: (t) => description(t, goal),
          category: category,
          tier: tier,
          goal: goal,
          value: value,
          secret: secret,
        ),
    ];

const _b = AchievementTier.bronze;
const _s = AchievementTier.silver;
const _g = AchievementTier.gold;
const _m = AchievementTier.mythic;

/// Todos los logros de ManaForge.
final List<Achievement> kAchievements = [
  // --- Colección -----------------------------------------------------------
  ..._series(
    id: 'copias',
    category: AchievementCategory.coleccion,
    steps: [
      (1, _b),
      (10, _b),
      (50, _b),
      (100, _s),
      (500, _s),
      (1000, _g),
      (5000, _g),
      (10000, _m),
    ],
    title: (t, g) => switch (g) {
      1 => t.achCopias1,
      10 => t.achCopias10,
      50 => t.achCopias50,
      100 => t.achCopias100,
      500 => t.achCopias500,
      1000 => t.achCopias1000,
      5000 => t.achCopias5000,
      _ => t.achCopias10000,
    },
    description: (t, g) => t.achCopiasDesc(g.toStringAsFixed(0)),
    value: (s) => s.totalCopies,
  ),
  ..._series(
    id: 'distintas',
    category: AchievementCategory.coleccion,
    steps: [
      (25, _b),
      (100, _b),
      (500, _s),
      (1000, _g),
      (2500, _m),
      (5000, _m),
    ],
    title: (t, g) => switch (g) {
      25 => t.achDistintas25,
      100 => t.achDistintas100,
      500 => t.achDistintas500,
      1000 => t.achDistintas1000,
      2500 => t.achDistintas2500,
      _ => t.achDistintas5000,
    },
    description: (t, g) => t.achDistintasDesc(g.toStringAsFixed(0)),
    value: (s) => s.distinctCards,
  ),
  ..._series(
    id: 'playsets',
    category: AchievementCategory.coleccion,
    steps: [(1, _b), (20, _g)],
    title: (t, g) => g == 1 ? t.achPlaysets1 : t.achPlaysets20,
    description: (t, g) => g == 1 ? t.achPlaysets1Desc : t.achPlaysets20Desc,
    value: (s) => s.playsets,
  ),

  // --- Rarezas -------------------------------------------------------------
  ..._series(
    id: 'comunes',
    category: AchievementCategory.rareza,
    steps: [(10, _b), (50, _b), (200, _s), (500, _g)],
    title: (t, g) => switch (g) {
      10 => t.achComunes10,
      50 => t.achComunes50,
      200 => t.achComunes200,
      _ => t.achComunes500,
    },
    description: (t, g) => t.achComunesDesc(g.toStringAsFixed(0)),
    value: (s) => s.rarity('common'),
  ),
  ..._series(
    id: 'infrecuentes',
    category: AchievementCategory.rareza,
    steps: [(10, _b), (50, _b), (200, _s), (500, _g)],
    title: (t, g) => switch (g) {
      10 => t.achInfrecuentes10,
      50 => t.achInfrecuentes50,
      200 => t.achInfrecuentes200,
      _ => t.achInfrecuentes500,
    },
    description: (t, g) => t.achInfrecuentesDesc(g.toStringAsFixed(0)),
    value: (s) => s.rarity('uncommon'),
  ),
  ..._series(
    id: 'raras',
    category: AchievementCategory.rareza,
    steps: [(5, _b), (25, _s), (100, _g), (300, _m)],
    title: (t, g) => switch (g) {
      5 => t.achRaras5,
      25 => t.achRaras25,
      100 => t.achRaras100,
      _ => t.achRaras300,
    },
    description: (t, g) => t.achRarasDesc(g.toStringAsFixed(0)),
    value: (s) => s.rarity('rare'),
  ),
  ..._series(
    id: 'miticas',
    category: AchievementCategory.rareza,
    steps: [(1, _b), (10, _s), (50, _g), (150, _m)],
    title: (t, g) => switch (g) {
      1 => t.achMiticas1,
      10 => t.achMiticas10,
      50 => t.achMiticas50,
      _ => t.achMiticas150,
    },
    description: (t, g) => t.achMiticasDesc(g.toStringAsFixed(0)),
    value: (s) => s.rarity('mythic'),
  ),

  // --- Colores -------------------------------------------------------------
  ..._series(
    id: 'blancas',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (t, g) => g == 25 ? t.achBlancas25 : t.achBlancas100,
    description: (t, g) => t.achBlancasDesc(g.toStringAsFixed(0)),
    value: (s) => s.color('W'),
  ),
  ..._series(
    id: 'azules',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (t, g) => g == 25 ? t.achAzules25 : t.achAzules100,
    description: (t, g) => t.achAzulesDesc(g.toStringAsFixed(0)),
    value: (s) => s.color('U'),
  ),
  ..._series(
    id: 'negras',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (t, g) => g == 25 ? t.achNegras25 : t.achNegras100,
    description: (t, g) => t.achNegrasDesc(g.toStringAsFixed(0)),
    value: (s) => s.color('B'),
  ),
  ..._series(
    id: 'rojas',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (t, g) => g == 25 ? t.achRojas25 : t.achRojas100,
    description: (t, g) => t.achRojasDesc(g.toStringAsFixed(0)),
    value: (s) => s.color('R'),
  ),
  ..._series(
    id: 'verdes',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (t, g) => g == 25 ? t.achVerdes25 : t.achVerdes100,
    description: (t, g) => t.achVerdesDesc(g.toStringAsFixed(0)),
    value: (s) => s.color('G'),
  ),
  ..._series(
    id: 'incoloras',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (t, g) => g == 25 ? t.achIncoloras25 : t.achIncoloras100,
    description: (t, g) => t.achIncolorasDesc(g.toStringAsFixed(0)),
    value: (s) => s.color('C'),
  ),
  ..._series(
    id: 'arcoiris',
    category: AchievementCategory.color,
    steps: [(5, _s)],
    title: (t, _) => t.achArcoiris,
    description: (t, _) => t.achArcoirisDesc,
    value: (s) => s.colorsPresent,
  ),
  ..._series(
    id: 'multicolor',
    category: AchievementCategory.color,
    steps: [(10, _b), (50, _s)],
    title: (t, g) => g == 10 ? t.achMulticolor10 : t.achMulticolor50,
    description: (t, g) => t.achMulticolorDesc(g.toStringAsFixed(0)),
    value: (s) => s.multicolorCards,
  ),
  ..._series(
    id: 'cincocolores',
    category: AchievementCategory.color,
    steps: [(1, _g)],
    title: (t, _) => t.achCincocolores,
    description: (t, _) => t.achCincocoloresDesc,
    value: (s) => s.fiveColorCards,
  ),

  // --- Expansiones ---------------------------------------------------------
  ..._series(
    id: 'sets',
    category: AchievementCategory.expansiones,
    steps: [(1, _b), (5, _b), (10, _s), (25, _s), (50, _g)],
    title: (t, g) => switch (g) {
      1 => t.achSets1,
      5 => t.achSets5,
      10 => t.achSets10,
      25 => t.achSets25,
      _ => t.achSets50,
    },
    description: (t, g) => t.achSetsDesc(g.toStringAsFixed(0)),
    value: (s) => s.distinctSets,
  ),
  ..._series(
    id: 'setscompletos',
    category: AchievementCategory.expansiones,
    steps: [(1, _g), (3, _g), (10, _m)],
    title: (t, g) => switch (g) {
      1 => t.achSetscompletos1,
      3 => t.achSetscompletos3,
      _ => t.achSetscompletos10,
    },
    description: (t, g) => g == 1
        ? t.achSetscompletos1Desc
        : t.achSetscompletos3Desc(g.toStringAsFixed(0)),
    value: (s) => s.setsCompleted,
  ),
  ..._series(
    id: 'anyos',
    category: AchievementCategory.expansiones,
    steps: [(5, _s), (15, _g)],
    title: (t, g) => g == 5 ? t.achAnyos5 : t.achAnyos15,
    description: (t, g) => t.achAnyosDesc(g.toStringAsFixed(0)),
    value: (s) => s.distinctYears,
  ),

  // --- Valor ---------------------------------------------------------------
  ..._series(
    id: 'valor',
    category: AchievementCategory.valor,
    steps: [
      (10, _b),
      (50, _b),
      (250, _s),
      (1000, _g),
      (5000, _m),
      (10000, _m),
      (25000, _m),
    ],
    title: (t, g) => switch (g) {
      10 => t.achValor10,
      50 => t.achValor50,
      250 => t.achValor250,
      1000 => t.achValor1000,
      5000 => t.achValor5000,
      10000 => t.achValor10000,
      _ => t.achValor25000,
    },
    description: (t, g) => t.achValorDesc(g.toStringAsFixed(0)),
    value: (s) => s.totalValue,
  ),
  ..._series(
    id: 'joya',
    category: AchievementCategory.valor,
    steps: [(20, _b), (100, _s), (500, _g), (1000, _m), (2500, _m)],
    title: (t, g) => switch (g) {
      20 => t.achJoya20,
      100 => t.achJoya100,
      500 => t.achJoya500,
      1000 => t.achJoya1000,
      _ => t.achJoya2500,
    },
    description: (t, g) => t.achJoyaDesc(g.toStringAsFixed(0)),
    value: (s) => s.bestCardValue,
  ),

  // --- Foils ---------------------------------------------------------------
  ..._series(
    id: 'foils',
    category: AchievementCategory.foils,
    steps: [(1, _b), (10, _b), (50, _s), (200, _g), (500, _m), (1000, _m)],
    title: (t, g) => switch (g) {
      1 => t.achFoils1,
      10 => t.achFoils10,
      50 => t.achFoils50,
      200 => t.achFoils200,
      500 => t.achFoils500,
      _ => t.achFoils1000,
    },
    description: (t, g) => t.achFoilsDesc(g.toStringAsFixed(0)),
    value: (s) => s.foilCopies,
  ),
  ..._series(
    id: 'foiljoya',
    category: AchievementCategory.foils,
    steps: [(10, _s), (50, _g), (200, _m)],
    title: (t, g) => switch (g) {
      10 => t.achFoiljoya10,
      50 => t.achFoiljoya50,
      _ => t.achFoiljoya200,
    },
    description: (t, g) => t.achFoiljoyaDesc(g.toStringAsFixed(0)),
    value: (s) => s.bestFoilValue,
  ),
  ..._series(
    id: 'foilvalor',
    category: AchievementCategory.foils,
    steps: [(50, _b), (250, _s), (1000, _g), (5000, _m)],
    title: (t, g) => switch (g) {
      50 => t.achFoilvalor50,
      250 => t.achFoilvalor250,
      1000 => t.achFoilvalor1000,
      _ => t.achFoilvalor5000,
    },
    description: (t, g) => t.achFoilvalorDesc(g.toStringAsFixed(0)),
    value: (s) => s.foilValue,
  ),

  // --- Forge ---------------------------------------------------------------
  ..._series(
    id: 'mazos',
    category: AchievementCategory.forge,
    steps: [(1, _b), (5, _b), (25, _s)],
    title: (t, g) => switch (g) {
      1 => t.achMazos1,
      5 => t.achMazos5,
      _ => t.achMazos25,
    },
    description: (t, g) => t.achMazosDesc(g.toStringAsFixed(0)),
    value: (s) => s.decksSaved,
  ),
  ..._series(
    id: 'mazoscore',
    category: AchievementCategory.forge,
    steps: [(90, _g)],
    title: (t, _) => t.achMazoscore,
    description: (t, _) => t.achMazoscoreDesc,
    value: (s) => s.bestDeckScore,
  ),
  ..._series(
    id: 'mazocolores',
    category: AchievementCategory.forge,
    steps: [(3, _s), (5, _g)],
    title: (t, g) => g == 3 ? t.achMazocolores3 : t.achMazocolores5,
    description: (t, g) => t.achMazocoloresDesc(g.toStringAsFixed(0)),
    value: (s) => s.maxDeckColors,
  ),
  ..._series(
    id: 'mazomono',
    category: AchievementCategory.forge,
    steps: [(1, _b)],
    title: (t, _) => t.achMazomono,
    description: (t, _) => t.achMazomonoDesc,
    value: (s) => s.monoColorDecks,
  ),
  ..._series(
    id: 'mazocommander',
    category: AchievementCategory.forge,
    steps: [(1, _s)],
    title: (t, _) => t.achMazocommander,
    description: (t, _) => t.achMazocommanderDesc,
    value: (s) => s.commanderDecks,
  ),

  // --- Escáner -------------------------------------------------------------
  ..._series(
    id: 'escaneadas',
    category: AchievementCategory.escaner,
    steps: [(1, _b), (50, _b), (500, _s), (2000, _g)],
    title: (t, g) => switch (g) {
      1 => t.achEscaneadas1,
      50 => t.achEscaneadas50,
      500 => t.achEscaneadas500,
      _ => t.achEscaneadas2000,
    },
    description: (t, g) => t.achEscaneadasDesc(g.toStringAsFixed(0)),
    value: (s) => s.cardsScanned,
  ),
  ..._series(
    id: 'foto',
    category: AchievementCategory.escaner,
    steps: [(9, _s), (20, _g)],
    title: (t, g) => g == 9 ? t.achFoto9 : t.achFoto20,
    description: (t, g) => t.achFotoDesc(g.toStringAsFixed(0)),
    value: (s) => s.bestPhotoCards,
  ),
  ..._series(
    id: 'escaneoperfecto',
    category: AchievementCategory.escaner,
    steps: [(1, _s)],
    title: (t, _) => t.achEscaneoperfecto,
    description: (t, _) => t.achEscaneoperfectoDesc,
    value: (s) => s.perfectScans,
  ),

  // --- Dedicación ----------------------------------------------------------
  ..._series(
    id: 'dias',
    category: AchievementCategory.dedicacion,
    steps: [(2, _b), (7, _b), (30, _s), (100, _g)],
    title: (t, g) => switch (g) {
      2 => t.achDias2,
      7 => t.achDias7,
      30 => t.achDias30,
      _ => t.achDias100,
    },
    description: (t, g) => t.achDiasDesc(g.toStringAsFixed(0)),
    value: (s) => s.activeDays,
  ),
  ..._series(
    id: 'racha',
    category: AchievementCategory.dedicacion,
    steps: [(3, _b), (7, _s), (30, _g)],
    title: (t, g) => switch (g) {
      3 => t.achRacha3,
      7 => t.achRacha7,
      _ => t.achRacha30,
    },
    description: (t, g) => t.achRachaDesc(g.toStringAsFixed(0)),
    value: (s) => s.longestStreak,
  ),
  ..._series(
    id: 'semanas',
    category: AchievementCategory.dedicacion,
    steps: [(4, _s)],
    // el nombre viejo ("Mes de compras") mentía: esto no mira lo que compras,
    // mira que vuelvas cuatro semanas seguidas
    title: (t, _) => t.achSemanas,
    description: (t, _) => t.achSemanasDesc,
    value: (s) => s.weeksInARow,
  ),

  // --- Carpetas ------------------------------------------------------------
  ..._series(
    id: 'carpetas',
    category: AchievementCategory.carpetas,
    steps: [(1, _b), (5, _s)],
    title: (t, g) => g == 1 ? t.achCarpetas1 : t.achCarpetas5,
    description: (t, g) => t.achCarpetasDesc(g.toStringAsFixed(0)),
    value: (s) => s.foldersCreated,
  ),
  ..._series(
    id: 'carpetagrande',
    category: AchievementCategory.carpetas,
    steps: [(100, _s)],
    title: (t, _) => t.achCarpetagrande,
    description: (t, _) => t.achCarpetagrandeDesc,
    value: (s) => s.biggestFolderCards,
  ),
  ..._series(
    id: 'carpetavalor',
    category: AchievementCategory.carpetas,
    steps: [(100, _g)],
    title: (t, _) => t.achCarpetavalor,
    description: (t, _) => t.achCarpetavalorDesc,
    value: (s) => s.richestFolderValue,
  ),

  // --- Curiosidades --------------------------------------------------------
  ..._series(
    id: 'tierrasbasicas',
    category: AchievementCategory.curiosidades,
    steps: [(5, _b)],
    title: (t, _) => t.achTierrasbasicas,
    description: (t, _) => t.achTierrasbasicasDesc,
    value: (s) => s.basicLandTypes,
  ),
  ..._series(
    id: 'fuerza',
    category: AchievementCategory.curiosidades,
    steps: [(10, _s)],
    title: (t, _) => t.achFuerza,
    description: (t, _) => t.achFuerzaDesc,
    value: (s) => s.maxPower,
  ),
  ..._series(
    id: 'coste',
    category: AchievementCategory.curiosidades,
    steps: [(10, _b)],
    title: (t, _) => t.achCoste,
    description: (t, _) => t.achCosteDesc,
    value: (s) => s.maxCmc,
  ),
  ..._series(
    id: 'costecero',
    category: AchievementCategory.curiosidades,
    steps: [(1, _b)],
    title: (t, _) => t.achCostecero,
    description: (t, _) => t.achCosteceroDesc,
    value: (s) => s.zeroCostCards,
  ),
  ..._series(
    id: 'tipos',
    category: AchievementCategory.curiosidades,
    steps: [(7, _s)],
    title: (t, _) => t.achTipos,
    description: (t, _) => t.achTiposDesc,
    value: (s) => s.typesCollected,
  ),
  ..._series(
    id: 'planeswalkers',
    category: AchievementCategory.curiosidades,
    steps: [(5, _s)],
    title: (t, _) => t.achPlaneswalkers,
    description: (t, _) => t.achPlaneswalkersDesc,
    value: (s) => s.type('Planeswalker'),
  ),
  ..._series(
    id: 'noventas',
    category: AchievementCategory.curiosidades,
    steps: [(1, _s)],
    title: (t, _) => t.achNoventas,
    description: (t, _) => t.achNoventasDesc,
    value: (s) => s.cardsFrom90s,
    secret: true,
  ),
  ..._series(
    id: 'idiomas',
    category: AchievementCategory.curiosidades,
    steps: [(1, _b), (25, _s)],
    title: (t, g) => g == 1 ? t.achIdiomas1 : t.achIdiomas25,
    description: (t, g) => g == 1 ? t.achIdiomas1Desc : t.achIdiomas25Desc,
    value: (s) => s.foreignCards,
    secret: true,
  ),
  ..._series(
    id: 'wishlist',
    category: AchievementCategory.curiosidades,
    steps: [(20, _b)],
    title: (t, _) => t.achWishlist,
    description: (t, _) => t.achWishlistDesc,
    value: (s) => s.wishlistCards,
  ),
];
