import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/theme/mf_theme.dart';

/// Un candidato listo para pintar en el selector: solo lo que ve el usuario.
class VersionChoice {
  final String name;
  final String setLine;
  final String? imageUrl;

  const VersionChoice(
      {required this.name, required this.setLine, this.imageUrl});
}

/// Convierte los candidatos de una línea de bandeja en [VersionChoice],
/// resolviendo nombre impreso e imagen contra la caché de cartas.
List<VersionChoice> versionChoicesFrom(
    TrayLine line, Map<String, CardHit?> hitCache) {
  return [
    for (final c in line.candidates)
      VersionChoice(
        name: hitCache[c.entry.scryfallId]?.printedName ?? c.entry.name,
        setLine: '${c.entry.setCode.toUpperCase()} '
            '#${c.entry.collectorNumber}',
        imageUrl: hitCache[c.entry.scryfallId]?.imageNormal ??
            hitCache[c.entry.scryfallId]?.imageSmall,
      ),
  ];
}

/// Diálogo CENTRADO con las cartas en grande para comparar ilustraciones y
/// elegir la buena. Devuelve el índice tocado, o null si se cierra sin más.
Future<int?> showVersionPicker(BuildContext context,
    {required List<VersionChoice> choices, int? selected}) {
  return showDialog<int>(
    context: context,
    builder: (context) => Dialog(
      child: _VersionPickerBody(choices: choices, selected: selected),
    ),
  );
}

class _VersionPickerBody extends StatelessWidget {
  final List<VersionChoice> choices;
  final int? selected;

  const _VersionPickerBody({required this.choices, this.selected});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    // carta grande: más de media pantalla de alto, con techo razonable
    final cardH = (screen.height * 0.55).clamp(240.0, 480.0);
    final cardW = cardH * 63 / 88;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr(context).scWhichIsIt,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(tr(context).vpTapCorrect,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 14),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < choices.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                          right: i == choices.length - 1 ? 0 : 14),
                      child: _BigCandidate(
                        key: Key('version-card-$i'),
                        choice: choices[i],
                        isSelected: i == selected,
                        width: cardW,
                        height: cardH,
                        onTap: () => Navigator.of(context).pop(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr(context).acCancel),
          ),
        ],
      ),
    );
  }
}

class _BigCandidate extends StatelessWidget {
  final VersionChoice choice;
  final bool isSelected;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _BigCandidate(
      {super.key,
      required this.choice,
      required this.isSelected,
      required this.width,
      required this.height,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final url = choice.imageUrl;
    Widget art = url == null
        ? _artFallback(context)
        : Image.network(url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _artFallback(context));
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: art,
                ),
                if (isSelected)
                  const Positioned(
                    right: 8,
                    top: 8,
                    child: Icon(Icons.check_circle,
                        color: MFColors.success, size: 28),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(choice.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(choice.setLine,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _artFallback(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(choice.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
