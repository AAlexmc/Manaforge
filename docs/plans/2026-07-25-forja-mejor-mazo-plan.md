# Forja mejor-mazo — Plan de implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Que Forge genere y rankee mazos por probabilidad real (robo, mulligans, colores),
use las tierras no básicas de la colección, entienda mazos de cementerio/tribus y valore
las mecánicas según el color.

**Architecture:** Motor Dart puro (`forge_engine/`) con espejo canónico Python
(`engine-reference/forge/`) para el núcleo (fases 1-2-4); simulador y forja profunda quedan
extensión solo-Dart (precedente ya documentado en `generator.dart:6-8`). La app solo toca
`card_database.dart` (subtipos+keywords), `forge_job.dart`/`forge_screen.dart` (interruptor)
e i18n.

**Tech Stack:** Dart (sin Flutter en el motor), Flutter app, Python 3 + pytest (referencia),
sqlite3 (DB de cartas, schema v4 con columna `keywords` — verificado en la DB real).

**Spec:** `docs/plans/2026-07-25-forja-mejor-mazo-diseno.md`

## Global Constraints

- Rama base: `feat/forja-mejor-mazo` (spec ya commiteado). 3 PRs SECUENCIALES (mergear PR-N antes de ramificar PR-N+1): PR1 = Tasks 1-6 (maná), PR2 = Tasks 7-9 (score), PR3 = Tasks 10-14 (temas+simulador+UI).
- Commits firmados como Ale, SIN co-author Claude (decisión fija del repo).
- Tests motor: `cd /home/ale/Manaforge/forge_engine && dart test` · Python: `cd /home/ale/Manaforge/engine-reference && python3 -m pytest -q` · App: `cd /home/ale/Manaforge/app && flutter test` · CI local: `cd app && flutter analyze` (warnings fatales — comando EXACTO, no grep).
- Paridad Dart↔Python en fases 1-2-4: mismos números con los mismos inputs; los tests de paridad usan los MISMOS casos en ambos lados.
- Regex sobre oracle SIEMPRE en minúsculas (`text = oracle.toLowerCase()`), inglés-only como todo el clasificador.
- Nada de `Random` sin semilla en el motor; el simulador sigue determinista.
- Comentarios de código: constantes/decisiones no deducibles, nunca narración del cambio.

---

## PR1 — Fase 1: maná (hipergeométrica, tierras no básicas, manabase v2)

### Task 1: `hypergeometric.dart` + espejo Python

**Files:**
- Create: `forge_engine/lib/src/hypergeometric.dart`
- Create: `engine-reference/forge/hypergeometric.py`
- Test: `forge_engine/test/hypergeometric_test.dart`, `engine-reference/tests/test_hypergeometric.py`
- Modify: `forge_engine/lib/forge_engine.dart` (export)

**Interfaces (Produces):**
```dart
double hypergeomPmf(int popSize, int successes, int draws, int k);
double hypergeomAtLeast(int popSize, int successes, int draws, int k);
/// P(caer tierra turnos 1..turn) = P(>=turn tierras entre las 7+turn-1 vistas en play).
double pLandDrops(int nLands, int deckSize, int turn);
/// P(mano de 2-5 tierras), con UN mulligan modelado: p + (1-p)*p.
double pKeepableHand(int nLands, int deckSize);
/// P(>=symbols fuentes de un color entre las 7+turn-1 vistas).
double pColorByTurn(int sources, int deckSize, int turn, int symbols);
```

- [ ] **Step 1: tests que fallan.** Valores tabulados a mano (4 decimales) — C(24 en 60):

```dart
import 'package:test/test.dart';
import 'package:forge_engine/forge_engine.dart';

void main() {
  test('pmf exacta: 3 tierras en mano de 7 con 24/60', () {
    // C(24,3)*C(36,4)/C(60,7) = 2024*58905/386206920
    expect(hypergeomPmf(60, 24, 7, 3), closeTo(0.3087, 0.0001));
  });
  test('atLeast suma la cola', () {
    final total = List.generate(8, (k) => hypergeomPmf(60, 24, 7, k))
        .reduce((a, b) => a + b);
    expect(total, closeTo(1.0, 1e-9));
    expect(hypergeomAtLeast(60, 24, 7, 0), closeTo(1.0, 1e-9));
  });
  test('mano keepable 24/60: P(2..5 tierras en 7) y mulligan', () {
    final p7 = hypergeomAtLeast(60, 24, 7, 2) - hypergeomAtLeast(60, 24, 7, 6);
    expect(pKeepableHand(24, 60), closeTo(p7 + (1 - p7) * p7, 1e-9));
  });
  test('pLandDrops(24,60,3) = P(>=3 en 9 vistas)', () {
    expect(pLandDrops(24, 60, 3), closeTo(hypergeomAtLeast(60, 24, 9, 3), 1e-12));
  });
  test('degenerados', () {
    expect(hypergeomAtLeast(60, 0, 7, 1), 0.0);
    expect(hypergeomAtLeast(60, 60, 7, 7), closeTo(1.0, 1e-9));
    expect(hypergeomPmf(60, 24, 7, 8), 0.0); // k > draws
  });
}
```
Python espejo con los MISMOS casos (`test_hypergeometric.py`, `math.comb` como oráculo
independiente: `assert abs(hypergeom_pmf(60,24,7,3) - comb(24,3)*comb(36,4)/comb(60,7)) < 1e-12`).

- [ ] **Step 2:** `dart test test/hypergeometric_test.dart` → FAIL (símbolos no existen).
- [ ] **Step 3: implementación.** Binomios con double multiplicativo (N≤100, cabe de sobra):

```dart
/// Probabilidad hipergeométrica pura — espejo 1:1 de
/// `engine-reference/forge/hypergeometric.py`.
double _binom(int n, int k) {
  if (k < 0 || k > n) return 0;
  var r = 1.0;
  for (var i = 0; i < k; i++) {
    r = r * (n - i) / (i + 1);
  }
  return r;
}

double hypergeomPmf(int popSize, int successes, int draws, int k) {
  if (k < 0 || k > draws || k > successes) return 0;
  if (draws - k > popSize - successes) return 0;
  return _binom(successes, k) *
      _binom(popSize - successes, draws - k) /
      _binom(popSize, draws);
}

double hypergeomAtLeast(int popSize, int successes, int draws, int k) {
  var p = 0.0;
  for (var i = k; i <= draws; i++) {
    p += hypergeomPmf(popSize, successes, draws, i);
  }
  return p > 1 ? 1 : p;
}

double pLandDrops(int nLands, int deckSize, int turn) =>
    hypergeomAtLeast(deckSize, nLands, 7 + turn - 1, turn);

double pKeepableHand(int nLands, int deckSize) {
  final p7 = hypergeomAtLeast(deckSize, nLands, 7, 2) -
      hypergeomAtLeast(deckSize, nLands, 7, 6);
  return p7 + (1 - p7) * p7;
}

double pColorByTurn(int sources, int deckSize, int turn, int symbols) =>
    hypergeomAtLeast(deckSize, sources, 7 + turn - 1, symbols);
```
Python idéntico (`from math import comb` NO — usar el mismo bucle multiplicativo para
paridad bit-a-bit razonable; `comb` queda solo como oráculo en el test).

- [ ] **Step 4:** `dart test` y `python3 -m pytest tests/test_hypergeometric.py -q` → PASS.
- [ ] **Step 5:** `git add … && git commit -m "Forge: hipergeométrica pura (Dart+Python) para tierras, mulligans y colores"`

### Task 2: `Card.subtypes` + `Card.keywords` (modelo + DB)

**Files:**
- Modify: `forge_engine/lib/src/models.dart` (Card)
- Modify: `app/lib/services/card_database.dart:377-394` (rowToCard) y los dos `SELECT` de `buildPool` (`:409-413`)
- Test: `forge_engine/test/forge_engine_test.dart` (Card.fromJson), `app/test/services/forge_pool_sets_test.dart` (rowToCard vía buildPool)

**Interfaces (Produces):**
```dart
class Card { …
  final List<String> subtypes;  // ["Elf","Druid"] — lo de detrás del «—»
  final List<String> keywords;  // minúsculas, de la columna JSON de la DB
  bool hasKeyword(String k);    // keywords si hay; si no, fallback oracle.contains(k)
}
```

- [ ] **Step 1: tests que fallan.**

```dart
test('subtypes y keywords viajan y hasKeyword cae al oracle si faltan', () {
  final c = Card.fromJson('Siren Lookout', {
    'qty': 1, 'mana_cost': '{2}{U}', 'cmc': 3, 'colors': 'U',
    'types': ['Creature'], 'subtypes': ['Siren', 'Pirate'],
    'oracle': 'Flying\nWhen Siren Lookout enters…',
    'keywords': ['flying', 'explore'], 'power': 1, 'toughness': 2,
  });
  expect(c.subtypes, ['Siren', 'Pirate']);
  expect(c.hasKeyword('flying'), isTrue);
  expect(c.hasKeyword('trample'), isFalse);
  final sinKw = Card.fromJson('X', {'qty': 1, 'cmc': 1, 'types': ['Creature'],
      'oracle': 'First strike'});
  expect(sinKw.hasKeyword('first strike'), isTrue); // fallback regex
});
```
App (`forge_pool_sets_test.dart`, patrón existente con DB en memoria): una carta
`type_line = 'Creature — Faerie Wizard // Instant — Adventure'` produce
`types == ['Creature']` y `subtypes == ['Faerie', 'Wizard']` (la cara trasera NO contamina),
y `keywords == ['flying']` con la columna `'["Flying"]'`.

- [ ] **Step 2:** correr ambos → FAIL.
- [ ] **Step 3: implementación.**
  - `models.dart`: campos `final List<String> subtypes; final List<String> keywords;`
    (default `const []`), en constructor y `fromJson`
    (`List<String>.from(json['subtypes'] ?? const [])`, keywords ya en minúsculas:
    `.map((k) => k.toString().toLowerCase())`).
    `bool hasKeyword(String k) => keywords.isNotEmpty ? keywords.contains(k) : oracle.toLowerCase().contains(k);`
  - `card_database.dart` rowToCard:
```dart
final face = ((r['type_line'] as String?) ?? '').split('//').first;
final parts = face.split('—');
// types = supertipos+tipos; subtypes = lo de detrás del «—» (tribus, tipos de tierra)
types: parts.first.trim().split(' ').where((t) => t.isNotEmpty).toList(),
subtypes: parts.length > 1
    ? parts[1].trim().split(' ').where((t) => t.isNotEmpty).toList()
    : const [],
keywords: _kwList(r), // jsonDecode con try/catch -> const []
```
    `_kwList`: `try { return (jsonDecode((r['keywords'] as String?) ?? '[]') as List).map((k) => k.toString().toLowerCase()).toList(); } catch (_) { return const []; }`
    Añadir `keywords` a la lista de columnas del `SELECT` de `buildPool`. La columna existe
    desde schema v4; para DB más vieja, envolver el `db.select` en try/catch que reintenta
    sin la columna (mismo patrón defensivo que `supportsYearFilter`).
- [ ] **Step 4:** tests PASS + `cd app && flutter analyze` limpio.
- [ ] **Step 5:** commit `"Forge: Card lleva subtipos y keywords estructuradas de la DB"`.

### Task 3: `lands.dart` — clasificador de tierras + espejo Python

**Files:**
- Create: `forge_engine/lib/src/lands.dart`; export en `forge_engine.dart`
- Create: `engine-reference/forge/lands.py`
- Test: `forge_engine/test/lands_test.dart`, `engine-reference/tests/test_lands.py`

**Interfaces (Produces):**
```dart
enum TappedKind { never, conditional, always }
class LandProfile {
  final Set<String> produces;   // WUBRG que puede dar (duales tipadas incluidas)
  final TappedKind tapped;
  final bool isFetch;
  final Set<String> fetches;    // colores buscables; vacío + isFetch = "basic land" genérica
  final bool isBasic;
  bool get isUtility => produces.isEmpty && !isFetch;
  /// ¿Cuenta como fuente de [color] en un mazo de [deckColors]?
  bool sourceOf(String color, String deckColors);
  static LandProfile fromCard(Card card);
}
```
`sourceOf`: `produces.contains(color) || (isFetch && (fetches.isEmpty ? deckColors.contains(color) : fetches.contains(color)))`.

- [ ] **Step 1: tests que fallan.** Fixtures reales (oracle copiado de la DB):

```dart
Card land(String name, String oracle, {List<String> sub = const []}) => Card(
    name: name, qty: 4, manaCost: '', cmc: 0, colors: '',
    types: const ['Land'], subtypes: sub, oracle: oracle);

test('básica', () {
  final p = LandProfile.fromCard(land('Plains', '({T}: Add {W}.)',
      sub: ['Plains'])..); // types ['Basic','Land'] en la real
  expect(p.produces, {'W'}); expect(p.tapped, TappedKind.never);
});
test('dual tipada condicional (Fetching Garden)', () {
  final p = LandProfile.fromCard(land('Fetching Garden',
      '({T}: Add {G} or {W}.)\nFetching Garden enters the battlefield tapped if it was played from your hand.',
      sub: ['Forest', 'Plains']));
  expect(p.produces, {'G', 'W'});
  expect(p.tapped, TappedKind.conditional);
});
test('tapland incondicional (Gate to Seatower)', () {
  final p = LandProfile.fromCard(land('Gate to Seatower',
      '({T}: Add {U}.)\nGate to Seatower enters the battlefield tapped.\n{3}{U}, {T}: Seek a nonland card.',
      sub: ['Island', 'Gate']));
  expect(p.produces, {'U'}); expect(p.tapped, TappedKind.always);
});
test('checkland: unless => conditional', () {
  final p = LandProfile.fromCard(land('Glacial Fortress',
      'Glacial Fortress enters the battlefield tapped unless you control a Plains or an Island.\n{T}: Add {W} or {U}.'));
  expect(p.produces, {'W', 'U'}); expect(p.tapped, TappedKind.conditional);
});
test('fetch genérica (Evolving Wilds)', () {
  final p = LandProfile.fromCard(land('Evolving Wilds',
      '{T}, Sacrifice Evolving Wilds: Search your library for a basic land card, put it onto the battlefield tapped, then shuffle.'));
  expect(p.isFetch, isTrue); expect(p.fetches, isEmpty);
  expect(p.sourceOf('R', 'RG'), isTrue); expect(p.sourceOf('U', 'RG'), isFalse);
});
test('fetch tipada (Flooded Strand)', () {
  final p = LandProfile.fromCard(land('Flooded Strand',
      '{T}, Pay 1 life, Sacrifice Flooded Strand: Search your library for a Plains or Island card, put it onto the battlefield, then shuffle.'));
  expect(p.fetches, {'W', 'U'});
});
test('utility incolora (Field of Ruin-style) queda utility', () {
  final p = LandProfile.fromCard(land('Wastes2', '{T}: Add {C}.'));
  expect(p.isUtility, isTrue);
});
test('any color', () {
  final p = LandProfile.fromCard(land('Evolving City',
      '{T}: Add one mana of any color.'));
  expect(p.produces, {'W', 'U', 'B', 'R', 'G'});
});
```

- [ ] **Step 2:** FAIL. **Step 3: implementación.** Reglas de parsing (orden importa):

```dart
const _basicTypeColor = {'Plains': 'W', 'Island': 'U', 'Swamp': 'B',
    'Mountain': 'R', 'Forest': 'G'};
static final _addClause = RegExp(r'add ([^\n.]*)');
static final _sym = RegExp(r'\{([wubrgc])\}');
static final _fetch = RegExp(r'search your library for ([^\n.]*land[^\n.]*)');
static final _tapped = RegExp(r'enters (the battlefield )?tapped');
```
1. `produces`: subtipos básicos (`_basicTypeColor[sub]`) ∪ símbolos WUBRG dentro de cada
   cláusula `add …` (en minúsculas) ∪ WUBRG entero si alguna cláusula add contiene
   `one mana of any color` / `mana of any one color`.
2. `tapped`: sin match → `never`; con match → la LÍNEA del match contiene `unless` o ` if ` →
   `conditional`, si no `always`.
3. `isFetch`/`fetches`: match de `_fetch`; en la cláusula capturada, nombres de
   `_basicTypeColor` → colores; `basic land` sin tipos concretos → `fetches` vacío (= genérica).
4. `isBasic`: `types.contains('Basic')` o nombre en el mapa de básicas (nieve incluida).
Python `lands.py`: dataclass `LandProfile` + `land_profile(card: dict)` con las mismas regex
y un `source_of(profile, color, deck_colors)`.
- [ ] **Step 4:** ambos verdes. **Step 5:** commit
  `"Forge: clasificador de tierras (produce/tapped/fetch) Dart+Python"`.

### Task 4: `recommendedLands` v2 (probabilidad, no solo fórmula)

**Files:**
- Modify: `forge_engine/lib/src/mana_curve.dart:60-70`
- Modify: `engine-reference/forge/curve.py:77-82`
- Test: `forge_engine/test/forge_engine_test.dart` (actualizar el test «Karsten 24»), `engine-reference/tests/test_curve_v2.py`

**Interfaces:** firma intacta `recommendedLands(cards, pool, archetype)`. Nueva const:
```dart
/// Turno al que cada arquetipo necesita haber caído tierra sí o sí.
const Map<String, int> landDropTurn = {'aggro': 3, 'tempo': 4, 'midrange': 4, 'control': 5};
```

- [ ] **Step 1: test primero.** El test viejo `«coste medio 3.0 sin fuentes baratas → 24 tierras»`
  se REESCRIBE justificado: mismo pool sintético, y el assert nuevo es
  `expect(n, inInclusiveRange(23, 25));` MÁS la propiedad que de verdad importa:
```dart
test('las tierras elegidas maximizan P(caídas) - 0.5*P(inundación) en su rango', () {
  final n = ManaCurve.recommendedLands(spells, pool, Archetype.midrange);
  double util(int k) => pLandDrops(k, 60, 4) -
      0.5 * hypergeomAtLeast(60, k, 4 + 8, 4 + 3);
  for (var k = 23; k <= 25; k++) {
    expect(util(n) + 1e-12, greaterThanOrEqualTo(util(k)));
  }
});
test('aggro barato elige menos tierras que control caro', () {
  expect(ManaCurve.recommendedLands(cheapSpells, pool, Archetype.aggro),
      lessThan(ManaCurve.recommendedLands(expensiveSpells, pool, Archetype.control)));
});
```
- [ ] **Step 2:** FAIL. **Step 3: implementación** (misma en Python):
```dart
static int recommendedLands(cards, pool, archetype) {
  final avg = averageCmc(cards, pool);
  final raw = 24 + (avg - 3.0) * 2 - cheapSources(cards, pool) / 3.5; // semilla Karsten
  final t = landDropTurn[archetype.name]!;
  double util(int n) =>
      pLandDrops(n, deckSize, t) -
      0.5 * hypergeomAtLeast(deckSize, n, t + 8, t + 3); // inundación: >=t+3 tierras al turno t+2
  var best = archetype.landMin;
  var bestU = double.negativeInfinity;
  for (var n = archetype.landMin; n <= archetype.landMax; n++) {
    var u = util(n);
    u -= (n - raw).abs() * 0.001; // desempate estable hacia la semilla Karsten
    if (u > bestU) { bestU = u; best = n; }
  }
  return best;
}
```
- [ ] **Step 4:** `dart test` + `pytest` verdes; correr TODO `dart test` (la suite del
  generador puede mover tierras ±1 en otros tests — actualizar asserts afectados con el
  valor nuevo y una línea de por qué).
- [ ] **Step 5:** commit `"Forge: nº de tierras elegido por probabilidad de caídas e inundación"`.

### Task 5: manabase v2 con no-básicas (60 cartas + Commander) + espejo

**Files:**
- Create: `forge_engine/lib/src/manabase.dart`; export
- Modify: `forge_engine/lib/src/generator.dart` (`_manaBase` → delega; `generateDeck`/`reforgeWithCurve` usan el resultado nuevo), `forge_engine/lib/src/commander.dart:158-205` (bloque de básicas → delega)
- Create: `engine-reference/forge/manabase.py`; Modify `generator.py:167-193`
- Test: `forge_engine/test/manabase_test.dart`, `engine-reference/tests/test_manabase.py`

**Interfaces (Produces):**
```dart
/// Tabla Karsten (mazo 60, ~90%): fuentes de UN color requeridas
/// por (nº símbolos, turno del coste). Clave: symbols*10 + turn.
const Map<int, int> karstenSources = {
  11: 14, 12: 13, 13: 12, 14: 11, 15: 10, 16: 9,
  22: 20, 23: 18, 24: 16, 25: 15, 26: 14,
  33: 23, 34: 22, 35: 21, 36: 20,
};
const Map<String, int> tappedBudget = {'aggro': 2, 'tempo': 3, 'midrange': 4, 'control': 6};

class ManabaseResult {
  final Map<String, int> lands;
  final Map<String, int> sourcesByColor; // fuentes efectivas (duales/fetch cuentan)
  final Map<String, int> requiredByColor; // objetivo Karsten por color
}

ManabaseResult? buildManaBase(Map<String, int> spells, Map<String, Card> pool,
    String colors, int nLands,
    {required String archetypeName, int copyCap = 4, int deckSize = 60});
```

- [ ] **Step 1: tests que fallan.**
```dart
test('con duales cumple Karsten donde las básicas no llegan', () {
  // 4x doble-símbolo {W}{W} t2 y 4x {U}{U} t2 => 20+20 fuentes: imposible con 24 básicas
  final r = buildManaBase(spellsWWyUU, poolConDuales8, 'WU', 24,
      archetypeName: 'midrange')!;
  expect(r.sourcesByColor['W']!, greaterThanOrEqualTo(r.lands.values.fold(0,(a,b)=>a+b) < 24 ? 0 : 16));
  // la manabase con duales domina a la de solo básicas en la peor fuente:
  final soloBasicas = buildManaBase(spellsWWyUU, poolSoloBasicas, 'WU', 24,
      archetypeName: 'midrange')!;
  double worst(ManabaseResult m) => ['W','U'].map((c) =>
      m.sourcesByColor[c]! / m.requiredByColor[c]!).reduce(min);
  expect(worst(r), greaterThan(worst(soloBasicas)));
});
test('respeta tope de taplands por arquetipo', () {
  final r = buildManaBase(spells, poolConMuchosTaplands, 'RG', 22,
      archetypeName: 'aggro')!;
  final tap = r.lands.entries.where((e) =>
      LandProfile.fromCard(pool[e.key]!).tapped == TappedKind.always)
      .fold(0, (a, e) => a + e.value);
  expect(tap, lessThanOrEqualTo(2));
});
test('fetch cuenta como fuente de ambos colores', () { … });
test('máx 4 copias de no-básica; básicas libres; nunca más de lo poseído', () { … });
test('monocolor sin duales = comportamiento de hoy (todo básicas)', () {
  final r = buildManaBase(spellsMonoW, poolSoloBasicas, 'W', 24,
      archetypeName: 'midrange')!;
  expect(r.lands, {'Plains': 24});
});
test('color sin ninguna fuente posible => null (igual que hoy)', () { … });
```
(los `…` de arriba se escriben completos en el propio test — casos directos con
pools sintéticos de 3-5 cartas, mismo estilo que los primeros).

- [ ] **Step 2:** FAIL. **Step 3: algoritmo** (idéntico en Python, iteración por orden
  de inserción = dict ordenado en ambos lados; candidatos SIEMPRE ordenados por
  `(nº colores que produce desc, tapped never<conditional<always, nombre asc)` antes del bucle):

```
1. requiredByColor: para cada color c de `colors` con símbolos en los hechizos:
   earliest = min cmc de una carta con >=1 símbolo c (clamp 1..6)
   maxSym   = max símbolos de c en un solo coste (clamp 1..3)
   turn     = max(earliest, maxSym)  // un {C}{C} no se juega antes del t2
   required = karstenSources[maxSym*10 + min(turn,6)]
2. candidatas = tierras del pool con LandProfile:
   - no-básicas: produces ⊆ colors  Y  produces ∩ colors ≠ ∅ (o fetch buscable en colors);
     utility (produces vacío sin fetch) FUERA.
   - básicas de los colores usados.
3. greedy nLands veces:
   gain(tierra) = Σ_c [sourcesByColor[c] < requiredByColor[c] && profile.sourceOf(c, colors)]
   - descarta tapped==always si tappedUsed >= tappedBudget[archetype]
   - elige max gain; empate → el orden de calidad del paso 2; si el mejor gain de una
     no-básica empata con una básica, gana la básica (más barata de girar y de poseer).
   - sin déficits (todos gain 0) → básica del color con menor sources/required;
     empate → orden WUBRG.
   - actualiza sourcesByColor con TODOS los colores que la tierra cubre, tappedUsed, copias.
4. algún color usado con sourcesByColor == 0 → null.
```
`generator.dart`: `_manaBase` pasa a
`buildManaBase(...)?.lands` (mismo contrato null); `generateDeck` guarda el
`ManabaseResult` completo para la fase 2 (campo nuevo `GeneratedDeck.manabase`,
nullable para no romper Commander hasta que lo rellene).
`commander.dart`: sustituir el bloque 158-205 por
`buildManaBase(chosen∪{comandante×2 símbolos}, pool, identity, 37, archetypeName: 'midrange', copyCap: 1, deckSize: 100)` — los símbolos del comandante se inyectan
sumándolo dos veces al mapa de hechizos que se le pasa (como hace hoy `addSyms(x2)`);
suelo de 6 básicas por color se conserva: tras el greedy, si una básica de color usado
quedó <6 y hay copias, convertir las no-básicas peor rankeadas hasta llegar (el test de
Commander existente debe seguir verde). Nota: `karstenSources` es tabla de 60; para 100
se escala `required = ceil(required * 100 / 60)` (aprox. suficiente, comentario en código).

- [ ] **Step 4:** `dart test` completo + `pytest` (espejo con los mismos pools sintéticos).
  Tests existentes de `_manaBase` solo-básicas: siguen verdes por el caso «monocolor sin
  duales» (paridad de comportamiento).
- [ ] **Step 5:** commit `"Forge: manabase con duales/fetch/taplands por objetivos Karsten"`.

### Task 6: PR1 — review, tests, merge

- [ ] `cd forge_engine && dart test` · `cd engine-reference && python3 -m pytest -q` ·
  `cd app && flutter test && flutter analyze` — TODO verde local.
- [ ] Subagente **reviewer** (diff completo de la rama; pedirle EXPLÍCITO: trazar primer-uso
  de `buildManaBase` desde `generateDeck`/`reforgeWithCurve`/`commander`, y EJECUTAR un
  benchmark del greedy con pool de 2.800 cartas — presupuesto <1 s por identidad).
- [ ] Subagente **tester** en paralelo con reviewer.
- [ ] Arreglos si los hay → PR `"Forja: maná por probabilidad y tierras no básicas"` →
  CI verde (`gh pr checks`) → merge (lo hace Claude) → `git pull` en main.

---

## PR2 — Fase 2: score (keywords, color pie, consistencia)

*(rama nueva desde main tras mergear PR1: `feat/forja-score-v2`)*

### Task 7: pesos de combate en `efficiency` + espejo

**Files:**
- Modify: `forge_engine/lib/src/classify.dart:117-143`, `engine-reference/forge/classify.py:108-134`
- Test: `forge_engine/test/generator_test.dart` (añadir grupo), `engine-reference/tests/test_classify_v2.py`

**Interfaces:**
```dart
/// Pesos de keywords de combate (sustituye el +0.8 plano). Suma con tope +2.0.
const Map<String, double> kwWeight = {
  'flying': 1.2, 'double strike': 0.9, 'menace': 0.8, 'haste': 0.7,
  'deathtouch': 0.6, 'lifelink': 0.6, 'first strike': 0.5,
  'vigilance': 0.3, 'reach': 0.2, 'trample': 0.2,
};
double efficiency(Card card, {String archetype = ''}); // haste ×1.5 si archetype=='aggro'
```
Trample extra: `+0.15 * (power - 3)` si `power >= 4` (arrollar solo paga en gordas).

- [ ] **Step 1: tests.**
```dart
test('volador vale más que arrollador pequeño a igualdad de stats', () {
  expect(efficiency(flier22cmc2), greaterThan(efficiency(trampler22cmc2)));
});
test('arrollar escala con el poder', () {
  // 6/6 cmc6 arrollador vs 6/6 cmc6 con alcance
  expect(efficiency(bigTrampler), greaterThan(efficiency(bigReacher)));
});
test('prisa vale más en aggro', () {
  expect(efficiency(hasty, archetype: 'aggro'), greaterThan(efficiency(hasty)));
});
test('tope +2.0: keyword soup no rompe la escala', () {
  expect(efficiency(kitchenSink), lessThanOrEqualTo(10));
});
test('sin columna keywords cae al oracle (double strike cuenta como first strike no)', () {
  // carta con keywords=[] y oracle 'Double strike' puntúa el peso de double strike
});
```
- [ ] **Step 2-4:** FAIL → implementar (bucle sobre `kwWeight` con `card.hasKeyword`,
  `if (k == 'haste' && archetype == 'aggro') w *= 1.5`, acumulador clamp 2.0; borrar
  `_keywords` regex vieja del bonus — sigue existiendo para `hasKeyword` fallback) → PASS
  ambos lados. Los llamadores pasan arquetipo donde lo saben: `_score` (generator),
  `_greedyFill` vía parámetro ya presente `archetypeName`, commander deja default.
- [ ] **Step 5:** commit `"Forge: evasión y combate pesados por keyword real, no +0.8 plano"`.

### Task 8: color pie en `detectTheme` + espejo

**Files:**
- Modify: `forge_engine/lib/src/generator.dart:46-72` (detectTheme firma `{String colors = ''}`), llamadores (`generateDeck:142`, `reforgeWithCurve:359`, `commander.dart:96`), `engine-reference/forge/generator.py:41-65`
- Test: `forge_engine/test/generator_test.dart`, `engine-reference/tests/test_generator.py`

**Interfaces:**
```dart
/// Colores naturales de cada tema (color pie). '' = cualquier color.
const Map<String, String> themeColors = {
  'lifegain': 'WB', 'sacrifice': 'BR', 'spells': 'UR', 'artifacts': 'WU',
  'counters': 'GW', 'tokens': 'WG', 'graveyard': 'BG',
};
```
Peso final del tema: `w * (natural == '' || colors == '' ? 1.0 : overlap ? 1.25 : 0.8)`
(weights pasan de `Map<String,int>` a `Map<String,double>`).

- [ ] **Step 1: test.** Pool sintético con lifegain y spells empatados a peso crudo:
  en identidad `WB` gana lifegain, en `UR` gana spells. Test de no-regresión: el caso
  del fixture real `«en WB el tema natural es lifegain»` sigue verde.
- [ ] **Step 2-4:** FAIL → implementar en ambos lados → PASS.
- [ ] **Step 5:** commit `"Forge: el color pie desempata los temas (lifegain es de WB, no de UR)"`.

### Task 9: score de mazo v2 + PR2

**Files:**
- Create: `forge_engine/lib/src/deck_score.dart`; export
- Modify: `forge_engine/lib/src/generator.dart` (score final en `generateDeck:170-176` y `reforgeWithCurve:452-459`), `models.dart` o `generator.dart` (`GeneratedDeck.eval`)
- Create: `engine-reference/forge/deck_score.py`; Modify `generator.py:196-209`
- Test: `forge_engine/test/deck_score_test.dart`, `engine-reference/tests/test_deck_score.py`

**Interfaces:**
```dart
class DeckEvaluation {
  final double efficiency;  // 0-10, media ponderada como hoy
  final double consistency; // 0-10: 6·pKeepableHand + 4·castabilidad media
  final double curve;       // 0-10: media t=1..4 de P(jugada de coste<=t al turno t)
  double get total => 0.5 * efficiency + 0.25 * consistency + 0.25 * curve;
}
DeckEvaluation evaluateDeck(Deck deck, Map<String, Card> pool,
    Map<String, int> sourcesByColor, {int deckSize = 60});
```
- castabilidad de una copia: `min` sobre sus colores de
  `pColorByTurn(sources_c, deckSize, clamp(cmc,1,6), symbols_c)`; sin símbolos → 1.0.
- curve: `S_t = Σ hist[1..t]` → `hypergeomAtLeast(deckSize, S_t, 6 + t, 1)`.
- `GeneratedDeck` gana `final DeckEvaluation? eval;` (posicional opcional al final);
  `score` pasa a ser `eval.total` donde hay manabase (60 cartas); Commander mantiene la
  media de efficiency hasta tener manabase result (rellena `sourcesByColor` del
  `buildManaBase` que ya usa desde PR1 — así que también evalúa).

- [ ] **Step 1: tests.**
```dart
test('mismo mazo con manabase coja puntúa menos', () {
  final bien = evaluateDeck(deck, pool, {'W': 14, 'U': 13});
  final mal = evaluateDeck(deck, pool, {'W': 14, 'U': 6});
  expect(mal.total, lessThan(bien.total));
});
test('curva imposible (todo cmc 6) hunde el componente curve', () {
  expect(evalTodoSeises.curve, lessThan(evalCurvaSana.curve));
});
test('el ranking de propuestas usa total, no solo media', () {
  // dos pools: uno bonito-inconsistente (gordas sin fuentes) y uno modesto-consistente;
  // generateProposals debe ordenar el consistente primero
});
```
- [ ] **Step 2-4:** implementar ambos lados; en `generate_proposals` de Python el score
  pasa a `evaluate_deck(...)['total']`. Actualizar goldens de
  `engine-reference/tests/test_acceptance.py` SI cambian, anotando en el commit por qué
  (el juez nuevo es probabilidad — cambio buscado).
- [ ] **Step 5:** commit. Después mismo cierre que Task 6: suites completas + reviewer
  (explícito: contratos `GeneratedDeck.eval` nullable — trazar TODOS los consumidores en
  `app/` con grep `\.score` y `whyItWorksFacts`) + tester → PR
  `"Forja: score por consistencia y curva jugable"` → CI → merge.

---

## PR3 — Fases 4+3: temas nuevos, simulador con cementerio, forja profunda

*(rama nueva desde main: `feat/forja-temas-simulacion`)*

### Task 10: tema reanimator

**Files:**
- Modify: `forge_engine/lib/src/classify.dart:20-54` (tema nuevo), `generator.dart` (`themeColors` += `'reanimator': 'BGU'`; gordas en `_greedyFill`), espejos Python
- Test: `forge_engine/test/generator_test.dart`, `engine-reference/tests/test_generator.py`

**Interfaces:** tema `'reanimator'`:
```dart
'reanimator': _Theme(
  RegExp(r'return .*creature.* from your graveyard to the battlefield|unearth|disturb|embalm|eternalize'),
  RegExp(r'mill (a card|\d+|up to)|surveil \d+|discard(s)? (a|two|three|your hand)'),
),
```
Gordas: en `_greedyFill`, si `theme == 'reanimator'` y la carta es criatura `cmc >= 5` con
`efficiency >= 6`: rol efectivo 'enabler' (+1.5) y el término de curva se acota a
`max(curveNeed, 0)` (sin castigo), máximo 6 copias de gordas así tratadas (contador local).

- [ ] **Step 1: tests.**
```dart
test('pool con reanimación+mill+gordas detecta reanimator y mete gordas', () {
  final gen = generateDeck(poolReanimator, 'B')!;
  expect(gen.theme, 'reanimator');
  expect(copiasCmc5oMas(gen.deck), greaterThanOrEqualTo(4));
});
test('control negativo: sin hechizos de reanimación las gordas se quedan fuera', () {
  final gen = generateDeck(poolSoloGordasYMill, 'B');
  expect(gen == null || gen.theme != 'reanimator', isTrue);
});
test('el validador sigue mandando: coste medio dentro del arquetipo', () { … });
```
- [ ] **Step 2-5:** ciclo TDD ambos lados; commit
  `"Forge: tema reanimator — las gordas valen su hechizo de reanimación, no su coste"`.

### Task 11: temas tribales

**Files:**
- Modify: `forge_engine/lib/src/generator.dart` (`detectTheme`: tribus compiten con temas mecánicos), `forge_engine/lib/src/classify.dart` (helper `tribalRole`), espejo `generator.py`/`classify.py`
- Modify: `forge_engine/lib/src/plan.dart` + `app/lib/services/forge_texts.dart` (texto para `tribal:*` y `reanimator`) + ARBs (2 claves × 10 idiomas: `ftThemeTribal`, `ftThemeReanimator`) + `flutter gen-l10n`
- Test: `forge_engine/test/generator_test.dart`, `app/test/services/` (forge_texts con tema `tribal:Elf`)

**Interfaces:**
- Tribu elegible: `>= 12` copias de criaturas del subtipo Y `>= 3` copias de payoffs.
- Payoff tribal: oracle (min.) contiene el nombre de la tribu (sing. o plural `s`) Y alguna de
  `other |you control|whenever|each `. Enabler: criatura con ese subtipo.
- Tema resultante: `'tribal:<Subtipo>'` (p. ej. `tribal:Elf`); peso = payoffs×3 + miembros×1,
  multiplicador de color pie 1.0 (tribus son de cualquier color).
- `forge_texts.dart`: `theme.startsWith('tribal:')` → clave `ftThemeTribal` con
  `{tribe}` interpolado (el subtipo va EN INGLÉS, como los nombres de carta — decisión previa).

- [ ] **Step 1: tests.** Pool con 14 Elfos + 4 payoffs («Other Elves you control get…») en G:
  `gen.theme == 'tribal:Elf'` y ≥10 elfos en el mazo. Control: 14 elfos SIN payoffs → tema
  mecánico o goodstuff. forge_texts: `tribal:Elf` produce texto con «Elf» y no revienta en
  los 10 idiomas (test paramétrico existente de forge_texts).
- [ ] **Step 2-5:** TDD; espejo Python de la detección; commit
  `"Forge: mazos tribales de verdad — los subtipos ya no se tiran"`.

### Task 12: simulador — cementerio + tierras reales

**Files:**
- Modify: `forge_engine/lib/src/simulator.dart` (_SimCard, _Player, _takeTurn, _expand)
- Test: `forge_engine/test/simulator_test.dart`

**Interfaces (solo-Dart, sin espejo — documentado en cabecera como hasta ahora):**
```dart
// _SimCard nuevo:
final Set<String> produces;   // de LandProfile; '' ya no existe, básicas -> {su color}
final bool entersTapped;      // LandProfile.tapped == always (conditional cuenta untapped)
final int millSelf;           // "mill N cards" propio
final bool loot;              // roba y descarta
final bool reanimates;        // return ... creature ... graveyard -> battlefield
// _Player nuevo:
final List<_SimCard> graveyard;
```
Cambios de juego (mantener determinismo):
1. Tierras: `me.lands` pasa a `List<Set<String>>`; una tierra `entersTapped` jugada este
   turno no cuenta para `mana` ni para `canPay` hasta el turno siguiente
   (flag `tappedNew` reseteado al inicio del turno). `canPay` empareja símbolos greedy:
   para cada símbolo requerido, gasta la tierra compatible con MENOS colores.
2. Todo lo que muere (combate, removal, sweeper) o se descarta va a `graveyard`.
3. `millSelf`: al resolverse, mueve N del final de `library` a `graveyard`.
   `loot`: roba 1 y descarta la carta de mayor cmc (criatura preferida — alimenta reanimator).
4. Prioridad nueva 2.5 (entre matar amenaza y bajar criatura): si hay `reanimates` pagable
   y en `graveyard` hay criatura con `cmc >= 5` → pagarlo y poner la de mayor power en
   mesa (`sick: !haste`).
5. Mulligan: sin cambios.

- [ ] **Step 1: tests.**
```dart
test('reanimator gana >55% a su gemelo sin reanimación (semilla fija)', () {
  final wr = simulateMatch(deckReanimator, pool, deckGemeloSinReanimar, pool,
      games: 200, seed: 7);
  expect(wr, greaterThan(0.55));
});
test('taplands cuestan tempo: aggro con 8 taplands pierde el espejo', () {
  final wr = simulateMatch(aggroTaplands, poolA, aggroUntapped, poolB,
      games: 200, seed: 7);
  expect(wr, lessThan(0.45));
});
test('determinismo se conserva', () {
  expect(simulateMatch(a, pa, b, pb, seed: 7), simulateMatch(a, pa, b, pb, seed: 7));
});
test('los muertos van al cementerio y el mill llena la tumba', () { … });
```
- [ ] **Step 2-5:** TDD; commit `"Simulador: cementerio, reanimación y tierras con colores/tapped reales"`.

### Task 13: forja profunda (ranking por simulación) + UI

**Files:**
- Create: `forge_engine/lib/src/deep_rank.dart`; export
- Modify: `app/lib/services/forge_job.dart` (campo `deepForge`), `app/lib/screens/forge_screen.dart` (switch tras el dropdown de arquetipo, `:423-431` zona de controles), ARBs (`fgDeepForge`, `fgDeepForgeHint` × 10) + gen-l10n
- Test: `forge_engine/test/deep_rank_test.dart`, `app/test/screens/forge_expansiones_test.dart` (widget)

**Interfaces:**
```dart
/// Reordena las [top] mejores propuestas por round-robin simulado.
/// ranking final = 0.6*winrate + 0.4*(score estático / 10). Determinista.
List<GeneratedDeck> rankBySimulation(
    List<GeneratedDeck> proposals, Map<String, Card> pool,
    {int games = 40, int seed = 7, int top = 6});
```
`runForgeJob`: `job.commander ? … : _maybeDeep(fe.generateProposals(…))` con
`_maybeDeep = job.deepForge ? fe.rankBySimulation(props, job.pool) : props`.
Switch UI: defecto ON, estado `_deepForge`, `SwitchListTile` con título/hint traducidos.

- [ ] **Step 1: tests.**
```dart
test('el mazo que gana el round-robin sube al puesto 1', () {
  // 3 propuestas artificiales donde la 3ª por score estático machaca en sim
});
test('con deepForge=false el orden estático se conserva', () { … });
test('presupuesto: 6 propuestas x 40 partidas < 15 s en esta máquina', () {
  final sw = Stopwatch()..start();
  rankBySimulation(seisPropuestas, pool);
  expect(sw.elapsed.inSeconds, lessThan(15));
}, tags: 'slow');
```
Widget test: el switch existe, arranca ON, y `ForgeJob` se construye con el valor del
switch (mismo patrón de test que el switch de «incluir cartas que no tengo»).
- [ ] **Step 2-5:** TDD; commit `"Forja profunda: las propuestas juegan entre sí antes de enseñarse"`.

### Task 13b: selector de Estilo (themeOverride motor + UI)

**Files:**
- Modify: `forge_engine/lib/src/generator.dart` (`generateDeck`/`generateProposals` ganan `String? themeOverride`; con override se salta `detectTheme` y el gate `minPayoffCopies`), espejo `engine-reference/forge/generator.py`
- Modify: `app/lib/services/forge_job.dart` (campo `theme`), `app/lib/screens/forge_screen.dart` (selector «Estilo» junto al dropdown de arquetipo; bottom sheet con secciones Auto / Temas / Tribus, mismo patrón visual que `showSetPickerSheet`)
- Modify: ARBs × 10 (`fgStyle`, `fgStyleAuto`, 8 claves de tema ya existentes en forge_texts se REUSAN, 24 claves `fgTribe*` nuevas) + `flutter gen-l10n`
- Test: `forge_engine/test/generator_test.dart`, `engine-reference/tests/test_generator.py`, `app/test/screens/forge_style_selector_test.dart`

**Interfaces:**
```dart
GeneratedDeck? generateDeck(Map<String, Card> pool, String colors,
    {String? name, String? archetypeOverride, String? themeOverride});
List<GeneratedDeck> generateProposals(Map<String, Card> pool,
    {int maxProposals = 5, String? allowedColors, String? archetypeOverride,
     String? themeOverride});
/// Tribus curadas para la UI (el motor acepta cualquier subtipo).
/// El valor es el subtipo Scryfall EN INGLÉS; el nombre visible se traduce.
const List<String> kUiTribes = ['Elf', 'Goblin', 'Zombie', 'Vampire', 'Dragon',
  'Angel', 'Demon', 'Dinosaur', 'Faerie', 'Merfolk', 'Human', 'Spirit',
  'Sliver', 'Wizard', 'Knight', 'Warrior', 'Soldier', 'Cat', 'Dog', 'Rat',
  'Pirate', 'Elemental', 'Giant', 'Rogue'];
```
Semántica del override: `theme = themeOverride`; `rolesByCard` se calcula igual
(tribal vía subtipos, mecánico vía `_themes`); cartas sin rol en ese tema puntúan sin
bonus (el greedy sigue llenando cuotas y curva). `detectTheme` NO se llama. Si tras el
greedy el mazo tiene 0 copias con rol en el tema forzado → null (ese color no puede
jugar ese estilo).

- [ ] **Step 1: tests.**
```dart
test('themeOverride tribal fuerza elfos aunque el peso natural sea otro', () {
  final gen = generateDeck(poolMixto, 'G', themeOverride: 'tribal:Elf')!;
  expect(gen.theme, 'tribal:Elf');
  expect(copiasConSubtipo(gen.deck, 'Elf'), greaterThanOrEqualTo(12));
});
test('override mecánico salta el gate de payoffs (mejor-esfuerzo)', () {
  // pool con solo 2 payoffs de lifegain (bajo el mínimo de 3): con override sale mazo
  expect(generateDeck(poolPocoLifegain, 'W', themeOverride: 'lifegain'), isNotNull);
});
test('estilo imposible en ese color => null', () {
  expect(generateDeck(poolSinElfos, 'U', themeOverride: 'tribal:Elf'), isNull);
});
test('generateProposals propaga themeOverride a todas las identidades', () { … });
```
Widget test: el selector muestra Auto por defecto; elegir «Elfos» construye `ForgeJob`
con `theme == 'tribal:Elf'`; funciona combinado con «incluir cartas que no tengo»
(mismo flujo de pool, sin código nuevo — el test solo fija que ambos flags viajan).
- [ ] **Step 2-4:** TDD ambos lados; traducciones de las 26 claves con el método rodado
  (es+en a mano, resto por tanda + check_lang).
- [ ] **Step 5:** commit `"Forja: elige tu estilo — tribus y temas forzables, el motor obedece"`.

### Task 14: docs + cierre PR3

- [ ] `docs/motor-forge.md`: actualizar secciones (tierras no básicas, score v2, temas
  tribal/reanimator YA implementados, forja profunda; qué sigue solo-Dart).
- [ ] Suites completas: `dart test` (motor) + `pytest` + `flutter test` + `flutter analyze`.
- [ ] Reviewer (explícito: primer-uso del switch desde estado cero — flujo teaser→selector→
  forjando→resultados con deepForge ON; y presupuesto de tiempo del isolate con pool de
  10 expansiones) + tester en paralelo.
- [ ] PR `"Forja: cementerio, tribus y forja profunda"` → CI → merge → actualizar memoria
  del proyecto (`project_manaforge.md` + memoria nueva de esta feature).

## Self-review del plan (hecho)

- Cobertura spec: 1a→T1, 1b→T4, 1c→T3, 1d→T5, 1e→T2, 2a→T2, 2b→T7, 2c→T8, 2d→T9,
  3a→T12, 3b→T13, 4a→T11, 4b→T10, 4c→T13b, fase 5 repartida en
  T1/T3/T4/T5/T7/T8/T9/T10/T11/T13b, docs→T14. Sin huecos.
- Tipos: `GeneratedDeck.eval` se define en T9 y solo se consume desde T9 en adelante;
  `ManabaseResult.sourcesByColor` nace en T5 y lo consume T9; `LandProfile` nace en T3 y
  lo consumen T5/T12. Firmas coherentes.
- Los `…` que quedan en bloques de test son casos ADICIONALES enumerados con su aserción
  descrita al lado; el implementador los escribe completos (regla: ningún test vacío).
