import 'dart:ui';

import 'package:flutter/painting.dart' show HSLColor;
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/ui/core/themes/contrast.dart';

const _blanco = Color(0xFFFFFFFF);
const _negro = Color(0xFF000000);

void main() {
  test('el ratio de contraste va de 1 a 21', () {
    expect(contrastRatio(_negro, _blanco), closeTo(21, 0.01));
    expect(contrastRatio(_blanco, _blanco), closeTo(1, 0.001));
    expect(contrastRatio(_negro, _negro), closeTo(1, 0.001));
    // es simétrico
    expect(contrastRatio(_blanco, _negro), closeTo(21, 0.01));
  });

  test('esLegible: negro sobre blanco sí, blanco sobre blanco no', () {
    expect(esLegible(_negro, _blanco), isTrue);
    expect(esLegible(_blanco, _blanco), isFalse);
  });

  test('legibleOn respeta el color si ya se lee', () {
    // negro se lee sobre blanco: se queda tal cual
    expect(legibleOn(_blanco, _negro), _negro);
    // blanco se lee sobre negro
    expect(legibleOn(_negro, _blanco), _blanco);
  });

  test('legibleOn arregla la letra ilegible saltando a blanco/negro', () {
    // letra casi blanca sobre tarjeta clara: ilegible -> negro
    final claroClaro = legibleOn(const Color(0xFFEFEFEF), const Color(0xFFFAFAFA));
    expect(claroClaro, _negro);
    expect(esLegible(claroClaro, const Color(0xFFEFEFEF)), isTrue);

    // letra casi negra sobre tarjeta oscura: ilegible -> blanco
    final oscuroOscuro = legibleOn(const Color(0xFF101010), const Color(0xFF202020));
    expect(oscuroOscuro, _blanco);
    expect(esLegible(oscuroOscuro, const Color(0xFF101010)), isTrue);
  });

  test('legibleOn conserva el alfa del color pedido', () {
    final ajustado = legibleOn(const Color(0xFFF0F0F0), const Color(0x80FAFAFA));
    expect(ajustado.a, closeTo(0x80 / 255, 0.005));
  });

  test('toneLegible conserva el matiz: rojo sobre piedra se aclara, no salta '
      'a blanco', () {
    const piedra = Color(0xFF2A2723);
    const rojo = Color(0xFFF44336);
    expect(esLegible(rojo, piedra), isFalse,
        reason: 'de partida el rojo NO se lee sobre la tarjeta piedra');

    final ajustado = toneLegible(piedra, rojo);

    expect(esLegible(ajustado, piedra), isTrue);
    expect(ajustado, isNot(_blanco));
    final hueOriginal = HSLColor.fromColor(rojo).hue;
    final hueAjustado = HSLColor.fromColor(ajustado).hue;
    expect((hueAjustado - hueOriginal).abs(), lessThanOrEqualTo(2));
  });

  test('toneLegible respeta el color si ya se lee', () {
    const piedra = Color(0xFF2A2723);
    const dorado = Color(0xFFE0CC8A); // ya legible sobre piedra
    expect(toneLegible(piedra, dorado), dorado);
  });

  test('toneLegible con letra oscura sobre tarjeta clara: se oscurece '
      'conservando el matiz', () {
    const hueso = Color(0xFFF2EFE9);
    const rojo = Color(0xFFF44336);
    expect(esLegible(rojo, hueso), isFalse);

    final ajustado = toneLegible(hueso, rojo);

    expect(esLegible(ajustado, hueso), isTrue);
    expect(ajustado, isNot(_negro));
    final hueOriginal = HSLColor.fromColor(rojo).hue;
    final hueAjustado = HSLColor.fromColor(ajustado).hue;
    expect((hueAjustado - hueOriginal).abs(), lessThanOrEqualTo(2));
    // se oscurece: la claridad baja respecto al rojo de partida
    expect(HSLColor.fromColor(ajustado).lightness,
        lessThan(HSLColor.fromColor(rojo).lightness));
  });

  test('toneLegible conserva el alfa del color pedido', () {
    const piedra = Color(0xFF2A2723);
    final ajustado = toneLegible(piedra, const Color(0x80F44336));
    expect(ajustado.a, closeTo(0x80 / 255, 0.005));
  });
}
