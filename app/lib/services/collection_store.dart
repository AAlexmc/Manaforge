import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Máximo que admite DateTime.fromMillisecondsSinceEpoch: un valor mayor
/// (fichero editado a mano, otra versión) reventaría al pintar la fila.
const int _maxStamp = 8640000000000000;

int? _saneStamp(Object? raw) {
  final value = raw is num ? raw.toInt() : null;
  if (value == null || value.abs() > _maxStamp) return null;
  return value;
}

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

  /// Cuándo entró a la colección (ms desde época). Se refresca al añadir
  /// copias, así lo último que escaneas sale primero. null = colección
  /// anterior a esta versión: se trata como lo más antiguo.
  int? addedAt;

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
    this.addedAt,
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
        if (addedAt != null) 'addedAt': addedAt,
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
        addedAt: _saneStamp(json['addedAt']),
      );
}

/// Orden "lo último que tocaste, primero". Las cartas sin fecha (guardadas
/// por versiones anteriores) van al final, entre ellas por nombre. Vive
/// aquí para que la pantalla y el almacén ordenen EXACTAMENTE igual.
int compareByRecent(OwnedCard a, OwnedCard b) {
  final at = a.addedAt;
  final bt = b.addedAt;
  if (at == null && bt == null) return a.name.compareTo(b.name);
  if (at == null) return 1;
  if (bt == null) return -1;
  if (at != bt) return bt.compareTo(at);
  return a.name.compareTo(b.name);
}

/// Colección del usuario. Persistencia local en JSON (sin cuentas, sin nube:
/// tus cartas son tuyas). ChangeNotifier para que la UI reaccione.
class CollectionStore extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  CollectionStore({this.dataDir});

  final Map<String, OwnedCard> _cards = {}; // por oracleId

  /// Cantidades por impresión exacta, clave "set|nºcoleccionista".
  /// Las rellena el importador (el CSV trae el Scryfall ID): permiten que el
  /// álbum ilumine SOLO la ilustración que de verdad tienes.
  final Map<String, int> _printings = {};

  /// Cuántas de esas copias son FOIL (misma clave "set|nºcoleccionista").
  /// Lo rellena el importador con la columna `Foil` del CSV: el escáner no
  /// distingue el brillo, así que aquí solo entra lo importado.
  final Map<String, int> _foils = {};

  /// A qué carta pertenece cada impresión ("set|nº" -> oracleId). Sin esto,
  /// vender una carta dejaba sus ediciones contando en el valor total.
  final Map<String, String> _printingOwner = {};
  bool _loaded = false;

  /// ¿Sabemos qué impresiones exactas tiene el usuario? (Colecciones
  /// importadas antes de esta versión no lo saben: reimportar lo arregla.)
  bool get hasPrintingData => _printings.isNotEmpty;

  Map<String, int> get printingQty => Map.unmodifiable(_printings);

  Map<String, int> get foilPrintings => Map.unmodifiable(_foils);

  /// Copias foil que sabemos que tienes.
  int get foilCopies => _foils.values.fold(0, (a, b) => a + b);

  List<OwnedCard> get cards {
    final list = _cards.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  /// Las más recientemente añadidas primero (lo que acabas de escanear
  /// arriba del todo).
  List<OwnedCard> get cardsByRecent =>
      _cards.values.toList()..sort(compareByRecent);

  int get totalCopies =>
      _cards.values.fold(0, (a, c) => a + c.qty);

  int get distinctCards => _cards.length;

  Map<String, int> get qtyByOracle =>
      {for (final c in _cards.values) c.oracleId: c.qty};

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'collection.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  /// Carga la colección del disco. Se parsea TODO a variables locales y solo
  /// al final se vuelca al estado: si el fichero está a medias o una carta
  /// tiene un campo raro, la colección en memoria se queda como estaba en
  /// vez de vaciarse (y el siguiente `_save()` guardaría ese vacío).
  ///
  /// Si el JSON no se puede leer, se aparta una copia `.roto` antes de
  /// seguir: los datos del usuario no se tiran a la basura en silencio.
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      final cards = <String, OwnedCard>{};
      final printings = <String, int>{};
      final foils = <String, int>{};
      final owners = <String, String>{};
      // v1: lista de cartas · v2: {cards, printings} · v3: + foils/owners
      final list = decoded is List
          ? decoded
          : ((decoded as Map<String, dynamic>)['cards'] as List<dynamic>);
      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;
        try {
          final card = OwnedCard.fromJson(item);
          cards[card.oracleId] = card;
        } catch (_) {
          continue; // una carta mala no se lleva por delante las demás
        }
      }
      if (decoded is Map<String, dynamic>) {
        (decoded['printings'] as Map<String, dynamic>? ?? {}).forEach((k, v) {
          if (v is int) printings[k] = v;
        });
        (decoded['foils'] as Map<String, dynamic>? ?? {}).forEach((k, v) {
          if (v is int) foils[k] = v;
        });
        (decoded['printingOwner'] as Map<String, dynamic>? ?? {})
            .forEach((k, v) {
          if (v is String) owners[k] = v;
        });
      }
      _cards
        ..clear()
        ..addAll(cards);
      _printings
        ..clear()
        ..addAll(printings);
      _foils
        ..clear()
        ..addAll(foils);
      _printingOwner
        ..clear()
        ..addAll(owners);
      notifyListeners();
    } catch (e) {
      // fichero ilegible: apartarlo con otro nombre y arrancar vacío, pero
      // sin borrarlo (se puede recuperar a mano)
      try {
        await file.rename('${file.path}.roto');
      } catch (_) {/* si tampoco se puede renombrar, no hay más que hacer */}
    }
  }

  /// Cola de escrituras: importar un CSV llama a `add()` una vez por carta,
  /// y cientos de `writeAsString` a la vez sobre el MISMO fichero se pisan
  /// entre ellas (colección corrupta o a medias).
  Future<void> _queue = Future.value();

  void _save() {
    _queue = _queue.then((_) => _write()).catchError((Object _) {});
  }

  /// Espera a que la cola de guardado vacíe. Los `_save()` son
  /// fire-and-forget: sin esto, un test que mira el fichero puede llegar
  /// antes que la escritura (y fallar solo a veces, en la máquina lenta de
  /// turno).
  @visibleForTesting
  Future<void> get pendingSave => _queue;

  /// Temporal + rename: si la app muere a media escritura, la colección
  /// anterior sigue entera en disco.
  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    final data = jsonEncode({
      'cards': [for (final c in _cards.values) c.toJson()],
      'printings': _printings,
      'foils': _foils,
      'printingOwner': _printingOwner,
    });
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(data, flush: true);
    await tmp.rename(file.path);
  }

  /// [at] sella cuándo entra (por defecto, ahora): pasando el MISMO
  /// instante a todo un lote, sus cartas empatan y salen por nombre en vez
  /// de en el orden en que se recorrió la lista.
  ///
  /// [bump] = false deja intacta la fecha de una carta que YA tenías y solo
  /// le suma copias. Lo usa el importador de CSV: reimportar no debe
  /// re-sellar toda la colección (enterraría lo que acabas de escanear
  /// bajo 300 cartas viejas, y esa información no se recupera).
  ///
  /// [foil] marca que ESAS copias son foil (lo sabe el CSV de ManaBox).
  void add(OwnedCard card,
      {int qty = 1,
      String? printingKey,
      DateTime? at,
      bool bump = true,
      bool foil = false}) {
    final stamp = (at ?? DateTime.now()).millisecondsSinceEpoch;
    final existing = _cards[card.oracleId];
    if (existing != null) {
      existing.qty += qty;
      if (bump) existing.addedAt = stamp; // volver a tocarla la sube arriba
    } else {
      _cards[card.oracleId] = card
        ..qty = qty
        ..addedAt = stamp;
    }
    if (printingKey != null && printingKey.isNotEmpty) {
      _printings[printingKey] = (_printings[printingKey] ?? 0) + qty;
      _printingOwner[printingKey] = card.oracleId;
      if (foil) _foils[printingKey] = (_foils[printingKey] ?? 0) + qty;
    }
    notifyListeners();
    _save();
  }

  /// Rellena el mapa impresión -> carta para las colecciones importadas
  /// ANTES de que existiera (las de Ale, por ejemplo). Lo llaman las
  /// pantallas que ya piden ese mapa a la base de cartas, así no cuesta una
  /// consulta extra. No avisa a nadie: no cambia lo que se ve, solo permite
  /// que vender una carta baje también sus copias por edición.
  void backfillPrintingOwners(Map<String, String> owners) {
    var changed = false;
    owners.forEach((key, oracleId) {
      if (!_printings.containsKey(key)) return;
      if (_printingOwner[key] == oracleId) return;
      _printingOwner[key] = oracleId;
      changed = true;
    });
    if (changed) _save();
  }

  /// Vacía la colección (modo "sustituir" del importador).
  void clear() {
    _cards.clear();
    _printings.clear();
    _foils.clear();
    _printingOwner.clear();
    notifyListeners();
    _save();
  }

  /// Cambia la cantidad; a 0 la elimina.
  ///
  /// Baja TAMBIÉN las copias por edición: si no, vender una carta la quitaba
  /// de la lista pero su precio seguía sumando en Inicio, Mercado y el total
  /// de Colección (y las foils nunca bajaban).
  void setQty(String oracleId, int qty) {
    if (qty <= 0) {
      _cards.remove(oracleId);
    } else {
      _cards[oracleId]?.qty = qty;
    }
    _trimPrintings(oracleId, qty < 0 ? 0 : qty);
    notifyListeners();
    _save();
  }

  /// Deja las copias por edición de [oracleId] sumando como mucho [qty],
  /// quitando de la última edición apuntada hacia atrás. Es una heurística:
  /// la app no sabe QUÉ edición concreta has vendido, pero es mucho mejor
  /// que dejar el contador inflado para siempre.
  void _trimPrintings(String oracleId, int qty) {
    final keys = [
      for (final e in _printingOwner.entries)
        if (e.value == oracleId) e.key
    ];
    if (keys.isEmpty) return;
    var total = keys.fold(0, (sum, k) => sum + (_printings[k] ?? 0));
    for (final key in keys.reversed) {
      if (total <= qty) break;
      final have = _printings[key] ?? 0;
      if (have == 0) continue;
      final drop = have < (total - qty) ? have : (total - qty);
      final left = have - drop;
      total -= drop;
      if (left <= 0) {
        _printings.remove(key);
        _foils.remove(key);
        _printingOwner.remove(key);
      } else {
        _printings[key] = left;
        final foil = _foils[key];
        // las foils no pueden pasar de las copias que quedan
        if (foil != null && foil > left) _foils[key] = left;
      }
    }
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
/// Quantity / Scryfall ID / Set name / Foil. Devuelve filas
/// (name, scryfallId, qty, setName, foil).
List<(String, String?, int, String?, bool)> parseManaBoxCsv(String content) {
  final lines = const LineSplitter().convert(content);
  if (lines.isEmpty) return const [];
  final sep = lines.first.contains(';') ? ';' : ',';
  final header = _splitCsvLine(lines.first, sep);
  int? nameIdx;
  int? qtyIdx;
  int? idIdx;
  int? setIdx;
  int? foilIdx;
  for (var i = 0; i < header.length; i++) {
    final h = header[i].toLowerCase().trim();
    if (h == 'name' || h == 'nombre') nameIdx = i;
    if (h == 'quantity' || h == 'cantidad' || h == 'qty' || h == 'count') {
      qtyIdx = i;
    }
    if (h == 'scryfall id') idIdx = i;
    if (h == 'set name' || h == 'edition' || h == 'edición') setIdx = i;
    if (h == 'foil') foilIdx = i;
  }
  if (nameIdx == null) return const [];
  final rows = <(String, String?, int, String?, bool)>[];
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
    // ManaBox escribe normal / foil / etched; las dos últimas brillan
    final finish = foilIdx != null && cols.length > foilIdx
        ? cols[foilIdx].trim().toLowerCase()
        : 'normal';
    final foil = finish == 'foil' || finish == 'etched';
    rows.add(
        (name, id != null && id.isNotEmpty ? id : null, qty, setName, foil));
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
