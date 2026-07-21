"""Tests del conversor de histórico de precios MTGJSON -> SQLite.

Lo que más duele aquí no es equivocarse en un precio, sino que el build
SEMANAL reviente por un `null` del volcado de terceros: la release se queda
congelada y nadie mira la pestaña Actions de un cron.
"""
import json
import math
import pathlib
import sqlite3
import struct
import sys

import pytest

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from build_price_history_db import build

IDENTIFIERS = {
    "meta": {"date": "2026-07-20"},
    "data": {
        "uuid-barata": {"identifiers": {"scryfallOracleId": "o-bolt"}},
        "uuid-cara": {"identifiers": {"scryfallOracleId": "o-bolt"}},
        "uuid-sol": {"identifiers": {"scryfallOracleId": "o-sol"}},
        "uuid-multi": {"identifiers": {"scryfallOracleId": "o-multi"}},
        "uuid-null": None,                       # entrada a null
        "uuid-sin-ids": {"identifiers": {}},     # sin scryfallOracleId
    },
}


def _paper(cardmarket):
    return {"paper": {"cardmarket": cardmarket}}


def _series_of(days):
    return {"retail": {"normal": days}}


PRICES = {
    "meta": {"date": "2026-07-20"},
    "data": {
        # dos ediciones de la misma carta: gana la MÁS BARATA de cada día
        "uuid-barata": _paper(
            {"retail": {"normal": {"2026-07-01": 1.0, "2026-07-03": 3.0}}}
        ),
        "uuid-cara": _paper(
            {"retail": {"normal": {"2026-07-01": 5.0, "2026-07-03": 2.0}}}
        ),
        # hueco intermedio (falta el día 2) y precios a descartar
        "uuid-sol": _paper(
            {
                "retail": {
                    "normal": {
                        "2026-07-01": 10.0,
                        "2026-07-02": 0,        # sin precio, no es punto
                        "2026-07-03": -1.0,     # negativo, tampoco
                        "no-es-una-fecha": 7.0, # clave rara
                    }
                }
            }
        ),
        # los null de MTGJSON tumbaban el build entero con AttributeError
        "uuid-cardmarket-null": _paper(None),
        "uuid-retail-null": _paper({"retail": None}),
        "uuid-normal-null": _paper({"retail": {"normal": None}}),
        "uuid-entry-null": None,
        # uuid que no está en identifiers: se ignora sin ruido
        "uuid-desconocido": _paper(
            {"retail": {"normal": {"2026-07-01": 4.0}}}
        ),
        # los otros mercados: TCGplayer y Card Kingdom en papel, Cardhoarder
        # en MTGO (tix)
        "uuid-multi": {
            "paper": {
                "tcgplayer": _series_of({"2026-07-01": 2.5, "2026-07-03": 2.7}),
                "cardkingdom": _series_of({"2026-07-03": 3.9}),
                "manapool": _series_of({"2026-07-02": 2.2}),
            },
            "mtgo": {"cardhoarder": _series_of({"2026-07-01": 0.5})},
        },
    },
}


@pytest.fixture
def built(tmp_path):
    prices = tmp_path / "AllPrices.json"
    ids = tmp_path / "AllIdentifiers.json"
    out = tmp_path / "prices.sqlite"
    prices.write_text(json.dumps(PRICES))
    ids.write_text(json.dumps(IDENTIFIERS))
    build(prices, ids, out)
    return sqlite3.connect(out)


def _series(db, oracle, provider="cardmarket"):
    row = db.execute(
        "SELECT values_f32 FROM price_series "
        "WHERE oracle_id = ? AND provider = ?",
        (oracle, provider),
    ).fetchone()
    if row is None:
        return None
    return struct.unpack(f"<{len(row[0]) // 4}f", row[0])


def test_meta_describe_el_tramo(built):
    meta = dict(built.execute("SELECT key, value FROM meta"))
    assert meta["start_date"] == "2026-07-01"
    assert meta["end_date"] == "2026-07-03"
    assert meta["days"] == "3"
    assert meta["currency"] == "EUR"


def test_cada_mercado_tiene_su_serie(built):
    assert _series(built, "o-multi", "tcgplayer") == pytest.approx(
        (2.5, float("nan"), 2.7), nan_ok=True
    )
    assert _series(built, "o-multi", "cardkingdom")[2] == pytest.approx(3.9)
    assert _series(built, "o-multi", "manapool")[1] == pytest.approx(2.2)
    assert _series(built, "o-multi", "cardhoarder")[0] == pytest.approx(0.5)
    # la carta de Cardmarket no se cuela en los otros mercados
    assert _series(built, "o-bolt", "tcgplayer") is None


def test_meta_dice_los_mercados_y_su_divisa(built):
    meta = dict(built.execute("SELECT key, value FROM meta"))
    assert meta["schema"] == "2"
    assert meta["providers"].split(",") == [
        "cardmarket",
        "tcgplayer",
        "cardkingdom",
        "manapool",
        "cardhoarder",
    ]
    assert meta["currency:tcgplayer"] == "USD"
    assert meta["currency:cardhoarder"] == "TIX"


def test_gana_la_edicion_mas_barata_de_cada_dia(built):
    serie = _series(built, "o-bolt")
    assert serie[0] == pytest.approx(1.0)   # 1.0 vs 5.0
    assert serie[2] == pytest.approx(2.0)   # 3.0 vs 2.0


def test_los_dias_sin_dato_son_nan(built):
    serie = _series(built, "o-bolt")
    assert math.isnan(serie[1])             # nadie publicó el día 2


def test_precios_no_positivos_y_fechas_raras_se_descartan(built):
    serie = _series(built, "o-sol")
    assert serie[0] == pytest.approx(10.0)
    assert math.isnan(serie[1])             # 0 no es un punto
    assert math.isnan(serie[2])             # negativo tampoco


def test_los_null_de_mtgjson_no_tumban_el_build(built):
    # si el build no hubiese llegado aquí, el fixture habría petado
    assert _series(built, "o-bolt") is not None


def test_las_cartas_sin_ningun_precio_valido_no_ocupan_fila(built):
    ids = {
        r[0]
        for r in built.execute(
            "SELECT oracle_id FROM price_series WHERE provider = 'cardmarket'"
        )
    }
    assert ids == {"o-bolt", "o-sol"}


def test_uuid_sin_oracle_no_aparece(built):
    assert _series(built, "uuid-desconocido") is None


def test_falla_ruidosamente_si_no_hay_ningun_historico(tmp_path):
    prices = tmp_path / "AllPrices.json"
    ids = tmp_path / "AllIdentifiers.json"
    prices.write_text(json.dumps({"data": {}}))
    ids.write_text(json.dumps({"data": {}}))
    with pytest.raises(SystemExit):
        build(prices, ids, tmp_path / "out.sqlite")
