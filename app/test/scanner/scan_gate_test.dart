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

  group('decideLiveScan (frame de cámara, no foto elegida)', () {
    test('sin carta detectada NO reconoce, por muy cerca que quede algo', () {
      // el detector no encontró contorno y hasheó el encuadre entero: eso
      // es la mesa. Antes entraba a la bandeja como carta inventada.
      final d = decideLiveScan([_m('o1', 6)], cardDetected: false);
      expect(d.confidence, ScanConfidence.none);
      expect(d.best, isNull);
    });

    test('carta detectada y match claro → confident', () {
      final d = decideLiveScan([_m('o1', 8), _m('o2', 30)],
          cardDetected: true);
      expect(d.confidence, ScanConfidence.confident);
    });

    test('ambigua en zona de error (≥28) NO reconoce aunque haya contorno',
        () {
      // las distancias de los falsos positivos reales caen en 28-34
      final d = decideLiveScan([_m('o1', 30), _m('o2', 33)],
          cardDetected: true);
      expect(d.confidence, ScanConfidence.none);
    });

    test('ambigua pero creíble (<28) sigue reconociéndose para revisar', () {
      final d = decideLiveScan([_m('o1', 20), _m('o2', 24)],
          cardDetected: true);
      expect(d.confidence, ScanConfidence.ambiguous);
      expect(d.best?.entry.oracleId, 'o1');
    });

    test('un recorte liso (mesa, servilleta) NO es carta aunque el detector '
        'haya encontrado un rectángulo y case cerca', () {
      // caso REAL de Ale: un pliegue de servilleta pasaba por carta y
      // casaba a 25 bits; su ventana de arte tiene detalle ~6, las cartas
      // reales 17-57
      final d = decideLiveScan([_m('o1', 25), _m('o2', 34)],
          cardDetected: true, artDetail: 6.1);
      expect(d.confidence, ScanConfidence.none);
    });

    test('una carta poco contrastada pero con arte de verdad sí pasa', () {
      final d = decideLiveScan([_m('o1', 10), _m('o2', 30)],
          cardDetected: true, artDetail: 17.3);
      expect(d.confidence, ScanConfidence.confident);
    });

    test('sin candidatos y sin carta: none, sin reventar', () {
      expect(decideLiveScan(const [], cardDetected: false).confidence,
          ScanConfidence.none);
      expect(decideLiveScan(const [], cardDetected: true).confidence,
          ScanConfidence.none);
    });
  });
}
