import 'package:flutter/material.dart';

import '../services/market_prefs.dart';
import '../services/markets.dart';

/// Botones para elegir mercado. Los que no tienen datos en las bases
/// descargadas salen apagados y dicen por qué: es mejor eso que enseñar un
/// mercado vacío y que parezca que la carta no vale nada.
class MarketPicker extends StatelessWidget {
  final MarketPreference preference;

  /// Mercados con histórico en la base descargada (los de precio de hoy
  /// siempre se pueden elegir).
  final Set<Market> available;

  const MarketPicker(
      {super.key, required this.preference, this.available = const {}});

  bool _usable(Market m) => m.hasTodayPrice || available.contains(m);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: preference,
      builder: (context, _) {
        return SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final market in Market.values)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text('${market.label} · ${market.symbol}'),
                    selected: preference.market == market,
                    onSelected: _usable(market)
                        ? (_) => preference.select(market)
                        : null,
                    tooltip: _usable(market)
                        ? (market.digital
                            ? 'Precios de MTGO en tix (cartas digitales)'
                            : null)
                        : 'Sin datos todavía: actualiza el histórico de '
                            'precios en Mercado',
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Aviso de que el mercado elegido no manda en el valor de la colección.
class MarketNote extends StatelessWidget {
  final Market market;

  const MarketNote({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    if (market == Market.cardmarket) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        market.digital
            ? 'Precios de MTGO en tix: son cartas digitales, no valen para '
                'tasar tu colección de papel. Inicio, carpetas y logros '
                'siguen en Cardmarket (€).'
            : 'Precios de ${market.label} en ${market.currency}. Inicio, '
                'carpetas y logros siguen valorando en Cardmarket (€): las '
                'divisas no se convierten.',
        style: const TextStyle(fontSize: 11.5),
      ),
    );
  }
}
