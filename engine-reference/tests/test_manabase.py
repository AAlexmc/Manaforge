"""Tests espejo de `forge_engine/test/manabase_test.dart`.

Mismos pools sintéticos que el lado Dart — mismos resultados (contrato de
paridad del orden de desempate del greedy).
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.manabase import build_mana_base
from forge.lands import land_profile


def _card(name, qty, mana_cost, cmc, colors, types, oracle):
    return {
        "name": name, "qty": qty, "mana_cost": mana_cost, "cmc": cmc,
        "colors": colors, "types": types, "oracle": oracle,
    }


def test_con_duales_cumple_karsten_donde_las_basicas_no_llegan():
    # 4x doble-símbolo {W}{W} t2 y 4x {U}{U} t2 => 20+20 fuentes: imposible
    # con 24 básicas. 2 duales distintos (4 copias cada uno = 8 usables) más
    # básicas nombradas para que el desempate por nombre favorezca W
    # ('A White Land' < 'Z Blue Land'), simétrico al caso solo-básicas.
    spells_ww_y_uu = {"WW Card": 4, "UU Card": 4}
    pool_con_duales_8 = {
        "WW Card": _card("WW Card", 4, "{W}{W}", 2, "W", ["Creature"], ""),
        "UU Card": _card("UU Card", 4, "{U}{U}", 2, "U", ["Creature"], ""),
        "WU Dual A": _card("WU Dual A", 4, "", 0, "", ["Land"], "{T}: Add {W} or {U}."),
        "WU Dual B": _card("WU Dual B", 4, "", 0, "", ["Land"], "{T}: Add {W} or {U}."),
        "A White Land": _card("A White Land", 30, "", 0, "", ["Basic", "Land"], "{T}: Add {W}."),
        "Z Blue Land": _card("Z Blue Land", 30, "", 0, "", ["Basic", "Land"], "{T}: Add {U}."),
    }
    pool_solo_basicas = {
        "WW Card": pool_con_duales_8["WW Card"],
        "UU Card": pool_con_duales_8["UU Card"],
        "A White Land": pool_con_duales_8["A White Land"],
        "Z Blue Land": pool_con_duales_8["Z Blue Land"],
    }

    r = build_mana_base(spells_ww_y_uu, pool_con_duales_8, "WU", 24, archetype_name="midrange")
    assert r is not None
    threshold = 0 if sum(r.lands.values()) < 24 else 16
    assert r.sources_by_color["W"] >= threshold
    # la manabase con duales domina a la de solo básicas en la peor fuente:
    solo_basicas = build_mana_base(spells_ww_y_uu, pool_solo_basicas, "WU", 24, archetype_name="midrange")
    assert solo_basicas is not None

    def worst(m):
        return min(m.sources_by_color[c] / m.required_by_color[c] for c in ("W", "U"))

    assert worst(r) > worst(solo_basicas)


def test_respeta_tope_de_taplands_por_arquetipo():
    spells = {"R Card": 4, "G Card": 4}
    pool_con_muchos_taplands = {
        "R Card": _card("R Card", 4, "{R}", 1, "R", ["Creature"], ""),
        "G Card": _card("G Card", 4, "{G}", 1, "G", ["Creature"], ""),
        "Tapland A": _card("Tapland A", 4, "", 0, "", ["Land"],
                            "This land enters the battlefield tapped.\n{T}: Add {R} or {G}."),
        "Tapland B": _card("Tapland B", 4, "", 0, "", ["Land"],
                            "This land enters the battlefield tapped.\n{T}: Add {R} or {G}."),
        "Tapland C": _card("Tapland C", 4, "", 0, "", ["Land"],
                            "This land enters the battlefield tapped.\n{T}: Add {R} or {G}."),
        "Mountain": _card("Mountain", 30, "", 0, "", ["Land"], "{T}: Add {R}."),
        "Forest": _card("Forest", 30, "", 0, "", ["Land"], "{T}: Add {G}."),
    }
    r = build_mana_base(spells, pool_con_muchos_taplands, "RG", 22, archetype_name="aggro")
    assert r is not None
    tap = sum(
        qty for name, qty in r.lands.items()
        if land_profile(pool_con_muchos_taplands[name]).tapped == "always"
    )
    assert tap <= 2


def test_fetch_cuenta_como_fuente_de_ambos_colores():
    spells = {"Card RW": 4}
    pool = {
        "Card RW": _card("Card RW", 4, "{R}{W}", 2, "RW", ["Creature"], ""),
        "Fetch RW": _card("Fetch RW", 4, "", 0, "", ["Land"],
                           "Search your library for a Plains or Mountain land "
                           "card, put it onto the battlefield, then shuffle."),
    }
    # sin básicas de ningún color: solo el fetch tipado cubre ambos a la vez.
    r = build_mana_base(spells, pool, "RW", 4, archetype_name="midrange")
    assert r is not None
    assert r.sources_by_color["R"] > 0
    assert r.sources_by_color["W"] > 0
    assert r.lands.get("Fetch RW", 0) > 0


def test_max_4_copias_no_basica_basicas_libres_nunca_mas_de_lo_poseido():
    spells = {"W Card": 4, "U Card": 4}
    pool = {
        "W Card": _card("W Card", 4, "{W}{W}", 2, "W", ["Creature"], ""),
        "U Card": _card("U Card", 4, "{U}{U}", 2, "U", ["Creature"], ""),
        "Dual WU": _card("Dual WU", 10, "", 0, "", ["Land"], "{T}: Add {W} or {U}."),
        "Plains": _card("Plains", 3, "", 0, "", ["Land"], "{T}: Add {W}."),
        "Island": _card("Island", 3, "", 0, "", ["Land"], "{T}: Add {U}."),
    }
    r = build_mana_base(spells, pool, "WU", 10, archetype_name="midrange")
    assert r is not None
    assert r.lands["Dual WU"] == 4  # tope de copy_cap pese a poseer 10
    assert r.lands["Plains"] == 3  # nunca más de lo poseído
    assert r.lands["Island"] == 3


def test_monocolor_sin_duales_comportamiento_de_hoy_todo_basicas():
    spells_mono_w = {"W Card": 20}
    pool_solo_basicas = {
        "W Card": _card("W Card", 20, "{W}", 1, "W", ["Creature"], ""),
        "Plains": _card("Plains", 30, "", 0, "", ["Land"], "{T}: Add {W}."),
    }
    r = build_mana_base(spells_mono_w, pool_solo_basicas, "W", 24, archetype_name="midrange")
    assert r is not None
    assert r.lands == {"Plains": 24}


def test_color_sin_ninguna_fuente_posible_da_none_igual_que_hoy():
    spells = {"B Card": 20}
    pool = {
        "B Card": _card("B Card", 20, "{B}", 1, "B", ["Creature"], ""),
        "Plains": _card("Plains", 20, "", 0, "", ["Land"], "{T}: Add {W}."),
    }
    # sin Swamp en la colección: B se queda en 0 fuentes => None.
    r = build_mana_base(spells, pool, "WB", 24, archetype_name="midrange")
    assert r is None
