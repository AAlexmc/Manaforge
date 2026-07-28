/// Tests de la pantalla de arranque: qué descarga, qué se salta, y que
/// sin conexión se entra igual en vez de quedarse colgada.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/home/startup_screen.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/data/services/startup_updates.dart';

/// Fuente de mentira: apunta si se le ha pedido la descarga.
class _FakeSource {
  int downloads = 0;
  String? date;
  final bool fails;

  _FakeSource({this.date, this.fails = false});

  static const progress = [0.5, 1.0]; // dos tirones y listo

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

  testWidgets('entrar a media descarga NO la cancela: el fichero se cierra '
      'bien', (tester) async {
    // salir del `await for` cancelaría el stream y dejaría el .gz y su
    // sink a medias, que es justo lo que no se quiere al pulsar "Entrar ya"
    final completer = Completer<void>();
    var cerrado = false;
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
            downloadedAt: () async => null,
            download: () async* {
              try {
                yield 0.1;
                await completer.future;
                yield 1.0;
              } finally {
                cerrado = true;
              }
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
    expect(cerrado, isFalse, reason: 'la descarga sigue viva, no cancelada');

    completer.complete();
    await tester.pumpAndSettle();
    expect(cerrado, isTrue, reason: 'y termina cerrando sus recursos');
  });

  testWidgets('una descarga que se queda muda no cuelga el arranque',
      (tester) async {
    var entrado = false;
    await tester.pumpWidget(MaterialApp(
      home: StartupScreen(
        sources: [
          UpdateSource(
            name: 'Muda',
            size: '1 MB',
            what: 'de prueba',
            maxAgeDays: 1,
            lastDate: () async => null,
            downloadedAt: () async => null,
            // emite un tramo y calla para siempre (portal cautivo)
            download: () async* {
              yield 0.1;
              await Completer<void>().future;
            },
          )
        ],
        collection: CollectionStore(),
        onReady: () => entrado = true,
        settleDelay: Duration.zero,
        canDownload: () async => true,
        downloadTimeout: const Duration(milliseconds: 100),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.textContaining('sin conexión'), findsOneWidget);
    expect(entrado, isTrue, reason: 'se entra igual tras el timeout');
  });

  testWidgets('una fuente que revienta al preguntarle la fecha no impide '
      'entrar', (tester) async {
    var entrado = false;
    await _pump(
        tester,
        [
          UpdateSource(
            name: 'Rota',
            size: '1 MB',
            what: 'de prueba',
            maxAgeDays: 1,
            lastDate: () async => throw Exception('base ilegible'),
            downloadedAt: () async => throw Exception('disco raro'),
            download: () async* {
              yield 1.0;
            },
          )
        ],
        onReady: () => entrado = true);
    expect(entrado, isTrue);
  });

  testWidgets('si la primera base falla, las siguientes se comprueban igual',
      (tester) async {
    final rota = _FakeSource(date: null, fails: true);
    final buena = _FakeSource(date: null);
    await _pump(tester, [rota.build(name: 'Rota'), buena.build(name: 'Buena')],
        onReady: () {});
    expect(rota.downloads, 1);
    expect(buena.downloads, 1);
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
