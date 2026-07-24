/// Elegir idioma.
///
/// Los nombres van en SU propio idioma: quien busca "日本語" no está leyendo
/// "japonés". Y por defecto se usa el del sistema, que es lo que espera quien
/// abre la app sin tocar nada.
library;

import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/language_prefs.dart';

class LanguageSettingsCard extends StatelessWidget {
  final LanguagePreference prefs;

  const LanguageSettingsCard({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.language,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(t.languageSystem),
                    selected: prefs.code == null,
                    onSelected: (_) => prefs.select(null),
                  ),
                  for (final idioma in kAppLanguages)
                    ChoiceChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(idioma.nativeName),
                      selected: prefs.code == idioma.code,
                      onSelected: (_) => prefs.select(idioma.code),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
