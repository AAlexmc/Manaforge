import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import 'package:manaforge_app/services/forge_texts.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_sets.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_shortfall.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/services/forge_job.dart';
import 'package:manaforge_app/ui/core/themes/mf_theme.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';
import 'package:manaforge_app/widgets/set_picker.dart';
import 'package:manaforge_app/widgets/style_picker.dart';
import 'package:manaforge_app/screens/deck_detail_screen.dart';
import 'package:manaforge_app/ui/settings/test_screen.dart';

const _minCardsForForge = 30;

List<String> _forgeMessages(AppLocalizations t) => [
      t.fgMsgReading,
      t.fgMsgCurve,
      t.fgMsgLands,
      t.fgMsgSynergy,
      t.fgMsgPlan,
    ];

/// Forge: el diferenciador. Estados: teaser (<30 cartas), selector, forjando
/// (mensajes rotatorios), resultados (carrusel) y "Forge no puede" con motivo.
class ForgeScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;

  /// Keys para que un tour pueda señalar los mandos de Forge.
  final Key? basicasKey;
  final Key? expansionesKey;
  final Key? queNoTengoKey;
  final Key? forjarKey;
  final Key? modoTestKey;
  final Key? deepForgeKey;

  const ForgeScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.decks,
      this.basicasKey,
      this.expansionesKey,
      this.queNoTengoKey,
      this.forjarKey,
      this.modoTestKey,
      this.deepForgeKey});

  @override
  State<ForgeScreen> createState() => _ForgeScreenState();
}

class _ForgeScreenState extends State<ForgeScreen> {
  bool _assumeBasics = true;
  // Opciones del jugador: colores, arquetipo, rango de precio y de años
  final Set<String> _selColors = {};
  String? _selArchetype;
  bool _deepForge = true;

  /// Estilo forzado ('lifegain', 'tribal:Elf', ...), o null para Auto.
  String? _selTheme;
  String _format = 'casual'; // casual · standard · pioneer · modern ·
  // pauper · legacy · commander
  final _minPriceCtrl = TextEditingController();
  final _maxPriceCtrl = TextEditingController();
  final _yearFromCtrl = TextEditingController();
  final _yearToCtrl = TextEditingController();
  bool _yearSupported = true;
  bool _forging = false;
  int _messageIndex = 0;
  Timer? _messageTimer;
  List<fe.GeneratedDeck>? _proposals;
  Map<String, fe.Card>? _pool;
  String? _cantReason;

  /// Expansiones elegidas (códigos de set). Vacío = sin filtro.
  final Set<String> _selSets = {};
  List<SetInfo>? _sets;
  Map<String, int> _ownedBySet = const {};
  bool _loadingSets = false;

  /// "Incluir cartas que no tengo": el pool deja de ser tu colección y pasa
  /// a ser TODO lo impreso en las expansiones elegidas. El mazo dice luego
  /// cuántas te faltan y cuánto costarían.
  bool _includeMissing = false;

  /// Cuántas copias te faltan de cada propuesta y lo que costarían, por
  /// índice de propuesta. Vacío mientras no se sepa.
  List<({int copies, double cost})>? _shortfalls;

  /// Copias que tienes DE VERDAD por nombre, congeladas al forjar: el pool
  /// del modo "cartas que no tengo" dice 4 de todo y mentiría.
  Map<String, int> _ownedByName = const {};

  /// Cuántas cartas tiene el pool que se está forjando: con muchas
  /// expansiones el motor tarda segundos y hay que decirlo.
  int? _poolSize;

  /// El teaser (menos de 30 cartas) no puede ser un muro: con "cartas que no
  /// tengo" se puede forjar sin colección. Este flag abre el selector igual.
  bool _forceSelector = false;

  @override
  void initState() {
    super.initState();
    widget.db.supportsYearFilter().then((v) {
      if (mounted) setState(() => _yearSupported = v);
    });
    // las expansiones NO se cargan aquí: Forge es una pestaña y se construye
    // al arrancar la app (IndexedStack). Listar los ~790 sets cuesta ~90 ms
    // de hilo de ventana que nadie ha pedido todavía; se cargan al abrir el
    // selector.
  }

  /// Las expansiones de la base, y cuántas casillas tienes de cada una (lo
  /// mismo que cuenta el Álbum: una sola fuente de verdad).
  Future<void> _loadSets() async {
    if (_loadingSets) return;
    _loadingSets = true;
    try {
      final sets = await widget.db.sets();
      final owned = await ownedCardsBySet(widget.db, widget.collection);
      if (!mounted) return;
      setState(() {
        _sets = sets;
        _ownedBySet = owned;
      });
    } catch (_) {
      // sin base de cartas descargada no hay expansiones que elegir; el
      // resto de Forge sigue funcionando igual
    } finally {
      _loadingSets = false;
    }
  }

  Future<void> _pickSets() async {
    if (_sets == null) await _loadSets();
    if (!mounted) return;
    final sets = _sets;
    if (sets == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(tr(context).fgNeedDbForSets)));
      return;
    }
    final elegidas = await showSetPickerSheet(context,
        sets: sets, selected: _selSets, owned: _ownedBySet);
    if (elegidas == null || !mounted) return; // cerrado sin tocar nada
    setState(() {
      _selSets
        ..clear()
        ..addAll(elegidas);
    });
  }

  /// Nombre corto de una expansión para los chips.
  String _setLabel(String code) {
    final match = _sets?.where((s) => s.code == code);
    final name = (match == null || match.isEmpty) ? null : match.first.name;
    return name ?? code.toUpperCase();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _yearFromCtrl.dispose();
    _yearToCtrl.dispose();
    super.dispose();
  }

  double? _parsePrice(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  int? _parseYear(TextEditingController c) {
    final y = int.tryParse(c.text.trim());
    return y != null && y >= 1993 && y <= 2100 ? y : null;
  }

  /// ¿Se puede forjar ahora mismo? En modo "cartas que no tengo" hace falta
  /// al menos una expansión: sin filtro serían las ~30.000 cartas de Magic,
  /// que no es un pool sino un catálogo.
  bool get _canForge => !_includeMissing || _selSets.isNotEmpty;

  /// El `ForgeJob` que `_forge()` mandaría al isolate con el estado ACTUAL
  /// de los mandos, sin lanzar la generación. Nombre público a propósito
  /// (el State es privado): es la costura para que un widget test afirme
  /// sobre el job de verdad (switch de forja profunda, estilo elegido...)
  /// en vez de solo mirar la etiqueta o el estado visual del control.
  @visibleForTesting
  ForgeJob buildForgeJob(Map<String, fe.Card> pool) => ForgeJob(
        pool: pool,
        allowedColors: _selColors.isEmpty ? null : _selColors.join(),
        archetype: _selArchetype,
        commander: _format == 'commander',
        deepForge: _deepForge,
        theme: _selTheme,
      );

  Future<void> _forge() async {
    if (!_canForge) return;
    setState(() {
      _forging = true;
      _messageIndex = 0;
      _proposals = null;
      _shortfalls = null;
      _cantReason = null;
      _poolSize = null;
    });
    _messageTimer =
        Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (mounted && _messageIndex < 4) {
        setState(() => _messageIndex++);
      }
    });
    try {
      // de dónde salen las cartas:
      //  · modo normal → tu colección, acotada a las expansiones elegidas
      //  · "cartas que no tengo" → todo lo impreso en esas expansiones
      final base = _includeMissing
          ? await widget.db.oraclesInSets(_selSets)
          : widget.collection.qtyByOracleInSets(_selSets);
      final pool = await widget.db.buildPool(base,
          assumeBasics: _assumeBasics,
          basicsQty: _format == 'commander' ? 40 : 25,
          minPriceEur: _parsePrice(_minPriceCtrl),
          maxPriceEur: _parsePrice(_maxPriceCtrl),
          yearMin: _parseYear(_yearFromCtrl),
          yearMax: _parseYear(_yearToCtrl),
          format: _format == 'casual' ? null : _format);
      if (mounted) setState(() => _poolSize = pool.length);
      // el trabajo pesado va en otro isolate: con 10 expansiones son ~21 s y
      // en el hilo de la ventana la app se queda colgada
      final trabajo = compute(runForgeJob, buildForgeJob(pool));
      // la pausa corre EN PARALELO al trabajo: es para que la animación
      // cuente su historia, no para hacer esperar de más
      await Future.delayed(const Duration(milliseconds: 2200));
      final proposals = await trabajo;
      // copias con las que se CUENTA: las tuyas de verdad y, si el
      // interruptor de básicas está puesto, las básicas sueltas que se dan
      // por supuestas. Es la misma cuenta que verá el detalle del mazo, para
      // que la tarjeta y el detalle no digan cosas distintas.
      final ownedByName = widget.collection.qtyByName;
      if (_assumeBasics) {
        for (final card in pool.values) {
          if (!card.types.contains('Basic')) continue;
          final tengo = ownedByName[card.name] ?? 0;
          if (card.qty > tengo) ownedByName[card.name] = card.qty;
        }
      }
      final shortfalls = await _shortfallsFor(proposals, ownedByName);
      _messageTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _forging = false;
        _pool = pool;
        _ownedByName = ownedByName;
        if (proposals.isEmpty) {
          _cantReason = sinMazoReason();
        } else {
          _proposals = proposals;
          _shortfalls = shortfalls;
        }
      });
    } catch (e) {
      _messageTimer?.cancel();
      if (mounted) {
        setState(() {
          _forging = false;
          _cantReason = tr(context).fgDbError('$e');
        });
      }
    }
  }

  /// Por qué la forja no dio ningún mazo. Nombre público a propósito (el
  /// State es privado, igual que `buildForgeJob`): costura para que un
  /// widget test afirme sobre el mensaje real sin tener que montar el
  /// pipeline de generación entero en un isolate.
  @visibleForTesting
  String sinMazoReason() {
    final t = tr(context);
    // Con Estilo forzado, la vía de salida vacía más probable es que ESE
    // color no tenga con qué jugarlo (generator.dart null-guard tribal/
    // mecánico) — un mensaje de "compra más cartas" desvía del motivo real
    // (I2). Se comprueba ANTES que formato/expansiones/colección: aplica
    // sea cual sea la causa real cuando hay un Estilo forzado puesto.
    if (_selTheme != null) {
      return t.fgNoDeckStyle(styleName(t, _selTheme!));
    }
    final donde = _selSets.isEmpty ? '' : t.fgInThoseSets(_selSets.length);
    if (_format == 'commander') return t.fgNoCommander(donde);
    return t.fgNoDeck(
      _format == 'casual' ? t.fgOf60 : t.fgLegalIn(_format),
      donde,
      _includeMissing ? t.fgTipMoreSets : t.fgTipMoreCards,
    );
  }

  /// Cuántas copias te faltan de cada propuesta y cuánto costarían. Se mide
  /// contra las copias REALES, no contra el pool (en modo "cartas que no
  /// tengo" el pool dice 4 de todo).
  Future<List<({int copies, double cost})>> _shortfallsFor(
      List<fe.GeneratedDeck> proposals,
      Map<String, int> ownedByName) async {
    if (proposals.isEmpty) return const [];
    final faltantes = <String>{};
    final porMazo = <Map<String, int>>[];
    for (final gen in proposals) {
      final falta = missingCards(gen.deck, ownedByName);
      porMazo.add(falta);
      faltantes.addAll(falta.keys);
    }
    var precios = const <String, double>{};
    if (faltantes.isNotEmpty) {
      try {
        precios = await widget.db.pricesForNames(faltantes);
      } catch (_) {/* sin precios: se dice el número, no el dinero */}
    }
    return [
      for (final falta in porMazo)
        (
          copies: falta.values.fold(0, (a, b) => a + b),
          cost: missingCost(falta, precios),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.collection,
          builder: (context, _) {
            final total = widget.collection.totalCopies;
            if (_forging) return _buildForging();
            if (_proposals != null) return _buildResults();
            if (total < _minCardsForForge && !_forceSelector) {
              return _buildTeaser(total);
            }
            return _buildSelector();
          },
        ),
      ),
    );
  }

  Widget _header() => Row(
        children: [
          const Icon(Icons.auto_awesome, color: MFColors.forge),
          const SizedBox(width: 8),
          Text('Forge', style: Theme.of(context).textTheme.headlineMedium),
        ],
      );

  /// Teaser con contador: anticipación, no candado.
  Widget _buildTeaser(int total) {
    final t = tr(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 8),
          Text(t.fgPitch),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Text('$total/$_minCardsForForge',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: MFColors.forge)),
                const SizedBox(height: 8),
                Text(t.fgTeaserCount, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: LinearProgressIndicator(
                    value: total / _minCardsForForge,
                    color: MFColors.forge,
                    backgroundColor: MFColors.forge.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(height: 20),
                // el teaser no puede ser un muro: sin colección todavía se
                // puede forjar con cartas que no tienes, para saber qué pedir
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _forceSelector = true;
                    _includeMissing = true;
                  }),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: Text(t.fgTeaserMissing),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSelector() {
    final t = tr(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      // Column dentro de un scroll, y no ListView: la lista perezosa no
      // construye lo que queda fuera de la vista, y entonces un tour no puede
      // medir los mandos de abajo (Modo Test) para señalarlos. Son ~20 hijos
      // fijos: montarlos todos no cuesta nada.
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(),
            const SizedBox(height: 8),
            Text(t.fgPitch),
            const SizedBox(height: 20),
            KeyedSubtree(
              key: widget.basicasKey,
              child: SwitchListTile(
                value: _assumeBasics,
                onChanged: (v) => setState(() => _assumeBasics = v),
                title: Text(t.fgBasics),
                subtitle: Text(t.fgBasicsSub),
              ),
            ),
            const SizedBox(height: 12),
            Text(t.fgFormat, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final f in [
                  ('casual', t.fgCasual60),
                  ('standard', 'Standard'),
                  ('pioneer', 'Pioneer'),
                  ('modern', 'Modern'),
                  ('pauper', 'Pauper'),
                  ('legacy', 'Legacy'),
                  ('commander', 'Commander'),
                ])
                  ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(f.$2),
                    selected: _format == f.$1,
                    onSelected: (_) => setState(() => _format = f.$1),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _format == 'commander'
                    ? t.fgCommanderNote
                    : _format == 'casual'
                        ? t.fgCasualNote
                        : t.fgFormatNote(
                            '${_format[0].toUpperCase()}${_format.substring(1)}'),
                style: const TextStyle(fontSize: 11.5),
              ),
            ),
            const SizedBox(height: 14),
            Text(t.fgWhereFrom,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                KeyedSubtree(
                  key: widget.expansionesKey,
                  child: ActionChip(
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.collections_bookmark_outlined,
                        size: 18),
                    label: Text(
                        _selSets.isEmpty ? t.fgPickSets : t.fgChangeSets),
                    onPressed: _pickSets,
                  ),
                ),
                for (final code in _selSets)
                  InputChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(_setLabel(code)),
                    onDeleted: () => setState(() => _selSets.remove(code)),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _selSets.isEmpty
                    ? (_includeMissing ? t.fgNeedOneSet : t.fgNoSetsNote)
                    : (_includeMissing
                        ? t.fgFromSetsAny(_selSets.length)
                        : t.fgFromSetsMine(_selSets.length)),
                style: TextStyle(
                    fontSize: 11.5,
                    color: _canForge ? null : MFColors.warning),
              ),
            ),
            if (!widget.collection.hasPrintingData &&
                widget.collection.totalCopies > 0 &&
                !_includeMissing)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  t.fgNoPrintingData,
                  style: const TextStyle(
                      fontSize: 11.5, color: MFColors.warning),
                ),
              ),
            // aire por arriba: sin él, el foco del tour (que engorda el rect 8
            // px) se comía media línea del texto de las expansiones
            const SizedBox(height: 10),
            KeyedSubtree(
              key: widget.queNoTengoKey,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _includeMissing,
                onChanged: (v) => setState(() => _includeMissing = v),
                title: Text(t.fgIncludeMissing),
                subtitle: Text(t.fgIncludeMissingSub),
              ),
            ),
            const SizedBox(height: 8),
            Text(t.fgYourTaste,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final c in const ['W', 'U', 'B', 'R', 'G'])
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    avatar: CircleAvatar(
                        radius: 6, backgroundColor: manaColors[c]!),
                    label: Text(c),
                    selected: _selColors.contains(c),
                    onSelected: (v) => setState(
                        () => v ? _selColors.add(c) : _selColors.remove(c)),
                  ),
                const SizedBox(width: 6),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selArchetype,
                    hint: Text(t.fgArchetypeAuto,
                        style: const TextStyle(fontSize: 12.5)),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 12.5),
                    borderRadius: BorderRadius.circular(10),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text(t.fgArchetypeAuto)),
                      const DropdownMenuItem(
                          value: 'aggro', child: Text('Aggro')),
                      const DropdownMenuItem(
                          value: 'tempo', child: Text('Tempo')),
                      const DropdownMenuItem(
                          value: 'midrange', child: Text('Midrange')),
                      const DropdownMenuItem(
                          value: 'control', child: Text('Control')),
                    ],
                    onChanged: (v) => setState(() => _selArchetype = v),
                  ),
                ),
                const SizedBox(width: 6),
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  avatar: const Icon(Icons.auto_fix_high, size: 16),
                  label: Text(
                      _selTheme == null ? t.fgStyleAuto : styleName(t, _selTheme!),
                      style: const TextStyle(fontSize: 12.5)),
                  onPressed: () async {
                    final picked = await showStylePickerSheet(context,
                        selected: _selTheme);
                    if (picked == null || !mounted) return; // cerrado sin tocar nada
                    setState(() => _selTheme = picked.isEmpty ? null : picked);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            KeyedSubtree(
              key: widget.deepForgeKey,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _deepForge,
                onChanged: (v) => setState(() => _deepForge = v),
                title: Text(t.fgDeepForge),
                subtitle: Text(t.fgDeepForgeHint,
                    style: const TextStyle(fontSize: 11.5)),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(t.fgPricePerCard,
                    style: const TextStyle(fontSize: 12.5)),
                _numField(_minPriceCtrl, t.fgMin),
                const Text('—', style: TextStyle(fontSize: 12.5)),
                _numField(_maxPriceCtrl, t.fgMax),
                const SizedBox(width: 12),
                Text(t.fgCardYear, style: const TextStyle(fontSize: 12.5)),
                _numField(_yearFromCtrl, t.fgFrom, enabled: _yearSupported),
                const Text('—', style: TextStyle(fontSize: 12.5)),
                _numField(_yearToCtrl, t.fgTo, enabled: _yearSupported),
              ],
            ),
            if (!_yearSupported)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  t.fgYearNeedsDb,
                  style: const TextStyle(
                      fontSize: 11.5, color: MFColors.warning),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              _selColors.isEmpty
                  ? t.fgNoColorsNote
                  : t.fgColorsNote(_selColors.join()),
              style: const TextStyle(fontSize: 11.5),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_includeMissing
                    ? t.fgMissingNote
                    : t.fgOnlyYoursNote(widget.collection.totalCopies)),
              ),
            ),
            const SizedBox(height: 20),
            if (_cantReason != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: MFColors.warning.withValues(alpha: 0.12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_cantReason!),
                  ),
                ),
              ),
            KeyedSubtree(
              key: widget.forjarKey,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: MFColors.forge,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _canForge ? _forge : null,
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                    _includeMissing ? t.fgForgeMissing : t.fgForgeMine),
              ),
            ),
            const SizedBox(height: 8),
            KeyedSubtree(
              key: widget.modoTestKey,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TestScreen(
                        db: widget.db,
                        collection: widget.collection,
                        decks: widget.decks),
                  ),
                ),
                icon: const Icon(Icons.sports_kabaddi, size: 18),
                label: Text(t.fgTestMode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numField(TextEditingController ctrl, String hint,
      {bool enabled = true}) {
    return SizedBox(
      width: 74,
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 12.5),
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildForging() {
    final t = tr(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(color: MFColors.forge),
          ),
          const SizedBox(height: 24),
          Text(_forgeMessages(t)[_messageIndex],
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(t.fgOffline, style: const TextStyle(fontSize: 12)),
          if ((_poolSize ?? 0) > 1200) ...[
            const SizedBox(height: 6),
            Text(t.fgForgingWith(_poolSize ?? 0),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _buildResults() {
    final t = tr(context);
    final proposals = _proposals!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(
            children: [
              // vuelta al selector SIN perder lo elegido (expansiones,
              // Estilo, presupuesto…): solo se descartan las propuestas
              IconButton(
                onPressed: () => setState(() => _proposals = null),
                icon: const Icon(Icons.arrow_back),
                tooltip: t.fgBackToOptions,
              ),
              Expanded(
                child: Text(t.fgDecksReady(proposals.length),
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextButton.icon(
                onPressed: _forge,
                icon: const Icon(Icons.refresh),
                label: Text(t.fgReforge),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
              _includeMissing ? t.fgSwipeMissing : t.fgSwipeMine),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: proposals.length,
            itemBuilder: (context, i) => _ProposalCard(
                gen: proposals[i],
                pool: _pool!,
                db: widget.db,
                decks: widget.decks,
                ownedPrintings:
                    widget.collection.printingQty.keys.toSet(),
                ownedByName: _ownedByName,
                shortfall: _shortfalls == null || i >= _shortfalls!.length
                    ? null
                    : _shortfalls![i]),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final fe.GeneratedDeck gen;
  final Map<String, fe.Card> pool;
  final CardDatabase db;
  final DeckStore decks;
  final Set<String> ownedPrintings;

  /// Copias reales por nombre: el pool del modo "cartas que no tengo" dice 4
  /// de todo, así que preguntarle a él cuántas tienes siempre diría "todas".
  final Map<String, int> ownedByName;

  /// Lo que falta para poder jugarlo, ya calculado. `null` = aún sin saber.
  final ({int copies, double cost})? shortfall;

  const _ProposalCard(
      {required this.gen,
      required this.pool,
      required this.db,
      required this.decks,
      required this.ownedPrintings,
      required this.ownedByName,
      this.shortfall});

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    final deck = gen.deck;
    final hist = fe.ManaCurve.curveHistogram(deck.cards, pool, cap: 6);
    final accent = manaColors[deck.colors.isEmpty ? 'C' : deck.colors[0]] ??
        MFColors.forge;
    return SizedBox(
      width: 262,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                        deck.totalCards == 100
                            ? 'COMMANDER'
                            : deck.archetype.name.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  ColorIdentityDots(colors: deck.colors),
                ],
              ),
              const SizedBox(height: 10),
              Text(deck.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold)),
              Text(themeName(t, gen.theme)),
              const SizedBox(height: 14),
              MiniCurve(histogram: hist, color: accent),
              const SizedBox(height: 14),
              Expanded(
                child: Text('"${tagline(t, gen)}"',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
              if ((shortfall?.copies ?? 0) == 0)
                Text(tr(context).fgHaveAll,
                    style: const TextStyle(
                        color: MFColors.success, fontSize: 12))
              else
                Text(
                    tr(context).fgShortfall(shortfall!.copies) +
                        (shortfall!.cost > 0
                            ? ' · ${shortfall!.cost.toStringAsFixed(2)} €'
                            : ''),
                    style: const TextStyle(
                        color: MFColors.warning, fontSize: 12)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => DeckDetailScreen(
                            gen: gen,
                            pool: pool,
                            db: db,
                            decks: decks,
                            ownedPrintings: ownedPrintings,
                            ownedByName: ownedByName)),
                  ),
                  child: Text(tr(context).fgSeeDeck),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
