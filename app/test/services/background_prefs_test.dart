/// El fondo de pantalla.
///
/// Es un fichero que elige el usuario, así que se acota como todo lo que
/// entra de fuera. Y la imagen se COPIA a la carpeta de datos: si el original
/// se mueve o se borra, el fondo tiene que seguir estando.
library;

import 'dart:async';
import 'dart:io';

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
}
