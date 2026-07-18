# Reconocimiento de cartas: cómo funciona el escáner

**Principios:** 100 % on-device (ninguna foto sale del iPhone), offline, cualquier fondo, tolerante a foils y fundas, <1 segundo por carta.

## El pipeline, paso a paso

```
Cámara (frames a 30 fps)
   │
   ▼
1. DETECCIÓN DE LA CARTA          Vision · VNDetectRectanglesRequest
   Busca rectángulos con la proporción de una carta Magic (63:88 ±tolerancia).
   No necesita fondo blanco: el contorno se detecta por contraste de bordes.
   Varios rectángulos por frame = varias cartas a la vez (modo ráfaga).
   │
   ▼
2. CORRECCIÓN DE PERSPECTIVA      Core Image · CIPerspectiveCorrection
   La carta fotografiada en ángulo se "endereza" a una imagen canónica
   de 488×680. A partir de aquí da igual cómo estuviera sobre la mesa.
   │
   ▼
3. NORMALIZACIÓN ANTI-FOIL        Core Image
   Conversión a luminancia (escala de grises), ecualización de histograma
   y un blur ligero. Esto "aplana" los reflejos del foil y las diferencias
   de iluminación — la razón nº1 por la que fallan otros escáneres.
   │
   ▼
4. HUELLA PERCEPTUAL (pHash/dHash)
   La imagen normalizada se reduce (p. ej. 17×16) y cada píxel se compara
   con su vecino → una huella de 256 bits. Se calculan dos: carta completa
   + solo el arte. Imágenes "parecidas" → huellas "parecidas" (distancia
   de Hamming baja), aunque cambien brillo, foil o desgaste.
   │
   ▼
5. BÚSQUEDA EN LA BASE DE HUELLAS         (~500k impresiones, ~30-60 MB)
   Comparación por distancia de Hamming contra las huellas precomputadas
   de TODAS las impresiones de Magic, con índice multi-tabla (MIH) para
   responder en <10 ms sin comparar una a una. Devuelve los k candidatos.
   │
   ▼
6. DESAMBIGUACIÓN                 Vision · VNRecognizeTextRequest (OCR)
   Si el nº1 gana con margen claro → aceptado directamente.
   Si hay duda (arte idéntico en varias ediciones, cartas reimpresas),
   se lee el nombre y el número de coleccionista/símbolo de set de la
   franja inferior para elegir la impresión exacta y el idioma.
   │
   ▼
7. CONFIRMACIÓN
   Marco verde + háptica + sonido (configurable), la carta cae a la pila
   de la sesión y suma al contador. Si la confianza es baja: mini-hoja
   con los 3 candidatos para elegir con un toque (y ese feedback se
   registra localmente para ajustar umbrales).
```

## La base de huellas: generada en CI, no en el móvil

- Un workflow de GitHub Actions descarga las imágenes `normal` de Scryfall
  (bulk data → `image_uris`), calcula las huellas de cada impresión y publica
  el archivo binario como release (~30-60 MB).
- La app lo descarga junto a la base de datos SQLite y recibe actualizaciones
  incrementales por set nuevo (~1-2 MB por set).
- Ventaja clave del open source: el pipeline de huellas es reproducible por
  cualquiera (`scripts/build-hashes`), y mejorarlo (nuevos algoritmos de hash,
  más robustez a foils) no requiere tocar la app.

## Por qué esto supera a los escáneres actuales

| Problema típico | Nuestra respuesta |
|---|---|
| Exigen fondo blanco | Detección por contorno geométrico (paso 1), no por segmentación de color |
| Fallan con foils | Normalización de luminancia + ecualización (paso 3) antes de la huella |
| Confunden reimpresiones | OCR del número de coleccionista solo cuando hace falta (paso 6) |
| Lentos carta a carta | Multi-rectángulo por frame + índice MIH → ráfaga real |
| Privacidad dudosa | Todo on-device; la cámara nunca sube nada |

## Plan de validación

1. Prototipo en Swift Playground con 50 cartas fotografiadas en condiciones
   reales (mesa de madera, luz cálida, foils, fundas mate y brillantes).
2. Métrica objetivo: ≥97 % de aciertos top-1 en no-foil, ≥90 % en foil,
   <800 ms por carta en un iPhone 12.
3. Set de torture-test comunitario: un issue del repo pedirá a la comunidad
   fotos difíciles (cartas antiguas desgastadas, ediciones en japonés, proxies
   que NO debe confundir) que se convierten en tests de regresión.
