import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/t.dart';
import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/deck_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'deck_detail_screen.dart';

/// Mis mazos: los guardados desde Forge. Tocar uno lo abre con todo
/// (plan, curva editable, lista) releyendo las cartas de la DB local.
class MazosScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;

  /// Llevar a Forge. Desde la pantalla vacía hay que poder ir sin saberse la
  /// barra de abajo de memoria.
  final VoidCallback? onGoToForge;

  const MazosScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.decks,
      this.onGoToForge});

  @override
  State<MazosScreen> createState() => _MazosScreenState();
}

class _MazosScreenState extends State<MazosScreen> {
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    widget.decks.load();
  }

  Future<void> _open(SavedDeck saved) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      // pool = colección actual + las cartas del mazo (por si ya no las tienes)
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle);
      // lo que tienes DE VERDAD, antes de rellenar el pool con las cartas que
      // ya no tienes (esas entran con la cantidad que pide el mazo)
      final propias = {for (final e in pool.entries) e.key: e.value.qty};
      final extra = await widget.db
          .poolByNames({...saved.cards, ...saved.lands});
      extra.forEach((k, v) => pool.putIfAbsent(k, () => v));
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DeckDetailScreen(
          gen: saved.toGenerated(),
          pool: pool,
          db: widget.db,
          decks: widget.decks,
          ownedPrintings: widget.collection.printingQty.keys.toSet(),
          ownedByName: propias,
        ),
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No pude abrir el mazo '
                '(¿está descargada la base de datos?): $e')));
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  String _dateLabel(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    two(int n) => n < 10 ? '0$n' : '$n';
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.decks,
          builder: (context, _) {
            final decks = widget.decks.decks;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mis mazos',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(decks.isEmpty
                      ? 'Aquí vivirán los mazos que guardes desde Forge '
                          '(botón de guardar en el detalle del mazo).'
                      : '${decks.length} guardado${decks.length == 1 ? '' : 's'}'),
                  const SizedBox(height: 12),
                  Expanded(
                    child: decks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.layers_outlined,
                                    size: 64, color: Colors.white24),
                                const SizedBox(height: 12),
                                // decir dónde está Forge no basta: desde una
                                // pantalla vacía tiene que haber por dónde ir
                                if (widget.onGoToForge != null)
                                  FilledButton.icon(
                                    onPressed: widget.onGoToForge,
                                    icon: const Icon(Icons.auto_awesome,
                                        size: 18),
                                    label: Text(tr(context)
                                        .decksEmptyGoForge),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: decks.length,
                            itemBuilder: (context, i) {
                              final d = decks[i];
                              return Card(
                                child: ListTile(
                                  leading: ColorIdentityDots(
                                      colors: d.colors, size: 14),
                                  title: Text(d.name),
                                  subtitle: Text(
                                      '${d.archetype} · ${d.totalSpells} hechizos '
                                      '+ ${d.totalLands} tierras · '
                                      'guardado el ${_dateLabel(d.savedAt)}'),
                                  trailing: IconButton(
                                    tooltip: 'Borrar mazo',
                                    icon: const Icon(
                                        Icons.delete_outline,
                                        color: MFColors.warning),
                                    onPressed: () =>
                                        widget.decks.remove(d.id),
                                  ),
                                  onTap: () => _open(d),
                                ),
                              );
                            },
                          ),
                  ),
                  if (_opening) const LinearProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
