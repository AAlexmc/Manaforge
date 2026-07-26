"""Generador de mazos — fase 3 del motor Forge.

Estrategia: para cada combinación de colores viable, detectar el mejor tema,
puntuar cada carta (eficiencia + sinergia + encaje en curva), construir con
greedy bajo cuotas y validar. Devuelve varias propuestas ordenadas.

Referencia canónica: el puerto Dart debe replicar este comportamiento.
"""
from __future__ import annotations
from collections import Counter
from itertools import combinations

from .classify import classify, theme_roles, tribal_role, efficiency, QUOTAS
from .curve import LAND_RANGES, AVG_CMC_RANGES, DECK_SIZE, average_cmc, recommended_lands
from .deck_score import evaluate_deck
from .manabase import build_mana_base
from .validator import validate_deck, BASIC_LANDS

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
MIN_TRIBE_MEMBERS = 12  # tribu elegible: además del mínimo de payoffs de siempre

# Colores naturales de cada tema (color pie). "" = cualquier color.
THEME_COLORS = {
    "lifegain": "WB",
    "sacrifice": "BR",
    "spells": "UR",
    "artifacts": "WU",
    "counters": "GW",
    "tokens": "WG",
    "graveyard": "BG",
    "reanimator": "BGU",
}

# Máximo de gordas (criaturas caras del tema reanimator) que reciben trato de
# enabler puro en _greedy_fill. Sin tope, un pool cargado de gordas vaciaría
# la curva media del arquetipo entero hacia costes altos.
MAX_REANIMATOR_FATTIES = 6

# Umbral de coste y eficiencia para que una criatura cuente como "gorda"
# reanimable: cara y con stats muy por encima de la media.
REANIMATOR_FATTY_MIN_CMC = 5
REANIMATOR_FATTY_MIN_EFFICIENCY = 6.0


def _theme_color_multiplier(colors: str) -> dict[str, float]:
    """1.25 si colors solapa con el color natural del tema, 0.8 si le es
    ajeno, 1.0 si el tema es de cualquier color o no se conocen los colores."""
    out: dict[str, float] = {}
    for theme, natural in THEME_COLORS.items():
        if not natural or not colors:
            out[theme] = 1.0
        else:
            out[theme] = 1.25 if set(natural) & set(colors) else 0.8
    return out


def _tribe_member_copies(cands: dict) -> dict[str, int]:
    """Copias de criaturas por subtipo entre las candidatas: la masa tribal
    cruda, antes de mirar quién la aprovecha."""
    out: Counter = Counter()
    for card in cands.values():
        if "Creature" not in card["types"]:
            continue
        for subtype in card.get("subtypes", []):
            out[subtype] += card["qty"]
    return dict(out)


def detect_theme(cands: dict, colors: str = "") -> tuple[str, dict[str, str]]:
    """Tema dominante y rol de cada carta.

    Un tema solo es elegible con >= MIN_PAYOFF_COPIES copias de payoffs en
    estos colores: los enablers solos no hacen tema (p. ej. artefactos
    incoloros presentes en toda identidad no convierten cualquier mazo en
    'artifacts'). Entre los elegibles gana el de más peso (payoffs x3),
    desempatado por el color pie de [colors]. Las tribus ("tribal:<Subtipo>")
    compiten con los temas mecánicos: no llevan multiplicador de color (son
    de cualquier color) y además del mínimo de payoffs piden
    >= MIN_TRIBE_MEMBERS criaturas del subtipo.
    """
    mult = _theme_color_multiplier(colors)
    weights: dict[str, float] = {}
    payoff_copies: Counter = Counter()
    roles_by_card: dict[str, dict[str, str]] = {}
    for name, card in cands.items():
        roles = theme_roles(card)
        roles_by_card[name] = roles
        for theme, role in roles.items():
            m = mult.get(theme, 1.0)
            if role == "payoff":
                payoff_copies[theme] += card["qty"]
                weights[theme] = weights.get(theme, 0.0) + card["qty"] * 3 * m
            else:
                weights[theme] = weights.get(theme, 0.0) + card["qty"] * m

    for tribe, members in _tribe_member_copies(cands).items():
        if members < MIN_TRIBE_MEMBERS:
            continue
        theme = f"tribal:{tribe}"
        payoffs = 0
        for name, card in cands.items():
            role = tribal_role(card, tribe)
            if role is None:
                continue
            roles_by_card[name][theme] = role
            if role == "payoff":
                payoffs += card["qty"]
        if payoffs >= MIN_PAYOFF_COPIES:
            payoff_copies[theme] = payoffs
            weights[theme] = payoffs * 3.0 + members * 1.0

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


def score(card: dict, theme: str, roles: dict[str, str], curve_need: dict[int, float],
          archetype: str, force_enabler_no_curve_penalty: bool = False) -> float:
    """eficiencia + sinergia con el tema + encaje en la curva que falta."""
    s = efficiency(card, archetype)
    role = "enabler" if force_enabler_no_curve_penalty else roles.get(theme)
    if role == "payoff":
        s += 3.0
    elif role == "enabler":
        s += 1.5
    curve_term = curve_need.get(min(card["cmc"], 6), 0.0)
    if force_enabler_no_curve_penalty:
        curve_term = max(curve_term, 0.0)
    s += curve_term * 4.0
    return s


def _is_reanimator_fatty(card: dict, theme: str, archetype: str, fatties_chosen: int) -> bool:
    """Las gordas del tema reanimator no valen por su coste (no se lanzan, se
    reaniman): tratarlas de enabler puro y sin castigo de curva, hasta el
    tope MAX_REANIMATOR_FATTIES."""
    return (
        theme == "reanimator"
        and "Creature" in card["types"]
        and card["cmc"] >= REANIMATOR_FATTY_MIN_CMC
        and efficiency(card, archetype) >= REANIMATOR_FATTY_MIN_EFFICIENCY
        and fatties_chosen < MAX_REANIMATOR_FATTIES
    )


def _roles_for_override(cands: dict, theme: str) -> dict[str, dict[str, str]]:
    """Roles de cada carta SOLO para [theme], sin la selección multi-tema de
    detect_theme ni sus umbrales de elegibilidad (mejor-esfuerzo): las
    cartas sin rol puntúan sin bonus, el greedy sigue llenando cuotas y
    curva igual. Se usa cuando el tema lo elige el jugador (theme_override),
    no el motor — detect_theme no se llama en ese caso."""
    tribe = theme[len("tribal:"):] if theme.startswith("tribal:") else None
    roles_by_card: dict[str, dict[str, str]] = {}
    for name, card in cands.items():
        role = tribal_role(card, tribe) if tribe is not None else theme_roles(card).get(theme)
        roles_by_card[name] = {theme: role} if role is not None else {}
    return roles_by_card


def generate_deck(pool: dict, colors: str, name: str | None = None,
                   theme_override: str | None = None) -> dict | None:
    """Construye el mejor mazo de 60 para una identidad de color. None si no da.

    theme_override fuerza el tema ("lifegain", "tribal:Elf", ...) en vez de
    detectarlo: se salta detect_theme y su gate de MIN_PAYOFF_COPIES
    (mejor-esfuerzo — el greedy prioriza cartas con rol en ese tema si las
    hay, y si no las hay igual llena el mazo por eficiencia/curva). Si el
    mazo resultante no lleva NINGUNA copia con rol en el tema forzado, ese
    color no puede jugarlo: None.
    """
    cands = _candidate_pool(pool, colors)
    if sum(c["qty"] for c in cands.values()) < 30:
        return None
    if theme_override is not None:
        theme = theme_override
        roles_by_card = _roles_for_override(cands, theme)
    else:
        theme, roles_by_card = detect_theme(cands, colors)
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

    if theme_override is not None and not any(
            theme in roles_by_card.get(n, {}) for n in chosen):
        return None  # ese color no tiene con qué jugar el estilo pedido

    manabase = _mana_base(chosen, pool, colors, n_lands, archetype)
    if manabase is None:
        return None

    deck = {
        "name": name or f"Forge {colors} {theme}",
        "colors": colors, "archetype": archetype, "theme": theme,
        "cards": chosen, "lands": manabase.lands,
        # fuentes efectivas por color: las reusa generate_proposals para
        # puntuar el mazo con evaluate_deck sin repetir el greedy de manabase.
        "sources_by_color": manabase.sources_by_color,
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

    fatties_chosen = 0
    while sum(chosen.values()) < n_spells:
        need = curve_need()
        pending = {b for b, minimum in quotas.items() if counts[b] < minimum}
        best_name, best_score, best_is_fatty = None, -1e9, False
        for n, card in cands.items():
            if chosen[n] >= min(card["qty"], 4):
                continue
            is_fatty = _is_reanimator_fatty(card, theme, archetype, fatties_chosen)
            s = score(card, theme, roles_by_card[n], need, archetype,
                      force_enabler_no_curve_penalty=is_fatty)
            buckets = bucket(card)
            if pending and not (pending & set(buckets)):
                s -= 3.0  # aún caben, pero prioriza cubrir cuotas
            if best_score < s:
                best_name, best_score, best_is_fatty = n, s, is_fatty
        if best_name is None:
            break
        if best_is_fatty:
            fatties_chosen += 1
        chosen[best_name] += 1
        for b in bucket(cands[best_name]):
            counts[b] += 1
    return dict(chosen)


def _mana_base(cards: dict, pool: dict, colors: str, n_lands: int, archetype: str):
    """Manabase con no-básicas por objetivos Karsten (duales/fetches/taplands
    del pool antes que básicas de relleno). None si la colección no da (avisar,
    no forzar). Ver `manabase.py` para el algoritmo completo."""
    return build_mana_base(cards, pool, colors, n_lands, archetype_name=archetype)


def generate_proposals(pool: dict, max_proposals: int = 5,
                        theme_override: str | None = None) -> list[dict]:
    """Las mejores propuestas entre monocolor y pares de colores.
    theme_override fuerza el tema de todas las propuestas (ver
    generate_deck) — cada identidad que no pueda jugarlo simplemente no
    entra en la lista, igual que hoy con cualquier otro "no da mazo sano"."""
    proposals = []
    identities = list("WUBRG") + ["".join(p) for p in combinations("WUBRG", 2)]
    for colors in identities:
        deck = generate_deck(pool, colors, theme_override=theme_override)
        if deck:
            deck["score"] = evaluate_deck(
                deck, pool, deck["sources_by_color"], deck_size=DECK_SIZE
            ).total
            proposals.append(deck)
    proposals.sort(key=lambda d: -d["score"])
    return proposals[:max_proposals]
