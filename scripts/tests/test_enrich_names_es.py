"""Tests del enriquecedor de nombres en español (bulk All Cards -> cards.name_es)."""
import json
import pathlib
import sqlite3
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from build_card_db import build
from enrich_names_es import enrich

# Mini-bulk formato Default Cards para construir la DB base (v4).
BULK_BASE = [
    {
        "id": "aaaa-1111", "oracle_id": "o-elves", "name": "Llanowar Elves",
        "lang": "en", "layout": "normal", "set": "fdn", "set_name": "Foundations",
        "collector_number": "227", "rarity": "common", "cmc": 1.0,
        "mana_cost": "{G}", "type_line": "Creature — Elf Druid",
        "oracle_text": "{T}: Add {G}.", "power": "1", "toughness": "1",
        "colors": ["G"], "color_identity": ["G"], "keywords": [],
        "legalities": {"standard": "legal"},
        "image_uris": {"small": "https://cards.scryfall.io/small/e.jpg",
                       "normal": "https://cards.scryfall.io/normal/e.jpg",
                       "png": "https://cards.scryfall.io/png/e.png"},
        "prices": {"eur": "0.13"},
    },
    {
        "id": "bbbb-1111", "oracle_id": "o-room", "name": "Meat Locker // Drowned Diner",
        "lang": "en", "layout": "split", "set": "dsk", "set_name": "Duskmourn",
        "collector_number": "65", "rarity": "common", "cmc": 3.0,
        "type_line": "Enchantment — Room", "colors": ["U"], "color_identity": ["U"],
        "keywords": [], "legalities": {"standard": "legal"},
        "card_faces": [
            {"name": "Meat Locker", "mana_cost": "{2}{U}",
             "oracle_text": "Tap up to one target creature.",
             "image_uris": {"small": "https://cards.scryfall.io/small/r.jpg",
                            "normal": "https://cards.scryfall.io/normal/r.jpg",
                            "png": "https://cards.scryfall.io/png/r.png"}},
            {"name": "Drowned Diner", "mana_cost": "{3}{U}",
             "oracle_text": "Draw two cards."},
        ],
        "prices": {},
    },
]

# Mini-bulk formato All Cards (todas las lenguas) para el enriquecimiento.
ALL_CARDS = [
    # impresión española normal: pone name_es
    {"oracle_id": "o-elves", "lang": "es", "printed_name": "Elfos de Llanowar"},
    # segunda impresión es de la MISMA carta con otro nombre: la primera gana
    {"oracle_id": "o-elves", "lang": "es", "printed_name": "Elfos de Llanowar (alt)"},
    # impresión inglesa: se ignora
    {"oracle_id": "o-elves", "lang": "en", "printed_name": "Llanowar Elves"},
    # es de una carta que NO está en la DB (p. ej. token): se ignora sin error
    {"oracle_id": "o-fantasma", "lang": "es", "printed_name": "Carta Fantasma"},
    # dos caras: printed_name por cara, se unen con //
    {"oracle_id": "o-room", "lang": "es", "card_faces": [
        {"printed_name": "Cámara frigorífica"},
        {"printed_name": "Restaurante anegado"},
    ]},
    # es sin printed_name por ninguna parte: se ignora
    {"oracle_id": "o-elves", "lang": "es"},
]


def _setup(tmp_path):
    bulk = tmp_path / "bulk.json"
    bulk.write_text(json.dumps(BULK_BASE))
    db = tmp_path / "cards.sqlite"
    build(bulk, db)
    allcards = tmp_path / "all.json"
    allcards.write_text(json.dumps(ALL_CARDS))
    return db, allcards


def test_enrich_pone_name_es_y_sube_schema_a_5(tmp_path):
    db, allcards = _setup(tmp_path)
    stats = enrich(db, allcards)
    con = sqlite3.connect(db)
    assert con.execute(
        "SELECT name_es FROM cards WHERE oracle_id='o-elves'").fetchone()[0] \
        == "Elfos de Llanowar"
    assert con.execute(
        "SELECT value FROM meta WHERE key='schema_version'").fetchone()[0] == "5"
    assert stats["updated"] == 2


def test_dos_caras_une_los_nombres_con_barras(tmp_path):
    db, allcards = _setup(tmp_path)
    enrich(db, allcards)
    con = sqlite3.connect(db)
    assert con.execute(
        "SELECT name_es FROM cards WHERE oracle_id='o-room'").fetchone()[0] \
        == "Cámara frigorífica // Restaurante anegado"


def test_carta_sin_impresion_es_queda_a_null(tmp_path):
    bulk = _setup(tmp_path)
    db, allcards = bulk
    enrich(db, allcards)
    con = sqlite3.connect(db)
    # o-fantasma no está en la DB; y ninguna carta de la DB se inventa nombre
    total_es = con.execute(
        "SELECT COUNT(*) FROM cards WHERE name_es IS NOT NULL").fetchone()[0]
    assert total_es == 2


def test_idempotente_correr_dos_veces_no_cambia_nada(tmp_path):
    db, allcards = _setup(tmp_path)
    enrich(db, allcards)
    stats2 = enrich(db, allcards)
    con = sqlite3.connect(db)
    assert con.execute(
        "SELECT name_es FROM cards WHERE oracle_id='o-elves'").fetchone()[0] \
        == "Elfos de Llanowar"
    assert con.execute(
        "SELECT value FROM meta WHERE key='schema_version'").fetchone()[0] == "5"
    assert stats2["updated"] == 2
