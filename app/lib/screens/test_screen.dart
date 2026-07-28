import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import 'package:manaforge_app/services/forge_texts.dart';
import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/deck_store.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/services/meta_decks.dart';
import 'package:manaforge_app/theme/mf_theme.dart';
import 'package:manaforge_app/widgets/common.dart';
import 'package:manaforge_app/screens/deck_detail_screen.dart';

/// Modo Test: elige un mazo del meta y ManaForge busca en tu colección el
/// mazo con mayor % de victoria simulando partidas (y luego afinando con
/// cambios de carta). El % es una estimación con partidas simplificadas.
class TestScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;
  final String? initialMetaId; // preseleccionar un mazo (desde Inicio)

  const TestScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.decks,
      this.initialMetaId});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<MetaDeck> _decks = metaDecks;
  /// De dónde salen los mazos del meta. Vacío hasta que se sepa: el texto de
  /// "cargando" (y el de "presets locales") lo pone el `build`, que sí sabe en
  /// qué idioma va la app.
  String _decksSource = '';
  bool? _decksOnline;
  String _metaId = metaDecks.first.id;
  String? _formatFilter;
  bool _running = false;
  fe.OptimizeResult? _result;
  MetaDeck? _resultMeta;
  Map<String, fe.Card>? _pool;
  String? _error;

  @override
  void initState() {
    super.initState();
    MetaDeckService().load().then((result) {
      if (!mounted) return;
      setState(() {
        _decks = result.decks;
        _decksSource = result.source;
        _decksOnline = result.online;
        final wanted = widget.initialMetaId;
        if (wanted != null && _decks.any((m) => m.id == wanted)) {
          _metaId = wanted;
        } else if (!_decks.any((m) => m.id == _metaId)) {
          _metaId = _decks.first.id;
        }
      });
    });
  }

  MetaDeck get _meta => _decks.firstWhere((m) => m.id == _metaId);

  /// Formatos presentes en los mazos cargados (null = todos).
  List<String?> _formats() {
    final formats = <String>{};
    for (final m in _decks) {
      if (m.format.isNotEmpty) formats.add(m.format);
    }
    return [null, ...formats.toList()..sort()];
  }

  List<MetaDeck> _visibleDecks() {
    final visible = _formatFilter == null
        ? _decks
        : _decks.where((m) => m.format == _formatFilter).toList();
    // si el mazo elegido queda fuera del filtro, elegir el primero visible
    if (visible.isNotEmpty && !visible.any((m) => m.id == _metaId)) {
      _metaId = visible.first.id;
    }
    return visible;
  }

  /// El closure del isolate se crea AQUÍ, en una función estática, para que
  /// solo capture los argumentos (un closure creado dentro del State captura
  /// el State entero, que no es serializable → crash "object is unsendable").
  static Future<fe.OptimizeResult?> _optimizeInIsolate(
      Map<String, fe.Card> pool,
      fe.Deck metaDeck,
      Map<String, fe.Card> metaPool,
      int seed,
      int startingLife) {
    return Isolate.run(() => fe.optimizeAgainst(pool, metaDeck, metaPool,
        seed: seed, startingLife: startingLife));
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _result = null;
      _error = null;
    });
    final t = tr(context);
    try {
      final meta = _meta;
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle);
      final metaPool = await widget.db.poolByNames(meta.allNames);
      final metaDeck = meta.toDeck();
      final seed = DateTime.now().millisecondsSinceEpoch & 0xffff;
      // Commander se juega a 40 vidas
      final life = meta.format.toLowerCase().contains('commander') ? 40 : 20;
      final result =
          await _optimizeInIsolate(pool, metaDeck, metaPool, seed, life);
      if (!mounted) return;
      setState(() {
        _running = false;
        if (result == null) {
          _error = t.tsNoDeckToFace;
        } else {
          _result = result;
          _resultMeta = meta;
          _pool = pool;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _running = false;
          _error = t.tsSimFailed('$e');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.tsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(t.tsIntro),
            const SizedBox(height: 8),
            Text(
                _decksOnline == null
                    ? t.tsLoadingMeta
                    : (_decksSource.isEmpty
                        ? t.tsLocalPresets
                        : _decksSource),
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final f in _formats())
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(f ?? t.acAll),
                    selected: _formatFilter == f,
                    onSelected: (_) =>
                        setState(() => _formatFilter = f),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            for (final m in _visibleDecks())
              Card(
                child: RadioListTile<String>(
                  value: m.id,
                  groupValue: _metaId,
                  onChanged: _running
                      ? null
                      : (v) => setState(() => _metaId = v!),
                  title: Row(
                    children: [
                      ColorIdentityDots(colors: m.colors, size: 12),
                      const SizedBox(width: 8),
                      Text(m.name),
                      if (m.share.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(t.tsFormatShare(m.format, m.share),
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ],
                  ),
                  subtitle: Text(_metaDescription(t, m)),
                ),
              ),
            const SizedBox(height: 16),
            if (_running) ...[
              const LinearProgressIndicator(color: MFColors.forge),
              const SizedBox(height: 10),
              Text(t.tsSimulating, textAlign: TextAlign.center),
            ] else
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: MFColors.forge,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _run,
                icon: const Icon(Icons.sports_kabaddi),
                label: Text(t.tsFindBest(_meta.name)),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Card(
                  color: MFColors.warning.withValues(alpha: 0.12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_error!),
                  ),
                ),
              ),
            if (_result != null) _buildResult(),
            const SizedBox(height: 12),
            Text(t.tsHonesty, style: const TextStyle(fontSize: 11.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final t = tr(context);
    final result = _result!;
    final meta = _resultMeta!;
    final deck = result.deck.deck;
    final pct = (result.winRate * 100).round();
    final good = result.winRate >= 0.5;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.tsChampion(meta.name),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('$pct %',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(
                            color:
                                good ? MFColors.success : MFColors.warning,
                            fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(t.tsWinRateLine(
                      result.decksTried, result.gamesPerEval)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ColorIdentityDots(colors: deck.colors, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${deck.name} · '
                      '${archetypeName(t, deck.archetype)} · '
                      '${themeName(t, result.deck.theme)}'),
                ),
              ],
            ),
            if (!good)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(t.tsNoDominant,
                    style: const TextStyle(fontSize: 12)),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DeckDetailScreen(
                    gen: result.deck,
                    pool: _pool!,
                    db: widget.db,
                    decks: widget.decks,
                    ownedPrintings:
                        widget.collection.printingQty.keys.toSet(),
                  ),
                ),
              ),
              child: Text(t.tsSeeDeck),
            ),
          ],
        ),
      ),
    );
  }
}

/// Los tres mazos de meta que la app trae dentro para cuando no hay conexión
/// son contenido nuestro, así que se traducen. Los que bajan del feed vienen
/// con su texto ya escrito y se enseñan tal cual.
String _metaDescription(AppLocalizations t, MetaDeck m) => switch (m.id) {
      'mono_red_aggro' => t.tsPresetMonoRed,
      'azorius_control' => t.tsPresetAzorius,
      'golgari_midrange' => t.tsPresetGolgari,
      _ => m.description,
    };
