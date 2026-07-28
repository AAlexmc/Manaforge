/// Lo que comparten el escáner por foto ([ScanScreen]) y el escáner en vivo
/// ([LiveScanScreen]): carpeta elegida, set bloqueado y selector de versión.
/// Antes cada pantalla tenía su propia copia idéntica; vive aquí para que
/// "elegir carpeta" o "bloquear set" signifiquen EXACTAMENTE lo mismo en
/// las dos.
library;

import 'package:flutter/material.dart';

import '../scanner/scan_tray.dart' show TrayLine;
import '../services/card_database.dart';
import '../services/folder_store.dart';
import '../widgets/folder_target.dart';
import '../widgets/set_lock.dart';
import '../widgets/version_picker.dart';

/// La carpeta elegida, si sigue existiendo (se puede borrar desde otra
/// pantalla mientras escaneas).
CardFolder? scanFolder(FolderStore? folders, String? folderId) =>
    folderId == null ? null : folders?.byId(folderId);

/// Abre el selector de carpeta y avisa con [onPicked] si se elige algo
/// (incluida "ninguna carpeta", que llega como `null`). Cerrar sin elegir no
/// avisa.
Future<void> pickScanFolder(BuildContext context, FolderStore folders,
    String? selectedId, void Function(String? folderId) onPicked) async {
  await folders.load();
  if (!context.mounted) return;
  final elegida = await showFolderTargetSheet(context,
      folders: folders, selectedId: selectedId);
  if (elegida == null || !context.mounted) return; // cerrado sin elegir
  onPicked(elegida.id);
}

/// Abre el diálogo de set bloqueado y avisa con [onChanged] si se confirma.
/// Cancelar no avisa.
Future<void> editScanLock(BuildContext context, String? current,
    void Function(String? lock) onChanged) async {
  final result = await showSetLockDialog(context, current);
  if (result == null || !context.mounted) return; // cancelado
  onChanged(result.isEmpty ? null : result);
}

/// Selector de versión entre los candidatos de una línea. Devuelve el
/// índice elegido, o null si se cierra sin elegir.
Future<int?> pickScanVersion(
        BuildContext context, TrayLine line, Map<String, CardHit?> hitCache) =>
    showVersionPicker(context,
        choices: versionChoicesFrom(line, hitCache), selected: line.selected);
