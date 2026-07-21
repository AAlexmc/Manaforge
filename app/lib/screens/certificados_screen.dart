import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../services/card_database.dart';
import '../services/certificate_store.dart';
import '../services/certificates.dart';
import '../services/collection_sets.dart';
import '../services/collection_store.dart';
import '../theme/mf_theme.dart';

/// Certificados: por completar una expansión entera te llevas un papel con
/// tu nombre, la fecha y un código, y te lo puedes descargar en PNG.
class CertificadosScreen extends StatefulWidget {
  final CardDatabase db;
  final CollectionStore collection;
  final CertificateStore certificates;

  const CertificadosScreen({
    super.key,
    required this.db,
    required this.collection,
    required this.certificates,
  });

  @override
  State<CertificadosScreen> createState() => _CertificadosScreenState();
}

class _CertificadosScreenState extends State<CertificadosScreen> {
  List<EarnedCertificate>? _certs;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.certificates.load().then((_) => _compute());
  }

  Future<void> _compute() async {
    try {
      final owned = await ownedCardsBySet(widget.db, widget.collection);
      final sets = await widget.db.sets();
      final certs = certificatesForSets(
        ownedBySet: owned,
        setTotals: {for (final s in sets) s.code: s.total},
        setNames: {for (final s in sets) s.code: s.name},
        today: certificateDay(DateTime.now()),
      );
      final synced = widget.certificates.sync(certs);
      if (mounted) setState(() => _certs = synced);
    } catch (e) {
      if (mounted) {
        setState(() {
          _certs = const [];
          _error = 'Hace falta la base de datos de cartas ($e)';
        });
      }
    }
  }

  Future<void> _editName() async {
    final ctrl = TextEditingController(text: widget.certificates.ownerName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿A nombre de quién?'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Nombre', hintText: 'Tu nombre de coleccionista'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(ctrl.text),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (name != null) widget.certificates.setOwnerName(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificados'),
        actions: [
          IconButton(
            tooltip: 'A nombre de…',
            icon: const Icon(Icons.badge_outlined),
            onPressed: _editName,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.certificates,
        builder: (context, _) {
          final certs = _certs;
          if (certs == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (certs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  _error ??
                      'Todavía no tienes ninguna expansión completa. Cuando '
                          'completes una entera en el Álbum, aquí saldrá tu '
                          'certificado para descargar.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: certs.length,
            itemBuilder: (context, i) {
              final cert = certs[i];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: const Icon(Icons.workspace_premium,
                      color: MFColors.forge, size: 32),
                  title: Text(cert.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${cert.subtitle} · ${cert.cards} cartas · '
                      '${prettyDate(cert.earnedAt)}\n${cert.code}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CertificateViewScreen(
                          certificate: cert,
                          ownerName: widget.certificates.ownerName),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// El certificado a tamaño completo, con su botón de descarga.
class CertificateViewScreen extends StatefulWidget {
  final EarnedCertificate certificate;
  final String ownerName;

  const CertificateViewScreen(
      {super.key, required this.certificate, required this.ownerName});

  @override
  State<CertificateViewScreen> createState() => _CertificateViewScreenState();
}

class _CertificateViewScreenState extends State<CertificateViewScreen> {
  final _boundaryKey = GlobalKey();
  bool _saving = false;

  Future<void> _download() async {
    setState(() => _saving = true);
    String? message;
    try {
      final path = await saveCertificatePng(
        _boundaryKey,
        'certificado-${widget.certificate.id.replaceAll(':', '-')}.png',
      );
      message = path == null
          ? 'No se guardó nada.'
          : '✓ Certificado guardado en $path';
    } catch (e) {
      message = 'No se pudo guardar: $e';
    }
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.certificate.title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: _boundaryKey,
                child: CertificateCard(
                    certificate: widget.certificate,
                    ownerName: widget.ownerName),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saving ? null : _download,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.download),
                label: const Text('Descargar PNG'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// El papel en sí. Se pinta igual en pantalla y en el PNG.
class CertificateCard extends StatelessWidget {
  final EarnedCertificate certificate;
  final String ownerName;

  const CertificateCard(
      {super.key, required this.certificate, required this.ownerName});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1A1526);
    const gold = Color(0xFFC9A227);
    return Container(
      width: 420,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3E8), // pergamino
        border: Border.all(color: gold, width: 3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: gold, size: 30),
          const SizedBox(height: 6),
          const Text('MANAFORGE',
              style: TextStyle(
                  color: ink,
                  fontSize: 13,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          const Text('CERTIFICADO DE COLECCIÓN COMPLETA',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ink, fontSize: 11, letterSpacing: 1.6)),
          const SizedBox(height: 18),
          Text(
            certificate.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: ink,
                fontSize: 24,
                height: 1.15,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('${certificate.subtitle} · ${certificate.cards} cartas',
              style: const TextStyle(color: ink, fontSize: 12)),
          const SizedBox(height: 18),
          Container(height: 1, width: 180, color: gold),
          const SizedBox(height: 18),
          Text(
            ownerName.isEmpty
                ? 'Coleccionista de ManaForge'
                : 'Otorgado a $ownerName',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ink,
              fontSize: 14,
              fontStyle: ownerName.isEmpty ? FontStyle.italic : null,
            ),
          ),
          const SizedBox(height: 4),
          Text('el ${prettyDate(certificate.earnedAt)}',
              style: const TextStyle(color: ink, fontSize: 12)),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(certificate.code,
                  style: const TextStyle(
                      color: ink,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontFeatures: [FontFeature.tabularFigures()])),
              const Text('Datos por Scryfall',
                  style: TextStyle(color: ink, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pinta el certificado a PNG y lo guarda donde diga el usuario. Devuelve la
/// ruta, o null si canceló. Si el diálogo de guardar no está disponible
/// (según plataforma), cae a la carpeta de Descargas.
Future<String?> saveCertificatePng(GlobalKey boundaryKey, String name) async {
  final boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return null;
  final image = await boundary.toImage(pixelRatio: 3);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (data == null) return null;
  final bytes = data.buffer.asUint8List();

  try {
    final location = await getSaveLocation(
      suggestedName: name,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'PNG', extensions: ['png'])
      ],
    );
    if (location != null) {
      await File(location.path).writeAsBytes(bytes);
      return location.path;
    }
    // el usuario canceló: no hay que inventarse un guardado
    return null;
  } catch (_) {
    // sin diálogo nativo: a Descargas
    final dir = await getDownloadsDirectory() ??
        await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
