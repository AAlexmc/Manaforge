import 'package:flutter/material.dart';

import 'contrast.dart';

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

/// El tema cuando hay un fondo de pantalla puesto.
///
/// Tres cosas, y las tres tienen que ver con que se vea la imagen:
///  - las pantallas dejan de pintar su color opaco (si no, taparían el fondo
///    entero y no se vería nunca);
///  - las tarjetas pueden llevar el color que elija el usuario y dejar pasar
///    algo de fondo ([cardOpacity]);
///  - la letra también, porque encima de una imagen clara la letra de siempre
///    puede no leerse.
///
/// [card] y [text] null = los del tema de siempre.
ThemeData mfThemeSobreFondo(ThemeData base,
    {Color? card,
    Color? text,
    Color? chip,
    Color? icon,
    double cardOpacity = 1}) {
  final fondoTarjeta = (card ?? base.colorScheme.surface)
      .withValues(alpha: cardOpacity.clamp(0, 1));
  // Red de seguridad: la letra y los iconos van SOBRE la tarjeta, así que si
  // el color a medida no se lee (p. ej. letra clara sobre tarjeta clara)
  // salta a blanco/negro legible. El aviso al usuario lo da la pantalla de
  // Ajustes; aquí solo garantizamos que nunca se renderiza ilegible.
  final fondoLetra = card ?? base.colorScheme.surface;
  // la barra inferior NO se pinta con la tarjeta: lleva su propio color
  // (tabBar*), que no cambia con el fondo. Los iconos de la barra hay que
  // contrastarlos con ESE color, no con el de la tarjeta.
  final fondoBarra = base.navigationBarTheme.backgroundColor ?? fondoLetra;
  final safeText = text == null ? null : legibleOn(fondoLetra, text);
  final safeIcon = icon == null ? null : legibleOn(fondoLetra, icon);
  final safeIconBarra = icon == null ? null : legibleOn(fondoBarra, icon);
  var tema = base.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    canvasColor: Colors.transparent,
    // el color va en el tema de las tarjetas y NO en `colorScheme.surface`:
    // por surface pasan también los diálogos y los menús, y esos tienen que
    // seguir siendo opacos (un diálogo translúcido no se lee)
    cardTheme: base.cardTheme.copyWith(color: fondoTarjeta),
  );
  if (card != null) {
    tema = tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(surface: card));
  }
  if (safeText != null) {
    tema = tema.copyWith(
      colorScheme: tema.colorScheme.copyWith(onSurface: safeText),
      textTheme:
          tema.textTheme.apply(bodyColor: safeText, displayColor: safeText),
      iconTheme: tema.iconTheme.copyWith(color: safeText),
    );
  }
  // las pestañas (chips): el color elegido tiñe la seleccionada y su borde
  if (chip != null) {
    tema = tema.copyWith(
      chipTheme: tema.chipTheme.copyWith(
        selectedColor: chip,
        side: BorderSide(color: chip.withValues(alpha: 0.7)),
        checkmarkColor:
            ThemeData.estimateBrightnessForColor(chip) == Brightness.dark
                ? Colors.white
                : Colors.black,
      ),
    );
  }
  // los iconos. Va DESPUÉS de la letra para que gane sobre el iconTheme que
  // pone el color de letra. Los iconos de marca (Forge, Escanear) llevan su
  // color a mano en el widget, así que no los toca.
  if (safeIcon != null) {
    tema = tema.copyWith(
      iconTheme: tema.iconTheme.copyWith(color: safeIcon),
      navigationBarTheme: tema.navigationBarTheme.copyWith(
        iconTheme: WidgetStatePropertyAll(IconThemeData(color: safeIconBarra)),
      ),
    );
  }
  return tema;
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
