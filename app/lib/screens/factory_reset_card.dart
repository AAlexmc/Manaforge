/// Tarjeta "Reset de fábrica" de Ajustes → Datos.
///
/// Doble freno escrito (pedido literal): primero ELIMINAR, luego CONFIRMAR.
/// El trabajo corre bajo una barrera modal; la barrera se cierra ANTES de
/// avisar con onDone, porque onDone reconstruye la app entera (session bump)
/// y un diálogo canPop:false superviviente la dejaría congelada.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/t.dart';
import '../services/backup.dart';
import '../services/factory_reset.dart';

/// Solo para tests (como kRestoreConfirmWord): la palabra del primer freno.
const String kFactoryResetWord = 'ELIMINAR';

class FactoryResetCard extends StatefulWidget {
  /// Copia previa + borrado. NO debe disparar el session bump.
  final Future<FactoryResetReport> Function() wipe;

  /// Se llama SOLO si el borrado terminó: la app entera vuelve a empezar.
  final VoidCallback onDone;

  const FactoryResetCard({super.key, required this.wipe, required this.onDone});

  @override
  State<FactoryResetCard> createState() => _FactoryResetCardState();
}

class _FactoryResetCardState extends State<FactoryResetCard> {
  bool _busy = false;
  String? _error;

  Future<bool> _confirmar(
      {required String titulo,
      required String cuerpo,
      required String palabra,
      required String accion}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        var escrito = '';
        return StatefulBuilder(builder: (context, setSheet) {
          final t = tr(context);
          final colores = Theme.of(context).colorScheme;
          final puede = escrito.trim().toUpperCase() == palabra.toUpperCase();
          return AlertDialog(
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cuerpo),
                const SizedBox(height: 16),
                Text(t.rfTypeWord(palabra),
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    hintText: palabra,
                  ),
                  onChanged: (v) => setSheet(() => escrito = v),
                  onSubmitted: (_) {
                    if (escrito.trim().toUpperCase() ==
                        palabra.toUpperCase()) {
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(t.acCancel)),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: colores.error,
                    foregroundColor: colores.onError),
                onPressed:
                    puede ? () => Navigator.of(context).pop(true) : null,
                child: Text(accion),
              ),
            ],
          );
        });
      },
    );
    return ok ?? false;
  }

  /// Corre [action] con la barrera modal delante (clon de
  /// `BackupCard._conLaAppQuieta`, backup_screen.dart): la barrera se cierra
  /// en el `finally`, es decir SIEMPRE antes de que quien llama siga adelante
  /// y dispare `onDone`.
  ///
  /// El `pop` NO se guarda con `mounted`: si la tarjeta se desmonta mientras
  /// [action] corre, la barrera (`canPop: false`) se queda huérfana y congela
  /// la app entera si nadie la cierra. `Navigator.of` con la key del
  /// diálogo (no `context`, que ya no sirve) puede fallar si la propia app se
  /// ha desmontado entera; ahí ya no hay nada que cerrar.
  Future<T> _conLaAppQuieta<T>(Future<T> Function() action) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    unawaited(showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(tr(dialogContext).rfWorking)),
          ]),
        ),
      ),
    ));
    try {
      return await action();
    } finally {
      try {
        navigator.pop();
      } catch (_) {/* ya no hay nada que cerrar: la app se ha desmontado */}
    }
  }

  Future<void> _avisoSimple(String texto) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(tr(dialogContext).onbGotIt),
          ),
        ],
      ),
    );
  }

  Future<void> _flujo() async {
    final t = tr(context);
    final paso1 = await _confirmar(
        titulo: t.rfConfirmTitle1,
        cuerpo: '${t.rfWillDelete}\n\n${t.rfBackupFirst}',
        palabra: t.rfDeleteWord,
        accion: t.rfContinueAction);
    if (!paso1 || !mounted) return;
    final paso2 = await _confirmar(
        titulo: t.rfConfirmTitle2,
        cuerpo: t.rfConfirmBody2,
        palabra: t.bkConfirmWord,
        accion: t.rfEraseAction);
    if (!paso2 || !mounted) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    FactoryResetReport report;
    try {
      report = await _conLaAppQuieta(widget.wipe);
    } on BackupError catch (e) {
      // la copia previa ha fallado: nada se ha borrado, la tarjeta sigue
      // viva y NO se avisa a onDone (no hay session bump que hacer)
      if (!mounted) return;
      final t2 = tr(context);
      setState(() {
        _busy = false;
        _error = t2.rfBackupFailed(backupErrorText(t2, e));
      });
      return;
    } on FactoryResetHalfDone catch (_) {
      // se quedó a medias EN CALIENTE (bases cerradas, fondo limpiado o
      // barrido a mitad): la app tiene que reconstruirse sí o sí, así que
      // onDone se llama ANTES de cualquier `if (!mounted) return` de aquí
      // abajo — si la tarjeta ya se ha desmontado, el aviso se salta, pero
      // el bump no
      await _avisoSimple(t.rfHalfDone);
      widget.onDone();
      return;
    }

    if (report.failed.isNotEmpty) {
      await _avisoSimple(t.rfPartial(report.failed.join(', ')));
    }
    widget.onDone();
    if (!mounted) return;
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    final colores = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.restart_alt, color: colores.error),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(t.rfTitle,
                      style: Theme.of(context).textTheme.titleMedium)),
            ]),
            const SizedBox(height: 6),
            Text(t.rfIntro, style: const TextStyle(fontSize: 12.5)),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: colores.error)),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: colores.error,
                  foregroundColor: colores.onError),
              onPressed: _busy ? null : _flujo,
              icon: const Icon(Icons.delete_forever),
              label: Text(t.rfButton),
            ),
          ],
        ),
      ),
    );
  }
}
