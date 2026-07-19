import 'package:flutter/material.dart';

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

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Placeholder(
      title: 'Ajustes',
      subtitle: 'ManaForge es gratis y de código abierto (MIT). Sin anuncios, '
          'sin premium, sin cuentas. Tus cartas son tuyas.\n\n'
          'Datos e imágenes de cartas por Scryfall. Magic: The Gathering es '
          'propiedad de Wizards of the Coast; proyecto de fans al amparo de su '
          'Fan Content Policy.',
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
