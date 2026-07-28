// Wishlist: cartas que quieres comprar con precio objetivo. Cuando el
// precio actual cae al objetivo, la app avisa UNA vez; si vuelve a subir,
// la alerta se rearma.
import 'package:flutter_test/flutter_test.dart';

import 'package:manaforge_app/data/repositories/wishlist_store.dart';

WishItem _item(String oracle, String name, double target) =>
    WishItem(oracleId: oracle, name: name, colors: '', targetPrice: target);

void main() {
  test('añadir, contener, quitar y listar ordenado por nombre', () {
    final store = WishlistStore();
    store.add(_item('o2', 'Zur', 5));
    store.add(_item('o1', 'Bolt', 2));
    expect(store.contains('o1'), isTrue);
    expect(store.items.map((i) => i.name).toList(), ['Bolt', 'Zur']);
    store.remove('o2');
    expect(store.contains('o2'), isFalse);
    expect(store.items, hasLength(1));
  });

  test('cae al objetivo: avisa UNA vez y guarda el último precio', () {
    final store = WishlistStore();
    store.add(_item('o1', 'Bolt', 2));
    final hits = store.updatePrices({'o1': 1.5});
    expect(hits.map((i) => i.oracleId), ['o1']);
    expect(store.items.single.lastPrice, 1.5);
    // mismo precio otra vez: sin re-aviso
    expect(store.updatePrices({'o1': 1.4}), isEmpty);
  });

  test('sube sobre el objetivo y vuelve a caer: se rearma y re-avisa', () {
    final store = WishlistStore();
    store.add(_item('o1', 'Bolt', 2));
    expect(store.updatePrices({'o1': 1.5}), isNotEmpty);
    expect(store.updatePrices({'o1': 3.0}), isEmpty); // rearmada
    expect(store.updatePrices({'o1': 1.9}), isNotEmpty); // re-avisa
  });

  test('sin precio conocido: ni avisa ni toca el item', () {
    final store = WishlistStore();
    store.add(_item('o1', 'Bolt', 2));
    expect(store.updatePrices(const {}), isEmpty);
    expect(store.items.single.lastPrice, isNull);
  });

  test('cambiar el objetivo rearma la alerta si procede', () {
    final store = WishlistStore();
    store.add(_item('o1', 'Bolt', 2));
    store.updatePrices({'o1': 1.5}); // avisada
    store.setTarget('o1', 1.0); // objetivo más duro: 1.5 ya no vale
    expect(store.updatePrices({'o1': 1.5}), isEmpty);
    expect(store.updatePrices({'o1': 0.9}), isNotEmpty);
  });

  test('WishItem sobrevive el viaje a JSON', () {
    final item = WishItem(
        oracleId: 'o1',
        name: 'Bolt',
        printedName: 'Rayo',
        imageSmall: 'http://img/s.jpg',
        colors: 'R',
        targetPrice: 2.5,
        lastPrice: 3.0,
        alerted: true);
    final back = WishItem.fromJson(item.toJson());
    expect(back.oracleId, 'o1');
    expect(back.printedName, 'Rayo');
    expect(back.targetPrice, 2.5);
    expect(back.lastPrice, 3.0);
    expect(back.alerted, isTrue);
  });

  group('WishItem.fromJson filtra la imagen (copia restaurada de otro)', () {
    test('URL fuera de Scryfall se queda sin imagen, no la pide', () {
      final item = WishItem.fromJson(const {
        'oracleId': 'o1',
        'name': 'Bolt',
        'imageSmall': 'http://evil/x.png',
        'colors': 'R',
        'targetPrice': 2.5,
      });
      expect(item.imageSmall, isNull);
    });

    test('URL legítima de Scryfall se conserva', () {
      const url = 'https://cards.scryfall.io/small/front/a/b/abc.jpg';
      final item = WishItem.fromJson({
        'oracleId': 'o1',
        'name': 'Bolt',
        'imageSmall': url,
        'colors': 'R',
        'targetPrice': 2.5,
      });
      expect(item.imageSmall, url);
    });
  });
}
