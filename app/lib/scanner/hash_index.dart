/// Núcleo de matching del escáner, SIN dependencias de Flutter: el índice de
/// huellas en memoria y el top-k por distancia de Hamming. Aislado aquí para
/// poder testearlo/ejecutarlo con `dart run` (sin engine de Flutter) — la
/// descarga de la base (path_provider, http) vive en `scanner_database.dart`,
/// que re-exporta este fichero.
library;

import 'dart:typed_data';

import 'package:manaforge_app/scanner/dhash.dart';
import 'package:manaforge_app/scanner/digital_sets.dart';

/// Una impresión de la base de huellas (una fila de art_hashes).
class HashEntry {
  final String scryfallId;
  final String oracleId;
  final String name;
  final String setCode;
  final String collectorNumber;

  const HashEntry({
    required this.scryfallId,
    required this.oracleId,
    required this.name,
    required this.setCode,
    required this.collectorNumber,
  });

  String get printingKey => '${setCode.toLowerCase()}|$collectorNumber';
}

/// Un candidato del escáner: la impresión que mejor casa + su distancia.
class ScanMatch {
  final HashEntry entry;

  /// Distancia de Hamming total (0..128); menos es mejor. Como orientación,
  /// ≤14 suele ser la misma ilustración y ≥30 otra carta.
  final int distance;

  const ScanMatch(this.entry, this.distance);
}

/// Índice de huellas EN MEMORIA: ~110k firmas de 128 bits caben en un par
/// de MB y el barrido completo por Hamming tarda milisegundos.
class HashIndex {
  final Int64List _hashH;
  final Int64List _hashV;
  final List<HashEntry> _entries;

  HashIndex(this._hashH, this._hashV, this._entries)
      : assert(_hashH.length == _entries.length),
        assert(_hashV.length == _entries.length);

  int get length => _entries.length;

  /// Los [k] mejores candidatos para las firmas [sigs] (variantes
  /// multi-recorte de la MISMA carta vista: cuenta la mejor), DISTINTOS a
  /// nivel de carta (oracle): la misma ilustración reimpresa no debe
  /// comerse el top. Para cada carta gana su impresión que mejor casa
  /// (printingKey exacta). Si [lockSet] no es null, SOLO se consideran las
  /// impresiones de ese set (bloqueo de edición para escanear una caja: es el
  /// truco con el que ManaBox clava el printing exacto de un precon/sobre).
  List<ScanMatch> topMatches(List<DHashPair> sigs,
      {int k = 3, String? lockSet, Set<String> ownedPrintings = const {}}) {
    if (sigs.isEmpty) return const [];
    final lock = lockSet?.toLowerCase();
    // Fase 1: barrido completo solo con la firma CENTRAL (artSignatures
    // pone la variante sin desplazamiento la primera) y preselección de
    // los ~1000 mejores por counting-sort de distancias (0..128). El
    // histograma cuenta solo las entradas del set bloqueado, para que el
    // cutoff no se agote con cartas que luego se descartan.
    final center = sigs.first;
    final d0 = Uint8List(_entries.length);
    final histogram = List<int>.filled(129, 0);
    for (var i = 0; i < _entries.length; i++) {
      final d = hamming64(center.h, _hashH[i]) +
          hamming64(center.v, _hashV[i]);
      d0[i] = d;
      if (isDigitalOnlySet(_entries[i].setCode)) continue; // no existe en papel
      if (lock == null || _entries[i].setCode.toLowerCase() == lock) {
        histogram[d]++;
      }
    }
    var cutoff = 128;
    var cumulative = 0;
    for (var d = 0; d <= 128; d++) {
      cumulative += histogram[d];
      if (cumulative >= 1000) {
        cutoff = d;
        break;
      }
    }
    // Fase 2: refinar los preseleccionados con TODAS las variantes.
    final bestByOracle = <String, ScanMatch>{};
    for (var i = 0; i < _entries.length; i++) {
      if (d0[i] > cutoff) continue;
      final e = _entries[i];
      // el escáner mira cartón: una edición de Arena o de Magic Online no
      // puede ser la carta que hay sobre la mesa, por bien que case su arte
      if (isDigitalOnlySet(e.setCode)) continue;
      if (lock != null && e.setCode.toLowerCase() != lock) continue;
      final hh = _hashH[i];
      final vv = _hashV[i];
      var d = d0[i].toInt();
      for (final sig in sigs) {
        final di = hamming64(sig.h, hh) + hamming64(sig.v, vv);
        if (di < d) d = di;
      }
      final current = bestByOracle[e.oracleId];
      if (current == null ||
          d < current.distance ||
          (d == current.distance &&
              _ganaElDesempate(e, current.entry, ownedPrintings))) {
        bestByOracle[e.oracleId] = ScanMatch(e, d);
      }
    }
    final all = bestByOracle.values.toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    return all.take(k).toList();
  }

  /// Dos ediciones con el MISMO arte hashean igual: el empate es exacto y la
  /// ilustración no puede deshacerlo. Antes ganaba la que estuviera antes en
  /// la base —o sea, al azar—, y por eso un Aether Revolt entraba como
  /// Kaladesh Remastered. Se desempata por lo que sí se sabe:
  ///  1. la edición que el usuario YA tiene (lo más probable con diferencia);
  ///  2. la de número de coleccionista normal: The List numera "AER-191" y
  ///     los promos "2023-6" o "113p", y esas son las raras;
  ///  3. el código de edición por orden alfabético, que no dice nada pero
  ///     hace que la respuesta no dependa de cómo se generó la base.
  static bool _ganaElDesempate(
      HashEntry candidata, HashEntry actual, Set<String> ownedPrintings) {
    final tieneCandidata = ownedPrintings.contains(candidata.printingKey);
    final tieneActual = ownedPrintings.contains(actual.printingKey);
    if (tieneCandidata != tieneActual) return tieneCandidata;

    final normalCandidata = _numeroNormal(candidata.collectorNumber);
    final normalActual = _numeroNormal(actual.collectorNumber);
    if (normalCandidata != normalActual) return normalCandidata;

    return candidata.setCode.compareTo(actual.setCode) < 0;
  }

  /// Un número de coleccionista a secas (123), sin letras ni guiones.
  static bool _numeroNormal(String collectorNumber) =>
      collectorNumber.isNotEmpty &&
      RegExp(r'^[0-9]+$').hasMatch(collectorNumber);

  /// Matching con HIPÓTESIS de posición: el grupo [primary] manda salvo
  /// que algún grupo de [alts] mejore su top-1 en ≥3 bits (histéresis:
  /// probar N grupos sesga el mínimo hacia abajo y sin margen un falso
  /// podría robarle el sitio a un acierto mediocre). Devuelve los matches
  /// ganadores y el índice del grupo elegido (-1 = primario).
  (List<ScanMatch>, int) bestGroupMatches(
      List<DHashPair> primary, List<List<DHashPair>> alts,
      {String? lockSet, Set<String> ownedPrintings = const {}}) {
    var matches = topMatches(primary,
        lockSet: lockSet, ownedPrintings: ownedPrintings);
    var chosen = -1;
    if (alts.isEmpty) return (matches, chosen);
    var best = matches.isEmpty ? 999 : matches.first.distance;
    for (var i = 0; i < alts.length; i++) {
      final m = topMatches(alts[i],
          lockSet: lockSet, ownedPrintings: ownedPrintings);
      if (m.isEmpty) continue;
      if (m.first.distance <= best - 3) {
        best = m.first.distance;
        matches = m;
        chosen = i;
      }
    }
    return (matches, chosen);
  }
}
