import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';

import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';
import 'package:manaforge_app/ui/collection/collection_filters.dart';

/// Marcar qué cartas de TU colección entran en una carpeta, con los mismos
/// filtros y el mismo orden que la lista completa. Devuelve el conjunto de
/// oracleIds elegidos (o null si cancelas).
class FolderPickScreen extends StatefulWidget {
  final CollectionStore collection;
  final Set<String> initial;
  /// Si no viene, "Elige las cartas" en el idioma de la app.
  final String? title;

  const FolderPickScreen({
    super.key,
    required this.collection,
    this.initial = const {},
    this.title,
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
    final t = tr(context);
    final visible = _visible;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? t.fpPickCards),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_picked),
            child: Text(t.fpSaveCount(_picked.length)),
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
                    hintText: t.fpFilterByName,
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
                    Text(t.fpVisibleCards(visible.length),
                        style: const TextStyle(fontSize: 11.5)),
                    const Spacer(),
                    TextButton(
                      onPressed: visible.isEmpty
                          ? null
                          : () => setState(() => _picked
                              .addAll(visible.map((c) => c.oracleId))),
                      child: Text(t.fpSelectAll),
                    ),
                    TextButton(
                      onPressed: _picked.isEmpty
                          ? null
                          : () => setState(() => _picked.removeAll(
                              visible.map((c) => c.oracleId))),
                      child: Text(t.fpUnselect),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        t.fpNoneMatch,
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
                            t.fdCopies(card.qty) +
                                (card.typeLine.isEmpty
                                    ? ''
                                    : ' · ${card.typeLine}'),
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
