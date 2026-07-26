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
