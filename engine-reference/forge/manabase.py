"""Manabase con no-básicas (referencia canónica del motor Forge).

Espejo 1:1 de `forge_engine/lib/src/manabase.dart`. Sustituye el reparto
proporcional de solo-básicas: un greedy determinista llena n_lands cubriendo
primero los déficits de fuentes de color contra la tabla Karsten
(`KARSTEN_SOURCES`), usando duales/fetches del pool antes que básicas de
relleno.
"""
from __future__ import annotations
import math
from dataclasses import dataclass

from .curve import color_symbols
from .lands import land_profile, source_of

# Tabla Karsten (mazo 60, ~90%): fuentes de UN color requeridas por (nº
# símbolos, turno del coste). Clave: symbols*10 + turn.
KARSTEN_SOURCES = {
    11: 14, 12: 13, 13: 12, 14: 11, 15: 10, 16: 9,
    22: 20, 23: 18, 24: 16, 25: 15, 26: 14,
    33: 23, 34: 22, 35: 21, 36: 20,
}

# Tope de tierras que entran giradas ("always"), por arquetipo.
TAPPED_BUDGET = {"aggro": 2, "tempo": 3, "midrange": 4, "control": 6}

WUBRG = ["W", "U", "B", "R", "G"]


@dataclass
class ManabaseResult:
    lands: dict[str, int]
    sources_by_color: dict[str, int]
    required_by_color: dict[str, int]


def _required_by_color(spells: dict[str, int], pool: dict, colors: str, deck_size: int) -> dict[str, int]:
    """earliest = primer turno con un símbolo de ese color, max_sym = más
    símbolos del mismo color en un solo coste (un {C}{C} no se juega antes
    del t2, de ahí turn = max(earliest, max_sym))."""
    max_sym_by_color: dict[str, int] = {}
    earliest_by_color: dict[str, int] = {}
    for name in spells:
        card = pool.get(name)
        if card is None:
            continue
        cmc = max(1, min(6, card["cmc"]))
        for c, k in color_symbols(card["mana_cost"]).items():
            if c not in colors:
                continue
            if k > max_sym_by_color.get(c, 0):
                max_sym_by_color[c] = k
            if c not in earliest_by_color or cmc < earliest_by_color[c]:
                earliest_by_color[c] = cmc

    required: dict[str, int] = {}
    for c, raw_max_sym in max_sym_by_color.items():
        max_sym = min(raw_max_sym, 3)
        earliest = earliest_by_color.get(c, 1)
        turn = min(max(earliest, max_sym), 6)
        base = KARSTEN_SOURCES[max_sym * 10 + turn]
        # karsten_sources está tabulada para mazos de 60; para otros tamaños
        # (Commander, 100) se escala proporcionalmente (aprox. suficiente).
        required[c] = math.ceil(base * deck_size / 60)
    return required


@dataclass
class _Candidate:
    name: str
    profile: object
    is_basic: bool
    owned: int


def _candidates(pool: dict, colors: str) -> list[_Candidate]:
    """No-básicas que producen solo colores del mazo (o fetches buscables
    dentro de él) + básicas de los colores del mazo. Utility fuera. Orden de
    calidad: nº de colores que produce desc, tapped never<conditional<always,
    nombre asc."""
    deck_colors = set(colors)
    out: list[_Candidate] = []
    for name, card in pool.items():
        if "Land" not in card.get("types", []):
            continue
        profile = land_profile(card)
        if profile.is_basic:
            if profile.produces & deck_colors:
                out.append(_Candidate(name, profile, True, card["qty"]))
            continue
        if profile.is_utility:
            continue
        if profile.is_fetch:
            ok = not profile.fetches or (profile.fetches & deck_colors)
            if ok:
                out.append(_Candidate(name, profile, False, card["qty"]))
            continue
        if profile.produces and profile.produces <= deck_colors:
            out.append(_Candidate(name, profile, False, card["qty"]))

    tapped_rank = {"never": 0, "conditional": 1, "always": 2}
    out.sort(key=lambda c: (-len(c.profile.produces), tapped_rank[c.profile.tapped], c.name))
    return out


def build_mana_base(
    spells: dict[str, int],
    pool: dict,
    colors: str,
    n_lands: int,
    *,
    archetype_name: str,
    copy_cap: int = 4,
    deck_size: int = 60,
) -> ManabaseResult | None:
    """Construye la manabase de n_lands para una identidad colors a partir de
    pool, cubriendo primero los déficits de fuentes Karsten de los spells.
    None si algún color usado se queda sin NINGUNA fuente."""
    required_by_color = _required_by_color(spells, pool, colors, deck_size)
    candidates = _candidates(pool, colors)
    sources_by_color = {c: 0 for c in required_by_color}
    taken: dict[str, int] = {}
    tapped_used = 0
    budget = TAPPED_BUDGET.get(archetype_name, 0)
    lands: dict[str, int] = {}

    def gain_of(cand: _Candidate) -> int:
        g = 0
        for c, required in required_by_color.items():
            if sources_by_color[c] < required and source_of(cand.profile, c, colors):
                g += 1
        return g

    for _ in range(n_lands):
        available = []
        for c in candidates:
            cap = c.owned if c.is_basic else min(copy_cap, c.owned)
            if taken.get(c.name, 0) >= cap:
                continue
            if c.profile.tapped == "always" and tapped_used >= budget:
                continue
            available.append(c)
        if not available:
            break

        gains = {c.name: gain_of(c) for c in available}
        best_gain = max(gains.values())

        if best_gain > 0:
            tied = [c for c in available if gains[c.name] == best_gain]
            basics = [c for c in tied if c.is_basic]
            # empate → orden de calidad (ya viene ordenado); no-básica vs
            # básica empatadas en gain → gana la básica (más barata de girar
            # y de poseer).
            pick = (basics or tied)[0]
        else:
            # sin déficits: básica del color con menor sources/required;
            # empate WUBRG.
            ranked = sorted(
                required_by_color.keys(),
                key=lambda c: (sources_by_color[c] / required_by_color[c], WUBRG.index(c)),
            )
            pick = None
            for c in ranked:
                basic_here = [cand for cand in available if cand.is_basic and c in cand.profile.produces]
                if basic_here:
                    pick = basic_here[0]
                    break
            if pick is None:
                pick = available[0]

        lands[pick.name] = lands.get(pick.name, 0) + 1
        taken[pick.name] = taken.get(pick.name, 0) + 1
        if pick.profile.tapped == "always":
            tapped_used += 1
        for c in required_by_color:
            if source_of(pick.profile, c, colors):
                sources_by_color[c] += 1

    for c in required_by_color:
        if sources_by_color.get(c, 0) == 0:
            return None

    return ManabaseResult(
        lands=lands,
        sources_by_color=sources_by_color,
        required_by_color=required_by_color,
    )
