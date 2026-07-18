// ManaForgeTokens.swift — design tokens del prototipo aprobado
// Colores definidos en oklch en el diseño; aquí su equivalente sRGB.
// Fuentes del prototipo → equivalentes iOS: Instrument Sans → SF Pro Text,
// Sora (numerales/display) → SF Pro Rounded .bold, JetBrains Mono → SF Mono.

import SwiftUI

enum MFColor {
    // Fondos — tema oscuro (por defecto)
    static let bgDark        = Color(hex: 0x141310) // oklch(0.16 0.005 90)
    static let surfaceDark   = Color(hex: 0x1E1C18)
    static let tabBarDark    = Color(hex: 0x171613)
    static let textDark      = Color(hex: 0xF2EFE9)
    // Fondos — tema claro
    static let bgLight       = Color(hex: 0xF6F3ED)
    static let surfaceLight  = Color(hex: 0xFFFFFF)
    static let tabBarLight   = Color(hex: 0xEFECE4)
    static let textLight     = Color(hex: 0x1C1A16)
    // Maná (uso semántico; misma croma/luminosidad, varía el tono)
    static let manaWhite = Color(hex: 0xE0CC8A) // oklch(0.85 0.09 90)
    static let manaBlue  = Color(hex: 0x5A9BD8) // oklch(0.70 0.14 240)
    static let manaBlack = Color(hex: 0x8A6E9E) // oklch(0.55 0.09 310)
    static let manaRed   = Color(hex: 0xE06A50) // oklch(0.65 0.17 30)  ← acento principal (FAB, tab activa)
    static let manaGreen = Color(hex: 0x4FB878) // oklch(0.70 0.14 150)
    // Funcionales
    static let forge   = Color(hex: 0x9B6BD6) // oklch(0.60 0.16 300) — exclusivo de Forge
    static let success = Color(hex: 0x5BCB8C) // oklch(0.75 0.13 150) — "✓ completo", confirmación de escaneo
    static let warning = Color(hex: 0xD9B24A) // oklch(0.78 0.13 80) — "faltan N cartas"
}

enum MFType {
    // Dynamic Type: usar .relativeTo en todos
    static let screenTitle  = Font.system(size: 30, weight: .bold)              // "Colección"
    static let bigNumber    = Font.system(size: 34, weight: .bold, design: .rounded) // valor total
    static let deckName     = Font.system(size: 19, weight: .bold, design: .rounded)
    static let sectionTitle = Font.system(size: 15, weight: .semibold)
    static let body         = Font.system(size: 13.5)
    static let caption      = Font.system(size: 11, weight: .regular)
    static let badge        = Font.system(size: 9, weight: .bold, design: .monospaced) // NM/EX/GD, FOIL
}

enum MFSpace { // escala de 4
    static let xs: CGFloat = 4; static let s: CGFloat = 8; static let m: CGFloat = 12
    static let l: CGFloat = 16; static let xl: CGFloat = 20
}

enum MFRadius {
    static let card: CGFloat = 18      // tarjeta de valor
    static let cell: CGFloat = 14      // filas, binders
    static let button: CGFloat = 14
    static let chip: CGFloat = 999     // chips de filtro, FAB
    static let thumb: CGFloat = 5      // miniatura de carta 36×50 (ratio 0.72)
}

extension Color {
    init(hex: UInt) {
        self.init(.sRGB, red: Double((hex >> 16) & 0xFF)/255,
                  green: Double((hex >> 8) & 0xFF)/255, blue: Double(hex & 0xFF)/255)
    }
}

// Extensión requerida por los tokens (no viene en SwiftUI de serie).
extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
