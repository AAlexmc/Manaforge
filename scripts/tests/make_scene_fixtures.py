"""Genera los fixtures de ESCENA del detector de cartas (regresión del
caso real que falló: carta sobre una manta de punto con sombras — foto de
Ale del 19-07-2026 — y carta sobre madera vetada).

Cada fixture es una "foto" compuesta: una carta sintética (borde negro,
marco, arte, caja de texto) pegada EN PERSPECTIVA sobre un fondo con
textura, con sombra, desenfoque, reflejo de funda y ruido de sensor. El
JSON acompaña las esquinas verdaderas y la huella dHash del arte prístino
(lo que tendría la base scan-db), con cotas de error/distancia holgadas
para absorber diferencias de decodificación JPEG entre Pillow y Dart.

Los fixtures van COMMITEADOS; este script solo se ejecuta a mano cuando
cambian las escenas:  python3 make_scene_fixtures.py
"""

from __future__ import annotations

import json
import math
import pathlib
import random
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from PIL import Image, ImageDraw, ImageFilter

from build_hash_db import dhash_pair, to_signed64

ART = (0.077, 0.923, 0.117, 0.545)  # ventana del arte (como en la app)


def make_card(seed=1, w=630, h=880, frame=(168, 165, 158)):
    """Carta sintética con proporciones Magic (63:88)."""
    rnd = random.Random(seed)
    img = Image.new("RGB", (w, h), (12, 12, 12))  # borde negro
    d = ImageDraw.Draw(img)
    m = int(w * 0.045)
    d.rectangle([m, m, w - m, h - m], fill=frame)
    d.rectangle([int(w*0.07), int(h*0.055), int(w*0.93), int(h*0.105)],
                fill=(210, 208, 200))  # título
    ax0, ay0 = int(w * ART[0]), int(h * ART[2])
    ax1, ay1 = int(w * ART[1]), int(h * ART[3])
    d.rectangle([ax0, ay0, ax1, ay1], fill=(120, 30, 20))  # arte
    for _ in range(40):
        x = rnd.randrange(ax0, ax1 - 30)
        y = rnd.randrange(ay0, ay1 - 30)
        c = (rnd.randrange(20, 230), rnd.randrange(10, 90),
             rnd.randrange(10, 60))
        d.ellipse([x, y, x + rnd.randrange(8, 60), y + rnd.randrange(8, 60)],
                  fill=c)
    d.rectangle([int(w*0.07), int(h*0.56), int(w*0.93), int(h*0.61)],
                fill=(215, 213, 205))  # línea de tipo
    d.rectangle([int(w*0.07), int(h*0.62), int(w*0.93), int(h*0.92)],
                fill=(225, 223, 215))  # caja de texto
    for i in range(9):
        y = int(h*0.64) + i * int(h*0.03)
        d.rectangle([int(w*0.10), y, int(w*rnd.uniform(0.6, 0.9)), y + 4],
                    fill=(60, 60, 60))
    return img


def blanket_bg(w, h, seed=2):
    """Manta clara de canalé con franjas diagonales de sombra."""
    rnd = random.Random(seed)
    img = Image.new("L", (w, h))
    px = img.load()
    for y in range(h):
        for x in range(w):
            base = 200
            rib = 45 * math.sin(x * 0.38 + 8 * math.sin(y * 0.015))
            rib2 = 25 * math.sin(y * 0.31)
            stripe = 55 * max(0.0, math.sin((x + 2.2 * y) * 0.010))
            noise = rnd.gauss(0, 9)
            px[x, y] = int(max(0, min(255, base + rib + rib2 - stripe + noise)))
    return img.convert("RGB")


def wood_bg(w, h, seed=3):
    rnd = random.Random(seed)
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        for x in range(w):
            g = 30 * math.sin(y * 0.05 + 3 * math.sin(x * 0.008))
            base = (150 + g, 105 + g * 0.7, 60 + g * 0.5)
            px[x, y] = tuple(int(max(0, min(255, c + rnd.gauss(0, 5))))
                             for c in base)
    return img


def _perspective_coeffs(dst_pts, src_pts):
    """Coeficientes de Image.transform(PERSPECTIVE): destino → origen.
    Eliminación gaussiana 8x8 (sin numpy)."""
    a = [[0.0] * 9 for _ in range(8)]
    for i in range(4):
        x, y = dst_pts[i]
        u, v = src_pts[i]
        a[i*2][0] = x; a[i*2][1] = y; a[i*2][2] = 1
        a[i*2][6] = -u * x; a[i*2][7] = -u * y; a[i*2][8] = u
        a[i*2+1][3] = x; a[i*2+1][4] = y; a[i*2+1][5] = 1
        a[i*2+1][6] = -v * x; a[i*2+1][7] = -v * y; a[i*2+1][8] = v
    for col in range(8):
        piv = max(range(col, 8), key=lambda r: abs(a[r][col]))
        a[col], a[piv] = a[piv], a[col]
        pv = a[col][col]
        for row in range(8):
            if row == col or a[row][col] == 0:
                continue
            f = a[row][col] / pv
            for k2 in range(col, 9):
                a[row][k2] -= f * a[col][k2]
    return [a[i][8] / a[i][i] for i in range(8)]


def compose(bg, card, corners, blur=1.0, seed=9):
    """Pega la carta con perspectiva + sombra + desenfoque + ruido."""
    w, h = bg.size
    cw, ch = card.size
    src = [(0, 0), (cw, 0), (cw, ch), (0, ch)]
    coeffs = _perspective_coeffs(corners, src)
    warped = card.transform((w, h), Image.PERSPECTIVE, coeffs, Image.BICUBIC)
    mask = Image.new("L", (cw, ch), 255).transform(
        (w, h), Image.PERSPECTIVE, coeffs, Image.BICUBIC)
    shadow = mask.point(lambda v: int(v * 0.45)).filter(
        ImageFilter.GaussianBlur(6))
    out = bg.copy()
    out.paste(Image.new("RGB", (w, h), (0, 0, 0)), (6, 9), shadow)
    out.paste(warped, (0, 0), mask)
    if blur:
        out = out.filter(ImageFilter.GaussianBlur(blur))
    rnd = random.Random(seed)
    px = out.load()
    for _ in range(w * h // 20):
        x = rnd.randrange(w)
        y = rnd.randrange(h)
        r, g, b = px[x, y]
        n = rnd.randint(-8, 8)
        px[x, y] = (max(0, min(255, r + n)), max(0, min(255, g + n)),
                    max(0, min(255, b + n)))
    return out


def main() -> None:
    out_dir = pathlib.Path(__file__).parents[2] / "app" / "test" / \
        "scanner" / "fixtures"
    out_dir.mkdir(parents=True, exist_ok=True)

    card = make_card()
    cw, ch = card.size
    art = card.crop((int(cw*ART[0]), int(ch*ART[2]),
                     int(cw*ART[1]), int(ch*ART[3])))
    art_h, art_v = dhash_pair(art)

    expected = {}

    # Escena 1: manta de canalé + reflejo de funda (el caso de Ale)
    c1 = [(225, 285), (495, 282), (501, 660), (219, 665)]
    img1 = compose(blanket_bg(720, 960), card, c1, blur=1.0)
    d = ImageDraw.Draw(img1, "RGBA")
    d.polygon([(c1[0][0]+30, c1[0][1]+22), (c1[1][0]-8, c1[1][1]+135),
               (c1[1][0]-45, c1[1][1]+195), (c1[0][0]+8, c1[0][1]+90)],
              fill=(255, 255, 255, 55))
    img1.save(out_dir / "escena_manta.jpg", quality=80)
    expected["escena_manta.jpg"] = {
        "corners": c1, "corner_tolerance": 30,
        "art_h": str(to_signed64(art_h)), "art_v": str(to_signed64(art_v)),
        # el reflejo tapa parte del arte: cota holgada (medido ~32)
        "max_multi_distance": 45,
    }

    # Escena 2: madera vetada, carta con leve perspectiva
    c2 = [(172, 210), (517, 225), (510, 720), (161, 705)]
    img2 = compose(wood_bg(720, 960), card, c2, blur=0.8)
    img2.save(out_dir / "escena_madera.jpg", quality=80)
    expected["escena_madera.jpg"] = {
        "corners": c2, "corner_tolerance": 30,
        "art_h": str(to_signed64(art_h)), "art_v": str(to_signed64(art_v)),
        # medido ~6; margen por diferencias de decodificación JPEG
        "max_multi_distance": 22,
    }

    (out_dir / "escenas_expected.json").write_text(
        json.dumps(expected, indent=2) + "\n", encoding="utf8")
    print(f"2 escenas en {out_dir}")


if __name__ == "__main__":
    main()
