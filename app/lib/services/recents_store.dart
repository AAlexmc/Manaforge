import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'json_store_io.dart';

/// Una carta vista recientemente (ficha abierta).
class RecentCard {
  final String oracleId;
  final String name;
  final String? imageNormal;
  final String colors;

  const RecentCard({
    required this.oracleId,
    required this.name,
    this.imageNormal,
    this.colors = '',
  });

  Map<String, dynamic> toJson() => {
        'o': oracleId,
        'n': name,
        'i': imageNormal,
        'c': colors,
      };

  factory RecentCard.fromJson(Map<String, dynamic> json) => RecentCard(
        oracleId: json['o'] as String,
        name: json['n'] as String,
        imageNormal: json['i'] as String?,
        colors: (json['c'] as String?) ?? '',
      );
}

/// Historial de cartas visitadas (para la pantalla de Inicio). Local, 24 máx.
class RecentsStore extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON (por defecto, la carpeta de datos
  /// de la app).
  final Directory? dataDir;

  RecentsStore({this.dataDir});

  static const _max = 24;
  final List<RecentCard> _cards = [];
  bool _loaded = false;

  List<RecentCard> get cards => List.unmodifiable(_cards);

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'recents.json'));
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final list = jsonDecode(await file.readAsString()) as List<dynamic>;
      _cards
        ..clear()
        ..addAll([
          for (final item in list)
            RecentCard.fromJson(item as Map<String, dynamic>)
        ]);
      notifyListeners();
    } catch (_) {
      // corrupto: apartarlo, no escribirle encima
      await setAsideBroken(file);
    }
  }

  /// Olvida lo cargado. Se llama al restaurar una copia: este store es un
  /// singleton y NO se recrea con el resto de la app, así que sin esto seguía
  /// con la lista de antes y volvía a escribirla en cuanto abrieras una carta.
  void invalidate() {
    _loaded = false;
    _cards.clear();
    notifyListeners();
  }

  void record(RecentCard card) {
    _cards.removeWhere((c) => c.oracleId == card.oracleId);
    _cards.insert(0, card);
    while (_cards.length > _max) {
      _cards.removeLast();
    }
    notifyListeners();
    _save();
  }

  final SaveQueue _saves = SaveQueue();

  /// Espera a que la cola de guardado vacíe (tests).
  @visibleForTesting
  Future<void> get pendingSave => _saves.pending;

  void _save() => _saves.schedule(_write);

  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    await writeJsonFile(
        file, jsonEncode([for (final c in _cards) c.toJson()]));
  }
}

/// Instancia única (la ficha de carta se abre desde una docena de sitios;
/// un singleton evita pasar el store por todas partes).
final recentsStore = RecentsStore();
