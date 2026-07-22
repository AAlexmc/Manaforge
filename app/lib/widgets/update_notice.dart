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

import '../l10n/t.dart';
import '../services/app_update.dart';
import '../services/whats_new.dart';
import '../theme/mf_theme.dart';
import 'whats_new_dialog.dart';

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
      title: Text(tr(context).downloadTitle),
      content: SelectableText(release.pageUrl),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: release.pageUrl));
            Navigator.of(context).pop();
          },
          child: Text(tr(context).downloadCopyLink),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr(context).downloadClose),
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
        final t = tr(context);
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
                      Text(t.versionThereIs(release.version),
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          t.versionNotAuto(widget.checker.currentVersion),
                          style: const TextStyle(fontSize: 11.5)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => openReleasePage(context, release),
                  child: Text(t.versionSee),
                ),
                IconButton(
                  tooltip: t.versionNotNow,
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

  /// Qué salió del último "buscar ahora". Se guarda el RESULTADO, no su
  /// texto: el texto ya traducido se quedaba en el idioma que hubiera al
  /// pulsar y no cambiaba al cambiar de idioma en Ajustes.
  bool _consultado = false;
  AppRelease? _ultimo;

  Future<void> _buscarAhora() async {
    setState(() {
      _buscando = true;
      _consultado = false;
    });
    // a mano se pregunta SIEMPRE, aunque toque dentro de un rato
    final release = await widget.checker.checkNow();
    if (!mounted) return;
    setState(() {
      _buscando = false;
      _consultado = true;
      _ultimo = release;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.checker,
      builder: (context, _) {
        final t = tr(context);
        final release = widget.checker.available;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.versionTitle,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(t.versionYouHave(widget.checker.currentVersion),
                        style: const TextStyle(fontSize: 12.5)),
                    if (currentNews != null)
                      TextButton(
                        onPressed: () =>
                            showWhatsNewDialog(context, currentNews!),
                        child: Text(t.versionSeeWhatsNew),
                      ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: widget.checker.enabled,
                  onChanged: (v) => widget.checker.setEnabled(v),
                  title: Text(t.versionNotifyMe),
                  subtitle: Text(t.versionNotifyMeWhy,
                      style: const TextStyle(fontSize: 11.5)),
                ),
                if (release != null) ...[
                  const SizedBox(height: 4),
                  Text('${t.versionThereIs(release.version)} ${release.title}',
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
                    label: Text(t.versionGoDownload),
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
                    label: Text(t.versionCheckNow),
                  ),
                ],
                if (_consultado)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                        _ultimo == null
                            ? t.versionUpToDate
                            : t.versionThereIs(_ultimo!.version),
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
