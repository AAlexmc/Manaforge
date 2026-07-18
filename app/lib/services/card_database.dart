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
  final String? imageSmall;
  final String? imageNormal;
  final String typeLine;
  final String colors;
  final String manaCost;

  const CardHit({
    required this.oracleId,
    required this.name,
    this.printedName,
    required this.setCode,
    this.imageSmall,
    this.imageNormal,
    required this.typeLine,
    required this.colors,
    required this.manaCost,
  });
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
             p.image_small, p.image_normal, c.type_line, c.colors, c.mana_cost
      FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id
      WHERE c.name LIKE ?1 OR p.printed_name LIKE ?1
      GROUP BY c.oracle_id
      ORDER BY length(c.name)
      LIMIT ?2
    ''', [like, limit]);
    return [
      for (final r in rows)
        CardHit(
          oracleId: r['oracle_id'] as String,
          name: r['name'] as String,
          printedName: r['printed_name'] as String?,
          setCode: (r['set_code'] as String?) ?? '',
          imageSmall: r['image_small'] as String?,
          imageNormal: r['image_normal'] as String?,
          typeLine: (r['type_line'] as String?) ?? '',
          colors: (r['colors'] as String?) ?? '',
          manaCost: (r['mana_cost'] as String?) ?? '',
        )
    ];
  }

  /// Resuelve un Scryfall ID (importador de ManaBox) a su carta Oracle.
  Future<CardHit?> byScryfallId(String scryfallId) async {
    final db = await _open();
    final rows = db.select('''
      SELECT c.oracle_id, c.name, p.printed_name, p.set_code,
             p.image_small, p.image_normal, c.type_line, c.colors, c.mana_cost
      FROM printings p JOIN cards c ON c.oracle_id = p.oracle_id
      WHERE p.scryfall_id = ?1
    ''', [scryfallId]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return CardHit(
      oracleId: r['oracle_id'] as String,
      name: r['name'] as String,
      printedName: r['printed_name'] as String?,
      setCode: (r['set_code'] as String?) ?? '',
      imageSmall: r['image_small'] as String?,
      imageNormal: r['image_normal'] as String?,
      typeLine: (r['type_line'] as String?) ?? '',
      colors: (r['colors'] as String?) ?? '',
      manaCost: (r['mana_cost'] as String?) ?? '',
    );
  }

  /// Construye el pool del motor Forge para las cartas poseídas
  /// {oracleId: qty}; añade básicas "de cortesía" si se pide (jugador casual
  /// con básicas sueltas de mazos de inicio).
  Future<Map<String, fe.Card>> buildPool(Map<String, int> ownedByOracle,
      {bool assumeBasics = true, int basicsQty = 25}) async {
    final db = await _open();
    final pool = <String, fe.Card>{};

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
