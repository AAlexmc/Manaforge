/// Precarga de fichas (imagen, nombre impreso) para los candidatos de un
/// escaneo, compartida entre escáner por foto y escáner en vivo.
///
/// Antes cada pantalla pedía `byScryfallId` UNO A UNO por candidato (hasta 3
/// por carta, top-3): consultar la base de cartas se convertía en N+1
/// consultas por carta escaneada. Con `byScryfallIds` se piden de una
/// tacada.
library;

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/scanner/hash_index.dart';

/// Rellena [hitCache] con lo que falte de [matches], en un único viaje a la
/// base. Si la consulta falla entera (sin DB de cartas), los candidatos se
/// quedan en caché como `null`: candidato solo con nombre, sin ficha.
Future<void> precacheHits(CardDatabase db, Map<String, CardHit?> hitCache,
    Iterable<ScanMatch> matches) async {
  final faltan = {
    for (final m in matches)
      if (!hitCache.containsKey(m.entry.scryfallId)) m.entry.scryfallId
  };
  if (faltan.isEmpty) return;
  Map<String, CardHit> hits;
  try {
    hits = await db.byScryfallIds(faltan);
  } catch (_) {
    hits = const {};
  }
  for (final id in faltan) {
    hitCache[id] = hits[id];
  }
}
