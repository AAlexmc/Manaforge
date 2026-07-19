import 'package:flutter/material.dart';

import '../services/scanner_database.dart';

/// Puerta de la base de huellas: si aún no está descargada enseña el
/// explicador + botón de descarga con progreso; cuando está lista pinta
/// [child]. La comparten la pantalla de foto y la de cámara en vivo.
class ScannerDbGate extends StatefulWidget {
  final ScannerDatabase scanner;
  final WidgetBuilder builder;

  const ScannerDbGate(
      {super.key, required this.scanner, required this.builder});

  @override
  State<ScannerDbGate> createState() => _ScannerDbGateState();
}

class _ScannerDbGateState extends State<ScannerDbGate> {
  bool? _ready;
  double? _progress;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.scanner.isReady().then((ready) {
      if (mounted) setState(() => _ready = ready);
    });
  }

  Future<void> _download() async {
    setState(() {
      _progress = 0;
      _error = null;
    });
    try {
      await for (final p in widget.scanner.download()) {
        if (mounted) setState(() => _progress = p < 0 ? null : p);
      }
      if (mounted) {
        setState(() {
          _ready = true;
          _progress = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _progress = null;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_ready == true) return widget.builder(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Icon(Icons.fingerprint, size: 56),
          const SizedBox(height: 12),
          Text('El ojo del escáner',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Para reconocer cartas sin internet necesito la base de huellas '
            'visuales (~12 MB): la firma del arte de cada ilustración de '
            'Magic. Se descarga una vez.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (_progress != null) ...[
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 8),
            Text(
              'Descargando… ${((_progress ?? 0) * 100).toStringAsFixed(0)} %',
              textAlign: TextAlign.center,
            ),
          ] else
            FilledButton.icon(
              onPressed: _download,
              icon: const Icon(Icons.download),
              label: const Text('Descargar base de huellas'),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
