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

## Cableado en `main.dart`

SIN plomería nueva en `_ManaForgeAppState`: se reusa `onRestored` (ya hace
`resetSharedStores()` + `_tour.value = null` + `_session++`, exactamente lo necesario).

- `HomeShell._factoryReset()`: `preResetBackup(dir)` (aborta aquí si falla) →
  `_db.close()` + `_prices.close()` → `widget.background.clear()` (en memoria + sus
  ficheros, ANTES del barrido para que no re-escriba nada después) →
  `wipeDataDir(dir)`.
- `FactoryResetCard` hace el trabajo bajo barrera modal, la CIERRA, y solo entonces
  llama `onDone` (= `onRestored`): un diálogo `canPop:false` vivo durante el session
  bump dejaría la app congelada (mismo orden que el flujo de restaurar).
- Tras el bump: `_started=false` → StartupScreen re-descarga; tarjeta muerta → el
  feedback de éxito ES la pantalla de arranque (no hace falta status). El status solo
  se enseña en aborto (la tarjeta sigue viva).
- Idioma: fichero borrado (primer arranque real preguntará), pero el objeto en memoria
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
