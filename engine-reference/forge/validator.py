"""Validador de mazos: las reglas duras que Forge NUNCA puede violar.

1. No usar más copias de una carta de las que hay en la colección.
2. Respetar el límite de copias del formato (4 en 60; básicas ilimitadas).
3. El mazo debe tener el tamaño exacto del formato.
4. Los colores de cada carta deben caber en la identidad del mazo.
5. Tierras y coste medio dentro del rango del arquetipo.

Si la colección no permite cumplirlas, Forge avisa y explica el compromiso
en lugar de generar un mazo defectuoso (regla de producto).
"""
from __future__ import annotations
from .curve import LAND_RANGES, AVG_CMC_RANGES, DECK_SIZE, average_cmc

BASIC_LANDS = {"Plains", "Island", "Swamp", "Mountain", "Forest"}
MAX_COPIES = 4


def validate_deck(deck: dict, pool: dict) -> list[str]:
    """Devuelve la lista de violaciones (vacía = mazo válido).

    deck = {"colors": "WB", "archetype": "midrange",
            "cards": {nombre: qty}, "lands": {nombre: qty}}
    pool = {nombre: {"qty": int, "cmc": int, "colors": str, ...}}
    """
    errors: list[str] = []
    cards, lands = deck["cards"], deck["lands"]
    everything = {**cards, **lands}

    # 1-2: propiedad y límite de copias
    for name, qty in everything.items():
        if name not in pool:
            errors.append(f"'{name}' no está en la colección")
            continue
        if qty > pool[name]["qty"]:
            errors.append(f"'{name}': usa {qty}, posee {pool[name]['qty']}")
        if qty > MAX_COPIES and name not in BASIC_LANDS:
            errors.append(f"'{name}': {qty} copias supera el límite de {MAX_COPIES}")

    # 3: tamaño exacto
    total = sum(everything.values())
    if total != DECK_SIZE:
        errors.append(f"el mazo tiene {total} cartas, deben ser {DECK_SIZE}")

    # 4: identidad de color
    allowed = set(deck["colors"])
    for name, qty in cards.items():
        if name in pool:
            colors = set(pool[name]["colors"])
            if not colors <= allowed:
                errors.append(f"'{name}' ({pool[name]['colors']}) fuera de la identidad {deck['colors']}")

    # 5: tierras y coste medio dentro del arquetipo
    archetype = deck["archetype"]
    n_lands = sum(lands.values())
    lo, hi = LAND_RANGES[archetype]
    if not lo <= n_lands <= hi:
        errors.append(f"{n_lands} tierras fuera del rango {lo}-{hi} de {archetype}")
    known_cards = {n: q for n, q in cards.items() if n in pool}
    avg = average_cmc(known_cards, pool) if known_cards else 0.0
    clo, chi = AVG_CMC_RANGES[archetype]
    if not clo <= avg <= chi:
        errors.append(f"coste medio {avg:.2f} fuera del rango {clo}-{chi} de {archetype}")

    return errors
