import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forge_engine/forge_engine.dart' as fe;

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/deck_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'deck_detail_screen.dart';

const _minCardsForForge = 30;

const _forgeMessages = [
  'Leyendo tu colección…',
  'Calculando la curva de maná…',
  'Repartiendo tierras…',
  'Buscando sinergias…',
  'Escribiendo tu plan de juego…',
];

/// Forge: el diferenciador. Estados: teaser (<30 cartas), selector, forjando
/// (mensajes rotatorios), resultados (carrusel) y "Forge no puede" con motivo.
class ForgeScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;

  const ForgeScreen(
      {super.key,
      required this.db,
      required this.collection,
      required this.decks});

  @override
  State<ForgeScreen> createState() => _ForgeScreenState();
}

class _ForgeScreenState extends State<ForgeScreen> {
  bool _assumeBasics = true;
  // Opciones del jugador: colores, arquetipo y presupuesto por carta
  final Set<String> _selColors = {};
  String? _selArchetype;
  double? _maxPriceEur;
  bool _forging = false;
  int _messageIndex = 0;
  Timer? _messageTimer;
  List<fe.GeneratedDeck>? _proposals;
  Map<String, fe.Card>? _pool;
  String? _cantReason;

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  Future<void> _forge() async {
    setState(() {
      _forging = true;
      _messageIndex = 0;
      _proposals = null;
      _cantReason = null;
    });
    _messageTimer =
        Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (mounted && _messageIndex < _forgeMessages.length - 1) {
        setState(() => _messageIndex++);
      }
    });
    try {
      final pool = await widget.db.buildPool(widget.collection.qtyByOracle,
          assumeBasics: _assumeBasics, maxPriceEur: _maxPriceEur);
      // pequeña pausa para que la animación cuente su historia
      await Future.delayed(const Duration(milliseconds: 2200));
      final proposals = fe.generateProposals(pool,
          allowedColors: _selColors.isEmpty ? null : _selColors.join(),
          archetypeOverride: _selArchetype);
      _messageTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _forging = false;
        _pool = pool;
        if (proposals.isEmpty) {
          _cantReason =
              'Con las cartas actuales no me sale ningún mazo completo de 60 '
              'que cumpla mis reglas (tierras suficientes, curva sana y solo '
              'cartas tuyas). Añade más cartas — sobre todo de tus colores '
              'principales — y vuelve a intentarlo. Antes que darte un mazo '
              'defectuoso, prefiero avisarte.';
        } else {
          _proposals = proposals;
        }
      });
    } catch (e) {
      _messageTimer?.cancel();
      if (mounted) {
        setState(() {
          _forging = false;
          _cantReason = 'No pude leer la base de datos de cartas: $e';
        });
      }
    }
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
            if (total < _minCardsForForge) return _buildTeaser(total);
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 8),
          const Text(
              'Mazos completos y jugables con las cartas que ya tienes. '
              'Sin comprar nada.'),
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
                const Text('cartas para tu primer mazo',
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: LinearProgressIndicator(
                    value: total / _minCardsForForge,
                    color: MFColors.forge,
                    backgroundColor: MFColors.forge.withValues(alpha: 0.15),
                  ),
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          const SizedBox(height: 8),
          const Text(
              'Mazos completos y jugables con las cartas que ya tienes. '
              'Sin comprar nada.'),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _assumeBasics,
            onChanged: (v) => setState(() => _assumeBasics = v),
            title: const Text('Cuento con tierras básicas sueltas'),
            subtitle: const Text(
                'Casi todo el mundo tiene básicas de mazos de inicio; '
                'desactívalo para usar SOLO las básicas de tu colección.'),
          ),
          const SizedBox(height: 12),
          Text('A tu gusto (opcional)',
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
                  hint: const Text('Arquetipo: auto',
                      style: TextStyle(fontSize: 12.5)),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12.5),
                  borderRadius: BorderRadius.circular(10),
                  items: const [
                    DropdownMenuItem(
                        value: null, child: Text('Arquetipo: auto')),
                    DropdownMenuItem(value: 'aggro', child: Text('Aggro')),
                    DropdownMenuItem(value: 'tempo', child: Text('Tempo')),
                    DropdownMenuItem(
                        value: 'midrange', child: Text('Midrange')),
                    DropdownMenuItem(
                        value: 'control', child: Text('Control')),
                  ],
                  onChanged: (v) => setState(() => _selArchetype = v),
                ),
              ),
              const SizedBox(width: 6),
              DropdownButtonHideUnderline(
                child: DropdownButton<double?>(
                  value: _maxPriceEur,
                  hint: const Text('Precio: sin límite',
                      style: TextStyle(fontSize: 12.5)),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12.5),
                  borderRadius: BorderRadius.circular(10),
                  items: const [
                    DropdownMenuItem(
                        value: null, child: Text('Precio: sin límite')),
                    DropdownMenuItem(
                        value: 1.0, child: Text('Cartas de ≤ 1 €')),
                    DropdownMenuItem(
                        value: 5.0, child: Text('Cartas de ≤ 5 €')),
                    DropdownMenuItem(
                        value: 10.0, child: Text('Cartas de ≤ 10 €')),
                  ],
                  onChanged: (v) => setState(() => _maxPriceEur = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _selColors.isEmpty
                ? 'Sin elegir colores, Forge prueba todas las combinaciones.'
                : 'Solo mazos ${_selColors.join("")} (y sus combinaciones).',
            style: const TextStyle(fontSize: 11.5),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                  'Forge solo usa tus ${widget.collection.totalCopies} cartas. '
                  'Nunca inventa copias que no tienes.'),
            ),
          ),
          const Spacer(),
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
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: MFColors.forge,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _forge,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Forjar mis mazos'),
          ),
        ],
      ),
    );
  }

  Widget _buildForging() {
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
          Text(_forgeMessages[_messageIndex],
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Todo se calcula en tu dispositivo, sin internet',
              style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final proposals = _proposals!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: Text('${proposals.length} mazos listos para jugar',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              TextButton.icon(
                onPressed: _forge,
                icon: const Icon(Icons.refresh),
                label: const Text('Reforjar'),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Hechos solo con tus cartas · desliza para comparar'),
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
                decks: widget.decks),
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

  const _ProposalCard(
      {required this.gen,
      required this.pool,
      required this.db,
      required this.decks});

  @override
  Widget build(BuildContext context) {
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
                    child: Text(deck.archetype.name.toUpperCase(),
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
              Text(fe.themeName(gen.theme)),
              const SizedBox(height: 14),
              MiniCurve(histogram: hist, color: accent),
              const SizedBox(height: 14),
              Expanded(
                child: Text('"${fe.tagline(gen)}"',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
              const Text('✓ Tienes todas las cartas',
                  style: TextStyle(color: MFColors.success, fontSize: 12)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => DeckDetailScreen(
                            gen: gen, pool: pool, db: db, decks: decks)),
                  ),
                  child: const Text('Ver mazo completo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
