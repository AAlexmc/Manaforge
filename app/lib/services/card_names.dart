import 'package:flutter/widgets.dart';

/// Nombre de carta para ENSEÑAR: con la UI en español y traducción disponible
/// (cards.name_es, schema v5), el español; si no, el inglés canónico.
///
/// SOLO presentación: las claves internas (pool, mazos, motor Forge) y la
/// exportación/copia de listas siguen siendo el nombre inglés SIEMPRE —
/// Moxfield/Arena/Discord esperan inglés.
String cardDisplayName(BuildContext context, String name, {String? nameEs}) {
  if (nameEs != null &&
      Localizations.localeOf(context).languageCode == 'es') {
    return nameEs;
  }
  return name;
}

const Map<String, String> _foldMap = {
  'á': 'a', 'à': 'a', 'ä': 'a', 'â': 'a', //
  'é': 'e', 'è': 'e', 'ë': 'e', 'ê': 'e',
  'í': 'i', 'ì': 'i', 'ï': 'i', 'î': 'i',
  'ó': 'o', 'ò': 'o', 'ö': 'o', 'ô': 'o',
  'ú': 'u', 'ù': 'u', 'ü': 'u', 'û': 'u',
  'ñ': 'n', 'ç': 'c',
};

/// Pliega para buscar: minúsculas y sin diacríticos — espejo del `_fold` de
/// `scripts/enrich_names_es.py` (que puebla `cards.name_es_fold`), acotado a
/// lo que trae el español de Magic. «Ornitóptero» y «ORNITOPTERO» buscan lo
/// mismo; el LIKE de SQLite solo pliega ASCII, por eso existe la columna.
String foldForSearch(String text) {
  final sb = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    sb.write(_foldMap[ch] ?? ch);
  }
  return sb.toString();
}
