import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../l10n/t.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(inputRejectedText(tr(context), e))));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(context).icBadFile('$e'))));
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(context).icNotCsv)));
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
    // UN sello para todo el lote: si no, cada fila coge su propio instante
    // y la colección acaba ordenada al revés que el CSV
    final at = DateTime.now();
    var imported = 0;
    var copies = 0;
    var withPrice = 0;
    var tokensIgnored = 0;
    final unrecognized = <String>[];
    // todo el CSV dentro de UN lote: cada add() avisaba a todas las
    // pantallas vivas y cada una recalculaba su valoración contra la base
    // — por fila. Con el lote, un solo aviso (y guardado) al final.
    await widget.collection.importBatch(() async {
      if (_replace) widget.collection.clear();
      for (final row in rows) {
        final name = row.name;
        final qty = row.qty;
        final foil = row.foil;
        // cada pocas filas se cede el turno para que se pinte un frame: es
        // lo que convierte una ventana congelada en una barra que avanza
        if (_done % 25 == 0) {
          await Future<void>.delayed(Duration.zero);
          if (!mounted) return;
          setState(() {});
        }
        _done++;
        final (hit, exactPrinting) = await _resolve(name, row.scryfallId);
        if (hit == null) {
          if (looksLikeToken(name, row.setName)) {
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
          // reimportar NO re-sella lo que ya tenías: enterraría bajo
          // cientos de cartas viejas lo que acabas de escanear
          bump: false,
          // el precio de compra del CSV es lo único que la app no puede
          // deducir sola: sin él no hay P&L posible. Entra en la MISMA
          // llamada para no dar dos avisos por fila.
          paidPerCopy: row.purchasePrice,
          paidCurrency: row.currency,
        );
        if (row.purchasePrice != null) withPrice += qty;
        imported++;
        copies += qty;
      }
    });
    if (mounted) {
      setState(() {
        _working = false;
        _done = 0;
        _total = 0;
        _result = ImportResult(imported, copies, unrecognized,
            tokensIgnored: tokensIgnored, withPurchasePrice: withPrice);
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
    final t = tr(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.icTitle)),
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
                    Text(t.icExplain),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _working ? null : _pickFile,
                          icon: const Icon(Icons.folder_open),
                          label: Text(t.icPickFile),
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
                        t.icImported(_result!.imported, _result!.copies) +
                            (_result!.tokensIgnored == 0
                                ? ''
                                : t.icTokensIgnored(_result!.tokensIgnored)) +
                            (_result!.unrecognized.isEmpty
                                ? ''
                                : t.icUnrecognized(
                                    _result!.unrecognized.take(8).join(', '),
                                    _result!.unrecognized.length > 8
                                        ? '…'
                                        : '')) +
                            // decir cuántas traían precio de compra evita la
                            // duda de "¿por qué no me sale el P&L?"
                            (_result!.withPurchasePrice == 0
                                ? t.icNoPurchasePrice
                                : t.icWithPurchasePrice(
                                    _result!.withPurchasePrice)),
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
                      title: Text(t.icReplaceMine),
                      subtitle: Text(t.icReplaceWhy),
                    ),
                    const SizedBox(height: 4),
                    if (_working && _total > 0) ...[
                      LinearProgressIndicator(
                          value: _done / _total, minHeight: 6),
                      const SizedBox(height: 6),
                      Text(t.icImporting(_done, _total),
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
                      label: Text(_working ? t.icImporting2 : t.icImport),
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
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.file_download,
                                size: 48, color: MFColors.forge),
                            const SizedBox(height: 8),
                            Text(tr(context).icDropHere,
                                style: const TextStyle(
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
