// ignore_for_file: avoid_print
// Para cada celda de las 3 fotos de Ale: distancia y RANKING de la carta
// esperada (ground truth anotada a mano) frente al top-1 del índice.
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:sqlite3/sqlite3.dart';

const _photos = {
  '/home/ale/Downloads/WhatsApp Image 2026-07-20 at 22.18.46(2).jpeg': [
    'Gray Merchant of Asphodel', 'Cruel Feeding', 'Cruel Feeding',
    'Cruel Feeding', 'Cruel Feeding', 'Consuming Corruption',
    'Consuming Corruption', 'Consuming Corruption', 'Consuming Corruption',
  ],
  '/home/ale/Downloads/WhatsApp Image 2026-07-20 at 22.18.46(1).jpeg': [
    'Bastion Enforcer', 'Conviction', 'Spire Patrol',
    'Aether Inspector', 'Sram, Senior Edificer', '(token energía)',
    'Aerial Modification', 'Decommission', "Sram's Expertise",
  ],
  '/home/ale/Desktop/WhatsApp Image 2026-07-20 at 22.18.46.jpeg': [
    'Weldfast Engineer', 'Reckless Racer', 'Bloodshot Trainee',
    'Sabertooth Alley Cat', 'Subterranean Shambler', 'Goblin Skycutter',
    'Frostwielder', 'Incandescent Soulstoke', 'Courageous Goblin',
  ],
};

void main() {
  final db = sqlite3.open(
      '/home/ale/.local/share/com.example.manaforge/manaforge_hashes.sqlite',
      mode: OpenMode.readOnly);
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

  for (final e in _photos.entries) {
    print('════ ${e.key.split('/').last} ════');
    final decoded = img.decodeImage(File(e.key).readAsBytesSync())!;
    final rgb3 = decoded.convert(numChannels: 3);
    final photo = RgbImage(
        rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
    gridRefineTrace = <String>[];
    final cards = detectCardGrid(photo);
    final trace = gridRefineTrace!;
    for (var i = 0; i < cards.length; i++) {
      final expected = e.value[i];
      final w = cards[i].warped;
      final sigs = artSignatures(w.pixels, w.width, w.height);
      final alts = [
        for (final aw in cards[i].altWarps)
          artSignatures(aw.pixels, aw.width, aw.height, compact: true)
      ];
      // el grupo ganador con la MISMA regla que la app
      final (_, chosen) = index.bestGroupMatches(sigs, alts);
      final winner = chosen == -1 ? sigs : alts[chosen];
      // distancia mínima multi-recorte a CADA entrada, como topMatches
      final all = index.topMatches(winner, k: 200000);
      final top = all.first;
      var rank = -1;
      var dist = -1;
      for (var k = 0; k < all.length; k++) {
        if (all[k].entry.name == expected) {
          rank = k + 1;
          dist = all[k].distance;
          break;
        }
      }
      print('  celda $i [${trace.length > i ? trace[i] : "?"}'
          '${chosen == -1 ? "" : " alt$chosen"}]: '
          'esperada "$expected" rank=$rank dist=$dist | '
          'top1 ${top.entry.name} ${top.distance}');
    }
  }
}
