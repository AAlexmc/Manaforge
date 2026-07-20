import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../scanner/burst_controller.dart';
import '../scanner/scan_gate.dart';
import '../scanner/scan_tray.dart';
import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/scanner_database.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/scanner_db_gate.dart';
import '../widgets/set_lock.dart';
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

class _LiveScanScreenState extends State<LiveScanScreen> {
  CameraController? _camera;
  String? _cameraError;
  bool _starting = true;

  Timer? _timer;
  bool _busy = false; // hay una captura en proceso
  final _burst = BurstController();

  final ScanTray _tray = ScanTray();
  final Map<String, CardHit?> _hitCache = {}; // scryfallId -> carta
  int _sessionCount = 0;
  bool _flash = false; // fogonazo visual al reconocer
  String? _lastSeenName; // pie de estado ("viendo: …")

  /// Quick Mode (como ManaBox): ON = las cartas claras entran solas en la
  /// bandeja; las dudosas entran marcadas para revisar. OFF ("Con cuidado")
  /// = las claras entran solas, pero las dudosas se paran y te preguntan.
  bool _quickMode = true;

  /// En modo "con cuidado", una carta dudosa pendiente de que elijas cuál es.
  Recognition? _pending;

  /// Set bloqueado (escanear una caja entera); null = buscar en todas.
  String? _lockSet;

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
          index.topMatches(outcome.signatures, lockSet: _lockSet);
      final best = matches.isEmpty ? null : matches.first;
      final recognition = _burst.feed(matches);
      if (!mounted) return;
      setState(() {
        _lastSeenName = best != null && best.distance <= 30
            ? best.entry.name
            : null;
      });
      if (recognition != null) {
        await _onRecognition(recognition);
      }
    } catch (_) {
      // captura fallida (cámara ocupada, foto corrupta): al siguiente tick
    } finally {
      _busy = false;
    }
  }

  Future<void> _onRecognition(Recognition rec) async {
    await _precache(rec.candidates);
    if (!mounted) return;
    // Dudosa y en modo "con cuidado": parar y preguntar antes de añadir.
    if (rec.confidence == ScanConfidence.ambiguous && !_quickMode) {
      setState(() => _pending = rec);
      _feedback(soft: true);
      return;
    }
    _addToTray(rec);
  }

  void _addToTray(Recognition rec) {
    setState(() {
      _tray.add(rec);
      _flash = true;
    });
    _feedback(soft: rec.confidence == ScanConfidence.ambiguous);
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _flash = false);
    });
  }

  /// Precarga las fichas (imagen, nombre impreso) de unos candidatos.
  Future<void> _precache(List<ScanMatch> candidates) async {
    for (final m in candidates) {
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
  }

  void _feedback({bool soft = false}) {
    try {
      unawaited(SystemSound.play(
          soft ? SystemSoundType.click : SystemSoundType.alert));
    } catch (_) {/* sin sonido en esta plataforma */}
  }

  Future<void> _editLock() async {
    final result = await showSetLockDialog(context, _lockSet);
    if (result == null || !mounted) return; // cancelado
    setState(() => _lockSet = result.isEmpty ? null : result);
  }

  void _confirmAll() {
    var added = 0;
    for (final line in _tray.lines) {
      final entry = line.chosen.entry;
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
            qty: line.qty,
          ),
          qty: line.qty,
          printingKey: entry.printingKey,
        );
      } else {
        widget.collection.add(
          OwnedCard(
              oracleId: entry.oracleId,
              name: entry.name,
              colors: '',
              qty: line.qty),
          qty: line.qty,
          printingKey: entry.printingKey,
        );
      }
      added += line.qty;
    }
    setState(() {
      _sessionCount += added;
      _tray.clear();
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
          SetLockChip(lock: _lockSet, onTap: _editLock),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Tooltip(
                message: _quickMode
                    ? 'Rápido: las cartas claras entran solas; las dudosas, '
                        'marcadas para revisar.'
                    : 'Con cuidado: las dudosas se paran y te preguntan cuál es.',
                child: FilterChip(
                  avatar: Icon(_quickMode ? Icons.bolt : Icons.verified_user,
                      size: 16),
                  label: Text(_quickMode ? 'Rápido' : 'Con cuidado'),
                  selected: _quickMode,
                  visualDensity: VisualDensity.compact,
                  onSelected: (v) => setState(() => _quickMode = v),
                ),
              ),
            ),
          ),
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
              // guía de encuadre: coloca la carta dentro del marco (con un
              // poco de margen alrededor el detector la recorta mejor)
              IgnorePointer(
                child: Center(
                  child: FractionallySizedBox(
                    heightFactor: 0.82,
                    child: AspectRatio(
                      aspectRatio: 63 / 88, // proporción de una carta Magic
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.75),
                              width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
              // banner de revisión (modo "con cuidado", carta dudosa)
              if (_pending != null)
                Positioned(
                  left: 12,
                  right: 12,
                  top: 12,
                  child: _buildReviewBanner(_pending!),
                ),
            ],
          ),
        ),
        _buildTray(),
      ],
    );
  }

  /// Aviso tocable cuando una carta dudosa espera que elijas cuál es.
  Widget _buildReviewBanner(Recognition rec) {
    final entry = rec.best.entry;
    final hit = _hitCache[entry.scryfallId];
    return Material(
      color: MFColors.warning,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _resolvePending(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.help_outline, color: Colors.black87),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '¿Es ${hit?.printedName ?? entry.name}? No estoy seguro — '
                  'toca para elegir.',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }

  /// Resuelve la carta dudosa pendiente: abre el selector y la añade.
  Future<void> _resolvePending() async {
    final rec = _pending;
    if (rec == null) return;
    final line = TrayLine(rec.candidates, confidence: rec.confidence);
    final picked = await _pickVersion(line);
    if (!mounted) return;
    setState(() {
      if (picked != null) line.selected = picked;
      line.reviewed = true;
      _tray.lines.add(line);
      _pending = null;
    });
  }

  /// Bandeja de la sesión: cada carta reconocida se apunta aquí, agrupando
  /// las copias iguales en ×N; al terminar confirmas todas de un golpe.
  Widget _buildTray() {
    final lines = _tray.lines;
    if (lines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          _quickMode
              ? 'Pasa cartas por delante: las claras se apuntan solas aquí '
                  '(las copias iguales suman ×N). Las dudosas, marcadas para '
                  'revisar. Al terminar, confirmas todas.'
              : 'Pasa cartas por delante: las claras se apuntan solas; las '
                  'dudosas te preguntan cuál es. Al terminar, confirmas todas.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 124,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: lines.length,
            itemBuilder: (context, i) => _trayTile(lines[i]),
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
                  label: Text('Añadir ${_tray.totalQty} a la colección'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => setState(_tray.clear),
                child: const Text('Vaciar'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trayTile(TrayLine line) {
    final entry = line.chosen.entry;
    final hit = _hitCache[entry.scryfallId];
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () => _editLine(line),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 88,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: line.needsReview
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: MFColors.warning, width: 2))
                        : null,
                    child: CardThumb(
                        url: hit?.imageSmall,
                        colors: hit?.colors ?? '',
                        name: entry.name,
                        width: 50,
                        height: 70),
                  ),
                  // cantidad ×N
                  if (line.qty > 1)
                    Positioned(
                      left: -4,
                      bottom: -4,
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: MFColors.manaRed,
                        child: Text('×${line.qty}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // aviso de revisión
                  if (line.needsReview)
                    const Positioned(
                      left: -4,
                      top: -4,
                      child: Icon(Icons.help,
                          size: 18, color: MFColors.warning),
                    ),
                  // quitar
                  Positioned(
                    right: -4,
                    top: -4,
                    child: GestureDetector(
                      onTap: () => setState(() => _tray.remove(line)),
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
              const SizedBox(height: 6),
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
  }

  /// Editar una línea de la bandeja: cantidad + versión.
  Future<void> _editLine(TrayLine line) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) {
          final entry = line.chosen.entry;
          final hit = _hitCache[entry.scryfallId];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hit?.printedName ?? entry.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('${entry.setCode.toUpperCase()} '
                      '#${entry.collectorNumber}'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Cantidad'),
                      const Spacer(),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setSheet(() => _tray.setQty(line, line.qty - 1));
                          setState(() {});
                          if (!_tray.lines.contains(line)) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('${line.qty}',
                            style:
                                Theme.of(context).textTheme.titleLarge),
                      ),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setSheet(() => line.qty++);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('No es esta — cambiar versión'),
                    onPressed: () async {
                      final picked = await _pickVersion(line);
                      if (picked != null) {
                        setSheet(() {
                          line.selected = picked;
                          line.reviewed = true;
                        });
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Selector de versión entre los candidatos de una línea. Devuelve el
  /// índice elegido, o null si se cierra sin elegir.
  Future<int?> _pickVersion(TrayLine line) {
    return showModalBottomSheet<int>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('¿Cuál es?'),
            ),
            for (var c = 0; c < line.candidates.length; c++)
              ListTile(
                onTap: () => Navigator.of(context).pop(c),
                leading: CardThumb(
                    url: _hitCache[line.candidates[c].entry.scryfallId]
                        ?.imageSmall,
                    colors: _hitCache[line.candidates[c].entry.scryfallId]
                            ?.colors ??
                        '',
                    name: line.candidates[c].entry.name),
                title: Text(
                    _hitCache[line.candidates[c].entry.scryfallId]
                            ?.printedName ??
                        line.candidates[c].entry.name),
                subtitle: Text(
                    '${line.candidates[c].entry.setCode.toUpperCase()} '
                    '#${line.candidates[c].entry.collectorNumber}'),
                trailing: c == line.selected
                    ? const Icon(Icons.check_circle,
                        color: MFColors.success)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
