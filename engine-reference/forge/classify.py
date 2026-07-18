"""Clasificación funcional y detección de temas — fase 2 del motor.

Lee el texto Oracle y el type_line para etiquetar cada carta por su función
en un mazo. Las etiquetas alimentan las cuotas del generador (fase 3).
"""
from __future__ import annotations
import re

# Cuotas funcionales por arquetipo para los ~36-37 hechizos de un mazo de 60:
# (mínimo de criaturas, mínimo de interacción, mínimo de robo/ventaja)
QUOTAS = {
    "aggro": {"creatures": 20, "interaction": 4, "draw": 0},
    "tempo": {"creatures": 14, "interaction": 8, "draw": 2},
    "midrange": {"creatures": 16, "interaction": 6, "draw": 2},
    "control": {"creatures": 8, "interaction": 12, "draw": 4},
}

# Temas mecánicos detectables: patrón en el texto de la carta que "hace" el
# tema (enabler) y patrón que lo "aprovecha" (payoff).
THEMES = {
    "lifegain": {
        "payoff": r"whenever you gain life",
        "enabler": r"you gain \d+ life|lifelink|gain that much life",
    },
    "sacrifice": {
        "payoff": r"whenever .* (creature|permanent) (you control )?dies",
        "enabler": r"sacrifice (a|another) creature|sacrifice this creature",
    },
    "spells": {
        "payoff": r"whenever you cast (an instant|a noncreature|an instant or sorcery)|prowess",
        "enabler": None,  # el enabler son los propios instantáneos/conjuros baratos
    },
    "artifacts": {
        # Payoff = premia tener/lanzar artefactos. OJO: improvisar NO es payoff
        # (consume artefactos, no premia tenerlos) — tratarlo como tal hacía
        # que los artefactos incoloros convirtieran cualquier identidad en
        # mazo de artefactos.
        "payoff": r"whenever you cast an artifact|whenever (an|another) artifact|artifact you control enters|affinity for artifacts|enchanted artifact is a creature",
        "enabler": r"improvise",  # además de los artefactos en sí (regla estructural)
    },
    "counters": {
        "payoff": r"if one or more counters would be put|proliferate",
        "enabler": r"\+1/\+1 counter",
    },
    "tokens": {
        "payoff": r"whenever (a|another) creature (you control )?enters",
        "enabler": r"create .* creature token",
    },
    "graveyard": {
        "payoff": r"delirium|threshold|for each creature card in your graveyard",
        "enabler": r"mill|return .* from your graveyard",
    },
}


def classify(card: dict) -> set[str]:
    """Etiquetas funcionales de una carta: creature, removal, sweeper, burn,
    counterspell, draw, ramp, recursion, lifegain, pump, land."""
    text = card["oracle"].lower()
    types = card["types"]
    tags: set[str] = set()

    if "Land" in types:
        return {"land"}
    if "Creature" in types:
        tags.add("creature")
    if re.search(r"destroy (target|up to)", text) or re.search(r"exile (target|up to)", text):
        tags.add("removal")
    if re.search(r"destroy all|each creature.*(-\d+/-\d+|destroy)", text):
        tags.add("sweeper")
    if re.search(r"deals? \d+ damage to (any target|target creature|target player|each opponent)", text):
        tags.add("burn")
        if "creature" not in tags:
            tags.add("removal")
    if re.search(r"counter target .*spell", text):
        tags.add("counterspell")
    if re.search(r"draws? (a|two|three|x) cards?", text):
        tags.add("draw")
    if re.search(r"\{t\}: add \{|search your library for a .*land", text):
        tags.add("ramp")
    if re.search(r"return .* from your graveyard to (your hand|the battlefield)", text):
        tags.add("recursion")
    if re.search(r"gains? \d+ life|lifelink", text):
        tags.add("lifegain")
    if re.search(r"target creature gets \+\d+", text):
        tags.add("pump")
    return tags


def theme_roles(card: dict) -> dict[str, str]:
    """Para cada tema, si la carta es 'payoff' o 'enabler' de ese tema."""
    text = card["oracle"].lower()
    types = card["types"]
    roles: dict[str, str] = {}
    for theme, pats in THEMES.items():
        if pats["payoff"] and re.search(pats["payoff"], text):
            roles[theme] = "payoff"
        elif pats["enabler"] and re.search(pats["enabler"], text):
            roles[theme] = "enabler"
    # enablers estructurales (por tipo de carta, no por texto)
    if "Artifact" in types and "artifacts" not in roles:
        roles["artifacts"] = "enabler"
    if ("Instant" in types or "Sorcery" in types) and card["cmc"] <= 3 and "spells" not in roles:
        roles["spells"] = "enabler"
    return roles


def efficiency(card: dict) -> float:
    """Puntuación de eficiencia individual (0-10, heurística).

    Criaturas: estadísticas respecto al coste. Hechizos: por función y coste.
    """
    cmc = max(card["cmc"], 1)
    score = 5.0
    if "Creature" in card["types"]:
        try:
            pt = int(card["power"]) + int(card["toughness"])
        except (TypeError, ValueError):
            pt = cmc * 2  # poder variable (*/*), neutral
        score = 5.0 + (pt - 2 * cmc) * 0.8  # 2*cmc de stats totales = media
        if re.search(r"flying|deathtouch|lifelink|first strike|menace|trample|haste",
                     card["oracle"].lower()):
            score += 0.8
        if card["oracle"]:
            score += 0.4  # tiene texto: algo hace
    else:
        tags = classify(card)
        if {"removal", "counterspell", "sweeper"} & tags:
            score = 7.0 - (cmc - 2) * 0.5
        elif "draw" in tags:
            score = 6.0 - (cmc - 2) * 0.4
        elif "pump" in tags:
            score = 4.0
    return max(0.0, min(10.0, score))
