/// La curva del valor de la colección a lo largo del tiempo.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/domain/collection_value_series.dart';
import 'package:manaforge_app/data/services/price_history.dart';
import 'package:manaforge_app/data/repositories/value_history.dart';

void main() {
  test('suma el precio de cada día por las copias que tienes', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 2, 'b': 1},
      seriesByOracle: {
        'a': const [
          PricePoint('2026-07-01', 1),
          PricePoint('2026-07-02', 2),
        ],
        'b': const [
          PricePoint('2026-07-01', 10),
          PricePoint('2026-07-02', 10),
        ],
      },
    );

    expect(serie.map((p) => p.date), ['2026-07-01', '2026-07-02']);
    expect(serie[0].value, 12); // 2×1 + 1×10
    expect(serie[1].value, 14); // 2×2 + 1×10
  });

  test('un día sin dato de una carta arrastra su último precio conocido', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 1, 'b': 1},
      seriesByOracle: {
        'a': const [
          PricePoint('2026-07-01', 5),
          PricePoint('2026-07-03', 7),
        ],
        'b': const [
          PricePoint('2026-07-01', 1),
          PricePoint('2026-07-02', 1),
          PricePoint('2026-07-03', 1),
        ],
      },
    );

    // el 2 de julio 'a' no tiene punto: vale lo que valía el 1
    expect(serie[1].date, '2026-07-02');
    expect(serie[1].value, 6);
  });

  test('antes del primer dato de una carta se usa su primer precio, para que '
      'la curva mida movimiento y no altas de datos', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'vieja': 1, 'nueva': 1},
      seriesByOracle: {
        'vieja': const [
          PricePoint('2026-07-01', 10),
          PricePoint('2026-07-02', 10),
        ],
        // esta carta solo tiene dato del día 2
        'nueva': const [PricePoint('2026-07-02', 4)],
      },
    );

    expect(serie[0].value, 14, reason: 'sin salto artificial el día que entra');
    expect(serie[1].value, 14);
  });

  test('las cartas sin ninguna serie no cuentan', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 1, 'sinDatos': 99},
      seriesByOracle: {
        'a': const [PricePoint('2026-07-01', 3)],
      },
    );

    expect(serie.single.value, 3);
  });

  test('solo cuentan las cartas que tienes, y con su cantidad', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 3},
      seriesByOracle: {
        'a': const [PricePoint('2026-07-01', 2)],
        'noLaTengo': const [PricePoint('2026-07-01', 1000)],
      },
    );

    expect(serie.single.value, 6);
  });

  test('cantidad cero o negativa no resta ni suma', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 0, 'b': -2, 'c': 1},
      seriesByOracle: {
        'a': const [PricePoint('2026-07-01', 100)],
        'b': const [PricePoint('2026-07-01', 100)],
        'c': const [PricePoint('2026-07-01', 5)],
      },
    );

    expect(serie.single.value, 5);
  });

  test('sin series no hay curva', () {
    expect(
      collectionValueSeries(qtyByOracle: {'a': 1}, seriesByOracle: const {}),
      isEmpty,
    );
  });

  test('las fechas salen ordenadas aunque lleguen desordenadas', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 1},
      seriesByOracle: {
        'a': const [
          PricePoint('2026-07-03', 3),
          PricePoint('2026-07-01', 1),
          PricePoint('2026-07-02', 2),
        ],
      },
    );

    expect(serie.map((p) => p.date), ['2026-07-01', '2026-07-02', '2026-07-03']);
    expect(serie.map((p) => p.value), [1, 2, 3]);
  });

  test('dos puntos del mismo día se quedan en uno (gana el último)', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 1},
      seriesByOracle: {
        'a': const [
          PricePoint('2026-07-01', 1),
          PricePoint('2026-07-01', 9),
        ],
      },
    );

    expect(serie.length, 1);
    expect(serie.single.value, 9);
  });

  test('todos los puntos llevan las copias que tienes hoy', () {
    final serie = collectionValueSeries(
      qtyByOracle: {'a': 2, 'b': 3},
      seriesByOracle: {
        'a': const [PricePoint('2026-07-01', 1), PricePoint('2026-07-02', 1)],
        'b': const [PricePoint('2026-07-01', 1), PricePoint('2026-07-02', 1)],
      },
    );

    expect(serie.every((p) => p.cards == 5), isTrue);
  });

  test('la costura solo existe si de verdad queda cola local', () {
    const real = [
      ValuePoint('2026-07-01', 10, 5),
      ValuePoint('2026-07-02', 11, 5),
    ];
    const local = [
      ValuePoint('2026-07-02', 99, 5), // mismo día: no entra
      ValuePoint('2026-07-03', 25, 5),
    ];
    final (curva, costura) = stitchValueCurve(real, local);
    expect(curva.map((p) => p.date),
        ['2026-07-01', '2026-07-02', '2026-07-03']);
    expect(costura, '2026-07-02');

    // sin cola local, no hay mezcla ni costura
    final (sola, sinCostura) = stitchValueCurve(real, const []);
    expect(sola, real);
    expect(sinCostura, isNull);

    // histórico insuficiente: manda lo local, sin costura
    final (soloLocal, tampoco) =
        stitchValueCurve(const [ValuePoint('2026-07-01', 10, 5)], local);
    expect(soloLocal, local);
    expect(tampoco, isNull);
  });

  test('cruzaCostura: solo el tramo que une las dos fuentes', () {
    // el salto histórico(02)→local(03) es cambio de fuente: sin delta
    expect(cruzaCostura('2026-07-02', '2026-07-02', '2026-07-03'), isTrue);
    // dos puntos locales seguidos: delta normal
    expect(cruzaCostura('2026-07-02', '2026-07-03', '2026-07-04'), isFalse);
    // dos históricos: delta normal
    expect(cruzaCostura('2026-07-02', '2026-07-01', '2026-07-02'), isFalse);
    // sin mezcla no hay costura que cruzar
    expect(cruzaCostura(null, '2026-07-02', '2026-07-03'), isFalse);
  });
}
