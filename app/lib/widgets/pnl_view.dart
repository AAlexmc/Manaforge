/// "Lo pagaste a X, hoy vale Y": el P&L de la colección, en una tarjeta.
///
/// Vive aparte de la pantalla del Mercado porque lo delicado de esto no es
/// pintarlo: es DECIR sobre cuántas cartas está medido. Un "+42 %" sin la
/// letra pequeña de "sobre 210 de 283 copias" es un número que engaña.
library;

import 'package:flutter/material.dart';

import '../services/markets.dart';
import '../services/pnl.dart';
import '../theme/mf_theme.dart';

class PnlView extends StatelessWidget {
  final PnL pnl;

  /// Mercado con el que se formatean los importes (el canónico: Cardmarket).
  final Market market;

  const PnlView({super.key, required this.pnl, required this.market});

  @override
  Widget build(BuildContext context) {
    if (!pnl.hasData) return _sinDatos(context);
    final sube = pnl.delta >= 0;
    final color = sube ? MFColors.success : MFColors.manaRed;
    final pct = pnl.percent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pagaste ${formatMoney(pnl.paid, market)} · '
            'hoy valen ${formatMoney(pnl.value, market)}'),
        const SizedBox(height: 2),
        Text(
          '${sube ? '+' : '−'}${formatMoney(pnl.delta.abs(), market)}'
          '${pct == null ? '' : ' (${sube ? '+' : '−'}'
              '${pct.abs().toStringAsFixed(1)} %)'}',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 2),
        Text(_alcance(), style: const TextStyle(fontSize: 11.5)),
        for (final aviso in _avisos())
          Text('· $aviso', style: const TextStyle(fontSize: 11.5)),
      ],
    );
  }

  Widget _sinDatos(BuildContext context) => const Text(
        'Sin precio de compra no hay P&L. Importa tu CSV de ManaBox con la '
        'columna "Purchase price" y aparece aquí.',
        style: TextStyle(fontSize: 11.5),
      );

  /// Sobre cuántas copias está medido. Es la línea que evita que el
  /// porcentaje se lea como si cubriera toda la colección.
  String _alcance() => pnl.complete
      ? 'sobre las ${pnl.totalCopies} copias de tu colección'
      : 'sobre ${pnl.copies} de ${pnl.totalCopies} copias '
          '(las demás no tienen precio de compra apuntado)';

  List<String> _avisos() => [
        if (pnl.copiesWithoutPrice > 0)
          '${pnl.copiesWithoutPrice} copias compradas no tienen precio de hoy '
              'en la base: fuera de la cuenta',
        for (final e in pnl.otherCurrencies.entries)
          'también pagaste ${e.value.toStringAsFixed(2)} ${e.key}, '
              'que no se convierte',
        if (pnl.copiesAssumedCurrency > 0)
          '${pnl.copiesAssumedCurrency} copias sin divisa en el CSV: se '
              'suponen ${market.currency}',
      ];
}
