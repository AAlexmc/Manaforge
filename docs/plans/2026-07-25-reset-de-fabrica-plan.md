# Reset de fábrica — plan de implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:test-driven-development. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Botón en Ajustes → Datos que deja la app como recién instalada (borra datos de usuario + bases descargadas, conservando `backups/`), con copia previa automática y doble freno escrito ELIMINAR → CONFIRMAR.

**Architecture:** Servicio puro `factory_reset.dart` (dos mitades: copia previa / barrido) + tarjeta `FactoryResetCard` que clona el patrón de diálogo escribir-palabra de `confirmRestore` (backup_screen.dart:311) + cableado en `HomeShell` reusando `onRestored` para el session bump. Spec: `docs/plans/2026-07-25-reset-de-fabrica-design.md` (LEERLA ANTES).

**Tech Stack:** Flutter/Dart, sin dependencias nuevas. Tests con `flutter test`.

## Global Constraints

- Comandos desde `~/Manaforge/app/`: `flutter test`, `flutter analyze` (warnings fatales, incluye test/).
- Commits SIN co-author Claude (decisión de Ale). Mensajes en español, estilo del repo.
- i18n: claves nuevas prefijo `rf*` SOLO en `app_es.arb` + `app_en.arb` (el resto cae al español). Plantilla = `app_es.arb`. Tras tocar ARBs: `flutter gen-l10n` y commitear los `app_localizations*.dart` regenerados.
- Trampas de test conocidas (CLAUDE.md/memoria): `pumpAndSettle` no termina con spinners → pumps discretos; `getApplicationSupportDirectory()` no completa en `testWidgets` sin `runAsync`.
- NO tocar `scene`/stores validados fuera del alcance. NO tagear versiones.

---

### Task 1: Servicio `factory_reset.dart`

**Files:**
- Create: `app/lib/services/factory_reset.dart`
- Test: `app/test/services/factory_reset_test.dart`

**Interfaces:**
- Consumes: `writeBackupFile(Directory, {required String prefix, DateTime? now})` (backup.dart:589), `BackupError`/`BackupErrorCode.noData` (backup.dart:71/90), `kBackupDirName` (backup.dart:59), `readBackup` (backup.dart:252).
- Produces: `class FactoryResetReport { File? backupFile; List<String> deleted; List<String> failed; }` · `Future<File?> preResetBackup(Directory dataDir, {DateTime? now})` · `Future<FactoryResetReport> wipeDataDir(Directory dataDir, {File? backup})`.

- [ ] **Step 1: tests que fallan** — `app/test/services/factory_reset_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge/services/backup.dart';
import 'package:manaforge/services/factory_reset.dart';
import 'package:path/path.dart' as p;

Future<Directory> _dataDir(Map<String, String> files) async {
  final dir = await Directory.systemTemp.createTemp('mf_reset');
  addTearDown(() async {
    if (await dir.exists()) await dir.delete(recursive: true);
  });
  for (final e in files.entries) {
    final f = File(p.join(dir.path, e.key));
    await f.parent.create(recursive: true);
    await f.writeAsString(e.value);
  }
  return dir;
}

void main() {
  test('la copia pre-reset se escribe en backups/ y es legible', () async {
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'decks.json': '[]',
    });
    final copia = await preResetBackup(dir);
    expect(copia, isNotNull);
    expect(p.basename(copia!.parent.path), 'backups');
    final contents = readBackup(await copia.readAsBytes());
    expect(contents.stores.keys,
        containsAll(['collection.json', 'decks.json']));
  });

  test('sin datos que copiar: devuelve null en vez de reventar', () async {
    final dir = await _dataDir({'algo.tmp': 'restos'});
    expect(await preResetBackup(dir), isNull);
  });

  test('si la copia no se puede escribir, lanza (y nadie borra nada)',
      () async {
    // un FICHERO llamado backups impide crear la carpeta
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'backups': 'soy un fichero, no una carpeta',
    });
    await expectLater(preResetBackup(dir), throwsA(anything));
    expect(File(p.join(dir.path, 'collection.json')).existsSync(), isTrue);
  });

  test('wipeDataDir borra todo salvo backups/', () async {
    final dir = await _dataDir({
      'collection.json': '{"cards":[]}',
      'decks.json': '[]',
      'language.json': '{}',
      'manaforge_cards.sqlite': 'sqlite falsa',
      'collection.json.roto': 'x',
      'collection.1.tmp': 'x',
      'background_123.jpg': 'img',
      'backups/auto-viejo.mfbak': 'copia vieja',
    });
    final report = await wipeDataDir(dir);
    final quedan =
        dir.listSync().map((e) => p.basename(e.path)).toList()..sort();
    expect(quedan, ['backups']);
    expect(File(p.join(dir.path, 'backups', 'auto-viejo.mfbak')).existsSync(),
        isTrue);
    expect(report.failed, isEmpty);
    expect(report.deleted, isNot(contains('backups')));
    expect(report.deleted, contains('manaforge_cards.sqlite'));
  });

  test('wipeDataDir arrastra el backupFile al informe', () async {
    final dir = await _dataDir({'collection.json': '{"cards":[]}'});
    final copia = await preResetBackup(dir);
    final report = await wipeDataDir(dir, backup: copia);
    expect(report.backupFile, copia);
    expect(await copia!.exists(), isTrue);
  });
}
```

- [ ] **Step 2: correr y ver fallar** — `cd ~/Manaforge/app && flutter test test/services/factory_reset_test.dart` → FAIL (no existe `factory_reset.dart`).

- [ ] **Step 3: implementación mínima** — `app/lib/services/factory_reset.dart`:

```dart
/// Reset de fábrica: deja la carpeta de datos como recién instalada.
///
/// Dos mitades a propósito: entre la copia previa y el barrido, quien orquesta
/// (HomeShell) cierra los sqlite abiertos y limpia el fondo. Si la copia
/// falla, se aborta ANTES de tocar nada.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'backup.dart';

/// Qué pasó en un reset: la copia guardada y qué se borró (o no se pudo).
class FactoryResetReport {
  /// La copia pre-reset, o null si no había nada que copiar.
  final File? backupFile;
  final List<String> deleted;
  final List<String> failed;
  const FactoryResetReport(
      {required this.backupFile, required this.deleted, required this.failed});
}

/// Guarda la copia `pre-reset` en `backups/` antes de borrar nada.
/// Devuelve null si no hay datos que copiar; cualquier otro fallo LANZA,
/// y en ese caso el reset no debe seguir.
Future<File?> preResetBackup(Directory dataDir, {DateTime? now}) async {
  try {
    return await writeBackupFile(dataDir, prefix: 'pre-reset', now: now);
  } on BackupError catch (e) {
    if (e.code == BackupErrorCode.noData) return null;
    rethrow;
  }
}

/// Borra TODO el contenido de la carpeta de datos salvo `backups/`.
/// Los fallos sueltos no paran el resto: se acumulan en el informe.
Future<FactoryResetReport> wipeDataDir(Directory dataDir,
    {File? backup}) async {
  final deleted = <String>[];
  final failed = <String>[];
  await for (final entry in dataDir.list()) {
    final name = p.basename(entry.path);
    if (name == kBackupDirName) continue;
    try {
      await entry.delete(recursive: true);
      deleted.add(name);
    } catch (_) {
      failed.add(name);
    }
  }
  deleted.sort();
  failed.sort();
  return FactoryResetReport(
      backupFile: backup, deleted: deleted, failed: failed);
}
```

Nota: si `writeBackupFile` con almacenes vacíos NO lanza `noData` (verificar en backup.dart:589 y buildBackup:134 qué pasa con cero stores), ajustar `preResetBackup` para que devuelva null cuando `presentStores(dataDir)` (backup.dart:280) venga vacío, y que el test 2 siga en verde tal cual está escrito.

- [ ] **Step 4: verde** — `flutter test test/services/factory_reset_test.dart` → PASS.
- [ ] **Step 5: commit**

```bash
cd ~/Manaforge && git add app/lib/services/factory_reset.dart app/test/services/factory_reset_test.dart && git commit -m "Reset de fábrica: servicio de copia previa y barrido (conserva backups/)"
```

---

### Task 2: claves i18n `rf*`

**Files:**
- Modify: `app/lib/l10n/app_es.arb`, `app/lib/l10n/app_en.arb`
- Modify (regenerado): `app/lib/l10n/app_localizations*.dart`

**Interfaces:**
- Produces (getters en `AppLocalizations`): `rfTitle, rfIntro, rfButton, rfConfirmTitle1, rfWillDelete, rfBackupFirst, rfTypeWord(String palabra), rfDeleteWord, rfContinueAction, rfConfirmTitle2, rfConfirmBody2, rfEraseAction, rfWorking, rfBackupFailed(String motivo)`.

- [ ] **Step 1: añadir a `app_es.arb`** (junto al bloque `bk*`, orden alfabético del fichero si lo hay):

```json
"rfTitle": "Reset de fábrica",
"rfIntro": "Deja la app como recién instalada: sin colección, sin mazos y sin bases descargadas.",
"rfButton": "Borrar todo",
"rfConfirmTitle1": "¿Borrar todos los datos?",
"rfWillDelete": "Se borrarán: la colección, los mazos, las carpetas, los logros, los certificados, la lista de deseos, el historial de valor, los ajustes y fondos, y las bases descargadas de cartas, precios y huellas.",
"rfBackupFirst": "Antes de borrar nada se guardará una copia de seguridad automática; podrás restaurarla desde Ajustes → Datos.",
"rfTypeWord": "Escribe {palabra} para continuar.",
"@rfTypeWord": { "placeholders": { "palabra": { "type": "String" } } },
"rfDeleteWord": "ELIMINAR",
"rfContinueAction": "Continuar",
"rfConfirmTitle2": "Última confirmación",
"rfConfirmBody2": "Esto borra todos tus datos de este equipo. Solo podrás volver atrás restaurando la copia que se guarda ahora.",
"rfEraseAction": "Borrar definitivamente",
"rfWorking": "Borrando los datos… no cierres la app.",
"rfBackupFailed": "No se pudo guardar la copia previa, así que NO se ha borrado nada. {motivo}",
"@rfBackupFailed": { "placeholders": { "motivo": { "type": "String" } } }
```

- [ ] **Step 2: añadir a `app_en.arb`**:

```json
"rfTitle": "Factory reset",
"rfIntro": "Returns the app to a fresh install: no collection, no decks, no downloaded databases.",
"rfButton": "Erase everything",
"rfConfirmTitle1": "Erase all data?",
"rfWillDelete": "This will erase: your collection, decks, folders, achievements, certificates, wishlist, value history, settings and backgrounds, and the downloaded card, price and fingerprint databases.",
"rfBackupFirst": "Before anything is erased, an automatic backup will be saved; you can restore it from Settings → Data.",
"rfTypeWord": "Type {palabra} to continue.",
"@rfTypeWord": { "placeholders": { "palabra": { "type": "String" } } },
"rfDeleteWord": "DELETE",
"rfContinueAction": "Continue",
"rfConfirmTitle2": "Last confirmation",
"rfConfirmBody2": "This erases all your data on this device. The only way back is restoring the backup being saved now.",
"rfEraseAction": "Erase for good",
"rfWorking": "Erasing data… don't close the app.",
"rfBackupFailed": "The backup could not be saved, so NOTHING was erased. {motivo}",
"@rfBackupFailed": { "placeholders": { "motivo": { "type": "String" } } }
```

- [ ] **Step 3: regenerar** — `cd ~/Manaforge/app && flutter gen-l10n` → sin errores; comprobar que `lib/l10n/app_localizations_es.dart` tiene `rfTitle`.
- [ ] **Step 4: commit**

```bash
cd ~/Manaforge && git add app/lib/l10n && git commit -m "Reset de fábrica: textos en español e inglés (claves rf*)"
```

---

### Task 3: `FactoryResetCard` con doble freno escrito

**Files:**
- Create: `app/lib/screens/factory_reset_card.dart`
- Test: `app/test/screens/factory_reset_card_test.dart`

**Interfaces:**
- Consumes: Task 1 (`FactoryResetReport`), Task 2 (claves `rf*`), `tr(context)` de `../l10n/t.dart`, `BackupError`/`backupErrorText` (backup.dart:71/306), `bkConfirmWord`/`acCancel` existentes. Patrón de diálogo: backup_screen.dart:311-383 (`confirmRestore`); patrón de barrera modal: backup_screen.dart:184-207 (`_conLaAppQuieta`).
- Produces: `class FactoryResetCard extends StatefulWidget { final Future<FactoryResetReport> Function() wipe; final VoidCallback onDone; const FactoryResetCard({super.key, required this.wipe, required this.onDone}); }` y (para tests) `const String kFactoryResetWord = 'ELIMINAR';`.

**ORDEN CRÍTICO (del diseño):** el trabajo corre bajo barrera modal `canPop:false`; la barrera se CIERRA antes de llamar `onDone` — `onDone` dispara el session bump y un diálogo imposible de cerrar que sobreviva al bump congela la app.

- [ ] **Step 1: tests que fallan** — `app/test/screens/factory_reset_card_test.dart` (usar `appDePrueba` de `test/helpers/app_l10n.dart`; clonar estilo de `backup_screen_test.dart`):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge/screens/factory_reset_card.dart';
import 'package:manaforge/services/backup.dart';
import 'package:manaforge/services/factory_reset.dart';

import '../helpers/app_l10n.dart';

void main() {
  var wipes = 0;
  var dones = 0;
  Widget carta(
      {Future<FactoryResetReport> Function()? wipe}) {
    return appDePrueba(
      home: Scaffold(
        body: FactoryResetCard(
          wipe: wipe ??
              () async {
                wipes++;
                return const FactoryResetReport(
                    backupFile: null, deleted: [], failed: []);
              },
          onDone: () => dones++,
        ),
      ),
    );
  }

  setUp(() {
    wipes = 0;
    dones = 0;
  });

  testWidgets('no se borra sin escribir ELIMINAR', (tester) async {
    await tester.pumpWidget(carta());
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    // el botón de seguir nace apagado
    final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continuar'));
    expect(boton.onPressed, isNull);
    // una palabra que no es, no lo enciende
    await tester.enterText(find.byType(TextField), 'BORRAR');
    await tester.pump();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Continuar'))
            .onPressed,
        isNull);
    expect(wipes, 0);
  });

  testWidgets('cancelar en el segundo diálogo tampoco borra', (tester) async {
    await tester.pumpWidget(carta());
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), ' eliminar ');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(find.text('Última confirmación'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    expect(wipes, 0);
    expect(dones, 0);
  });

  testWidgets('ELIMINAR + CONFIRMAR ejecuta el borrado y avisa al terminar',
      (tester) async {
    await tester.pumpWidget(carta());
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'ELIMINAR');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.text('Borrar definitivamente'));
    await tester.pump(); // arranca el trabajo
    await tester.pump(); // la barrera se cierra
    expect(wipes, 1);
    expect(dones, 1);
  });

  testWidgets('si la copia previa falla, no llama a onDone y enseña el motivo',
      (tester) async {
    await tester.pumpWidget(carta(
        wipe: () async =>
            throw BackupError(BackupErrorCode.writeFailed)));
    await tester.tap(find.text('Borrar todo'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'ELIMINAR');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CONFIRMAR');
    await tester.pump();
    await tester.tap(find.text('Borrar definitivamente'));
    await tester.pump();
    await tester.pump();
    expect(dones, 0);
    expect(find.textContaining('NO se ha borrado nada'), findsOneWidget);
  });
}
```

(Si el constructor de `BackupError` pide más argumentos — mirar backup.dart:71-87 — ajustar la llamada del último test, no el contrato.)

- [ ] **Step 2: correr y ver fallar** — `flutter test test/screens/factory_reset_card_test.dart` → FAIL.

- [ ] **Step 3: implementar** — `app/lib/screens/factory_reset_card.dart`:

```dart
/// Tarjeta "Reset de fábrica" de Ajustes → Datos.
///
/// Doble freno escrito (pedido literal): primero ELIMINAR, luego CONFIRMAR.
/// El trabajo corre bajo una barrera modal; la barrera se cierra ANTES de
/// avisar con onDone, porque onDone reconstruye la app entera (session bump)
/// y un diálogo canPop:false superviviente la dejaría congelada.
library;

import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/backup.dart';
import '../services/factory_reset.dart';

/// Solo para tests (como kRestoreConfirmWord): la palabra del primer freno.
const String kFactoryResetWord = 'ELIMINAR';

class FactoryResetCard extends StatefulWidget {
  /// Copia previa + borrado. NO debe disparar el session bump.
  final Future<FactoryResetReport> Function() wipe;

  /// Se llama SOLO si el borrado terminó: la app entera vuelve a empezar.
  final VoidCallback onDone;

  const FactoryResetCard(
      {super.key, required this.wipe, required this.onDone});

  @override
  State<FactoryResetCard> createState() => _FactoryResetCardState();
}

class _FactoryResetCardState extends State<FactoryResetCard> {
  bool _busy = false;
  String? _error;

  Future<bool> _confirmar(
      {required String titulo,
      required String cuerpo,
      required String palabra,
      required String accion}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        var escrito = '';
        return StatefulBuilder(builder: (context, setSheet) {
          final t = tr(context);
          final puede =
              escrito.trim().toUpperCase() == palabra.toUpperCase();
          final colores = Theme.of(context).colorScheme;
          return AlertDialog(
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cuerpo),
                const SizedBox(height: 16),
                Text(t.rfTypeWord(palabra),
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  onChanged: (v) => setSheet(() => escrito = v),
                  onSubmitted: (_) {
                    if (escrito.trim().toUpperCase() ==
                        palabra.toUpperCase()) {
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(t.acCancel)),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: colores.error,
                    foregroundColor: colores.onError),
                onPressed:
                    puede ? () => Navigator.of(context).pop(true) : null,
                child: Text(accion),
              ),
            ],
          );
        });
      },
    );
    return ok ?? false;
  }

  Future<void> _flujo() async {
    final t = tr(context);
    final paso1 = await _confirmar(
        titulo: t.rfConfirmTitle1,
        cuerpo: '${t.rfWillDelete}\n\n${t.rfBackupFirst}',
        palabra: t.rfDeleteWord,
        accion: t.rfContinueAction);
    if (!paso1 || !mounted) return;
    final paso2 = await _confirmar(
        titulo: t.rfConfirmTitle2,
        cuerpo: t.rfConfirmBody2,
        palabra: t.bkConfirmWord,
        accion: t.rfEraseAction);
    if (!paso2 || !mounted) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    // barrera: la app quieta mientras se copia y se borra
    final navigator = Navigator.of(context, rootNavigator: true);
    var barreraViva = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(tr(context).rfWorking)),
          ]),
        ),
      ),
    ).whenComplete(() => barreraViva = false);
    try {
      final report = await widget.wipe();
      if (barreraViva) navigator.pop();
      if (!mounted) return;
      setState(() => _busy = false);
      // el éxito no necesita cartel: onDone reconstruye la app y se ve la
      // pantalla de arranque. Los fallos sueltos del barrido no frenan.
      if (report.failed.isEmpty || report.deleted.isNotEmpty) {
        widget.onDone();
      }
    } catch (e) {
      if (barreraViva) navigator.pop();
      if (!mounted) return;
      final t = tr(context);
      setState(() {
        _busy = false;
        _error = t.rfBackupFailed(
            e is BackupError ? backupErrorText(t, e) : '$e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    final colores = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.restart_alt, color: colores.error),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(t.rfTitle,
                      style: Theme.of(context).textTheme.titleMedium)),
            ]),
            const SizedBox(height: 8),
            Text(t.rfIntro),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: colores.error)),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: colores.error,
                  foregroundColor: colores.onError),
              onPressed: _busy ? null : _flujo,
              icon: const Icon(Icons.delete_forever),
              label: Text(t.rfButton),
            ),
          ],
        ),
      ),
    );
  }
}
```

Ajustar detalles al estilo real de `BackupCard` (backup_screen.dart:19-290): mismos paddings/estructura de tarjeta. Si `_conLaAppQuieta` es reutilizable tal cual (mismo fichero u otro), preferir clonar su mecánica exacta antes que la barrera artesanal de arriba — pero SIEMPRE cerrando la barrera antes de `onDone`.

- [ ] **Step 4: verde** — `flutter test test/screens/factory_reset_card_test.dart` → PASS.
- [ ] **Step 5: commit**

```bash
cd ~/Manaforge && git add app/lib/screens/factory_reset_card.dart app/test/screens/factory_reset_card_test.dart && git commit -m "Reset de fábrica: tarjeta con doble freno escrito (ELIMINAR → CONFIRMAR)"
```

---

### Task 4: cableado en `main.dart` y `AjustesScreen`

**Files:**
- Modify: `app/lib/main.dart` (HomeShell: ~línea 629 construcción de `AjustesScreen`; `_HomeShellState` para `_factoryReset`)
- Modify: `app/lib/screens/screens.dart` (constructor `AjustesScreen` :85-103; sección Datos :189-236)
- Test: `app/test/screens/ajustes_secciones_test.dart` (ampliar)

**Interfaces:**
- Consumes: Task 1 (`preResetBackup`, `wipeDataDir`, `FactoryResetReport`), Task 3 (`FactoryResetCard`), `CardDatabase.close()` (card_database.dart:161), `PriceSeriesDatabase.close()` (price_series_database.dart:145), `BackgroundPreference.clear()` (background_prefs.dart:304), `getApplicationSupportDirectory()`.
- Produces: `AjustesScreen` acepta `Future<FactoryResetReport> Function()? onFactoryReset` (null → la tarjeta no se pinta; los tests viejos siguen intactos).

- [ ] **Step 1: test que falla** — añadir a `ajustes_secciones_test.dart` (clonando `_ajustes()` :29-36 y el patrón de abrir la sección Datos):

```dart
testWidgets('la seccion Datos lleva el reset de fabrica al final',
    (tester) async {
  tester.view.physicalSize = const Size(1200, 2400);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(appDePrueba(
    home: AjustesScreen(
      db: _sinBase(),
      onRestored: () {},
      onFactoryReset: () async => const FactoryResetReport(
          backupFile: null, deleted: [], failed: []),
    ),
  ));
  await tester.tap(find.text('Datos'));
  await tester.pump(const Duration(milliseconds: 500));
  await tester.scrollUntilVisible(find.text('Reset de fábrica'), 200);
  expect(find.text('Reset de fábrica'), findsOneWidget);
});
```

(Imports nuevos que hagan falta: `package:manaforge/services/factory_reset.dart`. Si `scrollUntilVisible` no encuentra scrollable único, usar `find.byType(ListView)` como `scrollable:`.)

- [ ] **Step 2: correr y ver fallar** — `flutter test test/screens/ajustes_secciones_test.dart` → FAIL (parámetro no existe).

- [ ] **Step 3: implementar.** En `screens.dart`:
  - Añadir al constructor de `AjustesScreen`: `this.onFactoryReset` (campo `final Future<FactoryResetReport> Function()? onFactoryReset;`) + import de `factory_reset.dart` y `factory_reset_card.dart`.
  - En la sección Datos (tras `BackupCard`, :230-235): 

```dart
if (widget.onFactoryReset != null) ...[
  const SizedBox(height: 8),
  FactoryResetCard(
    wipe: widget.onFactoryReset!,
    onDone: widget.onRestored,
  ),
],
```

  En `main.dart`, dentro de `_HomeShellState` (junto a `_autoBackup` :400):

```dart
/// Reset de fábrica: copia previa, cerrar los sqlite (en Windows un handle
/// abierto bloquea el borrado), limpiar el fondo (en memoria y sus ficheros,
/// ANTES del barrido para que no re-escriba nada después) y barrer. El
/// session bump lo dispara la tarjeta vía onRestored al terminar.
Future<FactoryResetReport> _factoryReset() async {
  final dir = await getApplicationSupportDirectory();
  final copia = await preResetBackup(dir); // si falla, aborta sin tocar nada
  _db.close();
  _prices.close();
  await widget.background.clear();
  return wipeDataDir(dir, backup: copia);
}
```

  Y en la construcción de `AjustesScreen` (:629): `onFactoryReset: _factoryReset,`. Import de `services/factory_reset.dart`.

  **Verificar** (leyendo card_database.dart:161-183 y price_series_database.dart:145): que `close()` deja el handle a null y la siguiente consulta reabre sola (lazy `_open()`); y que `_prices.close()` en `dispose` (main.dart:396) aguanta un segundo close sin reventar. Si `PriceSeriesDatabase.close()` no es idempotente, hacerlo idempotente (guard null) en ese fichero.

- [ ] **Step 4: verde** — `flutter test test/screens/ajustes_secciones_test.dart` → PASS.
- [ ] **Step 5: commit**

```bash
cd ~/Manaforge && git add app/lib/main.dart app/lib/screens/screens.dart app/test/screens/ajustes_secciones_test.dart && git commit -m "Reset de fábrica: cableado en Ajustes → Datos con copia previa y session bump"
```

---

### Task 5: suite completa + analyze

- [ ] **Step 1:** `cd ~/Manaforge/app && flutter analyze` → 0 issues (warnings son fatales e incluyen test/).
- [ ] **Step 2:** `cd ~/Manaforge/app && flutter test` → TODO verde (antes de esta rama: 842 tests).
- [ ] **Step 3:** si algo roto, arreglar SIN cambiar contratos de Tasks 1-4; si hay que cambiar un contrato, parar y reportar.
- [ ] **Step 4: commit final si hubo arreglos.**
