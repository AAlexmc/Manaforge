import XCTest
@testable import ForgeEngine

/// Tests espejo de `engine-reference/tests/test_acceptance.py`.
/// Los números vienen de mazos reales generados durante el diseño del producto:
/// "Sangre y Fe v3" (WB drenaje) → 36 hechizos, coste medio 2.64, 24 tierras.
final class ForgeEngineTests: XCTestCase {

    func testManaValue() {
        XCTAssertEqual(ManaCurve.manaValue("{2}{U}{U}"), 4)
        XCTAssertEqual(ManaCurve.manaValue("{G}"), 1)
        XCTAssertEqual(ManaCurve.manaValue("{X}{R}"), 1)      // X cuenta 0
        XCTAssertEqual(ManaCurve.manaValue("{B/G}{B/G}"), 2)  // híbridos
        XCTAssertEqual(ManaCurve.manaValue(""), 0)            // tierras
    }

    func testColorSymbols() {
        let rite = ManaCurve.colorSymbols("{1}{W}{B}{B}")
        XCTAssertEqual(rite["W"], 1)
        XCTAssertEqual(rite["B"], 2)
        let hybrid = ManaCurve.colorSymbols("{B/G}{B/G}")
        XCTAssertEqual(hybrid["B"], 2)  // el híbrido cuenta para ambos
        XCTAssertEqual(hybrid["G"], 2)
    }

    // Mini-pool de prueba: números tomados del fixture Python.
    private var pool: [String: Card] {
        [
            "Gray Merchant of Asphodel": Card(name: "Gray Merchant of Asphodel", qty: 3, manaCost: "{3}{B}{B}", cmc: 5, colors: "B", types: ["Creature"], oracle: "each opponent loses X life"),
            "Cruel Feeding": Card(name: "Cruel Feeding", qty: 4, manaCost: "{B}", cmc: 1, colors: "B", types: ["Instant"], oracle: "lifelink until end of turn"),
            "Healer's Hawk": Card(name: "Healer's Hawk", qty: 1, manaCost: "{W}", cmc: 1, colors: "W", types: ["Creature"], oracle: "Flying, lifelink"),
            "Llanowar Elves": Card(name: "Llanowar Elves", qty: 2, manaCost: "{G}", cmc: 1, colors: "G", types: ["Creature"], oracle: "{T}: Add {G}."),
            "Swamp": Card(name: "Swamp", qty: 12, manaCost: "", cmc: 0, colors: "", types: ["Land"], oracle: "{T}: Add {B}."),
            "Plains": Card(name: "Plains", qty: 14, manaCost: "", cmc: 0, colors: "", types: ["Land"], oracle: "{T}: Add {W}."),
        ]
    }

    private var validDeck: Deck {
        // Mazo sintético válido: 36 hechizos + 24 tierras, midrange.
        var cards: [String: Int] = [:]
        cards["Gray Merchant of Asphodel"] = 3   // 5 CMC ×3
        cards["Cruel Feeding"] = 4               // 1 CMC ×4
        cards["Healer's Hawk"] = 1               // 1 CMC
        // relleno sintético a 2-3 CMC para acercar el coste medio a midrange
        for i in 0..<28 {
            let name = "Relleno \(i)"
            cards[name] = 1
        }
        return Deck(name: "Test", colors: "WB", archetype: .midrange,
                    cards: cards, lands: ["Swamp": 12, "Plains": 12])
    }

    private var poolWithFiller: [String: Card] {
        var p = pool
        for i in 0..<28 {
            let name = "Relleno \(i)"
            p[name] = Card(name: name, qty: 1, manaCost: "{1}{B}", cmc: 2, colors: "B", types: ["Creature"], oracle: "")
        }
        p["Plains"] = Card(name: "Plains", qty: 14, manaCost: "", cmc: 0, colors: "", types: ["Land"], oracle: "")
        return p
    }

    func testValidDeckPasses() {
        let violations = DeckValidator.validate(deck: validDeck, pool: poolWithFiller)
        XCTAssertTrue(violations.isEmpty, "\(violations)")
    }

    func testCurveHistogramSumsToSpellCount() {
        // El bug que cazamos en el prototipo: las barras DEBEN sumar los hechizos.
        let deck = validDeck
        let hist = ManaCurve.curveHistogram(cards: deck.cards, pool: poolWithFiller)
        XCTAssertEqual(hist.values.reduce(0, +), deck.cards.values.reduce(0, +))
    }

    func testTooManyCopiesFails() {
        var deck = validDeck
        deck.cards["Cruel Feeding"] = 5
        let violations = DeckValidator.validate(deck: deck, pool: poolWithFiller)
        XCTAssertTrue(violations.contains { $0.kind == .tooManyCopies || $0.kind == .notOwned })
    }

    func testNotOwnedFails() {
        var deck = validDeck
        deck.cards["Black Lotus"] = 1
        let violations = DeckValidator.validate(deck: deck, pool: poolWithFiller)
        XCTAssertTrue(violations.contains { $0.kind == .notOwned })
    }

    func testColorIdentityFails() {
        var deck = validDeck
        deck.cards["Llanowar Elves"] = 1  // verde en mazo WB
        deck.cards.removeValue(forKey: "Healer's Hawk")
        let violations = DeckValidator.validate(deck: deck, pool: poolWithFiller)
        XCTAssertTrue(violations.contains { $0.kind == .colorIdentity })
    }

    func testKarstenLandFormula() {
        // Coste medio 3.0 sin fuentes baratas → 24 tierras para midrange.
        var cards: [String: Int] = [:]
        var p: [String: Card] = [:]
        for i in 0..<36 {
            let name = "Tres \(i)"
            cards[name] = 1
            p[name] = Card(name: name, qty: 1, manaCost: "{2}{B}", cmc: 3, colors: "B", types: ["Creature"], oracle: "")
        }
        XCTAssertEqual(ManaCurve.recommendedLands(cards: cards, pool: p, archetype: .midrange), 24)
    }
}
