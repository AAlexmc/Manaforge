import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import '../theme/mf_theme.dart';
import '../widgets/common.dart';

/// Detalle de un mazo generado: plan de juego, curva (editable: arrastra las
/// barras y reforja el mazo a tu curva), "¿por qué funciona?", lista agrupada
/// y exportación como texto (Moxfield/Arena/Discord).
class DeckDetailScreen extends StatefulWidget {
  final fe.GeneratedDeck gen;
  final Map<String, fe.Card> pool;

  const DeckDetailScreen({super.key, required this.gen, required this.pool});

  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  late fe.GeneratedDeck _gen;
  bool _editingCurve = false;
  Map<int, int> _edited = {};

  @override
  void initState() {
    super.initState();
    _gen = widget.gen;
  }

  Map<String, fe.Card> get _pool => widget.pool;

  String _exportText() {
    final deck = _gen.deck;
    final buffer = StringBuffer('${deck.name} · 60 cartas\n');
    final sorted = deck.cards.entries.toList()
      ..sort((a, b) => (_pool[a.key]!.cmc).compareTo(_pool[b.key]!.cmc));
    for (final e in sorted) {
      buffer.writeln('${e.value} ${e.key}');
    }
    deck.lands.forEach((name, qty) => buffer.writeln('$qty $name'));
    buffer.writeln('\nForjado con ManaForge');
    return buffer.toString();
  }

  Map<String, List<MapEntry<String, int>>> _grouped() {
    final groups = <String, List<MapEntry<String, int>>>{};
    for (final e in _gen.deck.cards.entries) {
      final types = _pool[e.key]!.types;
      final key = types.contains('Creature')
          ? 'Criaturas'
          : types.contains('Instant')
              ? 'Instantáneos'
              : types.contains('Sorcery')
                  ? 'Conjuros'
                  : types.contains('Enchantment')
                      ? 'Encantamientos'
                      : types.contains('Artifact')
                          ? 'Artefactos'
                          : 'Otros';
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
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✓ Mazo reforjado a tu curva — lista actualizada')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.reason!)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            tooltip: 'Copiar lista (Moxfield/Arena)',
            icon: const Icon(Icons.copy_all),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _exportText()));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        '✓ Lista copiada — pégala en Moxfield, Arena o Discord')));
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
              Text('${fe.themeName(_gen.theme)} · ${deck.archetype.name} · '
                  '$nSpells hechizos + $nLands tierras'),
            ],
          ),
          const SizedBox(height: 6),
          const Text('✓ Tienes todas las cartas',
              style: TextStyle(color: MFColors.success)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tu plan de juego',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final (turns, text) in fe.gamePlan(_gen))
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
                        child: Text('Curva de maná',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      if (!_editingCurve)
                        TextButton.icon(
                          onPressed: () => _startEditing(hist),
                          icon: const Icon(Icons.tune, size: 18),
                          label: const Text('Editar curva'),
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
                      'Arrastra las barras ↑↓ · $editedSpells hechizos → '
                      '$editedLands tierras'
                      '${editedLandsOk ? '' : '  (fuera del rango sano 20-27)'}',
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
                          label: const Text('Reforjar con esta curva'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () =>
                              setState(() => _editingCurve = false),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  ] else
                    CurveChart(histogram: hist, color: accent),
                  const SizedBox(height: 8),
                  Text('⛰ $nLands tierras · ✦ $nSpells hechizos · '
                      'Ø coste ${avg.toStringAsFixed(1)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ExpansionTile(
              title: const Text('¿Por qué este mazo funciona?',
                  style: TextStyle(color: MFColors.forge)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [Text(fe.whyItWorks(_gen, _pool))],
            ),
          ),
          const SizedBox(height: 12),
          for (final group in _grouped().entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Text(
                  '${group.key} (${group.value.fold(0, (a, e) => a + e.value)})'
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
                    Expanded(child: Text(e.key)),
                    Text(_pool[e.key]!.manaCost,
                        style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text('TIERRAS ($nLands)',
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
                  Expanded(child: Text(e.key)),
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
