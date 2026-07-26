import 'models.dart';

/// Clasificador de tierras — espejo 1:1 de `engine-reference/forge/lands.py`.
///
/// Fase 1 (maná): shocks/checks/fetches y demás no-básicas de la colección
/// entran en la manabase por función real, no solo básicas proporcionales.

enum TappedKind { never, conditional, always }

const Map<String, String> _basicTypeColor = {
  'Plains': 'W',
  'Island': 'U',
  'Swamp': 'B',
  'Mountain': 'R',
  'Forest': 'G',
};

const Set<String> _basicNames = {
  'Plains', 'Island', 'Swamp', 'Mountain', 'Forest', //
  'Snow-Covered Plains', 'Snow-Covered Island', 'Snow-Covered Swamp',
  'Snow-Covered Mountain', 'Snow-Covered Forest',
};

final RegExp _addClause = RegExp(r'add ([^\n.]*)');
final RegExp _sym = RegExp(r'\{([wubrgc])\}');
final RegExp _fetch = RegExp(r'search your library for ([^\n.]*land[^\n.]*)');
final RegExp _tappedRe = RegExp(r'enters (the battlefield )?tapped');

/// Línea del texto (delimitada por '\n') que contiene la posición [pos].
String _lineAt(String text, int pos) {
  final start = text.lastIndexOf('\n', pos) + 1;
  final nl = text.indexOf('\n', pos);
  final end = nl == -1 ? text.length : nl;
  return text.substring(start, end);
}

class LandProfile {
  final Set<String> produces; // WUBRG que puede dar (duales tipadas incluidas)
  final TappedKind tapped;
  final bool isFetch;
  final Set<String> fetches; // colores buscables; vacío + isFetch = básica genérica
  final bool isBasic;

  const LandProfile({
    required this.produces,
    required this.tapped,
    required this.isFetch,
    required this.fetches,
    required this.isBasic,
  });

  bool get isUtility => produces.isEmpty && !isFetch;

  /// ¿Cuenta como fuente de [color] en un mazo de [deckColors]?
  bool sourceOf(String color, String deckColors) =>
      produces.contains(color) ||
      (isFetch &&
          (fetches.isEmpty
              ? deckColors.contains(color)
              : fetches.contains(color)));

  static LandProfile fromCard(Card card) {
    final text = card.oracle.toLowerCase();

    final produces = <String>{};
    for (final sub in card.subtypes) {
      final c = _basicTypeColor[sub];
      if (c != null) produces.add(c);
    }
    for (final m in _addClause.allMatches(text)) {
      final clause = m.group(1)!;
      if (clause.contains('one mana of any color') ||
          clause.contains('mana of any one color')) {
        produces.addAll(const ['W', 'U', 'B', 'R', 'G']);
      }
      for (final s in _sym.allMatches(clause)) {
        final ch = s.group(1)!.toUpperCase();
        if (ch != 'C') produces.add(ch);
      }
    }

    var tapped = TappedKind.never;
    final tappedMatch = _tappedRe.firstMatch(text);
    if (tappedMatch != null) {
      final line = _lineAt(text, tappedMatch.start);
      tapped = (line.contains('unless') || line.contains(' if '))
          ? TappedKind.conditional
          : TappedKind.always;
    }

    var isFetch = false;
    final fetches = <String>{};
    final fetchMatch = _fetch.firstMatch(text);
    if (fetchMatch != null) {
      isFetch = true;
      final clause = fetchMatch.group(1)!;
      for (final entry in _basicTypeColor.entries) {
        if (clause.contains(entry.key.toLowerCase())) fetches.add(entry.value);
      }
    }

    final isBasic =
        card.types.contains('Basic') || _basicNames.contains(card.name);

    // Básicas "de cortesía" de la app: sin oracle ni subtipos. El color
    // sale del nombre, o la manabase entera se queda sin candidatas.
    if (produces.isEmpty && isBasic) {
      final c = _basicTypeColor[card.name.replaceFirst('Snow-Covered ', '')];
      if (c != null) produces.add(c);
    }

    return LandProfile(
      produces: produces,
      tapped: tapped,
      isFetch: isFetch,
      fetches: fetches,
      isBasic: isBasic,
    );
  }
}
