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
}
