import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/t.dart';
import '../services/backup.dart';

/// Tarjeta de copia de seguridad, reutilizable: va en Ajustes y en la pantalla
/// de carga (que es justo donde acabas cuando algo se ha roto).
///
/// [dataDir] se pasa como función y puede devolver null: en un test no hay
/// plugin de rutas, y la tarjeta tiene que poder pintarse igual.
/// [onRestored] avisa a la app de que los datos de disco han cambiado y hay
/// que releerlos.
class BackupCard extends StatefulWidget {
  final Future<Directory?> Function() dataDir;
  final VoidCallback onRestored;

  const BackupCard(
      {super.key, required this.dataDir, required this.onRestored});

  @override
  State<BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends State<BackupCard> {
  bool _busy = false;
  String? _status;

  /// Las copias que hay en la carpeta de datos. Se enseñan porque si no, no
  /// existen para nadie: viven en `~/.local/share/...`, que no es un sitio al
  /// que nadie vaya a navegar con un selector de ficheros justo el día que se
  /// le ha roto la colección.
  List<File> _autos = const [];

  /// Cuál de ellas está elegida en el desplegable. Empieza SIN elegir a
  /// propósito: restaurar borra lo de ahora, así que hay que pedirla a mano.
  File? _elegida;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAutos());
  }

  Future<void> _loadAutos() async {
    try {
      final dir = await widget.dataDir();
      if (dir == null) return;
      final copias = await listBackups(dir);
      if (!mounted) return;
      setState(() {
        _autos = copias.take(10).toList();
        // la elegida puede haber desaparecido (rotación): no dejar el
        // desplegable apuntando a un fichero que ya no está
        if (_elegida != null &&
            !_autos.any((f) => f.path == _elegida!.path)) {
          _elegida = null;
        }
      });
    } catch (_) {/* sin lista: los botones de arriba siguen funcionando */}
  }

  Future<void> _export() async {
    final t = tr(context);
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) {
        throw const BackupError('No encuentro tus datos.',
            code: BackupErrorCode.noData);
      }
      final bytes = await buildBackup(dir);
      final nombre = 'manaforge-${backupStamp(DateTime.now())}.mfbak';
      final destino = await getSaveLocation(suggestedName: nombre);
      if (destino == null) return; // cancelado
      await File(destino.path).writeAsBytes(bytes, flush: true);
      final manifest = readManifest(bytes);
      if (mounted) {
        setState(() => _status = t.bkSaved(manifest.summary(t)));
      }
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = backupErrorText(t, e));
    } catch (e) {
      if (mounted) setState(() => _status = t.bkSaveFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final t = tr(context);
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) {
        throw const BackupError('No encuentro tus datos.',
            code: BackupErrorCode.noData);
      }
      final origen = await openFile(acceptedTypeGroups: [
        XTypeGroup(label: t.bkFileName, extensions: const ['mfbak'])
      ]);
      if (origen == null) return; // cancelado
      // el tamaño se mira ANTES de leerlo a memoria: un fichero de fuera con
      // extensión .mfbak puede ser cualquier cosa
      ensureBackupFileSize(await origen.length());
      await _apply(await origen.readAsBytes(), dir);
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = backupErrorText(t, e));
    } catch (e) {
      if (mounted) setState(() => _status = t.bkRestoreFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Restaurar la copia elegida en el desplegable.
  Future<void> _restoreAuto(File file) async {
    final t = tr(context);
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) {
        throw const BackupError('No encuentro tus datos.',
            code: BackupErrorCode.noData);
      }
      ensureBackupFileSize(await file.length());
      await _apply(await file.readAsBytes(), dir);
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = backupErrorText(t, e));
    } catch (e) {
      if (mounted) setState(() => _status = t.bkRestoreFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// El camino común de los dos: validar, preguntar y aplicar. Uno solo para
  /// que el aviso de "esto reemplaza lo de ahora" no pueda faltar en una vía.
  Future<void> _apply(Uint8List bytes, Directory dir) async {
    final t = tr(context);
    // se lee y valida ANTES de preguntar: no tiene sentido pedir confirmación
    // de algo que no se va a poder aplicar. Y se lee UNA vez: descomprimir es
    // el trabajo caro, y va en otro hilo (compute) para no colgar la ventana
    final copia = await compute(readBackup, bytes);
    final manifest = copia.manifest;
    final seBorra = storesToDelete(manifest, present: await presentStores(dir));
    if (!mounted) return;
    if (!await confirmRestore(context, manifest, willDelete: seBorra)) return;
    if (!mounted) return;
    final report = await _conLaAppQuieta(
        () => restoreBackup(bytes, dir, contents: copia));
    if (!mounted) return;
    setState(() => _status = report.previous == null
        ? t.bkRestoredNoPrevious(
            manifest.summary(t), '${report.previousError}')
        : t.bkRestored(manifest.summary(t)));
    widget.onRestored();
    // el restaurar deja una copia `pre-restore` nueva: que salga en la lista
    unawaited(_loadAutos());
  }

  /// Corre [action] con una ventana modal delante que no se puede quitar.
  ///
  /// Restaurar reemplaza los ficheros de los almacenes mientras la app sigue
  /// viva: cualquier pantalla que guarde a media operación (añadir a un mazo,
  /// abrir una carta, cruzar precios) escribiría lo VIEJO encima de lo recién
  /// restaurado. La barrera impide tocar la app durante esos milisegundos.
  /// No es una garantía completa —un `await` lanzado antes puede aterrizar
  /// igual—, pero cierra la ventana de tiempo en la que se puede tocar algo.
  Future<T> _conLaAppQuieta<T>(Future<T> Function() action) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    unawaited(showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(tr(dialogContext).bkRestoring)),
            ],
          ),
        ),
      ),
    ));
    try {
      return await action();
    } finally {
      if (mounted) navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.bkTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(t.bkWhy, style: const TextStyle(fontSize: 12.5)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : _export,
              icon: const Icon(Icons.save_alt),
              label: Text(t.bkSave),
            ),
            if (_status != null) ...[
              const SizedBox(height: 10),
              Text(_status!, style: const TextStyle(fontSize: 12.5)),
            ],
            const Divider(height: 32),
            Text(t.bkRestoreTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(t.bkRestoreWarning(t.bkConfirmWord),
                style: const TextStyle(fontSize: 12.5)),
            const SizedBox(height: 12),
            if (_autos.isEmpty)
              Text(t.bkNoBackups, style: const TextStyle(fontSize: 12.5))
            else ...[
              DropdownButtonFormField<File>(
                // la clave depende de la LISTA: si las copias cambian (una
                // rotada, una nueva `pre-restore`), el campo se reconstruye
                // desde cero. Sin esto se queda con un fichero que ya no está
                // entre las opciones, y eso revienta el desplegable.
                key: ValueKey(_autos.map((f) => f.path).join('|')),
                initialValue: _elegida,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: t.bkWhich,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                hint: Text(t.bkPickOne),
                items: [
                  for (final file in _autos)
                    DropdownMenuItem<File>(
                      value: file,
                      child: Text(backupLabel(file, t),
                          style: const TextStyle(fontSize: 12.5),
                          overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged:
                    _busy ? null : (f) => setState(() => _elegida = f),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                // apagado hasta que haya una copia elegida: el botón no puede
                // hacer nada por defecto
                onPressed: _busy || _elegida == null
                    ? null
                    : () => _restoreAuto(_elegida!),
                icon: const Icon(Icons.settings_backup_restore),
                label: Text(t.bkRestorePicked),
              ),
              const SizedBox(height: 6),
              Text(t.bkAutoNote, style: const TextStyle(fontSize: 12)),
            ],
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _busy ? null : _restore,
              icon: const Icon(Icons.folder_open),
              label: Text(t.bkFromFile),
            ),
          ],
        ),
      ),
    );
  }
}

/// "a, b y c" — para poder leer la lista de lo que se borra de corrido.
String _enumerar(AppLocalizations t, List<String> cosas) {
  if (cosas.length == 1) return cosas.single;
  return '${cosas.sublist(0, cosas.length - 1).join(', ')}'
      '${t.bkAnd}${cosas.last}';
}

/// La palabra que hay que escribir para restaurar, en español. Escribirla
/// cuesta tres segundos; restaurar sin querer cuesta la colección entera.
///
/// La que se le pide a la persona sale de las traducciones (`bkConfirmWord`):
/// pedirle a alguien que escriba "CONFIRMAR" en un idioma que no habla no es
/// una traba, es un muro. Esta constante se queda para los tests.
const String kRestoreConfirmWord = 'CONFIRMAR';

/// Pregunta antes de aplicar una copia, diciendo QUÉ trae y qué va a pasar con
/// lo que hay ahora. Devuelve true solo si el usuario escribe la palabra de
/// confirmación y confirma: un clic de más no puede reemplazar una colección.
Future<bool> confirmRestore(BuildContext context, BackupManifest manifest,
    {List<String> willDelete = const []}) async {
  final t = tr(context);
  final fecha = manifest.createdAt.toLocal();
  final cuando = '${fecha.day}/${fecha.month}/${fecha.year}';
  // los dos historiales de precios dan el mismo texto: sin quitar repes
  // saldría "el historial de precios y el historial de precios"
  final borrados = <String>{
    for (final store in willDelete) backupStoreName(t, store),
  }.toList();
  final palabra = t.bkConfirmWord;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      var escrito = '';
      return StatefulBuilder(
        builder: (context, setSheet) {
          // en los dos lados: hay idiomas sin mayúsculas, y ahí `toUpperCase`
          // no hace nada
          final puede =
              escrito.trim().toUpperCase() == palabra.toUpperCase();
          return AlertDialog(
            title: Text(t.bkConfirmTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${t.bkOfDate(cuando, manifest.summary(t))}\n\n'
                    '${t.bkConfirmBody}'),
                if (borrados.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  // lo que la copia NO trae se BORRA, y el resumen de arriba
                  // solo cuenta cartas, mazos, carpetas y logros: sin esto,
                  // una copia vieja se llevaba por delante los certificados o
                  // el historial de precios sin decirlo en ninguna parte
                  Text(t.bkWillDelete(_enumerar(t, borrados)),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 16),
                Text(t.bkTypeToConfirm(palabra),
                    style: const TextStyle(fontSize: 12.5)),
                const SizedBox(height: 6),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    hintText: palabra,
                  ),
                  onChanged: (v) => setSheet(() => escrito = v),
                  onSubmitted: (_) {
                    if (puede) Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(t.acCancel),
              ),
              FilledButton(
                onPressed:
                    puede ? () => Navigator.of(context).pop(true) : null,
                child: Text(t.bkRestoreAction),
              ),
            ],
          );
        },
      );
    },
  );
  return ok ?? false;
}
