/// El tour de bienvenida se enseña una vez: markSeen se guarda y se relee.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/data/repositories/onboarding_prefs.dart';

void main() {
  test('recién instalado, el tour no se ha visto', () async {
    final dir = Directory.systemTemp.createTempSync('mf_onb');
    addTearDown(() => dir.deleteSync(recursive: true));
    final prefs = OnboardingPreference(dataDir: dir);
    await prefs.load();
    expect(prefs.cargado, isTrue);
    expect(prefs.seen, isFalse);
  });

  test('markSeen se guarda y se relee del disco', () async {
    final dir = Directory.systemTemp.createTempSync('mf_onb');
    addTearDown(() => dir.deleteSync(recursive: true));

    final prefs = OnboardingPreference(dataDir: dir);
    await prefs.load();
    await prefs.markSeen();
    expect(prefs.seen, isTrue);

    final otra = OnboardingPreference(dataDir: dir);
    await otra.load();
    expect(otra.seen, isTrue, reason: 'no vuelve a salir tras verlo');
  });

  test('markSeen es idempotente', () async {
    final dir = Directory.systemTemp.createTempSync('mf_onb');
    addTearDown(() => dir.deleteSync(recursive: true));
    final prefs = OnboardingPreference(dataDir: dir);
    await prefs.load();
    await prefs.markSeen();
    await prefs.markSeen();
    expect(prefs.seen, isTrue);
  });

  test('un onboarding.json roto se lee como no-visto', () async {
    final dir = Directory.systemTemp.createTempSync('mf_onb');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/onboarding.json').writeAsStringSync('{ roto');

    final prefs = OnboardingPreference(dataDir: dir);
    await prefs.load();
    expect(prefs.seen, isFalse);
  });
}
