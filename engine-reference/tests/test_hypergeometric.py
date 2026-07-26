"""Tests espejo de `forge_engine/test/hypergeometric_test.dart`."""
import pathlib
import sys
from math import comb

sys.path.insert(0, str(pathlib.Path(__file__).parent.parent))
from forge.hypergeometric import (
    hypergeom_pmf,
    hypergeom_at_least,
    p_land_drops,
    p_keepable_hand,
)


def test_pmf_exacta_contra_math_comb():
    # C(24,3)*C(36,4)/C(60,7) = 2024*58905/386206920
    assert abs(hypergeom_pmf(60, 24, 7, 3) - comb(24, 3) * comb(36, 4) / comb(60, 7)) < 1e-12
    assert abs(hypergeom_pmf(60, 24, 7, 3) - 0.3087) < 0.0001


def test_at_least_suma_la_cola():
    total = sum(hypergeom_pmf(60, 24, 7, k) for k in range(8))
    assert abs(total - 1.0) < 1e-9
    assert abs(hypergeom_at_least(60, 24, 7, 0) - 1.0) < 1e-9


def test_mano_keepable_24_60():
    p7 = hypergeom_at_least(60, 24, 7, 2) - hypergeom_at_least(60, 24, 7, 6)
    assert abs(p_keepable_hand(24, 60) - (p7 + (1 - p7) * p7)) < 1e-9


def test_p_land_drops_24_60_turno_3():
    assert abs(p_land_drops(24, 60, 3) - hypergeom_at_least(60, 24, 9, 3)) < 1e-12


def test_degenerados():
    assert hypergeom_at_least(60, 0, 7, 1) == 0.0
    assert abs(hypergeom_at_least(60, 60, 7, 7) - 1.0) < 1e-9
    assert hypergeom_pmf(60, 24, 7, 8) == 0.0  # k > draws
