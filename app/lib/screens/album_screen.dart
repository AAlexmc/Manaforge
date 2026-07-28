import 'package:flutter/material.dart';

import '../l10n/t.dart';

import '../services/card_database.dart';
import '../services/collection_sets.dart';
import '../services/collection_store.dart';
import '../services/market_prefs.dart';
import '../services/price_series_database.dart';
import '../services/markets.dart';
import '../theme/mf_theme.dart';
import '../widgets/app_shortcuts.dart';
import '../widgets/common.dart';
import 'album_filters.dart';
import 'card_detail_screen.dart';

/// Álbum por expansiones, estilo TCG Pocket: cada set es una página con
/// TODAS sus cartas en rejilla; las que no tienes se ven apagadas y las
/// tuyas a color con su cantidad. Coleccionar también es un juego.
class AlbumScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;

  /// Opcionales: si vienen, las fichas de carta que se abran desde aquí dejan
  /// elegir mercado (Cardmarket, TCGplayer…) como el Mercado.
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  /// Ctrl+F: si el aviso es para esta pestaña, se enfoca el buscador.
  final SearchFocusBus? search;

  /// Índice de esta pantalla en la barra, para saber si el aviso es suyo.
  final int tabIndex;

  /// Key para que un tour pueda señalar el filtro "Con cartas mías".
  final Key? miasKey;

  const AlbumScreen(
      {super.key,
      required this.db,
      required this.collection,
      this.market,
      this.prices,
      this.search,
      this.tabIndex = -1,
      this.miasKey});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<SetInfo>? _sets;
  Map<String, int> _owned = const {};
  bool _onlyMine = true;
  String _query = '';
  String _sort = 'progreso'; // progreso · fecha · antiguas · nombre
  String? _letter; // inicial A-Z o '#'; null = todas
  String? _year; // año de lanzamiento; null = todos
  String? _error;

  static const _letters = [
    '#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  void initState() {
    super.initState();
    _load();
    // el álbum vive como pestaña: debe reaccionar cuando la colección
    // cambia (importaciones, añadir/quitar cartas), no solo al crearse
    widget.collection.addListener(_onCollectionChanged);
    widget.search?.addListener(_onSearchShortcut);
  }

  @override
  void dispose() {
    widget.collection.removeListener(_onCollectionChanged);
    widget.search?.removeListener(_onSearchShortcut);
    _searchFocus.dispose();
    super.dispose();
  }

  final FocusNode _searchFocus = FocusNode();

  void _onSearchShortcut() {
    if (widget.search?.target != widget.tabIndex) return;
    _searchFocus.requestFocus();
  }

  void _onCollectionChanged() {
    if (_sets == null) {
      // aún sin sets (p. ej. la DB no estaba): reintentar todo
      _error = null;
      _load();
    } else {
      _computeOwned();
    }
  }

  Future<void> _load() async {
    try {
      final sets = await widget.db.sets();
      if (!mounted) return;
      setState(() => _sets = sets);
      await _computeOwned();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _computeOwned() async {
    try {
      // misma cuenta que usan los logros: una sola fuente de verdad
      final owned = await ownedCardsBySet(widget.db, widget.collection);
      if (!mounted) return;
      setState(() {
        _owned = owned;
        // si la colección está vacía, no tiene sentido filtrar por "míos"
        if (owned.isEmpty) _onlyMine = false;
      });
    } catch (_) {
      // DB no disponible: se reintentará con el siguiente cambio
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    final sets = _sets;
    final visible = sets == null
        ? const <SetInfo>[]
        : filterAlbumSets(sets,
            query: _query,
            letter: _letter,
            year: _year,
            onlyMine: _onlyMine,
            owned: _owned,
            sort: _sort);
    return Scaffold(
      appBar: AppBar(title: Text(t.tabAlbum)),
      body: sets == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(t.albNeedDb, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _error = null);
                              _load();
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: Text(t.albRetry),
                          ),
                        ],
                      ),
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
                    child: Text(
                      t.albApproxMode,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _searchFocus,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: t.albSearchSet,
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      KeyedSubtree(
                        key: widget.miasKey,
                        child: FilterChip(
                          selected: _onlyMine,
                          label: Text(t.albOnlyMine),
                          onSelected: (v) => setState(() => _onlyMine = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sort,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12.5),
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            DropdownMenuItem(
                                value: 'progreso',
                                child: Text(t.albSortProgress)),
                            DropdownMenuItem(
                                value: 'fecha', child: Text(t.albSortNewest)),
                            DropdownMenuItem(
                                value: 'antiguas',
                                child: Text(t.albSortOldest)),
                            DropdownMenuItem(
                                value: 'nombre', child: Text(t.albSortName)),
                          ],
                          onChanged: (v) => setState(
                              () => _sort = v ?? 'progreso'),
                        ),
                      ),
                    ],
                  ),
                ),
                // segunda fila: filtro por año de salida y por letra inicial
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                  child: Row(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _year,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12.5),
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            DropdownMenuItem<String?>(
                                value: null, child: Text(t.albYearAll)),
                            for (final y in availableYears(sets))
                              DropdownMenuItem<String?>(
                                  value: y, child: Text(y)),
                          ],
                          onChanged: (v) => setState(() => _year = v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  label: Text(t.albLetterAll),
                                  selected: _letter == null,
                                  visualDensity: VisualDensity.compact,
                                  onSelected: (_) =>
                                      setState(() => _letter = null),
                                ),
                              ),
                              for (final l in _letters)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ChoiceChip(
                                    label: Text(l),
                                    selected: _letter == l,
                                    visualDensity: VisualDensity.compact,
                                    onSelected: (_) => setState(() =>
                                        _letter = _letter == l ? null : l),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? Center(child: Text(t.albNoSets))
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
                                        t.albSetProgress(owned, s.total) +
                                            (s.year.isEmpty
                                                ? ''
                                                : ' · ${s.year}') +
                                            (complete ? t.albComplete : ''),
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
                                      market: widget.market,
                                      prices: widget.prices,
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
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  const AlbumSetScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.set,
      this.market,
      this.prices});

  @override
  State<AlbumSetScreen> createState() => _AlbumSetScreenState();
}

class _AlbumSetScreenState extends State<AlbumSetScreen> {
  List<AlbumCard>? _cards;
  String? _error;

  /// Búsqueda por nombre dentro del set. Un álbum de 300 cartas no se recorre
  /// a ojo para ver si tienes UNA concreta.
  final _searchCtrl = TextEditingController();
  String _query = '';

  /// Enseñar solo las que faltan: el uso real del álbum es "qué me queda".
  bool _soloFaltan = false;

  /// Contar solo la tirada base (contrato: "completo" son los números base).
  /// El conmutador saca las variantes y promos, que en un set moderno son
  /// decenas y nadie mete en la cuenta.
  bool _soloBase = true;

  // matriz de desaturación (escala de grises) para las cartas que faltan
  static const _greyMatrix = <double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    widget.market?.removeListener(_recargar);
    super.dispose();
  }

  /// Cambiar de mercado cambia los precios del álbum: se vuelven a pedir.
  Future<void> _recargar() async {
    final cards = await widget.db.setCards(widget.set.code,
        market: widget.market?.market ?? Market.cardmarket);
    if (mounted) setState(() => _cards = cards);
  }

  @override
  void initState() {
    super.initState();
    widget.db
        .setCards(widget.set.code,
            market: widget.market?.market ?? Market.cardmarket)
        .then((cards) {
      if (mounted) setState(() => _cards = cards);
    }).catchError((e) {
      if (mounted) setState(() => _error = '$e');
    });
    widget.market?.addListener(_recargar);
  }

  String _precioTotal(MissingReport r) => formatMoney(
      r.total, widget.market?.market ?? Market.cardmarket);

  /// Abre la ficha completa sabiendo qué cartas hay al lado: desde ahí se
  /// pasa a la siguiente sin volver al álbum.
  void _abrirFicha(List<AlbumCard> visibles, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
        db: widget.db,
        collection: widget.collection,
        oracleId: visibles[index].oracleId,
        market: widget.market,
        prices: widget.prices,
        siblings: [for (final c in visibles) c.oracleId],
        siblingIndex: index,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    final cards = _cards;
    return Scaffold(
      appBar: AppBar(
          title: Text('${widget.set.name} · ${widget.set.code.toUpperCase()}')),
      body: cards == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Text(t.albLoadError('$_error')),
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
                final baseSize = baseSetSize(cards);
                var ownedHere = 0;
                var deLasQueCuentan = 0;
                for (final c in cards) {
                  if (_soloBase && !isBaseNumber(c, baseSize)) {
                    continue;
                  }
                  deLasQueCuentan++;
                  if (qtyOf(c) > 0) ownedHere++;
                }
                final delSet = _soloBase
                    ? [for (final c in cards) if (isBaseNumber(c, baseSize)) c]
                    : cards;
                final visibles = filterAlbumCards(delSet,
                    query: _query, onlyMissing: _soloFaltan, qtyOf: qtyOf);
                final faltan = missingReport(cards,
                    qtyOf: qtyOf,
                    onlyBase: _soloBase,
                    countBasicLands: byPrinting);
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
                                value: deLasQueCuentan == 0
                                    ? 0
                                    : ownedHere / deLasQueCuentan,
                                minHeight: 6,
                                color: ownedHere >= deLasQueCuentan
                                    ? MFColors.success
                                    : MFColors.manaRed,
                                backgroundColor:
                                    MFColors.manaRed.withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('$ownedHere/$deLasQueCuentan',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: const Icon(Icons.search, size: 20),
                                hintText: t.albSearchIn(widget.set.name),
                                border: const OutlineInputBorder(),
                                suffixIcon: _query.isEmpty
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          _searchCtrl.clear();
                                          setState(() => _query = '');
                                        },
                                      ),
                              ),
                              onChanged: (v) => setState(() => _query = v),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilterChip(
                            avatar: const Icon(Icons.bookmark_border, size: 16),
                            label: Text(t.albOnlyMissing),
                            selected: _soloFaltan,
                            onSelected: (v) => setState(() => _soloFaltan = v),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            avatar: const Icon(Icons.auto_awesome_motion,
                                size: 16),
                            label: Text(t.albWithVariants),
                            selected: !_soloBase,
                            onSelected: (v) => setState(() => _soloBase = !v),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                faltan.missing == 0
                                    ? t.albYouHaveItAll
                                    : t.albMissingCount(faltan.missing) +
                                        _precioTotal(faltan) +
                                        (faltan.withoutPrice > 0
                                            ? t.albWithoutPrice(
                                                faltan.withoutPrice)
                                            : ''),
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: faltan.missing == 0
                                        ? MFColors.success
                                        : null)),
                          ),
                          if (visibles.length != delSet.length)
                            Text(
                                t.albVisibleOf(
                                    visibles.length, delSet.length),
                                style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    if (visibles.isEmpty)
                      Expanded(
                        child: Center(child: Text(t.albNoCardsNamed)),
                      )
                    else
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
                        itemCount: visibles.length,
                        itemBuilder: (context, i) {
                          final card = visibles[i];
                          final qty = qtyOf(card);
                          return _AlbumCell(
                              card: card,
                              qty: qty,
                              greyMatrix: _greyMatrix,
                              // el precio solo se pinta en los HUECOS: en las
                              // que ya tienes no dice nada útil y ensucia
                              priceLabel: qty > 0 || card.price == null
                                  ? null
                                  : formatMoney(card.price!,
                                      widget.market?.market ??
                                          Market.cardmarket),
                              // el visor recibe TODAS las visibles: se pasa a
                              // la de al lado sin cerrar y volver a abrir
                              onZoom: () => showCardZoomList(context,
                                  index: i,
                                  cards: [
                                    for (final c in visibles)
                                      ZoomCard(
                                          name: c.printedName ?? c.name,
                                          imageUrl:
                                              c.imageNormal ?? c.imageSmall,
                                          colors: c.colors,
                                          onDetails: () => _abrirFicha(
                                              visibles, visibles.indexOf(c)))
                                  ]));
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

/// Cuántas cartas tiene la TIRADA BASE del set: la serie seguida desde el 1.
///
/// Los sets modernos numeran las base 1..N y luego cuelgan detrás las
/// variantes (borderless, extendidas, promos de tienda) con números sueltos
/// muy por encima. Nadie cuenta esas para decir "tengo el set completo", así
/// que el 100 % del álbum se mide sobre la base y las variantes se ven con un
/// conmutador. Se calcula del propio set, sin tablas que mantener.
int baseSetSize(List<AlbumCard> cards) {
  final numeros = <int>{};
  for (final c in cards) {
    final n = int.tryParse(c.collectorNumber);
    if (n != null && c.collectorNumber == n.toString()) numeros.add(n);
  }
  var size = 0;
  while (numeros.contains(size + 1)) {
    size++;
  }
  return size;
}

/// ¿Esta carta es de la tirada base? Los números con letra o estrella
/// (`2★`, `12p`) no lo son nunca.
bool isBaseNumber(AlbumCard card, int baseSize) {
  final n = int.tryParse(card.collectorNumber);
  if (n == null || card.collectorNumber != n.toString()) return false;
  return n >= 1 && n <= baseSize;
}

/// Lo que falta para completar el álbum, y lo que costaría.
class MissingReport {
  /// Cartas que faltan (huecos).
  final int missing;

  /// Lo que costaría comprarlas, con el precio de las que se sabe.
  final double total;

  /// Cuántas de las que faltan no tienen precio conocido: el total es un
  /// mínimo, no una cifra cerrada, y hay que decirlo.
  final int withoutPrice;

  const MissingReport(
      {required this.missing,
      required this.total,
      required this.withoutPrice});
}

/// [countBasicLands] a false cuando la colección NO sabe de ediciones: ahí
/// "tener un Island" no dice qué ilustración tienes, el álbum nunca las marca
/// y contarlas como hueco sería inventarse una deuda de 20 tierras por set.
MissingReport missingReport(List<AlbumCard> cards,
    {required int Function(AlbumCard) qtyOf,
    bool onlyBase = true,
    bool countBasicLands = true}) {
  final baseSize = baseSetSize(cards);
  var missing = 0;
  var total = 0.0;
  var withoutPrice = 0;
  for (final c in cards) {
    if (onlyBase && !isBaseNumber(c, baseSize)) continue;
    if (!countBasicLands && c.isBasicLand) continue;
    if (qtyOf(c) > 0) continue;
    missing++;
    final price = c.price;
    if (price == null || price <= 0) {
      withoutPrice++;
    } else {
      total += price;
    }
  }
  return MissingReport(
      missing: missing, total: total, withoutPrice: withoutPrice);
}

/// Las cartas del álbum que hay que enseñar: por nombre (el impreso también,
/// que es el que se ve en la carta si la tienes en otro idioma) o por número
/// de coleccionista exacto, y opcionalmente solo las que faltan.
///
/// Función pura para poder testearla: la pantalla necesita la base de cartas
/// descargada y en CI no la hay.
List<AlbumCard> filterAlbumCards(List<AlbumCard> cards,
    {String query = '',
    bool onlyMissing = false,
    required int Function(AlbumCard) qtyOf}) {
  final q = query.trim().toLowerCase();
  return [
    for (final c in cards)
      if ((q.isEmpty ||
              c.name.toLowerCase().contains(q) ||
              (c.printedName ?? '').toLowerCase().contains(q) ||
              c.collectorNumber.toLowerCase() == q) &&
          (!onlyMissing || qtyOf(c) == 0))
        c
  ];
}

class _AlbumCell extends StatelessWidget {
  final AlbumCard card;
  final int qty;
  final List<double> greyMatrix;

  /// Abrir el visor a pantalla completa POR ESTA carta.
  final VoidCallback onZoom;

  /// Precio de la carta, solo cuando es un hueco (si la tienes, sobra).
  final String? priceLabel;

  const _AlbumCell(
      {required this.card,
      required this.qty,
      required this.greyMatrix,
      required this.onZoom,
      this.priceLabel});

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
      child: GestureDetector(
        onTap: onZoom,
        child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          if (!owned && priceLabel != null)
            Positioned(
              left: 3,
              bottom: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(priceLabel!,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70)),
              ),
            ),
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
