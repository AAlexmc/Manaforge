/// Los mandos de Forge que señala el tour se pueden MEDIR sin hacer scroll a
/// mano: el tour mide el rectángulo del botón con su GlobalKey, y una lista
/// perezosa no construye lo que queda fuera de la vista (el botón de Modo
/// Test, el último de la página, se quedaba sin contexto y el paso salía sin
/// diana). Por eso el selector es una Column dentro de un scroll.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/forge_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/ui/core/tours/tours.dart';

CollectionStore _conCartas(int copias) {
  final store = CollectionStore();
  for (var i = 0; i < copias; i++) {
    store.add(
      OwnedCard(oracleId: 'o$i', name: 'Carta $i', colors: 'G', qty: 1),
      printingKey: 'blb|$i',
    );
  }
  return store;
}

void main() {
  testWidgets('las dianas del tour de Forge están montadas en una ventana '
      'normal', (tester) async {
    // ventana pequeña a propósito: así el final de la página queda MUY lejos
    // de la vista, que es cuando una lista perezosa deja de construirlo
    tester.view.physicalSize = const Size(900, 400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final k = TourKeys();
    await tester.pumpWidget(MaterialApp(
      home: ForgeScreen(
        db: CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge')),
        collection: _conCartas(40),
        decks: DeckStore(),
        basicasKey: k.forgeBasicas,
        expansionesKey: k.forgeExpansiones,
        queNoTengoKey: k.forgeQueNoTengo,
        deepForgeKey: k.forgeDeepForge,
        forjarKey: k.forgeForjar,
        modoTestKey: k.forgeModoTest,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));

    final dianas = {
      'tierras básicas': k.forgeBasicas,
      'expansiones': k.forgeExpansiones,
      'cartas que no tengo': k.forgeQueNoTengo,
      'forja profunda': k.forgeDeepForge,
      'forjar': k.forgeForjar,
      'Modo Test': k.forgeModoTest,
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
