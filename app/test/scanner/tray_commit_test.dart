/// Meter la bandeja del escaneo en la colección, con carpeta opcional.
///
/// La carpeta NO es un destino alternativo: las cartas entran en la colección
/// igual y ADEMÁS se etiquetan. Las carpetas guardan solo pertenencia; la
/// cantidad la manda siempre la colección.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/burst_controller.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/scanner/tray_commit.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/folder_store.dart';

ScanMatch _match(String oracleId, String name,
        {String set = 'blb', String number = '72'}) =>
    ScanMatch(
      HashEntry(
        scryfallId: '$oracleId-$set-$number',
        oracleId: oracleId,
        name: name,
        setCode: set,
        collectorNumber: number,
      ),
      2,
    );

ScanTray _trayWith(List<ScanMatch> matches) {
  final tray = ScanTray();
  for (final m in matches) {
    tray.add(Recognition([m], ScanConfidence.confident));
  }
  return tray;
}

void main() {
  test('sin carpeta, las cartas entran solo en la colección', () {
    final collection = CollectionStore();
    final tray = _trayWith([_match('sol-ring', 'Sol Ring')]);

    final result = commitTray(
        tray: tray, collection: collection, hitCache: const {});

    expect(result.copies, 1);
    expect(collection.cards.single.name, 'Sol Ring');
  });

  test('con carpeta, entran en la colección Y se etiquetan', () {
    final collection = CollectionStore();
    final folders = FolderStore();
    final carpeta = folders.create(name: 'Caja de la tienda');
    final tray = _trayWith([
      _match('sol-ring', 'Sol Ring'),
      _match('mox-pearl', 'Mox Pearl', number: '264'),
    ]);

    commitTray(
      tray: tray,
      collection: collection,
      hitCache: const {},
      folders: folders,
      folderId: carpeta.id,
    );

    expect(collection.distinctCards, 2, reason: 'la colección manda igual');
    expect(folders.byId(carpeta.id)!.cardIds, {'sol-ring', 'mox-pearl'});
  });

  test('la carpeta guarda pertenencia, no cantidades', () {
    final collection = CollectionStore();
    final folders = FolderStore();
    final carpeta = folders.create(name: 'Duplicadas');
    final tray = _trayWith([_match('sol-ring', 'Sol Ring')]);
    tray.lines.single.qty = 4;

    final result = commitTray(
      tray: tray,
      collection: collection,
      hitCache: const {},
      folders: folders,
      folderId: carpeta.id,
    );

    expect(result.copies, 4);
    expect(collection.cards.single.qty, 4);
    expect(folders.byId(carpeta.id)!.cardIds, {'sol-ring'},
        reason: 'una carta está o no está: la cantidad no vive aquí');
  });

  test('una línea sin reconocer no entra en ningún sitio', () {
    final collection = CollectionStore();
    final folders = FolderStore();
    final carpeta = folders.create(name: 'Caja');
    final tray = _trayWith([_match('sol-ring', 'Sol Ring')])
      ..lines.add(TrayLine.unrecognized([_match('quien-sabe', '???')], null));

    final result = commitTray(
      tray: tray,
      collection: collection,
      hitCache: const {},
      folders: folders,
      folderId: carpeta.id,
    );

    expect(result.copies, 1);
    expect(collection.distinctCards, 1);
    expect(folders.byId(carpeta.id)!.cardIds, {'sol-ring'});
  });

  test('una carpeta que ya no existe no rompe el guardado', () {
    final collection = CollectionStore();
    final folders = FolderStore();
    final tray = _trayWith([_match('sol-ring', 'Sol Ring')]);

    final result = commitTray(
      tray: tray,
      collection: collection,
      hitCache: const {},
      folders: folders,
      folderId: 'una-que-se-borró',
    );

    expect(result.copies, 1, reason: 'las cartas se guardan igual');
    expect(collection.distinctCards, 1);
  });

  test('toda la tanda entra con el MISMO instante, para que empate el orden',
      () {
    final collection = CollectionStore();
    final tray = _trayWith([
      _match('sol-ring', 'Sol Ring'),
      _match('mox-pearl', 'Mox Pearl', number: '264'),
    ]);

    commitTray(
        tray: tray,
        collection: collection,
        hitCache: const {},
        at: DateTime.utc(2026, 7, 22, 12));

    final fechas = collection.cards.map((c) => c.addedAt).toSet();
    expect(fechas.length, 1);
  });

  test('toda la bandeja en lote: un solo aviso, no uno por línea', () async {
    final collection = CollectionStore();
    final tray = _trayWith([
      _match('sol-ring', 'Sol Ring'),
      _match('mox-pearl', 'Mox Pearl', number: '264'),
      _match('mox-sapphire', 'Mox Sapphire', number: '265'),
    ]);
    var avisos = 0;
    collection.addListener(() => avisos++);

    final result =
        commitTray(tray: tray, collection: collection, hitCache: const {});

    // los add() ya han corrido (sin await propio): el resultado y la
    // colección están completos ya mismo, solo el aviso se demora
    expect(result.copies, 3);
    expect(collection.distinctCards, 3,
        reason: 'las 3 cartas ya están en la colección aunque no haya '
            'avisado todavía');
    await Future<void>.delayed(Duration.zero); // deja correr el microtask
    expect(avisos, 1, reason: 'un lote, un aviso — no uno por carta');
  });
}
