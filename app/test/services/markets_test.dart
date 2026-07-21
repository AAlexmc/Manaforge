/// Mercados: divisas, formato y preferencia guardada.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/market_prefs.dart';
import 'package:manaforge_app/services/markets.dart';

void main() {
  test('cada mercado dice su divisa y de dónde sale su precio de hoy', () {
    expect(Market.cardmarket.currency, 'EUR');
    expect(Market.cardmarket.hasTodayPrice, isTrue);
    expect(Market.tcgplayer.todayColumn, 'price_usd');
    // Card Kingdom y Mana Pool solo tienen histórico (MTGJSON)
    expect(Market.cardkingdom.hasTodayPrice, isFalse);
    expect(Market.manapool.hasTodayPrice, isFalse);
    expect(Market.cardhoarder.digital, isTrue);
  });

  test('el dinero se escribe como en cada sitio', () {
    expect(formatMoney(12.3, Market.cardmarket), '12.30 €');
    expect(formatMoney(12.3, Market.tcgplayer), r'$12.30');
    expect(formatMoney(0.5, Market.cardhoarder), '0.50 tix');
  });

  test('un id desconocido cae a Cardmarket, no revienta', () {
    expect(Market.byId('starcitygames'), Market.cardmarket);
    expect(Market.byId(null), Market.cardmarket);
    expect(Market.byId('manapool'), Market.manapool);
  });

  test('la preferencia se recuerda entre arranques', () async {
    final dir = Directory.systemTemp.createTempSync('mf_market');
    addTearDown(() => dir.deleteSync(recursive: true));

    final prefs = MarketPreference(dataDir: dir);
    expect(prefs.market, Market.cardmarket);
    prefs.select(Market.tcgplayer);
    await prefs.pendingSave;

    final again = MarketPreference(dataDir: dir);
    await again.load();
    expect(again.market, Market.tcgplayer);
  });

  test('un market.json roto deja Cardmarket', () async {
    final dir = Directory.systemTemp.createTempSync('mf_market');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/market.json').writeAsStringSync('{');
    final prefs = MarketPreference(dataDir: dir);
    await prefs.load();
    expect(prefs.market, Market.cardmarket);
  });
}
