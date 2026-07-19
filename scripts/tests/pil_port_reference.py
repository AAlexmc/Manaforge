"""Reimplementación EN PYTHON PURO de las operaciones de Pillow que usa
build_hash_db.dhash_pair — convert("L") y resize(LANCZOS) — replicando la
aritmética entera del código C de Pillow bit a bit.

No la usa la app: es el espejo que valida que la fórmula portada a Dart
(app/lib/scanner/dhash.dart) es EXACTA. El test test_pil_port.py comprueba
que esta implementación coincide con Pillow en cientos de imágenes; el
mismo algoritmo, línea a línea, vive en Dart con sus propios fixtures.

Fuentes (Pillow src/libImaging):
- convert.c   rgb2l:  L24(rgb) = R*19595 + G*38470 + B*7471 + 0x8000; L = L24 >> 16
- Resample.c  precompute_coeffs + normalize_coeffs_8bpc + horizontal/vertical,
              PRECISION_BITS = 32 - 8 - 2, filtro Lanczos soporte 3.0.
"""

from __future__ import annotations

import math

PRECISION_BITS = 32 - 8 - 2  # 22


def rgb_to_l(r: int, g: int, b: int) -> int:
    """convert.c: fórmula ITU-R 601-2 en aritmética entera con redondeo."""
    return (r * 19595 + g * 38470 + b * 7471 + 0x8000) >> 16


def _sinc(x: float) -> float:
    if x == 0.0:
        return 1.0
    x *= math.pi
    return math.sin(x) / x


def lanczos_filter(x: float) -> float:
    if -3.0 <= x < 3.0:
        return _sinc(x) * _sinc(x / 3.0)
    return 0.0


LANCZOS_SUPPORT = 3.0


def precompute_coeffs(in_size: int, out_size: int) -> tuple[list[tuple[int, int]], list[list[float]]]:
    """Resample.c precompute_coeffs para el rango completo [0, in_size)."""
    scale = filterscale = in_size / out_size
    if filterscale < 1.0:
        filterscale = 1.0
    support = LANCZOS_SUPPORT * filterscale
    ksize = int(math.ceil(support)) * 2 + 1
    bounds: list[tuple[int, int]] = []
    coeffs: list[list[float]] = []
    for xx in range(out_size):
        center = (xx + 0.5) * scale
        ww = 0.0
        ss = 1.0 / filterscale
        xmin = int(center - support + 0.5)
        if xmin < 0:
            xmin = 0
        xmax = int(center + support + 0.5)
        if xmax > in_size:
            xmax = in_size
        xmax -= xmin
        k = []
        for x in range(xmax):
            w = lanczos_filter((x + xmin - center + 0.5) * ss) * ss
            k.append(w)
            ww += w
        for x in range(xmax):
            if ww != 0.0:
                k[x] /= ww
        # rellenar hasta ksize (el C lo deja a 0)
        k.extend(0.0 for _ in range(ksize - len(k)))
        bounds.append((xmin, xmax))
        coeffs.append(k)
    return bounds, coeffs


def normalize_coeffs_8bpc(coeffs: list[list[float]]) -> list[list[int]]:
    """Resample.c normalize_coeffs_8bpc: double -> INT32 con PRECISION_BITS."""
    out = []
    for k in coeffs:
        row = []
        for w in k:
            if w < 0:
                row.append(int(-0.5 + w * (1 << PRECISION_BITS)))
            else:
                row.append(int(0.5 + w * (1 << PRECISION_BITS)))
        out.append(row)
    return out


def _clip8(ss: int) -> int:
    v = ss >> PRECISION_BITS
    if v < 0:
        return 0
    if v > 255:
        return 255
    return v


def resample_lanczos_l(px: list[int], w: int, h: int,
                       out_w: int, out_h: int) -> list[int]:
    """Resample.c ImagingResample para modo L (8 bits), filtro LANCZOS.

    Igual que Pillow: pasada horizontal primero (si cambia el ancho) y
    vertical después (si cambia el alto), ambas con coeficientes enteros.
    """
    need_h = out_w != w
    need_v = out_h != h

    if need_h:
        bounds, coeffs = precompute_coeffs(w, out_w)
        kk = normalize_coeffs_8bpc(coeffs)
        mid = [0] * (out_w * h)
        for yy in range(h):
            for xx in range(out_w):
                xmin, xmax = bounds[xx]
                k = kk[xx]
                ss = 1 << (PRECISION_BITS - 1)
                for x in range(xmax):
                    ss += px[yy * w + xmin + x] * k[x]
                mid[yy * out_w + xx] = _clip8(ss)
        px, w = mid, out_w

    if need_v:
        bounds, coeffs = precompute_coeffs(h, out_h)
        kk = normalize_coeffs_8bpc(coeffs)
        out = [0] * (w * out_h)
        for yy in range(out_h):
            ymin, ymax = bounds[yy]
            k = kk[yy]
            for xx in range(w):
                ss = 1 << (PRECISION_BITS - 1)
                for y in range(ymax):
                    ss += px[(ymin + y) * w + xx] * k[y]
                out[yy * w + xx] = _clip8(ss)
        px = out

    return px


def dhash_pair_pure(rgb_px: list[tuple[int, int, int]], w: int, h: int) -> tuple[int, int]:
    """dhash_pair de build_hash_db.py sin Pillow: misma fórmula, puro Python."""
    grey = [rgb_to_l(r, g, b) for (r, g, b) in rgb_px]
    # horizontal: 9x8
    small = resample_lanczos_l(grey, w, h, 9, 8)
    hh = 0
    for row in range(8):
        for col in range(8):
            left = small[row * 9 + col]
            right = small[row * 9 + col + 1]
            hh = (hh << 1) | (1 if left > right else 0)
    # vertical: 8x9
    small = resample_lanczos_l(grey, w, h, 8, 9)
    vv = 0
    for col in range(8):
        for row in range(8):
            top = small[row * 8 + col]
            bottom = small[(row + 1) * 8 + col]
            vv = (vv << 1) | (1 if top > bottom else 0)
    return hh, vv
