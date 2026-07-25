# Forja mejor-mazo: probabilidad real, tierras no básicas, cementerio y color pie

**Fecha:** 2026-07-25 · **Rama:** `feat/forja-mejor-mazo` · **Pedido de Ale:** que Forge genere
siempre los mejores mazos posibles teniendo en cuenta el azar del robo, los mulligans,
instantáneos/conjuros, voladores/arrolladores, los tipos de tierra modernos, los mazos de
cementerio y las mecánicas propias de cada color.

## Diagnóstico del motor actual (main = 9e451f5)

| Pieza | Hoy | Problema |
|---|---|---|
| Tierras | `24 + (avg−3)·2 − baratas/3.5` (`mana_curve.dart:65`) | Heurística sin probabilidad; no mide P(robar tierras a tiempo) |
| Base de maná | Solo básicas proporcionales (`generator.dart:254`) | Duales/fetch/taplands de la colección NUNCA entran; screw de color no medido; sin tricolor |
| Score carta | `5 + (P+T−2·cmc)·0.8`, +0.8 por keyword plana (`classify.dart:118`) | Volar = arrollar = toque mortal; regex inglés; columna `keywords` de la DB sin leer |
| Score mazo | Media de efficiency | Ciego a consistencia: no ve mulligans ni curva jugable |
| Temas | 7 regex mecánicos (`classify.dart:20`) | Sin tribus (subtipos se tiran en `card_database.dart:384`); cementerio flojo (sin reanimator) |
| Simulador | Modela mulligan, colores, volar/arrollar/… (`simulator.dart`) | Solo Modo Test; sin cementerio; tierras `'*'` mágicas sin colores reales ni tapped |

## Fase 1 — Maná: matemática de verdad + tierras no básicas

### 1a. `hypergeometric.dart` (forge_engine, nuevo)
Función pura `hypergeomAtLeast(popSize, successes, draws, k)` (suma de PMF, sin
dependencias). Sobre ella:
- `pLandDrops(nLands, deckSize, turn, {onPlay})` — P(≥turn tierras en 7+turn−1 robos).
- `pKeepableHand(nLands, deckSize)` — P(2–5 tierras en 7), con un mulligan modelado:
  `p + (1−p)·p6` (mano de 6).
- `pColorByTurn(sources, deckSize, turn, symbols)` — P(≥symbols fuentes de un color al turno.

### 1b. `recommendedLands` v2
Se mantiene la fórmula Karsten como semilla, pero el número final se elige dentro de
`[landMin, landMax]` maximizando `P(caer tierra turnos 1..T) − 0.5·P(inundación)` con:
- T por arquetipo: aggro 3, tempo/midrange 4, control 5.
- Inundación = P(≥T+3 tierras al turno T+2).
Determinista, testeable con valores conocidos (24 tierras/60 → P(3 al t3 en la mano+2 robos) ≈ 0.83…).

### 1c. `lands.dart` — clasificador de tierras (nuevo)
`LandProfile.fromCard(Card)`:
- `produces: Set<String>` — de `{T}: Add {…}` del oracle **y** de subtipos básicos en la
  type_line (shock/dual tipadas: "Land — Plains Island"). Requiere `Card.subtypes` (ver 1e).
- `entersTapped: always | conditional | never` — "enters the battlefield tapped" sin/con
  "unless…"; condicional pesa 0.5.
- `isFetch` + `fetches: Set<String>` — "search your library for a/an … land" (Evolving
  Wilds y similares); cuenta como fuente de cada color buscable dentro de los colores del mazo.
- `utility` — tierra que solo produce incolora: **fuera de la manabase v1** (anotado como futuro).
- MDFC (cara-tierra) **fuera de alcance** — se anota y ya.
Las tierras "recientes" (surveil, duales nuevas) no necesitan trato especial: el clasificador
las valora por función y entran por pool/sets como cualquier otra.

### 1d. Manabase v2 (`_manaBase` sustituida, misma firma + no-básicas)
1. Necesidades de color por tabla Karsten (constantes embebidas, mazo de 60):
   fuentes requeridas por (turno del coste, nº símbolos) — p. ej. 1 símbolo t1→14, t2→13,
   t3→12; CC t2→20, t3→18… La exigencia real la fijan las cartas elegidas (la más temprana
   con {C}, la más temprana con {C}{C}).
2. Selección greedy: primero duales sin girar que cubran los 2 colores más exigidos, luego
   duales condicionales, fetches, básicas de relleno. Tope de tierras que entran giradas por
   arquetipo: aggro 2, tempo 3, midrange 4, control 6.
3. Regla BLANDA (no dura): si con toda la colección no se llega a las fuentes Karsten
   de un color al 90%, la identidad sigue generándose (como hoy) pero su score de
   consistencia (fase 2) la hunde en el ranking — no se miente al usuario ni se le
   prohíbe el mazo.
4. Commander reusa clasificador y greedy (37 tierras, singleton, suelo de básicas 6 por color
   como hoy). Tricolor en 60 sigue FUERA (decisión: pares ya saturan colecciones típicas;
   con duales buenas el par es mejor mazo que el tricolor forzado).

### 1e. `Card.subtypes`
`rowToCard` deja de tirar lo de detrás del `—`: `types` = antes, `subtypes` = después.
Necesario para duales tipadas (1c) y tribus (fase 4). Espejo en `Card.fromJson` y fixtures.

## Fase 2 — Score: keywords estructuradas, color pie, consistencia

### 2a. `Card.keywords`
`buildPool` lee la columna `keywords` (JSON array de Scryfall, ya en schema v4) → 
`List<String>` en minúsculas. Fallback si vacía/ausente (DB vieja): regex actual sobre oracle.
El motor consulta SIEMPRE vía `card.hasKeyword(k)` (keywords ∪ regex), nunca regex directo.

### 2b. Pesos de combate (sustituye el +0.8 plano de `efficiency`)
Tabla const `kwWeight`: flying 1.2 · menace 0.8 · haste 0.7 (×1.5 en aggro) ·
deathtouch 0.6 · lifelink 0.6 · first/double strike 0.5 · vigilance 0.3 · reach 0.2 ·
trample 0.2 + 0.15·(power−3) si power≥4 (arrollar solo paga en gordas).
Se suman (tope +2.0) — una criatura con volar+vínculo vale más que una con solo texto.

### 2c. Color pie (mecánicas por color)
Tabla `themeColors`: lifegain WB · sacrifice B(R) · spells UR · artifacts (incoloro)+UW ·
counters GW · tokens WG(R) · graveyard/reanimator BG(U) · tribal cualquiera.
En `detectTheme`, peso ×1.25 si identidad ∩ colores naturales del tema ≠ ∅, ×0.8 si el tema
es ajeno a la identidad. Mazos coherentes con su color ganan el desempate.

### 2d. Score de mazo v2 (ranking de propuestas)
`score = 0.5·mediaEfficiency + 0.25·consistencia + 0.25·curvaJugable` donde
- `consistencia` = 10·(0.6·pKeepableHand + 0.4·castabilidad media) — castabilidad de una
  carta = P(fuentes de sus colores al turno cmc) con las fuentes reales de la manabase v2;
- `curvaJugable` = 10·media de P(tener jugada de coste ≤t al turno t), t=1..4 (hipergeométrica
  sobre el histograma del mazo).
La media estática deja de ser el único juez: un mazo bonito que no roba sus tierras baja.

## Fase 3 — Simulador con cementerio + «forja profunda»

### 3a. Cementerio mínimo en `simulator.dart`
- `_Player.graveyard`; todo lo que muere/descarta/se muele va allí.
- `_SimCard` nuevo: `millSelf n` ("mill N cards" propio), `loot` (roba y descarta),
  `reanimates` ("return … creature … from your graveyard to the battlefield"),
  `fromGraveyard` (flashback/escape/unearth/disturb: una vez desde cementerio).
- Prioridad de juego nueva entre removal y bajar criatura: si tengo reanimación pagable y
  hay criatura cmc≥5 en mi cementerio → reanimar (gorda antes de tiempo = el plan del mazo).
- Tierras reales: `landColor` pasa a `Set<String> produces` + `entersTapped` (usa
  `LandProfile`); una tierra girada no paga el turno que entra. Así la manabase v2 gana
  partidas de verdad y los taplands cuestan tempo medible.

### 3b. Ranking por simulación en forja normal
Tras el ranking estático (fase 2), las top 6 propuestas juegan round-robin
(15 parejas × 40 partidas, semilla fija) en el mismo isolate; ranking final =
0.6·winrate + 0.4·score estático normalizado. Interruptor **«Forja profunda»** en
`ForgeScreen` (defecto ON; OFF = solo ranking estático). Presupuesto: <15 s extra.
i18n: 2 claves nuevas (título + subtítulo) × 10 idiomas.

## Fase 4 — Temas: tribus + reanimator

### 4a. Tribus
Con `Card.subtypes`: cuenta subtipos de criatura en el pool candidato; tribu elegible si
≥12 copias del subtipo Y ≥3 copias de payoffs tribales (oracle menciona el subtipo en plural
o "other <Tribu>"). Tema `tribal:<Subtipo>`; payoff = menciona la tribu, enabler = es de la
tribu. Compite con los temas mecánicos por peso, mismo circuito.

### 4b. Reanimator (separado del graveyard genérico)
- payoff: "return … from your graveyard to the battlefield" (criaturas), unearth/disturb/embalm.
- enabler: self-mill, descarte propio/loot, "discard … card" simétrico, y **gordas** (criatura
  cmc≥5 con efficiency ≥6) cuando el tema está activo.
- Excepción de curva: con tema reanimator, hasta 6 gordas puntúan sin el castigo de
  `curveNeed` (su coste real es el de la reanimación); el coste medio del validador se calcula
  igual que hoy (regla dura intacta — el arquetipo saldrá midrange/control por rangos).

## Fase 5 — Espejo Python (`engine-reference/`)

Regla del repo: si divergen, manda Python. Las fases 1, 2 y 4 tocan núcleo → espejo 1:1 en
`engine-reference/forge/` (`curve.py`, `classify.py`, `generator.py`, nuevo `lands.py`,
`hypergeometric.py`) + pytest con los mismos valores. El simulador y la forja profunda quedan
extensión solo-Dart, documentadas en la cabecera como ya hace `generator.dart:6-8`.
`docs/motor-forge.md` se actualiza (por fin las tribus prometidas existen).

## Qué NO entra (anotado, no olvidado)

- MDFC tierra-por-detrás; tierras utility incoloras en manabase; tricolor en 60 cartas.
- Sideboard; oracle en otros idiomas (la DB es inglés, decisión previa de Ale).
- Habilidades activadas/planeswalkers en el simulador (sigue siendo comparativo).

## Tests y aceptación

- Hipergeométrica contra valores tabulados a mano (4 decimales).
- Clasificador de tierras con fixtures reales: shockland, tapland, checkland, fetch,
  surveil land, utility.
- Karsten: mazo CC-t2 exige 20 fuentes → manabase con duales lo logra donde básicas no.
- Reanimator: pool con gordas+reanimación+mill se detecta y mete las gordas; sin
  reanimación, las gordas se quedan fuera (control negativo).
- Simulador: mazo reanimator gana >55% a su gemelo sin reanimación (semilla fija);
  manabase con taplands pierde tempo medible vs sin taplands en aggro.
- Todos los mazos generados siguen pasando `DeckValidator`/`validateCommanderDeck`.
- Tests existentes que fijan la fórmula vieja (p. ej. "coste medio 3.0 → 24 tierras") se
  actualizan con los valores nuevos JUSTIFICADOS en el propio test.
- Paridad Dart↔Python: mismos fixtures → mismo mazo (fases 1-2-4).

## Riesgos

- Rendimiento: round-robin acotado (6 propuestas, 40 partidas); todo en isolate como hoy.
- Regex nuevas (fetch, reanimación) inglés-only como todas las demás — consistente con la DB.
- Cambiar el ranking cambia los mazos que ve el usuario: los tests de aceptación fijan
  que los nuevos dominan a los viejos en el propio simulador (el juez es la probabilidad,
  no el gusto).
