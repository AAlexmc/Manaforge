/// Wishlist del Mercado: cartas que el usuario quiere comprar, cada una
/// con su precio objetivo. Al refrescar precios, las que CAEN al objetivo
/// disparan una alerta in-app (una vez; si el precio vuelve a subir por
/// encima, la alerta se rearma). Persiste en wishlist.json igual que la
/// colección; sin plugin de rutas (tests) vive solo en memoria.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'json_store_io.dart';
import 'safe_input.dart';

class WishItem {
  final String oracleId;
  final String name;
  final String? printedName;
  final String? imageSmall;
  final String colors;
  double targetPrice;
  double? lastPrice;
  bool alerted;

  WishItem({
    required this.oracleId,
    required this.name,
    this.printedName,
    this.imageSmall,
    required this.colors,
    required this.targetPrice,
    this.lastPrice,
    this.alerted = false,
  });

  /// ¿Está ahora mismo a precio de compra?
  bool get inRange => lastPrice != null && lastPrice! <= targetPrice;

  Map<String, dynamic> toJson() => {
        'oracleId': oracleId,
        'name': name,
        if (printedName != null) 'printedName': printedName,
        if (imageSmall != null) 'imageSmall': imageSmall,
        'colors': colors,
        'targetPrice': targetPrice,
        if (lastPrice != null) 'lastPrice': lastPrice,
        'alerted': alerted,
      };

  factory WishItem.fromJson(Map<String, dynamic> json) => WishItem(
        oracleId: json['oracleId'] as String,
        name: json['name'] as String,
        printedName: json['printedName'] as String?,
        // las URLs se filtran al LEER: este fichero puede venir de una copia
        // restaurada que te haya pasado otra persona
        imageSmall: safeCardImageUrl(json['imageSmall'] as String?),
        colors: json['colors'] as String? ?? '',
        targetPrice: (json['targetPrice'] as num).toDouble(),
        lastPrice: (json['lastPrice'] as num?)?.toDouble(),
        alerted: json['alerted'] as bool? ?? false,
      );
}

class WishlistStore extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON (por defecto, la carpeta de datos
  /// de la app).
  final Directory? dataDir;

  WishlistStore({this.dataDir});

  final Map<String, WishItem> _items = {}; // por oracleId
  bool _loaded = false;

  List<WishItem> get items {
    final list = _items.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  bool contains(String oracleId) => _items.containsKey(oracleId);

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'wishlist.json'));
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
      final decoded = jsonDecode(await file.readAsString()) as List<dynamic>;
      _items.clear();
      for (final item in decoded) {
        final wish = WishItem.fromJson(item as Map<String, dynamic>);
        _items[wish.oracleId] = wish;
      }
      notifyListeners();
    } catch (_) {
      // archivo corrupto: apartarlo con otro nombre en vez de arrancar vacío
      // y sobrescribirlo con lo primero que se añada
      await setAsideBroken(file);
    }
  }

  final SaveQueue _saves = SaveQueue();

  /// Espera a que la cola de guardado vacíe (tests).
  @visibleForTesting
  Future<void> get pendingSave => _saves.pending;

  void _save() => _saves.schedule(_write);

  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    await writeJsonFile(file, jsonEncode([for (final i in items) i.toJson()]));
  }

  void add(WishItem item) {
    _items[item.oracleId] = item;
    _save();
    notifyListeners();
  }

  void remove(String oracleId) {
    _items.remove(oracleId);
    _save();
    notifyListeners();
  }

  void setTarget(String oracleId, double target) {
    final item = _items[oracleId];
    if (item == null) return;
    item.targetPrice = target;
    item.alerted = false; // objetivo nuevo, alerta rearmada
    _save();
    notifyListeners();
  }

  /// Cruza los precios actuales y devuelve los items que ACABAN de caer a
  /// su objetivo (no avisados aún). Los precios por encima del objetivo
  /// rearman su alerta.
  List<WishItem> updatePrices(Map<String, double> priceByOracle) {
    final hits = <WishItem>[];
    var touched = false;
    for (final item in _items.values) {
      final price = priceByOracle[item.oracleId];
      if (price == null) continue;
      touched = true;
      item.lastPrice = price;
      if (price <= item.targetPrice) {
        if (!item.alerted) {
          item.alerted = true;
          hits.add(item);
        }
      } else {
        item.alerted = false;
      }
    }
    if (touched) {
      _save();
      notifyListeners();
    }
    return hits;
  }
}
