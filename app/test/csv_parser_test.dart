import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/collection_store.dart';

void main() {
  test('parsea el CSV real de ManaBox (comas, comillas y Scryfall ID)', () {
    const csv =
        'Binder Name,Binder Type,Name,Set code,Set name,Collector number,Foil,'
        'Rarity,Quantity,ManaBox ID,Scryfall ID,Purchase price\n'
        'Fuego,binder,"Ruby, Daring Tracker",FDN,Foundations,245,normal,'
        'uncommon,2,101405,fe3e7dd2-b66d-4218-9fde-f84bec26b7bf,0.11\n'
        'Agua,binder,Counterspell,BRB,Battle Royale,15,normal,common,1,'
        '34045,9a765377-bc8c-480a-9903-bd942c20fc47,2.69\n';
    final rows = parseManaBoxCsv(csv);
    expect(rows.length, 2);
    expect(rows[0].$1, 'Ruby, Daring Tracker'); // comillas respetadas
    expect(rows[0].$2, 'fe3e7dd2-b66d-4218-9fde-f84bec26b7bf');
    expect(rows[0].$3, 2);
    expect(rows[1].$1, 'Counterspell');
    expect(rows[1].$3, 1);
  });

  test('acepta cabeceras en español y separador punto y coma', () {
    const csv = 'Nombre;Cantidad\nElfos de Llanowar;3\n';
    final rows = parseManaBoxCsv(csv);
    expect(rows.single.$1, 'Elfos de Llanowar');
    expect(rows.single.$3, 3);
  });

  test('CSV sin columna de nombre devuelve vacío en vez de fallar', () {
    expect(parseManaBoxCsv('foo,bar\n1,2\n'), isEmpty);
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
