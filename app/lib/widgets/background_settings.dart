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
                // los colores solo salen con fondo puesto: sin imagen debajo
                // no hay nada que dejar pasar y el tema de siempre ya está
                // pensado para leerse
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
                  const SizedBox(height: 4),
                  Text(t.backgroundCardColor,
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  _Muestras(
                    paleta: kCardColors,
                    elegido: prefs.cardColorId,
                    porDefecto: t.backgroundColorDefault,
                    onElegir: prefs.setCardColor,
                  ),
                  const SizedBox(height: 12),
                  Text(t.backgroundTextColor,
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  _Muestras(
                    paleta: kTextColors,
                    elegido: prefs.textColorId,
                    porDefecto: t.backgroundColorDefault,
                    onElegir: prefs.setTextColor,
                  ),
                  const SizedBox(height: 12),
                  Text(t.backgroundCardOpacity,
                      style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: prefs.cardOpacity,
                    min: kMinCardOpacity,
                    max: kMaxCardOpacity,
                    divisions: 13,
                    label: '${(prefs.cardOpacity * 100).round()} %',
                    onChanged: (v) => prefs.setCardOpacity(v),
                  ),
                  const SizedBox(height: 4),
                  Text(t.backgroundPreview,
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  _Vistazo(prefs: prefs),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Fila de círculos de color. El primero es "el de siempre" y se pinta con un
/// aspa: elegir color es opcional y tiene que poder deshacerse.
///
/// Sin nombres escritos a propósito: un color se reconoce viéndolo, y poner
/// "vino" o "piedra" obligaría a traducir ocho palabras a diez idiomas para
/// decir lo que ya dice el círculo. El nombre va en el tooltip.
class _Muestras extends StatelessWidget {
  final List<NamedColor> paleta;
  final String? elegido;
  final String porDefecto;
  final void Function(String?) onElegir;

  const _Muestras({
    required this.paleta,
    required this.elegido,
    required this.porDefecto,
    required this.onElegir,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _circulo(context,
            color: null, seleccionado: elegido == null, nombre: porDefecto,
            onTap: () => onElegir(null)),
        for (final c in paleta)
          _circulo(context,
              color: c.color,
              seleccionado: elegido == c.id,
              nombre: c.id,
              onTap: () => onElegir(c.id)),
      ],
    );
  }

  Widget _circulo(BuildContext context,
      {required Color? color,
      required bool seleccionado,
      required String nombre,
      required VoidCallback onTap}) {
    final borde = Theme.of(context).colorScheme.onSurface;
    return Tooltip(
      message: nombre,
      child: Semantics(
        button: true,
        selected: seleccionado,
        label: nombre,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                  color: seleccionado
                      ? borde
                      : borde.withValues(alpha: 0.25),
                  width: seleccionado ? 2.5 : 1),
            ),
            child: color == null
                ? Icon(Icons.close, size: 16, color: borde)
                : null,
          ),
        ),
      ),
    );
  }
}

/// Cómo queda una tarjeta con los colores elegidos, encima del fondo de
/// verdad. Sin esto hay que salir de Ajustes para ver si se lee.
class _Vistazo extends StatelessWidget {
  final BackgroundPreference prefs;

  const _Vistazo({required this.prefs});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final letra = prefs.textColor ?? tema.colorScheme.onSurface;
    final tarjeta = (prefs.cardColor ?? tema.colorScheme.surface)
        .withValues(alpha: prefs.cardOpacity);
    final imagen = prefs.image;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 92,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagen != null)
              Image.file(imagen,
                  fit: BoxFit.cover,
                  cacheWidth: 640,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            Container(color: Colors.black.withValues(alpha: prefs.dim)),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tarjeta,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ManaForge',
                        style: TextStyle(
                            color: letra, fontWeight: FontWeight.bold)),
                    Text('Sol Ring · 2,40 €',
                        style: TextStyle(color: letra, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
