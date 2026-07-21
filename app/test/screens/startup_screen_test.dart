/// Tests de la pantalla de arranque: qué descarga, qué se salta, y que
/// sin conexión se entra igual en vez de quedarse colgada.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/screens/startup_screen.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/startup_updates.dart';

/// Fuente de mentira: apunta si se le ha pedido la descarga.
class _FakeSource {
  int downloads = 0;
  String? date;
  final bool fails;
  final List<double> progress;

  _FakeSource({this.date, this.fails = false, this.progress = const [0.5, 1]});

  UpdateSource build({String name = 'Base', int maxAgeDays = 1}) =>
      UpdateSource(
        name: name,
        size: '1 MB',
        what: 'de prueba',
        maxAgeDays: maxAgeDays,
        lastDate: () async => date,
        download: () async* {
          downloads++;
          if (fails) throw Exception('sin conexión');
          for (final p in progress) {
            yield p;
          }
          date = _hoy();
        },
      );
}

String _hoy() {
  final now = DateTime.now();
  two(int n) => n < 10 ? '0$n' : '$n';
  return '${now.year}-${two(now.month)}-${two(now.day)}';
}

Future<void> _pump(WidgetTester tester, List<UpdateSource> sources,
    {required void Function() onReady}) async {
  await tester.pumpWidget(MaterialApp(
    home: StartupScreen(
      sources: sources,
      collection: CollectionStore(),
      onReady: onReady,
      settleDelay: Duration.zero,
      canDownload: () async => true,
    ),
  ));
  await tester.pumpAndSettle();
  // el paso final (entrar) cuelga de un temporizador, no de un frame
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lo que está al día NO se descarga', (tester) async {
    final fuente = _FakeSource(date: _hoy());
    var entrado = false;
    await _pump(tester, [fuente.build()], onReady: () => entrado = true);

    expect(fuente.downloads, 0);
    expect(find.textContaining('al día'), findsWidgets);
    expect(entrado, isTrue);
  });

  testWidgets('lo que falta se descarga y luego se entra', (tester) async {
    final fuente = _FakeSource(date: null);
    var entrado = false;
    await _pump(tester, [fuente.build()], onReady: () => entrado = true);

    expect(fuente.downloads, 1);
    expect(find.textContaining('actualizado'), findsOneWidget);
    expect(entrado, isTrue);
  });

  testWidgets('lo viejo se refresca', (tester) async {
    final fuente = _FakeSource(date: '2020-01-01');
    await _pump(tester, [fuente.build()], onReady: () {});
    expect(fuente.downloads, 1);
  });

  testWidgets('sin conexión NO se queda colgada: avisa y entra igual',
      (tester) async {
    final fuente = _FakeSource(date: '2020-01-01', fails: true);
    var entrado = false;
    await _pump(tester, [fuente.build()], onReady: () => entrado = true);

    expect(find.textContaining('sigo con la que tenías'), findsOneWidget);
    expect(entrado, isTrue);
  });

  testWidgets('si falta del todo y no hay conexión, lo dice claro',
      (tester) async {
    final fuente = _FakeSource(date: null, fails: true);
    var entrado = false;
    await _pump(tester, [fuente.build()], onReady: () => entrado = true);

    expect(find.textContaining('sin conexión'), findsOneWidget);
    expect(entrado, isTrue);
  });

  testWidgets('varias bases: se procesan todas y en orden', (tester) async {
    final a = _FakeSource(date: null);
    final b = _FakeSource(date: _hoy());
    final c = _FakeSource(date: '2020-01-01');
    await _pump(
        tester,
        [
          a.build(name: 'Cartas'),
          b.build(name: 'Precios'),
          c.build(name: 'Huellas'),
        ],
        onReady: () {});

    expect(a.downloads, 1);
    expect(b.downloads, 0); // al día
    expect(c.downloads, 1);
    expect(find.text('Cartas'), findsOneWidget);
    expect(find.text('Precios'), findsOneWidget);
    expect(find.text('Huellas'), findsOneWidget);
  });

  testWidgets('"Entrar ya" entra sin esperar, y solo una vez',
      (tester) async {
    // una descarga que no termina hasta que el test la suelta
    final completer = Completer<void>();
    var entradas = 0;
    await tester.pumpWidget(MaterialApp(
      home: StartupScreen(
        sources: [
          UpdateSource(
            name: 'Lenta',
            size: '1 MB',
            what: 'de prueba',
            maxAgeDays: 1,
            lastDate: () async => null,
            // descarga que no avanza: la pantalla se queda actualizando
            download: () async* {
              yield 0.1;
              await completer.future;
            },
          )
        ],
        collection: CollectionStore(),
        onReady: () => entradas++,
        settleDelay: Duration.zero,
        canDownload: () async => true,
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Entrar ya'));
    await tester.pump();
    expect(entradas, 1);

    await tester.tap(find.text('Entrar ya'));
    await tester.pump();
    expect(entradas, 1, reason: 'no debe entrar dos veces');

    completer.complete(); // sin descargas colgando al terminar el test
    await tester.pumpAndSettle();
  });
}
