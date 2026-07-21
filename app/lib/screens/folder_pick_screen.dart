import 'package:flutter/material.dart';

import '../services/collection_store.dart';
import '../widgets/common.dart';
import 'collection_filters.dart';

/// Marcar qué cartas de TU colección entran en una carpeta, con los mismos
/// filtros y el mismo orden que la lista completa. Devuelve el conjunto de
/// oracleIds elegidos (o null si cancelas).
class FolderPickScreen extends StatefulWidget {
  final CollectionStore collection;
  final Set<String> initial;
  final String title;

  const FolderPickScreen({
    super.key,
    required this.collection,
    this.initial = const {},
    this.title = 'Elige las cartas',
  });

  @override
  State<FolderPickScreen> createState() => _FolderPickScreenState();
}

class _FolderPickScreenState extends State<FolderPickScreen> {
  late final Set<String> _picked = {...widget.initial};
  CollectionFilters _filters = const CollectionFilters();
  CollectionSort _sort = CollectionSort.recent;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<OwnedCard> get _visible {
    var cards = _filters.apply(widget.collection.cards);
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      cards = cards
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              (c.printedName ?? '').toLowerCase().contains(q))
          .toList();
    }
    return sortCollection(cards, _sort);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_picked),
            child: Text('Guardar (${_picked.length})'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Filtra por nombre…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 6),
                CollectionSortPicker(
                  value: _sort,
                  onChanged: (v) => setState(() => _sort = v),
                ),
                CollectionFilterBar(
                  value: _filters,
                  onChanged: (f) => setState(() => _filters = f),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${visible.length} cartas a la vista',
                        style: const TextStyle(fontSize: 11.5)),
                    const Spacer(),
                    TextButton(
                      onPressed: visible.isEmpty
                          ? null
                          : () => setState(() => _picked
                              .addAll(visible.map((c) => c.oracleId))),
                      child: const Text('Marcar todas'),
                    ),
                    TextButton(
                      onPressed: _picked.isEmpty
                          ? null
                          : () => setState(() => _picked.removeAll(
                              visible.map((c) => c.oracleId))),
                      child: const Text('Desmarcar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: visible.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Ninguna carta pasa estos filtros.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (context, i) {
                      final card = visible[i];
                      final on = _picked.contains(card.oracleId);
                      return CheckboxListTile(
                        value: on,
                        onChanged: (v) => setState(() => v == true
                            ? _picked.add(card.oracleId)
                            : _picked.remove(card.oracleId)),
                        controlAffinity: ListTileControlAffinity.trailing,
                        secondary: CardThumb(
                            url: card.imageSmall,
                            colors: card.colors,
                            name: card.name),
                        title: Text(card.printedName ?? card.name),
                        subtitle: Text(
                            '${card.qty} ${card.qty == 1 ? 'copia' : 'copias'}'
                            '${card.typeLine.isEmpty ? '' : ' · ${card.typeLine}'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
