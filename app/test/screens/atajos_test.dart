/// Atajos de teclado.
///
/// Ctrl+F no sabe cómo busca cada pantalla: avisa a la que está delante. Lo
/// que se prueba aquí es que el aviso llega a la pantalla CORRECTA y que dos
/// peticiones seguidas a la misma pestaña se notan las dos (si el aviso solo
/// guardara "a quién", pulsar Ctrl+F dos veces no haría nada la segunda).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/widgets/app_shortcuts.dart';

/// Dispara el atajo cuya tecla es [tecla].
void _dispara(
    Map<ShortcutActivator, VoidCallback> atajos, LogicalKeyboardKey tecla) {
  for (final e in atajos.entries) {
    final k = e.key;
    if (k is SingleActivator && k.trigger == tecla) {
      e.value();
      return;
    }
  }
  fail('no hay atajo para $tecla');
}

void main() {
  group('el aviso de buscar', () {
    test('va dirigido a una pestaña', () {
      final bus = SearchFocusBus();
      var avisos = 0;
      bus.addListener(() => avisos++);

      bus.request(2);

      expect(bus.target, 2);
      expect(avisos, 1);
    });

    test('dos veces a la misma pestaña se notan las dos', () {
      final bus = SearchFocusBus();
      bus.request(2);
      final primero = bus.tick;

      bus.request(2);

      expect(bus.tick, greaterThan(primero));
    });
  });

  group('las teclas', () {
    test('Ctrl+1..N cambian de pestaña, y no hay más de las que hay', () {
      var pedida = -1;
      final atajos = mainShortcuts(
        screenCount: 3,
        onTab: (i) => pedida = i,
        onScan: () {},
        onSearch: () {},
        onSettings: () {},
      );

      // 3 pantallas + escáner + buscar + ajustes
      expect(atajos.length, 6);

      // las claves son SingleActivator, que no se comparan por valor: se
      // busca por la tecla que dispara
      _dispara(atajos, LogicalKeyboardKey.digit2);
      expect(pedida, 1); // Ctrl+2 = segunda pantalla
    });

    test('Ctrl+E abre el escáner y Ctrl+, los ajustes', () {
      var escaner = 0;
      var ajustes = 0;
      final atajos = mainShortcuts(
        screenCount: 7,
        onTab: (_) {},
        onScan: () => escaner++,
        onSearch: () {},
        onSettings: () => ajustes++,
      );

      _dispara(atajos, LogicalKeyboardKey.keyE);
      _dispara(atajos, LogicalKeyboardKey.comma);

      expect(escaner, 1);
      expect(ajustes, 1);
    });
  });

  testWidgets('Escape cierra la pantalla que hay encima', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigator,
      builder: (context, child) => CallbackShortcuts(
        bindings: escapeCloses(navigator),
        child: Focus(
            autofocus: true, child: child ?? const SizedBox.shrink()),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('ficha')))),
            child: const Text('abrir'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('ficha'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('ficha'), findsNothing);
    expect(find.text('abrir'), findsOneWidget);
  });
}
