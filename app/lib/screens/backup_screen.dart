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

  /// Las copias automáticas que hay en la carpeta de datos. Se enseñan porque
  /// si no, no existen para nadie: viven en `~/.local/share/...`, que no es un
  /// sitio al que nadie vaya a navegar con un selector de ficheros justo el
  /// día que se le ha roto la colección.
  List<File> _autos = const [];

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
      if (mounted) setState(() => _autos = copias.take(5).toList());
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

  /// Restaurar una de las copias automáticas de la lista.
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
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : _export,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Guardar copia'),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _restore,
                  icon: const Icon(Icons.settings_backup_restore),
                  label: const Text('Restaurar copia'),
                ),
              ],
            ),
            if (_status != null) ...[
              const SizedBox(height: 10),
              Text(_status!, style: const TextStyle(fontSize: 12.5)),
            ],
            if (_autos.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Copias que he guardado yo solo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              const Text('Una cada semana, me quedo con las cinco últimas.',
                  style: TextStyle(fontSize: 12)),
              for (final file in _autos)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history, size: 20),
                  title: Text(backupLabel(file),
                      style: const TextStyle(fontSize: 12.5)),
                  trailing: TextButton(
                    onPressed: _busy ? null : () => _restoreAuto(file),
                    child: const Text('Restaurar'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pregunta antes de aplicar una copia, diciendo QUÉ trae y qué va a pasar con
/// lo que hay ahora. Devuelve true solo si el usuario lo confirma.
Future<bool> confirmRestore(
    BuildContext context, BackupManifest manifest) async {
  final fecha = manifest.createdAt.toLocal();
  final cuando = '${fecha.day}/${fecha.month}/${fecha.year}';
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Restaurar esta copia?'),
      content: Text('Copia del $cuando · ${manifest.summary}.\n\n'
          'Esto reemplaza tu colección, mazos, carpetas y logros de ahora '
          'por los de esa copia. Antes de hacerlo guardo lo que tienes en la '
          'carpeta backups, por si quieres volver.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Restaurar'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
