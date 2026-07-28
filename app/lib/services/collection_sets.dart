/// Cuántas casillas del álbum tienes de cada expansión. Está aquí, y no
/// dentro del Álbum, porque los LOGROS necesitan contar exactamente igual
/// (si no, "álbum completo" saldría a un número en una pantalla y a otro en
/// la otra).
library;

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';

Future<Map<String, int>> ownedCardsBySet(
    CardDatabase db, CollectionStore collection) async {
  if (collection.hasPrintingData) {
    // preciso: sabemos la edición exacta de cada carta (clave "set|nº")
    final owned = <String, int>{};
    collection.printingQty.forEach((key, qty) {
      if (qty <= 0) return;
      final set = key.split('|').first;
      owned[set] = (owned[set] ?? 0) + 1;
    });
    return owned;
  }
  // aproximado (colecciones antiguas): por carta, no por edición
  return db.ownedCountBySet(collection.qtyByOracle.keys);
}
