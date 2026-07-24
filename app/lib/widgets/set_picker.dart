/// Elegir expansiones (los álbumes: en esta app un álbum ES una expansión).
///
/// Se usa en Forge para acotar de dónde salen las cartas del mazo. Enseña
/// cuántas casillas tienes de cada una porque es lo que decide si un álbum te
/// sirve para forjar: un set con 3 cartas tuyas no da mazo.
library;

import 'package:flutter/material.dart';

import '../l10n/t.dart';

import '../services/card_database.dart';

/// Abre la hoja y devuelve la selección nueva. `null` = cerrada sin tocar
/// nada, que NO es lo mismo que "ninguna expansión".
Future<Set<String>?> showSetPickerSheet(
  BuildContext context, {
  required List<SetInfo> sets,
  required Set<String> selected,
  Map<String, int> owned = const {},
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _SetPickerSheet(
        sets: sets, selected: selected, owned: owned),
  );
}

class _SetPickerSheet extends StatefulWidget {
  final List<SetInfo> sets;
  final Set<String> selected;
  final Map<String, int> owned;

  const _SetPickerSheet(
      {required this.sets, required this.selected, required this.owned});

  @override
  State<_SetPickerSheet> createState() => _SetPickerSheetState();
}

class _SetPickerSheetState extends State<_SetPickerSheet> {
  late final Set<String> _sel = {...widget.selected};
  final _searchCtrl = TextEditingController();
  String _query = '';

  /// Solo las expansiones de las que tienes algo. Empieza encendido porque
  /// con ~790 sets la lista entera no se recorre a mano — pero NO cuando no
  /// tienes nada: ahí dejaría la hoja vacía justo en el caso que estrena
  /// esto (hacer un mazo con cartas que no tienes).
  late bool _soloMias = widget.owned.values.any((v) => v > 0);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<SetInfo> get _visibles {
    final q = _query.trim().toLowerCase();
    final list = [
      for (final s in widget.sets)
        if ((!_soloMias || (widget.owned[s.code] ?? 0) > 0 ||
                _sel.contains(s.code)) &&
            (q.isEmpty ||
                s.name.toLowerCase().contains(q) ||
                s.code.toLowerCase().contains(q)))
          s
    ];
    // las que más tienes primero: son las que pueden dar mazo
    list.sort((a, b) {
      final oa = widget.owned[a.code] ?? 0;
      final ob = widget.owned[b.code] ?? 0;
      if (oa != ob) return ob.compareTo(oa);
      return a.name.compareTo(b.name);
    });
    return list;
  }

  @override
    Widget build(BuildContext context) {
    final t = tr(context);
    final visibles = _visibles;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(t.spWhichSets,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    hintText: t.spSearchHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(t.spOnlyMine),
                    selected: _soloMias,
                    onSelected: (v) => setState(() => _soloMias = v),
                  ),
                  const Spacer(),
                  if (_sel.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(_sel.clear),
                      child: Text(t.spClearN(_sel.length)),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              const Divider(height: 8),
              Expanded(
                child: visibles.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(t.spNoneNamed,
                              textAlign: TextAlign.center),
                        ),
                      )
                    : ListView.builder(
                        itemCount: visibles.length,
                        itemBuilder: (context, i) {
                          final s = visibles[i];
                          final tuyas = widget.owned[s.code] ?? 0;
                          return CheckboxListTile(
                            dense: true,
                            value: _sel.contains(s.code),
                            title: Text(s.name),
                            subtitle: Text(t.spSetLine(s.code.toUpperCase(), s.total) +
                                (tuyas > 0 ? ' · ${t.cdYouHaveX(tuyas)}' : '')),
                            onChanged: (v) => setState(() => v == true
                                ? _sel.add(s.code)
                                : _sel.remove(s.code)),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(_sel),
                        child: Text(_sel.isEmpty
                            ? t.spNoFilter
                            : t.spUseN(_sel.length)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(t.acCancel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
