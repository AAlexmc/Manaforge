/// Elegir el Estilo del mazo en Forge: Auto (decide el motor), un tema
/// mecánico o una tribu curada. El valor que viaja al motor es el que
/// entiende `themeOverride` ('lifegain', 'tribal:Elf', ...); Auto es null.
library;

import 'package:flutter/material.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import '../l10n/t.dart';
import '../services/forge_texts.dart';

/// Abre la hoja y devuelve el estilo elegido: cadena vacía para Auto (null
/// de `themeOverride`), el tema/tribu si se eligió uno, o `null` si se cerró
/// SIN elegir (atrás / tocar fuera) — null aquí es "no toques nada", no
/// "Auto": si fuera lo mismo, cerrar la hoja sin querer resetearía a Auto
/// cualquier estilo ya elegido.
Future<String?> showStylePickerSheet(BuildContext context,
    {required String? selected}) {
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _StylePickerSheet(selected: selected),
  );
}

class _StylePickerSheet extends StatelessWidget {
  final String? selected;

  const _StylePickerSheet({required this.selected});

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(t.fgStyle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const Divider(height: 8),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.auto_awesome),
                    title: Text(t.fgStyleAuto),
                    trailing:
                        selected == null ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(context).pop(''),
                  ),
                  const Divider(height: 1),
                  for (final theme in fe.themeColors.keys)
                    ListTile(
                      leading: const Icon(Icons.auto_fix_high, size: 20),
                      title: Text(themeName(t, theme)),
                      trailing:
                          selected == theme ? const Icon(Icons.check) : null,
                      onTap: () => Navigator.of(context).pop(theme),
                    ),
                  const Divider(height: 1),
                  for (final tribe in fe.kUiTribes)
                    ListTile(
                      leading: const Icon(Icons.groups, size: 20),
                      title: Text(tribeName(t, tribe)),
                      trailing: selected == 'tribal:$tribe'
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => Navigator.of(context).pop('tribal:$tribe'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
