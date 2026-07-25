import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/folder_store.dart';
import '../services/market_prefs.dart';
import '../services/price_series_database.dart';
import '../services/collection_cascade.dart';
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

  /// Opcionales: si vienen, las fichas de carta que se abran desde aquí dejan
  /// elegir mercado (Cardmarket, TCGplayer…) como el Mercado.
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  const AllCardsScreen(
      {super.key,
      required this.db,
      required this.collection,
      this.folders,
      this.market,
      this.prices});

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

  void _openDetail({required String oracleId,
      List<String>? siblings, int index = 0}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
        db: widget.db,
        collection: widget.collection,
        oracleId: oracleId,
        market: widget.market,
        prices: widget.prices,
        siblings: siblings,
        siblingIndex: index,
      ),
    ));
  }

  /// "Ya no tengo esta carta": la saca de la colección Y de todas las
  /// carpetas. Los mazos la conservan marcada — vender una carta no puede
  /// deshacerte un mazo.
  Future<void> _confirmarQueYaNoLaTienes(OwnedCard card) async {
    final t = tr(context);
    final folders = widget.folders;
    final enCarpetas = folders?.foldersContaining(card.oracleId) ?? 0;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.acForgetTitle(card.printedName ?? card.name)),
        content: Text([
          t.acForgetBody,
          if (enCarpetas > 0) t.acForgetFolders(enCarpetas),
          t.acForgetDecks,
        ].join('\n\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.acCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.acForgetConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    forgetCard(
        collection: widget.collection,
        folders: folders,
        oracleId: card.oracleId);
  }

  void _add(CardHit hit) {
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
      // sin esto, la carta añadida desde el buscador no tenía edición
      // conocida: valía 0 € para siempre y sin marcar el total como
      // aproximado (~). Y sin número de coleccionista, mejor NINGUNA clave
      // que una a medias ('lea|'): esa no casa precio nunca pero tampoco
      // marca el total como aproximado
      printingKey:
          hit.collectorNumber.isEmpty ? null : hit.printingKey,
    );
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
      parts.add(tr(context)
          .acAddedOn(addedLabel(tr(context), card.addedAt)));
    }
    final inFolders = widget.folders?.foldersContaining(card.oracleId) ?? 0;
    if (inFolders > 0) {
      parts.add(tr(context).acInFolders(inFolders));
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.colAllCards)),
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
                      Text(t.colValueLine(widget.collection.totalCopies,
                          widget.collection.distinctCards, '')),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _searchCtrl,
                        onChanged: _search,
                        decoration: InputDecoration(
                          hintText: t.acSearchHint,
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
                            t.acFilteredCount(owned.length, allOwned.length) +
                                (missingData ? t.acMissingFilterData : ''),
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
                      // se pasa la LISTA entera: dentro del visor se pasa a
                      // la siguiente sin cerrar
                      onTap: () => showCardZoomList(context,
                          index: i,
                          cards: [
                            for (final h in _results)
                              ZoomCard(
                                  name: h.printedName ?? h.name,
                                  imageUrl: h.imageNormal ?? h.imageSmall,
                                  colors: h.colors,
                                  onDetails: () => _openDetail(
                                      oracleId: h.oracleId,
                                      siblings: [
                                        for (final r in _results) r.oracleId
                                      ],
                                      index: _results.indexOf(h)))
                          ]),
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
                        _filters.any ? t.acNoneMatch : t.acEmptyHint,
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
                      onTap: () => showCardZoomList(context,
                          index: i,
                          cards: [
                            for (final c in owned)
                              ZoomCard(
                                  name: c.printedName ?? c.name,
                                  imageUrl: c.imageNormal ?? c.imageSmall,
                                  colors: c.colors,
                                  onDetails: () => _openDetail(
                                      oracleId: c.oracleId,
                                      siblings: [
                                        for (final o in owned) o.oracleId
                                      ],
                                      index: owned.indexOf(c)))
                          ]),
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
                            // bajar de 1 a 0 es "ya no tengo esta carta": eso
                            // se pregunta y arrastra las carpetas, no se hace
                            // en silencio con un toque de más
                            onPressed: () => card.qty > 1
                                ? widget.collection
                                    .setQty(card.oracleId, card.qty - 1)
                                : _confirmarQueYaNoLaTienes(card),
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
