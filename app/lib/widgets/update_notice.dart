/// Lo que se ve del aviso de versión nueva: una tira en Inicio y una tarjeta
/// en Ajustes.
///
/// La app no se actualiza sola a propósito (ver `services/app_update.dart`):
/// el botón lleva a la página de descargas y ahí decide el usuario. Mientras
/// los binarios no vayan firmados, mandar a la página oficial es más honesto
/// que bajar un zip por su cuenta.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_update.dart';
import '../theme/mf_theme.dart';

/// Abre la página de la release en el navegador. Si no se puede (sistema sin
/// navegador, permisos), enseña la dirección para copiarla: quedarse en
/// silencio sería peor.
Future<void> openReleasePage(BuildContext context, AppRelease release) async {
  // segunda comprobación, aquí mismo: lo que se abre viene de un JSON de
  // fuera y esto es lo último antes de lanzarlo al sistema
  if (!release.pageUrl.startsWith(kRepoUrlPrefix)) return;
  var abierto = false;
  try {
    abierto = await launchUrl(Uri.parse(release.pageUrl),
        mode: LaunchMode.externalApplication);
  } catch (_) {
    abierto = false;
  }
  if (abierto || !context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Descargar ManaForge'),
      content: SelectableText(release.pageUrl),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: release.pageUrl));
            Navigator.of(context).pop();
          },
          child: const Text('Copiar enlace'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

/// Tira discreta en Inicio. No tapa nada ni bloquea: se puede apartar.
class UpdateBanner extends StatefulWidget {
  final AppUpdateChecker checker;

  const UpdateBanner({super.key, required this.checker});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
  /// Apartada en esta sesión. No se guarda en disco: si de verdad no la
  /// quiere ver, para eso está el interruptor de Ajustes.
  bool _apartada = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.checker,
      builder: (context, _) {
        final release = widget.checker.available;
        if (release == null || _apartada) return const SizedBox.shrink();
        return Card(
          color: MFColors.forge.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
            child: Row(
              children: [
                const Icon(Icons.download_outlined, color: MFColors.forge),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hay ManaForge ${release.version}',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Tienes la ${widget.checker.currentVersion}. La app '
                          'no se actualiza sola: te lleva a la descarga.',
                          style: const TextStyle(fontSize: 11.5)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => openReleasePage(context, release),
                  child: const Text('Ver'),
                ),
                IconButton(
                  tooltip: 'Ahora no',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _apartada = true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tarjeta de Ajustes: qué versión tienes, si se mira y buscar a mano.
class UpdateSettingsCard extends StatefulWidget {
  final AppUpdateChecker checker;

  const UpdateSettingsCard({super.key, required this.checker});

  @override
  State<UpdateSettingsCard> createState() => _UpdateSettingsCardState();
}

class _UpdateSettingsCardState extends State<UpdateSettingsCard> {
  bool _buscando = false;
  String? _resultado;

  Future<void> _buscarAhora() async {
    setState(() {
      _buscando = true;
      _resultado = null;
    });
    // a mano se pregunta SIEMPRE, aunque toque dentro de un rato
    final release = await widget.checker.checkNow();
    if (!mounted) return;
    setState(() {
      _buscando = false;
      _resultado = release == null
          ? 'Estás en la última versión (o GitHub no contesta ahora mismo).'
          : 'Hay ManaForge ${release.version}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.checker,
      builder: (context, _) {
        final release = widget.checker.available;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Versión de ManaForge',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text('Tienes la ${widget.checker.currentVersion}.',
                    style: const TextStyle(fontSize: 12.5)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: widget.checker.enabled,
                  onChanged: (v) => widget.checker.setEnabled(v),
                  title: const Text('Avisarme de versiones nuevas'),
                  subtitle: const Text(
                      'Pregunta una vez al día a GitHub qué versión es la '
                      'última. No descarga ni instala nada.',
                      style: TextStyle(fontSize: 11.5)),
                ),
                if (release != null) ...[
                  const SizedBox(height: 4),
                  Text('Hay ManaForge ${release.version}: ${release.title}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (release.notes.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(release.notes.trim(),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5)),
                    ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => openReleasePage(context, release),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Ir a la descarga'),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  OutlinedButton.icon(
                    onPressed: _buscando ? null : _buscarAhora,
                    icon: _buscando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh, size: 18),
                    label: const Text('Buscar ahora'),
                  ),
                ],
                if (_resultado != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_resultado!,
                        style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
