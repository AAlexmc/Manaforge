import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:image/image.dart' as img;

import 'package:manaforge_app/scanner/card_detector.dart';
import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/hit_cache.dart';
import 'package:manaforge_app/scanner/scan_gate.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/scanner/tray_commit.dart';
import 'package:manaforge_app/services/achievements_controller.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/folder_store.dart';
import 'package:manaforge_app/services/safe_input.dart';
import 'package:manaforge_app/services/scanner_database.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';
import 'package:manaforge_app/ui/scan/widgets/scanner_db_gate.dart';
import 'package:manaforge_app/ui/scan/widgets/set_lock.dart';
import 'package:manaforge_app/ui/scan/widgets/tray_list.dart';
import 'package:manaforge_app/ui/scan/scan_shared.dart';

/// Extensiones que se aceptan como foto: el picker de fichero solo enseña
/// estas, y arrastrar-y-soltar tiene que aplicar el MISMO filtro (si no,
/// soltar cualquier cosa la manda derecha al pipeline de reconocimiento).
const _photoExtensions = ['jpg', 'jpeg', 'png', 'webp', 'bmp'];

/// ¿Tiene [name] pinta de foto? Por extensión, igual que el picker.
bool looksLikePhotoFile(String name) {
  final lower = name.toLowerCase();
  return _photoExtensions.any((ext) => lower.endsWith('.$ext'));
}

/// Escáner de cartas, fase B: suelta una FOTO de una carta y ManaForge la
/// reconoce — detección de contornos, rectificación de perspectiva, huella
/// dHash del arte (la misma fórmula que scan-db) y matching por Hamming
/// contra las ~110k ilustraciones de la base de huellas. Top-3 candidatos,
/// confirmas, y va a la colección con su edición exacta.
class ScanScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final ScannerDatabase scanner;

  /// Opcional: si está, lo escaneado cuenta para los logros. Escanear por
  /// FOTO es el único camino cuando no hay cámara, así que tiene que contar
  /// igual que el escáner en vivo.
  final AchievementsController? achievements;

  /// Opcional: si está, se puede elegir carpeta para lo que entre. La carpeta
  /// es una ETIQUETA: las cartas van a la colección igual. Sin carpetas a
  /// mano, el selector no se enseña.
  final FolderStore? folders;

  /// Carpeta ya elegida al llegar aquí (viniendo del escáner en vivo, para no
  /// tener que volver a elegirla).
  final String? initialFolderId;

  const ScanScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.scanner,
      this.achievements,
      this.folders,
      this.initialFolderId});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

/// Resultado del pipeline pesado (corre en un isolate con compute()).
class ScanOutcome {
  /// Firmas multi-recorte del arte (la primera es la central): el matching
  /// se queda con la mejor por candidato, tolerando el error de esquinas.
  final List<DHashPair> signatures;
  final Uint8List artPng; // recorte del arte, para enseñarlo
  final bool usedFallback;

  /// Grupos de firmas de HIPÓTESIS de posición (celdas de rejilla donde la
  /// geometría no encontró la carta): el matching prueba cada grupo con
  /// [HashIndex.bestGroupMatches] y gana el que mejor casa.
  final List<List<DHashPair>> altSignatures;

  /// Detalle de la ventana del arte y su brillo medio: los usa el escaneo
  /// en vivo para no "reconocer" superficies lisas (ver [decideLiveScan]).
  final double artDetail;
  final double artMean;

  const ScanOutcome({
    required this.signatures,
    required this.artPng,
    required this.usedFallback,
    this.altSignatures = const [],
    this.artDetail = double.infinity,
    this.artMean = 0,
  });
}

/// Foto → carta → arte → firmas. Función de nivel superior para compute().
ScanOutcome? processScanPhoto(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final rgb3 = decoded.convert(numChannels: 3);
  final photo = RgbImage(
      rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
  return _outcomeFrom(detectCard(photo));
}

/// Foto → TODAS las cartas que haya. Prioridades:
///  1. Página de CARPETA (binder): rejilla regular ≥2×2 de cartas pegadas
///     → detector de rejilla (los contornos fusionan cartas contiguas).
///  2. Varias cartas sueltas sobre la mesa → detector multi por contornos.
///  3. Una carta → detector de una, con su fallback de imagen entera.
List<ScanOutcome> processScanPhotoAll(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return const [];
  final rgb3 = decoded.convert(numChannels: 3);
  final photo = RgbImage(
      rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
  final grid = detectCardGrid(photo);
  if (grid.length >= 4) return [for (final d in grid) _outcomeFrom(d)];
  final detected = detectCards(photo);
  if (detected.length > 1) return [for (final d in detected) _outcomeFrom(d)];
  return [_outcomeFrom(detectCard(photo))];
}

ScanOutcome _outcomeFrom(DetectedCard detected) {
  final warped = detected.warped;
  final likeness = cardLikeness(warped.pixels, warped.width, warped.height);
  final art = detected.artCrop;
  final artImage = img.Image.fromBytes(
      width: art.width,
      height: art.height,
      bytes: art.pixels.buffer,
      numChannels: 3,
      order: img.ChannelOrder.rgb);
  return ScanOutcome(
    signatures: artSignatures(warped.pixels, warped.width, warped.height),
    artPng: img.encodePng(artImage),
    usedFallback: detected.usedFallback,
    artDetail: likeness.artDetail,
    artMean: likeness.artMean,
    altSignatures: [
      for (final w in detected.altWarps)
        artSignatures(w.pixels, w.width, w.height, compact: true)
    ],
  );
}

/// Un candidato enriquecido con los datos de la carta (imagen, nombres).
class _Candidate {
  final ScanMatch match;
  final CardHit? hit; // null si la DB de cartas no conoce esa impresión

  const _Candidate(this.match, this.hit);
}

class _ScanScreenState extends State<ScanScreen> {
  String? _error;

  bool _processing = false;
  bool _dragging = false;
  ScanOutcome? _outcome;
  List<_Candidate> _candidates = const [];
  int _selected = 0;
  int _sessionCount = 0; // cartas añadidas en esta sesión de escaneo
  ScanConfidence _confidence = ScanConfidence.none;
  bool _showAll = false; // en un match claro, desplegar todas las opciones
  String? _lockSet; // set bloqueado (escanear una caja); null = todas
  String? _folderId; // carpeta que ADEMÁS se etiqueta; null = ninguna

  // Escaneo por lotes: varias fotos de golpe → bandeja para revisar y añadir.
  ScanTray? _batch;
  bool _batchProcessing = false;
  int _batchDone = 0;
  int _batchTotal = 0;
  final Map<String, CardHit?> _hitCache = {};

  @override
  void initState() {
    super.initState();
    _folderId = widget.initialFolderId;
  }

  CardFolder? get _folder => scanFolder(widget.folders, _folderId);

  Future<void> _pickFolder() async {
    final folders = widget.folders;
    if (folders == null) return;
    await pickScanFolder(
        context, folders, _folderId, (id) => setState(() => _folderId = id));
  }

  Future<void> _pickPhotos() async {
    final files = await openFiles(acceptedTypeGroups: [
      XTypeGroup(label: tr(context).scPhotos, extensions: _photoExtensions)
    ]);
    if (files.isEmpty) return;
    if (files.length == 1) {
      await _scanFile(files.first);
    } else {
      await _scanBatch(files);
    }
  }

  Future<void> _scanFile(XFile file) async {
    // el texto se coge ANTES del await: luego la pantalla puede estar muerta
    final mensajeFotoIlegible = tr(context).scBadImage;
    setState(() {
      _processing = true;
      _error = null;
      _outcome = null;
      _candidates = const [];
      _selected = 0;
      _confidence = ScanConfidence.none;
      _showAll = false;
    });
    try {
      // el tamaño se mira ANTES de leerlo: soltar un vídeo o una imagen de
      // disco enorme por error no debe cargarlo entero a memoria
      ensureScanFileSize(await file.length());
      final bytes = await file.readAsBytes();
      final outcomes = await compute(processScanPhotoAll, bytes);
      if (outcomes.isEmpty) {
        throw Exception(mensajeFotoIlegible);
      }
      if (outcomes.length > 1) {
        // una foto con VARIAS cartas (página de álbum): a la bandeja
        await _batchFromOutcomes(outcomes);
        return;
      }
      final outcome = outcomes.first;
      final index = await widget.scanner.loadIndex();
      final (matches, _) = index.bestGroupMatches(
          outcome.signatures, outcome.altSignatures,
          lockSet: _lockSet,
          ownedPrintings: widget.collection.printingQty.keys.toSet());
      final decision = decideScan(matches);
      final candidates = <_Candidate>[];
      for (final m in matches) {
        CardHit? hit;
        try {
          hit = await widget.db.byScryfallId(m.entry.scryfallId);
        } catch (_) {
          hit = null; // sin DB de cartas: candidato solo con nombre
        }
        candidates.add(_Candidate(m, hit));
      }
      if (mounted) {
        setState(() {
          _outcome = outcome;
          _candidates = candidates;
          _confidence = decision.confidence;
          _processing = false;
        });
      }
    } on InputRejected catch (e) {
      if (mounted) {
        final mensaje = inputRejectedText(tr(context), e);
        setState(() {
          _processing = false;
          _error = mensaje;
        });
        // el rechazo tiene que verse SIEMPRE: si ya hay una bandeja o
        // candidatos delante, el `_error` de _buildDropZone() no se pinta
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(mensaje),
          duration: const Duration(milliseconds: 1800),
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _processing = false;
          _error = e.toString();
        });
      }
    }
  }

  /// Añade UNA impresión a la colección (con su cantidad), con o sin ficha.
  /// [at] permite sellar todo un lote con el mismo instante.
  void _addOwned(HashEntry entry, CardHit? hit, int qty, {DateTime? at}) {
    final card = hit != null
        ? OwnedCard(
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
            qty: qty,
          )
        : OwnedCard(
            oracleId: entry.oracleId, name: entry.name, colors: '', qty: qty);
    widget.collection
        .add(card, qty: qty, printingKey: entry.printingKey, at: at);
  }

  Future<void> _precache(List<ScanMatch> matches) =>
      precacheHits(widget.db, _hitCache, matches);

  /// Una foto con varias cartas detectadas: montar la bandeja directamente.
  Future<void> _batchFromOutcomes(List<ScanOutcome> outcomes) async {
    final index = await widget.scanner.loadIndex();
    final perCard = <(List<ScanMatch>, Uint8List?)>[];
    for (final o in outcomes) {
      final (matches, _) = index.bestGroupMatches(o.signatures, o.altSignatures,
          lockSet: _lockSet,
          ownedPrintings: widget.collection.printingQty.keys.toSet());
      perCard.add((matches, o.artPng));
      await _precache(matches);
    }
    if (!mounted) return;
    setState(() {
      _processing = false;
      _batch = buildBatchTray(perCard);
      _batchProcessing = false;
      _batchDone = 0;
      _batchTotal = 0;
    });
  }

  /// Procesa VARIAS fotos: reconoce cada una y las junta en una bandeja para
  /// que revises y añadas las que quieras (agrupa copias iguales en ×N).
  Future<void> _scanBatch(List<XFile> files) async {
    setState(() {
      _error = null;
      _outcome = null;
      _candidates = const [];
      _confidence = ScanConfidence.none;
      _showAll = false;
      _batch = ScanTray();
      _batchProcessing = true;
      _batchDone = 0;
      _batchTotal = files.length;
    });
    try {
      final index = await widget.scanner.loadIndex();
      final perPhoto = <(List<ScanMatch>, Uint8List?)>[];
      // fotos que no llegan a entrar (demasiado grandes o ilegibles): se
      // cuentan para avisar al terminar, no desaparecen en silencio
      var saltadas = 0;
      for (final f in files) {
        try {
          // el tamaño se mira ANTES de leerla: una foto de más en el lote
          // no debe cargar a memoria un fichero enorme
          ensureScanFileSize(await f.length());
          final bytes = await f.readAsBytes();
          // cada foto puede traer VARIAS cartas (página de álbum)
          final outcomes = await compute(processScanPhotoAll, bytes);
          if (outcomes.isEmpty) saltadas++; // foto ilegible: ni una carta
          for (final outcome in outcomes) {
            final (matches, _) = index.bestGroupMatches(
                outcome.signatures, outcome.altSignatures,
                lockSet: _lockSet,
                ownedPrintings: widget.collection.printingQty.keys.toSet());
            perPhoto.add((matches, outcome.artPng));
            await _precache(matches);
          }
        } catch (_) {
          // una foto ilegible o demasiado grande no debe tumbar el lote
          // entero
          saltadas++;
        }
        if (!mounted) return;
        setState(() => _batchDone++);
      }
      // misma lógica testeada (gate + agrupación ×N) para lo que se ve
      if (mounted) {
        setState(() {
          _batch = buildBatchTray(perPhoto);
          _batchProcessing = false;
        });
        if (saltadas > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(tr(context).scSkipped(saltadas)),
            duration: const Duration(milliseconds: 2200),
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _batchProcessing = false;
          _error = e.toString();
        });
      }
    }
  }

  void _confirmBatch() {
    final tray = _batch;
    if (tray == null) return;
    final carpeta = _folder;
    // misma función que el escáner en vivo: una sola forma de meter bandeja
    final result = commitTray(
      tray: tray,
      collection: widget.collection,
      hitCache: _hitCache,
      folders: widget.folders,
      folderId: carpeta?.id,
    );
    final added = result.copies;
    widget.achievements?.recordScan(
        copies: added, distinct: result.distinct, perfect: result.clean);
    setState(() {
      _sessionCount += added;
      _batch = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr(context).lsAddedToCollection(added) +
          (carpeta == null ? '' : tr(context).lsAndToFolder(carpeta.name))),
      duration: const Duration(milliseconds: 1400),
    ));
  }

  void _confirmSelected() {
    if (_candidates.isEmpty) return;
    final c = _candidates[_selected];
    final entry = c.match.entry;
    _addOwned(entry, c.hit, 1);
    // misma regla que la bandeja: etiquetar DESPUÉS de guardar
    final carpeta = _folder;
    tagScanned(
        widget.folders, carpeta?.id, {c.hit?.oracleId ?? entry.oracleId});
    widget.achievements?.recordScan(copies: 1, distinct: 1);
    setState(() {
      _sessionCount++;
      _outcome = null;
      _candidates = const [];
      _confidence = ScanConfidence.none;
      _showAll = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(tr(context).scAddedOne(
              entry.name, entry.setCode.toUpperCase(), entry.collectorNumber) +
          (carpeta == null ? '' : tr(context).lsAndToFolder(carpeta.name))),
      duration: const Duration(milliseconds: 1200),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.tabScan),
        actions: [
          if (widget.folders != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Center(
                // escucha a las carpetas: si la elegida se borra en otra
                // pantalla, el chip no puede seguir enseñándola
                child: ListenableBuilder(
                  listenable: widget.folders!,
                  builder: (context, _) {
                    final carpeta = _folder;
                    return ActionChip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(
                          carpeta == null
                              ? Icons.folder_off_outlined
                              : Icons.folder,
                          size: 18),
                      label: Text(carpeta == null
                          ? t.scNoFolder
                          : t.scAlsoTo(carpeta.name)),
                      onPressed: _pickFolder,
                    );
                  },
                ),
              ),
            ),
          SetLockChip(lock: _lockSet, onTap: _editLock),
          if (_sessionCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Chip(
                  avatar: const Icon(Icons.check_circle,
                      size: 16, color: MFColors.success),
                  label: Text(t.lsThisSession(_sessionCount)),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: ScannerDbGate(
            scanner: widget.scanner, builder: (_) => _buildScanner()),
      ),
    );
  }

  Widget _buildScanner() {
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: (detail) {
        setState(() => _dragging = false);
        // mismo filtro que el picker: soltar cualquier cosa no la manda al
        // pipeline de reconocimiento
        final files =
            detail.files.where((f) => looksLikePhotoFile(f.name)).toList();
        // rechazo TOTAL o PARCIAL (2 fotos buenas + 1 .exe, p. ej.): se
        // avisa siempre, con SnackBar además del `_error` de la pantalla
        // vacía — ese `_error` no se pinta si ya hay bandeja o candidatos
        // delante
        if (files.length != detail.files.length) {
          setState(() => _error = tr(context).scBadImage);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(tr(context).scBadImage),
            duration: const Duration(milliseconds: 1800),
          ));
        }
        if (files.isEmpty) return;
        if (files.length == 1) {
          _scanFile(files.first);
        } else {
          _scanBatch(files);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _dragging
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_batch != null) return _buildBatch();
    if (_processing) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(tr(context).scLookingForCard),
          ],
        ),
      );
    }
    return _candidates.isNotEmpty ? _buildResults() : _buildDropZone();
  }

  /// Revisión del lote: mientras procesa muestra el progreso; al terminar,
  /// la lista de cartas reconocidas para quitar las que no quieras y añadir.
  Widget _buildBatch() {
    final t = tr(context);
    final tray = _batch!;
    final review = tray.lines.where((l) => l.needsReview).length;
    final unknown = tray.lines.where((l) => l.unrecognized).length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _batchProcessing
                          ? t.scRecognising(_batchDone, _batchTotal)
                          : t.scTrayCount(tray.lines.length, tray.totalQty),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (!_batchProcessing && review > 0)
                      Text(t.scToReview(review),
                          style: const TextStyle(
                              fontSize: 12.5, color: MFColors.warning)),
                    if (!_batchProcessing && unknown > 0)
                      Text(t.scUnknown(unknown),
                          style: TextStyle(
                              fontSize: 12.5,
                              color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
              if (_batchProcessing)
                const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5)),
            ],
          ),
        ),
        if (tray.lines.isEmpty && !_batchProcessing)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(t.scNothingRecognised, textAlign: TextAlign.center),
              ),
            ),
          )
        else
          Expanded(
            child: TrayList(
              tray: tray,
              hitCache: _hitCache,
              onEdit: _editBatchLine,
              onRemove: (l) => setState(() => tray.remove(l)),
              onQty: (l, q) => setState(() => tray.setQty(l, q)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _batchProcessing || tray.lines.isEmpty
                      ? null
                      : _confirmBatch,
                  icon: const Icon(Icons.playlist_add_check),
                  label: Text(t.scAddN(tray.totalQty)),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => setState(() => _batch = null),
                child: Text(t.acCancel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Tocar una fila del lote: elegir la versión correcta entre los candidatos.
  /// En una línea SIN reconocer, elegir un candidato a mano la convierte en
  /// reconocida (cuenta para "Añadir N").
  Future<void> _editBatchLine(TrayLine line) async {
    if (line.candidates.isEmpty) return; // sin apuestas: solo re-foto/borrar
    final picked = await _pickVersion(line);
    if (picked != null && mounted) {
      setState(() {
        line.selected = picked;
        line.reviewed = true;
        line.unrecognized = false;
      });
    }
  }

  Future<int?> _pickVersion(TrayLine line) =>
      pickScanVersion(context, line, _hitCache);

  Widget _buildDropZone() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_a_photo_outlined,
                size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(tr(context).scDropPhotos,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              tr(context).scDropExplain,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: _pickPhotos,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(tr(context).scPickPhotos),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }

  String _confidenceLabel(int distance) {
    final t = tr(context);
    if (distance <= 14) return t.scMatchHigh;
    if (distance <= 26) return t.scMatchMedium;
    return t.scMatchLow;
  }

  Future<void> _editLock() =>
      editScanLock(context, _lockSet, (v) => setState(() => _lockSet = v));

  void _reset() => setState(() {
        _outcome = null;
        _candidates = const [];
        _confidence = ScanConfidence.none;
        _showAll = false;
      });

  Widget _buildResults() {
    // Un ganador claro y sin desplegar → enseñar UNA carta, como ManaBox.
    if (_confidence == ScanConfidence.confident && !_showAll) {
      return _buildHero();
    }
    return _buildCandidateList();
  }

  /// Vista de UNA carta: el escáner está seguro. Confirmar con un toque.
  Widget _buildHero() {
    final best = _candidates.first;
    final entry = best.match.entry;
    final hit = best.hit;
    final img = hit?.imageNormal ?? hit?.imageSmall;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: img != null
                ? Image.network(img,
                    height: 340,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _heroArtFallback())
                : _heroArtFallback(),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Text(hit?.printedName ?? entry.name,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            '${entry.setCode.toUpperCase()} #${entry.collectorNumber}'
            '  ·  ${_confidenceLabel(best.match.distance)}',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _confirmSelected,
          icon: const Icon(Icons.add),
          label: Text(tr(context).scAddToCollection),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => setState(() => _showAll = true),
              icon: const Icon(Icons.unfold_more, size: 18),
              label: Text(tr(context).scSeeOptions),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(tr(context).scScanAnother),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroArtFallback() {
    final outcome = _outcome;
    return outcome != null
        ? Image.memory(outcome.artPng, height: 340, fit: BoxFit.contain)
        : const SizedBox(height: 340);
  }

  /// Lista de candidatos: hay duda (o el usuario pidió ver todas).
  Widget _buildCandidateList() {
    final outcome = _outcome;
    final unsure = _confidence == ScanConfidence.none;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            if (outcome != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(outcome.artPng,
                    width: 140, fit: BoxFit.contain),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(unsure ? tr(context).scNotSure : tr(context).scWhichIsIt,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    unsure
                        ? tr(context).scNoneQuiteFits
                        : outcome?.usedFallback == true
                            ? tr(context).scNoEdges
                            : tr(context).scCropped,
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _candidates.length; i++)
          Card(
            color: i == _selected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: ListTile(
              onTap: () => setState(() => _selected = i),
              leading: CardThumb(
                  url: _candidates[i].hit?.imageSmall,
                  colors: _candidates[i].hit?.colors ?? '',
                  name: _candidates[i].match.entry.name),
              title: Text(_candidates[i].hit?.printedName ??
                  _candidates[i].match.entry.name),
              subtitle:
                  Text('${_candidates[i].match.entry.setCode.toUpperCase()} '
                      '#${_candidates[i].match.entry.collectorNumber} · '
                      '${_confidenceLabel(_candidates[i].match.distance)}'),
              trailing: i == _selected
                  ? const Icon(Icons.check_circle, color: MFColors.success)
                  : const Icon(Icons.radio_button_unchecked),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _confirmSelected,
          icon: const Icon(Icons.add),
          label: Text(tr(context).scAddToCollection),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          label: Text(tr(context).scDiscard),
        ),
      ],
    );
  }
}
