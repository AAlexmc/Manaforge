/// "Hay una versión nueva de ManaForge".
///
/// La app NO se actualiza sola: mira una vez al día si hay una release más
/// nueva y, si la hay, lo dice y abre la página de descargas. Descargar y
/// reemplazar el binario en caliente, sin firma y en tres sistemas
/// distintos, es justo la clase de cosa que rompe instalaciones ajenas.
///
/// Dos trampas que hay que tener presentes:
///
///  1. **`/releases/latest` de este repo NO es la app.** En el mismo
///     repositorio se publican las bases de datos (cartas, huellas, precios)
///     y esas releases son más recientes, así que "latest" devuelve una base.
///     Por eso se listan las releases y se filtran por la etiqueta `app-v*`.
///  2. Lo que llega es un JSON de fuera: la dirección que se abre en el
///     navegador se comprueba contra el repositorio de verdad en vez de
///     confiar en el campo que venga.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'backup.dart' show kAppVersion;
import 'safe_input.dart';

/// De dónde se pregunta. Fijo a propósito: no se acepta ninguna otra.
final Uri kReleasesApi = Uri.parse(
    'https://api.github.com/repos/AAlexmc/Manaforge/releases?per_page=30');

/// Toda dirección que la app pueda abrir tiene que empezar por aquí.
const String kRepoUrlPrefix = 'https://github.com/AAlexmc/Manaforge/';

/// Prefijo de las etiquetas de la APP (las bases usan otras).
const String kAppTagPrefix = 'app-v';

/// Cada cuánto se pregunta. Una release de escritorio no sale cada hora.
const Duration kUpdateCheckInterval = Duration(days: 1);

/// Tope de lo que se acepta leer de la API: la respuesta ronda los 50 KB.
const int kMaxReleasesBytes = 2 * 1024 * 1024;

/// Tope de las notas que se enseñan: son texto de fuera.
const int kMaxNotesChars = 4000;

/// Una release de la app, ya limpia.
class AppRelease {
  /// Versión sin la etiqueta: '0.3.0'.
  final String version;
  final String title;

  /// Notas de la release, recortadas.
  final String notes;

  /// Página de la release en GitHub (comprobada).
  final String pageUrl;

  const AppRelease({
    required this.version,
    required this.title,
    required this.notes,
    required this.pageUrl,
  });
}

/// Compara dos versiones `X.Y.Z`. Negativo si [a] es anterior a [b].
///
/// Compara NÚMEROS, no textos: "0.10.0" es posterior a "0.9.0" aunque como
/// texto vaya antes. Lo que no sea número cuenta como 0, que es lo que hace
/// que una etiqueta rara no se lea como una versión del futuro.
int compareVersions(String a, String b) {
  final pa = _parts(a);
  final pb = _parts(b);
  for (var i = 0; i < 3; i++) {
    if (pa[i] != pb[i]) return pa[i].compareTo(pb[i]);
  }
  return 0;
}

List<int> _parts(String version) {
  // '0.3.0+3', 'v0.3.0', '0.3.0-beta' -> [0, 3, 0]
  final limpio = version.trim().replaceFirst(RegExp('^v'), '');
  final core = limpio.split(RegExp('[+-]')).first;
  final trozos = core.split('.');
  return [
    for (var i = 0; i < 3; i++)
      i < trozos.length ? (int.tryParse(trozos[i].trim()) ?? 0) : 0
  ];
}

/// ¿Es [candidate] más nueva que [current]?
bool isNewerVersion(String candidate, String current) =>
    compareVersions(candidate, current) > 0;

/// La release de la APP más nueva del JSON de la API. `null` si no hay
/// ninguna (o si el JSON no es lo que se esperaba: aquí no se revienta).
AppRelease? newestAppRelease(String body) {
  List<dynamic> lista;
  try {
    final decoded = jsonDecode(body);
    if (decoded is! List) return null;
    lista = decoded;
  } catch (_) {
    return null;
  }
  AppRelease? mejor;
  for (final item in lista) {
    if (item is! Map<String, dynamic>) continue;
    if (item['draft'] == true || item['prerelease'] == true) continue;
    final tag = item['tag_name'];
    if (tag is! String || !tag.startsWith(kAppTagPrefix)) continue;
    final version = tag.substring(kAppTagPrefix.length).trim();
    if (version.isEmpty) continue;
    final url = item['html_url'];
    // la dirección que se va a abrir tiene que ser de ESTE repositorio
    if (url is! String || !url.startsWith(kRepoUrlPrefix)) continue;
    final notas = item['body'];
    final release = AppRelease(
      version: version,
      title: (item['name'] as String?)?.trim().isNotEmpty == true
          ? (item['name'] as String).trim()
          : 'ManaForge $version',
      notes: notas is String
          ? (notas.length > kMaxNotesChars
              ? '${notas.substring(0, kMaxNotesChars)}…'
              : notas)
          : '',
      pageUrl: url,
    );
    if (mejor == null || isNewerVersion(release.version, mejor.version)) {
      mejor = release;
    }
  }
  return mejor;
}

/// ¿Toca preguntar? Sin fecha anterior, sí (primer arranque).
bool shouldCheckForUpdate(
    {required DateTime now,
    DateTime? lastCheck,
    Duration interval = kUpdateCheckInterval}) {
  if (lastCheck == null) return true;
  // fecha del futuro (reloj cambiado, fichero manipulado): se pregunta igual
  // en vez de quedarse callado para siempre
  if (lastCheck.isAfter(now)) return true;
  return now.difference(lastCheck) >= interval;
}

/// Estado del aviso de versión nueva, persistido en `update.json`.
class AppUpdateChecker extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON.
  final Directory? dataDir;

  /// Solo para tests: cliente HTTP.
  final http.Client Function()? clientFactory;

  /// Versión que corre ahora mismo.
  final String currentVersion;

  AppUpdateChecker({
    this.dataDir,
    this.clientFactory,
    this.currentVersion = kAppVersion,
  });

  bool _enabled = true;
  DateTime? _lastCheck;
  AppRelease? _available;
  bool _loaded = false;

  /// Última versión de la app que el usuario llegó a VER (para enseñarle las
  /// novedades cuando abre una nueva). null = nunca se guardó: o es el primer
  /// arranque, o viene de una versión anterior a esto.
  String? _seenVersion;

  /// ¿Es el primer arranque de la app? Si `update.json` no existía, sí.
  bool _firstRun = false;

  String? get seenVersion => _seenVersion;

  bool get firstRun => _firstRun;

  /// Da por vistas las novedades de la versión que corre.
  Future<void> markNewsSeen() async {
    if (_seenVersion == currentVersion) return;
    _seenVersion = currentVersion;
    notifyListeners();
    await _save();
  }

  /// ¿Se mira si hay versión nueva? Apagable desde Ajustes.
  bool get enabled => _enabled;

  /// La versión nueva encontrada, si hay alguna más nueva que la que corre.
  AppRelease? get available => _available;

  DateTime? get lastCheck => _lastCheck;

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    if (!value) _available = null; // apagarlo también quita el aviso
    notifyListeners();
    await _save();
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final file = await _file();
    if (file == null || !await file.exists()) {
      _firstRun = true;
      return;
    }
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) return;
      final vista = decoded['seenVersion'];
      if (vista is String && vista.isNotEmpty) _seenVersion = vista;
      _enabled = decoded['enabled'] is bool ? decoded['enabled'] as bool : true;
      final ms = decoded['lastCheck'];
      if (ms is int && ms > 0) {
        _lastCheck = DateTime.fromMillisecondsSinceEpoch(ms);
      }
    } catch (_) {
      // fichero raro: se queda como de fábrica (encendido y sin fecha)
    }
  }

  /// Mira si hay versión nueva, como mucho una vez al día. Devuelve la
  /// release nueva si la hay.
  ///
  /// No lanza nunca: quedarse sin internet no es un error del usuario.
  Future<AppRelease?> checkIfDue({DateTime? now}) =>
      _check(now: now, force: false);

  /// Lo mismo, pero AHORA: es el botón de Ajustes. Pedirlo a mano y que no
  /// haga nada porque "ya toca mañana" sería un botón mentiroso. Funciona
  /// aunque el aviso automático esté apagado.
  Future<AppRelease?> checkNow() => _check(force: true);

  Future<AppRelease?> _check({DateTime? now, required bool force}) async {
    await load();
    final ahora = now ?? DateTime.now();
    if (!_enabled && !force) return null;
    if (!force && !shouldCheckForUpdate(now: ahora, lastCheck: _lastCheck)) {
      return _available;
    }
    final client = clientFactory?.call() ?? http.Client();
    try {
      // por secureSend y no por client.get: package:http sigue las
      // redirecciones a donde le digan, incluido bajar a http en claro, y sin
      // decirlo. Es la misma regla que usan las descargas de las bases.
      final response = await secureSend(client, kReleasesApi,
              headers: const {
            'Accept': 'application/vnd.github+json',
            'User-Agent': 'ManaForge',
          })
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return _available;
      // tope en BYTES y mientras se lee, no después de tragarse el cuerpo
      // entero en memoria
      final body = await readCappedBody(response, kMaxReleasesBytes);
      if (body == null) return _available;
      final release = newestAppRelease(body);
      _lastCheck = ahora;
      _available = release != null &&
              isNewerVersion(release.version, currentVersion)
          ? release
          : null;
      notifyListeners();
      await _save();
      return _available;
    } catch (_) {
      return _available; // sin red, o GitHub de morros: silencio
    } finally {
      client.close();
    }
  }

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'update.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  Future<void> _save() async {
    final file = await _file();
    if (file == null) return;
    try {
      final tmp = File('${file.path}.tmp');
      await tmp.writeAsString(
          jsonEncode({
            'enabled': _enabled,
            if (_lastCheck != null)
              'lastCheck': _lastCheck!.millisecondsSinceEpoch,
            if (_seenVersion != null) 'seenVersion': _seenVersion,
          }),
          flush: true);
      await tmp.rename(file.path);
    } catch (_) {
      // no poder guardar cuándo se miró no puede tumbar nada
    }
  }
}
