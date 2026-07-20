// Cámara en Linux vía GStreamer: troceo del flujo MJPEG, enumeración de
// dispositivos V4L2 y (si hay gst-launch) captura real con videotestsrc.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:manaforge_app/services/linux_camera.dart';

Uint8List _jpeg(List<int> payload) =>
    Uint8List.fromList([0xFF, 0xD8, ...payload, 0xFF, 0xD9]);

bool get _hasGst =>
    Process.runSync('which', ['gst-launch-1.0']).exitCode == 0;

void main() {
  group('MjpegSplitter', () {
    test('separa dos JPEGs concatenados', () {
      final a = _jpeg([1, 2, 3]);
      final b = _jpeg([4, 5]);
      final frames = MjpegSplitter().feed([...a, ...b]);
      expect(frames, hasLength(2));
      expect(frames[0], a);
      expect(frames[1], b);
    });

    test('aguanta frames partidos en trozos arbitrarios', () {
      final a = _jpeg([9, 8, 7, 6]);
      final b = _jpeg([5]);
      final all = [...a, ...b];
      final splitter = MjpegSplitter();
      final frames = <Uint8List>[];
      // trozos de 3 bytes: los marcadores caen partidos entre trozos
      for (var i = 0; i < all.length; i += 3) {
        frames.addAll(splitter.feed(
            all.sublist(i, i + 3 > all.length ? all.length : i + 3)));
      }
      expect(frames, hasLength(2));
      expect(frames[0], a);
      expect(frames[1], b);
    });

    test('ignora basura antes del primer SOI', () {
      final a = _jpeg([1]);
      final frames = MjpegSplitter().feed([0x00, 0x11, 0xFF, ...a]);
      expect(frames.single, a);
    });

    test('un 0xFF suelto dentro del payload no corta el frame', () {
      final a = _jpeg([0xFF, 0x00, 0xAA]); // byte stuffing típico de JPEG
      final frames = MjpegSplitter().feed(a);
      expect(frames.single, a);
    });
  });

  group('listVideoDevices', () {
    test('lee /sys/class/video4linux y resuelve nombre y /dev', () async {
      final tmp = await Directory.systemTemp.createTemp('v4l-test');
      addTearDown(() => tmp.delete(recursive: true));
      await Directory('${tmp.path}/video1').create();
      await File('${tmp.path}/video1/name').writeAsString('Cam B\n');
      await Directory('${tmp.path}/video0').create();
      await File('${tmp.path}/video0/name').writeAsString('Cam A\n');
      await Directory('${tmp.path}/otracosa').create();

      final devices = await listVideoDevices(sysDir: tmp.path);
      expect(devices.map((d) => d.path), ['/dev/video0', '/dev/video1']);
      expect(devices.map((d) => d.name), ['Cam A', 'Cam B']);
    });

    test('sin directorio (máquina sin V4L2) devuelve vacío', () async {
      expect(await listVideoDevices(sysDir: '/no/existe'), isEmpty);
    });
  });

  group('LinuxCamera', () {
    test('captura frames JPEG de un pipeline de prueba', () async {
      final cam = LinuxCamera();
      addTearDown(cam.dispose);
      await cam.start('testsrc', argsOverride: [
        '-q', 'videotestsrc', 'num-buffers=5', '!',
        'video/x-raw,width=64,height=64', '!', 'videoconvert', '!',
        'jpegenc', '!', 'fdsink', 'fd=1',
      ]);
      final frame = cam.latestJpeg!;
      expect(frame.sublist(0, 2), [0xFF, 0xD8]);
      expect(frame.sublist(frame.length - 2), [0xFF, 0xD9]);
    }, skip: !_hasGst ? 'sin gst-launch-1.0 en esta máquina' : false);

    test('sin cámaras, autoStart falla con mensaje claro', () async {
      await expectLater(
          LinuxCamera.autoStart(sysDir: '/no/existe'),
          throwsA(isA<CameraUnavailable>()));
    });
  });
}
