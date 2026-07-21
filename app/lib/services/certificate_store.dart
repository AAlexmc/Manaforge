import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'certificates.dart';

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
  bool _loaded = false;

  Map<String, String> get earnedAt => Map.unmodifiable(_earnedAt);
  String get ownerName => _ownerName;
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

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, dynamic>) restore(decoded);
    } catch (_) {
      // fichero corrupto: sin certificados es mejor que no arrancar
    }
  }

  /// Cola de escrituras (dos guardados a la vez se pisan el temporal).
  Future<void> _queue = Future.value();

  void _save() {
    _queue = _queue.then((_) => _write()).catchError((Object _) {});
  }

  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(toJson()), flush: true);
    await tmp.rename(file.path);
  }
}
