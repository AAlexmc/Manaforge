# Reordenar `app/lib` a feature-first + capas — Plan de implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reordenar los 102 ficheros mezclados de `app/lib` (screens/ 28, services/ 50, widgets/ 22, theme/ 2) en la estructura oficial de Flutter (guía app-architecture / app Compass): `ui/<feature>/` + `ui/core/` + `data/{repositories,services}/` + `domain/` + `utils/`. Solo mover ficheros y arreglar imports — cero cambios de lógica.

**Architecture:** Capa UI organizada por feature (cada pantalla con sus widgets propios), capa data organizada por tipo (repositorios = fuente de verdad con estado; services = wrappers de IO/red/plugins/SQLite), `domain/` para lógica de negocio, `utils/` para transversales. `lib/scanner/` (motor de reconocimiento, 11 ficheros) y `lib/l10n/` (generado) NO se tocan: ya son módulos cohesionados. El dominio del forge ya vive en el paquete separado `forge_engine/` — esta reorganización completa esa misma idea para el resto.

**Tech Stack:** Flutter/Dart, paquete `manaforge_app`, sin gestor de estado externo (ChangeNotifier a pelo), tests con `flutter test` (978), lints con `flutter analyze` (warnings fatales, incluye `test/`).

## Global Constraints

- Solo `git mv` + reescritura de imports. NUNCA reescribir contenido de ficheros (excepto líneas `import`/`export` y el despiece del barrel en Tarea 7).
- NO renombrar ficheros ni clases. Mismo nombre, otra carpeta.
- NO tocar `lib/l10n/` (generado) ni `lib/scanner/` (módulo motor de escaneo).
- Imports SIEMPRE absolutos `package:manaforge_app/...` tras la Tarea 1.
- Antes de CADA commit: `flutter analyze` con exit 0 + `flutter test` todo verde (decidir por `$?`, no por grep).
- Commits SIN co-author de Claude (convención del repo).
- Todo en rama `estructura/feature-first`; PR al final, nunca commit directo a main.
- Directorio de trabajo de todos los comandos: `app/` salvo que se indique.

---

## Mapa completo de destinos

### `lib/theme/` (2)

| Fichero | Destino |
|---|---|
| mf_theme.dart | ui/core/themes/ |
| contrast.dart | ui/core/themes/ |

### `lib/widgets/` (22) — por consumidores reales (grep hecho 2026-07-28)

| Fichero | Destino | Evidencia |
|---|---|---|
| common.dart | ui/core/widgets/ | 17 pantallas |
| app_background.dart | ui/core/widgets/ | main |
| app_shortcuts.dart | ui/core/widgets/ | main + album + coleccion + ajustes |
| db_download.dart | ui/core/widgets/ | mercado + coleccion + ajustes |
| update_notice.dart | ui/core/widgets/ | home + ajustes |
| market_picker.dart | ui/core/widgets/ | set_market + mercado + card_detail (2 features) |
| price_chart.dart | ui/core/widgets/ | card_detail + wishlist + mercado (2 features) |
| whats_new_dialog.dart | ui/core/widgets/ | main |
| tour_overlay.dart | ui/core/tours/ | main + services/tours.dart |
| background_settings.dart | ui/settings/widgets/ | solo ajustes |
| language_settings.dart | ui/settings/widgets/ | solo ajustes |
| language_picker_dialog.dart | ui/settings/widgets/ | main (primer arranque) |
| folder_tile.dart | ui/collection/widgets/ | coleccion + folder_detail |
| folder_target.dart | ui/scan/widgets/ | scan_shared |
| scanner_db_gate.dart | ui/scan/widgets/ | scan + live_scan |
| session_tray.dart | ui/scan/widgets/ | live_scan |
| set_lock.dart | ui/scan/widgets/ | scan + scan_shared + live_scan |
| tray_list.dart | ui/scan/widgets/ | scan |
| version_picker.dart | ui/scan/widgets/ | scan_shared |
| set_picker.dart | ui/forge/widgets/ | forge |
| style_picker.dart | ui/forge/widgets/ | forge |
| pnl_view.dart | ui/market/widgets/ | mercado |

Regla aplicada: 2+ features distintas → `ui/core/widgets/`; 1 feature → widgets de esa feature.

### `lib/screens/` (28)

| Feature | Ficheros |
|---|---|
| ui/home/ | home_screen, editar_inicio_screen, startup_screen |
| ui/collection/ | coleccion_screen, album_screen, album_filters, all_cards_screen, collection_filters, card_detail_screen, folder_detail_screen, folder_pick_screen |
| ui/decks/ | mazos_screen, deck_detail_screen |
| ui/forge/ | forge_screen |
| ui/market/ | mercado_screen, set_market_screen, wishlist_screen |
| ui/scan/ | scan_screen, live_scan_screen, scan_shared, first_card_pick_screen, import_csv_screen |
| ui/achievements/ | logros_screen, certificados_screen |
| ui/settings/ | backup_screen, factory_reset_card, test_screen |
| (despiece) | screens.dart = barrel + `AjustesScreen` inline → Tarea 7 |

### `lib/services/` (50)

**→ `data/repositories/` (15)** — fuente de verdad con estado persistido (ChangeNotifier OK):
collection_store, deck_store, folder_store, wishlist_store, recents_store, achievement_store, certificate_store, value_history, background_prefs, home_layout_prefs, language_prefs, market_prefs, onboarding_prefs, window_prefs, window_memory

**→ `data/services/` (16)** — wrappers de IO/red/plugins/SQLite, sin estado de dominio:
card_database, price_series_database, scanner_database, json_store_io, markets, market_prices, price_history, meta_decks, app_update, download_check, startup_updates, backup, restore_reset, factory_reset, linux_camera, database_download_error

**→ `domain/` (13)** — lógica de negocio (cálculo de valor, logros, forja):
collection_value, collection_value_series, folder_value, pnl, collection_cascade, collection_sets, deck_shortfall, forge_job, achievements, achievement_snapshot, achievements_controller, certificates, card_names

**→ lógica de UI (3)** — importan l10n/widgets, van con su feature:
forge_texts → ui/forge/ · tours → ui/core/tours/ · whats_new → ui/core/

**→ `utils/` (3)** — transversales puros:
debouncer, serial_task, safe_input

Suma: 15+16+13+3+3 = 50 ✓

### Se quedan como están
`lib/scanner/` (11 — motor de escaneo, ya cohesionado; importa stores → anotado como deuda), `lib/l10n/` (12 — generado por l10n.yaml), `lib/main.dart`, `test/` entero (los tests usan `package:` imports; su ubicación no cambia nada — espejarlos es opcional futuro).

### Deuda anotada, NO tocar en este refactor
- `achievements.dart` y `safe_input.dart` importan `l10n` desde lógica (textos de error/logros localizados).
- `card_names.dart` importa `package:flutter/widgets.dart`.
- `lib/scanner/` importa `collection_store`/`folder_store`/`card_database` directamente.
- `screens.dart` barrel muere en Tarea 7; docs viejas en `docs/plans/` referencian rutas antiguas — son registros fechados, se dejan.

---

### Tarea 1: Rama + herramientas + imports absolutos

**Files:**
- Create: `app/tool/refactor/abs_imports.py`
- Create: `app/tool/refactor/move.sh`
- Modify: todos los `.dart` de `app/lib` (solo líneas import/export) — hoy hay 0 imports `package:manaforge_app` en lib y ~520 relativos.

**Interfaces:**
- Produces: todos los imports de proyecto en formato `package:manaforge_app/<ruta>`; `move.sh <vieja> <nueva>` como primitiva para el resto de tareas.

- [ ] **Paso 1: crear rama desde main actualizado**

```bash
cd /home/ale/Manaforge && git checkout main && git pull && git checkout -b estructura/feature-first
```

- [ ] **Paso 2: escribir `app/tool/refactor/abs_imports.py`**

```python
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
```

(El regex `[^':]+` deja pasar de largo `package:` y `dart:` porque llevan `:`. Conserva `as`/`show`/`hide` porque solo reescribe hasta la comilla de cierre. Fuera de l10n no hay directivas `part` — verificado.)

- [ ] **Paso 3: escribir `app/tool/refactor/move.sh`**

```bash
#!/usr/bin/env bash
# uso: tool/refactor/move.sh <ruta-vieja-bajo-lib> <ruta-nueva-bajo-lib>
set -euo pipefail
cd "$(dirname "$0")/../.."  # app/
old="$1"; new="$2"
mkdir -p "lib/$(dirname "$new")"
git mv "lib/$old" "lib/$new"
grep -rl --include='*.dart' "package:manaforge_app/$old" lib test \
  | xargs -r sed -i "s|package:manaforge_app/$old|package:manaforge_app/$new|g"
```

```bash
chmod +x app/tool/refactor/move.sh
```

(El sufijo `.dart` en el patrón hace cada reemplazo inequívoco — no hay colisiones de prefijo.)

- [ ] **Paso 4: ejecutar conversión**

```bash
cd /home/ale/Manaforge/app && python3 tool/refactor/abs_imports.py
```

Esperado: lista larga de ficheros tocados; ninguno bajo `lib/l10n/`.

- [ ] **Paso 5: verificar**

```bash
cd /home/ale/Manaforge/app && flutter analyze && flutter test
```

Esperado: analyze exit 0, 978 tests verdes. Si analyze falla, el script tiene un bug — arreglar script, `git checkout -- lib test` y repetir (árbol estaba limpio al empezar; NUNCA checkout con cambios propios sin backup).

- [ ] **Paso 6: commit**

```bash
cd /home/ale/Manaforge && git add app/tool/refactor app/lib app/test && git commit -m "refactor: imports absolutos package: en lib/ y test/"
```

### Tarea 2: `ui/core/` (theme + widgets compartidos + tours + novedades)

**Files:** Move: 2 theme + 9 widgets core + services/tours.dart + services/whats_new.dart

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
$M theme/mf_theme.dart            ui/core/themes/mf_theme.dart
$M theme/contrast.dart            ui/core/themes/contrast.dart
$M widgets/common.dart            ui/core/widgets/common.dart
$M widgets/app_background.dart    ui/core/widgets/app_background.dart
$M widgets/app_shortcuts.dart     ui/core/widgets/app_shortcuts.dart
$M widgets/db_download.dart       ui/core/widgets/db_download.dart
$M widgets/update_notice.dart     ui/core/widgets/update_notice.dart
$M widgets/market_picker.dart     ui/core/widgets/market_picker.dart
$M widgets/price_chart.dart       ui/core/widgets/price_chart.dart
$M widgets/whats_new_dialog.dart  ui/core/widgets/whats_new_dialog.dart
$M widgets/tour_overlay.dart      ui/core/tours/tour_overlay.dart
$M services/tours.dart            ui/core/tours/tours.dart
$M services/whats_new.dart        ui/core/whats_new.dart
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test` → exit 0 + 978 verdes.

- [ ] **Paso 3: commit** — `git add -A app && git commit -m "refactor: ui/core (themes, widgets compartidos, tours, novedades)"`

### Tarea 3: `ui/settings/` (pantallas + widgets de ajustes)

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
$M screens/backup_screen.dart           ui/settings/backup_screen.dart
$M screens/factory_reset_card.dart      ui/settings/factory_reset_card.dart
$M screens/test_screen.dart             ui/settings/test_screen.dart
$M widgets/background_settings.dart     ui/settings/widgets/background_settings.dart
$M widgets/language_settings.dart       ui/settings/widgets/language_settings.dart
$M widgets/language_picker_dialog.dart  ui/settings/widgets/language_picker_dialog.dart
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`.
- [ ] **Paso 3: commit** — `git commit -am "refactor: ui/settings"`

### Tarea 4: `ui/home/` + `ui/collection/`

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
$M screens/home_screen.dart          ui/home/home_screen.dart
$M screens/editar_inicio_screen.dart ui/home/editar_inicio_screen.dart
$M screens/startup_screen.dart       ui/home/startup_screen.dart
$M screens/coleccion_screen.dart     ui/collection/coleccion_screen.dart
$M screens/album_screen.dart         ui/collection/album_screen.dart
$M screens/album_filters.dart        ui/collection/album_filters.dart
$M screens/all_cards_screen.dart     ui/collection/all_cards_screen.dart
$M screens/collection_filters.dart   ui/collection/collection_filters.dart
$M screens/card_detail_screen.dart   ui/collection/card_detail_screen.dart
$M screens/folder_detail_screen.dart ui/collection/folder_detail_screen.dart
$M screens/folder_pick_screen.dart   ui/collection/folder_pick_screen.dart
$M widgets/folder_tile.dart          ui/collection/widgets/folder_tile.dart
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`.
- [ ] **Paso 3: commit** — `git commit -am "refactor: ui/home y ui/collection"`

### Tarea 5: `ui/decks/` + `ui/forge/` + `ui/market/`

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
$M screens/mazos_screen.dart       ui/decks/mazos_screen.dart
$M screens/deck_detail_screen.dart ui/decks/deck_detail_screen.dart
$M screens/forge_screen.dart       ui/forge/forge_screen.dart
$M widgets/set_picker.dart         ui/forge/widgets/set_picker.dart
$M widgets/style_picker.dart       ui/forge/widgets/style_picker.dart
$M services/forge_texts.dart       ui/forge/forge_texts.dart
$M screens/mercado_screen.dart     ui/market/mercado_screen.dart
$M screens/set_market_screen.dart  ui/market/set_market_screen.dart
$M screens/wishlist_screen.dart    ui/market/wishlist_screen.dart
$M widgets/pnl_view.dart           ui/market/widgets/pnl_view.dart
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`.
- [ ] **Paso 3: commit** — `git commit -am "refactor: ui/decks, ui/forge y ui/market"`

### Tarea 6: `ui/scan/` + `ui/achievements/`

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
$M screens/scan_screen.dart            ui/scan/scan_screen.dart
$M screens/live_scan_screen.dart       ui/scan/live_scan_screen.dart
$M screens/scan_shared.dart            ui/scan/scan_shared.dart
$M screens/first_card_pick_screen.dart ui/scan/first_card_pick_screen.dart
$M screens/import_csv_screen.dart      ui/scan/import_csv_screen.dart
$M widgets/folder_target.dart          ui/scan/widgets/folder_target.dart
$M widgets/scanner_db_gate.dart        ui/scan/widgets/scanner_db_gate.dart
$M widgets/session_tray.dart           ui/scan/widgets/session_tray.dart
$M widgets/set_lock.dart               ui/scan/widgets/set_lock.dart
$M widgets/tray_list.dart              ui/scan/widgets/tray_list.dart
$M widgets/version_picker.dart         ui/scan/widgets/version_picker.dart
$M screens/logros_screen.dart          ui/achievements/logros_screen.dart
$M screens/certificados_screen.dart    ui/achievements/certificados_screen.dart
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`. `lib/widgets/` debe quedar vacío ya (`ls lib/widgets` → nada).
- [ ] **Paso 3: commit** — `git commit -am "refactor: ui/scan y ui/achievements"`

### Tarea 7: despiece del barrel `screens.dart` → `ui/settings/ajustes_screen.dart`

`screens.dart` (482 líneas) = `AjustesScreen` + ~25 líneas `export`. Consumidores del barrel: `lib/main.dart` + 3 tests (`tour_datos_foco_test`, `ajustes_tour_targets_test`, `ajustes_secciones_test`).

- [ ] **Paso 1: mover el fichero** — `tool/refactor/move.sh screens/screens.dart ui/settings/ajustes_screen.dart` (deja `lib/screens/` vacío y actualiza los 4 consumidores al path nuevo).
- [ ] **Paso 2: borrar las líneas `export 'package:manaforge_app/...'` de `ui/settings/ajustes_screen.dart`** (solo las de export; el resto intacto).
- [ ] **Paso 3: `flutter analyze`** — dará símbolos sin resolver en `main.dart` y los 3 tests (los que llegaban por re-export). Por cada símbolo, añadir el import directo `package:manaforge_app/ui/<feature>/<pantalla>.dart` que toque. Repetir analyze hasta exit 0.
- [ ] **Paso 4: verificar** — `flutter test` completo verde. `lib/screens/` y `lib/widgets/` y `lib/theme/` ya no existen.
- [ ] **Paso 5: commit** — `git commit -am "refactor: despiezar barrel screens.dart; AjustesScreen a ui/settings"`

### Tarea 8: `data/repositories/` (15)

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
for f in collection_store deck_store folder_store wishlist_store recents_store \
         achievement_store certificate_store value_history background_prefs \
         home_layout_prefs language_prefs market_prefs onboarding_prefs \
         window_prefs window_memory; do
  $M services/$f.dart data/repositories/$f.dart
done
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`.
- [ ] **Paso 3: commit** — `git commit -am "refactor: data/repositories (stores y prefs)"`

### Tarea 9: `data/services/` (16)

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
for f in card_database price_series_database scanner_database json_store_io \
         markets market_prices price_history meta_decks app_update download_check \
         startup_updates backup restore_reset factory_reset linux_camera \
         database_download_error; do
  $M services/$f.dart data/services/$f.dart
done
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`.
- [ ] **Paso 3: commit** — `git commit -am "refactor: data/services (IO, red, plugins, SQLite)"`

### Tarea 10: `domain/` (13) + `utils/` (3)

- [ ] **Paso 1: mover**

```bash
cd /home/ale/Manaforge/app
M=tool/refactor/move.sh
for f in collection_value collection_value_series folder_value pnl \
         collection_cascade collection_sets deck_shortfall forge_job \
         achievements achievement_snapshot achievements_controller \
         certificates card_names; do
  $M services/$f.dart domain/$f.dart
done
for f in debouncer serial_task safe_input; do
  $M services/$f.dart utils/$f.dart
done
```

- [ ] **Paso 2: verificar** — `flutter analyze && flutter test`. `lib/services/` ya no existe. Árbol final de `lib/`: `data/ domain/ l10n/ scanner/ ui/ utils/ main.dart`.
- [ ] **Paso 3: commit** — `git commit -am "refactor: domain y utils; adios lib/services"`

### Tarea 11: documentar arquitectura + verificación final

**Files:** Create: `docs/arquitectura-app.md`

- [ ] **Paso 1: escribir `docs/arquitectura-app.md`**

```markdown
# Arquitectura de `app/lib`

Estructura según la [guía oficial de arquitectura de Flutter](https://docs.flutter.dev/app-architecture)
(app de referencia "Compass"): UI por feature, datos por tipo.

    lib/
    ├── ui/            capa de presentación, una carpeta por feature
    │   ├── core/      tema, widgets usados por 2+ features, sistema de tours
    │   ├── home/ collection/ decks/ forge/ market/ scan/ achievements/ settings/
    │   │              cada una: pantallas + widgets/ propios + textos de UI
    ├── domain/        lógica de negocio: valor de colección, P&L, logros, forja
    ├── data/
    │   ├── repositories/  fuente de verdad con estado persistido (stores, prefs)
    │   └── services/      IO puro: SQLite, red (Scryfall/precios), plugins, backup
    ├── scanner/       motor de reconocimiento de cartas (módulo cohesionado, ver
    │                  docs/reconocimiento-cartas.md)
    ├── utils/         transversales puros (debouncer, serial_task, safe_input)
    └── l10n/          generado (l10n.yaml) — no editar a mano

Reglas:
- `ui/` puede importar `domain/`, `data/` y `utils/`. `data/` no importa `ui/`.
- Widget usado por una sola feature vive en `ui/<feature>/widgets/`; por 2+, en `ui/core/widgets/`.
- Imports siempre absolutos `package:manaforge_app/...`.
- La lógica del generador de mazos vive en el paquete aparte `forge_engine/`.

Deuda conocida (consciente, no urgente): `domain/achievements.dart` y
`utils/safe_input.dart` importan l10n; `scanner/` importa stores directamente.
```

- [ ] **Paso 2: verificación final completa**

```bash
cd /home/ale/Manaforge/app && flutter analyze && flutter test && flutter build linux --release
```

Esperado: exit 0 en los tres. (El build atrapa roturas que los tests no cubren, p. ej. main.dart.)

- [ ] **Paso 3: commit** — `git add docs/arquitectura-app.md && git commit -m "docs: arquitectura de app/lib"`

### Tarea 12: PR y merge

- [ ] **Paso 1: push** — `git push -u origin estructura/feature-first` (el hook pre-push ejecuta tests).
- [ ] **Paso 2: abrir PR** — `gh pr create --title "Reordenar lib: feature-first + capas (guía oficial Flutter)" --body "..."` — cuerpo: motivación (feedback senior), árbol antes/después, 'solo git mv + imports, cero lógica', enlace a `docs/arquitectura-app.md` y a este plan.
- [ ] **Paso 3: CI** — `gh pr checks --watch`; decidir por estado real, no por suposición.
- [ ] **Paso 4: merge** — squash (rama no apilada), lo ejecuta Claude. Tras merge: `git checkout main && git pull`.

---

## Riesgos y por qué es seguro

- **git detecta renombres** aunque `git mv` no fuera especial — pero usarlo mantiene el índice limpio en cada paso.
- **Los tests no dependen de la ubicación de los fuentes** (importan por `package:`), así que la suite entera es el oráculo tras cada tarea.
- **Rollback por tarea**: cada tarea es un commit; `git revert <sha>` deshace una sin tocar el resto.
- **El sed de move.sh es inequívoco**: patrón completo con `.dart`, sin colisiones de prefijo entre los 102 ficheros (verificado contra la lista).
- Si un test fija rutas de fichero fuente (improbable), fallará en la tarea correspondiente y se arregla ahí mismo, no al final.
