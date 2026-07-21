/// Certificados por completar una expansión entera.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/certificate_store.dart';
import 'package:manaforge_app/services/certificates.dart';

void main() {
  const owned = {'aer': 194, 'kld': 50, 'fdn': 291};
  const totals = {'aer': 194, 'kld': 264, 'fdn': 291};
  const names = {
    'aer': 'Aether Revolt',
    'kld': 'Kaladesh',
    'fdn': 'Foundations',
  };

  test('solo certifica las expansiones que tienes ENTERAS', () {
    final certs = certificatesForSets(
      ownedBySet: owned,
      setTotals: totals,
      setNames: names,
      today: '2026-07-21',
    );
    expect(certs.map((c) => c.id), ['set:fdn', 'set:aer']); // más grande antes
    expect(certs.first.title, 'Foundations');
    expect(certs.first.cards, 291);
  });

  test('un set sin cartas en la base no certifica nada', () {
    final certs = certificatesForSets(
      ownedBySet: const {'xxx': 0},
      setTotals: const {'xxx': 0},
      setNames: const {},
      today: '2026-07-21',
    );
    expect(certs, isEmpty);
  });

  test('el código es estable y cambia con la fecha', () {
    expect(certificateCode('set:aer', '2026-07-21'),
        certificateCode('set:aer', '2026-07-21'));
    expect(certificateCode('set:aer', '2026-07-21'),
        isNot(certificateCode('set:aer', '2026-07-22')));
    expect(certificateCode('set:aer', '2026-07-21'), startsWith('MF-'));
  });

  test('la fecha se escribe en cristiano', () {
    expect(prettyDate('2026-07-21'), '21 de julio de 2026');
    expect(prettyDate('roto'), 'roto');
  });

  test('la fecha del certificado se sella la PRIMERA vez y no se re-sella',
      () {
    final store = CertificateStore();
    const cert = EarnedCertificate(
        id: 'set:aer',
        title: 'Aether Revolt',
        subtitle: 'Expansión completa',
        cards: 194,
        earnedAt: '2026-01-05');
    store.sync([cert]);
    final again = store.sync([cert.withDate('2026-09-09')]);
    expect(again.single.earnedAt, '2026-01-05');
    expect(store.count, 1);
  });

  test('guarda y relee del disco el nombre y las fechas', () async {
    final dir = Directory.systemTemp.createTempSync('mf_cert');
    addTearDown(() => dir.deleteSync(recursive: true));

    final store = CertificateStore(dataDir: dir);
    store.setOwnerName('  Ale  ');
    store.sync(const [
      EarnedCertificate(
          id: 'set:aer',
          title: 'Aether Revolt',
          subtitle: 'Expansión completa',
          cards: 194,
          earnedAt: '2026-01-05')
    ]);
    await store.pendingSave;

    final again = CertificateStore(dataDir: dir);
    await again.load();
    expect(again.ownerName, 'Ale'); // recortado
    expect(again.earnedAt['set:aer'], '2026-01-05');
  });
}
