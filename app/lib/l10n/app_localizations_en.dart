// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabCollection => 'Collection';

  @override
  String get tabAlbum => 'Album';

  @override
  String get tabDecks => 'Decks';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'Market';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabScan => 'Scan';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsIntro =>
      'ManaForge is free and its code is out in the open (PolyForm Noncommercial licence: share it and tinker with it all you like, just don\'t sell it). No ads, no premium, no accounts. Your cards are yours.';

  @override
  String get howItWorks => 'How it works';

  @override
  String get howScan =>
      'Hold cards up to the webcam or drop in a photo: they land in your collection with the exact printing.';

  @override
  String get howCollection =>
      'Everything you own, with search, filters and folders (folders are tags: a card can be in several).';

  @override
  String get howAlbum =>
      'One page per set, like a sticker album: what you own in colour, what\'s missing greyed out, and what completing it would cost.';

  @override
  String get howForge =>
      'Complete, legal decks from your cards. Or from a set you don\'t own yet, telling you what to buy and what it costs.';

  @override
  String get howDecks =>
      'The ones you save. If you sell a card, the deck says so instead of pretending you still have it.';

  @override
  String get howMarket =>
      'What your collection is worth, its chart, your wishlist with price alerts, and — if your CSV had purchase prices — how much you\'re up or down.';

  @override
  String get howPrivacy =>
      'Everything is worked out on your device. The only things that go online are the databases and, if you leave it on, checking whether there\'s a new version.';

  @override
  String get shortcuts => 'Keyboard shortcuts';

  @override
  String get shortcutTabs => 'Switch tab';

  @override
  String get shortcutScan => 'Open the scanner';

  @override
  String get shortcutSearch => 'Search in the tab you\'re on';

  @override
  String get shortcutSettings => 'Settings';

  @override
  String get shortcutClose => 'Close whatever is open on top';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Match the system';

  @override
  String get languagePartial =>
      'The app is being translated in stages: the shell is already in your language, the rest of the screens are still in Spanish for now.';

  @override
  String get versionTitle => 'ManaForge version';

  @override
  String versionYouHave(String version) {
    return 'You\'re on $version.';
  }

  @override
  String get versionSeeWhatsNew => 'See what\'s in it';

  @override
  String get versionNotifyMe => 'Tell me about new versions';

  @override
  String get versionNotifyMeWhy =>
      'Asks GitHub once a day which version is the latest. It doesn\'t download or install anything.';

  @override
  String get versionCheckNow => 'Check now';

  @override
  String get versionUpToDate =>
      'You\'re on the latest version (or GitHub isn\'t answering right now).';

  @override
  String versionThereIs(String version) {
    return 'ManaForge $version is out.';
  }

  @override
  String get versionGoDownload => 'Go to the download';

  @override
  String versionNotAuto(String version) {
    return 'You\'re on $version. The app doesn\'t update itself: it takes you to the download.';
  }

  @override
  String get versionNotNow => 'Not now';

  @override
  String get versionSee => 'See';

  @override
  String whatsNewTitle(String version) {
    return 'What\'s new in $version';
  }

  @override
  String get whatsNewClose => 'Let\'s play';

  @override
  String get downloadCopyLink => 'Copy link';

  @override
  String get downloadClose => 'Close';

  @override
  String get downloadTitle => 'Download ManaForge';

  @override
  String get backgroundTitle => 'Wallpaper';

  @override
  String get backgroundWhat =>
      'Put any image you like behind the app. Wizards publishes official wallpapers for every set: download the one you want and pick it here. The app doesn\'t fetch them for you — that art has an owner and handing it out isn\'t its place.';

  @override
  String get backgroundPick => 'Choose an image…';

  @override
  String get backgroundChange => 'Change image…';

  @override
  String get backgroundOfficial => 'Official Magic wallpapers';

  @override
  String get backgroundRemove => 'Remove wallpaper';

  @override
  String get backgroundDim => 'How much it dims (so the text stays readable)';

  @override
  String get backgroundCardColor => 'Card colour';

  @override
  String get backgroundTextColor => 'Text colour';

  @override
  String get backgroundCardOpacity => 'How much cards cover the wallpaper';

  @override
  String get backgroundColorDefault => 'The usual one';

  @override
  String get backgroundPreview => 'How it looks';

  @override
  String get backgroundNotAnImage =>
      'Pick an image (.jpg, .png or .webp) as the wallpaper.';

  @override
  String get backgroundTooBig => 'That image is too big to use as a wallpaper.';

  @override
  String get welcomeTitle =>
      'Welcome to the forge. Get your cards in however you like — or try Forge before adding any.';

  @override
  String get welcomeScan => 'Scan my cards';

  @override
  String get welcomeImport => 'Import CSV (ManaBox)';

  @override
  String get welcomeTryForge => 'Try Forge with no collection';

  @override
  String get decksEmptyGoForge => 'Go to Forge';

  @override
  String get yourCollection => 'Your collection';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies cards · $distinct distinct';
  }

  @override
  String get marketArrow => 'Market ›';

  @override
  String get certHeadingSetComplete => 'COMPLETE COLLECTION CERTIFICATE';

  @override
  String get certSubtitleSetComplete => 'Complete set';

  @override
  String get certHeadingWelcome => 'WELCOME CERTIFICATE';

  @override
  String get certWelcomeTitle => 'Welcome to the world of Magic';

  @override
  String get certSubtitleWelcome => 'Your first card';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return 'I started with $name';
  }

  @override
  String get certCollectorAnon => 'ManaForge collector';

  @override
  String certAwardedTo(String name) {
    return 'Awarded to $name';
  }

  @override
  String certOnDate(String date) {
    return 'on $date';
  }

  @override
  String get certDataBy => 'Data by Scryfall';

  @override
  String get onbCollectionTitle => 'Your collection';

  @override
  String get onbCollectionBody =>
      'All your cards live here, in folders and by set.';

  @override
  String get onbScanTitle => 'Scan cards';

  @override
  String get onbScanBody => 'Add new cards with the camera or a photo.';

  @override
  String get onbForgeTitle => 'Forge decks';

  @override
  String get onbForgeBody =>
      'Build complete decks from the cards you already own.';

  @override
  String get onbDecksTitle => 'Your decks';

  @override
  String get onbDecksBody => 'Decks you save from Forge show up here.';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbNext => 'Next';

  @override
  String get onbGotIt => 'Got it';

  @override
  String get onbBack => 'Back';

  @override
  String get tourMenuTitle => 'Guides';

  @override
  String get tourWelcomeName => 'Quick tour';

  @override
  String get tourHomeName => 'The home screen';

  @override
  String get onbEditHomeTitle => 'Customize your home';

  @override
  String get onbEditHomeBody =>
      'This button lets you pick which sections show on Home and in what order.';

  @override
  String get onbLangTitle => 'Language';

  @override
  String get onbLangBody => 'Change the whole app\'s language here.';

  @override
  String get onbLookTitle => 'Look';

  @override
  String get onbLookBody =>
      'Set a wallpaper and pick the colors of cards, text, tabs and icons.';

  @override
  String get tourSettingsName => 'Customize the app';

  @override
  String get tourFullName => 'Full tour of the app';

  @override
  String get tourCollectionName => 'Your collection and folders';

  @override
  String get tourForgeName => 'Forge a deck';

  @override
  String get tourMarketName => 'Market, wishlist and alerts';

  @override
  String get onbAllCardsTitle => 'All cards';

  @override
  String get onbAllCardsBody =>
      'Your whole collection: search, filter and sort.';

  @override
  String get onbFoldersTitle => 'Folders';

  @override
  String get onbFoldersBody =>
      'Folders are tags: group whatever you like, and a card can sit in several. \"New\" creates your first one.';

  @override
  String get onbAlbumMineTitle => 'The album by set';

  @override
  String get onbAlbumMineBody =>
      'Every set with its slots. This filter shows only the sets where you already own cards.';

  @override
  String get onbForgeBasicsTitle => 'Basic lands';

  @override
  String get onbForgeBasicsBody =>
      'If you have loose basics at home, leave this on and Forge will count on them. Turn it off to use only the ones in your collection.';

  @override
  String get onbForgeSetsTitle => 'Sets';

  @override
  String get onbForgeSetsBody =>
      'Narrow down where the cards come from. With none selected, Forge uses your whole collection.';

  @override
  String get onbForgeMissingTitle => 'Cards you don\'t own';

  @override
  String get onbForgeMissingBody =>
      'Turn this on and Forge also suggests cards you\'re missing, telling you how many and what they\'d cost.';

  @override
  String get onbForgeGoTitle => 'Forge';

  @override
  String get onbForgeGoBody =>
      'This button builds the decks. With many sets it takes a few seconds.';

  @override
  String get onbForgeTestTitle => 'Test mode';

  @override
  String get onbForgeTestBody =>
      'Pit your deck against a meta deck and see what it needs to beat it.';

  @override
  String get onbMarketPickTitle => 'Pick a market';

  @override
  String get onbMarketPickBody =>
      'Cardmarket or TCGplayer: it changes every card\'s price and its chart.';

  @override
  String get onbWishlistTitle => 'Wishlist';

  @override
  String get onbWishlistBody =>
      'The cards you want. The counter turns green when one hits your price.';

  @override
  String get onbPriceAlertTitle => 'Price alert';

  @override
  String get onbPriceAlertBody =>
      'Search a card, tap the bookmark to add it to your wishlist and set a target price: the app tells you when it drops.';
}
