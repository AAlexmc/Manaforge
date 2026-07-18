import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../widgets/common.dart';
import 'import_csv_screen.dart';

/// Colección: primera pestaña. Estados: sin base de datos (descargar),
/// colección vacía (empezar), y colección viva (buscar/añadir/gestionar).
class ColeccionScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;

  const ColeccionScreen(
      {super.key, required this.db, required this.collection});

  @override
  State<ColeccionScreen> createState() => _ColeccionScreenState();
}

class _ColeccionScreenState extends State<ColeccionScreen> {
  bool? _dbReady;
  double? _downloadProgress;
  String? _error;
  final _searchCtrl = TextEditingController();
  List<CardHit> _results = const [];

  @override
  void initState() {
    super.initState();
    widget.collection.load();
    widget.db.isReady().then((ready) {
      if (mounted) setState(() => _dbReady = ready);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _download() async {
    setState(() {
      _downloadProgress = 0;
      _error = null;
    });
    try {
      await for (final p in widget.db.download()) {
        if (mounted) setState(() => _downloadProgress = p < 0 ? null : p);
      }
      if (mounted) {
        setState(() {
          _dbReady = true;
          _downloadProgress = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloadProgress = null;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _search(String query) async {
    try {
      final results = await widget.db.search(query);
      if (mounted) setState(() => _results = results);
    } catch (_) {
      // DB no disponible: sin resultados
    }
  }

  void _add(CardHit hit) {
    widget.collection.add(OwnedCard(
      oracleId: hit.oracleId,
      name: hit.name,
      printedName: hit.printedName,
      imageSmall: hit.imageSmall,
      imageNormal: hit.imageNormal,
      colors: hit.colors,
      qty: 1,
    ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✓ ${hit.printedName ?? hit.name}'),
      duration: const Duration(milliseconds: 900),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _dbReady == true
          ? FloatingActionButton.extended(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'El escáner llega en la siguiente versión — de momento busca o importa tu CSV.'))),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear'),
            )
          : null,
      body: SafeArea(
        child: _dbReady == null
            ? const Center(child: CircularProgressIndicator())
            : (_dbReady == false ? _buildNeedsDb() : _buildCollection()),
      ),
    );
  }

  /// Estado inicial: hay que descargar la base de datos de cartas.
  Widget _buildNeedsDb() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Colección',
              style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          Text('Tu colección empieza aquí',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Primero necesito la base de datos con todas las cartas de Magic '
            '(se descarga una vez y luego todo funciona sin internet).',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_downloadProgress != null) ...[
            LinearProgressIndicator(value: _downloadProgress),
            const SizedBox(height: 8),
            Text(
              'Descargando… ${((_downloadProgress ?? 0) * 100).toStringAsFixed(0)} %',
              textAlign: TextAlign.center,
            ),
          ] else
            FilledButton.icon(
              onPressed: _download,
              icon: const Icon(Icons.download),
              label: const Text('Descargar base de datos de cartas'),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
            ),
          const Spacer(),
          const Text(
            'Datos e imágenes por Scryfall · Sin cuentas, sin pagos: todo queda en tu dispositivo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Colección viva: cabecera + búsqueda + lista.
  Widget _buildCollection() {
    return ListenableBuilder(
      listenable: widget.collection,
      builder: (context, _) {
        final owned = widget.collection.cards;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Colección',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(
                        '${widget.collection.totalCopies} cartas · '
                        '${widget.collection.distinctCards} distintas'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchCtrl,
                      onChanged: _search,
                      decoration: InputDecoration(
                        hintText: 'Busca una carta (español o inglés)…',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          tooltip: 'Importar CSV de ManaBox',
                          icon: const Icon(Icons.file_upload_outlined),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImportCsvScreen(
                                  db: widget.db,
                                  collection: widget.collection),
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_results.isNotEmpty)
              SliverList.builder(
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  final hit = _results[i];
                  return ListTile(
                    leading: CardThumb(
                        url: hit.imageSmall,
                        colors: hit.colors,
                        name: hit.name),
                    title: Text(hit.printedName ?? hit.name),
                    subtitle: Text(
                        '${hit.typeLine} · ${hit.setCode.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _add(hit),
                    ),
                  );
                },
              )
            else if (owned.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Busca tu primera carta arriba, o importa tu colección '
                      'de ManaBox con el botón de la lupa.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              SliverList.builder(
                itemCount: owned.length,
                itemBuilder: (context, i) {
                  final card = owned[i];
                  return ListTile(
                    leading: CardThumb(
                        url: card.imageSmall,
                        colors: card.colors,
                        name: card.name),
                    title: Text(card.printedName ?? card.name),
                    subtitle: Text(card.name != (card.printedName ?? card.name)
                        ? card.name
                        : ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => widget.collection
                              .setQty(card.oracleId, card.qty - 1),
                        ),
                        Text('${card.qty}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => widget.collection
                              .setQty(card.oracleId, card.qty + 1),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        );
      },
    );
  }
}
