/// "Lo que me falta" del álbum: qué cuenta para el 100 % y cuánto costaría
/// completarlo.
///
/// Contrato acordado: **completo = solo los números base**. Un set moderno
/// trae detrás decenas de variantes (borderless, extended, promos de tienda)
/// que nadie mete en la cuenta de "me falta X"; se ven con un conmutador.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/collection/album_screen.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/services/markets.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';

AlbumCard _c(String number, {double? price, String name = 'Carta'}) =>
    AlbumCard(
      oracleId: '$name-$number',
      collectorNumber: number,
      name: '$name $number',
      colors: 'W',
      price: price,
    );

void main() {
  group('qué es una carta base', () {
    test('la tirada base es la serie seguida desde el 1', () {
      final set = [_c('1'), _c('2'), _c('3'), _c('4')];

      expect(baseSetSize(set), 4);
    });

    test('lo que va detrás del hueco es variante, no base', () {
      // AER: 184 cartas base y luego los promos numerados 185, 190, 191…
      final set = [_c('1'), _c('2'), _c('3'), _c('190'), _c('191')];

      expect(baseSetSize(set), 3);
      expect(isBaseNumber(_c('3'), 3), isTrue);
      expect(isBaseNumber(_c('190'), 3), isFalse);
    });

    test('los números con letra o estrella nunca son base', () {
      final set = [_c('1'), _c('2'), _c('2★'), _c('3'), _c('12p')];

      expect(baseSetSize(set), 3);
      expect(isBaseNumber(_c('2★'), 3), isFalse);
      expect(isBaseNumber(_c('12p'), 3), isFalse);
    });

    test('un set sin el número 1 no rompe nada', () {
      expect(baseSetSize([_c('45'), _c('46')]), 0);
    });
  });

  group('cuánto cuesta lo que falta', () {
    final set = [
      _c('1', price: 0.10),
      _c('2', price: 2.50),
      _c('3', price: null), // sin precio conocido
      _c('4', price: 30.00),
      _c('190', price: 100.00), // variante: fuera de la cuenta base
    ];

    int tengo(AlbumCard c) => c.collectorNumber == '1' ? 2 : 0;

    test('suma solo las que faltan, y solo las base', () {
      final r = missingReport(set, qtyOf: tengo, onlyBase: true);

      expect(r.missing, 3, reason: 'faltan la 2, la 3 y la 4');
      expect(r.total, closeTo(32.50, 0.001));
      expect(r.withoutPrice, 1, reason: 'la 3 no tiene precio conocido');
    });

    test('con las variantes dentro, entra también la cara', () {
      final r = missingReport(set, qtyOf: tengo, onlyBase: false);

      expect(r.missing, 4);
      expect(r.total, closeTo(132.50, 0.001));
    });

    test('un álbum completo cuesta cero y no tiene huecos', () {
      final r = missingReport(set, qtyOf: (_) => 1, onlyBase: true);

      expect(r.missing, 0);
      expect(r.total, 0);
      expect(r.withoutPrice, 0);
    });

    test('sin datos de edición, las tierras básicas no cuentan como hueco',
        () {
      // "tener un Island" no dice qué ilustración tienes, así que en ese modo
      // el álbum nunca las marca: contarlas sería inventarse una deuda de 20
      // tierras por set
      final conTierra = [
        _c('1', price: 1),
        AlbumCard(
            oracleId: 'island',
            collectorNumber: '2',
            name: 'Island',
            colors: '',
            typeLine: 'Basic Land — Island',
            price: 0.05),
      ];

      final r = missingReport(conTierra,
          qtyOf: (_) => 0, onlyBase: true, countBasicLands: false);

      expect(r.missing, 1);
      expect(r.total, closeTo(1, 0.001));

      // con datos de edición sí cuentan: ahí el hueco es real
      final conEdiciones =
          missingReport(conTierra, qtyOf: (_) => 0, onlyBase: true);
      expect(conEdiciones.missing, 2);
    });
  });

  group('la línea-resumen según el mercado', () {
    final es = AppLocalizationsEs();
    final set = [
      _c('1', price: 0.10),
      _c('2', price: 2.50),
      _c('3', price: null), // sin precio conocido
    ];
    MissingReport faltanTodas() =>
        missingReport(set, qtyOf: (_) => 0, onlyBase: true);

    test('con Cardmarket: el total y cuántas van sin precio', () {
      final s = missingSummary(faltanTodas(), Market.cardmarket, es);

      expect(s, contains('Te faltan 3'));
      expect(s, contains('2.60 €'));
      expect(s, contains('(1 sin precio)'));
    });

    test('con Card Kingdom nada de "\$0.00" mudo: se dice que no publica',
        () {
      // Card Kingdom y Mana Pool no publican precio por edición
      // (todayColumn == null): sumar NULLs daría un cero mentiroso
      final s = missingSummary(faltanTodas(), Market.cardkingdom, es);

      expect(s, contains('Te faltan 3'));
      expect(s, contains('Card Kingdom'));
      expect(s, isNot(contains('0.00')));
      expect(s, isNot(contains('sin precio)')));
    });

    test('completo es completo, publique precios el mercado o no', () {
      final s = missingSummary(
          missingReport(set, qtyOf: (_) => 1, onlyBase: true),
          Market.cardkingdom,
          es);

      expect(s, es.albYouHaveItAll);
    });
  });
}
