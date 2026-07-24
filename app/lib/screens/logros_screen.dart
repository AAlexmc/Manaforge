import 'package:flutter/material.dart';

import '../l10n/t.dart';

import '../services/achievements.dart';
import '../services/achievements_controller.dart';
import '../services/card_database.dart';
import '../services/certificate_store.dart';
import '../services/collection_store.dart';
import '../theme/mf_theme.dart';
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

  /// Keys del tour: la tarjeta de nivel y el botón que lleva a Certificados.
  /// Solo las pone la pantalla que abre el TOUR, nunca la que abre el
  /// usuario: dos LogrosScreen con la misma GlobalKey a la vez reventaría.
  final Key? nivelKey;
  final Key? certificadosKey;

  const LogrosScreen({
    super.key,
    required this.achievements,
    this.db,
    this.collection,
    this.certificates,
    this.nivelKey,
    this.certificadosKey,
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
        title: Text(tr(context).acRecalcTitle),
        content: Text(tr(context).acRecalcBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(tr(context).acCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(tr(context).acRecalc)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final removed = await widget.achievements.recalculate();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(removed == 0
          ? tr(context).acAllFine
          : tr(context).acRemovedN(removed)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context).acTitle),
        actions: [
          IconButton(
            tooltip: tr(context).acRecalcTooltip,
            icon: const Icon(Icons.refresh),
            onPressed: _recalculate,
          ),
          if (widget.db != null &&
              widget.collection != null &&
              widget.certificates != null)
            IconButton(
              key: widget.certificadosKey,
              tooltip: tr(context).acCertsTooltip,
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
              SliverToBoxAdapter(
                  child: KeyedSubtree(
                      key: widget.nivelKey, child: _levelCard(context, c))),
              SliverToBoxAdapter(child: _filters(context)),
              if (states.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text(tr(context).acNoneWithFilters)),
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
                        Text(levelTitle(tr(context), level.level),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text(tr(context).acUnlockedOf(
                            c.unlockedCount, c.totalCount, c.xp)),
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
                tr(context).acLevelLine(level.level,
                    level.xpForNext - level.xpInLevel, level.level + 1),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelBadge(BuildContext context, int level) {
    // el mismo morado que la tarjeta de nivel de Inicio: es el mismo dato en
    // dos sitios y tiene que verse igual (antes aquí salía rojo)
    const color = MFColors.forge;
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
            label: Text(tr(context).acAll),
            selected: _category == null,
            onSelected: (_) => setState(() => _category = null),
          ),
          for (final c in AchievementCategory.values)
            FilterChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(categoryIcon(c), size: 16),
              label: Text(categoryLabel(tr(context), c)),
              selected: _category == c,
              onSelected: (v) => setState(() => _category = v ? c : null),
            ),
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: const Icon(Icons.hourglass_bottom, size: 16),
            label: Text(tr(context).acIMissing),
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
        hidden ? tr(context).acSecret : a.title(tr(context)),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: locked ? Theme.of(context).disabledColor : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hidden ? tr(context).acSecretDesc : a.description(tr(context)),
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
            Text(
                tr(context).acProgressLine(state.progressLabel,
                    tierLabel(tr(context), a.tier), a.xp),
                style: const TextStyle(fontSize: 11)),
          ] else
            Text(
              tr(context).acDoneLine(
                  state.unlockedAt == null
                      ? ''
                      : tr(context).acOnDate(_date(state.unlockedAt!)),
                  tierLabel(tr(context), a.tier),
                  a.xp),
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
      title: Text(tr(context).acLevelUp(level.level)),
      content: Text(
        tr(context).acLevelUpBody(levelTitle(tr(context), level.level),
            achievements.unlockedCount, achievements.totalCount),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr(context).acOk),
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
            child: Text(tr(context).acSeeAchievements),
          ),
        ),
      ],
    ),
  );
}

/// Aviso de logro nuevo. Se llama tras cada refresco desde cualquier pantalla.
/// Cuánto se queda en pantalla el aviso de logro. Corto a propósito: es una
/// palmadita en la espalda, no algo que haya que leer entero.
const Duration kAchievementToast = Duration(seconds: 3);

void showAchievementToasts(
    BuildContext context, AchievementsController achievements) {
  final fresh = achievements.takeCelebrations();
  if (fresh.isEmpty) return;
  final messenger = ScaffoldMessenger.of(context);
  final first = fresh.first;
  final more = fresh.length - 1;
  // el aviso SUSTITUYE al que hubiera, no se pone en la cola detrás: escaneando
  // saltan varios logros seguidos y encolados se quedaban un buen rato en
  // pantalla, uno detrás de otro, tapando la barra de abajo
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
    duration: kAchievementToast,
    // OJO: `persist` vale `action != null` por defecto, así que un aviso CON
    // botón se queda en pantalla para siempre hasta que lo tocas. Es lo que
    // hacía que la enhorabuena por un logro se quedara tapando la barra de
    // abajo. Se dice que no a mano.
    persist: false,
    backgroundColor: tierColor(first.tier),
    content: Text(
      tr(context).acToast(
          first.title(tr(context)),
          more > 0 ? tr(context).acAndMore(more) : '',
          fresh.fold<int>(0, (s, a) => s + a.xp)),
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold),
    ),
    action: SnackBarAction(
      label: tr(context).versionSee,
      textColor: Colors.black,
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => LogrosScreen(achievements: achievements)),
      ),
    ),
  ));
}
