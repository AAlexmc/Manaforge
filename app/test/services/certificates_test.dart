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

  // --- Certificado de bienvenida -------------------------------------------

  test('sin ninguna carta no hay certificado de bienvenida', () {
    expect(welcomeCertificate(copies: 0, today: '2026-07-21'), isNull);
  });

  test('con la primera carta ya te llevas el de bienvenida', () {
    final cert = welcomeCertificate(copies: 1, today: '2026-07-21');

    expect(cert, isNotNull);
    expect(cert!.id, 'bienvenida');
    expect(cert.title, 'Bienvenido al mundo de Magic');
    expect(cert.heading, 'CERTIFICADO DE BIENVENIDA');
    expect(cert.earnedAt, '2026-07-21');
  });

  test('el de bienvenida no cuenta cartas: no es un certificado de cantidad',
      () {
    final cert = welcomeCertificate(copies: 283, today: '2026-07-21');

    expect(cert!.cards, 0);
  });

  test('guardar la fecha real del certificado conserva su encabezado', () {
    final cert = welcomeCertificate(copies: 1, today: '2026-07-21')!;

    final antiguo = cert.withDate('2026-01-05');

    expect(antiguo.heading, 'CERTIFICADO DE BIENVENIDA');
    expect(antiguo.earnedAt, '2026-01-05');
    expect(antiguo.code, certificateCode('bienvenida', '2026-01-05'));
  });

  test('los de expansión mantienen su encabezado de siempre', () {
    final certs = certificatesForSets(
      ownedBySet: owned,
      setTotals: totals,
      setNames: names,
      today: '2026-07-21',
    );

    expect(certs.first.heading, 'CERTIFICADO DE COLECCIÓN COMPLETA');
  });

  test('la bienvenida va la primera aunque los de expansión tengan más cartas',
      () {
    final certs = allCertificates(
      copies: 283,
      ownedBySet: owned,
      setTotals: totals,
      setNames: names,
      today: '2026-07-21',
    );

    expect(certs.first.id, 'bienvenida');
    expect(certs.length, greaterThan(1));
  });
}
