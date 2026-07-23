import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/theme/contrast.dart';

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
}
