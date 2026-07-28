/// El catálogo de logros ya no lleva el texto dentro: cada logro pide su
/// nombre y su explicación a las traducciones. Eso se puede romper de una
/// forma que no se ve compilando — apuntar dos escalones de una serie a la
/// MISMA clave — y entonces la pantalla enseña "Cien y subiendo" dos veces.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/app_localizations_en.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/domain/achievements.dart';

void main() {
  final idiomas = <String, AppLocalizations>{
    'es': AppLocalizationsEs(),
    'en': AppLocalizationsEn(),
  };

  idiomas.forEach((nombre, t) {
    test('cada logro tiene nombre y explicación en $nombre', () {
      for (final a in kAchievements) {
        expect(a.title(t).trim(), isNotEmpty, reason: a.id);
        expect(a.description(t).trim(), isNotEmpty, reason: a.id);
        expect(a.description(t), isNot(contains('{')),
            reason: '${a.id}: hueco sin rellenar');
      }
    });

    test('ningún logro repite nombre en $nombre', () {
      final porNombre = <String, List<String>>{};
      for (final a in kAchievements) {
        porNombre.putIfAbsent(a.title(t), () => []).add(a.id);
      }
      final repes = porNombre.entries.where((e) => e.value.length > 1);
      expect(repes, isEmpty,
          reason: 'mismo nombre para varios logros: '
              '${repes.map((e) => '${e.key} -> ${e.value}').join(' · ')}');
    });

    test('la meta de cada escalón sale en su explicación en $nombre', () {
      // las series con hueco dicen el número: si la clave se queda sin
      // argumento, la explicación es la misma para todos los escalones
      final porSerie = <String, Set<String>>{};
      for (final a in kAchievements) {
        final serie = a.id.substring(0, a.id.lastIndexOf('-'));
        porSerie.putIfAbsent(serie, () => <String>{}).add(a.description(t));
      }
      for (final entry in porSerie.entries) {
        final escalones =
            kAchievements.where((a) => a.id.startsWith('${entry.key}-'));
        if (escalones.length < 2) continue;
        expect(entry.value.length, escalones.length,
            reason: '${entry.key}: escalones con la misma explicación');
      }
    });

    test('rarezas, categorías y rangos se saben decir en $nombre', () {
      for (final tier in AchievementTier.values) {
        expect(tierLabel(t, tier).trim(), isNotEmpty, reason: '$tier');
      }
      for (final c in AchievementCategory.values) {
        expect(categoryLabel(t, c).trim(), isNotEmpty, reason: '$c');
      }
      for (final nivel in [1, 3, 5, 7, 10, 13, 99]) {
        expect(levelTitle(t, nivel).trim(), isNotEmpty, reason: 'nivel $nivel');
      }
    });
  });
}
