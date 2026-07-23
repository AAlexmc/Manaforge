import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../l10n/t.dart';
import '../services/achievements_controller.dart';
import '../services/app_update.dart';
import '../services/certificate_store.dart';
import '../services/collection_value.dart';
import '../services/deck_store.dart';
import '../services/home_layout_prefs.dart';
import '../services/meta_decks.dart';
import '../services/recents_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import '../widgets/update_notice.dart';
import 'card_detail_screen.dart';
import 'deck_detail_screen.dart';
import 'editar_inicio_screen.dart';
import 'import_csv_screen.dart';
import 'logros_screen.dart';
import 'mercado_screen.dart';
import 'set_market_screen.dart';
import 'test_screen.dart';

/// Inicio: el vestíbulo de la forja. Valor de tu colección, accesos rápidos
/// y tiras deslizables — recientes, tus mazos, el meta, expansiones y joyas.
class HomeScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;
  final AchievementsController achievements;
  final CertificateStore certificates;

  /// Aviso de versión nueva. Opcional: sin él, Inicio no enseña nada.
  final AppUpdateChecker? updates;

  /// Qué secciones se ven y en qué orden. Opcional: si es null, un layout por
  /// defecto que enseña todo (así los tests montan Inicio sin tener que
  /// pasarlo, y el orden es el de siempre).
  final HomeLayoutPreference? layout;

  /// Abrir el escáner. Vive en la barra de abajo, y desde el estado vacío de
  /// Inicio hay que poder llegar sin saber eso.
  final VoidCallback? onScan;

  final void Function(int tabIndex) onGoToTab;

  /// Key del botón "Editar inicio", para que un tour pueda señalarlo.
  final Key? editarInicioKey;

  /// Abrir el menú de guías (el botón "?"). Si es null, no sale el botón.
  final VoidCallback? onHelp;

  const HomeScreen({
    super.key,
    required this.db,
    required this.collection,
    required this.decks,
    required this.achievements,
    required this.certificates,
    this.updates,
    this.layout,
    this.onScan,
    required this.onGoToTab,
    this.editarInicioKey,
    this.onHelp,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _value;
  List<ValuedCard> _jewels = const [];
  List<SetBanner> _sets = const [];
  List<MetaDeck> _meta = const [];
  String _metaSource = '';

  /// El layout efectivo: el que llega, o uno por defecto en memoria (enseña
  /// todo en el orden de siempre) para que Inicio funcione sin que se lo pasen.
  late final HomeLayoutPreference _layout =
      widget.layout ?? HomeLayoutPreference();

  @override
  void initState() {
    super.initState();
    recentsStore.load();
    widget.decks.load();
    _load();
    widget.collection.addListener(_load);
    MetaDeckService().load().then((result) {
      if (mounted) {
        setState(() {
          _meta = result.decks;
          _metaSource = result.source;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.collection.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      // misma fórmula que Mercado: que los dos totales SIEMPRE cuadren
      final valuation = await computeCollectionValue(
        cards: widget.collection.cards,
        byPrinting: widget.collection.hasPrintingData,
        printingQty: widget.collection.printingQty,
        oraclePrices: widget.db.pricesForOracles,
        printingPrices: widget.db.pricesForPrintings,
      );
      final sets = _sets.isEmpty
          ? await widget.db.marketSets(limit: 15)
          : _sets;
      if (!mounted) return;
      setState(() {
        _value = valuation.total;
        _jewels = valuation.valued.take(12).toList();
        _sets = sets;
      });
    } catch (_) {/* sin DB aún: héroe en modo bienvenida */}
  }

  void _openCard(String oracleId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CardDetailScreen(
          db: widget.db,
          collection: widget.collection,
          oracleId: oracleId),
    ));
  }

  Future<void> _openDeck(SavedDeck saved) async {
    try {
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle);
      // lo que tienes DE VERDAD, ANTES de rellenar el pool con las cartas que
      // ya no tienes: si no se pasa, el detalle mira el pool relleno y dice
      // "las tienes todas" — y el mismo mazo abierto desde Mazos decía "te
      // faltan N". El mazo no puede contar dos historias
      final propias = {for (final e in pool.entries) e.key: e.value.qty};
      final extra =
          await widget.db.poolByNames({...saved.cards, ...saved.lands});
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
    } catch (_) {
      widget.onGoToTab(4); // sin DB: a la pestaña Mazos con su mensaje
    }
  }

  void _openLogros() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LogrosScreen(
            achievements: widget.achievements,
            db: widget.db,
            collection: widget.collection,
            certificates: widget.certificates,
          ),
        ),
      );

  /// Tu nivel de un vistazo: cuánto llevas y cuánto falta para el siguiente.
  Widget _levelCard(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.achievements,
      builder: (context, _) {
        final a = widget.achievements;
        final level = a.level;
        final ratio =
            level.xpForNext == 0 ? 0.0 : level.xpInLevel / level.xpForNext;
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _openLogros,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MFColors.forge.withValues(alpha: 0.16),
                      border: Border.all(color: MFColors.forge, width: 2),
                    ),
                    child: Text('${level.level}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(level.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(
                            '${a.unlockedCount}/${a.totalCount} logros · '
                            '${level.xpForNext - level.xpInLevel} XP para el '
                            'nivel ${level.level + 1}',
                            style: const TextStyle(fontSize: 11.5)),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                              value: ratio.clamp(0.0, 1.0), minHeight: 6),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(letterSpacing: 1)),
      );

  Widget _strip({required double height, required Widget child}) =>
      SizedBox(
        height: height,
        child: ScrollConfiguration(
            behavior: const DragScrollBehavior(), child: child),
      );

  /// Las secciones de Inicio, cada una construida por su id. Devuelve una
  /// lista (posiblemente vacía): una sección sin datos no pinta nada, esté
  /// encendida o no. El orden y qué se ve lo decide `_layout`.
  List<Widget> _bloque(BuildContext context, String id,
      List<RecentCard> recents, List<SavedDeck> decks, bool hasCollection) {
    switch (id) {
      case 'nivel':
        return [const SizedBox(height: 12), _levelCard(context)];
      case 'accesos':
        return [const SizedBox(height: 12), _accesos(context)];
      case 'resumen':
        return _resumen(context, hasCollection);
      case 'recientes':
        return _recientes(recents);
      case 'mazos':
        return _mazos(decks);
      case 'meta':
        return _metaBloque();
      case 'expansiones':
        return _expansiones();
      case 'joyas':
        return _joyas();
      default:
        return const [];
    }
  }

  /// Accesos rápidos: forjar, test, álbum, logros.
  Widget _accesos(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: MFColors.forge),
            onPressed: () => widget.onGoToTab(3),
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Forjar mazos'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TestScreen(
                    db: widget.db,
                    collection: widget.collection,
                    decks: widget.decks),
              ),
            ),
            icon: const Icon(Icons.sports_kabaddi, size: 18),
            label: const Text('Modo Test'),
          ),
          OutlinedButton.icon(
            onPressed: () => widget.onGoToTab(2),
            icon: const Icon(Icons.auto_stories, size: 18),
            label: const Text('Álbum'),
          ),
          OutlinedButton.icon(
            onPressed: _openLogros,
            icon: const Icon(Icons.emoji_events_outlined, size: 18),
            label: const Text('Logros'),
          ),
        ],
      );

  /// Mosaico "Resumen": la colección en números. Un tipo de mosaico distinto
  /// de las tiras. Solo con colección: sin cartas no cuenta nada.
  List<Widget> _resumen(BuildContext context, bool hasCollection) {
    if (!hasCollection) return const [];
    final a = widget.achievements;
    return [
      _sectionTitle('RESUMEN'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _statCell('${widget.collection.totalCopies}', 'cartas'),
          _statCell('${widget.collection.distinctCards}', 'distintas'),
          _statCell(
              _value == null ? '—' : '${_value!.toStringAsFixed(0)} €', 'valor'),
          _statCell('${widget.decks.decks.length}', 'mazos'),
          _statCell('${a.unlockedCount}/${a.totalCount}', 'logros'),
        ],
      ),
    ];
  }

  Widget _statCell(String valor, String etiqueta) => Container(
        width: 104,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valor,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(etiqueta, style: const TextStyle(fontSize: 11)),
          ],
        ),
      );

  List<Widget> _recientes(List<RecentCard> recents) {
    if (recents.isEmpty) return const [];
    return [
      _sectionTitle('VISTAS RECIENTEMENTE'),
      _strip(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recents.length,
          itemBuilder: (context, i) {
            final r = recents[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _openCard(r.oracleId),
                child: CardThumb(
                    url: r.imageNormal,
                    colors: r.colors,
                    name: r.name,
                    width: 96,
                    height: 134,
                    radius: 7),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _mazos(List<SavedDeck> decks) {
    if (decks.isEmpty) return const [];
    return [
      _sectionTitle('TUS MAZOS'),
      _strip(
        height: 92,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: decks.length,
          itemBuilder: (context, i) {
            final d = decks[i];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => _openDeck(d),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ColorIdentityDots(colors: d.colors, size: 11),
                          const Spacer(),
                          Text(d.archetype,
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      const Spacer(),
                      Text(d.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _metaBloque() {
    if (_meta.isEmpty) return const [];
    return [
      _sectionTitle('EL META AHORA · $_metaSource'),
      _strip(
        height: 96,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _meta.length,
          itemBuilder: (context, i) {
            final m = _meta[i];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TestScreen(
                        db: widget.db,
                        collection: widget.collection,
                        decks: widget.decks,
                        initialMetaId: m.id),
                  ),
                ),
                child: Container(
                  width: 190,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MFColors.forge.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: MFColors.forge.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ColorIdentityDots(colors: m.colors, size: 10),
                          const Spacer(),
                          Text(
                              '${m.format}'
                              '${m.share.isEmpty ? '' : ' · ${m.share}'}',
                              style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      const Spacer(),
                      Text(m.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text('⚔ ponte a prueba',
                          style: TextStyle(
                              fontSize: 10.5, color: MFColors.forge)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _expansiones() {
    if (_sets.isEmpty) return const [];
    return [
      _sectionTitle('EXPANSIONES NUEVAS'),
      _strip(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _sets.length,
          itemBuilder: (context, i) {
            final set = _sets[i];
            return SetBannerTile(
              set: set,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SetMarketScreen(
                      db: widget.db,
                      collection: widget.collection,
                      set: set),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _joyas() {
    if (_jewels.isEmpty) return const [];
    return [
      _sectionTitle('TUS JOYAS'),
      _strip(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _jewels.length,
          itemBuilder: (context, i) {
            final j = _jewels[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _openCard(j.oracleId),
                child: Column(
                  children: [
                    CardThumb(
                        url: j.imageSmall,
                        colors: j.colors,
                        name: j.name,
                        width: 90,
                        height: 126,
                        radius: 7),
                    const SizedBox(height: 3),
                    Text('${j.unitPrice.toStringAsFixed(2)} €',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  void _abrirEditor() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EditarInicioScreen(layout: _layout),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          // achievements va en la mezcla por el mosaico Resumen (los logros);
          // el nivel ya tiene su propio ListenableBuilder, pero Resumen no
          listenable: Listenable.merge(
              [widget.decks, recentsStore, _layout, widget.achievements]),
          builder: (context, _) {
            final recents = recentsStore.cards;
            final decks = widget.decks.decks;
            final hasCollection = widget.collection.totalCopies > 0;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: MFColors.manaRed),
                    const SizedBox(width: 8),
                    Text('ManaForge',
                        style:
                            Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    if (widget.onHelp != null)
                      IconButton(
                        tooltip: tr(context).tourMenuTitle,
                        icon: const Icon(Icons.help_outline),
                        onPressed: widget.onHelp,
                      ),
                    IconButton(
                      key: widget.editarInicioKey,
                      tooltip: 'Editar inicio',
                      icon: const Icon(Icons.tune),
                      onPressed: _abrirEditor,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (widget.updates != null) ...[
                  UpdateBanner(checker: widget.updates!),
                  const SizedBox(height: 4),
                ],
                // héroe: tu colección de un vistazo
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: hasCollection
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        tr(context)
                                            .yourCollection,
                                        style: const TextStyle(fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _value == null
                                          ? '${widget.collection.totalCopies} cartas'
                                          : '${_value!.toStringAsFixed(2)} €',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                              fontWeight:
                                                  FontWeight.bold),
                                    ),
                                    Text(
                                        '${widget.collection.totalCopies} cartas · '
                                        '${widget.collection.distinctCards} distintas',
                                        style: const TextStyle(
                                            fontSize: 11.5)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => widget.onGoToTab(5),
                                child: Text(
                                    tr(context).marketArrow),
                              ),
                            ],
                          )
                        // primer arranque: TRES caminos, no uno. El CSV de
                        // ManaBox lo tiene poca gente; escanear es la vía
                        // natural, y Forge se puede probar sin tener nada
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(tr(context)
                                  .welcomeTitle),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton.icon(
                                    onPressed: widget.onScan,
                                    icon: const Icon(
                                        Icons.center_focus_strong, size: 18),
                                    label: Text(tr(context)
                                        .welcomeScan),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () =>
                                        Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ImportCsvScreen(
                                            db: widget.db,
                                            collection:
                                                widget.collection),
                                      ),
                                    ),
                                    icon: const Icon(Icons.file_upload,
                                        size: 18),
                                    label: Text(tr(context)
                                        .welcomeImport),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => widget.onGoToTab(3),
                                    icon: const Icon(Icons.auto_awesome,
                                        size: 18),
                                    label: Text(tr(context)
                                        .welcomeTryForge),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                // las secciones, en el orden y con la visibilidad que haya
                // elegido el usuario. Cada una se autooculta si no tiene datos.
                for (final id in _layout.ordenVisible)
                  ..._bloque(context, id, recents, decks, hasCollection),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
