import 'package:flutter/material.dart';

import '../theme/mf_theme.dart';

/// Pantallas placeholder del esqueleto: cada una se sustituirá por su
/// implementación real siguiendo DesignSystem/COMPONENT-SPECS.md.
class _Placeholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? fab;

  const _Placeholder({required this.title, required this.subtitle, this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab,
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

class ColeccionScreen extends StatelessWidget {
  const ColeccionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Placeholder(
      title: 'Colección',
      subtitle: 'Tu colección empieza aquí. Apunta la cámara a una carta o '
          'importa tu CSV de ManaBox.',
      fab: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escanear'),
      ),
    );
  }
}

class MazosScreen extends StatelessWidget {
  const MazosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Placeholder(
      title: 'Mis mazos',
      subtitle: 'Forge puede montarte mazos cuando quieras.',
    );
  }
}

class ForgeScreen extends StatelessWidget {
  const ForgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Placeholder(
      title: 'Forge',
      subtitle: 'Mazos completos y jugables con las cartas que ya tienes. '
          'Sin comprar nada.',
    );
  }
}

class TradesScreen extends StatelessWidget {
  const TradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Placeholder(
      title: 'Trades',
      subtitle: 'El balance se actualiza en vivo mientras añadís cartas.',
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
