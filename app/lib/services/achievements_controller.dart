import 'package:flutter/foundation.dart';

import 'achievement_snapshot.dart';
import 'achievement_store.dart';
import 'achievements.dart';
import 'card_database.dart';
import 'collection_store.dart';
import 'deck_store.dart';
import 'folder_store.dart';
import 'wishlist_store.dart';

/// El estado vivo de los logros: quién los evalúa, los guarda y avisa.
///
/// Vive en la app entera (lo crea `main`) para que Inicio y la pantalla de
/// Logros enseñen el MISMO nivel sin recalcularlo dos veces, y para que un
/// escaneo o una carpeta nueva actualicen el progreso al momento.
class AchievementsController extends ChangeNotifier {
  final CardDatabase db;
  final CollectionStore collection;
  final DeckStore decks;
  final FolderStore folders;
  final WishlistStore wishlist;
  final AchievementStore progress;

  AchievementsController({
    required this.db,
    required this.collection,
    required this.decks,
    required this.folders,
    required this.wishlist,
    required this.progress,
  }) {
    for (final source in [collection, decks, folders, wishlist]) {
      source.addListener(_scheduleRefresh);
    }
  }

  List<AchievementState> _states = const [];
  List<AchievementState> get states => _states;

  int _xp = 0;
  int get xp => _xp;

  ({int level, String title, int xpInLevel, int xpForNext}) get level =>
      levelFor(_xp);

  int get unlockedCount => _states.where((s) => s.unlocked).length;
  int get totalCount => kAchievements.length;

  /// Logros recién conseguidos pendientes de enseñar (los consume la UI).
  final List<Achievement> _toCelebrate = [];

  /// ¿Ha subido de nivel desde la última vez que se lo dijimos?
  bool get leveledUp => level.level > progress.lastSeenLevel;

  /// Refresco en marcha. Quien pida otro mientras tanto se engancha a este
  /// (que ya recogerá los cambios nuevos): así `await refresh()` siempre
  /// devuelve con el progreso al día, no a medias.
  Future<void>? _inFlight;
  bool _dirty = false;

  @override
  void dispose() {
    for (final source in [collection, decks, folders, wishlist]) {
      source.removeListener(_scheduleRefresh);
    }
    super.dispose();
  }

  /// Los almacenes avisan varias veces seguidas al importar un CSV: mejor
  /// una pasada al final que 300 consultas a la base de cartas.
  void _scheduleRefresh() => refresh();

  Future<void> refresh() {
    if (_inFlight != null) {
      _dirty = true;
      return _inFlight!;
    }
    final future = _refresh().whenComplete(() => _inFlight = null);
    _inFlight = future;
    return future;
  }

  Future<void> _refresh() async {
    // sin esto se evaluaría con el fichero de logros aún sin leer: los
    // logros viejos no estarían en `unlockedAt` y el guardado siguiente se
    // los llevaría por delante
    await progress.ready;
    do {
      _dirty = false;
      final snapshot = await gatherSnapshot(
        db: db,
        collection: collection,
        decks: decks,
        folders: folders,
        progress: progress,
        wishlistCards: wishlist.items.length,
      );
      final next =
          evaluateAchievements(snapshot, unlockedAt: progress.unlockedAt);
      final fresh = [
        for (final s in next)
          if (s.unlocked && !progress.unlockedAt.containsKey(s.achievement.id))
            s.achievement
      ];
      if (fresh.isNotEmpty) {
        progress.unlockAll(fresh.map((a) => a.id));
        _toCelebrate.addAll(fresh);
      }
      _states = next;
      _xp = totalXp(next);
    } while (_dirty);
    notifyListeners();
  }

  /// Vuelve a mirar la colección y quita los logros guardados que HOY no se
  /// cumplen. Es para arreglar los que se dieron por un cálculo malo (la
  /// rareza salía de todas las impresiones de la carta, no de las tuyas).
  /// Devuelve cuántos se han quitado.
  Future<int> recalculate() async {
    final snapshot = await gatherSnapshot(
      db: db,
      collection: collection,
      decks: decks,
      folders: folders,
      progress: progress,
      wishlistCards: wishlist.items.length,
    );
    // sin `unlockedAt`: solo cuenta lo que se cumple AHORA
    final live = evaluateAchievements(snapshot);
    final achievedNow = {
      for (final s in live)
        if (s.unlocked) s.achievement.id
    };
    final stale = [
      for (final id in progress.unlockedAt.keys)
        if (!achievedNow.contains(id)) id
    ];
    progress.forget(stale);
    _toCelebrate.clear(); // recalcular no es "conseguir"
    await refresh();
    return stale.length;
  }

  /// Se lleva los logros pendientes de avisar (y los da por avisados).
  List<Achievement> takeCelebrations() {
    final out = [..._toCelebrate];
    _toCelebrate.clear();
    return out;
  }

  /// El usuario ya ha visto su nivel: no volver a celebrarlo.
  void acknowledgeLevel() => progress.rememberLevel(level.level);

  // --- cosas que pasan y hay que apuntar ------------------------------------

  /// Cartas reconocidas por el escáner (foto o cámara). [perfect] = la
  /// tanda entera salió sin ninguna carta "para revisar".
  /// [copies] son copias añadidas (para "cartas escaneadas") y [distinct]
  /// cuántas cartas distintas salieron en esa tanda (para "página entera":
  /// 3 cartas x4 copias NO es una página de 9).
  void recordScan(
      {required int copies, required int distinct, bool perfect = false}) {
    if (copies <= 0) return;
    progress.bump(AchievementCounters.cardsScanned, copies);
    progress.raise(AchievementCounters.bestPhotoCards, distinct);
    if (perfect && distinct >= 9) {
      progress.bump(AchievementCounters.perfectScans);
    }
    refresh();
  }

  /// Un día más usando la app (para las rachas).
  void markActive() {
    progress.markDayActive();
    refresh();
  }
}
