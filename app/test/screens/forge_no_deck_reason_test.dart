/// Forge: el mensaje de "no hay mazo" con Estilo forzado (I2).
///
/// `_sinMazoReason` solo sabía de formato/expansiones/colección: con
/// `themeOverride` puesto, la vía de salida vacía más probable es la nueva
/// (generator.dart devuelve null porque ese color no tiene con qué jugar el
/// Estilo pedido) y el mensaje seguía aconsejando comprar cartas, sin
/// mencionar el Estilo. Hueco de cobertura detectado en benchmark B1: no
/// había ningún test sobre `_sinMazoReason` en absoluto.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/screens/forge_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/services/forge_texts.dart';

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

CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));

Future<void> _pump(WidgetTester tester, CollectionStore collection) async {
  tester.view.physicalSize = const Size(1000, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    home: ForgeScreen(
        db: _sinBase(), collection: collection, decks: DeckStore()),
  ));
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  final t = AppLocalizationsEs();

  testWidgets(
      'sin Estilo forzado, el motivo sigue siendo el de siempre (formato/'
      'expansiones/colección)', (tester) async {
    await _pump(tester, _conCartas(40));

    final state = tester.state(find.byType(ForgeScreen));
    final reason = (state as dynamic).sinMazoReason() as String;

    expect(reason, isNot(contains('Estilo')));
  });

  testWidgets(
      'con Estilo forzado (tribu), el motivo menciona el Estilo elegido y '
      'sugiere auto u otra tribu, no "compra más cartas" (I2)',
      (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Estilo: auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elfos').last);
    await tester.pumpAndSettle();

    final state = tester.state(find.byType(ForgeScreen));
    final reason = (state as dynamic).sinMazoReason() as String;

    expect(reason, t.fgNoDeckStyle(styleName(t, 'tribal:Elf')));
    expect(reason, contains('Elfos'));
    // no el mensaje genérico de "compra más cartas" (I2 exacto).
    expect(reason, isNot(contains(t.fgTipMoreCards)));
    expect(reason, isNot(contains(t.fgTipMoreSets)));
  });

  testWidgets(
      'con Estilo forzado (tema mecánico), el motivo también lo menciona',
      (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Estilo: auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('reanimación'));
    await tester.pumpAndSettle();

    final state = tester.state(find.byType(ForgeScreen));
    final reason = (state as dynamic).sinMazoReason() as String;

    expect(reason, t.fgNoDeckStyle(styleName(t, 'reanimator')));
  });
}
