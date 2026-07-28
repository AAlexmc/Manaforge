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
  String get onbForgeDeepTitle => 'Tiefe Schmiede';

  @override
  String get onbForgeDeepBody =>
      'Bevor er dir die Vorschläge zeigt, lässt er sie wirklich gegeneinander spielen: Die Endreihenfolge gewichtet, wie sie abschneiden, nicht nur ihren statischen Score. Schalte es aus, wenn du lieber schnellere Ergebnisse willst.';

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
  String get colStartHere => 'Deine Sammlung fängt hier an';

  @override
  String get colNeedDb =>
      'Zuerst brauche ich die Datenbank mit allen Magic-Karten (sie wird einmal heruntergeladen, danach läuft alles ohne Internet).';

  @override
  String colDownloading(String pct) {
    return 'Lade herunter… $pct %';
  }

  @override
  String get colDownloadDb => 'Kartendatenbank herunterladen';

  @override
  String get colScryfall =>
      'Daten und Bilder von Scryfall · Keine Konten, keine Zahlungen: Alles bleibt auf deinem Gerät.';

  @override
  String get colAlbumTooltip => 'Album nach Sets';

  @override
  String get colImportTooltip => 'ManaBox-CSV importieren';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies Karten · $distinct verschiedene$valor';
  }

  @override
  String get colAllCards => 'Alle Karten';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct verschiedene · suchen, filtern und sortieren';
  }

  @override
  String get colFolders => 'Ordner';

  @override
  String get colNewFolder => 'Neu';

  @override
  String get colNoFolders =>
      'Du hast noch keine Ordner. Sie bündeln, was du willst: \"Seltene aus Aetherdrift\", \"zum Verkaufen\", \"die Kiste oben\"… Eine Karte darf in mehreren stecken.';

  @override
  String get colCreateFirstFolder => 'Ersten Ordner anlegen';

  @override
  String get colEmptyTitle => 'Hier fängt deine Sammlung an';

  @override
  String get colEmptyBody =>
      'Scanne deine Karten mit der Kamera oder importiere eine ManaBox-CSV. Sie tauchen hier und im Album auf.';

  @override
  String get colImportShort => 'CSV importieren';

  @override
  String acForgetTitle(String carta) {
    return 'Du hast $carta nicht mehr?';
  }

  @override
  String get acForgetBody =>
      'Sie verschwindet aus deiner Sammlung und ihr Platz im Album ist wieder leer.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Sie fliegt auch aus den $n Ordnern, in denen sie steckt.',
      one: 'Sie fliegt auch aus dem Ordner, in dem sie steckt.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Die Decks verlieren sie NICHT: Sie bleibt in der Liste und das Deck sagt dir, dass sie dir fehlt.';

  @override
  String get acCancel => 'Abbrechen';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => 'Hab ich nicht mehr';

  @override
  String acAddedOn(String cuando) {
    return 'hinzugefügt $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'in $n Ordnern',
      one: 'in 1 Ordner',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Such eine Karte (spanisch oder englisch)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles von $total Karten';
  }

  @override
  String get acMissingFilterData =>
      ' · bei ein paar alten Karten fehlen die Filterdaten: importiere deine CSV neu mit aktiviertem \"Ersetzen\"';

  @override
  String get acNoneMatch => 'Keine Karte kommt durch diese Filter.';

  @override
  String get acEmptyHint =>
      'Such deine erste Karte hier oben, oder geh zurück und importiere deine ManaBox-CSV.';

  @override
  String get onbHowItWorksBody =>
      'Die Kurzfassung, was jeder Reiter macht, plus die Tastenkürzel. Wenn du dich verirrst, fang hier an.';

  @override
  String get onbVersionBody =>
      'Welche Version du hast, was drin ist, und ob die App einmal am Tag nach einer neuen schauen soll. Sie aktualisiert sich nie von selbst.';

  @override
  String get onbSuggestionsTitle => 'Vorschlagsbox';

  @override
  String get onbSuggestionsBody =>
      'Hast du eine Idee oder einen Fehler gefunden? Sag\'s auf GitHub: Es gibt eine Vorlage, dauert eine Minute.';

  @override
  String get onbSupportTitle => 'Das Projekt unterstützen';

  @override
  String get onbSupportBody =>
      'Die App ist kostenlos und werbefrei. Wenn sie dir geholfen hat, hier steht, wie du uns einen Kaffee spendierst.';

  @override
  String get onbScanSetTitle => 'Set: alle';

  @override
  String get onbScanSetBody =>
      'Wenn du Booster aus EINEM Set öffnest, leg es hier fest: Der Scanner hört auf, zwischen den zehn Nachdrucken derselben Karte zu schwanken.';

  @override
  String get onbScanModeTitle => 'Schnell oder sorgfältig';

  @override
  String get onbScanModeBody =>
      'Bei »Schnell« wandern klare Karten von allein rein und die zweifelhaften werden zum Prüfen markiert. Bei »Sorgfältig« hält er an und fragt dich, welche es ist.';

  @override
  String get onbScanPhotoTitle => 'Ein Foto scannen';

  @override
  String get onbScanPhotoBody =>
      'Keine Kamera, oder die Karten schon fotografiert? Hier wirfst du ein Foto rein — gern mit mehreren Karten — und er holt sie genauso raus.';

  @override
  String get tourScanName => 'Der Scanner';

  @override
  String get albNeedDb =>
      'Das Album braucht die Kartendatenbank (lade sie in der Sammlung herunter).';

  @override
  String get albRetry => 'Nochmal versuchen';

  @override
  String get albApproxMode =>
      'Album im Grobmodus: Ich weiß noch nicht, welche DRUCKVERSION du von jeder Karte hast. Importiere deine CSV neu mit aktiviertem \"Meine aktuelle Sammlung ersetzen\", dann schärft sich das Album nach Illustrationen.';

  @override
  String get albSearchSet => 'Such ein Set…';

  @override
  String get albOnlyMine => 'Mit Karten von mir';

  @override
  String get albSortProgress => 'Am vollständigsten';

  @override
  String get albSortNewest => 'Neueste';

  @override
  String get albSortOldest => 'Älteste';

  @override
  String get albSortName => 'Nach Name';

  @override
  String get albYearAll => 'Jahr: alle';

  @override
  String get albLetterAll => 'Alle';

  @override
  String get albNoSets => 'Kein Set passt zum Filter.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total Karten';
  }

  @override
  String get albComplete => ' · ✓ komplett!';

  @override
  String albLoadError(String error) {
    return 'Ich konnte das Set nicht laden: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'In $set suchen…';
  }

  @override
  String get albOnlyMissing => 'Nur die fehlenden';

  @override
  String get albWithVariants => 'Mit Varianten';

  @override
  String get albYouHaveItAll => '✓ Du hast alles';

  @override
  String albMissingCount(int n) {
    return 'Dir fehlen $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n ohne Preis)';
  }

  @override
  String albNoPerPrinting(String market) {
    return '$market no publica precios por edición — elige otro en la pestaña Mercado';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles von $total';
  }

  @override
  String get albNoCardsNamed => 'Hier gibt es keine Karte mit dem Namen.';

  @override
  String get fdNewFolder => 'Neuer Ordner';

  @override
  String get fdEditFolder => 'Ordner bearbeiten';

  @override
  String get fdName => 'Name';

  @override
  String get fdNameHint => 'Seltene aus Aetherdrift, Zum Verkaufen…';

  @override
  String get fdColor => 'Farbe';

  @override
  String get fdIcon => 'Symbol';

  @override
  String get fdCreate => 'Anlegen';

  @override
  String get fdSave => 'Speichern';

  @override
  String get fdDefaultName => 'Ordner';

  @override
  String fdDeleteTitle(String nombre) {
    return '\"$nombre\" löschen?';
  }

  @override
  String get fdDeleteBody =>
      'Nur der Ordner geht: Die Karten bleiben in deiner Sammlung.';

  @override
  String get fdDelete => 'Löschen';

  @override
  String get fdGone => 'Diesen Ordner gibt es nicht mehr.';

  @override
  String get fdEditTooltip => 'Name, Farbe und Symbol bearbeiten';

  @override
  String get fdDeleteTooltip => 'Ordner löschen';

  @override
  String get fdAddRemove => 'Hinzufügen oder entfernen';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas verschiedene Karten · $copias Exemplare';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n kommen durch den Filter';
  }

  @override
  String get fdRoughValue => ' · Richtwert';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n Karten sind nicht mehr in deiner Sammlung (sie bleiben notiert, falls sie zurückkommen).',
      one:
          '1 Karte ist nicht mehr in deiner Sammlung (sie bleibt notiert, falls sie zurückkommt).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Rauswerfen';

  @override
  String get fdNoneMatch =>
      'Keine Karte aus dem Ordner kommt durch diese Filter.';

  @override
  String get fdEmpty =>
      'Leerer Ordner. Drück auf \"Hinzufügen oder entfernen\" und hak die Karten ab, die rein sollen.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Exemplare',
      one: '1 Exemplar',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Aus dem Ordner entfernen';

  @override
  String get fpPickCards => 'Wähl die Karten';

  @override
  String fpSaveCount(int n) {
    return 'Speichern ($n)';
  }

  @override
  String get fpFilterByName => 'Nach Name filtern…';

  @override
  String fpVisibleCards(int n) {
    return '$n Karten im Blick';
  }

  @override
  String get fpSelectAll => 'Alle markieren';

  @override
  String get fpNoneMatch => 'Keine Karte kommt durch diese Filter.';

  @override
  String get fgMsgReading => 'Lese deine Sammlung…';

  @override
  String get fgMsgCurve => 'Berechne die Manakurve…';

  @override
  String get fgMsgLands => 'Teile Länder aus…';

  @override
  String get fgMsgSynergy => 'Suche Synergien…';

  @override
  String get fgMsgPlan => 'Schreibe deinen Spielplan…';

  @override
  String get fgNeedDbForSets =>
      'Ich brauche die Kartendatenbank, um die Sets aufzulisten: Einstellungen → Datenbank herunterladen.';

  @override
  String fgDbError(String error) {
    return 'Ich konnte die Kartendatenbank nicht lesen: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' in diesen $n Sets',
      one: ' in diesem Set',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'Ein legales Commander-Deck kriege ich nicht hin$donde: Es braucht einen legendären Kommandeur und ~62 VERSCHIEDENE Karten innerhalb seiner Farbidentität (es ist Singleton), plus genug Standardländer. Probier ein anderes Format, andere Sets oder erweitere deine Sammlung.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'Mit den Karten aus diesem Pool kriege ich kein vollständiges $formato-Deck hin, das meine Regeln erfüllt (genug Länder und eine gesunde Kurve)$donde. $consejo Statt dir ein kaputtes Deck anzudrehen, sage ich es dir lieber.';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return 'Mit diesem Stil ($estilo) kommt kein Deck heraus. Probier „Stil: auto“ oder einen anderen Stamm.';
  }

  @override
  String get fgOf60 => '60-Karten';

  @override
  String fgLegalIn(String formato) {
    return 'LEGAL in $formato';
  }

  @override
  String get fgTipMoreSets =>
      'Probier mehr Sets oder nimm ein paar Filter raus.';

  @override
  String get fgTipMoreCards =>
      'Füg mehr Karten hinzu — vor allem in deinen Hauptfarben — oder hak \"Karten einbeziehen, die ich nicht habe\" an.';

  @override
  String get fgPitch =>
      'Vollständige, spielbare Decks aus den Karten, die du schon hast. Ohne irgendwas zu kaufen.';

  @override
  String get fgTeaserCount => 'Karten für dein erstes Deck';

  @override
  String get fgTeaserMissing => 'Ein Deck mit Karten bauen, die ich nicht habe';

  @override
  String get fgBasics => 'Ich habe lose Standardländer';

  @override
  String get fgBasicsSub =>
      'Fast jeder hat Standardländer aus Startdecks; schalt es aus, um NUR die Standardländer aus deiner Sammlung zu nehmen.';

  @override
  String get fgFormat => 'Spielformat';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 Karten · Singleton · ein legendärer Kommandeur aus deiner Sammlung · Farbidentität wird eingehalten.';

  @override
  String get fgCasualNote =>
      '60 Karten, keine Legalitätsgrenzen: alles erlaubt.';

  @override
  String fgFormatNote(String formato) {
    return '60 Karten mit NUR deinen Karten, die in $formato legal sind.';
  }

  @override
  String get fgWhereFrom => 'Woher kommen die Karten?';

  @override
  String get fgPickSets => 'Sets wählen';

  @override
  String get fgChangeSets => 'Sets ändern';

  @override
  String get fgNeedOneSet =>
      'Wähl mindestens ein Set: ohne Filter wären es alle ~30.000 Magic-Karten.';

  @override
  String get fgNoSetsNote =>
      'Ohne gewählte Sets nimmt Forge deine ganze Sammlung.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Karten aus $n Sets, egal ob du sie hast.',
      one: 'Karten aus 1 Set, egal ob du sie hast.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Nur deine Karten aus $n Sets — nicht die ganze Sammlung.',
      one: 'Nur deine Karten aus 1 Set — nicht die ganze Sammlung.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'Deine Sammlung merkt sich die Druckversion der Karten nicht, deshalb würde ein Set-Filter fast alles rauswerfen. Importiere deine CSV neu mit \"Ersetzen\" und komm wieder.';

  @override
  String get fgIncludeMissing => 'Karten einbeziehen, die ich nicht habe';

  @override
  String get fgIncludeMissingSub =>
      'Forge hält sich nicht mehr an deine Sammlung und nimmt ALLES, was in diesen Sets gedruckt wurde; danach sagt es dir, wie viele Karten dir fehlen und was sie kosten würden.';

  @override
  String get fgYourTaste => 'Nach deinem Geschmack (optional)';

  @override
  String get fgArchetypeAuto => 'Archetyp: auto';

  @override
  String get fgStyle => 'Stil';

  @override
  String get fgStyleAuto => 'Stil: auto';

  @override
  String get fgTribeElf => 'Elfen';

  @override
  String get fgTribeGoblin => 'Goblins';

  @override
  String get fgTribeZombie => 'Zombies';

  @override
  String get fgTribeVampire => 'Vampire';

  @override
  String get fgTribeDragon => 'Drachen';

  @override
  String get fgTribeAngel => 'Engel';

  @override
  String get fgTribeDemon => 'Dämonen';

  @override
  String get fgTribeDinosaur => 'Dinosaurier';

  @override
  String get fgTribeFaerie => 'Feen';

  @override
  String get fgTribeMerfolk => 'Meervolk';

  @override
  String get fgTribeHuman => 'Menschen';

  @override
  String get fgTribeSpirit => 'Geister';

  @override
  String get fgTribeSliver => 'Wesenssplitter';

  @override
  String get fgTribeWizard => 'Zauberer';

  @override
  String get fgTribeKnight => 'Ritter';

  @override
  String get fgTribeWarrior => 'Krieger';

  @override
  String get fgTribeSoldier => 'Soldaten';

  @override
  String get fgTribeCat => 'Katzen';

  @override
  String get fgTribeDog => 'Hunde';

  @override
  String get fgTribeRat => 'Ratten';

  @override
  String get fgTribePirate => 'Piraten';

  @override
  String get fgTribeElemental => 'Elementare';

  @override
  String get fgTribeGiant => 'Riesen';

  @override
  String get fgTribeRogue => 'Schurken';

  @override
  String get fgDeepForge => 'Tiefe Schmiede';

  @override
  String get fgDeepForgeHint =>
      'Bevor sie dir die Vorschläge zeigt, lässt sie sie wirklich gegeneinander antreten (etwas mehr Wartezeit).';

  @override
  String get fgPricePerCard => 'Preis pro Karte:';

  @override
  String get fgMin => 'min €';

  @override
  String get fgMax => 'max €';

  @override
  String get fgCardYear => 'Jahr der Karte:';

  @override
  String get fgFrom => 'von';

  @override
  String get fgTo => 'bis';

  @override
  String get fgYearNeedsDb =>
      'Der Jahresfilter braucht eine aktuelle Datenbank: Einstellungen → Datenbank neu herunterladen.';

  @override
  String get fgNoColorsNote =>
      'Ohne gewählte Farben probiert Forge alle Kombinationen.';

  @override
  String fgColorsNote(String colores) {
    return 'Nur Decks in $colores (und ihren Kombinationen).';
  }

  @override
  String get fgMissingNote =>
      'Dieses Deck kann Karten enthalten, die du NICHT hast: Jeder Vorschlag sagt dir, wie viele dir fehlen und was sie kosten würden (Cardmarket-Preis).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge nimmt nur deine $n Karten. Es erfindet nie Exemplare, die du nicht hast.';
  }

  @override
  String get fgForgeMissing => 'Decks schmieden (auch mit dem, was mir fehlt)';

  @override
  String get fgForgeMine => 'Meine Decks schmieden';

  @override
  String get fgTestMode => 'Testmodus: schlag ein Meta-Deck';

  @override
  String get fgOffline =>
      'Alles wird auf deinem Gerät berechnet, ohne Internet';

  @override
  String fgForgingWith(int n) {
    return 'Du schmiedest mit $n Karten: Das dauert ein paar Sekunden. Das Fenster lebt noch.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Decks sind spielbereit',
      one: '1 Deck ist spielbereit',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'Mit Karten, die du noch nicht hast · wisch zum Vergleichen';

  @override
  String get fgSwipeMine =>
      'Nur aus deinen Karten gebaut · wisch zum Vergleichen';

  @override
  String get fgHaveAll => '✓ Du hast jede Karte';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Dir fehlen $n Karten',
      one: 'Dir fehlt 1 Karte',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Ganzes Deck ansehen';

  @override
  String get fgReforge => 'Neu schmieden';

  @override
  String get fgBackToOptions => 'Volver a elegir cómo forjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta steht bei $precio (dein Ziel: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 $n Karten von deiner Wunschliste sind auf ihren Zielpreis gefallen!';
  }

  @override
  String get mkTellMeWhenDrops => 'Sag mir Bescheid, wenn sie fällt';

  @override
  String get mkTargetPrice => 'Zielpreis';

  @override
  String mkNow(String precio) {
    return 'Jetzt: $precio';
  }

  @override
  String get mkUpdated => '✓ Preise und Karten aktualisiert';

  @override
  String mkUpdateFailed(String error) {
    return 'Ich konnte nicht aktualisieren: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Preisverlauf steht: Die Diagramme zeigen jetzt die letzten Monate';

  @override
  String mkHistoryFailed(String error) {
    return 'Ich konnte den Verlauf nicht holen (der alte bleibt unangetastet): $error';
  }

  @override
  String get mkHistoryLocal =>
      'Preisverlauf: nur das, was ManaForge täglich auf deinem Rechner notiert. Hol dir die echten letzten ~90 Tage von Cardmarket (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Echter Cardmarket-Verlauf vom $desde bis $hasta, und ab da das, was ManaForge notiert.';
  }

  @override
  String get mkFetchHistory => 'Verlauf holen';

  @override
  String get mkCollectionValue => 'Wert deiner Sammlung · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n Karten';
  }

  @override
  String get mkApproxSuffix => ' · Richtwert';

  @override
  String mkBulkPrices(String fecha) {
    return 'Cardmarket-Preise vom $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Markt ohne Daten: Lade die Datenbank in der Sammlung herunter. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'SETS ($n)';
  }

  @override
  String get mkPrevious => 'Zurück';

  @override
  String get mkNext => 'Weiter';

  @override
  String get mkSearchHint => 'Schlag den Preis einer beliebigen Karte nach…';

  @override
  String get mkRemoveFromWishlist => 'Von der Wunschliste nehmen';

  @override
  String get mkAddToWishlist =>
      'Auf die Wunschliste: sag mir Bescheid, wenn sie fällt';

  @override
  String get mkYourWishlist => 'DEINE WUNSCHLISTE';

  @override
  String mkTargetAtMost(String precio) {
    return 'Ziel ≤ $precio';
  }

  @override
  String get mkAtPrice => 'zum Zielpreis!';

  @override
  String get mkChangeTarget => 'Zielpreis ändern';

  @override
  String mkNoPriceIn(String market) {
    return 'kein Preis bei $market';
  }

  @override
  String get mkPerUnit => '/Stk.';

  @override
  String get mkTopCards => 'DEINE WERTVOLLSTEN KARTEN';

  @override
  String get mkImportToSeeValue =>
      'Importiere deine Sammlung, um ihren Wert zu sehen.';

  @override
  String mkSetCards(int n) {
    return ' · $n Karten';
  }

  @override
  String get wlEmpty =>
      'Such sie im Markt und tipp auf das Lesezeichen, damit du Bescheid kriegst, wenn sie auf deinen Preis fallen.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '🔔 $n Karten von deiner Wunschliste sind auf deinem Zielpreis oder darunter.',
      one:
          '🔔 1 Karte von deiner Wunschliste ist auf deinem Zielpreis oder darunter.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'MTGO-Preise in Tix (digitale Karten)';

  @override
  String get mpNoDataYet =>
      'Noch keine Daten: aktualisiere den Preisverlauf im Markt';

  @override
  String get mpMtgoNote =>
      'MTGO-Preise in Tix: Das sind digitale Karten, zum Bewerten deiner Papiersammlung taugen sie nicht. Start, Ordner und Erfolge bleiben bei Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return '$mercado-Preise in $moneda. Start, Ordner und Erfolge bewerten weiter mit Cardmarket (€): Währungen werden nicht umgerechnet.';
  }

  @override
  String get mkUpdate => 'Aktualisieren';

  @override
  String get mkApproxValue =>
      ' · ungefährer Wert (importiere neu mit \"Ersetzen\" für Preise pro Druckversion)';

  @override
  String get mkExactPrintings => ' · nach deinen genauen Druckversionen';

  @override
  String mkNowSuffix(String precio) {
    return ' · jetzt $precio';
  }

  @override
  String get wlNothingYet => 'Noch nichts auf deiner Wunschliste.';

  @override
  String get stDbUpdated => '✓ Datenbank aktualisiert';

  @override
  String stUpdateFailed(String error) {
    return 'Aktualisieren ging nicht: $error';
  }

  @override
  String get stCardDb => 'Kartendatenbank';

  @override
  String get stCardDbWhy =>
      'Lade sie neu herunter für neue Karten, frische Preise und die Funktionen, die aktuelle Daten brauchen (wie den Jahresfilter in Forge).';

  @override
  String get stDownloadDbAgain => 'Datenbank neu herunterladen';

  @override
  String get stAppearance => 'Aussehen';

  @override
  String get stData => 'Daten';

  @override
  String get stTheApp => 'Die App';

  @override
  String get stCredits =>
      'Kartendaten und -bilder von Scryfall. Magic: The Gathering gehört Wizards of the Coast; ein Fan-Projekt im Rahmen ihrer Fan Content Policy.';

  @override
  String get stSuggestions => 'Buzón de sugerencias';

  @override
  String get stSuggestionsSub =>
      '¿Una idea o un fallo? Cuéntalo en GitHub — hay plantilla y se rellena en un minuto.';

  @override
  String get stDonate => 'Apoyar el proyecto';

  @override
  String get stDonateSub =>
      'La app es gratis y sin anuncios. Si te sirve y quieres invitar a un café, aquí se explica cómo.';

  @override
  String get stEditHome => 'Start bearbeiten';

  @override
  String get stEditHomeSub =>
      'Wähl, welche Abschnitte zu sehen sind und in welcher Reihenfolge';

  @override
  String get ehLevel => 'Dein Level';

  @override
  String get ehShortcuts => 'Schnellzugriffe';

  @override
  String get ehSummary => 'Überblick über die Sammlung';

  @override
  String get ehRecent => 'Zuletzt angesehen';

  @override
  String get ehDecks => 'Deine Decks';

  @override
  String get ehMeta => 'Das Meta gerade';

  @override
  String get ehNewSets => 'Neue Sets';

  @override
  String get ehGems => 'Deine Schätze';

  @override
  String get ehStatCards => 'Karten';

  @override
  String get ehStatDistinct => 'verschiedene';

  @override
  String get ehStatValue => 'Wert';

  @override
  String get ehStatDecks => 'Decks';

  @override
  String get ehStatAchievements => 'Erfolge';

  @override
  String get ehHelp =>
      'Zieh zum Sortieren und nimm den Schalter, um zu wählen, was du auf Start siehst. Ein eingeschalteter Abschnitt taucht nur auf, wenn er etwas zu zeigen hat.';

  @override
  String get ehSection => 'Abschnitt';

  @override
  String get bkNoData => 'Ich finde deine Daten nicht.';

  @override
  String bkSaved(String resumen) {
    return '✓ Backup gespeichert · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'Ich konnte es nicht speichern: $error';
  }

  @override
  String get bkFileName => 'ManaForge-Backup';

  @override
  String bkRestoreFailed(String error) {
    return 'Ich konnte es nicht wiederherstellen: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Wiederhergestellt · $resumen. ACHTUNG: Ich konnte nicht sichern, was du vorher hattest ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Wiederhergestellt · $resumen. Was du vorher hattest, liegt im Ordner backups.';
  }

  @override
  String get bkRestoring => 'Stelle dein Backup wieder her…';

  @override
  String get bkTitle => 'Backup';

  @override
  String get bkWhy =>
      'Deine Karten, Decks, Ordner und Erfolge leben nur auf diesem Rechner. Sichere ab und zu eine Kopie und leg sie woanders ab: eine Platte, die Cloud, was du willst.';

  @override
  String get bkSave => 'Backup speichern';

  @override
  String get bkRestoreTitle => 'Ein Backup wiederherstellen';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Wiederherstellen ERSETZT deine jetzigen Karten, Decks, Ordner und Erfolge durch die aus dem Backup. Wähl eins, drück den Knopf und tipp $palabra: So wird nichts aus Versehen wiederhergestellt.';
  }

  @override
  String get bkNoBackups =>
      'Auf diesem Rechner sind noch keine Backups gespeichert.';

  @override
  String get bkWhich => 'Backup zum Wiederherstellen';

  @override
  String get bkPickOne => 'Wähl ein Backup';

  @override
  String get bkRestorePicked => 'Gewähltes Backup wiederherstellen';

  @override
  String get bkAutoNote =>
      'Ich speichere jede Woche ein automatisches Backup (die letzten fünf) und eins direkt vor jedem Wiederherstellen.';

  @override
  String get bkFromFile => 'Aus einer Datei wiederherstellen';

  @override
  String get bkConfirmTitle => 'Dieses Backup wiederherstellen?';

  @override
  String get bkConfirmBody =>
      'Das ersetzt deine jetzige Sammlung, deine Decks, Ordner und Erfolge durch die aus diesem Backup. Vorher sichere ich, was du hast, im Ordner backups — falls du zurückwillst.';

  @override
  String bkWillDelete(String cosas) {
    return 'In diesem Backup fehlt $cosas: Beim Wiederherstellen wird das gelöscht.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Tipp $palabra, um weiterzumachen:';
  }

  @override
  String get bkAnd => ' und ';

  @override
  String get ehReset => 'Zurücksetzen';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Backup vom $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'Ich finde keine Kamera.';

  @override
  String get lsCameraGone =>
      'Die Kamera hat sich mitten in der Sitzung verabschiedet. Prüf das Kabel und drück auf Nochmal versuchen.';

  @override
  String get lsFrameCard => 'Bring die Karte in den Rahmen';

  @override
  String get lsNoCardThere => 'Ich sehe da keine Karte';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n Karten in die Sammlung',
      one: '✓ 1 Karte in die Sammlung',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', und in \"$carpeta\"';
  }

  @override
  String get lsTitle => 'Live scannen';

  @override
  String get lsQuickTip =>
      'Schnell: Klare Karten wandern von allein rein; zweifelhafte werden zum Prüfen markiert.';

  @override
  String get lsCarefulTip =>
      'Sorgfältig: Zweifelhafte halten an und fragen dich, welche es ist.';

  @override
  String get lsQuick => 'Schnell';

  @override
  String get lsCareful => 'Sorgfältig';

  @override
  String lsThisSession(int n) {
    return '$n in dieser Sitzung';
  }

  @override
  String get lsScanPhotoTooltip => 'Ein einzelnes Foto scannen';

  @override
  String get lsStartingCamera => 'Wecke die Kamera auf…';

  @override
  String get lsCantUseCamera => 'Ich kann die Kamera nicht benutzen';

  @override
  String get lsCameraUnavailable => 'Kamera nicht verfügbar.';

  @override
  String get lsScanPhoto => 'Ein Foto scannen';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 gleiche · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Liegt schon auf dem Tisch: $carta · nimm sie weg und leg sie neu hin, oder tipp auf \"+1 gleiche\"';
  }

  @override
  String lsSeeing(String carta) {
    return 'Sehe: $carta';
  }

  @override
  String get lsPassACard => 'Halt eine Karte vor die Kamera…';

  @override
  String lsIsThis(String carta) {
    return 'Ist das $carta? Ich bin mir nicht sicher — tipp zum Wählen.';
  }

  @override
  String get lsNotThisOne => 'Nicht diese — Druckversion wechseln';

  @override
  String get lsRetry => 'Nochmal versuchen';

  @override
  String get scBadImage =>
      'Ich konnte das Bild nicht lesen (ist das ein gültiges Foto?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Kein Ordner';

  @override
  String scAlsoTo(String carpeta) {
    return 'Und außerdem in: $carpeta';
  }

  @override
  String get scLookingForCard => 'Suche die Karte auf dem Foto…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Erkenne… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Karten',
      one: '1 Karte',
    );
    return '$_temp0 · $copias insgesamt';
  }

  @override
  String scToReview(int n) {
    return '$n zum Prüfen (tipp sie an)';
  }

  @override
  String scUnknown(int n) {
    return '$n nicht erkannt (tipp an, um von Hand zu wählen)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Fotos übersprungen (zu groß oder unlesbar)',
      one: '1 Foto übersprungen (zu groß oder unlesbar)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'Ich habe auf diesen Fotos keine einzige Karte erkannt. Probier besseres Licht oder weniger Spiegelung.';

  @override
  String scAddN(int n) {
    return '$n zur Sammlung hinzufügen';
  }

  @override
  String get scDropPhotos => 'Wirf hier die Fotos deiner Karten rein';

  @override
  String get scDropExplain =>
      'Eins oder mehrere auf einmal — und wenn ein Foto MEHRERE Karten zeigt (eine Albumseite, der volle Tisch), hole ich sie alle raus und packe sie in eine Liste, die du prüfen und beliebig übernehmen kannst. Handyfoto oder Scan, beides geht.';

  @override
  String get scPickPhotos => 'Fotos wählen';

  @override
  String get scMatchHigh => 'hohe Übereinstimmung';

  @override
  String get scMatchMedium => 'mittlere Übereinstimmung';

  @override
  String get scMatchLow => 'geringe Übereinstimmung';

  @override
  String get scAddToCollection => 'Zur Sammlung hinzufügen';

  @override
  String get scSeeOptions => 'Nicht diese — Optionen zeigen';

  @override
  String get scScanAnother => 'Nächste scannen';

  @override
  String get scNotSure => 'Ich bin mir nicht sicher';

  @override
  String get scWhichIsIt => 'Welche ist es?';

  @override
  String get scNoneQuiteFits =>
      'Keine passt so richtig. Ist es eine davon? Wenn nicht, probier ein anderes Foto mit besserem Licht.';

  @override
  String get scNoEdges =>
      'Ich habe die Kanten der Karte nicht gesehen und deshalb das ganze Bild genommen. Das sind die Ähnlichsten:';

  @override
  String get scCropped =>
      'Das habe ich zugeschnitten. Die Kandidaten, nach Ähnlichkeit:';

  @override
  String get scDiscard => 'Verwerfen und nächste scannen';

  @override
  String get suCardsName => 'Karten und Preise';

  @override
  String get suCardsWhat => 'der komplette Scryfall-Katalog';

  @override
  String get suHistoryName => 'Preisverlauf';

  @override
  String get suHistoryWhat => '~90 Tage Cardmarket';

  @override
  String get suHashesName => 'Fingerabdrücke des Scanners';

  @override
  String get suHashesWhat => 'zum Erkennen per Foto';

  @override
  String suUpToDate(String fecha) {
    return 'aktuell ($fecha)';
  }

  @override
  String get suUpdated => 'aktualisiert';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'aktualisiert ($fecha)';
  }

  @override
  String get suFailedOffline => 'konnte ich nicht holen (keine Verbindung)';

  @override
  String get suKeepingOld => 'ich bleibe bei dem, was du hattest';

  @override
  String get suNeedMissing => 'fehlt, ich hole sie';

  @override
  String get suNeedStale => 'es gibt eine neue';

  @override
  String get suNeedFresh => 'aktuell';

  @override
  String get suAllUpToDate => 'Alles aktuell. Ich komme rein…';

  @override
  String get suUpdatingCards => 'Bringe deine Karten und Preise auf Stand…';

  @override
  String get suChecking => 'Schaue, ob es was Neues gibt…';

  @override
  String get suNoDownloadNote =>
      'Was schon aktuell ist, wird nicht heruntergeladen. In der App kannst du jede Aktualisierung erzwingen.';

  @override
  String get suEnter => 'Loslegen';

  @override
  String get suEnterNow => 'Jetzt loslegen';

  @override
  String icBadFile(String error) {
    return 'Ich konnte die Datei nicht lesen: $error';
  }

  @override
  String get icNotCsv =>
      'Das sieht nicht nach einer CSV aus — wirf eine .csv- oder .txt-Datei rein.';

  @override
  String get icTitle => 'Sammlung importieren';

  @override
  String get icExplain =>
      'Zieh deine ManaBox-CSV hierher (Moxfield, Archidekt oder jede CSV mit den Spalten Name und Quantity gehen auch), wähl sie über den Knopf, oder füg ihren Inhalt von Hand ein:';

  @override
  String get icPickFile => 'Datei wählen…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas Karten ($copias Exemplare) zu deiner Sammlung hinzugefügt.';
  }

  @override
  String get icReplaceMine => 'Meine aktuelle Sammlung ersetzen';

  @override
  String get icReplaceWhy =>
      'Schalt es ein, wenn du deine komplette CSV neu importierst: Es verhindert doppelte Mengen und schärft das Album nach Druckversionen.';

  @override
  String icImporting(int hechas, int total) {
    return 'Importiere $hechas von $total Karten…';
  }

  @override
  String get icDropHere => 'Wirf deine CSV hier rein';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n Spielsteine/Embleme ignoriert (die gehören nicht ins Deck, alles gut).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Nicht erkannt: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• Kein Kaufpreis in der CSV: Damit gibt es kein P&L (ManaBox exportiert ihn in der Spalte \"Purchase price\").';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n Exemplare mit Kaufpreis: Du siehst das P&L jetzt im Markt.';
  }

  @override
  String get icImporting2 => 'Importiere…';

  @override
  String get icImport => 'Importieren';

  @override
  String dkDeleted(String nombre) {
    return 'Deck \"$nombre\" gelöscht';
  }

  @override
  String get dkUndo => 'RÜCKGÄNGIG';

  @override
  String dkOpenFailed(String error) {
    return 'Ich konnte das Deck nicht öffnen (ist die Datenbank heruntergeladen?): $error';
  }

  @override
  String get dkMyDecks => 'Meine Decks';

  @override
  String get dkEmpty =>
      'Hier wohnen die Decks, die du aus Forge speicherst (Speichern-Knopf in der Deck-Ansicht).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gespeichert',
      one: '1 gespeichert',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos Zauber + $tierras Länder · gespeichert am $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Deck löschen';

  @override
  String get ddSaved => '✓ Deck gespeichert — du findest es im Reiter Decks';

  @override
  String get ddReforged =>
      '✓ Deck auf deine Kurve neu geschmiedet — Liste aktualisiert';

  @override
  String get ddSaveToMyDecks => 'In Meine Decks speichern';

  @override
  String get ddCopyList => 'Liste kopieren (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ Liste kopiert — füg sie in Moxfield, Arena oder Discord ein';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos Zauber + $tierras Länder';
  }

  @override
  String get ddHaveAll => '✓ Du hast jede Karte';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ Dir fehlen $n Karten aus diesem Deck — sie bleiben in der Liste, gelöscht wurden sie nicht',
      one:
          '⚠ Dir fehlt 1 Karte aus diesem Deck — sie bleibt in der Liste, gelöscht wurde sie nicht',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Dein Spielplan';

  @override
  String get ddManaCurve => 'Manakurve';

  @override
  String get ddEditCurve => 'Kurve bearbeiten';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Zieh die Balken ↑↓ · $hechizos Zauber → $tierras Länder';
  }

  @override
  String get ddReforgeCurve => 'Mit dieser Kurve neu schmieden';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras Länder · ✦ $hechizos Zauber · Ø Kosten $coste';
  }

  @override
  String get ddWhyWorks => 'Warum funktioniert dieses Deck?';

  @override
  String ddLands(int n) {
    return 'LÄNDER ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Deck gesamt: ~$precio €';
  }

  @override
  String get ddCheapestPrice =>
      'Preis der günstigsten Druckversion (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n ohne bekannten Preis · günstigste Druckversion (Cardmarket)';
  }

  @override
  String get ddInstants => 'Spontanzauber';

  @override
  String get ddTypeCreatures => 'Kreaturen';

  @override
  String get ddTypeSorceries => 'Hexereien';

  @override
  String get ddTypeEnchantments => 'Verzauberungen';

  @override
  String get ddTypeArtifacts => 'Artefakte';

  @override
  String get ddTypeOther => 'Sonstige';

  @override
  String get ddOutOfRange => '  (außerhalb des gesunden Bereichs 20-27)';

  @override
  String get acRecalcTitle => 'Erfolge neu berechnen?';

  @override
  String get acRecalcBody =>
      'Deine Karten werden noch einmal durchgesehen und Erfolge, die heute nicht mehr zutreffen, verschwinden. Gut, um versehentlich vergebene zu korrigieren; wenn du Karten verkauft hast, verlierst du die aber auch.';

  @override
  String get acRecalc => 'Neu berechnen';

  @override
  String get acAllFine => 'Alles stimmte: Es wurde kein Erfolg entfernt.';

  @override
  String acRemovedN(int n) {
    return '$n Erfolge entfernt, die nicht mehr zutreffen.';
  }

  @override
  String get acTitle => 'Erfolge';

  @override
  String get acRecalcTooltip => 'Mit meinen aktuellen Karten neu berechnen';

  @override
  String get acCertsTooltip => 'Zertifikate';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos von $total Erfolgen · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Level $nivel · noch $xp XP bis $siguiente';
  }

  @override
  String get acIMissing => 'Mir fehlen';

  @override
  String get acSecret => 'Geheimer Erfolg';

  @override
  String get acSecretDesc => 'Er zeigt sich erst, wenn du ihn schaffst.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Geschafft$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' am $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return 'Level $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'Du bist jetzt $titulo. Du hast $hechos von $total Erfolgen.';
  }

  @override
  String get acOk => 'Alles klar';

  @override
  String get acSeeAchievements => 'Erfolge ansehen';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 Erfolg! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (und $n weitere)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Für Set-Zertifikate braucht es die Kartendatenbank ($error)';
  }

  @override
  String get ceWhoseName => 'Auf wessen Namen?';

  @override
  String get ceCollectorName => 'Dein Sammlername';

  @override
  String get ceInNameOf => 'Auf den Namen…';

  @override
  String get ceEmptyWithData =>
      'Du hast noch kein Set komplett. Wenn du eins im Album vollmachst, taucht hier dein Zertifikat zum Herunterladen auf.';

  @override
  String get ceEmptyNoData =>
      'Um ein Set zu zertifizieren, muss ich die genaue Druckversion deiner Karten kennen: importiere deine ManaBox-CSV neu (sie bringt die Scryfall-ID mit).';

  @override
  String get ceNothingSaved => 'Es wurde nichts gespeichert.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Zertifikat gespeichert unter $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'Speichern ging nicht: $error';
  }

  @override
  String get cePickFirstCard => 'Die Karte wählen, mit der ich angefangen habe';

  @override
  String get ceChangeFirstCard =>
      'Die Karte ändern, mit der ich angefangen habe';

  @override
  String get ceDownloadPng => 'PNG herunterladen';

  @override
  String get cdNotFound => 'Ich finde diese Karte nicht in der Datenbank.';

  @override
  String cdLoadFailed(String error) {
    return 'Ich konnte die Karte nicht laden: $error';
  }

  @override
  String get cdPrev => 'Vorherige (←)';

  @override
  String get cdNext => 'Nächste (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Karte nicht gefunden';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return 'Du hast $total$divisa für $qty $copias bezahlt ($unidad pro Stück)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Exemplare',
      one: 'Exemplar',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ Du hast $n Exemplare in deiner Sammlung',
      one: '✓ Du hast 1 Exemplar in deiner Sammlung',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'Du hast diese Karte (noch) nicht.';

  @override
  String cdNoPrice(String mercado) {
    return 'Kein Preis für diese Karte auf $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'VERSIONEN ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'kein Preis pro Druckversion auf $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return '$mercado-Preise ($moneda) · normal / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'du hast x$n';
  }

  @override
  String get smMythic => 'Mythisch selten';

  @override
  String get smRare => 'Selten';

  @override
  String get smUncommon => 'Ungewöhnlich';

  @override
  String get smCommon => 'Gewöhnlich';

  @override
  String smLoadFailed(String error) {
    return 'Ich konnte das Set nicht laden: $error';
  }

  @override
  String get smSearchInSet => 'Im Set suchen…';

  @override
  String get smRarityAll => 'Seltenheit: alle';

  @override
  String get smPriceDown => 'Preis ↓';

  @override
  String get smPriceUp => 'Preis ↑';

  @override
  String get smNumber => 'Nummer';

  @override
  String get smOnlyMine => 'Nur meine';

  @override
  String smCardsCount(int n) {
    return '$n Karten';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: kein Preis pro Druckversion';
  }

  @override
  String smListedValue(String mercado) {
    return 'gelisteter Wert ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'Du hast $pagado bezahlt · heute sind sie $hoy wert';
  }

  @override
  String get pnNoPnl =>
      'Ohne Kaufpreis gibt es kein P&L. Importiere deine ManaBox-CSV mit der Spalte \"Purchase price\", dann taucht es hier auf.';

  @override
  String pnOverAll(int n) {
    return 'über die $n Exemplare in deiner Sammlung';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'über $conprecio von $total Exemplaren (bei den anderen ist kein Kaufpreis notiert)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return 'Für $n gekaufte Exemplare gibt es keinen heutigen Preis in der Datenbank: bleiben außen vor';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'du hast außerdem $importe $moneda bezahlt, was nicht umgerechnet wird';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n Exemplare ohne Währung in der CSV: angenommen $moneda';
  }

  @override
  String get pcTitle => 'Preisentwicklung';

  @override
  String get pcNoHistory => 'Für diese Karte gibt es noch keinen Preisverlauf.';

  @override
  String pcTodayPrice(String precio) {
    return 'Preis heute: $precio €. Das Diagramm erscheint, sobald mehrere Tage da sind.';
  }

  @override
  String get pcExplain =>
      'ManaForge notiert den Preis jeder Karte, die du ansiehst oder besitzt, Tag für Tag. Um mit den echten letzten Monaten von Cardmarket zu starten, hol dir den Verlauf im Markt.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Tage',
      one: '1 Tag',
    );
    return 'min $min € · max $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'Aus welchen Sets?';

  @override
  String get spSearchHint => 'Nach Name oder Code suchen (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Nur meine';

  @override
  String spClearN(int n) {
    return 'Die $n entfernen';
  }

  @override
  String get spNoneNamed =>
      'Kein Set mit dem Namen. Schalt \"Nur meine\" aus, um alle zu sehen.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n Karten';
  }

  @override
  String get spNoFilter => 'Kein Set-Filter';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Sets nehmen',
      one: '1 Set nehmen',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'Ich suche nur Karten aus dem Set $set. Tipp drauf, um zu wechseln oder die Sperre zu lösen.';
  }

  @override
  String get slLockHint =>
      'Sperr ein Set, um eine Box oder ein Precon zu scannen: Der Scanner sucht nur darin und trifft die Druckversion genau.';

  @override
  String slSetIs(String set) {
    return 'Set: $set';
  }

  @override
  String get slSetAll => 'Set: alle';

  @override
  String get slLockTitle => 'Druckversion sperren';

  @override
  String get slLockBody =>
      'Tipp den Set-Code ein (z. B. AER, MH3, LCI), um eine ganze Box zu scannen: Es werden nur Karten aus diesem Set gesucht.';

  @override
  String get slSetCode => 'Set-Code';

  @override
  String get slClearLock => 'Sperre lösen';

  @override
  String get stHintQuick =>
      'Halt Karten davor: Die klaren notieren sich hier von allein (gleiche Exemplare stapeln sich ×N). Die zweifelhaften werden zum Prüfen markiert. Am Ende bestätigst du alle.';

  @override
  String get stHintCareful =>
      'Halt Karten davor: Die klaren notieren sich von allein; die zweifelhaften fragen dich, welche es ist. Am Ende bestätigst du alle.';

  @override
  String stAddN(int n) {
    return '$n zur Sammlung hinzufügen';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return '$n zur Sammlung und zu $carpeta hinzufügen';
  }

  @override
  String get stOneLess => 'Eine weniger';

  @override
  String get stAnotherSame => 'Noch eine gleiche';

  @override
  String get stOnTable => 'auf dem Tisch';

  @override
  String cdLastData(String fecha) {
    return ' (letzter Stand: $fecha)';
  }

  @override
  String get cdLegalities => 'Legalität';

  @override
  String get slLockButton => 'Sperren';

  @override
  String get wn031Headline =>
      'Álbum que habla claro, Forge más cómodo y todo más fluido';

  @override
  String get wn031Album =>
      'Álbum: si tu mercado (Card Kingdom, Mana Pool) no publica precio por edición, te lo dice claro en vez de enseñar un \$0.00 mudo.';

  @override
  String get wn031Forge =>
      'Forge: al terminar una forja puedes volver a la selección sin perder lo elegido, y el aviso de mazo borrado dura más y se puede cerrar.';

  @override
  String get wn031Home =>
      'Inicio: el valor total marca ~ cuando hay cartas sin precio, para no vender certeza donde hay estimación.';

  @override
  String get wn031Perf =>
      'Más fluido: álbum, importaciones y búsquedas responden mejor con colecciones grandes.';

  @override
  String get wn030Headline =>
      'Forge nach Sets, Kaufpreis und Hinweise auf neue Versionen';

  @override
  String get wn030Forge =>
      'Forge: Wähl, aus welchen Sets die Karten kommen. Und wenn du \"Karten einbeziehen, die ich nicht habe\" einschaltest, baut es das Deck aus dem ganzen gewählten Set und sagt dir, wie viele dir fehlen und was sie kosten.';

  @override
  String get wn030Pnl =>
      'Kaufpreis und P&L: Wenn deine ManaBox-CSV \"Purchase price\" mitbringt, zeigt dir der Markt, was du bezahlt hast, was es heute wert ist und die Differenz. Währungen werden nie vermischt.';

  @override
  String get wn030PhotoFolder =>
      'Beim Scannen per Foto kannst du jetzt auch einen Ordner wählen, wie beim Live-Scanner.';

  @override
  String get wn030Album =>
      'Album: was dir aus jedem Set fehlt, und was es kosten würde.';

  @override
  String get wn030Background =>
      'Hintergrundbild: Leg dahinter, welches Bild du willst, mit regelbarem Schleier, und wähl die Farbe der Kacheln und der Schrift, damit man darauf noch lesen kann.';

  @override
  String get wn030Window =>
      'Das Fenster geht da auf, wo du es gelassen hast, in der Größe, in der du es gelassen hast.';

  @override
  String get wn030Achievements =>
      'Die Erfolge heißen nicht mehr wie ihre Bedingung, sondern wie der Moment: \"Da geht mein ganzes Geld hin\", \"Hundert Seltene und keine spielbar\".';

  @override
  String get wn030Update =>
      'Die App sagt Bescheid, wenn es eine neue Version gibt (sie aktualisiert sich nie von selbst) und prüft den SHA-256-Fingerabdruck jeder Datenbank, die sie herunterlädt.';

  @override
  String get wn030Shortcuts =>
      'Tastenkürzel: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, und Escape.';

  @override
  String get wn030Linux =>
      'Unter Linux legt ein Installer ManaForge mit seinem Icon ins Anwendungsmenü.';

  @override
  String get wn030License =>
      'PolyForm-Noncommercial-Lizenz: Teil sie und bastel dran, so viel du willst, aber verkauft wird sie nicht.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Karten',
      one: '1 Karte',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Decks',
      one: '1 Deck',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Ordner',
      one: '1 Ordner',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Erfolge',
      one: '1 Erfolg',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'leeres Backup';

  @override
  String get bkStoreCollection => 'deine Sammlung';

  @override
  String get bkStoreFolders => 'deine Ordner';

  @override
  String get bkStoreDecks => 'deine Decks';

  @override
  String get bkStoreAchievements => 'deine Erfolge';

  @override
  String get bkStoreWishlist => 'deine Wunschliste';

  @override
  String get bkStoreCertificates => 'deine Zertifikate';

  @override
  String get bkStoreMarket => 'dein bevorzugter Markt';

  @override
  String get bkStoreRecents => 'die zuletzt angesehenen Karten';

  @override
  String get bkStoreValueHistory => 'der Wertverlauf';

  @override
  String get bkStorePriceHistory => 'der Preisverlauf';

  @override
  String get bkKindAuto => 'automatisch';

  @override
  String get bkKindPreRestore => 'vor dem Wiederherstellen';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig =>
      'Diese Datei ist viel zu groß für ein ManaForge-Backup.';

  @override
  String get bkErrExpandTooBig =>
      'Dieses Backup ist entpackt viel zu groß: Das sieht nicht nach einem echten ManaForge-Backup aus.';

  @override
  String get bkErrNotABackup => 'Diese Datei ist kein ManaForge-Backup.';

  @override
  String get bkErrNewerVersion =>
      'Dieses Backup stammt von einer neueren ManaForge-Version. Aktualisiere die App und probier es nochmal.';

  @override
  String get bkErrIncomplete =>
      'Dieses Backup ist unvollständig: Deine Daten sind nicht drin.';

  @override
  String bkErrDamaged(String almacen) {
    return 'Dieses Backup ist beschädigt: $almacen lässt sich nicht lesen.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'Ich konnte nicht in den Datenordner schreiben, also habe ich nichts angefasst: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'Das Wiederherstellen ist auf halber Strecke steckengeblieben ($escritos von $total Dateien). Ich habe kein früheres Backup von dem, was da war. Details: $error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return 'Das Wiederherstellen ist auf halber Strecke steckengeblieben ($escritos von $total Dateien). Zum Zurückgehen stell $ruta wieder her. Details: $error';
  }

  @override
  String get siImportTooBig =>
      'Diese Datei ist viel zu groß für eine Kartenliste.';

  @override
  String get siInsecureDownload =>
      'Der Download ist bei einer unsicheren Adresse gelandet und wurde abgebrochen.';

  @override
  String get siRedirectNowhere =>
      'Der Download leitet ins Nirgendwo weiter und wurde abgebrochen.';

  @override
  String get siTooManyRedirects =>
      'Der Download dreht sich zu oft im Kreis und wurde abgebrochen.';

  @override
  String get siDownloadTooBig =>
      'Der Download ist viel größer, als er sein sollte, und wurde abgebrochen.';

  @override
  String get siBadHash =>
      'Das Heruntergeladene passt nicht zum Fingerabdruck, der auf GitHub steht. Es wurde nichts installiert. Probier es nochmal; wenn es weiter passiert, sag Bescheid.';

  @override
  String get siBackgroundNotImage =>
      'Wähl ein Bild (.jpg, .png oder .webp) als Hintergrund.';

  @override
  String get siBackgroundTooBig =>
      'Dieses Bild ist zu groß, um es als Hintergrund zu nehmen.';

  @override
  String get siScanTooBig => 'Dieses Foto ist zu groß, um es zu erkennen.';

  @override
  String get bgImages => 'Bilder';

  @override
  String bgImageFailed(String error) {
    return 'Ich konnte dieses Bild nicht nehmen: $error';
  }

  @override
  String get bgLowContrast =>
      'Zu nah an der Farbe der Kachel: Die Schrift passt sich selbst an, damit man sie lesen kann.';

  @override
  String get bgChipColor => 'Farbe der Reiter';

  @override
  String get bgIconColor => 'Farbe der Symbole';

  @override
  String get bgUseThis => 'Dieses nehmen';

  @override
  String get bgSaveSwatch => 'Guardar como muestra';

  @override
  String get bgSwatchTip => 'Muestra guardada';

  @override
  String get bgSwatchHint =>
      'Muestra guardada — bórrala con clic derecho o manteniendo pulsado';

  @override
  String get bgSwatchDeleteTitle => '¿Borrar esta muestra?';

  @override
  String get bgSwatchDeleteBody =>
      'Se quita de tu paleta guardada. Puedes volver a guardarla cuando quieras.';

  @override
  String get camGstreamerMissing =>
      'GStreamer ist nicht installiert. Installier es mit:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'Die Kamera $dispositivo liefert kein Bild (gst-launch endete mit $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'Die Kamera $dispositivo hat in 6 s keinen einzigen Frame geliefert.';
  }

  @override
  String get camNoCameras =>
      'Ich finde keine Kamera (/dev/video*). Ist sie angeschlossen? Prüf mit `lsusb`, ob das System sie sieht.';

  @override
  String camNoneWorked(String detalle) {
    return 'Keine Kamera lieferte ein Bild:\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Wiederherstellen';

  @override
  String get fpUnselect => 'Abwählen';

  @override
  String get stClear => 'Leeren';

  @override
  String get tlRemove => 'Entfernen';

  @override
  String get tlUnrecognized => 'Nicht erkannt';

  @override
  String get tlNothingAlike =>
      'nichts Ähnliches in der Datenbank — neu fotografieren oder entfernen';

  @override
  String get tlTapToPick => 'tipp an, um von Hand aus den Ähnlichen zu wählen';

  @override
  String get tlReview => 'prüfen';

  @override
  String get lsQuantity => 'Anzahl';

  @override
  String get scPhotos => 'Fotos';

  @override
  String get ftWhichFolder => 'In welchen Ordner sollen sie?';

  @override
  String get ftWhichFolderSub =>
      'In deine Sammlung kommen sie so oder so; der Ordner ist nur ein Etikett, um sie später wiederzufinden.';

  @override
  String get ftNone => 'Keiner';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Karten',
      one: '1 Karte',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => 'Neuer Ordner…';

  @override
  String get ftNewFolder => 'Neuer Ordner';

  @override
  String get ftNewFolderHint => 'Kiste aus dem Laden, Zum Verkaufen…';

  @override
  String get sgTitle => 'Das Auge des Scanners';

  @override
  String get sgWhy =>
      'Um Karten ohne Internet zu erkennen, brauche ich die Datenbank der visuellen Fingerabdrücke (~12 MB): die Signatur jeder Magic-Illustration. Sie wird einmal heruntergeladen.';

  @override
  String get sgDownload => 'Fingerabdruck-Datenbank herunterladen';

  @override
  String get cmFullCard => 'Ganze Karte ansehen (Preise und Legalität)';

  @override
  String get cmSwipeHint =>
      'zieh oder nimm ← →, um zu blättern · tipp daneben zum Schließen';

  @override
  String get cmTapOutHint => 'tipp daneben zum Schließen';

  @override
  String get fcTitle => 'Mit welcher Karte hast du angefangen?';

  @override
  String get fcRemove => 'Entfernen';

  @override
  String get fcSearchHint => 'In deiner Sammlung suchen';

  @override
  String get fcNoMatch => 'Ich finde keine Karte damit.';

  @override
  String get acNoneWithFilters => 'Mit diesen Filtern ist hier nichts.';

  @override
  String get acAll => 'Alle';

  @override
  String get tsTitle => 'Testmodus — schlag das Meta';

  @override
  String get tsIntro =>
      'Wähl, gegen welches Meta-Deck du spielen willst. ManaForge baut Decks aus DEINEN Karten, simuliert hunderte Partien dagegen und behält das, was am meisten gewinnt — und probiert dazu Kartentausche einzeln durch, um es zu schärfen.';

  @override
  String get tsLoadingMeta => 'Lade das Meta…';

  @override
  String get tsLocalPresets => 'Lokale Vorlagen (ohne Verbindung)';

  @override
  String get tsNoDeckToFace =>
      'Mit deinen jetzigen Karten kriege ich kein vollständiges Deck zusammen, das antreten könnte. Füg mehr Karten hinzu und probier es nochmal.';

  @override
  String tsSimFailed(String error) {
    return 'Ich konnte nicht simulieren: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota des Metas';
  }

  @override
  String get tsSimulating =>
      'Simuliere Partien… (ein paar Sekunden; alles auf deinem Rechner)';

  @override
  String tsFindBest(String meta) {
    return 'Mein bestes Deck gegen $meta suchen';
  }

  @override
  String get tsHonesty =>
      'Ganz ehrlich: Die Simulation versteht Manafarben, Mulligans, Evasion (Fliegend, Trampelschaden, Todesberührung…), Removal zur Spontanzauber-Zeit und Gegenzauber — aber nicht den kompletten Text jeder Karte. Der Prozentwert dient dazu, deine Decks UNTEREINANDER zu vergleichen, nicht als exakte Vorhersage.';

  @override
  String tsChampion(String meta) {
    return 'Dein Champion gegen $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'geschätzte Siege · $mazos Decks getestet · $partidas Partien pro Deck';
  }

  @override
  String get tsNoDominant =>
      'Kein Deck aus deiner Sammlung beherrscht dieses Matchup — das hier kämpft am besten. Schau dir seine Schwächen im Detail an.';

  @override
  String get tsSeeDeck => 'Ganzes Deck ansehen (und speichern)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total Erfolge · $xp XP bis Level $nivel';
  }

  @override
  String get hsForgeDecks => 'Decks schmieden';

  @override
  String get hsTestYourself => '⚔ stell dich auf die Probe';

  @override
  String get bgCustom => 'Eigene';

  @override
  String get bgPickCustom => 'Eine eigene Farbe wählen';

  @override
  String get bgCustomColor => 'Eigene Farbe';

  @override
  String get bgSampleTab => 'Rot';

  @override
  String get cfSortRecent => 'Gerade hinzugefügt';

  @override
  String get cfSortAlpha => 'Name A-Z';

  @override
  String get cfSortCmc => 'Kosten';

  @override
  String get cfSortQty => 'Anzahl';

  @override
  String get cfSortBy => 'Sortieren nach';

  @override
  String get cfSort => 'Sortierung';

  @override
  String get cfClear => 'Zurücksetzen';

  @override
  String get cfCost => 'Kosten';

  @override
  String get cfCostAll => 'Kosten: alle';

  @override
  String cfCostN(String n) {
    return 'Kosten $n';
  }

  @override
  String get cfType => 'Typ';

  @override
  String get cfTypeAll => 'Typ: alle';

  @override
  String get cfTypeCreature => 'Kreaturen';

  @override
  String get cfTypeInstant => 'Spontanzauber';

  @override
  String get cfTypeSorcery => 'Hexereien';

  @override
  String get cfTypeArtifact => 'Artefakte';

  @override
  String get cfTypeEnchantment => 'Verzauberungen';

  @override
  String get cfTypeLand => 'Länder';

  @override
  String get cfPower => 'Stärke';

  @override
  String get cfPowerAll => 'Stärke: alle';

  @override
  String cfPowerMin(int n) {
    return 'Stärke ≥ $n';
  }

  @override
  String get cfToughness => 'Widerstandskraft';

  @override
  String get cfToughnessAll => 'Widerstandskraft: alle';

  @override
  String cfToughnessMin(int n) {
    return 'Widerstandskraft ≥ $n';
  }

  @override
  String get cfNoDate => 'ohne Datum';

  @override
  String get cfToday => 'heute';

  @override
  String get cfYesterday => 'gestern';

  @override
  String cfDaysAgo(int n) {
    return 'vor $n Tagen';
  }

  @override
  String get pcWeek => 'Woche';

  @override
  String get pcMonth => 'Monat';

  @override
  String get pcAll => 'Alles';

  @override
  String get vpTapCorrect => 'Tipp die richtige Karte an';

  @override
  String get achCopias1 => 'Die erste von vielen';

  @override
  String get achCopias10 => 'Ich wollte nur eine kaufen';

  @override
  String get achCopias50 => 'Passt nicht mehr in eine Hand';

  @override
  String get achCopias100 => 'Hundert, Tendenz steigend';

  @override
  String get achCopias500 => 'Die Kiste wird langsam eng';

  @override
  String get achCopias1000 => 'Tausend. Und ich will sie alle';

  @override
  String get achCopias5000 => 'Das ist jetzt ein Lagerhaus';

  @override
  String get achCopias10000 => 'Zehntausend, aber ich hab\'s im Griff';

  @override
  String achCopiasDesc(String n) {
    return 'Hab $n Karten in deiner Sammlung.';
  }

  @override
  String get achDistintas25 => 'Da kommt Abwechslung rein';

  @override
  String get achDistintas100 => 'Hundert verschiedene Gesichter';

  @override
  String get achDistintas500 => 'Eine halbe Bibliothek';

  @override
  String get achDistintas1000 => 'Wandelnde Enzyklopädie';

  @override
  String get achDistintas2500 => 'Ich kenne sie nicht mehr alle';

  @override
  String get achDistintas5000 => 'Das Archiv';

  @override
  String achDistintasDesc(String n) {
    return 'Hab $n VERSCHIEDENE Karten (Doppelte zählen nicht).';
  }

  @override
  String get achPlaysets1 => 'Vier Gleiche';

  @override
  String get achPlaysets20 => 'Zwanzig Playsets, null Decks';

  @override
  String get achPlaysets1Desc => 'Hab 4 Exemplare derselben Karte.';

  @override
  String get achPlaysets20Desc =>
      'Hab 20 verschiedene Playsets (je 4 Exemplare).';

  @override
  String get achComunes10 => 'Die, die keiner haben will';

  @override
  String get achComunes50 => 'Der übliche Stapel';

  @override
  String get achComunes200 => 'König des Stapels';

  @override
  String get achComunes500 => 'Eine Flut von Gewöhnlichen';

  @override
  String achComunesDesc(String n) {
    return 'Hab $n verschiedene gewöhnliche Karten.';
  }

  @override
  String get achInfrecuentes10 => 'Eine Stufe über gewöhnlich';

  @override
  String get achInfrecuentes50 => 'Feines Silber';

  @override
  String get achInfrecuentes200 => 'Jäger der Ungewöhnlichen';

  @override
  String get achInfrecuentes500 => 'Silber eimerweise';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Hab $n verschiedene ungewöhnliche Karten.';
  }

  @override
  String get achRaras5 => 'Klingt gut beim Boosteröffnen';

  @override
  String get achRaras25 => 'Eine Truhe voller Seltener';

  @override
  String get achRaras100 => 'Hundert Seltene und keine spielbar';

  @override
  String get achRaras300 => 'Der Tresorraum';

  @override
  String achRarasDesc(String n) {
    return 'Hab $n verschiedene seltene Karten.';
  }

  @override
  String get achMiticas1 => 'Meine erste Mythische';

  @override
  String get achMiticas10 => 'Zehn Mythische';

  @override
  String get achMiticas50 => 'Mythischer Sammler';

  @override
  String get achMiticas150 => 'Mythisches Pantheon';

  @override
  String achMiticasDesc(String n) {
    return 'Hab $n verschiedene mythisch seltene Karten.';
  }

  @override
  String get achBlancas25 => 'Ordnung muss sein';

  @override
  String get achBlancas100 => 'Silbernes Heer';

  @override
  String achBlancasDesc(String n) {
    return 'Hab $n verschiedene weiße Karten.';
  }

  @override
  String get achAzules25 => 'Das lasse ich nicht zu';

  @override
  String get achAzules100 => 'Elfenbeinturm';

  @override
  String achAzulesDesc(String n) {
    return 'Hab $n verschiedene blaue Karten.';
  }

  @override
  String get achNegras25 => 'Dunkler Pakt';

  @override
  String get achNegras100 => 'Herr der Gruft';

  @override
  String achNegrasDesc(String n) {
    return 'Hab $n verschiedene schwarze Karten.';
  }

  @override
  String get achRojas25 => 'Alles abfackeln';

  @override
  String get achRojas100 => 'Großbrand';

  @override
  String achRojasDesc(String n) {
    return 'Hab $n verschiedene rote Karten.';
  }

  @override
  String get achVerdes25 => 'Ein Trieb';

  @override
  String get achVerdes100 => 'Der ganze Wald';

  @override
  String achVerdesDesc(String n) {
    return 'Hab $n verschiedene grüne Karten.';
  }

  @override
  String get achIncoloras25 => 'Kaltes Metall';

  @override
  String get achIncoloras100 => 'Ewige Schmiede';

  @override
  String achIncolorasDesc(String n) {
    return 'Hab $n verschiedene farblose Karten.';
  }

  @override
  String get achArcoiris => 'Alle fünf Farben';

  @override
  String get achArcoirisDesc =>
      'Hab mindestens eine Karte von jeder der 5 Farben.';

  @override
  String get achMulticolor10 => 'Farben mischen';

  @override
  String get achMulticolor50 => 'Goldenes Bündnis';

  @override
  String achMulticolorDesc(String n) {
    return 'Hab $n verschiedene mehrfarbige Karten.';
  }

  @override
  String get achCincocolores => 'Alle fünf auf einen Schlag';

  @override
  String get achCincocoloresDesc => 'Hab eine Karte mit allen fünf Farben.';

  @override
  String get achSets1 => 'Erstes Set';

  @override
  String get achSets5 => 'Fünf Welten';

  @override
  String get achSets10 => 'Planeswalker in Ausbildung';

  @override
  String get achSets25 => 'Weltenbummler';

  @override
  String get achSets50 => 'Das halbe Multiversum';

  @override
  String achSetsDesc(String n) {
    return 'Hab Karten aus $n verschiedenen Sets.';
  }

  @override
  String get achSetscompletos1 => 'Keine einzige fehlt';

  @override
  String get achSetscompletos3 => 'Drei volle Alben';

  @override
  String get achSetscompletos10 => 'Meister des Albums';

  @override
  String get achSetscompletos1Desc => 'Mach ein ganzes Set im Album voll.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Mach $n ganze Sets voll.';
  }

  @override
  String get achAnyos5 => 'Fünf Jahrgänge Pappe';

  @override
  String get achAnyos15 => 'Zeitmaschine';

  @override
  String achAnyosDesc(String n) {
    return 'Hab Karten aus $n verschiedenen Erscheinungsjahren.';
  }

  @override
  String get achValor10 => 'Die ersten Euros';

  @override
  String get achValor50 => 'Das Sparschwein';

  @override
  String get achValor250 => 'Da geht das Taschengeld hin';

  @override
  String get achValor1000 => 'Da geht mein ganzes Geld hin';

  @override
  String get achValor5000 => 'Sag es bloß keinem';

  @override
  String get achValor10000 => 'Mehr wert als mein Auto';

  @override
  String get achValor25000 => 'Eine Sammlung fürs Museum';

  @override
  String achValorDesc(String n) {
    return 'Bring deine Sammlung auf einen Wert von $n € oder mehr.';
  }

  @override
  String get achJoya20 => 'Eine von den guten Karten';

  @override
  String get achJoya100 => 'Das Schmuckstück der Sammlung';

  @override
  String get achJoya500 => 'Die kommt nie aus der Hülle';

  @override
  String get achJoya1000 => 'Tausend Euro in einer einzigen Hülle';

  @override
  String get achJoya2500 => 'Der heilige Gral';

  @override
  String achJoyaDesc(String n) {
    return 'Hab eine einzelne Karte, die $n € oder mehr wert ist.';
  }

  @override
  String get achFoils1 => 'Der erste Glanz';

  @override
  String get achFoils10 => 'Es funkelt';

  @override
  String get achFoils50 => 'Die Kiste glänzt';

  @override
  String get achFoils200 => 'Hier ist nichts mehr matt';

  @override
  String get achFoils500 => 'Alles glänzt';

  @override
  String get achFoils1000 => 'Glanzfabrik';

  @override
  String achFoilsDesc(String n) {
    return 'Hab $n foil-Karten.';
  }

  @override
  String get achFoiljoya10 => 'Eine gute foil';

  @override
  String get achFoiljoya50 => 'Eine teure foil';

  @override
  String get achFoiljoya200 => 'Eine foil fürs Museum';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Hab eine foil, die $n € oder mehr wert ist.';
  }

  @override
  String get achFoilvalor50 => 'Eine Vitrine, die glitzert';

  @override
  String get achFoilvalor250 => 'Teure Vitrine';

  @override
  String get achFoilvalor1000 => 'Tausend Euro Glanz';

  @override
  String get achFoilvalor5000 => 'Vitrine fürs Museum';

  @override
  String achFoilvalorDesc(String n) {
    return 'Bring alle deine foils zusammen auf $n € oder mehr.';
  }

  @override
  String get achMazos1 => 'Erstes Deck';

  @override
  String get achMazos5 => 'Fünf Decks gespeichert';

  @override
  String get achMazos25 => 'Die Werkstatt steht nie still';

  @override
  String achMazosDesc(String n) {
    return 'Speichere $n mit Forge gebaute Decks.';
  }

  @override
  String get achMazoscore => 'Ein rundes Deck';

  @override
  String get achMazoscoreDesc => 'Bau ein Deck mit 90 Punkten oder mehr.';

  @override
  String get achMazocolores3 => 'Dreifarbig';

  @override
  String get achMazocolores5 => 'Spielbarer Regenbogen';

  @override
  String achMazocoloresDesc(String n) {
    return 'Speichere ein Deck mit $n Farben.';
  }

  @override
  String get achMazomono => 'Nichts dazugemischt';

  @override
  String get achMazomonoDesc => 'Speichere ein einfarbiges Deck.';

  @override
  String get achMazocommander => 'Das Kommando übernommen';

  @override
  String get achMazocommanderDesc => 'Speichere ein Commander-Deck.';

  @override
  String get achEscaneadas1 => 'Erster Scan';

  @override
  String get achEscaneadas50 => 'Schnelle Hände';

  @override
  String get achEscaneadas500 => 'Scannen am Fließband';

  @override
  String get achEscaneadas2000 => 'Ich scanne im Schlaf';

  @override
  String achEscaneadasDesc(String n) {
    return 'Scanne $n Karten mit der Kamera oder per Foto.';
  }

  @override
  String get achFoto9 => 'Eine ganze Seite aus einem Foto';

  @override
  String get achFoto20 => 'Zwanzig auf einen Streich';

  @override
  String achFotoDesc(String n) {
    return 'Erkenne $n Karten auf einem einzigen Foto.';
  }

  @override
  String get achEscaneoperfecto => 'Keine einzige zum Prüfen';

  @override
  String get achEscaneoperfectoDesc =>
      'Scanne eine ganze Seite, ohne dass eine Karte zum Prüfen übrig bleibt.';

  @override
  String get achDias2 => 'Du bist wieder da';

  @override
  String get achDias7 => 'Eine Woche hier';

  @override
  String get achDias30 => 'Ein Monat hier';

  @override
  String get achDias100 => 'Hundert Tage hier';

  @override
  String achDiasDesc(String n) {
    return 'Nutze ManaForge an $n verschiedenen Tagen.';
  }

  @override
  String get achRacha3 => 'Drei am Stück';

  @override
  String get achRacha7 => 'Perfekte Woche';

  @override
  String get achRacha30 => 'Ein Monat ohne Aussetzer';

  @override
  String achRachaDesc(String n) {
    return 'Komm $n Tage hintereinander vorbei.';
  }

  @override
  String get achSemanas => 'Vier Wochen ohne zu fehlen';

  @override
  String get achSemanasDesc => 'Nutze ManaForge 4 Wochen hintereinander.';

  @override
  String get achCarpetas1 => 'Die Ordnung beginnt';

  @override
  String get achCarpetas5 => 'Alles einsortiert';

  @override
  String achCarpetasDesc(String n) {
    return 'Leg $n Ordner an.';
  }

  @override
  String get achCarpetagrande => 'Ein Riesenordner';

  @override
  String get achCarpetagrandeDesc =>
      'Hab einen Ordner mit 100 Karten oder mehr.';

  @override
  String get achCarpetavalor => 'Diesen Ordner verleihe ich nicht';

  @override
  String get achCarpetavalorDesc =>
      'Hab einen Ordner, der 100 € oder mehr wert ist.';

  @override
  String get achTierrasbasicas => 'Die fünf Standardländer';

  @override
  String get achTierrasbasicasDesc =>
      'Hab alle fünf Standardland-Typen (Ebene, Insel, Sumpf, Gebirge und Wald).';

  @override
  String get achFuerza => 'Was für ein Vieh';

  @override
  String get achFuerzaDesc => 'Hab eine Kreatur mit Stärke 10 oder mehr.';

  @override
  String get achCoste => 'Die wirke ich nie im Leben';

  @override
  String get achCosteDesc =>
      'Hab eine Karte mit umgewandelten Manakosten von 10 oder mehr.';

  @override
  String get achCostecero => 'Umsonst';

  @override
  String get achCosteceroDesc => 'Hab eine Karte mit Kosten 0.';

  @override
  String get achTipos => 'Von allem etwas';

  @override
  String get achTiposDesc =>
      'Hab mindestens eine Kreatur, einen Spontanzauber, eine Hexerei, ein Artefakt, eine Verzauberung, ein Land und einen Planeswalker.';

  @override
  String get achPlaneswalkers => 'Eine Runde Planeswalker';

  @override
  String get achPlaneswalkersDesc => 'Hab 5 verschiedene Planeswalker.';

  @override
  String get achNoventas => 'Ein Relikt aus den 90ern';

  @override
  String get achNoventasDesc => 'Hab eine Karte aus den 1990ern.';

  @override
  String get achIdiomas1 => 'Die kann ich nicht lesen';

  @override
  String get achIdiomas25 => 'Vielsprachige Sammlung';

  @override
  String get achIdiomas1Desc =>
      'Hab eine Karte in einer anderen Sprache als Englisch.';

  @override
  String get achIdiomas25Desc => 'Hab 25 Karten in anderen Sprachen.';

  @override
  String get achWishlist => 'Die Liste der Gelüste';

  @override
  String get achWishlistDesc => 'Setz 20 Karten auf deine Wunschliste.';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Silber';

  @override
  String get achTierGold => 'Gold';

  @override
  String get achTierMythic => 'Mythisch';

  @override
  String get achCatCollection => 'Sammlung';

  @override
  String get achCatRarity => 'Seltenheiten';

  @override
  String get achCatColor => 'Farben';

  @override
  String get achCatSets => 'Sets';

  @override
  String get achCatValue => 'Wert';

  @override
  String get achCatFoils => 'Foils';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Scanner';

  @override
  String get achCatDedication => 'Hingabe';

  @override
  String get achCatFolders => 'Ordner';

  @override
  String get achCatCuriosities => 'Kuriositäten';

  @override
  String get achRankApprentice => 'Lehrling';

  @override
  String get achRankSummoner => 'Beschwörer';

  @override
  String get achRankMage => 'Magier';

  @override
  String get achRankArchmage => 'Erzmagier';

  @override
  String get achRankMaster => 'Meister';

  @override
  String get achRankPlaneswalker => 'Planeswalker';

  @override
  String get bkConfirmWord => 'ERSETZEN';

  @override
  String get rfTitle => 'Reset de fábrica';

  @override
  String get rfIntro =>
      'Deja la app como recién instalada: sin colección, sin mazos y sin bases descargadas.';

  @override
  String get rfButton => 'Borrar todo';

  @override
  String get rfConfirmTitle1 => '¿Borrar todos los datos?';

  @override
  String get rfWillDelete =>
      'Se borrarán: la colección, los mazos, las carpetas, los logros, los certificados, la lista de deseos, el historial de valor, los ajustes y fondos, y las bases descargadas de cartas, precios y huellas.';

  @override
  String get rfBackupFirst =>
      'Antes de borrar nada se guardará una copia de seguridad automática; podrás restaurarla desde Ajustes → Datos.';

  @override
  String rfTypeWord(String palabra) {
    return 'Escribe $palabra para continuar.';
  }

  @override
  String get rfDeleteWord => 'ELIMINAR';

  @override
  String get rfContinueAction => 'Continuar';

  @override
  String get rfConfirmTitle2 => 'Última confirmación';

  @override
  String get rfConfirmBody2 =>
      'Esto borra todos tus datos de este equipo. Solo podrás volver atrás restaurando la copia que se guarda ahora.';

  @override
  String get rfEraseAction => 'Borrar definitivamente';

  @override
  String get rfWorking => 'Borrando los datos… no cierres la app.';

  @override
  String rfBackupFailed(String motivo) {
    return 'No se pudo guardar la copia previa, así que NO se ha borrado nada. $motivo';
  }

  @override
  String rfPartial(String cosas) {
    return 'No se pudo borrar todo. Queda: $cosas. Puedes reintentarlo desde Ajustes tras reiniciar.';
  }

  @override
  String get rfHalfDone =>
      'El borrado se quedó a medias. La app volverá a la pantalla de arranque; si algo sigue ahí, reintenta el reset.';

  @override
  String dbErrCards(String codigo) {
    return 'Die Kartendatenbank ließ sich nicht herunterladen (HTTP $codigo). Probier es später nochmal.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'Die Fingerabdruck-Datenbank ließ sich nicht herunterladen (HTTP $codigo). Probier es später nochmal.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'Der Preisverlauf ließ sich nicht herunterladen (HTTP $codigo). Probier es später nochmal.';
  }

  @override
  String ddCardCount(int n) {
    return '$n Karten';
  }

  @override
  String get ddForgedWith => 'Geschmiedet mit ManaForge';

  @override
  String get fxThemeLifegain => 'Lebensdrain';

  @override
  String get fxThemeSacrifice => 'Opfern';

  @override
  String get fxThemeSpells => 'Zauber';

  @override
  String get fxThemeArtifacts => 'Artefakte';

  @override
  String get fxThemeCounters => '+1/+1-Marken';

  @override
  String get fxThemeTokens => 'Schwarm';

  @override
  String get fxThemeGraveyard => 'Friedhof';

  @override
  String get fxThemeReanimator => 'Reanimation';

  @override
  String fxThemeTribal(String tribe) {
    return '$tribe-Stamm';
  }

  @override
  String get fxThemeGoodstuff => 'das Beste aus deinen Karten';

  @override
  String get fxTagLifegain =>
      'Jeder Lebenspunkt, den du dazubekommst, ist Schaden für sie: zapf ab und halt durch.';

  @override
  String get fxTagSacrifice =>
      'Deine Kreaturen sind tot mehr wert: opfere sie und kassier ab.';

  @override
  String get fxTagSpells =>
      'Jeder Spontanzauber zählt: spiel im Zug des Gegners und bestraf ihn.';

  @override
  String get fxTagArtifacts =>
      'Bau deine Werkstatt auf: jedes Artefakt macht die anderen stärker.';

  @override
  String get fxTagCounters =>
      '+1/+1-Marken: deine Kreaturen wachsen, bis keiner mehr rankommt.';

  @override
  String get fxTagTokens =>
      'Flute das Board mit Spielsteinen: wo sie einen haben, hast du fünf.';

  @override
  String get fxTagGraveyard =>
      'Dein Friedhof ist deine zweite Hand: füll ihn und recycle das Beste.';

  @override
  String get fxTagAggro =>
      'Schnell rauskommen und aufs Gesicht: die Partie sollte früh vorbei sein.';

  @override
  String get fxTagTempo =>
      'Früh Druck machen und den Vorsprung mit deinen Zaubern schützen.';

  @override
  String fxTagMidrange(String tema) {
    return 'Trade deine Karten gut und gewinn das Midgame über $tema.';
  }

  @override
  String get fxTagControl =>
      'Halt durch, hab auf alles eine Antwort und mach den Sack zu, wenn dir das Board gehört.';

  @override
  String get fxMidLifegain =>
      'Verkette deine Lebensquellen mit den Karten, die den Gegner dafür bestrafen.';

  @override
  String get fxMidSacrifice =>
      'Opfere das Billige, um zu ziehen, zu drainen oder den Rest wachsen zu lassen.';

  @override
  String get fxMidSpells =>
      'Lass Mana offen: deine Kreaturen wachsen mit jedem Zauber, den du wirkst.';

  @override
  String get fxMidArtifacts =>
      'Leg billige Artefakte raus und schalt die frei, die sie zählen.';

  @override
  String get fxMidCounters =>
      'Stapel Marken auf ein oder zwei Kreaturen und beschütz sie.';

  @override
  String get fxMidTokens =>
      'Mach jeden Zug Spielsteine und such die Effekte, die sie größer machen.';

  @override
  String get fxMidGraveyard =>
      'Mille und wirf mit Absicht ab: was im Friedhof landet, kommt zurück.';

  @override
  String get fxEndLifegain =>
      'Mit hohem Leben schaltest du auf Angriff: da kommen sie nicht mehr hin.';

  @override
  String get fxEndSacrifice =>
      'Der angehäufte Wert holt dir die Partie: jeder Trade ist für dich gratis.';

  @override
  String get fxEndSpells =>
      'Zwei Zauber im selben Zug und deine Kreaturen machen den Sack zu.';

  @override
  String get fxEndArtifacts =>
      'Dein Board ist doppelt so viel wert wie seins: beende es mit deinen Payoffs.';

  @override
  String get fxEndCounters =>
      'Eine riesige, geschützte Bedrohung beendet die Partie in zwei Angriffen.';

  @override
  String get fxEndTokens =>
      'Greif in Masse an: kein Block hält deine ganze Armee auf.';

  @override
  String get fxEndGraveyard =>
      'Nutze deine besten Karten doppelt: du spielst mit zwei Händen gegen eine.';

  @override
  String get fxTurns12 => 'Z1-Z2';

  @override
  String get fxTurns34 => 'Z3-Z4';

  @override
  String get fxTurns5 => 'Z5+';

  @override
  String get fxAggroEarly => 'Jeden Zug eine Kreatur, ohne Ausnahme.';

  @override
  String get fxAggroMid =>
      'Weiter angreifen; heb den Direktschaden auf, um Blocker wegzuräumen.';

  @override
  String get fxAggroLate => 'Alles rein: hier solltest du die Partie zumachen.';

  @override
  String get fxTempoEarly =>
      'Billige Bedrohung, und Mana offen lassen, wann immer es geht.';

  @override
  String get fxTempoMid =>
      'Angreifen und deine Zauber im Zug des Gegners einsetzen.';

  @override
  String get fxTempoLate =>
      'Beschütz deine Kreaturen und mach es über die Luft oder mit Direktschaden zu.';

  @override
  String get fxMidrangeEarly =>
      'Entwickle dein Board und verschenk keine Karten: gute Eins-zu-eins-Trades.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Bring deine Motoren für $tema ins Spiel und stabilisier das Board.';
  }

  @override
  String get fxMidrangeLate =>
      'Deine Karten sind mehr wert als seine: mach daraus die Partie.';

  @override
  String get fxControlEarly =>
      'Jeden Zug ein Land, und antworte nur auf das, was zählt.';

  @override
  String get fxControlMid =>
      'Räum das Board ab und zieh Karten: die Zeit spielt für dich.';

  @override
  String get fxControlLate =>
      'Leg eine Bedrohung nach und beschütz sie bis zum Schluss.';

  @override
  String get fxArchetypeAggro => 'Aggro';

  @override
  String get fxArchetypeTempo => 'Tempo';

  @override
  String get fxArchetypeMidrange => 'Midrange';

  @override
  String get fxArchetypeControl => 'Control';

  @override
  String fxWhyItWorks(
    String coste,
    String tierras,
    String arquetipo,
    int criaturas,
    int interaccion,
    String tema,
  ) {
    return 'Durchschnittskosten $coste: Nach Karstens Regel (24 Länder bei Kosten 3.0, ±1 pro ±0.5) spielt dieses Deck $tierras Länder — im Rahmen eines $arquetipo-Decks. Dazu $criaturas Kreaturen, um das Board zu halten, und $interaccion Interaktionskarten für alles, was der Gegner bringt. Das Thema ($tema) bündelt deine Synergien: je mehr Teile des Themas du siehst, desto stärker wird jedes einzelne.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'Mit dieser Kurve kommen $tierras Länder raus: außerhalb des gesunden Bereichs ($min-$max). Pass die Gesamtzahl der Zauber an.';
  }

  @override
  String get fxNoCards =>
      'Deine Sammlung hat nicht genug Karten in diesen Farben, um diese Kurve zu füllen. Probier weniger Zauber oder andere Kosten.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'Diese Kurve (Durchschnittskosten $coste mit $tierras Ländern) passt in kein gesundes Profil: ein billiges Deck will weniger Länder, ein teures will mehr. Bring beides näher zusammen.';
  }

  @override
  String get fxNoBasics =>
      'In der Sammlung sind nicht genug Standardländer für diese Kurve.';

  @override
  String fxHardRule(String detalle) {
    return 'Die gewünschte Kurve bricht eine harte Regel: $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Billige Kreaturen und Schaden aufs Gesicht: Es killt dich in 4-5 Zügen, wenn du das Tempo nicht mithältst.';

  @override
  String get tsPresetAzorius =>
      'Gegenzauber, Massenentfernung und Kartenziehen: Es zieht die Partie in die Länge und gewinnt mit ein paar Finishern.';

  @override
  String get tsPresetGolgari =>
      'Eins-zu-eins-Trades, effiziente Kreaturen und schwarzes Removal: Es gewinnt das lange Spiel über Kartenqualität.';
}
