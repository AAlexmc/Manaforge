# Inicio editable + Ajustes en secciones desplegables

Fecha: 2026-07-23. Autor: sesión de trabajo con Ale (modo auto).
Base: `main` = `c2f9429`, 690 tests app + 29 engine, analyze limpio.

Ale pidió tres cosas, en una: **el inicio con distintos tipos de mosaicos y
editable** (elegir qué se ve y en qué orden), y **Ajustes en desplegables**
(secciones ordenadas en vez de una lista larga de tarjetas). "Sobra la
configuración" = la pantalla de Ajustes está cargada; hay que ordenarla.

## Alcance (y lo que NO)

- SÍ: reordenar y encender/apagar las secciones del Inicio; un tipo de mosaico
  nuevo (rejilla de estadísticas); Ajustes agrupado en desplegables.
- NO: publicar la v0.3.0 (pendiente de validación a mano de ventana/colores, es
  decisión de Ale). NO tocar el fondo/colores ni la ventana. NO traducir (la
  cola de ~410 cadenas sigue aparte). Los textos nuevos van **en español a
  pelo**, como los vecinos de `screens.dart` (`'Base de datos de cartas'`, etc.),
  y se apuntan a la misma deuda de traducción.

## 1 · Inicio editable

### Servicio `home_layout_prefs.dart` (`HomeLayoutPreference`)

`ChangeNotifier` calcado a `background_prefs`/`language_prefs`:

- Catálogo `kHomeSections`: lista `const` de secciones con `id` y orden por
  defecto. Ids: `nivel`, `accesos`, `resumen` (NUEVO), `recientes`, `mazos`,
  `meta`, `expansiones`, `joyas`. El **héroe** (valor de la colección /
  bienvenida) y la cabecera NO entran: son el ancla de la pantalla y el camino
  de primer uso.
- Persiste `home_layout.json`: `{ "orden": [ids...], "ocultas": [ids...] }`.
  Se guarda el **orden** y el conjunto de **ocultas** por id (nombre, no
  índice), validados contra `kHomeSections`: un id que no existe se ignora, y un
  id conocido que falta en el fichero se **añade al final** en su orden por
  defecto (así una versión nueva con una sección nueva la enseña sin que el
  usuario tenga que tocar nada).
- API: `List<String> get ordenVisible` (ids en orden del usuario, sin ocultas);
  `List<HomeSectionState> get todas` (para el editor: id + visible, en orden);
  `Future<void> toggle(String id)`; `Future<void> reordenar(int desde, int
  hasta)`; `Future<void> restablecer()`.
- `load()` comparte el futuro (no un `bool` puesto antes de leer). Cola de
  guardado que **nace en la primera escritura**, no en un campo (la trampa del
  reloj falso de `testWidgets`, ver `language_prefs.dart`). Write atómico por
  `writeJsonFile`. Cualquier fallo de disco no tumba la app.

### Mosaico nuevo: `resumen` (rejilla de estadísticas)

Un tipo de mosaico distinto de las tiras: una rejilla de celdas con cartas
totales, distintas, valor, nº de mazos y logros. Da variedad real ("distintos
tipos de mosaicos") sin datos nuevos: todo sale de `collection`, `decks`,
`achievements`. Se autooculta si no hay colección.

### Editor `EditarInicioScreen`

`ReorderableListView` con las secciones de `todas`: asa para arrastrar +
`Switch` por fila + botón "Restablecer". Vive en su propia ruta (acción algo
destructiva del orden: fuera de la pantalla principal). Se llega desde:

- Inicio: icono de ajustes (tune) en la fila de la cabecera.
- Ajustes → Apariencia → "Editar inicio".

Ambas vistas leen el mismo `HomeLayoutPreference`; como el Inicio envuelve su
lista en un `ListenableBuilder`, editar desde Ajustes se refleja en vivo.

### Cableado

- `HomeLayoutPreference` se crea en `_HomeShellState` (como `_market`), se
  `load()`ea y se pasa a `HomeScreen` y a `AjustesScreen`.
- `HomeScreen.layout` es **opcional**: si es `null`, un layout por defecto en
  memoria enseña todo. Así `primer_uso_test` y demás siguen montando `HomeScreen`
  sin tocarlos.
- `HomeScreen.build` itera `layout.ordenVisible` y mapea id→builder. Cada tira
  sigue autoocultándose si no tiene datos (recientes vacío = nada), aparte del
  interruptor. El interruptor = "no la quiero ni con datos".

## 2 · Ajustes en secciones desplegables

Refactor de `AjustesScreen`: de `ListView` de tarjetas a grupos `ExpansionTile`.
Se **reutilizan** las tarjetas existentes (`LanguageSettingsCard`,
`BackgroundSettingsCard`, `UpdateSettingsCard`, `BackupCard`, la de "cómo
funciona", la de la base de datos). Grupos, en orden:

1. **Apariencia** — Idioma · Fondo y colores · **Editar inicio** (entrada
   nueva). `initiallyExpanded: true`.
2. **Datos** — Base de datos de cartas · Copia de seguridad.
3. **La app** — Cómo funciona y atajos · Novedades/actualización · Atribución.

Helper `_Seccion` (envoltorio `ExpansionTile` con estilo común). Sin persistir el
estado expandido (fuera de alcance): `initiallyExpanded` estático en Apariencia.

## Pruebas (TDD)

- `home_layout_prefs_test.dart`: defaults; toggle persiste; reordenar persiste;
  id desconocido ignorado; id conocido que falta se añade al final; fichero roto
  → defaults; `ordenVisible` respeta orden y ocultas.
- `editar_inicio_test.dart` (widget, `appDePrueba`): salen todas; apagar una la
  marca oculta; reordenar cambia el orden.
- `inicio_editable_test.dart` (widget): con una sección oculta, su título no sale
  en Inicio; el mosaico `resumen` sale con colección y no sin ella.
- `ajustes_secciones_test.dart` (widget): salen las cabeceras de sección;
  desplegar Apariencia enseña el selector de idioma; existe "Editar inicio".

## Entrega

Una rama `feat/inicio-editable-y-ajustes`, un PR, dos commits lógicos
(inicio-editable, luego ajustes-desplegables que enlaza a Editar inicio).
Reviewer + tester al final; merge solo si ambos OK. Commits **sin** co-author
(convención del repo). No lanzar la app.
