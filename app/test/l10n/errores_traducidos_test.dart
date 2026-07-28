/// Los fallos que se le enseñan a la persona salen de una traducción, no del
/// texto en español que lleva la excepción dentro. Si alguien añade un código
/// nuevo y se olvida de la clave, esto lo caza: el `switch` dejaría de
/// compilar, pero un `other` mal puesto (o una clave vacía) no.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/l10n/app_localizations.dart';
import 'package:manaforge_app/l10n/app_localizations_en.dart';
import 'package:manaforge_app/l10n/app_localizations_es.dart';
import 'package:manaforge_app/data/services/backup.dart';
import 'package:manaforge_app/data/services/linux_camera.dart';
import 'package:manaforge_app/utils/safe_input.dart';

/// Argumentos de mentira, tantos como el código que más pide.
const _args = ['1', '2', '3', '4'];

void main() {
  final idiomas = <String, AppLocalizations>{
    'es': AppLocalizationsEs(),
    'en': AppLocalizationsEn(),
  };

  idiomas.forEach((nombre, t) {
    test('cada fallo de copia se sabe contar en $nombre', () {
      for (final code in BackupErrorCode.values) {
        final texto =
            backupErrorText(t, BackupError('en español', code: code, args: _args));
        expect(texto.trim(), isNotEmpty, reason: '$code');
        expect(texto, isNot(contains('{')), reason: '$code deja un hueco sin rellenar');
        if (code != BackupErrorCode.other) {
          expect(texto, isNot(equals('en español')), reason: '$code no está traducido');
        }
      }
    });

    test('cada rechazo de lo que entra de fuera se sabe contar en $nombre', () {
      for (final code in InputRejectedCode.values) {
        final texto = inputRejectedText(t, InputRejected('en español', code: code));
        expect(texto.trim(), isNotEmpty, reason: '$code');
        if (code != InputRejectedCode.other) {
          expect(texto, isNot(equals('en español')), reason: '$code no está traducido');
        }
      }
    });

    test('cada fallo de cámara se sabe contar en $nombre', () {
      for (final code in CameraErrorCode.values) {
        final texto = cameraErrorText(
            t, CameraUnavailable('en español', code: code, args: _args));
        expect(texto.trim(), isNotEmpty, reason: '$code');
        expect(texto, isNot(contains('{')), reason: '$code deja un hueco sin rellenar');
        if (code != CameraErrorCode.other) {
          expect(texto, isNot(equals('en español')), reason: '$code no está traducido');
        }
      }
    });

    test('el almacén de una copia se nombra en cristiano en $nombre', () {
      for (final store in kBackupStores) {
        final texto = backupStoreName(t, store);
        expect(texto.trim(), isNotEmpty, reason: store);
        expect(texto, isNot(equals(store)), reason: '$store se queda sin nombre');
      }
    });
  });
}
