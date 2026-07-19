import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/deck_store.dart';
import '../services/meta_decks.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'deck_detail_screen.dart';

/// Modo Test: elige un mazo del meta y ManaForge busca en tu colección el
/// mazo con mayor % de victoria simulando partidas (y luego afinando con
/// cambios de carta). El % es una estimación con partidas simplificadas.
class TestScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;

  const TestScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.decks});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<MetaDeck> _decks = metaDecks;
  String _decksSource = 'Cargando meta…';
  String _metaId = metaDecks.first.id;
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
        if (!_decks.any((m) => m.id == _metaId)) {
          _metaId = _decks.first.id;
        }
      });
    });
  }

  MetaDeck get _meta => _decks.firstWhere((m) => m.id == _metaId);

  /// El closure del isolate se crea AQUÍ, en una función estática, para que
  /// solo capture los argumentos (un closure creado dentro del State captura
  /// el State entero, que no es serializable → crash "object is unsendable").
  static Future<fe.OptimizeResult?> _optimizeInIsolate(
      Map<String, fe.Card> pool,
      fe.Deck metaDeck,
      Map<String, fe.Card> metaPool,
      int seed) {
    return Isolate.run(
        () => fe.optimizeAgainst(pool, metaDeck, metaPool, seed: seed));
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _result = null;
      _error = null;
    });
    try {
      final meta = _meta;
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle);
      final metaPool = await widget.db.poolByNames(meta.allNames);
      final metaDeck = meta.toDeck();
      final seed = DateTime.now().millisecondsSinceEpoch & 0xffff;
      final result = await _optimizeInIsolate(pool, metaDeck, metaPool, seed);
      if (!mounted) return;
      setState(() {
        _running = false;
        if (result == null) {
          _error = 'Con las cartas actuales no me sale ningún mazo completo '
              'que enfrentar. Añade más cartas y vuelve a intentarlo.';
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
          _error = 'No pude simular: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Test — vence al meta')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
                'Elige contra qué mazo del meta quieres jugar. ManaForge '
                'construye mazos con TUS cartas, simula cientos de partidas '
                'contra él y se queda con el que más gana — probando además '
                'cambios de carta uno a uno para afinarlo.'),
            const SizedBox(height: 8),
            Text(_decksSource,
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final m in _decks)
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
                        Text('${m.format} · ${m.share} del meta',
                            style: const TextStyle(fontSize: 11)),
                      ],
                    ],
                  ),
                  subtitle: Text(m.description),
                ),
              ),
            const SizedBox(height: 16),
            if (_running) ...[
              const LinearProgressIndicator(color: MFColors.forge),
              const SizedBox(height: 10),
              const Text(
                'Simulando partidas… (unos segundos; todo en tu equipo)',
                textAlign: TextAlign.center,
              ),
            ] else
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: MFColors.forge,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _run,
                icon: const Icon(Icons.sports_kabaddi),
                label: Text('Buscar mi mejor mazo contra ${_meta.name}'),
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
            const Text(
              'Honestidad: la simulación entiende colores de maná, mulligans, '
              'evasión (volar, arrollar, toque mortal…), removal instantáneo '
              'y contramagia — pero no el texto completo de cada carta. El '
              'porcentaje sirve para COMPARAR tus mazos entre sí, no como '
              'predicción exacta.',
              style: TextStyle(fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
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
            Text('Tu campeón contra ${meta.name}',
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
                  child: Text(
                      'de victorias estimadas · ${result.decksTried} mazos '
                      'probados · ${result.gamesPerEval} partidas por mazo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ColorIdentityDots(colors: deck.colors, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      '${deck.name} · ${deck.archetype.name} · '
                      '${fe.themeName(result.deck.theme)}'),
                ),
              ],
            ),
            if (!good)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                    'Ningún mazo de tu colección domina este enfrentamiento '
                    '— este es el que mejor pelea. Mira sus debilidades en '
                    'el detalle.',
                    style: TextStyle(fontSize: 12)),
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
              child: const Text('Ver mazo completo (y guardarlo)'),
            ),
          ],
        ),
      ),
    );
  }
}
