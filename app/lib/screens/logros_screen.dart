import 'package:flutter/material.dart';

import '../services/achievements.dart';
import '../services/achievements_controller.dart';
import '../services/card_database.dart';
import '../services/certificate_store.dart';
import '../services/collection_store.dart';
import 'certificados_screen.dart';

/// Color de cada rareza de logro (bronce, plata, oro, mítico).
Color tierColor(AchievementTier tier) => switch (tier) {
      AchievementTier.bronze => const Color(0xFFCD7F32),
      AchievementTier.silver => const Color(0xFFB9C4CF),
      AchievementTier.gold => const Color(0xFFE8B93B),
      AchievementTier.mythic => const Color(0xFFEE6D3A),
    };

IconData categoryIcon(AchievementCategory c) => switch (c) {
      AchievementCategory.coleccion => Icons.style,
      AchievementCategory.rareza => Icons.diamond_outlined,
      AchievementCategory.color => Icons.palette_outlined,
      AchievementCategory.expansiones => Icons.auto_stories_outlined,
      AchievementCategory.valor => Icons.euro,
      AchievementCategory.foils => Icons.auto_awesome,
      AchievementCategory.forge => Icons.construction,
      AchievementCategory.escaner => Icons.qr_code_scanner,
      AchievementCategory.dedicacion => Icons.local_fire_department_outlined,
      AchievementCategory.carpetas => Icons.folder_outlined,
      AchievementCategory.curiosidades => Icons.emoji_objects_outlined,
    };

/// Pantalla de Logros: tu nivel, cuánto falta para el siguiente y todas las
/// medallas (las que no tienes, en gris y con lo que llevas).
class LogrosScreen extends StatefulWidget {
  final AchievementsController achievements;

  /// Si vienen, sale el acceso a los certificados descargables.
  final CardDatabase? db;
  final CollectionStore? collection;
  final CertificateStore? certificates;

  const LogrosScreen({
    super.key,
    required this.achievements,
    this.db,
    this.collection,
    this.certificates,
  });

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  AchievementCategory? _category; // null = todas
  bool _onlyPending = false;

  @override
  void initState() {
    super.initState();
    widget.achievements.refresh();
    // al entrar aquí ya has visto tu nivel: no hace falta celebrarlo dos veces
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.achievements.acknowledgeLevel();
    });
  }

  /// Quita los logros guardados que hoy no se cumplen (los que dio de más
  /// una versión con las cuentas mal).
  Future<void> _recalculate() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Recalcular logros?'),
        content: const Text(
            'Se vuelven a mirar tus cartas y se quitan los logros que hoy no '
            'se cumplan. Sirve para arreglar los que se dieron por error; si '
            'has vendido cartas, también perderás esos.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Recalcular')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final removed = await widget.achievements.recalculate();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(removed == 0
          ? 'Todo cuadraba: no se ha quitado ningún logro.'
          : 'Quitados $removed logros que ya no se cumplen.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logros'),
        actions: [
          IconButton(
            tooltip: 'Recalcular con mis cartas de ahora',
            icon: const Icon(Icons.refresh),
            onPressed: _recalculate,
          ),
          if (widget.db != null &&
              widget.collection != null &&
              widget.certificates != null)
            IconButton(
              tooltip: 'Certificados',
              icon: const Icon(Icons.workspace_premium_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CertificadosScreen(
                    db: widget.db!,
                    collection: widget.collection!,
                    certificates: widget.certificates!,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.achievements,
        builder: (context, _) {
          final c = widget.achievements;
          var states = c.states;
          if (_category != null) {
            states = states
                .where((s) => s.achievement.category == _category)
                .toList();
          }
          if (_onlyPending) {
            states = states.where((s) => !s.unlocked).toList();
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _levelCard(context, c)),
              SliverToBoxAdapter(child: _filters(context)),
              if (states.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                        child: Text('Nada por aquí con estos filtros.')),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: states.length,
                  itemBuilder: (context, i) =>
                      _AchievementTile(state: states[i]),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  Widget _levelCard(BuildContext context, AchievementsController c) {
    final level = c.level;
    final ratio =
        level.xpForNext == 0 ? 0.0 : level.xpInLevel / level.xpForNext;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _levelBadge(context, level.level),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(level.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text('${c.unlockedCount} de ${c.totalCount} logros · '
                            '${c.xp} XP'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                    value: ratio.clamp(0.0, 1.0), minHeight: 10),
              ),
              const SizedBox(height: 6),
              Text(
                'Nivel ${level.level} · faltan '
                '${level.xpForNext - level.xpInLevel} XP para el ${level.level + 1}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelBadge(BuildContext context, int level) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      width: 58,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.16),
        border: Border.all(color: color, width: 2),
      ),
      child: Text('$level',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _filters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          FilterChip(
            visualDensity: VisualDensity.compact,
            label: const Text('Todos'),
            selected: _category == null,
            onSelected: (_) => setState(() => _category = null),
          ),
          for (final c in AchievementCategory.values)
            FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(categoryIcon(c), size: 16),
              label: Text(c.label),
              selected: _category == c,
              onSelected: (v) => setState(() => _category = v ? c : null),
            ),
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: const Icon(Icons.hourglass_bottom, size: 16),
            label: const Text('Me faltan'),
            selected: _onlyPending,
            onSelected: (v) => setState(() => _onlyPending = v),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final AchievementState state;

  const _AchievementTile({required this.state});

  @override
  Widget build(BuildContext context) {
    final a = state.achievement;
    final color = tierColor(a.tier);
    final locked = !state.unlocked;
    final hidden = a.secret && locked;
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: locked
              ? Theme.of(context).disabledColor.withValues(alpha: 0.12)
              : color.withValues(alpha: 0.20),
          border: Border.all(
              color: locked
                  ? Theme.of(context).disabledColor.withValues(alpha: 0.35)
                  : color,
              width: 1.5),
        ),
        child: Icon(
          hidden ? Icons.help_outline : categoryIcon(a.category),
          size: 20,
          color: locked ? Theme.of(context).disabledColor : color,
        ),
      ),
      title: Text(
        hidden ? 'Logro secreto' : a.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: locked ? Theme.of(context).disabledColor : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hidden
                ? 'Se descubre solo cuando lo consigues.'
                : a.description,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (locked) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: state.progress, minHeight: 5),
            ),
            const SizedBox(height: 2),
            Text('${state.progressLabel} · ${a.tier.label} · ${a.xp} XP',
                style: const TextStyle(fontSize: 11)),
          ] else
            Text(
              '✓ Conseguido${state.unlockedAt == null ? '' : ' el ${_date(state.unlockedAt!)}'}'
              ' · ${a.tier.label} · ${a.xp} XP',
              style: TextStyle(fontSize: 11, color: color),
            ),
        ],
      ),
      isThreeLine: true,
    );
  }

  static String _date(DateTime d) {
    two(int n) => n < 10 ? '0$n' : '$n';
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}

/// Celebración de subida de nivel. Sale una sola vez por nivel: al cerrarla
/// (o al abrir Logros) queda dada por vista.
void showLevelUpDialog(
    BuildContext context, AchievementsController achievements) {
  final level = achievements.level;
  achievements.acknowledgeLevel();
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.military_tech, size: 40),
      title: Text('¡Nivel ${level.level}!'),
      content: Text(
        'Ya eres ${level.title}. Llevas ${achievements.unlockedCount} de '
        '${achievements.totalCount} logros.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vale'),
        ),
        Builder(
          builder: (context) => FilledButton(
            onPressed: () {
              // el navigator se coge ANTES del pop: después este context ya
              // está desactivado y buscar por él es inseguro
              final nav = Navigator.of(context);
              nav.pop();
              nav.push(MaterialPageRoute(
                  builder: (_) => LogrosScreen(achievements: achievements)));
            },
            child: const Text('Ver logros'),
          ),
        ),
      ],
    ),
  );
}

/// Aviso de logro nuevo. Se llama tras cada refresco desde cualquier pantalla.
void showAchievementToasts(
    BuildContext context, AchievementsController achievements) {
  final fresh = achievements.takeCelebrations();
  if (fresh.isEmpty) return;
  final messenger = ScaffoldMessenger.of(context);
  final first = fresh.first;
  final more = fresh.length - 1;
  messenger.showSnackBar(SnackBar(
    duration: const Duration(seconds: 4),
    backgroundColor: tierColor(first.tier),
    content: Text(
      '🏆 ¡Logro! ${first.title}'
      '${more > 0 ? ' (y $more más)' : ''} · +${fresh.fold<int>(0, (s, a) => s + a.xp)} XP',
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold),
    ),
    action: SnackBarAction(
      label: 'Ver',
      textColor: Colors.black,
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => LogrosScreen(achievements: achievements)),
      ),
    ),
  ));
}
