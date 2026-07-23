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
}
