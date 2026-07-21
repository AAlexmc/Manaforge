/// Tests de la bandeja de la sesión de escaneo en vivo: agrupa copias
/// iguales en una línea con cantidad (×N), como ManaBox.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/burst_controller.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/services/scanner_database.dart';

ScanMatch _m(String oracle, {String set = 'tst', String num = '1'}) => ScanMatch(
    HashEntry(
        scryfallId: '$oracle-$set-$num',
        oracleId: oracle,
        name: 'Carta $oracle',
        setCode: set,
        collectorNumber: num),
    5);

Recognition _rec(String oracle,
        {String set = 'tst',
        String num = '1',
        ScanConfidence conf = ScanConfidence.confident}) =>
    Recognition([_m(oracle, set: set, num: num)], conf);

void main() {
  test('carta nueva → una línea, cantidad 1', () {
    final tray = ScanTray();
    tray.add(_rec('bolt'));
    expect(tray.lines, hasLength(1));
    expect(tray.totalQty, 1);
    expect(tray.lines.first.qty, 1);
  });

  test('misma impresión varias veces → una línea con ×N', () {
    final tray = ScanTray();
    tray.add(_rec('bolt'));
    tray.add(_rec('bolt'));
    tray.add(_rec('bolt'));
    expect(tray.lines, hasLength(1));
    expect(tray.lines.first.qty, 3);
    expect(tray.totalQty, 3);
  });

  test('impresiones distintas de la misma carta NO se agrupan', () {
    // mismo oracle, distinto set/número = impresión distinta (valor distinto)
    final tray = ScanTray();
    tray.add(_rec('bolt', set: 'lea', num: '161'));
    tray.add(_rec('bolt', set: 'm10', num: '146'));
    expect(tray.lines, hasLength(2));
    expect(tray.totalQty, 2);
  });

  test('cartas distintas → líneas distintas', () {
    final tray = ScanTray();
    tray.add(_rec('bolt'));
    tray.add(_rec('shock'));
    expect(tray.lines, hasLength(2));
  });

  test('add devuelve la línea afectada (para el feedback visual)', () {
    final tray = ScanTray();
    final a = tray.add(_rec('bolt'));
    final b = tray.add(_rec('bolt'));
    expect(identical(a, b), isTrue); // misma línea, incrementada
    expect(b.qty, 2);
  });

  test('una reconocida ambigua marca la línea para revisar', () {
    final tray = ScanTray();
    final line = tray.add(_rec('bolt', conf: ScanConfidence.ambiguous));
    expect(line.needsReview, isTrue);
  });

  test('tras marcarla revisada, la línea ambigua deja de pedir revisión', () {
    final tray = ScanTray();
    final line = tray.add(_rec('bolt', conf: ScanConfidence.ambiguous));
    line.reviewed = true;
    expect(line.needsReview, isFalse);
  });

  test('setQty a 0 elimina la línea', () {
    final tray = ScanTray();
    final line = tray.add(_rec('bolt'));
    tray.setQty(line, 0);
    expect(tray.lines, isEmpty);
  });

  test('setQty cambia la cantidad', () {
    final tray = ScanTray();
    final line = tray.add(_rec('bolt'));
    tray.setQty(line, 4);
    expect(line.qty, 4);
    expect(tray.totalQty, 4);
  });

  test('remove quita la línea', () {
    final tray = ScanTray();
    final line = tray.add(_rec('bolt'));
    tray.remove(line);
    expect(tray.lines, isEmpty);
  });

  test('clear vacía la bandeja', () {
    final tray = ScanTray();
    tray.add(_rec('bolt'));
    tray.add(_rec('shock'));
    tray.clear();
    expect(tray.lines, isEmpty);
    expect(tray.totalQty, 0);
  });

  group('buildBatchTray (varias fotos → bandeja)', () {
    List<ScanMatch> _far() =>
        [_md('x', 99), _md('y', 100)]; // nada reconocible → none

    test('agrupa fotos de la misma carta; la no reconocida entra como '
        'línea "sin reconocer" que no suma al total', () {
      final tray = buildBatchTray([
        ([_md('bolt', 8), _md('shock', 30)], null), // bolt, confident
        (_far(), null), // no reconocida → línea sin reconocer
        ([_md('bolt', 9), _md('shock', 31)], null), // bolt otra vez → ×2
        ([_md('sol', 6)], null), // otra carta, confident
      ]);
      expect(tray.lines, hasLength(3));
      expect(tray.totalQty, 3); // la sin reconocer NO cuenta
      final bolt = tray.lines
          .firstWhere((l) => !l.unrecognized && l.chosen.entry.oracleId == 'bolt');
      expect(bolt.qty, 2);
      expect(tray.lines.where((l) => l.unrecognized), hasLength(1));
    });

    test('una foto dudosa con top-1 creíble entra marcada para revisar', () {
      final tray = buildBatchTray([
        ([_md('bolt', 20), _md('shock', 24)], null), // margen 4 → ambiguous
      ]);
      expect(tray.lines.single.needsReview, isTrue);
      expect(tray.lines.single.unrecognized, isFalse);
    });

    test('ambigua con top-1 en zona de error (≥ kUntrustedMin) NO propone '
        'carta: sale "sin reconocer" con sus apuestas para elegir a mano', () {
      final tray = buildBatchTray([
        ([_md('plains', 30), _md('island', 32)], null), // basura típica
      ]);
      final line = tray.lines.single;
      expect(line.unrecognized, isTrue);
      expect(line.candidates, isNotEmpty); // apuestas para el picker manual
      expect(tray.totalQty, 0);
    });

    test('una carta buena NO se agrupa dentro de una línea sin reconocer '
        'aunque compartan top-1', () {
      // la celda dudosa tiene 'bolt' como top-1 basura (dist 30); una foto
      // posterior reconoce bolt de verdad: debe salir en su PROPIA línea,
      // no sumarse a la que no se añade a la colección
      final tray = buildBatchTray([
        ([_md('bolt', 30), _md('shock', 32)], null), // sin reconocer
        ([_md('bolt', 8), _md('shock', 30)], null), // bolt de verdad
      ]);
      expect(tray.lines, hasLength(2));
      expect(tray.lines.first.unrecognized, isTrue);
      expect(tray.lines.first.qty, 1);
      expect(tray.lines.last.unrecognized, isFalse);
      expect(tray.totalQty, 1); // solo la buena
    });

    test('elegir a mano una línea sin reconocer la convierte en normal', () {
      final tray = buildBatchTray([
        ([_md('plains', 30), _md('island', 32)], null),
      ]);
      final line = tray.lines.single
        ..selected = 1
        ..reviewed = true
        ..unrecognized = false;
      expect(line.chosen.entry.oracleId, 'island');
      expect(tray.totalQty, 1);
    });
  });
}

ScanMatch _md(String oracle, int distance) => ScanMatch(
    HashEntry(
        scryfallId: '$oracle-$distance',
        oracleId: oracle,
        name: oracle,
        setCode: 'tst',
        collectorNumber: oracle == 'bolt' ? '1' : '2'),
    distance);
