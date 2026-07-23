// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tabHome => 'Start';

  @override
  String get tabCollection => 'Sammlung';

  @override
  String get tabAlbum => 'Album';

  @override
  String get tabDecks => 'Decks';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'Markt';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get tabScan => 'Scannen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsIntro =>
      'ManaForge ist kostenlos und der Code liegt offen (PolyForm-Noncommercial-Lizenz: teilen und verändern gern, verkaufen nicht). Keine Werbung, kein Premium, keine Konten. Deine Karten gehören dir.';

  @override
  String get howItWorks => 'So funktioniert es';

  @override
  String get howScan =>
      'Halte Karten vor die Webcam oder zieh ein Foto hinein: Sie landen mit der genauen Edition in deiner Sammlung.';

  @override
  String get howCollection =>
      'Alles, was du hast — mit Suche, Filtern und Ordnern (Ordner sind Etiketten: eine Karte kann in mehreren liegen).';

  @override
  String get howAlbum =>
      'Eine Seite pro Edition, wie ein Sammelalbum: Vorhandenes in Farbe, Fehlendes ausgegraut, samt Kosten zum Vervollständigen.';

  @override
  String get howForge =>
      'Vollständige, legale Decks aus deinen Karten. Oder aus einer Edition, die du noch nicht hast — inklusive was du kaufen müsstest und was es kostet.';

  @override
  String get howDecks =>
      'Deine gespeicherten Decks. Verkaufst du eine Karte, sagt das Deck es dir, statt so zu tun, als hättest du sie noch.';

  @override
  String get howMarket =>
      'Was deine Sammlung wert ist, ihr Verlauf, deine Wunschliste mit Preisalarm — und, wenn deine CSV Kaufpreise hatte, dein Gewinn oder Verlust.';

  @override
  String get howPrivacy =>
      'Alles wird auf deinem Gerät berechnet. Ins Netz gehen nur die Datenbanken und, wenn du es anlässt, die Frage nach einer neuen Version.';

  @override
  String get shortcuts => 'Tastenkürzel';

  @override
  String get shortcutTabs => 'Tab wechseln';

  @override
  String get shortcutScan => 'Scanner öffnen';

  @override
  String get shortcutSearch => 'Im aktuellen Tab suchen';

  @override
  String get shortcutSettings => 'Einstellungen';

  @override
  String get shortcutClose => 'Schließen, was oben offen ist';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Wie das System';

  @override
  String get languagePartial =>
      'Die App wird nach und nach übersetzt: das Grundgerüst ist schon in deiner Sprache, die übrigen Bildschirme bleiben vorerst auf Spanisch.';

  @override
  String get versionTitle => 'ManaForge-Version';

  @override
  String versionYouHave(String version) {
    return 'Du hast $version.';
  }

  @override
  String get versionSeeWhatsNew => 'Was drin ist';

  @override
  String get versionNotifyMe => 'Über neue Versionen informieren';

  @override
  String get versionNotifyMeWhy =>
      'Fragt einmal täglich bei GitHub nach der neuesten Version. Es wird nichts heruntergeladen oder installiert.';

  @override
  String get versionCheckNow => 'Jetzt suchen';

  @override
  String get versionUpToDate =>
      'Du bist auf der neuesten Version (oder GitHub antwortet gerade nicht).';

  @override
  String versionThereIs(String version) {
    return 'ManaForge $version ist da.';
  }

  @override
  String get versionGoDownload => 'Zum Download';

  @override
  String versionNotAuto(String version) {
    return 'Du hast $version. Die App aktualisiert sich nicht selbst: sie bringt dich zum Download.';
  }

  @override
  String get versionNotNow => 'Jetzt nicht';

  @override
  String get versionSee => 'Ansehen';

  @override
  String whatsNewTitle(String version) {
    return 'Neu in $version';
  }

  @override
  String get whatsNewClose => 'Los geht\'s';

  @override
  String get downloadCopyLink => 'Link kopieren';

  @override
  String get downloadClose => 'Schließen';

  @override
  String get downloadTitle => 'ManaForge herunterladen';

  @override
  String get backgroundTitle => 'Hintergrundbild';

  @override
  String get backgroundWhat =>
      'Leg hinter die App das Bild, das du willst. Wizards veröffentlicht offizielle Hintergrundbilder zu jeder Edition: lade dir das aus, das dir gefällt, und wähle es hier. Die App holt sie nicht selbst — diese Kunst hat einen Eigentümer, und sie zu verteilen ist nicht ihre Aufgabe.';

  @override
  String get backgroundPick => 'Bild auswählen…';

  @override
  String get backgroundChange => 'Bild ändern…';

  @override
  String get backgroundOfficial => 'Offizielle Magic-Hintergrundbilder';

  @override
  String get backgroundRemove => 'Hintergrund entfernen';

  @override
  String get backgroundDim =>
      'Wie stark es abgedunkelt wird (damit der Text lesbar bleibt)';

  @override
  String get backgroundCardColor => 'Farbe der Karten';

  @override
  String get backgroundTextColor => 'Farbe der Schrift';

  @override
  String get backgroundCardOpacity =>
      'Wie stark die Karten den Hintergrund verdecken';

  @override
  String get backgroundColorDefault => 'Die übliche';

  @override
  String get backgroundPreview => 'So sieht es aus';

  @override
  String get backgroundNotAnImage =>
      'Wähle ein Bild (.jpg, .png oder .webp) als Hintergrund.';

  @override
  String get backgroundTooBig =>
      'Dieses Bild ist zu groß für einen Hintergrund.';

  @override
  String get welcomeTitle =>
      'Willkommen in der Schmiede. Bring deine Karten herein, wie du magst — oder probier Forge, bevor du eine einzige hinzufügst.';

  @override
  String get welcomeScan => 'Meine Karten scannen';

  @override
  String get welcomeImport => 'CSV importieren (ManaBox)';

  @override
  String get welcomeTryForge => 'Forge ohne Sammlung ausprobieren';

  @override
  String get decksEmptyGoForge => 'Zu Forge';

  @override
  String get yourCollection => 'Deine Sammlung';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies Karten · $distinct verschiedene';
  }

  @override
  String get marketArrow => 'Markt ›';

  @override
  String get certHeadingSetComplete => 'ZERTIFIKAT DER VOLLSTÄNDIGEN SAMMLUNG';

  @override
  String get certSubtitleSetComplete => 'Set vollständig';

  @override
  String get certHeadingWelcome => 'WILLKOMMENSZERTIFIKAT';

  @override
  String get certWelcomeTitle => 'Willkommen in der Welt von Magic';

  @override
  String get certSubtitleWelcome => 'Deine erste Karte';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Karten',
      one: '1 Karte',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return 'Ich habe mit $name angefangen';
  }

  @override
  String get certCollectorAnon => 'ManaForge-Sammler';

  @override
  String certAwardedTo(String name) {
    return 'Verliehen an $name';
  }

  @override
  String certOnDate(String date) {
    return 'am $date';
  }

  @override
  String get certDataBy => 'Daten von Scryfall';

  @override
  String get onbCollectionTitle => 'Deine Sammlung';

  @override
  String get onbCollectionBody =>
      'Hier liegen alle deine Karten, in Ordnern und nach Set.';

  @override
  String get onbScanTitle => 'Karten scannen';

  @override
  String get onbScanBody =>
      'Füge neue Karten mit der Kamera oder einem Foto hinzu.';

  @override
  String get onbForgeTitle => 'Decks schmieden';

  @override
  String get onbForgeBody =>
      'Baue komplette Decks aus deinen vorhandenen Karten.';

  @override
  String get onbDecksTitle => 'Deine Decks';

  @override
  String get onbDecksBody => 'Aus Forge gespeicherte Decks erscheinen hier.';

  @override
  String get onbSkip => 'Überspringen';

  @override
  String get onbNext => 'Weiter';

  @override
  String get onbGotIt => 'Verstanden';

  @override
  String get onbBack => 'Zurück';

  @override
  String get tourMenuTitle => 'Anleitungen';

  @override
  String get tourWelcomeName => 'Kurze Tour';

  @override
  String get tourHomeName => 'Der Startbildschirm';

  @override
  String get onbEditHomeTitle => 'Startseite anpassen';

  @override
  String get onbEditHomeBody =>
      'Mit diesem Knopf wählst du, welche Bereiche auf der Startseite erscheinen und in welcher Reihenfolge.';

  @override
  String get onbLangTitle => 'Sprache';

  @override
  String get onbLangBody => 'Ändere hier die Sprache der ganzen App.';

  @override
  String get onbLookTitle => 'Aussehen';

  @override
  String get onbLookBody =>
      'Lege ein Hintergrundbild fest und wähle die Farben von Karten, Text, Tabs und Symbolen.';

  @override
  String get tourSettingsName => 'App anpassen';

  @override
  String get tourFullName => 'Komplette Tour durch die App';

  @override
  String get tourCollectionName => 'Deine Sammlung und die Ordner';

  @override
  String get tourForgeName => 'Ein Deck schmieden';

  @override
  String get tourMarketName => 'Markt, Wunschliste und Alarme';

  @override
  String get onbAllCardsTitle => 'Alle Karten';

  @override
  String get onbAllCardsBody =>
      'Deine ganze Sammlung: suchen, filtern und sortieren.';

  @override
  String get onbFoldersTitle => 'Ordner';

  @override
  String get onbFoldersBody =>
      'Ordner sind Etiketten: gruppiere, was du willst — eine Karte kann in mehreren liegen. Mit „Neu\" legst du den ersten an.';

  @override
  String get onbAlbumMineTitle => 'Das Album nach Editionen';

  @override
  String get onbAlbumMineBody =>
      'Jede Edition mit ihren Plätzen. Dieser Filter zeigt nur Editionen, von denen du schon Karten hast.';

  @override
  String get onbForgeBasicsTitle => 'Standardländer';

  @override
  String get onbForgeBasicsBody =>
      'Wenn du lose Standardländer zu Hause hast, lass das an: Forge rechnet mit ihnen. Aus heißt: nur die aus deiner Sammlung.';

  @override
  String get onbForgeSetsTitle => 'Editionen';

  @override
  String get onbForgeSetsBody =>
      'Grenze ein, woher die Karten kommen. Ohne Auswahl nutzt Forge deine ganze Sammlung.';

  @override
  String get onbForgeMissingTitle => 'Karten, die dir fehlen';

  @override
  String get onbForgeMissingBody =>
      'Damit schlägt Forge auch fehlende Karten vor und sagt dir, wie viele es sind und was sie kosten würden.';

  @override
  String get onbForgeGoTitle => 'Schmieden';

  @override
  String get onbForgeGoBody =>
      'Dieser Knopf baut die Decks. Mit vielen Editionen dauert es ein paar Sekunden.';

  @override
  String get onbForgeTestTitle => 'Testmodus';

  @override
  String get onbForgeTestBody =>
      'Miss dein Deck an einem Meta-Deck und sieh, was ihm zum Sieg fehlt.';

  @override
  String get onbMarketPickTitle => 'Markt wählen';

  @override
  String get onbMarketPickBody =>
      'Cardmarket oder TCGplayer: das ändert jeden Preis und die Kurve.';

  @override
  String get onbWishlistTitle => 'Wunschliste';

  @override
  String get onbWishlistBody =>
      'Die Karten, die du willst. Der Zähler wird grün, sobald eine deinen Preis erreicht.';

  @override
  String get onbPriceAlertTitle => 'Preisalarm';

  @override
  String get onbPriceAlertBody =>
      'Suche eine Karte, tippe auf das Lesezeichen für die Wunschliste und setze einen Zielpreis: die App meldet sich, wenn er fällt.';

  @override
  String get tourProgressName => 'Erfolge und Zertifikate';

  @override
  String get onbAchievementsTitle => 'Erfolge und Level';

  @override
  String get onbAchievementsBody =>
      'Dein Level und alles, was du bisher verdient hast. Es steigt beim Scannen, Sortieren und Schmieden.';

  @override
  String get onbCertificatesTitle => 'Zertifikate';

  @override
  String get onbCertificatesBody =>
      'Die großen Meilensteine gibt es als Urkunde, die du als PDF sichern oder herzeigen kannst. Sie stecken in den Erfolgen.';

  @override
  String get onbBackupTitle => 'Sicherung';

  @override
  String get onbBackupBody =>
      'Sichere Sammlung, Decks und Ordner in einer Datei und hol sie zurück, wenn du den Rechner wechselst. Einmal pro Woche wird zusätzlich automatisch gesichert.';

  @override
  String onbTapHere(String pantalla) {
    return 'Tippe hier, um $pantalla zu öffnen.';
  }

  @override
  String get onbAchievementsName => 'Erfolge';

  @override
  String get onbDataSectionTitle => 'Daten';

  @override
  String get onbDataSectionBody =>
      'Hier liegt alles, was die App speichert: die Kartendatenbank und deine Sicherungen.';

  @override
  String get onbCardDbTitle => 'Kartendatenbank';

  @override
  String get onbCardDbBody =>
      'Lade sie neu für neue Karten, frische Preise und alles, was aktuelle Daten braucht — etwa den Jahresfilter von Forge.';

  @override
  String get onbAboutTitle => 'Die App';

  @override
  String get onbAboutBody =>
      'Was jeder Tab macht, die Tastenkürzel, die Version und die Lizenz.';

  @override
  String get colStartHere => 'Tu colección empieza aquí';

  @override
  String get colNeedDb =>
      'Primero necesito la base de datos con todas las cartas de Magic (se descarga una vez y luego todo funciona sin internet).';

  @override
  String colDownloading(String pct) {
    return 'Descargando… $pct %';
  }

  @override
  String get colDownloadDb => 'Descargar base de datos de cartas';

  @override
  String get colScryfall =>
      'Datos e imágenes por Scryfall · Sin cuentas, sin pagos: todo queda en tu dispositivo.';

  @override
  String get colAlbumTooltip => 'Álbum por expansiones';

  @override
  String get colImportTooltip => 'Importar CSV de ManaBox';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies cartas · $distinct distintas$valor';
  }

  @override
  String get colAllCards => 'Todas las cartas';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct distintas · buscar, filtrar y ordenar';
  }

  @override
  String get colFolders => 'Carpetas';

  @override
  String get colNewFolder => 'Nueva';

  @override
  String get colNoFolders =>
      'Aún no tienes carpetas. Sirven para agrupar lo que quieras: \"rares de Aetherdrift\", \"para vender\", \"la caja de arriba\"… Una carta puede estar en varias.';

  @override
  String get colCreateFirstFolder => 'Crear la primera carpeta';

  @override
  String get colEmptyTitle => 'Aquí empieza tu colección';

  @override
  String get colEmptyBody =>
      'Escanea tus cartas con la cámara o importa un CSV de ManaBox. Aparecerán aquí y en el álbum.';

  @override
  String get colImportShort => 'Importar CSV';

  @override
  String acForgetTitle(String carta) {
    return '¿Ya no tienes $carta?';
  }

  @override
  String get acForgetBody =>
      'Sale de tu colección y su hueco del álbum vuelve a estar vacío.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'También sale de las $n carpetas en las que está.',
      one: 'También sale de la carpeta en la que está.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Los mazos NO la pierden: se queda en la lista y el mazo te avisa de que te falta.';

  @override
  String get acCancel => 'Cancelar';

  @override
  String get acForgetConfirm => 'Ya no la tengo';

  @override
  String acAddedOn(String cuando) {
    return 'añadida $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'en $n carpetas',
      one: 'en 1 carpeta',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Busca una carta (español o inglés)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles de $total cartas';
  }

  @override
  String get acMissingFilterData =>
      ' · algunas cartas antiguas no tienen datos de filtro: reimporta tu CSV con \"Sustituir\" activado';

  @override
  String get acNoneMatch => 'Ninguna carta pasa estos filtros.';

  @override
  String get acEmptyHint =>
      'Busca tu primera carta arriba, o vuelve atrás e importa tu CSV de ManaBox.';

  @override
  String get onbHowItWorksBody =>
      'El resumen de qué hace cada pestaña y los atajos de teclado. Si te pierdes, empieza por aquí.';

  @override
  String get onbVersionBody =>
      'Qué versión tienes, qué trae, y si quieres que la app mire una vez al día si hay una nueva. No se actualiza sola.';

  @override
  String get onbScanSetTitle => 'Set: todas';

  @override
  String get onbScanSetBody =>
      'Si estás abriendo sobres de UNA expansión, fíjala aquí: el escáner deja de dudar entre las diez reimpresiones de la misma carta.';

  @override
  String get onbScanModeTitle => 'Rápido o con cuidado';

  @override
  String get onbScanModeBody =>
      'En «Rápido» las cartas claras entran solas y las dudosas quedan marcadas para revisar. En «Con cuidado» se para y te pregunta cuál es.';

  @override
  String get onbScanPhotoTitle => 'Escanear una foto';

  @override
  String get onbScanPhotoBody =>
      '¿Sin cámara, o con las cartas ya fotografiadas? Aquí sueltas una foto —con varias cartas si quieres— y las saca igual.';

  @override
  String get tourScanName => 'El escáner';

  @override
  String get albNeedDb =>
      'El álbum necesita la base de datos de cartas (descárgala en Colección).';

  @override
  String get albRetry => 'Reintentar';

  @override
  String get albApproxMode =>
      'Álbum en modo aproximado: aún no sé qué EDICIÓN exacta tienes de cada carta. Reimporta tu CSV con \"Sustituir mi colección actual\" activado y el álbum se afinará por ilustraciones.';

  @override
  String get albSearchSet => 'Busca una expansión…';

  @override
  String get albOnlyMine => 'Con cartas mías';

  @override
  String get albSortProgress => 'Más completadas';

  @override
  String get albSortNewest => 'Más nuevas';

  @override
  String get albSortOldest => 'Más antiguas';

  @override
  String get albSortName => 'Por nombre';

  @override
  String get albYearAll => 'Año: todos';

  @override
  String get albLetterAll => 'Todas';

  @override
  String get albNoSets => 'Ninguna expansión coincide con el filtro.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total cartas';
  }

  @override
  String get albComplete => ' · ✓ ¡completa!';

  @override
  String albLoadError(String error) {
    return 'No pude cargar el set: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Buscar en $set…';
  }

  @override
  String get albOnlyMissing => 'Solo las que faltan';

  @override
  String get albWithVariants => 'Con variantes';

  @override
  String get albYouHaveItAll => '✓ Lo tienes entero';

  @override
  String albMissingCount(int n) {
    return 'Te faltan $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n sin precio)';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles de $total';
  }

  @override
  String get albNoCardsNamed => 'Ninguna carta con ese nombre aquí.';

  @override
  String get fdNewFolder => 'Nueva carpeta';

  @override
  String get fdEditFolder => 'Editar carpeta';

  @override
  String get fdName => 'Nombre';

  @override
  String get fdNameHint => 'Rares de Aetherdrift, Para vender…';

  @override
  String get fdColor => 'Color';

  @override
  String get fdIcon => 'Icono';

  @override
  String get fdCreate => 'Crear';

  @override
  String get fdSave => 'Guardar';

  @override
  String get fdDefaultName => 'Carpeta';

  @override
  String fdDeleteTitle(String nombre) {
    return '¿Borrar \"$nombre\"?';
  }

  @override
  String get fdDeleteBody =>
      'Se borra solo la carpeta: las cartas siguen en tu colección.';

  @override
  String get fdDelete => 'Borrar';

  @override
  String get fdGone => 'Esta carpeta ya no existe.';

  @override
  String get fdEditTooltip => 'Editar nombre, color e icono';

  @override
  String get fdDeleteTooltip => 'Borrar carpeta';

  @override
  String get fdAddRemove => 'Añadir o quitar';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas cartas distintas · $copias copias';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n pasan el filtro';
  }

  @override
  String get fdRoughValue => ' · valor orientativo';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n cartas ya no están en tu colección (siguen apuntadas por si vuelven).',
      one: '1 carta ya no está en tu colección (sigue apuntada por si vuelve).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Quitarlas';

  @override
  String get fdNoneMatch => 'Ninguna carta de la carpeta pasa estos filtros.';

  @override
  String get fdEmpty =>
      'Carpeta vacía. Dale a \"Añadir o quitar\" y marca las cartas que quieres meter.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n copias',
      one: '1 copia',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Quitar de la carpeta';

  @override
  String get fpPickCards => 'Elige las cartas';

  @override
  String fpSaveCount(int n) {
    return 'Guardar ($n)';
  }

  @override
  String get fpFilterByName => 'Filtra por nombre…';

  @override
  String fpVisibleCards(int n) {
    return '$n cartas a la vista';
  }

  @override
  String get fpSelectAll => 'Marcar todas';

  @override
  String get fpNoneMatch => 'Ninguna carta pasa estos filtros.';

  @override
  String get fgMsgReading => 'Leyendo tu colección…';

  @override
  String get fgMsgCurve => 'Calculando la curva de maná…';

  @override
  String get fgMsgLands => 'Repartiendo tierras…';

  @override
  String get fgMsgSynergy => 'Buscando sinergias…';

  @override
  String get fgMsgPlan => 'Escribiendo tu plan de juego…';

  @override
  String get fgNeedDbForSets =>
      'Necesito la base de cartas para listar las expansiones: Ajustes → descargar la base.';

  @override
  String fgDbError(String error) {
    return 'No pude leer la base de datos de cartas: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' en esas $n expansiones',
      one: ' en esa expansión',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'No me sale un Commander legal$donde: hacen falta un comandante legendario y ~62 cartas DISTINTAS dentro de su identidad (es singleton), más básicas suficientes. Prueba otro formato, otras expansiones o amplía la colección.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'Con las cartas de este pool no me sale ningún mazo completo $formato que cumpla mis reglas (tierras suficientes y curva sana)$donde. $consejo Antes que darte un mazo defectuoso, prefiero avisarte.';
  }

  @override
  String get fgOf60 => 'de 60';

  @override
  String fgLegalIn(String formato) {
    return 'LEGAL en $formato';
  }

  @override
  String get fgTipMoreSets => 'Prueba con más expansiones o quita filtros.';

  @override
  String get fgTipMoreCards =>
      'Añade más cartas — sobre todo de tus colores principales — o marca \"incluir cartas que no tengo\".';

  @override
  String get fgPitch =>
      'Mazos completos y jugables con las cartas que ya tienes. Sin comprar nada.';

  @override
  String get fgTeaserCount => 'cartas para tu primer mazo';

  @override
  String get fgTeaserMissing => 'Hacer un mazo con cartas que no tengo';

  @override
  String get fgBasics => 'Cuento con tierras básicas sueltas';

  @override
  String get fgBasicsSub =>
      'Casi todo el mundo tiene básicas de mazos de inicio; desactívalo para usar SOLO las básicas de tu colección.';

  @override
  String get fgFormat => 'Formato de juego';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 cartas · singleton · comandante legendario de tu colección · identidad de color respetada.';

  @override
  String get fgCasualNote =>
      '60 cartas, sin restricción de legalidad: todo vale.';

  @override
  String fgFormatNote(String formato) {
    return '60 cartas usando SOLO tus cartas legales en $formato.';
  }

  @override
  String get fgWhereFrom => '¿De dónde salen las cartas?';

  @override
  String get fgPickSets => 'Elegir expansiones';

  @override
  String get fgChangeSets => 'Cambiar expansiones';

  @override
  String get fgNeedOneSet =>
      'Elige al menos una expansión: sin filtro serían las ~30.000 cartas de Magic.';

  @override
  String get fgNoSetsNote =>
      'Sin elegir expansiones, Forge usa toda tu colección.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cartas de $n expansiones, tengas o no.',
      one: 'Cartas de 1 expansión, tengas o no.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Solo tus cartas de $n expansiones — no toda la colección.',
      one: 'Solo tus cartas de 1 expansión — no toda la colección.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'Tu colección no guarda la edición de cada carta, así que filtrar por expansión dejaría fuera casi todo. Reimporta tu CSV con \"Sustituir\" y vuelve.';

  @override
  String get fgIncludeMissing => 'Incluir cartas que no tengo';

  @override
  String get fgIncludeMissingSub =>
      'Forge deja de limitarse a tu colección y usa TODO lo impreso en esas expansiones; luego te dice cuántas cartas te faltan y cuánto costarían.';

  @override
  String get fgYourTaste => 'A tu gusto (opcional)';

  @override
  String get fgArchetypeAuto => 'Arquetipo: auto';

  @override
  String get fgPricePerCard => 'Precio por carta:';

  @override
  String get fgMin => 'mín €';

  @override
  String get fgMax => 'máx €';

  @override
  String get fgCardYear => 'Año de la carta:';

  @override
  String get fgFrom => 'desde';

  @override
  String get fgTo => 'hasta';

  @override
  String get fgYearNeedsDb =>
      'El filtro por año necesita la base de datos actualizada: Ajustes → Volver a descargar la base de datos.';

  @override
  String get fgNoColorsNote =>
      'Sin elegir colores, Forge prueba todas las combinaciones.';

  @override
  String fgColorsNote(String colores) {
    return 'Solo mazos $colores (y sus combinaciones).';
  }

  @override
  String get fgMissingNote =>
      'Este mazo puede llevar cartas que NO tienes: cada propuesta dice cuántas te faltan y lo que costarían (precio de Cardmarket).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge solo usa tus $n cartas. Nunca inventa copias que no tienes.';
  }

  @override
  String get fgForgeMissing => 'Forjar mazos (con lo que me falte)';

  @override
  String get fgForgeMine => 'Forjar mis mazos';

  @override
  String get fgTestMode => 'Modo Test: vence a un mazo del meta';

  @override
  String get fgOffline => 'Todo se calcula en tu dispositivo, sin internet';

  @override
  String fgForgingWith(int n) {
    return 'Estás forjando con $n cartas: esto tarda unos segundos. La ventana sigue viva.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mazos listos para jugar',
      one: '1 mazo listo para jugar',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'Con cartas que aún no tienes · desliza para comparar';

  @override
  String get fgSwipeMine =>
      'Hechos solo con tus cartas · desliza para comparar';

  @override
  String get fgHaveAll => '✓ Tienes todas las cartas';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Te faltan $n cartas',
      one: 'Te falta 1 carta',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Ver mazo completo';

  @override
  String get fgReforge => 'Reforjar';
}
