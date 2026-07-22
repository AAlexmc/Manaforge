// ignore_for_file: avoid_print
// Spike del bloque C: para cada foto, QUÉ ediciones compiten por la carta
// ganadora y a qué distancia. Sirve para saber si un desempate por tipo de
// edición (o leer el pie) arregla las atribuciones equivocadas.
//
//   dart run tool/spike_editions.dart <hashes.sqlite> <foto...>
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:sqlite3/sqlite3.dart';

void main(List<String> args) {
  final db = sqlite3.open(args.first, mode: OpenMode.readOnly);
  final rows = db.select('SELECT scryfall_id, oracle_id, name, set_code, '
      'collector_number, hash_h, hash_v FROM art_hashes');
  final hh = Int64List(rows.length);
  final vv = Int64List(rows.length);
  final entries = <HashEntry>[];
  for (var i = 0; i < rows.length; i++) {
    hh[i] = rows[i]['hash_h'] as int;
    vv[i] = rows[i]['hash_v'] as int;
    entries.add(HashEntry(
      scryfallId: rows[i]['scryfall_id'] as String,
      oracleId: rows[i]['oracle_id'] as String,
      name: rows[i]['name'] as String,
      setCode: (rows[i]['set_code'] as String?) ?? '',
      collectorNumber: (rows[i]['collector_number'] as String?) ?? '',
    ));
  }
  db.dispose();
  final index = HashIndex(hh, vv, entries);

  for (final path in args.skip(1)) {
    final decoded = img.decodeImage(File(path).readAsBytesSync())!;
    final rgb3 = decoded.convert(numChannels: 3);
    final photo = RgbImage(
        rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
    final detected = detectCard(photo);
    final sigs = artSignatures(
        detected.warped.pixels, detected.warped.width, detected.warped.height);
    final top = index.topMatches(sigs);
    if (top.isEmpty) {
      print('${path.split('/').last}: sin match');
      continue;
    }
    final oracle = top.first.entry.oracleId;
    final compiten = <(int, HashEntry)>[];
    for (var i = 0; i < entries.length; i++) {
      if (entries[i].oracleId != oracle) continue;
      var d = 999;
      for (final s in sigs) {
        final di = hamming64(s.h, hh[i]) + hamming64(s.v, vv[i]);
        if (di < d) d = di;
      }
      compiten.add((d, entries[i]));
    }
    compiten.sort((a, b) => a.$1.compareTo(b.$1));
    print('${path.split('/').last}  ->  ${top.first.entry.name}');
    for (final (d, e) in compiten.take(6)) {
      print('   $d  ${e.setCode.toUpperCase()} #${e.collectorNumber}');
    }
  }
}
