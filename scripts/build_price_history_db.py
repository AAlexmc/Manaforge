#!/usr/bin/env python3
"""Convierte el histórico de precios de MTGJSON en la SQLite de ManaForge.

Uso:
    python3 build_price_history_db.py AllPrices.json AllIdentifiers.json \\
        manaforge_prices.sqlite

MTGJSON publica, por carta y día, el precio de CARDMARKET de los últimos ~90
días (`data[uuid].paper.cardmarket.retail.normal`), que es la misma serie
"precio medio de venta" que enseña la ficha de Cardmarket. Scryfall —de donde
salen los precios de la app— solo publica el de HOY, así que sin esto la
gráfica de una carta tarda meses en tener forma.

Se guarda a nivel ORACLE y con el mismo criterio que el resto del Mercado de
ManaForge (`pricesForOracles`): el precio de la edición MÁS BARATA de ese día.
Así la serie encaja con el punto que la app apunta a diario en local.

Formato pensado para que quepa en una release y se lea sin parsear nada:
una fila por carta con un BLOB de float32 (uno por día desde `start_date`,
NaN = sin dato ese día). ~30k cartas × 90 días × 4 B ≈ 11 MB antes de gzip.

Corre en GitHub Actions (workflow build-price-db) igual que build_card_db.py.
"""
from __future__ import annotations

import array
import math
import sqlite3
import sys
from datetime import date, timedelta
from pathlib import Path

try:
    import ijson  # streaming: los dos ficheros suman ~2 GB descomprimidos
except ImportError:  # pragma: no cover - en CI siempre está
    ijson = None
    import json

SCHEMA = """
CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT);
CREATE TABLE price_series (
    oracle_id  TEXT PRIMARY KEY,
    values_f32 BLOB NOT NULL   -- float32 por día desde meta.start_date; NaN = sin dato
);
"""


def _uuid_to_oracle(identifiers_path: Path) -> dict[str, str]:
    """uuid de MTGJSON → oracle_id de Scryfall (el que usa ManaForge)."""
    out: dict[str, str] = {}
    with identifiers_path.open("rb") as fh:
        if ijson is None:
            for uuid, card in json.load(fh)["data"].items():
                oracle = (card.get("identifiers") or {}).get("scryfallOracleId")
                if oracle:
                    out[uuid] = oracle
            return out
        for uuid, card in ijson.kvitems(fh, "data", use_float=True):
            oracle = (card.get("identifiers") or {}).get("scryfallOracleId")
            if oracle:
                out[uuid] = oracle
    return out


def _series_by_oracle(
    prices_path: Path, uuid_to_oracle: dict[str, str]
) -> dict[str, dict[str, float]]:
    """Para cada oracle y día, el precio MÁS BARATO entre sus ediciones."""
    out: dict[str, dict[str, float]] = {}
    with prices_path.open("rb") as fh:
        items = (
            ijson.kvitems(fh, "data", use_float=True)
            if ijson is not None
            else json.load(fh)["data"].items()
        )
        for uuid, entry in items:
            oracle = uuid_to_oracle.get(uuid)
            if not oracle:
                continue
            daily = (
                ((entry or {}).get("paper") or {})
                .get("cardmarket", {})
                .get("retail", {})
                .get("normal")
            )
            if not daily:
                continue
            bucket = out.setdefault(oracle, {})
            for day, price in daily.items():
                price = float(price)
                if price <= 0:
                    continue
                current = bucket.get(day)
                if current is None or price < current:
                    bucket[day] = price
    return out


def build(prices_path: Path, identifiers_path: Path, out_path: Path) -> None:
    print(f"Leyendo identificadores de {identifiers_path}…", flush=True)
    uuid_to_oracle = _uuid_to_oracle(identifiers_path)
    print(f"  {len(uuid_to_oracle):,} impresiones con oracle_id", flush=True)

    print(f"Leyendo precios de {prices_path}…", flush=True)
    by_oracle = _series_by_oracle(prices_path, uuid_to_oracle)
    print(f"  {len(by_oracle):,} cartas con histórico de Cardmarket", flush=True)
    if not by_oracle:
        raise SystemExit("Ningún histórico: ¿cambió el formato de MTGJSON?")

    all_days = {day for series in by_oracle.values() for day in series}
    start = date.fromisoformat(min(all_days))
    end = date.fromisoformat(max(all_days))
    span = (end - start).days + 1
    index = {
        (start + timedelta(days=i)).isoformat(): i for i in range(span)
    }
    print(f"  {span} días, de {start} a {end}", flush=True)

    if out_path.exists():
        out_path.unlink()
    db = sqlite3.connect(out_path)
    db.executescript(SCHEMA)
    rows = []
    for oracle, series in by_oracle.items():
        values = array.array("f", [math.nan]) * span
        for day, price in series.items():
            values[index[day]] = price
        rows.append((oracle, values.tobytes()))
    db.executemany("INSERT INTO price_series VALUES (?, ?)", rows)
    db.executemany(
        "INSERT INTO meta VALUES (?, ?)",
        [
            ("schema", "1"),
            ("start_date", start.isoformat()),
            ("end_date", end.isoformat()),
            ("days", str(span)),
            ("source", "MTGJSON AllPrices · paper.cardmarket.retail.normal"),
            ("currency", "EUR"),
        ],
    )
    db.commit()
    db.execute("VACUUM")
    db.close()
    size = out_path.stat().st_size / 1024 / 1024
    print(f"✓ {out_path} — {len(rows):,} cartas, {size:.1f} MB", flush=True)


def main(argv: list[str]) -> int:
    if len(argv) != 4:
        print(__doc__)
        return 2
    build(Path(argv[1]), Path(argv[2]), Path(argv[3]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
