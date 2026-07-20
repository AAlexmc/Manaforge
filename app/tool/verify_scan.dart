// ignore_for_file: avoid_print
// Verificación headless del pipeline del escáner con cartas REALES de
// Scryfall (no es un test de CI; se corre a mano con `dart run`).
//
//   dart run tool/verify_scan.dart
//
// Baja la base de huellas real (release scanner-db-latest), descarga la
// imagen `normal` de unas cuantas cartas conocidas y corre el pipeline
// completo (detector → dHash multi-recorte → topMatches → decideScan),
// imprimiendo la confianza y el top-3. Sirve para calibrar los umbrales del
// gate sobre datos reales.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hash_index.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:sqlite3/sqlite3.dart';

const _dbUrl =
    'https://github.com/AAlexmc/Manaforge/releases/download/scanner-db-latest/manaforge_hashes.sqlite.gz';

// Cartas de prueba: variadas y algunas MUY reimpresas (el caso difícil).
const _cards = [
  'Aegis Automaton', // el caso de la captura de Ale
  'Lightning Bolt',
  'Sol Ring',
  'Llanowar Elves',
  'Counterspell',
  'Swords to Plowshares',
];

Future<Uint8List> _get(String url) async {
  final client = HttpClient();
  try {
    final req = await client.getUrl(Uri.parse(url));
    req.headers.set('User-Agent', 'ManaForge-verify/1.0');
    req.headers.set('Accept', '*/*'); // Scryfall devuelve 400 sin Accept
    final resp = await req.close();
    if (resp.statusCode != 200) {
      throw 'HTTP ${resp.statusCode} en $url';
    }
    final b = <int>[];
    await for (final chunk in resp) {
      b.addAll(chunk);
    }
    return Uint8List.fromList(b);
  } finally {
    client.close();
  }
}

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

/// Pega la carta sobre un lienzo mayor con margen oscuro, para simular una
/// foto sobre una mesa (el detector necesita ver el borde de la carta contra
/// un fondo; una imagen borde-a-borde no le da contraste).
img.Image _onTable(img.Image card) {
  final m = (card.width * 0.14).round();
  final canvas = img.Image(
      width: card.width + 2 * m, height: card.height + 2 * m);
  img.fill(canvas, color: img.ColorRgb8(28, 26, 24));
  img.compositeImage(canvas, card, dstX: m, dstY: m);
  return canvas;
}

List<DHashPair> _signatures(Uint8List bytes, {bool pad = false}) {
  var decoded = img.decodeImage(bytes)!;
  if (pad) decoded = _onTable(decoded);
  final rgb3 = decoded.convert(numChannels: 3);
  final photo = RgbImage(
      rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
  final detected = detectCard(photo);
  final w = detected.warped;
  return artSignatures(w.pixels, w.width, w.height);
}

bool _pad = false;
String? _lock;

Future<void> main(List<String> args) async {
  _pad = args.contains('--pad');
  _lock = args
      .where((a) => a.startsWith('--lock='))
      .map((a) => a.substring(7).toLowerCase())
      .firstOrNull;
  args = args.where((a) => a != '--pad' && !a.startsWith('--lock=')).toList();
  // Si se pasa un path a una base ya descomprimida, se usa; si no, se baja.
  String dbPath;
  Directory? tmp;
  if (args.isNotEmpty && File(args.first).existsSync()) {
    dbPath = args.first;
  } else {
    tmp = Directory.systemTemp.createTempSync('mf_verify');
    final gz = File('${tmp.path}/db.sqlite.gz');
    dbPath = '${tmp.path}/db.sqlite';
    stdout.writeln('Bajando base de huellas…');
    gz.writeAsBytesSync(await _get(_dbUrl));
    File(dbPath).writeAsBytesSync(gzip.decode(gz.readAsBytesSync()));
  }
  stdout.writeln('Cargando índice…');
  final index = await _loadIndex(dbPath);
  print('${index.length} firmas.\n');

  // Modo ficheros locales: los args restantes son rutas de imágenes.
  final localFiles =
      args.skip(1).where((a) => File(a).existsSync()).toList();
  if (localFiles.isNotEmpty) {
    if (_lock != null) print('== set-lock: ${_lock!.toUpperCase()} ==\n');
    for (final path in localFiles) {
      final name = path.split('/').last;
      try {
        final sigs = _signatures(File(path).readAsBytesSync(), pad: _pad);
        final matches = index.topMatches(sigs, lockSet: _lock);
        final decision = decideScan(matches);
        print('▸ $name');
        print('   veredicto: ${decision.confidence.name}');
        for (final m in matches) {
          print('     ${m.distance.toString().padLeft(3)}  '
              '${m.entry.name}  (${m.entry.setCode.toUpperCase()} '
              '#${m.entry.collectorNumber})');
        }
        print('');
      } catch (e) {
        print('▸ $name  ERROR: $e\n');
      }
    }
    tmp?.deleteSync(recursive: true);
    return;
  }

  var ok = 0;
  for (final name in _cards) {
    try {
      final meta = jsonDecode(utf8.decode(await _get(
              'https://api.scryfall.com/cards/named?exact=${Uri.encodeQueryComponent(name)}')))
          as Map<String, dynamic>;
      final imgUrl = ((meta['image_uris'] as Map?)?['normal']) as String?;
      if (imgUrl == null) throw 'sin image_uris.normal';
      final bytes = await _get(imgUrl);
      final sigs = _signatures(bytes, pad: _pad);
      final matches = index.topMatches(sigs);
      final decision = decideScan(matches);
      final top = matches.isEmpty ? null : matches.first;
      final hit = top != null &&
          top.entry.name.toLowerCase() == name.toLowerCase();
      if (hit && decision.confidence == ScanConfidence.confident) ok++;
      print('▸ $name');
      print('   veredicto: ${decision.confidence.name}'
          '  ${hit ? "✓ top-1 correcto" : "✗ top-1 NO es la carta"}');
      for (final m in matches) {
        print('     ${m.distance.toString().padLeft(3)}  '
            '${m.entry.name}  (${m.entry.setCode.toUpperCase()} '
            '#${m.entry.collectorNumber})');
      }
      print('');
      await Future.delayed(const Duration(milliseconds: 120)); // amable con Scryfall
    } catch (e) {
      print('▸ $name  ERROR: $e\n');
    }
  }
  print('RESULTADO: $ok/${_cards.length} confident + correcto');
  tmp?.deleteSync(recursive: true);
}
