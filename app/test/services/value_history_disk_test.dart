/// El historial del valor de la colección, contra disco de verdad.
///
/// Bug real: el Mercado reventaba con
/// `PathNotFoundException: Cannot rename file to '…/value_history.json',
/// path = '…/value_history.json.tmp'`. Dos guardados a la vez usaban EL MISMO
/// temporal: el primero lo renombraba y el segundo se encontraba sin fichero
/// que renombrar.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/json_store_io.dart';
import 'package:manaforge_app/services/value_history.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('manaforge_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('dos escrituras a la vez sobre el mismo fichero no revientan',
      () async {
    final file = File('${dir.path}/cosa.json');
    await Future.wait([
      writeJsonFile(file, '{"a":1}'),
      writeJsonFile(file, '{"a":2}'),
      writeJsonFile(file, '{"a":3}'),
    ]);

    expect(file.existsSync(), isTrue);
    // el contenido es el de UNA de ellas, entero: nunca a medias
    expect(['{"a":1}', '{"a":2}', '{"a":3}'],
        contains(file.readAsStringSync()));
    // y no se queda basura por el camino
    expect(
        dir.listSync().where((e) => e.path.endsWith('.tmp')), isEmpty);
  });

  test('escribir en una carpeta que aún no existe la crea', () async {
    final file = File('${dir.path}/nueva/otra/cosa.json');
    await writeJsonFile(file, '{"a":1}');
    expect(file.readAsStringSync(), '{"a":1}');
  });

  test('el historial aguanta dos apuntes del mismo día a la vez', () async {
    final history = ValueHistory(dataDir: dir);
    // el Mercado apunta al abrirse y otra vez al llegar los precios
    final resultados = await Future.wait([
      history.record(10, 1),
      history.record(20, 2),
    ]);

    for (final puntos in resultados) {
      expect(puntos, hasLength(1)); // un punto por día
    }
    final file = File('${dir.path}/value_history.json');
    final list = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    expect(list, hasLength(1));
    expect((list.first as Map)['v'], anyOf(10, 20));
  });
}
