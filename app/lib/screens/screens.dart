import 'dart:io';
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../services/app_update.dart';
import '../services/background_prefs.dart';
import '../services/card_database.dart';
import '../l10n/t.dart';
import '../services/home_layout_prefs.dart';
import '../services/language_prefs.dart';
import '../theme/mf_theme.dart';
import '../widgets/app_shortcuts.dart';
import '../widgets/background_settings.dart';
import '../widgets/language_settings.dart';
import '../widgets/update_notice.dart';
import 'backup_screen.dart';
import 'editar_inicio_screen.dart';

export 'album_screen.dart';
export 'backup_screen.dart';
export 'all_cards_screen.dart';
export 'coleccion_screen.dart';
export 'collection_filters.dart';
export 'folder_detail_screen.dart';
export 'folder_pick_screen.dart';
export 'home_screen.dart';
export 'card_detail_screen.dart';
export 'mazos_screen.dart';
export 'mercado_screen.dart';
export 'set_market_screen.dart';
export 'wishlist_screen.dart';
export 'test_screen.dart';
export 'deck_detail_screen.dart';
export 'forge_screen.dart';
export 'import_csv_screen.dart';
export 'live_scan_screen.dart';
export 'scan_screen.dart';
export 'startup_screen.dart';

class AjustesScreen extends StatefulWidget {
  final CardDatabase db;

  /// Aviso de versión nueva. Opcional: sin él, la tarjeta no sale.
  final AppUpdateChecker? updates;

  /// Fondo de pantalla. Opcional por lo mismo.
  final BackgroundPreference? background;

  /// Idioma de la app. Opcional: sin él, no sale el selector.
  final LanguagePreference? language;

  /// Layout de Inicio. Opcional: sin él, no sale "Editar inicio".
  final HomeLayoutPreference? homeLayout;

  /// Los datos de disco han cambiado (se ha restaurado una copia): hay que
  /// releerlo todo.
  final VoidCallback onRestored;

  const AjustesScreen(
      {super.key,
      required this.db,
      required this.onRestored,
      this.updates,
      this.background,
      this.language,
      this.homeLayout});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  double? _progress;
  String? _status;

  /// Dónde viven los datos. Devuelve null si no hay plugin de rutas (tests):
  /// la tarjeta se pinta igual y solo falla al pulsar.
  Future<Directory?> _dataDir() async {
    try {
      return await getApplicationSupportDirectory();
    } catch (_) {
      return null;
    }
  }

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
    final t = tr(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(t.settingsTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(t.settingsIntro),
            const SizedBox(height: 16),
            // el idioma va suelto y el primero: es lo primero que querría
            // cambiar alguien que abrió la app en un idioma que no es el suyo
            if (widget.language != null) ...[
              LanguageSettingsCard(prefs: widget.language!),
              const SizedBox(height: 8),
            ],
            // Apariencia: fondo y qué se ve en Inicio. Abierta de salida
            // porque es lo que la gente viene a tocar.
            _Seccion(
              titulo: 'Apariencia',
              icono: Icons.palette_outlined,
              initiallyExpanded: true,
              children: [
                if (widget.background != null)
                  BackgroundSettingsCard(prefs: widget.background!),
                if (widget.homeLayout != null)
                  _EditarInicioTile(layout: widget.homeLayout!),
              ],
            ),
            const SizedBox(height: 8),
            // Datos: la base de cartas y las copias de seguridad.
            _Seccion(
              titulo: 'Datos',
              icono: Icons.storage_outlined,
              children: [
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
                            label: const Text(
                                'Volver a descargar la base de datos'),
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
                BackupCard(dataDir: _dataDir, onRestored: widget.onRestored),
              ],
            ),
            const SizedBox(height: 8),
            // La app: cómo funciona, versión y créditos.
            _Seccion(
              titulo: 'La app',
              icono: Icons.info_outline,
              children: [
                // qué es cada pestaña. Alguien que abre la app por primera vez
                // ve varios iconos y ninguna explicación
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.howItWorks,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        for (final linea in [
                          (t.tabScan, t.howScan),
                          (t.tabCollection, t.howCollection),
                          (t.tabAlbum, t.howAlbum),
                          ('Forge', t.howForge),
                          (t.tabDecks, t.howDecks),
                          (t.tabMarket, t.howMarket),
                        ])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontSize: 12.5),
                                children: [
                                  TextSpan(
                                      text: '${linea.$1}: ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: linea.$2),
                                ],
                              ),
                            ),
                          ),
                        Text(t.howPrivacy,
                            style: const TextStyle(fontSize: 11.5)),
                        const SizedBox(height: 12),
                        Text(t.shortcuts,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        for (final atajo in shortcutHelp(t))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Text(atajo.$1,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontFeatures: [
                                            FontFeature.tabularFigures()
                                          ],
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                    child: Text(atajo.$2,
                                        style:
                                            const TextStyle(fontSize: 12))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.updates != null)
                  UpdateSettingsCard(checker: widget.updates!),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        'Datos e imágenes de cartas por Scryfall. Magic: The '
                        'Gathering es propiedad de Wizards of the Coast; '
                        'proyecto de fans al amparo de su Fan Content Policy.',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Una sección plegable de Ajustes: un título que se abre y enseña sus
/// tarjetas. Agrupar lo que antes era una lista larga y plana.
class _Seccion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final bool initiallyExpanded;
  final List<Widget> children;

  const _Seccion({
    required this.titulo,
    required this.icono,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      // el ExpansionTile pinta dos líneas divisorias por defecto; sin ellas
      // las secciones se leen como bloques y no como una tabla
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icono),
        title: Text(titulo,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 4),
        childrenPadding: const EdgeInsets.only(bottom: 4),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// La entrada a "Editar inicio" desde Ajustes → Apariencia. El editor de
/// verdad vive en su propia pantalla (`EditarInicioScreen`).
class _EditarInicioTile extends StatelessWidget {
  final HomeLayoutPreference layout;

  const _EditarInicioTile({required this.layout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.tune),
        title: const Text('Editar inicio'),
        subtitle: const Text('Elige qué secciones se ven y en qué orden'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => EditarInicioScreen(layout: layout)),
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
