/// "Qué hay de nuevo": lo que ha cambiado desde la última vez que abriste.
///
/// Sale UNA vez por versión y se puede volver a ver desde Ajustes. Y no sale
/// en un estreno: quien abre ManaForge por primera vez no tiene nada que
/// comparar y bastante tiene con empezar.
library;

import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/app_update.dart';
import '../services/whats_new.dart';
import '../theme/mf_theme.dart';

/// Enseña las novedades si toca, y las da por vistas.
///
/// [hasExistingData] distingue un estreno de una actualización: quien venía
/// de una versión anterior a esto no tiene el fichero de preferencias, pero
/// sí tiene cartas. Sin esa pista, a los que actualizan no se les enseñaría
/// nada nunca.
Future<void> maybeShowWhatsNew(
  BuildContext context, {
  required AppUpdateChecker checker,
  required bool hasExistingData,
}) async {
  await checker.load();
  final estreno = checker.firstRun && !hasExistingData;
  final toca = estreno
      ? false
      : shouldShowWhatsNew(
          current: checker.currentVersion,
          // quien viene de una versión sin este fichero cuenta como "vio
          // algo anterior", no como estreno
          seen: checker.seenVersion ?? (checker.firstRun ? 'anterior' : null),
        );
  if (!toca) {
    await checker.markNewsSeen(); // para que la próxima sí se note
    return;
  }
  if (!context.mounted) return;
  await showWhatsNewDialog(context, newsFor(checker.currentVersion)!);
  await checker.markNewsSeen();
}

Future<void> showWhatsNewDialog(BuildContext context, VersionNews news) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.auto_awesome, color: MFColors.forge),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
                  tr(context).whatsNewTitle(news.version))),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(news.headline,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              for (final linea in news.bullets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('· '),
                      Expanded(
                          child: Text(linea,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr(context).whatsNewClose),
        ),
      ],
    ),
  );
}
