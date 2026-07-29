"""El bulk de Scryfall cambió de UN array JSON a JSONL (julio 2026) y el
workflow murió con KeyError: 'download_uri'. Los iteradores deben tragar
los dos formatos — array (fixtures viejos, bulks descargados a mano) y
JSONL (lo único que Scryfall publica ahora)."""
import io
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from bulk_stream import iter_bulk_objects

CARDS = [{"name": "Llanowar Elves"}, {"name": "Serra Angel", "cmc": 5}]


def test_array_clasico():
    raw = io.BytesIO(b'[{"name": "Llanowar Elves"}, {"name": "Serra Angel", "cmc": 5}]')
    assert list(iter_bulk_objects(raw)) == CARDS


def test_array_con_espacios_delante():
    raw = io.BytesIO(b'  \n\t[{"name": "Llanowar Elves"}, {"name": "Serra Angel", "cmc": 5}]')
    assert list(iter_bulk_objects(raw)) == CARDS


def test_jsonl():
    raw = io.BytesIO(b'{"name": "Llanowar Elves"}\n{"name": "Serra Angel", "cmc": 5}\n')
    assert list(iter_bulk_objects(raw)) == CARDS


def test_jsonl_con_lineas_vacias_y_sin_salto_final():
    raw = io.BytesIO(b'\n{"name": "Llanowar Elves"}\n\n{"name": "Serra Angel", "cmc": 5}')
    assert list(iter_bulk_objects(raw)) == CARDS


def test_vacio():
    assert list(iter_bulk_objects(io.BytesIO(b""))) == []
    assert list(iter_bulk_objects(io.BytesIO(b"  \n"))) == []


def test_stream_sin_seek_como_stdin():
    class SoloLectura:
        def __init__(self, data):
            self._f = io.BytesIO(data)
        def read(self, n=-1):
            return self._f.read(n)
        def readline(self):
            return self._f.readline()

    raw = SoloLectura(b'{"name": "Llanowar Elves"}\n{"name": "Serra Angel", "cmc": 5}\n')
    assert list(iter_bulk_objects(raw)) == CARDS


def test_jsonl_gzip_transparente():
    # Scryfall publica el JSONL como .gz de contenido (no Content-Encoding)
    import gzip
    raw = io.BytesIO(gzip.compress(
        b'{"name": "Llanowar Elves"}\n{"name": "Serra Angel", "cmc": 5}\n'))
    assert list(iter_bulk_objects(raw)) == CARDS
