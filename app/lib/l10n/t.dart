/// Atajo para las traducciones, con red de seguridad.
///
/// `AppLocalizations.of(context)` revienta si en ese punto del árbol no hay
/// delegados de traducción (un diálogo suelto, un test que monta un widget a
/// pelo). Un texto en el idioma de casa es mucho mejor que una pantalla roja,
/// así que aquí se cae al español en vez de lanzar.
library;

import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import 'app_localizations_es.dart';

final AppLocalizations _deCasa = AppLocalizationsEs();

AppLocalizations tr(BuildContext context) =>
    Localizations.of<AppLocalizations>(context, AppLocalizations) ?? _deCasa;
