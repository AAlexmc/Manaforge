// Filtros del álbum: lógica pura (letra inicial, año de lanzamiento,
// búsqueda, "con cartas mías") y ordenaciones, separada de la UI.
import 'package:flutter_test/flutter_test.dart';

import 'package:manaforge_app/ui/collection/album_filters.dart';
import 'package:manaforge_app/data/services/card_database.dart';

const sets = [
  SetInfo(
      code: 'aer', name: 'Aether Revolt', total: 100,
      releasedAt: '2017-01-20'),
  SetInfo(
      code: 'thb', name: 'Theros Beyond Death', total: 50,
      releasedAt: '2020-01-24'),
  SetInfo(
      code: 'uma', name: 'Ultimate Masters', total: 30,
      releasedAt: '2018-12-07'),
  SetInfo(
      code: 'tsr', name: 'Time Spiral Remastered', total: 40,
      releasedAt: '2021-03-19'),
  SetInfo(code: '2x2', name: '2X2 Double Masters', total: 20),
];

void main() {
  group('setInitial', () {
    test('letra A-Z en mayúscula, resto al cajón #', () {
      expect(setInitial('Aether Revolt'), 'A');
      expect(setInitial('theros'), 'T');
      expect(setInitial('2X2 Double Masters'), '#');
      expect(setInitial(''), '#');
    });
  });

  group('availableYears', () {
    test('años distintos, descendentes, sin nulos', () {
      expect(availableYears(sets), ['2021', '2020', '2018', '2017']);
    });
  });

  group('filterAlbumSets', () {
    test('por letra inicial', () {
      final out = filterAlbumSets(sets, letter: 'T');
      expect(out.map((s) => s.code),
          containsAll(['thb', 'tsr']));
      expect(out, hasLength(2));
    });

    test('cajón # agrupa los que no empiezan por letra', () {
      final out = filterAlbumSets(sets, letter: '#');
      expect(out.single.code, '2x2');
    });

    test('por año de lanzamiento', () {
      final out = filterAlbumSets(sets, year: '2018');
      expect(out.single.code, 'uma');
    });

    test('letra + año se combinan con búsqueda y "míos"', () {
      final out = filterAlbumSets(sets,
          letter: 'T',
          year: '2020',
          query: 'theros',
          onlyMine: true,
          owned: {'thb': 3});
      expect(out.single.code, 'thb');
      // mismo filtro pero sin cartas de ese set → fuera
      expect(
          filterAlbumSets(sets,
              letter: 'T', year: '2020', onlyMine: true, owned: {}),
          isEmpty);
    });

    test('orden "fecha" (más nuevas): descendente, sin fecha al final', () {
      final out = filterAlbumSets(sets, sort: 'fecha');
      expect(out.map((s) => s.code).toList(),
          ['tsr', 'thb', 'uma', 'aer', '2x2']);
    });

    test('orden "antiguas": ascendente, sin fecha al final', () {
      final out = filterAlbumSets(sets, sort: 'antiguas');
      expect(out.map((s) => s.code).toList(),
          ['aer', 'uma', 'thb', 'tsr', '2x2']);
    });

    test('orden "nombre": alfabético', () {
      final out = filterAlbumSets(sets, sort: 'nombre');
      expect(out.first.code, '2x2');
      expect(out.last.code, 'uma');
    });

    test('orden "progreso": más completadas primero', () {
      final out = filterAlbumSets(sets,
          sort: 'progreso', owned: {'uma': 30, 'aer': 10});
      expect(out.first.code, 'uma'); // 30/30 completa
      expect(out[1].code, 'aer'); // 10/100
    });
  });
}
