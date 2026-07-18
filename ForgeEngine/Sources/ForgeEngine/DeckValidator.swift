import Foundation

/// Las reglas duras que Forge NUNCA puede violar.
/// Espejo 1:1 de `engine-reference/forge/validator.py`.
///
/// Regla de producto: si la colección no permite cumplirlas, Forge avisa y
/// explica el compromiso en lugar de generar un mazo defectuoso.
public enum DeckValidator {
    public static let basicLands: Set<String> = ["Plains", "Island", "Swamp", "Mountain", "Forest"]
    public static let maxCopies = 4

    public struct Violation: Equatable, CustomStringConvertible {
        public enum Kind { case notOwned, tooManyCopies, wrongSize, colorIdentity, landCount, curveOutOfRange }
        public let kind: Kind
        public let message: String
        public var description: String { message }
    }

    public static func validate(deck: Deck, pool: [String: Card]) -> [Violation] {
        var violations: [Violation] = []
        let everything = deck.cards.merging(deck.lands, uniquingKeysWith: +)

        // 1-2: propiedad y límite de copias
        for (name, qty) in everything {
            guard let owned = pool[name] else {
                violations.append(.init(kind: .notOwned, message: "'\(name)' no está en la colección"))
                continue
            }
            if qty > owned.qty {
                violations.append(.init(kind: .notOwned, message: "'\(name)': usa \(qty), posee \(owned.qty)"))
            }
            if qty > maxCopies && !basicLands.contains(name) {
                violations.append(.init(kind: .tooManyCopies, message: "'\(name)': \(qty) copias supera el límite de \(maxCopies)"))
            }
        }

        // 3: tamaño exacto
        if deck.totalCards != ManaCurve.deckSize {
            violations.append(.init(kind: .wrongSize, message: "el mazo tiene \(deck.totalCards) cartas, deben ser \(ManaCurve.deckSize)"))
        }

        // 4: identidad de color
        let allowed = Set(deck.colors)
        for name in deck.cards.keys {
            guard let card = pool[name] else { continue }
            if !Set(card.colors).isSubset(of: allowed) {
                violations.append(.init(kind: .colorIdentity, message: "'\(name)' (\(card.colors)) fuera de la identidad \(deck.colors)"))
            }
        }

        // 5: tierras y coste medio dentro del arquetipo
        let landCount = deck.lands.values.reduce(0, +)
        if !deck.archetype.landRange.contains(landCount) {
            violations.append(.init(kind: .landCount, message: "\(landCount) tierras fuera del rango \(deck.archetype.landRange) de \(deck.archetype.rawValue)"))
        }
        let knownCards = deck.cards.filter { pool[$0.key] != nil }
        let avg = ManaCurve.averageCMC(cards: knownCards, pool: pool)
        if !knownCards.isEmpty && !deck.archetype.averageCMCRange.contains(avg) {
            violations.append(.init(kind: .curveOutOfRange, message: String(format: "coste medio %.2f fuera del rango de %@", avg, deck.archetype.rawValue)))
        }

        return violations
    }
}
