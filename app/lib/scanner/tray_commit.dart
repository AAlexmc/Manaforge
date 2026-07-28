/// Meter la bandeja del escaneo en la colección, con carpeta opcional.
///
/// Vive fuera de la pantalla para poder testearlo: la pantalla en vivo necesita
/// cámara, y en CI (y en Linux de escritorio) no hay.
///
/// Contrato de las carpetas, que aquí es lo que importa: una carpeta es una
/// ETIQUETA, no una caja. Elegir carpeta al escanear NO desvía las cartas: van
/// a la colección igual y ADEMÁS se etiquetan. La cantidad la manda siempre la
/// colección; la carpeta solo sabe si una carta está o no está.
library;

import 'dart:async';

import 'package:manaforge_app/services/card_database.dart';
import 'package:manaforge_app/services/collection_store.dart';
import 'package:manaforge_app/services/folder_store.dart';
import 'package:manaforge_app/scanner/scan_tray.dart';

/// Qué ha entrado, para el mensaje y para los logros.
class TrayCommitResult {
  /// Copias añadidas (contando los ×N).
  final int copies;

  /// Cartas distintas reconocidas.
  final int distinct;

  /// La tanda salió limpia: ninguna línea sin reconocer ni pendiente de
  /// revisar.
  final bool clean;

  /// Las cartas (oracleId) que han entrado, que son las que se etiquetan.
  final Set<String> oracleIds;

  const TrayCommitResult({
    required this.copies,
    required this.distinct,
    required this.clean,
    required this.oracleIds,
  });
}

/// Etiqueta en una carpeta lo que acaba de entrar. Se llama SIEMPRE después de
/// guardar en la colección: si la carpeta se hubiera borrado en otra pantalla,
/// esto no hace nada y las cartas están igualmente a salvo.
///
/// Lo usan las dos vías de escaneo (bandeja y carta suelta) para que "y además
/// a la carpeta" signifique exactamente lo mismo en las dos.
void tagScanned(
    FolderStore? folders, String? folderId, Set<String> oracleIds) {
  if (folders == null || folderId == null || oracleIds.isEmpty) return;
  folders.addCards(folderId, oracleIds);
}

TrayCommitResult commitTray({
  required ScanTray tray,
  required CollectionStore collection,
  required Map<String, CardHit?> hitCache,
  FolderStore? folders,
  String? folderId,
  DateTime? at,
}) {
  final cuando = at ?? DateTime.now(); // toda la bandeja entra "a la vez"
  var copies = 0;
  final oracleIds = <String>{};
  // toda la bandeja en UN lote: sin esto, cada línea avisaba a todas las
  // pantallas vivas (Inicio, Mercado…) y cada una recalculaba su valoración
  // contra la base — por línea escaneada. No hace falta await: el cuerpo no
  // tiene ningún await propio, así que corre entero (y ya) antes de que
  // vuelva el control aquí; solo el aviso final queda para el próximo
  // microtask, como con la importación de CSV.
  unawaited(collection.importBatch(() async {
    for (final line in tray.lines) {
      // sin reconocer = no se sabe qué carta es: no se añade nada. Meter el
      // top-1 sería inventarse una carta que el usuario no ha confirmado
      if (line.unrecognized) continue;
      final entry = line.chosen.entry;
      final hit = hitCache[entry.scryfallId];
      collection.add(
        hit != null
            ? OwnedCard(
                oracleId: hit.oracleId,
                name: hit.name,
                printedName: hit.printedName,
                imageSmall: hit.imageSmall,
                imageNormal: hit.imageNormal,
                colors: hit.colors,
                typeLine: hit.typeLine,
                cmc: hit.cmc,
                power: hit.power,
                toughness: hit.toughness,
                qty: line.qty,
              )
            : OwnedCard(
                oracleId: entry.oracleId,
                name: entry.name,
                colors: '',
                qty: line.qty),
        qty: line.qty,
        printingKey: entry.printingKey,
        at: cuando,
      );
      copies += line.qty;
      oracleIds.add(hit?.oracleId ?? entry.oracleId);
    }
  }));
  tagScanned(folders, folderId, oracleIds);
  return TrayCommitResult(
    copies: copies,
    distinct: tray.lines.where((l) => !l.unrecognized).length,
    clean: tray.lines.every((l) => !l.unrecognized && !l.needsReview),
    oracleIds: oracleIds,
  );
}
