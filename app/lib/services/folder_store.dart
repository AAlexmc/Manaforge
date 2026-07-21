import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Color por defecto de una carpeta nueva (azul ManaForge).
const int kDefaultFolderColor = 0xFF4C7DF0;

/// Iconos entre los que elegir al crear/editar una carpeta. La clave se
/// guarda en el JSON; el `IconData` lo resuelve la pantalla.
const List<String> kFolderIcons = [
  'folder',
  'star',
  'favorite',
  'bolt',
  'shield',
  'sell',
  'diamond',
  'local_fire_department',
  'water_drop',
  'forest',
  'skull',
  'auto_awesome',
];

/// Una carpeta de la colección: un puñado de cartas agrupadas a mano.
///
/// Guarda SOLO pertenencia (qué cartas), nunca cantidades: la cantidad la
/// manda siempre la colección, así no hay dos contabilidades que se
/// desincronicen cuando escaneas una copia más.
///
/// No es un mazo: un mazo es una lista jugable (formato, curva, tierras) que
/// puede pedir cartas que no tienes; una carpeta es organización física de lo
/// que sí tienes, sin reglas ni límite de copias.
class CardFolder {
  final String id;
  final String name;
  final int colorValue; // ARGB de la portada
  final String icon; // clave de [kFolderIcons]
  final Set<String> cardIds; // oracleIds
  final String createdAt; // ISO-8601

  CardFolder({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.icon,
    required Set<String> cardIds,
    required this.createdAt,
  }) : cardIds = Set.unmodifiable(cardIds);

  int get count => cardIds.length;

  /// Cartas de la carpeta que SIGUES teniendo.
  Set<String> presentIn(Set<String> ownedOracleIds) =>
      cardIds.where(ownedOracleIds.contains).toSet();

  /// Cartas de la carpeta que ya no están en la colección. No se borran
  /// solas: si vuelves a añadir la carta, reaparece en su carpeta.
  Set<String> missingIn(Set<String> ownedOracleIds) =>
      cardIds.where((id) => !ownedOracleIds.contains(id)).toSet();

  CardFolder copyWith({
    String? name,
    int? colorValue,
    String? icon,
    Set<String>? cardIds,
  }) =>
      CardFolder(
        id: id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        icon: icon ?? this.icon,
        cardIds: cardIds ?? this.cardIds,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorValue': colorValue,
        'icon': icon,
        'cards': cardIds.toList()..sort(),
        'createdAt': createdAt,
      };

  factory CardFolder.fromJson(Map<String, dynamic> json) => CardFolder(
        id: json['id'] as String,
        name: (json['name'] as String?) ?? 'Carpeta',
        colorValue: (json['colorValue'] as int?) ?? kDefaultFolderColor,
        icon: (json['icon'] as String?) ?? 'folder',
        cardIds: {
          for (final id in (json['cards'] as List<dynamic>? ?? const []))
            if (id is String) id
        },
        createdAt: (json['createdAt'] as String?) ?? '',
      );
}

/// Carpetas del usuario. Fichero propio `folders.json` (el formato de
/// `collection.json` no se toca), mismo patrón que [DeckStore]: JSON local,
/// sin cuentas ni nube.
class FolderStore extends ChangeNotifier {
  /// Solo para tests: dónde guardar el JSON (por defecto, la carpeta de
  /// datos de la app). Permite comprobar de verdad lo que acaba en disco.
  final Directory? dataDir;

  FolderStore({this.dataDir});

  final List<CardFolder> _folders = [];
  bool _loaded = false;
  int _lastMicros = 0;

  /// La creada más recientemente, primero.
  List<CardFolder> get folders => List.unmodifiable(_folders);

  bool get isEmpty => _folders.isEmpty;

  CardFolder? byId(String id) {
    final i = _folders.indexWhere((f) => f.id == id);
    return i < 0 ? null : _folders[i];
  }

  /// En cuántas carpetas está una carta (una carta puede estar en varias).
  int foldersContaining(String oracleId) =>
      _folders.where((f) => f.cardIds.contains(oracleId)).length;

  Future<File?> _file() async {
    try {
      final dir = dataDir ?? await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'folders.json'));
    } catch (_) {
      return null; // sin plugin (tests): solo en memoria
    }
  }

  /// Carga las carpetas. Se parsea a una lista local y una carpeta con algún
  /// campo raro se SALTA en vez de tirar todas: las carpetas las ha hecho el
  /// usuario a mano y no se recuperan de ningún sitio.
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final file = await _file();
    if (file == null || !await file.exists()) return;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! List) return;
      final parsed = <CardFolder>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;
        try {
          parsed.add(CardFolder.fromJson(item));
        } catch (_) {
          continue; // esta carpeta no, las demás sí
        }
      }
      _folders
        ..clear()
        ..addAll(parsed);
      notifyListeners();
    } catch (_) {
      // fichero ilegible: se deja como está (vacío) y NO se sobrescribe
      // hasta que el usuario toque algo
    }
  }

  /// Cola de escrituras: dos guardados a la vez se pisaban el fichero
  /// temporal y el segundo `rename` fallaba.
  Future<void> _queue = Future.value();

  void _save() {
    _queue = _queue.then((_) => _write()).catchError((Object _) {});
  }

  /// Espera a que la cola de guardado vacíe. Los `_save()` son
  /// fire-and-forget: sin esto, un test que mira el fichero puede llegar
  /// antes que la escritura (y fallar solo a veces, en la máquina lenta de
  /// turno).
  @visibleForTesting
  Future<void> get pendingSave => _queue;

  /// Escribe por temporal + rename: un corte a mitad de escritura dejaría el
  /// fichero anterior intacto en vez de una lista de carpetas truncada.
  Future<void> _write() async {
    final file = await _file();
    if (file == null) return;
    final data = jsonEncode([for (final f in _folders) f.toJson()]);
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(data, flush: true);
    await tmp.rename(file.path);
  }

  /// Ids distintos aunque se creen dos carpetas en el mismo microsegundo.
  String _nextId() {
    var micros = DateTime.now().microsecondsSinceEpoch;
    if (micros <= _lastMicros) micros = _lastMicros + 1;
    _lastMicros = micros;
    return micros.toString();
  }

  CardFolder create({
    required String name,
    int colorValue = kDefaultFolderColor,
    String icon = 'folder',
    Set<String> cardIds = const {},
  }) {
    final folder = CardFolder(
      id: _nextId(),
      name: name,
      colorValue: colorValue,
      icon: icon,
      cardIds: cardIds,
      createdAt: DateTime.now().toIso8601String(),
    );
    _folders.insert(0, folder);
    notifyListeners();
    _save();
    return folder;
  }

  void _update(String id, CardFolder Function(CardFolder) change) {
    final i = _folders.indexWhere((f) => f.id == id);
    if (i < 0) return; // carpeta borrada en otra pantalla: no es un error
    _folders[i] = change(_folders[i]);
    notifyListeners();
    _save();
  }

  void rename(String id, String name) =>
      _update(id, (f) => f.copyWith(name: name));

  /// Nombre + aspecto de una tacada (el diálogo de editar cambia las tres
  /// cosas a la vez: una sola escritura en vez de dos).
  void edit(String id,
          {required String name,
          required int colorValue,
          required String icon}) =>
      _update(
          id,
          (f) => f.copyWith(
              name: name, colorValue: colorValue, icon: icon));

  void setAppearance(String id, {int? colorValue, String? icon}) =>
      _update(id, (f) => f.copyWith(colorValue: colorValue, icon: icon));

  void setCards(String id, Set<String> cardIds) =>
      _update(id, (f) => f.copyWith(cardIds: cardIds));

  void toggleCard(String id, String oracleId) => _update(id, (f) {
        final next = {...f.cardIds};
        if (!next.remove(oracleId)) next.add(oracleId);
        return f.copyWith(cardIds: next);
      });

  void addCards(String id, Iterable<String> oracleIds) =>
      _update(id, (f) => f.copyWith(cardIds: {...f.cardIds, ...oracleIds}));

  /// Limpieza MANUAL de las cartas que ya no están en la colección (botón en
  /// la carpeta). Nunca automática: borrar en silencio es perder datos.
  void removeMissing(String id, Set<String> ownedOracleIds) =>
      _update(id, (f) => f.copyWith(cardIds: f.presentIn(ownedOracleIds)));

  void remove(String id) {
    final before = _folders.length;
    _folders.removeWhere((f) => f.id == id);
    if (_folders.length == before) return;
    notifyListeners();
    _save();
  }
}
