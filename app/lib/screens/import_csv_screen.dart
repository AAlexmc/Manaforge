import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/safe_input.dart';
import '../theme/mf_theme.dart';

/// Importador de colección. Tres vías, de más cómoda a menos:
/// arrastrar el archivo CSV a la ventana, elegirlo con el botón, o pegar su
/// contenido a mano. Acepta ManaBox, Moxfield, Archidekt o cualquier CSV con
/// columnas Name/Quantity. Resuelve por Scryfall ID cuando existe y por
/// nombre si no; informa de las no reconocidas — nunca inventa.
class ImportCsvScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;

  /// Solo para tests: cómo se resuelve UNA fila del CSV a una carta. Por
  /// defecto se pregunta a la base descargada, que en CI no existe.
  /// Devuelve la carta y si la edición es la exacta (solo lo es cuando el CSV
  /// traía el Scryfall ID).
  final Future<(CardHit?, bool)> Function(String name, String? scryfallId)?
      resolver;

  const ImportCsvScreen(
      {super.key,
      required this.db,
      required this.collection,
      this.resolver});

  @override
  State<ImportCsvScreen> createState() => _ImportCsvScreenState();
}

class _ImportCsvScreenState extends State<ImportCsvScreen> {
  final _ctrl = TextEditingController();
  bool _working = false;

  /// Filas procesadas / totales del CSV en curso. La importación mira la base
  /// de cartas fila a fila y sqlite responde en el MISMO hilo, así que sin
  /// ceder el turno la ventana se queda congelada sin repintar: parecía
  /// colgada justo cuando más tarda (CSV de cientos de filas).
  int _done = 0;
  int _total = 0;
  bool _dragging = false;
  bool _replace = false;
  String? _loadedFileName;
  ImportResult? _result;

  /// Lee un archivo (soltado o elegido) y vuelca su contenido al editor.
  /// UTF-8 primero; si no decodifica, Latin-1 (exportaciones viejas de Excel).
  Future<void> _loadFile(XFile file) async {
    try {
      // el tamaño se mira ANTES de leerlo: soltar un vídeo por error cuelga
      // la app leyéndolo entero a memoria y metiéndolo en el cuadro de texto
      ensureImportFileSize(await file.length());
      final bytes = await file.readAsBytes();
      String content;
      try {
        content = utf8.decode(bytes);
      } on FormatException {
        content = latin1.decode(bytes);
      }
      if (!mounted) return;
      setState(() {
        _ctrl.text = content;
        _loadedFileName = file.name;
        _result = null;
      });
    } on InputRejected catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No pude leer el archivo: $e')));
    }
  }

  Future<void> _pickFile() async {
    const typeGroup = XTypeGroup(
      label: 'CSV',
      extensions: ['csv', 'txt', 'tsv'],
    );
    final file = await openFile(acceptedTypeGroups: const [typeGroup]);
    if (file != null) await _loadFile(file);
  }

  void _onDrop(DropDoneDetails detail) {
    if (detail.files.isEmpty) return;
    final file = detail.files.first;
    final name = file.name.toLowerCase();
    final looksText = name.endsWith('.csv') ||
        name.endsWith('.txt') ||
        name.endsWith('.tsv');
    if (!looksText) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Eso no parece un CSV — suelta un archivo .csv o .txt.')));
      return;
    }
    _loadFile(file);
  }

  Future<void> _import() async {
    setState(() {
      _working = true;
      _result = null;
    });
    final rows = parseManaBoxCsv(_ctrl.text);
    if (mounted) {
      setState(() {
        _done = 0;
        _total = rows.length;
      });
    }
    if (_replace) widget.collection.clear();
    // UN sello para todo el lote: si no, cada fila coge su propio instante
    // y la colección acaba ordenada al revés que el CSV
    final at = DateTime.now();
    var imported = 0;
    var copies = 0;
    var tokensIgnored = 0;
    final unrecognized = <String>[];
    for (final (name, scryfallId, qty, setName, foil) in rows) {
      // cada pocas filas se cede el turno para que se pinte un frame: es lo
      // que convierte una ventana congelada en una barra que avanza
      if (_done % 25 == 0) {
        await Future<void>.delayed(Duration.zero);
        if (!mounted) return;
        setState(() {});
      }
      _done++;
      final (hit, exactPrinting) = await _resolve(name, scryfallId);
      if (hit == null) {
        if (looksLikeToken(name, setName)) {
          tokensIgnored += qty;
        } else {
          unrecognized.add(name);
        }
        continue;
      }
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
          qty: qty,
        ),
        qty: qty,
        // solo si el CSV traía el Scryfall ID sabemos la edición exacta
        printingKey: exactPrinting ? hit.printingKey : null,
        foil: foil,
        at: at,
        // reimportar NO re-sella lo que ya tenías: enterraría bajo cientos
        // de cartas viejas lo que acabas de escanear
        bump: false,
      );
      imported++;
      copies += qty;
    }
    if (mounted) {
      setState(() {
        _working = false;
        _done = 0;
        _total = 0;
        _result = ImportResult(imported, copies, unrecognized,
            tokensIgnored: tokensIgnored);
      });
    }
  }

  /// Una fila del CSV -> carta de la base. Por Scryfall ID si el CSV lo trae
  /// (entonces se sabe la edición exacta), y si no por nombre exacto.
  Future<(CardHit?, bool)> _resolve(String name, String? scryfallId) async {
    final override = widget.resolver;
    if (override != null) return override(name, scryfallId);
    CardHit? hit;
    var exact = false;
    try {
      if (scryfallId != null) {
        hit = await widget.db.byScryfallId(scryfallId);
        exact = hit != null;
      }
      if (hit == null) {
        final results = await widget.db.search(name, limit: 1);
        if (results.isNotEmpty &&
            results.first.name.toLowerCase() == name.toLowerCase()) {
          hit = results.first;
        }
      }
    } catch (_) {
      hit = null;
      exact = false;
    }
    return (hit, exact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar colección')),
      body: SafeArea(
        child: DropTarget(
          onDragEntered: (_) => setState(() => _dragging = true),
          onDragExited: (_) => setState(() => _dragging = false),
          onDragDone: (detail) {
            setState(() => _dragging = false);
            _onDrop(detail);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                        'Arrastra aquí tu CSV de ManaBox (también vale '
                        'Moxfield, Archidekt o cualquier CSV con columnas '
                        'Name y Quantity), elígelo con el botón, o pega su '
                        'contenido a mano:'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _working ? null : _pickFile,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Elegir archivo…'),
                        ),
                        if (_loadedFileName != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '✓ $_loadedFileName',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: MFColors.success, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'monospace'),
                        decoration: InputDecoration(
                          hintText:
                              'Name,Set code,...,Quantity,...,Scryfall ID,...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_result != null) ...[
                      Text(
                        '✓ ${_result!.imported} cartas (${_result!.copies} copias) '
                        'añadidas a tu colección.'
                        '${_result!.tokensIgnored == 0 ? '' : '\n• ${_result!.tokensIgnored} tokens/emblemas ignorados (no van en mazos, todo bien).'}'
                        '${_result!.unrecognized.isEmpty ? '' : '\n✗ Sin reconocer: ${_result!.unrecognized.take(8).join(", ")}'
                            '${_result!.unrecognized.length > 8 ? '…' : ''}'}',
                      ),
                      const SizedBox(height: 8),
                    ],
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: _replace,
                      onChanged: _working
                          ? null
                          : (v) => setState(() => _replace = v),
                      title: const Text('Sustituir mi colección actual'),
                      subtitle: const Text(
                          'Actívalo al reimportar tu CSV completo: evita '
                          'duplicar cantidades y afina el álbum por ediciones.'),
                    ),
                    const SizedBox(height: 4),
                    if (_working && _total > 0) ...[
                      LinearProgressIndicator(
                          value: _done / _total, minHeight: 6),
                      const SizedBox(height: 6),
                      Text('Importando $_done de $_total cartas…',
                          style: const TextStyle(fontSize: 12.5)),
                      const SizedBox(height: 8),
                    ],
                    FilledButton.icon(
                      onPressed: _working ? null : _import,
                      icon: _working
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.file_download_done),
                      label: Text(_working ? 'Importando…' : 'Importar'),
                    ),
                  ],
                ),
              ),
              // Velo de "suelta aquí" mientras se arrastra un archivo encima.
              if (_dragging)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MFColors.forge.withValues(alpha: 0.12),
                        border: Border.all(color: MFColors.forge, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.file_download,
                                size: 48, color: MFColors.forge),
                            SizedBox(height: 8),
                            Text('Suelta tu CSV aquí',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: MFColors.forge)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
