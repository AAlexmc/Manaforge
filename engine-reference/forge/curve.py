"""Matemática de la curva de maná (referencia canónica del motor Forge).

Basada en la teoría estándar de construcción de mazos (aprox. de Frank Karsten):
partir de 24 tierras para un coste medio de 3.0 en mazos de 60, ajustar ±1 tierra
por cada ±0.5 de coste medio, y restar ~1 tierra por cada 3-4 fuentes baratas de
maná/robo (mana rocks, elfos de maná, cantrips de coste <=2).
"""
from __future__ import annotations
import re
from collections import Counter

from .hypergeometric import hypergeom_at_least, p_land_drops

MANA_SYMBOL = re.compile(r"\{([^}]+)\}")

# Turno al que cada arquetipo necesita haber caído tierra sí o sí.
LAND_DROP_TURN = {"aggro": 3, "tempo": 4, "midrange": 4, "control": 5}

# Rangos de tierras por arquetipo para mazos de 60 (min, max)
LAND_RANGES = {
    "aggro": (20, 23),
    "tempo": (22, 24),
    "midrange": (23, 25),
    "control": (26, 27),
}

# Perfil de curva por arquetipo: (coste_medio_min, coste_medio_max)
AVG_CMC_RANGES = {
    "aggro": (0.0, 2.2),
    "tempo": (1.8, 2.6),
    "midrange": (2.2, 3.5),
    "control": (2.8, 3.8),
}

DECK_SIZE = 60


def mana_value(cost: str) -> int:
    """Valor de maná de un coste tipo '{2}{U}{U}'. X cuenta como 0."""
    total = 0
    for sym in MANA_SYMBOL.findall(cost or ""):
        if sym.isdigit():
            total += int(sym)
        elif sym.upper() in ("X", "Y", "Z"):
            continue
        elif "/" in sym and "2" in sym:  # símbolos {2/W}
            total += 2
        else:
            total += 1
    return total


def color_symbols(cost: str) -> Counter:
    """Cuenta símbolos de color en un coste (los híbridos cuentan para ambos)."""
    out: Counter = Counter()
    for sym in MANA_SYMBOL.findall(cost or ""):
        for ch in "WUBRG":
            if ch in sym.upper():
                out[ch] += 1
    return out


def average_cmc(cards: dict[str, int], pool: dict) -> float:
    """Coste medio de los hechizos (cards = {nombre: cantidad})."""
    n = sum(cards.values())
    if n == 0:
        return 0.0
    return sum(pool[name]["cmc"] * qty for name, qty in cards.items()) / n


def cheap_sources(cards: dict[str, int], pool: dict) -> int:
    """Fuentes baratas de aceleración/robo (cmc<=2 que producen maná o roban)."""
    count = 0
    for name, qty in cards.items():
        card = pool[name]
        text = card["oracle"].lower()
        if card["cmc"] <= 2 and ("add {" in text or "draw a card" in text):
            count += qty
    return count


def recommended_lands(cards: dict[str, int], pool: dict, archetype: str) -> int:
    """Nº de tierras: semilla Karsten para desempatar, pero el número final es
    el que maximiza P(caer tierra a tiempo) - 0.5*P(inundación) dentro del
    rango del arquetipo."""
    avg = average_cmc(cards, pool)
    raw = 24 + (avg - 3.0) * 2 - cheap_sources(cards, pool) / 3.5
    t = LAND_DROP_TURN[archetype]

    def util(n: int) -> float:
        # inundación: >=t+3 tierras al turno t+2
        return p_land_drops(n, DECK_SIZE, t) - 0.5 * hypergeom_at_least(DECK_SIZE, n, t + 8, t + 3)

    lo, hi = LAND_RANGES[archetype]
    best, best_u = lo, float("-inf")
    for n in range(lo, hi + 1):
        u = util(n) - abs(n - raw) * 0.001  # desempate estable hacia la semilla Karsten
        if u > best_u:
            best, best_u = n, u
    return best


def curve_histogram(cards: dict[str, int], pool: dict, cap: int = 7) -> dict[int, int]:
    hist: Counter = Counter()
    for name, qty in cards.items():
        hist[min(pool[name]["cmc"], cap)] += qty
    return dict(sorted(hist.items()))
