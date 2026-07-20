/// Tests del índice de huellas en memoria (matching por Hamming, top-3).
library;

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/services/scanner_database.dart';

HashEntry _entry(String id, String oracle, String name,
        {String set = 'tst', String num = '1'}) =>
    HashEntry(
        scryfallId: id,
        oracleId: oracle,
        name: name,
        setCode: set,
        collectorNumber: num);

void main() {
  test('topMatches ordena por distancia y devuelve k candidatos', () {
    final index = HashIndex(
      Int64List.fromList([0, 0xFF, -1, 0x0F]),
      Int64List.fromList([0, 0, -1, 0]),
      [
        _entry('a', 'o1', 'Exacta'),
        _entry('b', 'o2', 'Cerca'), // 8 bits
        _entry('c', 'o3', 'Lejos'), // 128 bits
        _entry('d', 'o4', 'MuyCerca'), // 4 bits
      ],
    );
    final matches = index.topMatches(const [DHashPair(0, 0)], k: 3);

    expect(matches, hasLength(3));
    expect(matches[0].entry.name, 'Exacta');
    expect(matches[0].distance, 0);
    expect(matches[1].entry.name, 'MuyCerca');
    expect(matches[1].distance, 4);
    expect(matches[2].entry.name, 'Cerca');
    expect(matches[2].distance, 8);
  });

  test('reimpresiones de la MISMA carta no se comen el top-3', () {
    // la misma ilustración (mismo oracle) impresa en 3 sets con huellas
    // idénticas + otra carta algo más lejos: el top debe traer LAS DOS
    final index = HashIndex(
      Int64List.fromList([0, 0, 0, 0xFFFF]),
      Int64List.fromList([0, 0, 0, 0]),
      [
        _entry('a1', 'o1', 'Bolt', set: 'lea'),
        _entry('a2', 'o1', 'Bolt', set: 'm10'),
        _entry('a3', 'o1', 'Bolt', set: 'sta'),
        _entry('b', 'o2', 'Shock'),
      ],
    );
    final matches = index.topMatches(const [DHashPair(0, 0)], k: 3);

    expect(matches, hasLength(2)); // solo 2 cartas distintas
    expect(matches[0].entry.name, 'Bolt');
    expect(matches[1].entry.name, 'Shock');
  });

  test('para cada carta gana su impresión más parecida (printingKey exacta)',
      () {
    final index = HashIndex(
      Int64List.fromList([0xFF, 0]),
      Int64List.fromList([0, 0]),
      [
        _entry('viejo', 'o1', 'Bolt', set: 'lea', num: '161'),
        _entry('nuevo', 'o1', 'Bolt', set: 'sta', num: '42'),
      ],
    );
    final matches = index.topMatches(const [DHashPair(0, 0)], k: 1);

    expect(matches.single.entry.scryfallId, 'nuevo');
    expect(matches.single.entry.printingKey, 'sta|42');
  });

  test('las huellas firmadas de SQLite se comparan tal cual (sin conversión)',
      () {
    // -3727796709607303722 es la huella real de ruido_97x64.png: el XOR y
    // el popcount funcionan directamente sobre el entero firmado
    const stored = -3727796709607303722;
    final index = HashIndex(
      Int64List.fromList([stored]),
      Int64List.fromList([0]),
      [_entry('x', 'o', 'Real')],
    );
    final exact = index.topMatches(const [DHashPair(stored, 0)], k: 1);
    expect(exact.single.distance, 0);

    // a un bit de distancia
    final oneOff =
        index.topMatches([DHashPair(stored ^ (1 << 63), 0)], k: 1);
    expect(oneOff.single.distance, 1);
  });

  test('multi-firma: cuenta la MEJOR variante para cada candidato', () {
    final index = HashIndex(
      Int64List.fromList([0xFF, 0xF0F0]),
      Int64List.fromList([0, 0]),
      [
        _entry('a', 'o1', 'Bolt'),
        _entry('b', 'o2', 'Shock'),
      ],
    );
    // variante central lejos de todo; una variante desplazada clava a Bolt
    final matches = index.topMatches(
        const [DHashPair(0, 0), DHashPair(0xFF, 0)], k: 2);

    expect(matches[0].entry.name, 'Bolt');
    expect(matches[0].distance, 0); // gracias a la 2ª variante
    expect(matches[1].entry.name, 'Shock');
  });

  test('artSignatures: 75 variantes y la primera es la central', () {
    // carta rectificada sintética con degradado (firma no trivial)
    const w = 480, h = 670;
    final rgb = Uint8List(w * h * 3);
    var i = 0;
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        rgb[i++] = (x * 255 ~/ (w - 1));
        rgb[i++] = (y * 255 ~/ (h - 1));
        rgb[i++] = ((x + y) % 251);
      }
    }
    final sigs = artSignatures(rgb, w, h);
    expect(sigs, hasLength(75));

    // la primera firma debe ser EXACTAMENTE la del recorte central del arte
    final grey = Uint8List(w * h);
    for (var p = 0, j = 0; p < grey.length; p++, j += 3) {
      grey[p] = rgbToL(rgb[j], rgb[j + 1], rgb[j + 2]);
    }
    final x0 = (0.077 * w).round(), x1 = (0.923 * w).round();
    final y0 = (0.117 * h).round(), y1 = (0.545 * h).round();
    final cw = x1 - x0, ch = y1 - y0;
    final crop = Uint8List(cw * ch);
    for (var y = 0; y < ch; y++) {
      crop.setRange(y * cw, (y + 1) * cw, grey, (y0 + y) * w + x0);
    }
    final center = dhashPairFromGrey(crop, cw, ch);
    expect(sigs.first.h, center.h);
    expect(sigs.first.v, center.v);
  });

  group('set-lock (bloquear edición)', () {
    HashIndex build() => HashIndex(
          Int64List.fromList([0, 0, 0xFFFF]),
          Int64List.fromList([0, 0, 0]),
          [
            _entry('a', 'o1', 'Bolt', set: 'aer', num: '1'),
            _entry('b', 'o2', 'Shock', set: 'm10', num: '2'),
            _entry('c', 'o3', 'Otra', set: 'aer', num: '3'), // lejos
          ],
        );

    test('sin lock: salen candidatos de cualquier set', () {
      final m = build().topMatches(const [DHashPair(0, 0)], k: 3);
      final sets = m.map((x) => x.entry.setCode).toSet();
      expect(sets, containsAll(['aer', 'm10']));
    });

    test('lockSet filtra a solo ese set', () {
      final m =
          build().topMatches(const [DHashPair(0, 0)], k: 3, lockSet: 'm10');
      expect(m, hasLength(1));
      expect(m.single.entry.setCode, 'm10');
      expect(m.single.entry.name, 'Shock');
    });

    test('lockSet es insensible a mayúsculas', () {
      final m =
          build().topMatches(const [DHashPair(0, 0)], k: 3, lockSet: 'AER');
      expect(m.every((x) => x.entry.setCode == 'aer'), isTrue);
      expect(m.first.entry.name, 'Bolt'); // el cercano gana al lejano
    });
  });
}
