import 'classify.dart';
import 'mana_curve.dart';
import 'models.dart';
import 'generator.dart';

/// Textos de plan de juego y explicación — microcopys de jugador a jugador.

const Map<String, String> _themeNames = {
  'lifegain': 'drenaje de vida',
  'sacrifice': 'sacrificio',
  'spells': 'hechizos',
  'artifacts': 'artefactos',
  'counters': 'contadores +1/+1',
  'tokens': 'enjambre',
  'graveyard': 'cementerio',
  'goodstuff': 'lo mejor de tus cartas',
};

String themeName(String theme) => _themeNames[theme] ?? theme;

/// Frase corta para la tarjeta del carrusel.
String tagline(GeneratedDeck gen) {
  switch (gen.deck.archetype) {
    case Archetype.aggro:
      return 'Sal rápido y pega a la cara: la partida debería acabar pronto.';
    case Archetype.tempo:
      return 'Presiona pronto y protege la ventaja con tus hechizos.';
    case Archetype.midrange:
      return 'Cambia bien tus cartas y gana el medio juego con ${themeName(gen.theme)}.';
    case Archetype.control:
      return 'Aguanta, responde a todo y remata cuando la mesa sea tuya.';
  }
}

/// Plan de juego por tramos de turnos.
List<(String, String)> gamePlan(GeneratedDeck gen) {
  final theme = themeName(gen.theme);
  switch (gen.deck.archetype) {
    case Archetype.aggro:
      return [
        ('T1-T2', 'Juega una criatura cada turno, sin excepción.'),
        ('T3-T4', 'Sigue atacando; guarda el daño directo para quitar bloqueadores.'),
        ('T5+', 'Remata con todo: aquí deberías cerrar la partida.'),
      ];
    case Archetype.tempo:
      return [
        ('T1-T2', 'Amenaza barata y maná abierto cuando puedas.'),
        ('T3-T4', 'Ataca y usa tus hechizos en el turno del rival.'),
        ('T5+', 'Protege tus criaturas y cierra por el aire o con daño directo.'),
      ];
    case Archetype.midrange:
      return [
        ('T1-T2', 'Desarrolla y no regales cartas: cambios de uno por uno buenos.'),
        ('T3-T4', 'Despliega tus motores de $theme y estabiliza la mesa.'),
        ('T5+', 'Tus cartas valen más que las suyas: conviértelo en la partida.'),
      ];
    case Archetype.control:
      return [
        ('T1-T2', 'Tierra al turno y responde solo a lo que importa.'),
        ('T3-T4', 'Limpia la mesa y roba cartas: el tiempo juega para ti.'),
        ('T5+', 'Baja una amenaza y protégela hasta el final.'),
      ];
  }
}

/// Explicación plegable "¿Por qué este mazo funciona?" con los números reales.
String whyItWorks(GeneratedDeck gen, Map<String, Card> pool) {
  final deck = gen.deck;
  final avg = ManaCurve.averageCmc(deck.cards, pool);
  final lands = deck.lands.values.fold(0, (a, b) => a + b);
  var creatures = 0;
  var interaction = 0;
  deck.cards.forEach((n, q) {
    final tags = classify(pool[n]!);
    if (tags.contains('creature')) creatures += q;
    if (tags.contains('removal') ||
        tags.contains('counterspell') ||
        tags.contains('burn') ||
        tags.contains('sweeper')) {
      interaction += q;
    }
  });
  return 'Coste medio ${avg.toStringAsFixed(2)}: por la regla de Karsten '
      '(24 tierras a coste 3.0, ±1 por cada ±0.5), este mazo lleva $lands '
      'tierras — dentro del rango de un mazo ${deck.archetype.name}. '
      'Hay $creatures criaturas para mantener la mesa y $interaction cartas '
      'de interacción para lo que traiga el rival. El tema '
      '(${themeName(gen.theme)}) concentra tus sinergias: cuantas más piezas '
      'del tema veas, más fuerte es cada una.';
}
