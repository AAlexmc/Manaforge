/// Qué le falta a un mazo para poder jugarlo de verdad.
///
/// Vive fuera de las pantallas porque lo miran DOS: la tarjeta de la
/// propuesta en Forge ("te faltan 7 · 12,40 €") y el detalle del mazo
/// ("⚠ te faltan 7 cartas"). Cuando cada una lo calculaba a su manera, un
/// mazo podía decir dos cosas distintas en dos pantallas seguidas.
///
/// La cuenta se hace SIEMPRE contra las copias reales por nombre, nunca
/// contra el pool: el pool del modo "incluir cartas que no tengo" dice 4 de
/// todo, y preguntarle a él sería responder "las tienes todas" siempre.
library;

import 'package:forge_engine/forge_engine.dart' as fe;

/// Copias que faltan de cada carta {nombre: cuántas}. Vacío = lo tienes todo.
Map<String, int> missingCards(fe.Deck deck, Map<String, int> ownedByName) {
  final falta = <String, int>{};
  void mirar(Map<String, int> parte) {
    parte.forEach((nombre, pide) {
      final tengo = ownedByName[nombre] ?? 0;
      if (tengo < pide) falta[nombre] = pide - tengo;
    });
  }

  mirar(deck.cards);
  mirar(deck.lands);
  return falta;
}

/// Cuántas copias faltan en total.
int missingCopies(fe.Deck deck, Map<String, int> ownedByName) =>
    missingCards(deck, ownedByName).values.fold(0, (a, b) => a + b);

/// Lo que costaría completarlo. Las cartas sin precio conocido suman 0 y no
/// se inventan: por eso quien lo enseña dice también cuántas faltan.
double missingCost(Map<String, int> missing, Map<String, double> prices) =>
    missing.entries
        .fold(0.0, (sum, e) => sum + (prices[e.key] ?? 0) * e.value);
