/// Núcleo de matching del escáner, SIN dependencias de Flutter: el índice de
/// huellas en memoria y el top-k por distancia de Hamming. Aislado aquí para
/// poder testearlo/ejecutarlo con `dart run` (sin engine de Flutter) — la
/// descarga de la base (path_provider, http) vive en `scanner_database.dart`,
/// que re-exporta este fichero.
library;

import 'dart:typed_data';

import 'dhash.dart';

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
  List<ScanMatch> topMatches(List<DHashPair> sigs, {int k = 3, String? lockSet}) {
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
      if (lock != null && e.setCode.toLowerCase() != lock) continue;
      final hh = _hashH[i];
      final vv = _hashV[i];
      var d = d0[i].toInt();
      for (final sig in sigs) {
        final di = hamming64(sig.h, hh) + hamming64(sig.v, vv);
        if (di < d) d = di;
      }
      final current = bestByOracle[e.oracleId];
      if (current == null || d < current.distance) {
        bestByOracle[e.oracleId] = ScanMatch(e, d);
      }
    }
    final all = bestByOracle.values.toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    return all.take(k).toList();
  }
}
