"""Tests del conversor bulk Scryfall -> SQLite con un fixture en formato bulk."""
import json
import pathlib
import sqlite3
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from build_card_db import build

# Fixture mínimo en el formato real del bulk de Scryfall
BULK = [
    {   # impresión inglesa de una carta normal
        "id": "aaaa-1111", "oracle_id": "o-elves", "name": "Llanowar Elves",
        "lang": "en", "layout": "normal", "set": "fdn", "set_name": "Foundations",
        "collector_number": "227", "rarity": "common", "cmc": 1.0,
        "mana_cost": "{G}", "type_line": "Creature — Elf Druid",
        "oracle_text": "{T}: Add {G}.", "power": "1", "toughness": "1",
        "colors": ["G"], "color_identity": ["G"], "keywords": [],
        "legalities": {"standard": "legal", "modern": "legal"},
        "image_uris": {"small": "https://cards.scryfall.io/small/e.jpg",
                       "normal": "https://cards.scryfall.io/normal/e.jpg",
                       "png": "https://cards.scryfall.io/png/e.png"},
        "prices": {"eur": "0.13"},
    },
    {   # impresión ESPAÑOLA de la misma carta (mismo oracle_id)
        "id": "aaaa-2222", "oracle_id": "o-elves", "name": "Llanowar Elves",
        "printed_name": "Elfos de Llanowar",
        "lang": "es", "layout": "normal", "set": "fdn", "set_name": "Foundations",
        "collector_number": "227", "rarity": "common", "cmc": 1.0,
        "mana_cost": "{G}", "type_line": "Creature — Elf Druid",
        "oracle_text": "{T}: Add {G}.", "power": "1", "toughness": "1",
        "colors": ["G"], "color_identity": ["G"], "keywords": [],
        "legalities": {"standard": "legal"},
        "image_uris": {"small": "https://cards.scryfall.io/small/es.jpg",
                       "normal": "https://cards.scryfall.io/normal/es.jpg",
                       "png": "https://cards.scryfall.io/png/es.png"},
        "prices": {},
    },
    {   # carta de dos caras: reglas en card_faces
        "id": "bbbb-1111", "oracle_id": "o-room", "name": "Meat Locker // Drowned Diner",
        "lang": "en", "layout": "split", "set": "dsk", "set_name": "Duskmourn",
        "collector_number": "65", "rarity": "common", "cmc": 3.0,
        "type_line": "Enchantment — Room", "colors": ["U"], "color_identity": ["U"],
        "keywords": [], "legalities": {"standard": "legal"},
        "card_faces": [
            {"name": "Meat Locker", "mana_cost": "{2}{U}",
             "oracle_text": "When you unlock this door, tap up to one target creature.",
             "image_uris": {"small": "https://cards.scryfall.io/small/r.jpg",
                            "normal": "https://cards.scryfall.io/normal/r.jpg",
                            "png": "https://cards.scryfall.io/png/r.png"}},
            {"name": "Drowned Diner", "mana_cost": "{3}{U}",
             "oracle_text": "When you unlock this door, draw two cards."},
        ],
        "prices": {"eur": "0.06"},
    },
    {   # token: debe descartarse
        "id": "cccc-1111", "oracle_id": "o-token", "name": "Elf Warrior",
        "lang": "en", "layout": "token", "set": "tfdn", "cmc": 0.0,
        "type_line": "Token Creature — Elf Warrior", "legalities": {},
    },
]


def test_build(tmp_path):
    bulk = tmp_path / "bulk.json"
    bulk.write_text(json.dumps(BULK))
    db = tmp_path / "cards.sqlite"
    stats = build(bulk, db, bulk_date="2026-07-18")

    assert stats == {"cards": 2, "printings": 3, "skipped": 1}

    con = sqlite3.connect(db)
    # búsqueda por nombre inglés
    row = con.execute("SELECT oracle_text, power FROM cards WHERE name='Llanowar Elves'").fetchone()
    assert row == ("{T}: Add {G}.", "1")
    # búsqueda por nombre impreso en español -> llega a la carta oracle
    row = con.execute("""
        SELECT c.name FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id
        WHERE p.printed_name = 'Elfos de Llanowar'""").fetchone()
    assert row == ("Llanowar Elves",)
    # la impresión española conserva su imagen propia
    row = con.execute("SELECT image_png FROM printings WHERE lang='es'").fetchone()
    assert row[0].endswith("es.png")
    # dos caras: reglas combinadas y coste de la primera cara
    row = con.execute("SELECT oracle_text, mana_cost FROM cards WHERE oracle_id='o-room'").fetchone()
    assert "unlock this door" in row[0] and "//" in row[0]
    assert row[1] == "{2}{U}"
    # imagen de la primera cara disponible
    row = con.execute("SELECT image_small FROM printings WHERE scryfall_id='bbbb-1111'").fetchone()
    assert row[0] is not None
    # el token no está
    assert con.execute("SELECT COUNT(*) FROM cards WHERE name='Elf Warrior'").fetchone()[0] == 0
    # meta
    assert con.execute("SELECT value FROM meta WHERE key='bulk_date'").fetchone()[0] == "2026-07-18"
    con.close()
