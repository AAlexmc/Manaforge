/// Pinta el fondo elegido detrás de toda la app.
///
/// Dos cosas que no son adorno:
///  - **La capa oscura.** Una foto de arte de Magic detrás de una lista de
///    cartas hace la app ilegible. Encima de la imagen va un velo, regulable,
///    y por eso el fondo se ve pero el texto se sigue leyendo.
///  - **`cacheWidth`.** Un 4K decodificado a pelo son ~33 MB de memoria por
///    cada sitio donde se pinte. Se decodifica al ancho de la ventana.
library;

import 'package:flutter/material.dart';

import 'package:manaforge_app/data/repositories/background_prefs.dart';

class AppBackground extends StatelessWidget {
  final BackgroundPreference prefs;
  final Widget child;

  const AppBackground({super.key, required this.prefs, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        final imagen = prefs.image;
        if (imagen == null) return child;
        final ancho = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio;
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              imagen,
              fit: BoxFit.cover,
              cacheWidth: ancho.round().clamp(320, 3840),
              // una imagen que ya no se puede leer no puede dejar la app en
              // negro con un error rojo: se cae al fondo de siempre
              errorBuilder: (context, _, __) => const SizedBox.shrink(),
            ),
            Container(
              color: Colors.black.withValues(alpha: prefs.dim),
            ),
            child,
          ],
        );
      },
    );
  }
}
