// ignore_for_file: avoid_print
// Cuánto cuesta el matching con hipótesis por celda (el pipeline corre en
// el hilo de UI tras el spinner: interesa el coste por celda, no total).
//   dart run tool/time_match.dart <db.sqlite> <foto>
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:sqlite3/sqlite3.dart';

void main(List<String> args) {
  final db = sqlite3.open(args[0], mode: OpenMode.readOnly);
  final rows = db.select(
      'SELECT scryfall_id, oracle_id, name, set_code, collector_number, '
      'hash_h, hash_v FROM art_hashes');
  final hh = Int64List(rows.length);
  final vv = Int64List(rows.length);
  final entries = <HashEntry>[];
  for (var i = 0; i < rows.length; i++) {
    final r = rows[i];
    hh[i] = r['hash_h'] as int;
    vv[i] = r['hash_v'] as int;
    entries.add(HashEntry(
      scryfallId: r['scryfall_id'] as String,
      oracleId: r['oracle_id'] as String,
      name: r['name'] as String,
      setCode: (r['set_code'] as String?) ?? '',
      collectorNumber: (r['collector_number'] as String?) ?? '',
    ));
  }
  db.dispose();
  final index = HashIndex(hh, vv, entries);

  final decoded = img.decodeImage(File(args[1]).readAsBytesSync())!;
  final rgb3 = decoded.convert(numChannels: 3);
  final photo = RgbImage(
      rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);

  final tDetect = Stopwatch()..start();
  final cards = detectCardGrid(photo);
  tDetect.stop();
  print('detección rejilla: ${tDetect.elapsedMilliseconds} ms '
      '(${cards.length} celdas)');

  for (var i = 0; i < cards.length; i++) {
    final d = cards[i];
    final sw = Stopwatch()..start();
    final sigs =
        artSignatures(d.warped.pixels, d.warped.width, d.warped.height);
    final alts = [
      for (final aw in d.altWarps)
        artSignatures(aw.pixels, aw.width, aw.height, compact: true)
    ];
    final tSig = sw.elapsedMilliseconds;
    final (m, chosen) = index.bestGroupMatches(sigs, alts);
    sw.stop();
    print('  celda $i: ${d.altWarps.length} hipótesis · '
        'firmas ${tSig} ms · total ${sw.elapsedMilliseconds} ms · '
        'grupo ${chosen == -1 ? "primario" : "alt$chosen"} · '
        '${m.isEmpty ? "—" : "${m.first.distance} ${m.first.entry.name}"}');
  }
}
