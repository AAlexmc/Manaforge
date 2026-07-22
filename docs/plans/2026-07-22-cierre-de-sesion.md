# ManaForge · cierre de la sesión del 22-07-2026

Sesión larga: auditoría de seguridad, el fallo del escáner que encontró Ale,
bloque C (OCR) medido y aparcado, bloque D, cascada de borrado, licencia nueva
y un puñado de mejoras de uso probadas en caliente con la cámara.

**`main` sigue en `7ba681d`: no se ha mergeado NADA.** Todo vive en 16 PRs
abiertos, todos con CI verde.

## Cómo mergear (el orden importa)

Seis van sobre `main` y se pueden mergear en cualquier orden entre ellos. Los
apilados van **después** del suyo y **con merge-commit, nunca squash**.

```
main ─┬─ #9  almacenes sin perder datos
      ├─ #11 acotar lo que entra de fuera ──── #16 importar con progreso
      ├─ #18 escáner: edición correcta (y OCR aparcado)
      ├─ #7  escáner: volver a poner la misma cuenta ─ #12 carpeta al escanear ─ #19 escanear en la barra
      ├─ #8  restaurar solo en Ajustes + CONFIRMAR ─── #10 endurecer restaurar
      ├─ #14 el aviso de logro se va solo
      ├─ #15 álbum: buscar y pasar cartas ─ #17 ficha navegable + mercados ─ #21 lo que falta con precio ─ #22 cascada de borrado
      ├─ #20 licencia PolyForm Noncommercial
      └─ #13 nota de estado (solo docs)
```

Orden recomendado: **#9 → #11 → #16 → #18 → #7 → #12 → #19 → #8 → #10 → #14 →
#15 → #17 → #21 → #22 → #20 → #13.**

Mientras no se mergeen, la rama `test/todo-junto` (local, no se sube) tiene
todo junto para probar: se reconstruye mergeando la lista de arriba sobre
`main`. 502+ tests verdes con todo mezclado.

## Qué se hizo

### Seguridad y pérdida de datos (auditoría de todo `app/lib`)

- **#9** Cuatro almacenes (`decks`, `wishlist`, `recents`, `value_history`)
  escribían sin temporal ni cola: un corte a media escritura dejaba el JSON a
  medias, al arrancar salía lista vacía y el siguiente guardado escribía
  encima. Ahora tmp+rename+cola y `.roto` en vez de sobrescribir. Además,
  restaurar una copia **pisaba lo restaurado**: `recentsStore` y
  `priceHistoryStore` son instancias compartidas que no se recreaban.
- **#10** El `.mfbak` como fichero de terceros: bomba de descompresión acotada
  (medido 1000:1), se descomprime una vez y fuera del hilo de la ventana, tope
  de tamaño, el diálogo dice **qué se va a borrar**, y barrera modal mientras
  se restaura.
- **#11** CSV con tope antes de leerlo, descargas siguiendo redirecciones **a
  mano** comprobando que no bajan a `http`, URLs de imagen solo de Scryfall
  (un `.mfbak` ajeno podía hacer que la app pidiera imágenes a un tercero), y
  `basename` al guardar el certificado.

Bien resuelto de antes, sin tocar: path traversal al restaurar, inyección de
comandos en la cámara, SQL parametrizado, sin secretos, CI sin token para
forks.

### Escáner

- **#7** El fallo de Ale: borrar la ficha con la X dejaba la carta bloqueada
  para siempre. Un tick de mesa vacía basta y borrar la ficha suelta la carta.
- **#18** **Bloque C medido**: los fallos de edición eran **empates exactos**
  (12=12, 16=16, 19=19) resueltos por el orden de las filas. Se quitan las
  ediciones que solo existen en digital (61 sets, 8,3 % del índice) y se
  desempata por lo que ya tienes → número normal → alfabético. Con 9 fotos
  reales: 8 aciertos de carta Y edición. **El OCR no hacía falta**: aparcado
  con el porqué en `2026-07-22-spike-bloque-c-ocr.md`.
- **#12** Elegir carpeta al escanear (la carpeta etiqueta, no desvía).
- **#19** "Escanear" pasa a la barra de abajo, y la mesa se sigue mirando
  mientras corre el reconocimiento (antes, quitar la carta en ese hueco no lo
  veía nadie y se quedaba clavada en "ya está en la mesa").

### Uso diario

- **#8** Restaurar copia solo en Ajustes: desplegable, botón apagado hasta
  elegir y escribir **CONFIRMAR**.
- **#14** El aviso de logro se va solo (`SnackBar.persist` vale `action != null`
  por defecto: con botón, Flutter lo deja fijo para siempre).
- **#15** Álbum: buscador por nombre/número y visor que pasa de carta.
- **#16** Importar CSV con barra de progreso (sqlite responde en el mismo hilo
  y la ventana se quedaba congelada).
- **#17** La ficha completa pasa a la siguiente/anterior y deja elegir mercado
  desde el álbum.
- **#21** Bloque D: "te faltan N · X €", precio en cada hueco, y el 100 % se
  mide sobre la **tirada base** (calculada del propio set), con conmutador de
  variantes. También el total del mazo al final de la lista en Forge.
- **#22** Cascada: "ya no tengo esta carta" pregunta y la saca de todas las
  carpetas; los mazos la conservan y avisan "te faltan N".
- **#20** Licencia **PolyForm Noncommercial 1.0.0** (compartir y modificar sí,
  vender no). Lo publicado antes bajo MIT sigue siendo MIT.

## Qué falta

### De la hoja de ruta

1. **Precio de compra y P&L**: el CSV de ManaBox trae `Purchase price` y se
   está tirando. Es lo único grande que queda de la lista original.
2. **Carpeta también en el escaneo por FOTO** (`ScanScreen`): es otra bandeja
   distinta; barato.
3. **Detector con fondos cargados**: escanear sobre un teclado (o sujetando la
   carta con los dedos tapando un borde) da "Encuadra la carta dentro del
   marco". Con fondo liso va perfecto. Si molesta, es un bloque en sí.

### Decisiones de Ale (siguen pendientes)

- **`pubspec.lock` y `app/linux/` sin trackear**: quien clone el repo no puede
  compilar la app de escritorio y nadie puede auditar qué versiones lleva el
  binario publicado. Recomendación: trackear los dos.
- **`gh auth refresh -s workflow`**: sin ese scope no se pueden tocar los
  workflows, y hacen falta para publicar **SHA-256** de los binarios (hoy se
  publican sin firmar y con instrucción de saltarse Gatekeeper) y para
  verificar el checksum de las bases descargadas.
- **Restaurar ya no está en la pantalla de arranque**: si la app no llega a
  Ajustes, no hay vía de recuperación dentro de la app. Se puede volver a
  enseñar solo cuando el arranque detecte datos rotos.
- **Release v0.2.0 (19-07) es MIT** y se queda así. Cuando el estado convenza,
  toca **v0.3.0** con la licencia nueva, checksums y notas.

## Trampas nuevas aprendidas hoy

- **Los precios están en TEXTO en la base** (así los da Scryfall): toda
  consulta que los lea necesita `CAST(... AS REAL)`. Sin él revienta con
  *"type 'String' is not a subtype of type 'num?'"* y, peor, `MIN` compara
  textos ("10.00" < "9.00"). Rompió el álbum en caliente.
- **`SnackBar.persist` vale `action != null`**: un aviso con botón NO se va
  solo.
- Un `TextEditingController` soltado justo tras `showDialog` sigue en uso
  mientras el diálogo se cierra: revienta el árbol.
- Una hoja modal abierta al terminar un `testWidgets` falla en el `tearDown`.
- `DropdownButtonFormField` revienta si su valor sale de las opciones: con
  listas que cambian, `Key` que dependa de la lista.
- `package:http` **no** deja ver la URL final tras redirecciones.
- Índices escritos a mano (el sitio de "Escanear" en la barra) se descuadran:
  sacarlos de la propia lista con `indexWhere`.
- **De flujo, y costó un rato:** commitear estando en la rama temporal de
  pruebas y luego borrarla se lleva el commit por delante. Se recuperó del
  reflog. Antes de `git commit`, comprobar en qué rama estás.

## Herramientas nuevas

- `app/tool/spike_editions.dart`: para una foto, qué ediciones compiten y a
  qué distancia. Es con lo que se repite la medición del bloque C.
- `~/captura-carta.sh <set>-<numero>`: captura un frame con la MISMA cámara y
  resolución que el escáner, a `~/manaforge-spike/`. Para repetir el spike con
  frames reales de webcam en vez de fotos de móvil.
- `~/manaforge-spike/`: las 9 fotos de Ale y los recortes del spike (fuera del
  repo).
