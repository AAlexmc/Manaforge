/// Cámara en Linux sin plugin: el paquete `camera` no tiene implementación
/// de escritorio Linux, así que capturamos con GStreamer (gst-launch-1.0,
/// preinstalado en la mayoría de distros) — v4l2src → jpegenc → stdout — y
/// troceamos el flujo MJPEG en frames. El preview es un Image.memory que se
/// repinta con cada frame; el escáner usa el último JPEG recibido.
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

/// No hay cámara utilizable (sin dispositivos, sin GStreamer, o el
/// pipeline no arranca). El mensaje está pensado para enseñarlo tal cual.
class CameraUnavailable implements Exception {
  final String message;
  const CameraUnavailable(this.message);
  @override
  String toString() => message;
}

class VideoDevice {
  final String path; // /dev/videoN
  final String name; // nombre legible (de /sys)
  const VideoDevice(this.path, this.name);
}

/// Cámaras V4L2 presentes según /sys/class/video4linux (un UVC típico
/// expone video0=captura y video1=metadatos; se prueban en orden).
Future<List<VideoDevice>> listVideoDevices(
    {String sysDir = '/sys/class/video4linux'}) async {
  final dir = Directory(sysDir);
  if (!await dir.exists()) return const [];
  final devices = <VideoDevice>[];
  await for (final entry in dir.list()) {
    final base = entry.path.split('/').last;
    if (!base.startsWith('video')) continue;
    var name = base;
    try {
      name = (await File('${entry.path}/name').readAsString()).trim();
    } catch (_) {/* sin nombre en sysfs: se queda videoN */}
    devices.add(VideoDevice('/dev/$base', name));
  }
  devices.sort((a, b) => a.path.compareTo(b.path));
  return devices;
}

/// Trocea un flujo de JPEGs concatenados (MJPEG) en frames completos
/// SOI (FFD8) … EOI (FFD9). Aguanta marcadores partidos entre trozos.
class MjpegSplitter {
  Uint8List _pending = Uint8List(0);

  List<Uint8List> feed(List<int> chunk) {
    final data = Uint8List(_pending.length + chunk.length)
      ..setAll(0, _pending)
      ..setAll(_pending.length, chunk);
    final frames = <Uint8List>[];
    var from = 0;
    while (true) {
      final soi = _marker(data, 0xD8, from);
      if (soi < 0) {
        // sin SOI a la vista: conservar solo un posible 0xFF final partido
        _pending = data.isNotEmpty && data.last == 0xFF
            ? Uint8List.fromList([0xFF])
            : Uint8List(0);
        return frames;
      }
      final eoi = _marker(data, 0xD9, soi + 2);
      if (eoi < 0) {
        // frame a medias: guardar desde el SOI y esperar más datos
        _pending = Uint8List.fromList(data.sublist(soi));
        return frames;
      }
      frames.add(Uint8List.fromList(data.sublist(soi, eoi + 2)));
      from = eoi + 2;
    }
  }

  int _marker(Uint8List data, int second, int from) {
    for (var i = from; i + 1 < data.length; i++) {
      if (data[i] == 0xFF && data[i + 1] == second) return i;
    }
    return -1;
  }
}

class LinuxCamera {
  /// Último frame JPEG; el preview escucha aquí y se repinta.
  final ValueNotifier<Uint8List?> frame = ValueNotifier(null);

  Process? _proc;
  StreamSubscription<List<int>>? _sub;
  final _splitter = MjpegSplitter();

  Uint8List? get latestJpeg => frame.value;

  static List<String> _pipelineFor(String device) => [
        '-q', // sin -q, gst-launch escupe mensajes por el MISMO stdout
        'v4l2src', 'device=$device', '!',
        'videoconvert', '!', 'videorate', '!',
        'video/x-raw,framerate=10/1', '!',
        'jpegenc', 'quality=85', '!',
        'fdsink', 'fd=1',
      ];

  /// Arranca el pipeline y espera al primer frame (o falla con motivo).
  Future<void> start(String device, {List<String>? argsOverride}) async {
    final stderrBuf = StringBuffer();
    final Process proc;
    try {
      proc = await Process.start(
          'gst-launch-1.0', argsOverride ?? _pipelineFor(device));
    } on ProcessException {
      throw const CameraUnavailable(
          'GStreamer no está instalado. Instálalo con:\n'
          'sudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good');
    }
    _proc = proc;
    final first = Completer<void>();
    _sub = proc.stdout.listen((chunk) {
      for (final f in _splitter.feed(chunk)) {
        frame.value = f;
      }
      if (frame.value != null && !first.isCompleted) first.complete();
    });
    proc.stderr.transform(const SystemEncoding().decoder).listen(stderrBuf.write);
    unawaited(proc.exitCode.then((code) {
      if (!first.isCompleted) {
        first.completeError(CameraUnavailable(
            'La cámara $device no da imagen (gst-launch salió con $code).\n'
            '${stderrBuf.toString().trim()}'));
      }
    }));
    try {
      await first.future.timeout(const Duration(seconds: 6),
          onTimeout: () => throw CameraUnavailable(
              'La cámara $device no ha dado ningún frame en 6 s.'));
    } catch (_) {
      dispose();
      rethrow;
    }
  }

  /// Busca cámaras y arranca la primera que dé imagen.
  static Future<LinuxCamera> autoStart(
      {String sysDir = '/sys/class/video4linux'}) async {
    final devices = await listVideoDevices(sysDir: sysDir);
    if (devices.isEmpty) {
      throw const CameraUnavailable(
          'No encuentro ninguna cámara (/dev/video*). ¿Está conectada? '
          'Comprueba con `lsusb` que el sistema la ve.');
    }
    final errors = <String>[];
    for (final d in devices) {
      final cam = LinuxCamera();
      try {
        await cam.start(d.path);
        return cam;
      } on CameraUnavailable catch (e) {
        // los nodos de metadatos UVC fallan aquí: probar el siguiente
        errors.add('${d.path} (${d.name}): ${e.message}');
        cam.dispose();
      }
    }
    throw CameraUnavailable(
        'Ninguna cámara dio imagen:\n${errors.join('\n')}');
  }

  void dispose() {
    _sub?.cancel();
    _proc?.kill();
    _proc = null;
  }
}
