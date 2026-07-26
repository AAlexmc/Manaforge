"""Tests espejo de `forge_engine/test/generator_test.dart` (grupo Task 7):
pesos de combate en `efficiency`."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.classify import efficiency, has_keyword


def _creature(name, oracle, power=2, toughness=2, cmc=2, keywords=None):
    return {
        "name": name, "qty": 1, "mana_cost": f"{{{cmc}}}", "cmc": cmc,
        "colors": "", "types": ["Creature"], "oracle": oracle,
        "power": power, "toughness": toughness,
        "keywords": keywords if keywords is not None else [],
    }


def test_volador_vale_mas_que_arrollador_pequeno_a_igualdad_de_stats():
    flier = _creature("Flier", "Flying")
    trampler = _creature("Trampler", "Trample")
    assert efficiency(flier) > efficiency(trampler)


def test_arrollar_escala_con_el_poder():
    big_trampler = _creature("Big Trampler", "Trample", power=6, toughness=6, cmc=6)
    big_reacher = _creature("Big Reacher", "Reach", power=6, toughness=6, cmc=6)
    assert efficiency(big_trampler) > efficiency(big_reacher)


def test_prisa_vale_mas_en_aggro():
    hasty = _creature("Hasty", "Haste")
    assert efficiency(hasty, "aggro") > efficiency(hasty)


def test_tope_2_0_keyword_soup_no_rompe_la_escala():
    kitchen_sink = _creature(
        "Kitchen Sink",
        "Flying, double strike, menace, haste, deathtouch, lifelink, "
        "first strike, vigilance, reach, trample",
        power=6, toughness=6, cmc=6,
    )
    assert efficiency(kitchen_sink) <= 10


def test_sin_columna_keywords_cae_al_oracle_double_strike_no_cuenta_first_strike():
    ds = _creature("Double Strike Guy", "Double strike", cmc=3)
    plain = _creature("Plain Guy", "Vanilla creature with no abilities.", cmc=3)
    # Solo pesa double strike (0.9): si first strike también contara por el
    # fallback de substring, la diferencia sería 0.9+0.5.
    assert abs((efficiency(ds) - efficiency(plain)) - 0.9) < 1e-9


def test_has_keyword_usa_columna_estructurada_si_existe():
    card = _creature("With KW", "some flavor text", keywords=["flying"])
    assert has_keyword(card, "flying") is True
    assert has_keyword(card, "trample") is False


def test_has_keyword_cae_al_oracle_si_falta_o_vacia():
    card = _creature("No KW col", "First strike", keywords=[])
    assert has_keyword(card, "first strike") is True
    assert has_keyword(card, "flying") is False
