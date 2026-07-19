import 'package:forge_engine/forge_engine.dart' as fe;

/// Mazos del meta para el Modo Test: listas representativas de arquetipos
/// clásicos, con cartas archiconocidas que están en la base de datos local.
/// No son listas de torneo al día (eso llegará con datos online); son
/// sparrings honestos de cada estilo de juego.
class MetaDeck {
  final String id;
  final String name;
  final String description;
  final String colors;
  final fe.Archetype archetype;
  final Map<String, int> cards;
  final Map<String, int> lands;

  const MetaDeck({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    required this.archetype,
    required this.cards,
    required this.lands,
  });

  fe.Deck toDeck() => fe.Deck(
        name: name,
        colors: colors,
        archetype: archetype,
        cards: cards,
        lands: lands,
      );

  Map<String, int> get allNames => {...cards, ...lands};
}

const metaDecks = <MetaDeck>[
  MetaDeck(
    id: 'mono_red_aggro',
    name: 'Mono-Rojo Aggro',
    description: 'Criaturas baratas y daño a la cara: te mata en 4-5 turnos '
        'si no aguantas el ritmo.',
    colors: 'R',
    archetype: fe.Archetype.aggro,
    cards: {
      'Goblin Guide': 4,
      'Monastery Swiftspear': 4,
      'Viashino Pyromancer': 4,
      'Lightning Bolt': 4,
      'Lava Spike': 4,
      'Rift Bolt': 4,
      'Skewer the Critics': 4,
      'Searing Blaze': 4,
      'Light Up the Stage': 4,
      'Play with Fire': 4,
    },
    lands: {'Mountain': 20},
  ),
  MetaDeck(
    id: 'azorius_control',
    name: 'Control Azorius',
    description: 'Contramagia, barreduras y robo: alarga la partida y gana '
        'con pocos finalizadores.',
    colors: 'WU',
    archetype: fe.Archetype.control,
    cards: {
      'Counterspell': 4,
      'Essence Scatter': 4,
      'Path to Exile': 4,
      'Wrath of God': 4,
      'Divination': 4,
      'Opt': 4,
      'Serra Angel': 4,
      'Air Elemental': 4,
      'Sphinx of Magosi': 2,
    },
    lands: {'Island': 13, 'Plains': 13},
  ),
  MetaDeck(
    id: 'golgari_midrange',
    name: 'Midrange Golgari',
    description: 'Cambios de uno por uno, criaturas eficientes y removal '
        'negro: gana el juego largo por calidad de cartas.',
    colors: 'BG',
    archetype: fe.Archetype.midrange,
    cards: {
      'Llanowar Elves': 4,
      'Kalonian Tusker': 4,
      'Ravenous Chupacabra': 4,
      'Obstinate Baloth': 4,
      'Thrashing Brontodon': 4,
      'Murder': 4,
      'Epic Downfall': 4,
      'Sign in Blood': 4,
      'Rampant Growth': 4,
    },
    lands: {'Forest': 12, 'Swamp': 12},
  ),
];
