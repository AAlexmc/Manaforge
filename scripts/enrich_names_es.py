#!/usr/bin/env python3
"""Añade a la SQLite de cartas los nombres en español (cards.name_es, schema v5).

Uso:
    python3 enrich_names_es.py manaforge_cards.sqlite [all_cards.json]
    curl ... | python3 enrich_names_es.py manaforge_cards.sqlite

Segunda pasada tras build_card_db.py: lee el bulk All Cards de Scryfall (el
único que trae todas las lenguas) y, para cada impresión `lang == "es"` con
nombre impreso, guarda el primero visto por oracle_id. Solo cartas que ya
están en la DB — tokens y demás descartes del build se ignoran solos.

En CI el bulk llega por STDIN (curl | python3): ~2,9 GB en streaming con
ijson, sin tocar el disco del runner. Con un path como segundo argumento lee
del archivo (fixtures de test). Idempotente: correrlo dos veces deja la DB
igual. Medido 2026-07-26: ~29k de ~34,7k cartas (~83%) tienen nombre es; el
resto nunca se imprimió en español y queda a NULL (la app cae al inglés).
"""
from __future__ import annotations
import json
import sqlite3
import sys
from pathlib import Path


def _iter_cards(source):
    """Itera objetos carta del bulk. Streaming si ijson está instalado."""
    # el try acota SOLO el import: un ImportError diferido a mitad de stream
    # no debe caer a json.load sobre un source medio consumido
    try:
        import ijson  # type: ignore
    except ImportError:
        yield from json.load(source)
        return
    yield from ijson.items(source, "item")


def _fold(text: str) -> str:
    """Minúsculas y sin diacríticos (NFD): «Ornitóptero» -> «ornitoptero»,
    «Señor» -> «senor». Para que la búsqueda encuentre tecleando sin tildes
    ni mayúsculas — el LIKE de SQLite solo pliega ASCII."""
    import unicodedata
    return "".join(c for c in unicodedata.normalize("NFD", text.lower())
                   if not unicodedata.combining(c))


def _printed_name_es(card: dict) -> str | None:
    """Nombre impreso en español; en cartas de dos caras, las caras con //."""
    name = card.get("printed_name")
    if name:
        return name
    faces = card.get("card_faces") or []
    face_names = [f.get("printed_name") for f in faces]
    if face_names and all(face_names):
        return " // ".join(face_names)
    return None


def enrich(db_path: Path, bulk_path: Path | None = None,
           min_updated: int = 0) -> dict:
    """Enriquece la DB. Devuelve contadores para tests/logs.

    [min_updated] es un suelo de cordura para CI (medido real: ~29k nombres):
    si el bulk rinde menos —vacío, forma cambiada, campos renombrados— NO se
    escribe nada ni se sube el schema, y se sale con error en vez de publicar
    en verde una «v5» sin traducciones.
    """
    con = sqlite3.connect(db_path)
    cols = {r[1] for r in con.execute("PRAGMA table_info(cards)")}
    if "name_es" not in cols:
        con.execute("ALTER TABLE cards ADD COLUMN name_es TEXT")
    if "name_es_fold" not in cols:
        con.execute("ALTER TABLE cards ADD COLUMN name_es_fold TEXT")
    con.execute("CREATE INDEX IF NOT EXISTS idx_cards_name_es ON cards(name_es)")
    con.execute(
        "CREATE INDEX IF NOT EXISTS idx_cards_name_es_fold ON cards(name_es_fold)")

    known = {r[0] for r in con.execute("SELECT oracle_id FROM cards")}
    names: dict[str, str] = {}
    n_seen = 0
    if bulk_path is not None:
        source = open(bulk_path, "rb")
    else:
        source = sys.stdin.buffer
    try:
        for card in _iter_cards(source):
            n_seen += 1
            if card.get("lang") != "es":
                continue
            oracle_id = card.get("oracle_id")
            if not oracle_id or oracle_id in names or oracle_id not in known:
                continue
            name = _printed_name_es(card)
            if name:
                names[oracle_id] = name
    finally:
        if bulk_path is not None:
            source.close()

    if len(names) < min_updated:
        con.close()
        raise SystemExit(
            f"solo {len(names)} nombres es (< {min_updated}): bulk sospechoso "
            "(¿vacío, forma cambiada, campos renombrados?). No toco la DB.")

    con.executemany(
        "UPDATE cards SET name_es = ?, name_es_fold = ? WHERE oracle_id = ?",
        [(v, _fold(v), k) for k, v in names.items()])
    # el bump a v5 solo si de verdad hay traducciones: una pasada vacía no
    # debe fabricar una «v5» hueca
    if names:
        con.execute("UPDATE meta SET value = '5' WHERE key = 'schema_version'")
    con.commit()
    con.close()
    return {"seen": n_seen, "updated": len(names)}


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    min_updated = 0
    for a in sys.argv[1:]:
        if a.startswith("--min="):
            min_updated = int(a.split("=", 1)[1])
    if len(args) not in (1, 2):
        print(__doc__)
        return 2
    db = Path(args[0])
    bulk = Path(args[1]) if len(args) == 2 else None
    stats = enrich(db, bulk, min_updated=min_updated)
    print(f"objetos leídos: {stats['seen']}  ·  name_es puestos: {stats['updated']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
