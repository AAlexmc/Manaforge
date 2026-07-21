import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/price_history.dart';
import '../services/wishlist_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/price_chart.dart';
import 'card_detail_screen.dart';

/// Pantalla dedicada de la wishlist: las cartas que quieres comprar con su
/// precio objetivo. Cuando el precio actual cae al objetivo, la carta se
/// marca "¡a precio!" (y el Mercado lanza la alerta al refrescar precios).
class WishlistScreen extends StatefulWidget {
  final CardDatabase db;
  final WishlistStore wishlist;

  /// Cambiar el objetivo de una carta (lo gestiona el Mercado, que conoce
  /// el precio actual para la pista del diálogo).
  final Future<void> Function(WishItem) onEditTarget;

  const WishlistScreen(
      {super.key,
      required this.db,
      required this.wishlist,
      required this.onEditTarget});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  Map<String, List<PricePoint>> _history = const {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
    // al añadir/quitar cartas cambia qué historiales hacen falta
    widget.wishlist.addListener(_loadHistory);
  }

  @override
  void dispose() {
    widget.wishlist.removeListener(_loadHistory);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final h = await priceHistoryStore
          .forCards(widget.wishlist.items.map((i) => i.oracleId));
      if (mounted) setState(() => _history = h);
    } catch (_) {/* sin almacenamiento: lista sin mini-gráficas */}
  }

  String _euro(double v) => '${v.toStringAsFixed(2)} €';

  @override
  Widget build(BuildContext context) {
    final wishlist = widget.wishlist;
    final db = widget.db;
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: ListenableBuilder(
        listenable: wishlist,
        builder: (context, _) {
          final items = wishlist.items;
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_border, size: 56),
                    SizedBox(height: 12),
                    Text(
                      'Aún no tienes cartas en la wishlist.\n'
                      'Búscalas en Mercado y toca el marcador para que te '
                      'avise cuando bajen a tu precio.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          final atPrice = items.where((i) => i.inRange).length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (atPrice > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MFColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '🔔 $atPrice carta${atPrice == 1 ? '' : 's'} de tu '
                    'wishlist ${atPrice == 1 ? 'está' : 'están'} a tu precio '
                    'objetivo o por debajo.',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: MFColors.success),
                  ),
                ),
              for (final item in items)
                Card(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CardDetailScreen(
                            db: db,
                            collection: null,
                            oracleId: item.oracleId),
                      ),
                    ),
                    leading: CardThumb(
                        url: item.imageSmall,
                        colors: item.colors,
                        name: item.name),
                    title: Text(item.printedName ?? item.name),
                    subtitle: Text(
                      'objetivo ≤ ${_euro(item.targetPrice)}'
                      '${item.lastPrice != null ? '  ·  ahora ${_euro(item.lastPrice!)}' : ''}',
                      style: TextStyle(
                          color: item.inRange ? MFColors.success : null,
                          fontWeight:
                              item.inRange ? FontWeight.bold : null),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MiniPriceLine(
                            points: _history[item.oracleId] ?? const []),
                        const SizedBox(width: 6),
                        if (item.inRange)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.notifications_active,
                                color: MFColors.success, size: 20),
                          ),
                        IconButton(
                          tooltip: 'Cambiar precio objetivo',
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => widget.onEditTarget(item),
                        ),
                        IconButton(
                          tooltip: 'Quitar de la wishlist',
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => wishlist.remove(item.oracleId),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
