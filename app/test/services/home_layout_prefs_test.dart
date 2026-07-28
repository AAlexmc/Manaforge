/// El layout de Inicio: qué secciones se ven y en qué orden.
///
/// Se guarda por NOMBRE, no por índice, y se valida contra el catálogo: un
/// fichero manipulado no puede meter una sección que la app no sabría pintar,
/// y una versión nueva con una sección nueva la enseña sin tocar nada.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/home_layout_prefs.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory datos;

  setUp(() {
    datos = Directory.systemTemp.createTempSync('mf-home-layout');
  });
  tearDown(() {
    if (datos.existsSync()) datos.deleteSync(recursive: true);
  });

  File fichero() => File(p.join(datos.path, 'home_layout.json'));

  test('por defecto: todas visibles, en el orden del catálogo', () async {
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    expect(prefs.ordenVisible, kHomeSections);
    expect(prefs.todas.map((s) => s.id), kHomeSections);
    expect(prefs.todas.every((s) => s.visible), isTrue);
  });

  test('apagar una sección la quita de lo visible y lo guarda', () async {
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    await prefs.toggle('meta');
    expect(prefs.esVisible('meta'), isFalse);
    expect(prefs.ordenVisible, isNot(contains('meta')));
    // sigue en 'todas' (para poder volver a encenderla en el editor)
    expect(prefs.todas.map((s) => s.id), contains('meta'));

    final otra = HomeLayoutPreference(dataDir: datos);
    await otra.load();
    expect(otra.esVisible('meta'), isFalse);
  });

  test('encender vuelve a mostrar', () async {
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    await prefs.toggle('joyas');
    await prefs.toggle('joyas');
    expect(prefs.esVisible('joyas'), isTrue);
  });

  test('reordenar mueve la sección y persiste', () async {
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    // 'nivel' (0) a la posición 2
    await prefs.reordenar(0, 2);
    final orden = prefs.todas.map((s) => s.id).toList();
    expect(orden.indexOf('nivel'), 2);

    final otra = HomeLayoutPreference(dataDir: datos);
    await otra.load();
    expect(otra.todas.map((s) => s.id).toList().indexOf('nivel'), 2);
  });

  test('restablecer vuelve al orden de fábrica y enciende todo', () async {
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    await prefs.toggle('meta');
    await prefs.reordenar(0, 3);
    await prefs.restablecer();
    expect(prefs.todas.map((s) => s.id), kHomeSections);
    expect(prefs.ordenVisible, kHomeSections);
  });

  test('id desconocido en toggle se ignora', () async {
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    await prefs.toggle('no-existe');
    expect(prefs.ordenVisible, kHomeSections);
  });

  test('el fichero solo guarda ids del catálogo; los raros se descartan',
      () async {
    fichero().writeAsStringSync(jsonEncode({
      'orden': ['meta', 'inventada', 'nivel', 'meta'], // repetida + falsa
      'ocultas': ['joyas', 'otra-falsa'],
    }));
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    final orden = prefs.todas.map((s) => s.id).toList();
    // 'meta' primero, 'nivel' después, sin repetir ni 'inventada'
    expect(orden.first, 'meta');
    expect(orden.where((id) => id == 'meta').length, 1);
    expect(orden, isNot(contains('inventada')));
    // el resto del catálogo se añade al final
    expect(orden.toSet(), kHomeSections.toSet());
    // solo 'joyas' quedó oculta ('otra-falsa' no es del catálogo)
    expect(prefs.esVisible('joyas'), isFalse);
    expect(prefs.ordenVisible, isNot(contains('joyas')));
  });

  test('secciones conocidas que faltan en el fichero se añaden al final',
      () async {
    // un fichero viejo que solo conocía dos secciones
    fichero().writeAsStringSync(jsonEncode({
      'orden': ['mazos', 'recientes'],
      'ocultas': <String>[],
    }));
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    final orden = prefs.todas.map((s) => s.id).toList();
    expect(orden.take(2).toList(), ['mazos', 'recientes']);
    expect(orden.toSet(), kHomeSections.toSet());
    // las nuevas salen visibles
    expect(prefs.esVisible('resumen'), isTrue);
  });

  test('fichero corrupto: el layout de siempre', () async {
    fichero().writeAsStringSync('{ no es json');
    final prefs = HomeLayoutPreference(dataDir: datos);
    await prefs.load();
    expect(prefs.ordenVisible, kHomeSections);
  });
}
