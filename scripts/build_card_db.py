#!/usr/bin/env python3
"""Convierte el bulk data de Scryfall (Default Cards) en la SQLite de ManaForge.

Uso:
    python3 build_card_db.py bulk.json manaforge_cards.sqlite

Esquema (v1) — ver docs/arquitectura-datos.md:
    cards      1 fila por carta (nivel Oracle): reglas, coste, colores, legalidades
    printings  1 fila por impresión: set, número, idioma, printed_name, URLs de imagen
    meta       versión del esquema y fecha del bulk

El streaming con ijson permite procesar el bulk (~2 GB) con poca RAM; si ijson
no está disponible, cae a json.load (válido para fixtures y máquinas grandes).
Este script corre en GitHub Actions (workflow build-card-db) — el runner sí
tiene acceso a Scryfall — y publica la DB como release del repo.
"""
from __future__ import annotations
import json
import sqlite3
import sys
from pathlib import Path

SCHEMA = """
CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT);
CREATE TABLE cards (
    oracle_id  TEXT PRIMARY KEY,
    name       TEXT NOT NULL,
    mana_cost  TEXT,
    cmc        REAL,
    colors     TEXT,           -- "WU" etc.
    color_identity TEXT,
    type_line  TEXT,
    oracle_text TEXT,
    power      TEXT,
    toughness  TEXT,
    keywords   TEXT,           -- JSON array
    legalities TEXT            -- JSON object formato->estado
);
CREATE INDEX idx_cards_name ON cards(name);
CREATE TABLE printings (
    scryfall_id  TEXT PRIMARY KEY,
    oracle_id    TEXT NOT NULL REFERENCES cards(oracle_id),
    set_code     TEXT,
    set_name     TEXT,
    collector_number TEXT,
    lang         TEXT,
    printed_name TEXT,          -- nombre en el idioma de la impresión
    rarity       TEXT,
    image_small  TEXT,
    image_normal TEXT,
    image_png    TEXT,
    price_eur    TEXT,
    released_at  TEXT           -- fecha de salida del set (filtros por año)
);
CREATE INDEX idx_printings_oracle ON printings(oracle_id);
CREATE INDEX idx_printings_printed_name ON printings(printed_name);
"""


def iter_bulk(path: Path):
    """Itera las cartas del bulk. Streaming si ijson está instalado."""
    try:
        import ijson  # type: ignore
        with open(path, "rb") as f:
            yield from ijson.items(f, "item")
    except ImportError:
        yield from json.loads(path.read_text())


def _images(card: dict) -> tuple[str | None, str | None, str | None]:
    uris = card.get("image_uris")
    if not uris and card.get("card_faces"):
        uris = card["card_faces"][0].get("image_uris")
    if not uris:
        return None, None, None
    return uris.get("small"), uris.get("normal"), uris.get("png")


def _oracle_fields(card: dict) -> dict:
    """Campos de reglas; para cartas de dos caras, combina las caras."""
    faces = card.get("card_faces") or []
    oracle_text = card.get("oracle_text")
    if oracle_text is None and faces:
        oracle_text = " // ".join(f.get("oracle_text", "") for f in faces)
    mana_cost = card.get("mana_cost")
    if not mana_cost and faces:
        mana_cost = faces[0].get("mana_cost", "")
    power = card.get("power") or (faces[0].get("power") if faces else None)
    toughness = card.get("toughness") or (faces[0].get("toughness") if faces else None)
    return {
        "mana_cost": mana_cost or "",
        "oracle_text": oracle_text or "",
        "power": power,
        "toughness": toughness,
    }


def build(bulk_path: Path, db_path: Path, bulk_date: str = "") -> dict:
    """Construye la DB. Devuelve contadores para tests/logs."""
    db_path.unlink(missing_ok=True)
    con = sqlite3.connect(db_path)
    con.executescript(SCHEMA)
    seen_oracle: set[str] = set()
    n_cards = n_printings = n_skipped = 0

    for card in iter_bulk(bulk_path):
        oracle_id = card.get("oracle_id")
        layout = card.get("layout", "")
        # descartar tokens, arte y cartas sin identidad oracle
        if not oracle_id or layout in ("token", "double_faced_token", "art_series", "emblem"):
            n_skipped += 1
            continue
        if oracle_id not in seen_oracle:
            seen_oracle.add(oracle_id)
            f = _oracle_fields(card)
            con.execute(
                "INSERT INTO cards VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                (
                    oracle_id,
                    card["name"],
                    f["mana_cost"],
                    float(card.get("cmc") or 0),  # ijson da decimal.Decimal
                    "".join(card.get("colors") or []),
                    "".join(card.get("color_identity") or []),
                    card.get("type_line", ""),
                    f["oracle_text"],
                    f["power"],
                    f["toughness"],
                    json.dumps(card.get("keywords") or []),
                    json.dumps(card.get("legalities") or {}),
                ),
            )
            n_cards += 1
        small, normal, png = _images(card)
        con.execute(
            "INSERT OR REPLACE INTO printings VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
            (
                card["id"],
                oracle_id,
                card.get("set"),
                card.get("set_name"),
                card.get("collector_number"),
                card.get("lang", "en"),
                card.get("printed_name") or card["name"],
                card.get("rarity"),
                small,
                normal,
                png,
                (card.get("prices") or {}).get("eur"),
                card.get("released_at"),
            ),
        )
        n_printings += 1

    con.execute("INSERT INTO meta VALUES ('schema_version', '2')")
    con.execute("INSERT INTO meta VALUES ('bulk_date', ?)", (bulk_date,))
    con.commit()
    con.execute("VACUUM")
    con.close()
    return {"cards": n_cards, "printings": n_printings, "skipped": n_skipped}


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    try:
        stats = build(Path(sys.argv[1]), Path(sys.argv[2]),
                      bulk_date=sys.argv[3] if len(sys.argv) > 3 else "")
    except Exception as e:  # noqa: BLE001 — anotación visible en CI sin login
        print(f"::error::build_card_db: {type(e).__name__}: {e}")
        raise
    print(f"OK: {stats['cards']} cartas, {stats['printings']} impresiones, "
          f"{stats['skipped']} descartadas -> {sys.argv[2]}")
