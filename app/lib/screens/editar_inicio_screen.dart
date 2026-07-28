/// Editar Inicio: elegir qué secciones se ven y en qué orden.
///
/// Reordenar y apagar cosas es algo que cuesta deshacer de un vistazo, así que
/// vive en su propia pantalla (no suelto en Inicio) y trae un "Restablecer".
/// Un interruptor encendido NO garantiza que la sección salga: sale si además
/// tiene algo que enseñar (recientes vacío = nada). Eso se dice arriba.
library;

import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';

import 'package:manaforge_app/services/home_layout_prefs.dart';

/// Nombre e icono de cada sección, para pintarla en el editor. Las claves son
/// las de `kHomeSections`.
class _Meta {
  final String titulo;
  final IconData icono;

  const _Meta(this.titulo, this.icono);
}

// el mapa se construye con el idioma de ahora: una constante no puede
// traducirse
Map<String, _Meta> _meta(AppLocalizations t) => {
      'nivel': _Meta(t.ehLevel, Icons.emoji_events_outlined),
      'accesos': _Meta(t.ehShortcuts, Icons.bolt),
      'resumen': _Meta(t.ehSummary, Icons.grid_view),
      'recientes': _Meta(t.ehRecent, Icons.history),
      'mazos': _Meta(t.ehDecks, Icons.layers_outlined),
      'meta': _Meta(t.ehMeta, Icons.trending_up),
      'expansiones': _Meta(t.ehNewSets, Icons.new_releases_outlined),
      'joyas': _Meta(t.ehGems, Icons.diamond_outlined),
    };

class EditarInicioScreen extends StatelessWidget {
  final HomeLayoutPreference layout;

  const EditarInicioScreen({super.key, required this.layout});

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.stEditHome),
        actions: [
          TextButton.icon(
            onPressed: layout.restablecer,
            icon: const Icon(Icons.restart_alt),
            label: Text(t.ehReset),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: layout,
          builder: (context, _) {
            final secciones = layout.todas;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    t.ehHelp,
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: secciones.length,
                    onReorder: (desde, hasta) {
                      // convención de ReorderableListView: al mover hacia
                      // abajo, el índice destino cuenta el hueco que se va a
                      // dejar. El servicio quiere el índice final.
                      if (hasta > desde) hasta -= 1;
                      layout.reordenar(desde, hasta);
                    },
                    itemBuilder: (context, i) {
                      final s = secciones[i];
                      final m = _meta(t)[s.id] ??
                          _Meta(t.ehSection, Icons.widgets_outlined);
                      return Card(
                        key: ValueKey(s.id),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(m.icono),
                          title: Text(m.titulo),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: s.visible,
                                onChanged: (_) => layout.toggle(s.id),
                              ),
                              ReorderableDragStartListener(
                                index: i,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8, right: 4),
                                  child: Icon(Icons.drag_handle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
