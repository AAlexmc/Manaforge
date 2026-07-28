/// Forge: selector de Estilo (Task 13b) — Auto por defecto, elegir un tema o
/// una tribu cambia la etiqueta, y convive con "incluir cartas que no tengo"
/// sin pisarse (mismo flujo de pool, sin código nuevo entre los dos).
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/ui/forge/forge_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/repositories/deck_store.dart';

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
  testWidgets('el selector muestra Auto por defecto', (tester) async {
    await _pump(tester, _conCartas(40));

    expect(find.text('Estilo: auto'), findsOneWidget);
  });

  testWidgets('elegir Elfos cambia la etiqueta a Elfos y construye ForgeJob '
      "con theme == 'tribal:Elf'", (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Estilo: auto'));
    await tester.pumpAndSettle();

    expect(find.text('Elfos'), findsWidgets); // título de la hoja
    await tester.tap(find.text('Elfos').last);
    await tester.pumpAndSettle();

    expect(find.text('Elfos'), findsOneWidget); // ahora solo la etiqueta
    expect(find.text('Estilo: auto'), findsNothing);
    // no solo la etiqueta: el ForgeJob de verdad lleva el tema elegido.
    final state = tester.state(find.byType(ForgeScreen));
    final job = (state as dynamic).buildForgeJob(const <String, fe.Card>{});
    expect(job.theme, 'tribal:Elf');
  });

  testWidgets('la hoja también enseña temas mecánicos (p. ej. reanimación)',
      (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Estilo: auto'));
    await tester.pumpAndSettle();

    expect(find.text('reanimación'), findsOneWidget);
  });

  testWidgets(
      'funciona combinado con "incluir cartas que no tengo": ambos flags '
      'conviven sin pisarse', (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Incluir cartas que no tengo'));
    await tester.pump();
    await tester.tap(find.text('Estilo: auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elfos').last);
    await tester.pumpAndSettle();

    // el estilo elegido sigue puesto Y el interruptor sigue encendido: ni
    // uno resetea al otro.
    expect(find.text('Elfos'), findsOneWidget);
    final incluirSwitch = tester.widget<SwitchListTile>(find.ancestor(
        of: find.text('Incluir cartas que no tengo'),
        matching: find.byType(SwitchListTile)));
    expect(incluirSwitch.value, isTrue);
    // y el ForgeJob de verdad lleva el tema — "incluir cartas que no
    // tengo" no es un campo de ForgeJob (cambia de qué pool sale, no el
    // job), así que el flag combinado se ve en dos sitios distintos: el
    // switch de arriba y el theme del job construido aquí.
    final state = tester.state(find.byType(ForgeScreen));
    final job = (state as dynamic).buildForgeJob(const <String, fe.Card>{});
    expect(job.theme, 'tribal:Elf');
  });

  testWidgets('cerrar la hoja sin elegir no resetea el estilo ya puesto',
      (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Estilo: auto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elfos').last);
    await tester.pumpAndSettle();
    expect(find.text('Elfos'), findsOneWidget);

    // reabrir y cerrar tocando fuera (sin elegir nada nuevo)
    await tester.tap(find.text('Elfos'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // fuera de la hoja
    await tester.pumpAndSettle();

    expect(find.text('Elfos'), findsOneWidget); // se conserva
  });
}
