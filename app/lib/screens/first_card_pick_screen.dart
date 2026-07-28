import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/services/certificates.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/theme/mf_theme.dart';
import 'package:manaforge_app/widgets/common.dart';

/// Elegir UNA carta de tu colección: la que te metió en Magic, para que salga
/// en el certificado de bienvenida.
///
/// Es un selector de una sola carta a propósito (el de carpetas es de varias):
/// aquí se elige un recuerdo, y tocar una carta ya es la respuesta.
class FirstCardPickScreen extends StatefulWidget {
  final CollectionStore collection;
  final String? selected; // oracleId ya elegido, para marcarlo

  const FirstCardPickScreen(
      {super.key, required this.collection, this.selected});

  @override
  State<FirstCardPickScreen> createState() => _FirstCardPickScreenState();
}

class _FirstCardPickScreenState extends State<FirstCardPickScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<OwnedCard> get _visible {
    final q = _query.trim().toLowerCase();
    final cards = widget.collection.cards;
    if (q.isEmpty) return cards;
    return cards
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            (c.printedName?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  void _pick(OwnedCard card) {
    Navigator.of(context).pop(FirstCard(
      oracleId: card.oracleId,
      name: card.printedName?.isNotEmpty == true ? card.printedName! : card.name,
      image: card.imageNormal ?? card.imageSmall,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cards = _visible;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context).fcTitle),
        actions: [
          if (widget.selected != null)
            TextButton(
              // devolver el "quitar" tiene que ser distinto de cancelar, que
              // es lo que hace la flecha de atrás
              onPressed: () => Navigator.of(context).pop(_borrar),
              child: Text(tr(context).fcRemove),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: tr(context).fcSearchHint,
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: cards.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        tr(context).fcNoMatch,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, i) {
                      final card = cards[i];
                      final elegida = card.oracleId == widget.selected;
                      return ListTile(
                        leading: CardThumb(
                            url: card.imageSmall,
                            colors: card.colors,
                            name: card.name),
                        title: Text(card.printedName?.isNotEmpty == true
                            ? card.printedName!
                            : card.name),
                        subtitle: Text(card.typeLine),
                        trailing: elegida
                            ? const Icon(Icons.check_circle,
                                color: MFColors.success)
                            : null,
                        onTap: () => _pick(card),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Lo que devuelve la pantalla cuando el usuario pulsa "Quitar": distinguirlo
/// de `null` (cancelar) evita borrar el recuerdo por darle a la flecha atrás.
const Object _borrar = 'quitar';

/// ¿La pantalla ha dicho "quítala"?
bool isRemoveFirstCard(Object? result) => identical(result, _borrar);
