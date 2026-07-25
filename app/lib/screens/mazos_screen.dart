import 'package:flutter/material.dart';

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

  /// Borrar un mazo no es reversible una vez guardado el fichero, así que en
  /// vez de un diálogo se borra ya y se ofrece deshacer 6 s: menos fricción,
  /// misma red de seguridad. Deshacer lo vuelve a meter en su sitio.
  void _borrarConDeshacer(BuildContext context, SavedDeck d, int index) {
    widget.decks.remove(d.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(tr(context).dkDeleted(d.name)),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: tr(context).dkUndo,
          onPressed: () => widget.decks.restore(d, index),
        ),
      ));
  }

  Future<void> _open(SavedDeck saved) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      // pool = colección actual + las cartas del mazo (por si ya no las
      // tienes). Las básicas se asumen "gratis" (decisión de producto,
      // coherente con Forge — forge_screen.dart: `assumeBasics: true`), y
      // CUÁNTAS depende del formato: `SavedDeck` no lo guarda, así que se
      // infiere por el tamaño total del mazo (~100 cartas = Commander, 40
      // básicas asumidas; si no, 25 — mismo umbral que ya usa la cabecera
      // del detalle para saber que un Commander no son 60 cartas). Sin
      // esto, "cuántas te faltan" podía decir un número distinto al que
      // Forge acababa de decir al generar el mazo.
      final totalCartas = saved.totalSpells + saved.totalLands;
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle,
          assumeBasics: true, basicsQty: totalCartas >= 100 ? 40 : 25);
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
            content: Text(tr(context).dkOpenFailed('$e'))));
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
                  Text(tr(context).dkMyDecks,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(decks.isEmpty
                      ? tr(context).dkEmpty
                      : tr(context).dkSavedCount(decks.length)),
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
                                  subtitle: Text(tr(context).dkSubtitle(
                                      d.archetype,
                                      d.totalSpells,
                                      d.totalLands,
                                      _dateLabel(d.savedAt))),
                                  trailing: IconButton(
                                    tooltip: tr(context).dkDeleteTooltip,
                                    icon: const Icon(
                                        Icons.delete_outline,
                                        color: MFColors.warning),
                                    onPressed: () =>
                                        _borrarConDeshacer(context, d, i),
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
