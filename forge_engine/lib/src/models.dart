/// Carta del pool del usuario (subconjunto de los datos de Scryfall que el motor necesita).
class Card {
  final String name;
  final int qty;
  final String manaCost;
  final int cmc;
  final String colors; // "WB", "U", "" para incoloras
  final List<String> types; // ["Creature"], ["Land"], …
  final List<String> subtypes; // ["Elf","Druid"] — lo de detrás del «—»
  final String oracle;
  final int? power; // null para no-criaturas o poder variable (*)
  final int? toughness;

  /// Identidad de color (Commander). Null = usar [colors].
  final String? colorIdentity;

  /// Keywords estructuradas (minúsculas) de la columna JSON de la DB.
  final List<String> keywords;

  const Card({
    required this.name,
    required this.qty,
    required this.manaCost,
    required this.cmc,
    required this.colors,
    required this.types,
    this.subtypes = const [],
    required this.oracle,
    this.power,
    this.toughness,
    this.colorIdentity,
    this.keywords = const [],
  });

  String get identity => colorIdentity ?? colors;

  static int? _stat(dynamic v) =>
      v is int ? v : (v is String ? int.tryParse(v) : null);

  factory Card.fromJson(String name, Map<String, dynamic> json) => Card(
        name: name,
        qty: json['qty'] as int,
        manaCost: (json['mana_cost'] ?? '') as String,
        cmc: json['cmc'] as int,
        colors: (json['colors'] ?? '') as String,
        types: List<String>.from(json['types'] ?? const []),
        subtypes: List<String>.from(json['subtypes'] ?? const []),
        oracle: (json['oracle'] ?? '') as String,
        power: _stat(json['power']),
        toughness: _stat(json['toughness']),
        colorIdentity: json['color_identity'] as String?,
        keywords: List<String>.from(json['keywords'] ?? const [])
            .map((k) => k.toString().toLowerCase())
            .toList(),
      );

  bool get isLand => types.contains('Land');
  bool get isCreature => types.contains('Creature');
  bool get isLegendaryCreature =>
      isCreature && types.contains('Legendary');

  /// ¿Tiene esta keyword? Si hay [keywords] estructuradas se usan tal cual;
  /// si no (DB vieja o carta sintética), cae al regex sobre el oracle.
  bool hasKeyword(String k) =>
      keywords.isNotEmpty ? keywords.contains(k) : oracle.toLowerCase().contains(k);
}

/// Arquetipos soportados y sus rangos (aprox. Frank Karsten, mazos de 60).
enum Archetype {
  aggro(landMin: 20, landMax: 23, cmcMin: 0.0, cmcMax: 2.2),
  tempo(landMin: 22, landMax: 24, cmcMin: 1.8, cmcMax: 2.6),
  midrange(landMin: 23, landMax: 25, cmcMin: 2.2, cmcMax: 3.5),
  control(landMin: 26, landMax: 27, cmcMin: 2.8, cmcMax: 3.8);

  final int landMin;
  final int landMax;
  final double cmcMin;
  final double cmcMax;

  const Archetype({
    required this.landMin,
    required this.landMax,
    required this.cmcMin,
    required this.cmcMax,
  });
}

/// Un mazo generado o construido a mano.
class Deck {
  final String name;
  final String colors;
  final Archetype archetype;
  final Map<String, int> cards; // hechizos y criaturas {nombre: cantidad}
  final Map<String, int> lands; // tierras {nombre: cantidad}

  const Deck({
    required this.name,
    required this.colors,
    required this.archetype,
    required this.cards,
    required this.lands,
  });

  int get totalCards =>
      cards.values.fold(0, (a, b) => a + b) +
      lands.values.fold(0, (a, b) => a + b);
}
