import 'package:flutter/material.dart';

import 'package:manaforge_app/services/forge_texts.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';
import 'package:flutter/services.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/card_names.dart';
import 'package:manaforge_app/services/deck_shortfall.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';
import 'package:manaforge_app/ui/collection/card_detail_screen.dart';

/// Detalle de un mazo generado: plan de juego, curva (editable: arrastra las
/// barras y reforja el mazo a tu curva), "¿por qué funciona?", lista agrupada
/// y exportación como texto (Moxfield/Arena/Discord).
class DeckDetailScreen extends StatefulWidget {
  final fe.GeneratedDeck gen;
  final Map<String, fe.Card> pool;

  /// Con [db], el detalle muestra el banner horizontal con las imágenes de
  /// las cartas; con [decks], aparece el botón de guardar el mazo.
  /// [ownedPrintings] (claves "set|nº") hace que el banner enseñe la
  /// ilustración de TU edición, no una cualquiera.
  final CardDatabase? db;
  final DeckStore? decks;
  final Set<String>? ownedPrintings;

  /// Cuántas copias tienes DE VERDAD de cada carta (por nombre). Va aparte
  /// del pool porque al abrir un mazo guardado el pool se rellena con las
  /// cartas que ya no tienes —para poder pintarlas— con la cantidad que pide
  /// el mazo: mirar ahí diría que las tienes todas siempre.
  final Map<String, int>? ownedByName;

  const DeckDetailScreen(
      {super.key,
      required this.gen,
      required this.pool,
      this.db,
      this.decks,
      this.ownedPrintings,
      this.ownedByName});

  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  late fe.GeneratedDeck _gen;
  bool _editingCurve = false;
  Map<int, int> _edited = {};
  Future<Map<String, (String?, String?)>>? _imagesF;
  Map<String, double> _prices = const {};
  Map<String, String> _namesEs = const {};

  @override
  void initState() {
    super.initState();
    _gen = widget.gen;
    _loadImages();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    final db = widget.db;
    if (db == null) return;
    try {
      final names = [..._gen.deck.cards.keys, ..._gen.deck.lands.keys];
      final prices = await db.pricesForNames(names);
      final namesEs = await db.namesEsFor(names);
      if (mounted) {
        setState(() {
          _prices = prices;
          _namesEs = namesEs;
        });
      }
    } catch (_) {/* sin DB: sin precios */}
  }

  /// Nombre que se ENSEÑA en la lista (español si la UI está en es y la DB
  /// lo trae). La exportación/copia sigue en inglés: no pasa por aquí.
  String _display(String name) =>
      cardDisplayName(context, name, nameEs: _namesEs[name]);

  /// Copias del mazo que ya NO tienes. El mazo guarda su lista aunque vendas
  /// una carta: aquí se dice la verdad en vez de prometer "tienes todas".
  /// La cantidad la manda el pool, que se construye con tu colección.
  int get _faltan => missingCopies(_gen.deck, _tengoPorNombre);

  /// Las copias con las que se cuenta. Si quien abrió el mazo no las pasa
  /// (mazo guardado que se abre desde Mazos), se cae al pool, que en ese
  /// caso está construido con la colección.
  Map<String, int> get _tengoPorNombre =>
      widget.ownedByName ??
      {for (final e in _pool.entries) e.key: e.value.qty};

  double get _deckValue {
    var total = 0.0;
    _gen.deck.cards
        .forEach((n, q) => total += (_prices[n] ?? 0) * q);
    _gen.deck.lands
        .forEach((n, q) => total += (_prices[n] ?? 0) * q);
    return total;
  }

  void _openCardDetail(String name) {
    final db = widget.db;
    if (db == null) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(db: db, byName: name),
    ));
  }

  void _loadImages() {
    final db = widget.db;
    if (db == null) return;
    _imagesF = db.imagesForNames(
        [..._gen.deck.cards.keys, ..._gen.deck.lands.keys],
        ownedPrintings: widget.ownedPrintings);
  }

  void _saveDeck() {
    widget.decks!.add(SavedDeck.fromGenerated(_gen));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context).ddSaved)));
  }

  Map<String, fe.Card> get _pool => widget.pool;

  String _exportText(AppLocalizations t) {
    final deck = _gen.deck;
    // el total se cuenta: un Commander son 100 cartas, no 60, y la cabecera
    // decía 60 siempre
    final total = deck.cards.values.fold<int>(0, (a, b) => a + b) +
        deck.lands.values.fold<int>(0, (a, b) => a + b);
    final buffer = StringBuffer('${deck.name} · ${t.ddCardCount(total)}\n');
    final sorted = deck.cards.entries.toList()
      ..sort((a, b) => (_pool[a.key]!.cmc).compareTo(_pool[b.key]!.cmc));
    for (final e in sorted) {
      buffer.writeln('${e.value} ${e.key}');
    }
    deck.lands.forEach((name, qty) => buffer.writeln('$qty $name'));
    buffer.writeln('\n${t.ddForgedWith}');
    return buffer.toString();
  }

    String _typeLabel(AppLocalizations t, String key) => switch (key) {
        'creatures' => t.ddTypeCreatures,
        'instants' => t.ddInstants,
        'sorceries' => t.ddTypeSorceries,
        'enchantments' => t.ddTypeEnchantments,
        'artifacts' => t.ddTypeArtifacts,
        _ => t.ddTypeOther,
      };

  Map<String, List<MapEntry<String, int>>> _grouped() {
    final groups = <String, List<MapEntry<String, int>>>{};
    for (final e in _gen.deck.cards.entries) {
      final types = _pool[e.key]!.types;
            final key = types.contains('Creature')
          ? 'creatures'
          : types.contains('Instant')
              ? 'instants'
              : types.contains('Sorcery')
                  ? 'sorceries'
                  : types.contains('Enchantment')
                      ? 'enchantments'
                      : types.contains('Artifact')
                          ? 'artifacts'
                          : 'other';
      groups.putIfAbsent(key, () => []).add(e);
    }
    for (final list in groups.values) {
      list.sort((a, b) => (_pool[a.key]!.cmc).compareTo(_pool[b.key]!.cmc));
    }
    return groups;
  }

  void _startEditing(Map<int, int> hist) {
    setState(() {
      _editingCurve = true;
      _edited = {for (var cmc = 0; cmc <= 6; cmc++) cmc: hist[cmc] ?? 0};
    });
  }

  void _reforge() {
    final result = fe.reforgeWithCurve(_pool, _gen.deck.colors, _edited,
        name: _gen.deck.name);
    if (result.deck != null) {
      setState(() {
        _gen = result.deck!;
        _editingCurve = false;
        _loadImages(); // el banner refleja las cartas nuevas
      });
      _loadPrices();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(context).ddReforged)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(reforgeRefusalText(tr(context), result))));
    }
  }

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    final deck = _gen.deck;
    final hist = fe.ManaCurve.curveHistogram(deck.cards, _pool, cap: 6);
    final accent = manaColors[deck.colors.isEmpty ? 'C' : deck.colors[0]] ??
        MFColors.forge;
    final nSpells = deck.cards.values.fold(0, (a, b) => a + b);
    final nLands = deck.lands.values.fold(0, (a, b) => a + b);
    final avg = fe.ManaCurve.averageCmc(deck.cards, _pool);
    final editedSpells = _edited.values.fold(0, (a, b) => a + b);
    final editedLands = fe.ManaCurve.deckSize - editedSpells;
    final editedLandsOk = editedLands >= 20 && editedLands <= 27;

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
        actions: [
          if (widget.decks != null)
            IconButton(
              tooltip: t.ddSaveToMyDecks,
              icon: const Icon(Icons.bookmark_add_outlined),
              onPressed: _saveDeck,
            ),
          IconButton(
            tooltip: t.ddCopyList,
            icon: const Icon(Icons.copy_all),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _exportText(t)));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr(context).ddListCopied)));
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              ColorIdentityDots(colors: deck.colors, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(t.ddHeaderSub(themeName(t, _gen.theme),
                    archetypeName(t, deck.archetype), nSpells, nLands)),
              ),
              if (_prices.isNotEmpty)
                Text('~${_deckValue.toStringAsFixed(2)} €',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MFColors.warning)),
            ],
          ),
          const SizedBox(height: 6),
          if (_faltan == 0)
            Text(t.ddHaveAll,
                style: const TextStyle(color: MFColors.success))
          else
            Text(
                t.ddMissing(_faltan),
                style: const TextStyle(color: MFColors.warning)),
          if (_imagesF != null) ...[
            const SizedBox(height: 14),
            _DeckImageStrip(
                gen: _gen,
                imagesF: _imagesF!,
                namesEs: _namesEs,
                onDetails: widget.db == null ? null : _openCardDetail),
          ],
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.ddGamePlan,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final (turns, text) in gamePlan(t, _gen))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 52,
                              child: Text(turns,
                                  style: TextStyle(
                                      color: accent,
                                      fontWeight: FontWeight.bold))),
                          Expanded(child: Text(text)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(t.ddManaCurve,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      if (!_editingCurve &&
                          _gen.deck.totalCards == 60)
                        TextButton.icon(
                          onPressed: () => _startEditing(hist),
                          icon: const Icon(Icons.tune, size: 18),
                          label: Text(t.ddEditCurve),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_editingCurve) ...[
                    CurveEditor(
                      values: _edited,
                      color: MFColors.forge,
                      onChanged: (v) => setState(() => _edited = v),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t.ddDragBars(editedSpells, editedLands) +
                          (editedLandsOk ? '' : t.ddOutOfRange),
                      style: TextStyle(
                          fontSize: 12,
                          color: editedLandsOk
                              ? MFColors.success
                              : MFColors.warning),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                              backgroundColor: MFColors.forge),
                          onPressed: _reforge,
                          icon: const Icon(Icons.auto_awesome, size: 18),
                          label: Text(t.ddReforgeCurve),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () =>
                              setState(() => _editingCurve = false),
                          child: Text(t.acCancel),
                        ),
                      ],
                    ),
                  ] else
                    CurveChart(histogram: hist, color: accent),
                  const SizedBox(height: 8),
                  Text(t.ddCurveSummary(nLands, nSpells, avg.toStringAsFixed(1))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ExpansionTile(
              title: Text(t.ddWhyWorks,
                  style: const TextStyle(color: MFColors.forge)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [Text(whyItWorks(t, _gen, _pool))],
            ),
          ),
          const SizedBox(height: 12),
          for (final group in _grouped().entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Text(
                  '${_typeLabel(t, group.key)} '
                          '(${group.value.fold(0, (a, e) => a + e.value)})'
                      .toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            for (final e in group.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                        width: 24,
                        child: Text('${e.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold))),
                    Expanded(child: Text(_display(e.key))),
                    if (_prices[e.key] != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                            '${_prices[e.key]!.toStringAsFixed(2)} €',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white54)),
                      ),
                    Text(_pool[e.key]!.manaCost,
                        style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(t.ddLands(nLands),
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          for (final e in _gen.deck.lands.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                      width: 24,
                      child: Text('${e.value}',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text(_display(e.key))),
                ],
              ),
            ),
          // el total, al final de la lista: es donde acabas de leer los
          // precios carta a carta y donde se busca la cifra de "cuánto vale
          // esto". Arriba también está, pero con el mazo entero desplegado
          // queda a tres pantallas de scroll
          if (_prices.isNotEmpty) ...[
            const Divider(height: 28),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(t.ddDeckTotal(_deckValue.toStringAsFixed(2)),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MFColors.warning)),
                  const SizedBox(height: 2),
                  Text(
                      _sinPrecio == 0
                          ? t.ddCheapestPrice
                          : t.ddSomeNoPrice(_sinPrecio),
                      style: const TextStyle(
                          fontSize: 11, color: Colors.white54)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Cartas distintas del mazo sin precio en la base: el total es un mínimo,
  /// no una cifra cerrada, y hay que decirlo.
  int get _sinPrecio {
    var n = 0;
    for (final name in [..._gen.deck.cards.keys, ..._gen.deck.lands.keys]) {
      if (_prices[name] == null) n++;
    }
    return n;
  }
}


/// Banner horizontal con las imágenes de todas las cartas del mazo
/// (hechizos por coste y luego tierras): reconocerlas de un vistazo.
class _DeckImageStrip extends StatelessWidget {
  final fe.GeneratedDeck gen;
  final Future<Map<String, (String?, String?)>> imagesF;
  final void Function(String name)? onDetails;

  /// Español para los pies de las cartas sin imagen (mismo criterio que la
  /// lista): vacío = inglés.
  final Map<String, String> namesEs;

  const _DeckImageStrip(
      {required this.gen,
      required this.imagesF,
      this.onDetails,
      this.namesEs = const {}});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, (String?, String?)>>(
      future: imagesF,
      builder: (context, snap) {
        final images = snap.data ?? const {};
        final entries = [
          ...gen.deck.cards.entries,
          ...gen.deck.lands.entries,
        ];
        return SizedBox(
          height: 176,
          child: ScrollConfiguration(
            behavior: const DragScrollBehavior(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final e = entries[i];
              final urls = images[e.key];
              final url = urls?.$1 ?? urls?.$2; // normal, si no small
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => showCardZoom(context,
                      // el zoom es pura presentación: nombre traducido como
                      // el pie; onDetails sigue con la clave inglesa
                      name: cardDisplayName(context, e.key,
                          nameEs: namesEs[e.key]),
                      imageUrl: url,
                      onDetails: onDetails == null
                          ? null
                          : () => onDetails!(e.key)),
                  child: Stack(
                    children: [
                    SizedBox(
                      width: 120,
                      height: 168,
                      child: url == null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                  cardDisplayName(context, e.key,
                                      nameEs: namesEs[e.key]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 10)),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) =>
                                    progress == null
                                        ? child
                                        : Container(color: Colors.white10),
                                errorBuilder: (context, error, stack) =>
                                    Container(
                                  color: Colors.white10,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(6),
                                  child: Text(
                                      cardDisplayName(context, e.key,
                                          nameEs: namesEs[e.key]),
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(fontSize: 10)),
                                ),
                              ),
                            ),
                    ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.78),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text('x${e.value}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              },
            ),
          ),
        );
      },
    );
  }
}
