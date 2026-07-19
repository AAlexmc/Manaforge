import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../widgets/common.dart';
import 'album_screen.dart';
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

  // Filtros de la colección
  final Set<String> _fColors = {}; // W U B R G · 'C' = incolora
  int? _fCmc; // null = cualquiera · 6 = 6+
  String? _fType;
  int? _fMinPower;
  int? _fMinToughness;

  bool get _anyFilter =>
      _fColors.isNotEmpty ||
      _fCmc != null ||
      _fType != null ||
      _fMinPower != null ||
      _fMinToughness != null;

  List<OwnedCard> _applyFilters(List<OwnedCard> cards) {
    if (!_anyFilter) return cards;
    return cards.where((c) {
      if (_fColors.isNotEmpty) {
        final colorless = c.colors.isEmpty;
        final matches = _fColors.any((f) =>
            f == 'C' ? colorless : c.colors.contains(f));
        if (!matches) return false;
      }
      if (_fCmc != null) {
        if (_fCmc == 6 ? c.cmc < 6 : c.cmc != _fCmc) return false;
      }
      if (_fType != null && !c.typeLine.contains(_fType!)) return false;
      if (_fMinPower != null && (c.power ?? -99) < _fMinPower!) return false;
      if (_fMinToughness != null && (c.toughness ?? -99) < _fMinToughness!) {
        return false;
      }
      return true;
    }).toList();
  }

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
      typeLine: hit.typeLine,
      cmc: hit.cmc,
      power: hit.power,
      toughness: hit.toughness,
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
        final allOwned = widget.collection.cards;
        final owned = _applyFilters(allOwned);
        final missingData =
            _anyFilter && allOwned.any((c) => c.typeLine.isEmpty);
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
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Álbum por expansiones',
                              icon: const Icon(Icons.auto_stories_outlined),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AlbumScreen(
                                      db: widget.db,
                                      collection: widget.collection),
                                ),
                              ),
                            ),
                            IconButton(
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
                          ],
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFilterBar(),
                    if (_anyFilter)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${owned.length} de ${allOwned.length} cartas'
                          '${missingData ? ' · algunas cartas antiguas no tienen datos de filtro: reimporta tu CSV con "Sustituir" activado' : ''}',
                          style: const TextStyle(fontSize: 11.5),
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
                    onTap: () => showCardZoom(context,
                        name: hit.printedName ?? hit.name,
                        imageUrl: hit.imageNormal ?? hit.imageSmall,
                        colors: hit.colors),
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
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      _anyFilter
                          ? 'Ninguna carta pasa estos filtros.'
                          : 'Busca tu primera carta arriba, o abre el importador '
                              'con el icono de subir (a la derecha del buscador) '
                              'y arrastra ahí tu CSV de ManaBox.',
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
                    onTap: () => showCardZoom(context,
                        name: card.printedName ?? card.name,
                        imageUrl: card.imageNormal ?? card.imageSmall,
                        colors: card.colors),
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

  static const _typeOptions = <String, String>{
    'Creature': 'Criaturas',
    'Instant': 'Instantáneos',
    'Sorcery': 'Conjuros',
    'Artifact': 'Artefactos',
    'Enchantment': 'Encantamientos',
    'Land': 'Tierras',
  };

  Widget _buildFilterBar() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final c in const ['W', 'U', 'B', 'R', 'G', 'C'])
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: CircleAvatar(
                radius: 6,
                backgroundColor:
                    c == 'C' ? Colors.blueGrey : manaColors[c]!),
            label: Text(c),
            selected: _fColors.contains(c),
            onSelected: (v) => setState(
                () => v ? _fColors.add(c) : _fColors.remove(c)),
          ),
        _dropdown<int?>(
          hint: 'Coste',
          value: _fCmc,
          items: {
            null: 'Coste: todos',
            for (var i = 0; i <= 5; i++) i: 'Coste $i',
            6: 'Coste 6+',
          },
          onChanged: (v) => setState(() => _fCmc = v),
        ),
        _dropdown<String?>(
          hint: 'Tipo',
          value: _fType,
          items: {null: 'Tipo: todos', ..._typeOptions},
          onChanged: (v) => setState(() => _fType = v),
        ),
        _dropdown<int?>(
          hint: 'Ataque',
          value: _fMinPower,
          items: {
            null: 'Ataque: todos',
            for (var i = 1; i <= 6; i++) i: 'Ataque ≥ $i',
          },
          onChanged: (v) => setState(() => _fMinPower = v),
        ),
        _dropdown<int?>(
          hint: 'Defensa',
          value: _fMinToughness,
          items: {
            null: 'Defensa: todos',
            for (var i = 1; i <= 6; i++) i: 'Defensa ≥ $i',
          },
          onChanged: (v) => setState(() => _fMinToughness = v),
        ),
        if (_anyFilter)
          TextButton.icon(
            onPressed: () => setState(() {
              _fColors.clear();
              _fCmc = null;
              _fType = null;
              _fMinPower = null;
              _fMinToughness = null;
            }),
            icon: const Icon(Icons.filter_alt_off, size: 16),
            label: const Text('Limpiar'),
          ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String hint,
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint, style: const TextStyle(fontSize: 12.5)),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontSize: 12.5),
        borderRadius: BorderRadius.circular(10),
        items: [
          for (final e in items.entries)
            DropdownMenuItem<T>(value: e.key, child: Text(e.value)),
        ],
        onChanged: (v) => onChanged(v as T),
      ),
    );
  }
}
