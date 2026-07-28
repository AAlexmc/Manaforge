/// Dejar de tener una carta, con todo lo que arrastra.
///
/// Hay DOS acciones distintas y se parecen peligrosamente:
///
///  - **quitar de una carpeta**: solo desetiqueta. La carta se sigue teniendo,
///    no se toca el álbum ni ningún mazo. Eso lo hace `FolderStore.toggleCard`
///    y no pasa por aquí.
///  - **"ya no tengo esta carta"**: sale de la colección y de TODAS las
///    carpetas (si no, quedan cartas fantasma etiquetadas que ya no existen),
///    y su hueco del álbum vuelve a estar vacío.
///
/// Los mazos NO pierden la carta: se queda en la lista y el mazo avisa de
/// cuántas te faltan. Vender un Sol Ring no puede deshacer un mazo que costó
/// una tarde montar; si de verdad lo quieres fuera, se quita a mano.
library;

import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/folder_store.dart';

void forgetCard({
  required CollectionStore collection,
  required String oracleId,
  FolderStore? folders,
}) {
  // primero la colección: es el dato que manda. Si algo fallara después, lo
  // peor que queda es una etiqueta de más, no una carta que sigue contando
  collection.setQty(oracleId, 0);
  folders?.removeCardEverywhere(oracleId);
}

/// Cuántas copias del mazo NO tienes ahora mismo. Cuenta también las que
/// tienes a medias (el mazo pide 4 y tienes 1 son 3 que faltan).
int missingFromDeck({
  required Map<String, int> deckCards,
  required Map<String, int> deckLands,
  required Map<String, int> ownedByOracle,
}) {
  var faltan = 0;
  void mirar(Map<String, int> parte) {
    parte.forEach((id, pide) {
      final tengo = ownedByOracle[id] ?? 0;
      if (tengo < pide) faltan += pide - tengo;
    });
  }

  mirar(deckCards);
  mirar(deckLands);
  return faltan;
}
