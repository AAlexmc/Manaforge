"""Tests espejo de `forge_engine/test/deck_score_test.dart` (Task 9)."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.deck_score import evaluate_deck


def _spell(name, mana_cost, cmc, colors):
    return {
        "name": name, "qty": 20, "mana_cost": mana_cost, "cmc": cmc,
        "colors": colors, "types": ["Creature"], "oracle": "",
        "power": cmc, "toughness": cmc,
    }


def test_mismo_mazo_con_manabase_coja_puntua_menos():
    pool = {
        "W Card": _spell("W Card", "{W}{W}", 2, "W"),
        "U Card": _spell("U Card", "{U}{U}", 2, "U"),
    }
    deck = {
        "colors": "WU", "archetype": "midrange",
        "cards": {"W Card": 18, "U Card": 18},
        "lands": {"Plains": 12, "Island": 12},
    }
    bien = evaluate_deck(deck, pool, {"W": 14, "U": 13})
    mal = evaluate_deck(deck, pool, {"W": 14, "U": 6})
    assert mal.total < bien.total


def test_curva_imposible_todo_cmc_6_hunde_el_componente_curve():
    pool_all6 = {f"Six {i}": _spell(f"Six {i}", "{5}{W}", 6, "W") for i in range(6)}
    deck_all6 = {
        "colors": "W", "archetype": "control",
        "cards": {f"Six {i}": 6 for i in range(6)},
        "lands": {"Plains": 26},
    }
    pool_sano = {
        "One": _spell("One", "{W}", 1, "W"),
        "Two": _spell("Two", "{1}{W}", 2, "W"),
        "Three": _spell("Three", "{2}{W}", 3, "W"),
        "Four": _spell("Four", "{3}{W}", 4, "W"),
    }
    deck_sano = {
        "colors": "W", "archetype": "midrange",
        "cards": {"One": 9, "Two": 9, "Three": 9, "Four": 9},
        "lands": {"Plains": 24},
    }
    eval_todo_seises = evaluate_deck(deck_all6, pool_all6, {"W": 26})
    eval_curva_sana = evaluate_deck(deck_sano, pool_sano, {"W": 24})
    assert eval_todo_seises.curve < eval_curva_sana.curve


def test_el_ranking_de_propuestas_usa_total_no_solo_media():
    # "Bonito-inconsistente": gorda por encima de curva pero todo cmc 6 y sin
    # ninguna fuente de su color.
    pool_flashy = {
        "Bomb": {
            "name": "Bomb", "qty": 20, "mana_cost": "{4}{U}{U}", "cmc": 6,
            "colors": "U", "types": ["Creature"], "oracle": "",
            "power": 7, "toughness": 7,
        },
    }
    deck_flashy = {
        "colors": "U", "archetype": "control",
        "cards": {"Bomb": 20}, "lands": {"Island": 26},
    }
    eval_flashy = evaluate_deck(deck_flashy, pool_flashy, {"U": 0})

    # "Modesto-consistente": criaturas en curva 1-4, stats normales, fuentes
    # de sobra.
    pool_modest = {
        "One": _spell("One", "{W}", 1, "W"),
        "Two": _spell("Two", "{1}{W}", 2, "W"),
        "Three": _spell("Three", "{2}{W}", 3, "W"),
        "Four": _spell("Four", "{3}{W}", 4, "W"),
    }
    deck_modest = {
        "colors": "W", "archetype": "midrange",
        "cards": {"One": 5, "Two": 5, "Three": 5, "Four": 5},
        "lands": {"Plains": 24},
    }
    eval_modest = evaluate_deck(deck_modest, pool_modest, {"W": 24})

    # Por eficiencia sola ganaba el flashy...
    assert eval_flashy.efficiency > eval_modest.efficiency
    # ...pero el total (mismo comparador que generate_proposals) lo hunde por
    # su consistencia/curva rotas.
    proposals = sorted(
        [("flashy", eval_flashy.total), ("modest", eval_modest.total)],
        key=lambda p: -p[1],
    )
    assert proposals[0][0] == "modest"
