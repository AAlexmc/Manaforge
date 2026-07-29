# Diseño · Tanda: copia de seguridad, escaneo fiable, OCR y "lo que me falta"

Fecha: 2026-07-21. Acordado con Ale en sesión.

Cuatro bloques, en este orden, **un PR por bloque**:

| Bloque | Qué | Por qué ahora |
|---|---|---|
| A | Copia de seguridad y restaurar | Hoy la colección vive en 12 JSON sin red. Un formateo y adiós |
| B | Escaneo: no duplicar + velocidad | Bug real: una carta quieta se cuenta muchas veces |
| C | OCR del número de coleccionista | Resuelve la edición exacta. Ventaja técnica sobre los escáneres comerciales |
| D | "Lo que me falta" con precio | Objetivo claro para completar sets; encaja con certificados |

**Fuera de alcance de esta tanda** (apuntado, no se hace): app Android (aparcada
por Ale hasta nuevo aviso), precio de compra y P&L, divisas, pestaña "Escanear"
propia, buylist, importar/exportar mazos.

---

## Estado de partida

- Rama `feat/carpetas-y-logros`, PR #4 abierto y CI verde, 334 tests.
- Once almacenes JSON en `~/.local/share/com.example.manaforge/`:
  `collection.json`, `folders.json`, `decks.json`, `achievements.json`,
  `wishlist.json`, `certificates.json`, `market.json`, `recents.json`,
  `value_history.json`, `price_history.jsonl`, `meta_decks.json`
  (`meta_decks.json` es caché descargable, no dato del usuario).
- Las bases `manaforge_cards.sqlite` y `manaforge_prices.sqlite` NO son dato del
  usuario: se descargan solas de las releases.

---

## Bloque A · Copia de seguridad y restaurar

### Qué se guarda

Un zip con extensión `.mfbak`, nombre `manaforge-YYYY-MM-DD-HHMM.mfbak`:

```
manifest.json          versión de formato, fecha ISO, versión de la app,
                       y recuento por almacén (cartas, mazos, carpetas,
                       logros, wishlist, certificados)
stores/collection.json
stores/folders.json
stores/decks.json
stores/achievements.json
stores/wishlist.json
stores/certificates.json
stores/market.json
stores/recents.json
stores/value_history.json
stores/price_history.jsonl
```

Las bases sqlite quedan **fuera** a propósito: son ~95 MB, se regeneran solas y
meterlas convertiría una copia de 200 KB en uno de casi 100 MB.

`meta_decks.json` queda fuera: es caché de red, no dato del usuario.

### Módulo

`lib/services/backup.dart`, lógica pura y testeable, sin UI:

- `Future<Uint8List> buildBackup(Directory dataDir)` — lee los almacenes que
  existan (los que falten simplemente no van) y devuelve el zip en memoria.
- `BackupManifest readManifest(Uint8List zip)` — valida y describe una copia sin
  aplicarla, para poder enseñar "283 cartas · 4 mazos · 12 carpetas · 21 jul"
  antes de que el usuario confirme.
- `Future<RestoreReport> restoreBackup(Uint8List zip, Directory dataDir)` —
  aplica la copia.

Dependencia nueva: `archive` (Dart puro; también sirve el día que haya Android).

### Cómo restaura sin poder romper nada

1. Validar el manifest **antes** de tocar disco. Manifest ausente, versión futura
   o zip corrupto → error claro y **no se escribe nada**.
2. Guardar el estado actual en `backups/pre-restore-<fecha>.mfbak`. Deshacer un
   restaurar equivocado es restaurar ese fichero.
3. Escribir cada almacén a `<nombre>.restore-tmp`, y solo cuando estén todos
   escritos, renombrar uno a uno. Un corte de luz a mitad deja los originales.
4. Un almacén que falte en la copia se **borra** del destino, no se conserva:
   restaurar significa "déjalo como estaba ese día", no fusionar.
5. Devolver un `RestoreReport` con lo aplicado, para poder enseñarlo.

### Auto-copia rotativa

Al arrancar, si la copia más reciente en `backups/` tiene más de 7 días, se hace
una en silencio. Se conservan las **5** últimas; las demás se borran. Es la red
que no depende de que nadie se acuerde de pulsar un botón.

### UI

- **Ajustes** (desde Inicio): "Copia de seguridad" → *Exportar copia* (diálogo de
  guardar de `file_selector`) y *Restaurar copia* (diálogo de abrir). Al elegir
  fichero se enseña el manifest y se pide confirmación explícita.
- **Pantalla de carga**: enlace "Restaurar copia", siempre visible. Es donde
  acabas cuando algo se ha roto, así que tiene que estar ahí y no dentro de la
  app que quizá no arranca bien.
- Tras restaurar: recargar los almacenes en memoria y volver a Inicio. Nada de
  pedir que se cierre y se abra la app a mano.

### Pruebas

- Ida y vuelta: colección con datos → exportar → borrar el directorio →
  restaurar → todo idéntico (comparación campo a campo, no solo recuentos).
- Zip corrupto, manifest ausente, versión futura → error y **directorio intacto**
  (se comprueba el disco, no solo el valor devuelto).
- Almacén ausente en la copia → se borra del destino.
- Rotación: con 7 copias, quedan 5 y son las más nuevas.
- Se crea el `pre-restore` antes de aplicar.

---

## Bloque B · Escaneo: no duplicar + velocidad

### El bug, ya localizado en el código

`PresenceGate.feed` pone `_movedSinceSettle = true` con **cualquier** movimiento:
una mano que pasa, una sombra, la autoexposición de la cámara. Cuando la escena
vuelve a asentarse, si el frame difiere del snapshot emite `cardChanged` **aunque
sea la misma carta**. La pantalla reconoce otra vez y `ScanTray.add` agrupa por
impresión → `qty++`.

Resultado: una carta quieta bajo la cámara durante un minuto se cuenta muchas
veces sin que nadie toque nada.

### La regla

**Nunca inferir copias.** El tiempo no cuenta copias. Solo dos cosas las cuentan:

1. **Mesa vacía de por medio** (prueba física: la carta se fue y volvió otra).
2. **El usuario pulsando `+`** (prueba humana).

Corolario asumido y correcto: si cambias una carta por **otra igual** sin que la
mesa quede vacía, se cuenta **una**. La cámara ve píxeles idénticos; no hay
prueba de que sean dos, y adivinar es justo lo que produce el ×7 de hoy.

Tabla de comportamiento acordada:

| Escenario | Hoy | Objetivo |
|---|---|---|
| Carta quieta una hora | ×7, ×20… | **1** |
| Quieta una hora, cambiada a mitad por otra igual | impredecible | **1** |
| Levantas y vuelves a poner la misma | 2 | **2** |
| La cambias por otra distinta sin vaciar la mesa | 2 | **2** |

### Los tres arreglos

1. **Memoria de identidad en la pantalla.** Se recuerda qué impresión hay ahora
   sobre la mesa. Si tras `cardChanged` el reconocimiento devuelve la **misma**
   impresión, no suma: solo refresca el pie. Solo `cardRemoved` borra esa
   memoria. Una impresión **distinta** sí suma: eso sí es prueba de cambio.
2. **Retirada con antirrebote.** Hacen falta **2** frames asentados seguidos por
   debajo del umbral de retirada para dar la carta por retirada. Una hora bajo la
   cámara da muchas oportunidades a un parpadeo de exposición, y un parpadeo que
   rearme la puerta cuenta una copia fantasma. Levantar una carta de verdad hunde
   la presencia mucho, así que sigue disparando en ~0,3-0,6 s.
3. **Contador `+`/`−` en la ficha de la bandeja.** Un toque, sin diálogo: "tengo
   cuatro iguales" son tres toques. Pulsación larga → teclado numérico. Es la vía
   rápida para montones de repetidas, mucho mejor que pasarlas una a una.

Además: la ficha marca **"en mesa"** mientras la carta sigue delante, para que se
vea que está bloqueada y que no va a sumar sola.

Se fija con un test que la línea base **no** se actualiza con carta presente (hoy
es así; que nadie lo rompa sin enterarse).

### Velocidad

Mejora ya identificada leyendo el código: **el JPEG se decodifica dos veces por
tick**. `presenceThumbFromJpeg` decodifica la imagen entera solo para sacar una
miniatura de 64×36, y después `processScanPhoto` la vuelve a decodificar. Se
decodifica una vez y se reparte.

Antes de tocar nada más (periodo del temporizador, número de intentos, frames de
asentamiento) se **instrumenta y se miden** tiempos reales por etapa. Sin números
no se optimiza: se rompe.

### Criterios de aceptación

- Unitarios de `PresenceGate` con frames sintéticos: deriva lenta de luz, sombra
  que cruza, mano que pasa → **cero eventos**.
- Unitarios de la memoria de identidad: `cardChanged` con la misma impresión no
  suma; con otra distinta sí.
- Prueba real con cámara: carta quieta **10 minutos** con registro de eventos →
  **1 copia y cero eventos espurios**. Si salen 2, no está arreglado.
- Las cuatro filas de la tabla, a mano y con Ale delante.
- Medición de velocidad antes y después, con números.

---

## Bloque C · OCR del número de coleccionista

### Enfoque: verificar, no leer

Nada de OCR abierto. El matching de arte ya devuelve el top-k de impresiones, y
de cada candidato se conoce su código de set y su número de coleccionista. Así
que el problema no es *leer* un texto desconocido, sino **decidir cuál de N
textos conocidos** encaja con esos píxeles. Es un problema mucho más fácil y
mucho más robusto, y resuelve exactamente lo que los escáneres comerciales admiten que no hacen:
variantes, promos y ediciones distintas con el mismo arte.

Cómo: recortar la franja inferior izquierda (el detector ya devuelve el
rectángulo de la carta), binarizar, y puntuar cada candidato contra el texto que
debería aparecer ahí.

Fase 2, opcional y solo si la 1 funciona: leer los dígitos de verdad (juego de
caracteres `0-9` y `/`) para los casos en que el arte no acota nada.

Trampa conocida: las cartas anteriores a 2015 no llevan número impreso. Ahí no
hay nada que verificar y se cae al comportamiento actual.

### Spike medido, con criterio para abortar

Antes de comprometerse: 20 fotos reales de Ale, con la edición correcta anotada a
mano. Medir aciertos de edición **con** y **sin** la verificación.

- Mejora clara → seguir y hacerlo bien.
- Sin mejora, o empeora → **se aborta**, se documenta por qué y se pasa al bloque
  D. No se gasta más.

---

## Bloque D · "Lo que me falta" con precio

En el álbum de una expansión: **"Me faltan N · XX €"** en el mercado elegido.

- Lista de las que faltan, ordenable por precio o por número de coleccionista.
- Total abajo, y un apartado "las 10 más baratas" para avanzar barato.
- Botón "mandar todas a la wishlist".
- Reusa `setCardsWithPrices`, que ya sabe de mercados.

Decisión de alcance: **"completo" = solo los números base del set**, con un
conmutador "incluir variantes y promos". Si contaran las variantes, ningún set se
completaría nunca y los certificados perderían sentido.

Providers sin precio por edición (Card Kingdom, Mana Pool) ya enseñan "sin precio
por edición"; aquí se comportan igual: la lista sale, el total dice que no se
puede calcular en ese mercado.

---

## Decisiones de carpetas (confirmadas por Ale el 2026-07-21)

| # | Decisión | Resultado |
|---|---|---|
| 1 | Una carta puede estar en varias carpetas | **Se mantiene**: carpetas = etiquetas |
| 2 | Carpeta ≠ mazo | **Se mantiene** |
| 3 | La carpeta guarda pertenencia; la cantidad la manda la colección | **Se mantiene** |
| 4 | Borrar de la colección NO la quita de las carpetas | **Cambia**: se quita (si no, quedan cartas fantasma) |

### Cascada al dejar de tener una carta (bloque propio, tras mergear el PR #4)

Dos acciones DISTINTAS y bien separadas en la UI. Confundirlas es lo que haría
que reorganizar carpetas te desmontara un mazo:

- **"Quitar de la carpeta"** → solo desetiqueta. La carta se sigue teniendo: no
  se toca ni el álbum ni ningún mazo. Es coherente con la decisión 3.
- **"Ya no tengo esta carta"** (borrar de la colección) → cascada:
  - sale de **todas** las carpetas;
  - su hueco en el álbum vuelve a vacío;
  - **los mazos NO pierden la carta**: se queda en la lista marcada como "ya no
    la tienes", y el mazo enseña arriba "te faltan N cartas". Vender un Sol Ring
    no puede deshacer un mazo que costó una tarde montar; y si de verdad se
    quiere fuera, se quita a mano desde el mazo.

---

## Bloque B · lo medido (2026-07-21)

**El bug, reproducido de verdad.** Con frames sintéticos con estructura (no
planos), la misma carta movida **un solo píxel** tras pasar una mano dispara
`cardChanged`, la pantalla re-reconoce y la bandeja suma otra copia. Corrección
a lo que se supuso al diseñar: la deriva de brillo por sí sola **no** lo
dispara; el disparador es que la carta se reasiente movida.

De ahí que el arreglo NO pueda estar en la puerta: mira píxeles, no cartas, y
"la misma carta movida" y "otra carta" le parecen lo mismo. Decide la identidad
de lo reconocido (`TableMemory`).

**Coste del tick de presencia**, medido con frames del tamaño real de la cámara
(1280×720, que es lo que pide el pipeline de GStreamer):

| etapa | ms |
|---|---|
| decodificar el JPEG | 75,0 |
| remuestrear a 64×36 (`average`, el actual) | 8,0 |
| remuestrear con `nearest` | 0,1 |
| muestreo directo a mano | 0,1 |
| **total por tick** | **~89** |

Conclusión incómoda: el remuestreo no es el problema, la decodificación sí, y
`package:image` no sabe decodificar JPEG a escala reducida. Cambiar a `nearest`
ahorraría 8 ms de 89 (9 %): no merece tocar código que funciona.

Las únicas vías reales, si algún día molesta:
1. **Segundo stream diminuto desde GStreamer** (un `tee` a 64×36 en crudo):
   cero decodificación por tick. Es la buena, pero es solo Linux y toca el
   pipeline de cámara.
2. Bajar el ritmo de muestreo (ya está a 300 ms).
3. Dejarlo: corre en un isolate, no bloquea la interfaz.

**Lo que sí se cambió**: los reintentos de reconocimiento esperaban 300 ms por
un frame fresco cuando el pipeline entrega uno cada ~100 ms. Con dos reintentos
eso eran ~600 ms perdidos en cada carta dudosa. Ahora esperan 120 ms en Linux.

**Lo que NO se tocó, a propósito**: `settleFrames` (2 frames = ~600 ms antes de
reconocer). Bajarlo aceleraría cada carta, pero arriesga reconocer una carta aún
en movimiento, y eso no se puede decidir sin medir aciertos con fotos reales.
