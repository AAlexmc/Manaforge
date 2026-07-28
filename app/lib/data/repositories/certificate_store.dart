import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:manaforge_app/services/certificates.dart';
import 'package:manaforge_app/services/json_store_io.dart';

/// Cuándo conseguiste cada certificado y a nombre de quién sale.
///
/// La fecha se sella la PRIMERA vez que se ve completo: si mañana vendes una
/// carta y la vuelves a comprar, el certificado no se re-fecha.
class CertificateStore extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  CertificateStore({this.dataDir});

  final Map<String, String> _earnedAt = {}; // id -> 'YYYY-MM-DD'
  String _ownerName = '';
  FirstCard? _firstCard;
  Future<void>? _loading;

  Map<String, String> get earnedAt => Map.unmodifiable(_earnedAt);
  String get ownerName => _ownerName;

  /// La carta con la que empezaste en Magic, si has elegido una.
  FirstCard? get firstCard => _firstCard;

  /// Elegir (o quitar, con null) la carta del certificado de bienvenida.
  void setFirstCard(FirstCard? card) {
    if (card?.oracleId == _firstCard?.oracleId &&
        card?.image == _firstCard?.image) {
      return;
    }
    _firstCard = card;
    notifyListeners();
    _save();
  }
  int get count => _earnedAt.length;

  void setOwnerName(String name) {
    final clean = name.trim();
    if (clean == _ownerName) return;
    _ownerName = clean;
    notifyListeners();
    _save();
  }

  /// Cruza los certificados que TOCAN ahora mismo con las fechas guardadas:
  /// devuelve la lista con su fecha real y apunta los nuevos.
  List<EarnedCertificate> sync(List<EarnedCertificate> current) {
    var changed = false;
    final out = <EarnedCertificate>[];
    for (final cert in current) {
      final known = _earnedAt[cert.id];
      if (known == null) {
        _earnedAt[cert.id] = cert.earnedAt;
        changed = true;
        out.add(cert);
      } else {
        out.add(cert.withDate(known));
      }
    }
    if (changed) {
      notifyListeners();
      _save();
    }
    return out;
  }

  Map<String, dynamic> toJson() => {
        'earnedAt': _earnedAt,
        'ownerName': _ownerName,
        if (_firstCard != null) 'firstCard': _firstCard!.toJson(),
      };

  void restore(Map<String, dynamic> json) {
    _earnedAt.clear();
    final earned = json['earnedAt'];
    if (earned is Map) {
      earned.forEach((k, v) {
        if (k is String && v is String) _earnedAt[k] = v;
      });
    }
    final owner = json['ownerName'];
    _ownerName = owner is String ? owner : '';
    _firstCard = FirstCard.fromJson(json['firstCard']);
    notifyListeners();
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'certificates.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  /// Future memoizado: dos `load()` a la vez no pueden dejar el mapa vacío
  /// mientras `sync()` corre (re-sellaría todas las fechas a hoy).
  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    final file = await _file();
    if (file == null || !await file.exists()) return;
    // el try cubre SOLO la lectura y el decode: `restore()` no puede
    // apartar como roto un fichero que se ha leído perfectamente solo
    // porque algo DESPUÉS del decode (un listener, por ejemplo) revienta
    Map<String, dynamic>? decoded;
    try {
      final raw = jsonDecode(await file.readAsString());
      if (raw is Map<String, dynamic>) decoded = raw;
    } catch (_) {
      // fichero corrupto: apartarlo con otro nombre en vez de arrancar vacío
      // y escribirle encima — el nombre del dueño y los certificados no se
      // pierden sin rastro
      await setAsideBroken(file);
      return;
    }
    if (decoded != null) restore(decoded);
  }

  /// Cola de escrituras (dos guardados a la vez se pisan el temporal).
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

  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(toJson()), flush: true);
    await tmp.rename(file.path);
  }
}
