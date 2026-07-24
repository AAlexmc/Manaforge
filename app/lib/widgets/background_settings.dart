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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/t.dart';
import '../services/background_prefs.dart';
import '../services/safe_input.dart';
import '../theme/contrast.dart';

class BackgroundSettingsCard extends StatefulWidget {
  final BackgroundPreference prefs;

  const BackgroundSettingsCard({super.key, required this.prefs});

  @override
  State<BackgroundSettingsCard> createState() =>
      _BackgroundSettingsCardState();
}

class _BackgroundSettingsCardState extends State<BackgroundSettingsCard> {
  Future<void> _elegir() async {
    final t = tr(context);
    try {
      final fichero = await openFile(acceptedTypeGroups: [
        XTypeGroup(
            label: t.bgImages,
            extensions: const ['jpg', 'jpeg', 'png', 'webp'])
      ]);
      if (fichero == null) return;
      await widget.prefs.select(File(fichero.path));
    } on InputRejected catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(inputRejectedText(t, e))));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.bgImageFailed('$e'))));
      }
    }
  }

  /// Pone la letra a medida y, si queda con poco contraste sobre la tarjeta,
  /// avisa: el tema la ajustará sola a un color legible (no la deja ilegible).
  Future<void> _ponerLetra(
      BuildContext context, BackgroundPreference prefs, Color c) async {
    await prefs.setTextColorCustom(c);
    if (!context.mounted) return;
    final fondo = prefs.cardColor ?? Theme.of(context).colorScheme.surface;
    if (!esLegible(c, fondo)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(tr(context).bgLowContrast),
        duration: const Duration(seconds: 4),
      ));
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
                    custom: prefs.cardCustomColor,
                    customActivo: prefs.cardIsCustom,
                    onCustom: prefs.setCardColorCustom,
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
                    custom: prefs.textCustomColor,
                    customActivo: prefs.textIsCustom,
                    onCustom: (c) => _ponerLetra(context, prefs, c),
                  ),
                  const SizedBox(height: 12),
                  Text(t.bgChipColor, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  _Muestras(
                    paleta: const [],
                    elegido: null,
                    porDefecto: t.backgroundColorDefault,
                    onElegir: (_) => prefs.setChipColor(null),
                    custom: prefs.chipColor,
                    customActivo: prefs.chipColor != null,
                    onCustom: prefs.setChipColor,
                  ),
                  const SizedBox(height: 12),
                  Text(t.bgIconColor, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  _Muestras(
                    paleta: const [],
                    elegido: null,
                    porDefecto: t.backgroundColorDefault,
                    onElegir: (_) => prefs.setIconColor(null),
                    custom: prefs.iconColor,
                    customActivo: prefs.iconColor != null,
                    onCustom: prefs.setIconColor,
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

  /// El color a medida puesto (o null), si está activo, y cómo cambiarlo.
  final Color? custom;
  final bool customActivo;
  final void Function(Color) onCustom;

  const _Muestras({
    required this.paleta,
    required this.elegido,
    required this.porDefecto,
    required this.onElegir,
    required this.custom,
    required this.customActivo,
    required this.onCustom,
  });

  @override
  Widget build(BuildContext context) {
    // "el de siempre" solo está elegido si NO hay preset NI color a medida
    final sinElegir = elegido == null && !customActivo;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _circulo(context,
            color: null, seleccionado: sinElegir, nombre: porDefecto,
            onTap: () => onElegir(null)),
        for (final c in paleta)
          _circulo(context,
              color: c.color,
              seleccionado: !customActivo && elegido == c.id,
              nombre: c.id,
              onTap: () => onElegir(c.id)),
        _CirculoCustom(
          color: custom,
          activo: customActivo,
          onTap: () => _elegirColor(
              context, custom ?? (paleta.isEmpty ? Colors.grey : paleta.first.color),
              onCustom),
        ),
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

/// El círculo del color a medida. Si hay uno puesto, se pinta con él; si no,
/// con un arcoíris que dice "aquí eliges el que quieras".
class _CirculoCustom extends StatelessWidget {
  final Color? color;
  final bool activo;
  final VoidCallback onTap;

  const _CirculoCustom(
      {required this.color, required this.activo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final borde = Theme.of(context).colorScheme.onSurface;
    return Tooltip(
      message: tr(context).bgCustom,
      child: Semantics(
        button: true,
        selected: activo,
        label: tr(context).bgPickCustom,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: activo ? color : null,
              shape: BoxShape.circle,
              gradient: activo
                  ? null
                  : const SweepGradient(colors: [
                      Color(0xFFFF0000),
                      Color(0xFFFFFF00),
                      Color(0xFF00FF00),
                      Color(0xFF00FFFF),
                      Color(0xFF0000FF),
                      Color(0xFFFF00FF),
                      Color(0xFFFF0000),
                    ]),
              border: Border.all(
                  color: activo ? borde : borde.withValues(alpha: 0.25),
                  width: activo ? 2.5 : 1),
            ),
            child: activo
                ? null
                : const Icon(Icons.colorize, size: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Abre el selector de color (área HSV + tono + RGB/hex). Si se confirma,
/// devuelve el color por [onOk].
Future<void> _elegirColor(
    BuildContext context, Color inicial, void Function(Color) onOk) async {
  var sel = inicial;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(tr(ctx).bgCustomColor),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: inicial,
          onColorChanged: (c) => sel = c,
          enableAlpha: false, // la transparencia de las tarjetas va aparte
          hexInputBar: true,
          labelTypes: const [ColorLabelType.rgb, ColorLabelType.hex],
          pickerAreaHeightPercent: 0.7,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(tr(ctx).acCancel)),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(tr(ctx).bgUseThis)),
      ],
    ),
  );
  if (ok == true) onOk(sel);
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
    final cardOpaco = prefs.cardColor ?? tema.colorScheme.surface;
    final tarjeta = cardOpaco.withValues(alpha: prefs.cardOpacity);
    // muestras de pestaña e icono: si no se han elegido, los del tema. El
    // icono se ajusta para leerse sobre la tarjeta, igual que hace el tema.
    final chip = prefs.chipColor ?? tema.colorScheme.primary;
    final icono = legibleOn(cardOpaco, prefs.iconColor ?? letra);
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // una pestaña de muestra, con su color
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: chip,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(tr(context).bgSampleTab,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: ThemeData.estimateBrightnessForColor(
                                              chip) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        const Spacer(),
                        // un icono de muestra, con su color
                        Icon(Icons.star_rounded, size: 20, color: icono),
                      ],
                    ),
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
