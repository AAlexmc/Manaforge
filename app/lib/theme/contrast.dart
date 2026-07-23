import 'dart:math' as math;
import 'dart:ui';

/// Contraste y legibilidad de color (WCAG 2.x).
///
/// Se usa para que la letra a medida no quede ilegible sobre la tarjeta a
/// medida: si el usuario elige, p. ej., letra casi blanca sobre tarjeta clara,
/// la letra salta a blanco/negro legible.

/// Luminancia relativa de un color (0 negro .. 1 blanco), canal alfa ignorado.
double relativeLuminance(Color c) {
  double lin(double channel) {
    final s = channel; // 0..1
    return s <= 0.03928 ? s / 12.92 : math.pow((s + 0.055) / 1.055, 2.4) as double;
  }

  // Color.r/g/b son 0..1 en Flutter reciente.
  return 0.2126 * lin(c.r) + 0.7152 * lin(c.g) + 0.0722 * lin(c.b);
}

/// Ratio de contraste entre dos colores: 1 (nada) .. 21 (negro sobre blanco).
double contrastRatio(Color a, Color b) {
  final la = relativeLuminance(a);
  final lb = relativeLuminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Umbral por defecto: AA para texto normal.
const double kMinContrast = 4.5;

/// ¿El color de frente [fg] se lee sobre el fondo [bg]?
bool esLegible(Color fg, Color bg, {double min = kMinContrast}) =>
    contrastRatio(fg, bg) >= min;

/// Devuelve [desired] si se lee sobre [bg]; si no, blanco o negro (el que más
/// contraste dé). El alfa de [desired] se conserva.
Color legibleOn(Color bg, Color desired, {double min = kMinContrast}) {
  if (contrastRatio(desired, bg) >= min) return desired;
  final blanco = contrastRatio(const Color(0xFFFFFFFF), bg);
  final negro = contrastRatio(const Color(0xFF000000), bg);
  final base = blanco >= negro ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  return base.withValues(alpha: desired.a);
}
