// Dump de los perfiles de energía y bandas del detector de rejilla.
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';

void main(List<String> args) {
  final bytes = File(args[0]).readAsBytesSync();
  final decoded = img.decodeImage(bytes)!.convert(numChannels: 3);
  final photo = RgbImage(
      decoded.getBytes(order: img.ChannelOrder.rgb),
      decoded.width,
      decoded.height);
  final d = debugGridProfiles(photo);
  print('col profile (${d.colE.length}) min=${d.colMin.toStringAsFixed(0)} '
      'max=${d.colMax.toStringAsFixed(0)}');
  print('  col bands: ${d.colBands}');
  print('row profile (${d.rowE.length}) min=${d.rowMin.toStringAsFixed(0)} '
      'max=${d.rowMax.toStringAsFixed(0)}');
  print('  row bands: ${d.rowBands}');
  // ASCII sparkline del perfil de columnas (submuestreo a 80)
  print('  col: ${_spark(d.colE)}');
  print('  row: ${_spark(d.rowE)}');
}

String _spark(Float64List p) {
  const chars = ' .:-=+*#%@';
  var lo = p[0], hi = p[0];
  for (final v in p) {
    if (v < lo) lo = v;
    if (v > hi) hi = v;
  }
  final range = hi - lo < 1e-6 ? 1.0 : hi - lo;
  final sb = StringBuffer();
  const n = 90;
  for (var i = 0; i < n; i++) {
    final idx = (i * p.length / n).floor();
    final t = ((p[idx] - lo) / range * (chars.length - 1)).round();
    sb.write(chars[t]);
  }
  return sb.toString();
}
