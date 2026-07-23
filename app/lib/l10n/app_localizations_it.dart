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

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 ¡$carta está a $precio (tu objetivo: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 ¡$n cartas de tu wishlist han caído a su precio objetivo!';
  }

  @override
  String get mkTellMeWhenDrops => 'Avísame cuando baje';

  @override
  String get mkTargetPrice => 'Precio objetivo';

  @override
  String mkNow(String precio) {
    return 'Ahora: $precio';
  }

  @override
  String get mkUpdated => '✓ Precios y cartas actualizados';

  @override
  String mkUpdateFailed(String error) {
    return 'No pude actualizar: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Histórico de precios listo: las gráficas ya enseñan los últimos meses';

  @override
  String mkHistoryFailed(String error) {
    return 'No pude traer el histórico (el que ya tenías sigue intacto): $error';
  }

  @override
  String get mkHistoryLocal =>
      'Histórico de precios: solo el que ManaForge apunta a diario en tu equipo. Tráete los últimos ~90 días reales de Cardmarket (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Histórico real de Cardmarket del $desde al $hasta, y desde ahí lo que apunta ManaForge.';
  }

  @override
  String get mkFetchHistory => 'Traer histórico';

  @override
  String get mkCollectionValue => 'Valor de tu colección · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n cartas';
  }

  @override
  String get mkApproxSuffix => ' · valor orientativo';

  @override
  String mkBulkPrices(String fecha) {
    return 'Precios Cardmarket del $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Mercado sin datos: descarga la base de datos en Colección. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'EXPANSIONES ($n)';
  }

  @override
  String get mkPrevious => 'Anteriores';

  @override
  String get mkNext => 'Siguientes';

  @override
  String get mkSearchHint => 'Busca el precio de cualquier carta…';

  @override
  String get mkRemoveFromWishlist => 'Quitar de la wishlist';

  @override
  String get mkAddToWishlist => 'A la wishlist: avísame cuando baje';

  @override
  String get mkYourWishlist => 'TU WISHLIST';

  @override
  String mkTargetAtMost(String precio) {
    return 'objetivo ≤ $precio';
  }

  @override
  String get mkAtPrice => '¡a precio!';

  @override
  String get mkChangeTarget => 'Cambiar precio objetivo';

  @override
  String get mkTopCards => 'TUS CARTAS MÁS VALIOSAS';

  @override
  String get mkImportToSeeValue => 'Importa tu colección para ver su valor.';

  @override
  String mkSetCards(int n) {
    return ' · $n cartas';
  }

  @override
  String get wlEmpty =>
      'Búscalas en Mercado y toca el marcador para que te avise cuando bajen a tu precio.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '🔔 $n cartas de tu wishlist están a tu precio objetivo o por debajo.',
      one: '🔔 1 carta de tu wishlist está a tu precio objetivo o por debajo.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'Precios de MTGO en tix (cartas digitales)';

  @override
  String get mpNoDataYet =>
      'Sin datos todavía: actualiza el histórico de precios en Mercado';

  @override
  String get mpMtgoNote =>
      'Precios de MTGO en tix: son cartas digitales, no valen para tasar tu colección de papel. Inicio, carpetas y logros siguen en Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return 'Precios de $mercado en $moneda. Inicio, carpetas y logros siguen valorando en Cardmarket (€): las divisas no se convierten.';
  }

  @override
  String get mkUpdate => 'Actualizar';

  @override
  String get mkApproxValue =>
      ' · valor aproximado (reimporta con \"Sustituir\" para precios por edición)';

  @override
  String get mkExactPrintings => ' · por tus ediciones exactas';

  @override
  String mkNowSuffix(String precio) {
    return ' · ahora $precio';
  }

  @override
  String get wlNothingYet => 'Aún no tienes cartas en la wishlist.';

  @override
  String get stDbUpdated => '✓ Base de datos actualizada';

  @override
  String stUpdateFailed(String error) {
    return 'No se pudo actualizar: $error';
  }

  @override
  String get stCardDb => 'Base de datos de cartas';

  @override
  String get stCardDbWhy =>
      'Vuelve a descargarla para tener cartas nuevas, precios frescos y las funciones que piden datos recientes (como el filtro por año en Forge).';

  @override
  String get stDownloadDbAgain => 'Volver a descargar la base de datos';

  @override
  String get stAppearance => 'Apariencia';

  @override
  String get stData => 'Datos';

  @override
  String get stTheApp => 'La app';

  @override
  String get stCredits =>
      'Datos e imágenes de cartas por Scryfall. Magic: The Gathering es propiedad de Wizards of the Coast; proyecto de fans al amparo de su Fan Content Policy.';

  @override
  String get stEditHome => 'Editar inicio';

  @override
  String get stEditHomeSub => 'Elige qué secciones se ven y en qué orden';

  @override
  String get ehLevel => 'Tu nivel';

  @override
  String get ehShortcuts => 'Accesos rápidos';

  @override
  String get ehSummary => 'Resumen de la colección';

  @override
  String get ehRecent => 'Vistas recientemente';

  @override
  String get ehDecks => 'Tus mazos';

  @override
  String get ehMeta => 'El meta ahora';

  @override
  String get ehNewSets => 'Expansiones nuevas';

  @override
  String get ehGems => 'Tus joyas';

  @override
  String get ehHelp =>
      'Arrastra para ordenar y usa el interruptor para elegir qué ves en Inicio. Una sección encendida solo sale si tiene algo que enseñar.';

  @override
  String get ehSection => 'Sección';

  @override
  String get bkNoData => 'No encuentro tus datos.';

  @override
  String bkSaved(String resumen) {
    return '✓ Copia guardada · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'No he podido guardarla: $error';
  }

  @override
  String get bkFileName => 'Copia de ManaForge';

  @override
  String bkRestoreFailed(String error) {
    return 'No he podido restaurarla: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Restaurado · $resumen. OJO: no he podido guardar lo que tenías antes ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Restaurado · $resumen. Lo que tenías antes está guardado en la carpeta backups.';
  }

  @override
  String get bkRestoring => 'Restaurando tu copia…';

  @override
  String get bkTitle => 'Copia de seguridad';

  @override
  String get bkWhy =>
      'Tus cartas, mazos, carpetas y logros viven solo en este ordenador. Guarda una copia de vez en cuando y déjala en otro sitio: un disco, la nube, lo que quieras.';

  @override
  String get bkSave => 'Guardar copia';

  @override
  String get bkRestoreTitle => 'Restaurar una copia';

  @override
  String get bkRestoreWarning =>
      'Restaurar REEMPLAZA tus cartas, mazos, carpetas y logros de ahora por los de la copia. Elige cuál, dale al botón y escribe CONFIRMAR: así no se restaura nada sin querer.';

  @override
  String get bkNoBackups => 'Aún no hay copias guardadas en este ordenador.';

  @override
  String get bkWhich => 'Copia a restaurar';

  @override
  String get bkPickOne => 'Elige una copia';

  @override
  String get bkRestorePicked => 'Restaurar la copia elegida';

  @override
  String get bkAutoNote =>
      'Guardo una copia automática cada semana (las cinco últimas) y otra justo antes de cada restaurar.';

  @override
  String get bkFromFile => 'Restaurar de un archivo';

  @override
  String get bkConfirmTitle => '¿Restaurar esta copia?';

  @override
  String get bkConfirmBody =>
      'Esto reemplaza tu colección, mazos, carpetas y logros de ahora por los de esa copia. Antes de hacerlo guardo lo que tienes en la carpeta backups, por si quieres volver.';

  @override
  String bkWillDelete(String cosas) {
    return 'Esa copia no trae $cosas: al restaurarla, eso se borra.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Escribe $palabra para poder seguir:';
  }

  @override
  String get bkAnd => ' y ';

  @override
  String get ehReset => 'Restablecer';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Copia del $cuando · $resumen.';
  }
}
