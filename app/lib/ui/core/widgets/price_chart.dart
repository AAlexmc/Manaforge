import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/data/services/price_history.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';

/// Rangos de la gráfica, como el mercado de Steam (Semana/Mes/Todo).
enum PriceRange {
  week(7),
  month(30),
  all(null);

  final int? days;

  const PriceRange(this.days);
}

/// Cómo se llama cada rango en el idioma del usuario.
String priceRangeLabel(AppLocalizations t, PriceRange range) =>
    switch (range) {
      PriceRange.week => t.pcWeek,
      PriceRange.month => t.pcMonth,
      PriceRange.all => t.pcAll,
    };

/// Gráfica de evolución del precio de UNA carta, estilo mercado de Steam:
/// línea verde sobre rejilla, ejes con precio y fecha, selector de rango y
/// tooltip al pasar/tocar (fecha + precio del punto más cercano).
///
/// El historial es LOCAL y se construye con el uso (Scryfall solo publica
/// el precio de hoy), así que al principio hay pocos puntos: con menos de
/// dos, en vez de una gráfica vacía se explica por qué.
class PriceChart extends StatefulWidget {
  final List<PricePoint> points;

  /// Precio de hoy aunque aún no haya historial (para el texto de ayuda).
  final double? currentPrice;

  const PriceChart({super.key, required this.points, this.currentPrice});

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  PriceRange _range = PriceRange.month;
  int? _hover; // índice del punto bajo el cursor/dedo

  @override
  void didUpdateWidget(PriceChart old) {
    super.didUpdateWidget(old);
    // otro historial: el punto señalado ya no significa lo mismo
    if (!identical(old.points, widget.points)) _hover = null;
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    var shown = filterRange(widget.points, _range.days);
    // si el rango elegido deja menos de dos puntos pero SÍ hay historia
    // más antigua, enseñarla: decir "aún no hay datos" sería mentira
    if (shown.length < 2 && widget.points.length >= 2) {
      shown = widget.points;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(tr(context).pcTitle,
                      style: const TextStyle(fontSize: 13)),
                ),
                for (final r in PriceRange.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: _RangeChip(
                      label: priceRangeLabel(t, r),
                      selected: _range == r,
                      onTap: () => setState(() {
                        _range = r;
                        _hover = null;
                      }),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 170,
              child: shown.length < 2
                  ? _empty(context)
                  : LayoutBuilder(
                      builder: (context, constraints) => MouseRegion(
                        onExit: (_) => setState(() => _hover = null),
                        onHover: (e) => _updateHover(
                            e.localPosition, shown, constraints.maxWidth),
                        child: GestureDetector(
                          onTapDown: (d) => _updateHover(
                              d.localPosition, shown, constraints.maxWidth),
                          onHorizontalDragUpdate: (d) => _updateHover(
                              d.localPosition, shown, constraints.maxWidth),
                          onHorizontalDragEnd: (_) =>
                              setState(() => _hover = null),
                          child: CustomPaint(
                            size: const Size(double.infinity, 170),
                            painter: _PriceChartPainter(
                              points: shown,
                              hover: _hover,
                              line: MFColors.success,
                              grid: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.5),
                              text: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color ??
                                  Colors.grey,
                              tooltipBg: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              tooltipFg:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            if (shown.length >= 2) ...[
              const SizedBox(height: 6),
              _summary(context, shown),
            ],
          ],
        ),
      ),
    );
  }

  /// Punto más cercano al cursor: misma geometría que el painter (dibuja
  /// entre padLeft y width−padRight sobre el MISMO lienzo del gesto).
  void _updateHover(Offset pos, List<PricePoint> shown, double width) {
    if (shown.length < 2) return;
    final usable =
        width - _PriceChartPainter.padLeft - _PriceChartPainter.padRight;
    if (usable <= 0) return;
    final t =
        ((pos.dx - _PriceChartPainter.padLeft) / usable).clamp(0.0, 1.0);
    final i = (t * (shown.length - 1)).round();
    if (i != _hover) setState(() => _hover = i);
  }

    Widget _empty(BuildContext context) {
    final t = tr(context);
    final price = widget.currentPrice;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // el texto explicativo es largo y la caja tiene alto fijo: los
        // Flexible evitan que se recorte por abajo en pantallas estrechas
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart,
                size: 34,
                color: Theme.of(context).dividerColor),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                price == null
                    ? t.pcNoHistory
                    : t.pcTodayPrice(price.toStringAsFixed(2)),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                t.pcExplain,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(BuildContext context, List<PricePoint> shown) {
    final first = shown.first.value;
    final last = shown.last.value;
    final diff = last - first;
    final pct = first == 0 ? 0.0 : diff / first * 100;
    final up = diff >= 0;
    var min = shown.first.value, max = shown.first.value;
    for (final pt in shown) {
      if (pt.value < min) min = pt.value;
      if (pt.value > max) max = pt.value;
    }
    return Row(
      children: [
        Icon(up ? Icons.trending_up : Icons.trending_down,
            size: 16, color: up ? MFColors.success : MFColors.manaRed),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            '${up ? '+' : ''}${diff.toStringAsFixed(2)} € '
            '(${pct.toStringAsFixed(1)}%)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: up ? MFColors.success : MFColors.manaRed),
          ),
        ),
        const SizedBox(width: 8),
        // en pantallas estrechas se recorta esto antes que la variación
        Flexible(
          child: Text(
                        tr(context).pcRange(min.toStringAsFixed(2),
                max.toStringAsFixed(2), shown.length),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

/// Comparación por CONTENIDO (longitud + extremos): las listas de puntos
/// pueden llegar mutadas en sitio desde el almacén, así que comparar por
/// identidad dejaría la gráfica congelada con datos viejos.
bool _samePoints(List<PricePoint> a, List<PricePoint> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  if (a.isEmpty) return true;
  return a.first.date == b.first.date &&
      a.first.value == b.first.value &&
      a.last.date == b.last.date &&
      a.last.value == b.last.value;
}

/// Línea de tendencia en miniatura para una fila de lista (Mercado,
/// wishlist): solo la forma, verde si sube y roja si baja respecto al
/// primer punto del tramo. Vacía si aún no hay dos días apuntados.
class MiniPriceLine extends StatelessWidget {
  final List<PricePoint> points;
  final double width;
  final double height;

  const MiniPriceLine(
      {super.key,
      required this.points,
      this.width = 54,
      this.height = 22});

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return SizedBox(width: width, height: height);
    final up = points.last.value >= points.first.value;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _MiniLinePainter(
            points, up ? MFColors.success : MFColors.manaRed),
      ),
    );
  }
}

class _MiniLinePainter extends CustomPainter {
  final List<PricePoint> points;
  final Color color;

  _MiniLinePainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    var min = points.first.value, max = points.first.value;
    for (final pt in points) {
      if (pt.value < min) min = pt.value;
      if (pt.value > max) max = pt.value;
    }
    final range = (max - min).abs() < 0.001 ? 1.0 : max - min;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height -
          (points[i].value - min) / range * (size.height - 4) -
          2;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 1.6
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(_MiniLinePainter old) =>
      old.color != color || !_samePoints(old.points, points);
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodySmall?.color,
            )),
      ),
    );
  }
}

class _PriceChartPainter extends CustomPainter {
  static const padLeft = 46.0; // sitio para las etiquetas de precio
  static const padRight = 8.0;
  static const padTop = 8.0;
  static const padBottom = 20.0; // sitio para las fechas

  final List<PricePoint> points;
  final int? hover;
  final Color line;
  final Color grid;
  final Color text;
  final Color tooltipBg;
  final Color tooltipFg;

  _PriceChartPainter({
    required this.points,
    required this.hover,
    required this.line,
    required this.grid,
    required this.text,
    required this.tooltipBg,
    required this.tooltipFg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    var min = points.first.value, max = points.first.value;
    for (final pt in points) {
      if (pt.value < min) min = pt.value;
      if (pt.value > max) max = pt.value;
    }
    // margen del 8 % arriba y abajo para que la línea no pegue al borde;
    // si el precio no se ha movido, se abre un rango artificial
    if ((max - min).abs() < 0.005) {
      final mid = max == 0 ? 1.0 : max;
      min = mid * 0.95;
      max = mid * 1.05;
    } else {
      final pad = (max - min) * 0.08;
      min -= pad;
      max += pad;
    }
    final w = size.width - padLeft - padRight;
    final h = size.height - padTop - padBottom;
    if (w <= 0 || h <= 0) return;

    double xOf(int i) => padLeft + w * i / (points.length - 1);
    double yOf(double v) => padTop + h - (v - min) / (max - min) * h;

    // rejilla horizontal + etiquetas de precio
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    const rows = 4;
    for (var r = 0; r <= rows; r++) {
      final y = padTop + h * r / rows;
      canvas.drawLine(Offset(padLeft, y), Offset(padLeft + w, y), gridPaint);
      final value = max - (max - min) * r / rows;
      _label(canvas, '${value.toStringAsFixed(2)} €',
          Offset(padLeft - 5, y), text, alignRight: true, centerY: true);
    }

    // fechas: primera y última (y la del medio si caben)
    _label(canvas, _shortDate(points.first.date), Offset(padLeft, size.height - 13),
        text);
    _label(canvas, _shortDate(points.last.date),
        Offset(padLeft + w, size.height - 13), text, alignRight: true);
    if (points.length >= 5 && w > 220) {
      final mid = points.length ~/ 2;
      _label(canvas, _shortDate(points[mid].date),
          Offset(xOf(mid), size.height - 13), text, centerX: true);
    }

    // área bajo la línea + línea
    final path = Path()..moveTo(xOf(0), yOf(points.first.value));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(xOf(i), yOf(points[i].value));
    }
    final area = Path.from(path)
      ..lineTo(xOf(points.length - 1), padTop + h)
      ..lineTo(xOf(0), padTop + h)
      ..close();
    canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              line.withValues(alpha: 0.28),
              line.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(padLeft, padTop, w, h)));
    canvas.drawPath(
        path,
        Paint()
          ..color = line
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round);

    // punto señalado + tooltip
    final hi = hover;
    if (hi != null && hi >= 0 && hi < points.length) {
      final pt = points[hi];
      final x = xOf(hi);
      final y = yOf(pt.value);
      canvas.drawLine(Offset(x, padTop), Offset(x, padTop + h),
          Paint()..color = line.withValues(alpha: 0.45));
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = line);
      _tooltip(canvas, size, x, y,
          '${_shortDate(pt.date)}   ${pt.value.toStringAsFixed(2)} €');
    }
  }

  void _tooltip(Canvas canvas, Size size, double x, double y, String label) {
    final tp = TextPainter(
      text: TextSpan(
          text: label,
          style: TextStyle(
              fontSize: 11.5,
              color: tooltipFg,
              fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout();
    const padH = 7.0, padV = 4.0;
    final boxW = tp.width + padH * 2;
    final boxH = tp.height + padV * 2;
    // el globo se mantiene dentro del lienzo y por encima del punto
    var left = (x - boxW / 2).clamp(0.0, size.width - boxW);
    var top = y - boxH - 10;
    if (top < 0) top = y + 10;
    final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, boxW, boxH), const Radius.circular(5));
    canvas.drawRRect(rect, Paint()..color = tooltipBg);
    canvas.drawRRect(
        rect,
        Paint()
          ..color = grid
          ..style = PaintingStyle.stroke);
    tp.paint(canvas, Offset(left + padH, top + padV));
  }

  void _label(Canvas canvas, String s, Offset at, Color color,
      {bool alignRight = false,
      bool centerX = false,
      bool centerY = false}) {
    final tp = TextPainter(
      text: TextSpan(
          text: s, style: TextStyle(fontSize: 10, color: color)),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = at.dx;
    if (alignRight) dx -= tp.width;
    if (centerX) dx -= tp.width / 2;
    var dy = at.dy;
    if (centerY) dy -= tp.height / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  /// 'YYYY-MM-DD' → '3 mar' (compacto como en la gráfica de Steam).
  static String _shortDate(String iso) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (m == null || d == null || m < 1 || m > 12) return iso;
    return '$d ${months[m - 1]}';
  }

  @override
  bool shouldRepaint(_PriceChartPainter old) =>
      old.hover != hover ||
      old.line != line ||
      old.grid != grid ||
      old.text != text ||
      old.tooltipBg != tooltipBg ||
      old.tooltipFg != tooltipFg ||
      !_samePoints(old.points, points);
}
