import 'package:flutter/material.dart';

/// Chip de "bloqueo de edición" para las pantallas de escaneo: cuando escaneas
/// una caja o precon entera, fijas el set y el escáner solo busca dentro de él
/// (clava el printing exacto). null = sin bloqueo (busca en todas).
class SetLockChip extends StatelessWidget {
  final String? lock;
  final VoidCallback onTap;

  const SetLockChip({super.key, required this.lock, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locked = lock != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Tooltip(
          message: locked
              ? 'Solo busco cartas del set ${lock!.toUpperCase()}. Tócalo para '
                  'cambiar o quitar el bloqueo.'
              : 'Bloquea un set para escanear una caja/precon: el escáner solo '
                  'buscará dentro de él y clava la edición.',
          child: ActionChip(
            avatar: Icon(locked ? Icons.lock : Icons.lock_open, size: 16),
            label: Text(locked ? 'Set: ${lock!.toUpperCase()}' : 'Set: todas'),
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
      title: const Text('Bloquear edición'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Escribe el código del set (p. ej. AER, MH3, LCI) para escanear '
            'una caja entera: solo se buscarán cartas de ese set.',
            style: TextStyle(fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Código de set',
              hintText: 'AER',
              border: OutlineInputBorder(),
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
            child: const Text('Quitar bloqueo'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(controller.text.trim().toLowerCase()),
          child: const Text('Bloquear'),
        ),
      ],
    ),
  );
}
