"""Tests del generador (fase 3) contra la colección real de los fixtures."""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.classify import classify, theme_roles
from forge.generator import generate_deck, generate_proposals
from forge.validator import validate_deck

FIXTURES = pathlib.Path(__file__).parent.parent / "fixtures"
POOL = json.loads((FIXTURES / "pool.json").read_text())


def test_classify_known_cards():
    murder = POOL["Murder"]
    assert "removal" in classify(murder)
    counterspell = POOL["Counterspell"]
    assert "counterspell" in classify(counterspell)
    elves = POOL["Llanowar Elves"]
    assert "ramp" in classify(elves)


def test_theme_roles_lifegain():
    priest = POOL["Marauding Blight-Priest"]
    assert theme_roles(priest).get("lifegain") == "payoff"
    hawk = POOL["Healer's Hawk"]
    assert theme_roles(hawk).get("lifegain") == "enabler"


def test_generated_decks_pass_validator():
    """Todo mazo que el generador devuelve DEBE pasar el validador (regla 6)."""
    proposals = generate_proposals(POOL)
    assert len(proposals) >= 2, "la colección real da para varias propuestas"
    for deck in proposals:
        assert validate_deck(deck, POOL) == [], deck["name"]


def test_generated_deck_wb_finds_lifegain_theme():
    """En la colección real, el tema natural de WB es lifegain/drenaje."""
    deck = generate_deck(POOL, "WB")
    assert deck is not None
    assert deck["theme"] == "lifegain"


def test_generator_respects_scarce_lands():
    """Solo hay 2 Mountains y 4 Forests: los mazos RG no deben salir
    (la colección no tiene base de maná) — Forge avisa en vez de forzar."""
    deck = generate_deck(POOL, "RG")
    assert deck is None


def test_proposals_are_distinct_colors():
    proposals = generate_proposals(POOL)
    assert len({d["colors"] for d in proposals}) == len(proposals)
