import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';

/// Chip de "bloqueo de edición" para las pantallas de escaneo: cuando escaneas
/// una caja o precon entera, fijas el set y el escáner solo busca dentro de él
/// (clava el printing exacto). null = sin bloqueo (busca en todas).
class SetLockChip extends StatelessWidget {
  final String? lock;
  final VoidCallback onTap;

  const SetLockChip({super.key, required this.lock, required this.onTap});

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    final locked = lock != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Tooltip(
          message: locked
              ? t.slLockedTo(lock!.toUpperCase())
              : t.slLockHint,
          child: ActionChip(
            avatar: Icon(locked ? Icons.lock : Icons.lock_open, size: 16),
            label: Text(locked ? t.slSetIs(lock!.toUpperCase()) : t.slSetAll),
            visualDensity: VisualDensity.compact,
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}

/// Diálogo para fijar/quitar el set bloqueado. Devuelve:
/// - un código de set (minúsculas) para bloquear,
/// - cadena vacía para QUITAR el bloqueo,
/// - null si se cancela (sin cambios).
Future<String?> showSetLockDialog(BuildContext context, String? current) {
  final controller = TextEditingController(text: current ?? '');
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(tr(context).slLockTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(context).slLockBody,
            style: const TextStyle(fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: tr(context).slSetCode,
              hintText: 'AER',
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (v) =>
                Navigator.of(context).pop(v.trim().toLowerCase()),
          ),
        ],
      ),
      actions: [
        if (current != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: Text(tr(context).slClearLock),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr(context).acCancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(controller.text.trim().toLowerCase()),
          child: Text(tr(context).slLockButton),
        ),
      ],
    ),
  );
}
