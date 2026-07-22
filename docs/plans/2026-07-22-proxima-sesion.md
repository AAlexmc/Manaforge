# ManaForge · dónde retomar (nota del 2026-07-21, noche)

## Estado

`main` = `7ba681d`. Mergeados hoy: **PR #4** (carpetas, logros, certificados,
mercado multi-proveedor), **PR #5** (certificado de bienvenida + carta con la
que empezaste, curva real del valor, más logros) y **PR #6** (copia de
seguridad y restaurar).

**PR #7 abierto** (`feat/escaneo-sin-duplicados`): escaneo sin duplicados +
contador ±N. CI verde, 414 tests. **NO mergear todavía**: tiene un fallo
encontrado a mano (abajo).

Validado a mano con la colección real de Ale (283 cartas): certificados,
mercado, y la copia de seguridad (restaurar dejó `collection.json` **idéntico
byte a byte**, md5 `8961136425ba27ffe122fea6efe6c525`).

## LO PRIMERO: arreglar el PR #7

**Síntoma (visto por Ale con la cámara real):** escanea una carta, sale bien en
la bandeja, **borra la ficha con la X**, quita la carta y vuelve a poner LA
MISMA. La reconoce ("Viendo: Shipwreck Moray") pero **no la vuelve a añadir**.

**Causa, ya localizada:** `TableMemory` (`lib/scanner/table_memory.dart`) solo
olvida lo que hay en la mesa tras `emptyTicksToForget = 3` ticks seguidos con
la mesa vacía — unos 0,9 s de mesa quieta y vacía, encima DESPUÉS de que la
puerta necesite sus 2 frames de asentamiento. Levantar y volver a poner rápido
no llega. Y borrar la ficha de la bandeja no toca la memoria, así que la carta
queda bloqueada para siempre.

**Autocrítica:** ese guardián de 3 ticks se puso para protegerse de un falso
`cardRemoved` (una mano tapando quieta) **que nunca se llegó a reproducir**. El
×7 venía de `cardChanged`, no de la retirada. Se protegió un fantasma y se
rompió el flujo normal.

**Arreglo (tres cosas):**
1. Olvidar la carta de la mesa en cuanto la puerta emita `cardRemoved`: ya
   exige escena asentada y presencia por debajo del umbral, es prueba
   suficiente. En la práctica, `emptyTicksToForget: 1`.
2. Borrar una ficha (`onRemove`) o vaciar la bandeja (`onClear`) tiene que
   limpiar la memoria de esa impresión: el usuario ha dicho explícitamente que
   no la quiere, y volver a pasarla es una acción deliberada.
3. El pie de la pantalla debe decir POR QUÉ no suma: "ya está en la mesa" en
   vez de solo "Viendo: X", que parece que se ha colgado.
4. Test de regresión que cubra justo esto: contar → borrar ficha → retirar →
   volver a poner la misma → **cuenta otra vez**.

## Siguiente: guardar el escaneo en una carpeta

Pedido por Ale. Hoy la bandeja solo tiene "Añadir N a la colección".

- El botón pasa a ofrecer también **carpeta de destino**, y **crear carpeta
  nueva** ahí mismo si no hay ninguna (o si quieres una nueva).
- Ojo al contrato ya decidido: las carpetas guardan **solo pertenencia**, la
  cantidad la manda la colección. Así que la carpeta **no es un destino
  alternativo**: las cartas entran en la colección igual y ADEMÁS se etiquetan.
- Piezas que ya existen y hay que reusar, no reinventar: `folder_store.dart`,
  `folder_pick_screen.dart`, `FolderPickScreen`.

## Luego (orden acordado)

1. **Bloque C · OCR del número de coleccionista.** Enfoque decidido: NO OCR
   abierto, sino **verificar por plantilla contra los candidatos** que ya
   devuelve el matching de arte (de cada uno se sabe set y número, así que es
   elegir entre N textos conocidos, no leer uno desconocido). **Spike medido
   primero**: 20 fotos reales con la edición correcta anotada; si no mejora la
   elección de edición, se aborta y se documenta.
2. **Bloque D · "Lo que me falta" con precio** en el álbum de expansión.
   "Completo" = solo números base, con conmutador para variantes/promos.
3. **Cascada de borrado** (decisión 4 de carpetas, confirmada): "quitar de la
   carpeta" solo desetiqueta; "ya no tengo esta carta" saca de todas las
   carpetas, vacía el hueco del álbum, y los mazos **conservan** la carta
   marcada "ya no la tienes" con aviso "te faltan N cartas".
4. **Precio de compra y P&L** (el CSV de ManaBox trae `Purchase price` y se
   está tirando).

Aparcado hasta nuevo aviso: **app de Android**. Decidido que NO: conversión de
divisas.

## Deuda que muerde

**`app/linux/` está sin trackear en git** (también `pubspec.lock` y
`.metadata`). Descubierto porque un worktree nuevo no compilaba: `Error: No
Linux desktop project configured`. Significa que **quien clone el repo no puede
compilar la app de escritorio** — y es un proyecto público pensado para la
comunidad. Son tres `git add`, pero cambia si alguien de fuera puede arrancarlo.

## Medidas del escáner (para no repetir el trabajo)

Tick de presencia con frames de 1280×720 (lo que da el pipeline de GStreamer):
decodificar el JPEG **75 ms**, remuestrear a 64×36 **8 ms** (`nearest` sería
0,1 ms), total **~89 ms**. La decodificación es el coste y `package:image` no
sabe decodificar a escala reducida: cambiar el remuestreo ahorra un 9 %, no
merece la pena. La vía buena, si algún día molesta, es un segundo stream
diminuto desde GStreamer (cero decodificación por tick), pero es solo Linux.

## Trampas que ya han costado tiempo

- Tests con frames sintéticos **planos** no reproducen nada del escáner: hace
  falta imagen con estructura. Una tanda entera de tests pasó con el código sin
  arreglar y hubo que rehacerla.
- En `testWidgets`, el I/O real de disco **no avanza con el reloj falso**: hay
  que montar el widget DENTRO de `tester.runAsync(...)`, no solo esperar dentro.
- Los identificadores de Dart son **ASCII**: `añadir` no compila.
- `gh` de esta máquina **no soporta `--json` en `pr checks`**: un bucle de
  espera con `--json` sale al instante sin esperar nada. Usar la salida de texto
  y buscar `pending`.
- `flutter analyze` saca ~16 avisos `info` heredados (en `tool/`, `test/` y
  algún `deprecated_member_use`): no son de lo nuevo, CI pasa igual.
- Nada de `pumpAndSettle` en pantallas con `LinearProgressIndicator`.
