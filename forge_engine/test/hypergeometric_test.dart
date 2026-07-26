import 'package:test/test.dart';
import 'package:forge_engine/forge_engine.dart';

/// Tests espejo de `engine-reference/tests/test_hypergeometric.py`.
void main() {
  test('pmf exacta: 3 tierras en mano de 7 con 24/60', () {
    // C(24,3)*C(36,4)/C(60,7) = 2024*58905/386206920
    expect(hypergeomPmf(60, 24, 7, 3), closeTo(0.3087, 0.0001));
  });
  test('atLeast suma la cola', () {
    final total = List.generate(8, (k) => hypergeomPmf(60, 24, 7, k))
        .reduce((a, b) => a + b);
    expect(total, closeTo(1.0, 1e-9));
    expect(hypergeomAtLeast(60, 24, 7, 0), closeTo(1.0, 1e-9));
  });
  test('mano keepable 24/60: P(2..5 tierras en 7) y mulligan', () {
    final p7 = hypergeomAtLeast(60, 24, 7, 2) - hypergeomAtLeast(60, 24, 7, 6);
    expect(pKeepableHand(24, 60), closeTo(p7 + (1 - p7) * p7, 1e-9));
  });
  test('pLandDrops(24,60,3) = P(>=3 en 9 vistas)', () {
    expect(pLandDrops(24, 60, 3), closeTo(hypergeomAtLeast(60, 24, 9, 3), 1e-12));
  });
  test('degenerados', () {
    expect(hypergeomAtLeast(60, 0, 7, 1), 0.0);
    expect(hypergeomAtLeast(60, 60, 7, 7), closeTo(1.0, 1e-9));
    expect(hypergeomPmf(60, 24, 7, 8), 0.0); // k > draws
  });
}
