/// El aviso de "hay versión nueva".
///
/// Lo delicado aquí no es pedir un JSON: es que en ESTE repositorio conviven
/// las releases de la app y las de las bases de datos, y las bases son más
/// recientes. Coger "la última release" sin mirar la etiqueta haría que la
/// app se comparase con la base de precios.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manaforge_app/data/services/app_update.dart';

String _releases(List<Map<String, dynamic>> items) => jsonEncode(items);

Map<String, dynamic> _release(String tag,
        {String? url,
        String? name,
        String? body,
        bool draft = false,
        bool prerelease = false}) =>
    {
      'tag_name': tag,
      'html_url':
          url ?? 'https://github.com/AAlexmc/Manaforge/releases/tag/$tag',
      'name': name ?? 'ManaForge $tag',
      'body': body ?? 'notas',
      'draft': draft,
      'prerelease': prerelease,
    };

http.Client Function() _clienteQueDevuelve(String body, {int status = 200}) =>
    () => MockClient((_) async => http.Response(body, status,
        headers: {'content-type': 'application/json; charset=utf-8'}));

void main() {
  group('comparar versiones', () {
    test('compara números, no textos', () {
      // como texto "0.10.0" va ANTES que "0.9.0"; como versión, después
      expect(isNewerVersion('0.10.0', '0.9.0'), isTrue);
      expect(isNewerVersion('0.9.0', '0.10.0'), isFalse);
    });

    test('la misma versión no es más nueva', () {
      expect(isNewerVersion('0.3.0', '0.3.0'), isFalse);
      expect(compareVersions('1.2.3', '1.2.3'), 0);
    });

    test('aguanta v delante, +build detrás y trozos que faltan', () {
      expect(compareVersions('v1.2.0', '1.2.0'), 0);
      expect(compareVersions('1.2.0+7', '1.2.0'), 0);
      expect(compareVersions('2', '1.9.9'), greaterThan(0));
    });

    test('una etiqueta rara no se lee como versión del futuro', () {
      expect(isNewerVersion('latest', '0.3.0'), isFalse);
      expect(isNewerVersion('', '0.3.0'), isFalse);
    });
  });

  group('elegir la release de la app', () {
    test('ignora las releases de las bases de datos', () {
      final body = _releases([
        _release('price-db-latest'),
        _release('card-db-latest'),
        _release('scanner-db-latest'),
        _release('app-v0.2.0'),
      ]);

      expect(newestAppRelease(body)!.version, '0.2.0');
    });

    test('se queda con la más nueva, no con la primera', () {
      final body = _releases([
        _release('app-v0.9.0'),
        _release('app-v0.10.0'),
        _release('app-v0.3.0'),
      ]);

      expect(newestAppRelease(body)!.version, '0.10.0');
    });

    test('borradores y prereleases no cuentan', () {
      final body = _releases([
        _release('app-v9.0.0', draft: true),
        _release('app-v8.0.0', prerelease: true),
        _release('app-v0.2.0'),
      ]);

      expect(newestAppRelease(body)!.version, '0.2.0');
    });

    test('una dirección que no es del repo se descarta entera', () {
      final body = _releases([
        _release('app-v9.9.9', url: 'https://evil.example/pwn'),
        _release('app-v0.2.0'),
      ]);

      final release = newestAppRelease(body)!;
      expect(release.version, '0.2.0');
      expect(release.pageUrl, startsWith(kRepoUrlPrefix));
    });

    test('un ".." que normaliza fuera del repo se descarta entera', () {
      // en TEXTO empieza como toca, pero Uri.parse normaliza los ".." y
      // acaba en otro repositorio (mismo host: github.com)
      final body = _releases([
        _release('app-v9.9.9',
            url: 'https://github.com/AAlexmc/Manaforge/../../evil/repo'
                '/releases'),
        _release('app-v0.2.0'),
      ]);

      final release = newestAppRelease(body)!;
      expect(release.version, '0.2.0');
    });

    test('las notas se recortan: son texto de fuera', () {
      final body = _releases([
        _release('app-v0.2.0', body: 'x' * (kMaxNotesChars + 500)),
      ]);

      expect(newestAppRelease(body)!.notes.length, kMaxNotesChars + 1);
    });

    test('un JSON que no es lo esperado devuelve null, no revienta', () {
      expect(newestAppRelease('{"esto":"no es una lista"}'), isNull);
      expect(newestAppRelease('no soy json'), isNull);
      expect(newestAppRelease('[1, 2, 3]'), isNull);
    });
  });

  group('safeReleaseUri: se valida sobre la URI YA PARSEADA', () {
    test('la URL legítima de una release se acepta', () {
      const url = 'https://github.com/AAlexmc/Manaforge/releases/tag/'
          'app-v0.3.0';
      expect(safeReleaseUri(url), Uri.parse(url));
    });

    test('los enlaces fijos de Ajustes (buzón y donativos) pasan la guarda',
        () {
      // si un día cambian y la guarda los rechaza, las tarjetas de Ajustes
      // se quedarían mudas sin que nada avisara
      expect(safeReleaseUri(kSuggestionsUrl), Uri.parse(kSuggestionsUrl));
      expect(safeReleaseUri(kDonationsUrl), Uri.parse(kDonationsUrl));
    });

    test('un ".." que normaliza fuera del repo se rechaza', () {
      expect(
          safeReleaseUri('https://github.com/AAlexmc/Manaforge/../../evil/repo'
              '/releases'),
          isNull);
    });

    test('otro host, o http en vez de https, se rechaza', () {
      expect(
          safeReleaseUri('https://evil.example/AAlexmc/Manaforge/x'), isNull);
      expect(safeReleaseUri('http://github.com/AAlexmc/Manaforge/x'), isNull);
      expect(safeReleaseUri(null), isNull);
      expect(safeReleaseUri('no soy una url'), isNull);
    });

    test('un puerto explícito que no es el de https se rechaza', () {
      expect(safeReleaseUri('https://github.com:1337/AAlexmc/Manaforge/x'),
          isNull);
      // el puerto POR DEFECTO de https, puesto a mano, no es un ataque
      expect(safeReleaseUri('https://github.com:443/AAlexmc/Manaforge/x'),
          isNotNull);
    });

    test('userInfo ("usuario@") se rechaza: se vería en "copia el enlace"', () {
      expect(safeReleaseUri('https://user@github.com/AAlexmc/Manaforge/x'),
          isNull);
    });

    test(
        '"%2f" en el camino se rechaza (Uri.path lo deja SIN decodificar, '
        'así que el prefijo no lo caza)', () {
      // Uri.parse no convierte %2f en '/': el segmento entero
      // "x%2F..%2F..%2Fevil" queda DENTRO de /AAlexmc/Manaforge/ y el
      // `startsWith` de más arriba lo deja pasar. Solo esta comprobación
      // explícita lo para.
      expect(
          safeReleaseUri('https://github.com/AAlexmc/Manaforge/'
              'x%2f..%2f..%2fevil'),
          isNull);
      expect(
          safeReleaseUri('https://github.com/AAlexmc/Manaforge/'
              'x%2F..%2F..%2Fevil'),
          isNull);
    });

    test(
        '"%2e%2e%2f" en el camino se rechaza: Uri.path decodifica el '
        'punto (queda ".." literal) pero NO la barra, así que el tramo '
        'entero no colapsa y lo caza el chequeo de "%2f"', () {
      expect(
          safeReleaseUri('https://github.com/AAlexmc/Manaforge/'
              '%2e%2e%2f/evil'),
          isNull);
      expect(
          safeReleaseUri('https://github.com/AAlexmc/Manaforge/'
              '%2E%2E%2F/evil'),
          isNull);
      // otro % que no sea %2e/%2f (un espacio, p. ej.) no se rechaza
      expect(
          safeReleaseUri('https://github.com/AAlexmc/Manaforge/releases/'
              'tag/v%201'),
          isNotNull);
    });
  });

  group('cada cuánto se pregunta', () {
    final ahora = DateTime(2026, 7, 22, 18);

    test('la primera vez, sí', () {
      expect(shouldCheckForUpdate(now: ahora, lastCheck: null), isTrue);
    });

    test('hace un rato, no', () {
      expect(
          shouldCheckForUpdate(
              now: ahora, lastCheck: ahora.subtract(const Duration(hours: 3))),
          isFalse);
    });

    test('ayer, sí', () {
      expect(
          shouldCheckForUpdate(
              now: ahora, lastCheck: ahora.subtract(const Duration(days: 2))),
          isTrue);
    });

    test('una fecha del futuro no deja el aviso mudo para siempre', () {
      expect(
          shouldCheckForUpdate(
              now: ahora, lastCheck: ahora.add(const Duration(days: 400))),
          isTrue);
    });
  });

  group('el comprobador completo', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('mf-update'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('encuentra una versión más nueva y la recuerda', () async {
      final checker = AppUpdateChecker(
        dataDir: dir,
        currentVersion: '0.2.0',
        clientFactory: _clienteQueDevuelve(_releases([_release('app-v0.3.0')])),
      );

      final release = await checker.checkIfDue();

      expect(release?.version, '0.3.0');
      expect(checker.available?.version, '0.3.0');
      expect(File('${dir.path}/update.json').existsSync(), isTrue);
    });

    test('con la versión al día no avisa de nada', () async {
      final checker = AppUpdateChecker(
        dataDir: dir,
        currentVersion: '0.3.0',
        clientFactory: _clienteQueDevuelve(_releases([_release('app-v0.3.0')])),
      );

      expect(await checker.checkIfDue(), isNull);
    });

    test('no pregunta dos veces el mismo día', () async {
      var llamadas = 0;
      final checker = AppUpdateChecker(
        dataDir: dir,
        currentVersion: '0.2.0',
        clientFactory: () => MockClient((_) async {
          llamadas++;
          return http.Response(_releases([_release('app-v0.3.0')]), 200);
        }),
      );

      await checker.checkIfDue();
      await checker.checkIfDue();

      expect(llamadas, 1);
    });

    test('apagado, ni pregunta', () async {
      var llamadas = 0;
      final checker = AppUpdateChecker(
        dataDir: dir,
        currentVersion: '0.2.0',
        clientFactory: () => MockClient((_) async {
          llamadas++;
          return http.Response(_releases([_release('app-v0.3.0')]), 200);
        }),
      );

      await checker.setEnabled(false);
      await checker.checkIfDue();

      expect(llamadas, 0);
      expect(checker.available, isNull);
    });

    test('sin red no revienta ni deja aviso a medias', () async {
      final checker = AppUpdateChecker(
        dataDir: dir,
        currentVersion: '0.2.0',
        clientFactory: () =>
            MockClient((_) async => throw const SocketException('sin red')),
      );

      expect(await checker.checkIfDue(), isNull);
      expect(checker.available, isNull);
    });

    test('GitHub de morros (403) no cuenta como comprobado', () async {
      final checker = AppUpdateChecker(
        dataDir: dir,
        currentVersion: '0.2.0',
        clientFactory: _clienteQueDevuelve('rate limit', status: 403),
      );

      await checker.checkIfDue();

      expect(checker.available, isNull);
      expect(checker.lastCheck, isNull); // se volverá a intentar
    });

    test('el interruptor sobrevive a cerrar la app', () async {
      final uno = AppUpdateChecker(dataDir: dir, currentVersion: '0.2.0');
      await uno.setEnabled(false);

      final otro = AppUpdateChecker(dataDir: dir, currentVersion: '0.2.0');
      await otro.load();

      expect(otro.enabled, isFalse);
    });
  });

  group('la última versión vista', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('mf-vista'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('sin fichero de preferencias, es un primer arranque', () async {
      final checker = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      await checker.load();

      expect(checker.firstRun, isTrue);
      expect(checker.seenVersion, isNull);
    });

    test('darlas por vistas sobrevive a cerrar la app', () async {
      final uno = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      await uno.markNewsSeen();

      final otro = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      await otro.load();

      expect(otro.seenVersion, '0.3.0');
      expect(otro.firstRun, isFalse);
    });

    test('actualizar deja la versión vista por detrás', () async {
      final vieja = AppUpdateChecker(dataDir: dir, currentVersion: '0.2.0');
      await vieja.markNewsSeen();

      final nueva = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      await nueva.load();

      expect(nueva.seenVersion, '0.2.0'); // hay novedades que contar
    });

    test('dos load() a la vez: el segundo no se cuela con todo vacío',
        () async {
      // regresión: al arrancar hay DOS load() casi juntos (el aviso de
      // versión y el "qué hay de nuevo"). Con un `bool` puesto antes de leer
      // el disco, el segundo volvía sin `seenVersion` y las novedades no se
      // enseñaban en la versión que las estrena
      final uno = AppUpdateChecker(dataDir: dir, currentVersion: '0.2.0');
      await uno.markNewsSeen();

      final otro = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      unawaited(otro.load()); // el del aviso de versión, aún leyendo
      await otro.load(); // el del "qué hay de nuevo"

      expect(otro.seenVersion, '0.2.0');
      expect(otro.firstRun, isFalse);
    });

    test('apuntar la versión vista y apagar el aviso a la vez: no se pisan',
        () async {
      final uno = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      await Future.wait([uno.markNewsSeen(), uno.setEnabled(false)]);

      final otro = AppUpdateChecker(dataDir: dir, currentVersion: '0.3.0');
      await otro.load();

      expect(otro.seenVersion, '0.3.0');
      expect(otro.enabled, isFalse);
    });
  });
}
