# Nota técnica ManaForge: base de datos de cartas e imágenes

**Objetivo de producto:** la colección debe ser 100 % visual — al registrar/escanear una carta, el usuario ve su foto real al instante, y su colección se navega como una galería, no como una lista de nombres. Todo debe funcionar offline una vez visto.

## Arquitectura de datos (4 capas)

1. **Base de datos completa on-device.** En el primer arranque, la app descarga el bulk data "Default Cards" de Scryfall (todas las cartas e impresiones de la historia de Magic, con nombres multiidioma, coste, texto Oracle, legalidades, precios y la URL de imagen de cada impresión) y lo convierte a SQLite local (~200-400 MB). Se actualiza en segundo plano cada 24 h descargando el bulk nuevo (los archivos bulk de Scryfall no tienen rate limit). Esto alimenta el buscador offline y el generador Forge.

2. **Imágenes bajo demanda con caché permanente.** Las fotos NO se preinstalan (todas las cartas serían cientos de GB). Cada imagen se descarga del CDN de Scryfall la primera vez que aparece en pantalla y queda cacheada en disco: miniatura `small` (~20 KB, 146×204) en listas y galería, `normal` (488×680) en tarjetas, PNG 745×1040 solo en el detalle a pantalla completa. Una colección de 2.000 cartas en vista galería ≈ 40 MB de caché. Gestión de caché con límite configurable y purga LRU de lo no-poseído.

3. **Modo offline garantizado para lo tuyo.** Opción "Descargar mi colección": baja de golpe las imágenes de todas las cartas que el usuario posee (y las de sus mazos) en la calidad elegida, marcándolas como no-purgables. La galería del usuario funciona siempre, sin internet.

4. **Huellas visuales para el escáner.** El reconocimiento de cartas es 100 % on-device (ninguna foto sale del móvil): la cámara compara contra una base de hashes perceptuales precomputados de todas las impresiones. Esa base se genera en CI (GitHub Actions) a partir de las imágenes de Scryfall y se distribuye como archivo compacto (~50-100 MB) junto a la base de datos, con actualizaciones incrementales por set nuevo. Es la clave para superar a otros escáneres en foils y fondos difíciles.

## Restricciones a respetar

API de Scryfall máx. ~10 req/s con User-Agent identificado (los bulk y el CDN de imágenes no tienen límite, pero se cachea siempre); atribución a Scryfall en Ajustes/About; las ilustraciones son propiedad de Wizards of the Coast y se usan al amparo de su Fan Content Policy (app gratuita, sin insinuar patrocinio oficial — incluir el descargo estándar de la política en el About).

## Implicaciones de diseño (UI)

Estado de descarga inicial de la base de datos en el onboarding (con tamaño y progreso), indicador de "imagen descargándose" en tarjetas (skeleton con el color de identidad de la carta, nunca un hueco blanco), ajuste de calidad/uso de datos móviles, y sección de Ajustes con: estado de la base de datos ("Actualizada hoy"), tamaño de caché de imágenes, y botón "Descargar mi colección para offline".
