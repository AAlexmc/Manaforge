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

  @override
  String get onbBack => 'Indietro';

  @override
  String get tourMenuTitle => 'Guide';

  @override
  String get tourWelcomeName => 'Giro veloce';

  @override
  String get tourHomeName => 'La schermata iniziale';

  @override
  String get onbEditHomeTitle => 'Personalizza la home';

  @override
  String get onbEditHomeBody =>
      'Con questo pulsante scegli quali sezioni compaiono nella home e in che ordine.';

  @override
  String get onbLangTitle => 'Lingua';

  @override
  String get onbLangBody => 'Cambia qui la lingua di tutta l\'app.';

  @override
  String get onbLookTitle => 'Aspetto';

  @override
  String get onbLookBody =>
      'Metti uno sfondo e scegli i colori di carte, testo, schede e icone.';

  @override
  String get tourSettingsName => 'Personalizza l\'app';

  @override
  String get tourFullName => 'Giro completo dell\'app';

  @override
  String get tourCollectionName => 'La tua collezione e le cartelle';

  @override
  String get tourForgeName => 'Forgiare un mazzo';

  @override
  String get tourMarketName => 'Mercato, wishlist e avvisi';

  @override
  String get onbAllCardsTitle => 'Tutte le carte';

  @override
  String get onbAllCardsBody =>
      'Tutta la tua collezione: cercare, filtrare e ordinare.';

  @override
  String get onbFoldersTitle => 'Cartelle';

  @override
  String get onbFoldersBody =>
      'Le cartelle sono etichette: raggruppa quello che vuoi e una carta può stare in più di una. Con «Nuova» crei la prima.';

  @override
  String get onbAlbumMineTitle => 'L\'album per espansioni';

  @override
  String get onbAlbumMineBody =>
      'Ogni espansione con i suoi spazi. Questo filtro mostra solo le espansioni in cui hai già carte.';

  @override
  String get onbForgeBasicsTitle => 'Terre base';

  @override
  String get onbForgeBasicsBody =>
      'Se hai terre base sfuse in casa, lascialo attivo: Forge ci conta. Disattivalo per usare solo quelle della tua collezione.';

  @override
  String get onbForgeSetsTitle => 'Espansioni';

  @override
  String get onbForgeSetsBody =>
      'Limita da dove escono le carte. Senza sceglierne nessuna, Forge usa tutta la collezione.';

  @override
  String get onbForgeMissingTitle => 'Carte che non ho';

  @override
  String get onbForgeMissingBody =>
      'Attivandolo, Forge propone anche carte che ti mancano e ti dice quante sono e quanto costerebbero.';

  @override
  String get onbForgeGoTitle => 'Forgia';

  @override
  String get onbForgeGoBody =>
      'Questo pulsante crea i mazzi. Con molte espansioni ci mette qualche secondo.';

  @override
  String get onbForgeTestTitle => 'Modalità Test';

  @override
  String get onbForgeTestBody =>
      'Metti il tuo mazzo contro uno del meta e scopri cosa gli manca per vincere.';

  @override
  String get onbMarketPickTitle => 'Scegliere il mercato';

  @override
  String get onbMarketPickBody =>
      'Cardmarket o TCGplayer: cambia il prezzo di ogni carta e il suo grafico.';

  @override
  String get onbWishlistTitle => 'Wishlist';

  @override
  String get onbWishlistBody =>
      'Le carte che vuoi. Il contatore diventa verde quando una arriva al tuo prezzo.';

  @override
  String get onbPriceAlertTitle => 'Avviso di prezzo';

  @override
  String get onbPriceAlertBody =>
      'Cerca una carta, tocca il segnalibro per metterla in wishlist e imposta un prezzo obiettivo: l\'app ti avvisa quando scende.';

  @override
  String get tourProgressName => 'Obiettivi e certificati';

  @override
  String get onbAchievementsTitle => 'Obiettivi e livello';

  @override
  String get onbAchievementsBody =>
      'Il tuo livello e tutto quello che hai guadagnato. Sale scansionando, ordinando e forgiando.';

  @override
  String get onbCertificatesTitle => 'Certificati';

  @override
  String get onbCertificatesBody =>
      'I traguardi grossi diventano un diploma che puoi salvare in PDF o mostrare. Stanno dentro Obiettivi.';

  @override
  String get onbBackupTitle => 'Copia di sicurezza';

  @override
  String get onbBackupBody =>
      'Salva collezione, mazzi e cartelle in un file e recuperali se cambi computer. In più ogni settimana si fa una copia da sola.';

  @override
  String onbTapHere(String pantalla) {
    return 'Tocca qui per aprire $pantalla.';
  }

  @override
  String get onbAchievementsName => 'Obiettivi';

  @override
  String get onbDataSectionTitle => 'Dati';

  @override
  String get onbDataSectionBody =>
      'Qui sta tutto quello che l\'app conserva: la base di carte e le tue copie di sicurezza.';

  @override
  String get onbCardDbTitle => 'Base di dati delle carte';

  @override
  String get onbCardDbBody =>
      'Riscaricala per avere carte nuove, prezzi freschi e quello che chiede dati recenti, come il filtro per anno di Forge.';

  @override
  String get onbAboutTitle => 'L\'app';

  @override
  String get onbAboutBody =>
      'Cosa fa ogni scheda, le scorciatoie da tastiera, la versione e la licenza.';

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
}
