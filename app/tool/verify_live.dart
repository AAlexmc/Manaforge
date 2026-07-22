// ignore_for_file: avoid_print
// Qué haría el escáner EN VIVO con un frame concreto: si el detector
// encuentra carta, qué casa y si la puerta de vídeo lo deja pasar.
//
//   dart run tool/verify_live.dart <db.sqlite> <frame...>
//
// Sirve para comprobar los FALSOS POSITIVOS: un frame de mesa vacía debe
// salir "NO reconoce".
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:sqlite3/sqlite3.dart';

Future<HashIndex> _loadIndex(String path) async {
  final db = sqlite3.open(path, mode: OpenMode.readOnly);
  try {
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
    return HashIndex(hh, vv, entries);
  } finally {
    db.dispose();
  }
}

Future<void> main(List<String> args) async {
  final index = await _loadIndex(args.first);
  for (final path in args.skip(1).where((a) => !a.startsWith('--'))) {
    final decoded = img.decodeImage(File(path).readAsBytesSync())!;
    final rgb3 = decoded.convert(numChannels: 3);
    final photo = RgbImage(
        rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
    if (args.contains('--dim')) {
      // simula media luz: la misma escena peor iluminada
      for (var i = 0; i < photo.pixels.length; i++) {
        photo.pixels[i] = (photo.pixels[i] * 0.35).round();
      }
    }
    final detected = detectCard(photo);
    final sigs = artSignatures(
        detected.warped.pixels, detected.warped.width, detected.warped.height);
    final matches = index.topMatches(sigs);
    final likeness = cardLikeness(
        detected.warped.pixels, detected.warped.width, detected.warped.height);
    final live = decideLiveScan(matches,
        cardDetected: !detected.usedFallback,
        artDetail: likeness.artDetail,
        artMean: likeness.artMean);
    final top = matches.isEmpty ? null : matches.first;
    final w = detected.warped;
    print('${path.split('/').last}');
    print('  pinta de carta: ${cardLikeness(w.pixels, w.width, w.height)}');
    print('  detector: ${detected.usedFallback ? "SIN carta (encuadre "
        "entero)" : "carta encontrada"}');
    print('  mejor match: ${top == null ? "—" : "${top.distance} "
        "${top.entry.name} [${top.entry.setCode.toUpperCase()} "
        "#${top.entry.collectorNumber}]"}');
    for (final m in matches.skip(1)) {
      print('    otro: ${m.distance} ${m.entry.name} '
          '[${m.entry.setCode.toUpperCase()} #${m.entry.collectorNumber}]');
    }
    print('  foto (decideScan):  ${decideScan(matches).confidence.name}');
    print('  vivo (decideLiveScan): ${live.confidence.name}'
        '${live.confidence == ScanConfidence.none ? "  ← NO reconoce" : ""}');
  }
}
