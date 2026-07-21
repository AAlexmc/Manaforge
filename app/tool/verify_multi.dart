// ignore_for_file: avoid_print
// Verificación headless del pipeline MULTI-carta (páginas de carpeta) con la
// base de huellas local y fotos reales. No es un test de CI.
//
//   dart run tool/verify_multi.dart <db.sqlite> [--dump=dir] [--lock=set] <fotos...>
//
// Corre exactamente lo que hace processScanPhotoAll (rejilla → contornos →
// una carta), y por cada celda: artSignatures → topMatches → decideScan.
// Con --dump guarda el warp y el recorte de arte de cada celda para
// inspección visual.
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
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

img.Image _toImg(RgbImage r) => img.Image.fromBytes(
    width: r.width,
    height: r.height,
    bytes: r.pixels.buffer,
    numChannels: 3,
    order: img.ChannelOrder.rgb);

Future<void> main(List<String> args) async {
  final dump = args
      .where((a) => a.startsWith('--dump='))
      .map((a) => a.substring(7))
      .firstOrNull;
  final lock = args
      .where((a) => a.startsWith('--lock='))
      .map((a) => a.substring(7).toLowerCase())
      .firstOrNull;
  args = args.where((a) => !a.startsWith('--')).toList();
  final dbPath = args.first;
  final index = await _loadIndex(dbPath);
  print('${index.length} firmas.\n');
  if (dump != null) Directory(dump).createSync(recursive: true);

  for (final path in args.skip(1)) {
    final name = path.split('/').last;
    print('════ $name ════');
    final decoded = img.decodeImage(File(path).readAsBytesSync())!;
    final rgb3 = decoded.convert(numChannels: 3);
    final photo = RgbImage(
        rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
    var cards = detectCardGrid(photo);
    var mode = 'rejilla';
    if (cards.length < 4) {
      cards = detectCards(photo);
      mode = 'contornos';
    }
    if (cards.length <= 1) {
      cards = [detectCard(photo)];
      mode = 'una carta';
    }
    print('modo: $mode, ${cards.length} cartas');
    final perCell = <(List<ScanMatch>, Uint8List?)>[];
    for (var i = 0; i < cards.length; i++) {
      final d = cards[i];
      final w = d.warped;
      final sigs = artSignatures(w.pixels, w.width, w.height);
      final alts = [
        for (final aw in d.altWarps)
          artSignatures(aw.pixels, aw.width, aw.height, compact: true)
      ];
      final (matches, _) = index.bestGroupMatches(sigs, alts, lockSet: lock);
      perCell.add((matches, null));
      final decision = decideScan(matches);
      final top = matches.isEmpty ? null : matches.first;
      print('  celda $i: ${decision.confidence.name.padRight(10)} '
          '${top == null ? "—" : "${top.distance.toString().padLeft(3)}  "
              "${top.entry.name} (${top.entry.setCode.toUpperCase()} "
              "#${top.entry.collectorNumber})"}');
      for (final m in matches.skip(1).take(2)) {
        print('           ${m.distance.toString().padLeft(3)}  '
            '${m.entry.name} (${m.entry.setCode.toUpperCase()} '
            '#${m.entry.collectorNumber})');
      }
      if (dump != null) {
        final base = '$dump/${name.replaceAll(RegExp(r"[^A-Za-z0-9]"), "_")}';
        File('${base}_c${i}_warp.png')
            .writeAsBytesSync(img.encodePng(_toImg(w)));
        File('${base}_c${i}_art.png')
            .writeAsBytesSync(img.encodePng(_toImg(d.artCrop)));
      }
    }
    // lo que vería Ale en la bandeja (misma función que la app)
    final tray = buildBatchTray(perCell);
    print('  bandeja: ${tray.lines.length} líneas · '
        '${tray.totalQty} para añadir · '
        '${tray.lines.where((l) => l.unrecognized).length} sin reconocer · '
        '${tray.lines.where((l) => l.needsReview).length} a revisar');
    for (final l in tray.lines) {
      print('    ${l.unrecognized ? "SIN RECONOCER" : "${l.chosen.entry.name}"
          " x${l.qty}${l.needsReview ? " (revisar)" : ""}"}');
    }
    print('');
  }
}
