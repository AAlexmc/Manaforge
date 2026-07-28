/// Los mercados de los que ManaForge sabe precios.
///
/// Cada uno publica en SU divisa y con su propio criterio, así que no se
/// mezclan: eligiendo mercado cambian el precio de la carta y su gráfica,
/// pero nada se convierte a otra moneda (eso sería inventarse un número).
///
/// De dónde salen los datos:
///  - **hoy**: del volcado de Scryfall (`printings.price_*`), que trae
///    Cardmarket (EUR), TCGplayer (USD) y Cardhoarder (tix de MTGO);
///  - **histórico (~90 días)**: de MTGJSON, que además de esos trae
///    Card Kingdom y Mana Pool.
///
/// Card Kingdom y Mana Pool NO tienen precio de hoy: se enseña el último día
/// del histórico y se dice. Star City Games no está en ninguna fuente
/// abierta, así que no está (scrapear su web es frágil y de dudosa legalidad).
library;

enum Market {
  cardmarket(
    id: 'cardmarket',
    label: 'Cardmarket',
    currency: 'EUR',
    symbol: '€',
    todayColumn: 'price_eur',
    todayFoilColumn: 'price_eur_foil',
  ),
  tcgplayer(
    id: 'tcgplayer',
    label: 'TCGplayer',
    currency: 'USD',
    symbol: r'$',
    todayColumn: 'price_usd',
    todayFoilColumn: 'price_usd_foil',
  ),
  cardkingdom(
    id: 'cardkingdom',
    label: 'Card Kingdom',
    currency: 'USD',
    symbol: r'$',
  ),
  manapool(
    id: 'manapool',
    label: 'Mana Pool',
    currency: 'USD',
    symbol: r'$',
  ),
  cardhoarder(
    id: 'cardhoarder',
    label: 'Cardhoarder',
    currency: 'TIX',
    symbol: 'tix',
    todayColumn: 'price_tix',
    digital: true,
  );

  /// Clave del proveedor en la base de histórico y en el JSON de ajustes.
  final String id;
  final String label;

  /// Código de divisa (los tix de MTGO no son una divisa, pero se tratan
  /// igual: no se convierten a nada).
  final String currency;
  final String symbol;

  /// Columna de `printings` con el precio de HOY, si la fuente lo publica.
  final String? todayColumn;
  final String? todayFoilColumn;

  /// Mercado de cartas DIGITALES (MTGO). Sus precios no valen para valorar
  /// cartas de papel.
  final bool digital;

  const Market({
    required this.id,
    required this.label,
    required this.currency,
    required this.symbol,
    this.todayColumn,
    this.todayFoilColumn,
    this.digital = false,
  });

  /// ¿Sabemos su precio de hoy, o solo el histórico?
  bool get hasTodayPrice => todayColumn != null;

  /// El símbolo delante ($12,30) o detrás (12,30 €), como se escribe en cada
  /// sitio.
  bool get symbolFirst => currency == 'USD';

  static Market byId(String? id) => values.firstWhere(
        (m) => m.id == id,
        orElse: () => Market.cardmarket,
      );
}

/// "12,30 €" · "$12.30" · "1.20 tix". Dos decimales, siempre con su moneda:
/// un número suelto no dice si son euros o dólares.
String formatMoney(double value, Market market) {
  final n = value.toStringAsFixed(2);
  if (market.symbol == 'tix') return '$n tix';
  return market.symbolFirst ? '${market.symbol}$n' : '$n ${market.symbol}';
}
