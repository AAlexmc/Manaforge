import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/data/services/markets.dart';

/// En qué mercado quieres ver los precios. Se recuerda entre arranques
/// (`market.json`), como pidió Ale: elegir mercado en cada pantalla cada vez
/// sería un peaje.
class MarketPreference extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  MarketPreference({this.dataDir});

  Market _market = Market.cardmarket;
  Future<void>? _loading;

  Market get market => _market;

  void select(Market market) {
    if (market == _market) return;
    _market = market;
    notifyListeners();
    _save();
  }

  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, dynamic>) {
        _market = Market.byId(decoded['market'] as String?);
        notifyListeners();
      }
    } catch (_) {
      // fichero raro: se queda Cardmarket, que es el de siempre
    }
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'market.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  Future<void> _queue = Future.value();
  bool _pendingSave = false;

  void _save() {
    if (_pendingSave) return;
    _pendingSave = true;
    _queue = _queue.then((_) {
      _pendingSave = false;
      return _write();
    }).catchError((Object _) {
      _pendingSave = false;
    });
  }

  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode({'market': _market.id}), flush: true);
    await tmp.rename(file.path);
  }

  @visibleForTesting
  Future<void> get pendingSave => _queue;
}
