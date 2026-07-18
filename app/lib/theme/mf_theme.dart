import 'package:flutter/material.dart';

/// Tokens de color del DesignSystem (DesignSystem/ManaForgeTokens.swift).
/// Cualquier cambio debe hacerse primero en el handoff y replicarse aquí.
class MFColors {
  MFColors._();

  // Fondos — tema oscuro (por defecto)
  static const bgDark = Color(0xFF141310);
  static const surfaceDark = Color(0xFF1E1C18);
  static const tabBarDark = Color(0xFF171613);
  static const textDark = Color(0xFFF2EFE9);

  // Fondos — tema claro
  static const bgLight = Color(0xFFF6F3ED);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const tabBarLight = Color(0xFFEFECE4);
  static const textLight = Color(0xFF1C1A16);

  // Maná (uso semántico)
  static const manaWhite = Color(0xFFE0CC8A);
  static const manaBlue = Color(0xFF5A9BD8);
  static const manaBlack = Color(0xFF8A6E9E);
  static const manaRed = Color(0xFFE06A50); // acento principal (FAB, tab activa)
  static const manaGreen = Color(0xFF4FB878);

  // Funcionales
  static const forge = Color(0xFF9B6BD6); // exclusivo de Forge
  static const success = Color(0xFF5BCB8C); // "✓ completo", escaneo ok
  static const warning = Color(0xFFD9B24A); // "faltan N cartas"
}

ThemeData mfTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: MFColors.manaRed,
    onPrimary: Colors.white,
    secondary: MFColors.forge,
    onSecondary: Colors.white,
    error: MFColors.manaRed,
    onError: Colors.white,
    surface: dark ? MFColors.surfaceDark : MFColors.surfaceLight,
    onSurface: dark ? MFColors.textDark : MFColors.textLight,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? MFColors.bgDark : MFColors.bgLight,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? MFColors.tabBarDark : MFColors.tabBarLight,
      indicatorColor: MFColors.manaRed.withValues(alpha: 0.22),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MFColors.manaRed,
      foregroundColor: Colors.white,
    ),
  );
}
