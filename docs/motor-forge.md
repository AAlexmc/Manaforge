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

## Tierras no básicas (implementado — fase 1)
`lands.py` / `lands.dart` clasifican cada tierra de la colección en un
`LandProfile`: colores que produce de verdad, si entra girada (`never` /
`conditional` / `always`) y su función (shock, check, fetch, tapland…). La
manabase las incorpora por función real — no solo básicas proporcionales — y
reporta `sources_by_color` para que el score sepa cuántas fuentes reales hay
de cada color exigido.

## Score v2 (implementado — fase 2)
El score de un mazo (`deck_score.py` / `deck_score.dart`, `DeckEvaluation`)
deja de ser la media de eficiencia:
- **efficiency** (0-10): media ponderada de eficiencia por carta, como antes.
- **consistency** (0-10): 6·pKeepableHand + 4·castabilidad media, con las
  probabilidades hipergeométricas de la fase 1 sobre `sources_by_color`.
- **curve** (0-10): media t=1..4 de P(jugada de coste ≤ t al turno t).

`total = 0.5·efficiency + 0.25·consistency + 0.25·curve`. Un mazo bonito que
no roba sus tierras a tiempo baja en el ranking.

## Construcción (fase 3 del roadmap)
1. Clasificación funcional por texto Oracle: ramp, removal, contramagia, robo,
   barreduras, recursión, win conditions.
2. Detección de sinergias — implementado: tribus dinámicas por subtipos
   (payoffs con plurales irregulares: «Elves», «Dwarves»…) y temas mecánicos
   (sacrificio, contadores +1/+1, artefactos, cementerio, lifegain,
   hechizos/prowess, tokens, reanimator).
3. Puntuación por carta: eficiencia individual + bonus de sinergia con el tema
   + encaje en la curva objetivo del arquetipo. Caso especial reanimator: las
   gordas (cmc ≥ 5, eficiencia ≥ 6) no valen por su coste de lanzamiento —
   no se lanzan, se reaniman — sino por el hechizo de reanimación que las trae.
4. Búsqueda: greedy con cuotas (criaturas/interacción/robo por arquetipo) +
   reoptimización si el validador rechaza; generar 3-5 propuestas distintas
   (mejores combinaciones color/tema), no una sola.
5. Salida por mazo: lista agrupada, curva, estadísticas, plan de juego turno a
   turno en lenguaje natural, debilidades, faltantes con coste de completado.

## Elige tu estilo (implementado — `theme_override`)
El jugador puede forzar tema en vez de dejar que el detector elija:
`generate(theme_override: 'lifegain' | 'tribal:Elf' | …)` se salta la
detección y construye alrededor del tema pedido (cualquier subtipo vale vía
`tribal:<Subtipo>`). Espejo 1:1 Dart/Python. La app expone un selector con
24 tribus + los temas mecánicos, localizado a 10 idiomas.

## Forja profunda y Modo Test (solo-Dart, sin espejo Python)
`simulator.dart` y `deep_rank.dart` son Modo Test de la app de escritorio,
no parte del generador — no tienen referencia Python y no la necesitan:

- **Simulador v3**: colores de maná reales por `LandProfile` (una tierra
  `entersTapped` no da maná hasta el turno siguiente), combate con keywords,
  removal y contramagia; cementerio real (muertes, descartes por loot,
  `mill N` — dígitos o palabras, distinguiendo self-mill de mill al rival);
  reanimación con prioridad: una gorda reanimable en la tumba se juega si hay
  hechizo de reanimación pagable, y las criaturas-reanimadoras entran ellas
  mismas al campo. Sigue siendo simulación simplificada: el % es comparativo.
- **Forja profunda** (`rankBySimulation`, switch en la UI): las mejores
  propuestas juegan un round-robin simulado entre sí antes de enseñarse;
  ranking final `0.6·winrate medio + 0.4·(score estático/10)`. Determinista
  con semilla.

Qué sigue solo-Dart y por qué: todo lo que simula partidas (Modo Test,
forja profunda). El generador, score, manabase, tierras y `theme_override`
sí deben mantenerse espejo 1:1 con `engine-reference/`.

## Tests de aceptación
Los fixtures (`engine-reference/fixtures/`) son mazos reales generados a partir
de una colección ManaBox real durante el diseño: si el validador los rechaza,
el motor está roto. El bug de referencia: en el prototipo de diseño la curva
sumaba 38 con 39 hechizos — por eso existe test_curve_histogram_sums_to_spell_count.
