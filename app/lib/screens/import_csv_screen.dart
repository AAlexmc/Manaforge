import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';

/// Importador de colección: pega el contenido del CSV de ManaBox (o Moxfield/
/// Archidekt con columnas Name/Quantity). Resuelve por Scryfall ID cuando
/// existe y por nombre si no; informa de las no reconocidas — nunca inventa.
class ImportCsvScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;

  const ImportCsvScreen(
      {super.key, required this.db, required this.collection});

  @override
  State<ImportCsvScreen> createState() => _ImportCsvScreenState();
}

class _ImportCsvScreenState extends State<ImportCsvScreen> {
  final _ctrl = TextEditingController();
  bool _working = false;
  ImportResult? _result;

  Future<void> _import() async {
    setState(() {
      _working = true;
      _result = null;
    });
    final rows = parseManaBoxCsv(_ctrl.text);
    var imported = 0;
    var copies = 0;
    final unrecognized = <String>[];
    for (final (name, scryfallId, qty) in rows) {
      CardHit? hit;
      try {
        if (scryfallId != null) {
          hit = await widget.db.byScryfallId(scryfallId);
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
      }
      if (hit == null) {
        unrecognized.add(name);
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
          qty: qty,
        ),
        qty: qty,
      );
      imported++;
      copies += qty;
    }
    if (mounted) {
      setState(() {
        _working = false;
        _result = ImportResult(imported, copies, unrecognized);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar colección')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                  'Pega aquí el contenido de tu CSV de ManaBox '
                  '(también vale Moxfield, Archidekt o cualquier CSV con '
                  'columnas Name y Quantity):'),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'Name,Set code,...,Quantity,...,Scryfall ID,...',
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
                  '${_result!.unrecognized.isEmpty ? '' : '\n✗ Sin reconocer: ${_result!.unrecognized.take(8).join(", ")}'
                      '${_result!.unrecognized.length > 8 ? '…' : ''}'}',
                ),
                const SizedBox(height: 8),
              ],
              FilledButton.icon(
                onPressed: _working ? null : _import,
                icon: _working
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.file_download_done),
                label: Text(_working ? 'Importando…' : 'Importar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
