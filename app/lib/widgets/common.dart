import 'package:flutter/material.dart';

import '../theme/mf_theme.dart';

/// Color de cada símbolo de maná (tokens del DesignSystem).
const Map<String, Color> manaColors = {
  'W': MFColors.manaWhite,
  'U': MFColors.manaBlue,
  'B': MFColors.manaBlack,
  'R': MFColors.manaRed,
  'G': MFColors.manaGreen,
};

/// Puntos de identidad de color de una carta o mazo.
class ColorIdentityDots extends StatelessWidget {
  final String colors; // "WB", "U", "" (incolora)
  final double size;

  const ColorIdentityDots({super.key, required this.colors, this.size = 13});

  @override
  Widget build(BuildContext context) {
    final dots = colors.isEmpty ? ['C'] : colors.split('');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in dots)
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: manaColors[c] ?? Colors.blueGrey,
              ),
            ),
          ),
      ],
    );
  }
}

/// Mini-curva de maná (7 barras, 0-6+) para tarjetas de mazo.
class MiniCurve extends StatelessWidget {
  final Map<int, int> histogram;
  final Color color;
  final double height;

  const MiniCurve(
      {super.key,
      required this.histogram,
      required this.color,
      this.height = 36});

  @override
  Widget build(BuildContext context) {
    final max = histogram.values.fold(1, (a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var cmc = 0; cmc <= 6; cmc++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                height: 4 + height * (histogram[cmc] ?? 0) / max,
                decoration: BoxDecoration(
                  color: (histogram[cmc] ?? 0) > 0
                      ? color
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Imagen de carta con los estados del DesignSystem: skeleton con el color
/// de identidad mientras carga, y nombre sobre skeleton si falla. Nunca un
/// hueco blanco.
class CardThumb extends StatelessWidget {
  final String? url;
  final String colors;
  final String name;
  final double width;
  final double height;
  final double radius;

  const CardThumb({
    super.key,
    required this.url,
    required this.colors,
    required this.name,
    this.width = 36,
    this.height = 50,
    this.radius = 5,
  });

  Color get _identityColor {
    if (colors.length == 1) {
      return manaColors[colors] ?? Colors.blueGrey;
    }
    return colors.isEmpty
        ? Colors.blueGrey
        : manaColors[colors[0]] ?? Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final skeleton = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _identityColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: url == null
          ? Text(
              name.isEmpty ? '' : name[0],
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            )
          : null,
    );
    if (url == null) return skeleton;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : skeleton,
        errorBuilder: (context, error, stack) => skeleton,
      ),
    );
  }
}
