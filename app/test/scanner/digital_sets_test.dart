/// El escáner mira cartón: una edición que solo existe en Arena o en Magic
/// Online NUNCA puede ser la carta que hay sobre la mesa.
///
/// Y compiten de verdad: la reimpresión digital suele llevar el MISMO arte,
/// así que su huella es idéntica y puede ganar el desempate. Es lo que metió
/// un "Implement of Examination" de Aether Revolt en la colección como
/// Kaladesh Remastered, un set de Arena que no existe en papel.
library;

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/digital_sets.dart';
import 'package:manaforge_app/scanner/hash_index.dart';

HashIndex _index(List<(String set, String num, String oracle, int hash)> defs) {
  final hh = Int64List(defs.length);
  final vv = Int64List(defs.length);
  final entries = <HashEntry>[];
  for (var i = 0; i < defs.length; i++) {
    final (set, num, oracle, hash) = defs[i];
    hh[i] = hash;
    vv[i] = hash;
    entries.add(HashEntry(
      scryfallId: '$set-$num',
      oracleId: oracle,
      name: 'Implement of Examination',
      setCode: set,
      collectorNumber: num,
    ));
  }
  return HashIndex(hh, vv, entries);
}

const _sig = [DHashPair(0, 0)];

void main() {
  test('la lista sabe quién es digital y quién no', () {
    expect(isDigitalOnlySet('klr'), isTrue);
    expect(isDigitalOnlySet('KLR'), isTrue, reason: 'da igual la caja');
    expect(isDigitalOnlySet('prm'), isTrue, reason: 'promos de Magic Online');
    expect(isDigitalOnlySet('aer'), isFalse);
    expect(isDigitalOnlySet(''), isFalse);
  });

  test('con arte idéntico gana la de papel, no la de Arena', () {
    // la digital va PRIMERA a propósito: antes ganaba por orden de recorrido
    final index = _index([
      ('klr', '244', 'implement', 0),
      ('aer', '156', 'implement', 0),
    ]);

    final m = index.topMatches(_sig);

    expect(m.single.entry.setCode, 'aer');
    expect(m.single.entry.collectorNumber, '156');
  });

  test('una carta que SOLO existe en digital no se propone jamás', () {
    final index = _index([
      ('klr', '244', 'solo-digital', 0),
    ]);

    expect(index.topMatches(_sig), isEmpty,
        reason: 'no hay carta física posible: mejor nada que una mentira');
  });

  test('la de papel gana aunque case PEOR que la digital', () {
    // el arte digital puede estar más limpio y casar mejor; da igual, no
    // existe en cartón
    final index = _index([
      ('klr', '244', 'implement', 0), // distancia 0
      ('aer', '156', 'implement', 3), // distancia peor
    ]);

    final m = index.topMatches(_sig);

    expect(m.single.entry.setCode, 'aer');
  });

  test('bloquear un set digital no resucita esas cartas', () {
    final index = _index([
      ('klr', '244', 'implement', 0),
      ('aer', '156', 'implement', 0),
    ]);

    expect(index.topMatches(_sig, lockSet: 'klr'), isEmpty);
  });
}
