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
