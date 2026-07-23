import 'package:flutter/material.dart';

import '../services/achievements_controller.dart';
import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/collection_value.dart';
import '../services/folder_store.dart';
import '../services/folder_value.dart';
import '../services/scanner_database.dart';
import '../services/market_prefs.dart';
import '../services/price_series_database.dart';
import '../widgets/app_shortcuts.dart';
import '../widgets/folder_tile.dart';
import 'album_screen.dart';
import 'all_cards_screen.dart';
import 'folder_detail_screen.dart';
import 'folder_pick_screen.dart';
import 'import_csv_screen.dart';

// El orden y los filtros viven en collection_filters.dart; se re-exportan
// porque media app (y sus tests) los importaban desde aquí.
export 'collection_filters.dart'
    show CollectionSort, sortCollection, CollectionFilters, addedLabel;

/// Colección: portada con tus CARPETAS y su valor. La lista completa de
/// cartas está tras el botón "Todas las cartas". Estados: sin base de datos
/// (descargar) y colección viva.
class ColeccionScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final ScannerDatabase scanner;
  final FolderStore folders;

  /// Opcional: si está, escanear y crear carpetas cuentan para los logros.
  final AchievementsController? achievements;

  /// Opcionales: si vienen, las fichas de carta abiertas desde la colección
  /// dejan elegir mercado, como el Mercado.
  final MarketPreference? market;
  final PriceSeriesDatabase? prices;

  /// Ctrl+F: aquí no hay buscador, se busca en "Todas las cartas". Si el
  /// aviso es para esta pestaña, se abre esa pantalla directamente.
  final SearchFocusBus? search;
  final int tabIndex;

  /// Abrir el escáner. Si viene, la colección vacía enseña el botón de
  /// escanear la primera carta.
  final VoidCallback? onScan;

  /// Keys para que un tour pueda señalar "Todas las cartas" y las carpetas.
  final Key? todasKey;
  final Key? carpetasKey;

  const ColeccionScreen({
    super.key,
    required this.db,
    required this.collection,
    required this.scanner,
    required this.folders,
    this.achievements,
    this.market,
    this.prices,
    this.search,
    this.tabIndex = -1,
    this.onScan,
    this.todasKey,
    this.carpetasKey,
  });

  @override
  State<ColeccionScreen> createState() => _ColeccionScreenState();
}

class _ColeccionScreenState extends State<ColeccionScreen> {
  bool? _dbReady;
  double? _downloadProgress;
  String? _error;

  /// Valor por carpeta (id -> €) y de la colección entera, con la MISMA
  /// fórmula que Inicio y Mercado.
  Map<String, CollectionValuation> _folderValues = const {};
  CollectionValuation? _total;
  int _valuesToken = 0;
  bool _computing = false;
  bool _needsRecompute = false;

  @override
  void initState() {
    super.initState();
    widget.collection.load();
    widget.folders.load();
    widget.collection.addListener(_recomputeValues);
    widget.folders.addListener(_recomputeValues);
    widget.search?.addListener(_onSearchShortcut);
    widget.db.isReady().then((ready) {
      if (mounted) setState(() => _dbReady = ready);
      if (ready) _recomputeValues();
    });
  }

  @override
  void dispose() {
    widget.collection.removeListener(_recomputeValues);
    widget.folders.removeListener(_recomputeValues);
    widget.search?.removeListener(_onSearchShortcut);
    super.dispose();
  }

  /// Ctrl+F en esta pestaña: aquí no hay buscador — se busca en "Todas las
  /// cartas", así que se abre esa, que es lo que se quería.
  void _onSearchShortcut() {
    if (!mounted || widget.search?.target != widget.tabIndex) return;
    _openAllCards();
  }

  /// Una sola pasada para todas las carpetas: el mapa impresión -> carta se
  /// pide UNA vez y se reparte, en vez de una consulta por carpeta.
  Future<void> _recomputeValues() async {
    // importar un CSV avisa una vez POR CARTA: sin esto son cientos de
    // pasadas a la base de precios para acabar pintando solo la última
    if (_computing) {
      _needsRecompute = true;
      return;
    }
    _computing = true;
    try {
      do {
        _needsRecompute = false;
        await _computeValuesOnce();
      } while (_needsRecompute && mounted);
    } finally {
      _computing = false;
    }
  }

  Future<void> _computeValuesOnce() async {
    final token = ++_valuesToken;
    final folders = widget.folders.folders;
    final cards = widget.collection.cards;
    final byPrinting = widget.collection.hasPrintingData;
    final printingQty = widget.collection.printingQty;
    try {
      final owners = byPrinting && printingQty.isNotEmpty
          ? await widget.db.oracleByPrintings(printingQty.keys)
          : const <String, String>{};
      // de paso, las colecciones viejas aprenden a qué carta pertenece cada
      // edición (hace falta para que vender baje el valor)
      if (owners.isNotEmpty) {
        widget.collection.backfillPrintingOwners(owners);
      }
      Future<Map<String, String>> cachedOwners(Iterable<String> _) async =>
          owners;
      final values = <String, CollectionValuation>{};
      for (final f in folders) {
        values[f.id] = await computeFolderValue(
          folderCardIds: f.cardIds,
          cards: cards,
          byPrinting: byPrinting,
          printingQty: printingQty,
          oracleByPrintings: cachedOwners,
          oraclePrices: widget.db.pricesForOracles,
          printingPrices: widget.db.pricesForPrintings,
        );
      }
      final total = await computeCollectionValue(
        cards: cards,
        byPrinting: byPrinting,
        printingQty: printingQty,
        oraclePrices: widget.db.pricesForOracles,
        printingPrices: widget.db.pricesForPrintings,
      );
      if (mounted && token == _valuesToken) {
        setState(() {
          _folderValues = values;
          _total = total;
        });
      }
    } catch (_) {
      // sin base de cartas todavía: la portada funciona igual, sin precios
    }
  }

  Future<void> _download() async {
    setState(() {
      _downloadProgress = 0;
      _error = null;
    });
    try {
      await for (final p in widget.db.download()) {
        if (mounted) setState(() => _downloadProgress = p < 0 ? null : p);
      }
      if (mounted) {
        setState(() {
          _dbReady = true;
          _downloadProgress = null;
        });
        _recomputeValues();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloadProgress = null;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _newFolder() async {
    final look = await showFolderEditor(context);
    if (look == null || !mounted) return;
    // recién creada se abre el selector: crear una carpeta vacía y tener que
    // buscar dónde se llena era el paso que sobraba
    final picked = await Navigator.of(context).push<Set<String>>(
      MaterialPageRoute(
        builder: (_) => FolderPickScreen(
            collection: widget.collection, title: look.name),
      ),
    );
    // dar atrás en el selector = no quiero la carpeta (antes se creaba vacía)
    if (picked == null) return;
    widget.folders.create(
      name: look.name,
      colorValue: look.colorValue,
      icon: look.icon,
      cardIds: picked,
    );
  }

  void _openFolder(CardFolder folder) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FolderDetailScreen(
        db: widget.db,
        collection: widget.collection,
        folders: widget.folders,
        folderId: folder.id,
        market: widget.market,
        prices: widget.prices,
      ),
    ));
  }

  void _openAllCards() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AllCardsScreen(
          db: widget.db,
          collection: widget.collection,
          folders: widget.folders,
          market: widget.market,
          prices: widget.prices),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _dbReady == null
            ? const Center(child: CircularProgressIndicator())
            : (_dbReady == false ? _buildNeedsDb() : _buildHome()),
      ),
    );
  }

  /// Estado inicial: hay que descargar la base de datos de cartas.
  Widget _buildNeedsDb() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Colección',
              style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          Text('Tu colección empieza aquí',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Primero necesito la base de datos con todas las cartas de Magic '
            '(se descarga una vez y luego todo funciona sin internet).',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_downloadProgress != null) ...[
            LinearProgressIndicator(value: _downloadProgress),
            const SizedBox(height: 8),
            Text(
              'Descargando… ${((_downloadProgress ?? 0) * 100).toStringAsFixed(0)} %',
              textAlign: TextAlign.center,
            ),
          ] else
            FilledButton.icon(
              onPressed: _download,
              icon: const Icon(Icons.download),
              label: const Text('Descargar base de datos de cartas'),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          const Spacer(),
          const Text(
            'Datos e imágenes por Scryfall · Sin cuentas, sin pagos: todo queda en tu dispositivo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Portada: cabecera, "Todas las cartas" y la rejilla de carpetas.
  Widget _buildHome() {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.collection, widget.folders]),
      builder: (context, _) {
        final folders = widget.folders.folders;
        final owned = {for (final c in widget.collection.cards) c.oracleId};
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Colección',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium),
                        ),
                        IconButton(
                          tooltip: 'Álbum por expansiones',
                          icon: const Icon(Icons.auto_stories_outlined),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlbumScreen(
                                  db: widget.db,
                                  collection: widget.collection),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Importar CSV de ManaBox',
                          icon: const Icon(Icons.file_upload_outlined),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImportCsvScreen(
                                  db: widget.db,
                                  collection: widget.collection),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('${widget.collection.totalCopies} cartas · '
                        '${widget.collection.distinctCards} distintas'
                        '${_total == null ? '' : ' · ${_total!.approximate ? '~' : ''}${_total!.total.toStringAsFixed(2)} €'}'),
                    if (widget.collection.totalCopies == 0) ...[
                      const SizedBox(height: 14),
                      _ColeccionVaciaCta(
                        onScan: widget.onScan,
                        onImport: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ImportCsvScreen(
                                db: widget.db, collection: widget.collection),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    KeyedSubtree(
                      key: widget.todasKey,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          onTap: _openAllCards,
                          leading: const Icon(Icons.style_outlined),
                          title: const Text('Todas las cartas'),
                          subtitle: Text(
                              '${widget.collection.distinctCards} distintas · '
                              'buscar, filtrar y ordenar'),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    KeyedSubtree(
                      key: widget.carpetasKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Carpetas',
                                style:
                                    Theme.of(context).textTheme.titleMedium),
                          ),
                          TextButton.icon(
                            onPressed: _newFolder,
                            icon: const Icon(Icons.create_new_folder_outlined,
                                size: 18),
                            label: const Text('Nueva'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (folders.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    children: [
                      const Text(
                        'Aún no tienes carpetas. Sirven para agrupar lo que '
                        'quieras: "rares de Aetherdrift", "para vender", "la '
                        'caja de arriba"… Una carta puede estar en varias.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _newFolder,
                        icon: const Icon(Icons.create_new_folder_outlined),
                        label: const Text('Crear la primera carpeta'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                sliver: SliverGrid.builder(
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 190,
                    mainAxisExtent: 168,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: folders.length,
                  itemBuilder: (context, i) {
                    final folder = folders[i];
                    final value = _folderValues[folder.id];
                    return FolderCard(
                      folder: folder,
                      presentCount: folder.presentIn(owned).length,
                      value: value?.total,
                      approximate: value?.approximate ?? false,
                      onTap: () => _openFolder(folder),
                    );
                  },
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        );
      },
    );
  }
}

/// Lo que ve alguien que llega a la colección con la base ya descargada pero
/// sin ninguna carta: en vez de una portada de carpetas vacías, por dónde
/// empezar (escanear o importar).
class _ColeccionVaciaCta extends StatelessWidget {
  final VoidCallback? onScan;
  final VoidCallback onImport;

  const _ColeccionVaciaCta({required this.onScan, required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aquí empieza tu colección',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(
              'Escanea tus cartas con la cámara o importa un CSV de ManaBox. '
              'Aparecerán aquí y en el álbum.',
              style: TextStyle(fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (onScan != null)
                  FilledButton.icon(
                    onPressed: onScan,
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: const Text('Escanear mis cartas'),
                  ),
                OutlinedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.file_upload_outlined, size: 18),
                  label: const Text('Importar CSV'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
