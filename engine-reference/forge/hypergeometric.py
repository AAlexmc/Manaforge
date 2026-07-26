"""Probabilidad hipergeométrica pura (referencia canónica del motor Forge).

Espejo 1:1 de `forge_engine/lib/src/hypergeometric.dart`. Bucle multiplicativo
propio (no `math.comb`) para paridad con Dart: `math.comb` queda solo como
oráculo independiente en los tests.
"""
from __future__ import annotations


def _binom(n: int, k: int) -> float:
    if k < 0 or k > n:
        return 0.0
    r = 1.0
    for i in range(k):
        r = r * (n - i) / (i + 1)
    return r


def hypergeom_pmf(pop_size: int, successes: int, draws: int, k: int) -> float:
    """P(exactamente k éxitos) al robar draws de una población pop_size con successes éxitos."""
    if k < 0 or k > draws or k > successes:
        return 0.0
    if draws - k > pop_size - successes:
        return 0.0
    return _binom(successes, k) * _binom(pop_size - successes, draws - k) / _binom(pop_size, draws)


def hypergeom_at_least(pop_size: int, successes: int, draws: int, k: int) -> float:
    """P(>= k éxitos) al robar draws."""
    p = sum(hypergeom_pmf(pop_size, successes, draws, i) for i in range(k, draws + 1))
    return min(p, 1.0)


def p_land_drops(n_lands: int, deck_size: int, turn: int) -> float:
    """P(caer tierra turnos 1..turn) = P(>=turn tierras entre las 7+turn-1 vistas en juego)."""
    return hypergeom_at_least(deck_size, n_lands, 7 + turn - 1, turn)


def p_keepable_hand(n_lands: int, deck_size: int) -> float:
    """P(mano de 2-5 tierras), con UN mulligan modelado: p + (1-p)*p."""
    p7 = hypergeom_at_least(deck_size, n_lands, 7, 2) - hypergeom_at_least(deck_size, n_lands, 7, 6)
    return p7 + (1 - p7) * p7


def p_color_by_turn(sources: int, deck_size: int, turn: int, symbols: int) -> float:
    """P(>=symbols fuentes de un color entre las 7+turn-1 vistas)."""
    return hypergeom_at_least(deck_size, sources, 7 + turn - 1, symbols)
