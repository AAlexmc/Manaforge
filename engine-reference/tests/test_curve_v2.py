"""Tests espejo de `forge_engine/test/forge_engine_test.dart` (recommended_lands v2).

Reescrito (v2 tierras por probabilidad): antes el test fijaba un número mágico
("coste medio 3.0 -> 24 tierras" de la fórmula vieja). Ahora la fórmula elige,
DENTRO del rango del arquetipo, el n que maximiza P(caídas) - 0.5*P(inundación);
con este pool (coste medio 3.0, sin fuentes baratas) el máximo cae en 25 (el
tope de midrange), que sigue dentro del rango de la vieja fórmula (23-25).
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.curve import recommended_lands, LAND_RANGES
from forge.hypergeometric import hypergeom_at_least, p_land_drops


def test_las_tierras_elegidas_maximizan_utilidad_en_su_rango():
    cards = {}
    pool = {}
    for i in range(36):
        name = f"Tres {i}"
        cards[name] = 1
        pool[name] = {
            "name": name, "qty": 1, "mana_cost": "{2}{B}", "cmc": 3,
            "colors": "B", "types": ["Creature"], "oracle": "",
        }
    n = recommended_lands(cards, pool, "midrange")
    assert 23 <= n <= 25

    def util(k):
        return p_land_drops(k, 60, 4) - 0.5 * hypergeom_at_least(60, k, 4 + 8, 4 + 3)

    for k in range(23, 26):
        assert util(n) + 1e-12 >= util(k)


def test_aggro_barato_elige_menos_tierras_que_control_caro():
    cheap_cards = {}
    cheap_pool = {}
    for i in range(20):
        name = f"Barata {i}"
        cheap_cards[name] = 1
        cheap_pool[name] = {
            "name": name, "qty": 1, "mana_cost": "{R}", "cmc": 1,
            "colors": "R", "types": ["Creature"], "oracle": "",
        }
    expensive_cards = {}
    expensive_pool = {}
    for i in range(20):
        name = f"Cara {i}"
        expensive_cards[name] = 1
        expensive_pool[name] = {
            "name": name, "qty": 1, "mana_cost": "{4}{U}{U}", "cmc": 6,
            "colors": "U", "types": ["Creature"], "oracle": "",
        }
    aggro_n = recommended_lands(cheap_cards, cheap_pool, "aggro")
    control_n = recommended_lands(expensive_cards, expensive_pool, "control")
    assert aggro_n < control_n
    assert LAND_RANGES["aggro"][0] <= aggro_n <= LAND_RANGES["aggro"][1]
    assert LAND_RANGES["control"][0] <= control_n <= LAND_RANGES["control"][1]
