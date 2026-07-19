import 'package:flutter/material.dart';

import '../services/card_database.dart';
import '../theme/mf_theme.dart';

export 'album_screen.dart';
export 'coleccion_screen.dart';
export 'mazos_screen.dart';
export 'test_screen.dart';
export 'deck_detail_screen.dart';
export 'forge_screen.dart';
export 'import_csv_screen.dart';

/// Pantallas aún en esqueleto (se implementan sobre COMPONENT-SPECS.md).
class _Placeholder extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Placeholder({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class TradesScreen extends StatelessWidget {
  const TradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Placeholder(
      title: 'Trades',
      subtitle: 'El balance se actualizará en vivo mientras añadís cartas. '
          'En construcción.',
    );
  }
}

class AjustesScreen extends StatefulWidget {
  final CardDatabase db;

  const AjustesScreen({super.key, required this.db});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  double? _progress;
  String? _status;

  Future<void> _redownload() async {
    setState(() {
      _progress = 0;
      _status = null;
    });
    try {
      await for (final p in widget.db.download()) {
        if (mounted) setState(() => _progress = p < 0 ? null : p);
      }
      if (mounted) {
        setState(() {
          _progress = null;
          _status = '✓ Base de datos actualizada';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _progress = null;
          _status = 'No se pudo actualizar: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Ajustes', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text(
                'ManaForge es gratis y de código abierto (MIT). Sin anuncios, '
                'sin premium, sin cuentas. Tus cartas son tuyas.'),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Base de datos de cartas',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    const Text(
                        'Vuelve a descargarla para tener cartas nuevas, '
                        'precios frescos y las funciones que piden datos '
                        'recientes (como el filtro por año en Forge).',
                        style: TextStyle(fontSize: 12.5)),
                    const SizedBox(height: 12),
                    if (_progress != null) ...[
                      LinearProgressIndicator(value: _progress),
                      const SizedBox(height: 6),
                      Text(
                          'Descargando… ${((_progress ?? 0) * 100).toStringAsFixed(0)} %'),
                    ] else
                      FilledButton.icon(
                        onPressed: _redownload,
                        icon: const Icon(Icons.refresh),
                        label:
                            const Text('Volver a descargar la base de datos'),
                      ),
                    if (_status != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(_status!),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
                'Datos e imágenes de cartas por Scryfall. Magic: The Gathering '
                'es propiedad de Wizards of the Coast; proyecto de fans al '
                'amparo de su Fan Content Policy.',
                style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// Icono de la pestaña Forge con su color exclusivo (violeta del DesignSystem).
class ForgeTabIcon extends StatelessWidget {
  final bool selected;

  const ForgeTabIcon({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected ? Icons.auto_awesome : Icons.auto_awesome_outlined,
      color: MFColors.forge,
    );
  }
}
