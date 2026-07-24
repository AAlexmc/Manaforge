import 'dart:convert';
import 'dart:io';

import 'package:forge_engine/forge_engine.dart' as fe;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'safe_input.dart';

/// Mazos del meta para el Modo Test. Los REALES se descargan del repo
/// (data/meta_decks.json, actualizable sin tocar la app) y se cachean 24 h;
/// si no hay conexión, se usan los presets locales de más abajo.
class MetaDeck {
  final String id;
  final String name;
  final String description;
  final String colors;
  final fe.Archetype archetype;
  final Map<String, int> cards;
  final Map<String, int> lands;
  final String format; // "Standard"… ('' en presets locales)
  final String share; // cuota de meta, p. ej. "12%"

  const MetaDeck({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    required this.archetype,
    required this.cards,
    required this.lands,
    this.format = '',
    this.share = '',
  });

  factory MetaDeck.fromJson(Map<String, dynamic> json) => MetaDeck(
        id: json['id'] as String,
        name: json['name'] as String,
        description: (json['description'] as String?) ?? '',
        colors: (json['colors'] as String?) ?? '',
        archetype: fe.Archetype.values.firstWhere(
            (a) => a.name == (json['archetype'] as String? ?? ''),
            orElse: () => fe.Archetype.midrange),
        cards: Map<String, int>.from(json['cards'] as Map),
        lands: Map<String, int>.from(json['lands'] as Map),
        format: (json['format'] as String?) ?? '',
        share: (json['share'] as String?) ?? '',
      );

  fe.Deck toDeck() => fe.Deck(
        name: name,
        colors: colors,
        archetype: archetype,
        cards: cards,
        lands: lands,
      );

  Map<String, int> get allNames => {...cards, ...lands};
}

/// Resultado de la carga: mazos + de dónde salieron.
class MetaDecksResult {
  final List<MetaDeck> decks;
  final String source; // p. ej. "Meta Standard · MTGGoldfish · 2026-07-19"
  final bool online;
  const MetaDecksResult(this.decks, this.source, {required this.online});
}

/// Descarga los mazos del meta reales publicados en el repo, con caché de
/// 24 h en disco y fallback a los presets locales si no hay red.
/// Tope del JSON del meta. Son unos KB; el tope está para que una respuesta
/// desproporcionada no se lea entera a memoria ni acabe en la caché.
const int kMaxMetaDecksBytes = 2 * 1024 * 1024;

class MetaDeckService {
  static const url =
      'https://raw.githubusercontent.com/AAlexmc/Manaforge/main/data/meta_decks.json';

  Future<File?> _cacheFile() async {
    try {
      final dir = await getApplicationSupportDirectory();
      return File(p.join(dir.path, 'meta_decks.json'));
    } catch (_) {
      return null;
    }
  }

  MetaDecksResult _parse(String body, {required bool online}) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final decks = [
      for (final d in (json['decks'] as List<dynamic>))
        MetaDeck.fromJson(d as Map<String, dynamic>)
    ];
    final source = '${json['source'] ?? 'meta'} · ${json['updated'] ?? ''}';
    return MetaDecksResult(decks, source, online: online);
  }

  Future<MetaDecksResult> load() async {
    final cache = await _cacheFile();
    // red primero: el meta se actualiza editando el JSON del repo y debe
    // verse al momento; la caché queda como salvavidas sin conexión
    final client = http.Client();
    try {
      // por secureSend, como el resto de lo que se baja: package:http sigue
      // las redirecciones a donde le digan, incluido bajar a http en claro
      final response = await secureSend(client, Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        // tope en bytes: este JSON son unos KB, y sin tope una respuesta
        // enorme se leería entera a memoria y encima se escribiría en disco
        final body = await readCappedBody(response, kMaxMetaDecksBytes);
        if (body != null) {
          final result = _parse(body, online: true);
          // solo se cachea lo que se ha podido leer: nunca basura
          await cache?.writeAsString(body);
          return result;
        }
      }
    } catch (_) {/* sin red: fallback */
    } finally {
      client.close();
    }
    if (cache != null && await cache.exists()) {
      try {
        return _parse(await cache.readAsString(), online: true);
      } catch (_) {/* caché corrupta */}
    }
    // sin `source`: no hay feed que citar y el texto ("presets locales") lo
    // pone la pantalla, que sabe en qué idioma va la app
    return const MetaDecksResult(metaDecks, '', online: false);
  }
}

const metaDecks = <MetaDeck>[
  MetaDeck(
    id: 'mono_red_aggro',
    name: 'Mono-Rojo Aggro',
    description: 'Criaturas baratas y daño a la cara: te mata en 4-5 turnos '
        'si no aguantas el ritmo.',
    colors: 'R',
    archetype: fe.Archetype.aggro,
    cards: {
      'Goblin Guide': 4,
      'Monastery Swiftspear': 4,
      'Viashino Pyromancer': 4,
      'Lightning Bolt': 4,
      'Lava Spike': 4,
      'Rift Bolt': 4,
      'Skewer the Critics': 4,
      'Searing Blaze': 4,
      'Light Up the Stage': 4,
      'Play with Fire': 4,
    },
    lands: {'Mountain': 20},
  ),
  MetaDeck(
    id: 'azorius_control',
    name: 'Control Azorius',
    description: 'Contramagia, barreduras y robo: alarga la partida y gana '
        'con pocos finalizadores.',
    colors: 'WU',
    archetype: fe.Archetype.control,
    cards: {
      'Counterspell': 4,
      'Essence Scatter': 4,
      'Path to Exile': 4,
      'Wrath of God': 4,
      'Divination': 4,
      'Opt': 4,
      'Serra Angel': 4,
      'Air Elemental': 4,
      'Sphinx of Magosi': 2,
    },
    lands: {'Island': 13, 'Plains': 13},
  ),
  MetaDeck(
    id: 'golgari_midrange',
    name: 'Midrange Golgari',
    description: 'Cambios de uno por uno, criaturas eficientes y removal '
        'negro: gana el juego largo por calidad de cartas.',
    colors: 'BG',
    archetype: fe.Archetype.midrange,
    cards: {
      'Llanowar Elves': 4,
      'Kalonian Tusker': 4,
      'Ravenous Chupacabra': 4,
      'Obstinate Baloth': 4,
      'Thrashing Brontodon': 4,
      'Murder': 4,
      'Epic Downfall': 4,
      'Sign in Blood': 4,
      'Rampant Growth': 4,
    },
    lands: {'Forest': 12, 'Swamp': 12},
  ),
];
