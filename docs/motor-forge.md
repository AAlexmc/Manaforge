# Motor Forge: especificación del algoritmo

La referencia canónica y testeada vive en `engine-reference/` (Python).
El puerto Dart en `forge_engine/` (el que usa la app Flutter en todas las plataformas) debe mantenerse espejo 1:1 — mismos números,
mismos tests. Si divergen, manda la referencia Python.

## Reglas duras (nunca se violan)
1. Solo cartas que el usuario posee, en las cantidades que posee.
2. Límite de copias del formato (4 en 60 cartas; singleton en Commander; básicas libres).
3. Solo cartas legales en el formato elegido (campo `legalities` de Scryfall).
4. En Commander: identidad de color del comandante.
5. Tamaño exacto del mazo.
6. Curva y tierras dentro del rango del arquetipo — si la colección no da,
   Forge avisa y explica el compromiso; jamás genera un mazo defectuoso en silencio.

## Curva de maná (aprox. Karsten)
- Base: 24 tierras para coste medio 3.0 (mazo de 60); ±1 tierra por ±0.5 de coste medio.
- Descuento: ~1 tierra por cada 3-4 fuentes baratas de maná/robo (cmc ≤ 2).
- Rangos por arquetipo: aggro 20-23 · tempo 22-24 · midrange 23-25 · control 26-27.
- Reparto de básicas proporcional a los símbolos de color, con mínimo jugable
  para el color secundario (≥8 fuentes si tiene exigencias tempranas).

## Construcción (fase 3 del roadmap)
1. Clasificación funcional por texto Oracle: ramp, removal, contramagia, robo,
   barreduras, recursión, win conditions.
2. Detección de sinergias: tribus (subtipos), temas mecánicos (sacrificio,
   contadores +1/+1, artefactos, cementerio, lifegain, hechizos/prowess, tokens).
3. Puntuación por carta: eficiencia individual + bonus de sinergia con el tema
   + encaje en la curva objetivo del arquetipo.
4. Búsqueda: greedy con cuotas (criaturas/interacción/robo por arquetipo) +
   reoptimización si el validador rechaza; generar 3-5 propuestas distintas
   (mejores combinaciones color/tema), no una sola.
5. Salida por mazo: lista agrupada, curva, estadísticas, plan de juego turno a
   turno en lenguaje natural, debilidades, faltantes con coste de completado.

## Tests de aceptación
Los fixtures (`engine-reference/fixtures/`) son mazos reales generados a partir
de una colección ManaBox real durante el diseño: si el validador los rechaza,
el motor está roto. El bug de referencia: en el prototipo de diseño la curva
sumaba 38 con 39 hechizos — por eso existe test_curve_histogram_sums_to_spell_count.
