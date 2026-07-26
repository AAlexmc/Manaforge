/// Forge: filtro por expansión y mazos con cartas que no tienes.
///
/// Lo que se prueba es que la pantalla NO deje forjar lo que no tiene
/// sentido (todo Magic de golpe) y que diga en cada momento de dónde van a
/// salir las cartas: es la diferencia entre "solo tuyas" y "también las que
/// tendrías que comprar".
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:manaforge_app/screens/forge_screen.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';

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

/// Base de cartas que NO existe: es el caso real de alguien que aún no la ha
/// descargado, y además no depende de plugins (en test no hay path_provider).
CardDatabase _sinBase() =>
    CardDatabase(dataDir: Directory('/ruta/que/no/existe/manaforge'));

Future<void> _pump(WidgetTester tester, CollectionStore collection) async {
  // pantalla alta: el selector de Forge es una lista larga y lo que no cabe
  // no se construye (y no se puede tocar en un test)
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
  testWidgets('sin expansiones elegidas, Forge usa toda tu colección',
      (tester) async {
    await _pump(tester, _conCartas(40));

    expect(find.text('Sin elegir expansiones, Forge usa toda tu colección.'),
        findsOneWidget);
    expect(find.text('Elegir expansiones'), findsOneWidget);
    // el modo normal sigue siendo el de siempre
    expect(find.text('Forjar mis mazos'), findsOneWidget);
  });

  testWidgets('"cartas que no tengo" sin expansión no deja forjar',
      (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Incluir cartas que no tengo'));
    await tester.pump();

    expect(
        find.text('Elige al menos una expansión: sin filtro serían las '
            '~30.000 cartas de Magic.'),
        findsOneWidget);
    final boton = tester.widget<FilledButton>(find.ancestor(
        of: find.text('Forjar mazos (con lo que me falte)'),
        matching: find.byType(FilledButton)));
    expect(boton.onPressed, isNull); // apagado hasta elegir expansión
  });

  testWidgets('el aviso de "solo tus cartas" cambia con el interruptor',
      (tester) async {
    await _pump(tester, _conCartas(40));

    expect(find.textContaining('Forge solo usa tus 40 cartas'),
        findsOneWidget);

    await tester.tap(find.text('Incluir cartas que no tengo'));
    await tester.pump();

    expect(find.textContaining('puede llevar cartas que NO tienes'),
        findsOneWidget);
    expect(find.textContaining('Forge solo usa tus'), findsNothing);
  });

  testWidgets('con menos de 30 cartas, el teaser deja forjar comprando',
      (tester) async {
    await _pump(tester, _conCartas(3));

    expect(find.text('3/30'), findsOneWidget);
    await tester.tap(find.text('Hacer un mazo con cartas que no tengo'));
    await tester.pump();

    // se abre el selector, ya con el modo puesto
    expect(find.text('¿De dónde salen las cartas?'), findsOneWidget);
    expect(find.textContaining('puede llevar cartas que NO tienes'),
        findsOneWidget);
  });

  testWidgets('sin base de cartas, elegir expansiones lo dice en vez de '
      'quedarse mudo', (tester) async {
    await _pump(tester, _conCartas(40));

    await tester.tap(find.text('Elegir expansiones'));
    // las expansiones se piden AHORA (no al arrancar la app): hay que dejar
    // que el intento falle antes de mirar el aviso. Nada de pumpAndSettle:
    // adelanta el reloj lo bastante como para que el aviso ya se haya ido.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    expect(find.textContaining('Necesito la base de cartas'), findsOneWidget);
  });

  testWidgets('forja profunda: el switch existe y arranca ON', (tester) async {
    await _pump(tester, _conCartas(40));

    final switchFinder = find.ancestor(
        of: find.text('Forja profunda'), matching: find.byType(SwitchListTile));
    expect(switchFinder, findsOneWidget);
    expect(tester.widget<SwitchListTile>(switchFinder).value, isTrue);
    // ForgeJob se construye con el switch: por defecto ON.
    final state = tester.state(find.byType(ForgeScreen));
    expect((state as dynamic).buildForgeJob(const <String, fe.Card>{}).deepForge,
        isTrue);

    await tester.tap(find.text('Forja profunda'));
    await tester.pump();

    expect(tester.widget<SwitchListTile>(switchFinder).value, isFalse);
    // y también se construye con el valor apagado tras tocarlo: no es solo
    // la etiqueta la que cambia, es el ForgeJob de verdad.
    expect((state as dynamic).buildForgeJob(const <String, fe.Card>{}).deepForge,
        isFalse);
  });
}
