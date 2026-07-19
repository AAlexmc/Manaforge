import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Una carta poseída (nivel Oracle) con los datos mínimos para pintarla
/// y filtrarla (coste, tipo, fuerza/resistencia).
class OwnedCard {
  final String oracleId;
  final String name;
  final String? printedName;
  final String? imageSmall;
  final String? imageNormal;
  final String colors;
  final String typeLine;
  final int cmc;
  final int? power;
  final int? toughness;
  int qty;

  OwnedCard({
    required this.oracleId,
    required this.name,
    this.printedName,
    this.imageSmall,
    this.imageNormal,
    required this.colors,
    this.typeLine = '',
    this.cmc = 0,
    this.power,
    this.toughness,
    required this.qty,
  });

  bool get isCreature => typeLine.contains('Creature');

  Map<String, dynamic> toJson() => {
        'oracleId': oracleId,
        'name': name,
        'printedName': printedName,
        'imageSmall': imageSmall,
        'imageNormal': imageNormal,
        'colors': colors,
        'typeLine': typeLine,
        'cmc': cmc,
        'power': power,
        'toughness': toughness,
        'qty': qty,
      };

  factory OwnedCard.fromJson(Map<String, dynamic> json) => OwnedCard(
        oracleId: json['oracleId'] as String,
        name: json['name'] as String,
        printedName: json['printedName'] as String?,
        imageSmall: json['imageSmall'] as String?,
        imageNormal: json['imageNormal'] as String?,
        colors: (json['colors'] as String?) ?? '',
        typeLine: (json['typeLine'] as String?) ?? '',
        cmc: (json['cmc'] as int?) ?? 0,
        power: json['power'] as int?,
        toughness: json['toughness'] as int?,
        qty: json['qty'] as int,
      );
}

/// Colección del usuario. Persistencia local en JSON (sin cuentas, sin nube:
/// tus cartas son tuyas). ChangeNotifier para que la UI reaccione.
class CollectionStore extends ChangeNotifier {
  final Map<String, OwnedCard> _cards = {}; // por oracleId

  /// Cantidades por impresión exacta, clave "set|nºcoleccionista".
  /// Las rellena el importador (el CSV trae el Scryfall ID): permiten que el
  /// álbum ilumine SOLO la ilustración que de verdad tienes.
  final Map<String, int> _printings = {};
  bool _loaded = false;

  /// ¿Sabemos qué impresiones exactas tiene el usuario? (Colecciones
  /// importadas antes de esta versión no lo saben: reimportar lo arregla.)
  bool get hasPrintingData => _printings.isNotEmpty;

  Map<String, int> get printingQty => Map.unmodifiable(_printings);

  List<OwnedCard> get cards {
    final list = _cards.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  int get totalCopies =>
      _cards.values.fold(0, (a, c) => a + c.qty);

  int get distinctCards => _cards.length;

  Map<String, int> get qtyByOracle =>
      {for (final c in _cards.values) c.oracleId: c.qty};

  Future<File?> _file() async {
    try {
      final dir = await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'collection.json'));
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
      final decoded = jsonDecode(await file.readAsString());
      _cards.clear();
      _printings.clear();
      // v1: lista de cartas · v2: {cards: [...], printings: {...}}
      final list = decoded is List
          ? decoded
          : ((decoded as Map<String, dynamic>)['cards'] as List<dynamic>);
      for (final item in list) {
        final card = OwnedCard.fromJson(item as Map<String, dynamic>);
        _cards[card.oracleId] = card;
      }
      if (decoded is Map<String, dynamic>) {
        final prints = decoded['printings'] as Map<String, dynamic>? ?? {};
        prints.forEach((k, v) => _printings[k] = v as int);
      }
      notifyListeners();
    } catch (_) {
      // archivo corrupto: mejor colección vacía que crash
    }
  }

  Future<void> _save() async {
    final file = await _file();
    if (file == null) return;
    await file.writeAsString(jsonEncode({
      'cards': [for (final c in _cards.values) c.toJson()],
      'printings': _printings,
    }));
  }

  void add(OwnedCard card, {int qty = 1, String? printingKey}) {
    final existing = _cards[card.oracleId];
    if (existing != null) {
      existing.qty += qty;
    } else {
      _cards[card.oracleId] = card..qty = qty;
    }
    if (printingKey != null && printingKey.isNotEmpty) {
      _printings[printingKey] = (_printings[printingKey] ?? 0) + qty;
    }
    notifyListeners();
    _save();
  }

  /// Vacía la colección (modo "sustituir" del importador).
  void clear() {
    _cards.clear();
    _printings.clear();
    notifyListeners();
    _save();
  }

  /// Cambia la cantidad; a 0 la elimina.
  void setQty(String oracleId, int qty) {
    if (qty <= 0) {
      _cards.remove(oracleId);
    } else {
      _cards[oracleId]?.qty = qty;
    }
    notifyListeners();
    _save();
  }
}

/// Resultado del importador de CSV (ManaBox y compatibles).
class ImportResult {
  final int imported;
  final int copies;
  final List<String> unrecognized;

  /// Tokens y emblemas del CSV: no son cartas de mazo, se ignoran a
  /// propósito (y se cuentan para poder decírselo al usuario).
  final int tokensIgnored;

  const ImportResult(this.imported, this.copies, this.unrecognized,
      {this.tokensIgnored = 0});
}

/// ¿Es una ficha/emblema? ManaBox los exporta desde sets "... Tokens"
/// (códigos TXXX) y los emblemas se llaman "... Emblem".
bool looksLikeToken(String name, String? setName) {
  final set = (setName ?? '').toLowerCase();
  return set.contains('token') ||
      set.contains('art series') ||
      set.contains('substitute') ||
      name.endsWith(' Emblem') ||
      name.toLowerCase() == 'emblem';
}

/// Parsea un CSV de ManaBox: detecta separador y las columnas Name /
/// Quantity / Scryfall ID / Set name. Devuelve filas
/// (name, scryfallId, qty, setName).
List<(String, String?, int, String?)> parseManaBoxCsv(String content) {
  final lines = const LineSplitter().convert(content);
  if (lines.isEmpty) return const [];
  final sep = lines.first.contains(';') ? ';' : ',';
  final header = _splitCsvLine(lines.first, sep);
  int? nameIdx;
  int? qtyIdx;
  int? idIdx;
  int? setIdx;
  for (var i = 0; i < header.length; i++) {
    final h = header[i].toLowerCase().trim();
    if (h == 'name' || h == 'nombre') nameIdx = i;
    if (h == 'quantity' || h == 'cantidad' || h == 'qty' || h == 'count') {
      qtyIdx = i;
    }
    if (h == 'scryfall id') idIdx = i;
    if (h == 'set name' || h == 'edition' || h == 'edición') setIdx = i;
  }
  if (nameIdx == null) return const [];
  final rows = <(String, String?, int, String?)>[];
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final cols = _splitCsvLine(line, sep);
    if (cols.length <= nameIdx) continue;
    final name = cols[nameIdx].trim();
    if (name.isEmpty) continue;
    final qty = qtyIdx != null && cols.length > qtyIdx
        ? int.tryParse(cols[qtyIdx].trim()) ?? 1
        : 1;
    final id = idIdx != null && cols.length > idIdx ? cols[idIdx].trim() : null;
    final setName =
        setIdx != null && cols.length > setIdx ? cols[setIdx].trim() : null;
    rows.add((name, id != null && id.isNotEmpty ? id : null, qty, setName));
  }
  return rows;
}

/// Split CSV respetando comillas ("Ruby, Daring Tracker").
List<String> _splitCsvLine(String line, String sep) {
  final out = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final ch = line[i];
    if (ch == '"') {
      inQuotes = !inQuotes;
    } else if (ch == sep && !inQuotes) {
      out.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(ch);
    }
  }
  out.add(buffer.toString());
  return out;
}
