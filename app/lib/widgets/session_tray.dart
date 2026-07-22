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

  /// Sumar o restar copias de una línea con un toque. Es la vía rápida para
  /// un montón de repetidas: mucho mejor que pasarlas una a una por delante
  /// de la cámara, y es además la forma HONESTA de contar dos copias
  /// idénticas (la cámara no puede distinguirlas).
  final void Function(TrayLine, int delta) onQty;

  /// La impresión que está ahora mismo sobre la mesa, para marcarla. Que se
  /// vea que está ahí y que no va a sumar sola.
  final String? onTableKey;

  /// Carpeta a la que se van a etiquetar estas cartas, si hay alguna elegida.
  /// No es un destino alternativo: van a la colección igual.
  final String? folderName;

  /// Abrir el selector de carpeta. Si es null, no se enseña (la pantalla no
  /// tiene carpetas a mano).
  final VoidCallback? onPickFolder;
  final VoidCallback onConfirm;
  final VoidCallback onClear;

  const SessionTray({
    super.key,
    required this.tray,
    required this.hitCache,
    required this.quickMode,
    required this.onEdit,
    required this.onRemove,
    required this.onQty,
    this.onTableKey,
    this.folderName,
    this.onPickFolder,
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
          height: 148,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: lines.length,
            itemBuilder: (context, i) => _tile(lines[i]),
          ),
        ),
        if (onPickFolder != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ActionChip(
                avatar: Icon(
                    folderName == null
                        ? Icons.folder_off_outlined
                        : Icons.folder,
                    size: 18),
                label: Text(folderName == null
                    ? 'Sin carpeta'
                    : 'Y además a: $folderName'),
                onPressed: onPickFolder,
              ),
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
                  // el botón dice TODO lo que va a pasar al pulsarlo,
                  // incluida la carpeta: es la última pantalla antes de
                  // tocarlo y no se puede quedar a medias de contarlo
                  label: Text(folderName == null
                      ? 'Añadir ${tray.totalQty} a la colección'
                      : 'Añadir ${tray.totalQty} a la colección '
                          'y a $folderName'),
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
    final enMesa = onTableKey != null && line.key == onTableKey;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () => onEdit(line),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 92,
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
              const SizedBox(height: 2),
              // sumar copias a mano: la cámara no puede distinguir dos
              // cartas idénticas, así que esta es la forma de decirlo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepButton(
                      icon: Icons.remove,
                      tooltip: 'Una menos',
                      onTap: () => onQty(line, -1)),
                  Text('${line.qty}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  _StepButton(
                      icon: Icons.add,
                      tooltip: 'Otra igual',
                      onTap: () => onQty(line, 1)),
                ],
              ),
              Text(
                enMesa ? 'en mesa' : (hit?.printedName ?? entry.name),
                maxLines: enMesa ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.5,
                    fontStyle: enMesa ? FontStyle.italic : null,
                    color: enMesa ? MFColors.warning : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botoncito de ±1 de la ficha: área táctil decente sin ocupar media ficha.
class _StepButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _StepButton(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 16,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(icon, size: 15),
        ),
      ),
    );
  }
}
