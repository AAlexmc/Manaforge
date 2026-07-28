/// El fichero se aparta como `.roto` SOLO si el propio fichero es ilegible
/// (no decodifica) — nunca porque algo que corre DESPUÉS del decode (un
/// listener, por ejemplo) reviente. Antes, el `try` cubría también
/// `restore()` (que acaba en `notifyListeners()`), así que un fichero
/// PERFECTO podía acabar renombrado a `.roto` por un fallo ajeno a la
/// lectura. Mismo principio que ya documenta `collection_store.dart`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/achievement_store.dart';
import 'package:manaforge_app/data/repositories/certificate_store.dart';

/// Simula "algo revienta DESPUÉS de decodificar bien" sin depender de que
/// `ChangeNotifier.notifyListeners()` atrape la excepción de un listener
/// (la atrapa y solo la reporta: por eso un listener normal no basta para
/// reproducir el bug).
class _AchievementStoreQueRevienta extends AchievementStore {
  _AchievementStoreQueRevienta({super.dataDir});

  @override
  void restore(Map<String, dynamic> json) {
    super.restore(json);
    throw Exception('algo revienta después de leer bien');
  }
}

class _CertificateStoreQueRevienta extends CertificateStore {
  _CertificateStoreQueRevienta({super.dataDir});

  @override
  void restore(Map<String, dynamic> json) {
    super.restore(json);
    throw Exception('algo revienta después de leer bien');
  }
}

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mf-roto-decode'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('AchievementStore: un fichero perfecto no se aparta como roto aunque '
      'algo reviente después de leerlo', () async {
    final file = File('${dir.path}/achievements.json');
    file.writeAsStringSync(jsonEncode({
      'unlocked': {'copias-1': '2026-07-01T00:00:00.000'},
    }));

    final store = _AchievementStoreQueRevienta(dataDir: dir);
    await expectLater(store.load(), throwsException);

    expect(File('${file.path}.roto').existsSync(), isFalse,
        reason: 'el fichero se leyó perfectamente: no hay motivo para '
            'apartarlo');
    expect(file.existsSync(), isTrue);
    expect(store.unlockedAt.keys, ['copias-1'],
        reason: 'restore() sí llegó a aplicar los datos antes de reventar');
  });

  test('CertificateStore: un fichero perfecto no se aparta como roto aunque '
      'algo reviente después de leerlo', () async {
    final file = File('${dir.path}/certificates.json');
    file.writeAsStringSync(jsonEncode({
      'earnedAt': {'scan-1': '2026-07-01'},
      'ownerName': 'Ale',
    }));

    final store = _CertificateStoreQueRevienta(dataDir: dir);
    await expectLater(store.load(), throwsException);

    expect(File('${file.path}.roto').existsSync(), isFalse);
    expect(file.existsSync(), isTrue);
    expect(store.ownerName, 'Ale');
  });
}
