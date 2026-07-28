/// El paso «Datos» del tour de Ajustes descuadraba: el agujero del scrim se
/// medía justo cuando terminaba el scroll/despliegue, un frame antes de que
/// el layout recogiera ese último tramo (y, si la sección aún estaba
/// asentando su propia animación de despliegue, el desfase era mayor). El
/// resultado: el bocadillo decía «Datos» pero el agujero caía sobre el
/// contenido de más abajo.
///
/// Reproduce montando la pantalla real de Ajustes (con su `_Seccion`
/// plegable de verdad) bajo un `TourOverlay` de verdad, igual que hace
/// `_prepararPaso` en main.dart: expandir el controller y esperar 350ms
/// antes de medir. El agujero debe coincidir EXACTO con la cabecera «Datos»
/// inflada 8px (el engorde del foco), no solo "cerca".
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/screens.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/language_prefs.dart';
import 'package:manaforge_app/ui/core/tours/tour_overlay.dart';

import '../helpers/app_l10n.dart';
import '../helpers/tour_foco.dart';

CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));



void main() {
  testWidgets(
      'el foco del paso "Datos" cuadra con la cabecera real, no con lo '
      'que hay debajo', (tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final datosKey = GlobalKey();
    final baseDatosKey = GlobalKey();
    final copiaKey = GlobalKey();
    final datosController = ExpansibleController();

    // el mismo procedimiento que `_prepararPaso` en main.dart: desplegar la
    // sección (si hace falta) y esperar a que termine su animación
    Future<void> prepararDatos(TourPrep? prep) async {
      if (prep == null) return;
      if (datosController.isExpanded) return;
      datosController.expand();
      await Future<void>.delayed(const Duration(milliseconds: 350));
    }

    await tester.pumpWidget(appDePrueba(
      home: Scaffold(
        body: Stack(
          children: [
            AjustesScreen(
              db: _sinBase(),
              onRestored: () {},
              background: BackgroundPreference(),
              language: LanguagePreference(),
              datosController: datosController,
              datosKey: datosKey,
              baseDatosKey: baseDatosKey,
              copiaKey: copiaKey,
            ),
            TourOverlay(
              steps: [
                TourStep(
                    prepare: TourPrep.ajustesDatos,
                    targetKey: datosKey,
                    title: 'Datos',
                    body: 'Aquí vive todo lo que la app guarda'),
              ],
              navItemCount: 8,
              onPrepare: prepararDatos,
              onDone: () {},
            ),
          ],
        ),
      ),
    ));
    // igual que un tour real: el paso arranca en el postFrame, despliega
    // (350ms), hace scroll y remide varios frames más hasta asentar
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // la cabecera "Datos" ya desplegada, con la base de cartas debajo
    expect(find.text('Base de datos de cartas'), findsOneWidget);

    final headerRect = tester.getRect(find.byKey(datosKey));
    final indicador = indicadorDeFoco();
    expect(indicador, findsOneWidget);
    final focoRect = tester.getRect(indicador);

    expect(focoRect, equals(headerRect.inflate(8)),
        reason: 'el agujero del scrim no cuadra con la cabecera "Datos": '
            'cabecera=$headerRect foco=$focoRect');

    // el bocadillo no debe solaparse con el contenido que sigue a la
    // cabecera (la tarjeta de "Base de datos de cartas")
    final contenidoRect = tester.getRect(find.text('Base de datos de cartas'));
    final burbujaRect =
        tester.getRect(find.ancestor(of: find.text('Datos').last, matching: find.byType(Card)));
    expect(burbujaRect.overlaps(contenidoRect), isFalse,
        reason: 'el bocadillo tapa el contenido: burbuja=$burbujaRect '
            'contenido=$contenidoRect');
  });
}
