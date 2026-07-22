/// "¿En qué idioma?", una sola vez.
///
/// Sale al entrar por primera vez y no vuelve a salir: cerrarlo también es
/// contestar. Después se cambia en Ajustes cuando se quiera.
///
/// Los nombres van cada uno en SU idioma, sin traducir: quien busca 한국어 no
/// está leyendo "coreano".
library;

import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/language_prefs.dart';

/// Pregunta el idioma si no se ha preguntado nunca.
Future<void> maybeAskLanguage(
    BuildContext context, LanguagePreference prefs) async {
  await prefs.load();
  if (prefs.asked || !context.mounted) return;
  await showLanguagePickerDialog(context, prefs);
  await prefs.markAsked();
}

Future<void> showLanguagePickerDialog(
    BuildContext context, LanguagePreference prefs) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.language),
          const SizedBox(width: 8),
          Expanded(child: Text(tr(context).language)),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr(context).languagePartial,
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ChoiceChip(
                    label: Text(tr(context).languageSystem),
                    selected: prefs.code == null,
                    onSelected: (_) {
                      prefs.select(null);
                      Navigator.of(context).pop();
                    },
                  ),
                  for (final idioma in kAppLanguages)
                    ChoiceChip(
                      label: Text(idioma.nativeName),
                      selected: prefs.code == idioma.code,
                      onSelected: (_) {
                        prefs.select(idioma.code);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
