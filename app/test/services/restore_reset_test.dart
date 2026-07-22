/// Restaurar una copia tiene que dejar la app leyendo el disco NUEVO.
///
/// Los dos almacenes compartidos (`recentsStore`, `priceHistoryStore`) son
/// singletons: no se recrean cuando la app se reconstruye al restaurar, así
/// que se quedaban con lo de antes en memoria y lo volvían a escribir encima
/// de lo recién restaurado. El historial de precios avisa en su cabecera de
/// que un apunte perdido no se recupera.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/price_history.dart';
import 'package:manaforge_app/services/recents_store.dart';
import 'package:manaforge_app/services/restore_reset.dart';
import 'package:path/path.dart' as p;

Directory _tmpDir() {
  final dir = Directory.systemTemp.createTempSync('mf-restore');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

void main() {
  test('las cartas vistas hace poco se releen del disco restaurado', () async {
    final dir = _tmpDir();
    final file = File(p.join(dir.path, 'recents.json'));
    final store = RecentsStore(dataDir: dir);
    store.record(const RecentCard(oracleId: 'antes', name: 'La de antes'));
    await store.pendingSave;

    // llega una copia restaurada con OTRAS cartas
    await file.writeAsString('[{"o":"despues","n":"La restaurada"}]');
    expect(store.cards.first.oracleId, 'antes',
        reason: 'todavía con lo de antes en memoria');

    store.invalidate();
    await store.load();

    expect(store.cards.single.oracleId, 'despues');
  });

  test('el historial de precios se relee del disco restaurado', () async {
    final dir = _tmpDir();
    final store = PriceHistoryStore(directory: dir);
    await store.recordOne('sol-ring', 2.5);
    expect((await store.forCard('sol-ring')).single.value, 2.5);

    // copia restaurada: el log de disco dice otra cosa
    final file = File(p.join(dir.path, 'price_history.jsonl'));
    await file.writeAsString(
        '{"o":"sol-ring","d":"2026-01-01","v":9.9}\n');

    store.invalidate();

    final leido = await store.forCard('sol-ring');
    expect(leido.single.value, 9.9,
        reason: 'la caché vieja reescribiría el log restaurado al compactar');
  });

  test('reiniciar los almacenes compartidos los vacía a los dos', () async {
    final dir = _tmpDir();
    final recents = RecentsStore(dataDir: dir);
    final history = PriceHistoryStore(directory: dir);
    recents.record(const RecentCard(oracleId: 'x', name: 'X'));
    await recents.pendingSave;
    await history.recordOne('x', 1);
    history.baseSeriesProvider = (ids, market) async => const {};

    resetSharedStores(recents: recents, history: history);

    expect(recents.cards, isEmpty);
    expect(history.baseSeriesProvider, isNotNull,
        reason: 'el proveedor de series lo pone la app, no el disco');
    // el disco sigue intacto: reiniciar no borra nada
    await recents.load();
    expect(recents.cards.single.oracleId, 'x');
  });
}
