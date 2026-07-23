/// El catálogo de tours. Blinda la invariante que documenta TourStep: un paso
/// que señala un botón (targetKey) DEBE traer su pantalla al frente
/// (goToScreen), porque el IndexedStack mantiene todas montadas y medir sin
/// traerla daría el rectángulo equivocado.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/services/tours.dart';
import 'package:manaforge_app/widgets/tour_overlay.dart';

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

  test('el gran tour abre Logros y Certificados', () {
    final full = kTours.firstWhere((t) => t.id == 'full');
    final empujadas = full
        .build(t, TourKeys())
        .map((s) => s.push)
        .whereType<TourPush>()
        .toSet();
    expect(empujadas, {TourPush.logros, TourPush.certificados});
  });

  test('antes de abrir una pantalla, el tour enseña el botón que la abre', () {
    // la regla que pidió Ale: nunca aparecer ya dentro de una pantalla. El
    // paso que cambia de pestaña va SIEMPRE detrás de uno que señala su
    // destino en la barra.
    final full = kTours.firstWhere((t) => t.id == 'full');
    final pasos = full.build(t, TourKeys());
    int? anterior;
    for (var i = 0; i < pasos.length; i++) {
      final destino = pasos[i].goToScreen;
      if (destino == null || destino == anterior) continue;
      if (anterior != null) {
        expect(pasos[i - 1].navBarIndex, isNotNull,
            reason: 'el paso ${i + 1} salta a la pantalla $destino sin '
                'enseñar antes su botón en la barra');
      }
      anterior = destino;
    }
  });

  test('el tour enseña la puerta de las pantallas empujadas', () {
    // Logros y Certificados se abren desde un botón: hay que señalarlo antes
    final progreso = kTours.firstWhere((t) => t.id == 'progress');
    final pasos = progreso.build(t, TourKeys());
    expect(pasos.first.push, isNull); // el primero enseña la tarjeta de nivel
    expect(pasos.first.targetKey, isNotNull);
    expect(pasos[1].push, TourPush.logros);
    // y dentro de Logros se señala el botón de Certificados antes de abrirlos
    expect(pasos[2].push, TourPush.logros);
    expect(pasos[2].targetKey, isNotNull);
    expect(pasos[3].push, TourPush.certificados);
  });

  test('un paso que despliega una sección trae antes su pantalla', () {
    for (final tour in kTours) {
      for (final step in tour.build(t, TourKeys())) {
        if (step.prepare != null) {
          expect(step.goToScreen, isNotNull,
              reason: 'tour "${tour.id}": despliega una sección de una '
                  'pantalla que no ha traído al frente');
        }
      }
    }
  });

  test('el tour de Ajustes recorre las paradas en orden', () {
    final ajustes = kTours.firstWhere((t) => t.id == 'settings');
    final pasos = ajustes.build(t, TourKeys());
    // barra → idioma → aspecto → editar inicio → Datos → base de cartas →
    // copia de seguridad → La app → cómo funciona → versión
    expect(pasos.first.navBarIndex, isNotNull);
    expect(pasos.length, 10);
    expect(pasos.map((s) => s.prepare).toList().sublist(4), [
      TourPrep.ajustesDatos,
      TourPrep.ajustesDatos,
      TourPrep.ajustesDatos,
      TourPrep.ajustesLaApp,
      TourPrep.ajustesLaApp,
      TourPrep.ajustesLaApp,
    ]);
    expect(pasos.last.targetKey, isNotNull);
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
