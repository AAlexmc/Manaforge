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

/// Frase corta por tema: cada mazo cuenta su propia historia.
const Map<String, String> _themeTaglines = {
  'lifegain': 'Cada punto de vida que ganas es daño para ellos: drena y aguanta.',
  'sacrifice': 'Tus criaturas valen más muertas: sacrifícalas y cobra el peaje.',
  'spells': 'Cada instantáneo cuenta: juega en el turno del rival y castiga.',
  'artifacts': 'Monta tu taller: cada artefacto hace más fuertes a los demás.',
  'counters': 'Contadores +1/+1: tus criaturas crecen hasta ser inalcanzables.',
  'tokens': 'Inunda la mesa de fichas: donde ellos tienen una, tú tienes cinco.',
  'graveyard': 'Tu cementerio es tu segunda mano: llénalo y recicla lo mejor.',
};

/// Frase corta para la tarjeta del carrusel.
String tagline(GeneratedDeck gen) {
  final themed = _themeTaglines[gen.theme];
  switch (gen.deck.archetype) {
    case Archetype.aggro:
      return themed ??
          'Sal rápido y pega a la cara: la partida debería acabar pronto.';
    case Archetype.tempo:
      return themed ?? 'Presiona pronto y protege la ventaja con tus hechizos.';
    case Archetype.midrange:
      return themed ??
          'Cambia bien tus cartas y gana el medio juego con ${themeName(gen.theme)}.';
    case Archetype.control:
      return 'Aguanta, responde a todo y remata cuando la mesa sea tuya.';
  }
}

/// Paso central del plan, específico del tema (T3-T4 es donde el tema manda).
const Map<String, String> _themeMidgame = {
  'lifegain':
      'Encadena tus fuentes de vida con los que castigan al rival por ello.',
  'sacrifice':
      'Sacrifica lo barato para robar, drenar o hacer crecer al resto.',
  'spells':
      'Guarda maná abierto: tus criaturas crecen con cada hechizo que lanzas.',
  'artifacts':
      'Despliega artefactos baratos y activa a los que los cuentan.',
  'counters':
      'Apila contadores en una o dos criaturas y protégelas.',
  'tokens':
      'Genera fichas cada turno y busca los efectos que las hacen mayores.',
  'graveyard':
      'Muele y descarta con intención: lo que cae al cementerio vuelve.',
};

/// Remate del plan, específico del tema.
const Map<String, String> _themeEndgame = {
  'lifegain': 'Con la vida alta, cambia a modo agresivo: ellos ya no llegan.',
  'sacrifice': 'El valor acumulado te da la partida: cada cambio te sale gratis.',
  'spells': 'Un par de hechizos en el mismo turno y tus criaturas cierran.',
  'artifacts': 'Tu mesa vale el doble que la suya: remata con tus payoffs.',
  'counters': 'Una amenaza enorme y protegida acaba la partida en dos golpes.',
  'tokens': 'Ataca en masa: ningún bloqueo aguanta a todo tu ejército.',
  'graveyard': 'Reutiliza tus mejores cartas: juegas con dos manos contra una.',
};

/// Plan de juego por tramos de turnos, con el tema del mazo como hilo.
List<(String, String)> gamePlan(GeneratedDeck gen) {
  final theme = themeName(gen.theme);
  final mid = _themeMidgame[gen.theme];
  final end = _themeEndgame[gen.theme];
  switch (gen.deck.archetype) {
    case Archetype.aggro:
      return [
        ('T1-T2', 'Juega una criatura cada turno, sin excepción.'),
        ('T3-T4',
            mid ?? 'Sigue atacando; guarda el daño directo para quitar bloqueadores.'),
        ('T5+', end ?? 'Remata con todo: aquí deberías cerrar la partida.'),
      ];
    case Archetype.tempo:
      return [
        ('T1-T2', 'Amenaza barata y maná abierto cuando puedas.'),
        ('T3-T4', mid ?? 'Ataca y usa tus hechizos en el turno del rival.'),
        ('T5+',
            end ?? 'Protege tus criaturas y cierra por el aire o con daño directo.'),
      ];
    case Archetype.midrange:
      return [
        ('T1-T2', 'Desarrolla y no regales cartas: cambios de uno por uno buenos.'),
        ('T3-T4', mid ?? 'Despliega tus motores de $theme y estabiliza la mesa.'),
        ('T5+',
            end ?? 'Tus cartas valen más que las suyas: conviértelo en la partida.'),
      ];
    case Archetype.control:
      return [
        ('T1-T2', 'Tierra al turno y responde solo a lo que importa.'),
        ('T3-T4', 'Limpia la mesa y roba cartas: el tiempo juega para ti.'),
        ('T5+', end ?? 'Baja una amenaza y protégela hasta el final.'),
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
