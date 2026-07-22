/// Cuando dos ediciones llevan el MISMO arte, sus huellas son idénticas y el
/// escáner no puede distinguirlas mirando la ilustración: hay empate. Hasta
/// ahora ganaba la que estuviera antes en la base, que es como decir "al
/// azar" — así entró un Aether Revolt como Kaladesh Remastered.
///
/// Medido con fotos reales de Ale (22-07-2026): los tres fallos de edición
/// eran empates exactos (19/19, 16/16, 12/12). Ninguno necesitaba leer el
/// número de coleccionista.
library;

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';

HashIndex _index(List<(String set, String num, int hash)> defs,
    {String oracle = 'la-carta'}) {
  final hh = Int64List(defs.length);
  final vv = Int64List(defs.length);
  final entries = <HashEntry>[];
  for (var i = 0; i < defs.length; i++) {
    final (set, num, hash) = defs[i];
    hh[i] = hash;
    vv[i] = hash;
    entries.add(HashEntry(
      scryfallId: '$set-$num',
      oracleId: oracle,
      name: 'Carta de prueba',
      setCode: set,
      collectorNumber: num,
    ));
  }
  return HashIndex(hh, vv, entries);
}

const _sig = [DHashPair(0, 0)];

void main() {
  test('empatadas, gana la edición que YA tienes', () {
    final index = _index([
      ('mh3', '12', 0),
      ('aer', '191', 0),
    ]);

    final m = index.topMatches(_sig, ownedPrintings: {'aer|191'});

    expect(m.single.entry.setCode, 'aer');
  });

  test('empatadas y sin tener ninguna, gana la de número normal', () {
    // The List numera "AER-191"; los promos, "2023-6" o "113p". Un número a
    // secas es la edición corriente, que es la que casi siempre tienes.
    final index = _index([
      ('plst', 'AER-191', 0),
      ('aer', '191', 0),
    ]);

    expect(index.topMatches(_sig).single.entry.setCode, 'aer');
  });

  test('tener la rara manda sobre el número normal', () {
    final index = _index([
      ('plst', 'AER-191', 0),
      ('aer', '191', 0),
    ]);

    final m = index.topMatches(_sig, ownedPrintings: {'plst|AER-191'});

    expect(m.single.entry.setCode, 'plst',
        reason: 'si la tienes, es que la tienes');
  });

  test('el desempate NO se salta una edición que casa mejor', () {
    final index = _index([
      ('aer', '191', 0), // casa perfecto
      ('plst', 'AER-191', 8), // peor, aunque sea la que tienes
    ]);

    final m = index.topMatches(_sig, ownedPrintings: {'plst|AER-191'});

    expect(m.single.entry.setCode, 'aer',
        reason: 'el arte manda; el desempate solo entra en empate exacto');
  });

  test('sin nada que desempatar, el resultado no depende del orden', () {
    final a = _index([('zen', '20', 0), ('aer', '191', 0)]);
    final b = _index([('aer', '191', 0), ('zen', '20', 0)]);

    expect(a.topMatches(_sig).single.entry.setCode,
        b.topMatches(_sig).single.entry.setCode,
        reason: 'mismo empate, misma respuesta: nada de orden de la base');
  });
}
