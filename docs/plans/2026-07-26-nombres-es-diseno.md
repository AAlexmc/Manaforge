# Nombres de carta en español — diseño (2026-07-26)

Pedido de Ale (con captura): UI en español pero la lista del mazo enseña «Ornithopter,
Murder…» en inglés. Activa la «opción futura acotada» de la decisión del 24-07 (nombres
en inglés): añadir SOLO español, sin bulk completo en la app ni DB ×5-7.

## Alcance
- SÍ: nombres de carta en español en superficies de LECTURA cuando la UI está en es —
  detalle de mazo, listas de propuestas de Forge, Modo Test — y la búsqueda encuentra
  por nombre español universal (no solo si posees la impresión es).
- NO: exportar/copiar mazos (siempre inglés — Moxfield/Arena lo esperan), nombres de
  expansión, otros 8 idiomas (mismo mecanismo serviría; YAGNI), oracle text.
- Motor Forge intacto: las claves de pool/mazo siguen siendo el nombre inglés. Cambio
  SOLO de presentación.

## Datos (schema v5)
- `cards.name_es TEXT` (nivel Oracle, 1 por carta) + índice. Coste ~<1 MB sobre 34.745
  cartas. `meta.schema_version = '5'`.
- Fuente: bulk **All Cards** de Scryfall en CI — pasada de enriquecimiento tras el build
  con Default Cards: para cada objeto `lang == "es"` con `printed_name`, primer
  `printed_name` visto por `oracle_id`.
- CI sin comerse el disco del runner: `curl --compressed <all_cards_uri> | python3
  scripts/enrich_names_es.py <db>` — ijson en streaming sobre stdin, cero JSON en disco.
- Script nuevo `scripts/enrich_names_es.py` (idempotente: ALTER TABLE IF missing +
  UPDATE), tests con mini-bulk fixture en scripts/tests.
- `.github/workflows/build-card-db.yml`: paso nuevo tras construir la DB (token ya tiene
  scope workflow).

## App
- `CardDatabase`: exponer `nameEs` en los structs de resultados (junto a printedName).
  Lectura tolerante: si la columna no existe (DB v4 del usuario) → null, cero errores.
  Patrón existente: «funciones que piden datos recientes» → el usuario re-descarga la
  base cuando quiera los nombres.
- Helper único de presentación (services): `String cardDisplayName({required String
  name, String? nameEs, required Locale locale})` → es + nameEs≠null → nameEs, si no
  name. TODAS las superficies pasan por él (un sitio que arreglar).
- Búsqueda: `WHERE c.name LIKE ?1 OR p.printed_name LIKE ?1 OR c.name_es LIKE ?1`
  (si v5).
- Superficies de esta tanda: deck_detail_screen (lista, tierras, pies del banner y
  zoom — la del pantallazo), buscador (filas + snackbar; OJO printed_name nunca es
  NULL en la DB publicada, el helper envuelve `printedName ?? name`), ficha de carta
  (título, cuerpo, zoom y placeholder — `CardFullDetail.nameEs`). Forge/Modo Test
  desembocan en el detalle de mazo.
- Búsqueda con tildes/mayúsculas: el LIKE de SQLite solo pliega ASCII, así que hay
  columna `name_es_fold` (minúsculas, sin diacríticos, calculada en el script) y la
  app pliega la query igual (`foldForSearch`, espejo del `_fold` Python) —
  «ornitoptero», «ORNITÓPTERO» y «señor/senor» encuentran.
- Robustez CI: el paso de nombres lleva `continue-on-error` (un hipo de Scryfall en
  los 2,9 GB no puede comerse la release diaria de precios — la app degrada a inglés)
  y el script `--min=20000` (suelo de cordura, medido real ~29k: un bulk vacío o con
  forma cambiada aborta en vez de publicar una «v5» hueca; el bump a v5 además es
  condicional a que haya nombres).

## Tests
- Python: fixture mini-bulk con 2 cartas es + 1 en → enrich pone name_es, idempotente.
- Dart/Flutter: DB fixture v5 con name_es → detalle de mazo en es enseña «Ornitóptero»;
  DB v4 sin columna → inglés sin reventar; búsqueda «Ornitóptero» encuentra; export
  copia SIEMPRE inglés (test que lo blinda).

## Validación
- HECHA (2026-07-26, pre-implementación): streaming del all_cards real (2,9 GB,
  535.598 objetos) → **29.003 oracle_ids con printed_name es ≈ 83% de las ~34.745
  cartas de la DB**. Ejemplos: «Señor de los muertos vivientes», «Anfibio prodigio».
  El ~17% restante nunca se imprimió en español → fallback inglés, esperado.
- El pipe curl→python en streaming funciona (mismo mecanismo que usará CI, cero
  JSON en disco).
- CI: disparar build-card-db manual tras merge → release DB nueva → Ale re-descarga la
  base desde Ajustes y ve los nombres.

## Orden de obra (1 PR, 3 commits)
1. Script enrich + tests py + workflow.
2. Schema v5 read-path + helper + tests dart.
3. Superficies UI + tests widget.
