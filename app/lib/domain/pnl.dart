/// Precio de compra y P&L: qué pagaste, qué vale hoy y cuánto va de uno a
/// otro.
///
/// Dos reglas mandan aquí:
///
/// 1. **Las divisas no se convierten** (igual que en `markets.dart`). El P&L
///    se calcula SOLO con las compras que están en la divisa del mercado que
///    estás mirando; lo pagado en otras monedas se enseña aparte, sin sumar.
/// 2. **Solo se comparan copias comparables.** El valor de hoy se mide sobre
///    las MISMAS copias que tienen precio de compra apuntado. Comparar lo
///    pagado por 200 cartas contra el valor de las 283 que tienes daría un
///    beneficio inventado.
library;

import 'package:manaforge_app/data/repositories/collection_store.dart';

/// El resultado: lo pagado, lo que vale hoy, y qué parte de la colección
/// entra en la cuenta.
class PnL {
  /// Divisa en la que están estos números (la del mercado elegido).
  final String currency;

  /// Lo que pagaste por las copias que entran en la cuenta.
  final double paid;

  /// Lo que valen HOY esas mismas copias.
  final double value;

  /// Copias con precio de compra apuntado Y precio de hoy conocido.
  final int copies;

  /// Copias de la colección en total (para decir sobre cuántas se mide).
  final int totalCopies;

  /// Copias con precio de compra pero SIN precio de hoy en la base: no
  /// entran en la cuenta y se dicen, en vez de contarlas como si valieran 0.
  final int copiesWithoutPrice;

  /// Lo pagado en OTRAS divisas, sin convertir: 'USD' -> 34.10.
  final Map<String, double> otherCurrencies;

  /// Copias compradas cuyo CSV no decía la divisa. Se cuentan como si fueran
  /// de la divisa del mercado, porque es lo más probable, pero hay que
  /// avisarlo: es una suposición, no un dato.
  final int copiesAssumedCurrency;

  const PnL({
    required this.currency,
    required this.paid,
    required this.value,
    required this.copies,
    required this.totalCopies,
    required this.copiesWithoutPrice,
    required this.otherCurrencies,
    required this.copiesAssumedCurrency,
  });

  /// Ganancia (o pérdida) sobre lo pagado.
  double get delta => value - paid;

  /// En porcentaje. `null` si no pagaste nada: dividir entre cero no es
  /// "infinito por ciento", es que no hay porcentaje que enseñar.
  double? get percent => paid > 0 ? delta / paid * 100 : null;

  /// ¿Hay algo que enseñar? Sin copias en la cuenta, un 0 € grande solo
  /// confunde.
  bool get hasData => copies > 0;

  /// El P&L cubre toda la colección (nadie se queda fuera).
  bool get complete => copies == totalCopies;
}

/// Calcula el P&L.
///
/// [printingPrices] y [oraclePrices] son los mismos buscadores de precio que
/// usa la valoración de la colección: se les pasa un puñado de claves y
/// devuelven las que conocen, en la divisa de [currency].
Future<PnL> computePnl({
  required Map<String, PurchaseLot> purchases,
  required int totalCopies,
  required String currency,
  required Future<Map<String, double>> Function(Iterable<String>)
      printingPrices,
  required Future<Map<String, double>> Function(Iterable<String>) oraclePrices,
}) async {
  final propias = <PurchaseLot>[];
  final otras = <String, double>{};
  for (final lot in purchases.values) {
    if (lot.currency == null) {
      // el CSV no decía divisa: se supone la del mercado y se avisa luego
      propias.add(lot);
    } else if (lot.currency == currency) {
      propias.add(lot);
    } else {
      otras[lot.currency!] = (otras[lot.currency!] ?? 0) + lot.total;
    }
  }
  if (propias.isEmpty) {
    return PnL(
      currency: currency,
      paid: 0,
      value: 0,
      copies: 0,
      totalCopies: totalCopies,
      copiesWithoutPrice: 0,
      otherCurrencies: otras,
      copiesAssumedCurrency: 0,
    );
  }

  final porImpresion = [
    for (final l in propias)
      if (!l.base.startsWith('oracle:')) l
  ];
  final porCarta = [
    for (final l in propias)
      if (l.base.startsWith('oracle:')) l
  ];
  final precios = <String, double>{};
  if (porImpresion.isNotEmpty) {
    precios.addAll(await printingPrices(porImpresion.map((l) => l.base)));
  }
  final preciosCarta = porCarta.isEmpty
      ? const <String, double>{}
      : await oraclePrices(porCarta.map((l) => l.base.substring(7)));

  double pagado = 0;
  double valor = 0;
  var copias = 0;
  var sinPrecio = 0;
  var asumidasEnCuenta = 0;
  for (final lot in propias) {
    final hoy = lot.base.startsWith('oracle:')
        ? preciosCarta[lot.base.substring(7)]
        : precios[lot.base];
    if (hoy == null) {
      // sin precio de hoy no hay comparación posible: se dice, no se inventa
      sinPrecio += lot.qty;
      continue;
    }
    pagado += lot.total;
    valor += hoy * lot.qty;
    copias += lot.qty;
    if (lot.currency == null) asumidasEnCuenta += lot.qty;
  }
  return PnL(
    currency: currency,
    paid: pagado,
    value: valor,
    copies: copias,
    totalCopies: totalCopies,
    copiesWithoutPrice: sinPrecio,
    otherCurrencies: otras,
    copiesAssumedCurrency: asumidasEnCuenta,
  );
}
