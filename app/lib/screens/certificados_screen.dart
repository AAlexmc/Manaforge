import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../services/database_download_error.dart';
import '../l10n/app_localizations.dart';
import '../l10n/t.dart';
import '../services/card_database.dart';
import '../services/certificate_store.dart';
import '../services/certificates.dart';
import '../services/collection_sets.dart';
import '../services/collection_store.dart';
import '../theme/mf_theme.dart';
import '../widgets/common.dart';
import 'first_card_pick_screen.dart';

// El papel se pinta en el idioma de la app: el certificado solo guarda datos
// (qué clase es, la fecha ISO, el nombre propio de la expansión) y aquí se le
// pone el texto que toca.
String _certHeading(AppLocalizations t, EarnedCertificate c) =>
    c.kind == CertificateKind.welcome
        ? t.certHeadingWelcome
        : t.certHeadingSetComplete;

String _certSubtitle(AppLocalizations t, EarnedCertificate c) =>
    c.kind == CertificateKind.welcome
        ? t.certSubtitleWelcome
        : t.certSubtitleSetComplete;

String _certTitle(AppLocalizations t, EarnedCertificate c) =>
    c.kind == CertificateKind.welcome ? t.certWelcomeTitle : c.title;

/// La fecha del papel en el idioma de la app ('21 de julio de 2026', 'July 21,
/// 2026'…). Si el ISO viene roto, se enseña tal cual.
String _certFecha(BuildContext context, String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return DateFormat.yMMMMd(Localizations.localeOf(context).toString())
      .format(d);
}

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
    final today = certificateDay(DateTime.now());
    // el de bienvenida se calcula aparte y ANTES: solo mira cuántas cartas
    // tienes, así que una base de datos ausente no debe hacértelo perder
    final welcome =
        welcomeCertificate(copies: widget.collection.totalCopies, today: today);
    try {
      final owned = await ownedCardsBySet(widget.db, widget.collection);
      final sets = await widget.db.sets();
      final certs = allCertificates(
        // el de bienvenida solo necesita que tengas UNA carta: no depende de
        // la base de datos ni de saber las ediciones exactas
        copies: widget.collection.totalCopies,
        ownedBySet: owned,
        // igual que el logro "expansión completa": sin saber las ediciones
        // exactas, lo poseído no cuenta básicas y el total sí, así que
        // nunca cuadraría (y saldrían cero certificados por otra razón)
        setTotals: widget.collection.hasPrintingData
            ? {for (final s in sets) s.code: s.total}
            : const <String, int>{},
        setNames: {for (final s in sets) s.code: s.name},
        today: today,
      );
      final synced = widget.certificates.sync(certs);
      if (mounted) setState(() => _certs = synced);
    } catch (e) {
      if (mounted) {
        setState(() {
          // sin base de datos no hay certificados de expansión, pero el de
          // bienvenida sí se puede dar
          _certs = widget.certificates.sync([if (welcome != null) welcome]);
          _error = tr(context).ceNeedDb(downloadErrorText(tr(context), e));
        });
      }
    }
  }

  Future<void> _editName() async {
    final ctrl = TextEditingController(text: widget.certificates.ownerName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context).ceWhoseName),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              labelText: tr(context).fdName,
              hintText: tr(context).ceCollectorName),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr(context).acCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(ctrl.text),
              child: Text(tr(context).fdSave)),
        ],
      ),
    );
    if (name != null) widget.certificates.setOwnerName(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context).acCertsTooltip),
        actions: [
          IconButton(
            tooltip: tr(context).ceInNameOf,
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
                      (widget.collection.hasPrintingData
                          ? tr(context).ceEmptyWithData
                          : tr(context).ceEmptyNoData),
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
              final t = tr(context);
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: const Icon(Icons.workspace_premium,
                      color: MFColors.forge, size: 32),
                  title: Text(_certTitle(t, cert),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(cert.cards > 0
                      ? '${_certSubtitle(t, cert)} · ${t.certCards(cert.cards)} · '
                          '${_certFecha(context, cert.earnedAt)}\n${cert.code}'
                      : '${_certSubtitle(t, cert)} · '
                          '${_certFecha(context, cert.earnedAt)}\n${cert.code}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CertificateViewScreen(
                        certificate: cert,
                        certificates: widget.certificates,
                        collection: widget.collection,
                      ),
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

  /// De aquí salen el nombre y la carta con la que empezaste, y por eso la
  /// pantalla se entera sola cuando cambian.
  final CertificateStore certificates;

  /// La colección, para poder elegir la carta. Null = no se ofrece elegirla.
  final CollectionStore? collection;

  const CertificateViewScreen(
      {super.key,
      required this.certificate,
      required this.certificates,
      this.collection});

  @override
  State<CertificateViewScreen> createState() => _CertificateViewScreenState();
}

class _CertificateViewScreenState extends State<CertificateViewScreen> {
  final _boundaryKey = GlobalKey();
  bool _saving = false;

  /// Elegir (o quitar) la carta con la que empezó en Magic.
  Future<void> _pickFirstCard() async {
    final collection = widget.collection;
    if (collection == null) return;
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (_) => FirstCardPickScreen(
          collection: collection,
          selected: widget.certificates.firstCard?.oracleId,
        ),
      ),
    );
    if (result == null) return; // atrás: no se toca el recuerdo
    widget.certificates
        .setFirstCard(isRemoveFirstCard(result) ? null : result as FirstCard);
  }

  Future<void> _download() async {
    // los textos se cogen ANTES de los await: usar el context tras uno es un
    // aviso del analizador
    final t = tr(context);
    setState(() => _saving = true);
    String? message;
    try {
      // la imagen de la carta se pinta con Image.network: si aún no está
      // descargada, el PNG saldría con un hueco donde va el recuerdo
      final url = widget.certificates.firstCard?.image;
      if (url != null && mounted) {
        try {
          await precacheImage(NetworkImage(url), context);
        } catch (_) {/* sin imagen: el papel sale igual, sin la carta */}
      }
      if (!mounted) return;
      final path = await saveCertificatePng(
        _boundaryKey,
        'certificado-${widget.certificate.id.replaceAll(':', '-')}.png',
      );
      message = path == null ? t.ceNothingSaved : t.ceSavedTo(path);
    } catch (e) {
      message = t.ceSaveFailed('$e');
    }
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final esBienvenida = widget.certificate.id == kWelcomeCertificateId;
    return Scaffold(
      appBar: AppBar(title: Text(widget.certificate.title)),
      // escuchando al almacén: elegir la carta tiene que verse en el papel
      // en el momento, sin volver atrás y entrar otra vez
      body: ListenableBuilder(
        listenable: widget.certificates,
        builder: (context, _) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  key: _boundaryKey,
                  child: CertificateCard(
                    certificate: widget.certificate,
                    ownerName: widget.certificates.ownerName,
                    firstCard: widget.certificates.firstCard,
                  ),
                ),
                const SizedBox(height: 20),
                if (esBienvenida && widget.collection != null)
                  TextButton.icon(
                    onPressed: _saving ? null : _pickFirstCard,
                    icon: const Icon(Icons.auto_stories_outlined),
                    label: Text(widget.certificates.firstCard == null
                        ? tr(context).cePickFirstCard
                        : tr(context).ceChangeFirstCard),
                  ),
                FilledButton.icon(
                  onPressed: _saving ? null : _download,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.download),
                  label: Text(tr(context).ceDownloadPng),
                ),
              ],
            ),
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

  /// La carta con la que el usuario empezó en Magic. Solo sale en el
  /// certificado de bienvenida: en el de una expansión completa no pinta nada.
  final FirstCard? firstCard;

  const CertificateCard(
      {super.key,
      required this.certificate,
      required this.ownerName,
      this.firstCard});

  FirstCard? get _memoria =>
      certificate.id == kWelcomeCertificateId ? firstCard : null;

  @override
  Widget build(BuildContext context) {
    final t = tr(context);
    final titulo = _certTitle(t, certificate);
    const ink = Color(0xFF1A1526);
    const gold = Color(0xFFC9A227);
    // Cinzel son capitales romanas: es la letra de los diplomas de toda la
    // vida y aguanta el espaciado grande sin apelmazarse. Va con
    // `fontVariations` porque el fichero es una fuente VARIABLE: pedirle
    // `fontWeight` a secas no mueve el eje de peso.
    const romana = 'Cinzel';
    const negrita = [FontVariation('wght', 700)];
    const normal = [FontVariation('wght', 400)];
    // un título largo (el de bienvenida) no puede desbordar el papel
    final tituloGrande = titulo.length <= 22;
    return Container(
      width: 420,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3E8), // pergamino
        border: Border.all(color: gold, width: 3),
        borderRadius: BorderRadius.circular(6),
      ),
      // filete interior: el marco doble es lo que hace que un papel parezca
      // un diploma y no una tarjeta
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        decoration: BoxDecoration(
          border: Border.all(color: gold.withValues(alpha: 0.55)),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: gold, size: 30),
            const SizedBox(height: 8),
            const Text('MANAFORGE',
                style: TextStyle(
                    color: ink,
                    fontFamily: romana,
                    fontVariations: negrita,
                    fontSize: 13,
                    letterSpacing: 6)),
            const SizedBox(height: 18),
            Text(_certHeading(t, certificate),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: ink,
                    fontFamily: romana,
                    fontVariations: normal,
                    fontSize: 10.5,
                    letterSpacing: 2.2)),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ink,
                  fontFamily: romana,
                  fontVariations: negrita,
                  fontSize: tituloGrande ? 26 : 21,
                  height: 1.2,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
                // el de bienvenida no va de cantidad: enseñar "0 cartas"
                // sería absurdo
                certificate.cards > 0
                    ? '${_certSubtitle(t, certificate)} · '
                        '${t.certCards(certificate.cards)}'
                    : _certSubtitle(t, certificate),
                textAlign: TextAlign.center,
                style: const TextStyle(color: ink, fontSize: 12)),
            if (_memoria != null) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CardThumb(
                  url: _memoria!.image,
                  colors: '',
                  name: _memoria!.name,
                  width: 108,
                  height: 151,
                  radius: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(t.certStartedWith(_memoria!.name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: ink,
                      fontFamily: romana,
                      fontVariations: normal,
                      fontSize: 13,
                      letterSpacing: 0.4)),
            ],
            const SizedBox(height: 18),
            Container(height: 1, width: 180, color: gold),
            const SizedBox(height: 18),
            Text(
              ownerName.isEmpty
                  ? t.certCollectorAnon
                  : t.certAwardedTo(ownerName),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ink,
                fontFamily: romana,
                fontVariations: normal,
                fontSize: 15,
                letterSpacing: 0.6,
                fontStyle: ownerName.isEmpty ? FontStyle.italic : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(t.certOnDate(_certFecha(context, certificate.earnedAt)),
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
                Text(t.certDataBy,
                    style: const TextStyle(color: ink, fontSize: 9)),
              ],
            ),
          ],
        ),
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
  Uint8List bytes;
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return null;
    bytes = data.buffer.asUint8List();
  } finally {
    image.dispose();
  }

  FileSaveLocation? location;
  try {
    location = await getSaveLocation(
      suggestedName: name,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'PNG', extensions: ['png'])
      ],
    );
  } catch (_) {
    // esta plataforma no tiene diálogo de guardar: a Descargas
    final dir =
        await getDownloadsDirectory() ?? await getApplicationSupportDirectory();
    // basename: el nombre lo arma la app a partir del código de la edición,
    // que sale de la base descargada. Un código con `../` dentro escaparía de
    // Descargas y escribiría donde no toca
    final file = File(p.join(dir.path, p.basename(name)));
    await file.writeAsBytes(bytes);
    return file.path;
  }
  // el usuario canceló: no hay que inventarse un guardado
  if (location == null) return null;
  // si esto falla (permisos), que se entere: NO se guarda a escondidas en
  // otro sitio y se canta esa ruta como si fuera la que pidió
  await File(location.path).writeAsBytes(bytes);
  return location.path;
}
