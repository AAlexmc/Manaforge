"""Tests espejo de `forge_engine/test/lands_test.dart`.

Fixtures reales (oracle copiado de la DB).
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.lands import land_profile, source_of


def _land(name, oracle, sub=None):
    return {
        "name": name,
        "qty": 4,
        "mana_cost": "",
        "cmc": 0,
        "colors": "",
        "types": ["Land"],
        "subtypes": sub or [],
        "oracle": oracle,
    }


def test_basica():
    p = land_profile(_land("Plains", "({T}: Add {W}.)", sub=["Plains"]))
    assert p.produces == {"W"}
    assert p.tapped == "never"


def test_dual_tipada_condicional_fetching_garden():
    p = land_profile(_land(
        "Fetching Garden",
        "({T}: Add {G} or {W}.)\nFetching Garden enters the battlefield "
        "tapped if it was played from your hand.",
        sub=["Forest", "Plains"],
    ))
    assert p.produces == {"G", "W"}
    assert p.tapped == "conditional"


def test_tapland_incondicional_gate_to_seatower():
    p = land_profile(_land(
        "Gate to Seatower",
        "({T}: Add {U}.)\nGate to Seatower enters the battlefield tapped.\n"
        "{3}{U}, {T}: Seek a nonland card.",
        sub=["Island", "Gate"],
    ))
    assert p.produces == {"U"}
    assert p.tapped == "always"


def test_checkland_unless_conditional():
    p = land_profile(_land(
        "Glacial Fortress",
        "Glacial Fortress enters the battlefield tapped unless you control "
        "a Plains or an Island.\n{T}: Add {W} or {U}.",
    ))
    assert p.produces == {"W", "U"}
    assert p.tapped == "conditional"


def test_fetch_generica_evolving_wilds():
    p = land_profile(_land(
        "Evolving Wilds",
        "{T}, Sacrifice Evolving Wilds: Search your library for a basic "
        "land card, put it onto the battlefield tapped, then shuffle.",
    ))
    assert p.is_fetch
    assert p.fetches == set()
    assert source_of(p, "R", "RG") is True
    assert source_of(p, "U", "RG") is False


def test_fetch_tipada_flooded_strand():
    p = land_profile(_land(
        "Flooded Strand",
        "{T}, Pay 1 life, Sacrifice Flooded Strand: Search your library "
        "for a Plains or Island card, put it onto the battlefield, then "
        "shuffle.",
    ))
    assert p.fetches == {"W", "U"}


def test_utility_incolora_queda_utility():
    p = land_profile(_land("Wastes2", "{T}: Add {C}."))
    assert p.is_utility


def test_any_color():
    p = land_profile(_land("Evolving City", "{T}: Add one mana of any color."))
    assert p.produces == {"W", "U", "B", "R", "G"}
