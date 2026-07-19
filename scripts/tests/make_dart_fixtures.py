"""Genera los fixtures de PARIDAD Python↔Dart del dHash del escáner.

Crea PNGs deterministas y calcula su huella con la fórmula REAL
(build_hash_db.dhash_pair, con Pillow). El test Dart
app/test/scanner/dhash_parity_test.dart decodifica los mismos PNGs y debe
producir exactamente los mismos 64+64 bits.

Uso:  python3 make_dart_fixtures.py [carpeta_destino]
      (por defecto ../../app/test/scanner/fixtures)
"""

from __future__ import annotations

import json
import pathlib
import random
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from PIL import Image, ImageDraw

from build_hash_db import dhash_pair, to_signed64


def synthetic_art(seed: int, size=(200, 150)) -> Image.Image:
    img = Image.new("RGB", size, (seed * 37 % 255, 80, 120))
    draw = ImageDraw.Draw(img)
    for i in range(6):
        x = (seed * 13 + i * 31) % (size[0] - 20)
        draw.rectangle([x, i * 22, x + 40, i * 22 + 18],
                       fill=((seed + i) * 53 % 255, 200, 40))
    return img


def noise(seed: int, w: int, h: int) -> Image.Image:
    rnd = random.Random(seed)
    img = Image.new("RGB", (w, h))
    img.putdata([(rnd.randrange(256), rnd.randrange(256), rnd.randrange(256))
                 for _ in range(w * h)])
    return img


def near_ties(seed: int, w: int, h: int, block: int, amp: int) -> Image.Image:
    """El caso más traicionero para la paridad: gris plano + ruido en
    BLOQUES del tamaño de una celda del resize. Los valores reescalados
    quedan a ±amp unos de otros, así que cada bit de la huella lo decide
    el redondeo entero exacto de Pillow — cualquier desviación del port
    a Dart se nota aquí."""
    rnd = random.Random(seed)
    levels = {}

    def px(x: int, y: int) -> tuple[int, int, int]:
        key = (x // block, y // block)
        if key not in levels:
            levels[key] = 128 + rnd.randint(-amp, amp)
        v = levels[key]
        return (v, v, v)

    img = Image.new("RGB", (w, h))
    img.putdata([px(x, y) for y in range(h) for x in range(w)])
    return img


def main() -> None:
    out_dir = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else \
        pathlib.Path(__file__).parents[2] / "app" / "test" / "scanner" / "fixtures"
    out_dir.mkdir(parents=True, exist_ok=True)

    fixtures = {
        "art_200x150.png": synthetic_art(2),
        "art_ancha_320x120.png": synthetic_art(5, (320, 120)),
        "ruido_97x64.png": noise(7, 97, 64),
        "ruido_alto_30x200.png": noise(11, 30, 200),
        "empates_bloque_grande_200x150.png": near_ties(21, 200, 150, 22, 2),
        "empates_bloque_fino_150x200.png": near_ties(23, 150, 200, 17, 1),
        "empates_bloque_100x80.png": near_ties(29, 100, 80, 11, 2),
        "gris_plano_50x50.png": Image.new("RGB", (50, 50), (128, 128, 128)),
        "exacta_9x8.png": noise(13, 9, 8),  # sin reescalado horizontal
    }

    expected = {}
    for name, img in fixtures.items():
        img.save(out_dir / name)
        # releer el PNG guardado: la huella debe salir del MISMO archivo
        h, v = dhash_pair(Image.open(out_dir / name))
        expected[name] = {
            "h": str(to_signed64(h)),  # firmado, como en SQLite y en Dart
            "v": str(to_signed64(v)),
        }
    (out_dir / "expected_hashes.json").write_text(
        json.dumps(expected, indent=2, sort_keys=True) + "\n",
        encoding="utf8")
    print(f"{len(fixtures)} fixtures en {out_dir}")


if __name__ == "__main__":
    main()
