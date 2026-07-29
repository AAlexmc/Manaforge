import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/utils/safe_input.dart';

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
        // las URLs se filtran al LEER: este fichero puede venir de una copia
        // restaurada que te haya pasado otra persona, y una URL cualquiera
        // aquí hace que la app la pida sola al pintar el álbum
        imageSmall: safeCardImageUrl(json['imageSmall'] as String?),
        imageNormal: safeCardImageUrl(json['imageNormal'] as String?),
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

/// Lo pagado por unas copias concretas: coste MEDIO por copia, cuántas y en
/// qué divisa.
///
/// Las divisas no se mezclan ni se convierten (ver `services/markets.dart`):
/// pagar 10 $ y 10 € no son 20 de nada. Por eso la divisa entra en la clave.
class PurchaseLot {
  /// Impresión exacta ("set|nº") o "oracle:<id>" si el CSV no traía edición.
  final String base;

  /// Lo pagado por UNA copia.
  final double perCopy;

  /// Cuántas copias tienen ese coste apuntado. Puede ser menos que las que
  /// tienes: escanear no sabe lo que pagaste.
  final int qty;

  /// Divisa tal cual venía. `null` = el CSV no lo decía.
  final String? currency;

  const PurchaseLot({
    required this.base,
    required this.perCopy,
    required this.qty,
    required this.currency,
  });

  double get total => perCopy * qty;

  Map<String, dynamic> toJson() => {
        'base': base,
        'per': perCopy,
        'qty': qty,
        if (currency != null) 'cur': currency,
      };

  static PurchaseLot? fromJson(Map<String, dynamic> json) {
    final base = json['base'];
    final per = json['per'];
    final qty = json['qty'];
    if (base is! String || per is! num || qty is! int) return null;
    if (per <= 0 || qty <= 0 || !per.toDouble().isFinite) return null;
    return PurchaseLot(
      base: base,
      perCopy: per.toDouble(),
      qty: qty,
      currency: json['cur'] is String ? json['cur'] as String : null,
    );
  }
}

/// Clave con la que se guarda una compra: la impresión y su divisa. Sin la
/// divisa dentro, importar un CSV en dólares encima de uno en euros sumaría
/// peras con manzanas.
String purchaseKey(String base, String? currency) =>
    '$base@${currency ?? '?'}';

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

  /// Lo que PAGASTE, por impresión y divisa (clave de [purchaseKey]). Se
  /// guarda el coste MEDIO por copia: comprar la misma carta dos veces a
  /// precios distintos deja el promedio, que es lo que un P&L necesita.
  final Map<String, PurchaseLot> _paid = {};
  Future<void>? _loading;
  bool _cargado = false;

  /// ¿Sabemos qué impresiones exactas tiene el usuario? (Colecciones
  /// importadas antes de esta versión no lo saben: reimportar lo arregla.)
  bool get hasPrintingData => _printings.isNotEmpty;

  Map<String, int> get printingQty => Map.unmodifiable(_printings);

  /// A qué carta pertenece cada impresión conocida ("set|nº" -> oracleId).
  /// Sirve para saber si una carta con copias tiene ALGUNA edición asociada:
  /// sin ninguna, su precio no puede ser exacto (ver `collection_value.dart`).
  Map<String, String> get printingOwner => Map.unmodifiable(_printingOwner);

  Map<String, int> get foilPrintings => Map.unmodifiable(_foils);

  /// Copias foil que sabemos que tienes.
  int get foilCopies => _foils.values.fold(0, (a, b) => a + b);

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

  /// Copias por carta contando SOLO las impresiones de esas expansiones. Es
  /// lo que necesita Forge para "haz el mazo con lo que tengo de ESTOS
  /// álbumes", en vez de con toda la colección.
  ///
  /// Necesita saber de quién es cada impresión ([backfillPrintingOwners]).
  /// Una impresión sin dueño conocido no se cuenta: mejor quedarse corto que
  /// meter en el mazo una carta de otra expansión.
  Map<String, int> qtyByOracleInSets(Set<String> setCodes) {
    if (setCodes.isEmpty) return qtyByOracle;
    final codigos = {for (final c in setCodes) c.toLowerCase()};
    final out = <String, int>{};
    _printings.forEach((key, qty) {
      if (qty <= 0) return;
      final set = key.split('|').first.toLowerCase();
      if (!codigos.contains(set)) return;
      final oracleId = _printingOwner[key];
      if (oracleId == null) return;
      out[oracleId] = (out[oracleId] ?? 0) + qty;
    });
    // nunca más copias de las que tienes de verdad: si el mapa de dueños
    // está desfasado, la colección manda
    out.forEach((oracleId, qty) {
      final real = _cards[oracleId]?.qty;
      if (real != null && qty > real) out[oracleId] = real;
    });
    return out;
  }

  /// Copias por NOMBRE de carta. Lo usa el detalle del mazo para decir
  /// cuántas te faltan de verdad.
  Map<String, int> get qtyByName {
    final out = <String, int>{};
    for (final c in _cards.values) {
      out[c.name] = (out[c.name] ?? 0) + c.qty;
    }
    return out;
  }

  /// Lo pagado, por clave de compra. Solo lectura: para cambiarlo está
  /// [recordPurchase].
  Map<String, PurchaseLot> get purchases => Map.unmodifiable(_paid);

  /// ¿Hay algún precio de compra apuntado? Sin ninguno, el P&L no se enseña
  /// (un "has ganado un 100 %" calculado sobre cero es mentira).
  bool get hasPurchaseData => _paid.isNotEmpty;

  /// Lo que pagaste por UNA carta, sumando todas sus ediciones y agrupado por
  /// divisa (las divisas no se mezclan). Clave: 'EUR', 'USD'… o `null` si el
  /// CSV no lo decía.
  Map<String?, ({double total, int qty})> paidForCard(String oracleId) {
    final out = <String?, ({double total, int qty})>{};
    for (final lot in _paid.values) {
      final mia = lot.base == 'oracle:$oracleId' ||
          _printingOwner[lot.base] == oracleId;
      if (!mia) continue;
      final antes = out[lot.currency];
      out[lot.currency] = antes == null
          ? (total: lot.total, qty: lot.qty)
          : (total: antes.total + lot.total, qty: antes.qty + lot.qty);
    }
    return out;
  }

  /// Apunta lo que pagaste por [qty] copias, a [perCopy] cada una. Si ya
  /// había compras de esa misma impresión y divisa, el coste queda en el
  /// PROMEDIO ponderado por copias.
  ///
  /// [base] es la impresión exacta ("set|nº") cuando se sabe, o
  /// "oracle:<id>" cuando el CSV no traía el Scryfall ID.
  void recordPurchase({
    required String base,
    required int qty,
    required double perCopy,
    String? currency,
  }) {
    if (!_recordPurchase(base, qty, perCopy, currency)) return;
    _notifyAndSave();
  }

  /// La cuenta, sin avisar a nadie. Aparte para que importar un CSV no dé
  /// DOS avisos por fila (uno al añadir la carta y otro al apuntar lo
  /// pagado): cada aviso hace que el Álbum recalcule sus casillas contra la
  /// base, y con 300 filas eso se nota.
  ///
  /// Devuelve si ha cambiado algo.
  bool _recordPurchase(
      String base, int qty, double perCopy, String? currency) {
    if (qty <= 0 || perCopy <= 0 || !perCopy.isFinite) return false;
    final divisa = (currency == null || currency.trim().isEmpty)
        ? null
        : currency.trim().toUpperCase();
    final key = purchaseKey(base, divisa);
    final antes = _paid[key];
    _paid[key] = antes == null
        ? PurchaseLot(
            base: base, perCopy: perCopy, qty: qty, currency: divisa)
        : PurchaseLot(
            base: base,
            perCopy: (antes.perCopy * antes.qty + perCopy * qty) /
                (antes.qty + qty),
            qty: antes.qty + qty,
            currency: divisa,
          );
    return true;
  }

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
  ///
  /// Memoizado en [_loading]: con un `bool` marcado ANTES de leer, un segundo
  /// `load()` mientras el primero seguía en el disco volvía enseguida con la
  /// colección vacía (y algo que espere a `load()` para decidir cosas, como
  /// `hasExistingData`, se quedaba con un "no hay nada" falso).
  ///
  /// Una vez leído ([_cargado]), un `load()` posterior devuelve un futuro
  /// NUEVO en vez de reutilizar [_loading]: ese futuro nació en la zona de
  /// quien llamó primero (p. ej. el `runAsync` de un test), y esperarlo desde
  /// otra zona (el reloj falso de `testWidgets`) no vuelve — o tarda segundos
  /// reales en volver, que en una app de verdad son un arranque congelado.
  Future<void> load() => _cargado ? Future.value() : (_loading ??= _load());

  Future<void> _load() async {
    try {
      await _leer();
    } finally {
      _cargado = true;
    }
  }

  Future<void> _leer() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    var ok = false;
    try {
      final decoded = jsonDecode(await file.readAsString());
      final cards = <String, OwnedCard>{};
      final printings = <String, int>{};
      final foils = <String, int>{};
      final owners = <String, String>{};
      final paid = <String, PurchaseLot>{};
      // v1: lista de cartas · v2: {cards, printings} · v3: + foils/owners ·
      // v4: + paid (lo que pagaste)
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
        (decoded['paid'] as Map<String, dynamic>? ?? {}).forEach((k, v) {
          if (v is! Map<String, dynamic>) return;
          final lot = PurchaseLot.fromJson(v);
          // una compra ilegible se salta: no vale tirar toda la colección
          // por un número raro en un campo de dinero
          if (lot != null) paid[k] = lot;
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
      _paid
        ..clear()
        ..addAll(paid);
      ok = true;
    } catch (_) {
      // fichero ilegible: apartarlo con otro nombre y arrancar vacío, pero
      // sin borrarlo (se puede recuperar a mano)
      try {
        await file.rename('${file.path}.roto');
      } catch (_) {/* si tampoco se puede renombrar, no hay más que hacer */}
    }
    // fuera del try: si un listener revienta, NO se debe apartar como rota
    // una colección que se ha leído perfectamente
    if (ok) notifyListeners();
  }

  /// Lotes de importación en curso (contador: un lote anidado no puede
  /// "cerrar" el de fuera). Dentro de un lote los cambios NO avisan uno a
  /// uno: cada aviso hace que TODAS las pantallas vivas del IndexedStack
  /// (Inicio, Mercado, Álbum, Colección) recalculen contra la base de
  /// cartas; por fila del CSV eso era O(n²) y 308 cartas = minutos.
  int _lotes = 0;
  bool _loteSucio = false;

  /// Corre [fn] (los `add()`/`clear()` del importador) difiriendo los
  /// avisos: al terminar — también si [fn] revienta a mitad — avisa UNA
  /// vez, solo si algo cambió. El GUARDADO no se difiere: la cola de
  /// [_save] ya coalesce escrituras, y cortar la importación a mitad
  /// (cerrar la ventana, apagón) no debe perder lo ya importado.
  Future<T> importBatch<T>(Future<T> Function() fn) async {
    _lotes++;
    try {
      return await fn();
    } finally {
      _lotes--;
      if (_lotes == 0 && _loteSucio) {
        _loteSucio = false;
        notifyListeners();
      }
    }
  }

  /// Todo cambio de colección sale por aquí: en lote guarda pero calla.
  void _notifyAndSave() {
    _save();
    if (_lotes > 0) {
      _loteSucio = true;
      return;
    }
    notifyListeners();
  }

  /// Cola de escrituras: importar un CSV llama a `add()` una vez por carta,
  /// y cientos de `writeAsString` a la vez sobre el MISMO fichero se pisan
  /// entre ellas (colección corrupta o a medias).
  Future<void> _queue = Future.value();
  bool _pendingSave = false;

  void _save() {
    // si ya hay una escritura encolada, esa verá el estado FINAL: encolar
    // otra solo repetiría el mismo JSON (importar 300 cartas encolaba 300)
    if (_pendingSave) return;
    _pendingSave = true;
    _queue = _queue.then((_) {
      _pendingSave = false;
      return _write();
    }).catchError((Object _) {
      _pendingSave = false; // la cola sigue viva si una escritura falla
    });
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
      'paid': {for (final e in _paid.entries) e.key: e.value.toJson()},
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
  /// [foil] marca que ESAS copias son foil (lo dice el propio CSV).
  /// [paidPerCopy] apunta de paso lo que pagaste por ESTAS copias (lo trae
  /// el propio CSV). Va aquí, y no en una llamada aparte, para que meter
  /// una fila del CSV sea UN solo aviso a la interfaz.
  void add(OwnedCard card,
      {int qty = 1,
      String? printingKey,
      DateTime? at,
      bool bump = true,
      bool foil = false,
      double? paidPerCopy,
      String? paidCurrency}) {
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
    if (paidPerCopy != null) {
      _recordPurchase(
          printingKey != null && printingKey.isNotEmpty
              ? printingKey
              : 'oracle:${card.oracleId}',
          qty,
          paidPerCopy,
          paidCurrency);
    }
    _notifyAndSave();
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
    _paid.clear();
    _notifyAndSave();
  }

  /// Cambia la cantidad; a 0 la elimina.
  ///
  /// Baja TAMBIÉN las copias por edición: si no, vender una carta la quitaba
  /// de la lista pero su precio seguía sumando en Inicio, Mercado y el total
  /// de Colección (y las foils nunca bajaban).
  ///
  /// Al SUBIR, repone la copia de más en la última impresión conocida (ver
  /// [_restorePrintings]): sin esto, bajar y volver a subir dejaba esa copia
  /// sin edición asociada, y una impresión sin precio vale 0 € para siempre
  /// sin que la valoración lo marque como aproximado.
  void setQty(String oracleId, int qty) {
    final before = _cards[oracleId]?.qty ?? 0;
    if (qty <= 0) {
      _cards.remove(oracleId);
    } else {
      _cards[oracleId]?.qty = qty;
    }
    final after = qty < 0 ? 0 : qty;
    // el orden importa: _trimPaid necesita saber de quién es cada impresión,
    // y _trimPrintings puede borrar justo esa pista
    _trimPaid(oracleId, after);
    // solo si la carta existe de verdad: _leer puede saltarse una carta mala
    // y dejar sus impresiones cargadas — reponer ahí crearía copias fantasma
    if (after > before && _cards.containsKey(oracleId)) {
      _restorePrintings(oracleId, after - before);
    }
    _trimPrintings(oracleId, after);
    _notifyAndSave();
  }

  /// Deja apuntadas como mucho [qty] copias compradas de [oracleId]: vender
  /// una carta se lleva su coste. Si no, el P&L seguiría contando lo que
  /// pagaste por algo que ya no tienes y el "has perdido X" sería falso.
  void _trimPaid(String oracleId, int qty) {
    final keys = [
      for (final e in _paid.entries)
        if (e.value.base == 'oracle:$oracleId' ||
            _printingOwner[e.value.base] == oracleId)
          e.key
    ];
    if (keys.isEmpty) return;
    var total = keys.fold(0, (sum, k) => sum + (_paid[k]?.qty ?? 0));
    for (final key in keys.reversed) {
      if (total <= qty) break;
      final lot = _paid[key];
      if (lot == null) continue;
      final drop = lot.qty < (total - qty) ? lot.qty : (total - qty);
      final left = lot.qty - drop;
      total -= drop;
      if (left <= 0) {
        _paid.remove(key);
      } else {
        _paid[key] = PurchaseLot(
            base: lot.base,
            perCopy: lot.perCopy, // el coste medio por copia no cambia
            qty: left,
            currency: lot.currency);
      }
    }
  }

  /// Repone [extra] copias en la ÚLTIMA impresión conocida de [oracleId] al
  /// subir la cantidad: el mismo criterio (por el final) con el que
  /// [_trimPrintings] recorta al bajarla. Sin ninguna impresión conocida no
  /// se inventa una: esa carta se queda sin edición hasta que se reimporte.
  void _restorePrintings(String oracleId, int extra) {
    final keys = [
      for (final e in _printingOwner.entries)
        if (e.value == oracleId) e.key
    ];
    if (keys.isEmpty) return;
    final key = keys.last;
    _printings[key] = (_printings[key] ?? 0) + extra;
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

/// Resultado del importador de CSV de colección.
class ImportResult {
  final int imported;
  final int copies;
  final List<String> unrecognized;

  /// Tokens y emblemas del CSV: no son cartas de mazo, se ignoran a
  /// propósito (y se cuentan para poder decírselo al usuario).
  final int tokensIgnored;

  /// Copias que traían precio de compra. Se dice al terminar: si el CSV no
  /// lo trae, el usuario tiene que saber POR QUÉ no le sale el P&L.
  final int withPurchasePrice;

  const ImportResult(this.imported, this.copies, this.unrecognized,
      {this.tokensIgnored = 0, this.withPurchasePrice = 0});
}

/// ¿Es una ficha/emblema? Hay apps de colección que los exportan desde sets "... Tokens"
/// (códigos TXXX) y los emblemas se llaman "... Emblem".
bool looksLikeToken(String name, String? setName) {
  final set = (setName ?? '').toLowerCase();
  return set.contains('token') ||
      set.contains('art series') ||
      set.contains('substitute') ||
      name.endsWith(' Emblem') ||
      name.toLowerCase() == 'emblem';
}

/// Una fila del CSV de colección ya interpretada.
class CollectionCsvRow {
  final String name;
  final String? scryfallId;
  final int qty;
  final String? setName;
  final bool foil;

  /// Lo que pagaste por UNA copia, si el CSV lo trae. `null` = la columna no
  /// estaba, o venía vacía, o era 0 (hay exportadores que escriben 0 cuando no lo saben, y
  /// tomarlo por "me salió gratis" convertiría cualquier carta en un chollo).
  final double? purchasePrice;

  /// Divisa de [purchasePrice] tal cual viene en el CSV. `null` = el CSV
  /// no lo dice. NUNCA se convierte a otra moneda.
  final String? currency;

  const CollectionCsvRow({
    required this.name,
    required this.scryfallId,
    required this.qty,
    required this.setName,
    required this.foil,
    this.purchasePrice,
    this.currency,
  });
}

/// Parsea el CSV exportado por una app de colección: detecta separador y las columnas Name /
/// Quantity / Scryfall ID / Set name / Foil / Purchase price (+ su divisa).
List<CollectionCsvRow> parseCollectionCsv(String content) {
  final lines = const LineSplitter().convert(content);
  if (lines.isEmpty) return const [];
  final sep = lines.first.contains(';') ? ';' : ',';
  final header = _splitCsvLine(lines.first, sep);
  int? nameIdx;
  int? qtyIdx;
  int? idIdx;
  int? setIdx;
  int? foilIdx;
  int? priceIdx;
  int? currencyIdx;
  for (var i = 0; i < header.length; i++) {
    final h = header[i].toLowerCase().trim();
    if (h == 'name' || h == 'nombre') nameIdx = i;
    if (h == 'quantity' || h == 'cantidad' || h == 'qty' || h == 'count') {
      qtyIdx = i;
    }
    if (h == 'scryfall id') idIdx = i;
    if (h == 'set name' || h == 'edition' || h == 'edición') setIdx = i;
    if (h == 'foil') foilIdx = i;
    // la divisa se mira ANTES que el precio: "purchase price currency"
    // también empieza por "purchase price"
    if (h == 'purchase price currency' || h == 'currency' || h == 'divisa') {
      currencyIdx = i;
    } else if (h == 'purchase price' ||
        h == 'precio de compra' ||
        h == 'price bought') {
      priceIdx = i;
    }
  }
  if (nameIdx == null) return const [];
  final rows = <CollectionCsvRow>[];
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
    // los exportadores escriben normal / foil / etched; las dos últimas brillan
    final finish = foilIdx != null && cols.length > foilIdx
        ? cols[foilIdx].trim().toLowerCase()
        : 'normal';
    final foil = finish == 'foil' || finish == 'etched';
    final price = priceIdx != null && cols.length > priceIdx
        ? _parseMoney(cols[priceIdx])
        : null;
    final currency = currencyIdx != null && cols.length > currencyIdx
        ? cols[currencyIdx].trim().toUpperCase()
        : null;
    rows.add(CollectionCsvRow(
      name: name,
      scryfallId: id != null && id.isNotEmpty ? id : null,
      qty: qty,
      setName: setName,
      foil: foil,
      purchasePrice: price,
      currency: currency == null || currency.isEmpty ? null : currency,
    ));
  }
  return rows;
}

/// Dinero de un CSV: acepta coma decimal (exportes en español) y descarta lo
/// que no sea un número positivo. 0 no es un precio: es "no lo sé".
double? _parseMoney(String raw) {
  final limpio = raw.trim().replaceAll(',', '.');
  if (limpio.isEmpty) return null;
  final value = double.tryParse(limpio);
  if (value == null || value <= 0 || !value.isFinite) return null;
  return value;
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
