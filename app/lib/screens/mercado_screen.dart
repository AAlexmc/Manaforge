import 'package:flutter/material.dart';

import '../services/database_download_error.dart';
import '../l10n/t.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/collection_value.dart';
import '../services/collection_value_series.dart';
import '../services/market_prefs.dart';
import '../services/market_prices.dart';
import '../services/markets.dart';
import '../services/pnl.dart';
import '../services/price_history.dart';
import '../services/price_series_database.dart';
import '../services/value_history.dart';
import '../services/wishlist_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/pnl_view.dart';
import '../widgets/market_picker.dart';
import '../widgets/price_chart.dart';
import 'card_detail_screen.dart';
import 'set_market_screen.dart';
import 'wishlist_screen.dart';

/// Mercado: el valor de tu colección con evolución local, tus cartas más
/// valiosas y un buscador de precios de cualquier carta. Precios Cardmarket
/// vía la base de datos local (Scryfall, regenerada a diario).
class MercadoScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final WishlistStore wishlist;

  /// Histórico real de Cardmarket (~90 días), descargable aparte.
  final PriceSeriesDatabase prices;

  /// Mercado elegido (se recuerda entre arranques).
  final MarketPreference market;

  /// Keys para que un tour pueda señalar el selector de mercado, la wishlist
  /// y el buscador (donde se pone la alerta de precio).
  final Key? selectorKey;
  final Key? wishlistKey;
  final Key? buscarKey;

  const MercadoScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.wishlist,
      required this.prices,
      required this.market,
      this.selectorKey,
      this.wishlistKey,
      this.buscarKey});

  @override
  State<MercadoScreen> createState() => _MercadoScreenState();
}

class _MercadoScreenState extends State<MercadoScreen> {
  final _history = ValueHistory();
  final _searchCtrl = TextEditingController();
  final _bannerCtrl = ScrollController();

  double? _totalValue;

  /// Lo pagado contra lo que vale hoy. null = aún sin calcular o sin
  /// ninguna compra apuntada.
  PnL? _pnl;
  List<ValuedCard> _top = const [];
  List<ValuePoint> _points = const [];
  Map<String, List<PricePoint>> _cardHistory = const {};
  (String, String)? _historyCovered; // tramo del histórico descargado
  bool _historyDownloading = false;
  double? _historyProgress; // null con descarga en curso = indeterminado
  String? _bulkDate;
  List<CardHit> _results = const [];
  List<SetBanner> _banners = const [];
  double? _updateProgress;
  bool _approximate = false;
  String? _error;

  /// Precio por carta en el mercado elegido (si no es Cardmarket, sustituye
  /// al de la valoración, que es siempre en euros).
  Map<String, MarketPrice> _marketPrices = const {};

  MarketPrices get _prices =>
      MarketPrices(db: widget.db, series: widget.prices);

  Market get _market => widget.market.market;

  @override
  void initState() {
    super.initState();
    widget.wishlist.load().then((_) => _checkWishlist());
    _load();
    widget.collection.addListener(_load);
    widget.wishlist.addListener(_onWishlistChanged);
    widget.market.load().then((_) => _load());
    widget.market.addListener(_load);
  }

  @override
  void dispose() {
    widget.collection.removeListener(_load);
    widget.wishlist.removeListener(_onWishlistChanged);
    widget.market.removeListener(_load);
    _searchCtrl.dispose();
    _bannerCtrl.dispose();
    super.dispose();
  }

  void _onWishlistChanged() {
    if (mounted) setState(() {});
  }

  /// Apunta precios al historial sin que un fallo de almacenamiento afecte
  /// a lo que el usuario ha venido a hacer (ver su valor, cobrar alertas).
  void _recordPrices(Map<String, double> prices) {
    if (prices.isEmpty) return;
    priceHistoryStore.recordAll(prices).catchError((_) {});
  }

  /// Cruza los precios actuales con la wishlist y avisa de lo que ACABA de
  /// caer a su precio objetivo.
  Future<void> _checkWishlist() async {
    final items = widget.wishlist.items;
    if (items.isEmpty) return;
    try {
      final prices = await widget.db
          .pricesForOracles(items.map((i) => i.oracleId));
      final hits = widget.wishlist.updatePrices(prices);
      // las de la wishlist también acumulan gráfica aunque no las tengas;
      // va DESPUÉS y con su propio catch: que no se pueda guardar el
      // historial no debe cargarse la alerta de precio objetivo
      _recordPrices(prices);
      if (hits.isEmpty || !mounted) return;
      final t = tr(context);
      final msg = hits.length == 1
          ? t.mkAlertOne(
              hits.first.printedName ?? hits.first.name,
              _euro(hits.first.lastPrice!),
              _euro(hits.first.targetPrice))
          : t.mkAlertMany(hits.length);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 5),
      ));
    } catch (_) {/* DB no disponible: se reintenta en el próximo load */}
  }

  void _scrollBanners(double delta) {
    if (!_bannerCtrl.hasClients) return;
    _bannerCtrl.animateTo(
      (_bannerCtrl.offset + delta).clamp(
          0.0, _bannerCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Future<void> _load() async {
    try {
      final byPrinting = widget.collection.hasPrintingData;
      final printingQty = widget.collection.printingQty;
      // colecciones de antes de esta versión saben qué impresiones tienen
      // pero no de quién es cada una (`printingOwner` sale vacío): sin este
      // backfill, el valor salía marcado aproximado (~) aquí aunque
      // Colección, que sí hace este mismo prólogo, lo enseñara exacto
      if (byPrinting && printingQty.isNotEmpty) {
        final owners = await widget.db.oracleByPrintings(printingQty.keys);
        if (owners.isNotEmpty) {
          widget.collection.backfillPrintingOwners(owners);
        }
      }
      // fórmula compartida con Home (services/collection_value.dart)
      final valuation = await computeCollectionValue(
        cards: widget.collection.cards,
        byPrinting: byPrinting,
        printingQty: printingQty,
        oraclePrices: widget.db.pricesForOracles,
        printingPrices: widget.db.pricesForPrintings,
        printingOwner: widget.collection.printingOwner,
      );
      final total = valuation.total;
      final valued = valuation.valued;

      // foto diaria del precio de CADA carta de la colección: es lo que
      // alimenta la gráfica de evolución de su ficha (Scryfall solo da el
      // precio de hoy, la historia se construye con el uso). Sin await ni
      // propagación: el Mercado no debe romperse porque falle el disco.
      _recordPrices({
        for (final c in valued)
          if (c.unitPrice > 0) c.oracleId: c.unitPrice
      });

      // P&L: solo si hay precios de compra apuntados. Va en la divisa
      // canónica (Cardmarket), la misma del número grande de arriba.
      final pnl = widget.collection.hasPurchaseData
          ? await computePnl(
              purchases: widget.collection.purchases,
              totalCopies: widget.collection.totalCopies,
              currency: Market.cardmarket.currency,
              printingPrices: widget.db.pricesForPrintings,
              oraclePrices: widget.db.pricesForOracles,
            )
          : null;

      final points =
          await _history.record(total, widget.collection.totalCopies);
      final curva = await _valueCurve(points);
      final bulkDate = await widget.db.bulkDate();
      final banners =
          _banners.isEmpty ? await widget.db.marketSets() : _banners;
      final top = valued.take(20).toList();
      final watched = [
        for (final c in top) c.oracleId,
        for (final i in widget.wishlist.items) i.oracleId,
      ];
      final cardHistory =
          await _prices.historyFor(watched, _market);
      // el precio que se ENSEÑA por carta es el del mercado elegido; el
      // total de la colección se queda en Cardmarket (es la valoración
      // canónica que comparten Inicio, carpetas y logros)
      final marketPrices = _market == Market.cardmarket
          ? const <String, MarketPrice>{}
          : await _prices.byOracle(watched, _market);
      // el histórico es opcional: si falla, el Mercado sigue pintando
      (String, String)? covered;
      try {
        covered = await widget.prices.covered();
      } catch (_) {/* sin tramo cubierto */}
      if (!mounted) return;
      setState(() {
        _totalValue = total;
        _pnl = pnl;
        _top = top;
        _points = curva;
        _cardHistory = cardHistory;
        _marketPrices = marketPrices;
        _historyCovered = covered;
        _bulkDate = bulkDate;
        _banners = banners;
        _approximate = valuation.approximate;
        _error = null;
      });
      await _checkWishlist();
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  /// La curva del valor de la colección. Se construye con el histórico REAL
  /// de cada carta que tienes (los ~90 días que trae la base descargable) y
  /// se le pegan detrás las fotos diarias locales de los días que el
  /// histórico ya no cubre.
  ///
  /// Antes se pintaban solo las fotos locales: con dos días de uso eran dos
  /// puntos, y dos puntos siempre salen en línea recta.
  ///
  /// Si no hay base descargada, se queda con las fotos locales de siempre.
  Future<List<ValuePoint>> _valueCurve(List<ValuePoint> local) async {
    try {
      final qty = widget.collection.qtyByOracle;
      if (qty.isEmpty) return local;
      // el total de la colección es el de Cardmarket, igual que en Inicio y
      // en las carpetas: la curva tiene que ir en la misma moneda que el
      // número grande de arriba
      final series =
          await widget.prices.seriesFor(qty.keys, market: Market.cardmarket);
      final real =
          collectionValueSeries(qtyByOracle: qty, seriesByOracle: series);
      if (real.length < 2) return local;
      final ultimo = real.last.date;
      return [...real, ...local.where((p) => p.date.compareTo(ultimo) > 0)];
    } catch (_) {
      return local; // sin histórico: lo de siempre
    }
  }

  /// Añadir/quitar una carta de la wishlist desde los resultados de búsqueda.
  Future<void> _toggleWish(CardHit hit) async {
    if (widget.wishlist.contains(hit.oracleId)) {
      widget.wishlist.remove(hit.oracleId);
      return;
    }
    double? current;
    try {
      current =
          (await widget.db.pricesForOracles([hit.oracleId]))[hit.oracleId];
    } catch (_) {/* sin DB de precios: se pide el objetivo a ciegas */}
    if (!mounted) return;
    final target =
        await _askTargetPrice(hit.printedName ?? hit.name, current);
    if (target == null) return;
    widget.wishlist.add(WishItem(
      oracleId: hit.oracleId,
      name: hit.name,
      printedName: hit.printedName,
      imageSmall: hit.imageSmall,
      colors: hit.colors,
      targetPrice: target,
      lastPrice: current,
      // si YA está a precio al añadirla, no hace falta re-avisar luego
      alerted: current != null && current <= target,
    ));
  }

  Future<void> _editWish(WishItem item) async {
    final target = await _askTargetPrice(
        item.printedName ?? item.name, item.lastPrice);
    if (target != null) widget.wishlist.setTarget(item.oracleId, target);
  }

    Future<double?> _askTargetPrice(String name, double? current) {
    final t = tr(context);
    final ctrl = TextEditingController(
        text: current?.toStringAsFixed(2) ?? '');
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.mkTellMeWhenDrops),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: t.mkTargetPrice,
                suffixText: '€',
                helperText:
                    current != null ? t.mkNow(_euro(current)) : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (v) => Navigator.of(context)
                  .pop(double.tryParse(v.replaceAll(',', '.'))),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr(context).acCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context)
                .pop(double.tryParse(ctrl.text.replaceAll(',', '.'))),
            child: Text(tr(context).fdSave),
          ),
        ],
      ),
    );
  }

  Future<void> _search(String query) async {
    try {
      final results = await widget.db.search(query);
      if (mounted) setState(() => _results = results);
    } catch (_) {/* DB no disponible */}
  }

  Future<void> _updateDb() async {
    setState(() => _updateProgress = 0);
    try {
      await for (final p in widget.db.download()) {
        if (mounted) setState(() => _updateProgress = p < 0 ? null : p);
      }
      if (mounted) {
        setState(() => _updateProgress = null);
        await _load();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr(context).mkUpdated)));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _updateProgress = null);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(tr(context)
                    .mkUpdateFailed(downloadErrorText(tr(context), e)))));
      }
    }
  }

  /// Trae los ~90 días de histórico real de Cardmarket (≈4 MB) para TODAS
  /// las cartas: sin esto las gráficas arrancan vacías, porque Scryfall
  /// solo publica el precio de hoy.
  Future<void> _downloadHistory() async {
    if (_historyDownloading) return; // dos descargas a la vez se pisarían
    setState(() {
      _historyDownloading = true;
      _historyProgress = 0;
    });
    try {
      await for (final p in widget.prices.download()) {
        // p < 0 = sin Content-Length: barra indeterminada, pero la descarga
        // SIGUE en curso (el botón no debe reaparecer)
        if (mounted) setState(() => _historyProgress = p < 0 ? null : p);
      }
      if (!mounted) return;
      setState(() => _historyProgress = null);
      await _load();
      if (mounted) {
        setState(() => _historyDownloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr(context).mkHistoryReady)));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _historyDownloading = false;
          _historyProgress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(tr(context).mkHistoryFailed('$e'))));
      }
    } finally {
      _historyDownloading = false;
    }
  }

    Widget _historyRow() {
    final t = tr(context);
    final covered = _historyCovered;
    return Row(
      children: [
        Expanded(
          child: Text(
            covered == null
                ? t.mkHistoryLocal
                : t.mkHistoryReal(covered.$1, covered.$2),
            style: const TextStyle(fontSize: 11.5),
          ),
        ),
        if (_historyDownloading)
          SizedBox(
            width: 120,
            child: LinearProgressIndicator(value: _historyProgress),
          )
        else
          TextButton.icon(
            onPressed: _downloadHistory,
            icon: const Icon(Icons.timeline, size: 16),
            label: Text(covered == null ? t.mkFetchHistory : t.mkUpdate),
          ),
      ],
    );
  }

  void _openDetail({String? oracleId, String? byName}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
        db: widget.db,
        collection: widget.collection,
        oracleId: oracleId,
        byName: byName,
        market: widget.market,
        prices: widget.prices,
      ),
    ));
  }

  String _euro(double v) => '${v.toStringAsFixed(2)} €';

  /// Lo que suman TUS copias de esa carta en el mercado elegido.
  String _totalOf(ValuedCard card) {
    final price = _marketPrices[card.oracleId];
    if (price != null) return formatMoney(price.value * card.qty, _market);
    if (_market == Market.cardmarket) return _euro(card.total);
    return '—';
  }

  /// Precio de una carta en el mercado elegido; null si ese mercado no tiene
  /// dato de esa carta.
  String? _priceOf(String oracleId, {double? fallbackEur}) {
    final price = _marketPrices[oracleId];
    if (price != null) {
      final label = formatMoney(price.value, _market);
      return price.isFresh ? label : '$label (${price.asOf})';
    }
    if (_market == Market.cardmarket && fallbackEur != null) {
      return _euro(fallbackEur);
    }
    return null;
  }

  /// Botón de acceso a la wishlist, con contador de cartas y punto verde si
  /// alguna está ya a precio de compra.
  Widget _wishlistButton() {
    return ListenableBuilder(
      listenable: widget.wishlist,
      builder: (context, _) {
        final n = widget.wishlist.items.length;
        final atPrice = widget.wishlist.items.any((i) => i.inRange);
        return Badge(
          isLabelVisible: n > 0,
          label: Text('$n'),
          backgroundColor: atPrice ? MFColors.success : MFColors.manaRed,
          child: FilledButton.tonalIcon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WishlistScreen(
                  db: widget.db,
                  wishlist: widget.wishlist,
                  onEditTarget: _editWish,
                ),
              ),
            ),
            icon: const Icon(Icons.bookmark, size: 18),
            label: Text(tr(context).onbWishlistTitle),
          ),
        );
      },
    );
  }

  /// Cuánto se ha movido de un punto al anterior. Los dos valores salen de la
  /// MISMA serie a propósito: mezclar el total de hoy (calculado por
  /// ediciones exactas) con un punto de la curva histórica (que va por carta)
  /// daría una diferencia inventada por el cambio de fuente, no por el
  /// mercado.
  (double, double)? _delta() {
    if (_points.length < 2) return null;
    final prev = _points[_points.length - 2].value;
    final diff = _points.last.value - prev;
    final pct = prev == 0 ? 0.0 : diff / prev * 100;
    return (diff, pct);
  }

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    final delta = _delta();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          // margen generoso de construcción: la lista sigue siendo perezosa
          // (la wishlist de abajo puede ser larga), pero los mandos que
          // señala el tour —selector, wishlist y buscador— se montan aunque
          // queden fuera de la vista, que es lo que hace falta para medirlos.
          // (`scrollCacheExtent`, el relevo moderno, no compila con el SDK
          // que usan los tests: "Couldn't find constructor
          // ScrollCacheExtent.pixels". Cuando compile, cambiarlo)
          // ignore: deprecated_member_use
          cacheExtent: 1200,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: MFColors.warning),
                const SizedBox(width: 8),
                Text(tr(context).tabMarket,
                    style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                KeyedSubtree(
                    key: widget.wishlistKey, child: _wishlistButton()),
              ],
            ),
            const SizedBox(height: 8),
            // elegir mercado: cambia el precio de cada carta y su gráfica
            KeyedSubtree(
              key: widget.selectorKey,
              child: MarketPicker(
                  preference: widget.market,
                  available: widget.prices.markets),
            ),
            MarketNote(market: _market),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.mkCollectionValue,
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _totalValue == null
                              ? '…'
                              : _euro(_totalValue!),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        if (delta != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '${delta.$1 >= 0 ? '+' : ''}${_euro(delta.$1)} '
                              '(${delta.$2.toStringAsFixed(1)}%)',
                              style: TextStyle(
                                  color: delta.$1 >= 0
                                      ? MFColors.success
                                      : MFColors.manaRed,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    Text(
                        t.mkCardsCount(widget.collection.totalCopies) +
                            (_approximate
                                ? t.mkApproxValue
                                : t.mkExactPrintings),
                        style: const TextStyle(fontSize: 11.5)),
                    if (_pnl != null) ...[
                      const Divider(height: 18),
                      PnlView(pnl: _pnl!, market: Market.cardmarket),
                    ],
                    if (_points.length >= 2) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 44,
                        child: _Sparkline(points: _points),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(t.mkBulkPrices(_bulkDate ?? '…'),
                              style: const TextStyle(fontSize: 11.5)),
                        ),
                        if (_updateProgress != null)
                          SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(
                                value: _updateProgress),
                          )
                        else
                          TextButton.icon(
                            onPressed: _updateDb,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: Text(t.mkUpdate),
                          ),
                      ],
                    ),
                    _historyRow(),
                  ],
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(t.mkNoData('$_error')),
              ),
            if (_banners.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(t.mkSetsHeader(_banners.length),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(letterSpacing: 1)),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: t.mkPrevious,
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _scrollBanners(-600),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: t.mkNext,
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _scrollBanners(600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: ScrollConfiguration(
                  behavior: const DragScrollBehavior(),
                  child: ListView.builder(
                    controller: _bannerCtrl,
                    scrollDirection: Axis.horizontal,
                    itemCount: _banners.length,
                    itemBuilder: (context, i) {
                      final set = _banners[i];
                      return SetBannerTile(
                        set: set,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SetMarketScreen(
                                db: widget.db,
                                collection: widget.collection,
                                set: set,
                                market: widget.market,
                                prices: widget.prices),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            KeyedSubtree(
              key: widget.buscarKey,
              child: TextField(
                controller: _searchCtrl,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: t.mkSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final hit in _results.take(12))
                ListTile(
                  dense: true,
                  onTap: () => _openDetail(oracleId: hit.oracleId),
                  leading: CardThumb(
                      url: hit.imageSmall,
                      colors: hit.colors,
                      name: hit.name),
                  title: Text(hit.printedName ?? hit.name),
                  subtitle: Text(hit.typeLine,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: widget.wishlist.contains(hit.oracleId)
                            ? t.mkRemoveFromWishlist
                            : t.mkAddToWishlist,
                        icon: Icon(
                          widget.wishlist.contains(hit.oracleId)
                              ? Icons.bookmark
                              : Icons.bookmark_add_outlined,
                          size: 20,
                          color: widget.wishlist.contains(hit.oracleId)
                              ? MFColors.manaRed
                              : null,
                        ),
                        onPressed: () => _toggleWish(hit),
                      ),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
            ] else ...[
              if (widget.wishlist.items.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(t.mkYourWishlist,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(letterSpacing: 1)),
                const SizedBox(height: 6),
                for (final item in widget.wishlist.items)
                  ListTile(
                    dense: true,
                    onTap: () => _openDetail(oracleId: item.oracleId),
                    leading: CardThumb(
                        url: item.imageSmall,
                        colors: item.colors,
                        name: item.name),
                    title: Text(item.printedName ?? item.name),
                    subtitle: Text(t.mkTargetAtMost(_euro(item.targetPrice)) +
                        (_priceOf(item.oracleId,
                                    fallbackEur: item.lastPrice) !=
                                null
                            ? t.mkNowSuffix(_priceOf(item.oracleId,
                                fallbackEur: item.lastPrice)!)
                            : '')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MiniPriceLine(
                            points: _cardHistory[item.oracleId] ?? const []),
                        const SizedBox(width: 6),
                        if (item.inRange)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  MFColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(t.mkAtPrice,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: MFColors.success)),
                          ),
                        IconButton(
                          tooltip: t.mkChangeTarget,
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _editWish(item),
                        ),
                        IconButton(
                          tooltip: t.mkRemoveFromWishlist,
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () =>
                              widget.wishlist.remove(item.oracleId),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              Text(t.mkTopCards,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(letterSpacing: 1)),
              const SizedBox(height: 6),
              if (_top.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(t.mkImportToSeeValue),
                ),
              for (final card in _top)
                ListTile(
                  dense: true,
                  onTap: () => _openDetail(oracleId: card.oracleId),
                  leading: CardThumb(
                      url: card.imageSmall,
                      colors: card.colors,
                      name: card.name),
                  title: Text(card.printedName ?? card.name),
                  subtitle: Text(
                      'x${card.qty} · '
                      '${_priceOf(card.oracleId, fallbackEur: card.unitPrice) ?? t.mkNoPriceIn(_market.label)}'
                      '${t.mkPerUnit}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MiniPriceLine(
                          points: _cardHistory[card.oracleId] ?? const []),
                      const SizedBox(width: 10),
                      // el total de la fila también en el mercado elegido:
                      // enseñar euros al lado de un precio en dólares era
                      // pedir que se leyera mal
                      Text(_totalOf(card),
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Mini-gráfica de la evolución del valor (línea simple, sin dependencias).
class _Sparkline extends StatelessWidget {
  final List<ValuePoint> points;

  const _Sparkline({required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 44),
      painter: _SparklinePainter(points),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<ValuePoint> points;

  _SparklinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final values = [for (final p in points) p.value];
    var min = values.first, max = values.first;
    for (final v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    final range = (max - min).abs() < 0.01 ? 1.0 : max - min;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y =
          size.height - (values[i] - min) / range * (size.height - 6) - 3;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final up = values.last >= values.first;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = up ? MFColors.success : MFColors.manaRed;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.points != points;
}


/// Banner de expansión estilo gacha: la carta más cara del set de fondo,
/// nombre y año por encima.
class SetBannerTile extends StatelessWidget {
  final SetBanner set;
  final VoidCallback onTap;

  const SetBannerTile({required this.set, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 190,
            height: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (set.imageNormal != null)
                  Image.network(
                    set.imageNormal!,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.6), // el arte, no el texto
                    errorBuilder: (context, error, stack) =>
                        Container(color: Colors.white10),
                  )
                else
                  Container(color: Colors.white10),
                // velo para que el texto respire
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        set.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${set.code.toUpperCase()}'
                        '${set.year.isEmpty ? '' : ' · ${set.year}'}'
                        '${tr(context).mkSetCards(set.total)}',
                        style: const TextStyle(
                            fontSize: 10.5, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
