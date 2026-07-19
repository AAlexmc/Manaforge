import 'dart:io';

import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Resultado de búsqueda: una carta (nivel Oracle) con su impresión visible.
class CardHit {
  final String oracleId;
  final String name;
  final String? printedName; // nombre en el idioma de la impresión encontrada
  final String setCode;
  final String collectorNumber;
  final String? imageSmall;
  final String? imageNormal;
  final String typeLine;
  final String colors;
  final String manaCost;
  final int cmc;
  final int? power;
  final int? toughness;

  const CardHit({
    required this.oracleId,
    required this.name,
    this.printedName,
    required this.setCode,
    this.collectorNumber = '',
    this.imageSmall,
    this.imageNormal,
    required this.typeLine,
    required this.colors,
    required this.manaCost,
    this.cmc = 0,
    this.power,
    this.toughness,
  });

  /// Clave de impresión exacta (para el álbum): SET|número de coleccionista.
  String get printingKey =>
      '${setCode.toLowerCase()}|$collectorNumber';
}

/// Acceso a la base de datos de cartas (generada por scripts/build_card_db.py
/// y publicada como release del repo). Descarga con progreso, consulta offline.
class CardDatabase {
  static const releaseUrl =
      'https://github.com/AAlexmc/Manaforge/releases/download/card-db-latest/manaforge_cards.sqlite.gz';

  Database? _db;

  Future<File> _dbFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'manaforge_cards.sqlite'));
  }

  Future<bool> isReady() async {
    try {
      return await (await _dbFile()).exists();
    } catch (_) {
      return false; // sin plugin (tests) => no hay DB
    }
  }

  /// Descarga y descomprime la DB, emitiendo progreso 0..1 (-1 = indeterminado).
  Stream<double> download() async* {
    close(); // soltar el archivo si estaba abierto (Windows lo bloquea)
    final dbFile = await _dbFile();
    final gzFile = File('${dbFile.path}.gz');
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(releaseUrl));
      final response = await client.send(request);
      if (response.statusCode != 200) {
        throw HttpException(
            'No se pudo descargar la base de datos (HTTP ${response.statusCode}). '
            '¿Se ha ejecutado ya el workflow "Build card database"?');
      }
      final total = response.contentLength ?? -1;
      var received = 0;
      final sink = gzFile.openWrite();
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        yield total > 0 ? received / total : -1;
      }
      await sink.close();
      // descompresión en streaming (la DB puede ocupar cientos de MB)
      await gzFile
          .openRead()
          .transform(gzip.decoder)
          .pipe(dbFile.openWrite());
      await gzFile.delete();
      yield 1.0;
    } finally {
      client.close();
    }
  }

  /// Cierra la conexión (necesario antes de re-descargar la DB en Windows,
  /// que bloquea archivos abiertos).
  void close() {
    _db?.dispose();
    _db = null;
  }

  /// ¿La DB descargada tiene fecha de salida? (schema v2; si no, el filtro
  /// por año no está disponible hasta actualizar la DB en Ajustes).
  Future<bool> supportsYearFilter() async {
    try {
      final db = await _open();
      final rows = db.select('PRAGMA table_info(printings)');
      return rows.any((r) => r['name'] == 'released_at');
    } catch (_) {
      return false;
    }
  }

  Future<Database> _open() async {
    if (_db != null) return _db!;
    final file = await _dbFile();
    _db = sqlite3.open(file.path, mode: OpenMode.readOnly);
    return _db!;
  }

  /// Búsqueda por nombre en inglés o nombre impreso (español incluido).
  Future<List<CardHit>> search(String query, {int limit = 30}) async {
    if (query.trim().length < 2) return const [];
    final db = await _open();
    final like = '%${query.trim()}%';
    final rows = db.select('''
      SELECT c.oracle_id, c.name, p.printed_name, p.set_code,
             p.collector_number, p.image_small, p.image_normal,
             c.type_line, c.colors, c.mana_cost, c.cmc, c.power, c.toughness
      FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id
      WHERE c.name LIKE ?1 OR p.printed_name LIKE ?1
      GROUP BY c.oracle_id
      ORDER BY length(c.name)
      LIMIT ?2
    ''', [like, limit]);
    return [for (final r in rows) _hitFromRow(r)];
  }

  CardHit _hitFromRow(Row r) => CardHit(
        oracleId: r['oracle_id'] as String,
        name: r['name'] as String,
        printedName: r['printed_name'] as String?,
        setCode: (r['set_code'] as String?) ?? '',
        collectorNumber: (r['collector_number'] as String?) ?? '',
        imageSmall: r['image_small'] as String?,
        imageNormal: r['image_normal'] as String?,
        typeLine: (r['type_line'] as String?) ?? '',
        colors: (r['colors'] as String?) ?? '',
        manaCost: (r['mana_cost'] as String?) ?? '',
        cmc: ((r['cmc'] as num?) ?? 0).round(),
        power: int.tryParse((r['power'] as String?) ?? ''),
        toughness: int.tryParse((r['toughness'] as String?) ?? ''),
      );

  /// Resuelve un Scryfall ID (importador de ManaBox) a su carta Oracle.
  Future<CardHit?> byScryfallId(String scryfallId) async {
    final db = await _open();
    final rows = db.select('''
      SELECT c.oracle_id, c.name, p.printed_name, p.set_code,
             p.collector_number, p.image_small, p.image_normal,
             c.type_line, c.colors, c.mana_cost, c.cmc, c.power, c.toughness
      FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id
      WHERE p.scryfall_id = ?1
    ''', [scryfallId]);
    if (rows.isEmpty) return null;
    return _hitFromRow(rows.first);
  }

  /// Construye el pool del motor Forge para las cartas poseídas
  /// {oracleId: qty}; añade básicas "de cortesía" si se pide (jugador casual
  /// con básicas sueltas de mazos de inicio).
  Future<Map<String, fe.Card>> buildPool(Map<String, int> ownedByOracle,
      {bool assumeBasics = true,
      int basicsQty = 25,
      double? minPriceEur,
      double? maxPriceEur,
      int? yearMin,
      int? yearMax}) async {
    final db = await _open();
    final pool = <String, fe.Card>{};
    final ids = ownedByOracle.keys.toList();
    const chunkSize = 400;

    // Rango de precio: precio mínimo conocido por carta (cualquier
    // impresión). Sin dato de precio: solo pasa si no hay mínimo exigido.
    final excluded = <String>{};
    if (minPriceEur != null || maxPriceEur != null) {
      final priceByOracle = <String, double>{};
      for (var i = 0; i < ids.length; i += chunkSize) {
        final chunk = ids.sublist(
            i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
        final marks = List.filled(chunk.length, '?').join(',');
        final rows = db.select(
          'SELECT oracle_id, MIN(CAST(price_eur AS REAL)) AS minp '
          'FROM printings WHERE oracle_id IN ($marks) '
          'AND price_eur IS NOT NULL GROUP BY oracle_id',
          chunk,
        );
        for (final r in rows) {
          final minp = r['minp'] as double?;
          if (minp != null) priceByOracle[r['oracle_id'] as String] = minp;
        }
      }
      for (final id in ids) {
        final price = priceByOracle[id];
        if (maxPriceEur != null && price != null && price > maxPriceEur) {
          excluded.add(id);
        }
        if (minPriceEur != null && minPriceEur > 0 &&
            (price == null || price < minPriceEur)) {
          excluded.add(id);
        }
      }
    }

    // Rango de años: por la PRIMERA impresión de la carta (su año de
    // salida). Requiere DB con released_at (schema v2).
    if ((yearMin != null || yearMax != null) &&
        await supportsYearFilter()) {
      final yearByOracle = <String, int>{};
      for (var i = 0; i < ids.length; i += chunkSize) {
        final chunk = ids.sublist(
            i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
        final marks = List.filled(chunk.length, '?').join(',');
        final rows = db.select(
          "SELECT oracle_id, MIN(substr(released_at, 1, 4)) AS y "
          'FROM printings WHERE oracle_id IN ($marks) '
          'AND released_at IS NOT NULL GROUP BY oracle_id',
          chunk,
        );
        for (final r in rows) {
          final y = int.tryParse((r['y'] as String?) ?? '');
          if (y != null) yearByOracle[r['oracle_id'] as String] = y;
        }
      }
      for (final id in ids) {
        final y = yearByOracle[id];
        if (y == null ||
            (yearMin != null && y < yearMin) ||
            (yearMax != null && y > yearMax)) {
          excluded.add(id);
        }
      }
    }
    final tooExpensive = excluded;

    fe.Card rowToCard(Row r, int qty) => fe.Card(
          name: r['name'] as String,
          qty: qty,
          manaCost: (r['mana_cost'] as String?) ?? '',
          cmc: ((r['cmc'] as num?) ?? 0).round(),
          colors: (r['colors'] as String?) ?? '',
          types: ((r['type_line'] as String?) ?? '')
              .split('—')
              .first
              .trim()
              .split(' ')
              .where((t) => t.isNotEmpty)
              .toList(),
          oracle: (r['oracle_text'] as String?) ?? '',
          power: int.tryParse((r['power'] as String?) ?? ''),
          toughness: int.tryParse((r['toughness'] as String?) ?? ''),
        );

    for (final entry in ownedByOracle.entries) {
      if (tooExpensive.contains(entry.key)) continue;
      final rows = db.select(
          'SELECT name, mana_cost, cmc, colors, type_line, oracle_text, power, toughness '
          'FROM cards WHERE oracle_id = ?1',
          [entry.key]);
      if (rows.isEmpty) continue;
      final card = rowToCard(rows.first, entry.value);
      pool[card.name] = card;
    }
    if (assumeBasics) {
      for (final basic in ['Plains', 'Island', 'Swamp', 'Mountain', 'Forest']) {
        final owned = pool[basic]?.qty ?? 0;
        if (owned < basicsQty) {
          pool[basic] = fe.Card(
            name: basic,
            qty: basicsQty,
            manaCost: '',
            cmc: 0,
            colors: '',
            types: const ['Basic', 'Land'],
            oracle: '',
          );
        }
      }
    }
    return pool;
  }
}

/// Una expansión (set) para el álbum.
class SetInfo {
  final String code;
  final String name;
  final int total; // casillas del álbum (nº de collector numbers)

  const SetInfo({required this.code, required this.name, required this.total});
}

/// Una casilla del álbum: una carta concreta de un set.
class AlbumCard {
  final String oracleId;
  final String collectorNumber;
  final String name;
  final String? printedName;
  final String? imageSmall;
  final String? imageNormal;
  final String colors;
  final String typeLine;

  const AlbumCard({
    required this.oracleId,
    required this.collectorNumber,
    required this.name,
    this.printedName,
    this.imageSmall,
    this.imageNormal,
    required this.colors,
    this.typeLine = '',
  });

  bool get isBasicLand => typeLine.startsWith('Basic');
}

/// Consultas del álbum por expansiones (estilo TCG Pocket): todas las cartas
/// de cada set; las no poseídas se pintan apagadas.
extension AlbumQueries on CardDatabase {
  /// Todas las expansiones de la base de datos con su nº de cartas.
  Future<List<SetInfo>> sets() async {
    final db = await _open();
    final rows = db.select('''
      SELECT set_code, MAX(set_name) AS set_name,
             COUNT(DISTINCT collector_number) AS total
      FROM printings
      WHERE set_code IS NOT NULL AND set_name IS NOT NULL
      GROUP BY set_code
      ORDER BY set_name
    ''');
    return [
      for (final r in rows)
        SetInfo(
          code: r['set_code'] as String,
          name: r['set_name'] as String,
          total: r['total'] as int,
        )
    ];
  }

  /// Casillas poseídas por set para un conjunto de oracle IDs (troceado para
  /// no pasarse del límite de parámetros de SQLite).
  Future<Map<String, int>> ownedCountBySet(Iterable<String> oracleIds) async {
    final db = await _open();
    final out = <String, int>{};
    final ids = oracleIds.toList();
    const chunkSize = 400;
    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk = ids.sublist(
          i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
        'SELECT p.set_code, COUNT(DISTINCT p.collector_number) AS owned '
        'FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id '
        "WHERE p.oracle_id IN ($marks) AND c.type_line NOT LIKE 'Basic%' "
        'GROUP BY p.set_code',
        chunk,
      );
      for (final r in rows) {
        final code = r['set_code'] as String?;
        if (code == null) continue;
        out[code] = (out[code] ?? 0) + (r['owned'] as int);
      }
    }
    return out;
  }

  /// Todas las cartas de un set, una por collector number (preferencia por
  /// la impresión en inglés), en orden de coleccionista.
  Future<List<AlbumCard>> setCards(String setCode) async {
    final db = await _open();
    final rows = db.select('''
      SELECT p.oracle_id, p.collector_number, p.printed_name, p.image_small,
             p.image_normal, c.name, c.colors, c.type_line,
             MIN(CASE WHEN p.lang = 'en' THEN 0 ELSE 1 END) AS pref
      FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id
      WHERE p.set_code = ?1
      GROUP BY p.collector_number
      ORDER BY CAST(p.collector_number AS INTEGER), p.collector_number
    ''', [setCode]);
    return [
      for (final r in rows)
        AlbumCard(
          oracleId: r['oracle_id'] as String,
          collectorNumber: (r['collector_number'] as String?) ?? '',
          name: r['name'] as String,
          printedName: r['printed_name'] as String?,
          imageSmall: r['image_small'] as String?,
          imageNormal: r['image_normal'] as String?,
          colors: (r['colors'] as String?) ?? '',
          typeLine: (r['type_line'] as String?) ?? '',
        )
    ];
  }
}


/// Consultas de apoyo para el detalle y los mazos guardados.
extension DeckQueries on CardDatabase {
  /// Imagen (normal y small) de cada carta por nombre inglés.
  /// Con [ownedPrintings] (claves "set|nº"), elige la ILUSTRACIÓN QUE EL
  /// USUARIO POSEE; si no la hay, una impresión en inglés cualquiera.
  Future<Map<String, (String?, String?)>> imagesForNames(
      Iterable<String> names,
      {Set<String>? ownedPrintings}) async {
    final db = await _open();
    final best = <String, (int, String?, String?)>{}; // rango, normal, small
    final list = names.toList();
    const chunkSize = 200;
    for (var i = 0; i < list.length; i += chunkSize) {
      final chunk = list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
        'SELECT c.name, p.set_code, p.collector_number, p.lang, '
        'p.image_normal, p.image_small '
        'FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id '
        'WHERE c.name IN ($marks)',
        chunk,
      );
      for (final r in rows) {
        final name = r['name'] as String;
        final normal = r['image_normal'] as String?;
        final small = r['image_small'] as String?;
        if (normal == null && small == null) continue;
        final key = '${((r['set_code'] as String?) ?? '').toLowerCase()}|'
            '${(r['collector_number'] as String?) ?? ''}';
        // rango: 0 = la tuya · 1 = inglés · 2 = lo que haya
        final rank = (ownedPrintings?.contains(key) ?? false)
            ? 0
            : ((r['lang'] as String?) == 'en' ? 1 : 2);
        final current = best[name];
        if (current == null || rank < current.$1) {
          best[name] = (rank, normal, small);
        }
      }
    }
    return {for (final e in best.entries) e.key: (e.value.$2, e.value.$3)};
  }

  /// Pool del motor para un conjunto {nombre: cantidad} (mazos guardados:
  /// el mazo debe poder abrirse aunque la colección haya cambiado).
  Future<Map<String, fe.Card>> poolByNames(Map<String, int> qtyByName) async {
    final db = await _open();
    final pool = <String, fe.Card>{};
    for (final entry in qtyByName.entries) {
      var rows = db.select(
          'SELECT name, mana_cost, cmc, colors, type_line, oracle_text, '
          'power, toughness FROM cards WHERE name = ?1',
          [entry.key]);
      if (rows.isEmpty) {
        // cartas de dos caras: la lista suele traer solo la cara delantera
        rows = db.select(
            'SELECT name, mana_cost, cmc, colors, type_line, oracle_text, '
            "power, toughness FROM cards WHERE name LIKE ?1 || ' //%'",
            [entry.key]);
      }
      if (rows.isEmpty) continue;
      final r = rows.first;
      pool[entry.key] = fe.Card(
        name: r['name'] as String,
        qty: entry.value,
        manaCost: (r['mana_cost'] as String?) ?? '',
        cmc: ((r['cmc'] as num?) ?? 0).round(),
        colors: (r['colors'] as String?) ?? '',
        types: ((r['type_line'] as String?) ?? '')
            .split('—')
            .first
            .trim()
            .split(' ')
            .where((t) => t.isNotEmpty)
            .toList(),
        oracle: (r['oracle_text'] as String?) ?? '',
        power: int.tryParse((r['power'] as String?) ?? ''),
        toughness: int.tryParse((r['toughness'] as String?) ?? ''),
      );
    }
    return pool;
  }
}
