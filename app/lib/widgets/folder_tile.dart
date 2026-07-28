import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/services/folder_store.dart';

/// Icono de carpeta a partir de la clave guardada en el JSON. Se resuelve
/// aquí (y no con `IconData(codePoint)`) porque los iconos por código se
/// caen con el tree-shaking de iconos al compilar en release.
IconData folderIconFor(String key) => switch (key) {
      'star' => Icons.star,
      'favorite' => Icons.favorite,
      'bolt' => Icons.bolt,
      'shield' => Icons.shield,
      'sell' => Icons.sell,
      'diamond' => Icons.diamond,
      'local_fire_department' => Icons.local_fire_department,
      'water_drop' => Icons.water_drop,
      'forest' => Icons.forest,
      'skull' => Icons.psychology_alt,
      'auto_awesome' => Icons.auto_awesome,
      _ => Icons.folder,
    };

/// Tarjeta de carpeta en la portada de Colección: icono en su color, nombre,
/// cuántas cartas tiene y cuánto valen.
class FolderCard extends StatelessWidget {
  final CardFolder folder;
  final int presentCount;
  final double? value;
  final bool approximate;
  final VoidCallback onTap;

  const FolderCard({
    super.key,
    required this.folder,
    required this.presentCount,
    required this.value,
    required this.approximate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(folder.colorValue);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(folderIconFor(folder.icon), color: color),
              ),
              const SizedBox(height: 10),
              Text(
                folder.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                tr(context).ftCards(presentCount),
                style: const TextStyle(fontSize: 11.5),
              ),
              Text(
                value == null
                    ? '…'
                    : '${approximate ? '~' : ''}${value!.toStringAsFixed(2)} €',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
