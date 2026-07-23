import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../theme/mf_theme.dart';

/// Un paso de un tour guiado.
///
/// Puede, antes de enseñarse, cambiar de pestaña ([goToScreen], índice de
/// PANTALLA) y luego señalar algo:
///  - un botón concreto por [targetKey] (foco sobre su rectángulo real), o
///  - un destino de la barra de abajo por [navBarIndex] (foco por fracción del
///    ancho, sin depender de la geometría interna de la barra), o
///  - nada: la burbuja va centrada.
class TourStep {
  final int? goToScreen;
  final GlobalKey? targetKey;
  final int? navBarIndex;
  final String title;
  final String body;

  const TourStep({
    this.goToScreen,
    this.targetKey,
    this.navBarIndex,
    required this.title,
    required this.body,
  });
}

/// Pinta un tour guiado por encima de la app: scrim oscuro con un foco sobre lo
/// que señala cada paso y una burbuja que lo explica, con Atrás/Siguiente/Saltar.
class TourOverlay extends StatefulWidget {
  final List<TourStep> steps;

  /// Cuántos destinos tiene la barra (para el foco por fracción).
  final int navItemCount;
  final double navBarHeight;

  /// Cambiar de pestaña (índice de PANTALLA) cuando un paso lo pide.
  final void Function(int screen)? onGoToScreen;

  /// Al terminar o saltar.
  final VoidCallback onDone;

  const TourOverlay({
    super.key,
    required this.steps,
    required this.navItemCount,
    required this.onDone,
    this.onGoToScreen,
    this.navBarHeight = 80,
  });

  @override
  State<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends State<TourOverlay> {
  int _i = 0;
  Rect? _targetRect; // rect medido del botón señalado, si hay

  @override
  void initState() {
    super.initState();
    _entrarEnPaso(_i, primeraVez: true);
  }

  void _entrarEnPaso(int i, {bool primeraVez = false}) {
    final step = widget.steps[i];
    _targetRect = null;
    // TODO en el siguiente frame: cambiar de pantalla (onGoToScreen hace
    // setState en el padre, y esto puede llamarse DURANTE su build —initState—,
    // que reventaría con "setState durante build"); y solo entonces medir el
    // botón, que necesita estar ya colocado tras el cambio de pantalla.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (step.goToScreen != null) {
        widget.onGoToScreen?.call(step.goToScreen!);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _medir());
    });
  }

  void _medir() {
    final step = widget.steps[_i];
    final key = step.targetKey;
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final pos = box.localToGlobal(Offset.zero);
    if (!mounted) return;
    setState(() => _targetRect = pos & box.size);
  }

  void _siguiente() {
    if (_i >= widget.steps.length - 1) {
      widget.onDone();
    } else {
      setState(() => _i++);
      _entrarEnPaso(_i);
    }
  }

  void _atras() {
    if (_i == 0) return;
    setState(() => _i--);
    _entrarEnPaso(_i);
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_i];
    final ultimo = _i == widget.steps.length - 1;

    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final inset = MediaQuery.viewPaddingOf(context).bottom;

          // geometría del foco: rect de un botón, círculo en la barra, o nada
          Rect? foco;
          if (_targetRect != null) {
            foco = _targetRect!.inflate(8);
          } else if (step.navBarIndex != null) {
            final cx = (step.navBarIndex! + 0.5) / widget.navItemCount * w;
            final cy = h - inset - widget.navBarHeight / 2;
            foco = Rect.fromCircle(center: Offset(cx, cy), radius: 38);
          }

          // la burbuja: si el foco está en la mitad de abajo, la burbuja va
          // arriba de él; si está arriba, debajo; si no hay foco, centrada
          final Widget burbuja = _Burbuja(
            title: step.title,
            body: step.body,
            paso: _i + 1,
            total: widget.steps.length,
            ultimo: ultimo,
            primero: _i == 0,
            onSaltar: widget.onDone,
            onSiguiente: _siguiente,
            onAtras: _atras,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {},
                  child: CustomPaint(
                    painter: _FocoPainter(foco: foco),
                  ),
                ),
              ),
              if (foco != null)
                Positioned(
                  left: foco.left,
                  top: foco.top,
                  child: IgnorePointer(
                    child: Container(
                      width: foco.width,
                      height: foco.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            foco.shortestSide / 2 > 14
                                ? 14
                                : foco.shortestSide / 2),
                        border: Border.all(color: MFColors.forge, width: 2),
                      ),
                    ),
                  ),
                ),
              _colocarBurbuja(foco, h, inset, burbuja),
            ],
          );
        },
      ),
    );
  }

  /// Coloca la burbuja lejos del foco para no taparlo.
  Widget _colocarBurbuja(Rect? foco, double h, double inset, Widget burbuja) {
    if (foco == null) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: burbuja),
      );
    }
    final focoAbajo = foco.center.dy > h / 2;
    return Positioned(
      left: 20,
      right: 20,
      top: focoAbajo ? null : foco.bottom + 16,
      bottom: focoAbajo ? (h - foco.top + 16) : null,
      child: burbuja,
    );
  }
}

class _Burbuja extends StatelessWidget {
  final String title;
  final String body;
  final int paso;
  final int total;
  final bool ultimo;
  final bool primero;
  final VoidCallback onSaltar;
  final VoidCallback onSiguiente;
  final VoidCallback onAtras;

  const _Burbuja({
    required this.title,
    required this.body,
    required this.paso,
    required this.total,
    required this.ultimo,
    required this.primero,
    required this.onSaltar,
    required this.onSiguiente,
    required this.onAtras,
  });

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(fontSize: 13.5, height: 1.3)),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  Text('$paso / $total',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  if (!ultimo)
                    TextButton(onPressed: onSaltar, child: Text(t.onbSkip)),
                  if (!primero)
                    TextButton(onPressed: onAtras, child: Text(t.onbBack)),
                  FilledButton(
                    onPressed: onSiguiente,
                    child: Text(ultimo ? t.onbGotIt : t.onbNext),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scrim oscuro con un agujero (el foco) recortado. Si [foco] es null, oscurece
/// todo (paso sin diana).
class _FocoPainter extends CustomPainter {
  final Rect? foco;

  _FocoPainter({required this.foco});

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Path()..addRect(Offset.zero & size);
    if (foco != null) {
      scrim
        ..addRRect(RRect.fromRectAndRadius(
            foco!, Radius.circular(foco!.shortestSide / 2 > 14 ? 14 : foco!.shortestSide / 2)))
        ..fillType = PathFillType.evenOdd;
    }
    canvas.drawPath(scrim, Paint()..color = Colors.black.withValues(alpha: 0.72));
  }

  @override
  bool shouldRepaint(_FocoPainter old) => old.foco != foco;
}
