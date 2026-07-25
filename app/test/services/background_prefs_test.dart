/// El fondo de pantalla.
///
/// Es un fichero que elige el usuario, así que se acota como todo lo que
/// entra de fuera. Y la imagen se COPIA a la carpeta de datos: si el original
/// se mueve o se borra, el fondo tiene que seguir estando.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/background_prefs.dart';
import 'package:manaforge_app/services/safe_input.dart';
import 'package:path/path.dart' as p;

/// Un PNG de 1×1 de verdad (cabecera incluida), por si algún día se decodifica.
final _png = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
];

void main() {
  late Directory datos;
  late Directory fuera;

  setUp(() {
    datos = Directory.systemTemp.createTempSync('mf-fondo-datos');
    fuera = Directory.systemTemp.createTempSync('mf-fondo-fuera');
  });
  tearDown(() {
    for (final d in [datos, fuera]) {
      if (d.existsSync()) d.deleteSync(recursive: true);
    }
  });

  File _imagen(String nombre) =>
      File(p.join(fuera.path, nombre))..writeAsBytesSync(_png);

  test('elegir una imagen la copia a la carpeta de datos', () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.select(_imagen('fondo.png'));

    expect(prefs.hasImage, isTrue);
    expect(p.dirname(prefs.image!.path), datos.path);
    expect(prefs.image!.existsSync(), isTrue);
  });

  test('borrar el original no se lleva el fondo por delante', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    final original = _imagen('fondo.png');
    await prefs.select(original);

    original.deleteSync();

    expect(prefs.image!.existsSync(), isTrue);
  });

  test('lo que no es imagen no entra', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    final falsa = File(p.join(fuera.path, 'peli.mp4'))
      ..writeAsBytesSync(_png);

    await expectLater(prefs.select(falsa), throwsA(isA<InputRejected>()));
    expect(prefs.hasImage, isFalse);
  });

  test('una imagen desproporcionada tampoco', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    final enorme = File(p.join(fuera.path, 'enorme.jpg'))
      ..writeAsBytesSync(List.filled(kMaxBackgroundBytes + 1, 0));

    await expectLater(prefs.select(enorme), throwsA(isA<InputRejected>()));
  });

  test('cambiar de formato no deja el fondo anterior tirado', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.select(_imagen('uno.png'));
    final primero = prefs.image!.path;

    await prefs.select(_imagen('dos.jpg'));

    expect(File(primero).existsSync(), isFalse);
    expect(prefs.image!.path, endsWith('.jpg'));
  });

  test('quitar el fondo borra la copia', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.select(_imagen('fondo.png'));
    final copia = prefs.image!.path;

    await prefs.clear();

    expect(prefs.hasImage, isFalse);
    expect(File(copia).existsSync(), isFalse);
  });

  test('el fondo y su oscurecido sobreviven a cerrar la app', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.select(_imagen('fondo.png'));
    await uno.setDim(0.5);

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.hasImage, isTrue);
    expect(otro.dim, 0.5);
  });

  test('si la copia ha desaparecido, se arranca sin fondo', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.select(_imagen('fondo.png'));
    uno.image!.deleteSync(); // limpieza de disco, carpeta movida…

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.hasImage, isFalse);
  });

  test('el oscurecido no se sale de rango', () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.setDim(5);
    expect(prefs.dim, kMaxDim);

    await prefs.setDim(-3);
    expect(prefs.dim, kMinDim);
  });

  test('los colores elegidos sobreviven a cerrar la app', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.setCardColor('noche');
    await uno.setTextColor('dorado');
    await uno.setCardOpacity(0.5);

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.cardColorId, 'noche');
    expect(otro.textColorId, 'dorado');
    expect(otro.cardColor, kCardColors.firstWhere((c) => c.id == 'noche').color);
    expect(otro.cardOpacity, 0.5);
  });

  test('volver al color de siempre', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.setCardColor('vino');
    await prefs.setCardColor(null);

    expect(prefs.cardColorId, isNull);
    expect(prefs.cardColor, isNull); // null = el del tema
  });

  test('un color que no está en la paleta no se acepta', () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.setCardColor('fucsia');
    await prefs.setTextColor('fucsia');

    expect(prefs.cardColorId, isNull);
    expect(prefs.textColorId, isNull);
  });

  test('un fichero manipulado no pinta un color inventado', () async {
    File(p.join(datos.path, 'background.json')).writeAsStringSync(
        '{"cardColor":"fucsia","textColor":"fucsia","cardOpacity":9}');

    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.load();

    expect(prefs.cardColor, isNull);
    expect(prefs.textColor, isNull);
    expect(prefs.cardOpacity, kMaxCardOpacity); // recortado, no un 9
  });

  test('un color a medida (del selector) se guarda y vuelve', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.setCardColorCustom(const Color(0xFF59F7FF)); // el sky blue
    await uno.setTextColorCustom(const Color(0xFF102030));

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.cardIsCustom, isTrue);
    expect(otro.cardColor, const Color(0xFF59F7FF));
    expect(otro.textColor, const Color(0xFF102030));
    expect(otro.cardColorId, isNull); // un color a medida no es un preset
  });

  test('elegir un preset descarta el color a medida, y al revés', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.setCardColorCustom(const Color(0xFF123456));
    expect(prefs.cardIsCustom, isTrue);

    await prefs.setCardColor('noche'); // un preset manda fuera al a medida
    expect(prefs.cardIsCustom, isFalse);
    expect(prefs.cardColorId, 'noche');

    await prefs.setCardColorCustom(const Color(0xFFAABBCC)); // y al revés
    expect(prefs.cardColorId, isNull);
    expect(prefs.cardColor, const Color(0xFFAABBCC));
  });

  test('un hex inválido en el fichero se ignora', () async {
    File(p.join(datos.path, 'background.json')).writeAsStringSync(
        '{"cardColorHex":"no-es-hex","textColorHex":"#ZZZZZZ"}');
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.load();

    expect(prefs.cardColor, isNull);
    expect(prefs.textColor, isNull);
    expect(prefs.cardIsCustom, isFalse);
  });

  test('un hex con signo no se cuela como color', () async {
    File(p.join(datos.path, 'background.json'))
        .writeAsStringSync('{"cardColorHex":"-FFFFFFF"}');
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.load();

    expect(prefs.cardColor, isNull);
    expect(prefs.cardIsCustom, isFalse);
  });

  test('el color de las pestañas y el de los iconos se guardan', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.setChipColor(const Color(0xFF4FB878));
    await uno.setIconColor(const Color(0xFFE0CC8A));

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.chipColor, const Color(0xFF4FB878));
    expect(otro.iconColor, const Color(0xFFE0CC8A));
  });

  test('volver al color del tema (null) en pestañas/iconos', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.setChipColor(const Color(0xFF123456));
    await prefs.setIconColor(const Color(0xFF654321));
    await prefs.setChipColor(null);
    await prefs.setIconColor(null);

    expect(prefs.chipColor, isNull);
    expect(prefs.iconColor, isNull);
  });

  test('las tarjetas no pueden quedar tan transparentes que no se lean',
      () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.setCardOpacity(0);

    expect(prefs.cardOpacity, kMinCardOpacity);
  });

  test('dos load() a la vez: el segundo espera al primero', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.select(_imagen('fondo.png'));
    await uno.setDim(0.4);

    final otro = BackgroundPreference(dataDir: datos);
    unawaited(otro.load()); // el de main(), aún leyendo el disco
    await otro.load(); // el de Ajustes, que da por hecho que ya está

    expect(otro.hasImage, isTrue);
    expect(otro.dim, 0.4);
  });

  test('arrastrar el velo escribe en cola y el último valor es el que queda',
      () async {
    final prefs = BackgroundPreference(dataDir: datos);
    // como arrastrar el mando: un setDim por frame, todos sin esperar
    for (final v in [0.3, 0.4, 0.5, 0.6, 0.7]) {
      unawaited(prefs.setDim(v));
    }
    await prefs.setDim(0.8);

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.dim, 0.8);
  });

  test('elegir otra imagen del mismo formato cambia el path (ImageCache)',
      () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.select(_imagen('a.jpg'));
    final primero = prefs.image!.path;
    await prefs.select(_imagen('b.jpg'));
    final segundo = prefs.image!.path;

    // el path tiene que cambiar aunque la extensión sea la misma: el
    // ImageCache de Flutter usa el path como clave, y un path repetido
    // seguiría sirviendo la imagen vieja ya decodificada
    expect(segundo, isNot(primero));
  });

  test('tras elegir otra imagen solo queda un fichero background* en el dir',
      () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.select(_imagen('a.jpg'));
    await prefs.select(_imagen('b.jpg'));

    final restantes = datos
        .listSync()
        .whereType<File>()
        .where((f) =>
            p.basename(f.path).startsWith('background') &&
            kBackgroundExtensions.contains(p.extension(f.path).toLowerCase()))
        .toList();
    expect(restantes, hasLength(1));
    expect(restantes.single.path, prefs.image!.path);
  });

  test('el barrido de select() nunca se lleva por delante background.json',
      () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.select(_imagen('a.jpg'));

    await prefs.select(_imagen('b.jpg'));

    expect(File(p.join(datos.path, 'background.json')).existsSync(), isTrue);
  });

  test('un background.json legado que apunta a background.jpg carga bien',
      () async {
    final legado = File(p.join(datos.path, 'background.jpg'))
      ..writeAsBytesSync(_png);
    File(p.join(datos.path, 'background.json'))
        .writeAsStringSync(jsonEncode({'image': legado.path, 'dim': 0.5}));

    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.load();

    expect(prefs.hasImage, isTrue);
    expect(prefs.image!.path, legado.path);
  });

  test('resetAll() vuelve todo a los valores de fábrica, en memoria',
      () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.select(_imagen('fondo.png'));
    await prefs.setDim(0.5);
    await prefs.setCardColor('noche');
    await prefs.setTextColor('dorado');
    await prefs.setCardColorCustom(const Color(0xFF123456));
    await prefs.setChipColor(const Color(0xFF4FB878));
    await prefs.setIconColor(const Color(0xFFE0CC8A));
    await prefs.setCardOpacity(0.5);

    await prefs.resetAll();

    expect(prefs.hasImage, isFalse);
    expect(prefs.dim, kDefaultDim);
    expect(prefs.cardColorId, isNull);
    expect(prefs.textColorId, isNull);
    expect(prefs.cardColor, isNull);
    expect(prefs.textColor, isNull);
    expect(prefs.chipColor, isNull);
    expect(prefs.iconColor, isNull);
    expect(prefs.cardOpacity, kDefaultCardOpacity);
  });

  test('resetAll() borra la imagen de fondo del disco', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.select(_imagen('fondo.png'));
    final copia = prefs.image!.path;

    await prefs.resetAll();

    expect(File(copia).existsSync(), isFalse);
  });

  test('tras resetAll(), un load() posterior no arrastra nada de antes',
      () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.select(_imagen('fondo.png'));
    await uno.setCardColor('noche');

    await uno.resetAll();

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.hasImage, isFalse);
    expect(otro.cardColorId, isNull);
  });

  test('los cinco presets maná nuevos están en la paleta sin duplicar ids',
      () {
    for (final id in ['isla', 'pantano', 'montana', 'oro', 'incoloro']) {
      expect(kCardColors.where((c) => c.id == id), hasLength(1));
    }
    final ids = kCardColors.map((c) => c.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('una muestra guardada sobrevive a cerrar la app', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.addSwatch(const Color(0xFF59F7FF));

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();

    expect(otro.savedSwatches, [const Color(0xFF59F7FF)]);
  });

  test('añadir la misma muestra dos veces no la duplica', () async {
    final prefs = BackgroundPreference(dataDir: datos);

    await prefs.addSwatch(const Color(0xFF59F7FF));
    await prefs.addSwatch(const Color(0xFF59F7FF));

    expect(prefs.savedSwatches, [const Color(0xFF59F7FF)]);
  });

  test('la novena muestra tira la más vieja (tope 8)', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    final colores = List.generate(9, (i) => Color(0xFF000000 + i * 0x10101));

    for (final c in colores) {
      await prefs.addSwatch(c);
    }

    expect(prefs.savedSwatches, hasLength(8));
    expect(prefs.savedSwatches, isNot(contains(colores.first)));
    expect(prefs.savedSwatches.last, colores.last);
  });

  test('removeSwatch() la quita y persiste', () async {
    final uno = BackgroundPreference(dataDir: datos);
    await uno.addSwatch(const Color(0xFF59F7FF));
    await uno.addSwatch(const Color(0xFF102030));

    await uno.removeSwatch(const Color(0xFF59F7FF));

    expect(uno.savedSwatches, [const Color(0xFF102030)]);

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();
    expect(otro.savedSwatches, [const Color(0xFF102030)]);
  });

  test('una entrada no-hex en swatchesHex se descarta, el resto entra',
      () async {
    File(p.join(datos.path, 'background.json')).writeAsStringSync(jsonEncode(
        {'swatchesHex': ['#59F7FF', 'no-es-hex', '#ZZZZZZ', '#102030']}));

    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.load();

    expect(prefs.savedSwatches,
        [const Color(0xFF59F7FF), const Color(0xFF102030)]);
  });

  test('un fichero con más de 8 muestras (o repetidas) queda en 8 únicas',
      () async {
    final doce =
        List.generate(12, (i) => '#0000${(10 + i).toRadixString(16).padLeft(2, '0').toUpperCase()}');
    File(p.join(datos.path, 'background.json')).writeAsStringSync(jsonEncode(
        {'swatchesHex': [...doce, doce.first]}));

    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.load();

    expect(prefs.savedSwatches, hasLength(8));
    expect(prefs.savedSwatches.toSet(), hasLength(8));
  });

  test('la lectura en segundo plano no pisa una muestra recién guardada',
      () async {
    File(p.join(datos.path, 'background.json')).writeAsStringSync(
        jsonEncode({'swatchesHex': ['#102030']}));

    final prefs = BackgroundPreference(dataDir: datos);
    // el usuario guarda con la lectura de arranque aún EN VUELO: gane quien
    // gane la carrera, la fusión conserva las dos
    final lectura = prefs.load();
    await prefs.addSwatch(const Color(0xFF59F7FF));
    await lectura;

    expect(prefs.savedSwatches, contains(const Color(0xFF59F7FF)));
    expect(prefs.savedSwatches, contains(const Color(0xFF102030)));
  });

  test('resetAll() también vacía las muestras guardadas', () async {
    final prefs = BackgroundPreference(dataDir: datos);
    await prefs.addSwatch(const Color(0xFF59F7FF));

    await prefs.resetAll();

    expect(prefs.savedSwatches, isEmpty);

    final otro = BackgroundPreference(dataDir: datos);
    await otro.load();
    expect(otro.savedSwatches, isEmpty);
  });
}
