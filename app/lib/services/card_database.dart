import 'dart:convert';
import 'dart:io';

import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'markets.dart';

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

  /// Solo para tests: dónde vive la base (por defecto, la carpeta de datos
  /// de la app).
  final Directory? dataDir;

  CardDatabase({this.dataDir});

  Database? _db;

  Future<File> _dbFile() async {
    final dir = dataDir ?? await getApplicationSupportDirectory();
    return File(p.join(dir.path, 'manaforge_cards.sqlite'));
  }

  /// Cuándo se trajo la copia local (para no re-descargar cada arranque
  /// cuando la fecha del contenido nunca alcanza al día de hoy).
  Future<DateTime?> lastDownloaded() async {
    try {
      final file = await _dbFile();
      if (!await file.exists()) return null;
      return file.lastModified();
    } catch (_) {
      return null;
    }
  }

  Future<bool> isReady() async {
    try {
      return await (await _dbFile()).exists();
    } catch (_) {
      return false; // sin plugin (tests) => no hay DB
    }
  }

  /// Descarga y descomprime la DB, emitiendo progreso 0..1 (-1 = indeterminado).
  /// La DB que ya funcionaba NO se toca hasta que la nueva está entera y
  /// descomprimida: una descarga cortada (o cancelada al entrar a la app)
  /// deja la anterior intacta y no ficheros a medias.
  Stream<double> download() async* {
    final dbFile = await _dbFile();
    final gzFile = File('${dbFile.path}.gz');
    final tmpFile = File('${dbFile.path}.tmp');
    final client = http.Client();
    IOSink? sink;
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
      sink = gzFile.openWrite();
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        yield total > 0 ? received / total : -1;
      }
      await sink.close();
      sink = null;
      // descompresión en streaming (la DB puede ocupar cientos de MB)
      await gzFile.openRead().transform(gzip.decoder).pipe(tmpFile.openWrite());
      close(); // soltar el archivo (Windows lo bloquea)
      await tmpFile.rename(dbFile.path);
      yield 1.0;
    } finally {
      client.close();
      // si el consumidor cancela el stream (p. ej. al salir de la pantalla)
      // solo corre esto: hay que cerrar el sink y no dejar restos
      try {
        await sink?.close();
      } catch (_) {/* ya estaba rota */}
      for (final leftover in [gzFile, tmpFile]) {
        if (await leftover.exists()) {
          try {
            await leftover.delete();
          } catch (_) {/* nada que hacer */}
        }
      }
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
      int? yearMax,
      String? format}) async {
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
          colorIdentity: r['color_identity'] as String?,
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

    bool legalIn(Row r) {
      if (format == null) return true;
      try {
        final legal = jsonDecode((r['legalities'] as String?) ?? '{}')
            as Map<String, dynamic>;
        return legal[format] == 'legal';
      } catch (_) {
        return false;
      }
    }

    for (final entry in ownedByOracle.entries) {
      if (tooExpensive.contains(entry.key)) continue;
      final rows = db.select(
          'SELECT name, mana_cost, cmc, colors, color_identity, type_line, '
          'oracle_text, power, toughness, legalities '
          'FROM cards WHERE oracle_id = ?1',
          [entry.key]);
      if (rows.isEmpty) continue;
      if (!legalIn(rows.first)) continue;
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
  final String? releasedAt;

  const SetInfo(
      {required this.code,
      required this.name,
      required this.total,
      this.releasedAt});

  String get year => (releasedAt ?? '').split('-').first;
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
    final hasDate = await supportsYearFilter();
    final rows = db.select('''
      SELECT set_code, MAX(set_name) AS set_name,
             COUNT(DISTINCT collector_number) AS total
             ${hasDate ? ', MAX(released_at) AS rel' : ''}
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
          releasedAt: hasDate ? r['rel'] as String? : null,
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
          'SELECT name, mana_cost, cmc, colors, color_identity, type_line, '
          'oracle_text, power, toughness FROM cards WHERE name = ?1',
          [entry.key]);
      if (rows.isEmpty) {
        // cartas de dos caras: la lista suele traer solo la cara delantera
        rows = db.select(
            'SELECT name, mana_cost, cmc, colors, color_identity, type_line, '
            "oracle_text, power, toughness FROM cards WHERE name LIKE ?1 || ' //%'",
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
        colorIdentity: r['color_identity'] as String?,
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

/// Detalle completo de una carta (ficha estilo mercado).
class CardFullDetail {
  final String oracleId;
  final String name;
  final String manaCost;
  final String typeLine;
  final String oracleText;
  final String colors;
  final String? power;
  final String? toughness;
  final Map<String, String> legalities; // formato -> legal/not_legal/banned…

  const CardFullDetail({
    required this.oracleId,
    required this.name,
    required this.manaCost,
    required this.typeLine,
    required this.oracleText,
    required this.colors,
    this.power,
    this.toughness,
    required this.legalities,
  });
}

/// Una versión impresa de la carta, con sus precios.
class CardVersion {
  final String setCode;
  final String setName;
  final String collectorNumber;
  final String rarity;
  final String? releasedAt;

  /// Precio de ESTA edición en el mercado con el que se pidió la lista
  /// (no siempre son euros: el mercado lo elige el usuario).
  final double? price;
  final double? priceFoil;
  final String? imageSmall;
  final String? imageNormal;

  const CardVersion({
    required this.setCode,
    required this.setName,
    required this.collectorNumber,
    required this.rarity,
    this.releasedAt,
    this.price,
    this.priceFoil,
    this.imageSmall,
    this.imageNormal,
  });

  String get printingKey => '${setCode.toLowerCase()}|$collectorNumber';
  String get year => (releasedAt ?? '????').split('-').first;
}

/// Una carta valorada de la colección (para el top del Mercado).
class ValuedCard {
  final String oracleId;
  final String name;
  final String? printedName;
  final String? imageSmall;
  final String? imageNormal;
  final String colors;
  final int qty;
  final double unitPrice;

  const ValuedCard({
    required this.oracleId,
    required this.name,
    this.printedName,
    this.imageSmall,
    this.imageNormal,
    required this.colors,
    required this.qty,
    required this.unitPrice,
  });

  double get total => unitPrice * qty;
}

/// Consultas de mercado: precios, versiones, legalidades y valor.
extension MarketQueries on CardDatabase {
  Future<bool> _hasColumn(String table, String column) async {
    try {
      final db = await _open();
      final rows = db.select('PRAGMA table_info($table)');
      return rows.any((r) => r['name'] == column);
    } catch (_) {
      return false;
    }
  }

  /// Fecha del bulk de Scryfall con el que se generó la DB (YYYY-MM-DD).
  Future<String?> bulkDate() async {
    try {
      final db = await _open();
      final rows =
          db.select("SELECT value FROM meta WHERE key = 'bulk_date'");
      return rows.isEmpty ? null : rows.first['value'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Ficha completa por oracle id, o por nombre si [byName] no es nulo.
  Future<CardFullDetail?> cardDetail(
      {String? oracleId, String? byName}) async {
    final db = await _open();
    final rows = oracleId != null
        ? db.select(
            'SELECT oracle_id, name, mana_cost, type_line, oracle_text, '
            'colors, power, toughness, legalities FROM cards '
            'WHERE oracle_id = ?1',
            [oracleId])
        : db.select(
            'SELECT oracle_id, name, mana_cost, type_line, oracle_text, '
            'colors, power, toughness, legalities FROM cards '
            "WHERE name = ?1 OR name LIKE ?1 || ' //%'",
            [byName]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    Map<String, String> legal = {};
    try {
      (jsonDecode((r['legalities'] as String?) ?? '{}')
              as Map<String, dynamic>)
          .forEach((k, v) => legal[k] = v as String);
    } catch (_) {/* sin legalidades */}
    return CardFullDetail(
      oracleId: r['oracle_id'] as String,
      name: r['name'] as String,
      manaCost: (r['mana_cost'] as String?) ?? '',
      typeLine: (r['type_line'] as String?) ?? '',
      oracleText: (r['oracle_text'] as String?) ?? '',
      colors: (r['colors'] as String?) ?? '',
      power: r['power'] as String?,
      toughness: r['toughness'] as String?,
      legalities: legal,
    );
  }

  /// Todas las versiones impresas (una por set+número, preferencia EN),
  /// nuevas primero.
  /// Ediciones de una carta con su precio EN EL MERCADO ELEGIDO. Los
  /// mercados sin precio por edición (Card Kingdom, Mana Pool: de esos solo
  /// hay histórico a nivel carta) devuelven las ediciones sin precio, y la
  /// ficha lo explica en vez de enseñar euros con otra etiqueta.
  Future<List<CardVersion>> versionsOf(String oracleId,
      {Market market = Market.cardmarket}) async {
    final db = await _open();
    final priceCol = market.todayColumn;
    final foilCol = market.todayFoilColumn;
    final hasPrice =
        priceCol != null && await _hasColumn('printings', priceCol);
    final hasFoil = foilCol != null && await _hasColumn('printings', foilCol);
    final hasDate = await _hasColumn('printings', 'released_at');
    final cols = [
      'set_code',
      'set_name',
      'collector_number',
      'rarity',
      'image_small',
      'image_normal',
      if (hasPrice) priceCol,
      if (hasFoil) foilCol,
      if (hasDate) 'released_at',
    ].join(', ');
    final rows = db.select(
      'SELECT $cols, '
      "MIN(CASE WHEN lang = 'en' THEN 0 ELSE 1 END) AS pref "
      'FROM printings WHERE oracle_id = ?1 '
      'GROUP BY set_code, collector_number',
      [oracleId],
    );
    final versions = [
      for (final r in rows)
        CardVersion(
          setCode: (r['set_code'] as String?) ?? '',
          setName: (r['set_name'] as String?) ?? '',
          collectorNumber: (r['collector_number'] as String?) ?? '',
          rarity: (r['rarity'] as String?) ?? '',
          releasedAt: hasDate ? r['released_at'] as String? : null,
          price: hasPrice
              ? double.tryParse((r[priceCol] as String?) ?? '')
              : null,
          priceFoil:
              hasFoil ? double.tryParse((r[foilCol] as String?) ?? '') : null,
          imageSmall: r['image_small'] as String?,
          imageNormal: r['image_normal'] as String?,
        )
    ]..sort((a, b) =>
        (b.releasedAt ?? '').compareTo(a.releasedAt ?? ''));
    return versions;
  }

  /// A qué carta pertenece cada impresión ("set|nº" -> oracleId). Lo usan las
  /// carpetas para repartir las cantidades por edición de la colección entre
  /// las cartas que tiene cada carpeta.
  Future<Map<String, String>> oracleByPrintings(
      Iterable<String> printingKeys) async {
    final db = await _open();
    final out = <String, String>{};
    final keys = printingKeys.toList();
    const chunkSize = 150; // 2 parámetros por clave
    for (var i = 0; i < keys.length; i += chunkSize) {
      final chunk = keys.sublist(
          i, i + chunkSize > keys.length ? keys.length : i + chunkSize);
      final where = List.filled(
              chunk.length, '(set_code = ? AND collector_number = ?)')
          .join(' OR ');
      final params = <String>[];
      for (final k in chunk) {
        final parts = k.split('|');
        params.add(parts.first);
        params.add(parts.length > 1 ? parts[1] : '');
      }
      final rows = db.select(
        'SELECT set_code, collector_number, oracle_id '
        'FROM printings WHERE $where',
        params,
      );
      for (final r in rows) {
        final key =
            '${(r['set_code'] as String).toLowerCase()}|${r['collector_number']}';
        out[key] = r['oracle_id'] as String;
      }
    }
    return out;
  }

  /// Precio unitario por impresión exacta ("set|nº" -> dinero del mercado
  /// elegido). Si ese mercado no publica precio de HOY (Card Kingdom, Mana
  /// Pool) o la base descargada es vieja y no trae su columna, devuelve
  /// vacío: quien llame se apaña con el histórico.
  Future<Map<String, double>> pricesForPrintings(Iterable<String> printingKeys,
      {Market market = Market.cardmarket}) async {
    final column = market.todayColumn;
    if (column == null) return const {};
    if (!await _hasColumn('printings', column)) return const {};
    final db = await _open();
    final out = <String, double>{};
    final keys = printingKeys.toList();
    const chunkSize = 150; // 2 parámetros por clave
    for (var i = 0; i < keys.length; i += chunkSize) {
      final chunk = keys.sublist(
          i, i + chunkSize > keys.length ? keys.length : i + chunkSize);
      final where = List.filled(
              chunk.length, '(set_code = ? AND collector_number = ?)')
          .join(' OR ');
      final params = <String>[];
      for (final k in chunk) {
        final parts = k.split('|');
        params.add(parts.first);
        params.add(parts.length > 1 ? parts[1] : '');
      }
      final rows = db.select(
        'SELECT set_code, collector_number, '
        'MIN(CAST($column AS REAL)) AS p '
        'FROM printings WHERE $column IS NOT NULL AND ($where) '
        'GROUP BY set_code, collector_number',
        params,
      );
      for (final r in rows) {
        final key =
            '${(r['set_code'] as String).toLowerCase()}|${r['collector_number']}';
        final p = r['p'] as double?;
        if (p != null) out[key] = p;
      }
    }
    return out;
  }

  /// Precio mínimo conocido por oracle id (modo aproximado y mazos), en el
  /// mercado elegido.
  Future<Map<String, double>> pricesForOracles(Iterable<String> oracleIds,
      {Market market = Market.cardmarket}) async {
    final column = market.todayColumn;
    if (column == null) return const {};
    if (!await _hasColumn('printings', column)) return const {};
    final db = await _open();
    final out = <String, double>{};
    final ids = oracleIds.toList();
    const chunkSize = 400;
    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk = ids.sublist(
          i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
        'SELECT oracle_id, MIN(CAST($column AS REAL)) AS p '
        'FROM printings WHERE oracle_id IN ($marks) '
        'AND $column IS NOT NULL GROUP BY oracle_id',
        chunk,
      );
      for (final r in rows) {
        final p = r['p'] as double?;
        if (p != null) out[r['oracle_id'] as String] = p;
      }
    }
    return out;
  }

  /// Precio mínimo por NOMBRE inglés (valor de mazos).
  Future<Map<String, double>> pricesForNames(Iterable<String> names) async {
    final db = await _open();
    final out = <String, double>{};
    final list = names.toList();
    const chunkSize = 300;
    for (var i = 0; i < list.length; i += chunkSize) {
      final chunk = list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
        'SELECT c.name, MIN(CAST(p.price_eur AS REAL)) AS pr '
        'FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id '
        'WHERE c.name IN ($marks) AND p.price_eur IS NOT NULL '
        'GROUP BY c.oracle_id',
        chunk,
      );
      for (final r in rows) {
        final p = r['pr'] as double?;
        if (p != null) out[r['name'] as String] = p;
      }
    }
    return out;
  }
}

/// Una expansión para la tira del Mercado (estilo banner de gacha).
class SetBanner {
  final String code;
  final String name;
  final int total;
  final String? releasedAt;
  final String? imageNormal; // la carta más cara del set como fondo

  const SetBanner({
    required this.code,
    required this.name,
    required this.total,
    this.releasedAt,
    this.imageNormal,
  });

  String get year => (releasedAt ?? '').split('-').first;
}

/// Una carta de un set con sus precios (vista de mercado por expansión).
class SetCardPrice {
  final String oracleId;
  final String name;
  final String? printedName;
  final String collectorNumber;
  final String rarity;
  final String colors;
  final String? imageSmall;
  final String? imageNormal;

  /// Precio en el mercado con el que se pidió la lista.
  final double? price;
  final double? priceFoil;

  const SetCardPrice({
    required this.oracleId,
    required this.name,
    this.printedName,
    required this.collectorNumber,
    required this.rarity,
    required this.colors,
    this.imageSmall,
    this.imageNormal,
    this.price,
    this.priceFoil,
  });
}

/// Consultas de mercado por expansión.
extension SetMarketQueries on CardDatabase {
  /// Expansiones "de verdad" (≥50 cartas), nuevas primero, con la carta
  /// más cara de cada una como imagen de banner.
  Future<List<SetBanner>> marketSets({int limit = 500}) async {
    final db = await _open();
    final hasDate = await _hasColumn('printings', 'released_at');
    final rows = db.select(
      'SELECT set_code, MAX(set_name) AS set_name, '
      'COUNT(DISTINCT collector_number) AS total'
      '${hasDate ? ', MAX(released_at) AS rel' : ''} '
      'FROM printings WHERE set_code IS NOT NULL '
      'GROUP BY set_code HAVING total >= 25 '
      'ORDER BY ${hasDate ? 'rel DESC' : 'set_name'} LIMIT ?1',
      [limit],
    );
    final banners = [
      for (final r in rows)
        SetBanner(
          code: r['set_code'] as String,
          name: (r['set_name'] as String?) ?? '',
          total: r['total'] as int,
          releasedAt: hasDate ? r['rel'] as String? : null,
        )
    ];
    if (banners.isEmpty) return banners;
    // fondo: la carta más cara de cada set, en una sola pasada
    final marks = List.filled(banners.length, '?').join(',');
    final imgs = db.select(
      'SELECT set_code, image_normal, '
      'MAX(CAST(price_eur AS REAL)) AS maxp '
      'FROM printings WHERE set_code IN ($marks) '
      'AND image_normal IS NOT NULL AND price_eur IS NOT NULL '
      'GROUP BY set_code',
      [for (final b in banners) b.code],
    );
    final imageBySet = <String, String?>{
      for (final r in imgs)
        r['set_code'] as String: r['image_normal'] as String?
    };
    return [
      for (final b in banners)
        SetBanner(
          code: b.code,
          name: b.name,
          total: b.total,
          releasedAt: b.releasedAt,
          imageNormal: imageBySet[b.code],
        )
    ];
  }

  /// Cartas de un set con precios, una por número de coleccionista.
  Future<List<SetCardPrice>> setCardsWithPrices(String setCode,
      {Market market = Market.cardmarket}) async {
    final db = await _open();
    final priceCol = market.todayColumn;
    final foilCol = market.todayFoilColumn;
    final hasPrice =
        priceCol != null && await _hasColumn('printings', priceCol);
    final hasFoil = foilCol != null && await _hasColumn('printings', foilCol);
    final rows = db.select(
      'SELECT p.oracle_id, p.collector_number, p.printed_name, '
      'p.image_small, p.image_normal, p.rarity, '
      '${hasPrice ? 'p.$priceCol, ' : ''}'
      '${hasFoil ? 'p.$foilCol, ' : ''}'
      'c.name, c.colors, '
      "MIN(CASE WHEN p.lang = 'en' THEN 0 ELSE 1 END) AS pref "
      'FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id '
      'WHERE p.set_code = ?1 GROUP BY p.collector_number',
      [setCode],
    );
    return [
      for (final r in rows)
        SetCardPrice(
          oracleId: r['oracle_id'] as String,
          name: r['name'] as String,
          printedName: r['printed_name'] as String?,
          collectorNumber: (r['collector_number'] as String?) ?? '',
          rarity: (r['rarity'] as String?) ?? '',
          colors: (r['colors'] as String?) ?? '',
          imageSmall: r['image_small'] as String?,
          imageNormal: r['image_normal'] as String?,
          price: hasPrice
              ? double.tryParse((r[priceCol] as String?) ?? '')
              : null,
          priceFoil:
              hasFoil ? double.tryParse((r[foilCol] as String?) ?? '') : null,
        )
    ];
  }
}

/// Consultas que usan los LOGROS: rareza, año y precio foil.
extension StatsQueries on CardDatabase {
  /// Rareza y año de las impresiones EXACTAS que tiene el usuario
  /// ("set|nº" -> carta, rareza, año). Es lo que hay que mirar para los
  /// logros: tener el Counterspell de una caja de 1999 no te hace dueño de
  /// la versión mítica de otra edición.
  Future<Map<String, ({String oracleId, String rarity, int year})>>
      factsForPrintings(Iterable<String> printingKeys) async {
    final db = await _open();
    final hasDate = await supportsYearFilter();
    final out = <String, ({String oracleId, String rarity, int year})>{};
    final keys = printingKeys.toList();
    const chunkSize = 150; // 2 parámetros por clave
    for (var i = 0; i < keys.length; i += chunkSize) {
      final chunk = keys.sublist(
          i, i + chunkSize > keys.length ? keys.length : i + chunkSize);
      final where = List.filled(
              chunk.length, '(set_code = ? AND collector_number = ?)')
          .join(' OR ');
      final params = <String>[];
      for (final k in chunk) {
        final parts = k.split('|');
        params.add(parts.first);
        params.add(parts.length > 1 ? parts[1] : '');
      }
      final rows = db.select(
        'SELECT set_code, collector_number, oracle_id, rarity'
        '${hasDate ? ', released_at' : ''} '
        'FROM printings WHERE $where',
        params,
      );
      for (final r in rows) {
        final key =
            '${(r['set_code'] as String).toLowerCase()}|${r['collector_number']}';
        out[key] = (
          oracleId: r['oracle_id'] as String,
          rarity: ((r['rarity'] as String?) ?? '').toLowerCase(),
          year: hasDate
              ? int.tryParse(
                      ((r['released_at'] as String?) ?? '').split('-').first) ??
                  0
              : 0,
        );
      }
    }
    return out;
  }

  /// Rareza (la más alta de sus impresiones) y año (el de la más antigua)
  /// de cada carta. Solo para colecciones SIN datos de edición exacta.
  Future<Map<String, ({String rarity, int year})>> factsForOracles(
      Iterable<String> oracleIds) async {
    final db = await _open();
    final hasDate = await supportsYearFilter();
    const order = {'common': 0, 'uncommon': 1, 'rare': 2, 'mythic': 3};
    final out = <String, ({String rarity, int year})>{};
    final ids = oracleIds.toList();
    const chunkSize = 400;
    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk = ids.sublist(
          i, i + chunkSize > ids.length ? ids.length : i + chunkSize);
      final marks = List.filled(chunk.length, '?').join(',');
      final rows = db.select(
        'SELECT oracle_id, rarity'
        '${hasDate ? ', released_at' : ''} '
        'FROM printings WHERE oracle_id IN ($marks)',
        chunk,
      );
      for (final r in rows) {
        final id = r['oracle_id'] as String;
        final rarity = ((r['rarity'] as String?) ?? '').toLowerCase();
        final year = hasDate
            ? int.tryParse(((r['released_at'] as String?) ?? '').split('-').first) ?? 0
            : 0;
        final old = out[id];
        final bestRarity = old == null
            ? rarity
            : ((order[rarity] ?? -1) > (order[old.rarity] ?? -1)
                ? rarity
                : old.rarity);
        final oldestYear = old == null || old.year == 0
            ? year
            : (year > 0 && year < old.year ? year : old.year);
        out[id] = (rarity: bestRarity, year: oldestYear);
      }
    }
    return out;
  }

  /// Precio de la versión FOIL por impresión exacta, en el mercado elegido.
  Future<Map<String, double>> foilPricesForPrintings(
      Iterable<String> printingKeys,
      {Market market = Market.cardmarket}) async {
    final column = market.todayFoilColumn;
    if (column == null) return const {};
    if (!await _hasColumn('printings', column)) return const {};
    final db = await _open();
    final out = <String, double>{};
    final keys = printingKeys.toList();
    const chunkSize = 150; // 2 parámetros por clave
    for (var i = 0; i < keys.length; i += chunkSize) {
      final chunk = keys.sublist(
          i, i + chunkSize > keys.length ? keys.length : i + chunkSize);
      final where = List.filled(
              chunk.length, '(set_code = ? AND collector_number = ?)')
          .join(' OR ');
      final params = <String>[];
      for (final k in chunk) {
        final parts = k.split('|');
        params.add(parts.first);
        params.add(parts.length > 1 ? parts[1] : '');
      }
      final rows = db.select(
        'SELECT set_code, collector_number, '
        'MIN(CAST($column AS REAL)) AS p '
        'FROM printings WHERE $column IS NOT NULL AND ($where) '
        'GROUP BY set_code, collector_number',
        params,
      );
      for (final r in rows) {
        final key =
            '${(r['set_code'] as String).toLowerCase()}|${r['collector_number']}';
        final p = r['p'] as double?;
        if (p != null) out[key] = p;
      }
    }
    return out;
  }
}
