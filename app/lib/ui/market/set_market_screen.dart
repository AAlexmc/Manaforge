import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/market_prefs.dart';
import 'package:manaforge_app/services/markets.dart';
import 'package:manaforge_app/services/price_series_database.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';
import 'package:manaforge_app/ui/core/widgets/market_picker.dart';
import 'package:manaforge_app/ui/collection/card_detail_screen.dart';

/// Mercado de una expansión: todas sus cartas con precio, con filtros
/// (nombre, rareza, color, solo las tuyas) y ordenación por precio.
class SetMarketScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final SetBanner set;

  /// Si vienen, se puede cambiar de mercado y los precios de CADA carta de
  /// la expansión pasan a ese mercado.
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  const SetMarketScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.set,
      this.market,
      this.prices});

  @override
  State<SetMarketScreen> createState() => _SetMarketScreenState();
}

enum _Sort { priceDesc, priceAsc, number, name }

class _SetMarketScreenState extends State<SetMarketScreen> {
  List<SetCardPrice>? _cards;
  String? _error;

  String _query = '';
  String? _rarity;
  final Set<String> _colors = {};
  bool _onlyMine = false;
  _Sort _sort = _Sort.priceDesc;

    static const _rarityKeys = ['mythic', 'rare', 'uncommon', 'common'];

  String _rarityLabel(AppLocalizations t, String key) => switch (key) {
        'mythic' => t.smMythic,
        'rare' => t.smRare,
        'uncommon' => t.smUncommon,
        _ => t.smCommon,
      };

  Market get _market => widget.market?.market ?? Market.cardmarket;

  @override
  void initState() {
    super.initState();
    _loadCards();
    widget.market?.addListener(_loadCards);
  }

  @override
  void dispose() {
    widget.market?.removeListener(_loadCards);
    super.dispose();
  }

  /// Los precios se piden PARA el mercado elegido: cambiarlo recarga la
  /// lista entera (es una consulta a la base local, va sobrada).
  void _loadCards() {
    widget.db
        .setCardsWithPrices(widget.set.code, market: _market)
        .then((cards) {
      if (mounted) setState(() => _cards = cards);
    }).catchError((e) {
      if (mounted) setState(() => _error = '$e');
    });
  }

  List<SetCardPrice> _visible() {
    final qtyByOracle = widget.collection.qtyByOracle;
    var list = List<SetCardPrice>.from(_cards ?? const []);
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              (c.printedName ?? '').toLowerCase().contains(q))
          .toList();
    }
    if (_rarity != null) {
      list = list.where((c) => c.rarity == _rarity).toList();
    }
    if (_colors.isNotEmpty) {
      list = list.where((c) {
        final colorless = c.colors.isEmpty;
        return _colors
            .any((f) => f == 'C' ? colorless : c.colors.contains(f));
      }).toList();
    }
    if (_onlyMine) {
      list =
          list.where((c) => (qtyByOracle[c.oracleId] ?? 0) > 0).toList();
    }
    int byNumber(SetCardPrice a, SetCardPrice b) {
      final na = int.tryParse(a.collectorNumber) ?? 9999;
      final nb = int.tryParse(b.collectorNumber) ?? 9999;
      final cmp = na.compareTo(nb);
      return cmp != 0
          ? cmp
          : a.collectorNumber.compareTo(b.collectorNumber);
    }

    switch (_sort) {
      case _Sort.priceDesc:
        list.sort(
            (a, b) => (b.price ?? -1).compareTo(a.price ?? -1));
      case _Sort.priceAsc:
        list.sort((a, b) =>
            (a.price ?? 1e9).compareTo(b.price ?? 1e9));
      case _Sort.number:
        list.sort(byNumber);
      case _Sort.name:
        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  String _euro(double? v) => v == null ? '—' : formatMoney(v, _market);

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    final cards = _cards;
    final visible = _visible();
    final totalValue = visible.fold<double>(
        0, (a, c) => a + (c.price ?? 0));
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.set.name} · ${widget.set.code.toUpperCase()}'),
      ),
      body: cards == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                                    : Text(t.smLoadFailed('$_error')),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: t.smSearchInSet,
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final c in const ['W', 'U', 'B', 'R', 'G', 'C'])
                        FilterChip(
                          visualDensity: VisualDensity.compact,
                          avatar: CircleAvatar(
                              radius: 5,
                              backgroundColor: c == 'C'
                                  ? Colors.blueGrey
                                  : manaColors[c]!),
                          label: Text(c,
                              style: const TextStyle(fontSize: 11)),
                          selected: _colors.contains(c),
                          onSelected: (v) => setState(() =>
                              v ? _colors.add(c) : _colors.remove(c)),
                        ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _rarity,
                          hint: Text(t.smRarityAll,
                              style: const TextStyle(fontSize: 12)),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12),
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            DropdownMenuItem(
                                value: null,
                                child: Text(t.smRarityAll)),
                            for (final k in _rarityKeys)
                              DropdownMenuItem(
                                  value: k, child: Text(_rarityLabel(t, k))),
                          ],
                          onChanged: (v) =>
                              setState(() => _rarity = v),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<_Sort>(
                          value: _sort,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12),
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            DropdownMenuItem(
                                value: _Sort.priceDesc,
                                child: Text(t.smPriceDown)),
                            DropdownMenuItem(
                                value: _Sort.priceAsc,
                                child: Text(t.smPriceUp)),
                            DropdownMenuItem(
                                value: _Sort.number,
                                child: Text(t.smNumber)),
                            DropdownMenuItem(
                                value: _Sort.name,
                                child: Text(tr(context).albSortName)),
                          ],
                          onChanged: (v) =>
                              setState(() => _sort = v ?? _Sort.priceDesc),
                        ),
                      ),
                      FilterChip(
                        visualDensity: VisualDensity.compact,
                        label: Text(t.smOnlyMine,
                            style: const TextStyle(fontSize: 11)),
                        selected: _onlyMine,
                        onSelected: (v) =>
                            setState(() => _onlyMine = v),
                      ),
                    ],
                  ),
                ),
                if (widget.market != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                    child: MarketPicker(
                        preference: widget.market!,
                        available: widget.prices?.markets ?? const {}),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(t.smCardsCount(visible.length),
                          style: const TextStyle(fontSize: 11.5)),
                      const Spacer(),
                      Text(
                          _market.todayColumn == null
                              ? t.smNoPerPrinting(_market.label)
                              : t.smListedValue(_market.label) +
                                  _euro(totalValue),
                          style: const TextStyle(fontSize: 11.5)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: widget.collection,
                    builder: (context, _) {
                      final qtyByOracle = widget.collection.qtyByOracle;
                      return ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: visible.length,
                        itemBuilder: (context, i) {
                          final card = visible[i];
                          final owned =
                              qtyByOracle[card.oracleId] ?? 0;
                          return ListTile(
                            dense: true,
                            onTap: () =>
                                Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CardDetailScreen(
                                    db: widget.db,
                                    collection: widget.collection,
                                    oracleId: card.oracleId,
                                    market: widget.market,
                                    prices: widget.prices),
                              ),
                            ),
                            leading: CardThumb(
                                url: card.imageSmall,
                                colors: card.colors,
                                name: card.name),
                            title: Text(
                                card.printedName ?? card.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                                '#${card.collectorNumber} · ${card.rarity}'
                                '${owned > 0 ? ' · ${tr(context).cdYouHaveX(owned)}' : ''}',
                                style: TextStyle(
                                    color: owned > 0
                                        ? MFColors.success
                                        : null)),
                            trailing: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(_euro(card.price),
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold)),
                                if (card.priceFoil != null)
                                  Text(
                                      tr(context).cdFoil(_euro(card.priceFoil)),
                                      style: const TextStyle(
                                          fontSize: 10.5,
                                          color: MFColors.warning)),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
