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
  String get onbForgeDeepTitle => 'Forge profonde';

  @override
  String get onbForgeDeepBody =>
      'Avant de te montrer les propositions, il les fait vraiment s\'affronter : le classement final pèse leurs vraies performances, pas seulement leur score statique. Désactive-le si tu préfères des résultats plus rapides.';

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
  String get colStartHere => 'Ta collection commence ici';

  @override
  String get colNeedDb =>
      'Il me faut d\'abord la base de données avec toutes les cartes Magic (elle se télécharge une seule fois et ensuite tout marche sans internet).';

  @override
  String colDownloading(String pct) {
    return 'Téléchargement… $pct %';
  }

  @override
  String get colDownloadDb => 'Télécharger la base de données de cartes';

  @override
  String get colScryfall =>
      'Données et images par Scryfall · Sans compte, sans paiement : tout reste sur ton appareil.';

  @override
  String get colAlbumTooltip => 'Album par extensions';

  @override
  String get colImportTooltip => 'Importer un CSV de ManaBox';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies cartes · $distinct différentes$valor';
  }

  @override
  String get colAllCards => 'Toutes les cartes';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct différentes · chercher, filtrer et trier';
  }

  @override
  String get colFolders => 'Dossiers';

  @override
  String get colNewFolder => 'Nouveau';

  @override
  String get colNoFolders =>
      'Tu n\'as encore aucun dossier. Ils servent à regrouper ce que tu veux : « rares d\'Aetherdrift », « à vendre », « la boîte du haut »… Une carte peut être dans plusieurs.';

  @override
  String get colCreateFirstFolder => 'Créer le premier dossier';

  @override
  String get colEmptyTitle => 'Ta collection commence ici';

  @override
  String get colEmptyBody =>
      'Scanne tes cartes avec la caméra ou importe un CSV de ManaBox. Elles apparaîtront ici et dans l\'album.';

  @override
  String get colImportShort => 'Importer un CSV';

  @override
  String acForgetTitle(String carta) {
    return 'Tu n\'as plus $carta ?';
  }

  @override
  String get acForgetBody =>
      'Elle sort de ta collection et sa case dans l\'album redevient vide.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Elle sort aussi des $n dossiers où elle est.',
      one: 'Elle sort aussi du dossier où elle est.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Les decks ne la perdent PAS : elle reste dans la liste et le deck te prévient qu\'elle te manque.';

  @override
  String get acCancel => 'Annuler';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => 'Je ne l\'ai plus';

  @override
  String acAddedOn(String cuando) {
    return 'ajoutée $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'dans $n dossiers',
      one: 'dans 1 dossier',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Cherche une carte (espagnol ou anglais)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles cartes sur $total';
  }

  @override
  String get acMissingFilterData =>
      ' · certaines vieilles cartes n\'ont pas de données de filtre : réimporte ton CSV avec « Remplacer » activé';

  @override
  String get acNoneMatch => 'Aucune carte ne passe ces filtres.';

  @override
  String get acEmptyHint =>
      'Cherche ta première carte en haut, ou reviens en arrière et importe ton CSV de ManaBox.';

  @override
  String get onbHowItWorksBody =>
      'Le résumé de ce que fait chaque onglet et les raccourcis clavier. Si tu te perds, commence par ici.';

  @override
  String get onbVersionBody =>
      'Quelle version tu as, ce qu\'elle apporte, et si tu veux que l\'app regarde une fois par jour s\'il y en a une nouvelle. Elle ne se met jamais à jour toute seule.';

  @override
  String get onbSuggestionsTitle => 'Boîte à suggestions';

  @override
  String get onbSuggestionsBody =>
      'Une idée, ou un bug repéré ? Dis-le sur GitHub : il y a un modèle et ça prend une minute.';

  @override
  String get onbSupportTitle => 'Soutenir le projet';

  @override
  String get onbSupportBody =>
      'L\'app est gratuite et sans pub. Si elle t\'a été utile, voici comment nous offrir un café.';

  @override
  String get onbScanSetTitle => 'Extension : toutes';

  @override
  String get onbScanSetBody =>
      'Si tu ouvres des boosters d\'UNE seule extension, fixe-la ici : le scanner arrête d\'hésiter entre les dix rééditions de la même carte.';

  @override
  String get onbScanModeTitle => 'Rapide ou prudent';

  @override
  String get onbScanModeBody =>
      'En « Rapide », les cartes nettes entrent toutes seules et les douteuses sont marquées à revoir. En « Prudent », il s\'arrête et te demande laquelle c\'est.';

  @override
  String get onbScanPhotoTitle => 'Scanner une photo';

  @override
  String get onbScanPhotoBody =>
      'Pas de caméra, ou tes cartes déjà prises en photo ? Ici tu lâches une photo — avec plusieurs cartes si tu veux — et il les sort pareil.';

  @override
  String get tourScanName => 'Le scanner';

  @override
  String get albNeedDb =>
      'L\'album a besoin de la base de données de cartes (télécharge-la dans Collection).';

  @override
  String get albRetry => 'Réessayer';

  @override
  String get albApproxMode =>
      'Album en mode approximatif : je ne sais pas encore quelle ÉDITION exacte tu as de chaque carte. Réimporte ton CSV avec « Remplacer ma collection actuelle » activé et l\'album s\'affinera par illustration.';

  @override
  String get albSearchSet => 'Cherche une extension…';

  @override
  String get albOnlyMine => 'Avec mes cartes';

  @override
  String get albSortProgress => 'Les plus complètes';

  @override
  String get albSortNewest => 'Les plus récentes';

  @override
  String get albSortOldest => 'Les plus anciennes';

  @override
  String get albSortName => 'Par nom';

  @override
  String get albYearAll => 'Année : toutes';

  @override
  String get albLetterAll => 'Toutes';

  @override
  String get albNoSets => 'Aucune extension ne correspond au filtre.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total cartes';
  }

  @override
  String get albComplete => ' · ✓ complète !';

  @override
  String albLoadError(String error) {
    return 'Je n\'ai pas pu charger l\'extension : $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Chercher dans $set…';
  }

  @override
  String get albOnlyMissing => 'Seulement celles qui manquent';

  @override
  String get albWithVariants => 'Avec les variantes';

  @override
  String get albYouHaveItAll => '✓ Tu as tout';

  @override
  String albMissingCount(int n) {
    return 'Il t\'en manque $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n sans prix)';
  }

  @override
  String albMarketNoToday(String market) {
    return '$market no publica precios por edición — cambia de mercado para verlos';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles sur $total';
  }

  @override
  String get albNoCardsNamed => 'Aucune carte de ce nom ici.';

  @override
  String get fdNewFolder => 'Nouveau dossier';

  @override
  String get fdEditFolder => 'Modifier le dossier';

  @override
  String get fdName => 'Nom';

  @override
  String get fdNameHint => 'Rares d\'Aetherdrift, À vendre…';

  @override
  String get fdColor => 'Couleur';

  @override
  String get fdIcon => 'Icône';

  @override
  String get fdCreate => 'Créer';

  @override
  String get fdSave => 'Enregistrer';

  @override
  String get fdDefaultName => 'Dossier';

  @override
  String fdDeleteTitle(String nombre) {
    return 'Supprimer « $nombre » ?';
  }

  @override
  String get fdDeleteBody =>
      'Seul le dossier disparaît : les cartes restent dans ta collection.';

  @override
  String get fdDelete => 'Supprimer';

  @override
  String get fdGone => 'Ce dossier n\'existe plus.';

  @override
  String get fdEditTooltip => 'Modifier le nom, la couleur et l\'icône';

  @override
  String get fdDeleteTooltip => 'Supprimer le dossier';

  @override
  String get fdAddRemove => 'Ajouter ou retirer';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas cartes différentes · $copias exemplaires';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n passent le filtre';
  }

  @override
  String get fdRoughValue => ' · valeur indicative';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n cartes ne sont plus dans ta collection (elles restent notées au cas où elles reviendraient).',
      one:
          '1 carte n\'est plus dans ta collection (elle reste notée au cas où elle reviendrait).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Les retirer';

  @override
  String get fdNoneMatch => 'Aucune carte du dossier ne passe ces filtres.';

  @override
  String get fdEmpty =>
      'Dossier vide. Appuie sur « Ajouter ou retirer » et coche les cartes que tu veux y mettre.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n exemplaires',
      one: '1 exemplaire',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Retirer du dossier';

  @override
  String get fpPickCards => 'Choisis les cartes';

  @override
  String fpSaveCount(int n) {
    return 'Enregistrer ($n)';
  }

  @override
  String get fpFilterByName => 'Filtre par nom…';

  @override
  String fpVisibleCards(int n) {
    return '$n cartes en vue';
  }

  @override
  String get fpSelectAll => 'Tout cocher';

  @override
  String get fpNoneMatch => 'Aucune carte ne passe ces filtres.';

  @override
  String get fgMsgReading => 'Lecture de ta collection…';

  @override
  String get fgMsgCurve => 'Calcul de la courbe de mana…';

  @override
  String get fgMsgLands => 'Distribution des terrains…';

  @override
  String get fgMsgSynergy => 'Recherche de synergies…';

  @override
  String get fgMsgPlan => 'Rédaction de ton plan de jeu…';

  @override
  String get fgNeedDbForSets =>
      'J\'ai besoin de la base de cartes pour lister les extensions : Réglages → télécharger la base.';

  @override
  String fgDbError(String error) {
    return 'Je n\'ai pas pu lire la base de données de cartes : $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' dans ces $n extensions',
      one: ' dans cette extension',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'Je n\'arrive pas à sortir un Commander légal$donde : il faut un commandant légendaire et ~62 cartes DIFFÉRENTES dans son identité couleur (c\'est du singleton), plus assez de terrains de base. Essaie un autre format, d\'autres extensions ou agrandis ta collection.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'Avec les cartes de ce pool, je n\'arrive à aucun deck $formato complet qui respecte mes règles (assez de terrains et une courbe saine)$donde. $consejo Plutôt que de te refiler un deck bancal, je préfère te prévenir.';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return 'Avec ce Style ($estilo), aucun deck ne sort. Essaie « Style : auto » ou une autre tribu.';
  }

  @override
  String get fgOf60 => 'de 60';

  @override
  String fgLegalIn(String formato) {
    return 'LÉGAL en $formato';
  }

  @override
  String get fgTipMoreSets =>
      'Essaie avec plus d\'extensions ou enlève des filtres.';

  @override
  String get fgTipMoreCards =>
      'Ajoute des cartes — surtout dans tes couleurs principales — ou coche « inclure des cartes que je n\'ai pas ».';

  @override
  String get fgPitch =>
      'Des decks complets et jouables avec les cartes que tu as déjà. Sans rien acheter.';

  @override
  String get fgTeaserCount => 'cartes pour ton premier deck';

  @override
  String get fgTeaserMissing =>
      'Faire un deck avec des cartes que je n\'ai pas';

  @override
  String get fgBasics => 'Je compte sur des terrains de base en vrac';

  @override
  String get fgBasicsSub =>
      'Presque tout le monde a des terrains de base qui traînent depuis un deck d\'initiation ; désactive-le pour n\'utiliser QUE les terrains de base de ta collection.';

  @override
  String get fgFormat => 'Format de jeu';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 cartes · singleton · un commandant légendaire de ta collection · identité couleur respectée.';

  @override
  String get fgCasualNote =>
      '60 cartes, sans restriction de légalité : tout passe.';

  @override
  String fgFormatNote(String formato) {
    return '60 cartes en utilisant UNIQUEMENT tes cartes légales en $formato.';
  }

  @override
  String get fgWhereFrom => 'D\'où sortent les cartes ?';

  @override
  String get fgPickSets => 'Choisir des extensions';

  @override
  String get fgChangeSets => 'Changer d\'extensions';

  @override
  String get fgNeedOneSet =>
      'Choisis au moins une extension : sans filtre, ce serait les ~30 000 cartes de Magic.';

  @override
  String get fgNoSetsNote =>
      'Sans extension choisie, Forge utilise toute ta collection.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Les cartes de $n extensions, que tu les aies ou non.',
      one: 'Les cartes d\'1 extension, que tu les aies ou non.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Seulement tes cartes de $n extensions — pas toute la collection.',
      one: 'Seulement tes cartes d\'1 extension — pas toute la collection.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'Ta collection ne garde pas l\'édition de chaque carte, donc filtrer par extension laisserait presque tout de côté. Réimporte ton CSV avec « Remplacer » et reviens.';

  @override
  String get fgIncludeMissing => 'Inclure des cartes que je n\'ai pas';

  @override
  String get fgIncludeMissingSub =>
      'Forge arrête de se limiter à ta collection et utilise TOUT ce qui est imprimé dans ces extensions ; ensuite il te dit combien de cartes te manquent et ce qu\'elles coûteraient.';

  @override
  String get fgYourTaste => 'À ton goût (facultatif)';

  @override
  String get fgArchetypeAuto => 'Archétype : auto';

  @override
  String get fgStyle => 'Style';

  @override
  String get fgStyleAuto => 'Style : auto';

  @override
  String get fgTribeElf => 'Elfes';

  @override
  String get fgTribeGoblin => 'Gobelins';

  @override
  String get fgTribeZombie => 'Zombies';

  @override
  String get fgTribeVampire => 'Vampires';

  @override
  String get fgTribeDragon => 'Dragons';

  @override
  String get fgTribeAngel => 'Anges';

  @override
  String get fgTribeDemon => 'Démons';

  @override
  String get fgTribeDinosaur => 'Dinosaures';

  @override
  String get fgTribeFaerie => 'Farfadets';

  @override
  String get fgTribeMerfolk => 'Ondins';

  @override
  String get fgTribeHuman => 'Humains';

  @override
  String get fgTribeSpirit => 'Esprits';

  @override
  String get fgTribeSliver => 'Éclats';

  @override
  String get fgTribeWizard => 'Sorciers';

  @override
  String get fgTribeKnight => 'Chevaliers';

  @override
  String get fgTribeWarrior => 'Guerriers';

  @override
  String get fgTribeSoldier => 'Soldats';

  @override
  String get fgTribeCat => 'Chats';

  @override
  String get fgTribeDog => 'Chiens';

  @override
  String get fgTribeRat => 'Rats';

  @override
  String get fgTribePirate => 'Pirates';

  @override
  String get fgTribeElemental => 'Élémentaux';

  @override
  String get fgTribeGiant => 'Géants';

  @override
  String get fgTribeRogue => 'Roublards';

  @override
  String get fgDeepForge => 'Forge approfondie';

  @override
  String get fgDeepForgeHint =>
      'Avant de te montrer les propositions, elle les fait vraiment s\'affronter entre elles (un peu plus d\'attente).';

  @override
  String get fgPricePerCard => 'Prix par carte :';

  @override
  String get fgMin => 'min €';

  @override
  String get fgMax => 'max €';

  @override
  String get fgCardYear => 'Année de la carte :';

  @override
  String get fgFrom => 'de';

  @override
  String get fgTo => 'à';

  @override
  String get fgYearNeedsDb =>
      'Le filtre par année a besoin d\'une base à jour : Réglages → Retélécharger la base de données.';

  @override
  String get fgNoColorsNote =>
      'Sans couleurs choisies, Forge essaie toutes les combinaisons.';

  @override
  String fgColorsNote(String colores) {
    return 'Uniquement des decks $colores (et leurs combinaisons).';
  }

  @override
  String get fgMissingNote =>
      'Ce deck peut contenir des cartes que tu n\'as PAS : chaque proposition dit combien il t\'en manque et ce qu\'elles coûteraient (prix Cardmarket).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge n\'utilise que tes $n cartes. Il n\'invente jamais des exemplaires que tu n\'as pas.';
  }

  @override
  String get fgForgeMissing => 'Forger des decks (avec ce qui me manque)';

  @override
  String get fgForgeMine => 'Forger mes decks';

  @override
  String get fgTestMode => 'Mode Test : bats un deck du meta';

  @override
  String get fgOffline => 'Tout se calcule sur ton appareil, sans internet';

  @override
  String fgForgingWith(int n) {
    return 'Tu forges avec $n cartes : ça prend quelques secondes. La fenêtre est toujours vivante.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n decks prêts à jouer',
      one: '1 deck prêt à jouer',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'Avec des cartes que tu n\'as pas encore · fais glisser pour comparer';

  @override
  String get fgSwipeMine =>
      'Faits uniquement avec tes cartes · fais glisser pour comparer';

  @override
  String get fgHaveAll => '✓ Tu as toutes les cartes';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Il te manque $n cartes',
      one: 'Il te manque 1 carte',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Voir le deck complet';

  @override
  String get fgReforge => 'Reforger';

  @override
  String get fgBackToOptions => 'Volver a elegir cómo forjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta est à $precio (ton objectif : $objetivo) !';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 $n cartes de ta wishlist sont tombées à leur prix objectif !';
  }

  @override
  String get mkTellMeWhenDrops => 'Préviens-moi quand ça baisse';

  @override
  String get mkTargetPrice => 'Prix objectif';

  @override
  String mkNow(String precio) {
    return 'Maintenant : $precio';
  }

  @override
  String get mkUpdated => '✓ Prix et cartes mis à jour';

  @override
  String mkUpdateFailed(String error) {
    return 'Je n\'ai pas pu mettre à jour : $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Historique des prix prêt : les graphiques montrent enfin les derniers mois';

  @override
  String mkHistoryFailed(String error) {
    return 'Je n\'ai pas pu récupérer l\'historique (celui que tu avais est intact) : $error';
  }

  @override
  String get mkHistoryLocal =>
      'Historique des prix : seulement celui que ManaForge note chaque jour sur ton ordi. Récupère les ~90 derniers jours réels de Cardmarket (≈4 Mo).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Historique réel de Cardmarket du $desde au $hasta, et à partir de là ce que note ManaForge.';
  }

  @override
  String get mkFetchHistory => 'Récupérer l\'historique';

  @override
  String get mkCollectionValue => 'Valeur de ta collection · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n cartes';
  }

  @override
  String get mkApproxSuffix => ' · valeur indicative';

  @override
  String mkBulkPrices(String fecha) {
    return 'Prix Cardmarket du $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Marché sans données : télécharge la base de données dans Collection. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'EXTENSIONS ($n)';
  }

  @override
  String get mkPrevious => 'Précédentes';

  @override
  String get mkNext => 'Suivantes';

  @override
  String get mkSearchHint => 'Cherche le prix de n\'importe quelle carte…';

  @override
  String get mkRemoveFromWishlist => 'Retirer de la wishlist';

  @override
  String get mkAddToWishlist => 'À la wishlist : préviens-moi quand ça baisse';

  @override
  String get mkYourWishlist => 'TA WISHLIST';

  @override
  String mkTargetAtMost(String precio) {
    return 'objectif ≤ $precio';
  }

  @override
  String get mkAtPrice => 'au bon prix !';

  @override
  String get mkChangeTarget => 'Changer le prix objectif';

  @override
  String mkNoPriceIn(String market) {
    return 'pas de prix sur $market';
  }

  @override
  String get mkPerUnit => '/u';

  @override
  String get mkTopCards => 'TES CARTES LES PLUS PRÉCIEUSES';

  @override
  String get mkImportToSeeValue =>
      'Importe ta collection pour voir ce qu\'elle vaut.';

  @override
  String mkSetCards(int n) {
    return ' · $n cartes';
  }

  @override
  String get wlEmpty =>
      'Cherche-les dans Marché et touche le marque-page pour qu\'on te prévienne quand elles descendent à ton prix.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '🔔 $n cartes de ta wishlist sont à ton prix objectif ou en dessous.',
      one: '🔔 1 carte de ta wishlist est à ton prix objectif ou en dessous.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'Prix MTGO en tix (cartes numériques)';

  @override
  String get mpNoDataYet =>
      'Pas encore de données : mets à jour l\'historique des prix dans Marché';

  @override
  String get mpMtgoNote =>
      'Prix MTGO en tix : ce sont des cartes numériques, ça ne vaut rien pour estimer ta collection papier. Accueil, dossiers et succès restent sur Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return 'Prix de $mercado en $moneda. Accueil, dossiers et succès continuent d\'estimer en Cardmarket (€) : les devises ne sont jamais converties.';
  }

  @override
  String get mkUpdate => 'Mettre à jour';

  @override
  String get mkApproxValue =>
      ' · valeur approximative (réimporte avec « Remplacer » pour des prix par édition)';

  @override
  String get mkExactPrintings => ' · selon tes éditions exactes';

  @override
  String mkNowSuffix(String precio) {
    return ' · maintenant $precio';
  }

  @override
  String get wlNothingYet => 'Rien dans ta wishlist pour l\'instant.';

  @override
  String get stDbUpdated => '✓ Base de données mise à jour';

  @override
  String stUpdateFailed(String error) {
    return 'Impossible de mettre à jour : $error';
  }

  @override
  String get stCardDb => 'Base de données de cartes';

  @override
  String get stCardDbWhy =>
      'Retélécharge-la pour avoir les nouvelles cartes, des prix frais et les fonctions qui réclament des données récentes (comme le filtre par année dans Forge).';

  @override
  String get stDownloadDbAgain => 'Retélécharger la base de données';

  @override
  String get stAppearance => 'Apparence';

  @override
  String get stData => 'Données';

  @override
  String get stTheApp => 'L\'app';

  @override
  String get stCredits =>
      'Données et images des cartes par Scryfall. Magic: The Gathering appartient à Wizards of the Coast ; projet de fans sous couvert de sa Fan Content Policy.';

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
  String get stEditHome => 'Modifier l\'accueil';

  @override
  String get stEditHomeSub =>
      'Choisis quelles sections s\'affichent et dans quel ordre';

  @override
  String get ehLevel => 'Ton niveau';

  @override
  String get ehShortcuts => 'Accès rapides';

  @override
  String get ehSummary => 'Résumé de la collection';

  @override
  String get ehRecent => 'Vues récemment';

  @override
  String get ehDecks => 'Tes decks';

  @override
  String get ehMeta => 'Le meta en ce moment';

  @override
  String get ehNewSets => 'Nouvelles extensions';

  @override
  String get ehGems => 'Tes joyaux';

  @override
  String get ehStatCards => 'cartes';

  @override
  String get ehStatDistinct => 'différentes';

  @override
  String get ehStatValue => 'valeur';

  @override
  String get ehStatDecks => 'decks';

  @override
  String get ehStatAchievements => 'succès';

  @override
  String get ehHelp =>
      'Fais glisser pour réordonner et utilise l\'interrupteur pour choisir ce que tu vois sur l\'Accueil. Une section allumée n\'apparaît que si elle a quelque chose à montrer.';

  @override
  String get ehSection => 'Section';

  @override
  String get bkNoData => 'Je ne trouve pas tes données.';

  @override
  String bkSaved(String resumen) {
    return '✓ Sauvegarde enregistrée · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'Je n\'ai pas pu l\'enregistrer : $error';
  }

  @override
  String get bkFileName => 'Sauvegarde ManaForge';

  @override
  String bkRestoreFailed(String error) {
    return 'Je n\'ai pas pu la restaurer : $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Restauré · $resumen. ATTENTION : je n\'ai pas pu enregistrer ce que tu avais avant ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Restauré · $resumen. Ce que tu avais avant est enregistré dans le dossier backups.';
  }

  @override
  String get bkRestoring => 'Restauration de ta sauvegarde…';

  @override
  String get bkTitle => 'Sauvegarde';

  @override
  String get bkWhy =>
      'Tes cartes, tes decks, tes dossiers et tes succès vivent uniquement sur cet ordinateur. Enregistre une copie de temps en temps et range-la ailleurs : un disque, le cloud, ce que tu veux.';

  @override
  String get bkSave => 'Enregistrer une sauvegarde';

  @override
  String get bkRestoreTitle => 'Restaurer une sauvegarde';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Restaurer REMPLACE tes cartes, decks, dossiers et succès actuels par ceux de la sauvegarde. Choisis laquelle, appuie sur le bouton et écris $palabra : comme ça, rien ne se restaure par accident.';
  }

  @override
  String get bkNoBackups =>
      'Aucune sauvegarde enregistrée sur cet ordinateur pour l\'instant.';

  @override
  String get bkWhich => 'Sauvegarde à restaurer';

  @override
  String get bkPickOne => 'Choisis une sauvegarde';

  @override
  String get bkRestorePicked => 'Restaurer la sauvegarde choisie';

  @override
  String get bkAutoNote =>
      'J\'enregistre une sauvegarde automatique chaque semaine (les cinq dernières) et une autre juste avant chaque restauration.';

  @override
  String get bkFromFile => 'Restaurer depuis un fichier';

  @override
  String get bkConfirmTitle => 'Restaurer cette sauvegarde ?';

  @override
  String get bkConfirmBody =>
      'Ça remplace ta collection, tes decks, tes dossiers et tes succès actuels par ceux de cette sauvegarde. Avant de le faire, j\'enregistre ce que tu as dans le dossier backups, au cas où tu voudrais revenir en arrière.';

  @override
  String bkWillDelete(String cosas) {
    return 'Cette sauvegarde ne contient pas $cosas : en la restaurant, ça s\'efface.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Écris $palabra pour pouvoir continuer :';
  }

  @override
  String get bkAnd => ' et ';

  @override
  String get ehReset => 'Réinitialiser';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Sauvegarde du $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'Je ne trouve aucune caméra.';

  @override
  String get lsCameraGone =>
      'La caméra s\'est déconnectée en pleine session. Vérifie le câble et appuie sur Réessayer.';

  @override
  String get lsFrameCard => 'Cadre la carte dans le viseur';

  @override
  String get lsNoCardThere => 'Je ne vois aucune carte là';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n cartes dans la collection',
      one: '✓ 1 carte dans la collection',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', et dans « $carpeta »';
  }

  @override
  String get lsTitle => 'Scan en direct';

  @override
  String get lsQuickTip =>
      'Rapide : les cartes nettes entrent toutes seules ; les douteuses sont marquées à revoir.';

  @override
  String get lsCarefulTip =>
      'Prudent : les douteuses s\'arrêtent et te demandent laquelle c\'est.';

  @override
  String get lsQuick => 'Rapide';

  @override
  String get lsCareful => 'Prudent';

  @override
  String lsThisSession(int n) {
    return '$n cette session';
  }

  @override
  String get lsScanPhotoTooltip => 'Scanner une photo toute seule';

  @override
  String get lsStartingCamera => 'Réveil de la caméra…';

  @override
  String get lsCantUseCamera => 'Je ne peux pas utiliser la caméra';

  @override
  String get lsCameraUnavailable => 'Caméra indisponible.';

  @override
  String get lsScanPhoto => 'Scanner une photo';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 pareille · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Elle est déjà sur la table : $carta · retire-la et repose-la, ou touche « +1 pareille »';
  }

  @override
  String lsSeeing(String carta) {
    return 'Je vois : $carta';
  }

  @override
  String get lsPassACard => 'Passe une carte devant la caméra…';

  @override
  String lsIsThis(String carta) {
    return 'C\'est $carta ? Je n\'en suis pas sûr — touche pour choisir.';
  }

  @override
  String get lsNotThisOne => 'Ce n\'est pas celle-là — changer d\'édition';

  @override
  String get lsRetry => 'Réessayer';

  @override
  String get scBadImage =>
      'Je n\'ai pas pu lire cette image (c\'est bien une photo valide ?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Sans dossier';

  @override
  String scAlsoTo(String carpeta) {
    return 'Et aussi dans : $carpeta';
  }

  @override
  String get scLookingForCard => 'Recherche de la carte sur la photo…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Reconnaissance… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartes',
      one: '1 carte',
    );
    return '$_temp0 · $copias au total';
  }

  @override
  String scToReview(int n) {
    return '$n à revoir (touche-les)';
  }

  @override
  String scUnknown(int n) {
    return '$n non reconnues (touche pour choisir à la main)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n photos ignorées (trop grosses ou illisibles)',
      one: '1 photo ignorée (trop grosse ou illisible)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'Je n\'ai reconnu aucune carte sur ces photos. Essaie avec une meilleure lumière ou moins de reflets.';

  @override
  String scAddN(int n) {
    return 'Ajouter $n à la collection';
  }

  @override
  String get scDropPhotos => 'Lâche ici les photos de tes cartes';

  @override
  String get scDropExplain =>
      'Une ou plusieurs à la fois — et si une photo contient PLUSIEURS cartes (une page d\'album, la table pleine), je les sors toutes et je les rassemble dans une liste pour que tu vérifies et ajoutes celles que tu veux. Photo de téléphone ou scan, les deux marchent.';

  @override
  String get scPickPhotos => 'Choisir des photos';

  @override
  String get scMatchHigh => 'correspondance forte';

  @override
  String get scMatchMedium => 'correspondance moyenne';

  @override
  String get scMatchLow => 'correspondance faible';

  @override
  String get scAddToCollection => 'Ajouter à la collection';

  @override
  String get scSeeOptions => 'Ce n\'est pas celle-là — voir les options';

  @override
  String get scScanAnother => 'Scanner une autre';

  @override
  String get scNotSure => 'Je n\'en suis pas sûr';

  @override
  String get scWhichIsIt => 'Laquelle c\'est ?';

  @override
  String get scNoneQuiteFits =>
      'Aucune ne colle vraiment. C\'est l\'une de celles-là ? Sinon, essaie une autre photo avec une meilleure lumière.';

  @override
  String get scNoEdges =>
      'Je n\'ai pas vu les bords de la carte, alors j\'ai pris l\'image entière. Voici les plus ressemblantes :';

  @override
  String get scCropped =>
      'Voilà ce que j\'ai découpé. Les candidates, par ressemblance :';

  @override
  String get scDiscard => 'Jeter et scanner une autre';

  @override
  String get suCardsName => 'Cartes et prix';

  @override
  String get suCardsWhat => 'le catalogue complet de Scryfall';

  @override
  String get suHistoryName => 'Historique des prix';

  @override
  String get suHistoryWhat => '~90 jours de Cardmarket';

  @override
  String get suHashesName => 'Empreintes du scanner';

  @override
  String get suHashesWhat => 'pour reconnaître par photo';

  @override
  String suUpToDate(String fecha) {
    return 'à jour ($fecha)';
  }

  @override
  String get suUpdated => 'mise à jour';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'mise à jour ($fecha)';
  }

  @override
  String get suFailedOffline => 'je n\'ai pas pu la récupérer (hors connexion)';

  @override
  String get suKeepingOld => 'je garde celle que tu avais';

  @override
  String get suNeedMissing => 'elle manque, je la récupère';

  @override
  String get suNeedStale => 'il y en a une nouvelle';

  @override
  String get suNeedFresh => 'à jour';

  @override
  String get suAllUpToDate => 'Tout est à jour. On entre…';

  @override
  String get suUpdatingCards => 'Mise à jour de tes cartes et de tes prix…';

  @override
  String get suChecking => 'Je regarde s\'il y a du nouveau…';

  @override
  String get suNoDownloadNote =>
      'Ce qui est déjà à jour ne se télécharge pas. Dans l\'app, tu peux forcer n\'importe quelle mise à jour.';

  @override
  String get suEnter => 'Entrer';

  @override
  String get suEnterNow => 'Entrer tout de suite';

  @override
  String icBadFile(String error) {
    return 'Je n\'ai pas pu lire le fichier : $error';
  }

  @override
  String get icNotCsv =>
      'Ça ne ressemble pas à un CSV — lâche un fichier .csv ou .txt.';

  @override
  String get icTitle => 'Importer une collection';

  @override
  String get icExplain =>
      'Fais glisser ici ton CSV de ManaBox (Moxfield, Archidekt ou n\'importe quel CSV avec les colonnes Name et Quantity marchent aussi), choisis-le avec le bouton, ou colle son contenu à la main :';

  @override
  String get icPickFile => 'Choisir un fichier…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas cartes ($copias exemplaires) ajoutées à ta collection.';
  }

  @override
  String get icReplaceMine => 'Remplacer ma collection actuelle';

  @override
  String get icReplaceWhy =>
      'Active-le quand tu réimportes ton CSV complet : ça évite de doubler les quantités et ça affine l\'album par édition.';

  @override
  String icImporting(int hechas, int total) {
    return 'Import de $hechas cartes sur $total…';
  }

  @override
  String get icDropHere => 'Lâche ton CSV ici';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n jetons/emblèmes ignorés (ils ne vont pas dans les decks, tout va bien).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Non reconnues : $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• Pas de prix d\'achat dans le CSV : il n\'y aura pas de P&L (ManaBox l\'exporte dans la colonne « Purchase price »).';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n exemplaires avec un prix d\'achat : tu peux déjà voir le P&L dans Marché.';
  }

  @override
  String get icImporting2 => 'Import en cours…';

  @override
  String get icImport => 'Importer';

  @override
  String dkDeleted(String nombre) {
    return 'Deck « $nombre » supprimé';
  }

  @override
  String get dkUndo => 'ANNULER';

  @override
  String dkOpenFailed(String error) {
    return 'Je n\'ai pas pu ouvrir le deck (la base de données est bien téléchargée ?) : $error';
  }

  @override
  String get dkMyDecks => 'Mes decks';

  @override
  String get dkEmpty =>
      'C\'est ici que vivront les decks que tu enregistres depuis Forge (bouton d\'enregistrement dans le détail du deck).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n enregistrés',
      one: '1 enregistré',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos sorts + $tierras terrains · enregistré le $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Supprimer le deck';

  @override
  String get ddSaved =>
      '✓ Deck enregistré — tu le retrouves dans l\'onglet Decks';

  @override
  String get ddReforged => '✓ Deck reforgé selon ta courbe — liste mise à jour';

  @override
  String get ddSaveToMyDecks => 'Enregistrer dans Mes decks';

  @override
  String get ddCopyList => 'Copier la liste (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ Liste copiée — colle-la dans Moxfield, Arena ou Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos sorts + $tierras terrains';
  }

  @override
  String get ddHaveAll => '✓ Tu as toutes les cartes';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ Il te manque $n cartes de ce deck — elles restent dans la liste, elles n\'ont pas été supprimées',
      one:
          '⚠ Il te manque 1 carte de ce deck — elle reste dans la liste, elle n\'a pas été supprimée',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Ton plan de jeu';

  @override
  String get ddManaCurve => 'Courbe de mana';

  @override
  String get ddEditCurve => 'Modifier la courbe';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Fais glisser les barres ↑↓ · $hechizos sorts → $tierras terrains';
  }

  @override
  String get ddReforgeCurve => 'Reforger avec cette courbe';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras terrains · ✦ $hechizos sorts · Ø coût $coste';
  }

  @override
  String get ddWhyWorks => 'Pourquoi ce deck marche ?';

  @override
  String ddLands(int n) {
    return 'TERRAINS ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Total du deck : ~$precio €';
  }

  @override
  String get ddCheapestPrice =>
      'prix de l\'édition la moins chère (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n sans prix connu · édition la moins chère (Cardmarket)';
  }

  @override
  String get ddInstants => 'Éphémères';

  @override
  String get ddTypeCreatures => 'Créatures';

  @override
  String get ddTypeSorceries => 'Rituels';

  @override
  String get ddTypeEnchantments => 'Enchantements';

  @override
  String get ddTypeArtifacts => 'Artefacts';

  @override
  String get ddTypeOther => 'Autres';

  @override
  String get ddOutOfRange => '  (hors de la plage saine 20-27)';

  @override
  String get acRecalcTitle => 'Recalculer les succès ?';

  @override
  String get acRecalcBody =>
      'Tes cartes sont réexaminées et les succès qui ne tiennent plus aujourd\'hui sont retirés. Ça sert à corriger ceux qui ont été donnés par erreur ; si tu as vendu des cartes, tu perdras ceux-là aussi.';

  @override
  String get acRecalc => 'Recalculer';

  @override
  String get acAllFine => 'Tout collait : aucun succès n\'a été retiré.';

  @override
  String acRemovedN(int n) {
    return '$n succès retirés, ils ne tiennent plus.';
  }

  @override
  String get acTitle => 'Succès';

  @override
  String get acRecalcTooltip => 'Recalculer avec mes cartes actuelles';

  @override
  String get acCertsTooltip => 'Certificats';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos succès sur $total · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Niveau $nivel · encore $xp XP pour le $siguiente';
  }

  @override
  String get acIMissing => 'Il me manque';

  @override
  String get acSecret => 'Succès secret';

  @override
  String get acSecretDesc => 'Il se découvre seulement quand tu l\'obtiens.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Obtenu$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' le $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return 'Niveau $nivel !';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'Te voilà $titulo. Tu en es à $hechos succès sur $total.';
  }

  @override
  String get acOk => 'OK';

  @override
  String get acSeeAchievements => 'Voir les succès';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 Succès ! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (et $n de plus)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Pour ceux d\'extension, il faut la base de données de cartes ($error)';
  }

  @override
  String get ceWhoseName => 'Au nom de qui ?';

  @override
  String get ceCollectorName => 'Ton nom de collectionneur';

  @override
  String get ceInNameOf => 'Au nom de…';

  @override
  String get ceEmptyWithData =>
      'Tu n\'as encore aucune extension complète. Quand tu en termineras une entière dans l\'Album, ton certificat apparaîtra ici, prêt à télécharger.';

  @override
  String get ceEmptyNoData =>
      'Pour certifier une extension, il faut connaître l\'édition exacte de tes cartes : réimporte ton CSV de ManaBox (il apporte le Scryfall ID).';

  @override
  String get ceNothingSaved => 'Rien n\'a été enregistré.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Certificat enregistré dans $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'Impossible de l\'enregistrer : $error';
  }

  @override
  String get cePickFirstCard => 'Choisir la carte par laquelle j\'ai commencé';

  @override
  String get ceChangeFirstCard =>
      'Changer la carte par laquelle j\'ai commencé';

  @override
  String get ceDownloadPng => 'Télécharger le PNG';

  @override
  String get cdNotFound =>
      'Je ne trouve pas cette carte dans la base de données.';

  @override
  String cdLoadFailed(String error) {
    return 'Je n\'ai pas pu charger la fiche : $error';
  }

  @override
  String get cdPrev => 'Précédente (←)';

  @override
  String get cdNext => 'Suivante (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Carte introuvable';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return 'Tu as payé $total$divisa pour $qty $copias ($unidad chacun)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'exemplaires',
      one: 'exemplaire',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ Tu as $n exemplaires dans ta collection',
      one: '✓ Tu as 1 exemplaire dans ta collection',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'Tu n\'as pas cette carte (pas encore).';

  @override
  String cdNoPrice(String mercado) {
    return 'Pas de prix pour cette carte sur $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'VERSIONS ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'pas de prix par édition sur $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return 'prix $mercado ($moneda) · normale / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'tu en as x$n';
  }

  @override
  String get smMythic => 'Mythique';

  @override
  String get smRare => 'Rare';

  @override
  String get smUncommon => 'Peu commune';

  @override
  String get smCommon => 'Commune';

  @override
  String smLoadFailed(String error) {
    return 'Je n\'ai pas pu charger l\'extension : $error';
  }

  @override
  String get smSearchInSet => 'Cherche dans l\'extension…';

  @override
  String get smRarityAll => 'Rareté : toutes';

  @override
  String get smPriceDown => 'Prix ↓';

  @override
  String get smPriceUp => 'Prix ↑';

  @override
  String get smNumber => 'Numéro';

  @override
  String get smOnlyMine => 'Seulement les miennes';

  @override
  String smCardsCount(int n) {
    return '$n cartes';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado : pas de prix par édition';
  }

  @override
  String smListedValue(String mercado) {
    return 'valeur listée ($mercado) : ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'Tu as payé $pagado · aujourd\'hui elles valent $hoy';
  }

  @override
  String get pnNoPnl =>
      'Sans prix d\'achat, pas de P&L. Importe ton CSV de ManaBox avec la colonne « Purchase price » et ça apparaît ici.';

  @override
  String pnOverAll(int n) {
    return 'sur les $n exemplaires de ta collection';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'sur $conprecio des $total exemplaires (les autres n\'ont pas de prix d\'achat noté)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '$n exemplaires achetés n\'ont pas de prix du jour dans la base : hors du compte';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'tu as aussi payé $importe $moneda, qui ne se convertit pas';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n exemplaires sans devise dans le CSV : on suppose des $moneda';
  }

  @override
  String get pcTitle => 'Évolution du prix';

  @override
  String get pcNoHistory =>
      'Pas encore d\'historique de prix pour cette carte.';

  @override
  String pcTodayPrice(String precio) {
    return 'Prix du jour : $precio €. Le graphique apparaît dès qu\'il y a plusieurs jours.';
  }

  @override
  String get pcExplain =>
      'ManaForge note le prix de chaque carte que tu regardes ou que tu as, jour après jour. Pour démarrer avec les derniers mois réels de Cardmarket, récupère l\'historique depuis Marché.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '1 jour',
    );
    return 'min $min € · max $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'De quelles extensions ?';

  @override
  String get spSearchHint => 'Chercher par nom ou par code (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Seulement les miennes';

  @override
  String spClearN(int n) {
    return 'Enlever les $n';
  }

  @override
  String get spNoneNamed =>
      'Aucune extension de ce nom. Désactive « Seulement les miennes » pour toutes les voir.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n cartes';
  }

  @override
  String get spNoFilter => 'Sans filtre d\'extension';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Utiliser $n extensions',
      one: 'Utiliser 1 extension',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'Je ne cherche que des cartes de l\'extension $set. Touche-la pour changer ou enlever le verrou.';
  }

  @override
  String get slLockHint =>
      'Verrouille une extension pour scanner une boîte/precon : le scanner ne cherchera que dedans et clouera l\'édition.';

  @override
  String slSetIs(String set) {
    return 'Extension : $set';
  }

  @override
  String get slSetAll => 'Extension : toutes';

  @override
  String get slLockTitle => 'Verrouiller l\'édition';

  @override
  String get slLockBody =>
      'Écris le code de l\'extension (p. ex. AER, MH3, LCI) pour scanner une boîte entière : seules les cartes de cette extension seront cherchées.';

  @override
  String get slSetCode => 'Code d\'extension';

  @override
  String get slClearLock => 'Enlever le verrou';

  @override
  String get stHintQuick =>
      'Passe des cartes devant : les nettes se notent toutes seules ici (les exemplaires identiques s\'empilent ×N). Les douteuses sont marquées à revoir. À la fin, tu confirmes tout.';

  @override
  String get stHintCareful =>
      'Passe des cartes devant : les nettes se notent toutes seules ; les douteuses te demandent laquelle c\'est. À la fin, tu confirmes tout.';

  @override
  String stAddN(int n) {
    return 'Ajouter $n à la collection';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return 'Ajouter $n à la collection et à $carpeta';
  }

  @override
  String get stOneLess => 'Une de moins';

  @override
  String get stAnotherSame => 'Une autre pareille';

  @override
  String get stOnTable => 'sur la table';

  @override
  String cdLastData(String fecha) {
    return ' (dernière donnée : $fecha)';
  }

  @override
  String get cdLegalities => 'Légalités';

  @override
  String get slLockButton => 'Verrouiller';

  @override
  String get wn030Headline =>
      'Forge par extensions, prix d\'achat et alertes de version';

  @override
  String get wn030Forge =>
      'Forge : choisis de quelles extensions sortent les cartes. Et si tu actives « inclure des cartes que je n\'ai pas », il te monte le deck avec toute la sélection choisie et te dit combien il t\'en manque et ce qu\'elles coûtent.';

  @override
  String get wn030Pnl =>
      'Prix d\'achat et P&L : si ton CSV de ManaBox contient « Purchase price », le Marché te dit ce que tu as payé, ce que ça vaut aujourd\'hui et la différence. Les devises ne se mélangent pas.';

  @override
  String get wn030PhotoFolder =>
      'Scanner par photo permet aussi de choisir un dossier, comme le scanner en direct.';

  @override
  String get wn030Album =>
      'Album : ce qui te manque dans chaque extension, avec ce que ça coûterait.';

  @override
  String get wn030Background =>
      'Fond d\'écran : mets derrière l\'image que tu veux, avec un voile réglable, et choisis la couleur des cartes et du texte pour que tout reste lisible par-dessus.';

  @override
  String get wn030Window =>
      'La fenêtre s\'ouvre là où tu l\'as laissée, à la taille où tu l\'as laissée.';

  @override
  String get wn030Achievements =>
      'Les succès ne portent plus le nom du critère mais celui du moment : « Voilà tout mon argent », « Cent rares et pas une jouable ».';

  @override
  String get wn030Update =>
      'L\'app prévient quand il y a une nouvelle version (elle ne se met jamais à jour toute seule) et vérifie l\'empreinte SHA-256 des bases qu\'elle télécharge.';

  @override
  String get wn030Shortcuts =>
      'Raccourcis clavier : Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, et Échap.';

  @override
  String get wn030Linux =>
      'Sous Linux, un installeur met ManaForge dans ton menu d\'applications avec son icône.';

  @override
  String get wn030License =>
      'Licence PolyForm Noncommercial : partage-la et bidouille-la tant que tu veux, mais elle ne se vend pas.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartes',
      one: '1 carte',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n decks',
      one: '1 deck',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dossiers',
      one: '1 dossier',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n succès',
      one: '1 succès',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'sauvegarde vide';

  @override
  String get bkStoreCollection => 'ta collection';

  @override
  String get bkStoreFolders => 'tes dossiers';

  @override
  String get bkStoreDecks => 'tes decks';

  @override
  String get bkStoreAchievements => 'tes succès';

  @override
  String get bkStoreWishlist => 'ta liste d\'envies';

  @override
  String get bkStoreCertificates => 'tes certificats';

  @override
  String get bkStoreMarket => 'ton marché préféré';

  @override
  String get bkStoreRecents => 'les cartes vues récemment';

  @override
  String get bkStoreValueHistory => 'l\'historique de la valeur';

  @override
  String get bkStorePriceHistory => 'l\'historique des prix';

  @override
  String get bkKindAuto => 'automatique';

  @override
  String get bkKindPreRestore => 'avant restauration';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig =>
      'Ce fichier est bien trop gros pour être une sauvegarde de ManaForge.';

  @override
  String get bkErrExpandTooBig =>
      'Cette sauvegarde est bien trop grosse une fois ouverte : ça ne ressemble pas à une vraie sauvegarde de ManaForge.';

  @override
  String get bkErrNotABackup =>
      'Ce fichier n\'est pas une sauvegarde de ManaForge.';

  @override
  String get bkErrNewerVersion =>
      'Cette sauvegarde a été faite par une version plus récente de ManaForge. Mets l\'app à jour et réessaie.';

  @override
  String get bkErrIncomplete =>
      'Cette sauvegarde est incomplète : elle n\'apporte pas tes données.';

  @override
  String bkErrDamaged(String almacen) {
    return 'Cette sauvegarde est abîmée : $almacen ne peut pas être lu.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'Je n\'ai pas pu écrire dans le dossier de données, donc je n\'ai touché à rien : $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'La restauration s\'est arrêtée à moitié ($escritos fichiers sur $total). Je n\'ai aucune sauvegarde antérieure de ce qu\'il y avait. Détail : $error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return 'La restauration s\'est arrêtée à moitié ($escritos fichiers sur $total). Pour revenir en arrière, restaure $ruta. Détail : $error';
  }

  @override
  String get siImportTooBig =>
      'Ce fichier est bien trop gros pour être une liste de cartes.';

  @override
  String get siInsecureDownload =>
      'Le téléchargement a fini sur une adresse non sécurisée et a été annulé.';

  @override
  String get siRedirectNowhere =>
      'Le téléchargement redirige vers nulle part et a été annulé.';

  @override
  String get siTooManyRedirects =>
      'Le téléchargement tourne en rond bien trop de fois et a été annulé.';

  @override
  String get siDownloadTooBig =>
      'Le téléchargement est bien plus gros qu\'il ne devrait et a été annulé.';

  @override
  String get siBadHash =>
      'Ce qui a été téléchargé ne correspond pas à l\'empreinte publiée sur GitHub. Rien n\'a été installé. Réessaie ; si ça continue, préviens-nous.';

  @override
  String get siBackgroundNotImage =>
      'Choisis une image (.jpg, .png ou .webp) comme fond.';

  @override
  String get siBackgroundTooBig =>
      'Cette image est trop grosse pour servir de fond.';

  @override
  String get siScanTooBig => 'Cette photo est trop grosse pour être reconnue.';

  @override
  String get bgImages => 'Images';

  @override
  String bgImageFailed(String error) {
    return 'Je n\'ai pas pu utiliser cette image : $error';
  }

  @override
  String get bgLowContrast =>
      'Trop proche de la couleur de la carte : le texte s\'ajustera tout seul pour rester lisible.';

  @override
  String get bgChipColor => 'Couleur des onglets';

  @override
  String get bgIconColor => 'Couleur des icônes';

  @override
  String get bgUseThis => 'Utiliser celle-ci';

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
      'GStreamer n\'est pas installé. Installe-le avec :\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'La caméra $dispositivo ne donne pas d\'image (gst-launch est sorti avec $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'La caméra $dispositivo n\'a produit aucune image en 6 s.';
  }

  @override
  String get camNoCameras =>
      'Je ne trouve aucune caméra (/dev/video*). Elle est branchée ? Vérifie avec `lsusb` que le système la voit.';

  @override
  String camNoneWorked(String detalle) {
    return 'Aucune caméra n\'a donné d\'image :\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Restaurer';

  @override
  String get fpUnselect => 'Décocher';

  @override
  String get stClear => 'Vider';

  @override
  String get tlRemove => 'Retirer';

  @override
  String get tlUnrecognized => 'Non reconnue';

  @override
  String get tlNothingAlike =>
      'rien de semblable dans la base — refais la photo ou retire-la';

  @override
  String get tlTapToPick =>
      'touche pour choisir à la main parmi les ressemblantes';

  @override
  String get tlReview => 'à vérifier';

  @override
  String get lsQuantity => 'Quantité';

  @override
  String get scPhotos => 'Photos';

  @override
  String get ftWhichFolder => 'Dans quel dossier tu les veux ?';

  @override
  String get ftWhichFolderSub =>
      'Elles entrent dans ta collection de toute façon ; le dossier n\'est qu\'une étiquette pour les retrouver après.';

  @override
  String get ftNone => 'Aucun';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartes',
      one: '1 carte',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => 'Nouveau dossier…';

  @override
  String get ftNewFolder => 'Nouveau dossier';

  @override
  String get ftNewFolderHint => 'Boîte de la boutique, À vendre…';

  @override
  String get sgTitle => 'L\'œil du scanner';

  @override
  String get sgWhy =>
      'Pour reconnaître des cartes sans internet, il me faut la base d\'empreintes visuelles (~12 Mo) : la signature de chaque illustration de Magic. Elle se télécharge une seule fois.';

  @override
  String get sgDownload => 'Télécharger la base d\'empreintes';

  @override
  String get cmFullCard => 'Voir la fiche complète (prix et légalité)';

  @override
  String get cmSwipeHint =>
      'fais glisser ou utilise ← → pour passer · touche à côté pour fermer';

  @override
  String get cmTapOutHint => 'touche à côté pour fermer';

  @override
  String get fcTitle => 'Par quelle carte as-tu commencé ?';

  @override
  String get fcRemove => 'Retirer';

  @override
  String get fcSearchHint => 'Chercher dans ta collection';

  @override
  String get fcNoMatch => 'Je ne trouve aucune carte avec ça.';

  @override
  String get acNoneWithFilters => 'Rien par ici avec ces filtres.';

  @override
  String get acAll => 'Tous';

  @override
  String get tsTitle => 'Mode Test — bats le meta';

  @override
  String get tsIntro =>
      'Choisis contre quel deck du meta tu veux jouer. ManaForge construit des decks avec TES cartes, simule des centaines de parties contre lui et garde celui qui gagne le plus — en testant en plus les changements de carte un par un pour l\'affiner.';

  @override
  String get tsLoadingMeta => 'Chargement du meta…';

  @override
  String get tsLocalPresets => 'Presets locaux (hors connexion)';

  @override
  String get tsNoDeckToFace =>
      'Avec tes cartes actuelles, je n\'arrive à aucun deck complet à lui opposer. Ajoute des cartes et réessaie.';

  @override
  String tsSimFailed(String error) {
    return 'Je n\'ai pas pu simuler : $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota du meta';
  }

  @override
  String get tsSimulating =>
      'Simulation des parties… (quelques secondes ; tout sur ta machine)';

  @override
  String tsFindBest(String meta) {
    return 'Chercher mon meilleur deck contre $meta';
  }

  @override
  String get tsHonesty =>
      'Soyons honnêtes : la simulation comprend les couleurs de mana, les mulligans, l\'évasion (vol, piétinement, contact mortel…), le removal à vitesse d\'éphémère et la contremagie — mais pas le texte complet de chaque carte. Le pourcentage sert à COMPARER tes decks entre eux, pas comme prédiction exacte.';

  @override
  String tsChampion(String meta) {
    return 'Ton champion contre $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'de victoires estimées · $mazos decks testés · $partidas parties par deck';
  }

  @override
  String get tsNoDominant =>
      'Aucun deck de ta collection ne domine ce matchup — celui-ci est celui qui se bat le mieux. Regarde ses points faibles dans le détail.';

  @override
  String get tsSeeDeck => 'Voir le deck complet (et l\'enregistrer)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total succès · $xp XP pour le niveau $nivel';
  }

  @override
  String get hsForgeDecks => 'Forger des decks';

  @override
  String get hsTestYourself => '⚔ mets-toi à l\'épreuve';

  @override
  String get bgCustom => 'Sur mesure';

  @override
  String get bgPickCustom => 'Choisir une couleur sur mesure';

  @override
  String get bgCustomColor => 'Couleur sur mesure';

  @override
  String get bgSampleTab => 'Rouge';

  @override
  String get cfSortRecent => 'Juste ajoutées';

  @override
  String get cfSortAlpha => 'Nom A-Z';

  @override
  String get cfSortCmc => 'Coût';

  @override
  String get cfSortQty => 'Quantité';

  @override
  String get cfSortBy => 'Trier par';

  @override
  String get cfSort => 'Tri';

  @override
  String get cfClear => 'Effacer';

  @override
  String get cfCost => 'Coût';

  @override
  String get cfCostAll => 'Coût : tous';

  @override
  String cfCostN(String n) {
    return 'Coût $n';
  }

  @override
  String get cfType => 'Type';

  @override
  String get cfTypeAll => 'Type : tous';

  @override
  String get cfTypeCreature => 'Créatures';

  @override
  String get cfTypeInstant => 'Éphémères';

  @override
  String get cfTypeSorcery => 'Rituels';

  @override
  String get cfTypeArtifact => 'Artefacts';

  @override
  String get cfTypeEnchantment => 'Enchantements';

  @override
  String get cfTypeLand => 'Terrains';

  @override
  String get cfPower => 'Force';

  @override
  String get cfPowerAll => 'Force : toutes';

  @override
  String cfPowerMin(int n) {
    return 'Force ≥ $n';
  }

  @override
  String get cfToughness => 'Endurance';

  @override
  String get cfToughnessAll => 'Endurance : toutes';

  @override
  String cfToughnessMin(int n) {
    return 'Endurance ≥ $n';
  }

  @override
  String get cfNoDate => 'sans date';

  @override
  String get cfToday => 'aujourd\'hui';

  @override
  String get cfYesterday => 'hier';

  @override
  String cfDaysAgo(int n) {
    return 'il y a $n jours';
  }

  @override
  String get pcWeek => 'Semaine';

  @override
  String get pcMonth => 'Mois';

  @override
  String get pcAll => 'Tout';

  @override
  String get vpTapCorrect => 'Touche la bonne carte';

  @override
  String get achCopias1 => 'La première d\'une longue série';

  @override
  String get achCopias10 => 'J\'en voulais juste une';

  @override
  String get achCopias50 => 'Ça ne tient plus dans une main';

  @override
  String get achCopias100 => 'Cent, et ça continue';

  @override
  String get achCopias500 => 'La boîte devient trop petite';

  @override
  String get achCopias1000 => 'Mille. Et je les veux toutes';

  @override
  String get achCopias5000 => 'C\'est devenu un entrepôt';

  @override
  String get achCopias10000 => 'Dix mille, mais je gère';

  @override
  String achCopiasDesc(String n) {
    return 'Avoir $n cartes dans ta collection.';
  }

  @override
  String get achDistintas25 => 'Ça commence à varier';

  @override
  String get achDistintas100 => 'Cent visages différents';

  @override
  String get achDistintas500 => 'Une demi-bibliothèque';

  @override
  String get achDistintas1000 => 'Encyclopédie ambulante';

  @override
  String get achDistintas2500 => 'Je ne les connais plus toutes';

  @override
  String get achDistintas5000 => 'Les archives';

  @override
  String achDistintasDesc(String n) {
    return 'Avoir $n cartes DIFFÉRENTES (les doublons ne comptent pas).';
  }

  @override
  String get achPlaysets1 => 'Carré d\'as';

  @override
  String get achPlaysets20 => 'Vingt playsets, zéro deck';

  @override
  String get achPlaysets1Desc => 'Avoir 4 exemplaires d\'une même carte.';

  @override
  String get achPlaysets20Desc =>
      'Avoir 20 playsets différents (4 exemplaires de chacun).';

  @override
  String get achComunes10 => 'Celles dont personne ne veut';

  @override
  String get achComunes50 => 'Le tas habituel';

  @override
  String get achComunes200 => 'Roi du tas';

  @override
  String get achComunes500 => 'Marée de communes';

  @override
  String achComunesDesc(String n) {
    return 'Avoir $n cartes communes différentes.';
  }

  @override
  String get achInfrecuentes10 => 'Un cran au-dessus de commune';

  @override
  String get achInfrecuentes50 => 'Argent fin';

  @override
  String get achInfrecuentes200 => 'Chasseur de peu communes';

  @override
  String get achInfrecuentes500 => 'De l\'argent à la pelle';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Avoir $n cartes peu communes différentes.';
  }

  @override
  String get achRaras5 => 'Ça sonne bien à l\'ouverture du booster';

  @override
  String get achRaras25 => 'Un coffre à rares';

  @override
  String get achRaras100 => 'Cent rares et pas une jouable';

  @override
  String get achRaras300 => 'La chambre forte';

  @override
  String achRarasDesc(String n) {
    return 'Avoir $n cartes rares différentes.';
  }

  @override
  String get achMiticas1 => 'Ma première mythique';

  @override
  String get achMiticas10 => 'Dix mythiques';

  @override
  String get achMiticas50 => 'Collectionneur mythique';

  @override
  String get achMiticas150 => 'Panthéon mythique';

  @override
  String achMiticasDesc(String n) {
    return 'Avoir $n cartes mythiques différentes.';
  }

  @override
  String get achBlancas25 => 'L\'ordre règne';

  @override
  String get achBlancas100 => 'Armée d\'argent';

  @override
  String achBlancasDesc(String n) {
    return 'Avoir $n cartes blanches différentes.';
  }

  @override
  String get achAzules25 => 'Ça, je te l\'interdis';

  @override
  String get achAzules100 => 'Tour d\'ivoire';

  @override
  String achAzulesDesc(String n) {
    return 'Avoir $n cartes bleues différentes.';
  }

  @override
  String get achNegras25 => 'Pacte obscur';

  @override
  String get achNegras100 => 'Seigneur de la crypte';

  @override
  String achNegrasDesc(String n) {
    return 'Avoir $n cartes noires différentes.';
  }

  @override
  String get achRojas25 => 'On brûle tout';

  @override
  String get achRojas100 => 'Incendie général';

  @override
  String achRojasDesc(String n) {
    return 'Avoir $n cartes rouges différentes.';
  }

  @override
  String get achVerdes25 => 'Une pousse';

  @override
  String get achVerdes100 => 'La forêt entière';

  @override
  String achVerdesDesc(String n) {
    return 'Avoir $n cartes vertes différentes.';
  }

  @override
  String get achIncoloras25 => 'Métal froid';

  @override
  String get achIncoloras100 => 'Forge éternelle';

  @override
  String achIncolorasDesc(String n) {
    return 'Avoir $n cartes incolores différentes.';
  }

  @override
  String get achArcoiris => 'Les cinq couleurs';

  @override
  String get achArcoirisDesc =>
      'Avoir au moins une carte de chacune des 5 couleurs.';

  @override
  String get achMulticolor10 => 'On mélange les couleurs';

  @override
  String get achMulticolor50 => 'Alliance dorée';

  @override
  String achMulticolorDesc(String n) {
    return 'Avoir $n cartes multicolores différentes.';
  }

  @override
  String get achCincocolores => 'Les cinq d\'un coup';

  @override
  String get achCincocoloresDesc => 'Avoir une carte qui a les cinq couleurs.';

  @override
  String get achSets1 => 'Première extension';

  @override
  String get achSets5 => 'Cinq mondes';

  @override
  String get achSets10 => 'Planeswalker en formation';

  @override
  String get achSets25 => 'Globe-trotteur';

  @override
  String get achSets50 => 'La moitié du multivers';

  @override
  String achSetsDesc(String n) {
    return 'Avoir des cartes de $n extensions différentes.';
  }

  @override
  String get achSetscompletos1 => 'Pas une qui manque';

  @override
  String get achSetscompletos3 => 'Trois albums complets';

  @override
  String get achSetscompletos10 => 'Maître de l\'album';

  @override
  String get achSetscompletos1Desc =>
      'Compléter une extension entière dans l\'Album.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Compléter $n extensions entières.';
  }

  @override
  String get achAnyos5 => 'Cinq ans de carton';

  @override
  String get achAnyos15 => 'Machine à remonter le temps';

  @override
  String achAnyosDesc(String n) {
    return 'Avoir des cartes de $n années de sortie différentes.';
  }

  @override
  String get achValor10 => 'Premiers euros';

  @override
  String get achValor50 => 'La tirelire';

  @override
  String get achValor250 => 'Voilà l\'argent de poche';

  @override
  String get achValor1000 => 'Voilà tout mon argent';

  @override
  String get achValor5000 => 'Ne le dis à personne';

  @override
  String get achValor10000 => 'Ça vaut plus que ma voiture';

  @override
  String get achValor25000 => 'Collection de musée';

  @override
  String achValorDesc(String n) {
    return 'Faire en sorte que ta collection vaille $n € ou plus.';
  }

  @override
  String get achJoya20 => 'Une carte des bonnes';

  @override
  String get achJoya100 => 'Le joyau de la collection';

  @override
  String get achJoya500 => 'Celle-là ne sort pas de sa pochette';

  @override
  String get achJoya1000 => 'Mille euros dans une seule pochette';

  @override
  String get achJoya2500 => 'Le Saint Graal';

  @override
  String achJoyaDesc(String n) {
    return 'Avoir une seule carte qui vaut $n € ou plus.';
  }

  @override
  String get achFoils1 => 'Premier éclat';

  @override
  String get achFoils10 => 'Ça scintille';

  @override
  String get achFoils50 => 'La boîte brille';

  @override
  String get achFoils200 => 'Plus rien de mat par ici';

  @override
  String get achFoils500 => 'Tout brille';

  @override
  String get achFoils1000 => 'Usine à paillettes';

  @override
  String achFoilsDesc(String n) {
    return 'Avoir $n cartes foil.';
  }

  @override
  String get achFoiljoya10 => 'Une foil des bonnes';

  @override
  String get achFoiljoya50 => 'Une foil qui coûte cher';

  @override
  String get achFoiljoya200 => 'Une foil de musée';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Avoir une foil qui vaut $n € ou plus.';
  }

  @override
  String get achFoilvalor50 => 'Une vitrine qui brille';

  @override
  String get achFoilvalor250 => 'Vitrine hors de prix';

  @override
  String get achFoilvalor1000 => 'Mille euros de brillance';

  @override
  String get achFoilvalor5000 => 'Vitrine de musée';

  @override
  String achFoilvalorDesc(String n) {
    return 'Faire en sorte que toutes tes foils réunies valent $n € ou plus.';
  }

  @override
  String get achMazos1 => 'Premier deck';

  @override
  String get achMazos5 => 'Cinq decks enregistrés';

  @override
  String get achMazos25 => 'L\'atelier ne s\'arrête jamais';

  @override
  String achMazosDesc(String n) {
    return 'Enregistrer $n decks faits avec Forge.';
  }

  @override
  String get achMazoscore => 'Un deck bien rond';

  @override
  String get achMazoscoreDesc => 'Générer un deck avec un score de 90 ou plus.';

  @override
  String get achMazocolores3 => 'Tricolore';

  @override
  String get achMazocolores5 => 'Arc-en-ciel jouable';

  @override
  String achMazocoloresDesc(String n) {
    return 'Enregistrer un deck de $n couleurs.';
  }

  @override
  String get achMazomono => 'Sans rien mélanger';

  @override
  String get achMazomonoDesc => 'Enregistrer un deck monocolore.';

  @override
  String get achMazocommander => 'Aux commandes';

  @override
  String get achMazocommanderDesc => 'Enregistrer un deck Commander.';

  @override
  String get achEscaneadas1 => 'Premier scan';

  @override
  String get achEscaneadas50 => 'Main rapide';

  @override
  String get achEscaneadas500 => 'Scan à la chaîne';

  @override
  String get achEscaneadas2000 => 'Je scanne même en dormant';

  @override
  String achEscaneadasDesc(String n) {
    return 'Scanner $n cartes avec la caméra ou depuis une photo.';
  }

  @override
  String get achFoto9 => 'Une page entière en une photo';

  @override
  String get achFoto20 => 'Vingt d\'un coup';

  @override
  String achFotoDesc(String n) {
    return 'Reconnaître $n cartes sur une seule photo.';
  }

  @override
  String get achEscaneoperfecto => 'Pas une seule à revoir';

  @override
  String get achEscaneoperfectoDesc =>
      'Scanner une page entière sans laisser une seule carte à revoir.';

  @override
  String get achDias2 => 'Te revoilà';

  @override
  String get achDias7 => 'Une semaine ici';

  @override
  String get achDias30 => 'Un mois ici';

  @override
  String get achDias100 => 'Cent jours ici';

  @override
  String achDiasDesc(String n) {
    return 'Utiliser ManaForge $n jours différents.';
  }

  @override
  String get achRacha3 => 'Trois d\'affilée';

  @override
  String get achRacha7 => 'Semaine parfaite';

  @override
  String get achRacha30 => 'Un mois sans en rater un';

  @override
  String achRachaDesc(String n) {
    return 'Venir $n jours d\'affilée.';
  }

  @override
  String get achSemanas => 'Quatre semaines sans manquer à l\'appel';

  @override
  String get achSemanasDesc => 'Utiliser ManaForge 4 semaines d\'affilée.';

  @override
  String get achCarpetas1 => 'Le rangement commence';

  @override
  String get achCarpetas5 => 'Tout est classé';

  @override
  String achCarpetasDesc(String n) {
    return 'Créer $n dossiers.';
  }

  @override
  String get achCarpetagrande => 'Un sacré dossier';

  @override
  String get achCarpetagrandeDesc =>
      'Avoir un dossier avec 100 cartes ou plus.';

  @override
  String get achCarpetavalor => 'Ce dossier, je ne le prête pas';

  @override
  String get achCarpetavalorDesc => 'Avoir un dossier qui vaut 100 € ou plus.';

  @override
  String get achTierrasbasicas => 'Les cinq de base';

  @override
  String get achTierrasbasicasDesc =>
      'Avoir les cinq types de terrain de base (Plaine, Île, Marais, Montagne et Forêt).';

  @override
  String get achFuerza => 'Quelle bestiole';

  @override
  String get achFuerzaDesc => 'Avoir une créature de force 10 ou plus.';

  @override
  String get achCoste => 'Celle-là, je ne la lancerai jamais';

  @override
  String get achCosteDesc =>
      'Avoir une carte de coût converti de mana 10 ou plus.';

  @override
  String get achCostecero => 'Gratuit';

  @override
  String get achCosteceroDesc => 'Avoir une carte de coût 0.';

  @override
  String get achTipos => 'Un peu de tout';

  @override
  String get achTiposDesc =>
      'Avoir au moins une créature, un éphémère, un rituel, un artefact, un enchantement, un terrain et un planeswalker.';

  @override
  String get achPlaneswalkers => 'Une brigade de planeswalkers';

  @override
  String get achPlaneswalkersDesc => 'Avoir 5 planeswalkers différents.';

  @override
  String get achNoventas => 'Relique des années 90';

  @override
  String get achNoventasDesc => 'Avoir une carte des années 90.';

  @override
  String get achIdiomas1 => 'Celle-là, je ne sais pas la lire';

  @override
  String get achIdiomas25 => 'Collection polyglotte';

  @override
  String get achIdiomas1Desc =>
      'Avoir une carte dans une langue autre que l\'anglais.';

  @override
  String get achIdiomas25Desc => 'Avoir 25 cartes dans d\'autres langues.';

  @override
  String get achWishlist => 'La liste des envies folles';

  @override
  String get achWishlistDesc => 'Noter 20 cartes dans la wishlist.';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Argent';

  @override
  String get achTierGold => 'Or';

  @override
  String get achTierMythic => 'Mythique';

  @override
  String get achCatCollection => 'Collection';

  @override
  String get achCatRarity => 'Raretés';

  @override
  String get achCatColor => 'Couleurs';

  @override
  String get achCatSets => 'Extensions';

  @override
  String get achCatValue => 'Valeur';

  @override
  String get achCatFoils => 'Foils';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Scanner';

  @override
  String get achCatDedication => 'Assiduité';

  @override
  String get achCatFolders => 'Dossiers';

  @override
  String get achCatCuriosities => 'Curiosités';

  @override
  String get achRankApprentice => 'Apprenti';

  @override
  String get achRankSummoner => 'Invocateur';

  @override
  String get achRankMage => 'Mage';

  @override
  String get achRankArchmage => 'Archimage';

  @override
  String get achRankMaster => 'Maître';

  @override
  String get achRankPlaneswalker => 'Planeswalker';

  @override
  String get bkConfirmWord => 'CONFIRMER';

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
    return 'Impossible de télécharger la base de cartes (HTTP $codigo). Réessaie dans un moment.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'Impossible de télécharger la base d\'empreintes (HTTP $codigo). Réessaie dans un moment.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'Impossible de télécharger l\'historique des prix (HTTP $codigo). Réessaie dans un moment.';
  }

  @override
  String ddCardCount(int n) {
    return '$n cartes';
  }

  @override
  String get ddForgedWith => 'Forgé avec ManaForge';

  @override
  String get fxThemeLifegain => 'drain de vie';

  @override
  String get fxThemeSacrifice => 'sacrifice';

  @override
  String get fxThemeSpells => 'sorts';

  @override
  String get fxThemeArtifacts => 'artefacts';

  @override
  String get fxThemeCounters => 'marqueurs +1/+1';

  @override
  String get fxThemeTokens => 'nuée';

  @override
  String get fxThemeGraveyard => 'cimetière';

  @override
  String get fxThemeReanimator => 'réanimation';

  @override
  String fxThemeTribal(String tribe) {
    return 'tribu $tribe';
  }

  @override
  String get fxThemeGoodstuff => 'le meilleur de tes cartes';

  @override
  String get fxTagLifegain =>
      'Chaque point de vie que tu gagnes leur fait mal : draine et tiens bon.';

  @override
  String get fxTagSacrifice =>
      'Tes créatures valent plus mortes que vivantes : sacrifie-les et encaisse.';

  @override
  String get fxTagSpells =>
      'Chaque éphémère compte : joue pendant leur tour et punis.';

  @override
  String get fxTagArtifacts =>
      'Monte ton atelier : chaque artefact rend les autres plus forts.';

  @override
  String get fxTagCounters =>
      'Marqueurs +1/+1 : tes créatures grossissent jusqu\'à devenir intouchables.';

  @override
  String get fxTagTokens =>
      'Inonde le board de jetons : là où ils en ont un, tu en as cinq.';

  @override
  String get fxTagGraveyard =>
      'Ton cimetière est ta deuxième main : remplis-le et recycle le meilleur.';

  @override
  String get fxTagAggro =>
      'Sors vite et tape-leur dans la face : la partie devrait finir tôt.';

  @override
  String get fxTagTempo =>
      'Mets la pression tôt et protège ton avance avec tes sorts.';

  @override
  String fxTagMidrange(String tema) {
    return 'Échange bien tes cartes et gagne le milieu de partie avec $tema.';
  }

  @override
  String get fxTagControl =>
      'Tiens bon, réponds à tout et achève-les quand le board est à toi.';

  @override
  String get fxMidLifegain =>
      'Enchaîne tes sources de gain de vie avec les cartes qui les punissent pour ça.';

  @override
  String get fxMidSacrifice =>
      'Sacrifie ce qui ne coûte rien pour piocher, drainer ou faire grossir le reste.';

  @override
  String get fxMidSpells =>
      'Garde du mana ouvert : tes créatures grossissent à chaque sort que tu lances.';

  @override
  String get fxMidArtifacts =>
      'Déploie des artefacts pas chers et allume ceux qui les comptent.';

  @override
  String get fxMidCounters =>
      'Empile les marqueurs sur une ou deux créatures et protège-les.';

  @override
  String get fxMidTokens =>
      'Fabrique des jetons chaque tour et cherche les effets qui les grossissent.';

  @override
  String get fxMidGraveyard =>
      'Meule et défausse exprès : ce qui tombe au cimetière revient.';

  @override
  String get fxEndLifegain =>
      'Avec la vie haute, passe en mode agressif : ils n\'y arrivent plus.';

  @override
  String get fxEndSacrifice =>
      'La valeur accumulée te donne la partie : chaque échange est gratuit pour toi.';

  @override
  String get fxEndSpells =>
      'Deux sorts dans le même tour et tes créatures concluent.';

  @override
  String get fxEndArtifacts =>
      'Ton board vaut le double du leur : achève avec tes payoffs.';

  @override
  String get fxEndCounters =>
      'Une menace énorme et protégée finit la partie en deux coups.';

  @override
  String get fxEndTokens =>
      'Attaque en masse : aucun blocage ne tient face à toute ton armée.';

  @override
  String get fxEndGraveyard =>
      'Rejoue tes meilleures cartes : tu joues avec deux mains contre une.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => 'Pose une créature chaque tour, sans exception.';

  @override
  String get fxAggroMid =>
      'Continue d\'attaquer ; garde le burn pour dégager les bloqueurs.';

  @override
  String get fxAggroLate =>
      'Envoie tout : c\'est ici que tu dois refermer la partie.';

  @override
  String get fxTempoEarly =>
      'Une menace pas chère et du mana ouvert dès que tu peux.';

  @override
  String get fxTempoMid =>
      'Attaque et lance tes sorts pendant le tour du rival.';

  @override
  String get fxTempoLate =>
      'Protège tes créatures et conclus par les airs ou au burn.';

  @override
  String get fxMidrangeEarly =>
      'Développe et ne donne pas de cartes : de bons échanges un pour un.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Déploie tes moteurs de $tema et stabilise le board.';
  }

  @override
  String get fxMidrangeLate =>
      'Tes cartes valent plus que les siennes : transforme ça en victoire.';

  @override
  String get fxControlEarly =>
      'Un terrain par tour, et ne réponds qu\'à ce qui compte.';

  @override
  String get fxControlMid =>
      'Nettoie le board et pioche : le temps joue pour toi.';

  @override
  String get fxControlLate => 'Pose une menace et protège-la jusqu\'au bout.';

  @override
  String get fxArchetypeAggro => 'aggro';

  @override
  String get fxArchetypeTempo => 'tempo';

  @override
  String get fxArchetypeMidrange => 'midrange';

  @override
  String get fxArchetypeControl => 'control';

  @override
  String fxWhyItWorks(
    String coste,
    String tierras,
    String arquetipo,
    int criaturas,
    int interaccion,
    String tema,
  ) {
    return 'Coût moyen $coste : d\'après la règle de Karsten (24 terrains à un coût de 3.0, ±1 par ±0.5), ce deck joue $tierras terrains — dans la fourchette d\'un deck $arquetipo. Il y a $criaturas créatures pour tenir le board et $interaccion cartes d\'interaction pour ce que le rival amènera. Le thème ($tema) concentre tes synergies : plus tu vois de pièces du thème, plus chacune est forte.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'Avec cette courbe, ça donne $tierras terrains : hors de la fourchette saine ($min-$max). Ajuste le total de sorts.';
  }

  @override
  String get fxNoCards =>
      'Ta collection n\'a pas assez de cartes dans ces couleurs pour remplir cette courbe. Essaie avec moins de sorts ou avec d\'autres coûts.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'Cette courbe (coût moyen $coste avec $tierras terrains) ne colle à aucun profil sain : un deck bon marché veut moins de terrains et un deck cher en veut plus. Rapproche-les.';
  }

  @override
  String get fxNoBasics =>
      'Il n\'y a pas assez de terrains de base dans la collection pour cette courbe.';

  @override
  String fxHardRule(String detalle) {
    return 'La courbe demandée casse une règle dure : $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Créatures pas chères et dégâts dans la face : il te tue en 4-5 tours si tu ne suis pas le rythme.';

  @override
  String get tsPresetAzorius =>
      'Contremagie, wraths et pioche : il fait traîner la partie et gagne avec deux ou trois finishers.';

  @override
  String get tsPresetGolgari =>
      'Échanges un pour un, créatures efficaces et removal noir : il gagne le jeu long à la qualité des cartes.';
}
