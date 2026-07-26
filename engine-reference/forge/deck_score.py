"""Evaluación de un mazo completo (referencia canónica del motor Forge).

Espejo 1:1 de `forge_engine/lib/src/deck_score.dart`. El score de un mazo
deja de ser solo la media de eficiencia: también cuenta si sus tierras
llegan a tiempo (consistencia) y si tiene jugada pronto (curva), con las
probabilidades hipergeométricas de la fase 1.
"""
from __future__ import annotations
import re
from dataclasses import dataclass

from .classify import efficiency
from .hypergeometric import hypergeom_at_least, p_color_by_turn, p_keepable_hand


@dataclass
class DeckEvaluation:
    efficiency: float  # 0-10, media ponderada como hoy
    consistency: float  # 0-10: 6·p_keepable_hand + 4·castabilidad media
    curve: float  # 0-10: media t=1..4 de P(jugada de coste<=t al turno t)

    @property
    def total(self) -> float:
        return 0.5 * self.efficiency + 0.25 * self.consistency + 0.25 * self.curve


SYMBOL_RE = re.compile(r"\{([^}]+)\}")


def _color_groups(cost: str) -> dict[str, int]:
    """Grupos de color por símbolo: {B/G}{B/G} -> {'BG': 2}, {W}{W}{U} ->
    {'W': 2, 'U': 1}. Los símbolos pagables sin color ({2/W}, {W/P},
    genéricos, X, {C}) no exigen fuente y quedan fuera."""
    groups: dict[str, int] = {}
    for m in SYMBOL_RE.finditer(cost or ""):
        sym = m.group(1).upper()
        if "2" in sym or "P" in sym:  # pago alternativo
            continue
        colors = [ch for ch in "WUBRG" if ch in sym]
        if not colors:
            continue
        key = "".join(colors)
        groups[key] = groups.get(key, 0) + 1
    return groups


def _castability(card: dict, sources_by_color: dict[str, int], deck_size: int,
                 n_lands: int) -> float:
    """Mínimo entre sus grupos de color de P(fuentes suficientes al turno de
    su coste). Un híbrido {B/G} se paga con CUALQUIERA de los dos: sus
    fuentes son la unión, aproximada como la suma de fuentes de los colores
    del grupo capada al total de tierras (las duales cuentan en ambos colores
    y la cota evita el doble conteo). Sin símbolos -> 1.0."""
    groups = _color_groups(card["mana_cost"])
    if not groups:
        return 1.0
    turn = max(1, min(6, card["cmc"]))
    return min(
        p_color_by_turn(
            min(n_lands, sum(sources_by_color.get(c, 0) for c in group)),
            deck_size, turn, k)
        for group, k in groups.items()
    )


def evaluate_deck(deck: dict, pool: dict, sources_by_color: dict[str, int],
                   deck_size: int = 60) -> DeckEvaluation:
    """Eficiencia media, consistencia (manos keepable + castabilidad con las
    fuentes reales de sources_by_color) y curva jugable (P de tener jugada de
    coste <=t al turno t, t=1..4)."""
    cards = deck["cards"]
    n_lands = sum(deck["lands"].values())
    spell_count = 0
    eff_sum = 0.0
    cast_sum = 0.0
    hist: dict[int, int] = {}
    for name, qty in cards.items():
        card = pool.get(name)
        if card is None:
            continue
        spell_count += qty
        eff_sum += efficiency(card) * qty
        cast_sum += _castability(card, sources_by_color, deck_size, n_lands) * qty
        cmc = max(0, min(6, card["cmc"]))
        hist[cmc] = hist.get(cmc, 0) + qty
    spell_count = spell_count or 1

    keepable = p_keepable_hand(n_lands, deck_size)
    castability = cast_sum / spell_count
    consistency = 10 * (0.6 * keepable + 0.4 * castability)

    curve_sum = 0.0
    for t in range(1, 5):
        # coste 0 (Ornithopter, Memnite…) también es jugada de turno t
        s_t = sum(hist.get(cmc, 0) for cmc in range(0, t + 1))
        curve_sum += hypergeom_at_least(deck_size, s_t, 6 + t, 1)
    curve = 10 * (curve_sum / 4)

    return DeckEvaluation(
        efficiency=eff_sum / spell_count,
        consistency=consistency,
        curve=curve,
    )
