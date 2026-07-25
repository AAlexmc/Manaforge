# Reset de fábrica — diseño (2026-07-25)

Pedido de Ale (literal): botón en Ajustes que deja la app sin cartas ni bases instaladas.
Flujo: clic → diálogo donde hay que escribir `ELIMINAR` → segundo diálogo donde hay que
escribir `CONFIRMAR` → **backup automático ANTES de borrar nada**. Decisiones de alcance
tomadas en modo auto (Ale delegó).

## Alcance del borrado

**Se borra TODO el contenido de `getApplicationSupportDirectory()` SALVO la carpeta
`backups/`.** Eso incluye:

- Almacenes de usuario: `collection.json`, `folders.json`, `decks.json`, `wishlist.json`,
  `achievements.json`, `certificates.json`, `market.json`, `recents.json`,
  `value_history.json`, `price_history.jsonl`, `price_history.json.migrado`.
- Preferencias: `background.json` + imágenes `background_*`, `language.json`,
  `home_layout.json`, `onboarding.json` (tour), `update.json` (novedades/firstRun),
  `window.json`, `meta_decks.json`.
- Bases descargadas: `manaforge_cards.sqlite`, `manaforge_prices.sqlite`,
  `manaforge_hashes.sqlite`.
- Residuos: `*.roto`, `*.tmp`, `*.restore-tmp`, `*.gz`.

`backups/` se conserva ÍNTEGRA: ahí vive la copia automática pre-reset → el reset es
deshacible restaurando desde Ajustes (las bases se re-descargan, no van en copias).

Resultado = estado de primer arranque: próximo alzado pregunta idioma, enseña tour,
StartupScreen descarga bases. En caliente (sin cerrar la app): mismo mecanismo que
restaurar — `_session++` tira `HomeShell`, `_started=false` → StartupScreen re-descarga.

## Orden de operaciones (servicio `services/factory_reset.dart`, dos mitades)

1. `preResetBackup(dataDir)` → `writeBackupFile(prefix: 'pre-reset')`.
   - `BackupError.noData` (no hay nada que copiar) → devuelve null y se sigue.
   - CUALQUIER otro error → **lanza y no se borra nada** (la UI enseña el error).
2. `wipeDataDir(dataDir)`: iterar `dataDir.list()`, saltar `backups`, borrar recursivo.
   Fallos individuales se acumulan y se reportan (no abortan el resto).
3. Devuelve `FactoryResetReport { backupFile, deleted, failed }`.

En dos mitades porque entre copia y borrado `HomeShell` cierra los sqlite y limpia el
fondo: si la copia falla, se aborta ANTES de tocar nada. Lógica pura sobre `Directory`
(sin plugins) → testeable como `backup.dart`.

## Handles sqlite — cerrar ANTES de borrar (crítico Windows)

`CardDatabase.close()` y `PriceSeriesDatabase.close()` existen y las llama `HomeShell`
entre copia y borrado. `ScannerDatabase` NO mantiene handle (loadIndex/updatedDate
abren y `dispose()` en finally) → no necesita close. En Windows un sqlite abierto
bloquea el `delete()`.

## UI — `FactoryResetCard` (`screens/factory_reset_card.dart`)

- Vive en Ajustes → sección **Datos** (plegada), debajo de `BackupCard`. Cumple
  [feedback: acciones destructivas con frenos]: fuera de pantalla principal + dos
  diálogos con palabra escrita.
- Tarjeta con icono aviso y botón rojo (`FilledButton` con `colorScheme.error`).
- **Diálogo 1**: lista CON NOMBRES lo que se va a borrar (colección, mazos, carpetas,
  logros, certificados, lista de deseos, historial de valor, ajustes y fondos, bases
  descargadas) + avisa de que se guardará copia en `backups/` antes. Campo de texto:
  hay que escribir `ELIMINAR` (clave i18n, EN `DELETE`) para encender el botón.
- **Diálogo 2**: última confirmación, escribir `CONFIRMAR` (reusa `bkConfirmWord`).
  Ambos clonan la mecánica de `confirmRestore` (backup_screen.dart:311): `StatefulBuilder`,
  botón `onPressed: puede ? ... : null`, `onSubmitted` respeta la guarda.
- Durante el trabajo: barrera modal no descartable (patrón `_conLaAppQuieta`).
- Contrato: `FactoryResetCard({required Future<FactoryResetReport> Function() onReset})`
  — la tarjeta solo pone diálogos/estado/errores; el trabajo lo hace el callback.

## Cableado en `main.dart` (revisado tras revisión de reviewer, 2026-07-25 tarde)

SIN plomería nueva en `_ManaForgeAppState`: se reusa `onRestored` (ya hace
`resetSharedStores()` + `_tour.value = null` + `_session++`, exactamente lo necesario).

La orquestación real vive en el SERVICIO, no en `HomeShell`, para poder testear el
aborto y el orden sin UI:

```dart
Future<FactoryResetReport> factoryReset(
  Directory dataDir, {
  required void Function() closeDbs,
  required Future<void> Function() clearBackground,
  DateTime? now,
})
```

Compone: `preResetBackup(dataDir, now: now)` (si lanza, se propaga TAL CUAL y nada más
corre) → envuelto en un try que convierte CUALQUIER fallo posterior en
`FactoryResetHalfDone` (la copia ya está a salvo; el resto puede haberse quedado a
medias): `closeDbs()` → `await clearBackground()` → `wipeDataDir()` → si
`report.failed` no queda vacío, una SEGUNDA pasada (`closeDbs()` otra vez +
`wipeDataDir()` de nuevo; lo que siga fallando se acumula como `failed` final).

`HomeShell._factoryReset()` queda en:

```dart
Future<FactoryResetReport> _factoryReset() async {
  final dir = await getApplicationSupportDirectory();
  return factoryReset(dir,
      closeDbs: () { _db.close(); _prices.close(); },
      clearBackground: () => widget.background.resetAll());
}
```

`widget.background.resetAll()` sustituye a `clear()`: además de quitar la imagen,
devuelve TODOS los campos de apariencia (colores, oscurecido, opacidad de tarjetas) a
su valor de fábrica en memoria.

`FactoryResetCard` hace el trabajo bajo barrera modal (la barrera se cierra en el
`finally`, SIN guardar `mounted` y envuelta en try/catch: si la tarjeta se desmonta
mientras corre el trabajo, un `canPop:false` huérfano congelaría la app) y separa el
catch en tres caminos:

- `BackupError` (falló la copia, nada tocado): status `rfBackupFailed` en la propia
  tarjeta, `onDone` NO se llama.
- `FactoryResetHalfDone` (se quedó a medias en caliente): `AlertDialog` simple
  (`rfHalfDone`) y DESPUÉS `onDone` — la app tiene que reconstruirse sí o sí.
- Éxito con `report.failed` no vacío: `AlertDialog` (`rfPartial`, con la lista unida
  por comas) y DESPUÉS `onDone`.
- Éxito limpio: `onDone` directo, como antes.

En los tres casos con `onDone`, se llama ANTES de cualquier `if (!mounted) return` /
`setState` final: el closure de `onDone` apunta al estado de `_ManaForgeAppState`, que
sobrevive aunque la tarjeta muera; un desmontaje entre barrido y aviso no puede dejar
el disco borrado sin el session bump.

Tras el bump: `_started=false` → StartupScreen re-descarga.

### `.roto` rescatados y copias `pre-reset`

`wipeDataDir` NO borra los `.roto` (almacenes ilegibles apartados por
`setAsideBroken`): son datos rescatables, y se MUEVEN a `backups/` (colisión →
sufijo `-2`, `-3`…). Cuentan en `FactoryResetReport.rescued`, no en `deleted`.

La copia `pre-reset-*` se enseña en Restaurar con su propio texto (`bkKindPreReset`,
"Antes del reset de fábrica") y rota a `kKeepPreRestore` (20) igual que las
`pre-restore-*`. `listBackups` ordena por la FECHA del sello del nombre (no por el
nombre entero): con tres prefijos distintos mezclados, ordenar por `basename` sacaba
una copia más nueva por detrás de una más vieja con un prefijo que alfabéticamente
va antes.

### Tour de bienvenida diferido a `onReady`

El tour de bienvenida se lanzaba en el `postFrameCallback` de `initState`
independientemente de `_started`: si `_onboarding.load()` terminaba antes que
`StartupScreen` saliera, las burbujas salían pintadas sobre la pantalla de arranque
(pasa justo después de un reset, con las bases recién borradas y StartupScreen
tardando en re-descargar). Ahora, si `!_started` en ese punto, se apunta
`_tourBienvenidaPendiente = true` en vez de lanzarlo; el `onReady` de `StartupScreen`
(el mismo que pone `_started = true`) lo dispara con un `postFrameCallback` extra si
había quedado pendiente.

### Idioma

Fichero borrado (primer arranque real preguntará), pero el objeto en memoria
conserva el locale esta sesión → la UI sigue legible tras el reset. Decisión a favor
de usabilidad; no se re-escribe el fichero salvo que el usuario cambie idioma.

## i18n

Claves `rf*` solo en es+en (resto cae al español, método de tandas). `flutter gen-l10n`
regenerado y commiteado. Palabra 1: `rfDeleteWord` = `ELIMINAR`/`DELETE`. Palabra 2:
reusa `bkConfirmWord`.

## Tests

- Servicio (`test/services/factory_reset_test.dart`): borra todo salvo `backups/`;
  la copia pre-reset existe y contiene los almacenes; dir vacío → borra sin copia
  (noData); error de copia → NO borra nada; `.roto`/`.tmp` fuera; report cuenta bien.
- UI (`test/screens/factory_reset_card_test.dart`, clon de `backup_screen_test.dart`):
  botón del diálogo 1 apagado hasta escribir `ELIMINAR` (mayúsculas laxas como
  `confirmRestore`); cancelar en cualquiera de los dos diálogos → `onReset` NO se llama;
  flujo completo → se llama una vez; error del callback → se enseña texto.
- Ajustes: la tarjeta aparece en sección Datos (ampliar `ajustes_secciones_test.dart`).

## Riesgo aceptado

Una escritura encolada (SaveQueue) de justo antes del reset podría resucitar UN json
tras el borrado. Ventana ínfima (usuario está quieto en Ajustes bajo barrera modal);
si mordiera, el fichero resucitado se ve como datos sueltos en primer arranque, sin
corrupción. No se complica el diseño por esto.
