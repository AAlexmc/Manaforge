"""Generador de mazos — fase 3 del motor Forge.

Estrategia: para cada combinación de colores viable, detectar el mejor tema,
puntuar cada carta (eficiencia + sinergia + encaje en curva), construir con
greedy bajo cuotas y validar. Devuelve varias propuestas ordenadas.

Referencia canónica: el puerto Dart debe replicar este comportamiento.
"""
from __future__ import annotations
from collections import Counter
from itertools import combinations

from .classify import classify, theme_roles, efficiency, QUOTAS
from .curve import (LAND_RANGES, AVG_CMC_RANGES, DECK_SIZE, average_cmc,
                    color_symbols, recommended_lands)
from .validator import validate_deck, BASIC_LANDS

BASIC_FOR_COLOR = {"W": "Plains", "U": "Island", "B": "Swamp", "R": "Mountain", "G": "Forest"}

# Perfil de curva objetivo (proporción deseada de hechizos por CMC 1..6+)
CURVE_TARGET = {
    "aggro":    {1: .30, 2: .35, 3: .20, 4: .10, 5: .04, 6: .01},
    "tempo":    {1: .20, 2: .35, 3: .25, 4: .12, 5: .06, 6: .02},
    "midrange": {1: .12, 2: .28, 3: .26, 4: .18, 5: .12, 6: .04},
    "control":  {1: .08, 2: .20, 3: .25, 4: .22, 5: .17, 6: .08},
}


def _candidate_pool(pool: dict, colors: str) -> dict:
    """Cartas jugables en esta identidad de color (no tierras)."""
    allowed = set(colors)
    return {
        n: c for n, c in pool.items()
        if "Land" not in c["types"] and set(c["colors"]) <= allowed
    }


MIN_PAYOFF_COPIES = 3  # sin masa crítica de payoffs no hay tema


def detect_theme(cands: dict) -> tuple[str, dict[str, str]]:
    """Tema dominante y rol de cada carta.

    Un tema solo es elegible con >= MIN_PAYOFF_COPIES copias de payoffs en
    estos colores: los enablers solos no hacen tema (p. ej. artefactos
    incoloros presentes en toda identidad no convierten cualquier mazo en
    'artifacts'). Entre los elegibles gana el de más peso (payoffs x3).
    """
    weights: Counter = Counter()
    payoff_copies: Counter = Counter()
    roles_by_card: dict[str, dict[str, str]] = {}
    for name, card in cands.items():
        roles = theme_roles(card)
        roles_by_card[name] = roles
        for theme, role in roles.items():
            if role == "payoff":
                payoff_copies[theme] += card["qty"]
                weights[theme] += card["qty"] * 3
            else:
                weights[theme] += card["qty"]
    eligible = {t: w for t, w in weights.items()
                if payoff_copies[t] >= MIN_PAYOFF_COPIES}
    if not eligible:
        return "goodstuff", roles_by_card
    return max(eligible, key=eligible.get), roles_by_card


def pick_archetype(cands: dict) -> str:
    """Arquetipo según el perfil del pool disponible."""
    cheap = sum(c["qty"] for c in cands.values() if c["cmc"] <= 2)
    total = sum(c["qty"] for c in cands.values()) or 1
    interaction = sum(c["qty"] for c in cands.values()
                      if {"removal", "counterspell", "burn"} & classify(c))
    if cheap / total > 0.55:
        return "aggro" if interaction / total < 0.25 else "tempo"
    return "midrange"


def score(card: dict, theme: str, roles: dict[str, str], curve_need: dict[int, float]) -> float:
    """eficiencia + sinergia con el tema + encaje en la curva que falta."""
    s = efficiency(card)
    role = roles.get(theme)
    if role == "payoff":
        s += 3.0
    elif role == "enabler":
        s += 1.5
    s += curve_need.get(min(card["cmc"], 6), 0.0) * 4.0
    return s


def generate_deck(pool: dict, colors: str, name: str | None = None) -> dict | None:
    """Construye el mejor mazo de 60 para una identidad de color. None si no da."""
    cands = _candidate_pool(pool, colors)
    if sum(c["qty"] for c in cands.values()) < 30:
        return None
    theme, roles_by_card = detect_theme(cands)
    archetype = pick_archetype(cands)
    target = CURVE_TARGET[archetype]

    # nº de tierras estimado en dos pasadas (depende del coste medio final)
    n_lands = (LAND_RANGES[archetype][0] + LAND_RANGES[archetype][1]) // 2
    chosen: dict[str, int] = {}
    for _ in range(2):  # segunda pasada refina tierras con la curva real
        n_spells = DECK_SIZE - n_lands
        chosen = _greedy_fill(cands, roles_by_card, theme, archetype, target, n_spells)
        n_lands = recommended_lands(chosen, pool, archetype)

    n_spells = DECK_SIZE - n_lands
    chosen = _greedy_fill(cands, roles_by_card, theme, archetype, target, n_spells)
    lands = _mana_base(chosen, pool, colors, n_lands)
    if lands is None:
        return None

    deck = {
        "name": name or f"Forge {colors} {theme}",
        "colors": colors, "archetype": archetype, "theme": theme,
        "cards": chosen, "lands": lands,
    }
    return deck if not validate_deck(deck, pool) else None


def _greedy_fill(cands, roles_by_card, theme, archetype, target, n_spells) -> dict[str, int]:
    """Greedy con cuotas: primero cubre criaturas/interacción/robo, luego rellena."""
    quotas = dict(QUOTAS[archetype])
    chosen: Counter = Counter()
    counts = {"creatures": 0, "interaction": 0, "draw": 0}

    def curve_need() -> dict[int, float]:
        total = sum(chosen.values()) or 1
        hist: Counter = Counter()
        for n, q in chosen.items():
            hist[min(cands[n]["cmc"], 6)] += q
        return {cmc: target.get(cmc, 0) - hist[cmc] / total for cmc in range(0, 7)}

    def bucket(card) -> list[str]:
        tags = classify(card)
        out = []
        if "creature" in tags:
            out.append("creatures")
        if {"removal", "counterspell", "burn", "sweeper"} & tags:
            out.append("interaction")
        if "draw" in tags:
            out.append("draw")
        return out

    while sum(chosen.values()) < n_spells:
        need = curve_need()
        pending = {b for b, minimum in quotas.items() if counts[b] < minimum}
        best_name, best_score = None, -1e9
        for n, card in cands.items():
            if chosen[n] >= min(card["qty"], 4):
                continue
            s = score(card, theme, roles_by_card[n], need)
            buckets = bucket(card)
            if pending and not (pending & set(buckets)):
                s -= 3.0  # aún caben, pero prioriza cubrir cuotas
            if best_score < s:
                best_name, best_score = n, s
        if best_name is None:
            break
        chosen[best_name] += 1
        for b in bucket(cands[best_name]):
            counts[b] += 1
    return dict(chosen)


def _mana_base(cards: dict, pool: dict, colors: str, n_lands: int) -> dict | None:
    """Básicas proporcionales a los símbolos, mínimo 8 fuentes por color usado."""
    syms: Counter = Counter()
    for n, q in cards.items():
        for c, k in color_symbols(pool[n]["mana_cost"]).items():
            syms[c] += k * q
    used = [c for c in colors if syms[c] > 0]
    if not used:
        return None
    total = sum(syms[c] for c in used)
    lands: dict[str, int] = {}
    remaining = n_lands
    for i, c in enumerate(used):
        basic = BASIC_FOR_COLOR[c]
        if pool.get(basic, {"qty": 0})["qty"] <= 0:
            return None  # sin básicas de ese color en la colección
        if i == len(used) - 1:
            n = remaining
        else:
            n = max(8, round(n_lands * syms[c] / total)) if len(used) > 1 else n_lands
            n = min(n, remaining - 8 * (len(used) - 1 - i))
        n = min(n, pool[basic]["qty"])  # nunca más básicas de las poseídas
        lands[basic] = n
        remaining -= n
    if remaining > 0:
        return None  # la colección no tiene tierras suficientes: avisar, no forzar
    return lands


def generate_proposals(pool: dict, max_proposals: int = 5) -> list[dict]:
    """Las mejores propuestas entre monocolor y pares de colores."""
    proposals = []
    identities = list("WUBRG") + ["".join(p) for p in combinations("WUBRG", 2)]
    for colors in identities:
        deck = generate_deck(pool, colors)
        if deck:
            spells = deck["cards"]
            deck["score"] = sum(
                efficiency(pool[n]) * q for n, q in spells.items()
            ) / sum(spells.values())
            proposals.append(deck)
    proposals.sort(key=lambda d: -d["score"])
    return proposals[:max_proposals]
