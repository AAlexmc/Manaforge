/// Filtros y orden de la colección. Viven aquí, fuera de la pantalla, para
/// que la lista completa ("Todas las cartas") y el selector de cartas de una
/// carpeta usen EXACTAMENTE el mismo código en vez de dos copias que se van
/// separando con el tiempo.
library;

import 'package:flutter/material.dart';

import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/t.dart';
import 'package:manaforge_app/data/repositories/collection_store.dart';
import 'package:manaforge_app/ui/core/widgets/common.dart';

/// Cómo se ordena la lista de la colección.
enum CollectionSort {
  /// Lo último que has escaneado o añadido, primero.
  recent,
  alpha,
  cmc,
  qty,
}

/// Cómo se llama cada orden en el idioma del usuario.
String sortLabel(AppLocalizations t, CollectionSort sort) => switch (sort) {
      CollectionSort.recent => t.cfSortRecent,
      CollectionSort.alpha => t.cfSortAlpha,
      CollectionSort.cmc => t.cfSortCmc,
      CollectionSort.qty => t.cfSortQty,
    };

/// Ordena una copia de [cards] según [sort]. Función pura (la colección ya
/// llega ordenada por nombre; aquí solo se reordena) para poder testearla.
List<OwnedCard> sortCollection(List<OwnedCard> cards, CollectionSort sort) {
  final list = [...cards];
  switch (sort) {
    case CollectionSort.alpha:
      list.sort((a, b) => a.name.compareTo(b.name));
    case CollectionSort.cmc:
      list.sort((a, b) {
        final c = a.cmc.compareTo(b.cmc);
        return c != 0 ? c : a.name.compareTo(b.name);
      });
    case CollectionSort.qty:
      list.sort((a, b) {
        final c = b.qty.compareTo(a.qty);
        return c != 0 ? c : a.name.compareTo(b.name);
      });
    case CollectionSort.recent:
      // mismo comparador que usa el almacén: una sola fuente de verdad
      list.sort(compareByRecent);
  }
  return list;
}

/// Los filtros de la colección: color, coste, tipo, ataque y defensa.
class CollectionFilters {
  /// W U B R G · 'C' = incolora
  final Set<String> colors;

  /// null = cualquiera · 6 = 6 o más
  final int? cmc;
  final String? type;
  final int? minPower;
  final int? minToughness;

  const CollectionFilters({
    this.colors = const {},
    this.cmc,
    this.type,
    this.minPower,
    this.minToughness,
  });

  bool get any =>
      colors.isNotEmpty ||
      cmc != null ||
      type != null ||
      minPower != null ||
      minToughness != null;

  List<OwnedCard> apply(List<OwnedCard> cards) {
    if (!any) return cards;
    return cards.where((c) {
      if (colors.isNotEmpty) {
        final colorless = c.colors.isEmpty;
        final matches = colors
            .any((f) => f == 'C' ? colorless : c.colors.contains(f));
        if (!matches) return false;
      }
      if (cmc != null) {
        if (cmc == 6 ? c.cmc < 6 : c.cmc != cmc) return false;
      }
      if (type != null && !c.typeLine.contains(type!)) return false;
      if (minPower != null && (c.power ?? -99) < minPower!) return false;
      if (minToughness != null && (c.toughness ?? -99) < minToughness!) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Los `clear*` hacen falta porque `null` significa "no lo cambies".
  CollectionFilters copyWith({
    Set<String>? colors,
    int? cmc,
    String? type,
    int? minPower,
    int? minToughness,
    bool clearCmc = false,
    bool clearType = false,
    bool clearMinPower = false,
    bool clearMinToughness = false,
  }) =>
      CollectionFilters(
        colors: colors ?? this.colors,
        cmc: clearCmc ? null : (cmc ?? this.cmc),
        type: clearType ? null : (type ?? this.type),
        minPower: clearMinPower ? null : (minPower ?? this.minPower),
        minToughness:
            clearMinToughness ? null : (minToughness ?? this.minToughness),
      );

  CollectionFilters cleared() => const CollectionFilters();
}

/// Chips de color + desplegables de coste/tipo/ataque/defensa.
class CollectionFilterBar extends StatelessWidget {
  final CollectionFilters value;
  final ValueChanged<CollectionFilters> onChanged;

  const CollectionFilterBar(
      {super.key, required this.value, required this.onChanged});

  /// Los tipos que se pueden filtrar: clave de Scryfall (en inglés, que es
  /// como vienen los datos) -> nombre para la persona.
  static Map<String, String> typeOptions(AppLocalizations t) => {
        'Creature': t.cfTypeCreature,
        'Instant': t.cfTypeInstant,
        'Sorcery': t.cfTypeSorcery,
        'Artifact': t.cfTypeArtifact,
        'Enchantment': t.cfTypeEnchantment,
        'Land': t.cfTypeLand,
      };

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final c in const ['W', 'U', 'B', 'R', 'G', 'C'])
          FilterChip(
            visualDensity: VisualDensity.compact,
            avatar: CircleAvatar(
                radius: 6,
                backgroundColor: c == 'C' ? Colors.blueGrey : manaColors[c]!),
            label: Text(c),
            selected: value.colors.contains(c),
            onSelected: (v) {
              final next = {...value.colors};
              v ? next.add(c) : next.remove(c);
              onChanged(value.copyWith(colors: next));
            },
          ),
        _dropdown<int?>(
          context,
          hint: t.cfCost,
          value: value.cmc,
          items: {
            null: t.cfCostAll,
            for (var i = 0; i <= 5; i++) i: t.cfCostN('$i'),
            6: t.cfCostN('6+'),
          },
          onChanged: (v) =>
              onChanged(value.copyWith(cmc: v, clearCmc: v == null)),
        ),
        _dropdown<String?>(
          context,
          hint: t.cfType,
          value: value.type,
          items: {null: t.cfTypeAll, ...typeOptions(t)},
          onChanged: (v) =>
              onChanged(value.copyWith(type: v, clearType: v == null)),
        ),
        _dropdown<int?>(
          context,
          hint: t.cfPower,
          value: value.minPower,
          items: {
            null: t.cfPowerAll,
            for (var i = 1; i <= 6; i++) i: t.cfPowerMin(i),
          },
          onChanged: (v) => onChanged(
              value.copyWith(minPower: v, clearMinPower: v == null)),
        ),
        _dropdown<int?>(
          context,
          hint: t.cfToughness,
          value: value.minToughness,
          items: {
            null: t.cfToughnessAll,
            for (var i = 1; i <= 6; i++) i: t.cfToughnessMin(i),
          },
          onChanged: (v) => onChanged(
              value.copyWith(minToughness: v, clearMinToughness: v == null)),
        ),
        if (value.any)
          TextButton.icon(
            onPressed: () => onChanged(value.cleared()),
            icon: const Icon(Icons.filter_alt_off, size: 16),
            label: Text(t.cfClear),
          ),
      ],
    );
  }
}

/// Desplegable compacto, el mismo que usaba la colección.
Widget _dropdown<T>(
  BuildContext context, {
  required String hint,
  required T value,
  required Map<T, String> items,
  required ValueChanged<T> onChanged,
}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton<T>(
      value: value,
      hint: Text(hint, style: const TextStyle(fontSize: 12.5)),
      style:
          Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.5),
      borderRadius: BorderRadius.circular(10),
      items: [
        for (final e in items.entries)
          DropdownMenuItem<T>(value: e.key, child: Text(e.value)),
      ],
      onChanged: (v) => onChanged(v as T),
    ),
  );
}

/// Selector de orden ("Ordenar por [ … ]").
class CollectionSortPicker extends StatelessWidget {
  final CollectionSort value;
  final ValueChanged<CollectionSort> onChanged;

  const CollectionSortPicker(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    return Row(
      children: [
        Text(t.cfSortBy, style: const TextStyle(fontSize: 12.5)),
        const SizedBox(width: 8),
        _dropdown<CollectionSort>(
          context,
          hint: t.cfSort,
          value: value,
          items: {for (final s in CollectionSort.values) s: sortLabel(t, s)},
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// "hoy", "ayer", "hace 3 días", o la fecha si es vieja.
String addedLabel(AppLocalizations t, int? addedAt, {DateTime? now}) {
  if (addedAt == null) return t.cfNoDate;
  final when = DateTime.fromMillisecondsSinceEpoch(addedAt);
  final today = now ?? DateTime.now();
  // los días civiles se cuentan en UTC: en hora local, el día del cambio
  // de hora dura 23 h y `inDays` lo trunca (ayer salía como "hoy")
  final days = DateTime.utc(today.year, today.month, today.day)
      .difference(DateTime.utc(when.year, when.month, when.day))
      .inDays;
  if (days <= 0) return t.cfToday;
  if (days == 1) return t.cfYesterday;
  if (days < 7) return t.cfDaysAgo(days);
  two(int n) => n < 10 ? '0$n' : '$n';
  return '${two(when.day)}/${two(when.month)}/${when.year}';
}
