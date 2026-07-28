import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:flutter/services.dart';

import 'package:manaforge_app/scanner/burst_controller.dart';
import 'package:manaforge_app/scanner/hit_cache.dart';
import 'package:manaforge_app/scanner/presence_gate.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/scanner/table_memory.dart';
import 'package:manaforge_app/scanner/tray_commit.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/data/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/data/services/linux_camera.dart';
import 'package:manaforge_app/data/services/scanner_database.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';
import 'package:manaforge_app/ui/scan/widgets/scanner_db_gate.dart';
import 'package:manaforge_app/ui/scan/widgets/session_tray.dart';
import 'package:manaforge_app/ui/scan/widgets/set_lock.dart';
import 'package:manaforge_app/ui/scan/scan_screen.dart';
import 'package:manaforge_app/ui/scan/scan_shared.dart';

/// Escáner en vivo, fase C: la webcam mira la mesa y ManaForge reconoce las
/// cartas que le pases por delante — sin tocar nada. Cada reconocimiento
/// suena, parpadea y entra en la cola de confirmación; al final revisas la
/// cola y añades todo de un golpe.
///
/// El muestreo continuo solo alimenta una PUERTA DE PRESENCIA barata
/// (miniaturas grises); el pipeline pesado de la fase B (contornos →
/// perspectiva → recorte del arte → dHash → Hamming) corre únicamente
/// cuando una carta se asienta delante de la cámara, con el frame ya
/// quieto (sin blur de movimiento). Quitar la carta rearma la puerta:
/// dos copias iguales seguidas cuentan como dos.
class LiveScanScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final ScannerDatabase scanner;

  /// Opcional: si está, el escaneo cuenta para los logros.
  final AchievementsController? achievements;

  /// Opcional: si están, se puede elegir carpeta para lo escaneado. Las cartas
  /// entran en la colección igual; la carpeta es una etiqueta de más.
  final FolderStore? folders;

  /// Keys del tour para los mandos de arriba. Solo las pone la pantalla que
  /// abre el TOUR (dos GlobalKey iguales montadas a la vez revientan).
  final Key? setKey;
  final Key? modoKey;
  final Key? fotoKey;

  const LiveScanScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.scanner,
      this.achievements,
      this.folders,
      this.setKey,
      this.modoKey,
      this.fotoKey});

  @override
  State<LiveScanScreen> createState() => _LiveScanScreenState();
}

class _LiveScanScreenState extends State<LiveScanScreen> {
  CameraController? _camera;
  LinuxCamera? _linuxCam; // en Linux el plugin `camera` no existe: GStreamer
  String? _cameraError;
  bool _starting = true;

  Timer? _timer;

  /// Hay una MUESTRA de presencia en marcha (miniatura barata).
  bool _sampling = false;

  /// Hay un RECONOCIMIENTO pesado en marcha. Va aparte de la muestra a
  /// propósito: mientras se reconoce (hasta ~1 s con reintentos) la puerta de
  /// presencia tiene que seguir mirando. Cuando compartían bandera, quitar la
  /// carta justo en ese hueco no lo veía nadie, la mesa nunca constaba vacía y
  /// la carta se quedaba clavada en "ya está en la mesa" para siempre.
  bool _recognizing = false;

  /// El pipeline pesado NO corre cada tick: la puerta de presencia mira
  /// miniaturas baratas y solo dispara el reconocimiento cuando pones una
  /// carta y se asienta (o la cambias). Quitarla rearma la puerta, así
  /// dos copias iguales seguidas cuentan como dos. Se ESTRENA en cada
  /// arranque de cámara: la línea base de una sesión anterior (otra
  /// exposición) dejaría la puerta creyendo que siempre hay carta.
  PresenceGate _gate = PresenceGate();

  /// Qué carta hay AHORA sobre la mesa. La puerta de presencia mira píxeles,
  /// así que una carta que se mueve un solo píxel (pasa una mano, se roza la
  /// mesa) le parece una carta nueva y volvía a sumarla: una carta olvidada
  /// bajo la cámara se contaba muchas veces. Quien decide si hay copia nueva
  /// es la IDENTIDAD de lo reconocido, no la puerta.
  final TableMemory _table = TableMemory();

  /// Última línea añadida a la bandeja: para el botón "+1 igual" (por si
  /// pasas otra copia y la puerta no llega a verte retirar la primera).
  TrayLine? _lastAdded;

  final ScanTray _tray = ScanTray();
  final Map<String, CardHit?> _hitCache = {}; // scryfallId -> carta
  int _sessionCount = 0;
  bool _flash = false; // fogonazo visual al reconocer
  String? _lastSeenName; // pie de estado ("viendo: …")

  /// Lo que se está viendo YA está apuntado en la mesa, así que no suma. Sin
  /// decirlo, el pie ponía solo "Viendo: X" y parecía que se había colgado.
  bool _alreadyOnTable = false;

  /// Por qué no se está reconociendo nada, cuando la puerta de presencia
  /// dispara pero no hay carta: sin esto los tres motivos (mesa vacía, mal
  /// encuadre, superficie lisa) decían lo mismo.
  String? _noCardHint;

  /// Quick Mode (como ManaBox): ON = las cartas claras entran solas en la
  /// bandeja; las dudosas entran marcadas para revisar. OFF ("Con cuidado")
  /// = las claras entran solas, pero las dudosas se paran y te preguntan.
  bool _quickMode = true;

  /// En modo "con cuidado", una carta dudosa pendiente de que elijas cuál es.
  Recognition? _pending;

  /// Set bloqueado (escanear una caja entera); null = buscar en todas.
  String? _lockSet;

  /// Carpeta a la que etiquetar lo de esta tanda; null = ninguna. Se mantiene
  /// entre tandas: si estás vaciando una caja entera, la eliges una vez.
  String? _folderId;

  /// Cuánto esperar antes de reintentar el reconocimiento: lo justo para que
  /// la cámara haya entregado un frame nuevo.
  Duration get _retryDelay => Platform.isLinux
      ? const Duration(milliseconds: 120)
      : const Duration(milliseconds: 300);

  /// Cada cuánto muestreamos la mesa (miniatura barata para la puerta de
  /// presencia; el reconocimiento solo corre cuando la puerta dispara).
  /// En Windows takePicture() es caro (foto real con obturador): más lento.
  Duration get _period => Platform.isLinux
      ? const Duration(milliseconds: 300)
      : const Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  Future<void> _startCamera() async {
    // Reintentar es reentrante: apagar lo que hubiera antes de arrancar otra
    // vez, que no queden dos timers/cámaras vivos.
    _timer?.cancel();
    _timer = null;
    _camera?.dispose();
    _camera = null;
    _stopLinuxCam();
    _gate = PresenceGate();
    _table.reset(); // sesión nueva: la mesa está vacía para nosotros
    setState(() {
      _starting = true;
      _cameraError = null;
    });
    if (Platform.isLinux) {
      try {
        final cam = await LinuxCamera.autoStart();
        if (!mounted) {
          cam.dispose();
          return;
        }
        cam.died.addListener(_onLinuxCamDied);
        setState(() {
          _linuxCam = cam;
          _starting = false;
        });
        _timer = Timer.periodic(_period, (_) => _tick());
      } catch (e) {
        if (mounted) {
          setState(() {
            _starting = false;
            _cameraError = e is CameraUnavailable
                ? cameraErrorText(tr(context), e)
                : e.toString();
          });
        }
      }
      return;
    }
    // el plugin `camera` no tiene implementación macOS: availableCameras()
    // lanzaría un MissingPluginException crudo a la cara del usuario (y el
    // tour empuja esta pantalla solo). Mensaje limpio y a la ruta de foto,
    // que en macOS sí funciona (file_selector + drag&drop)
    if (Platform.isMacOS) {
      setState(() {
        _starting = false;
        _cameraError = tr(context).lsMacUsePhoto;
      });
      return;
    }
    final sinCamara = tr(context).lsNoCamera;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('sin_camara', sinCamara);
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

  void _stopLinuxCam() {
    _linuxCam?.died.removeListener(_onLinuxCamDied);
    _linuxCam?.dispose();
    _linuxCam = null;
  }

  /// El pipeline gst murió a media sesión (cámara desenchufada): parar el
  /// tick y enseñar el error con su botón de Reintentar.
  void _onLinuxCamDied() {
    if (!mounted) return;
    _timer?.cancel();
    _timer = null;
    _stopLinuxCam();
    setState(() {
      _cameraError = tr(context).lsCameraGone;
    });
  }

  Future<void> _tick() async {
    final camera = _camera;
    final linux = _linuxCam;
    if (_sampling) return;
    if (linux == null &&
        (camera == null || !camera.value.isInitialized)) {
      return;
    }
    _sampling = true;
    try {
      final bytes = await _captureBytes();
      if (bytes == null || !mounted) return; // aún sin frame
      final thumb = await compute(presenceThumbFromJpeg, bytes);
      if (thumb == null || !mounted) return;
      final event = _gate.feed(thumb);
      // mesa vacía: hacia el olvido de lo que había encima (hacen falta
      // varios ticks seguidos, un parpadeo no vale)
      if (!_gate.cardPresent) _table.sawEmpty();
      switch (event) {
        case PresenceEvent.cardPlaced:
        case PresenceEvent.cardChanged:
          // el reconocimiento NO bloquea el muestreo: se lanza y el tick
          // siguiente vuelve a mirar la mesa
          if (!_recognizing) {
            _recognizing = true;
            unawaited(_recognizeSettled(bytes)
                .whenComplete(() => _recognizing = false));
          }
        case PresenceEvent.cardRemoved:
          // la puerta solo dice esto con la escena asentada y la mesa por
          // debajo del umbral: la carta ya NO está, olvidarla sin esperar más
          _table.reset();
          setState(() {
            _lastSeenName = null;
            _noCardHint = null;
            _alreadyOnTable = false;
          });
        case PresenceEvent.none:
          break;
      }
    } catch (_) {
      // captura fallida (cámara ocupada, foto corrupta): al siguiente tick
    } finally {
      _sampling = false;
    }
  }

  Future<Uint8List?> _captureBytes() async {
    final linux = _linuxCam;
    if (linux != null) return linux.latestJpeg;
    final shot = await _camera!.takePicture();
    // takePicture() deja el JPEG en el temporal del sistema (fuera de
    // Linux): sin borrarlo, cada foto de la mesa se queda ahí para siempre
    try {
      return await shot.readAsBytes();
    } finally {
      File(shot.path).delete().ignore();
    }
  }

  /// Una carta acaba de asentarse (o cambiar): hasta 3 intentos de
  /// reconocimiento — el primero con el frame que disparó la puerta, los
  /// siguientes con frames frescos por si el primero salió justo movido.
  Future<void> _recognizeSettled(Uint8List firstBytes) async {
    final index = await widget.scanner.loadIndex();
    Recognition? fallback; // mejor resultado ambiguo visto
    var bytes = firstBytes;
    var sinCarta = 0; // intentos seguidos en los que no había carta
    for (var attempt = 0; attempt < 3; attempt++) {
      if (attempt > 0) {
        // esperar solo a que llegue un frame NUEVO, no un tercio de
        // segundo: en Linux el pipeline de GStreamer va a 10 fps, así que
        // con ~120 ms ya hay imagen fresca. Eran 300 ms y con dos reintentos
        // se iban 600 ms de más en cada carta dudosa.
        await Future<void>.delayed(_retryDelay);
        if (!mounted) return;
        final fresh = await _captureBytes();
        if (fresh == null) break;
        bytes = fresh;
      }
      final outcome = await compute(processScanPhoto, bytes);
      if (!mounted) return;
      if (outcome == null) continue;
      final matches =
          index.topMatches(outcome.signatures,
              lockSet: _lockSet,
              // desempate: entre dos ediciones con el mismo arte gana la que
              // ya tienes, que es lo más probable con diferencia
              ownedPrintings: widget.collection.printingQty.keys.toSet());
      // usedFallback = el detector no encontró carta y hasheó el encuadre
      // entero: eso es la mesa, no una carta (ver decideLiveScan)
      final decision = decideLiveScan(matches,
          cardDetected: !outcome.usedFallback,
          artDetail: outcome.artDetail,
          artMean: outcome.artMean);
      if (decision.confidence == ScanConfidence.none) {
        // dos veces seguidas sin carta: no gastar más pipeline (cada
        // intento son ~230 ms de isolate) y decir POR QUÉ no se ve
        sinCarta++;
        setState(() => _lastSeenName = null);
        setState(() => _noCardHint = outcome.usedFallback
            ? tr(context).lsFrameCard
            : tr(context).lsNoCardThere);
        if (sinCarta >= 2) return;
        continue;
      }
      sinCarta = 0;
      setState(() {
        _lastSeenName = decision.best?.entry.name;
        _noCardHint = null;
      });
      if (decision.confidence == ScanConfidence.confident) {
        await _onRecognition(Recognition(matches, decision.confidence));
        return;
      }
      fallback = Recognition(matches, decision.confidence);
    }
    if (fallback != null && mounted) {
      // el pie decía "viendo X": que no se añada algo distinto de lo que
      // dice estar viendo
      setState(() => _lastSeenName = fallback!.best.entry.name);
      await _onRecognition(fallback);
    }
  }

  Future<void> _onRecognition(Recognition rec) async {
    // ¿es la misma carta que ya está en la mesa? Entonces no es una copia
    // nueva: la puerta ha re-disparado porque la escena se ha reasentado.
    // Ni se suma ni se pregunta.
    final key =
        '${rec.best.entry.oracleId}|${rec.best.entry.printingKey}';
    if (!_table.shouldCount(key)) {
      if (mounted) {
        setState(() {
          _lastSeenName = rec.best.entry.name;
          _alreadyOnTable = true;
        });
      }
      return;
    }
    if (mounted) setState(() => _alreadyOnTable = false);
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
      _lastAdded = _tray.add(rec);
      _flash = true;
    });
    _feedback(soft: rec.confidence == ScanConfidence.ambiguous);
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _flash = false);
    });
  }

  /// Precarga las fichas (imagen, nombre impreso) de unos candidatos.
  Future<void> _precache(List<ScanMatch> candidates) =>
      precacheHits(widget.db, _hitCache, candidates);

  void _feedback({bool soft = false}) {
    try {
      unawaited(SystemSound.play(
          soft ? SystemSoundType.click : SystemSoundType.alert));
    } catch (_) {/* sin sonido en esta plataforma */}
  }

  Future<void> _editLock() =>
      editScanLock(context, _lockSet, (v) => setState(() => _lockSet = v));

  void _confirmAll() {
    final carpeta = _folder;
    final result = commitTray(
      tray: _tray,
      collection: widget.collection,
      hitCache: _hitCache,
      folders: widget.folders,
      folderId: carpeta?.id,
    );
    widget.achievements?.recordScan(
        copies: result.copies,
        distinct: result.distinct,
        perfect: result.clean);
    setState(() {
      _sessionCount += result.copies;
      _tray.clear();
      _lastAdded = null;
    });
    final n = result.copies;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr(context).lsAddedToCollection(n) +
          (carpeta == null ? '' : tr(context).lsAndToFolder(carpeta.name))),
      duration: const Duration(milliseconds: 1400),
    ));
  }

  CardFolder? get _folder => scanFolder(widget.folders, _folderId);

  Future<void> _pickFolder() async {
    final folders = widget.folders;
    if (folders == null) return;
    await pickScanFolder(
        context, folders, _folderId, (id) => setState(() => _folderId = id));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _camera?.dispose();
    _stopLinuxCam();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.lsTitle),
        actions: [
          KeyedSubtree(
            key: widget.setKey,
            child: SetLockChip(lock: _lockSet, onTap: _editLock),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Tooltip(
                message: _quickMode ? t.lsQuickTip : t.lsCarefulTip,
                child: KeyedSubtree(
                  key: widget.modoKey,
                  child: FilterChip(
                    avatar: Icon(_quickMode ? Icons.bolt : Icons.verified_user,
                        size: 16),
                    label: Text(_quickMode ? t.lsQuick : t.lsCareful),
                    selected: _quickMode,
                    visualDensity: VisualDensity.compact,
                    onSelected: (v) => setState(() => _quickMode = v),
                  ),
                ),
              ),
            ),
          ),
          if (_sessionCount > 0)
            Center(
              child: Chip(
                avatar: const Icon(Icons.check_circle,
                    size: 16, color: MFColors.success),
                label: Text(t.lsThisSession(_sessionCount)),
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            key: widget.fotoKey,
            tooltip: t.lsScanPhotoTooltip,
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ScanScreen(
                    db: widget.db,
                    collection: widget.collection,
                    scanner: widget.scanner,
                    achievements: widget.achievements,
                    folders: widget.folders,
                    initialFolderId: _folderId),
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
    final t = tr(context);
    if (_starting) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(t.lsStartingCamera),
          ],
        ),
      );
    }
    final camera = _camera;
    final linux = _linuxCam;
    if (camera == null && linux == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off_outlined, size: 56),
              const SizedBox(height: 12),
              Text(t.lsCantUseCamera,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                _cameraError ?? t.lsCameraUnavailable,
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
                    label: Text(t.lsRetry),
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ScanScreen(
                            db: widget.db,
                            collection: widget.collection,
                            scanner: widget.scanner,
                            achievements: widget.achievements,
                            folders: widget.folders,
                            initialFolderId: _folderId),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(t.lsScanPhoto),
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
              Center(
                child: linux != null
                    ? _LinuxPreview(camera: linux)
                    : CameraPreview(camera!),
              ),
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
              // "+1 igual": otra copia de la última carta, por si pasas dos
              // iguales tan rápido que la puerta no ve el hueco entre ellas
              if (_lastAdded != null && _tray.lines.contains(_lastAdded))
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: ActionChip(
                    avatar: const Icon(Icons.control_point_duplicate,
                        size: 18),
                    label: Text(t.lsPlusOneSame(
                        _hitCache[_lastAdded!.chosen.entry.scryfallId]
                                ?.printedName ??
                            _lastAdded!.chosen.entry.name,
                        _lastAdded!.qty)),
                    onPressed: () {
                      setState(() => _lastAdded!.qty++);
                      _feedback(soft: true);
                    },
                  ),
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
                      _lastSeenName != null
                          ? (_alreadyOnTable
                              ? t.lsAlreadyOnTable(_lastSeenName!)
                              : t.lsSeeing(_lastSeenName!))
                          : _noCardHint ?? t.lsPassACard,
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
        SessionTray(
          tray: _tray,
          hitCache: _hitCache,
          quickMode: _quickMode,
          onEdit: _editLine,
          // borrar la ficha es decir "esta no la quiero": la memoria de mesa
          // tiene que soltarla o la carta queda bloqueada hasta reiniciar
          onRemove: (line) => setState(() {
            _tray.remove(line);
            _table.forget(line.key);
            _alreadyOnTable = false;
          }),
          onQty: (line, delta) => setState(() {
            final key = line.key;
            _tray.setQty(line, line.qty + delta);
            // bajar a 0 borra la línea: mismo trato que la X
            if (!_tray.lines.contains(line)) {
              _table.forget(key);
              _alreadyOnTable = false;
            }
          }),
          onTableKey: _table.onTable,
          folderName: _folder?.name,
          onPickFolder: widget.folders == null ? null : _pickFolder,
          onConfirm: _confirmAll,
          onClear: () => setState(() {
            _tray.clear();
            _table.reset(); // bandeja vacía a propósito: nada bloqueado
            _alreadyOnTable = false;
          }),
        ),
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
                  tr(context).lsIsThis(hit?.printedName ?? entry.name),
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
                      Text(tr(context).lsQuantity),
                      const Spacer(),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          final key = line.key;
                          setSheet(() => _tray.setQty(line, line.qty - 1));
                          setState(() {});
                          if (!_tray.lines.contains(line)) {
                            // se ha quedado en 0: la línea desaparece, así que
                            // la memoria de mesa tiene que soltar esa carta
                            setState(() {
                              _table.forget(key);
                              _alreadyOnTable = false;
                            });
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
                    label: Text(tr(context).lsNotThisOne),
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

  Future<int?> _pickVersion(TrayLine line) =>
      pickScanVersion(context, line, _hitCache);
}

/// Preview de la cámara Linux: repinta el último JPEG del pipeline GStreamer.
class _LinuxPreview extends StatelessWidget {
  final LinuxCamera camera;

  const _LinuxPreview({required this.camera});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: camera.frame,
      builder: (context, frame, _) => frame == null
          ? const Center(child: CircularProgressIndicator())
          : Image.memory(frame,
              gaplessPlayback: true, // sin parpadeo entre frames
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity),
    );
  }
}
