/// Precio de compra y P&L.
///
/// Lo que se prueba aquí es sobre todo lo que NO se debe hacer: mezclar
/// divisas, comparar lo pagado por unas cartas contra el valor de otras, o
/// dar por bueno un 0 del CSV como si te hubiera salido gratis.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/services/pnl.dart';

Future<Map<String, double>> Function(Iterable<String>) _prices(
        Map<String, double> table) =>
    (keys) async => {
          for (final k in keys)
            if (table.containsKey(k)) k: table[k]!
        };

Future<Map<String, double>> _ninguno(Iterable<String> keys) async => const {};

void main() {
  group('parseo del CSV', () {
    test('lee Purchase price y su divisa', () {
      const csv = 'Name,Quantity,Scryfall ID,Purchase price,'
          'Purchase price currency\n'
          'Sol Ring,2,aaa,3.50,EUR\n';
      final row = parseManaBoxCsv(csv).single;
      expect(row.purchasePrice, 3.50);
      expect(row.currency, 'EUR');
    });

    test('un 0 no es un precio: es "no lo sé"', () {
      const csv = 'Name,Quantity,Purchase price\nShock,1,0\n';
      expect(parseManaBoxCsv(csv).single.purchasePrice, isNull);
    });

    test('acepta coma decimal y descarta lo que no es número', () {
      const csv = 'Nombre;Cantidad;Precio de compra\n'
          'Rayo;1;2,40\n'
          'Isla;1;gratis\n';
      final rows = parseManaBoxCsv(csv);
      expect(rows[0].purchasePrice, 2.40);
      expect(rows[1].purchasePrice, isNull);
    });

    test('sin columna de precio, no se inventa ninguno', () {
      const csv = 'Name,Quantity\nShock,1\n';
      final row = parseManaBoxCsv(csv).single;
      expect(row.purchasePrice, isNull);
      expect(row.currency, isNull);
    });

    test('"Purchase price currency" no se confunde con "Purchase price"', () {
      const csv = 'Name,Purchase price currency,Purchase price,Quantity\n'
          'Shock,USD,1.25,1\n';
      final row = parseManaBoxCsv(csv).single;
      expect(row.purchasePrice, 1.25);
      expect(row.currency, 'USD');
    });
  });

  group('lo que pagaste, en la colección', () {
    test('dos compras de la misma impresión dejan el coste medio', () {
      final store = CollectionStore();
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 2, currency: 'EUR');
      store.recordPurchase(base: 'blb|72', qty: 3, perCopy: 6, currency: 'EUR');

      final lot = store.purchases[purchaseKey('blb|72', 'EUR')]!;
      expect(lot.qty, 4);
      expect(lot.perCopy, 5); // (2·1 + 6·3) / 4
      expect(lot.total, 20);
    });

    test('divisas distintas no se promedian entre ellas', () {
      final store = CollectionStore();
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 2, currency: 'EUR');
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 9, currency: 'USD');

      expect(store.purchases.length, 2);
      expect(store.purchases[purchaseKey('blb|72', 'EUR')]!.perCopy, 2);
      expect(store.purchases[purchaseKey('blb|72', 'USD')]!.perCopy, 9);
    });

    test('un precio absurdo no entra', () {
      final store = CollectionStore();
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 0);
      store.recordPurchase(base: 'blb|72', qty: 0, perCopy: 3);
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: -4);

      expect(store.hasPurchaseData, isFalse);
    });

    test('vender una carta se lleva su coste', () {
      final store = CollectionStore();
      final card =
          OwnedCard(oracleId: 'o1', name: 'Sol Ring', colors: '', qty: 1);
      store.add(card, qty: 3, printingKey: 'blb|72');
      store.recordPurchase(base: 'blb|72', qty: 3, perCopy: 5, currency: 'EUR');

      store.setQty('o1', 1); // vendidas dos

      final lot = store.purchases[purchaseKey('blb|72', 'EUR')]!;
      expect(lot.qty, 1);
      expect(lot.perCopy, 5); // el coste por copia no cambia al vender
    });

    test('quitar la carta entera borra lo pagado', () {
      final store = CollectionStore();
      store.add(OwnedCard(oracleId: 'o1', name: 'Sol Ring', colors: '', qty: 1),
          qty: 2, printingKey: 'blb|72');
      store.recordPurchase(base: 'blb|72', qty: 2, perCopy: 5, currency: 'EUR');

      store.setQty('o1', 0);

      expect(store.hasPurchaseData, isFalse);
    });

    test('vaciar la colección también vacía lo pagado', () {
      final store = CollectionStore();
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 5, currency: 'EUR');
      store.clear();
      expect(store.hasPurchaseData, isFalse);
    });
  });

  group('P&L', () {
    Map<String, PurchaseLot> lots(List<PurchaseLot> l) =>
        {for (final lot in l) purchaseKey(lot.base, lot.currency): lot};

    test('gana lo que ha subido, sobre lo que pagaste', () async {
      final pnl = await computePnl(
        purchases: lots([
          const PurchaseLot(
              base: 'blb|72', perCopy: 2, qty: 2, currency: 'EUR'),
        ]),
        totalCopies: 2,
        currency: 'EUR',
        printingPrices: _prices({'blb|72': 5}),
        oraclePrices: _ninguno,
      );

      expect(pnl.paid, 4);
      expect(pnl.value, 10);
      expect(pnl.delta, 6);
      expect(pnl.percent, 150);
      expect(pnl.copies, 2);
      expect(pnl.complete, isTrue);
    });

    test('las compras en otra divisa NO se convierten ni se suman', () async {
      final pnl = await computePnl(
        purchases: lots([
          const PurchaseLot(
              base: 'blb|72', perCopy: 2, qty: 1, currency: 'EUR'),
          const PurchaseLot(
              base: 'kld|5', perCopy: 30, qty: 1, currency: 'USD'),
        ]),
        totalCopies: 2,
        currency: 'EUR',
        printingPrices: _prices({'blb|72': 3, 'kld|5': 40}),
        oraclePrices: _ninguno,
      );

      expect(pnl.paid, 2);
      expect(pnl.value, 3);
      expect(pnl.otherCurrencies, {'USD': 30});
    });

    test('solo compara copias comparables: sin precio de hoy, fuera',
        () async {
      final pnl = await computePnl(
        purchases: lots([
          const PurchaseLot(
              base: 'blb|72', perCopy: 2, qty: 1, currency: 'EUR'),
          const PurchaseLot(
              base: 'rara|99', perCopy: 8, qty: 2, currency: 'EUR'),
        ]),
        totalCopies: 3,
        currency: 'EUR',
        printingPrices: _prices({'blb|72': 3}),
        oraclePrices: _ninguno,
      );

      expect(pnl.paid, 2); // los 16 € de la que no tiene precio no cuentan
      expect(pnl.value, 3);
      expect(pnl.copiesWithoutPrice, 2);
      expect(pnl.complete, isFalse);
    });

    test('colecciones antiguas sin edición exacta: precio a nivel carta',
        () async {
      final pnl = await computePnl(
        purchases: lots([
          const PurchaseLot(
              base: 'oracle:o1', perCopy: 1, qty: 4, currency: 'EUR'),
        ]),
        totalCopies: 4,
        currency: 'EUR',
        printingPrices: _ninguno,
        oraclePrices: _prices({'o1': 2.5}),
      );

      expect(pnl.paid, 4);
      expect(pnl.value, 10);
    });

    test('sin divisa en el CSV se supone la del mercado, y se dice', () async {
      final pnl = await computePnl(
        purchases: lots([
          const PurchaseLot(
              base: 'blb|72', perCopy: 2, qty: 2, currency: null),
        ]),
        totalCopies: 2,
        currency: 'EUR',
        printingPrices: _prices({'blb|72': 2}),
        oraclePrices: _ninguno,
      );

      expect(pnl.copiesAssumedCurrency, 2);
      expect(pnl.paid, 4);
    });

    test('sin compras, no hay P&L que enseñar', () async {
      final pnl = await computePnl(
        purchases: const {},
        totalCopies: 10,
        currency: 'EUR',
        printingPrices: _ninguno,
        oraclePrices: _ninguno,
      );

      expect(pnl.hasData, isFalse);
      expect(pnl.percent, isNull);
    });
  });

  group('lo pagado por UNA carta', () {
    test('suma sus ediciones y separa divisas', () {
      final store = CollectionStore();
      store.add(OwnedCard(oracleId: 'o1', name: 'Sol Ring', colors: '', qty: 1),
          qty: 1, printingKey: 'blb|72');
      store.add(OwnedCard(oracleId: 'o1', name: 'Sol Ring', colors: '', qty: 1),
          qty: 2, printingKey: 'kld|5');
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 4, currency: 'EUR');
      store.recordPurchase(base: 'kld|5', qty: 2, perCopy: 3, currency: 'EUR');
      store.recordPurchase(base: 'kld|5', qty: 1, perCopy: 9, currency: 'USD');

      final pagado = store.paidForCard('o1');

      expect(pagado['EUR']!.total, 10); // 4 + 3·2
      expect(pagado['EUR']!.qty, 3);
      expect(pagado['USD']!.total, 9); // aparte: no se convierte
    });

    test('otra carta no cuenta', () {
      final store = CollectionStore();
      store.add(OwnedCard(oracleId: 'o1', name: 'A', colors: '', qty: 1),
          qty: 1, printingKey: 'blb|72');
      store.recordPurchase(base: 'blb|72', qty: 1, perCopy: 4, currency: 'EUR');

      expect(store.paidForCard('o2'), isEmpty);
    });
  });

  group('meter una fila del CSV avisa UNA vez', () {
    test('añadir con precio de compra da un solo aviso', () {
      final store = CollectionStore();
      var avisos = 0;
      store.addListener(() => avisos++);

      store.add(
        OwnedCard(oracleId: 'o1', name: 'Sol Ring', colors: '', qty: 1),
        qty: 2,
        printingKey: 'blb|72',
        paidPerCopy: 3.5,
        paidCurrency: 'EUR',
      );

      expect(avisos, 1); // no dos: cada aviso hace recalcular al Album
      expect(store.purchases[purchaseKey('blb|72', 'EUR')]!.qty, 2);
    });

    test('sin edición exacta, lo pagado va a la carta', () {
      final store = CollectionStore();

      store.add(OwnedCard(oracleId: 'o1', name: 'Shock', colors: '', qty: 1),
          qty: 1, paidPerCopy: 0.25);

      expect(store.purchases[purchaseKey('oracle:o1', null)]!.perCopy, 0.25);
    });

    test('sin precio no se apunta nada', () {
      final store = CollectionStore();

      store.add(OwnedCard(oracleId: 'o1', name: 'Shock', colors: '', qty: 1),
          qty: 1);

      expect(store.hasPurchaseData, isFalse);
    });
  });
}
