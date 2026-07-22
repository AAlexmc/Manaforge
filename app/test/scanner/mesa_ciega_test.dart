/// La puerta de presencia y la memoria de mesa, juntas: quitar la carta y
/// volver a ponerla tiene que contar dos.
///
/// El fallo que persigue: mientras corría el reconocimiento pesado (hasta ~1 s
/// con reintentos) la pantalla dejaba de muestrear la mesa. Si retirabas la
/// carta justo en ese hueco, NADIE veía la mesa vacía: la memoria no la
/// olvidaba y la carta se quedaba clavada en "ya está en la mesa" para
/// siempre. Aquí se simula ese hueco saltándose ticks.
library;

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/presence_gate.dart';
import 'package:manaforge_app/scanner/table_memory.dart';

Uint8List _frame(int value, [int n = 64]) =>
    Uint8List.fromList(List.filled(n, value));

const _mesa = 50;
const _carta = 120;
const _clave = 'ornithopter|aer|167';

/// Un tick del escáner: mira, y si la mesa está vacía se lo dice a la memoria.
PresenceEvent _tick(PresenceGate gate, TableMemory table, int gris) {
  final event = gate.feed(_frame(gris));
  if (!gate.cardPresent) table.sawEmpty();
  if (event == PresenceEvent.cardRemoved) table.reset();
  return event;
}

void main() {
  late PresenceGate gate;
  late TableMemory table;

  setUp(() {
    gate = PresenceGate();
    table = TableMemory();
    for (var i = 0; i < 3; i++) {
      _tick(gate, table, _mesa); // línea base: mesa vacía
    }
  });

  int _ponerYContar() {
    var contadas = 0;
    for (var i = 0; i < 4; i++) {
      final e = _tick(gate, table, _carta);
      if (e == PresenceEvent.cardPlaced || e == PresenceEvent.cardChanged) {
        if (table.shouldCount(_clave)) contadas++;
      }
    }
    return contadas;
  }

  test('poner, quitar y volver a poner la misma cuenta DOS', () {
    expect(_ponerYContar(), 1);

    for (var i = 0; i < 4; i++) {
      _tick(gate, table, _mesa); // se retira
    }

    expect(_ponerYContar(), 1, reason: 'la segunda pasada vuelve a contar');
  });

  test('la mesa se sigue mirando aunque el reconocimiento vaya lento', () {
    expect(_ponerYContar(), 1);

    // el usuario la quita y la vuelve a poner deprisa: cuatro ticks de mesa
    // vacía es menos de un segundo y medio a 300 ms
    for (var i = 0; i < 4; i++) {
      _tick(gate, table, _mesa);
    }
    expect(table.onTable, isNull,
        reason: 'la memoria tiene que haberla soltado ya');

    expect(_ponerYContar(), 1);
  });

  test('si NADIE mira mientras se retira, la carta se queda clavada', () {
    // esto es el fallo, escrito para que no vuelva: si los ticks de mesa
    // vacía no llegan a la puerta (porque el reconocimiento tenía la sartén
    // por el mango), la memoria nunca olvida
    expect(_ponerYContar(), 1);

    // NO se llama a _tick durante la retirada: se pasa directo a la carta
    expect(table.shouldCount(_clave), isFalse,
        reason: 'sin ver la mesa vacía, sigue creyendo que está puesta');
  });
}
