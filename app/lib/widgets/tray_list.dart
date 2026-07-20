import 'package:flutter/material.dart';

import '../scanner/scan_tray.dart';
import '../services/card_database.dart';
import '../theme/mf_theme.dart';
import 'common.dart';

/// Lista VERTICAL de la bandeja de escaneo, al estilo de ManaBox: una fila
/// rica por carta (miniatura, cantidad, nombre, set·número, editar/borrar).
/// La usan el escaneo por lotes de fotos y la revisión de la sesión. Widget
/// sin estado: la pantalla le pasa la [ScanTray] y los callbacks.
class TrayList extends StatelessWidget {
  final ScanTray tray;
  final Map<String, CardHit?> hitCache;
  final void Function(TrayLine) onEdit;
  final void Function(TrayLine) onRemove;

  /// Cambio de cantidad (nueva cantidad; 0 = borrar).
  final void Function(TrayLine, int) onQty;

  const TrayList({
    super.key,
    required this.tray,
    required this.hitCache,
    required this.onEdit,
    required this.onRemove,
    required this.onQty,
  });

  @override
  Widget build(BuildContext context) {
    final lines = tray.lines;
    return ListView.separated(
      itemCount: lines.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => _row(context, lines[i]),
    );
  }

  Widget _row(BuildContext context, TrayLine line) {
    final entry = line.chosen.entry;
    final hit = hitCache[entry.scryfallId];
    return ListTile(
      onTap: () => onEdit(line),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      leading: SizedBox(
        width: 42,
        child: CardThumb(
            url: hit?.imageSmall,
            colors: hit?.colors ?? '',
            name: entry.name,
            width: 42,
            height: 58),
      ),
      title: Text(hit?.printedName ?? entry.name,
          maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(
        children: [
          Text('${entry.setCode.toUpperCase()} #${entry.collectorNumber}',
              style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).textTheme.bodySmall?.color)),
          if (line.needsReview) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: MFColors.warning.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('revisar',
                  style: TextStyle(
                      fontSize: 11,
                      color: MFColors.warning,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 18),
            onPressed: () => onQty(line, line.qty - 1),
          ),
          Text('${line.qty}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()])),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => onQty(line, line.qty + 1),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: 'Quitar',
            onPressed: () => onRemove(line),
          ),
        ],
      ),
    );
  }
}
