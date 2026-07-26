"""Tests del generador (fase 3) contra la colección real de los fixtures."""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.classify import classify, theme_roles, tribal_role
from forge.generator import detect_theme, generate_deck, generate_proposals
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


def _tied_pool():
    cands = {}
    for i in range(3):
        cands[f"Lifegain Payoff {i}"] = {
            "name": f"Lifegain Payoff {i}", "qty": 1, "mana_cost": "{2}{W}",
            "cmc": 3, "colors": "W", "types": ["Creature"],
            "oracle": "Whenever you gain life, draw a card.",
        }
    for i in range(3):
        cands[f"Spells Payoff {i}"] = {
            "name": f"Spells Payoff {i}", "qty": 1, "mana_cost": "{1}{U}",
            "cmc": 2, "colors": "U", "types": ["Creature"],
            "oracle": "Whenever you cast an instant or sorcery spell, draw a card.",
        }
    return cands


def test_detect_theme_empate_lifegain_spells_en_wb_gana_lifegain():
    theme, _ = detect_theme(_tied_pool(), "WB")
    assert theme == "lifegain"


def test_detect_theme_empate_lifegain_spells_en_ur_gana_spells():
    theme, _ = detect_theme(_tied_pool(), "UR")
    assert theme == "spells"


def _reanimator_base_pool(with_payoff: bool = True) -> dict:
    """Mismo pool que `forge_engine/test/generator_test.dart` (Task 10):
    interacción+gordas de sobra, y opcionalmente el payoff de reanimación."""
    p = {
        "Swamp": {
            "name": "Swamp", "qty": 30, "mana_cost": "", "cmc": 0, "colors": "",
            "types": ["Basic", "Land"], "oracle": "{T}: Add {B}.",
        },
        "Charnel Scavenger": {
            "name": "Charnel Scavenger", "qty": 4, "mana_cost": "{1}{B}", "cmc": 2,
            "colors": "B", "types": ["Sorcery"],
            "oracle": "Discard a card, then mill 3 cards.",
        },
        "Read the Bones": {
            "name": "Read the Bones", "qty": 4, "mana_cost": "{2}{B}", "cmc": 3,
            "colors": "B", "types": ["Sorcery"], "oracle": "Draw two cards.",
        },
    }
    if with_payoff:
        p["Raise from the Grave"] = {
            "name": "Raise from the Grave", "qty": 4, "mana_cost": "{2}{B}", "cmc": 3,
            "colors": "B", "types": ["Sorcery"],
            "oracle": "Return target creature card from your graveyard to the battlefield.",
        }
    for i in range(3):
        name = f"Grave Titan Clone {i}"
        p[name] = {
            "name": name, "qty": 4, "mana_cost": "{3}{B}{B}", "cmc": 5, "colors": "B",
            "types": ["Creature"], "oracle": "", "power": 7, "toughness": 7,
        }
    for i in range(5):
        name = f"Removal {i}"
        p[name] = {
            "name": name, "qty": 4, "mana_cost": "{1}{B}", "cmc": 2, "colors": "B",
            "types": ["Instant"], "oracle": "Destroy target creature.",
        }
    for i in range(2):
        name = f"Sweeper {i}"
        p[name] = {
            "name": name, "qty": 4, "mana_cost": "{3}{B}", "cmc": 4, "colors": "B",
            "types": ["Sorcery"], "oracle": "Destroy all creatures.",
        }
    for i, cmc in enumerate([1, 2, 3, 4]):
        name = f"Filler Creature {i}"
        p[name] = {
            "name": name, "qty": 4, "mana_cost": "{%d}" % cmc, "cmc": cmc, "colors": "",
            "types": ["Creature"], "oracle": "", "power": cmc, "toughness": cmc,
        }
    return p


def _copias_cmc_5_o_mas(pool: dict, deck: dict) -> int:
    return sum(qty for name, qty in deck["cards"].items() if pool[name]["cmc"] >= 5)


def test_pool_con_reanimacion_mill_gordas_detecta_reanimator_y_mete_gordas():
    pool = _reanimator_base_pool()
    deck = generate_deck(pool, "B")
    assert deck is not None
    assert deck["theme"] == "reanimator"
    assert _copias_cmc_5_o_mas(pool, deck) >= 4


def test_control_negativo_sin_hechizos_de_reanimacion_las_gordas_se_quedan_fuera():
    deck = generate_deck(_reanimator_base_pool(with_payoff=False), "B")
    assert deck is None or deck["theme"] != "reanimator"


def test_el_validador_sigue_mandando_coste_medio_dentro_del_arquetipo():
    pool = _reanimator_base_pool()
    deck = generate_deck(pool, "B")
    assert deck is not None
    assert validate_deck(deck, pool) == []


def _copias_del_subtipo(pool: dict, deck: dict, subtype: str) -> int:
    return sum(qty for name, qty in deck["cards"].items()
               if subtype in pool[name].get("subtypes", []))


def _elf_pool(with_payoff: bool = True) -> dict:
    """Mismo pool que `forge_engine/test/generator_test.dart` (Task 11):
    14 elfos + 4 payoffs («Other Elves you control get…», el plural
    irregular real de Magic) en G."""
    p = {
        "Forest": {
            "name": "Forest", "qty": 30, "mana_cost": "", "cmc": 0, "colors": "",
            "types": ["Basic", "Land"], "oracle": "{T}: Add {G}.",
        },
    }
    for i, qty in enumerate([4, 4, 3, 3]):
        name = f"Elf Warrior {i}"
        p[name] = {
            "name": name, "qty": qty, "mana_cost": "{G}", "cmc": 1, "colors": "G",
            "types": ["Creature"], "subtypes": ["Elf"], "oracle": "",
            "power": 1, "toughness": 1,
        }
    if with_payoff:
        p["Elvish Chieftain"] = {
            "name": "Elvish Chieftain", "qty": 4, "mana_cost": "{1}{G}", "cmc": 2,
            "colors": "G", "types": ["Creature"], "subtypes": ["Elf"],
            "oracle": "Other Elves you control get +1/+1.",
            "power": 2, "toughness": 2,
        }
    for i, cmc in enumerate([1, 2, 2, 3, 3, 4]):
        name = f"Filler Beast {i}"
        p[name] = {
            "name": name, "qty": 4, "mana_cost": "{%d}" % cmc, "cmc": cmc, "colors": "G",
            "types": ["Creature"], "oracle": "", "power": cmc, "toughness": cmc,
        }
    return p


def test_14_elfos_mas_payoffs_en_g_detecta_tribal_elf_y_mete_elfos_de_sobra():
    pool = _elf_pool()
    deck = generate_deck(pool, "G")
    assert deck is not None
    assert deck["theme"] == "tribal:Elf"
    assert _copias_del_subtipo(pool, deck, "Elf") >= 10


def test_control_14_elfos_sin_payoffs_no_hacen_tema_tribal():
    deck = generate_deck(_elf_pool(with_payoff=False), "G")
    assert deck is None or deck["theme"] != "tribal:Elf"


def _payoff_card(oracle: str) -> dict:
    return {
        "name": "Payoff", "qty": 1, "mana_cost": "{1}{G}", "cmc": 2,
        "colors": "G", "types": ["Creature"], "oracle": oracle,
    }


def test_tribal_role_reconoce_plurales_irregulares_no_solo_el_s_regular():
    # El literal del brief: "Elves" no contiene "elf" ni "elfs" como
    # substring (no hay 'f' en "elves"), solo el irregular "-ves" lo pilla.
    assert tribal_role(_payoff_card("Other Elves you control get +1/+1."), "Elf") == "payoff"
    assert tribal_role(_payoff_card("Other Dwarves you control get +1/+1."), "Dwarf") == "payoff"
    assert tribal_role(_payoff_card("Other Wolves you control get +1/+1."), "Wolf") == "payoff"
    # Regular +s sigue funcionando (no es un caso irregular).
    assert tribal_role(_payoff_card("Other Goblins you control get +1/+1."), "Goblin") == "payoff"
