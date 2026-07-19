/// Tests del modo ráfaga del escaneo en vivo (BurstController).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/burst_controller.dart';
import 'package:manaforge_app/services/scanner_database.dart';

List<ScanMatch> _frame(String oracle, int distance) => [
      ScanMatch(
          HashEntry(
              scryfallId: 'sf-$oracle',
              oracleId: oracle,
              name: 'Carta $oracle',
              setCode: 'tst',
              collectorNumber: '1'),
          distance),
    ];

void main() {
  test('reconoce tras N frames estables con la misma carta', () {
    final c = BurstController(stableFrames: 2);
    expect(c.feed(_frame('bolt', 5)), isNull); // 1º frame: aún no
    final rec = c.feed(_frame('bolt', 6)); // 2º frame: reconocida
    expect(rec, isNotNull);
    expect(rec!.best.entry.oracleId, 'bolt');
  });

  test('frames lejanos (ruido, mesa vacía) no cuentan', () {
    final c = BurstController(stableFrames: 2, maxDistance: 24);
    expect(c.feed(_frame('bolt', 60)), isNull);
    expect(c.feed(_frame('bolt', 60)), isNull);
    expect(c.feed(const []), isNull);
  });

  test('cambiar de carta a medias reinicia la racha', () {
    final c = BurstController(stableFrames: 2);
    expect(c.feed(_frame('bolt', 5)), isNull);
    expect(c.feed(_frame('shock', 5)), isNull); // racha rota
    expect(c.feed(_frame('shock', 5)), isNotNull); // 2 de shock seguidos
  });

  test('la misma carta quieta NO se añade dos veces (bloqueo)', () {
    final c = BurstController(stableFrames: 2, gapFrames: 3);
    c.feed(_frame('bolt', 5));
    expect(c.feed(_frame('bolt', 5)), isNotNull); // reconocida
    // sigue delante de la cámara: nada de duplicados
    for (var i = 0; i < 10; i++) {
      expect(c.feed(_frame('bolt', 5)), isNull);
    }
  });

  test('tras el gap (mesa vacía) la misma carta se puede volver a escanear',
      () {
    final c = BurstController(stableFrames: 2, gapFrames: 3);
    c.feed(_frame('bolt', 5));
    expect(c.feed(_frame('bolt', 5)), isNotNull); // 1ª copia
    // retiras la carta: 3 frames sin verla
    c.feed(const []);
    c.feed(const []);
    c.feed(const []);
    // la vuelves a poner (2ª copia)
    c.feed(_frame('bolt', 5));
    expect(c.feed(_frame('bolt', 5)), isNotNull);
  });

  test('modo ráfaga: varias cartas seguidas sin tocar nada', () {
    final c = BurstController(stableFrames: 2, gapFrames: 2);
    final added = <String>[];
    final secuencia = [
      _frame('bolt', 5), _frame('bolt', 5), // bolt
      const <ScanMatch>[], // transición
      _frame('shock', 8), _frame('shock', 8), // shock
      const <ScanMatch>[], const <ScanMatch>[],
      _frame('bolt', 5), _frame('bolt', 5), // bolt otra vez (2ª copia)
    ];
    for (final f in secuencia) {
      final rec = c.feed(f);
      if (rec != null) added.add(rec.best.entry.oracleId);
    }
    expect(added, ['bolt', 'shock', 'bolt']);
  });

  test('reset olvida el bloqueo y las rachas', () {
    final c = BurstController(stableFrames: 2);
    c.feed(_frame('bolt', 5));
    c.feed(_frame('bolt', 5));
    c.reset();
    c.feed(_frame('bolt', 5));
    expect(c.feed(_frame('bolt', 5)), isNotNull); // como si fuera nueva
  });
}
