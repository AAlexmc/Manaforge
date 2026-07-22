/// Tarjeta de Ajustes para poner un fondo de pantalla.
///
/// La app NO trae un catálogo de fondos ni se los baja de ninguna parte: el
/// arte de Magic tiene dueño y repartirlo dentro de las releases sería
/// redistribuirlo. Lo que hace es llevarte a la página oficial de fondos y
/// dejarte elegir el fichero que te hayas bajado. Tuyo, y de tu disco.
library;

import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/t.dart';
import '../services/background_prefs.dart';
import '../services/safe_input.dart';

class BackgroundSettingsCard extends StatefulWidget {
  final BackgroundPreference prefs;

  const BackgroundSettingsCard({super.key, required this.prefs});

  @override
  State<BackgroundSettingsCard> createState() =>
      _BackgroundSettingsCardState();
}

class _BackgroundSettingsCardState extends State<BackgroundSettingsCard> {
  static const _tipos = XTypeGroup(
      label: 'Imágenes', extensions: ['jpg', 'jpeg', 'png', 'webp']);

  Future<void> _elegir() async {
    try {
      final fichero = await openFile(acceptedTypeGroups: const [_tipos]);
      if (fichero == null) return;
      await widget.prefs.select(File(fichero.path));
    } on InputRejected catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No pude usar esa imagen: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.prefs,
      builder: (context, _) {
        final t = tr(context);
        final prefs = widget.prefs;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.backgroundTitle,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(t.backgroundWhat,
                    style: const TextStyle(fontSize: 12.5)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _elegir,
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: Text(prefs.hasImage
                          ? t.backgroundChange
                          : t.backgroundPick),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => launchUrl(
                          Uri.parse(kOfficialWallpapersUrl),
                          mode: LaunchMode.externalApplication),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(t.backgroundOfficial),
                    ),
                    if (prefs.hasImage)
                      TextButton.icon(
                        onPressed: prefs.clear,
                        icon: const Icon(Icons.close, size: 18),
                        label: Text(t.backgroundRemove),
                      ),
                  ],
                ),
                if (prefs.hasImage) ...[
                  const SizedBox(height: 8),
                  Text(t.backgroundDim,
                      style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: prefs.dim,
                    min: kMinDim,
                    max: kMaxDim,
                    divisions: 12,
                    label: '${(prefs.dim * 100).round()} %',
                    onChanged: (v) => prefs.setDim(v),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
