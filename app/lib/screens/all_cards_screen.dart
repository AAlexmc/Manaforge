import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/folder_store.dart';
import '../widgets/common.dart';
import 'card_detail_screen.dart';
import 'collection_filters.dart';

/// La lista completa de la colección: buscar, añadir, filtrar, ordenar y
/// cambiar cantidades. Antes era lo primero que veías al entrar en Colección;
/// ahora la portada son las carpetas y esto vive tras el botón
/// "Todas las cartas".
class AllCardsScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final FolderStore? folders;

  const AllCardsScreen(
      {super.key, required this.db, required this.collection, this.folders});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen> {
  final _searchCtrl = TextEditingController();
  List<CardHit> _results = const [];
  CollectionFilters _filters = const CollectionFilters();

  /// Por defecto, lo recién escaneado arriba: es lo que acabas de hacer.
  CollectionSort _sort = CollectionSort.recent;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    try {
      final results = await widget.db.search(query);
      if (mounted) setState(() => _results = results);
    } catch (_) {
      // DB no disponible: sin resultados
    }
  }

  void _openDetail({required String oracleId}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
          db: widget.db, collection: widget.collection, oracleId: oracleId),
    ));
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

  /// Bajo el nombre: el nombre inglés si la carta es de otro idioma, cuándo
  /// entró (ordenando por recientes) y en qué carpetas está.
  String _subtitleFor(OwnedCard card) {
    final parts = <String>[];
    if (card.name != (card.printedName ?? card.name)) parts.add(card.name);
    // sin fecha (colección anterior a esta versión) no se dice nada: ya lo
    // cuenta la posición, y "añadida sin fecha" en 300 filas es ruido
    if (_sort == CollectionSort.recent && card.addedAt != null) {
      parts.add('añadida ${addedLabel(card.addedAt)}');
    }
    final inFolders = widget.folders?.foldersContaining(card.oracleId) ?? 0;
    if (inFolders > 0) {
      parts.add(inFolders == 1 ? 'en 1 carpeta' : 'en $inFolders carpetas');
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todas las cartas')),
      body: ListenableBuilder(
        listenable: Listenable.merge([widget.collection, widget.folders]),
        builder: (context, _) {
          final allOwned = widget.collection.cards;
          final owned = sortCollection(_filters.apply(allOwned), _sort);
          final missingData =
              _filters.any && allOwned.any((c) => c.typeLine.isEmpty);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.collection.totalCopies} cartas · '
                          '${widget.collection.distinctCards} distintas'),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _searchCtrl,
                        onChanged: _search,
                        decoration: InputDecoration(
                          hintText: 'Busca una carta (español o inglés)…',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CollectionSortPicker(
                        value: _sort,
                        onChanged: (v) => setState(() => _sort = v),
                      ),
                      CollectionFilterBar(
                        value: _filters,
                        onChanged: (f) => setState(() => _filters = f),
                      ),
                      if (_filters.any)
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
                          colors: hit.colors,
                          onDetails: () =>
                              _openDetail(oracleId: hit.oracleId)),
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
                        _filters.any
                            ? 'Ninguna carta pasa estos filtros.'
                            : 'Busca tu primera carta arriba, o vuelve atrás e '
                                'importa tu CSV de ManaBox.',
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
                          colors: card.colors,
                          onDetails: () =>
                              _openDetail(oracleId: card.oracleId)),
                      leading: CardThumb(
                          url: card.imageSmall,
                          colors: card.colors,
                          name: card.name),
                      title: Text(card.printedName ?? card.name),
                      subtitle: Text(_subtitleFor(card)),
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
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }
}
