"""Iterar las cartas de un bulk de Scryfall sin cargarlo entero en RAM.

Scryfall sirvió los bulks como UN array JSON gigante hasta julio de 2026;
ahora los publica solo en JSONL (un objeto por línea, `jsonl_download_uri`).
Aquí se aceptan los dos formatos mirando el primer byte no blanco, así los
fixtures viejos y cualquier bulk descargado a mano siguen funcionando.

Funciona sobre cualquier file-like binario SIN seek (stdin de un pipe de
curl incluido): el byte ya consumido se antepone de vuelta con _Prepend.
"""
from __future__ import annotations

import json


class _Prepend:
    """File-like que devuelve `head` antes de seguir leyendo de `f`."""

    def __init__(self, head: bytes, f):
        self._head = head
        self._f = f

    def read(self, n: int = -1):
        if n == 0:
            # ijson sondea con read(0) para saber si el stream da bytes o
            # str; devolver aquí el byte guardado lo perdería en la sonda
            return b""
        if self._head:
            head, self._head = self._head, b""
            if n is None or n < 0:
                return head + self._f.read(n)
            return head + self._f.read(max(0, n - len(head)))
        return self._f.read(n)


def iter_bulk_objects(f):
    """Objetos carta de `f` (binario): array JSON clásico o JSONL."""
    first = f.read(1)
    while first and first.isspace():
        first = f.read(1)
    if not first:
        return
    if first == b"\x1f":
        # Scryfall sirve el JSONL como .gz de verdad (contenido gzip, no
        # Content-Encoding): descomprimir al vuelo, sirve también en un pipe
        import gzip
        yield from iter_bulk_objects(gzip.GzipFile(fileobj=_Prepend(first, f)))
        return
    if first == b"[":
        try:
            import ijson  # type: ignore
        except ImportError:
            # sin ijson solo caben ficheros pequeños (fixtures de test)
            yield from json.loads(first + f.read())
            return
        yield from ijson.items(_Prepend(first, f), "item")
        return
    # JSONL: la primera línea ya está empezada
    line = first + (f.readline() or b"")
    while line:
        stripped = line.strip()
        if stripped:
            yield json.loads(stripped)
        line = f.readline()
