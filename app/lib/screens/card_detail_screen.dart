import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/market_prefs.dart';
import '../services/market_prices.dart';
import '../services/markets.dart';
import '../services/price_history.dart';
import '../services/price_series_database.dart';
import '../services/recents_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/market_picker.dart';
import '../widgets/price_chart.dart';

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

  const CardDetailScreen(
      {super.key,
      required this.db,
      this.collection,
      this.oracleId,
      this.byName,
      this.market,
      this.prices})
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

  /// Cambiar de mercado no recarga la carta entera: solo su precio y su
  /// gráfica.
  void _reloadPrices() {
    final id = _oracleId;
    if (id != null) _loadPriceHistory(id, _versions);
  }

  Future<void> _load() async {
    try {
      final detail = await widget.db
          .cardDetail(oracleId: widget.oracleId, byName: widget.byName);
      if (detail == null) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = 'No encuentro esta carta en la base de datos.';
          });
        }
        return;
      }
      final versions = await widget.db.versionsOf(detail.oracleId);
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
          _error = 'No pude cargar la ficha: $e';
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
    // el precio en euros de las ediciones que ya trae la ficha: es el que se
    // apunta a diario en local (y el de Cardmarket)
    double? eur;
    for (final v in versions) {
      final p = v.priceEur;
      if (p != null && p > 0 && (eur == null || p < eur)) eur = p;
    }
    try {
      if (eur != null) {
        await priceHistoryStore.recordOne(oracleId, eur);
      }
      final market = _market;
      double? today = eur;
      String? asOf;
      if (market != Market.cardmarket) {
        final series = widget.prices;
        today = null;
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

  String _euro(double? v) => v == null ? '—' : '${v.toStringAsFixed(2)} €';

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(title: Text(detail?.name ?? 'Carta')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error ?? 'Carta no encontrada',
                        textAlign: TextAlign.center),
                  ),
                )
              : _content(context, detail),
    );
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
                            name: detail.name,
                            imageUrl:
                                hero?.imageNormal ?? hero?.imageSmall,
                            colors: detail.colors),
                        child: SizedBox(
                          width: 240,
                          height: 335,
                          child: CardThumb(
                            url: hero?.imageNormal ?? hero?.imageSmall,
                            colors: detail.colors,
                            name: detail.name,
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
                          child: Text(detail.name,
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
                          child: Text(
                            ownedTotal > 0
                                ? '✓ Tienes $ownedTotal copia${ownedTotal == 1 ? '' : 's'} en tu colección'
                                : 'No tienes esta carta (todavía).',
                            style: TextStyle(
                                color: ownedTotal > 0
                                    ? MFColors.success
                                    : null),
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
                            ? 'Sin precio de esta carta en ${_market.label}.'
                            : '${_market.label}: '
                                '${formatMoney(_todayPrice!, _market)}'
                                '${_priceAsOf != null ? ' (último dato: $_priceAsOf)' : ''}',
                        style: const TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    PriceChart(points: _history, currentPrice: _todayPrice),
                    const SizedBox(height: 12),
                    Text('LEGALIDADES',
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
                        Text('VERSIONES (${_versions.length})',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(letterSpacing: 1)),
                        const Spacer(),
                        const Text('precios Cardmarket · normal / foil',
                            style: TextStyle(fontSize: 11)),
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
                                Text(_euro(v.priceEur),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text('foil ${_euro(v.priceEurFoil)}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: MFColors.warning)),
                                if ((printingQty[v.printingKey] ?? 0) > 0)
                                  Text(
                                      'tienes x${printingQty[v.printingKey]}',
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
