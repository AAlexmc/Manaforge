import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../scanner/card_detector.dart';
import '../scanner/dhash.dart';
import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/scanner_database.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/scanner_db_gate.dart';

/// Escáner de cartas, fase B: suelta una FOTO de una carta y ManaForge la
/// reconoce — detección de contornos, rectificación de perspectiva, huella
/// dHash del arte (la misma fórmula que scan-db) y matching por Hamming
/// contra las ~110k ilustraciones de la base de huellas. Top-3 candidatos,
/// confirmas, y va a la colección con su edición exacta.
class ScanScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final ScannerDatabase scanner;

  const ScanScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.scanner});

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

  const ScanOutcome({
    required this.signatures,
    required this.artPng,
    required this.usedFallback,
  });
}

/// Foto → carta → arte → firmas. Función de nivel superior para compute().
ScanOutcome? processScanPhoto(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final rgb3 = decoded.convert(numChannels: 3);
  final photo = RgbImage(
      rgb3.getBytes(order: img.ChannelOrder.rgb), rgb3.width, rgb3.height);
  final detected = detectCard(photo);
  final warped = detected.warped;
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

  Future<void> _pickPhoto() async {
    const typeGroup = XTypeGroup(
        label: 'Fotos',
        extensions: ['jpg', 'jpeg', 'png', 'webp', 'bmp']);
    final file = await openFile(acceptedTypeGroups: const [typeGroup]);
    if (file != null) await _scanFile(file);
  }

  Future<void> _scanFile(XFile file) async {
    setState(() {
      _processing = true;
      _error = null;
      _outcome = null;
      _candidates = const [];
      _selected = 0;
    });
    try {
      final bytes = await file.readAsBytes();
      final outcome = await compute(processScanPhoto, bytes);
      if (outcome == null) {
        throw Exception('No pude leer esa imagen (¿es una foto válida?)');
      }
      final index = await widget.scanner.loadIndex();
      final matches = index.topMatches(outcome.signatures);
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
          _processing = false;
        });
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

  void _confirmSelected() {
    if (_candidates.isEmpty) return;
    final c = _candidates[_selected];
    final hit = c.hit;
    final entry = c.match.entry;
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
      // la DB de cartas no conoce la impresión: al menos nombre + edición
      widget.collection.add(
        OwnedCard(
          oracleId: entry.oracleId,
          name: entry.name,
          colors: '',
          qty: 1,
        ),
        printingKey: entry.printingKey,
      );
    }
    setState(() {
      _sessionCount++;
      _outcome = null;
      _candidates = const [];
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✓ ${entry.name} '
          '(${entry.setCode.toUpperCase()} #${entry.collectorNumber})'),
      duration: const Duration(milliseconds: 1200),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear'),
        actions: [
          if (_sessionCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Chip(
                  avatar: const Icon(Icons.check_circle,
                      size: 16, color: MFColors.success),
                  label: Text('$_sessionCount esta sesión'),
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
        if (detail.files.isNotEmpty) _scanFile(detail.files.first);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _dragging
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        child: _processing
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Buscando la carta en la foto…'),
                  ],
                ),
              )
            : (_candidates.isNotEmpty ? _buildResults() : _buildDropZone()),
      ),
    );
  }

  Widget _buildDropZone() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_a_photo_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Suelta aquí la foto de una carta',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Vale una foto del móvil o un escaneo: encuentro la carta, '
              'enderezo la perspectiva y comparo su arte con todas las '
              'ilustraciones de Magic.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Elegir foto'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }

  String _confidence(int distance) {
    if (distance <= 14) return 'coincidencia alta';
    if (distance <= 26) return 'coincidencia media';
    return 'coincidencia baja';
  }

  Widget _buildResults() {
    final outcome = _outcome;
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
                  Text('¿Cuál es?',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    outcome?.usedFallback == true
                        ? 'No vi los bordes de la carta, así que he usado la '
                            'imagen entera. Estos son los parecidos:'
                        : 'Esto es lo que he recortado. Los candidatos, por '
                            'parecido:',
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
              subtitle: Text(
                  '${_candidates[i].match.entry.setCode.toUpperCase()} '
                  '#${_candidates[i].match.entry.collectorNumber} · '
                  '${_confidence(_candidates[i].match.distance)}'),
              trailing: i == _selected
                  ? const Icon(Icons.check_circle, color: MFColors.success)
                  : const Icon(Icons.radio_button_unchecked),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _confirmSelected,
          icon: const Icon(Icons.add),
          label: const Text('Añadir a la colección'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            _outcome = null;
            _candidates = const [];
          }),
          icon: const Icon(Icons.refresh),
          label: const Text('Descartar y escanear otra'),
        ),
      ],
    );
  }
}
