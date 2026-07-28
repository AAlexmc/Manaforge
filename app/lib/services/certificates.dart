/// Certificados: el papelito que te llevas por completar una colección
/// entera. Aquí está la lógica pura (qué está completo y con qué código);
/// el almacén guarda cuándo lo conseguiste y a nombre de quién.
library;

import 'package:manaforge_app/services/safe_input.dart';

/// Id del certificado de bienvenida, el único que enseña la carta con la que
/// empezaste.
const String kWelcomeCertificateId = 'bienvenida';

/// De qué clase es el certificado. Los textos del papel (encabezado, subtítulo
/// y, en el de bienvenida, el título) se ponen en la pantalla en el idioma de
/// la app; aquí solo viaja el DATO de qué clase es, no el texto.
enum CertificateKind { welcome, setComplete }

/// Un certificado ganado. Solo datos, sin texto de interfaz: el papel se pinta
/// en la pantalla con las traducciones del idioma elegido.
class EarnedCertificate {
  /// 'set:aer' — identifica lo que se ha completado.
  final String id;

  /// Nombre propio que sale grande en el papel (la expansión, p. ej. 'Aether
  /// Revolt'). Vacío en el de bienvenida: su título es traducible y lo pone la
  /// pantalla.
  final String title;

  /// Casillas de la colección completada. A 0 cuando el certificado no va de
  /// cantidad (el de bienvenida), y entonces el papel no la enseña.
  final int cards;
  final String earnedAt; // 'YYYY-MM-DD'

  /// Qué clase de certificado es (decide encabezado y subtítulo en pantalla).
  final CertificateKind kind;

  const EarnedCertificate({
    required this.id,
    required this.title,
    required this.cards,
    required this.earnedAt,
    this.kind = CertificateKind.setComplete,
  });

  /// Código corto e irrepetible del certificado: mismo logro + misma fecha =
  /// mismo código, así el papel se puede volver a generar igualito.
  String get code => certificateCode(id, earnedAt);

  EarnedCertificate withDate(String date) => EarnedCertificate(
        id: id,
        title: title,
        cards: cards,
        earnedAt: date,
        kind: kind,
      );
}

/// Hash corto y estable (FNV-1a en base36) para el código del certificado.
String certificateCode(String id, String earnedAt) {
  var hash = 0x811c9dc5;
  for (final unit in '$id|$earnedAt'.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  final body = hash.toRadixString(36).toUpperCase().padLeft(7, '0');
  return 'MF-${body.substring(body.length - 7)}';
}

/// Qué expansiones tienes ENTERAS. Misma cuenta que el Álbum
/// (`ownedCardsBySet`), para que "álbum completo" signifique lo mismo en las
/// dos pantallas.
List<EarnedCertificate> certificatesForSets({
  required Map<String, int> ownedBySet,
  required Map<String, int> setTotals,
  required Map<String, String> setNames,
  required String today,
}) {
  final out = <EarnedCertificate>[];
  setTotals.forEach((code, total) {
    if (total <= 0) return;
    if ((ownedBySet[code] ?? 0) < total) return;
    out.add(EarnedCertificate(
      id: 'set:$code',
      title: setNames[code] ?? code.toUpperCase(),
      cards: total,
      earnedAt: today,
      kind: CertificateKind.setComplete,
    ));
  });
  out.sort((a, b) => b.cards.compareTo(a.cards));
  return out;
}

/// 'YYYY-MM-DD' del día local.
String certificateDay(DateTime when) {
  two(int n) => n < 10 ? '0$n' : '$n';
  return '${when.year}-${two(when.month)}-${two(when.day)}';
}

/// El primer certificado de todos: por tener una carta. Existe para que
/// nadie abra la pantalla de Certificados y se encuentre el vacío — completar
/// una expansión entera es cosa de meses, y hasta entonces no había NADA que
/// enseñar.
///
/// Devuelve null si aún no hay ni una carta.
EarnedCertificate? welcomeCertificate({
  required int copies,
  required String today,
}) {
  if (copies < 1) return null;
  return EarnedCertificate(
    id: kWelcomeCertificateId,
    // el título ('Bienvenido al mundo de Magic') es traducible: lo pone la
    // pantalla según el idioma. Aquí no hay nombre propio que enseñar.
    title: '',
    // no va de cantidad: da igual si es una carta o si son mil
    cards: 0,
    earnedAt: today,
    kind: CertificateKind.welcome,
  );
}

/// Todos los certificados que tocan ahora mismo, con el de bienvenida
/// SIEMPRE el primero: es el que cuenta cuándo empezaste, así que abre la
/// colección aunque tengas expansiones enteras con muchas más cartas.
List<EarnedCertificate> allCertificates({
  required int copies,
  required Map<String, int> ownedBySet,
  required Map<String, int> setTotals,
  required Map<String, String> setNames,
  required String today,
}) {
  final welcome = welcomeCertificate(copies: copies, today: today);
  return [
    if (welcome != null) welcome,
    ...certificatesForSets(
      ownedBySet: ownedBySet,
      setTotals: setTotals,
      setNames: setNames,
      today: today,
    ),
  ];
}

/// La carta con la que empezaste en Magic, para que salga en el certificado
/// de bienvenida. Es un recuerdo, no un dato de la colección: se guarda con
/// su nombre y su imagen dentro, así que sigue saliendo aunque un día
/// vendas esa carta o falte la base de datos.
class FirstCard {
  final String oracleId;
  final String name;
  final String? image;

  const FirstCard({required this.oracleId, required this.name, this.image});

  Map<String, dynamic> toJson() => {
        'oracleId': oracleId,
        'name': name,
        if (image != null) 'image': image,
      };

  /// null si el JSON no trae lo mínimo (id y nombre): media carta guardada no
  /// vale para enseñar nada.
  static FirstCard? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['oracleId'];
    final name = json['name'];
    if (id is! String || id.isEmpty) return null;
    if (name is! String || name.isEmpty) return null;
    // la URL se filtra al LEER: este fichero puede venir de una copia
    // restaurada que te haya pasado otra persona
    final image = json['image'];
    return FirstCard(
        oracleId: id,
        name: name,
        image: safeCardImageUrl(image is String ? image : null));
  }
}
