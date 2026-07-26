/// Las dianas del tour de Ajustes dentro de "La app" se pueden MEDIR sin
/// hacer scroll a mano ni reventar: una vez desplegada la sección, el
/// GlobalKey de cada tarjeta tiene contexto y rectángulo real.
///
/// Cubre las dos paradas nuevas del tour (PR buzón de sugerencias / apoyar
/// el proyecto), con el mismo patrón que `forge_tour_targets_test.dart`.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/screens.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/tours.dart';

import '../helpers/app_l10n.dart';

CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));

void main() {
  testWidgets(
      'las dianas de "La app" (cómo funciona, sugerencias, apoyar) están '
      'montadas al desplegar la sección', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final k = TourKeys();
    await tester.pumpWidget(appDePrueba(
      home: AjustesScreen(
        db: _sinBase(),
        onRestored: () {},
        comoFuncionaKey: k.ajustesComoFunciona,
        sugerenciasKey: k.ajustesSugerencias,
        apoyarKey: k.ajustesApoyar,
      ),
    ));
    await tester.pump();

    // "La app" nace plegada: sin abrirla, sus tarjetas no tienen ni sitio
    await tester.tap(find.text('La app'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final dianas = {
      'cómo funciona': k.ajustesComoFunciona,
      'buzón de sugerencias': k.ajustesSugerencias,
      'apoyar el proyecto': k.ajustesApoyar,
    };
    for (final entrada in dianas.entries) {
      final ctx = entrada.value.currentContext;
      expect(ctx, isNotNull, reason: 'sin diana medible: ${entrada.key}');
      final box = ctx!.findRenderObject();
      expect(box, isA<RenderBox>(), reason: '${entrada.key} sin rectángulo');
      expect((box as RenderBox).hasSize, isTrue,
          reason: '${entrada.key} sin tamaño');
    }
  });
}
