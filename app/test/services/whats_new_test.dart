/// "Qué hay de nuevo".
///
/// Lo delicado es CUÁNDO sale: a quien estrena la app no se le enseña un
/// changelog (no tiene nada que comparar), y a quien actualiza hay que
/// enseñárselo aunque venga de una versión que no guardaba esta preferencia.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/services/backup.dart' show kAppVersion;
import 'package:manaforge_app/services/whats_new.dart';

void main() {
  test('la versión que corre tiene sus novedades escritas', () {
    // si esto falla al publicar, es que se subió kAppVersion sin contar qué
    // trae: el aviso saldría vacío
    expect(newsFor(kAppVersion), isNotNull);
    expect(currentNews!.bullets, isNotEmpty);
  });

  test('las novedades van de la más nueva a la más vieja', () {
    for (var i = 1; i < kWhatsNew.length; i++) {
      expect(kWhatsNew[i - 1].version.compareTo(kWhatsNew[i].version),
          greaterThan(0));
    }
  });

  group('cuándo se enseña', () {
    test('quien actualiza, sí', () {
      expect(
          shouldShowWhatsNew(current: '0.3.0', seen: '0.2.0'), isTrue);
    });

    test('quien ya las vio, no', () {
      expect(shouldShowWhatsNew(current: '0.3.0', seen: '0.3.0'), isFalse);
    });

    test('quien estrena la app, no', () {
      expect(
          shouldShowWhatsNew(current: '0.3.0', seen: null, firstRun: true),
          isFalse);
      expect(shouldShowWhatsNew(current: '0.3.0', seen: null), isFalse);
    });

    test('una versión sin novedades escritas no abre un cartel vacío', () {
      expect(
          shouldShowWhatsNew(current: '9.9.9', seen: '0.3.0'), isFalse);
    });
  });
}
