# Colores de Apariencia — diseño (2026-07-25)

Pedido expreso de Ale (25-07): (1) guardar el color personalizado como muestra
reutilizable con anillo distinto y opción de eliminar; (2) los presets de
`kCardColors` también en pestañas e iconos; (3) más presets con estética Magic
(cinco maná, oro, incoloro). Decisiones de detalle en modo auto (Ale delegó).

## 1. Muestras guardadas (custom como muestra)

- **Una lista ÚNICA compartida** de muestras guardadas para las cuatro filas
  (tarjetas, letra, pestañas, iconos): es "tu paleta", no una por campo.
- Persistencia en `background.json`: `swatchesHex: ['#RRGGBB', ...]`, cada
  entrada validada con `_parseHex` al leer (fichero manipulado → se descarta la
  entrada). **Tope 8**; al añadir la novena cae la más vieja. Duplicados no se
  re-añaden.
- API en `BackgroundPreference`: `List<Color> get savedSwatches` (inmutable),
  `Future<void> addSwatch(Color)`, `Future<void> removeSwatch(Color)`.
- UI en `_Muestras`: las muestras guardadas se pintan tras los presets y antes
  del círculo custom, con **anillo exterior de otro color** (el `tertiary` del
  tema) para distinguirlas. Tap = aplicar (por el mismo camino que el custom).
  **Pulsación larga = eliminar**, con confirmación ligera (diálogo simple).
- Guardar: en el diálogo del color picker (`_elegirColor`) aparece una acción
  extra **"Guardar como muestra"** que aplica el color Y lo añade a la lista.
- `resetAll()` (reset de fábrica) también vacía las muestras.

## 2. Presets en pestañas e iconos

- `chipColor`/`iconColor` siguen guardándose por HEX (sin migración): los
  presets son atajos que rellenan ese hex.
- En la UI, sus `_Muestras` reciben `kCardColors` como paleta;
  `elegido` se calcula por igualdad de color (preset cuyo color == el hex
  guardado), y elegir un preset llama `setChipColor(color)` /
  `setIconColor(color)`. "El de siempre" sigue siendo null.
- La guarda de contraste existente (`toneLegible`, PR #80/#51) ya ajusta sola
  los colores ilegibles; no se toca.

## 3. Presets Magic nuevos (en `kCardColors`)

Se añaden al final (el JSON guarda por nombre → retrocompatible); ids ASCII:

| id | color | qué es |
|---|---|---|
| `isla` | `0xFF16324F` | azul isla |
| `pantano` | `0xFF191320` | negro pantano (morado muy oscuro) |
| `montana` | `0xFF381713` | rojo montaña |
| `oro` | `0xFF3A2E12` | oro/multicolor |
| `incoloro` | `0xFF26262B` | incoloro/artefacto |

(`hueso` ya hace de blanco llanura y `bosque` de verde bosque.) Sirven a la
vez para tarjetas y, por el punto 2, para pestañas/iconos.

## i18n

Claves nuevas solo es+en (resto cae al español): `bgSaveSwatch` ("Guardar como
muestra"), `bgSwatchTip` (tooltip muestra guardada), `bgSwatchDeleteTitle` /
`bgSwatchDeleteBody` (confirmación de borrado) y `acDelete` si no existe ya.

## Tests

- Prefs (disco real): roundtrip de `swatchesHex`; tope 8 con la más vieja
  fuera; duplicado no se re-añade; entrada no-hex en el JSON se descarta;
  `removeSwatch` persiste; `resetAll` las vacía.
- Widget: la muestra guardada aparece con su anillo; tap aplica; pulsación
  larga + confirmar la quita; los presets salen ahora en las filas de pestañas
  e iconos y elegir uno marca el círculo.
- Paleta: ids nuevos presentes y sin duplicados en `kCardColors`.
