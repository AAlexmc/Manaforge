import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';

void main() {
  test('CardFolder: ida y vuelta a JSON', () {
    final folder = CardFolder(
      id: '1',
      name: 'Rares de Aetherdrift',
      colorValue: 0xFF00AAFF,
      icon: 'star',
      cardIds: {'a', 'b'},
      createdAt: '2026-07-21T10:00:00.000',
    );
    final back = CardFolder.fromJson(folder.toJson());
    expect(back.id, '1');
    expect(back.name, 'Rares de Aetherdrift');
    expect(back.colorValue, 0xFF00AAFF);
    expect(back.icon, 'star');
    expect(back.cardIds, {'a', 'b'});
    expect(back.createdAt, '2026-07-21T10:00:00.000');
  });

  test('CardFolder.fromJson tolera una carpeta sin cartas ni apariencia', () {
    final back = CardFolder.fromJson({'id': '7', 'name': 'Vacía'});
    expect(back.cardIds, isEmpty);
    expect(back.icon, isNotEmpty);
    expect(back.colorValue, isNonZero);
  });

  test('FolderStore: crear, marcar cartas y borrar (en memoria, sin plugin)',
      () {
    final store = FolderStore();
    final folder = store.create(name: 'Para vender', cardIds: {'a'});
    expect(store.folders.length, 1);
    expect(store.folders.first.cardIds, {'a'});

    store.toggleCard(folder.id, 'b');
    expect(store.folders.first.cardIds, {'a', 'b'});
    store.toggleCard(folder.id, 'b'); // idempotente: vuelve a quitarla
    expect(store.folders.first.cardIds, {'a'});

    store.rename(folder.id, 'Vendidas');
    expect(store.folders.first.name, 'Vendidas');

    store.setAppearance(folder.id, colorValue: 0xFF112233, icon: 'sell');
    expect(store.folders.first.colorValue, 0xFF112233);
    expect(store.folders.first.icon, 'sell');

    store.setCards(folder.id, {'x', 'y', 'z'});
    expect(store.folders.first.cardIds, {'x', 'y', 'z'});

    store.remove(folder.id);
    expect(store.folders, isEmpty);
  });

  test('FolderStore: la carpeta más reciente sale primero', () {
    final store = FolderStore();
    store.create(name: 'Primera');
    store.create(name: 'Segunda');
    expect(store.folders.map((f) => f.name), ['Segunda', 'Primera']);
  });

  test('foldersContaining cuenta en cuántas carpetas está una carta', () {
    final store = FolderStore();
    store.create(name: 'A', cardIds: {'x'});
    store.create(name: 'B', cardIds: {'x', 'y'});
    expect(store.foldersContaining('x'), 2);
    expect(store.foldersContaining('y'), 1);
    expect(store.foldersContaining('z'), 0);
  });

  test('removeMissing quita solo los ids que ya no están en la colección', () {
    final store = FolderStore();
    final f = store.create(name: 'A', cardIds: {'x', 'y', 'z'});
    store.removeMissing(f.id, {'x', 'z'});
    expect(store.folders.first.cardIds, {'x', 'z'});
  });

  test('missingIn dice qué cartas de la carpeta ya no tienes', () {
    final folder = CardFolder(
      id: '1',
      name: 'A',
      colorValue: 1,
      icon: 'folder',
      cardIds: {'x', 'y'},
      createdAt: '',
    );
    expect(folder.missingIn({'x'}), {'y'});
    expect(folder.presentIn({'x'}), {'x'});
  });

  test('crear dos carpetas seguidas no reutiliza el id', () {
    final store = FolderStore();
    final a = store.create(name: 'A');
    final b = store.create(name: 'B');
    expect(a.id, isNot(b.id));
  });

  test('operaciones sobre un id que no existe no revientan', () {
    final store = FolderStore();
    store.rename('nope', 'x');
    store.toggleCard('nope', 'a');
    store.setCards('nope', {'a'});
    store.setAppearance('nope', icon: 'star');
    store.remove('nope');
    expect(store.folders, isEmpty);
  });
}
