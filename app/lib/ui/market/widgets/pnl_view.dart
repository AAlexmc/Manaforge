/// "Lo pagaste a X, hoy vale Y": el P&L de la colección, en una tarjeta.
///
/// Vive aparte de la pantalla del Mercado porque lo delicado de esto no es
/// pintarlo: es DECIR sobre cuántas cartas está medido. Un "+42 %" sin la
/// letra pequeña de "sobre 210 de 283 copias" es un número que engaña.
library;

import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';

import 'package:manaforge_app/data/services/markets.dart';
import 'package:manaforge_app/domain/pnl.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';

class PnlView extends StatelessWidget {
  final PnL pnl;

  /// Mercado con el que se formatean los importes (el canónico: Cardmarket).
  final Market market;

  const PnlView({super.key, required this.pnl, required this.market});

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    if (!pnl.hasData) return _sinDatos(context);
    final sube = pnl.delta >= 0;
    final color = sube ? MFColors.success : MFColors.manaRed;
    final pct = pnl.percent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.pnPaidVsToday(formatMoney(pnl.paid, market),
            formatMoney(pnl.value, market))),
        const SizedBox(height: 2),
        Text(
          '${sube ? '+' : '−'}${formatMoney(pnl.delta.abs(), market)}'
          '${pct == null ? '' : ' (${sube ? '+' : '−'}'
              '${pct.abs().toStringAsFixed(1)} %)'}',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 2),
        Text(_alcance(t), style: const TextStyle(fontSize: 11.5)),
        for (final aviso in _avisos(t))
          Text('· $aviso', style: const TextStyle(fontSize: 11.5)),
      ],
    );
  }

    Widget _sinDatos(BuildContext context) => Text(
        tr(context).pnNoPnl,
        style: const TextStyle(fontSize: 11.5),
      );

  /// Sobre cuántas copias está medido. Es la línea que evita que el
  /// porcentaje se lea como si cubriera toda la colección.
    String _alcance(AppLocalizations t) => pnl.complete
      ? t.pnOverAll(pnl.totalCopies)
      : t.pnOverSome(pnl.copies, pnl.totalCopies);

    List<String> _avisos(AppLocalizations t) => [
        if (pnl.copiesWithoutPrice > 0)
          t.pnNoTodayPrice(pnl.copiesWithoutPrice),
        for (final e in pnl.otherCurrencies.entries)
          t.pnOtherCurrency(e.value.toStringAsFixed(2), e.key),
        if (pnl.copiesAssumedCurrency > 0)
          t.pnAssumedCurrency(pnl.copiesAssumedCurrency, market.currency),
      ];
}
