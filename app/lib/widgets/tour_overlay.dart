import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/theme/mf_theme.dart';

/// Pantallas que NO son pestaña: se abren encima (Navigator.push). El tour
/// las abre él mismo y las cierra al pasar de paso.
enum TourPush { logros, certificados, escaner }

/// Cosas que hay que hacer ANTES de poder señalar algo: desplegar una sección
/// plegada de Ajustes (plegada, lo de dentro no se puede medir).
enum TourPrep { ajustesDatos, ajustesLaApp }

/// Un paso de un tour guiado.
///
/// Puede, antes de enseñarse, cambiar de pestaña ([goToScreen], índice de
/// PANTALLA), abrir una pantalla de las que se empujan ([push]) y luego
/// señalar algo:
///  - un botón concreto por [targetKey] (foco sobre su rectángulo real), o
///  - un destino de la barra de abajo por [navBarIndex] (foco por fracción del
///    ancho, sin depender de la geometría interna de la barra), o
///  - nada: la burbuja va centrada.
class TourStep {
  final int? goToScreen;

  /// Pantalla empujada que este paso enseña. Los pasos que no la piden
  /// CIERRAN la que hubiera abierto un paso anterior, así que ir y volver por
  /// el tour no deja pantallas apiladas. Repetir la misma en dos pasos
  /// seguidos la deja abierta (no parpadea).
  ///
  /// Se puede combinar con [targetKey] para señalar un botón DE DENTRO de esa
  /// pantalla: el tour se pinta por encima del Navigator, así que la mide sin
  /// problema.
  final TourPush? push;

  /// Qué hay que dejar preparado antes de medir la diana de este paso.
  final TourPrep? prepare;

  /// Botón a señalar. INVARIANTE: si se pone [targetKey], hay que poner también
  /// [goToScreen] con la pantalla donde vive ese botón. El IndexedStack de main
  /// mantiene TODAS las pantallas montadas (aunque no se pinten), así que sin
  /// traer la pantalla al frente se mediría el botón de una pantalla de fondo y
  /// el foco caería en el sitio equivocado.
  final GlobalKey? targetKey;
  final int? navBarIndex;
  final String title;
  final String body;

  const TourStep({
    this.goToScreen,
    this.push,
    this.prepare,
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

  /// Abrir (o cerrar, con null) la pantalla empujada que pide el paso.
  final void Function(TourPush? push)? onPush;

  /// Dejar listo lo que pide el paso (desplegar una sección). Se espera a que
  /// termine —la sección se abre con animación— antes de medir la diana.
  final Future<void> Function(TourPrep? prep)? onPrepare;

  /// Al terminar o saltar.
  final VoidCallback onDone;

  const TourOverlay({
    super.key,
    required this.steps,
    required this.navItemCount,
    required this.onDone,
    this.onGoToScreen,
    this.onPush,
    this.onPrepare,
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
    _entrarEnPaso(_i);
  }

  void _entrarEnPaso(int i) {
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
      // siempre, también con null: un paso sin pantalla empujada cierra la
      // que hubiera abierto el paso anterior
      widget.onPush?.call(step.push);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // lo que el paso necesite tener abierto ANTES de medir (una sección
        // plegada no tiene ni sitio en pantalla). Se espera a la animación.
        final preparar = widget.onPrepare;
        if (preparar != null) {
          await preparar(step.prepare);
          if (!mounted || _i != i) return; // ya se ha ido a otro paso
        }
        _medir();
      });
    });
  }

  /// Cuánto tiempo se sigue remidiendo tras el scroll, para dar tiempo a
  /// que el layout termine de asentar (ver comentario en [_medir]). En
  /// TIEMPO, no en frames: a 120 Hz un presupuesto de frames se queda en la
  /// mitad de margen.
  static const Duration _ventanaRemedicion = Duration(milliseconds: 400);

  Future<void> _medir() async {
    final entrada = _i; // si el usuario cambia de paso a media medición, cortar
    final step = widget.steps[entrada];
    final key = step.targetKey;
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    // si el botón está en una lista con scroll (Ajustes, Forge…), llevarlo a
    // la vista antes de medir; si no hay scroll, es un no-op
    await Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 250), alignment: 0.35);
    if (!mounted || _i != entrada) return;
    // El Future de arriba se cumple durante el propio tick de la animación
    // de scroll, un frame antes de que el layout recoja ese último tramo (y,
    // si el paso acaba de desplegar una sección, esta puede seguir
    // empujando cosas por debajo mientras termina su propia animación).
    // Medir una sola vez justo ahí da un rect "rancio": se remide varios
    // frames más y se sigue el rect hasta que deja de moverse.
    // «Convergió» exige DOS medidas seguidas iguales: con una sola, una
    // repetición casual a mitad de animación (p. ej. la sección desplegando
    // aún — isExpanded miente durante la animación) cortaba antes de tiempo
    // y volvía el rect rancio.
    final sw = Stopwatch()..start();
    var igualesSeguidas = 0;
    while (sw.elapsed < _ventanaRemedicion) {
      await _unFrameMas();
      if (!mounted || _i != entrada) return;
      final fresco = key.currentContext;
      if (fresco == null || !fresco.mounted) return;
      final box = fresco.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      if (rect == _targetRect) {
        if (++igualesSeguidas >= 2) return;
        continue;
      }
      igualesSeguidas = 0;
      setState(() => _targetRect = rect);
    }
  }

  /// Espera a que se pinte un frame más (y a que ese frame exista: si nada
  /// más lo pide, lo agenda él mismo).
  Future<void> _unFrameMas() => WidgetsBinding.instance.endOfFrame;

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
                // AbsorbPointer: el scrim se come TODOS los gestos —tap y
                // arrastre— para que durante el tour no se pueda tocar ni hacer
                // scroll en la app de debajo (si se pudiera, el foco medido
                // quedaría desalineado). La burbuja va por encima en el Stack,
                // así que sigue siendo interactiva.
                child: AbsorbPointer(
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

  /// Coloca la burbuja en el extremo con MÁS hueco libre (descontando
  /// insets), no pegada al borde de la diana: pegada, un foco cerca de un
  /// extremo quedaba tapado por el propio contenido que sigue justo debajo,
  /// encajado entre foco y burbuja.
  Widget _colocarBurbuja(Rect? foco, double h, double inset, Widget burbuja) {
    if (foco == null) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: burbuja),
      );
    }
    // al lado con MÁS hueco libre, no al opuesto del centro: una diana que
    // ocupa media pantalla (la tarjeta «Cómo funciona») invadiría la mitad
    // «opuesta» y la burbuja se le montaría encima
    final insetTop = MediaQuery.viewPaddingOf(context).top;
    final focoAbajo = foco.top - insetTop > (h - inset) - foco.bottom;
    return Positioned(
      left: 20,
      right: 20,
      // el 20 a pelo arriba se metía bajo la barra de estado/notch en
      // edge-to-edge: el overlay vive fuera de todo SafeArea
      top: focoAbajo ? insetTop + 20 : null,
      bottom: focoAbajo ? null : inset + 20,
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
