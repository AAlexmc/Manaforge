import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

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
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) throw const BackupError('No encuentro tus datos.');
      final bytes = await buildBackup(dir);
      final nombre = 'manaforge-${backupStamp(DateTime.now())}.mfbak';
      final destino = await getSaveLocation(suggestedName: nombre);
      if (destino == null) return; // cancelado
      await File(destino.path).writeAsBytes(bytes, flush: true);
      final manifest = readManifest(bytes);
      if (mounted) {
        setState(() => _status = '✓ Copia guardada · ${manifest.summary}');
      }
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = e.message);
    } catch (e) {
      if (mounted) setState(() => _status = 'No he podido guardarla: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) throw const BackupError('No encuentro tus datos.');
      final origen = await openFile(acceptedTypeGroups: const [
        XTypeGroup(label: 'Copia de ManaForge', extensions: ['mfbak'])
      ]);
      if (origen == null) return; // cancelado
      await _apply(await origen.readAsBytes(), dir);
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = e.message);
    } catch (e) {
      if (mounted) setState(() => _status = 'No he podido restaurarla: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Restaurar la copia elegida en el desplegable.
  Future<void> _restoreAuto(File file) async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final dir = await widget.dataDir();
      if (dir == null) throw const BackupError('No encuentro tus datos.');
      await _apply(await file.readAsBytes(), dir);
    } on BackupError catch (e) {
      if (mounted) setState(() => _status = e.message);
    } catch (e) {
      if (mounted) setState(() => _status = 'No he podido restaurarla: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// El camino común de los dos: validar, preguntar y aplicar. Uno solo para
  /// que el aviso de "esto reemplaza lo de ahora" no pueda faltar en una vía.
  Future<void> _apply(Uint8List bytes, Directory dir) async {
    // se valida ANTES de preguntar: no tiene sentido pedir confirmación de
    // algo que no se va a poder aplicar
    final manifest = readManifest(bytes);
    if (!mounted) return;
    if (!await confirmRestore(context, manifest)) return;
    final report = await restoreBackup(bytes, dir);
    if (!mounted) return;
    setState(() => _status = report.previous == null
        ? '✓ Restaurado · ${manifest.summary}. OJO: no he podido guardar lo '
            'que tenías antes (${report.previousError}).'
        : '✓ Restaurado · ${manifest.summary}. Lo que tenías antes está '
            'guardado en la carpeta backups.');
    widget.onRestored();
    // el restaurar deja una copia `pre-restore` nueva: que salga en la lista
    unawaited(_loadAutos());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Copia de seguridad',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(
                'Tus cartas, mazos, carpetas y logros viven solo en este '
                'ordenador. Guarda una copia de vez en cuando y déjala en '
                'otro sitio: un disco, la nube, lo que quieras.',
                style: TextStyle(fontSize: 12.5)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : _export,
              icon: const Icon(Icons.save_alt),
              label: const Text('Guardar copia'),
            ),
            if (_status != null) ...[
              const SizedBox(height: 10),
              Text(_status!, style: const TextStyle(fontSize: 12.5)),
            ],
            const Divider(height: 32),
            Text('Restaurar una copia',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(
                'Restaurar REEMPLAZA tus cartas, mazos, carpetas y logros de '
                'ahora por los de la copia. Elige cuál, dale al botón y '
                'escribe CONFIRMAR: así no se restaura nada sin querer.',
                style: TextStyle(fontSize: 12.5)),
            const SizedBox(height: 12),
            if (_autos.isEmpty)
              const Text('Aún no hay copias guardadas en este ordenador.',
                  style: TextStyle(fontSize: 12.5))
            else ...[
              DropdownButtonFormField<File>(
                // la clave depende de la LISTA: si las copias cambian (una
                // rotada, una nueva `pre-restore`), el campo se reconstruye
                // desde cero. Sin esto se queda con un fichero que ya no está
                // entre las opciones, y eso revienta el desplegable.
                key: ValueKey(_autos.map((f) => f.path).join('|')),
                initialValue: _elegida,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Copia a restaurar',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                hint: const Text('Elige una copia'),
                items: [
                  for (final file in _autos)
                    DropdownMenuItem<File>(
                      value: file,
                      child: Text(backupLabel(file),
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
                label: const Text('Restaurar la copia elegida'),
              ),
              const SizedBox(height: 6),
              const Text(
                  'Guardo una copia automática cada semana (las cinco '
                  'últimas) y otra justo antes de cada restaurar.',
                  style: TextStyle(fontSize: 12)),
            ],
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _busy ? null : _restore,
              icon: const Icon(Icons.folder_open),
              label: const Text('Restaurar de un archivo'),
            ),
          ],
        ),
      ),
    );
  }
}

/// La palabra que hay que escribir para restaurar. Escribirla cuesta tres
/// segundos; restaurar sin querer cuesta la colección entera.
const String kRestoreConfirmWord = 'CONFIRMAR';

/// Pregunta antes de aplicar una copia, diciendo QUÉ trae y qué va a pasar con
/// lo que hay ahora. Devuelve true solo si el usuario escribe [kRestoreConfirmWord]
/// y confirma: un clic de más no puede reemplazar una colección.
Future<bool> confirmRestore(
    BuildContext context, BackupManifest manifest) async {
  final fecha = manifest.createdAt.toLocal();
  final cuando = '${fecha.day}/${fecha.month}/${fecha.year}';
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      var escrito = '';
      return StatefulBuilder(
        builder: (context, setSheet) {
          final puede =
              escrito.trim().toUpperCase() == kRestoreConfirmWord;
          return AlertDialog(
            title: const Text('¿Restaurar esta copia?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Copia del $cuando · ${manifest.summary}.\n\n'
                    'Esto reemplaza tu colección, mazos, carpetas y logros de '
                    'ahora por los de esa copia. Antes de hacerlo guardo lo '
                    'que tienes en la carpeta backups, por si quieres volver.'),
                const SizedBox(height: 16),
                const Text('Escribe $kRestoreConfirmWord para poder seguir:',
                    style: TextStyle(fontSize: 12.5)),
                const SizedBox(height: 6),
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: kRestoreConfirmWord,
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
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed:
                    puede ? () => Navigator.of(context).pop(true) : null,
                child: const Text('Restaurar'),
              ),
            ],
          );
        },
      );
    },
  );
  return ok ?? false;
}
