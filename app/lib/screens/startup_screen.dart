import 'dart:async';


import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../services/collection_store.dart';
import '../services/price_series_database.dart';
import '../services/scanner_database.dart';
import '../services/startup_updates.dart';
import '../theme/mf_theme.dart';

/// Las tres bases que ManaForge se descarga, en el orden en que hacen
/// falta: sin la de cartas no hay app; el histórico y las huellas mejoran
/// el Mercado y el escáner.
List<UpdateSource> defaultUpdateSources({
  required CardDatabase db,
  required PriceSeriesDatabase prices,
  required ScannerDatabase scanner,
}) =>
    [
      UpdateSource(
        name: 'Cartas y precios',
        size: '22 MB',
        what: 'catálogo completo de Scryfall',
        lastDate: db.bulkDate,
        downloadedAt: db.lastDownloaded,
        download: db.download,
        maxAgeDays: kCardsMaxAgeDays,
      ),
      UpdateSource(
        name: 'Histórico de precios',
        size: '3 MB',
        what: '~90 días de Cardmarket',
        lastDate: () async => (await prices.covered())?.$2,
        downloadedAt: prices.lastDownloaded,
        download: prices.download,
        maxAgeDays: kPricesMaxAgeDays,
      ),
      UpdateSource(
        name: 'Huellas del escáner',
        size: '11 MB',
        what: 'para reconocer por foto',
        lastDate: scanner.updatedDate,
        downloadedAt: scanner.lastDownloaded,
        download: scanner.download,
        maxAgeDays: kHashesMaxAgeDays,
      ),
    ];

/// Pantalla de arranque: antes de entrar a la app se comprueba qué bases
/// hay que poner al día (cartas y precios, histórico de precios, huellas
/// del escáner) y se traen las que hagan falta, con progreso a la vista.
///
/// Reglas de la casa:
///  - sin conexión NO se bloquea: se entra con lo que ya hubiera;
///  - lo que ya está al día no se descarga (ver services/startup_updates);
///  - los botones "Actualizar" de dentro de la app siguen funcionando para
///    forzar una descarga cuando quieras.
class StartupScreen extends StatefulWidget {
  final List<UpdateSource> sources;

  /// La colección local (se carga siempre; es de disco y va rápido).
  final CollectionStore collection;
  final VoidCallback onReady;

  /// Pausa antes de entrar cuando ya está todo (para que dé tiempo a leer
  /// el resultado). En tests se pone a cero.
  final Duration settleDelay;

  /// ¿Hay dónde guardar las bases? Sin carpeta de datos (tests, entorno
  /// capado) no tiene sentido descargar nada: se entra directo.
  final Future<bool> Function() canDownload;

  /// Tope de espera por descarga. Sin esto, una red que acepta la conexión
  /// y no contesta (portal cautivo) deja el arranque colgado para siempre:
  /// al vencer se marca esa base como fallida y se sigue con las demás.
  final Duration downloadTimeout;

  const StartupScreen({
    super.key,
    required this.sources,
    required this.collection,
    required this.onReady,
    this.settleDelay = const Duration(milliseconds: 700),
    this.canDownload = storageAvailable,
    this.downloadTimeout = const Duration(minutes: 6),
  });

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

enum _State { waiting, checking, updating, done, failed }

class _Task {
  final String name;
  final String size;
  final String what;
  _State state = _State.waiting;
  double? progress; // null mientras descarga = indeterminado
  String detail = '';

  _Task(this.name, this.size, this.what);
}

class _StartupScreenState extends State<StartupScreen> {
  late final List<_Task> _tasks = [
    for (final s in widget.sources) _Task(s.name, s.size, s.what)
  ];

  bool _finished = false;
  bool _entered = false;

  @override
  void initState() {
    super.initState();
    // pase lo que pase ahí dentro, se entra: una pantalla de carga eterna
    // es el peor final posible para una comprobación opcional
    _run().catchError((_) {
      if (mounted) _enter();
    });
  }

  /// Entra a la app (una sola vez, la pulses tú o al terminar).
  void _enter() {
    if (_entered) return;
    _entered = true;
    widget.onReady();
  }

  Future<void> _run() async {
    // la colección es local: se pide ya, pero SIN esperarla — es disco y no
    // debe retrasar (ni bloquear) la comprobación de novedades
    unawaited(widget.collection.load().catchError((_) {}));

    // con timeout: si el sistema no contesta a dónde guardar, se entra en
    // vez de dejar al usuario mirando una pantalla de carga para siempre
    final puede = await widget.canDownload()
        .timeout(const Duration(seconds: 3), onTimeout: () => false);
    if (!puede) {
      if (mounted) _enter();
      return;
    }

    for (var i = 0; i < widget.sources.length; i++) {
      await _step(_tasks[i], widget.sources[i]);
    }

    if (!mounted) return;
    setState(() => _finished = true);
    // un respiro para que se vea el resultado y adentro
    await Future<void>.delayed(widget.settleDelay);
    if (mounted) _enter();
  }

  Future<void> _step(_Task task, UpdateSource source) async {
    final lastDate = source.lastDate;
    final download = source.download;
    final maxAgeDays = source.maxAgeDays;
    if (!mounted) return;
    setState(() => task.state = _State.checking);
    String? date;
    try {
      date = await lastDate();
    } catch (_) {
      date = null;
    }
    DateTime? traida;
    try {
      traida = await source.downloadedAt?.call();
    } catch (_) {/* da igual: solo sirve para no repetir descargas */}
    final need =
        updateNeed(date, maxAgeDays: maxAgeDays, downloadedAt: traida);
    if (need == UpdateNeed.fresh) {
      if (mounted) {
        setState(() {
          task.state = _State.done;
          task.detail = 'al día (${date ?? '—'})';
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        task.state = _State.updating;
        task.detail = updateLabel(need);
        task.progress = 0;
      });
    }
    try {
      // NO se sale del bucle si la pantalla ya no está: salir del `await
      // for` CANCELA el stream, y una descarga cancelada a medias deja el
      // fichero temporal y el sink abiertos. Al pulsar "Entrar ya" lo que
      // quiere el usuario es entrar, no tirar los megas ya bajados. El
      // tope de tiempo tampoco la corta: solo deja de esperarla.
      await (() async {
        await for (final p in download()) {
          if (mounted) setState(() => task.progress = p < 0 ? null : p);
        }
      })()
          .timeout(widget.downloadTimeout);
      String? fresh;
      try {
        fresh = await lastDate();
      } catch (_) {/* da igual: lo importante ya está descargado */}
      if (mounted) {
        setState(() {
          task.state = _State.done;
          task.progress = null;
          task.detail = fresh == null ? 'actualizado' : 'actualizado ($fresh)';
        });
      }
    } catch (_) {
      // sin conexión o release caída: se sigue con lo que hubiera
      if (mounted) {
        setState(() {
          task.state = _State.failed;
          task.progress = null;
          task.detail = need == UpdateNeed.missing
              ? 'no he podido traerla (sin conexión)'
              : 'sigo con la que tenías';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = _tasks.where((t) => t.state == _State.updating).length;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_mosaic,
                        color: MFColors.manaRed, size: 34),
                    const SizedBox(width: 12),
                    Text('ManaForge',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _finished
                      ? 'Todo al día. Entrando…'
                      : pendientes > 0
                          ? 'Poniendo al día tus cartas y precios…'
                          : 'Comprobando si hay novedades…',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 22),
                for (final task in _tasks) _row(context, task),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Lo que ya está al día no se descarga. Dentro de la '
                        'app puedes forzar cualquier actualización.',
                        style: TextStyle(
                            fontSize: 11.5,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _enter,
                      child: Text(_finished ? 'Entrar' : 'Entrar ya'),
                    ),
                  ],
                ),
                // restaurar vive SOLO en Ajustes: aquí, con el desplegable a
                // un clic de la pantalla que ves cada vez que abres la app,
                // era demasiado fácil reemplazar la colección sin querer
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, _Task task) {
    final (icon, color) = switch (task.state) {
      _State.waiting => (Icons.remove, Theme.of(context).dividerColor),
      _State.checking => (Icons.search, Theme.of(context).hintColor),
      _State.updating => (Icons.downloading, MFColors.warning),
      _State.done => (Icons.check_circle, MFColors.success),
      _State.failed => (Icons.cloud_off, MFColors.manaRed),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(task.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13.5)),
                    ),
                    Text(
                        task.state == _State.updating
                            ? task.size
                            : task.detail.isEmpty
                                ? task.what
                                : task.detail,
                        style: TextStyle(
                            fontSize: 11.5,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color)),
                  ],
                ),
                if (task.state == _State.updating) ...[
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                        value: task.progress, minHeight: 5),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
