/// El catálogo de tours. Blinda la invariante que documenta TourStep: un paso
/// que señala un botón (targetKey) DEBE traer su pantalla al frente
/// (goToScreen), porque el IndexedStack mantiene todas montadas y medir sin
/// traerla daría el rectángulo equivocado.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/services/tours.dart';

void main() {
  final t = AppLocalizationsEs();

  test('hay tours y todos tienen nombre y al menos un paso', () {
    expect(kTours, isNotEmpty);
    final keys = TourKeys();
    for (final tour in kTours) {
      expect(tour.name(t), isNotEmpty, reason: '${tour.id} sin nombre');
      expect(tour.build(t, keys), isNotEmpty, reason: '${tour.id} sin pasos');
    }
  });

  test('cada paso con targetKey también cambia de pantalla (invariante)', () {
    final keys = TourKeys();
    for (final tour in kTours) {
      for (final step in tour.build(t, keys)) {
        if (step.targetKey != null) {
          expect(step.goToScreen, isNotNull,
              reason: 'tour "${tour.id}": un paso señala un botón pero no '
                  'trae su pantalla al frente');
        }
      }
    }
  });

  test('el primer tour es el de bienvenida', () {
    expect(kTours.first.id, 'welcome');
  });

  test('los ids no se repiten (el menú los usa como identidad)', () {
    final ids = kTours.map((t) => t.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'ids repetidos: $ids');
  });

  test('están los tours por tema de Colección, Forge y Mercado', () {
    final ids = kTours.map((t) => t.id).toSet();
    expect(ids, containsAll(['collection', 'forge', 'market', 'settings']));
  });

  test('el gran tour pasa por TODAS las pestañas', () {
    final full = kTours.firstWhere((t) => t.id == 'full');
    final pantallas = full
        .build(t, TourKeys())
        .map((s) => s.goToScreen)
        .whereType<int>()
        .toSet();
    // 0 Inicio · 1 Colección · 2 Álbum · 3 Forge · 4 Mazos · 5 Mercado · 6 Ajustes
    expect(pantallas, {0, 1, 2, 3, 4, 5, 6});
  });

  test('el gran tour no salta hacia atrás entre pantallas', () {
    final full = kTours.firstWhere((t) => t.id == 'full');
    int anterior = -1;
    for (final step in full.build(t, TourKeys())) {
      final s = step.goToScreen;
      if (s == null) continue;
      expect(s, greaterThanOrEqualTo(anterior),
          reason: 'el recorrido vuelve atrás: $anterior → $s');
      anterior = s;
    }
  });

  test('ningún paso señala dos sitios a la vez', () {
    for (final tour in kTours) {
      for (final step in tour.build(t, TourKeys())) {
        expect(step.targetKey != null && step.navBarIndex != null, isFalse,
            reason: 'tour "${tour.id}": un paso señala botón Y barra');
      }
    }
  });
}
