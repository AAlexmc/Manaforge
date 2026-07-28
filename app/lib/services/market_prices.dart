/// Precios de HOY en el mercado elegido, mirando en los dos sitios donde
/// puede haberlos.
///
/// Cardmarket, TCGplayer y Cardhoarder publican precio de hoy (viene en el
/// volcado de cartas). Card Kingdom y Mana Pool NO: de esos solo hay
/// histórico, así que su "precio de hoy" es el último día con dato de la
/// serie descargada — y se marca como tal para no vender por fresco algo que
/// puede ser de la semana pasada.
library;

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/markets.dart';
import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/services/price_series_database.dart';

class MarketPrice {
  final double value;

  /// De qué día es. null = de hoy (viene del volcado de cartas).
  final String? asOf;

  const MarketPrice(this.value, {this.asOf});

  bool get isFresh => asOf == null;
}

class MarketPrices {
  final CardDatabase db;
  final PriceSeriesDatabase series;

  const MarketPrices({required this.db, required this.series});

  /// Precio por carta (nivel oracle) en [market].
  Future<Map<String, MarketPrice>> byOracle(
      Iterable<String> oracleIds, Market market) async {
    final ids = oracleIds.toSet();
    if (ids.isEmpty) return const {};
    if (market.hasTodayPrice) {
      final today = await db.pricesForOracles(ids, market: market);
      if (today.isNotEmpty) {
        return {for (final e in today.entries) e.key: MarketPrice(e.value)};
      }
    }
    // sin precio de hoy: el último día del histórico de ESE mercado
    final history = await series.seriesFor(ids, market: market);
    final out = <String, MarketPrice>{};
    history.forEach((id, points) {
      if (points.isEmpty) return;
      final last = points.last;
      out[id] = MarketPrice(last.value, asOf: last.date);
    });
    return out;
  }

  /// Serie histórica en el mercado elegido, ya fusionada con lo que la app
  /// apunta a diario (que es de Cardmarket: en otros mercados no se mezcla).
  Future<Map<String, List<PricePoint>>> historyFor(
          Iterable<String> oracleIds, Market market) =>
      priceHistoryStore.forCards(oracleIds, market: market);
}
