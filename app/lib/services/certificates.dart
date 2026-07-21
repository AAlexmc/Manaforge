/// Certificados: el papelito que te llevas por completar una colección
/// entera. Aquí está la lógica pura (qué está completo y con qué código);
/// el almacén guarda cuándo lo conseguiste y a nombre de quién.
library;

/// Un certificado ganado.
class EarnedCertificate {
  /// 'set:aer' — identifica lo que se ha completado.
  final String id;
  final String title; // 'Aether Revolt'
  final String subtitle; // 'Expansión completa'
  final int cards; // casillas de la colección completada
  final String earnedAt; // 'YYYY-MM-DD'

  const EarnedCertificate({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cards,
    required this.earnedAt,
  });

  /// Código corto e irrepetible del certificado: mismo logro + misma fecha =
  /// mismo código, así el papel se puede volver a generar igualito.
  String get code => certificateCode(id, earnedAt);

  EarnedCertificate withDate(String date) => EarnedCertificate(
        id: id,
        title: title,
        subtitle: subtitle,
        cards: cards,
        earnedAt: date,
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
      subtitle: 'Expansión completa',
      cards: total,
      earnedAt: today,
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

/// '21 de julio de 2026' para el papel.
String prettyDate(String isoDay) {
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  final parts = isoDay.split('-');
  if (parts.length != 3) return isoDay;
  final month = int.tryParse(parts[1]) ?? 0;
  if (month < 1 || month > 12) return isoDay;
  final day = int.tryParse(parts[2]) ?? 0;
  return '$day de ${months[month - 1]} de ${parts[0]}';
}
