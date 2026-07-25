"""Clasificador de tierras (referencia canónica del motor Forge).

Espejo 1:1 de `forge_engine/lib/src/lands.dart`. Shocks/checks/fetches y
demás no-básicas de la colección entran en la manabase por función real,
no solo básicas proporcionales.
"""
from __future__ import annotations
import re
from dataclasses import dataclass, field

BASIC_TYPE_COLOR = {
    "Plains": "W",
    "Island": "U",
    "Swamp": "B",
    "Mountain": "R",
    "Forest": "G",
}

BASIC_NAMES = {
    "Plains", "Island", "Swamp", "Mountain", "Forest",
    "Snow-Covered Plains", "Snow-Covered Island", "Snow-Covered Swamp",
    "Snow-Covered Mountain", "Snow-Covered Forest",
}

ADD_CLAUSE = re.compile(r"add ([^\n.]*)")
SYMBOL = re.compile(r"\{([wubrgc])\}")
FETCH = re.compile(r"search your library for ([^\n.]*land[^\n.]*)")
TAPPED = re.compile(r"enters (the battlefield )?tapped")


def _line_at(text: str, pos: int) -> str:
    """Línea (delimitada por '\\n') que contiene la posición pos."""
    start = text.rfind("\n", 0, pos + 1) + 1
    nl = text.find("\n", pos)
    end = len(text) if nl == -1 else nl
    return text[start:end]


@dataclass
class LandProfile:
    produces: set[str]
    tapped: str  # "never" | "conditional" | "always"
    is_fetch: bool
    fetches: set[str] = field(default_factory=set)
    is_basic: bool = False

    @property
    def is_utility(self) -> bool:
        return not self.produces and not self.is_fetch


def land_profile(card: dict) -> LandProfile:
    text = (card.get("oracle") or "").lower()

    produces: set[str] = set()
    for sub in card.get("subtypes", []):
        color = BASIC_TYPE_COLOR.get(sub)
        if color:
            produces.add(color)
    for m in ADD_CLAUSE.finditer(text):
        clause = m.group(1)
        if "one mana of any color" in clause or "mana of any one color" in clause:
            produces.update("WUBRG")
        for s in SYMBOL.finditer(clause):
            ch = s.group(1).upper()
            if ch != "C":
                produces.add(ch)

    tapped = "never"
    tapped_match = TAPPED.search(text)
    if tapped_match:
        line = _line_at(text, tapped_match.start())
        tapped = "conditional" if ("unless" in line or " if " in line) else "always"

    is_fetch = False
    fetches: set[str] = set()
    fetch_match = FETCH.search(text)
    if fetch_match:
        is_fetch = True
        clause = fetch_match.group(1)
        for name, color in BASIC_TYPE_COLOR.items():
            if name.lower() in clause:
                fetches.add(color)

    is_basic = "Basic" in card.get("types", []) or card.get("name") in BASIC_NAMES

    return LandProfile(
        produces=produces,
        tapped=tapped,
        is_fetch=is_fetch,
        fetches=fetches,
        is_basic=is_basic,
    )


def source_of(profile: LandProfile, color: str, deck_colors: str) -> bool:
    """¿Cuenta esta tierra como fuente de color en un mazo de deck_colors?"""
    if color in profile.produces:
        return True
    if profile.is_fetch:
        return color in deck_colors if not profile.fetches else color in profile.fetches
    return False
