import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Un mazo guardado desde Forge. Se persiste con lo necesario para volver a
/// abrirlo aunque la colección cambie (las cartas se releen de la DB).
class SavedDeck {
  final String id;
  final String name;
  final String colors;
  final String archetype; // nombre del enum (aggro, tempo…)
  final String theme;
  final double score;
  final Map<String, int> cards;
  final Map<String, int> lands;
  final String savedAt; // ISO-8601

  const SavedDeck({
    required this.id,
    required this.name,
    required this.colors,
    required this.archetype,
    required this.theme,
    required this.score,
    required this.cards,
    required this.lands,
    required this.savedAt,
  });

  factory SavedDeck.fromGenerated(fe.GeneratedDeck gen) {
    final now = DateTime.now();
    return SavedDeck(
      id: now.microsecondsSinceEpoch.toString(),
      name: gen.deck.name,
      colors: gen.deck.colors,
      archetype: gen.deck.archetype.name,
      theme: gen.theme,
      score: gen.score,
      cards: Map.of(gen.deck.cards),
      lands: Map.of(gen.deck.lands),
      savedAt: now.toIso8601String(),
    );
  }

  fe.GeneratedDeck toGenerated() => fe.GeneratedDeck(
        fe.Deck(
          name: name,
          colors: colors,
          archetype: fe.Archetype.values.firstWhere(
              (a) => a.name == archetype,
              orElse: () => fe.Archetype.midrange),
          cards: cards,
          lands: lands,
        ),
        theme,
        score,
      );

  int get totalSpells => cards.values.fold(0, (a, b) => a + b);
  int get totalLands => lands.values.fold(0, (a, b) => a + b);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colors': colors,
        'archetype': archetype,
        'theme': theme,
        'score': score,
        'cards': cards,
        'lands': lands,
        'savedAt': savedAt,
      };

  factory SavedDeck.fromJson(Map<String, dynamic> json) => SavedDeck(
        id: json['id'] as String,
        name: json['name'] as String,
        colors: (json['colors'] as String?) ?? '',
        archetype: (json['archetype'] as String?) ?? 'midrange',
        theme: (json['theme'] as String?) ?? 'goodstuff',
        score: ((json['score'] as num?) ?? 0).toDouble(),
        cards: Map<String, int>.from(json['cards'] as Map),
        lands: Map<String, int>.from(json['lands'] as Map),
        savedAt: (json['savedAt'] as String?) ?? '',
      );
}

/// Mazos guardados del usuario. Persistencia local en JSON, como la
/// colección: sin cuentas, sin nube.
class DeckStore extends ChangeNotifier {
  final List<SavedDeck> _decks = [];
  bool _loaded = false;

  List<SavedDeck> get decks => List.unmodifiable(_decks);

  Future<File?> _file() async {
    try {
      final dir = await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'decks.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final list = jsonDecode(await file.readAsString()) as List<dynamic>;
      _decks
        ..clear()
        ..addAll([
          for (final item in list)
            SavedDeck.fromJson(item as Map<String, dynamic>)
        ]);
      notifyListeners();
    } catch (_) {
      // archivo corrupto: mejor lista vacía que crash
    }
  }

  Future<void> _save() async {
    final file = await _file();
    if (file == null) return;
    await file
        .writeAsString(jsonEncode([for (final d in _decks) d.toJson()]));
  }

  void add(SavedDeck deck) {
    _decks.insert(0, deck); // el más reciente arriba
    notifyListeners();
    _save();
  }

  void remove(String id) {
    _decks.removeWhere((d) => d.id == id);
    notifyListeners();
    _save();
  }
}
