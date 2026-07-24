import 'classify.dart';
import 'mana_curve.dart';
import 'models.dart';
import 'generator.dart';

/// Los NÚMEROS del plan de juego. El texto no vive aquí: el motor es Dart
/// puro y la app se lee en diez idiomas, así que los microcopys ("juega una
/// criatura cada turno") están en `app/lib/services/forge_texts.dart`, que sí
/// tiene traducciones. Aquí queda lo que hace falta saber del mazo para
/// escribirlos.

/// Los temas que sabe detectar el motor, en el orden en que se nombran.
const List<String> kThemes = [
  'lifegain',
  'sacrifice',
  'spells',
  'artifacts',
  'counters',
  'tokens',
  'graveyard',
  'goodstuff',
];

/// Lo que hay que contar del mazo para explicar por qué funciona: el coste
/// medio, cuántas tierras lleva y cuántas cartas hacen cada trabajo.
typedef WhyItWorksFacts = ({
  double avgCmc,
  int lands,
  int creatures,
  int interaction,
});

/// Cuenta lo de arriba. Función pura: los mismos números que enseña la
/// explicación plegable "¿Por qué este mazo funciona?".
WhyItWorksFacts whyItWorksFacts(GeneratedDeck gen, Map<String, Card> pool) {
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
  return (
    avgCmc: avg,
    lands: lands,
    creatures: creatures,
    interaction: interaction,
  );
}
