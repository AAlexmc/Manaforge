"""Base de datos de huellas visuales para el escáner de ManaForge.

Descarga el ARTE de cada impresión (art_crop de Scryfall) y calcula su
huella perceptual (dHash de 128 bits: 16x8 horizontal + 8x16 vertical).
El escáner de la app compara la huella de lo que ve la cámara contra esta
base por distancia de Hamming — el mismo enfoque (hash perceptual del arte)
que usan los escáneres comerciales de cartas.

Incremental: si recibe una base previa, solo descarga las impresiones
nuevas. Sé educado con Scryfall: concurrencia baja y pausas.
"""

from __future__ import annotations

import io
import json
import sqlite3
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

try:
    from PIL import Image
except ImportError:  # pragma: no cover
    Image = None

try:
    import requests
except ImportError:  # pragma: no cover
    requests = None

SCHEMA = """
CREATE TABLE IF NOT EXISTS meta (key TEXT PRIMARY KEY, value TEXT);
CREATE TABLE IF NOT EXISTS art_hashes (
    scryfall_id TEXT PRIMARY KEY,
    oracle_id   TEXT NOT NULL,
    name        TEXT NOT NULL,
    set_code    TEXT,
    collector_number TEXT,
    hash_h      INTEGER NOT NULL,  -- dHash horizontal 8x8 (64 bits, firmado)
    hash_v      INTEGER NOT NULL   -- dHash vertical 8x8 (64 bits, firmado)
);
CREATE INDEX IF NOT EXISTS idx_hashes_oracle ON art_hashes(oracle_id);
"""

USER_AGENT = "ManaForge-ScannerDB/1.0 (github.com/AAlexmc/Manaforge)"


def dhash_pair(img) -> tuple[int, int]:
    """dHash doble de una imagen PIL: horizontal 8x8 + vertical 8x8.

    Cada huella son EXACTAMENTE 64 bits (cabe en el INTEGER de SQLite);
    juntas, 128 bits de firma. La app Dart debe replicar esta fórmula
    bit a bit (tests espejo).
    """
    grey = img.convert("L")
    # horizontal: 9x8, compara columnas vecinas
    small = grey.resize((9, 8), Image.LANCZOS)
    px = list(small.getdata())
    h = 0
    for row in range(8):
        for col in range(8):
            left = px[row * 9 + col]
            right = px[row * 9 + col + 1]
            h = (h << 1) | (1 if left > right else 0)
    # vertical: 8x9, compara filas vecinas
    small = grey.resize((8, 9), Image.LANCZOS)
    px = list(small.getdata())
    v = 0
    for col in range(8):
        for row in range(8):
            top = px[row * 8 + col]
            bottom = px[(row + 1) * 8 + col]
            v = (v << 1) | (1 if top > bottom else 0)
    return h, v


def to_signed64(n: int) -> int:
    """Complemento a dos: [0, 2^64) -> INTEGER firmado de SQLite."""
    return n - (1 << 64) if n >= (1 << 63) else n


def hamming(a: int, b: int) -> int:
    return bin(a ^ b).count("1")


def iter_bulk(path: Path):
    with open(path, "rb") as f:
        try:
            import ijson
            yield from ijson.items(f, "item")
        except ImportError:  # pragma: no cover
            yield from json.load(open(path, encoding="utf8"))


def wanted_printings(bulk_path: Path):
    """Impresiones a hashear: con arte, sin tokens; una por scryfall_id."""
    for card in iter_bulk(bulk_path):
        if card.get("layout") in ("token", "double_faced_token", "art_series", "emblem"):
            continue
        if not card.get("oracle_id"):
            continue
        uris = card.get("image_uris") or {}
        art = uris.get("art_crop")
        if not art and card.get("card_faces"):
            face = card["card_faces"][0]
            art = (face.get("image_uris") or {}).get("art_crop")
        if not art:
            continue
        yield {
            "id": card["id"],
            "oracle_id": card["oracle_id"],
            "name": card["name"],
            "set": card.get("set"),
            "collector_number": card.get("collector_number"),
            "art": art,
        }


def fetch_and_hash(item, session, retries=3):
    for attempt in range(retries):
        try:
            r = session.get(item["art"], timeout=30,
                            headers={"User-Agent": USER_AGENT})
            if r.status_code == 200:
                img = Image.open(io.BytesIO(r.content))
                h, v = dhash_pair(img)
                return item, h, v
            if r.status_code in (404, 403):
                return None
        except Exception:
            pass
        time.sleep(1 + attempt)
    return None


def build(bulk_path: Path, db_path: Path, limit: int | None = None,
          workers: int = 6) -> dict:
    con = sqlite3.connect(db_path)
    con.executescript(SCHEMA)
    have = {r[0] for r in con.execute("SELECT scryfall_id FROM art_hashes")}
    todo = [it for it in wanted_printings(bulk_path) if it["id"] not in have]
    if limit is not None:
        todo = todo[:limit]
    print(f"ya hasheadas: {len(have)} · pendientes: {len(todo)}")
    n_new = n_fail = 0
    session = requests.Session()
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = [pool.submit(fetch_and_hash, it, session) for it in todo]
        for i, fut in enumerate(as_completed(futures)):
            result = fut.result()
            if result is None:
                n_fail += 1
                continue
            item, h, v = result
            con.execute(
                "INSERT OR REPLACE INTO art_hashes VALUES (?,?,?,?,?,?,?)",
                (item["id"], item["oracle_id"], item["name"], item["set"],
                 item["collector_number"],
                 to_signed64(h), to_signed64(v)),
            )
            n_new += 1
            if n_new % 500 == 0:
                con.commit()
                print(f"  {n_new}/{len(todo)}…", flush=True)
    con.execute("INSERT OR REPLACE INTO meta VALUES ('updated', ?)",
                (time.strftime("%Y-%m-%d"),))
    con.commit()
    con.close()
    return {"new": n_new, "failed": n_fail, "already": len(have)}


if __name__ == "__main__":
    bulk = Path(sys.argv[1])
    out = Path(sys.argv[2])
    limit = int(sys.argv[3]) if len(sys.argv) > 3 else None
    stats = build(bulk, out, limit=limit)
    print(stats)
