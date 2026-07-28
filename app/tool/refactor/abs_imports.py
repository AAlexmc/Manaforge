#!/usr/bin/env python3
"""Convierte imports/exports relativos de lib/ y test/ a package:manaforge_app/."""
import re
from pathlib import Path

APP = Path(__file__).resolve().parents[2]  # tool/refactor/ -> app/
LIB = APP / 'lib'
PAT = re.compile(r"^(import|export)\s+'([^':]+)'", re.M)

def fix(f: Path) -> None:
    text = f.read_text(encoding='utf-8')

    def repl(m: re.Match) -> str:
        kind, target = m.group(1), m.group(2)
        resolved = (f.parent / target).resolve()
        try:
            rel = resolved.relative_to(LIB)
        except ValueError:
            return m.group(0)  # apunta fuera de lib/ (helpers de test): dejar
        return f"{kind} 'package:manaforge_app/{rel.as_posix()}'"

    out = PAT.sub(repl, text)
    if out != text:
        f.write_text(out, encoding='utf-8')
        print(f.relative_to(APP))

for d in (LIB, APP / 'test'):
    for f in sorted(d.rglob('*.dart')):
        if (LIB / 'l10n') in f.parents:  # generado: no tocar
            continue
        fix(f)
