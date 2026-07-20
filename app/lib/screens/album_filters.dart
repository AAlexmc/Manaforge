/// Filtros y ordenación del álbum de expansiones: lógica pura, sin UI,
/// para poder testearla en CI.
library;

import '../services/card_database.dart';

/// Inicial de un set para el filtro por letra: A-Z en mayúscula, y todo lo
/// que no empiece por letra (números, símbolos) cae al cajón '#'.
String setInitial(String name) {
  if (name.isEmpty) return '#';
  final first = name[0].toUpperCase();
  return RegExp(r'[A-Z]').hasMatch(first) ? first : '#';
}

/// Años de lanzamiento presentes, descendentes y sin duplicados.
List<String> availableYears(List<SetInfo> sets) {
  final years = <String>{
    for (final s in sets)
      if (s.year.isNotEmpty) s.year,
  }.toList();
  years.sort((a, b) => b.compareTo(a));
  return years;
}

/// Aplica búsqueda, filtro por letra inicial, año, "con cartas mías" y la
/// ordenación elegida. [sort]: progreso · fecha · antiguas · nombre.
List<SetInfo> filterAlbumSets(
  List<SetInfo> sets, {
  String query = '',
  String? letter,
  String? year,
  bool onlyMine = false,
  Map<String, int> owned = const {},
  String sort = 'progreso',
}) {
  final q = query.toLowerCase();
  final visible = sets.where((s) {
    if (onlyMine && (owned[s.code] ?? 0) == 0) return false;
    if (letter != null && setInitial(s.name) != letter) return false;
    if (year != null && s.year != year) return false;
    if (q.isNotEmpty &&
        !s.name.toLowerCase().contains(q) &&
        !s.code.toLowerCase().contains(q)) {
      return false;
    }
    return true;
  }).toList();
  switch (sort) {
    case 'fecha':
      visible.sort(
          (a, b) => (b.releasedAt ?? '').compareTo(a.releasedAt ?? ''));
    case 'antiguas':
      // sin fecha → al final (no al principio, como haría '' en ascendente)
      visible.sort((a, b) =>
          (a.releasedAt ?? '9999').compareTo(b.releasedAt ?? '9999'));
    case 'nombre':
      visible.sort((a, b) => a.name.compareTo(b.name));
    default: // progreso: primero los que más completos llevas
      visible.sort((a, b) {
        final pa = (owned[a.code] ?? 0) / (a.total == 0 ? 1 : a.total);
        final pb = (owned[b.code] ?? 0) / (b.total == 0 ? 1 : b.total);
        return pb.compareTo(pa);
      });
  }
  return visible;
}
