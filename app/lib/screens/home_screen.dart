import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/collection_value.dart';
import '../services/deck_store.dart';
import '../services/meta_decks.dart';
import '../services/recents_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'card_detail_screen.dart';
import 'deck_detail_screen.dart';
import 'import_csv_screen.dart';
import 'mercado_screen.dart';
import 'set_market_screen.dart';
import 'test_screen.dart';

/// Inicio: el vestíbulo de la forja. Valor de tu colección, accesos rápidos
/// y tiras deslizables — recientes, tus mazos, el meta, expansiones y joyas.
class HomeScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;
  final void Function(int tabIndex) onGoToTab;

  const HomeScreen({
    super.key,
    required this.db,
    required this.collection,
    required this.decks,
    required this.onGoToTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _value;
  List<ValuedCard> _jewels = const [];
  List<SetBanner> _sets = const [];
  List<MetaDeck> _meta = const [];
  String _metaSource = '';

  @override
  void initState() {
    super.initState();
    recentsStore.load();
    widget.decks.load();
    _load();
    widget.collection.addListener(_load);
    MetaDeckService().load().then((result) {
      if (mounted) {
        setState(() {
          _meta = result.decks;
          _metaSource = result.source;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.collection.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      // misma fórmula que Mercado: que los dos totales SIEMPRE cuadren
      final valuation = await computeCollectionValue(
        cards: widget.collection.cards,
        byPrinting: widget.collection.hasPrintingData,
        printingQty: widget.collection.printingQty,
        oraclePrices: widget.db.pricesForOracles,
        printingPrices: widget.db.pricesForPrintings,
      );
      final sets = _sets.isEmpty
          ? await widget.db.marketSets(limit: 15)
          : _sets;
      if (!mounted) return;
      setState(() {
        _value = valuation.total;
        _jewels = valuation.valued.take(12).toList();
        _sets = sets;
      });
    } catch (_) {/* sin DB aún: héroe en modo bienvenida */}
  }

  void _openCard(String oracleId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
          db: widget.db,
          collection: widget.collection,
          oracleId: oracleId),
    ));
  }

  Future<void> _openDeck(SavedDeck saved) async {
    try {
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle);
      final extra =
          await widget.db.poolByNames({...saved.cards, ...saved.lands});
      extra.forEach((k, v) => pool.putIfAbsent(k, () => v));
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DeckDetailScreen(
          gen: saved.toGenerated(),
          pool: pool,
          db: widget.db,
          decks: widget.decks,
          ownedPrintings: widget.collection.printingQty.keys.toSet(),
        ),
      ));
    } catch (_) {
      widget.onGoToTab(3); // sin DB: a la pestaña Mazos con su mensaje
    }
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(letterSpacing: 1)),
      );

  Widget _strip({required double height, required Widget child}) =>
      SizedBox(
        height: height,
        child: ScrollConfiguration(
            behavior: const DragScrollBehavior(), child: child),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([widget.decks, recentsStore]),
          builder: (context, _) {
            final recents = recentsStore.cards;
            final decks = widget.decks.decks;
            final hasCollection = widget.collection.totalCopies > 0;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: MFColors.manaRed),
                    const SizedBox(width: 8),
                    Text('ManaForge',
                        style:
                            Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 12),
                // héroe: tu colección de un vistazo
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: hasCollection
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tu colección',
                                        style:
                                            TextStyle(fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _value == null
                                          ? '${widget.collection.totalCopies} cartas'
                                          : '${_value!.toStringAsFixed(2)} €',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                              fontWeight:
                                                  FontWeight.bold),
                                    ),
                                    Text(
                                        '${widget.collection.totalCopies} cartas · '
                                        '${widget.collection.distinctCards} distintas',
                                        style: const TextStyle(
                                            fontSize: 11.5)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => widget.onGoToTab(5),
                                child: const Text('Mercado ›'),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                  'Bienvenido a la forja. Importa tu '
                                  'colección y empieza a crear mazos '
                                  'con lo que ya tienes.'),
                              const SizedBox(height: 10),
                              FilledButton.icon(
                                onPressed: () =>
                                    Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ImportCsvScreen(
                                        db: widget.db,
                                        collection:
                                            widget.collection),
                                  ),
                                ),
                                icon: const Icon(Icons.file_upload),
                                label: const Text(
                                    'Importar mi colección (CSV)'),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                // accesos rápidos
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: MFColors.forge),
                      onPressed: () => widget.onGoToTab(4),
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Forjar mazos'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TestScreen(
                              db: widget.db,
                              collection: widget.collection,
                              decks: widget.decks),
                        ),
                      ),
                      icon: const Icon(Icons.sports_kabaddi, size: 18),
                      label: const Text('Modo Test'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => widget.onGoToTab(2),
                      icon:
                          const Icon(Icons.auto_stories, size: 18),
                      label: const Text('Álbum'),
                    ),
                  ],
                ),
                // vistas recientemente
                if (recents.isNotEmpty) ...[
                  _sectionTitle('VISTAS RECIENTEMENTE'),
                  _strip(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recents.length,
                      itemBuilder: (context, i) {
                        final r = recents[i];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _openCard(r.oracleId),
                            child: CardThumb(
                                url: r.imageNormal,
                                colors: r.colors,
                                name: r.name,
                                width: 96,
                                height: 134,
                                radius: 7),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // tus mazos
                if (decks.isNotEmpty) ...[
                  _sectionTitle('TUS MAZOS'),
                  _strip(
                    height: 92,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: decks.length,
                      itemBuilder: (context, i) {
                        final d = decks[i];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => _openDeck(d),
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ColorIdentityDots(
                                          colors: d.colors,
                                          size: 11),
                                      const Spacer(),
                                      Text(d.archetype,
                                          style: const TextStyle(
                                              fontSize: 10)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(d.name,
                                      maxLines: 2,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // el meta ahora
                if (_meta.isNotEmpty) ...[
                  _sectionTitle('EL META AHORA · $_metaSource'),
                  _strip(
                    height: 96,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _meta.length,
                      itemBuilder: (context, i) {
                        final m = _meta[i];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TestScreen(
                                    db: widget.db,
                                    collection: widget.collection,
                                    decks: widget.decks,
                                    initialMetaId: m.id),
                              ),
                            ),
                            child: Container(
                              width: 190,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: MFColors.forge
                                    .withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                    color: MFColors.forge
                                        .withValues(alpha: 0.4)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ColorIdentityDots(
                                          colors: m.colors,
                                          size: 10),
                                      const Spacer(),
                                      Text(
                                          '${m.format}'
                                          '${m.share.isEmpty ? '' : ' · ${m.share}'}',
                                          style: const TextStyle(
                                              fontSize: 10)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(m.name,
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 13)),
                                  const Text('⚔ ponte a prueba',
                                      style: TextStyle(
                                          fontSize: 10.5,
                                          color: MFColors.forge)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // expansiones nuevas
                if (_sets.isNotEmpty) ...[
                  _sectionTitle('EXPANSIONES NUEVAS'),
                  _strip(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sets.length,
                      itemBuilder: (context, i) {
                        final set = _sets[i];
                        return SetBannerTile(
                          set: set,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SetMarketScreen(
                                  db: widget.db,
                                  collection: widget.collection,
                                  set: set),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // tus joyas
                if (_jewels.isNotEmpty) ...[
                  _sectionTitle('TUS JOYAS'),
                  _strip(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _jewels.length,
                      itemBuilder: (context, i) {
                        final j = _jewels[i];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _openCard(j.oracleId),
                            child: Column(
                              children: [
                                CardThumb(
                                    url: j.imageSmall,
                                    colors: j.colors,
                                    name: j.name,
                                    width: 90,
                                    height: 126,
                                    radius: 7),
                                const SizedBox(height: 3),
                                Text(
                                    '${j.unitPrice.toStringAsFixed(2)} €',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
