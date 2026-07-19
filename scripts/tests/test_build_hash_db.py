"""Tests de la huella perceptual del escáner (sin red)."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from PIL import Image, ImageDraw

from build_hash_db import dhash_pair, hamming, to_signed64


def _art(seed: int) -> Image.Image:
    """Genera un 'arte' sintético determinista."""
    img = Image.new("RGB", (200, 150), (seed * 37 % 255, 80, 120))
    draw = ImageDraw.Draw(img)
    for i in range(6):
        x = (seed * 13 + i * 31) % 180
        draw.rectangle([x, i * 22, x + 40, i * 22 + 18],
                       fill=((seed + i) * 53 % 255, 200, 40))
    return img


def test_hash_determinista():
    a1 = dhash_pair(_art(1))
    a2 = dhash_pair(_art(1))
    assert a1 == a2


def test_mismo_arte_reescalado_coincide():
    original = _art(2)
    resized = original.resize((100, 75))
    h1, v1 = dhash_pair(original)
    h2, v2 = dhash_pair(resized)
    assert hamming(h1, h2) + hamming(v1, v2) <= 10


def test_artes_distintos_no_coinciden():
    h1, v1 = dhash_pair(_art(3))
    h2, v2 = dhash_pair(_art(4))
    assert hamming(h1, h2) + hamming(v1, v2) > 20


def test_hash_cabe_en_sqlite():
    """El bug que tumbó scan-db-1: la huella debe caber en 64 bits."""
    for seed in range(8):
        h, v = dhash_pair(_art(seed))
        assert 0 <= h < (1 << 64)
        assert 0 <= v < (1 << 64)
        assert -(1 << 63) <= to_signed64(h) < (1 << 63)
        assert -(1 << 63) <= to_signed64(v) < (1 << 63)


def test_signed64_ida_y_vuelta():
    for n in (0, 1, (1 << 63) - 1, 1 << 63, (1 << 64) - 1):
        signed = to_signed64(n)
        assert (signed + (1 << 64)) % (1 << 64) == n
