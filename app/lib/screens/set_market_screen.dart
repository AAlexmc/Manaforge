import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'card_detail_screen.dart';

/// Mercado de una expansión: todas sus cartas con precio, con filtros
/// (nombre, rareza, color, solo las tuyas) y ordenación por precio.
class SetMarketScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final SetBanner set;

  const SetMarketScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.set});

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

  static const _rarities = <String, String>{
    'mythic': 'Mítica',
    'rare': 'Rara',
    'uncommon': 'Infrecuente',
    'common': 'Común',
  };

  @override
  void initState() {
    super.initState();
    widget.db.setCardsWithPrices(widget.set.code).then((cards) {
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
            (a, b) => (b.priceEur ?? -1).compareTo(a.priceEur ?? -1));
      case _Sort.priceAsc:
        list.sort((a, b) =>
            (a.priceEur ?? 1e9).compareTo(b.priceEur ?? 1e9));
      case _Sort.number:
        list.sort(byNumber);
      case _Sort.name:
        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  String _euro(double? v) => v == null ? '—' : '${v.toStringAsFixed(2)} €';

  @override
  Widget build(BuildContext context) {
    final cards = _cards;
    final visible = _visible();
    final totalValue = visible.fold<double>(
        0, (a, c) => a + (c.priceEur ?? 0));
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.set.name} · ${widget.set.code.toUpperCase()}'),
      ),
      body: cards == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Text('No pude cargar el set: $_error'),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Busca en la expansión…',
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
                          hint: const Text('Rareza',
                              style: TextStyle(fontSize: 12)),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12),
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            const DropdownMenuItem(
                                value: null,
                                child: Text('Rareza: todas')),
                            for (final e in _rarities.entries)
                              DropdownMenuItem(
                                  value: e.key, child: Text(e.value)),
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
                          items: const [
                            DropdownMenuItem(
                                value: _Sort.priceDesc,
                                child: Text('Precio ↓')),
                            DropdownMenuItem(
                                value: _Sort.priceAsc,
                                child: Text('Precio ↑')),
                            DropdownMenuItem(
                                value: _Sort.number,
                                child: Text('Número')),
                            DropdownMenuItem(
                                value: _Sort.name,
                                child: Text('Nombre')),
                          ],
                          onChanged: (v) =>
                              setState(() => _sort = v ?? _Sort.priceDesc),
                        ),
                      ),
                      FilterChip(
                        visualDensity: VisualDensity.compact,
                        label: const Text('Solo las mías',
                            style: TextStyle(fontSize: 11)),
                        selected: _onlyMine,
                        onSelected: (v) =>
                            setState(() => _onlyMine = v),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('${visible.length} cartas',
                          style: const TextStyle(fontSize: 11.5)),
                      const Spacer(),
                      Text('valor listado: ${_euro(totalValue)}',
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
                                    oracleId: card.oracleId),
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
                                '${owned > 0 ? ' · tienes x$owned' : ''}',
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
                                Text(_euro(card.priceEur),
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold)),
                                if (card.priceEurFoil != null)
                                  Text(
                                      'foil ${_euro(card.priceEurFoil)}',
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
