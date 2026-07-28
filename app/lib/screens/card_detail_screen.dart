import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:flutter/services.dart';

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/card_names.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/market_prefs.dart';
import 'package:manaforge_app/services/market_prices.dart';
import 'package:manaforge_app/services/markets.dart';
import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/services/price_series_database.dart';
import 'package:manaforge_app/services/recents_store.dart';
import 'package:manaforge_app/theme/mf_theme.dart';
import 'package:manaforge_app/widgets/common.dart';
import 'package:manaforge_app/widgets/market_picker.dart';
import 'package:manaforge_app/widgets/price_chart.dart';

/// Ficha completa de una carta: imagen, reglas, tus copias, legalidades y
/// precios por edición (normal y foil). El corazón del Mercado.
class CardDetailScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore? collection;
  final String? oracleId;
  final String? byName; // alternativa cuando solo se conoce el nombre

  /// Si vienen, la ficha deja elegir mercado y su precio y su gráfica pasan
  /// a ese mercado.
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  /// Las cartas que había AL LADO de esta en la lista de la que se abrió
  /// (álbum, colección, carpeta). Con ellas, la ficha pasa a la siguiente y a
  /// la anterior sin volver atrás: mirar precios de un set entero era salir y
  /// entrar una vez por carta.
  final List<String>? siblings;
  final int siblingIndex;

  const CardDetailScreen(
      {super.key,
      required this.db,
      this.collection,
      this.oracleId,
      this.byName,
      this.market,
      this.prices,
      this.siblings,
      this.siblingIndex = 0})
      : assert(oracleId != null || byName != null);

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  CardFullDetail? _detail;
  List<CardVersion> _versions = const [];
  bool _loading = true;
  String? _error;

  List<PricePoint> _history = const [];
  double? _todayPrice;

  /// De qué día es el precio cuando el mercado no publica el de hoy.
  String? _priceAsOf;
  String? _oracleId;

  /// Por dónde vamos dentro de [CardDetailScreen.siblings].
  late int _pos = widget.siblingIndex;

  /// La carta que se está enseñando: la de la lista si hay lista.
  String? get _showing {
    final hermanas = widget.siblings;
    if (hermanas == null || hermanas.isEmpty) return widget.oracleId;
    return hermanas[_pos.clamp(0, hermanas.length - 1)];
  }

  bool get _hayLista => (widget.siblings?.length ?? 0) > 1;

  bool get _puedeAnterior => _hayLista && _pos > 0;

  bool get _puedeSiguiente =>
      _hayLista && _pos < widget.siblings!.length - 1;

  /// Pasa a la carta de al lado y la carga de cero (imagen, precios, gráfica).
  void _mover(int delta) {
    if (delta < 0 && !_puedeAnterior) return;
    if (delta > 0 && !_puedeSiguiente) return;
    setState(() {
      _pos += delta;
      _loading = true;
      _detail = null;
      _versions = const [];
      _history = const [];
      _todayPrice = null;
      _priceAsOf = null;
      _error = null;
    });
    _load();
  }

  Market get _market => widget.market?.market ?? Market.cardmarket;

  // formatos que se muestran, en orden (nombre Scryfall -> etiqueta)
  static const _formats = <String, String>{
    'standard': 'Standard',
    'pioneer': 'Pioneer',
    'modern': 'Modern',
    'legacy': 'Legacy',
    'vintage': 'Vintage',
    'commander': 'Commander',
    'pauper': 'Pauper',
    'brawl': 'Brawl',
    'historic': 'Historic',
    'timeless': 'Timeless',
  };

  @override
  void initState() {
    super.initState();
    _load();
    widget.market?.addListener(_reloadPrices);
  }

  @override
  void dispose() {
    widget.market?.removeListener(_reloadPrices);
    super.dispose();
  }

  /// Cambiar de mercado no recarga la carta entera: solo los precios (el de
  /// arriba, el de CADA edición y la gráfica).
  Future<void> _reloadPrices() async {
    final id = _oracleId;
    if (id == null) return;
    final versions = await widget.db.versionsOf(id, market: _market);
    if (!mounted) return;
    setState(() => _versions = versions);
    await _loadPriceHistory(id, versions);
  }

  Future<void> _load() async {
    try {
      final detail = await widget.db.cardDetail(
          oracleId: _showing, byName: _showing == null ? widget.byName : null);
      if (detail == null) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = tr(context).cdNotFound;
          });
        }
        return;
      }
      final versions =
          await widget.db.versionsOf(detail.oracleId, market: _market);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _versions = versions;
        _loading = false;
      });
      // apunta la visita para la tira de "vistas recientemente" de Inicio
      recentsStore.record(RecentCard(
        oracleId: detail.oracleId,
        name: detail.name,
        imageNormal: versions.isEmpty
            ? null
            : versions.first.imageNormal ?? versions.first.imageSmall,
        colors: detail.colors,
      ));
      await _loadPriceHistory(detail.oracleId, versions);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = tr(context).cdLoadFailed('$e');
        });
      }
    }
  }

  /// Apunta el precio de HOY de esta carta y carga su historial: cualquier
  /// carta que mires empieza a acumular gráfica, la tengas o no (mismo
  /// criterio de precio que el Mercado: la edición más barata con precio).
  Future<void> _loadPriceHistory(
      String oracleId, List<CardVersion> versions) async {
    _oracleId = oracleId;
    // el precio de las ediciones que ya trae la ficha, en el mercado que se
    // esté mirando (la lista de versiones se pide con ese mercado)
    double? cheapest;
    for (final v in versions) {
      final p = v.price;
      if (p != null && p > 0 && (cheapest == null || p < cheapest)) {
        cheapest = p;
      }
    }
    try {
      final market = _market;
      // el apunte diario que guarda la app es SIEMPRE de Cardmarket (euros):
      // mezclarlo con dólares rompería la gráfica local
      if (market == Market.cardmarket && cheapest != null) {
        await priceHistoryStore.recordOne(oracleId, cheapest);
      }
      double? today = cheapest;
      String? asOf;
      if (market != Market.cardmarket && today == null) {
        // mercados sin precio por edición (Card Kingdom, Mana Pool): el
        // último día del histórico de ESE mercado
        final series = widget.prices;
        if (series != null) {
          final prices = await MarketPrices(db: widget.db, series: series)
              .byOracle([oracleId], market);
          final price = prices[oracleId];
          today = price?.value;
          asOf = price?.isFresh == false ? price?.asOf : null;
        }
      }
      final history = await priceHistoryStore.forCardIn(oracleId, market);
      if (!mounted) return;
      setState(() {
        _history = history;
        _todayPrice = today;
        _priceAsOf = asOf;
      });
    } catch (_) {/* sin almacenamiento: la ficha sigue funcionando */}
  }

  /// Precio en la moneda del mercado elegido ('—' si ese mercado no lo
  /// publica para esa edición).
  String _price(double? v) => v == null ? '—' : formatMoney(v, _market);

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail == null
            ? tr(context).cdCardNotFound
            : cardDisplayName(context, detail.name, nameEs: detail.nameEs)),
        actions: [
          if (_hayLista) ...[
            IconButton(
              tooltip: tr(context).cdPrev,
              icon: const Icon(Icons.chevron_left),
              onPressed: _puedeAnterior ? () => _mover(-1) : null,
            ),
            Center(
              child: Text(tr(context).cdPosition(_pos + 1, widget.siblings!.length),
                  style: const TextStyle(fontSize: 12.5)),
            ),
            IconButton(
              tooltip: tr(context).cdNext,
              icon: const Icon(Icons.chevron_right),
              onPressed: _puedeSiguiente ? () => _mover(1) : null,
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (!_hayLista || event is! KeyDownEvent) {
            return KeyEventResult.ignored;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _mover(1);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _mover(-1);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: GestureDetector(
          // arrastrar de lado también pasa carta; el cuerpo se desplaza en
          // vertical, así que no se pisan
          onHorizontalDragEnd: !_hayLista
              ? null
              : (d) {
                  final v = d.primaryVelocity ?? 0;
                  if (v < -250) _mover(1);
                  if (v > 250) _mover(-1);
                },
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : detail == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(_error ?? tr(context).cdCardNotFound,
                            textAlign: TextAlign.center),
                      ),
                    )
                  : _content(context, detail),
        ),
      ),
    );
  }

  /// "Pagaste X por N copias", una línea por divisa. Vacío si no hay ningún
  /// precio de compra apuntado para esta carta.
    List<String> _pagadoPorEsta(BuildContext context, String oracleId) {
    final t = tr(context);
    final collection = widget.collection;
    if (collection == null || !collection.hasPurchaseData) return const [];
    final out = <String>[];
    collection.paidForCard(oracleId).forEach((divisa, dato) {
      final unidad = dato.total / dato.qty;
      out.add(t.cdPaid(
          dato.total.toStringAsFixed(2),
          divisa == null ? '' : ' $divisa',
          dato.qty,
          t.cdCopyWord(dato.qty),
          unidad.toStringAsFixed(2)));
    });
    return out;
  }

  Widget _content(BuildContext context, CardFullDetail detail) {
    final printingQty = widget.collection?.printingQty ?? const {};
    final ownedTotal =
        widget.collection?.qtyByOracle[detail.oracleId] ?? 0;
    // imagen destacada: tu edición si la conocemos; si no, la más nueva
    CardVersion? hero;
    for (final v in _versions) {
      if ((printingQty[v.printingKey] ?? 0) > 0) {
        hero = v;
        break;
      }
    }
    hero ??= _versions.isEmpty ? null : _versions.first;

    return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => showCardZoom(context,
                            name: cardDisplayName(context, detail.name,
                                nameEs: detail.nameEs),
                            imageUrl:
                                hero?.imageNormal ?? hero?.imageSmall,
                            colors: detail.colors),
                        child: SizedBox(
                          width: 240,
                          height: 335,
                          child: CardThumb(
                            url: hero?.imageNormal ?? hero?.imageSmall,
                            colors: detail.colors,
                            name: cardDisplayName(context, detail.name,
                                nameEs: detail.nameEs),
                            width: 240,
                            height: 335,
                            radius: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                              cardDisplayName(context, detail.name,
                                  nameEs: detail.nameEs),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold)),
                        ),
                        Text(detail.manaCost,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(child: Text(detail.typeLine)),
                        if (detail.power != null)
                          Text('${detail.power}/${detail.toughness}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (detail.oracleText.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(detail.oracleText,
                              style: const TextStyle(height: 1.4)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (widget.collection != null)
                      Card(
                        color: ownedTotal > 0
                            ? MFColors.success.withValues(alpha: 0.10)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ownedTotal > 0
                                    ? tr(context).cdYouHave(ownedTotal)
                                    : tr(context).cdNotOwned,
                                style: TextStyle(
                                    color: ownedTotal > 0
                                        ? MFColors.success
                                        : null),
                              ),
                              // lo que pagaste, si el CSV lo traía: una divisa
                              // por línea, porque no se convierten
                              for (final linea
                                  in _pagadoPorEsta(context, detail.oracleId))
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(linea,
                                      style: const TextStyle(fontSize: 12)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.market != null) ...[
                      MarketPicker(
                          preference: widget.market!,
                          available: widget.prices?.markets ?? const {}),
                      const SizedBox(height: 6),
                    ],
                    if (_market != Market.cardmarket)
                      Text(
                        _todayPrice == null
                            ? tr(context).cdNoPrice(_market.label)
                            : '${_market.label}: '
                                '${formatMoney(_todayPrice!, _market)}'
                                '${_priceAsOf != null ? tr(context).cdLastData(_priceAsOf!) : ''}',
                        style: const TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    PriceChart(points: _history, currentPrice: _todayPrice),
                    const SizedBox(height: 12),
                    Text(tr(context).cdLegalities.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        for (final e in _formats.entries)
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Icon(
                                  detail.legalities[e.key] == 'legal'
                                      ? Icons.check_circle
                                      : Icons.remove,
                                  size: 16,
                                  color: detail.legalities[e.key] == 'legal'
                                      ? MFColors.success
                                      : Colors.white38,
                                ),
                                const SizedBox(width: 6),
                                Text(e.value,
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(tr(context).cdVersions(_versions.length),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(letterSpacing: 1)),
                        const Spacer(),
                        Text(
                            _market.todayColumn == null
                                ? tr(context).cdNoPerPrinting(_market.label)
                                : tr(context).cdPricesNormalFoil(
                                    _market.label, _market.currency),
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final v in _versions)
                      Card(
                        child: ListTile(
                          dense: true,
                          onTap: () => showCardZoom(context,
                              name:
                                  '${detail.name} · ${v.setCode.toUpperCase()} #${v.collectorNumber}',
                              imageUrl: v.imageNormal ?? v.imageSmall,
                              colors: detail.colors),
                          leading: CardThumb(
                              url: v.imageSmall,
                              colors: detail.colors,
                              name: detail.name),
                          title: Text(v.setName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                              '${v.setCode.toUpperCase()} · #${v.collectorNumber}'
                              ' · ${v.year} · ${v.rarity}'),
                          // FittedBox: con la tercera línea ("tienes xN")
                          // las tres no caben en un ListTile dense y se
                          // recortaba por abajo
                          trailing: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_price(v.price),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(tr(context).cdFoil(_price(v.priceFoil)),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: MFColors.warning)),
                                if ((printingQty[v.printingKey] ?? 0) > 0)
                                  Text(
                                      tr(context).cdYouHaveX(
                                          printingQty[v.printingKey] ?? 0),
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: MFColors.success)),
                              ],
                            ),
                          ),
                        ),
                      ),
        const SizedBox(height: 24),
      ],
    );
  }
}
