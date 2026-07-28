import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/collection_value.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/services/folder_value.dart';
import 'package:manaforge_app/services/market_prefs.dart';
import 'package:manaforge_app/services/price_series_database.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';
import 'package:manaforge_app/ui/collection/widgets/folder_tile.dart';
import 'package:manaforge_app/ui/collection/card_detail_screen.dart';
import 'package:manaforge_app/ui/collection/collection_filters.dart';
import 'package:manaforge_app/ui/collection/folder_pick_screen.dart';

/// Lo que se edita de una carpeta: nombre, color e icono.
typedef FolderLook = ({String name, int colorValue, String icon});

/// Diálogo de crear/editar carpeta. Devuelve null si cancelas.
Future<FolderLook?> showFolderEditor(
  BuildContext context, {
  CardFolder? folder,
}) {
  final t = tr(context);
  final ctrl = TextEditingController(text: folder?.name ?? '');
  var color = folder?.colorValue ?? kDefaultFolderColor;
  var icon = folder?.icon ?? 'folder';
  const palette = [
    kDefaultFolderColor,
    0xFFE05B5B,
    0xFF4CAF6E,
    0xFFE0A63C,
    0xFF9C6BE0,
    0xFF3CC5D6,
    0xFF8A8F98,
  ];
  return showDialog<FolderLook>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(folder == null ? t.fdNewFolder : t.fdEditFolder),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: ctrl,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: t.fdName,
                  hintText: t.fdNameHint,
                ),
              ),
              const SizedBox(height: 16),
              Text(t.fdColor, style: const TextStyle(fontSize: 12.5)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  for (final c in palette)
                    InkWell(
                      onTap: () => setState(() => color = c),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: color == c ? 3 : 1,
                            color: color == c
                                ? Colors.white
                                : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(t.fdIcon, style: const TextStyle(fontSize: 12.5)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final key in kFolderIcons)
                    IconButton(
                      isSelected: icon == key,
                      onPressed: () => setState(() => icon = key),
                      icon: Icon(folderIconFor(key)),
                      color: icon == key ? Color(color) : null,
                      style: IconButton.styleFrom(
                        backgroundColor: icon == key
                            ? Color(color).withValues(alpha: 0.16)
                            : null,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.acCancel),
          ),
          FilledButton(
            onPressed: () {
              final name = ctrl.text.trim();
              Navigator.of(context).pop((
                name: name.isEmpty ? t.fdDefaultName : name,
                colorValue: color,
                icon: icon,
              ));
            },
            child: Text(folder == null ? t.fdCreate : t.fdSave),
          ),
        ],
      ),
    ),
  );
}

/// Una carpeta por dentro: sus cartas (con los filtros de siempre), su valor,
/// y las acciones para editarla.
class FolderDetailScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final FolderStore folders;
  final String folderId;

  /// Opcionales: si vienen, las fichas de carta que se abran desde aquí dejan
  /// elegir mercado (Cardmarket, TCGplayer…) como el Mercado.
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  const FolderDetailScreen({
    super.key,
    required this.db,
    required this.collection,
    required this.folders,
    required this.folderId,
    this.market,
    this.prices,
  });

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  CollectionFilters _filters = const CollectionFilters();
  CollectionSort _sort = CollectionSort.alpha;
  CollectionValuation? _valuation;
  int _valuationToken = 0;
  bool _computing = false;
  bool _needsRecompute = false;

  @override
  void initState() {
    super.initState();
    widget.folders.addListener(_recompute);
    widget.collection.addListener(_recompute);
    _recompute();
  }

  @override
  void dispose() {
    widget.folders.removeListener(_recompute);
    widget.collection.removeListener(_recompute);
    super.dispose();
  }

  /// Igual que la portada: confirmar una bandeja de 20 cartas avisa 20
  /// veces, y sin esto salían 20 consultas a la base de precios a la vez.
  Future<void> _recompute() async {
    if (_computing) {
      _needsRecompute = true;
      return;
    }
    _computing = true;
    try {
      do {
        _needsRecompute = false;
        await _computeOnce();
      } while (_needsRecompute && mounted);
    } finally {
      _computing = false;
    }
  }

  Future<void> _computeOnce() async {
    final folder = widget.folders.byId(widget.folderId);
    if (folder == null) return;
    final token = ++_valuationToken;
    try {
      final v = await folderValue(
          folder: folder, collection: widget.collection, db: widget.db);
      // si mientras tanto ha cambiado algo, manda el cálculo más nuevo
      if (mounted && token == _valuationToken) {
        setState(() => _valuation = v);
      }
    } catch (_) {
      if (mounted && token == _valuationToken) {
        setState(() => _valuation = null); // sin base de cartas: sin precio
      }
    }
  }

  Future<void> _editCards(CardFolder folder) async {
    final picked = await Navigator.of(context).push<Set<String>>(
      MaterialPageRoute(
        builder: (_) => FolderPickScreen(
          collection: widget.collection,
          initial: folder.cardIds,
          title: folder.name,
        ),
      ),
    );
    if (picked != null) widget.folders.setCards(folder.id, picked);
  }

  Future<void> _editLook(CardFolder folder) async {
    final look = await showFolderEditor(context, folder: folder);
    if (look == null) return;
    widget.folders.edit(folder.id,
        name: look.name, colorValue: look.colorValue, icon: look.icon);
  }

  Future<void> _confirmDelete(CardFolder folder) async {
    final t = tr(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.fdDeleteTitle(folder.name)),
        content: Text(t.fdDeleteBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t.acCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(t.fdDelete)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    widget.folders.remove(folder.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return ListenableBuilder(
      listenable: Listenable.merge([widget.folders, widget.collection]),
      builder: (context, _) {
        final folder = widget.folders.byId(widget.folderId);
        if (folder == null) {
          // borrada desde otra pantalla: no dejar un esqueleto a medias
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(t.fdGone)),
          );
        }
        final owned = {for (final c in widget.collection.cards) c.oracleId};
        final missing = folder.missingIn(owned);
        final cards = sortCollection(
          _filters.apply(widget.collection.cards
              .where((c) => folder.cardIds.contains(c.oracleId))
              .toList()),
          _sort,
        );
        final color = Color(folder.colorValue);
        final inFolder = widget.collection.cards
            .where((c) => folder.cardIds.contains(c.oracleId))
            .toList();
        final copies = inFolder.fold(0, (a, c) => a + c.qty);
        final present = inFolder.length;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(folderIconFor(folder.icon), color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(folder.name, overflow: TextOverflow.ellipsis)),
              ],
            ),
            actions: [
              IconButton(
                tooltip: t.fdEditTooltip,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editLook(folder),
              ),
              IconButton(
                tooltip: t.fdDeleteTooltip,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(folder),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _editCards(folder),
            icon: const Icon(Icons.playlist_add),
            label: Text(t.fdAddRemove),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _valuation == null
                            ? '…'
                            : '${_valuation!.approximate ? '~' : ''}'
                                '${_valuation!.total.toStringAsFixed(2)} €',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: color, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        // cuentas de lo que TIENES en la carpeta, sin filtrar:
                        // el valor de arriba también es sin filtrar
                        t.fdCounts(present, copies) +
                            (cards.length != present
                                ? t.fdPassFilter(cards.length)
                                : '') +
                            (_valuation?.approximate == true
                                ? t.fdRoughValue
                                : ''),
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (missing.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.fdMissing(missing.length),
                                  style: const TextStyle(fontSize: 11.5),
                                ),
                              ),
                              TextButton(
                                onPressed: () => widget.folders
                                    .removeMissing(folder.id, owned),
                                child: Text(t.fdRemoveThem),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 4),
                      CollectionSortPicker(
                        value: _sort,
                        onChanged: (v) => setState(() => _sort = v),
                      ),
                      CollectionFilterBar(
                        value: _filters,
                        onChanged: (f) => setState(() => _filters = f),
                      ),
                    ],
                  ),
                ),
              ),
              if (cards.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        _filters.any ? t.fdNoneMatch : t.fdEmpty,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, i) {
                    final card = cards[i];
                    return ListTile(
                      // la carpeta entera, para pasar carta dentro del visor
                      onTap: () => showCardZoomList(context,
                          index: i,
                          cards: [
                            for (final c in cards)
                              ZoomCard(
                                  name: c.printedName ?? c.name,
                                  imageUrl: c.imageNormal ?? c.imageSmall,
                                  colors: c.colors,
                                  onDetails: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CardDetailScreen(
                                            db: widget.db,
                                            collection: widget.collection,
                                            oracleId: c.oracleId,
                                            market: widget.market,
                                            prices: widget.prices,
                                            siblings: [
                                              for (final x in cards)
                                                x.oracleId
                                            ],
                                            siblingIndex: cards.indexOf(c),
                                          ),
                                        ),
                                      ))
                          ]),
                      leading: CardThumb(
                          url: card.imageSmall,
                          colors: card.colors,
                          name: card.name),
                      title: Text(card.printedName ?? card.name),
                      subtitle: Text(t.fdCopies(card.qty) +
                          (card.typeLine.isEmpty
                              ? ''
                              : ' · ${card.typeLine}')),
                      trailing: IconButton(
                        tooltip: t.fdRemoveFromFolder,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            widget.folders.toggleCard(folder.id, card.oracleId),
                      ),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        );
      },
    );
  }
}
