# Carpetas en Colección · Logros y niveles · Certificados

> **Estado 2026-07-21 noche:** Fase 1 (carpetas) y Fase 2 (logros y niveles)
> HECHAS y en verde (307 tests). Fase 3 (certificados) sigue sin construir.
> Las cuatro decisiones de abajo las tomé yo con Ale ausente: son lo primero
> que hay que confirmar.

**Objetivo:** organizar la colección en carpetas con su valor, y añadir una capa de
progresión (logros + nivel) que dé una razón para seguir completando cosas.

**Arquitectura:** dos almacenes JSON nuevos al lado de los que ya hay
(`folders.json`, `achievements.json`), el mismo patrón de `DeckStore`; la
valoración sigue saliendo de `computeCollectionValue` para que los totales
cuadren con Inicio y Mercado; los filtros de la colección se extraen a un
fichero propio para que carpeta y "Todas las cartas" usen EXACTAMENTE el mismo
código.

**Stack:** Flutter/Dart, sqlite3 (base de cartas ya existente), JSON local.

---

## Decisiones (tomadas 2026-07-21 con Ale ausente — revisar si alguna no gusta)

Ale dejó cuatro preguntas abiertas. Respuestas elegidas y por qué:

1. **¿Una carta puede estar en varias carpetas?** → **Sí.** La carpeta es una
   etiqueta sobre la colección, no un cajón exclusivo. Exclusivo obligaría a
   "sacar de una para meter en otra" y a decidir dónde vive lo no clasificado.
2. **¿En qué se diferencia de un Mazo?** → El **mazo** es una lista jugable
   (formato, curva, tierras, lo genera Forge y puede pedir cartas que NO tienes).
   La **carpeta** es organización física de lo que SÍ tienes: sin reglas, sin
   límite de copias, sin validación. Carpeta = "mis rares de Aetherdrift", "para
   vender", "la caja de arriba".
3. **¿Guarda cantidades?** → **Solo pertenencia.** La cantidad la manda siempre
   la colección: si tienes 3 copias y la carta está en la carpeta, la carpeta
   vale por 3. Guardar cantidades aparte crea dos contabilidades que se
   desincronizan (escaneas una copia nueva y la carpeta se queda desfasada).
4. **¿Y si borras de la colección una carta que está en carpetas?** → La carpeta
   **NO olvida** el id: se filtra al pintar y se enseña "N cartas ya no están en
   tu colección" con botón para limpiarlas. Borrar en silencio es perder datos
   del usuario sin poder deshacer; si la vuelve a añadir, reaparece sola.

## Estructura de ficheros

**Crear**
- `app/lib/services/folder_store.dart` — `CardFolder` + `FolderStore` (JSON).
- `app/lib/services/folder_value.dart` — valor de una carpeta reusando `computeCollectionValue`.
- `app/lib/screens/collection_filters.dart` — filtros puros + barra de filtros (extraído de `coleccion_screen.dart`).
- `app/lib/screens/all_cards_screen.dart` — la lista completa de hoy, ahora tras botón.
- `app/lib/screens/folder_detail_screen.dart` — cartas de una carpeta + valor + editar.
- `app/lib/screens/folder_pick_screen.dart` — marcar cartas de la colección con los filtros de siempre.
- `app/lib/services/achievements.dart` — catálogo + evaluación (Dart puro, sin Flutter).
- `app/lib/services/achievement_store.dart` — desbloqueos, XP, contadores persistentes.
- `app/lib/screens/logros_screen.dart` — nivel, barra de XP, rejilla de medallas.
- Tests: `app/test/services/folder_store_test.dart`, `app/test/services/folder_value_test.dart`,
  `app/test/screens/collection_filters_test.dart`, `app/test/services/achievements_test.dart`,
  `app/test/services/achievement_store_test.dart`.

**Modificar**
- `app/lib/screens/coleccion_screen.dart` — pasa a ser portada de carpetas + "Todas las cartas".
- `app/lib/services/card_database.dart` — `oracleByPrintings()` (para el valor por carpeta) y
  `rarityByOracles()` / `yearsByOracles()` (para logros).
- `app/lib/services/collection_store.dart` — cuenta de foils importados (`foils`), contador de escaneos.
- `app/lib/screens/import_csv_screen.dart` + `parseManaBoxCsv` — leer la columna `Foil`.
- `app/lib/main.dart` — instanciar `FolderStore` y `AchievementStore`, pasarlos abajo.
- `app/lib/screens/home_screen.dart` — tarjeta de nivel + acceso a Logros.

---

## Fase 1 — Carpetas

### Tarea 1.1: `FolderStore`

**Files:** crear `app/lib/services/folder_store.dart`, test `app/test/services/folder_store_test.dart`.

**Interfaces (produce):**
```dart
class CardFolder {
  final String id;          // micros desde época, como SavedDeck
  final String name;
  final int colorValue;     // color de la portada (ARGB)
  final String icon;        // nombre del icono de Material, p.ej. 'folder'
  final Set<String> cardIds;// oracleIds; SOLO pertenencia
  final String createdAt;   // ISO-8601
  Map<String, dynamic> toJson();
  factory CardFolder.fromJson(Map<String, dynamic> json);
}

class FolderStore extends ChangeNotifier {
  List<CardFolder> get folders;             // creación más reciente primero
  Future<void> load();
  CardFolder create({required String name, int colorValue, String icon, Set<String> cardIds});
  void rename(String id, String name);
  void setAppearance(String id, {int? colorValue, String? icon});
  void setCards(String id, Set<String> cardIds);
  void toggleCard(String id, String oracleId);
  void removeMissing(String id, Set<String> ownedOracleIds); // limpieza manual
  void remove(String id);
  int foldersContaining(String oracleId);
}
```

- [ ] **Paso 1: test que falla** — crear carpeta, marcar cartas, guardar y releer del JSON;
      `toggleCard` idempotente; `fromJson` tolera `cards` ausente.
- [ ] **Paso 2:** `flutter test test/services/folder_store_test.dart` → FAIL.
- [ ] **Paso 3:** implementar copiando el patrón de `DeckStore` (fichero `folders.json`,
      `getApplicationSupportDirectory`, `_file()` devuelve null en tests, catch de corrupto).
- [ ] **Paso 4:** test en verde.
- [ ] **Paso 5:** commit `Carpetas: almacén folders.json`.

### Tarea 1.2: valor por carpeta que cuadra con Inicio/Mercado

**Files:** crear `app/lib/services/folder_value.dart` + test; modificar `card_database.dart`.

`computeCollectionValue` valora por edición exacta cuando hay datos de printing.
La carpeta es a nivel oracle, así que para no romper el cuadre se restringen las
printings a las que pertenecen a cartas de la carpeta:

```dart
// card_database.dart
Future<Map<String, String>> oracleByPrintings(Iterable<String> keys); // "set|num" -> oracleId

// folder_value.dart
Future<CollectionValuation> computeFolderValue({
  required CardFolder folder,
  required CollectionStore collection,
  required CardDatabase db,
});
```
Filtra `collection.cards` a `folder.cardIds`, filtra `printingQty` a las claves cuyo
oracle está en la carpeta y llama a `computeCollectionValue` con `byPrinting:
collection.hasPrintingData`. Suma de carpetas ≤ total de la colección, misma fórmula.

- [ ] test: colección con 2 cartas y printings, carpeta con una → valor = el de esa carta.
- [ ] test: sin datos de printing → `approximate == true`.
- [ ] commit `Carpetas: valor con la fórmula compartida`.

### Tarea 1.3: extraer los filtros de la colección

**Files:** crear `app/lib/screens/collection_filters.dart` + test; modificar `coleccion_screen.dart`.

Mover tal cual la lógica de `_applyFilters` y el `Wrap` de chips/desplegables:

```dart
class CollectionFilters {
  final Set<String> colors; final int? cmc; final String? type;
  final int? minPower; final int? minToughness;
  bool get any;
  List<OwnedCard> apply(List<OwnedCard> cards);
  CollectionFilters copyWith(...); CollectionFilters cleared();
}
class CollectionFilterBar extends StatelessWidget {  // chips + dropdowns
  final CollectionFilters value; final ValueChanged<CollectionFilters> onChanged;
}
```
`sortCollection` y `CollectionSort` se mueven aquí también (hoy viven en
`coleccion_screen.dart`; los importa `all_cards_screen` y el selector de carpeta).
Reexportar desde `coleccion_screen.dart` para no romper los tests que ya existen.

- [ ] test: los mismos casos que ya cubre `album_filters_test` en espíritu (color, coste 6+, tipo, ataque/defensa, limpiar).
- [ ] commit `Colección: filtros y orden en su propio fichero`.

### Tarea 1.4: portada de Colección con carpetas + "Todas las cartas"

**Files:** crear `all_cards_screen.dart`, `folder_detail_screen.dart`, `folder_pick_screen.dart`;
modificar `coleccion_screen.dart`, `main.dart`.

- `ColeccionScreen`: cabecera (total cartas / distintas / valor), botón grande
  **"Todas las cartas"**, botón **"Nueva carpeta"**, y rejilla de carpetas con
  nombre, nº de cartas y valor en €. Se mantienen el buscador, el FAB Escanear y
  los accesos a Álbum e Importar CSV.
- `AllCardsScreen`: exactamente la lista de hoy (búsqueda, filtros, orden, ±cantidad).
- `FolderPickScreen`: lista de la colección con checkbox + `CollectionFilterBar` +
  selector de orden + contador "N seleccionadas" + guardar.
- `FolderDetailScreen`: cartas de la carpeta (mismos filtros), valor, renombrar,
  cambiar icono/color, añadir/quitar cartas, borrar carpeta, aviso de cartas que
  ya no están en la colección con botón "Quitarlas de la carpeta".

- [ ] test de widget: con colección vacía la portada ofrece crear carpeta y no revienta.
- [ ] test de widget: pulsar "Todas las cartas" abre la lista con las cartas.
- [ ] commit `Colección: carpetas con su valor y la lista completa tras un botón`.

---

## Fase 2 — Logros y niveles

### Diseño

- **XP por logro según rareza:** bronce 10 · plata 25 · oro 60 · mítico 150.
- **Nivel:** curva suave, `xpParaNivel(n) = 100 * n * (n + 1) / 2` (nivel 2 a los
  100 XP, nivel 5 a 1.500, nivel 10 a 5.500). Título por tramo:
  Aprendiz (1-4) · Invocador (5-9) · Archimago (10-19) · Maestro (20-34) ·
  Planeswalker (35+).
- **Evaluación pura:** `evaluate(AchievementSnapshot)` devuelve progreso 0..1 y
  `unlocked` por logro. La pantalla no calcula nada.
- **Persistencia:** `achievements.json` = `{unlocked: {id: isoDate}, counters: {...}, seenLevel: n}`.
  Los contadores acumulativos (cartas escaneadas, días distintos con actividad,
  mazos creados) los sube la app cuando pasa la cosa; el resto sale de la colección.

```dart
enum AchievementTier { bronze, silver, gold, mythic }
enum AchievementCategory { coleccion, rareza, color, expansiones, valor, forge, escaner, dedicacion, curiosidades }

class Achievement {
  final String id, title, description;
  final AchievementCategory category;
  final AchievementTier tier;
  final num goal;                       // meta numérica
  final num Function(AchievementSnapshot) progress; // valor actual
  final bool secret;                    // no se enseña la descripción hasta lograrlo
  int get xp;
}

class AchievementSnapshot {
  final int totalCopies, distinctCards, foilCount, setsCompleted, decksSaved,
      foldersCreated, cardsScanned, activeDays, longestStreak, wishlistCount;
  final Map<String, int> byColor, byRarity, byType, byYear, bySetOwned, bySetTotal;
  final double totalValue, bestCardValue;
  final int maxCmc, distinctSets, distinctArtists;
}

class AchievementState { final Achievement a; final double progress; final bool unlocked; final DateTime? at; }
List<AchievementState> evaluateAchievements(AchievementSnapshot s, Map<String, String> unlocked);
int totalXp(List<AchievementState> states);
({int level, String title, int xpInLevel, int xpForNext}) levelFor(int xp);
```

### Catálogo (mínimo 70 logros)

Escalones repetidos por tramos, que es lo que engancha en Pokémon TCG Pocket,
Hearthstone y ManaBox:

- **Colección** (8): 1 / 10 / 50 / 100 / 500 / 1.000 / 5.000 / 10.000 copias.
- **Distintas** (5): 25 / 100 / 500 / 1.000 / 2.500 cartas distintas.
- **Rareza** (12): 10/50/200 comunes, 10/50/200 infrecuentes, 5/25/100 raras,
  1/10/50 míticas.
- **Color** (12): 25 y 100 de cada color (W/U/B/R/G) + 25 incoloras +
  "Arcoíris" (las 5 en un mismo día) + "Cinco colores" (una carta con las 5).
- **Expansiones** (10): 1/5/10/25/50 sets tocados, 1/3/10 sets **completos**,
  set completo de la expansión más reciente, set completo pre-2003.
- **Valor** (8): colección de 10 € / 50 € / 250 € / 1.000 € / 5.000 €;
  una carta de 20 € / 100 € / 500 €.
- **Foils** (6): 1 / 10 / 50 / 200 foils; una foil de 50 €; carpeta solo de foils.
- **Forge** (8): 1/5/25 mazos guardados, mazo con puntuación ≥ 90, mazo mono-color,
  mazo de 3+ colores, mazo commander, mazo sin tierras básicas.
- **Escáner** (7): 1 / 50 / 500 / 2.000 cartas escaneadas, página de álbum entera
  (9 de 9), 10 cartas en una sola foto, escanear sin ningún "revisar".
- **Dedicación** (8): usar la app 2 / 7 / 30 / 100 días distintos; racha de 3 / 7 / 30
  días; añadir cartas en 4 semanas seguidas.
- **Carpetas** (4): crear la primera, 5 carpetas, una carpeta de 100+ cartas,
  una carpeta que valga 100 €+.
- **Curiosidades / secretos** (10): tener las cinco tierras básicas; una criatura
  de fuerza ≥ 10; una carta de coste 0; una carta de coste 10+; 4 copias de la
  misma carta ("playset"); 20 playsets; una carta de cada tipo (criatura,
  instantáneo, conjuro, artefacto, encantamiento, tierra, planeswalker);
  una carta de los 90; el mismo nombre en dos idiomas; wishlist de 20 cartas.

### Tareas

- [ ] **2.1** `achievements.dart`: enums, `Achievement`, `AchievementSnapshot`,
      `evaluateAchievements`, `levelFor`, catálogo completo. Tests: progreso
      parcial, desbloqueo exacto en la meta, XP total, curva de niveles,
      **ids únicos** y **todos los logros alcanzables** (goal > 0). Commit.
- [ ] **2.2** `achievement_store.dart`: JSON, `unlock(id)`, `bump(counter)`,
      `markDayActive()` (días distintos + racha, en UTC como `addedLabel`),
      `newlyUnlocked` para avisar una sola vez. Tests: racha rota, mismo día dos
      veces, fichero corrupto. Commit.
- [ ] **2.3** `snapshotFrom(collection, db, decks, folders, store)` en
      `services/achievement_snapshot.dart` (consulta rareza/año/set a la base de
      cartas con `rarityByOracles`). Test con base falsa. Commit.
- [ ] **2.4** `logros_screen.dart`: cabecera con nivel, barra de XP, "N de M
      logros", filtro por categoría, medallas bloqueadas en gris con su progreso
      ("34/50"), secretas tapadas. Acceso desde Inicio (tarjeta de nivel) y
      Ajustes. Aviso `SnackBar` al desbloquear. Test de widget. Commit.

---

## Fase 3 — Certificados descargables (apuntado, aún sin construir)

Idea de Ale: al completar una colección entera (una expansión, o un reto grande),
poder **descargar un certificado**. Diseño previsto:

- Widget `CertificateCard` renderizado con `RepaintBoundary` →
  `toImage(pixelRatio: 3)` → PNG guardado con `FilePicker.saveFile` (o
  `getSaveLocation` de `file_selector`, que ya se usa para abrir).
- Contenido: nombre de la expansión + símbolo, nº de cartas, fecha de
  finalización, nombre del coleccionista, sello ManaForge y un código corto
  (hash del set + fecha) para que sea verificable/no genérico.
- Se ganan al 100 % de un set en el Álbum, y también por logros míticos.
- Pantalla "Mis certificados" dentro de Logros, con volver a descargar.

Pendiente decidir con Ale: ¿solo sets, o también logros? ¿PDF además de PNG?

## Bloques que siguen pendientes (de la nota de la sesión anterior)

- **A. Multi-mercado** (Cardmarket/TCGplayer/CardKingdom/Mana Pool/Cardhoarder).
- **B. Divisas** (conversión con tipos del BCE, marcada como aproximada).
- **D. Pestaña "Escanear"** propia en la barra de abajo.
