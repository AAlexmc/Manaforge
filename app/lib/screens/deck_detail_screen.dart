import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import '../theme/mf_theme.dart';
import '../widgets/common.dart';

/// Detalle de un mazo generado: plan de juego, curva, "¿por qué funciona?",
/// lista agrupada y exportación como texto (Moxfield/Arena/Discord).
class DeckDetailScreen extends StatelessWidget {
  final fe.GeneratedDeck gen;
  final Map<String, fe.Card> pool;

  const DeckDetailScreen({super.key, required this.gen, required this.pool});

  String _exportText() {
    final deck = gen.deck;
    final buffer = StringBuffer('${deck.name} · 60 cartas\n');
    final sorted = deck.cards.entries.toList()
      ..sort((a, b) =>
          (pool[a.key]!.cmc).compareTo(pool[b.key]!.cmc));
    for (final e in sorted) {
      buffer.writeln('${e.value} ${e.key}');
    }
    deck.lands.forEach((name, qty) => buffer.writeln('$qty $name'));
    buffer.writeln('\nForjado con ManaForge');
    return buffer.toString();
  }

  Map<String, List<MapEntry<String, int>>> _grouped() {
    final groups = <String, List<MapEntry<String, int>>>{};
    for (final e in gen.deck.cards.entries) {
      final types = pool[e.key]!.types;
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
      list.sort(
          (a, b) => (pool[a.key]!.cmc).compareTo(pool[b.key]!.cmc));
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final deck = gen.deck;
    final hist = fe.ManaCurve.curveHistogram(deck.cards, pool, cap: 6);
    final accent = manaColors[deck.colors.isEmpty ? 'C' : deck.colors[0]] ??
        MFColors.forge;
    final nSpells = deck.cards.values.fold(0, (a, b) => a + b);
    final nLands = deck.lands.values.fold(0, (a, b) => a + b);
    final avg = fe.ManaCurve.averageCmc(deck.cards, pool);

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
              Text(
                  '${fe.themeName(gen.theme)} · ${deck.archetype.name} · '
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
                  for (final (turns, text) in fe.gamePlan(gen))
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
                  Text('Curva de maná',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  MiniCurve(histogram: hist, color: accent, height: 72),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      for (var cmc = 0; cmc <= 6; cmc++)
                        Expanded(
                            child: Text(cmc == 6 ? '6+' : '$cmc',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10))),
                    ],
                  ),
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
              children: [Text(fe.whyItWorks(gen, pool))],
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
                    Text(pool[e.key]!.manaCost,
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
          for (final e in gen.deck.lands.entries)
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
