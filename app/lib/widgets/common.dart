import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/theme/mf_theme.dart';

/// En escritorio, las listas horizontales no se pueden arrastrar con el
/// ratón por defecto: este comportamiento lo permite (tiras de cartas,
/// banners de expansiones…).
class DragScrollBehavior extends MaterialScrollBehavior {
  const DragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

/// Color de cada símbolo de maná (tokens del DesignSystem).
const Map<String, Color> manaColors = {
  'W': MFColors.manaWhite,
  'U': MFColors.manaBlue,
  'B': MFColors.manaBlack,
  'R': MFColors.manaRed,
  'G': MFColors.manaGreen,
};

/// Puntos de identidad de color de una carta o mazo.
class ColorIdentityDots extends StatelessWidget {
  final String colors; // "WB", "U", "" (incolora)
  final double size;

  const ColorIdentityDots({super.key, required this.colors, this.size = 13});

  @override
  Widget build(BuildContext context) {
    final dots = colors.isEmpty ? ['C'] : colors.split('');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in dots)
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: manaColors[c] ?? Colors.blueGrey,
              ),
            ),
          ),
      ],
    );
  }
}

/// Mini-curva de maná (7 barras, 0-6+) para tarjetas de mazo.
class MiniCurve extends StatelessWidget {
  final Map<int, int> histogram;
  final Color color;
  final double height;

  const MiniCurve(
      {super.key,
      required this.histogram,
      required this.color,
      this.height = 36});

  @override
  Widget build(BuildContext context) {
    final max = histogram.values.fold(1, (a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var cmc = 0; cmc <= 6; cmc++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                height: 4 + height * (histogram[cmc] ?? 0) / max,
                decoration: BoxDecoration(
                  color: (histogram[cmc] ?? 0) > 0
                      ? color
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Imagen de carta con los estados del DesignSystem: skeleton con el color
/// de identidad mientras carga, y nombre sobre skeleton si falla. Nunca un
/// hueco blanco.
class CardThumb extends StatelessWidget {
  final String? url;
  final String colors;
  final String name;
  final double width;
  final double height;
  final double radius;

  const CardThumb({
    super.key,
    required this.url,
    required this.colors,
    required this.name,
    this.width = 36,
    this.height = 50,
    this.radius = 5,
  });

  Color get _identityColor {
    if (colors.length == 1) {
      return manaColors[colors] ?? Colors.blueGrey;
    }
    return colors.isEmpty
        ? Colors.blueGrey
        : manaColors[colors[0]] ?? Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _identityColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: url == null
          ? Text(
              name.isEmpty ? '' : name[0],
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            )
          : null,
    );
    if (url == null) return skeleton;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : skeleton,
        errorBuilder: (context, error, stack) => skeleton,
      ),
    );
  }
}

/// Histograma de curva "de verdad" para el detalle del mazo: ancho acotado
/// (en escritorio las barras no deben ocupar toda la ventana), número de
/// cartas encima de cada barra y etiquetas de coste debajo.
class CurveChart extends StatelessWidget {
  final Map<int, int> histogram;
  final Color color;
  final double height;

  const CurveChart(
      {super.key,
      required this.histogram,
      required this.color,
      this.height = 120});

  @override
  Widget build(BuildContext context) {
    var max = 1;
    for (var cmc = 0; cmc <= 6; cmc++) {
      final v = histogram[cmc] ?? 0;
      if (v > max) max = v;
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var cmc = 0; cmc <= 6; cmc++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (histogram[cmc] ?? 0) > 0 ? '${histogram[cmc]}' : '',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 6 + height * (histogram[cmc] ?? 0) / max,
                        decoration: BoxDecoration(
                          color: (histogram[cmc] ?? 0) > 0
                              ? color
                              : color.withValues(alpha: 0.15),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(cmc == 6 ? '6+' : '$cmc',
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Editor de curva: las mismas barras, pero arrastrables ↑↓. Escala fija
/// (no relativa al máximo) para que el gesto se sienta absoluto.
class CurveEditor extends StatefulWidget {
  final Map<int, int> values;
  final Color color;
  final double height;
  final ValueChanged<Map<int, int>> onChanged;

  const CurveEditor(
      {super.key,
      required this.values,
      required this.color,
      required this.onChanged,
      this.height = 120});

  @override
  State<CurveEditor> createState() => _CurveEditorState();
}

class _CurveEditorState extends State<CurveEditor> {
  static const _maxPerSlot = 16;
  late Map<int, double> _floats;

  @override
  void initState() {
    super.initState();
    _floats = {
      for (var cmc = 0; cmc <= 6; cmc++)
        cmc: (widget.values[cmc] ?? 0).toDouble()
    };
  }

  void _drag(int cmc, double dy) {
    setState(() {
      _floats[cmc] =
          (_floats[cmc]! - dy / 7).clamp(0.0, _maxPerSlot.toDouble());
    });
    widget.onChanged(
        {for (final e in _floats.entries) e.key: e.value.round()});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var cmc = 0; cmc <= 6; cmc++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (d) => _drag(cmc, d.delta.dy),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${_floats[cmc]!.round()}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: widget.color)),
                        const SizedBox(height: 2),
                        Container(
                          height: 6 +
                              widget.height *
                                  _floats[cmc]!.round() /
                                  _maxPerSlot,
                          decoration: BoxDecoration(
                            color: _floats[cmc]!.round() > 0
                                ? widget.color
                                : widget.color.withValues(alpha: 0.2),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                            border: Border.all(
                                color: widget.color.withValues(alpha: 0.6)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(cmc == 6 ? '6+' : '$cmc',
                            style: const TextStyle(fontSize: 10)),
                        Icon(Icons.unfold_more,
                            size: 12,
                            color: widget.color.withValues(alpha: 0.6)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/// Una carta dentro del visor a pantalla completa.
class ZoomCard {
  final String name;
  final String? imageUrl;
  final String colors;

  /// Abrir la ficha completa de ESTA carta (precios, legalidad). Opcional.
  final VoidCallback? onDetails;

  const ZoomCard(
      {required this.name,
      this.imageUrl,
      this.colors = '',
      this.onDetails});
}

/// Visor de carta a pantalla completa: toca una carta en cualquier parte de
/// la app y se amplía (con zoom de pellizco/rueda). Toca fuera para cerrar.
void showCardZoom(BuildContext context,
        {required String name,
        String? imageUrl,
        String colors = '',
        VoidCallback? onDetails}) =>
    showCardZoomList(context, cards: [
      ZoomCard(
          name: name,
          imageUrl: imageUrl,
          colors: colors,
          onDetails: onDetails)
    ], index: 0);

/// Igual, pero sabiendo qué cartas hay AL LADO: se pasa a la siguiente y a la
/// anterior arrastrando, con las flechas del teclado o con los botones de los
/// lados. Sin esto, mirar un álbum de 274 cartas es abrir y cerrar 274 veces.
void showCardZoomList(BuildContext context,
    {required List<ZoomCard> cards, required int index}) {
  if (cards.isEmpty) return;
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.88),
    builder: (context) =>
        _CardZoomView(cards: cards, index: index.clamp(0, cards.length - 1)),
  );
}

class _CardZoomView extends StatefulWidget {
  final List<ZoomCard> cards;
  final int index;

  const _CardZoomView({required this.cards, required this.index});

  @override
  State<_CardZoomView> createState() => _CardZoomViewState();
}

class _CardZoomViewState extends State<_CardZoomView> {
  late final PageController _pages = PageController(initialPage: widget.index);
  late int _current = widget.index;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final destino = _current + delta;
    if (destino < 0 || destino >= widget.cards.length) return;
    _pages.animateToPage(destino,
        duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final varias = widget.cards.length > 1;
    final card = widget.cards[_current];
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _go(1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _go(-1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        // tocar el fondo cierra; la carta y los botones no
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Row(
                children: [
                  _Arrow(
                    icon: Icons.chevron_left,
                    visible: varias && _current > 0,
                    onTap: () => _go(-1),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pages,
                      // con una sola carta no hay a dónde ir: que no rebote
                      physics: varias
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      onPageChanged: (i) => setState(() => _current = i),
                      itemCount: widget.cards.length,
                      itemBuilder: (context, i) => _ZoomImage(card: widget.cards[i]),
                    ),
                  ),
                  _Arrow(
                    icon: Icons.chevron_right,
                    visible: varias && _current < widget.cards.length - 1,
                    onTap: () => _go(1),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(card.name,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            if (varias)
              Text('${_current + 1} / ${widget.cards.length}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
            if (card.onDetails != null)
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  card.onDetails!();
                },
                icon: const Icon(Icons.info_outline, size: 18),
                label: Text(tr(context).cmFullCard),
              ),
            Text(
                varias ? tr(context).cmSwipeHint : tr(context).cmTapOutHint,
                style: const TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

/// Flecha de los lados. Ocupa sitio siempre (aunque esté oculta) para que la
/// carta no dé un salto lateral al llegar al primer o al último hueco.
class _Arrow extends StatelessWidget {
  final IconData icon;
  final bool visible;
  final VoidCallback onTap;

  const _Arrow(
      {required this.icon, required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox(width: 48);
    return SizedBox(
      width: 48,
      child: IconButton(
        icon: Icon(icon, size: 34, color: Colors.white70),
        onPressed: onTap,
      ),
    );
  }
}

class _ZoomImage extends StatelessWidget {
  final ZoomCard card;

  const _ZoomImage({required this.card});

  @override
  Widget build(BuildContext context) {
    final imageUrl = card.imageUrl;
    return InteractiveViewer(
      maxScale: 4,
      child: AspectRatio(
        aspectRatio: 63 / 88,
        child: imageUrl == null
            ? Container(
                decoration: BoxDecoration(
                  color: (manaColors[
                              card.colors.isEmpty ? '' : card.colors[0]] ??
                          Colors.blueGrey)
                      .withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Text(card.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18)),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stack) =>
                      Center(child: Text(card.name, textAlign: TextAlign.center)),
                ),
              ),
      ),
    );
  }
}
