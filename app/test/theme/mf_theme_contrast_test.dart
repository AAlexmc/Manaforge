import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/theme/contrast.dart';
import 'package:manaforge_app/theme/mf_theme.dart';

void main() {
  final base = mfTheme(Brightness.light);

  test('letra ilegible sobre la tarjeta se ajusta a color legible', () {
    // tarjeta casi blanca + letra casi blanca: combinación ilegible
    final tema = mfThemeSobreFondo(base,
        card: const Color(0xFFFAFAFA), text: const Color(0xFFFFFFFF));
    final letra = tema.colorScheme.onSurface;
    expect(esLegible(letra, const Color(0xFFFAFAFA)), isTrue,
        reason: 'la letra debe leerse sobre la tarjeta');
    expect(tema.textTheme.bodyMedium!.color, letra);
  });

  test('letra que ya se lee se respeta tal cual', () {
    const negro = Color(0xFF000000);
    final tema = mfThemeSobreFondo(base,
        card: const Color(0xFFFAFAFA), text: negro);
    expect(tema.colorScheme.onSurface, negro);
  });

  test('iconos ilegibles sobre la tarjeta también se ajustan', () {
    final tema = mfThemeSobreFondo(base,
        card: const Color(0xFF101010), icon: const Color(0xFF151515));
    final ic = tema.iconTheme.color!;
    expect(esLegible(ic, const Color(0xFF101010)), isTrue);
  });

  test('sin colores a medida el tema no cambia la letra base', () {
    final tema = mfThemeSobreFondo(base);
    expect(tema.colorScheme.onSurface, base.colorScheme.onSurface);
  });
}
