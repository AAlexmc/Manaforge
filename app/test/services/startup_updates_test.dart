/// Tests de las reglas de puesta al día del arranque.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/services/startup_updates.dart';

void main() {
  final hoy = DateTime(2026, 7, 21, 13, 40);

  test('sin fecha = no está descargada', () {
    expect(updateNeed(null, maxAgeDays: 1, now: hoy), UpdateNeed.missing);
    expect(updateNeed('', maxAgeDays: 1, now: hoy), UpdateNeed.missing);
  });

  test('construida hoy está al día', () {
    expect(updateNeed('2026-07-21', maxAgeDays: 1, now: hoy),
        UpdateNeed.fresh);
  });

  test('la de ayer se refresca con el límite de un día', () {
    expect(updateNeed('2026-07-20', maxAgeDays: kCardsMaxAgeDays, now: hoy),
        UpdateNeed.stale);
  });

  test('el histórico aguanta una semana', () {
    expect(updateNeed('2026-07-16', maxAgeDays: kPricesMaxAgeDays, now: hoy),
        UpdateNeed.fresh);
    expect(updateNeed('2026-07-14', maxAgeDays: kPricesMaxAgeDays, now: hoy),
        UpdateNeed.stale);
  });

  test('las huellas del escáner aguantan tres semanas', () {
    expect(updateNeed('2026-07-05', maxAgeDays: kHashesMaxAgeDays, now: hoy),
        UpdateNeed.fresh);
    expect(updateNeed('2026-06-25', maxAgeDays: kHashesMaxAgeDays, now: hoy),
        UpdateNeed.stale);
  });

  test('la comparación va por día: la hora no cambia el veredicto', () {
    final manana = DateTime(2026, 7, 21, 8);
    final noche = DateTime(2026, 7, 21, 23, 59);
    expect(updateNeed('2026-07-20', maxAgeDays: 1, now: manana),
        updateNeed('2026-07-20', maxAgeDays: 1, now: noche));
  });

  test('una fecha ilegible se refresca en vez de darla por buena', () {
    expect(updateNeed('vete a saber', maxAgeDays: 1, now: hoy),
        UpdateNeed.stale);
  });

  test('una base del futuro (reloj torcido) no se descarga en bucle', () {
    expect(updateNeed('2026-07-25', maxAgeDays: 1, now: hoy),
        UpdateNeed.fresh);
  });

  group('no re-descargar en cada arranque', () {
    // el bulk de Scryfall se publica con la fecha de la víspera: su
    // contenido NUNCA es "de hoy", así que sin mirar cuándo se trajo la
    // copia local la app se bajaría 22 MB cada vez que la abres
    test('contenido viejo pero traído hoy: no se toca', () {
      expect(
          updateNeed('2026-07-20',
              maxAgeDays: 1, now: hoy, downloadedAt: hoy),
          UpdateNeed.fresh);
    });

    test('contenido viejo y traído hace días: se refresca', () {
      expect(
          updateNeed('2026-07-20',
              maxAgeDays: 1,
              now: hoy,
              downloadedAt: DateTime(2026, 7, 19)),
          UpdateNeed.stale);
    });

    test('sin saber cuándo se trajo, manda la fecha del contenido', () {
      expect(updateNeed('2026-07-20', maxAgeDays: 1, now: hoy),
          UpdateNeed.stale);
    });

    test('base presente pero SIN fecha legible (esquema viejo): manda '
        'cuándo se trajo, no se re-descarga en bucle', () {
      expect(updateNeed(null, maxAgeDays: 1, now: hoy, downloadedAt: hoy),
          UpdateNeed.fresh);
      expect(
          updateNeed(null,
              maxAgeDays: 1,
              now: hoy,
              downloadedAt: DateTime(2026, 7, 1)),
          UpdateNeed.stale);
    });

    test('sin fichero y sin fecha: falta', () {
      expect(updateNeed(null, maxAgeDays: 1, now: hoy), UpdateNeed.missing);
    });

    test('un mtime en el FUTURO no congela la base para siempre', () {
      expect(
          updateNeed('2020-01-01',
              maxAgeDays: 1,
              now: hoy,
              downloadedAt: DateTime(2027, 1, 1)),
          UpdateNeed.stale);
    });
  });
}
