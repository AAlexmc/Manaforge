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

  test('cada certificado sabe de qué clase es (el texto lo pone la pantalla)',
      () {
    final sets = certificatesForSets(
      ownedBySet: owned,
      setTotals: totals,
      setNames: names,
      today: '2026-07-21',
    );
    expect(sets.first.kind, CertificateKind.setComplete);
    final bienvenida = welcomeCertificate(copies: 1, today: '2026-07-21');
    expect(bienvenida!.kind, CertificateKind.welcome);
  });

  test('la fecha del certificado se sella la PRIMERA vez y no se re-sella',
      () {
    final store = CertificateStore();
    const cert = EarnedCertificate(
        id: 'set:aer',
        title: 'Aether Revolt',
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
    // el título traducible ('Bienvenido al mundo de Magic') lo pone la
    // pantalla: el dato solo dice que es el de bienvenida
    expect(cert.title, '');
    expect(cert.kind, CertificateKind.welcome);
    expect(cert.earnedAt, '2026-07-21');
  });

  test('el de bienvenida no cuenta cartas: no es un certificado de cantidad',
      () {
    final cert = welcomeCertificate(copies: 283, today: '2026-07-21');

    expect(cert!.cards, 0);
  });

  test('guardar la fecha real del certificado conserva su clase', () {
    final cert = welcomeCertificate(copies: 1, today: '2026-07-21')!;

    final antiguo = cert.withDate('2026-01-05');

    expect(antiguo.kind, CertificateKind.welcome);
    expect(antiguo.earnedAt, '2026-01-05');
    expect(antiguo.code, certificateCode('bienvenida', '2026-01-05'));
  });

  test('los de expansión son de clase setComplete', () {
    final certs = certificatesForSets(
      ownedBySet: owned,
      setTotals: totals,
      setNames: names,
      today: '2026-07-21',
    );

    expect(certs.first.kind, CertificateKind.setComplete);
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

  // --- La carta con la que empezaste --------------------------------------

  test('sin elegir carta, el certificado de bienvenida no enseña ninguna', () {
    final store = CertificateStore(dataDir: Directory.systemTemp.createTempSync('mfcert'));
    addTearDown(() => store.dataDir!.deleteSync(recursive: true));

    expect(store.firstCard, isNull);
  });

  test('la carta elegida se guarda y se relee del disco', () async {
    final dir = Directory.systemTemp.createTempSync('mfcert');
    addTearDown(() => dir.deleteSync(recursive: true));
    final store = CertificateStore(dataDir: dir);

    store.setFirstCard(const FirstCard(
      oracleId: 'abc',
      name: 'Shivan Dragon',
      image: 'https://cards/shivan.jpg',
    ));
    await Future<void>.delayed(const Duration(milliseconds: 60));

    final otra = CertificateStore(dataDir: dir);
    await otra.load();

    expect(otra.firstCard?.oracleId, 'abc');
    expect(otra.firstCard?.name, 'Shivan Dragon');
    expect(otra.firstCard?.image, 'https://cards/shivan.jpg');
  });

  test('se puede quitar la carta elegida', () async {
    final dir = Directory.systemTemp.createTempSync('mfcert');
    addTearDown(() => dir.deleteSync(recursive: true));
    final store = CertificateStore(dataDir: dir);
    store.setFirstCard(
        const FirstCard(oracleId: 'abc', name: 'Shivan Dragon'));

    store.setFirstCard(null);
    await Future<void>.delayed(const Duration(milliseconds: 60));

    final otra = CertificateStore(dataDir: dir);
    await otra.load();
    expect(otra.firstCard, isNull);
  });

  test('un certificates.json viejo (sin carta) se lee sin romperse', () async {
    final dir = Directory.systemTemp.createTempSync('mfcert');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/certificates.json').writeAsStringSync(
        '{"earnedAt":{"set:aer":"2026-01-05"},"ownerName":"Ale"}');

    final store = CertificateStore(dataDir: dir);
    await store.load();

    expect(store.firstCard, isNull);
    expect(store.ownerName, 'Ale');
  });

  test('una carta guardada a medias (sin nombre) se ignora en vez de romper',
      () async {
    final dir = Directory.systemTemp.createTempSync('mfcert');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/certificates.json')
        .writeAsStringSync('{"firstCard":{"oracleId":"abc"}}');

    final store = CertificateStore(dataDir: dir);
    await store.load();

    expect(store.firstCard, isNull);
  });
}
