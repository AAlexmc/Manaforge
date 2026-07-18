import Foundation

/// Matemática de la curva de maná — espejo 1:1 de `engine-reference/forge/curve.py`.
/// Cualquier cambio aquí debe replicarse en la referencia Python y viceversa;
/// los tests de ambos lados usan los mismos números.
public enum Archetype: String, Codable, CaseIterable {
    case aggro, tempo, midrange, control

    /// Rango de tierras para mazos de 60 (aprox. Frank Karsten).
    public var landRange: ClosedRange<Int> {
        switch self {
        case .aggro:    return 20...23
        case .tempo:    return 22...24
        case .midrange: return 23...25
        case .control:  return 26...27
        }
    }

    /// Rango de coste medio de maná aceptable para el arquetipo.
    public var averageCMCRange: ClosedRange<Double> {
        switch self {
        case .aggro:    return 0.0...2.2
        case .tempo:    return 1.8...2.6
        case .midrange: return 2.2...3.5
        case .control:  return 2.8...3.8
        }
    }
}

public enum ManaCurve {
    public static let deckSize = 60

    /// Valor de maná de un coste tipo "{2}{U}{U}". X cuenta como 0; {2/W} cuenta 2.
    public static func manaValue(_ cost: String) -> Int {
        symbols(in: cost).reduce(0) { total, sym in
            if let n = Int(sym) { return total + n }
            if ["X", "Y", "Z"].contains(sym.uppercased()) { return total }
            if sym.contains("/") && sym.contains("2") { return total + 2 }
            return total + 1
        }
    }

    /// Símbolos de color de un coste (los híbridos cuentan para ambos colores).
    public static func colorSymbols(_ cost: String) -> [Character: Int] {
        var out: [Character: Int] = [:]
        for sym in symbols(in: cost) {
            for ch in "WUBRG" where sym.uppercased().contains(ch) {
                out[ch, default: 0] += 1
            }
        }
        return out
    }

    /// Coste medio de un conjunto de hechizos {nombre: cantidad}.
    public static func averageCMC(cards: [String: Int], pool: [String: Card]) -> Double {
        let n = cards.values.reduce(0, +)
        guard n > 0 else { return 0 }
        let total = cards.reduce(0.0) { acc, entry in
            acc + Double((pool[entry.key]?.cmc ?? 0) * entry.value)
        }
        return total / Double(n)
    }

    /// Fuentes baratas de aceleración/robo (cmc ≤ 2 que producen maná o roban).
    public static func cheapSources(cards: [String: Int], pool: [String: Card]) -> Int {
        cards.reduce(0) { acc, entry in
            guard let card = pool[entry.key], card.cmc <= 2 else { return acc }
            let text = card.oracle.lowercased()
            return text.contains("add {") || text.contains("draw a card") ? acc + entry.value : acc
        }
    }

    /// Tierras recomendadas: 24 en coste medio 3.0, ±1 por cada ±0.5, menos
    /// descuento por fuentes baratas; acotado al rango del arquetipo.
    public static func recommendedLands(cards: [String: Int], pool: [String: Card], archetype: Archetype) -> Int {
        let avg = averageCMC(cards: cards, pool: pool)
        let raw = 24 + (avg - 3.0) * 2 - Double(cheapSources(cards: cards, pool: pool)) / 3.5
        let range = archetype.landRange
        return min(range.upperBound, max(range.lowerBound, Int(raw.rounded())))
    }

    /// Histograma de curva por CMC (agrupa 7+).
    public static func curveHistogram(cards: [String: Int], pool: [String: Card], cap: Int = 7) -> [Int: Int] {
        var hist: [Int: Int] = [:]
        for (name, qty) in cards {
            let cmc = min(pool[name]?.cmc ?? 0, cap)
            hist[cmc, default: 0] += qty
        }
        return hist
    }

    private static func symbols(in cost: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: #"\{([^}]+)\}"#) else { return [] }
        let range = NSRange(cost.startIndex..., in: cost)
        return regex.matches(in: cost, range: range).compactMap {
            Range($0.range(at: 1), in: cost).map { String(cost[$0]) }
        }
    }
}
