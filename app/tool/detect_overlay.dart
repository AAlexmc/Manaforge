// Dibuja los cuadriláteros detectados sobre la foto y guarda un PNG para
// inspección visual.  dart run tool/detect_overlay.dart <img> <out.png>
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:manaforge_app/scanner/card_detector.dart';

void main(List<String> args) {
  final bytes = File(args[0]).readAsBytesSync();
  final decoded = img.decodeImage(bytes)!.convert(numChannels: 3);
  final photo = RgbImage(
      decoded.getBytes(order: img.ChannelOrder.rgb),
      decoded.width,
      decoded.height);
  final useGrid = args.length > 2 && args[2] == 'grid';
  final dets = useGrid ? detectCardGrid(photo) : detectCards(photo);
  final out = img.Image.from(decoded);
  final green = img.ColorRgb8(0, 255, 0);
  for (final d in dets) {
    final c = d.corners;
    for (var i = 0; i < 4; i++) {
      img.drawLine(out,
          x1: c[i].x.round(),
          y1: c[i].y.round(),
          x2: c[(i + 1) % 4].x.round(),
          y2: c[(i + 1) % 4].y.round(),
          color: green,
          thickness: 6);
    }
  }
  File(args[1]).writeAsBytesSync(img.encodePng(out));
  print('${dets.length} cartas → ${args[1]}');
}
