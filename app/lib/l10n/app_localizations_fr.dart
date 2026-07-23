// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabCollection => 'Collection';

  @override
  String get tabAlbum => 'Album';

  @override
  String get tabDecks => 'Decks';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'Marché';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get tabScan => 'Scanner';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsIntro =>
      'ManaForge est gratuite et son code est ouvert (licence PolyForm Noncommercial : partagez-la et bidouillez-la autant que vous voulez, mais elle ne se vend pas). Sans pub, sans premium, sans comptes. Vos cartes sont à vous.';

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get howScan =>
      'Passez des cartes devant la webcam ou déposez une photo : elles entrent dans votre collection avec la bonne édition.';

  @override
  String get howCollection =>
      'Tout ce que vous avez, avec recherche, filtres et dossiers (les dossiers sont des étiquettes : une carte peut être dans plusieurs).';

  @override
  String get howAlbum =>
      'Une page par édition, comme un album de vignettes : ce que vous avez en couleur, ce qui manque en grisé, et ce que coûterait de la compléter.';

  @override
  String get howForge =>
      'Des decks complets et légaux avec vos cartes. Ou avec celles d\'une édition que vous n\'avez pas encore, en vous disant quoi acheter et combien ça coûte.';

  @override
  String get howDecks =>
      'Ceux que vous enregistrez. Si vous vendez une carte, le deck le dit au lieu de faire semblant que vous l\'avez encore.';

  @override
  String get howMarket =>
      'Ce que vaut votre collection, sa courbe, votre liste d\'envies avec alertes de prix — et, si votre CSV avait les prix d\'achat, combien vous gagnez ou perdez.';

  @override
  String get howPrivacy =>
      'Tout est calculé sur votre appareil. Les seules choses qui passent par internet sont les bases de données et, si vous le laissez activé, la vérification d\'une nouvelle version.';

  @override
  String get shortcuts => 'Raccourcis clavier';

  @override
  String get shortcutTabs => 'Changer d\'onglet';

  @override
  String get shortcutScan => 'Ouvrir le scanner';

  @override
  String get shortcutSearch => 'Chercher dans l\'onglet affiché';

  @override
  String get shortcutSettings => 'Réglages';

  @override
  String get shortcutClose => 'Fermer ce qui est ouvert par-dessus';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Comme le système';

  @override
  String get languagePartial =>
      'L\'app est traduite par étapes : la structure est déjà dans votre langue, les autres écrans restent en espagnol pour l\'instant.';

  @override
  String get versionTitle => 'Version de ManaForge';

  @override
  String versionYouHave(String version) {
    return 'Vous avez la $version.';
  }

  @override
  String get versionSeeWhatsNew => 'Voir ce qu\'elle apporte';

  @override
  String get versionNotifyMe => 'Me prévenir des nouvelles versions';

  @override
  String get versionNotifyMeWhy =>
      'Demande une fois par jour à GitHub quelle est la dernière version. Ne télécharge et n\'installe rien.';

  @override
  String get versionCheckNow => 'Chercher maintenant';

  @override
  String get versionUpToDate =>
      'Vous êtes à jour (ou GitHub ne répond pas pour l\'instant).';

  @override
  String versionThereIs(String version) {
    return 'ManaForge $version est sortie.';
  }

  @override
  String get versionGoDownload => 'Aller au téléchargement';

  @override
  String versionNotAuto(String version) {
    return 'Vous avez la $version. L\'app ne se met pas à jour toute seule : elle vous emmène au téléchargement.';
  }

  @override
  String get versionNotNow => 'Pas maintenant';

  @override
  String get versionSee => 'Voir';

  @override
  String whatsNewTitle(String version) {
    return 'Nouveautés de la $version';
  }

  @override
  String get whatsNewClose => 'On joue';

  @override
  String get downloadCopyLink => 'Copier le lien';

  @override
  String get downloadClose => 'Fermer';

  @override
  String get downloadTitle => 'Télécharger ManaForge';

  @override
  String get backgroundTitle => 'Fond d\'écran';

  @override
  String get backgroundWhat =>
      'Mettez l\'image que vous voulez derrière l\'app. Wizards publie des fonds d\'écran officiels pour chaque édition : téléchargez celui qui vous plaît et choisissez-le ici. L\'app ne les télécharge pas toute seule — cet art a un propriétaire, et le distribuer n\'est pas son rôle.';

  @override
  String get backgroundPick => 'Choisir une image…';

  @override
  String get backgroundChange => 'Changer d\'image…';

  @override
  String get backgroundOfficial => 'Fonds d\'écran officiels Magic';

  @override
  String get backgroundRemove => 'Enlever le fond';

  @override
  String get backgroundDim =>
      'Assombrissement (pour que le texte reste lisible)';

  @override
  String get backgroundCardColor => 'Couleur des cartes';

  @override
  String get backgroundTextColor => 'Couleur du texte';

  @override
  String get backgroundCardOpacity =>
      'À quel point les cartes masquent le fond';

  @override
  String get backgroundColorDefault => 'Celle d\'origine';

  @override
  String get backgroundPreview => 'Aperçu';

  @override
  String get backgroundNotAnImage =>
      'Choisissez une image (.jpg, .png ou .webp) comme fond.';

  @override
  String get backgroundTooBig =>
      'Cette image est trop grande pour servir de fond.';

  @override
  String get welcomeTitle =>
      'Bienvenue à la forge. Faites entrer vos cartes comme vous voulez — ou essayez Forge avant d\'en ajouter une seule.';

  @override
  String get welcomeScan => 'Scanner mes cartes';

  @override
  String get welcomeImport => 'Importer un CSV (ManaBox)';

  @override
  String get welcomeTryForge => 'Essayer Forge sans collection';

  @override
  String get decksEmptyGoForge => 'Aller à Forge';

  @override
  String get yourCollection => 'Votre collection';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies cartes · $distinct différentes';
  }

  @override
  String get marketArrow => 'Marché ›';

  @override
  String get certHeadingSetComplete => 'CERTIFICAT DE COLLECTION COMPLÈTE';

  @override
  String get certSubtitleSetComplete => 'Extension complète';

  @override
  String get certHeadingWelcome => 'CERTIFICAT DE BIENVENUE';

  @override
  String get certWelcomeTitle => 'Bienvenue dans le monde de Magic';

  @override
  String get certSubtitleWelcome => 'Ta première carte';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes',
      one: '1 carte',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return 'J\'ai commencé avec $name';
  }

  @override
  String get certCollectorAnon => 'Collectionneur ManaForge';

  @override
  String certAwardedTo(String name) {
    return 'Décerné à $name';
  }

  @override
  String certOnDate(String date) {
    return 'le $date';
  }

  @override
  String get certDataBy => 'Données par Scryfall';

  @override
  String get onbCollectionTitle => 'Ta collection';

  @override
  String get onbCollectionBody =>
      'Toutes tes cartes sont ici, en dossiers et par extension.';

  @override
  String get onbScanTitle => 'Scanner des cartes';

  @override
  String get onbScanBody =>
      'Ajoute de nouvelles cartes avec l\'appareil photo ou une photo.';

  @override
  String get onbForgeTitle => 'Forger des decks';

  @override
  String get onbForgeBody =>
      'Crée des decks complets avec les cartes que tu possèdes.';

  @override
  String get onbDecksTitle => 'Tes decks';

  @override
  String get onbDecksBody =>
      'Les decks enregistrés depuis Forge apparaissent ici.';

  @override
  String get onbSkip => 'Passer';

  @override
  String get onbNext => 'Suivant';

  @override
  String get onbGotIt => 'Compris';

  @override
  String get onbBack => 'Retour';

  @override
  String get tourMenuTitle => 'Guides';

  @override
  String get tourWelcomeName => 'Tour rapide';

  @override
  String get tourHomeName => 'L\'écran d\'accueil';

  @override
  String get onbEditHomeTitle => 'Personnalise ton accueil';

  @override
  String get onbEditHomeBody =>
      'Ce bouton te laisse choisir quelles sections apparaissent sur l\'accueil et dans quel ordre.';

  @override
  String get onbLangTitle => 'Langue';

  @override
  String get onbLangBody => 'Change ici la langue de toute l\'app.';

  @override
  String get onbLookTitle => 'Apparence';

  @override
  String get onbLookBody =>
      'Mets un fond d\'écran et choisis les couleurs des cartes, du texte, des onglets et des icônes.';

  @override
  String get tourSettingsName => 'Personnaliser l\'app';

  @override
  String get tourFullName => 'Tour complet de l\'app';

  @override
  String get tourCollectionName => 'Ta collection et les dossiers';

  @override
  String get tourForgeName => 'Forger un deck';

  @override
  String get tourMarketName => 'Marché, wishlist et alertes';

  @override
  String get onbAllCardsTitle => 'Toutes les cartes';

  @override
  String get onbAllCardsBody =>
      'Toute ta collection : chercher, filtrer et trier.';

  @override
  String get onbFoldersTitle => 'Dossiers';

  @override
  String get onbFoldersBody =>
      'Les dossiers sont des étiquettes : regroupe ce que tu veux, une carte peut être dans plusieurs. « Nouveau » crée le premier.';

  @override
  String get onbAlbumMineTitle => 'L\'album par extensions';

  @override
  String get onbAlbumMineBody =>
      'Chaque extension avec ses cases. Ce filtre n\'affiche que les extensions où tu as déjà des cartes.';

  @override
  String get onbForgeBasicsTitle => 'Terrains de base';

  @override
  String get onbForgeBasicsBody =>
      'Si tu as des terrains de base qui traînent, laisse activé : Forge compte dessus. Désactive pour n\'utiliser que ceux de ta collection.';

  @override
  String get onbForgeSetsTitle => 'Extensions';

  @override
  String get onbForgeSetsBody =>
      'Limite d\'où viennent les cartes. Sans sélection, Forge utilise toute ta collection.';

  @override
  String get onbForgeMissingTitle => 'Cartes que tu n\'as pas';

  @override
  String get onbForgeMissingBody =>
      'Activé, Forge propose aussi des cartes qui te manquent, et te dit combien et à quel prix.';

  @override
  String get onbForgeGoTitle => 'Forger';

  @override
  String get onbForgeGoBody =>
      'Ce bouton fabrique les decks. Avec beaucoup d\'extensions, ça prend quelques secondes.';

  @override
  String get onbForgeTestTitle => 'Mode Test';

  @override
  String get onbForgeTestBody =>
      'Confronte ton deck à un deck du meta et vois ce qu\'il lui manque pour gagner.';

  @override
  String get onbMarketPickTitle => 'Choisir le marché';

  @override
  String get onbMarketPickBody =>
      'Cardmarket ou TCGplayer : ça change le prix de chaque carte et sa courbe.';

  @override
  String get onbWishlistTitle => 'Wishlist';

  @override
  String get onbWishlistBody =>
      'Les cartes que tu veux. Le compteur passe au vert quand l\'une atteint ton prix.';

  @override
  String get onbPriceAlertTitle => 'Alerte de prix';

  @override
  String get onbPriceAlertBody =>
      'Cherche une carte, touche le marque-page pour l\'ajouter à la wishlist et fixe un prix cible : l\'app te prévient quand il baisse.';

  @override
  String get tourProgressName => 'Succès et certificats';

  @override
  String get onbAchievementsTitle => 'Succès et niveau';

  @override
  String get onbAchievementsBody =>
      'Ton niveau et tout ce que tu as gagné. Il monte en scannant, en rangeant et en forgeant.';

  @override
  String get onbCertificatesTitle => 'Certificats';

  @override
  String get onbCertificatesBody =>
      'Les gros jalons donnent un diplôme que tu peux enregistrer en PDF ou montrer. Ils sont dans les succès.';

  @override
  String get onbBackupTitle => 'Sauvegarde';

  @override
  String get onbBackupBody =>
      'Enregistre ta collection, tes decks et tes dossiers dans un fichier, et récupère-les si tu changes d\'ordinateur. Une sauvegarde automatique se fait aussi chaque semaine.';

  @override
  String onbTapHere(String pantalla) {
    return 'Touche ici pour ouvrir $pantalla.';
  }

  @override
  String get onbAchievementsName => 'Succès';

  @override
  String get onbDataSectionTitle => 'Données';

  @override
  String get onbDataSectionBody =>
      'Tout ce que l\'app garde est ici : la base de cartes et tes sauvegardes.';

  @override
  String get onbCardDbTitle => 'Base de cartes';

  @override
  String get onbCardDbBody =>
      'Retélécharge-la pour avoir les nouvelles cartes, des prix frais et ce qui demande des données récentes, comme le filtre par année de Forge.';

  @override
  String get onbAboutTitle => 'L\'app';

  @override
  String get onbAboutBody =>
      'Ce que fait chaque onglet, les raccourcis clavier, la version et la licence.';

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
