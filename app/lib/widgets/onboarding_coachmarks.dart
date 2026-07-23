import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../theme/mf_theme.dart';

/// Un paso del tour: qué destino de la barra señalar y qué contar.
class CoachStep {
  /// Índice del destino EN LA BARRA (0 = el primero de la izquierda).
  final int barIndex;
  final String title;
  final String body;

  const CoachStep(
      {required this.barIndex, required this.title, required this.body});
}

/// Tour de bienvenida: un scrim oscuro con un foco redondo sobre cada destino
/// de la barra de abajo y una burbuja que lo explica. Sale una sola vez.
///
/// Coloca cada foco por fracciones ((índice + 0,5) / nº de destinos): la barra
/// reparte los destinos a lo ancho por igual, así que no hace falta ir a por la
/// geometría real de cada uno.
class OnboardingCoachmarks extends StatefulWidget {
  final List<CoachStep> steps;

  /// Cuántos destinos tiene la barra (para repartir el ancho).
  final int itemCount;

  /// Alto de la barra de abajo (el foco se centra en su mitad).
  final double navBarHeight;

  /// Se llama al terminar o al saltar: hay que marcar el tour como visto.
  final VoidCallback onDone;

  const OnboardingCoachmarks({
    super.key,
    required this.steps,
    required this.itemCount,
    required this.onDone,
    this.navBarHeight = 80,
  });

  @override
  State<OnboardingCoachmarks> createState() => _OnboardingCoachmarksState();
}

class _OnboardingCoachmarksState extends State<OnboardingCoachmarks> {
  int _paso = 0;

  void _siguiente() {
    if (_paso >= widget.steps.length - 1) {
      widget.onDone();
    } else {
      setState(() => _paso++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_paso];
    final ultimo = _paso == widget.steps.length - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final foco = Offset(
          (step.barIndex + 0.5) / widget.itemCount * w,
          h - widget.navBarHeight / 2,
        );
        const radio = 38.0;

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // el scrim con el agujero del foco. Absorbe los toques para que
              // no se pueda tocar la app por debajo mientras dura el tour.
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {},
                  child: CustomPaint(
                    painter: _FocoPainter(centro: foco, radio: radio),
                  ),
                ),
              ),
              // un aro alrededor del foco, para que se vea qué se señala
              Positioned(
                left: foco.dx - radio,
                top: foco.dy - radio,
                child: IgnorePointer(
                  child: Container(
                    width: radio * 2,
                    height: radio * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MFColors.forge, width: 2),
                    ),
                  ),
                ),
              ),
              // la burbuja, encima de la barra
              Positioned(
                left: 20,
                right: 20,
                bottom: widget.navBarHeight + 24,
                child: _Burbuja(
                  title: step.title,
                  body: step.body,
                  paso: _paso + 1,
                  total: widget.steps.length,
                  ultimo: ultimo,
                  onSaltar: widget.onDone,
                  onSiguiente: _siguiente,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Burbuja extends StatelessWidget {
  final String title;
  final String body;
  final int paso;
  final int total;
  final bool ultimo;
  final VoidCallback onSaltar;
  final VoidCallback onSiguiente;

  const _Burbuja({
    required this.title,
    required this.body,
    required this.paso,
    required this.total,
    required this.ultimo,
    required this.onSaltar,
    required this.onSiguiente,
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
            Row(
              children: [
                Text('$paso / $total',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                if (!ultimo)
                  TextButton(onPressed: onSaltar, child: Text(t.onbSkip)),
                FilledButton(
                  onPressed: onSiguiente,
                  child: Text(ultimo ? t.onbGotIt : t.onbNext),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinta el scrim oscuro con un agujero redondo (el foco) recortado.
class _FocoPainter extends CustomPainter {
  final Offset centro;
  final double radio;

  _FocoPainter({required this.centro, required this.radio});

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Path()
      ..addRect(Offset.zero & size)
      ..addOval(Rect.fromCircle(center: centro, radius: radio))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(scrim, Paint()..color = Colors.black.withValues(alpha: 0.72));
  }

  @override
  bool shouldRepaint(_FocoPainter old) =>
      old.centro != centro || old.radio != radio;
}
