import Foundation

/// Carta del pool del usuario (subconjunto de los datos de Scryfall que el motor necesita).
public struct Card: Codable, Hashable {
    public let name: String
    public var qty: Int
    public let manaCost: String
    public let cmc: Int
    public let colors: String      // "WB", "U", "" para incoloras
    public let types: [String]     // ["Creature"], ["Land"], …
    public let oracle: String

    public init(name: String, qty: Int, manaCost: String, cmc: Int,
                colors: String, types: [String], oracle: String) {
        self.name = name
        self.qty = qty
        self.manaCost = manaCost
        self.cmc = cmc
        self.colors = colors
        self.types = types
        self.oracle = oracle
    }

    enum CodingKeys: String, CodingKey {
        case name, qty, cmc, colors, types, oracle
        case manaCost = "mana_cost"
    }

    public var isLand: Bool { types.contains("Land") }
    public var isCreature: Bool { types.contains("Creature") }
}

/// Un mazo generado o construido a mano.
public struct Deck: Codable {
    public let name: String
    public let colors: String
    public let archetype: Archetype
    public var cards: [String: Int]   // hechizos y criaturas {nombre: cantidad}
    public var lands: [String: Int]   // tierras {nombre: cantidad}

    public init(name: String, colors: String, archetype: Archetype,
                cards: [String: Int], lands: [String: Int]) {
        self.name = name
        self.colors = colors
        self.archetype = archetype
        self.cards = cards
        self.lands = lands
    }

    public var totalCards: Int {
        cards.values.reduce(0, +) + lands.values.reduce(0, +)
    }
}
