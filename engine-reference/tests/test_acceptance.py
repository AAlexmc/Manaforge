"""Tests de aceptación del motor Forge.

Los fixtures son mazos reales generados a partir de una colección ManaBox real
durante el diseño del producto: si el validador los rechaza, el motor está roto.
"""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.curve import mana_value, average_cmc, recommended_lands, curve_histogram, color_symbols
from forge.validator import validate_deck

FIXTURES = pathlib.Path(__file__).parent.parent / "fixtures"
POOL = json.loads((FIXTURES / "pool.json").read_text())
DECKS = json.loads((FIXTURES / "decks.json").read_text())


def test_mana_value():
    assert mana_value("{2}{U}{U}") == 4
    assert mana_value("{G}") == 1
    assert mana_value("{X}{R}") == 1          # X cuenta 0
    assert mana_value("{B/G}{B/G}") == 2      # híbridos
    assert mana_value("") == 0                 # tierras


def test_color_symbols():
    assert color_symbols("{1}{W}{B}{B}") == {"W": 1, "B": 2}
    assert color_symbols("{B/G}{B/G}")["B"] == 2  # híbrido cuenta para ambos
    assert color_symbols("{B/G}{B/G}")["G"] == 2


def test_all_generated_decks_are_valid():
    for name, deck in DECKS.items():
        errors = validate_deck(deck, POOL)
        assert errors == [], f"{name}: {errors}"


def test_curve_histogram_sums_to_spell_count():
    """El bug que cazamos en el prototipo: las barras DEBEN sumar los hechizos."""
    for name, deck in DECKS.items():
        hist = curve_histogram(deck["cards"], POOL)
        assert sum(hist.values()) == sum(deck["cards"].values()), name


def test_recommended_lands_within_archetype_range():
    """Tolerancia ±2: la fórmula es una guía; un constructor humano puede
    desviarse (p. ej. el mazo de improvisar lleva 25 con recomendación de 23)."""
    for name, deck in DECKS.items():
        rec = recommended_lands(deck["cards"], POOL, deck["archetype"])
        actual = sum(deck["lands"].values())
        assert abs(rec - actual) <= 2, f"{name}: recomendadas {rec}, mazo lleva {actual}"


def test_validator_catches_too_many_copies():
    deck = json.loads(json.dumps(DECKS["Sangre y Fe v3 (WB drenaje)"]))
    deck["cards"]["Cruel Feeding"] = 5  # solo hay 4 y el límite es 4
    errors = validate_deck(deck, POOL)
    assert any("Cruel Feeding" in e for e in errors)


def test_validator_catches_not_owned():
    deck = json.loads(json.dumps(DECKS["Cielos de Serra (WU voladores)"]))
    deck["cards"]["Black Lotus"] = 1
    errors = validate_deck(deck, POOL)
    assert any("Black Lotus" in e for e in errors)


def test_validator_catches_wrong_size():
    deck = json.loads(json.dumps(DECKS["El Taller de Tezzeret (UB artefactos)"]))
    deck["lands"]["Island"] += 1
    errors = validate_deck(deck, POOL)
    assert any("61" in e for e in errors)


def test_validator_catches_color_identity():
    deck = json.loads(json.dumps(DECKS["Cielos de Serra (WU voladores)"]))
    deck["cards"]["Murder"] = 1  # negro en mazo WU
    del deck["cards"]["Inspiration"]  # mantener 60
    errors = validate_deck(deck, POOL)
    assert any("identidad" in e for e in errors)
