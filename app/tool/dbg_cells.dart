// ignore_for_file: avoid_print
// Volcado de rechazos del refinado de celda sobre una foto de binder.
//   dart run tool/dbg_cells.dart <foto...>
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';

void main(List<String> args) {
  for (final path in args) {
    print('════ ${path.split('/').last} ════');
    final decoded = img.decodeImage(File(path).readAsBytesSync())!;
    final rgb3 = decoded.convert(numChannels: 3);
    final photo = RgbImage(
        rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
    debugCellRefine = true;
    detectCardGrid(photo);
    debugCellRefine = false;
  }
}
