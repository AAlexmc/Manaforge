# Changelog

Historial de cambios de la app ManaForge. Formato basado en
[Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/); las versiones
siguen [SemVer](https://semver.org/lang/es/) y cada una tiene su
[Release en GitHub](https://github.com/AAlexmc/Manaforge/releases) con
binarios (y sumas SHA-256 desde la 0.3.0).

## [Sin publicar]

### Cambiado
- `app/lib` reordenado a la estructura oficial de Flutter (UI por feature,
  datos por tipo): `ui/` + `domain/` + `data/{repositories,services}/` +
  `utils/` (#109). Ver `docs/arquitectura-app.md`.
- Flujos duplicados consolidados (cinco copias → una) y el total de Inicio
  marca `~` cuando hay cartas sin precio (#107).
- Volver a la selección tras forjar; el aviso de mazo borrado dura más y se
  puede cerrar, con colores accesibles en ambos temas (#108).

### Arreglado
- Rendimiento: álbum sin consultas O(n²), bandeja del escáner en lote,
  búsquedas con debounce y pool troceado con cachés (#106).

### Añadido
- El álbum avisa cuando el mercado elegido (Card Kingdom, Mana Pool) no
  publica precio por edición, en vez de mostrar "$0.00".
- Este CHANGELOG; `repository:` e `issue_tracker:` en `pubspec.yaml`.

## [0.3.0] — 2026-07-27

### Añadido
- **Escáner de cartas**: webcam o foto, reconoce la edición exacta por el
  arte, 100 % en el dispositivo.
- **Forge v2**: manabase probabilística, puntuación por consistencia y curva,
  temas tribales y reanimator, selector de estilo (24 tribus + temas
  mecánicos) y forja profunda (las propuestas juegan cientos de partidas
  entre sí antes de ordenarse).
- **10 idiomas** (las cadenas más nuevas caen al español) y nombres de carta
  en español en mazos, buscador y fichas.
- **Tours guiados**: vuelta completa en el primer arranque y guías por tema
  en el menú "?".
- **Precios y valor de colección**: valor total, joyas, P&L de compra,
  histórico de Cardmarket y mercado por expansión.
- **Apariencia**: fondo propio, colores de tarjetas/letra/pestañas/iconos con
  muestras guardadas y paleta de maná.
- Calidad de vida: reset de fábrica con doble freno, copias de seguridad,
  buzón de sugerencias y donativos desde Ajustes, ventana que recuerda su
  sitio y atajos de teclado.

### Cambiado
- Importar CSV pasa de minutos a segundos (índice + importación en lote).

### Seguridad
- Workflows con permisos mínimos, verificación SHA-256 de las bases de datos
  descargadas y `SECURITY.md` con aviso privado de vulnerabilidades.

## [0.2.0] — 2026-07-19

### Añadido
- Primera versión pública de escritorio (Windows/macOS/Linux): colección con
  base de datos de cartas de Scryfall (SQLite publicada como release), álbum
  por expansión, primera versión del generador de mazos (Forge) y pipeline de
  datos con releases mensuales.

[Sin publicar]: https://github.com/AAlexmc/Manaforge/compare/app-v0.3.0...HEAD
[0.3.0]: https://github.com/AAlexmc/Manaforge/compare/app-v0.2.0...app-v0.3.0
[0.2.0]: https://github.com/AAlexmc/Manaforge/releases/tag/app-v0.2.0
