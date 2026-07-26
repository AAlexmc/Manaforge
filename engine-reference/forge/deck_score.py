"""Evaluación de un mazo completo (referencia canónica del motor Forge).

Espejo 1:1 de `forge_engine/lib/src/deck_score.dart`. El score de un mazo
deja de ser solo la media de eficiencia: también cuenta si sus tierras
llegan a tiempo (consistencia) y si tiene jugada pronto (curva), con las
probabilidades hipergeométricas de la fase 1.
"""
from __future__ import annotations
from dataclasses import dataclass

from .classify import efficiency
from .curve import color_symbols
from .hypergeometric import hypergeom_at_least, p_color_by_turn, p_keepable_hand


@dataclass
class DeckEvaluation:
    efficiency: float  # 0-10, media ponderada como hoy
    consistency: float  # 0-10: 6·p_keepable_hand + 4·castabilidad media
    curve: float  # 0-10: media t=1..4 de P(jugada de coste<=t al turno t)

    @property
    def total(self) -> float:
        return 0.5 * self.efficiency + 0.25 * self.consistency + 0.25 * self.curve


def _castability(card: dict, sources_by_color: dict[str, int], deck_size: int) -> float:
    """Mínimo entre sus colores de P(fuentes suficientes al turno de su
    coste). Sin símbolos de color -> 1.0 (una carta incolora siempre es
    "castable")."""
    symbols = color_symbols(card["mana_cost"])
    if not symbols:
        return 1.0
    turn = max(1, min(6, card["cmc"]))
    return min(
        p_color_by_turn(sources_by_color.get(c, 0), deck_size, turn, k)
        for c, k in symbols.items()
    )


def evaluate_deck(deck: dict, pool: dict, sources_by_color: dict[str, int],
                   deck_size: int = 60) -> DeckEvaluation:
    """Eficiencia media, consistencia (manos keepable + castabilidad con las
    fuentes reales de sources_by_color) y curva jugable (P de tener jugada de
    coste <=t al turno t, t=1..4)."""
    cards = deck["cards"]
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
        cast_sum += _castability(card, sources_by_color, deck_size) * qty
        cmc = max(0, min(6, card["cmc"]))
        hist[cmc] = hist.get(cmc, 0) + qty
    spell_count = spell_count or 1

    n_lands = sum(deck["lands"].values())
    keepable = p_keepable_hand(n_lands, deck_size)
    castability = cast_sum / spell_count
    consistency = 10 * (0.6 * keepable + 0.4 * castability)

    curve_sum = 0.0
    for t in range(1, 5):
        s_t = sum(hist.get(cmc, 0) for cmc in range(1, t + 1))
        curve_sum += hypergeom_at_least(deck_size, s_t, 6 + t, 1)
    curve = 10 * (curve_sum / 4)

    return DeckEvaluation(
        efficiency=eff_sum / spell_count,
        consistency=consistency,
        curve=curve,
    )
