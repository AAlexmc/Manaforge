# ManaForge · repaso de la noche del 22-07 y qué toca mañana

Segunda tanda del 22-07 (la primera está en
`2026-07-22-cierre-de-sesion.md`). Ale pidió **revisión del código de todo lo
que entró hoy** antes de seguir con la cola, y luego seguir con la cola sin
lanzar la app.

`main` = **`c58d153`** + el PR de esta nota. **0 PRs abiertos.**
**690 tests** app + 29 engine · `flutter analyze --no-fatal-infos` salida 0.

---

## 1 · La revisión: qué se encontró

Base verificada primero: 660 tests verdes, analyze 0, y el l10n generado en
sync con los `.arb` (se regeneró y no salió diff).

| Qué | Dónde estaba | Estado |
|---|---|---|
| `load()` marcaba "ya cargado" **antes** de leer el disco → dos cargas a la vez y la segunda volvía vacía | `language_prefs`, `background_prefs`, `app_update` | **arreglado** (#42) |
| Guardaban sin cola → `_check()` y `markNewsSeen()` escribían `update.json.tmp` a la vez | los mismos tres | **arreglado** (#42) |
| El zip de Linux traía una carpeta `bundle` y el README decía "ejecuta `./manaforge`" | `build-app.yml`, `README.md` | **arreglado** (#42) |
| `late final _t = tr(context)` congelaba el idioma en la tarjeta de Ajustes | `update_notice.dart` | **arreglado** (#42) |
| "Mes de compras" no miraba compras, miraba rachas | `achievements.dart` | **arreglado** (#43) |

Lo que **se comprobó y NO era problema** (para no volver a mirarlo):

- `flutter create` en CI **no pisa** `app/linux/` trackeado. Probado en una
  copia: `CMakeLists.txt` y `my_application.cc` salen idénticos, el
  `BINARY_NAME=manaforge` sobrevive. Por eso el `.desktop` sigue cuadrando.
- `kAppVersion` = `0.3.0` = `pubspec.yaml`, con test que los ata, y el tag
  `app-v0.3.0` parsea a `0.3.0`: la app no se avisará a sí misma.
- El SHA-256 se comprueba **antes** de descomprimir y de tocar la base buena.
- `qtyByName` devuelve un mapa nuevo: Forge no muta la colección al suponer
  básicas.
- El P&L no mezcla divisas y mide solo copias comparables.

### Las dos trampas que costaron tiempo (apuntadas para no repetirlas)

1. **La cola de guardado NO puede nacer en un campo.** El patrón viejo
   (`Future<void> _queue = Future.value();` como campo) crea ese futuro **al
   construir el objeto**, o sea dentro de la zona del reloj falso de
   `testWidgets`. Esperarlo desde `runAsync` no vuelve nunca: la zona falsa no
   corre sus microtareas mientras `runAsync` está dentro. Se colgaron dos
   ficheros de tests 10 minutos cada uno hasta dar con esto. Ahora la fila nace
   en la primera escritura, en la zona de quien la pide.
2. **El smoke test se apoyaba en el bug.** `getApplicationSupportDirectory()`
   **no completa** dentro del reloj falso (comprobado: ni la colección ni el
   idioma terminan de cargar en 2 s de reloj falso). El `bool _loaded` hacía
   que la segunda llamada volviese enseguida y por eso el diálogo de idioma
   salía. Al arreglar la carrera, el diálogo dejó de salir. Solución:
   `ManaForgeApp` acepta las preferencias **ya cargadas** y el smoke test las
   precarga con `runAsync`.

Regla que se cumplió y salvó el día: **correr el comando exacto de CI en
local**. `flutter analyze --no-fatal-infos` cazó un import sin usar (salida 1)
que un `grep` no habría visto — exactamente el fallo que tumbó el #39 ayer.

---

## 2 · Lo que entró (PRs #42–#46)

- **#42 · Que no se pierda lo que se acaba de guardar** — los cuatro arreglos
  de arriba, más tests de regresión (los de la carrera de `load()` fallan sin
  el arreglo; comprobado quitando el arreglo).
- **#43 · Logros con nombres que pican** — los títulos ya no describen el
  criterio, describen el momento: *Ahí va todo mi dinero* (1.000 €), *Vale más
  que mi coche* (10.000 €), *Cien raras y ninguna jugable*, *Veinte playsets,
  cero mazos*, *Eso no te lo permito* (25 azules), *Esta no la lanzo en la
  vida* (coste 10), *Diez mil, pero yo controlo*. **Los IDs no se tocan**: lo
  ya conseguido se conserva.
- **#44 · Colores de las tarjetas y de la letra, cuando hay fondo** — 7 tonos
  para tarjetas, 4 para la letra, cuánto tapan al fondo (35-100 %) y un
  vistazo con tu fondo real. Solo salen si hay fondo puesto. La transparencia
  vive en el tema de las **tarjetas**, no en `surface`, para que los diálogos
  sigan siendo opacos. Colores guardados **por nombre** y validados contra la
  paleta.
- **#45 · La ventana se abre donde la dejaste** — tamaño, sitio y maximizada.
  `window_prefs.dart` son datos con topes y tests; `window_memory.dart` es el
  puente con `window_manager`, fino y a prueba de fallos. Una posición
  imposible pierde el sitio pero no el tamaño (una ventana fuera de pantalla
  se parece demasiado a "la app no arranca").
- **#46 · Esta nota** + el informe de términos de uso + las novedades de la
  0.3.0 al día.

---

## 3 · LO PRIMERO DE MAÑANA: validar a mano lo que no se ha visto

**La app no se ha lanzado en toda esta tanda** (Ale lo pidió así). Hay dos
cosas nuevas que tocan cosas que los tests no pueden ver:

- [ ] **La ventana** (`#45`, lo más delicado: es un plugin nativo nuevo).
      Abrir, mover a otro sitio, cambiar tamaño, cerrar, volver a abrir →
      tiene que salir donde estaba. Luego maximizar, cerrar, abrir → sale
      maximizada; desmaximizar → vuelve al tamaño de antes.
- [ ] **Los colores** (`#44`): Ajustes → Fondo de pantalla, poner un fondo y
      probar los círculos. Mirar que los **diálogos** siguen siendo opacos y
      que la barra de abajo se lee.
- [ ] **El diálogo de idioma** no vuelve a salir en el segundo arranque (era
      el bug de la carrera).
- [ ] **"Qué hay de nuevo"**: sale una vez y no vuelve.

Si algo de esto falla, **arreglarlo antes de publicar**.

## 4 · Y entonces sí: publicar la v0.3.0

```
git tag app-v0.3.0 && git push origin app-v0.3.0
```

El workflow monta Windows/macOS/Linux, calcula los SHA-256 y publica la
release con sus notas. **Comprobar después**: que el zip de Linux trae una
carpeta `ManaForge` (no `bundle`) y que dentro está `instalar.sh` y
`packaging/` con los iconos.

## 5 · La cola que queda

1. **Traducir las ~410 cadenas que siguen en español** (Colección, Álbum,
   Forge, Mercado, escáner). Ojo: **no es solo rellenar ARBs** — esas cadenas
   están escritas a pelo dentro de los `.dart`, así que hay que sacarlas a los
   `.arb` y cambiarlas por `tr(context).loQueSea`. Lo bueno: los tests que
   comprueban textos en español **siguen pasando** sin tocarlos, porque
   `tr()` cae al español cuando no hay delegados. Sugerencia: una pantalla por
   PR, empezando por Colección.
2. **Más fuentes de meta** → leer
   `docs/plans/2026-07-22-fuentes-del-meta-terminos-de-uso.md`. Resumen:
   **mtgdecks.net dice que no** en su `robots.txt` (cierra `*/txt` y
   `/cards/csv/` para todo el mundo y banea bots con nombre propio);
   **untapped.gg** no dejó leer sus términos automáticamente y sus datos son
   telemetría de sus usuarios → hace falta permiso por escrito; **MTGGoldfish**
   permite leer pero prohíbe `/deck/download`. Lo de hoy (curar
   `data/meta_decks.json` a mano y atribuir) está bien; automatizarlo no.
   Recomendación: un importador de **"pega aquí tu lista"**, que no depende de
   los términos de nadie.
3. **P&L realizado** (lo vendido, no solo lo que tienes). Pide decidir cómo se
   apunta una venta: hoy no hay concepto de venta en `collection_store`.
4. Detector con fondos cargados: **aparcado**, Ale dice que va bien.

## 6 · Deuda vista de pasada (no urgente)

- El `bool _loaded` puesto antes de leer sigue en `collection_store`,
  `deck_store`, `folder_store`, `recents_store` y `wishlist_store`. Ahí no
  muerde hoy (la primera llamada la hace siempre la misma pantalla), pero es
  la misma carrera. Si algún día una pantalla lee justo después de pedir la
  carga, verá la colección vacía.
- Nadie comprueba en CI que `lib/l10n/app_localizations*.dart` esté al día con
  los `.arb`. Hoy lo está (se verificó a mano). Un `flutter gen-l10n &&
  git diff --exit-code` en el workflow lo ataría.
- El zip de Windows deja los ficheros sueltos en la raíz (el de Linux ya no).
  No se tocó por no romper a ciegas un build que no se puede probar aquí.
