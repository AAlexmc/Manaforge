/// Logros y niveles. Todo aquí es Dart puro y SIN estado: se le pasa una foto
/// de la colección ([AchievementSnapshot]) y devuelve qué está conseguido y
/// cuánto falta para lo demás. Así la pantalla no calcula nada y los logros se
/// pueden testear sin base de datos ni ficheros.
library;

/// Rareza del logro; de ella sale el XP que da.
enum AchievementTier {
  bronze('Bronce', 10),
  silver('Plata', 25),
  gold('Oro', 60),
  mythic('Mítico', 150);

  final String label;
  final int xp;
  const AchievementTier(this.label, this.xp);
}

enum AchievementCategory {
  coleccion('Colección'),
  rareza('Rarezas'),
  color('Colores'),
  expansiones('Expansiones'),
  valor('Valor'),
  foils('Foils'),
  forge('Forge'),
  escaner('Escáner'),
  dedicacion('Dedicación'),
  carpetas('Carpetas'),
  curiosidades('Curiosidades');

  final String label;
  const AchievementCategory(this.label);
}

/// Un logro: una meta numérica sobre la foto de la colección.
class Achievement {
  final String id;
  final String title;
  final String description;
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
String levelTitle(int level) {
  if (level >= 13) return 'Planeswalker';
  if (level >= 10) return 'Maestro';
  if (level >= 7) return 'Archimago';
  if (level >= 5) return 'Mago';
  if (level >= 3) return 'Invocador';
  return 'Aprendiz';
}

/// Nivel actual, cuánto llevas dentro del nivel y cuánto vale el nivel.
({int level, String title, int xpInLevel, int xpForNext}) levelFor(int xp) {
  var level = 1;
  while (xp >= xpToReach(level + 1)) {
    level++;
  }
  final floor = xpToReach(level);
  final ceil = xpToReach(level + 1);
  return (
    level: level,
    title: levelTitle(level),
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
  required String Function(num goal) title,
  required String Function(num goal) description,
  required List<(num, AchievementTier)> steps,
  required num Function(AchievementSnapshot) value,
  bool secret = false,
}) =>
    [
      for (final (goal, tier) in steps)
        Achievement(
          id: '$id-${goal.toStringAsFixed(0)}',
          title: title(goal),
          description: description(goal),
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
    title: (g) => switch (g) {
      1 => 'La primera',
      10 => 'Un puñado',
      50 => 'Media caja',
      100 => 'Cien cartas',
      500 => 'Caja llena',
      1000 => 'Mil cartas',
      5000 => 'Almacén',
      _ => 'Diez mil',
    },
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas en tu colección.',
    value: (s) => s.totalCopies,
  ),
  ..._series(
    id: 'distintas',
    category: AchievementCategory.coleccion,
    steps: [(25, _b), (100, _b), (500, _s), (1000, _g), (2500, _m)],
    title: (g) => switch (g) {
      25 => 'Variedad',
      100 => 'Cien caras',
      500 => 'Biblioteca',
      1000 => 'Enciclopedia',
      _ => 'Catálogo vivo',
    },
    description: (g) =>
        'Ten ${g.toStringAsFixed(0)} cartas DISTINTAS (sin contar repetidas).',
    value: (s) => s.distinctCards,
  ),
  ..._series(
    id: 'playsets',
    category: AchievementCategory.coleccion,
    steps: [(1, _b), (20, _g)],
    title: (g) => g == 1 ? 'Playset' : 'Constructor',
    description: (g) => g == 1
        ? 'Ten 4 copias de una misma carta.'
        : 'Ten 20 playsets distintos (4 copias de cada uno).',
    value: (s) => s.playsets,
  ),

  // --- Rarezas -------------------------------------------------------------
  ..._series(
    id: 'comunes',
    category: AchievementCategory.rareza,
    steps: [(10, _b), (50, _b), (200, _s)],
    title: (g) => switch (g) {
      10 => 'Pan de cada día',
      50 => 'El montón',
      _ => 'Rey de las comunes',
    },
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas comunes distintas.',
    value: (s) => s.rarity('common'),
  ),
  ..._series(
    id: 'infrecuentes',
    category: AchievementCategory.rareza,
    steps: [(10, _b), (50, _b), (200, _s)],
    title: (g) => switch (g) {
      10 => 'Algo mejor',
      50 => 'Plata fina',
      _ => 'Cazador de uncommons',
    },
    description: (g) =>
        'Ten ${g.toStringAsFixed(0)} cartas infrecuentes distintas.',
    value: (s) => s.rarity('uncommon'),
  ),
  ..._series(
    id: 'raras',
    category: AchievementCategory.rareza,
    steps: [(5, _b), (25, _s), (100, _g)],
    title: (g) => switch (g) {
      5 => 'Brilla el símbolo',
      25 => 'Cofre de raras',
      _ => 'Cien raras',
    },
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas raras distintas.',
    value: (s) => s.rarity('rare'),
  ),
  ..._series(
    id: 'miticas',
    category: AchievementCategory.rareza,
    steps: [(1, _b), (10, _s), (50, _g)],
    title: (g) => switch (g) {
      1 => 'Primera mítica',
      10 => 'Decena mítica',
      _ => 'Coleccionista mítico',
    },
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas míticas distintas.',
    value: (s) => s.rarity('mythic'),
  ),

  // --- Colores -------------------------------------------------------------
  ..._series(
    id: 'blancas',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (g) => g == 25 ? 'Orden blanca' : 'Ejército de plata',
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas blancas distintas.',
    value: (s) => s.color('W'),
  ),
  ..._series(
    id: 'azules',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (g) => g == 25 ? 'Mar de ideas' : 'Torre de marfil',
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas azules distintas.',
    value: (s) => s.color('U'),
  ),
  ..._series(
    id: 'negras',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (g) => g == 25 ? 'Pacto oscuro' : 'Señor de la cripta',
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas negras distintas.',
    value: (s) => s.color('B'),
  ),
  ..._series(
    id: 'rojas',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (g) => g == 25 ? 'Chispa' : 'Incendio',
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas rojas distintas.',
    value: (s) => s.color('R'),
  ),
  ..._series(
    id: 'verdes',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (g) => g == 25 ? 'Brote' : 'Bosque entero',
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas verdes distintas.',
    value: (s) => s.color('G'),
  ),
  ..._series(
    id: 'incoloras',
    category: AchievementCategory.color,
    steps: [(25, _b), (100, _s)],
    title: (g) => g == 25 ? 'Metal frío' : 'Forja eterna',
    description: (g) =>
        'Ten ${g.toStringAsFixed(0)} cartas incoloras distintas.',
    value: (s) => s.color('C'),
  ),
  ..._series(
    id: 'arcoiris',
    category: AchievementCategory.color,
    steps: [(5, _s)],
    title: (_) => 'Arcoíris',
    description: (_) => 'Ten al menos una carta de cada uno de los 5 colores.',
    value: (s) => s.colorsPresent,
  ),
  ..._series(
    id: 'multicolor',
    category: AchievementCategory.color,
    steps: [(10, _b), (50, _s)],
    title: (g) => g == 10 ? 'Mezcla' : 'Alianza dorada',
    description: (g) =>
        'Ten ${g.toStringAsFixed(0)} cartas multicolor distintas.',
    value: (s) => s.multicolorCards,
  ),
  ..._series(
    id: 'cincocolores',
    category: AchievementCategory.color,
    steps: [(1, _g)],
    title: (_) => 'Los cinco a la vez',
    description: (_) => 'Ten una carta con los cinco colores.',
    value: (s) => s.fiveColorCards,
  ),

  // --- Expansiones ---------------------------------------------------------
  ..._series(
    id: 'sets',
    category: AchievementCategory.expansiones,
    steps: [(1, _b), (5, _b), (10, _s), (25, _s), (50, _g)],
    title: (g) => switch (g) {
      1 => 'Primera expansión',
      5 => 'Cinco mundos',
      10 => 'Viajero',
      25 => 'Trotamundos',
      _ => 'Multiverso',
    },
    description: (g) =>
        'Ten cartas de ${g.toStringAsFixed(0)} expansiones distintas.',
    value: (s) => s.distinctSets,
  ),
  ..._series(
    id: 'setscompletos',
    category: AchievementCategory.expansiones,
    steps: [(1, _g), (3, _g), (10, _m)],
    title: (g) => switch (g) {
      1 => 'Álbum completo',
      3 => 'Tres de tres',
      _ => 'Maestro del álbum',
    },
    description: (g) => g == 1
        ? 'Completa una expansión entera en el Álbum.'
        : 'Completa ${g.toStringAsFixed(0)} expansiones enteras.',
    value: (s) => s.setsCompleted,
  ),
  ..._series(
    id: 'anyos',
    category: AchievementCategory.expansiones,
    steps: [(5, _s), (15, _g)],
    title: (g) => g == 5 ? 'Cinco años' : 'Máquina del tiempo',
    description: (g) =>
        'Ten cartas de ${g.toStringAsFixed(0)} años de salida distintos.',
    value: (s) => s.distinctYears,
  ),

  // --- Valor ---------------------------------------------------------------
  ..._series(
    id: 'valor',
    category: AchievementCategory.valor,
    steps: [(10, _b), (50, _b), (250, _s), (1000, _g), (5000, _m)],
    title: (g) => switch (g) {
      10 => 'Primeros euros',
      50 => 'Hucha',
      250 => 'Cartera gorda',
      1000 => 'Mil euros en cartón',
      _ => 'Tesorería',
    },
    description: (g) =>
        'Que tu colección valga ${g.toStringAsFixed(0)} € o más.',
    value: (s) => s.totalValue,
  ),
  ..._series(
    id: 'joya',
    category: AchievementCategory.valor,
    steps: [(20, _b), (100, _s), (500, _g)],
    title: (g) => switch (g) {
      20 => 'Buena carta',
      100 => 'Joya',
      _ => 'Pieza de museo',
    },
    description: (g) =>
        'Ten una sola carta que valga ${g.toStringAsFixed(0)} € o más.',
    value: (s) => s.bestCardValue,
  ),

  // --- Foils ---------------------------------------------------------------
  ..._series(
    id: 'foils',
    category: AchievementCategory.foils,
    steps: [(1, _b), (10, _b), (50, _s), (200, _g), (500, _m)],
    title: (g) => switch (g) {
      1 => 'Primer brillo',
      10 => 'Destellos',
      50 => 'Brilla la caja',
      200 => 'Colección brillante',
      _ => 'Todo brilla',
    },
    description: (g) => 'Ten ${g.toStringAsFixed(0)} cartas foil.',
    value: (s) => s.foilCopies,
  ),
  ..._series(
    id: 'foiljoya',
    category: AchievementCategory.foils,
    steps: [(50, _g)],
    title: (_) => 'Foil de las caras',
    description: (_) => 'Ten una foil que valga 50 € o más.',
    value: (s) => s.bestFoilValue,
  ),

  // --- Forge ---------------------------------------------------------------
  ..._series(
    id: 'mazos',
    category: AchievementCategory.forge,
    steps: [(1, _b), (5, _b), (25, _s)],
    title: (g) => switch (g) {
      1 => 'Primer mazo',
      5 => 'Cinco mazos',
      _ => 'Taller a pleno rendimiento',
    },
    description: (g) =>
        'Guarda ${g.toStringAsFixed(0)} mazos hechos con Forge.',
    value: (s) => s.decksSaved,
  ),
  ..._series(
    id: 'mazoscore',
    category: AchievementCategory.forge,
    steps: [(90, _g)],
    title: (_) => 'Mazo redondo',
    description: (_) => 'Genera un mazo con puntuación 90 o más.',
    value: (s) => s.bestDeckScore,
  ),
  ..._series(
    id: 'mazocolores',
    category: AchievementCategory.forge,
    steps: [(3, _s), (5, _g)],
    title: (g) => g == 3 ? 'Tricolor' : 'Arcoíris jugable',
    description: (g) =>
        'Guarda un mazo de ${g.toStringAsFixed(0)} colores.',
    value: (s) => s.maxDeckColors,
  ),
  ..._series(
    id: 'mazomono',
    category: AchievementCategory.forge,
    steps: [(1, _b)],
    title: (_) => 'Puro',
    description: (_) => 'Guarda un mazo de un solo color.',
    value: (s) => s.monoColorDecks,
  ),
  ..._series(
    id: 'mazocommander',
    category: AchievementCategory.forge,
    steps: [(1, _s)],
    title: (_) => 'Al mando',
    description: (_) => 'Guarda un mazo de Commander.',
    value: (s) => s.commanderDecks,
  ),

  // --- Escáner -------------------------------------------------------------
  ..._series(
    id: 'escaneadas',
    category: AchievementCategory.escaner,
    steps: [(1, _b), (50, _b), (500, _s), (2000, _g)],
    title: (g) => switch (g) {
      1 => 'Primer escaneo',
      50 => 'Mano rápida',
      500 => 'Escáner en serie',
      _ => 'Digitalizador',
    },
    description: (g) =>
        'Escanea ${g.toStringAsFixed(0)} cartas con la cámara o por foto.',
    value: (s) => s.cardsScanned,
  ),
  ..._series(
    id: 'foto',
    category: AchievementCategory.escaner,
    steps: [(9, _s), (20, _g)],
    title: (g) => g == 9 ? 'Página entera' : 'Foto de campeonato',
    description: (g) =>
        'Reconoce ${g.toStringAsFixed(0)} cartas en una sola foto.',
    value: (s) => s.bestPhotoCards,
  ),
  ..._series(
    id: 'escaneoperfecto',
    category: AchievementCategory.escaner,
    steps: [(1, _s)],
    title: (_) => 'Sin revisar',
    description: (_) =>
        'Escanea una página entera sin que ninguna carta quede para revisar.',
    value: (s) => s.perfectScans,
  ),

  // --- Dedicación ----------------------------------------------------------
  ..._series(
    id: 'dias',
    category: AchievementCategory.dedicacion,
    steps: [(2, _b), (7, _b), (30, _s), (100, _g)],
    title: (g) => switch (g) {
      2 => 'Vuelves',
      7 => 'Una semana',
      30 => 'Un mes',
      _ => 'Cien días',
    },
    description: (g) =>
        'Usa ManaForge ${g.toStringAsFixed(0)} días distintos.',
    value: (s) => s.activeDays,
  ),
  ..._series(
    id: 'racha',
    category: AchievementCategory.dedicacion,
    steps: [(3, _b), (7, _s), (30, _g)],
    title: (g) => switch (g) {
      3 => 'Tres seguidos',
      7 => 'Semana perfecta',
      _ => 'Mes sin fallar',
    },
    description: (g) =>
        'Entra ${g.toStringAsFixed(0)} días seguidos.',
    value: (s) => s.longestStreak,
  ),
  ..._series(
    id: 'semanas',
    category: AchievementCategory.dedicacion,
    steps: [(4, _s)],
    title: (_) => 'Mes de compras',
    description: (_) => 'Usa ManaForge 4 semanas seguidas.',
    value: (s) => s.weeksInARow,
  ),

  // --- Carpetas ------------------------------------------------------------
  ..._series(
    id: 'carpetas',
    category: AchievementCategory.carpetas,
    steps: [(1, _b), (5, _s)],
    title: (g) => g == 1 ? 'Orden' : 'Todo clasificado',
    description: (g) => 'Crea ${g.toStringAsFixed(0)} carpetas.',
    value: (s) => s.foldersCreated,
  ),
  ..._series(
    id: 'carpetagrande',
    category: AchievementCategory.carpetas,
    steps: [(100, _s)],
    title: (_) => 'Carpetón',
    description: (_) => 'Ten una carpeta con 100 cartas o más.',
    value: (s) => s.biggestFolderCards,
  ),
  ..._series(
    id: 'carpetavalor',
    category: AchievementCategory.carpetas,
    steps: [(100, _g)],
    title: (_) => 'La carpeta buena',
    description: (_) => 'Ten una carpeta que valga 100 € o más.',
    value: (s) => s.richestFolderValue,
  ),

  // --- Curiosidades --------------------------------------------------------
  ..._series(
    id: 'tierrasbasicas',
    category: AchievementCategory.curiosidades,
    steps: [(5, _b)],
    title: (_) => 'Las cinco básicas',
    description: (_) =>
        'Ten los cinco tipos de tierra básica (llanura, isla, pantano, '
        'montaña y bosque).',
    value: (s) => s.basicLandTypes,
  ),
  ..._series(
    id: 'fuerza',
    category: AchievementCategory.curiosidades,
    steps: [(10, _s)],
    title: (_) => 'Bicho gordo',
    description: (_) => 'Ten una criatura de fuerza 10 o más.',
    value: (s) => s.maxPower,
  ),
  ..._series(
    id: 'coste',
    category: AchievementCategory.curiosidades,
    steps: [(10, _b)],
    title: (_) => 'Carísima de lanzar',
    description: (_) => 'Ten una carta de coste convertido 10 o más.',
    value: (s) => s.maxCmc,
  ),
  ..._series(
    id: 'costecero',
    category: AchievementCategory.curiosidades,
    steps: [(1, _b)],
    title: (_) => 'Gratis',
    description: (_) => 'Ten una carta de coste 0.',
    value: (s) => s.zeroCostCards,
  ),
  ..._series(
    id: 'tipos',
    category: AchievementCategory.curiosidades,
    steps: [(7, _s)],
    title: (_) => 'De todo un poco',
    description: (_) =>
        'Ten al menos una criatura, un instantáneo, un conjuro, un artefacto, '
        'un encantamiento, una tierra y un planeswalker.',
    value: (s) => s.typesCollected,
  ),
  ..._series(
    id: 'planeswalkers',
    category: AchievementCategory.curiosidades,
    steps: [(5, _s)],
    title: (_) => 'Compañía de planeswalkers',
    description: (_) => 'Ten 5 planeswalkers distintos.',
    value: (s) => s.type('Planeswalker'),
  ),
  ..._series(
    id: 'noventas',
    category: AchievementCategory.curiosidades,
    steps: [(1, _s)],
    title: (_) => 'Reliquia',
    description: (_) => 'Ten una carta de los años 90.',
    value: (s) => s.cardsFrom90s,
    secret: true,
  ),
  ..._series(
    id: 'idiomas',
    category: AchievementCategory.curiosidades,
    steps: [(1, _b), (25, _s)],
    title: (g) => g == 1 ? 'Otra lengua' : 'Colección políglota',
    description: (g) => g == 1
        ? 'Ten una carta en un idioma que no sea inglés.'
        : 'Ten 25 cartas en otros idiomas.',
    value: (s) => s.foreignCards,
    secret: true,
  ),
  ..._series(
    id: 'wishlist',
    category: AchievementCategory.curiosidades,
    steps: [(20, _b)],
    title: (_) => 'Lista de deseos',
    description: (_) => 'Apunta 20 cartas en la wishlist.',
    value: (s) => s.wishlistCards,
  ),
];
