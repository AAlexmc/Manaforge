# ManaForge · dónde está todo (22-07-2026)

Sesión hecha sin supervisión, a partir de la nota
`2026-07-22-proxima-sesion.md`. Nada mergeado: **seis PRs abiertos**, todos
con CI verde, para que los revises tú.

## Los seis PRs, y en qué orden mergearlos

Dos son apilados (van sobre otra rama, no sobre `main`). Los apilados se
mergean con **merge-commit, nunca squash**, y el de abajo primero.

| Orden | PR | Sobre | Qué es |
|---|---|---|---|
| 1 | **#9** | `main` | Pérdida de datos: cuatro almacenes que escribían sin red + restaurar que pisaba lo restaurado |
| 2 | **#11** | `main` | Acotar lo que entra de fuera: CSV, descargas, URLs de imagen |
| 3 | **#7** | `main` | El fallo del escáner que encontraste (volver a poner la misma carta no contaba) |
| 4 | **#12** | `#7` | Escanear a una carpeta |
| 5 | **#8** | `main` | Restaurar solo en Ajustes, con desplegable y CONFIRMAR |
| 6 | **#10** | `#8` | Endurecer el restaurar (bomba de descompresión, qué se borra, barrera modal) |

El orden 1→2 antes que el resto es a propósito: son los que arreglan pérdida
de datos de verdad.

## 1 · Tu fallo del escáner (#7)

Lo diagnosticado en la nota anterior, arreglado tal cual:

- La puerta de presencia solo dice "carta retirada" con la escena asentada y
  la presencia por debajo del umbral: eso ya es prueba. **Un tick basta**
  (antes tres, 0,9 s de mesa vacía y quieta).
- Borrar la ficha con la X —o bajarla a 0, o vaciar la bandeja— **suelta esa
  carta** de la memoria de mesa. Antes quedaba bloqueada para siempre.
- El pie dice **"Ya está en la mesa: X · retírala y vuelve a ponerla para
  sumar otra"** en vez de parecer colgado.
- Test de regresión con tu secuencia exacta.

## 2 · La carpeta al escanear (#12)

Chip en la bandeja: *Sin carpeta* → *Y además a: Caja de la tienda*. Hoja
para elegir, con crear carpeta nueva ahí mismo. La elección se mantiene entre
tandas.

Contrato respetado: la carpeta **no es un destino alternativo**. Las cartas
entran en la colección igual y ADEMÁS se etiquetan; la carpeta guarda
pertenencia, nunca cantidades.

Pendiente a propósito: el escaneo por FOTO (`ScanScreen`) no tiene selector de
carpeta. Es otra bandeja; se añade igual de barato si lo quieres.

## 3 · Restaurar copia como pediste (#8 y #10)

- **Fuera de la pantalla de arranque**; vive solo en Ajustes.
- **Desplegable** con las copias de este ordenador (fecha legible, no nombre
  de fichero) y un botón al lado que **nace apagado**: sin copia elegida no
  hace nada.
- Al pulsarlo, ventana donde hay que **escribir CONFIRMAR**. Cancelar o
  escribir otra cosa no restaura.

**Contrapartida que tienes que decidir:** ese botón estaba en el arranque a
propósito, porque es donde acabas cuando la app no arranca bien. Ahora, si la
app no llega a Ajustes, no hay vía de restaurar desde dentro. Se puede volver
a enseñar ahí **solo cuando el arranque detecte datos rotos**; dilo y se hace.

## 4 · La auditoría de seguridad

Repasado todo `app/lib` y `forge_engine/lib` buscando lo que pueda dañar a
quien se baje la app.

### Arreglado (#9, #10, #11)

- **Cuatro almacenes escribían sin red.** `decks.json`, `wishlist.json`,
  `recents.json` y `value_history.json` hacían `writeAsString` directo, sin
  temporal ni cola. Un corte a media escritura dejaba el JSON a medias; al
  reabrir, la lista salía vacía y el siguiente guardado escribía encima. Doce
  mazos podían desaparecer así. Ahora los cuatro van por temporal + rename con
  cola, y un fichero ilegible se aparta como `.roto`.
- **Restaurar pisaba lo restaurado.** `recentsStore` y `priceHistoryStore` son
  instancias compartidas y no se recreaban: seguían con lo de antes en memoria
  y lo reescribían encima. El historial de precios además reescribe su log
  entero al compactar, y ahí un apunte perdido no se recupera.
- **Bomba de descompresión en `.mfbak`.** Medido: 1000:1. Un fichero de 10 MB
  se convertía en ~10 GB de RAM. Ahora se descomprime contando bytes, una sola
  vez (antes dos) y fuera del hilo de la ventana.
- **Restaurar borraba en silencio** lo que la copia no trae. Ahora el diálogo
  lo dice con nombres de persona.
- **Barrera modal mientras se restaura**, para que ninguna pantalla escriba a
  media faena.
- **Descargas**: las redirecciones se siguen a mano comprobando cada salto
  (`package:http` seguía hasta cinco a donde le dijeran, incluso bajando a
  `http` en claro, y lo bajado lo abre sqlite, que es código nativo).
- **URLs de imagen**: `collection.json` puede venir de una copia que te haya
  pasado otra persona. Al leer solo se aceptan `https` de Scryfall; si no, la
  app pedía sola direcciones de un tercero al pintar el álbum (delata tu IP).
- **CSV**: tope de tamaño antes de leerlo a memoria.
- **Certificado guardado a Descargas**: `basename` al nombre.

### Bien resuelto, sin tocar (para que conste)

Path traversal al restaurar (lista blanca), copia corrupta que no escribe
nada, inyección de comandos en la cámara Linux (argumentos en lista, sin
shell), inyección SQL (todo parametrizado), decodificación de imágenes en
isolate, sin secretos en el repo, y CI que no da token de escritura a un PR de
un fork.

### Lo que NO he tocado porque es decisión tuya

1. **`pubspec.lock` sin trackear.** Cada build de release resuelve las
   dependencias transitivas de cero: ni tú ni nadie puede reproducir ni
   auditar qué versiones acabaron dentro del binario publicado. La memoria del
   proyecto dice que esos artefactos son untracked A PROPÓSITO, así que no lo
   toco. Recomendación: `pubspec.lock` sí; `linux/` también, o quien clone el
   repo no puede compilar la app de escritorio (y es un proyecto público).
2. **Binarios publicados sin firmar ni checksums**, con instrucción explícita
   en las notas de release de saltarse Gatekeeper en macOS. Arreglo: un
   `sha256sum` en el job de release y los hashes en las notas. **No lo puedo
   hacer yo**: el token de esta máquina no tiene scope `workflow`. Con
   `gh auth refresh -s workflow` se desbloquea.
3. **Checksum de las bases descargadas.** Verificar el SHA-256 antes del
   `rename` exige publicarlo en cada release, o sea tocar workflows: mismo
   bloqueo que el punto 2.

## Lo siguiente, cuando vuelvas

1. Revisar y mergear los seis PRs en el orden de la tabla.
2. Probar a mano con la cámara: escanear → borrar ficha → retirar → volver a
   poner la misma (tiene que volver a contar) y escanear a una carpeta.
3. Decidir lo de `pubspec.lock` / `linux/` y lo del scope `workflow`.
4. Y entonces sí, lo que quedaba de la hoja de ruta: OCR del número de
   coleccionista (spike medido primero), "lo que me falta" con precio, cascada
   de borrado, precio de compra y P&L.

## Trampas nuevas (aparte de las de la nota anterior)

- Un `TextEditingController` soltado justo después de `showDialog` sigue en
  uso mientras el diálogo se cierra: revienta el árbol. El controlador tiene
  que vivir en un `StatefulWidget` propio. (Lo cazaron los tests nuevos.)
- Una hoja modal abierta al terminar un `testWidgets` deja el árbol a medio
  desmontar y falla en el `tearDown`: hay que cerrarla dentro del test.
- `DropdownButtonFormField` revienta si su valor deja de estar entre las
  opciones: con listas que cambian (copias rotadas), ponerle una `Key` que
  dependa de la lista.
- `package:http` NO deja ver la URL final tras redirecciones
  (`response.request` sigue siendo la original). Para comprobar el esquema hay
  que seguirlas a mano con `followRedirects = false`.
