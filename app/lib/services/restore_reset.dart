/// Volver a empezar tras restaurar una copia.
///
/// Al restaurar, la app se reconstruye entera y los almacenes se crean de
/// cero... salvo dos, que son instancias compartidas (`recentsStore` y
/// `priceHistoryStore`): esos sobreviven con lo de ANTES en memoria y lo
/// vuelven a escribir encima de lo recién restaurado —el historial de precios
/// además reescribe su log entero al compactar, y un apunte perdido ahí no se
/// recupera—. Esto los deja como recién nacidos, sin tocar el disco.
library;

import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/data/repositories/recents_store.dart';

void resetSharedStores({RecentsStore? recents, PriceHistoryStore? history}) {
  (recents ?? recentsStore).invalidate();
  (history ?? priceHistoryStore).invalidate();
}
