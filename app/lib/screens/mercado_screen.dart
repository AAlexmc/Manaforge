import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/value_history.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'card_detail_screen.dart';
import 'set_market_screen.dart';

/// Mercado: el valor de tu colección con evolución local, tus cartas más
/// valiosas y un buscador de precios de cualquier carta. Precios Cardmarket
/// vía la base de datos local (Scryfall, regenerada a diario).
class MercadoScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;

  const MercadoScreen(
      {super.key, required this.db, required this.collection});

  @override
  State<MercadoScreen> createState() => _MercadoScreenState();
}

class _MercadoScreenState extends State<MercadoScreen> {
  final _history = ValueHistory();
  final _searchCtrl = TextEditingController();
  final _bannerCtrl = ScrollController();

  double? _totalValue;
  List<ValuedCard> _top = const [];
  List<ValuePoint> _points = const [];
  String? _bulkDate;
  List<CardHit> _results = const [];
  List<SetBanner> _banners = const [];
  double? _updateProgress;
  bool _approximate = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    widget.collection.addListener(_load);
  }

  @override
  void dispose() {
    widget.collection.removeListener(_load);
    _searchCtrl.dispose();
    _bannerCtrl.dispose();
    super.dispose();
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
      final cards = widget.collection.cards;
      final byPrinting = widget.collection.hasPrintingData;
      double total = 0;
      final valued = <ValuedCard>[];

      if (byPrinting) {
        // preciso: precio de TU edición exacta
        final printingQty = widget.collection.printingQty;
        final prices =
            await widget.db.pricesForPrintings(printingQty.keys);
        // el valor por carta (para el top) se agrega a nivel oracle con
        // el precio de la edición más cara que tengas de esa carta
        final oraclePrices = await widget.db
            .pricesForOracles(cards.map((c) => c.oracleId));
        printingQty.forEach((key, qty) {
          total += (prices[key] ?? 0) * qty;
        });
        for (final c in cards) {
          final unit = oraclePrices[c.oracleId] ?? 0;
          valued.add(ValuedCard(
            oracleId: c.oracleId,
            name: c.name,
            printedName: c.printedName,
            imageSmall: c.imageSmall,
            imageNormal: c.imageNormal,
            colors: c.colors,
            qty: c.qty,
            unitPrice: unit,
          ));
        }
      } else {
        final oraclePrices = await widget.db
            .pricesForOracles(cards.map((c) => c.oracleId));
        for (final c in cards) {
          final unit = oraclePrices[c.oracleId] ?? 0;
          total += unit * c.qty;
          valued.add(ValuedCard(
            oracleId: c.oracleId,
            name: c.name,
            printedName: c.printedName,
            imageSmall: c.imageSmall,
            imageNormal: c.imageNormal,
            colors: c.colors,
            qty: c.qty,
            unitPrice: unit,
          ));
        }
      }
      valued.sort((a, b) => b.total.compareTo(a.total));

      final points =
          await _history.record(total, widget.collection.totalCopies);
      final bulkDate = await widget.db.bulkDate();
      final banners =
          _banners.isEmpty ? await widget.db.marketSets() : _banners;
      if (!mounted) return;
      setState(() {
        _totalValue = total;
        _top = valued.take(20).toList();
        _points = points;
        _bulkDate = bulkDate;
        _banners = banners;
        _approximate = !byPrinting;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('✓ Precios y cartas actualizados')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _updateProgress = null);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No pude actualizar: $e')));
      }
    }
  }

  void _openDetail({String? oracleId, String? byName}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
        db: widget.db,
        collection: widget.collection,
        oracleId: oracleId,
        byName: byName,
      ),
    ));
  }

  String _euro(double v) => '${v.toStringAsFixed(2)} €';

  (double, double)? _delta() {
    if (_points.length < 2 || _totalValue == null) return null;
    final prev = _points[_points.length - 2].value;
    final diff = _totalValue! - prev;
    final pct = prev == 0 ? 0.0 : diff / prev * 100;
    return (diff, pct);
  }

  @override
  Widget build(BuildContext context) {
    final delta = _delta();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: MFColors.warning),
                const SizedBox(width: 8),
                Text('Mercado',
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Valor de tu colección',
                        style: TextStyle(fontSize: 13)),
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
                        '${widget.collection.totalCopies} cartas'
                        '${_approximate ? ' · valor aproximado (reimporta con "Sustituir" para precios por edición)' : ' · por tus ediciones exactas'}',
                        style: const TextStyle(fontSize: 11.5)),
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
                          child: Text(
                              'Precios Cardmarket del '
                              '${_bulkDate ?? '…'} (Scryfall)',
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
                            label: const Text('Actualizar'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Mercado sin datos: descarga la base de '
                    'datos en Colección. ($_error)'),
              ),
            if (_banners.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('EXPANSIONES (${_banners.length})',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(letterSpacing: 1)),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Anteriores',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _scrollBanners(-600),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Siguientes',
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
                      return _SetBannerTile(
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
              ),
            ],
            const SizedBox(height: 14),
            TextField(
              controller: _searchCtrl,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Busca el precio de cualquier carta…',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
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
                  trailing: const Icon(Icons.chevron_right, size: 18),
                ),
            ] else ...[
              const SizedBox(height: 16),
              Text('TUS CARTAS MÁS VALIOSAS',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(letterSpacing: 1)),
              const SizedBox(height: 6),
              if (_top.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Importa tu colección para ver su valor.'),
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
                      'x${card.qty} · ${_euro(card.unitPrice)}/ud'),
                  trailing: Text(_euro(card.total),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
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
class _SetBannerTile extends StatelessWidget {
  final SetBanner set;
  final VoidCallback onTap;

  const _SetBannerTile({required this.set, required this.onTap});

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
                        ' · ${set.total} cartas',
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
