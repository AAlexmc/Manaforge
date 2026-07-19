"""Guardia de la paridad Python↔Dart del dHash del escáner.

pil_port_reference.py reimplementa en Python puro las operaciones de Pillow
que usa dhash_pair (convert("L") y resize(LANCZOS), aritmética entera del C
de Pillow). El MISMO algoritmo, línea a línea, está portado a Dart en
app/lib/scanner/dhash.dart. Si Pillow cambiara su resample en una versión
futura, este test lo detecta ANTES de que scan-db-N genere huellas que ya
no cuadren con las de la app.
"""
import pathlib
import random
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
sys.path.insert(0, str(pathlib.Path(__file__).parent))
from PIL import Image

from build_hash_db import dhash_pair
from pil_port_reference import dhash_pair_pure, resample_lanczos_l, rgb_to_l


def _random_img(seed: int, w: int, h: int) -> Image.Image:
    rnd = random.Random(seed)
    img = Image.new("RGB", (w, h))
    img.putdata([(rnd.randrange(256), rnd.randrange(256), rnd.randrange(256))
                 for _ in range(w * h)])
    return img


def test_grayscale_identico_a_pillow():
    img = _random_img(1, 40, 30)
    px = list(img.getdata())
    assert [rgb_to_l(r, g, b) for r, g, b in px] == list(img.convert("L").getdata())


def test_resize_lanczos_identico_a_pillow():
    for seed, w, h in [(2, 40, 30), (3, 200, 150), (4, 9, 8), (5, 31, 200)]:
        img = _random_img(seed, w, h).convert("L")
        grey = list(img.getdata())
        for out_w, out_h in [(9, 8), (8, 9)]:
            assert resample_lanczos_l(grey, w, h, out_w, out_h) == \
                list(img.resize((out_w, out_h), Image.LANCZOS).getdata()), \
                f"resize {w}x{h}->{out_w}x{out_h} (seed {seed})"


def test_dhash_identico_a_pillow_en_lote():
    rnd = random.Random(99)
    for _ in range(25):
        w, h = rnd.randint(15, 250), rnd.randint(15, 250)
        img = _random_img(rnd.randrange(10_000), w, h)
        assert dhash_pair_pure(list(img.getdata()), w, h) == dhash_pair(img), \
            f"dhash difiere en {w}x{h}"


def test_degradado_caso_traicionero():
    """Degradados suaves: vecinos casi iguales, máximo riesgo de redondeo."""
    w, h = 120, 90
    img = Image.new("RGB", (w, h))
    img.putdata([(int(x * 255 / (w - 1)), int(y * 255 / (h - 1)), 128)
                 for y in range(h) for x in range(w)])
    assert dhash_pair_pure(list(img.getdata()), w, h) == dhash_pair(img)
