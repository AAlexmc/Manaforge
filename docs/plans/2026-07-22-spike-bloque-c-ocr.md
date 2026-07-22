# Bloque C (OCR del número de coleccionista): medido y APARCADO

Fecha: 22-07-2026. Regla acordada en la nota anterior: **spike medido primero;
si no mejora la elección de edición, se aborta y se documenta.** Esto es la
documentación.

## Qué se midió

9 fotos reales de cartas de Ale (Aether Revolt en español, alguna en funda,
fondos y ángulos distintos, una tierra de Kaladesh). Verdad sacada del pie
impreso de cada carta. Se pasó el pipeline REAL de la app
(`tool/verify_live.dart` y `tool/spike_editions.dart`, nuevo).

## Resultado: el OCR no hacía falta para ninguno de los fallos

Los tres errores de edición eran **empates exactos** de distancia de Hamming,
resueltos por el orden en que estaban las filas en la base:

| foto | verdad | competían | distancia |
|---|---|---|---|
| Implement of Examination | AER #156 | KLR #244 (Arena) | **12 = 12** |
| Ornithopter | AER #167 | KLR #255 (Arena) | **16 = 16** |
| Tezzeret's Betrayal | AER #191 | PLST #AER-191 (The List) | **19 = 19** |

Cuando dos ediciones llevan el mismo arte, sus huellas son **idénticas**: la
ilustración no puede deshacer el empate ni con la mejor cámara del mundo. Leer
el número de coleccionista habría arreglado los tres… y también los arregla
mirar dos cosas que ya se saben, sin OCR:

1. **Ediciones que solo existen en digital** (Arena, Magic Online, Alchemy):
   61 sets, **9.129 de las 109.825 huellas del índice (8,3 %)**. El escáner
   mira cartón: ninguna puede ser la respuesta. Se filtran.
2. **Empate exacto entre ediciones de papel**: gana la que el usuario YA
   tiene; si no tiene ninguna, la de número de coleccionista normal (The List
   numera `AER-191`, los promos `2023-6` o `113p`); y en último término, orden
   alfabético del código, para que la respuesta no dependa de cómo se generó
   la base.

Con eso, las 9 fotos: **8 aciertos de carta Y edición**, y la que falla
(Aegis Automaton, foto muy cerrada) el escáner en vivo la **rechaza** en vez de
inventarse una carta — que es el comportamiento correcto.

## ¿Y el OCR, entonces?

**Aparcado, no descartado.** Lo que sabemos ahora:

- **Se puede leer.** A la resolución de la cámara (carta de ~590 px de alto en
  un frame de 1280×720), el pie —`191/184 R` y `AER • SP`— se lee sin
  problema en las fotos de Ale reescaladas a ese tamaño, incluso con la carta
  girada. No está pegado al límite.
- **Pero ya no arregla nada medible.** Después de los dos desempates, no queda
  ningún fallo de edición en la muestra. Sin fallos que arreglar, el OCR es
  complejidad sin retorno.
- **Cuándo retomarlo:** si aparecen empates entre ediciones de papel que el
  usuario NO tiene y con número normal las dos (mismo arte reimpreso en dos
  expansiones corrientes). Ahí el desempate acierta por prior, no por leer, y
  el OCR sí aportaría. Antes de programarlo: repetir esta medición con frames
  de la webcam de verdad (`~/captura-carta.sh`), no con fotos de móvil
  reescaladas, que son más nítidas de lo que da la cámara.
- **Ojo, límite duro:** las cartas anteriores a 2015 **no llevan número ni
  código de edición impresos**. Para esas, el OCR no existe como opción.

## Lo que quedó hecho

- `lib/scanner/digital_sets.dart` (lista de los 61 sets digitales) y filtro en
  `HashIndex`.
- Desempate determinista en `HashIndex.topMatches`, con `ownedPrintings`
  enchufado desde la colección en el escáner en vivo y en el de fotos.
- `tool/spike_editions.dart`: para una foto, qué ediciones compiten y a qué
  distancia. Es la herramienta con la que se repite esta medición.
- Fotos y recortes del spike: fuera del repo, en `~/manaforge-spike/`.

## Deuda anotada

La lista de sets digitales vive en el código porque la base descargable ya
está generada y en el ordenador de la gente. Lo correcto es marcar la bandera
`digital` al construir la base de huellas (`scripts/ci/`) y borrar la lista.
