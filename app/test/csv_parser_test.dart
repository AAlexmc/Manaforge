import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';

void main() {
  test('parsea un CSV real exportado (comas, comillas, Scryfall ID y columnas ajenas)', () {
    const csv =
        'Binder Name,Binder Type,Name,Set code,Set name,Collector number,Foil,'
        'Rarity,Quantity,ManaBox ID,Scryfall ID,Purchase price\n'
        'Fuego,binder,"Ruby, Daring Tracker",FDN,Foundations,245,normal,'
        'uncommon,2,101405,fe3e7dd2-b66d-4218-9fde-f84bec26b7bf,0.11\n'
        'Agua,binder,Counterspell,BRB,Battle Royale,15,normal,common,1,'
        '34045,9a765377-bc8c-480a-9903-bd942c20fc47,2.69\n';
    final rows = parseCollectionCsv(csv);
    expect(rows.length, 2);
    expect(rows[0].name, 'Ruby, Daring Tracker'); // comillas respetadas
    expect(rows[0].scryfallId, 'fe3e7dd2-b66d-4218-9fde-f84bec26b7bf');
    expect(rows[0].qty, 2);
    expect(rows[1].name, 'Counterspell');
    expect(rows[1].qty, 1);
    expect(rows[0].setName, 'Foundations'); // set name capturado
  });

  test('detecta tokens y emblemas por set o nombre', () {
    expect(looksLikeToken('Cat', 'Foundations Tokens'), isTrue);
    expect(looksLikeToken('Toy', 'Duskmourn: House of Horror Tokens'), isTrue);
    expect(looksLikeToken('Tezzeret the Schemer Emblem', 'Aether Revolt'),
        isTrue);
    expect(looksLikeToken('Counterspell', 'Battle Royale'), isFalse);
    expect(looksLikeToken('Llanowar Elves', null), isFalse);
  });

  test('acepta cabeceras en español y separador punto y coma', () {
    const csv = 'Nombre;Cantidad\nElfos de Llanowar;3\n';
    final rows = parseCollectionCsv(csv);
    expect(rows.single.name, 'Elfos de Llanowar');
    expect(rows.single.qty, 3);
  });

  test('CSV sin columna de nombre devuelve vacío en vez de fallar', () {
    expect(parseCollectionCsv('foo,bar\n1,2\n'), isEmpty);
  });

  test('lee la columna Foil del CSV', () {
    const csv = 'Name,Foil,Quantity,Scryfall ID\n'
        'Shock,normal,2,aaa\n'
        'Lightning Bolt,foil,1,bbb\n'
        'Sol Ring,etched,1,ccc\n';
    final rows = parseCollectionCsv(csv);
    expect(rows[0].foil, isFalse);
    expect(rows[1].foil, isTrue);
    expect(rows[2].foil, isTrue); // etched también brilla
  });

  test('la colección cuenta las copias foil por edición', () {
    final store = CollectionStore();
    OwnedCard card() =>
        OwnedCard(oracleId: 'o1', name: 'Test', colors: 'W', qty: 1);
    store.add(card(), qty: 2, printingKey: 'aer|1');
    store.add(card(), qty: 1, printingKey: 'aer|1', foil: true);
    store.add(card(), qty: 3, printingKey: 'kld|5', foil: true);
    expect(store.foilCopies, 4);
    expect(store.foilPrintings['aer|1'], 1);
    expect(store.printingQty['aer|1'], 3); // las foil también son copias
    store.clear();
    expect(store.foilCopies, 0);
  });

  test('la colección suma y elimina cantidades', () {
    final store = CollectionStore();
    final card = OwnedCard(
        oracleId: 'o1', name: 'Test', colors: 'W', qty: 1);
    store.add(card);
    store.add(
        OwnedCard(oracleId: 'o1', name: 'Test', colors: 'W', qty: 1),
        qty: 2);
    expect(store.totalCopies, 3);
    store.setQty('o1', 0);
    expect(store.distinctCards, 0);
  });
}
