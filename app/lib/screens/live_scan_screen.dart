import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../scanner/burst_controller.dart';
import '../scanner/dhash.dart';
import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/scanner_database.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/scanner_db_gate.dart';
import 'scan_screen.dart';

/// Escáner en vivo, fase C: la webcam mira la mesa y ManaForge reconoce las
/// cartas que le pases por delante — modo ráfaga, sin tocar nada. Cada
/// reconocimiento suena, parpadea y entra en la cola de confirmación; al
/// final revisas la cola y añades todo de un golpe.
///
/// En Windows el plugin de cámara no da streaming de frames (issue #97542
/// de Flutter), así que capturamos fotos periódicamente: cada captura pasa
/// por el MISMO pipeline de la fase B (contornos → perspectiva → recorte
/// del arte → dHash → Hamming contra la base de huellas).
class LiveScanScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final ScannerDatabase scanner;

  const LiveScanScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.scanner});

  @override
  State<LiveScanScreen> createState() => _LiveScanScreenState();
}

/// Una carta esperando confirmación en la cola de la ráfaga.
class _QueuedCard {
  final List<ScanMatch> candidates;
  int selected = 0; // cuál de los candidatos es (editable en la cola)

  _QueuedCard(this.candidates);

  ScanMatch get chosen => candidates[selected];
}

class _LiveScanScreenState extends State<LiveScanScreen> {
  CameraController? _camera;
  String? _cameraError;
  bool _starting = true;

  Timer? _timer;
  bool _busy = false; // hay una captura en proceso
  final _burst = BurstController();

  final List<_QueuedCard> _queue = [];
  final Map<String, CardHit?> _hitCache = {}; // scryfallId -> carta
  int _sessionCount = 0;
  bool _flash = false; // fogonazo visual al reconocer
  String? _lastSeenName; // pie de estado ("viendo: …")

  /// Cada cuánto miramos la mesa (captura + reconocimiento).
  static const _period = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  Future<void> _startCamera() async {
    setState(() {
      _starting = true;
      _cameraError = null;
    });
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('sin_camara', 'No encuentro ninguna cámara.');
      }
      final controller = CameraController(cameras.first,
          ResolutionPreset.high,
          enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _starting = false;
      });
      _timer = Timer.periodic(_period, (_) => _tick());
    } catch (e) {
      if (mounted) {
        setState(() {
          _starting = false;
          _cameraError = e is CameraException
              ? (e.description ?? e.code)
              : e.toString();
        });
      }
    }
  }

  Future<void> _tick() async {
    final camera = _camera;
    if (camera == null || _busy || !camera.value.isInitialized) return;
    _busy = true;
    try {
      final shot = await camera.takePicture();
      final bytes = await shot.readAsBytes();
      final outcome = await compute(processScanPhoto, bytes);
      if (outcome == null || !mounted) return;
      final index = await widget.scanner.loadIndex();
      final matches =
          index.topMatches(DHashPair(outcome.hashH, outcome.hashV));
      final best = matches.isEmpty ? null : matches.first;
      final recognition = _burst.feed(matches);
      if (!mounted) return;
      setState(() {
        _lastSeenName = best != null && best.distance <= 30
            ? best.entry.name
            : null;
      });
      if (recognition != null) {
        await _enqueue(recognition);
      }
    } catch (_) {
      // captura fallida (cámara ocupada, foto corrupta): al siguiente tick
    } finally {
      _busy = false;
    }
  }

  Future<void> _enqueue(Recognition recognition) async {
    // feedback: sonido + fogonazo
    try {
      unawaited(SystemSound.play(SystemSoundType.alert));
    } catch (_) {/* sin sonido en esta plataforma */}
    // precargar las fichas de los candidatos (imagen, nombre impreso)
    for (final m in recognition.candidates) {
      if (!_hitCache.containsKey(m.entry.scryfallId)) {
        CardHit? hit;
        try {
          hit = await widget.db.byScryfallId(m.entry.scryfallId);
        } catch (_) {
          hit = null;
        }
        _hitCache[m.entry.scryfallId] = hit;
      }
    }
    if (!mounted) return;
    setState(() {
      _queue.add(_QueuedCard(recognition.candidates));
      _flash = true;
    });
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _flash = false);
    });
  }

  void _confirmAll() {
    var added = 0;
    for (final q in _queue) {
      final entry = q.chosen.entry;
      final hit = _hitCache[entry.scryfallId];
      if (hit != null) {
        widget.collection.add(
          OwnedCard(
            oracleId: hit.oracleId,
            name: hit.name,
            printedName: hit.printedName,
            imageSmall: hit.imageSmall,
            imageNormal: hit.imageNormal,
            colors: hit.colors,
            typeLine: hit.typeLine,
            cmc: hit.cmc,
            power: hit.power,
            toughness: hit.toughness,
            qty: 1,
          ),
          printingKey: entry.printingKey,
        );
      } else {
        widget.collection.add(
          OwnedCard(
              oracleId: entry.oracleId,
              name: entry.name,
              colors: '',
              qty: 1),
          printingKey: entry.printingKey,
        );
      }
      added++;
    }
    setState(() {
      _sessionCount += added;
      _queue.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✓ $added carta${added == 1 ? '' : 's'} a la colección'),
      duration: const Duration(milliseconds: 1400),
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear en vivo'),
        actions: [
          if (_sessionCount > 0)
            Center(
              child: Chip(
                avatar: const Icon(Icons.check_circle,
                    size: 16, color: MFColors.success),
                label: Text('$_sessionCount esta sesión'),
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            tooltip: 'Escanear una foto suelta',
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ScanScreen(
                    db: widget.db,
                    collection: widget.collection,
                    scanner: widget.scanner),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ScannerDbGate(
            scanner: widget.scanner, builder: (_) => _buildLive()),
      ),
    );
  }

  Widget _buildLive() {
    if (_starting) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Encendiendo la cámara…'),
          ],
        ),
      );
    }
    final camera = _camera;
    if (camera == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off_outlined, size: 56),
              const SizedBox(height: 12),
              Text('No puedo usar la cámara',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                _cameraError ?? 'Cámara no disponible.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _startCamera,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ScanScreen(
                            db: widget.db,
                            collection: widget.collection,
                            scanner: widget.scanner),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Escanear una foto'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(child: CameraPreview(camera)),
              // fogonazo al reconocer
              AnimatedOpacity(
                opacity: _flash ? 0.55 : 0.0,
                duration: const Duration(milliseconds: 120),
                child: const ColoredBox(color: Colors.white),
              ),
              // pie de estado: qué está viendo ahora mismo
              Positioned(
                left: 12,
                bottom: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    child: Text(
                      _lastSeenName == null
                          ? 'Pasa una carta por delante de la cámara…'
                          : 'Viendo: $_lastSeenName',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildQueue(),
      ],
    );
  }

  /// Cola de confirmación de la ráfaga.
  Widget _buildQueue() {
    if (_queue.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Modo ráfaga: cada carta reconocida se apunta aquí abajo; al '
          'terminar confirmas todas de un golpe.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _queue.length,
            itemBuilder: (context, i) {
              final q = _queue[i];
              final entry = q.chosen.entry;
              final hit = _hitCache[entry.scryfallId];
              return Padding(
                padding: const EdgeInsets.all(6),
                child: InkWell(
                  onTap: () => _editQueued(i),
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 84,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CardThumb(
                                url: hit?.imageSmall,
                                colors: hit?.colors ?? '',
                                name: entry.name,
                                width: 50,
                                height: 70),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _queue.removeAt(i)),
                                child: const CircleAvatar(
                                  radius: 9,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close,
                                      size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hit?.printedName ?? entry.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _confirmAll,
                  icon: const Icon(Icons.playlist_add_check),
                  label: Text('Añadir ${_queue.length} a la colección'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => setState(_queue.clear),
                child: const Text('Vaciar'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ¿No era esa? Elegir entre los top-3 candidatos de una carta en cola.
  Future<void> _editQueued(int i) async {
    final q = _queue[i];
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('¿Cuál es?'),
            ),
            for (var c = 0; c < q.candidates.length; c++)
              ListTile(
                onTap: () => Navigator.of(context).pop(c),
                leading: CardThumb(
                    url: _hitCache[q.candidates[c].entry.scryfallId]
                        ?.imageSmall,
                    colors: _hitCache[q.candidates[c].entry.scryfallId]
                            ?.colors ??
                        '',
                    name: q.candidates[c].entry.name),
                title: Text(
                    _hitCache[q.candidates[c].entry.scryfallId]
                            ?.printedName ??
                        q.candidates[c].entry.name),
                subtitle: Text(
                    '${q.candidates[c].entry.setCode.toUpperCase()} '
                    '#${q.candidates[c].entry.collectorNumber}'),
                trailing: c == q.selected
                    ? const Icon(Icons.check_circle,
                        color: MFColors.success)
                    : null,
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() => q.selected = picked);
    }
  }
}
