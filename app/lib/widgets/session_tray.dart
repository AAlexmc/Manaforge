import 'package:flutter/material.dart';

import '../scanner/scan_tray.dart';
import '../services/card_database.dart';
import '../theme/mf_theme.dart';
import 'common.dart';

/// Bandeja de la sesión de escaneo en vivo: fila horizontal de cartas
/// reconocidas, agrupando copias iguales en ×N (como ManaBox), con las
/// dudosas marcadas en ámbar. Widget sin estado propio: la pantalla le pasa
/// la [ScanTray] y los callbacks. Aislado aquí para poder testear el render
/// (en escritorio Linux la cámara no tiene plugin, así que la pantalla en
/// vivo no se puede pintar de otra forma).
class SessionTray extends StatelessWidget {
  final ScanTray tray;
  final Map<String, CardHit?> hitCache;
  final bool quickMode;
  final void Function(TrayLine) onEdit;
  final void Function(TrayLine) onRemove;
  final VoidCallback onConfirm;
  final VoidCallback onClear;

  const SessionTray({
    super.key,
    required this.tray,
    required this.hitCache,
    required this.quickMode,
    required this.onEdit,
    required this.onRemove,
    required this.onConfirm,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final lines = tray.lines;
    if (lines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          quickMode
              ? 'Pasa cartas por delante: las claras se apuntan solas aquí '
                  '(las copias iguales suman ×N). Las dudosas, marcadas para '
                  'revisar. Al terminar, confirmas todas.'
              : 'Pasa cartas por delante: las claras se apuntan solas; las '
                  'dudosas te preguntan cuál es. Al terminar, confirmas todas.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 124,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: lines.length,
            itemBuilder: (context, i) => _tile(lines[i]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.playlist_add_check),
                  label: Text('Añadir ${tray.totalQty} a la colección'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onClear,
                child: const Text('Vaciar'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile(TrayLine line) {
    final entry = line.chosen.entry;
    final hit = hitCache[entry.scryfallId];
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () => onEdit(line),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 88,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: line.needsReview
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: MFColors.warning, width: 2))
                        : null,
                    child: CardThumb(
                        url: hit?.imageSmall,
                        colors: hit?.colors ?? '',
                        name: entry.name,
                        width: 50,
                        height: 70),
                  ),
                  if (line.qty > 1)
                    Positioned(
                      left: -4,
                      bottom: -4,
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: MFColors.manaRed,
                        child: Text('×${line.qty}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (line.needsReview)
                    const Positioned(
                      left: -4,
                      top: -4,
                      child:
                          Icon(Icons.help, size: 18, color: MFColors.warning),
                    ),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: GestureDetector(
                      onTap: () => onRemove(line),
                      child: const CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.black54,
                        child:
                            Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                hit?.printedName ?? entry.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
