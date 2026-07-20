/// Tests del gate de confianza: dados los candidatos del matching, decide si
/// hay un ganador CLARO (mostrar UNA carta) o si hay duda (mostrar la lista).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/services/scanner_database.dart';

ScanMatch _m(String oracle, int distance, {String name = 'X'}) => ScanMatch(
      HashEntry(
          scryfallId: '$oracle-$distance',
          oracleId: oracle,
          name: name,
          setCode: 'tst',
          collectorNumber: '1'),
      distance,
    );

void main() {
  test('ganador con margen claro → confident, best es el primero', () {
    // d1 mucho más cerca que el siguiente candidato distinto
    final d = decideScan([_m('o1', 8, name: 'Bolt'), _m('o2', 30)]);
    expect(d.confidence, ScanConfidence.confident);
    expect(d.best!.entry.name, 'Bolt');
  });

  test('el caso de la captura (media + baja) es confident', () {
    // top-1 "media" (18) contra "baja" (31): margen 13 → un solo resultado
    final d = decideScan([_m('o1', 18), _m('o2', 31)]);
    expect(d.confidence, ScanConfidence.confident);
  });

  test('dos candidatos casi empatados → ambiguous (pedir a mano)', () {
    // d1 pequeñísimo pero el siguiente está igual de cerca: podría ser cualquiera
    final d = decideScan([_m('o1', 8), _m('o2', 10)]);
    expect(d.confidence, ScanConfidence.ambiguous);
  });

  test('mejor candidato demasiado lejos → none', () {
    final d = decideScan([_m('o1', 45), _m('o2', 60)]);
    expect(d.confidence, ScanConfidence.none);
    expect(d.best, isNull);
  });

  test('sin candidatos → none', () {
    final d = decideScan(const []);
    expect(d.confidence, ScanConfidence.none);
    expect(d.best, isNull);
  });

  test('un único candidato cercano → confident (no hay rival)', () {
    final d = decideScan([_m('o1', 6)]);
    expect(d.confidence, ScanConfidence.confident);
  });

  test('plausible pero sin margen (baja, <umbral no-match) → ambiguous', () {
    // 32 no es "alta" ni "media", pero está dentro de lo escaneable: lista
    final d = decideScan([_m('o1', 32), _m('o2', 40)]);
    expect(d.confidence, ScanConfidence.ambiguous);
  });

  test('none conserva los candidatos (por si el llamador los quiere)', () {
    final d = decideScan([_m('o1', 45)]);
    expect(d.confidence, ScanConfidence.none);
    expect(d.candidates, hasLength(1));
  });
}
