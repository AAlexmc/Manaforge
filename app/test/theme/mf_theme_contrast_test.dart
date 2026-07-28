import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/core/themes/contrast.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';

void main() {
  final base = mfTheme(Brightness.light);

  test('letra roja ilegible sobre tarjeta piedra: se aclara, no salta a '
      'blanco (el vistazo y la app tienen que enseñar lo mismo)', () {
    const piedra = Color(0xFF2A2723);
    const rojo = Color(0xFFF44336);
    final tema = mfThemeSobreFondo(base, card: piedra, text: rojo);

    final letra = tema.textTheme.bodyLarge!.color!;
    expect(esLegible(letra, piedra), isTrue);
    final hueOriginal = HSLColor.fromColor(rojo).hue;
    final hueAjustado = HSLColor.fromColor(letra).hue;
    expect((hueAjustado - hueOriginal).abs(), lessThanOrEqualTo(2),
        reason: 'conserva el matiz rojo, no salta a blanco/negro');
  });

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

  test('el icono de la barra se contrasta con el color de la barra, no con la '
      'tarjeta', () {
    final barra = base.navigationBarTheme.backgroundColor!; // clara
    // tarjeta OSCURA + icono claro: sobre la tarjeta el icono claro se lee,
    // pero sobre la barra (clara) no. Cada uno debe ir a su fondo.
    final tema = mfThemeSobreFondo(base,
        card: const Color(0xFF101010), icon: const Color(0xFFF2F0EA));
    final iconTarjeta = tema.iconTheme.color!;
    final iconBarra = tema.navigationBarTheme.iconTheme!.resolve({})!.color!;
    expect(esLegible(iconTarjeta, const Color(0xFF101010)), isTrue,
        reason: 'sobre la tarjeta oscura');
    expect(esLegible(iconBarra, barra), isTrue,
        reason: 'sobre la barra clara');
    expect(iconTarjeta == iconBarra, isFalse,
        reason: 'fondos distintos → colores de icono distintos');
  });

  test('el SnackBar se lee entero en los dos temas: contenido, acción '
      '(DESHACER) y X de cierre contrastan con su fondo', () {
    for (final brightness in Brightness.values) {
      final st = mfTheme(brightness).snackBarTheme;
      final fondo = st.backgroundColor!;
      expect(esLegible(st.contentTextStyle!.color!, fondo), isTrue,
          reason: 'contenido en $brightness');
      expect(esLegible(st.actionTextColor!, fondo), isTrue,
          reason: 'acción en $brightness (antes salía casi del color '
              'del fondo)');
      expect(esLegible(st.closeIconColor!, fondo), isTrue,
          reason: 'X de cierre en $brightness');
      expect(st.showCloseIcon, isTrue,
          reason: 'sin la X, un aviso con acción parece no irse nunca');
    }
  });
}
