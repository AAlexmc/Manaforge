/// Qué carta hay AHORA sobre la mesa, para no contarla dos veces.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/scanner/table_memory.dart';

void main() {
  test('la primera vez que se ve una carta, se cuenta', () {
    final mesa = TableMemory();

    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);
  });

  test('la MISMA carta reconocida otra vez sin levantarla no se cuenta', () {
    final mesa = TableMemory();
    mesa.shouldCount('sol-ring|lea|270');

    // la puerta re-dispara porque la carta se ha movido un pelín
    expect(mesa.shouldCount('sol-ring|lea|270'), isFalse);
    expect(mesa.shouldCount('sol-ring|lea|270'), isFalse);
  });

  test('cambiarla por OTRA sin vaciar la mesa sí cuenta: eso es prueba', () {
    final mesa = TableMemory();
    mesa.shouldCount('sol-ring|lea|270');

    expect(mesa.shouldCount('mox-pearl|lea|264'), isTrue);
  });

  test('una carta quieta un buen rato se cuenta UNA vez', () {
    final mesa = TableMemory();
    var contadas = 0;

    for (var i = 0; i < 500; i++) {
      if (mesa.shouldCount('sol-ring|lea|270')) contadas++;
    }

    expect(contadas, 1);
  });

  test('levantarla y volver a ponerla cuenta dos: la mesa vacía es la prueba',
      () {
    final mesa = TableMemory(emptyTicksToForget: 3);
    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);

    for (var i = 0; i < 3; i++) {
      mesa.sawEmpty();
    }

    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);
  });

  test('un parpadeo de mesa vacía no basta para volver a contar', () {
    final mesa = TableMemory(emptyTicksToForget: 3);
    mesa.shouldCount('sol-ring|lea|270');

    mesa.sawEmpty(); // uno solo: no llega

    expect(mesa.shouldCount('sol-ring|lea|270'), isFalse);
  });

  test('los ticks de mesa vacía no se acumulan entre tandas', () {
    final mesa = TableMemory(emptyTicksToForget: 3);
    mesa.shouldCount('sol-ring|lea|270');

    mesa.sawEmpty();
    mesa.sawEmpty();
    // vuelve a verse la carta: la cuenta de vacíos se reinicia
    expect(mesa.shouldCount('sol-ring|lea|270'), isFalse);
    mesa.sawEmpty();
    mesa.sawEmpty();

    expect(mesa.shouldCount('sol-ring|lea|270'), isFalse,
        reason: 'nunca hubo 3 vacíos seguidos');
  });

  test('vaciar la mesa sin nada apuntado no rompe nada', () {
    final mesa = TableMemory();

    mesa.sawEmpty();
    mesa.sawEmpty();

    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);
  });

  test('por defecto, verla retirada una vez basta para volver a contarla', () {
    // la puerta de presencia solo dice "retirada" con la escena asentada y la
    // mesa por debajo del umbral: eso YA es prueba, no hace falta esperar más
    final mesa = TableMemory();
    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);

    mesa.sawEmpty();

    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);
  });

  test('borrar la ficha de la bandeja libera esa carta al momento', () {
    final mesa = TableMemory();
    mesa.shouldCount('sol-ring|lea|270');

    // el usuario borra la ficha con la X: ha dicho que no la quiere, así que
    // volver a pasarla es una acción deliberada
    mesa.forget('sol-ring|lea|270');

    expect(mesa.onTable, isNull);
    expect(mesa.shouldCount('sol-ring|lea|270'), isTrue);
  });

  test('borrar la ficha de OTRA carta no libera la que está en la mesa', () {
    final mesa = TableMemory();
    mesa.shouldCount('sol-ring|lea|270');

    mesa.forget('mox-pearl|lea|264');

    expect(mesa.onTable, 'sol-ring|lea|270');
    expect(mesa.shouldCount('sol-ring|lea|270'), isFalse);
  });

  test(
      'REGRESIÓN: contar → borrar ficha → retirar → volver a poner LA MISMA '
      'vuelve a contar', () {
    final mesa = TableMemory();
    expect(mesa.shouldCount('shipwreck-moray|blb|72'), isTrue);

    mesa.forget('shipwreck-moray|blb|72'); // X en la bandeja
    mesa.sawEmpty(); // se retira la carta de la mesa

    expect(mesa.shouldCount('shipwreck-moray|blb|72'), isTrue,
        reason: 'quedaba bloqueada para siempre: era el fallo del PR #7');
  });

  test('qué hay en la mesa se puede consultar, para poder enseñarlo', () {
    final mesa = TableMemory(emptyTicksToForget: 1);

    expect(mesa.onTable, isNull);
    mesa.shouldCount('sol-ring|lea|270');
    expect(mesa.onTable, 'sol-ring|lea|270');
    mesa.sawEmpty();
    expect(mesa.onTable, isNull);
  });
}
