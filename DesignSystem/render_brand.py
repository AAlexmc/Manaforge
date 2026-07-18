#!/usr/bin/env python3
"""Geometría de Ascua — banner y logo de ManaForge.
Expresión visual de DesignSystem/FILOSOFIA-VISUAL.md."""
import math
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import numpy as np

F = "/root/.claude/skills/canvas-design/canvas-fonts/"
GLOOCK = F + "Gloock-Regular.ttf"
DMMONO = F + "DMMono-Regular.ttf"
JURA = F + "Jura-Medium.ttf"
JURA_L = F + "Jura-Light.ttf"

# Las cinco voces + la joya dorada
BONE   = (224, 204, 138)
WATER  = (90, 155, 216)
SHADOW = (138, 110, 158)
EMBER  = (224, 106, 80)
FOREST = (79, 184, 120)
GOLD   = (201, 166, 76)
CREAM  = (240, 234, 220)
FIELD1 = (23, 20, 31)    # berenjena de carbón
FIELD2 = (13, 12, 11)    # carbón
GRAPH  = (72, 68, 62)    # grafito
MANA5 = [BONE, WATER, SHADOW, EMBER, FOREST]


def field(w, h):
    x = np.linspace(0, 1, w)[None, :]
    y = np.linspace(0, 1, h)[:, None]
    t = np.clip(x * 0.45 + y * 0.55, 0, 1)
    img = np.zeros((h, w, 3))
    for i in range(3):
        img[:, :, i] = FIELD1[i] + (FIELD2[i] - FIELD1[i]) * t
    return Image.fromarray(img.astype("uint8"), "RGB").convert("RGBA")


def glow(canvas, cx, cy, rx, ry, color, alpha, blur):
    g = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(g).ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=color + (alpha,))
    canvas.alpha_composite(g.filter(ImageFilter.GaussianBlur(blur)))


def grain_and_vignette(img, grain_alpha=9, vig=52):
    w, h = img.size
    rng = np.random.default_rng(60)
    noise = rng.integers(0, grain_alpha + 1, (h, w), dtype="uint8")
    layer = Image.merge("RGBA", [Image.new("L", (w, h), 235)] * 3 + [Image.fromarray(noise, "L")])
    img.alpha_composite(layer)
    m = Image.new("L", (w, h), 0)
    ImageDraw.Draw(m).rectangle([int(w * 0.06), int(h * 0.1), int(w * 0.94), int(h * 0.9)], fill=vig)
    m = m.filter(ImageFilter.GaussianBlur(min(w, h) // 7))
    dark = Image.new("RGBA", (w, h), (0, 0, 0, 255))
    dark.putalpha(Image.eval(m, lambda a: vig - min(a, vig)))
    img.alpha_composite(dark)


def rounded(img, radius):
    m = Image.new("L", img.size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, img.size[0], img.size[1]], radius=radius, fill=255)
    img.putalpha(m)


def anvil(draw, x, y, u, tone=GOLD):
    """Yunque en geometría destilada. u = unidad; origen (x,y) esquina sup-izq."""
    dark = tuple(int(c * 0.62) for c in tone)
    mid = tuple(int(c * 0.85) for c in tone)
    lite = tuple(min(255, int(c * 1.3)) for c in tone)
    # losa superior
    draw.rounded_rectangle([x + 14 * u, y, x + 76 * u, y + 14 * u], radius=3 * u, fill=tone)
    # cuerno (bigornia): cono que continúa la losa
    draw.polygon([(x + 16 * u, y), (x + 16 * u, y + 14 * u),
                  (x + 8 * u, y + 13.2 * u), (x, y + 7 * u), (x + 6 * u, y + 2 * u)], fill=tone)
    # cintura
    draw.polygon([(x + 32 * u, y + 14 * u), (x + 60 * u, y + 14 * u),
                  (x + 54 * u, y + 27 * u), (x + 38 * u, y + 27 * u)], fill=dark)
    # base
    draw.polygon([(x + 38 * u, y + 27 * u), (x + 54 * u, y + 27 * u),
                  (x + 66 * u, y + 37 * u), (x + 26 * u, y + 37 * u)], fill=mid)
    # plinto
    draw.rounded_rectangle([x + 22 * u, y + 37 * u, x + 70 * u, y + 44 * u],
                           radius=2.4 * u, fill=dark)
    # filo de luz
    draw.line([(x + 15 * u, y + 1.4 * u), (x + 74 * u, y + 1.4 * u)],
              fill=lite, width=max(2, int(1.4 * u)))


def make_banner(path):
    W, H = 2560, 800
    img = field(W, H)
    glow(img, W * 0.74, H * 0.78, 620, 420, EMBER, 46, 170)
    glow(img, W * 0.06, H * 0.02, 700, 380, SHADOW, 30, 190)
    d = ImageDraw.Draw(img)

    # marco de un cabello
    d.rounded_rectangle([56, 56, W - 56, H - 56], radius=30, outline=GOLD + (30,), width=2)

    # ——— fenómeno (derecha): la curva estudiada ———
    base_y = 620
    x0, step, bw = 1500, 130, 56
    heights = [46, 150, 262, 330, 252, 152, 84]
    colors = [GRAPH, BONE, WATER, SHADOW, EMBER, FOREST, GRAPH]
    for i, (bh, col) in enumerate(zip(heights, colors)):
        x = x0 + i * step
        alpha = 120 if col == GRAPH else 165
        d.rounded_rectangle([x, base_y - bh, x + bw, base_y], radius=10, fill=col + (alpha,))
    # eje con marcas
    d.line([(x0 - 40, base_y + 1), (x0 + 6 * step + bw + 40, base_y + 1)], fill=CREAM + (90,), width=2)
    mono26 = ImageFont.truetype(DMMONO, 26)
    for i in range(7):
        cx = x0 + i * step + bw / 2
        d.line([(cx, base_y + 4), (cx, base_y + 16)], fill=CREAM + (90,), width=2)
        lbl = "6+" if i == 6 else str(i)
        tw = d.textlength(lbl, font=mono26)
        d.text((cx - tw / 2, base_y + 26), lbl, font=mono26, fill=CREAM + (110,))
    apex_x = x0 + 3 * step + bw / 2

    # arco de cinco voces sobre la curva
    ccx, ccy, R = apex_x, base_y + 60, 430
    for i, col in enumerate(MANA5):
        ang = math.radians(142 - i * 26)
        px = ccx + R * math.cos(ang)
        py = ccy - R * math.sin(ang)
        d.ellipse([px - 34, py - 34, px + 34, py + 34], outline=col + (70,), width=2)
        halo = 22
        hi = Image.new("RGBA", img.size, (0, 0, 0, 0))
        ImageDraw.Draw(hi).ellipse([px - halo, py - halo, px + halo, py + halo], fill=col + (70,))
        img.alpha_composite(hi.filter(ImageFilter.GaussianBlur(16)))
        d.ellipse([px - 15, py - 15, px + 15, py + 15], fill=col + (255,))

    # ——— palabra (izquierda) ———
    title = ImageFont.truetype(GLOOCK, 236)
    d.text((146, 158), "ManaForge", font=title, fill=CREAM)
    sub = ImageFont.truetype(JURA, 57)
    d.text((156, 474), "Forja mazos con las cartas que ya tienes.", font=sub, fill=(206, 199, 186, 255))
    mono32 = ImageFont.truetype(DMMONO, 33)
    d.text((156, 610), "60 CARTAS   ·   CURVA 2.0–3.5   ·   5 COLORES   ·   0 €",
           font=mono32, fill=GOLD + (200,))
    # ley, en susurro
    mono24 = ImageFont.truetype(DMMONO, 24)
    law = "LEY DE KARSTEN · 24 ± 1 TIERRAS"
    d.text((W - 120 - d.textlength(law, font=mono24), H - 108), law,
           font=mono24, fill=CREAM + (80,))

    grain_and_vignette(img)
    rounded(img, 44)
    img.save(path)
    print("banner ->", path)


def make_logo(path):
    S = 2048
    img = field(S, S)
    glow(img, S * 0.5, S * 0.72, S * 0.42, S * 0.34, EMBER, 64, S // 9)
    glow(img, S * 0.18, S * 0.1, S * 0.4, S * 0.3, SHADOW, 34, S // 8)
    d = ImageDraw.Draw(img)
    # marco interior de un cabello
    d.rounded_rectangle([S * 0.052, S * 0.052, S * 0.948, S * 0.948],
                        radius=S * 0.16, outline=GOLD + (56,), width=max(3, S // 400))
    # yunque (76u de ancho -> centrado)
    u = S / 118
    ax = (S - 76 * u) / 2
    ay = S * 0.40
    # sombra del yunque
    sh = Image.new("RGBA", img.size, (0, 0, 0, 0))
    anvil(ImageDraw.Draw(sh), ax, ay, u, tone=(0, 0, 0))
    sh = sh.filter(ImageFilter.GaussianBlur(S // 70))
    sh.putalpha(Image.eval(sh.split()[3], lambda a: int(a * 0.55)))
    img.alpha_composite(sh, (int(S * 0.008), int(S * 0.018)))
    anvil(d, ax, ay, u)
    # arco de cinco voces
    ccx, ccy, R = S / 2, ay + 12 * u, S * 0.27
    for i, col in enumerate(MANA5):
        ang = math.radians(138 - i * 24)
        px = ccx + R * math.cos(ang)
        py = ccy - R * math.sin(ang)
        halo = S * 0.030
        hi = Image.new("RGBA", img.size, (0, 0, 0, 0))
        ImageDraw.Draw(hi).ellipse([px - halo, py - halo, px + halo, py + halo], fill=col + (85,))
        img.alpha_composite(hi.filter(ImageFilter.GaussianBlur(int(S * 0.016))))
        r = S * 0.0145
        d.ellipse([px - r, py - r, px + r, py + r], fill=col + (255,))
    grain_and_vignette(img, grain_alpha=8, vig=40)
    rounded(img, int(S * 0.225))
    img = img.resize((1024, 1024), Image.LANCZOS)
    img.save(path)
    print("logo ->", path)


make_banner("/root/manaforge/docs/assets/banner.png")
make_logo("/root/manaforge/docs/assets/logo.png")
