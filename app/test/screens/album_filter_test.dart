/// Buscar dentro de un álbum de expansión. Un set de 300 cartas no se recorre
/// a ojo para comprobar si tienes UNA.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/album_screen.dart';
import 'package:manaforge_app/services/card_database.dart';

AlbumCard _card(String name,
        {String number = '1', String? printed, String colors = 'W'}) =>
    AlbumCard(
      oracleId: name.toLowerCase().replaceAll(' ', '-'),
      collectorNumber: number,
      name: name,
      printedName: printed,
      colors: colors,
    );

final _set = [
  _card('Serra Angel', number: '3', printed: 'Ángel de Serra'),
  _card('Shock', number: '117', colors: 'R'),
  _card('Shipwreck Moray', number: '72', colors: 'U'),
  _card('Island', number: '250', colors: ''),
];

int _tengo(AlbumCard c) => c.name == 'Shock' ? 0 : 2;

void main() {
  test('sin buscar nada salen todas', () {
    expect(filterAlbumCards(_set, qtyOf: _tengo).length, 4);
  });

  test('busca por trozo del nombre, sin importar mayúsculas', () {
    final r = filterAlbumCards(_set, query: 'ship', qtyOf: _tengo);

    expect(r.single.name, 'Shipwreck Moray');
  });

  test('busca también por el nombre impreso (carta en otro idioma)', () {
    final r = filterAlbumCards(_set, query: 'ángel', qtyOf: _tengo);

    expect(r.single.name, 'Serra Angel');
  });

  test('busca por número de coleccionista exacto', () {
    final r = filterAlbumCards(_set, query: '72', qtyOf: _tengo);

    expect(r.single.name, 'Shipwreck Moray');
    // exacto: "7" no puede sacar la 72, o buscar un número no sirve de nada
    expect(filterAlbumCards(_set, query: '7', qtyOf: _tengo), isEmpty);
  });

  test('los espacios de más no cuentan', () {
    expect(
        filterAlbumCards(_set, query: '  shock  ', qtyOf: _tengo).single.name,
        'Shock');
  });

  test('"solo las que faltan" deja las que no tienes', () {
    final r = filterAlbumCards(_set, onlyMissing: true, qtyOf: _tengo);

    expect(r.single.name, 'Shock');
  });

  test('buscar y "solo las que faltan" se combinan', () {
    expect(
        filterAlbumCards(_set,
            query: 'sh', onlyMissing: true, qtyOf: _tengo),
        hasLength(1));
    expect(
        filterAlbumCards(_set,
            query: 'island', onlyMissing: true, qtyOf: _tengo),
        isEmpty);
  });

  test('el orden del set se respeta: el álbum va por número', () {
    final r = filterAlbumCards(_set, query: 's', qtyOf: _tengo);

    expect(r.map((c) => c.name),
        ['Serra Angel', 'Shock', 'Shipwreck Moray', 'Island']);
  });
}
