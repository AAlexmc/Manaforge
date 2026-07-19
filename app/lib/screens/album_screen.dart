import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../theme/mf_theme.dart';

/// Álbum por expansiones, estilo TCG Pocket: cada set es una página con
/// TODAS sus cartas en rejilla; las que no tienes se ven apagadas y las
/// tuyas a color con su cantidad. Coleccionar también es un juego.
class AlbumScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;

  const AlbumScreen({super.key, required this.db, required this.collection});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<SetInfo>? _sets;
  Map<String, int> _owned = const {};
  bool _onlyMine = true;
  String _query = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final sets = await widget.db.sets();
      Map<String, int> owned;
      if (widget.collection.hasPrintingData) {
        // preciso: sabemos la edición exacta de cada carta (clave "set|nº")
        owned = {};
        widget.collection.printingQty.forEach((key, qty) {
          if (qty <= 0) return;
          final set = key.split('|').first;
          owned[set] = (owned[set] ?? 0) + 1;
        });
      } else {
        // aproximado (colecciones antiguas): por carta, no por edición
        owned = await widget.db
            .ownedCountBySet(widget.collection.qtyByOracle.keys);
      }
      if (!mounted) return;
      setState(() {
        _sets = sets;
        _owned = owned;
        // si la colección está vacía, no tiene sentido filtrar por "míos"
        if (owned.isEmpty) _onlyMine = false;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final sets = _sets;
    List<SetInfo> visible = const [];
    if (sets != null) {
      visible = sets.where((s) {
        if (_onlyMine && (_owned[s.code] ?? 0) == 0) return false;
        if (_query.isNotEmpty &&
            !s.name.toLowerCase().contains(_query.toLowerCase()) &&
            !s.code.toLowerCase().contains(_query.toLowerCase())) {
          return false;
        }
        return true;
      }).toList()
        // primero los que más completos llevas: coleccionar pica
        ..sort((a, b) {
          final pa = (_owned[a.code] ?? 0) / (a.total == 0 ? 1 : a.total);
          final pb = (_owned[b.code] ?? 0) / (b.total == 0 ? 1 : b.total);
          return pb.compareTo(pa);
        });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Álbum')),
      body: sets == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('No pude abrir el álbum: $_error'),
                    ),
            )
          : Column(
              children: [
                if (!widget.collection.hasPrintingData &&
                    widget.collection.distinctCards > 0)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MFColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Álbum en modo aproximado: aún no sé qué EDICIÓN exacta '
                      'tienes de cada carta. Reimporta tu CSV con "Sustituir '
                      'mi colección actual" activado y el álbum se afinará '
                      'por ilustraciones.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Busca una expansión…',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilterChip(
                        selected: _onlyMine,
                        label: const Text('Con cartas mías'),
                        onSelected: (v) => setState(() => _onlyMine = v),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(
                          child: Text('Ninguna expansión coincide con el filtro.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: visible.length,
                          itemBuilder: (context, i) {
                            final s = visible[i];
                            final owned = _owned[s.code] ?? 0;
                            final complete = owned >= s.total && s.total > 0;
                            return Card(
                              child: ListTile(
                                title: Text(s.name),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: s.total == 0
                                              ? 0
                                              : owned / s.total,
                                          minHeight: 6,
                                          color: complete
                                              ? MFColors.success
                                              : MFColors.manaRed,
                                          backgroundColor: MFColors.manaRed
                                              .withValues(alpha: 0.12),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$owned/${s.total} cartas'
                                        '${complete ? ' · ✓ ¡completa!' : ''}',
                                        style: TextStyle(
                                            fontSize: 11.5,
                                            color: complete
                                                ? MFColors.success
                                                : null),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Text(s.code.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AlbumSetScreen(
                                      db: widget.db,
                                      collection: widget.collection,
                                      set: s,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

/// Página de un set: rejilla con todas sus cartas. Las no poseídas, en gris
/// semitransparente; las poseídas, a color y con su cantidad.
class AlbumSetScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final SetInfo set;

  const AlbumSetScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.set});

  @override
  State<AlbumSetScreen> createState() => _AlbumSetScreenState();
}

class _AlbumSetScreenState extends State<AlbumSetScreen> {
  List<AlbumCard>? _cards;
  String? _error;

  // matriz de desaturación (escala de grises) para las cartas que faltan
  static const _greyMatrix = <double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ];

  @override
  void initState() {
    super.initState();
    widget.db.setCards(widget.set.code).then((cards) {
      if (mounted) setState(() => _cards = cards);
    }).catchError((e) {
      if (mounted) setState(() => _error = '$e');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = _cards;
    return Scaffold(
      appBar: AppBar(
          title: Text('${widget.set.name} · ${widget.set.code.toUpperCase()}')),
      body: cards == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Text('No pude cargar el set: $_error'),
            )
          : ListenableBuilder(
              listenable: widget.collection,
              builder: (context, _) {
                final byPrinting = widget.collection.hasPrintingData;
                final printingQty = widget.collection.printingQty;
                final qtyByOracle = widget.collection.qtyByOracle;
                int qtyOf(AlbumCard c) {
                  if (byPrinting) {
                    return printingQty[
                            '${widget.set.code.toLowerCase()}|${c.collectorNumber}'] ??
                        0;
                  }
                  // modo aproximado: nunca marcar tierras básicas (tener
                  // "un Island" no significa tener ESTA ilustración)
                  if (c.isBasicLand) return 0;
                  return qtyByOracle[c.oracleId] ?? 0;
                }
                var ownedHere = 0;
                for (final c in cards) {
                  if (qtyOf(c) > 0) ownedHere++;
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: cards.isEmpty
                                    ? 0
                                    : ownedHere / cards.length,
                                minHeight: 6,
                                color: ownedHere >= cards.length
                                    ? MFColors.success
                                    : MFColors.manaRed,
                                backgroundColor:
                                    MFColors.manaRed.withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('$ownedHere/${cards.length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          childAspectRatio: 63 / 88,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: cards.length,
                        itemBuilder: (context, i) {
                          final card = cards[i];
                          final qty = qtyOf(card);
                          return _AlbumCell(
                              card: card,
                              qty: qty,
                              greyMatrix: _greyMatrix);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _AlbumCell extends StatelessWidget {
  final AlbumCard card;
  final int qty;
  final List<double> greyMatrix;

  const _AlbumCell(
      {required this.card, required this.qty, required this.greyMatrix});

  @override
  Widget build(BuildContext context) {
    final owned = qty > 0;
    final identity = card.colors.isEmpty
        ? Colors.blueGrey
        : (manaColorsAlbum[card.colors[0]] ?? Colors.blueGrey);
    Widget image = card.imageSmall == null
        ? Container(
            decoration: BoxDecoration(
              color: identity.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4),
            child: Text(card.printedName ?? card.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9)),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              card.imageSmall!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(
                      decoration: BoxDecoration(
                        color: identity.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
              errorBuilder: (context, error, stack) => Container(
                decoration: BoxDecoration(
                  color: identity.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: Text(card.printedName ?? card.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9)),
              ),
            ),
          );
    if (!owned) {
      // carta que falta: gris y semitransparente, como en TCG Pocket
      image = Opacity(
        opacity: 0.35,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(greyMatrix),
          child: image,
        ),
      );
    }
    return Tooltip(
      message:
          '${card.printedName ?? card.name} · #${card.collectorNumber}'
          '${owned ? ' · tienes $qty' : ' · te falta'}',
      waitDuration: const Duration(milliseconds: 500),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          if (owned)
            Positioned(
              right: 3,
              top: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MFColors.success, width: 1),
                ),
                child: Text('x$qty',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: MFColors.success)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Colores de identidad (copia local para no acoplar el álbum a widgets/).
const Map<String, Color> manaColorsAlbum = {
  'W': MFColors.manaWhite,
  'U': MFColors.manaBlue,
  'B': MFColors.manaBlack,
  'R': MFColors.manaRed,
  'G': MFColors.manaGreen,
};
