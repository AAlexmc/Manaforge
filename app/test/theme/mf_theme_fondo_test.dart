/// El tema cuando hay fondo de pantalla puesto.
///
/// Lo que se comprueba aquí es que el fondo se pueda ver (pantallas
/// transparentes, tarjetas que dejan pasar algo) sin llevarse por delante lo
/// que tiene que seguir siendo opaco y legible.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';

void main() {
  final base = mfTheme(Brightness.dark);

  test('las pantallas se vuelven transparentes: si no, tapan la imagen', () {
    final tema = mfThemeSobreFondo(base);

    expect(tema.scaffoldBackgroundColor, Colors.transparent);
    expect(tema.canvasColor, Colors.transparent);
  });

  test('sin elegir colores, se quedan los de siempre', () {
    final tema = mfThemeSobreFondo(base);

    expect(tema.colorScheme.surface, base.colorScheme.surface);
    expect(tema.colorScheme.onSurface, base.colorScheme.onSurface);
  });

  test('el color de las tarjetas se aplica con su transparencia', () {
    final tema = mfThemeSobreFondo(base,
        card: const Color(0xFF14243A), cardOpacity: 0.5);

    final color = tema.cardTheme.color!;
    expect((color.r * 255).round(), 0x14);
    expect((color.g * 255).round(), 0x24);
    expect((color.b * 255).round(), 0x3A);
    expect(color.a, closeTo(0.5, 0.01));
  });

  test('los diálogos NO se vuelven translúcidos: un diálogo así no se lee',
      () {
    final tema = mfThemeSobreFondo(base,
        card: const Color(0xFF14243A), cardOpacity: 0.4);

    // la transparencia vive en el tema de las tarjetas, no en el `surface`
    // por el que pasan diálogos y menús
    expect(tema.colorScheme.surface.a, 1);
  });

  test('el color de la letra llega al texto, al icono y al esquema', () {
    const letra = Color(0xFFE0CC8A);
    final tema = mfThemeSobreFondo(base, text: letra);

    expect(tema.colorScheme.onSurface, letra);
    expect(tema.textTheme.bodyMedium?.color, letra);
    expect(tema.textTheme.titleLarge?.color, letra);
    expect(tema.iconTheme.color, letra);
  });

  test('una transparencia fuera de rango no rompe el color', () {
    final tema = mfThemeSobreFondo(base, cardOpacity: 5);

    expect(tema.cardTheme.color!.a, 1);
  });
}
