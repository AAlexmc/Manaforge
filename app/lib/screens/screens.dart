import 'dart:io';
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../services/app_update.dart';
import '../services/background_prefs.dart';
import '../services/card_database.dart';
import '../l10n/app_localizations.dart';
import '../l10n/t.dart';
import '../services/language_prefs.dart';
import '../theme/mf_theme.dart';
import '../widgets/app_shortcuts.dart';
import '../widgets/background_settings.dart';
import '../widgets/language_settings.dart';
import '../widgets/update_notice.dart';
import 'backup_screen.dart';

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

  /// Los datos de disco han cambiado (se ha restaurado una copia): hay que
  /// releerlo todo.
  final VoidCallback onRestored;

  const AjustesScreen(
      {super.key,
      required this.db,
      required this.onRestored,
      this.updates,
      this.background,
      this.language});

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
            const SizedBox(height: 12),
            Text(t.settingsIntro),
            const SizedBox(height: 20),
            if (widget.language != null) ...[
              LanguageSettingsCard(prefs: widget.language!),
              const SizedBox(height: 12),
            ],
            // qué es cada pestaña. Alguien que abre la app por primera vez
            // ve siete iconos y ninguna explicación
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
                                    style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (widget.updates != null) ...[
              UpdateSettingsCard(checker: widget.updates!),
              const SizedBox(height: 12),
            ],
            if (widget.background != null) ...[
              BackgroundSettingsCard(prefs: widget.background!),
              const SizedBox(height: 12),
            ],
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
            BackupCard(dataDir: _dataDir, onRestored: widget.onRestored),
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
