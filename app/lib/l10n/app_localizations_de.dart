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
      'Dein Level und die Abzeichen fürs Scannen, Sortieren und Schmieden. Öffnet sich über die Level-Karte auf der Startseite.';

  @override
  String get onbCertificatesTitle => 'Zertifikate';

  @override
  String get onbCertificatesBody =>
      'Die großen Meilensteine gibt es als Urkunde, die du als PDF sichern oder herzeigen kannst. Sie stecken in den Erfolgen.';
}
