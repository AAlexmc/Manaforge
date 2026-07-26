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
  String get colStartHere => 'La tua collezione inizia qui';

  @override
  String get colNeedDb =>
      'Prima mi serve il database con tutte le carte di Magic (si scarica una volta sola e poi funziona tutto senza internet).';

  @override
  String colDownloading(String pct) {
    return 'Sto scaricando… $pct %';
  }

  @override
  String get colDownloadDb => 'Scarica il database delle carte';

  @override
  String get colScryfall =>
      'Dati e immagini di Scryfall · Niente account, niente pagamenti: resta tutto sul tuo dispositivo.';

  @override
  String get colAlbumTooltip => 'Album per espansioni';

  @override
  String get colImportTooltip => 'Importa un CSV di ManaBox';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies carte · $distinct diverse$valor';
  }

  @override
  String get colAllCards => 'Tutte le carte';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct diverse · cerca, filtra e ordina';
  }

  @override
  String get colFolders => 'Cartelle';

  @override
  String get colNewFolder => 'Nuova';

  @override
  String get colNoFolders =>
      'Non hai ancora cartelle. Servono a raggruppare quello che ti pare: \"rare di Aetherdrift\", \"da vendere\", \"la scatola di sopra\"… Una carta può stare in più cartelle.';

  @override
  String get colCreateFirstFolder => 'Crea la prima cartella';

  @override
  String get colEmptyTitle => 'Qui inizia la tua collezione';

  @override
  String get colEmptyBody =>
      'Scansiona le tue carte con la fotocamera o importa un CSV di ManaBox. Compariranno qui e nell\'album.';

  @override
  String get colImportShort => 'Importa CSV';

  @override
  String acForgetTitle(String carta) {
    return 'Non hai più $carta?';
  }

  @override
  String get acForgetBody =>
      'Esce dalla tua collezione e il suo posto nell\'album torna vuoto.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Esce anche dalle $n cartelle in cui si trova.',
      one: 'Esce anche dalla cartella in cui si trova.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'I mazzi NON la perdono: resta nella lista e il mazzo ti avvisa che ti manca.';

  @override
  String get acCancel => 'Annulla';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => 'Non ce l\'ho più';

  @override
  String acAddedOn(String cuando) {
    return 'aggiunta $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'in $n cartelle',
      one: 'in 1 cartella',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Cerca una carta (spagnolo o inglese)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles di $total carte';
  }

  @override
  String get acMissingFilterData =>
      ' · alcune carte vecchie non hanno dati di filtro: reimporta il tuo CSV con \"Sostituisci\" attivo';

  @override
  String get acNoneMatch => 'Nessuna carta passa questi filtri.';

  @override
  String get acEmptyHint =>
      'Cerca la tua prima carta qui sopra, oppure torna indietro e importa il tuo CSV di ManaBox.';

  @override
  String get onbHowItWorksBody =>
      'Il riassunto di cosa fa ogni scheda, più le scorciatoie da tastiera. Se ti perdi, parti da qui.';

  @override
  String get onbVersionBody =>
      'Che versione hai, cosa porta, e se vuoi che l\'app controlli una volta al giorno se ne è uscita una nuova. Non si aggiorna da sola.';

  @override
  String get onbScanSetTitle => 'Set: tutti';

  @override
  String get onbScanSetBody =>
      'Se stai aprendo buste di UNA espansione, fissala qui: lo scanner smette di titubare tra le dieci ristampe della stessa carta.';

  @override
  String get onbScanModeTitle => 'Veloce o con calma';

  @override
  String get onbScanModeBody =>
      'In «Veloce» le carte chiare entrano da sole e quelle dubbie restano segnate da rivedere. In «Con calma» si ferma e ti chiede quale sia.';

  @override
  String get onbScanPhotoTitle => 'Scansiona una foto';

  @override
  String get onbScanPhotoBody =>
      'Niente fotocamera, o carte già fotografate? Qui molli una foto —anche con più carte, se vuoi— e le tira fuori lo stesso.';

  @override
  String get tourScanName => 'Lo scanner';

  @override
  String get albNeedDb =>
      'L\'album ha bisogno del database delle carte (scaricalo in Collezione).';

  @override
  String get albRetry => 'Riprova';

  @override
  String get albApproxMode =>
      'Album in modalità approssimata: non so ancora quale EDIZIONE esatta hai di ogni carta. Reimporta il tuo CSV con \"Sostituisci la mia collezione attuale\" attivo e l\'album si affinerà per illustrazioni.';

  @override
  String get albSearchSet => 'Cerca un\'espansione…';

  @override
  String get albOnlyMine => 'Con carte mie';

  @override
  String get albSortProgress => 'Più complete';

  @override
  String get albSortNewest => 'Più recenti';

  @override
  String get albSortOldest => 'Più vecchie';

  @override
  String get albSortName => 'Per nome';

  @override
  String get albYearAll => 'Anno: tutti';

  @override
  String get albLetterAll => 'Tutte';

  @override
  String get albNoSets => 'Nessuna espansione corrisponde al filtro.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total carte';
  }

  @override
  String get albComplete => ' · ✓ completa!';

  @override
  String albLoadError(String error) {
    return 'Non sono riuscito a caricare il set: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Cerca in $set…';
  }

  @override
  String get albOnlyMissing => 'Solo quelle che mancano';

  @override
  String get albWithVariants => 'Con varianti';

  @override
  String get albYouHaveItAll => '✓ Ce l\'hai tutta';

  @override
  String albMissingCount(int n) {
    return 'Te ne mancano $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n senza prezzo)';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles di $total';
  }

  @override
  String get albNoCardsNamed => 'Nessuna carta con quel nome qui.';

  @override
  String get fdNewFolder => 'Nuova cartella';

  @override
  String get fdEditFolder => 'Modifica cartella';

  @override
  String get fdName => 'Nome';

  @override
  String get fdNameHint => 'Rare di Aetherdrift, Da vendere…';

  @override
  String get fdColor => 'Colore';

  @override
  String get fdIcon => 'Icona';

  @override
  String get fdCreate => 'Crea';

  @override
  String get fdSave => 'Salva';

  @override
  String get fdDefaultName => 'Cartella';

  @override
  String fdDeleteTitle(String nombre) {
    return 'Vuoi eliminare \"$nombre\"?';
  }

  @override
  String get fdDeleteBody =>
      'Sparisce solo la cartella: le carte restano nella tua collezione.';

  @override
  String get fdDelete => 'Elimina';

  @override
  String get fdGone => 'Questa cartella non esiste più.';

  @override
  String get fdEditTooltip => 'Modifica nome, colore e icona';

  @override
  String get fdDeleteTooltip => 'Elimina cartella';

  @override
  String get fdAddRemove => 'Aggiungi o togli';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas carte diverse · $copias copie';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n passano il filtro';
  }

  @override
  String get fdRoughValue => ' · valore indicativo';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n carte non sono più nella tua collezione (restano segnate, casomai tornassero).',
      one:
          '1 carta non è più nella tua collezione (resta segnata, casomai tornasse).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Toglile';

  @override
  String get fdNoneMatch => 'Nessuna carta della cartella passa questi filtri.';

  @override
  String get fdEmpty =>
      'Cartella vuota. Premi \"Aggiungi o togli\" e spunta le carte che vuoi metterci.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n copie',
      one: '1 copia',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Togli dalla cartella';

  @override
  String get fpPickCards => 'Scegli le carte';

  @override
  String fpSaveCount(int n) {
    return 'Salva ($n)';
  }

  @override
  String get fpFilterByName => 'Filtra per nome…';

  @override
  String fpVisibleCards(int n) {
    return '$n carte in vista';
  }

  @override
  String get fpSelectAll => 'Seleziona tutte';

  @override
  String get fpNoneMatch => 'Nessuna carta passa questi filtri.';

  @override
  String get fgMsgReading => 'Leggo la tua collezione…';

  @override
  String get fgMsgCurve => 'Calcolo la curva di mana…';

  @override
  String get fgMsgLands => 'Distribuisco le terre…';

  @override
  String get fgMsgSynergy => 'Cerco sinergie…';

  @override
  String get fgMsgPlan => 'Scrivo il tuo piano di gioco…';

  @override
  String get fgNeedDbForSets =>
      'Mi serve il database delle carte per elencare le espansioni: Impostazioni → scarica il database.';

  @override
  String fgDbError(String error) {
    return 'Non sono riuscito a leggere il database delle carte: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' in quelle $n espansioni',
      one: ' in quell\'espansione',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'Non riesco a tirare fuori un Commander legale$donde: servono un comandante leggendario e ~62 carte DIVERSE dentro la sua identità di colore (è singleton), più terre base a sufficienza. Prova un altro formato, altre espansioni o allarga la collezione.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'Con le carte di questo pool non mi esce nessun mazzo $formato completo che rispetti le mie regole (terre a sufficienza e curva sana)$donde. $consejo Piuttosto che darti un mazzo difettoso, preferisco avvisarti.';
  }

  @override
  String get fgOf60 => 'da 60';

  @override
  String fgLegalIn(String formato) {
    return 'LEGALE in $formato';
  }

  @override
  String get fgTipMoreSets =>
      'Prova con più espansioni o togli qualche filtro.';

  @override
  String get fgTipMoreCards =>
      'Aggiungi più carte — soprattutto dei tuoi colori principali — o spunta \"includi carte che non ho\".';

  @override
  String get fgPitch =>
      'Mazzi completi e giocabili con le carte che hai già. Senza comprare niente.';

  @override
  String get fgTeaserCount => 'carte per il tuo primo mazzo';

  @override
  String get fgTeaserMissing => 'Fare un mazzo con carte che non ho';

  @override
  String get fgBasics => 'Conto sulle terre base sfuse';

  @override
  String get fgBasicsSub =>
      'Quasi tutti hanno terre base dei mazzi introduttivi; disattivalo per usare SOLO le terre base della tua collezione.';

  @override
  String get fgFormat => 'Formato di gioco';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 carte · singleton · un comandante leggendario della tua collezione · identità di colore rispettata.';

  @override
  String get fgCasualNote =>
      '60 carte, senza restrizioni di legalità: vale tutto.';

  @override
  String fgFormatNote(String formato) {
    return '60 carte usando SOLO le tue carte legali in $formato.';
  }

  @override
  String get fgWhereFrom => 'Da dove escono le carte?';

  @override
  String get fgPickSets => 'Scegli le espansioni';

  @override
  String get fgChangeSets => 'Cambia espansioni';

  @override
  String get fgNeedOneSet =>
      'Scegli almeno un\'espansione: senza filtro sarebbero le ~30.000 carte di Magic.';

  @override
  String get fgNoSetsNote =>
      'Senza espansioni scelte, Forge usa tutta la tua collezione.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Carte di $n espansioni, che tu le abbia o no.',
      one: 'Carte di 1 espansione, che tu le abbia o no.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Solo le tue carte di $n espansioni — non tutta la collezione.',
      one: 'Solo le tue carte di 1 espansione — non tutta la collezione.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'La tua collezione non salva l\'edizione di ogni carta, quindi filtrare per espansione lascerebbe fuori quasi tutto. Reimporta il tuo CSV con \"Sostituisci\" e torna qui.';

  @override
  String get fgIncludeMissing => 'Includi carte che non ho';

  @override
  String get fgIncludeMissingSub =>
      'Forge smette di limitarsi alla tua collezione e usa TUTTO quello che è stampato in quelle espansioni; poi ti dice quante carte ti mancano e quanto costerebbero.';

  @override
  String get fgYourTaste => 'A tuo gusto (facoltativo)';

  @override
  String get fgArchetypeAuto => 'Archetipo: auto';

  @override
  String get fgStyle => 'Stile';

  @override
  String get fgStyleAuto => 'Stile: auto';

  @override
  String get fgTribeElf => 'Elfi';

  @override
  String get fgTribeGoblin => 'Goblin';

  @override
  String get fgTribeZombie => 'Zombie';

  @override
  String get fgTribeVampire => 'Vampiri';

  @override
  String get fgTribeDragon => 'Draghi';

  @override
  String get fgTribeAngel => 'Angeli';

  @override
  String get fgTribeDemon => 'Demoni';

  @override
  String get fgTribeDinosaur => 'Dinosauri';

  @override
  String get fgTribeFaerie => 'Fate';

  @override
  String get fgTribeMerfolk => 'Tritoni';

  @override
  String get fgTribeHuman => 'Umani';

  @override
  String get fgTribeSpirit => 'Spiriti';

  @override
  String get fgTribeSliver => 'Schegge';

  @override
  String get fgTribeWizard => 'Maghi';

  @override
  String get fgTribeKnight => 'Cavalieri';

  @override
  String get fgTribeWarrior => 'Guerrieri';

  @override
  String get fgTribeSoldier => 'Soldati';

  @override
  String get fgTribeCat => 'Gatti';

  @override
  String get fgTribeDog => 'Cani';

  @override
  String get fgTribeRat => 'Ratti';

  @override
  String get fgTribePirate => 'Pirati';

  @override
  String get fgTribeElemental => 'Elementali';

  @override
  String get fgTribeGiant => 'Giganti';

  @override
  String get fgTribeRogue => 'Furfanti';

  @override
  String get fgDeepForge => 'Forgiatura profonda';

  @override
  String get fgDeepForgeHint =>
      'Prima di mostrarti le proposte, le fa davvero giocare tra loro (un po\' più di attesa).';

  @override
  String get fgPricePerCard => 'Prezzo per carta:';

  @override
  String get fgMin => 'min €';

  @override
  String get fgMax => 'max €';

  @override
  String get fgCardYear => 'Anno della carta:';

  @override
  String get fgFrom => 'da';

  @override
  String get fgTo => 'a';

  @override
  String get fgYearNeedsDb =>
      'Il filtro per anno vuole il database aggiornato: Impostazioni → Riscarica il database.';

  @override
  String get fgNoColorsNote =>
      'Senza colori scelti, Forge prova tutte le combinazioni.';

  @override
  String fgColorsNote(String colores) {
    return 'Solo mazzi $colores (e le loro combinazioni).';
  }

  @override
  String get fgMissingNote =>
      'Questo mazzo può contenere carte che NON hai: ogni proposta dice quante te ne mancano e quanto costerebbero (prezzo di Cardmarket).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge usa solo le tue $n carte. Non si inventa mai copie che non hai.';
  }

  @override
  String get fgForgeMissing => 'Forgia mazzi (con quello che mi manca)';

  @override
  String get fgForgeMine => 'Forgia i miei mazzi';

  @override
  String get fgTestMode => 'Modalità Test: batti un mazzo del meta';

  @override
  String get fgOffline =>
      'Si calcola tutto sul tuo dispositivo, senza internet';

  @override
  String fgForgingWith(int n) {
    return 'Stai forgiando con $n carte: ci vogliono un paio di secondi. La finestra è ancora viva.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mazzi pronti da giocare',
      one: '1 mazzo pronto da giocare',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'Con carte che ancora non hai · scorri per confrontare';

  @override
  String get fgSwipeMine =>
      'Fatti solo con le tue carte · scorri per confrontare';

  @override
  String get fgHaveAll => '✓ Hai tutte le carte';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Ti mancano $n carte',
      one: 'Ti manca 1 carta',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Vedi il mazzo completo';

  @override
  String get fgReforge => 'Riforgia';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta è a $precio (il tuo obiettivo: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 $n carte della tua wishlist sono scese al prezzo obiettivo!';
  }

  @override
  String get mkTellMeWhenDrops => 'Avvisami quando scende';

  @override
  String get mkTargetPrice => 'Prezzo obiettivo';

  @override
  String mkNow(String precio) {
    return 'Ora: $precio';
  }

  @override
  String get mkUpdated => '✓ Prezzi e carte aggiornati';

  @override
  String mkUpdateFailed(String error) {
    return 'Non sono riuscito ad aggiornare: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Storico dei prezzi pronto: i grafici ora mostrano gli ultimi mesi';

  @override
  String mkHistoryFailed(String error) {
    return 'Non sono riuscito a scaricare lo storico (quello che avevi resta intatto): $error';
  }

  @override
  String get mkHistoryLocal =>
      'Storico dei prezzi: solo quello che ManaForge annota ogni giorno sul tuo computer. Portati gli ultimi ~90 giorni veri di Cardmarket (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Storico vero di Cardmarket dal $desde al $hasta, e da lì in poi quello che annota ManaForge.';
  }

  @override
  String get mkFetchHistory => 'Scarica lo storico';

  @override
  String get mkCollectionValue => 'Quanto vale la tua collezione · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n carte';
  }

  @override
  String get mkApproxSuffix => ' · valore indicativo';

  @override
  String mkBulkPrices(String fecha) {
    return 'Prezzi Cardmarket del $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Mercato senza dati: scarica il database in Collezione. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'ESPANSIONI ($n)';
  }

  @override
  String get mkPrevious => 'Precedenti';

  @override
  String get mkNext => 'Successive';

  @override
  String get mkSearchHint => 'Cerca il prezzo di qualsiasi carta…';

  @override
  String get mkRemoveFromWishlist => 'Togli dalla wishlist';

  @override
  String get mkAddToWishlist => 'Nella wishlist: avvisami quando scende';

  @override
  String get mkYourWishlist => 'LA TUA WISHLIST';

  @override
  String mkTargetAtMost(String precio) {
    return 'obiettivo ≤ $precio';
  }

  @override
  String get mkAtPrice => 'al tuo prezzo!';

  @override
  String get mkChangeTarget => 'Cambia il prezzo obiettivo';

  @override
  String mkNoPriceIn(String market) {
    return 'nessun prezzo su $market';
  }

  @override
  String get mkPerUnit => '/pz';

  @override
  String get mkTopCards => 'LE TUE CARTE PIÙ PREZIOSE';

  @override
  String get mkImportToSeeValue =>
      'Importa la tua collezione per vedere quanto vale.';

  @override
  String mkSetCards(int n) {
    return ' · $n carte';
  }

  @override
  String get wlEmpty =>
      'Cercale in Mercato e tocca il segnalibro, così ti avvisa quando scendono al tuo prezzo.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '🔔 $n carte della tua wishlist sono al tuo prezzo obiettivo o sotto.',
      one: '🔔 1 carta della tua wishlist è al tuo prezzo obiettivo o sotto.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'Prezzi di MTGO in tix (carte digitali)';

  @override
  String get mpNoDataYet =>
      'Ancora nessun dato: aggiorna lo storico dei prezzi in Mercato';

  @override
  String get mpMtgoNote =>
      'Prezzi di MTGO in tix: sono carte digitali, non servono a valutare la tua collezione di cartone. Home, cartelle e traguardi restano su Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return 'Prezzi di $mercado in $moneda. Home, cartelle e traguardi continuano a valutare in Cardmarket (€): le valute non si convertono.';
  }

  @override
  String get mkUpdate => 'Aggiorna';

  @override
  String get mkApproxValue =>
      ' · valore approssimativo (reimporta con \"Sostituisci\" per i prezzi per edizione)';

  @override
  String get mkExactPrintings => ' · per le tue edizioni esatte';

  @override
  String mkNowSuffix(String precio) {
    return ' · ora $precio';
  }

  @override
  String get wlNothingYet => 'Non hai ancora carte nella wishlist.';

  @override
  String get stDbUpdated => '✓ Database aggiornato';

  @override
  String stUpdateFailed(String error) {
    return 'Non è stato possibile aggiornare: $error';
  }

  @override
  String get stCardDb => 'Database delle carte';

  @override
  String get stCardDbWhy =>
      'Riscaricalo per avere carte nuove, prezzi freschi e le funzioni che vogliono dati recenti (tipo il filtro per anno in Forge).';

  @override
  String get stDownloadDbAgain => 'Riscarica il database';

  @override
  String get stAppearance => 'Aspetto';

  @override
  String get stData => 'Dati';

  @override
  String get stTheApp => 'L\'app';

  @override
  String get stCredits =>
      'Dati e immagini delle carte di Scryfall. Magic: The Gathering è proprietà di Wizards of the Coast; progetto di fan sotto la loro Fan Content Policy.';

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
  String get stEditHome => 'Modifica la Home';

  @override
  String get stEditHomeSub => 'Scegli quali sezioni si vedono e in che ordine';

  @override
  String get ehLevel => 'Il tuo livello';

  @override
  String get ehShortcuts => 'Azioni rapide';

  @override
  String get ehSummary => 'Riepilogo della collezione';

  @override
  String get ehRecent => 'Viste di recente';

  @override
  String get ehDecks => 'I tuoi mazzi';

  @override
  String get ehMeta => 'Il meta adesso';

  @override
  String get ehNewSets => 'Espansioni nuove';

  @override
  String get ehGems => 'I tuoi gioielli';

  @override
  String get ehStatCards => 'carte';

  @override
  String get ehStatDistinct => 'diverse';

  @override
  String get ehStatValue => 'valore';

  @override
  String get ehStatDecks => 'mazzi';

  @override
  String get ehStatAchievements => 'obiettivi';

  @override
  String get ehHelp =>
      'Trascina per riordinare e usa l\'interruttore per scegliere cosa vedi nella Home. Una sezione accesa compare solo se ha qualcosa da mostrare.';

  @override
  String get ehSection => 'Sezione';

  @override
  String get bkNoData => 'Non trovo i tuoi dati.';

  @override
  String bkSaved(String resumen) {
    return '✓ Copia salvata · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'Non sono riuscito a salvarla: $error';
  }

  @override
  String get bkFileName => 'Copia di ManaForge';

  @override
  String bkRestoreFailed(String error) {
    return 'Non sono riuscito a ripristinarla: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Ripristinato · $resumen. ATTENZIONE: non sono riuscito a salvare quello che avevi prima ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Ripristinato · $resumen. Quello che avevi prima è salvato nella cartella backups.';
  }

  @override
  String get bkRestoring => 'Sto ripristinando la tua copia…';

  @override
  String get bkTitle => 'Copia di sicurezza';

  @override
  String get bkWhy =>
      'Le tue carte, i mazzi, le cartelle e i traguardi vivono solo su questo computer. Salva una copia ogni tanto e tienila da un\'altra parte: un disco, il cloud, quello che vuoi.';

  @override
  String get bkSave => 'Salva una copia';

  @override
  String get bkRestoreTitle => 'Ripristina una copia';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Ripristinare SOSTITUISCE le carte, i mazzi, le cartelle e i traguardi di adesso con quelli della copia. Scegli quale, premi il pulsante e scrivi $palabra: così non si ripristina niente per sbaglio.';
  }

  @override
  String get bkNoBackups =>
      'Su questo computer non ci sono ancora copie salvate.';

  @override
  String get bkWhich => 'Copia da ripristinare';

  @override
  String get bkPickOne => 'Scegli una copia';

  @override
  String get bkRestorePicked => 'Ripristina la copia scelta';

  @override
  String get bkAutoNote =>
      'Salvo una copia automatica ogni settimana (le ultime cinque) e un\'altra subito prima di ogni ripristino.';

  @override
  String get bkFromFile => 'Ripristina da un file';

  @override
  String get bkConfirmTitle => 'Ripristinare questa copia?';

  @override
  String get bkConfirmBody =>
      'Questo sostituisce la collezione, i mazzi, le cartelle e i traguardi che hai adesso con quelli di quella copia. Prima di farlo salvo quello che hai nella cartella backups, casomai volessi tornare indietro.';

  @override
  String bkWillDelete(String cosas) {
    return 'Quella copia non porta $cosas: se la ripristini, quella roba sparisce.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Scrivi $palabra per andare avanti:';
  }

  @override
  String get bkAnd => ' e ';

  @override
  String get ehReset => 'Reimposta';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Copia del $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'Non trovo nessuna fotocamera.';

  @override
  String get lsCameraGone =>
      'La fotocamera si è scollegata a metà sessione. Controlla il cavo e premi Riprova.';

  @override
  String get lsFrameCard => 'Inquadra la carta dentro il riquadro';

  @override
  String get lsNoCardThere => 'Lì non vedo nessuna carta';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n carte nella collezione',
      one: '✓ 1 carta nella collezione',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', e in \"$carpeta\"';
  }

  @override
  String get lsTitle => 'Scansione dal vivo';

  @override
  String get lsQuickTip =>
      'Veloce: le carte chiare entrano da sole; quelle dubbie restano segnate da rivedere.';

  @override
  String get lsCarefulTip =>
      'Con calma: quelle dubbie si fermano e ti chiedono quale carta sia.';

  @override
  String get lsQuick => 'Veloce';

  @override
  String get lsCareful => 'Con calma';

  @override
  String lsThisSession(int n) {
    return '$n in questa sessione';
  }

  @override
  String get lsScanPhotoTooltip => 'Scansiona una foto singola';

  @override
  String get lsStartingCamera => 'Sto accendendo la fotocamera…';

  @override
  String get lsCantUseCamera => 'Non posso usare la fotocamera';

  @override
  String get lsCameraUnavailable => 'Fotocamera non disponibile.';

  @override
  String get lsScanPhoto => 'Scansiona una foto';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 uguale · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'È già sul tavolo: $carta · toglila e rimettila, oppure tocca \"+1 uguale\"';
  }

  @override
  String lsSeeing(String carta) {
    return 'Vedo: $carta';
  }

  @override
  String get lsPassACard => 'Passa una carta davanti alla fotocamera…';

  @override
  String lsIsThis(String carta) {
    return 'È $carta? Non sono sicuro — tocca per scegliere.';
  }

  @override
  String get lsNotThisOne => 'Non è questa — cambia versione';

  @override
  String get lsRetry => 'Riprova';

  @override
  String get scBadImage =>
      'Non sono riuscito a leggere quell\'immagine (è una foto valida?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Nessuna cartella';

  @override
  String scAlsoTo(String carpeta) {
    return 'E anche in: $carpeta';
  }

  @override
  String get scLookingForCard => 'Cerco la carta nella foto…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Riconosco… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n carte',
      one: '1 carta',
    );
    return '$_temp0 · $copias in totale';
  }

  @override
  String scToReview(int n) {
    return '$n da rivedere (toccale)';
  }

  @override
  String scUnknown(int n) {
    return '$n non riconosciute (tocca per sceglierle a mano)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n foto saltate (troppo grandi o illeggibili)',
      one: '1 foto saltata (troppo grande o illeggibile)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'Non ho riconosciuto nemmeno una carta in quelle foto. Prova con più luce o meno riflessi.';

  @override
  String scAddN(int n) {
    return 'Aggiungi $n alla collezione';
  }

  @override
  String get scDropPhotos => 'Molla qui le foto delle tue carte';

  @override
  String get scDropExplain =>
      'Una o tante alla volta — e se una foto contiene PIÙ carte (una pagina dell\'album, il tavolo pieno), le tiro fuori tutte e te le metto in un\'unica lista, così le rivedi e aggiungi quelle che vuoi. Va bene sia una foto col telefono sia una scansione.';

  @override
  String get scPickPhotos => 'Scegli le foto';

  @override
  String get scMatchHigh => 'somiglianza alta';

  @override
  String get scMatchMedium => 'somiglianza media';

  @override
  String get scMatchLow => 'somiglianza bassa';

  @override
  String get scAddToCollection => 'Aggiungi alla collezione';

  @override
  String get scSeeOptions => 'Non è questa — vedi le opzioni';

  @override
  String get scScanAnother => 'Scansiona un\'altra';

  @override
  String get scNotSure => 'Non sono sicuro';

  @override
  String get scWhichIsIt => 'Qual è?';

  @override
  String get scNoneQuiteFits =>
      'Nessuna torna del tutto. È una di queste? Se no, prova un\'altra foto con più luce.';

  @override
  String get scNoEdges =>
      'Non ho visto i bordi della carta, quindi ho usato tutta l\'immagine. Queste sono le più simili:';

  @override
  String get scCropped =>
      'Ecco cosa ho ritagliato. I candidati, per somiglianza:';

  @override
  String get scDiscard => 'Scarta e scansiona un\'altra';

  @override
  String get suCardsName => 'Carte e prezzi';

  @override
  String get suCardsWhat => 'il catalogo completo di Scryfall';

  @override
  String get suHistoryName => 'Storico dei prezzi';

  @override
  String get suHistoryWhat => '~90 giorni di Cardmarket';

  @override
  String get suHashesName => 'Impronte dello scanner';

  @override
  String get suHashesWhat => 'per riconoscere dalla foto';

  @override
  String suUpToDate(String fecha) {
    return 'già aggiornato ($fecha)';
  }

  @override
  String get suUpdated => 'aggiornato';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'aggiornato ($fecha)';
  }

  @override
  String get suFailedOffline =>
      'non sono riuscito a scaricarlo (niente connessione)';

  @override
  String get suKeepingOld => 'tengo quello che avevi';

  @override
  String get suNeedMissing => 'manca, lo scarico';

  @override
  String get suNeedStale => 'ce n\'è uno nuovo';

  @override
  String get suNeedFresh => 'già aggiornato';

  @override
  String get suAllUpToDate => 'Tutto già aggiornato. Entro…';

  @override
  String get suUpdatingCards => 'Sto mettendo in pari le tue carte e i prezzi…';

  @override
  String get suChecking => 'Controllo se c\'è qualcosa di nuovo…';

  @override
  String get suNoDownloadNote =>
      'Quello che è già aggiornato non si scarica. Dentro l\'app puoi forzare qualsiasi aggiornamento.';

  @override
  String get suEnter => 'Entra';

  @override
  String get suEnterNow => 'Entra subito';

  @override
  String icBadFile(String error) {
    return 'Non sono riuscito a leggere il file: $error';
  }

  @override
  String get icNotCsv =>
      'Quello non sembra un CSV — molla un file .csv o .txt.';

  @override
  String get icTitle => 'Importa la collezione';

  @override
  String get icExplain =>
      'Trascina qui il tuo CSV di ManaBox (vanno bene anche Moxfield, Archidekt o qualsiasi CSV con le colonne Name e Quantity), scegli il file col pulsante, oppure incolla il contenuto a mano:';

  @override
  String get icPickFile => 'Scegli un file…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas carte ($copias copie) aggiunte alla tua collezione.';
  }

  @override
  String get icReplaceMine => 'Sostituisci la mia collezione attuale';

  @override
  String get icReplaceWhy =>
      'Attivalo quando reimporti il CSV completo: evita di raddoppiare le quantità e affina l\'album per edizioni.';

  @override
  String icImporting(int hechas, int total) {
    return 'Importo $hechas carte su $total…';
  }

  @override
  String get icDropHere => 'Molla qui il tuo CSV';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n pedine/emblemi ignorati (nei mazzi non ci vanno, tutto a posto).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Non riconosciute: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• Nel CSV non c\'è il prezzo d\'acquisto: niente P&L (ManaBox lo esporta nella colonna \"Purchase price\").';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n copie con prezzo d\'acquisto: ora puoi vedere il P&L in Mercato.';
  }

  @override
  String get icImporting2 => 'Sto importando…';

  @override
  String get icImport => 'Importa';

  @override
  String dkDeleted(String nombre) {
    return 'Mazzo \"$nombre\" eliminato';
  }

  @override
  String get dkUndo => 'ANNULLA';

  @override
  String dkOpenFailed(String error) {
    return 'Non sono riuscito ad aprire il mazzo (il database è scaricato?): $error';
  }

  @override
  String get dkMyDecks => 'I miei mazzi';

  @override
  String get dkEmpty =>
      'Qui vivranno i mazzi che salvi da Forge (pulsante di salvataggio nel dettaglio del mazzo).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n salvati',
      one: '1 salvato',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos magie + $tierras terre · salvato il $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Elimina mazzo';

  @override
  String get ddSaved => '✓ Mazzo salvato — lo trovi nella scheda Mazzi';

  @override
  String get ddReforged =>
      '✓ Mazzo riforgiato sulla tua curva — lista aggiornata';

  @override
  String get ddSaveToMyDecks => 'Salva nei Miei mazzi';

  @override
  String get ddCopyList => 'Copia la lista (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ Lista copiata — incollala su Moxfield, Arena o Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos magie + $tierras terre';
  }

  @override
  String get ddHaveAll => '✓ Hai tutte le carte';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ Ti mancano $n carte di questo mazzo — restano nella lista, non sono state cancellate',
      one:
          '⚠ Ti manca 1 carta di questo mazzo — resta nella lista, non è stata cancellata',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Il tuo piano di gioco';

  @override
  String get ddManaCurve => 'Curva di mana';

  @override
  String get ddEditCurve => 'Modifica la curva';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Trascina le barre ↑↓ · $hechizos magie → $tierras terre';
  }

  @override
  String get ddReforgeCurve => 'Riforgia con questa curva';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras terre · ✦ $hechizos magie · Ø costo $coste';
  }

  @override
  String get ddWhyWorks => 'Perché questo mazzo funziona?';

  @override
  String ddLands(int n) {
    return 'TERRE ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Totale del mazzo: ~$precio €';
  }

  @override
  String get ddCheapestPrice =>
      'prezzo dell\'edizione più economica (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n senza prezzo noto · edizione più economica (Cardmarket)';
  }

  @override
  String get ddInstants => 'Istantanei';

  @override
  String get ddTypeCreatures => 'Creature';

  @override
  String get ddTypeSorceries => 'Stregonerie';

  @override
  String get ddTypeEnchantments => 'Incantesimi';

  @override
  String get ddTypeArtifacts => 'Artefatti';

  @override
  String get ddTypeOther => 'Altre';

  @override
  String get ddOutOfRange => '  (fuori dall\'intervallo sano 20-27)';

  @override
  String get acRecalcTitle => 'Ricalcolare i traguardi?';

  @override
  String get acRecalcBody =>
      'Si riguardano le tue carte e si tolgono i traguardi che oggi non reggono più. Serve a sistemare quelli dati per errore; se hai venduto carte, perderai anche quelli.';

  @override
  String get acRecalc => 'Ricalcola';

  @override
  String get acAllFine => 'Tornava tutto: non è stato tolto nessun traguardo.';

  @override
  String acRemovedN(int n) {
    return 'Tolti $n traguardi che non reggono più.';
  }

  @override
  String get acTitle => 'Traguardi';

  @override
  String get acRecalcTooltip => 'Ricalcola con le carte che ho adesso';

  @override
  String get acCertsTooltip => 'Certificati';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos traguardi su $total · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Livello $nivel · mancano $xp XP per il $siguiente';
  }

  @override
  String get acIMissing => 'Mi mancano';

  @override
  String get acSecret => 'Traguardo segreto';

  @override
  String get acSecretDesc => 'Si scopre solo quando lo raggiungi.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Raggiunto$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' il $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return 'Livello $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'Ora sei $titulo. Hai $hechos traguardi su $total.';
  }

  @override
  String get acOk => 'Va bene';

  @override
  String get acSeeAchievements => 'Vedi i traguardi';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 Traguardo! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (e altri $n)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Per quelli di espansione serve il database delle carte ($error)';
  }

  @override
  String get ceWhoseName => 'A nome di chi?';

  @override
  String get ceCollectorName => 'Il tuo nome da collezionista';

  @override
  String get ceInNameOf => 'A nome di…';

  @override
  String get ceEmptyWithData =>
      'Non hai ancora nessuna espansione completa. Quando ne completi una intera nell\'Album, qui comparirà il tuo certificato da scaricare.';

  @override
  String get ceEmptyNoData =>
      'Per certificare un\'espansione bisogna sapere l\'edizione esatta delle tue carte: reimporta il tuo CSV di ManaBox (porta con sé lo Scryfall ID).';

  @override
  String get ceNothingSaved => 'Non è stato salvato niente.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Certificato salvato in $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'Non è stato possibile salvarlo: $error';
  }

  @override
  String get cePickFirstCard => 'Scegli la carta con cui ho iniziato';

  @override
  String get ceChangeFirstCard => 'Cambia la carta con cui ho iniziato';

  @override
  String get ceDownloadPng => 'Scarica PNG';

  @override
  String get cdNotFound => 'Non trovo questa carta nel database.';

  @override
  String cdLoadFailed(String error) {
    return 'Non sono riuscito a caricare la scheda: $error';
  }

  @override
  String get cdPrev => 'Precedente (←)';

  @override
  String get cdNext => 'Successiva (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Carta non trovata';

  @override
  String cdPaid(
      String total, String divisa, int qty, String copias, String unidad) {
    return 'Hai pagato $total$divisa per $qty $copias ($unidad l\'una)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'copie',
      one: 'copia',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ Hai $n copie nella tua collezione',
      one: '✓ Hai 1 copia nella tua collezione',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'Questa carta non ce l\'hai (per ora).';

  @override
  String cdNoPrice(String mercado) {
    return 'Nessun prezzo per questa carta su $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'VERSIONI ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'nessun prezzo per edizione su $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return 'prezzi $mercado ($moneda) · normale / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'ne hai x$n';
  }

  @override
  String get smMythic => 'Mitica';

  @override
  String get smRare => 'Rara';

  @override
  String get smUncommon => 'Non comune';

  @override
  String get smCommon => 'Comune';

  @override
  String smLoadFailed(String error) {
    return 'Non sono riuscito a caricare il set: $error';
  }

  @override
  String get smSearchInSet => 'Cerca nell\'espansione…';

  @override
  String get smRarityAll => 'Rarità: tutte';

  @override
  String get smPriceDown => 'Prezzo ↓';

  @override
  String get smPriceUp => 'Prezzo ↑';

  @override
  String get smNumber => 'Numero';

  @override
  String get smOnlyMine => 'Solo le mie';

  @override
  String smCardsCount(int n) {
    return '$n carte';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: nessun prezzo per edizione';
  }

  @override
  String smListedValue(String mercado) {
    return 'valore listato ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'Hai pagato $pagado · oggi valgono $hoy';
  }

  @override
  String get pnNoPnl =>
      'Senza prezzo d\'acquisto non c\'è P&L. Importa il tuo CSV di ManaBox con la colonna \"Purchase price\" e compare qui.';

  @override
  String pnOverAll(int n) {
    return 'sulle $n copie della tua collezione';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'su $conprecio copie di $total (le altre non hanno un prezzo d\'acquisto segnato)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '$n copie comprate non hanno un prezzo di oggi nel database: fuori dal conto';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'hai pagato anche $importe $moneda, che non si convertono';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n copie senza valuta nel CSV: si suppongono $moneda';
  }

  @override
  String get pcTitle => 'Andamento del prezzo';

  @override
  String get pcNoHistory =>
      'Ancora nessuno storico del prezzo di questa carta.';

  @override
  String pcTodayPrice(String precio) {
    return 'Prezzo di oggi: $precio €. Il grafico compare appena ci sono più giorni.';
  }

  @override
  String get pcExplain =>
      'ManaForge annota il prezzo di ogni carta che guardi o che hai, giorno per giorno. Per partire con gli ultimi mesi veri di Cardmarket, scarica lo storico da Mercato.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n giorni',
      one: '1 giorno',
    );
    return 'min $min € · max $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'Da quali espansioni?';

  @override
  String get spSearchHint => 'Cerca per nome o codice (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Solo le mie';

  @override
  String spClearN(int n) {
    return 'Togli le $n';
  }

  @override
  String get spNoneNamed =>
      'Nessuna espansione con quel nome. Togli \"Solo le mie\" per vederle tutte.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n carte';
  }

  @override
  String get spNoFilter => 'Nessun filtro di espansione';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Usa $n espansioni',
      one: 'Usa 1 espansione',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'Cerco solo carte del set $set. Toccalo per cambiare o togliere il blocco.';
  }

  @override
  String get slLockHint =>
      'Blocca un set per scansionare una scatola/precon: lo scanner cercherà solo lì dentro e azzecca l\'edizione.';

  @override
  String slSetIs(String set) {
    return 'Set: $set';
  }

  @override
  String get slSetAll => 'Set: tutti';

  @override
  String get slLockTitle => 'Blocca l\'edizione';

  @override
  String get slLockBody =>
      'Scrivi il codice del set (per esempio AER, MH3, LCI) per scansionare una scatola intera: si cercheranno solo carte di quel set.';

  @override
  String get slSetCode => 'Codice del set';

  @override
  String get slClearLock => 'Togli il blocco';

  @override
  String get stHintQuick =>
      'Passa le carte davanti: quelle chiare si segnano da sole qui (le copie uguali si sommano ×N). Quelle dubbie restano segnate da rivedere. Alla fine le confermi tutte.';

  @override
  String get stHintCareful =>
      'Passa le carte davanti: quelle chiare si segnano da sole; quelle dubbie ti chiedono quale carta sia. Alla fine le confermi tutte.';

  @override
  String stAddN(int n) {
    return 'Aggiungi $n alla collezione';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return 'Aggiungi $n alla collezione e a $carpeta';
  }

  @override
  String get stOneLess => 'Una in meno';

  @override
  String get stAnotherSame => 'Un\'altra uguale';

  @override
  String get stOnTable => 'sul tavolo';

  @override
  String cdLastData(String fecha) {
    return ' (ultimo dato: $fecha)';
  }

  @override
  String get cdLegalities => 'Legalità';

  @override
  String get slLockButton => 'Blocca';

  @override
  String get wn030Headline =>
      'Forge per espansioni, prezzo d\'acquisto e avvisi di versione';

  @override
  String get wn030Forge =>
      'Forge: scegli da quali espansioni escono le carte. E se attivi \"includi carte che non ho\", ti monta il mazzo con tutta la collezione scelta e ti dice quante te ne mancano e quanto costano.';

  @override
  String get wn030Pnl =>
      'Prezzo d\'acquisto e P&L: se il tuo CSV di ManaBox porta \"Purchase price\", il Mercato ti dice quanto hai pagato, quanto vale oggi e la differenza. Le valute non si mescolano.';

  @override
  String get wn030PhotoFolder =>
      'Anche scansionando da foto puoi scegliere la cartella, come nello scanner dal vivo.';

  @override
  String get wn030Album =>
      'Album: quello che ti manca di ogni espansione, con quanto costerebbe.';

  @override
  String get wn030Background =>
      'Sfondo: mettici dietro l\'immagine che vuoi, con un velo regolabile, e scegli il colore dei riquadri e del testo perché sopra si continui a leggere.';

  @override
  String get wn030Window =>
      'La finestra si apre dove l\'hai lasciata, della dimensione che le hai dato.';

  @override
  String get wn030Achievements =>
      'I traguardi non si chiamano più come il criterio, si chiamano come il momento: \"Ecco dove finiscono i miei soldi\", \"Cento rare e nemmeno una giocabile\".';

  @override
  String get wn030Update =>
      'L\'app ti avvisa quando c\'è una versione nuova (non si aggiorna da sola) e controlla l\'impronta SHA-256 di ogni database che scarica.';

  @override
  String get wn030Shortcuts =>
      'Scorciatoie da tastiera: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, ed Escape.';

  @override
  String get wn030Linux =>
      'Su Linux, un installer mette ManaForge nel menu delle applicazioni con la sua icona.';

  @override
  String get wn030License =>
      'Licenza PolyForm Noncommercial: condividila e smanettaci quanto vuoi, ma non si vende.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n carte',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mazzi',
      one: '1 mazzo',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartelle',
      one: '1 cartella',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n traguardi',
      one: '1 traguardo',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'copia vuota';

  @override
  String get bkStoreCollection => 'la tua collezione';

  @override
  String get bkStoreFolders => 'le tue cartelle';

  @override
  String get bkStoreDecks => 'i tuoi mazzi';

  @override
  String get bkStoreAchievements => 'i tuoi traguardi';

  @override
  String get bkStoreWishlist => 'la tua lista dei desideri';

  @override
  String get bkStoreCertificates => 'i tuoi certificati';

  @override
  String get bkStoreMarket => 'il tuo mercato preferito';

  @override
  String get bkStoreRecents => 'le carte viste di recente';

  @override
  String get bkStoreValueHistory => 'lo storico del valore';

  @override
  String get bkStorePriceHistory => 'lo storico dei prezzi';

  @override
  String get bkKindAuto => 'automatica';

  @override
  String get bkKindPreRestore => 'prima di ripristinare';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig =>
      'Quel file è decisamente troppo grande per essere una copia di ManaForge.';

  @override
  String get bkErrExpandTooBig =>
      'Quella copia diventa troppo grande una volta aperta: non sembra una vera copia di ManaForge.';

  @override
  String get bkErrNotABackup =>
      'Quel file non è una copia di sicurezza di ManaForge.';

  @override
  String get bkErrNewerVersion =>
      'Quella copia l\'ha fatta una versione più nuova di ManaForge. Aggiorna l\'app e riprova.';

  @override
  String get bkErrIncomplete =>
      'Quella copia è incompleta: non porta i tuoi dati.';

  @override
  String bkErrDamaged(String almacen) {
    return 'Quella copia è danneggiata: $almacen non si riesce a leggere.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'Non sono riuscito a scrivere nella cartella dei dati, quindi non ho toccato niente: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'Il ripristino si è fermato a metà ($escritos file su $total). Non ho una copia precedente di quello che c\'era. Dettaglio: $error';
  }

  @override
  String bkErrHalfDonePrevious(
      String escritos, String total, String ruta, String error) {
    return 'Il ripristino si è fermato a metà ($escritos file su $total). Per tornare indietro, ripristina $ruta. Dettaglio: $error';
  }

  @override
  String get siImportTooBig =>
      'Quel file è decisamente troppo grande per essere una lista di carte.';

  @override
  String get siInsecureDownload =>
      'Il download è finito su un indirizzo non sicuro ed è stato annullato.';

  @override
  String get siRedirectNowhere =>
      'Il download rimanda nel vuoto ed è stato annullato.';

  @override
  String get siTooManyRedirects =>
      'Il download gira troppo in tondo ed è stato annullato.';

  @override
  String get siDownloadTooBig =>
      'Il download è molto più grande di quanto dovrebbe ed è stato annullato.';

  @override
  String get siBadHash =>
      'Quello che è stato scaricato non coincide con l\'impronta pubblicata su GitHub. Non è stato installato niente. Riprova; se continua a succedere, fammelo sapere.';

  @override
  String get siBackgroundNotImage =>
      'Scegli un\'immagine (.jpg, .png o .webp) come sfondo.';

  @override
  String get siBackgroundTooBig =>
      'Quell\'immagine è troppo grande per usarla come sfondo.';

  @override
  String get siScanTooBig => 'Quella foto è troppo grande per riconoscerla.';

  @override
  String get bgImages => 'Immagini';

  @override
  String bgImageFailed(String error) {
    return 'Non sono riuscito a usare quell\'immagine: $error';
  }

  @override
  String get bgLowContrast =>
      'Poca differenza col riquadro: il testo si regolerà da solo per restare leggibile.';

  @override
  String get bgChipColor => 'Colore delle schede';

  @override
  String get bgIconColor => 'Colore delle icone';

  @override
  String get bgUseThis => 'Usa questo';

  @override
  String get bgSaveSwatch => 'Guardar como muestra';

  @override
  String get bgSwatchTip => 'Muestra guardada';

  @override
  String get bgSwatchDeleteTitle => '¿Borrar esta muestra?';

  @override
  String get bgSwatchDeleteBody =>
      'Se quita de tu paleta guardada. Puedes volver a guardarla cuando quieras.';

  @override
  String get camGstreamerMissing =>
      'GStreamer non è installato. Installalo con:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'La fotocamera $dispositivo non dà immagine (gst-launch è uscito con $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'La fotocamera $dispositivo non ha prodotto nemmeno un frame in 6 s.';
  }

  @override
  String get camNoCameras =>
      'Non trovo nessuna fotocamera (/dev/video*). È collegata? Controlla con `lsusb` che il sistema la veda.';

  @override
  String camNoneWorked(String detalle) {
    return 'Nessuna fotocamera ha dato immagine:\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Ripristina';

  @override
  String get fpUnselect => 'Deseleziona';

  @override
  String get stClear => 'Svuota';

  @override
  String get tlRemove => 'Togli';

  @override
  String get tlUnrecognized => 'Non riconosciuta';

  @override
  String get tlNothingAlike =>
      'niente di simile nel database — rifai la foto o toglila';

  @override
  String get tlTapToPick => 'tocca per sceglierla a mano tra le simili';

  @override
  String get tlReview => 'da rivedere';

  @override
  String get lsQuantity => 'Quantità';

  @override
  String get scPhotos => 'Foto';

  @override
  String get ftWhichFolder => 'In quale cartella le vuoi?';

  @override
  String get ftWhichFolderSub =>
      'Nella tua collezione entrano comunque; la cartella è solo un\'etichetta per ritrovarle dopo.';

  @override
  String get ftNone => 'Nessuna';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n carte',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => 'Cartella nuova…';

  @override
  String get ftNewFolder => 'Cartella nuova';

  @override
  String get ftNewFolderHint => 'Scatola del negozio, Da vendere…';

  @override
  String get sgTitle => 'L\'occhio dello scanner';

  @override
  String get sgWhy =>
      'Per riconoscere le carte senza internet mi serve il database delle impronte visive (~12 MB): la firma dell\'arte di ogni illustrazione di Magic. Si scarica una volta sola.';

  @override
  String get sgDownload => 'Scarica il database delle impronte';

  @override
  String get cmFullCard => 'Vedi la scheda completa (prezzi e legalità)';

  @override
  String get cmSwipeHint =>
      'trascina o usa ← → per sfogliare · tocca fuori per chiudere';

  @override
  String get cmTapOutHint => 'tocca fuori per chiudere';

  @override
  String get fcTitle => 'Con quale carta hai iniziato?';

  @override
  String get fcRemove => 'Togli';

  @override
  String get fcSearchHint => 'Cerca nella tua collezione';

  @override
  String get fcNoMatch => 'Non trovo nessuna carta con quello.';

  @override
  String get acNoneWithFilters => 'Qui non c\'è niente con questi filtri.';

  @override
  String get acAll => 'Tutti';

  @override
  String get tsTitle => 'Modalità Test — batti il meta';

  @override
  String get tsIntro =>
      'Scegli contro quale mazzo del meta vuoi giocare. ManaForge costruisce mazzi con LE TUE carte, simula centinaia di partite contro di lui e si tiene quello che vince di più — provando anche cambi di carta uno a uno per affinarlo.';

  @override
  String get tsLoadingMeta => 'Carico il meta…';

  @override
  String get tsLocalPresets => 'Preset locali (senza connessione)';

  @override
  String get tsNoDeckToFace =>
      'Con le carte che hai adesso non riesco a tirare su un mazzo completo da mandargli contro. Aggiungi altre carte e riprova.';

  @override
  String tsSimFailed(String error) {
    return 'Non sono riuscito a simulare: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota del meta';
  }

  @override
  String get tsSimulating =>
      'Simulo partite… (qualche secondo; tutto sul tuo computer)';

  @override
  String tsFindBest(String meta) {
    return 'Trova il mio mazzo migliore contro $meta';
  }

  @override
  String get tsHonesty =>
      'Onestà: la simulazione capisce i colori di mana, i mulligan, l\'evasione (volare, travolgere, tocco letale…), la rimozione a velocità istantanea e le contromagie — ma non il testo completo di ogni carta. La percentuale serve a CONFRONTARE i tuoi mazzi tra loro, non come previsione esatta.';

  @override
  String tsChampion(String meta) {
    return 'Il tuo campione contro $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'di vittorie stimate · $mazos mazzi provati · $partidas partite per mazzo';
  }

  @override
  String get tsNoDominant =>
      'Nessun mazzo della tua collezione domina questo scontro — questo è quello che se la cava meglio. Guarda i suoi punti deboli nel dettaglio.';

  @override
  String get tsSeeDeck => 'Vedi il mazzo completo (e salvalo)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total traguardi · $xp XP per il livello $nivel';
  }

  @override
  String get hsForgeDecks => 'Forgia mazzi';

  @override
  String get hsTestYourself => '⚔ mettiti alla prova';

  @override
  String get bgCustom => 'Su misura';

  @override
  String get bgPickCustom => 'Scegli un colore su misura';

  @override
  String get bgCustomColor => 'Colore su misura';

  @override
  String get bgSampleTab => 'Rosso';

  @override
  String get cfSortRecent => 'Appena aggiunte';

  @override
  String get cfSortAlpha => 'Nome A-Z';

  @override
  String get cfSortCmc => 'Costo';

  @override
  String get cfSortQty => 'Quantità';

  @override
  String get cfSortBy => 'Ordina per';

  @override
  String get cfSort => 'Ordine';

  @override
  String get cfClear => 'Pulisci';

  @override
  String get cfCost => 'Costo';

  @override
  String get cfCostAll => 'Costo: tutti';

  @override
  String cfCostN(String n) {
    return 'Costo $n';
  }

  @override
  String get cfType => 'Tipo';

  @override
  String get cfTypeAll => 'Tipo: tutti';

  @override
  String get cfTypeCreature => 'Creature';

  @override
  String get cfTypeInstant => 'Istantanei';

  @override
  String get cfTypeSorcery => 'Stregonerie';

  @override
  String get cfTypeArtifact => 'Artefatti';

  @override
  String get cfTypeEnchantment => 'Incantesimi';

  @override
  String get cfTypeLand => 'Terre';

  @override
  String get cfPower => 'Forza';

  @override
  String get cfPowerAll => 'Forza: tutte';

  @override
  String cfPowerMin(int n) {
    return 'Forza ≥ $n';
  }

  @override
  String get cfToughness => 'Costituzione';

  @override
  String get cfToughnessAll => 'Costituzione: tutte';

  @override
  String cfToughnessMin(int n) {
    return 'Costituzione ≥ $n';
  }

  @override
  String get cfNoDate => 'senza data';

  @override
  String get cfToday => 'oggi';

  @override
  String get cfYesterday => 'ieri';

  @override
  String cfDaysAgo(int n) {
    return '$n giorni fa';
  }

  @override
  String get pcWeek => 'Settimana';

  @override
  String get pcMonth => 'Mese';

  @override
  String get pcAll => 'Tutto';

  @override
  String get vpTapCorrect => 'Tocca la carta giusta';

  @override
  String get achCopias1 => 'La prima di tante';

  @override
  String get achCopias10 => 'Dovevo comprarne solo una';

  @override
  String get achCopias50 => 'In una mano non ci stanno più';

  @override
  String get achCopias100 => 'Cento e non si ferma';

  @override
  String get achCopias500 => 'La scatola sta diventando piccola';

  @override
  String get achCopias1000 => 'Mille. E le voglio tutte';

  @override
  String get achCopias5000 => 'Ormai è un magazzino';

  @override
  String get achCopias10000 => 'Diecimila, ma io smetto quando voglio';

  @override
  String achCopiasDesc(String n) {
    return 'Avere $n carte nella tua collezione.';
  }

  @override
  String get achDistintas25 => 'Qui c\'è varietà';

  @override
  String get achDistintas100 => 'Cento facce diverse';

  @override
  String get achDistintas500 => 'Mezza biblioteca';

  @override
  String get achDistintas1000 => 'Enciclopedia ambulante';

  @override
  String get achDistintas2500 => 'Non me le ricordo più tutte';

  @override
  String get achDistintas5000 => 'L\'archivio';

  @override
  String achDistintasDesc(String n) {
    return 'Avere $n carte DIVERSE (le ripetute non contano).';
  }

  @override
  String get achPlaysets1 => 'Quattro uguali';

  @override
  String get achPlaysets20 => 'Venti playset, zero mazzi';

  @override
  String get achPlaysets1Desc => 'Avere 4 copie della stessa carta.';

  @override
  String get achPlaysets20Desc =>
      'Avere 20 playset diversi (4 copie di ciascuno).';

  @override
  String get achComunes10 => 'Quelle che non vuole nessuno';

  @override
  String get achComunes50 => 'Il solito mucchio';

  @override
  String get achComunes200 => 'Re del mucchio';

  @override
  String get achComunes500 => 'Una marea di comuni';

  @override
  String achComunesDesc(String n) {
    return 'Avere $n carte comuni diverse.';
  }

  @override
  String get achInfrecuentes10 => 'Un gradino sopra la comune';

  @override
  String get achInfrecuentes50 => 'Argento fino';

  @override
  String get achInfrecuentes200 => 'Cacciatore di non comuni';

  @override
  String get achInfrecuentes500 => 'Argento a palate';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Avere $n carte non comuni diverse.';
  }

  @override
  String get achRaras5 => 'Che bel rumore quando apri la busta';

  @override
  String get achRaras25 => 'Uno scrigno di rare';

  @override
  String get achRaras100 => 'Cento rare e nemmeno una giocabile';

  @override
  String get achRaras300 => 'Camera blindata';

  @override
  String achRarasDesc(String n) {
    return 'Avere $n carte rare diverse.';
  }

  @override
  String get achMiticas1 => 'La mia prima mitica';

  @override
  String get achMiticas10 => 'Dieci mitiche';

  @override
  String get achMiticas50 => 'Collezionista mitico';

  @override
  String get achMiticas150 => 'Pantheon mitico';

  @override
  String achMiticasDesc(String n) {
    return 'Avere $n carte mitiche diverse.';
  }

  @override
  String get achBlancas25 => 'Ordine e disciplina';

  @override
  String get achBlancas100 => 'Esercito d\'argento';

  @override
  String achBlancasDesc(String n) {
    return 'Avere $n carte bianche diverse.';
  }

  @override
  String get achAzules25 => 'Questo non te lo lascio fare';

  @override
  String get achAzules100 => 'Torre d\'avorio';

  @override
  String achAzulesDesc(String n) {
    return 'Avere $n carte blu diverse.';
  }

  @override
  String get achNegras25 => 'Patto oscuro';

  @override
  String get achNegras100 => 'Signore della cripta';

  @override
  String achNegrasDesc(String n) {
    return 'Avere $n carte nere diverse.';
  }

  @override
  String get achRojas25 => 'Diamo fuoco a tutto';

  @override
  String get achRojas100 => 'Incendio generale';

  @override
  String achRojasDesc(String n) {
    return 'Avere $n carte rosse diverse.';
  }

  @override
  String get achVerdes25 => 'Un germoglio';

  @override
  String get achVerdes100 => 'Tutta la foresta';

  @override
  String achVerdesDesc(String n) {
    return 'Avere $n carte verdi diverse.';
  }

  @override
  String get achIncoloras25 => 'Metallo freddo';

  @override
  String get achIncoloras100 => 'Fucina eterna';

  @override
  String achIncolorasDesc(String n) {
    return 'Avere $n carte incolori diverse.';
  }

  @override
  String get achArcoiris => 'Tutti e cinque i colori';

  @override
  String get achArcoirisDesc =>
      'Avere almeno una carta di ognuno dei 5 colori.';

  @override
  String get achMulticolor10 => 'Mescolando i colori';

  @override
  String get achMulticolor50 => 'Alleanza dorata';

  @override
  String achMulticolorDesc(String n) {
    return 'Avere $n carte multicolore diverse.';
  }

  @override
  String get achCincocolores => 'Cinque colori in una botta';

  @override
  String get achCincocoloresDesc =>
      'Avere una carta con tutti e cinque i colori.';

  @override
  String get achSets1 => 'Prima espansione';

  @override
  String get achSets5 => 'Cinque mondi';

  @override
  String get achSets10 => 'Viaggiatore di piani';

  @override
  String get achSets25 => 'Giramondo';

  @override
  String get achSets50 => 'Mezzo multiverso';

  @override
  String achSetsDesc(String n) {
    return 'Avere carte di $n espansioni diverse.';
  }

  @override
  String get achSetscompletos1 => 'Non ne manca nemmeno una';

  @override
  String get achSetscompletos3 => 'Tre album interi';

  @override
  String get achSetscompletos10 => 'Maestro dell\'album';

  @override
  String get achSetscompletos1Desc =>
      'Completare un\'espansione intera nell\'Album.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Completare $n espansioni intere.';
  }

  @override
  String get achAnyos5 => 'Cinque anni di cartone';

  @override
  String get achAnyos15 => 'Macchina del tempo';

  @override
  String achAnyosDesc(String n) {
    return 'Avere carte di $n anni di uscita diversi.';
  }

  @override
  String get achValor10 => 'Primi euro';

  @override
  String get achValor50 => 'Il salvadanaio';

  @override
  String get achValor250 => 'Addio paghetta';

  @override
  String get achValor1000 => 'Ecco dove finiscono i miei soldi';

  @override
  String get achValor5000 => 'Non dirlo a nessuno';

  @override
  String get achValor10000 => 'Vale più della mia macchina';

  @override
  String get achValor25000 => 'Collezione da museo';

  @override
  String achValorDesc(String n) {
    return 'Far arrivare la tua collezione a valere $n € o più.';
  }

  @override
  String get achJoya20 => 'Una carta di quelle buone';

  @override
  String get achJoya100 => 'Il gioiello della collezione';

  @override
  String get achJoya500 => 'Questa dalla bustina non esce';

  @override
  String get achJoya1000 => 'Mille euro in una bustina sola';

  @override
  String get achJoya2500 => 'Il sacro graal';

  @override
  String achJoyaDesc(String n) {
    return 'Avere una singola carta che valga $n € o più.';
  }

  @override
  String get achFoils1 => 'Primo luccichio';

  @override
  String get achFoils10 => 'Bagliori';

  @override
  String get achFoils50 => 'La scatola luccica';

  @override
  String get achFoils200 => 'Qui non c\'è più niente di opaco';

  @override
  String get achFoils500 => 'Brilla tutto';

  @override
  String get achFoils1000 => 'Fabbrica di luccichii';

  @override
  String achFoilsDesc(String n) {
    return 'Avere $n carte foil.';
  }

  @override
  String get achFoiljoya10 => 'Una foil di quelle buone';

  @override
  String get achFoiljoya50 => 'Una foil di quelle care';

  @override
  String get achFoiljoya200 => 'Una foil da museo';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Avere una foil che valga $n € o più.';
  }

  @override
  String get achFoilvalor50 => 'Vetrina che luccica';

  @override
  String get achFoilvalor250 => 'Vetrina costosa';

  @override
  String get achFoilvalor1000 => 'Mille euro di luccichio';

  @override
  String get achFoilvalor5000 => 'Vetrina da museo';

  @override
  String achFoilvalorDesc(String n) {
    return 'Far arrivare tutte le tue foil insieme a valere $n € o più.';
  }

  @override
  String get achMazos1 => 'Primo mazzo';

  @override
  String get achMazos5 => 'Cinque mazzi salvati';

  @override
  String get achMazos25 => 'L\'officina non si ferma';

  @override
  String achMazosDesc(String n) {
    return 'Salvare $n mazzi fatti con Forge.';
  }

  @override
  String get achMazoscore => 'Mazzo che gira';

  @override
  String get achMazoscoreDesc => 'Generare un mazzo con punteggio 90 o più.';

  @override
  String get achMazocolores3 => 'Tricolore';

  @override
  String get achMazocolores5 => 'Arcobaleno giocabile';

  @override
  String achMazocoloresDesc(String n) {
    return 'Salvare un mazzo da $n colori.';
  }

  @override
  String get achMazomono => 'Senza mescolare niente';

  @override
  String get achMazomonoDesc => 'Salvare un mazzo di un solo colore.';

  @override
  String get achMazocommander => 'Al comando';

  @override
  String get achMazocommanderDesc => 'Salvare un mazzo Commander.';

  @override
  String get achEscaneadas1 => 'Prima scansione';

  @override
  String get achEscaneadas50 => 'Mano veloce';

  @override
  String get achEscaneadas500 => 'Scansioni in serie';

  @override
  String get achEscaneadas2000 => 'Scansiono anche nel sonno';

  @override
  String achEscaneadasDesc(String n) {
    return 'Scansionare $n carte con la fotocamera o da foto.';
  }

  @override
  String get achFoto9 => 'Una pagina intera in una foto';

  @override
  String get achFoto20 => 'Venti in un colpo solo';

  @override
  String achFotoDesc(String n) {
    return 'Riconoscere $n carte in una sola foto.';
  }

  @override
  String get achEscaneoperfecto => 'Nemmeno una da rivedere';

  @override
  String get achEscaneoperfectoDesc =>
      'Scansionare una pagina intera senza lasciare nemmeno una carta da rivedere.';

  @override
  String get achDias2 => 'Sei tornato';

  @override
  String get achDias7 => 'Una settimana qui';

  @override
  String get achDias30 => 'Un mese qui';

  @override
  String get achDias100 => 'Cento giorni qui';

  @override
  String achDiasDesc(String n) {
    return 'Usare ManaForge in $n giorni diversi.';
  }

  @override
  String get achRacha3 => 'Tre di fila';

  @override
  String get achRacha7 => 'Settimana perfetta';

  @override
  String get achRacha30 => 'Un mese senza saltare un giorno';

  @override
  String achRachaDesc(String n) {
    return 'Entrare $n giorni di fila.';
  }

  @override
  String get achSemanas => 'Quattro settimane senza mancare';

  @override
  String get achSemanasDesc => 'Usare ManaForge per 4 settimane di fila.';

  @override
  String get achCarpetas1 => 'Comincia l\'ordine';

  @override
  String get achCarpetas5 => 'Tutto catalogato';

  @override
  String achCarpetasDesc(String n) {
    return 'Creare $n cartelle.';
  }

  @override
  String get achCarpetagrande => 'Cartella formato famiglia';

  @override
  String get achCarpetagrandeDesc => 'Avere una cartella con 100 carte o più.';

  @override
  String get achCarpetavalor => 'Questa cartella non te la presto';

  @override
  String get achCarpetavalorDesc => 'Avere una cartella che valga 100 € o più.';

  @override
  String get achTierrasbasicas => 'Le cinque base';

  @override
  String get achTierrasbasicasDesc =>
      'Avere tutti e cinque i tipi di terra base (Pianura, Isola, Palude, Montagna e Foresta).';

  @override
  String get achFuerza => 'Che bestione';

  @override
  String get achFuerzaDesc => 'Avere una creatura con forza 10 o più.';

  @override
  String get achCoste => 'Questa non la lancio mai nella vita';

  @override
  String get achCosteDesc =>
      'Avere una carta con costo di mana convertito 10 o più.';

  @override
  String get achCostecero => 'Gratis';

  @override
  String get achCosteceroDesc => 'Avere una carta con costo 0.';

  @override
  String get achTipos => 'Un po\' di tutto';

  @override
  String get achTiposDesc =>
      'Avere almeno una creatura, un istantaneo, una stregoneria, un artefatto, un incantesimo, una terra e un planeswalker.';

  @override
  String get achPlaneswalkers => 'Compagnia di planeswalker';

  @override
  String get achPlaneswalkersDesc => 'Avere 5 planeswalker diversi.';

  @override
  String get achNoventas => 'Reliquia degli anni 90';

  @override
  String get achNoventasDesc => 'Avere una carta degli anni 90.';

  @override
  String get achIdiomas1 => 'Questa non la so leggere';

  @override
  String get achIdiomas25 => 'Collezione poliglotta';

  @override
  String get achIdiomas1Desc =>
      'Avere una carta in una lingua diversa dall\'inglese.';

  @override
  String get achIdiomas25Desc => 'Avere 25 carte in altre lingue.';

  @override
  String get achWishlist => 'La lista degli sfizi';

  @override
  String get achWishlistDesc => 'Segnare 20 carte nella wishlist.';

  @override
  String get achTierBronze => 'Bronzo';

  @override
  String get achTierSilver => 'Argento';

  @override
  String get achTierGold => 'Oro';

  @override
  String get achTierMythic => 'Mitico';

  @override
  String get achCatCollection => 'Collezione';

  @override
  String get achCatRarity => 'Rarità';

  @override
  String get achCatColor => 'Colori';

  @override
  String get achCatSets => 'Espansioni';

  @override
  String get achCatValue => 'Valore';

  @override
  String get achCatFoils => 'Foil';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Scanner';

  @override
  String get achCatDedication => 'Dedizione';

  @override
  String get achCatFolders => 'Cartelle';

  @override
  String get achCatCuriosities => 'Curiosità';

  @override
  String get achRankApprentice => 'Apprendista';

  @override
  String get achRankSummoner => 'Evocatore';

  @override
  String get achRankMage => 'Mago';

  @override
  String get achRankArchmage => 'Arcimago';

  @override
  String get achRankMaster => 'Maestro';

  @override
  String get achRankPlaneswalker => 'Planeswalker';

  @override
  String get bkConfirmWord => 'CONFERMA';

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
    return 'Non è stato possibile scaricare il database delle carte (HTTP $codigo). Riprova tra un po\'.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'Non è stato possibile scaricare il database delle impronte (HTTP $codigo). Riprova tra un po\'.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'Non è stato possibile scaricare lo storico dei prezzi (HTTP $codigo). Riprova tra un po\'.';
  }

  @override
  String ddCardCount(int n) {
    return '$n carte';
  }

  @override
  String get ddForgedWith => 'Forgiato con ManaForge';

  @override
  String get fxThemeLifegain => 'drenaggio vitale';

  @override
  String get fxThemeSacrifice => 'sacrificio';

  @override
  String get fxThemeSpells => 'magie';

  @override
  String get fxThemeArtifacts => 'artefatti';

  @override
  String get fxThemeCounters => 'segnalini +1/+1';

  @override
  String get fxThemeTokens => 'sciame';

  @override
  String get fxThemeGraveyard => 'cimitero';

  @override
  String get fxThemeReanimator => 'rianimazione';

  @override
  String fxThemeTribal(String tribe) {
    return 'tribù $tribe';
  }

  @override
  String get fxThemeGoodstuff => 'il meglio delle tue carte';

  @override
  String get fxTagLifegain =>
      'Ogni punto vita che guadagni è danno per loro: drena e reggi.';

  @override
  String get fxTagSacrifice =>
      'Le tue creature valgono di più da morte: sacrificale e incassa il pedaggio.';

  @override
  String get fxTagSpells =>
      'Ogni istantaneo conta: gioca nel turno dell\'avversario e punisci.';

  @override
  String get fxTagArtifacts =>
      'Monta la tua officina: ogni artefatto rende più forti gli altri.';

  @override
  String get fxTagCounters =>
      'Segnalini +1/+1: le tue creature crescono fino a diventare irraggiungibili.';

  @override
  String get fxTagTokens =>
      'Riempi il campo di pedine: dove loro ne hanno una, tu ne hai cinque.';

  @override
  String get fxTagGraveyard =>
      'Il cimitero è la tua seconda mano: riempilo e ricicla il meglio.';

  @override
  String get fxTagAggro =>
      'Esci veloce e picchia in faccia: la partita dovrebbe finire presto.';

  @override
  String get fxTagTempo =>
      'Premi subito e proteggi il vantaggio con le tue magie.';

  @override
  String fxTagMidrange(String tema) {
    return 'Scambia bene le tue carte e vinci il medio gioco con $tema.';
  }

  @override
  String get fxTagControl =>
      'Reggi, rispondi a tutto e chiudi quando il campo è tuo.';

  @override
  String get fxMidLifegain =>
      'Concatena le tue fonti di vita con le carte che li puniscono per questo.';

  @override
  String get fxMidSacrifice =>
      'Sacrifica la roba che costa poco per pescare, drenare o far crescere il resto.';

  @override
  String get fxMidSpells =>
      'Tieni mana aperto: le tue creature crescono a ogni magia che lanci.';

  @override
  String get fxMidArtifacts =>
      'Cala artefatti economici e accendi quelli che li contano.';

  @override
  String get fxMidCounters =>
      'Ammucchia segnalini su una o due creature e proteggile.';

  @override
  String get fxMidTokens =>
      'Genera pedine ogni turno e cerca gli effetti che le ingrossano.';

  @override
  String get fxMidGraveyard =>
      'Macina e scarta apposta: quello che finisce nel cimitero torna.';

  @override
  String get fxEndLifegain =>
      'Con i punti vita alti, passa in modalità aggressiva: loro non ci arrivano più.';

  @override
  String get fxEndSacrifice =>
      'Il valore accumulato ti dà la partita: ogni scambio ti esce gratis.';

  @override
  String get fxEndSpells =>
      'Un paio di magie nello stesso turno e le tue creature chiudono.';

  @override
  String get fxEndArtifacts =>
      'Il tuo campo vale il doppio del suo: chiudi con i tuoi payoff.';

  @override
  String get fxEndCounters =>
      'Una minaccia enorme e protetta finisce la partita in due colpi.';

  @override
  String get fxEndTokens =>
      'Attacca in massa: nessun blocco regge tutto il tuo esercito.';

  @override
  String get fxEndGraveyard =>
      'Riusa le tue carte migliori: giochi con due mani contro una.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => 'Gioca una creatura ogni turno, senza eccezioni.';

  @override
  String get fxAggroMid =>
      'Continua ad attaccare; tieni il danno diretto per togliere i bloccanti.';

  @override
  String get fxAggroLate => 'Vai con tutto: qui dovresti chiudere la partita.';

  @override
  String get fxTempoEarly =>
      'Una minaccia economica e mana aperto quando puoi.';

  @override
  String get fxTempoMid =>
      'Attacca e usa le tue magie nel turno dell\'avversario.';

  @override
  String get fxTempoLate =>
      'Proteggi le tue creature e chiudi per via aerea o col danno diretto.';

  @override
  String get fxMidrangeEarly =>
      'Sviluppa e non regalare carte: scambi uno-a-uno buoni.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Cala i tuoi motori di $tema e stabilizza il campo.';
  }

  @override
  String get fxMidrangeLate =>
      'Le tue carte valgono più delle sue: trasformalo nella partita.';

  @override
  String get fxControlEarly =>
      'Una terra a turno e rispondi solo a quello che conta.';

  @override
  String get fxControlMid =>
      'Pulisci il campo e pesca carte: il tempo gioca per te.';

  @override
  String get fxControlLate => 'Cala una minaccia e proteggila fino alla fine.';

  @override
  String get fxArchetypeAggro => 'aggro';

  @override
  String get fxArchetypeTempo => 'tempo';

  @override
  String get fxArchetypeMidrange => 'midrange';

  @override
  String get fxArchetypeControl => 'control';

  @override
  String fxWhyItWorks(String coste, String tierras, String arquetipo,
      int criaturas, int interaccion, String tema) {
    return 'Costo medio $coste: per la regola di Karsten (24 terre a costo 3.0, ±1 per ogni ±0.5), questo mazzo porta $tierras terre — dentro il range di un mazzo $arquetipo. Ci sono $criaturas creature per tenere il campo e $interaccion carte di interazione per quello che tira fuori l\'avversario. Il tema ($tema) concentra le tue sinergie: più pezzi del tema vedi, più forte diventa ognuno.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'Con quella curva escono $tierras terre: fuori dall\'intervallo sano ($min-$max). Aggiusta il totale delle magie.';
  }

  @override
  String get fxNoCards =>
      'La tua collezione non ha abbastanza carte di questi colori per riempire quella curva. Prova con meno magie, o con costi diversi.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'Quella curva (costo medio $coste con $tierras terre) non rientra in nessun profilo sano: un mazzo economico vuole meno terre e uno caro ne vuole di più. Avvicinali.';
  }

  @override
  String get fxNoBasics =>
      'Nella collezione non ci sono abbastanza terre base per quella curva.';

  @override
  String fxHardRule(String detalle) {
    return 'La curva che hai chiesto rompe una regola dura: $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Creature economiche e danno in faccia: ti ammazza in 4-5 turni se non reggi il ritmo.';

  @override
  String get tsPresetAzorius =>
      'Contromagie, rimozioni di massa e pescata: allunga la partita e vince con pochi finisher.';

  @override
  String get tsPresetGolgari =>
      'Scambi uno-a-uno, creature efficienti e rimozione nera: vince il gioco lungo per qualità delle carte.';
}
