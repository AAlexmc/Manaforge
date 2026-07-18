# ManaForge — specs de componentes (del prototipo aprobado 2a)

## Reglas de producto (no negociables)
- Los números cuadran SIEMPRE: curva Σ = hechizos; hechizos + tierras (+ comandante) = total.
- Forge nunca genera un mazo defectuoso: si el formato no da, pantalla "no puede" con explicación + alternativa.
- Faltantes siempre accionables: "Te faltan N cartas · completarlo cuesta ~X €" → lista → wishlist.
- Microcopys de jugador a jugador ("te faltan 2 tierras", nunca "déficit de fuentes").
- "Forjar" se reserva para mazos (Forge). Cartas se "añaden"/"escanean".

## Iconografía de maná (handoff/mana-icons/)
Círculo de color + glifo geométrico oscuro (mismo tono). Nunca letras solas (daltónicos, ES/EN).
Tamaños: 13 px (filas), 14 px (leyenda distribución), 17 px (identidad de mazo).

## Componentes clave
- **Tarjeta de valor**: radius 18, padding 16/18; delta semanal (chip success), número Sora 34,
  barra distribución 9 px (segmentos con gap 2) + leyenda icono+%, pie "N cartas · M foils | Ver evolución ›".
  Tappable → gráfica de evolución.
- **Chips de filtro**: pill, 11.5 px; activo = fondo texto invertido. Set: Todo · Foil · >5 € · Faltan en mazos · Wishlist.
- **Fila de carta**: thumb 36×50 r5, nombre 13.5 semibold, badge condición (NM/M/EX/GD, mono 9)
  + texto llano ("casi perfecta"), precio + icono de maná a la derecha. Badge FOIL: degradado 3 tonos.
- **FAB Escanear**: pill rojo maná, icono + etiqueta SIEMPRE, sombra 0 8 24 rojo 40 %.
  Las listas llevan padding-bottom ≥ 116 para que nunca tape la última fila.
- **Tab bar**: 5 pestañas; Forge usa violeta #9B6BD6 con glow + destello (única pestaña con color propio).
- **Escáner**: contador de sesión Sora 30 con pulso; marco con flash verde por reconocimiento;
  toast "✓ Nombre"; pila inferior (cartas 50×70, solape −12, rotación ±7°, animación drop 450 ms).
  Háptica: .light por carta, .success al guardar.
- **Carrusel Forge**: tarjeta 262 anchura, scroll-snap center; badge arquetipo (tono del color primario del mazo),
  identidad de maná, mini-curva 7 barras (0–6+), plan en cursiva, estado de completitud accionable.
- **Detalle de mazo**: Plan de juego (T1–T2/T3–T4/T5+) → curva grande → "¿Por qué este mazo funciona?"
  PLEGADO por defecto (violeta Forge) → lista agrupada → debilidades + mejoras <5 €.
- **Mis mazos**: cada fila lleva mini-curva + "✓ completo" (success) / "faltan N" (warning).

## Imagen de carta — estados (el componente más repetido de la app)
Fuente: CDN de Scryfall, caché en disco (small 146×204 en listas/galería, normal 488×680 en tarjetas, PNG 745×1040 solo en detalle). Nunca un hueco blanco.
- **Cargando (skeleton)**: placeholder con el color de identidad de la carta (rayado diagonal 45°, tono oscuro del maná — patrón ya usado en el prototipo), shimmer sutil opcional. Multicolor: degradado entre sus colores; incolora: gris cálido. Radius 5 (thumb) / 9 (tarjeta).
- **Cacheada**: imagen directa, fade-in 150 ms solo en la primera descarga (desde caché aparece sin animación).
- **Sin conexión y no cacheada**: skeleton de identidad + glifo de nube tachada 12 px esquina inferior derecha + tooltip "Se descargará con conexión". Se auto-recarga al volver la red.
- **Error (404/corrupta)**: skeleton de identidad + nombre de la carta centrado (mono, 10 px) — la carta sigue siendo identificable y tappable. Retry con backoff; nunca bloquear la fila.
- **Descargando colección (modo offline)**: barra de progreso global en Ajustes ("340/1.842 imágenes · 28 MB"), no indicadores por carta.
- Accesibilidad: el skeleton lleva accessibilityLabel con el nombre de la carta desde el primer frame.

## Pendientes de diseño apuntados (próxima entrega)
1. Pase de idioma EN (microcopys mapeados en el prototipo, ES canónico).
2. Pantalla completa de Trades (el prototipo lleva el stub de dos columnas + balance en vivo).
3. Onboarding de primera descarga: progreso del bulk de Scryfall (~200-400 MB, tamaño visible),
   skeletons de identidad durante la carga, y en Ajustes: estado de la base ("Actualizada hoy"),
   tamaño de caché de imágenes y "Descargar mi colección para offline".
   Atribución a Scryfall + descargo de la Fan Content Policy de Wizards en About.

## Motor Forge (referencia para el paquete Swift)
Karsten: tierras por arquetipo (aggro 20–23, midrange 24–25, control 26–27, Commander 36–40),
±1 tierra por ±0,5 de coste medio, descuento por ramp/cantrips; fuentes ∝ símbolos de color.
Los 5 mazos del prototipo son los tests de aceptación (datos en ManaForge Prototype.dc.html).
