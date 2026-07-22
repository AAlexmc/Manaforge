/// Tests que SÍ tocan el disco. Los demás corren en memoria (sin
/// path_provider, `_file()` devuelve null), así que las carreras de guardado
/// —justo lo que nos rompió— no se veían en CI.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/achievement_store.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/folder_store.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('manaforge_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('dos guardados en el mismo turno dejan un JSON válido y completo',
      () async {
    final store = FolderStore(dataDir: dir);
    final folder = store.create(name: 'A', cardIds: {'x'});
    // el diálogo de editar hacía justo esto: dos escrituras seguidas
    store.rename(folder.id, 'B');
    store.setAppearance(folder.id, colorValue: 0xFF010203, icon: 'star');
    await store.pendingSave;

    final file = File('${dir.path}/folders.json');
    expect(file.existsSync(), isTrue);
    final list = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    expect(list, hasLength(1));
    expect((list.first as Map)['name'], 'B');
    expect((list.first as Map)['icon'], 'star');
    expect(File('${file.path}.tmp').existsSync(), isFalse);
  });

  test('300 altas seguidas (importar un CSV) no corrompen la colección',
      () async {
    final store = CollectionStore(dataDir: dir);
    for (var i = 0; i < 300; i++) {
      store.add(
        OwnedCard(oracleId: 'o$i', name: 'Carta $i', colors: 'G', qty: 1),
        printingKey: 'aer|$i',
      );
    }
    await store.pendingSave;

    final decoded = jsonDecode(
        File('${dir.path}/collection.json').readAsStringSync());
    expect((decoded as Map)['cards'], hasLength(300));

    final again = CollectionStore(dataDir: dir);
    await again.load();
    expect(again.distinctCards, 300);
    expect(again.totalCopies, 300);
  });

  test('un JSON roto se aparta y NO se pierde la colección buena', () async {
    File('${dir.path}/collection.json').writeAsStringSync('{"cards": [');
    final store = CollectionStore(dataDir: dir);
    await store.load();
    expect(store.distinctCards, 0);
    expect(File('${dir.path}/collection.json.roto').existsSync(), isTrue);
  });

  test('una carpeta con basura no se lleva por delante a las demás',
      () async {
    File('${dir.path}/folders.json').writeAsStringSync(jsonEncode([
      {'id': '1', 'name': 'Buena', 'cards': ['x']},
      {'name': 'Sin id'},
      {'id': '3', 'name': 'También buena', 'cards': ['y']},
    ]));
    final store = FolderStore(dataDir: dir);
    await store.load();
    expect(store.folders.map((f) => f.name), ['Buena', 'También buena']);
  });

  test('los logros sobreviven a varios desbloqueos a la vez', () async {
    final store = AchievementStore(dataDir: dir);
    store.unlockAll(['copias-1']);
    store.bump(AchievementCounters.cardsScanned, 5);
    store.raise(AchievementCounters.bestPhotoCards, 9);
    store.markDayActive();
    await store.pendingSave;

    final again = AchievementStore(dataDir: dir);
    await again.load();
    expect(again.unlockedAt.keys, ['copias-1']);
    expect(again.counter(AchievementCounters.cardsScanned), 5);
    expect(again.counter(AchievementCounters.bestPhotoCards), 9);
    expect(again.activeDays, 1);
  });

  test('una colección vieja aprende de quién es cada edición', () async {
    final store = CollectionStore(dataDir: dir);
    // simula lo importado antes de esta versión: printings sin dueño
    File('${dir.path}/collection.json').writeAsStringSync(jsonEncode({
      'cards': [
        {'oracleId': 'o1', 'name': 'A', 'colors': 'G', 'qty': 2}
      ],
      'printings': {'aer|1': 2},
    }));
    await store.load();
    expect(store.printingQty['aer|1'], 2);
    store.setQty('o1', 0); // sin dueño no se puede limpiar…
    expect(store.printingQty['aer|1'], 2);

    final fresh = CollectionStore(dataDir: dir);
    await fresh.load();
    fresh.backfillPrintingOwners({'aer|1': 'o1'}); // …hasta que lo aprende
    fresh.setQty('o1', 0);
    expect(fresh.printingQty.containsKey('aer|1'), isFalse);
    await fresh.pendingSave;
  });

  test('vender una carta baja también sus copias por edición', () async {
    final store = CollectionStore(dataDir: dir);
    store.add(OwnedCard(oracleId: 'o1', name: 'A', colors: 'G', qty: 2),
        qty: 2, printingKey: 'aer|1', foil: true);
    store.add(OwnedCard(oracleId: 'o2', name: 'B', colors: 'U', qty: 1),
        printingKey: 'kld|9');
    expect(store.printingQty['aer|1'], 2);
    expect(store.foilCopies, 2);

    store.setQty('o1', 1); // vendes una copia
    expect(store.printingQty['aer|1'], 1);
    expect(store.foilCopies, 1);

    store.setQty('o1', 0); // vendes la que queda
    expect(store.printingQty.containsKey('aer|1'), isFalse);
    expect(store.foilCopies, 0);
    expect(store.printingQty['kld|9'], 1); // la otra carta ni se toca
    await store.pendingSave;
  });

  test('lo pagado sobrevive a cerrar la app', () async {
    final store = CollectionStore(dataDir: dir);
    store.add(OwnedCard(oracleId: 'o1', name: 'Sol Ring', colors: '', qty: 1),
        qty: 2, printingKey: 'blb|72');
    store.recordPurchase(
        base: 'blb|72', qty: 2, perCopy: 4.25, currency: 'EUR');
    await store.pendingSave;

    final otra = CollectionStore(dataDir: dir);
    await otra.load();

    final lot = otra.purchases[purchaseKey('blb|72', 'EUR')]!;
    expect(lot.qty, 2);
    expect(lot.perCopy, 4.25);
    expect(lot.currency, 'EUR');
  });

  test('una compra con un número imposible no se lleva la colección por '
      'delante', () async {
    final file = File('${dir.path}/collection.json');
    file.writeAsStringSync(jsonEncode({
      'cards': [
        {'oracleId': 'o1', 'name': 'Sol Ring', 'colors': '', 'qty': 1}
      ],
      'printings': {'blb|72': 1},
      'paid': {
        'blb|72@EUR': {'base': 'blb|72', 'per': 'gratis', 'qty': 1},
        'kld|5@EUR': {'base': 'kld|5', 'per': 2.0, 'qty': 3},
      },
    }));

    final store = CollectionStore(dataDir: dir);
    await store.load();

    expect(store.totalCopies, 1); // la colección entera sigue ahí
    expect(store.purchases.length, 1); // solo se cae la compra ilegible
    expect(store.purchases[purchaseKey('kld|5', 'EUR')]!.perCopy, 2.0);
  });
}
