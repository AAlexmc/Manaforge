/// Elegir a qué carpeta van las cartas que estás escaneando.
///
/// La carpeta NO es un destino alternativo: las cartas entran en la colección
/// igual y ADEMÁS se etiquetan (una carpeta es una etiqueta, no una caja). Por
/// eso el texto dice "y además a", no "guardar en".
library;

import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/widgets/folder_tile.dart';

/// Lo elegido en la hoja: la carpeta (o ninguna). `null` como resultado de la
/// hoja significa "he cerrado sin elegir", que NO es lo mismo que "ninguna".
class FolderTarget {
  final String? id;

  const FolderTarget(this.id);
}

/// Hoja para elegir carpeta, con la opción de crear una ahí mismo.
Future<FolderTarget?> showFolderTargetSheet(BuildContext context,
    {required FolderStore folders, String? selectedId}) {
  return showModalBottomSheet<FolderTarget>(
    context: context,
    builder: (context) => AnimatedBuilder(
      animation: folders,
      builder: (context, _) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(tr(context).ftWhichFolder,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(tr(context).ftWhichFolderSub,
                  style: const TextStyle(fontSize: 12.5)),
            ),
            ListTile(
              leading: const Icon(Icons.block, size: 20),
              title: Text(tr(context).ftNone),
              trailing: selectedId == null
                  ? const Icon(Icons.check, size: 20)
                  : null,
              onTap: () =>
                  Navigator.of(context).pop(const FolderTarget(null)),
            ),
            for (final folder in folders.folders)
              ListTile(
                leading: Icon(folderIconFor(folder.icon),
                    color: Color(folder.colorValue)),
                title: Text(folder.name),
                subtitle: Text(tr(context).ftCards(folder.count)),
                trailing: selectedId == folder.id
                    ? const Icon(Icons.check, size: 20)
                    : null,
                onTap: () =>
                    Navigator.of(context).pop(FolderTarget(folder.id)),
              ),
            const Divider(height: 8),
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: Text(tr(context).ftNewFolderEllipsis),
              onTap: () async {
                final nombre = await _askFolderName(context);
                if (nombre == null || !context.mounted) return;
                final creada = folders.create(name: nombre);
                if (!context.mounted) return;
                Navigator.of(context).pop(FolderTarget(creada.id));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

Future<String?> _askFolderName(BuildContext context) async {
  final nombre = await showDialog<String>(
    context: context,
    builder: (context) => const _NewFolderDialog(),
  );
  final limpio = nombre?.trim();
  return (limpio == null || limpio.isEmpty) ? null : limpio;
}

/// El diálogo es un widget con estado propio para que el controlador del
/// texto viva y muera CON él: soltarlo en cuanto `showDialog` devuelve lo
/// deja usándose mientras el diálogo aún se está cerrando.
class _NewFolderDialog extends StatefulWidget {
  const _NewFolderDialog();

  @override
  State<_NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<_NewFolderDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr(context).ftNewFolder),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        decoration: InputDecoration(
          labelText: tr(context).fdName,
          hintText: tr(context).ftNewFolderHint,
        ),
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr(context).acCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_ctrl.text),
          child: Text(tr(context).fdCreate),
        ),
      ],
    );
  }
}
