// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabCollection => 'Collezione';

  @override
  String get tabAlbum => 'Album';

  @override
  String get tabDecks => 'Mazzi';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'Mercato';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get tabScan => 'Scansiona';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsIntro =>
      'ManaForge è gratuita e con il codice in chiaro (licenza PolyForm Noncommercial: condividila e modificala quanto vuoi, ma non si vende). Niente pubblicità, niente premium, niente account. Le tue carte sono tue.';

  @override
  String get howItWorks => 'Come funziona';

  @override
  String get howScan =>
      'Passa le carte davanti alla webcam o trascina una foto: entrano in collezione con l\'edizione esatta.';

  @override
  String get howCollection =>
      'Tutto quello che hai, con ricerca, filtri e cartelle (le cartelle sono etichette: una carta può stare in più di una).';

  @override
  String get howAlbum =>
      'Una pagina per espansione, come un album di figurine: quello che hai a colori, quello che manca in grigio, e quanto costerebbe completarlo.';

  @override
  String get howForge =>
      'Mazzi completi e legali con le tue carte. Oppure con quelle di un\'espansione che non hai ancora, dicendoti cosa comprare e quanto costa.';

  @override
  String get howDecks =>
      'Quelli che salvi. Se vendi una carta, il mazzo lo dice invece di fingere che tu ce l\'abbia ancora.';

  @override
  String get howMarket =>
      'Quanto vale la tua collezione, il suo grafico, la lista dei desideri con avvisi di prezzo — e, se il CSV aveva il prezzo d\'acquisto, quanto ci guadagni o ci perdi.';

  @override
  String get howPrivacy =>
      'Tutto viene calcolato sul tuo dispositivo. Le uniche cose che vanno in rete sono i database e, se lo lasci attivo, il controllo delle nuove versioni.';

  @override
  String get shortcuts => 'Scorciatoie da tastiera';

  @override
  String get shortcutTabs => 'Cambiare scheda';

  @override
  String get shortcutScan => 'Aprire lo scanner';

  @override
  String get shortcutSearch => 'Cercare nella scheda in cui sei';

  @override
  String get shortcutSettings => 'Impostazioni';

  @override
  String get shortcutClose => 'Chiudere quello che hai aperto sopra';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Come il sistema';

  @override
  String get languagePartial =>
      'L\'app viene tradotta a tappe: l\'impalcatura è già nella tua lingua, il resto delle schermate resta per ora in spagnolo.';

  @override
  String get versionTitle => 'Versione di ManaForge';

  @override
  String versionYouHave(String version) {
    return 'Hai la $version.';
  }

  @override
  String get versionSeeWhatsNew => 'Vedi cosa porta';

  @override
  String get versionNotifyMe => 'Avvisami delle nuove versioni';

  @override
  String get versionNotifyMeWhy =>
      'Chiede una volta al giorno a GitHub qual è l\'ultima versione. Non scarica né installa nulla.';

  @override
  String get versionCheckNow => 'Cerca ora';

  @override
  String get versionUpToDate =>
      'Sei all\'ultima versione (o GitHub non risponde in questo momento).';

  @override
  String versionThereIs(String version) {
    return 'È uscita ManaForge $version.';
  }

  @override
  String get versionGoDownload => 'Vai al download';

  @override
  String versionNotAuto(String version) {
    return 'Hai la $version. L\'app non si aggiorna da sola: ti porta al download.';
  }

  @override
  String get versionNotNow => 'Non ora';

  @override
  String get versionSee => 'Vedi';

  @override
  String whatsNewTitle(String version) {
    return 'Novità della $version';
  }

  @override
  String get whatsNewClose => 'Si gioca';

  @override
  String get downloadCopyLink => 'Copia il link';

  @override
  String get downloadClose => 'Chiudi';

  @override
  String get downloadTitle => 'Scarica ManaForge';

  @override
  String get backgroundTitle => 'Sfondo';

  @override
  String get backgroundWhat =>
      'Metti dietro l\'app l\'immagine che vuoi. Wizards pubblica sfondi ufficiali di ogni espansione: scarica quello che ti piace e scegli qui. L\'app non se li scarica da sola — quell\'arte ha un proprietario e distribuirla non tocca a lei.';

  @override
  String get backgroundPick => 'Scegli un\'immagine…';

  @override
  String get backgroundChange => 'Cambia immagine…';

  @override
  String get backgroundOfficial => 'Sfondi ufficiali di Magic';

  @override
  String get backgroundRemove => 'Togli lo sfondo';

  @override
  String get backgroundDim =>
      'Quanto si scurisce (perché il testo resti leggibile)';

  @override
  String get backgroundCardColor => 'Colore delle schede';

  @override
  String get backgroundTextColor => 'Colore del testo';

  @override
  String get backgroundCardOpacity => 'Quanto le schede coprono lo sfondo';

  @override
  String get backgroundColorDefault => 'Quello di sempre';

  @override
  String get backgroundPreview => 'Come si vede';

  @override
  String get backgroundNotAnImage =>
      'Scegli un\'immagine (.jpg, .png o .webp) come sfondo.';

  @override
  String get backgroundTooBig =>
      'Quell\'immagine è troppo grande per usarla come sfondo.';

  @override
  String get welcomeTitle =>
      'Benvenuto alla forgia. Fai entrare le tue carte come preferisci — o prova Forge prima di aggiungerne una.';

  @override
  String get welcomeScan => 'Scansiona le mie carte';

  @override
  String get welcomeImport => 'Importa CSV (ManaBox)';

  @override
  String get welcomeTryForge => 'Prova Forge senza collezione';

  @override
  String get decksEmptyGoForge => 'Vai a Forge';

  @override
  String get yourCollection => 'La tua collezione';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies carte · $distinct diverse';
  }

  @override
  String get marketArrow => 'Mercato ›';

  @override
  String get certHeadingSetComplete => 'CERTIFICATO DI COLLEZIONE COMPLETA';

  @override
  String get certSubtitleSetComplete => 'Espansione completa';

  @override
  String get certHeadingWelcome => 'CERTIFICATO DI BENVENUTO';

  @override
  String get certWelcomeTitle => 'Benvenuto nel mondo di Magic';

  @override
  String get certSubtitleWelcome => 'La tua prima carta';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count carte',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return 'Ho iniziato con $name';
  }

  @override
  String get certCollectorAnon => 'Collezionista ManaForge';

  @override
  String certAwardedTo(String name) {
    return 'Assegnato a $name';
  }

  @override
  String certOnDate(String date) {
    return 'il $date';
  }

  @override
  String get certDataBy => 'Dati da Scryfall';

  @override
  String get onbCollectionTitle => 'La tua collezione';

  @override
  String get onbCollectionBody =>
      'Qui vivono tutte le tue carte, in cartelle e per espansione.';

  @override
  String get onbScanTitle => 'Scansiona carte';

  @override
  String get onbScanBody =>
      'Aggiungi nuove carte con la fotocamera o una foto.';

  @override
  String get onbForgeTitle => 'Forgia mazzi';

  @override
  String get onbForgeBody =>
      'Crea mazzi completi con le carte che già possiedi.';

  @override
  String get onbDecksTitle => 'I tuoi mazzi';

  @override
  String get onbDecksBody => 'I mazzi salvati da Forge compaiono qui.';

  @override
  String get onbSkip => 'Salta';

  @override
  String get onbNext => 'Avanti';

  @override
  String get onbGotIt => 'Ho capito';
}
