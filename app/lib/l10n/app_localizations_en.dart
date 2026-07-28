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
  String get onbForgeDeepTitle => 'Deep forge';

  @override
  String get onbForgeDeepBody =>
      'Before showing you the proposals, it makes them actually play against each other: the final order weighs how they perform, not just their static score. Turn it off if you\'d rather have faster results.';

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

  @override
  String get tourProgressName => 'Achievements and certificates';

  @override
  String get onbAchievementsTitle => 'Achievements and level';

  @override
  String get onbAchievementsBody =>
      'Your level and everything you\'ve earned so far. It goes up as you scan, tidy and forge.';

  @override
  String get onbCertificatesTitle => 'Certificates';

  @override
  String get onbCertificatesBody =>
      'The big milestones come as a diploma you can save as a PDF or show off. They live inside Achievements.';

  @override
  String get onbBackupTitle => 'Backup';

  @override
  String get onbBackupBody =>
      'Save your collection, decks and folders to a file, and get them back if you switch computers. There\'s also an automatic weekly backup.';

  @override
  String onbTapHere(String pantalla) {
    return 'Tap here to open $pantalla.';
  }

  @override
  String get onbAchievementsName => 'Achievements';

  @override
  String get onbDataSectionTitle => 'Data';

  @override
  String get onbDataSectionBody =>
      'Everything the app stores lives here: the card database and your backups.';

  @override
  String get onbCardDbTitle => 'Card database';

  @override
  String get onbCardDbBody =>
      'Download it again for new cards, fresh prices and anything that needs recent data, like Forge\'s year filter.';

  @override
  String get onbAboutTitle => 'The app';

  @override
  String get onbAboutBody =>
      'What each tab does, the keyboard shortcuts, the version and the licence.';

  @override
  String get colStartHere => 'Your collection starts here';

  @override
  String get colNeedDb =>
      'First I need the database with every Magic card (it downloads once and after that everything works offline).';

  @override
  String colDownloading(String pct) {
    return 'Downloading… $pct%';
  }

  @override
  String get colDownloadDb => 'Download the card database';

  @override
  String get colScryfall =>
      'Data and images by Scryfall · No accounts, no payments: everything stays on your device.';

  @override
  String get colAlbumTooltip => 'Album by set';

  @override
  String get colImportTooltip => 'Import a ManaBox CSV';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies cards · $distinct distinct$valor';
  }

  @override
  String get colAllCards => 'All cards';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct distinct · search, filter and sort';
  }

  @override
  String get colFolders => 'Folders';

  @override
  String get colNewFolder => 'New';

  @override
  String get colNoFolders =>
      'You don\'t have any folders yet. They group whatever you like: \"Aetherdrift rares\", \"to sell\", \"the box upstairs\"… A card can be in several.';

  @override
  String get colCreateFirstFolder => 'Create your first folder';

  @override
  String get colEmptyTitle => 'Your collection starts here';

  @override
  String get colEmptyBody =>
      'Scan your cards with the camera or import a ManaBox CSV. They\'ll show up here and in the album.';

  @override
  String get colImportShort => 'Import CSV';

  @override
  String acForgetTitle(String carta) {
    return 'You no longer have $carta?';
  }

  @override
  String get acForgetBody =>
      'It leaves your collection and its album slot goes empty again.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'It also leaves the $n folders it\'s in.',
      one: 'It also leaves the folder it\'s in.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Decks do NOT lose it: it stays in the list and the deck tells you it\'s missing.';

  @override
  String get acCancel => 'Cancel';

  @override
  String get acDelete => 'Delete';

  @override
  String get acForgetConfirm => 'I no longer have it';

  @override
  String acAddedOn(String cuando) {
    return 'added $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'in $n folders',
      one: 'in 1 folder',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Search for a card (Spanish or English)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles of $total cards';
  }

  @override
  String get acMissingFilterData =>
      ' · some older cards have no filter data: re-import your CSV with \"Replace\" on';

  @override
  String get acNoneMatch => 'No card matches these filters.';

  @override
  String get acEmptyHint =>
      'Search for your first card above, or go back and import your ManaBox CSV.';

  @override
  String get onbHowItWorksBody =>
      'A summary of what each tab does, plus the keyboard shortcuts. If you get lost, start here.';

  @override
  String get onbVersionBody =>
      'Which version you\'re on, what\'s in it, and whether the app should check once a day for a new one. It never updates itself.';

  @override
  String get onbSuggestionsTitle => 'Suggestion box';

  @override
  String get onbSuggestionsBody =>
      'Got an idea, or found a bug? Tell us on GitHub — there\'s a template and it takes a minute.';

  @override
  String get onbSupportTitle => 'Support the project';

  @override
  String get onbSupportBody =>
      'The app is free with no ads. If it\'s been useful, here\'s how to buy us a coffee.';

  @override
  String get onbScanSetTitle => 'Set: all';

  @override
  String get onbScanSetBody =>
      'If you\'re opening packs from ONE set, lock it here: the scanner stops hesitating between the ten reprints of the same card.';

  @override
  String get onbScanModeTitle => 'Fast or careful';

  @override
  String get onbScanModeBody =>
      'In \"Fast\", clear cards go in on their own and the doubtful ones get flagged for review. In \"Careful\" it stops and asks you which one it is.';

  @override
  String get onbScanPhotoTitle => 'Scan a photo';

  @override
  String get onbScanPhotoBody =>
      'No camera, or your cards already photographed? Drop a photo here — several cards in one shot is fine — and it pulls them out just the same.';

  @override
  String get tourScanName => 'The scanner';

  @override
  String get albNeedDb =>
      'The album needs the card database (download it in Collection).';

  @override
  String get albRetry => 'Try again';

  @override
  String get albApproxMode =>
      'Album in rough mode: I don\'t know yet which exact PRINTING you own of each card. Re-import your CSV with \"Replace my current collection\" on and the album will sharpen up by artwork.';

  @override
  String get albSearchSet => 'Search for a set…';

  @override
  String get albOnlyMine => 'With cards of mine';

  @override
  String get albSortProgress => 'Most complete';

  @override
  String get albSortNewest => 'Newest';

  @override
  String get albSortOldest => 'Oldest';

  @override
  String get albSortName => 'By name';

  @override
  String get albYearAll => 'Year: all';

  @override
  String get albLetterAll => 'All';

  @override
  String get albNoSets => 'No set matches the filter.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total cards';
  }

  @override
  String get albComplete => ' · ✓ complete!';

  @override
  String albLoadError(String error) {
    return 'Couldn\'t load the set: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Search in $set…';
  }

  @override
  String get albOnlyMissing => 'Only the missing ones';

  @override
  String get albWithVariants => 'With variants';

  @override
  String get albYouHaveItAll => '✓ You have it all';

  @override
  String albMissingCount(int n) {
    return 'You\'re missing $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n without a price)';
  }

  @override
  String albMarketNoToday(String market) {
    return '$market doesn\'t publish per-printing prices — switch markets to see them';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles of $total';
  }

  @override
  String get albNoCardsNamed => 'No card by that name here.';

  @override
  String get fdNewFolder => 'New folder';

  @override
  String get fdEditFolder => 'Edit folder';

  @override
  String get fdName => 'Name';

  @override
  String get fdNameHint => 'Aetherdrift rares, To sell…';

  @override
  String get fdColor => 'Colour';

  @override
  String get fdIcon => 'Icon';

  @override
  String get fdCreate => 'Create';

  @override
  String get fdSave => 'Save';

  @override
  String get fdDefaultName => 'Folder';

  @override
  String fdDeleteTitle(String nombre) {
    return 'Delete \"$nombre\"?';
  }

  @override
  String get fdDeleteBody =>
      'Only the folder goes: the cards stay in your collection.';

  @override
  String get fdDelete => 'Delete';

  @override
  String get fdGone => 'This folder is gone.';

  @override
  String get fdEditTooltip => 'Edit name, colour and icon';

  @override
  String get fdDeleteTooltip => 'Delete folder';

  @override
  String get fdAddRemove => 'Add or remove';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas distinct cards · $copias copies';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n match the filter';
  }

  @override
  String get fdRoughValue => ' · rough value';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n cards are no longer in your collection (they stay listed in case they come back).',
      one:
          '1 card is no longer in your collection (it stays listed in case it comes back).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Remove them';

  @override
  String get fdNoneMatch => 'No card in this folder matches these filters.';

  @override
  String get fdEmpty =>
      'Empty folder. Hit \"Add or remove\" and tick the cards you want in it.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n copies',
      one: '1 copy',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Remove from the folder';

  @override
  String get fpPickCards => 'Pick the cards';

  @override
  String fpSaveCount(int n) {
    return 'Save ($n)';
  }

  @override
  String get fpFilterByName => 'Filter by name…';

  @override
  String fpVisibleCards(int n) {
    return '$n cards in view';
  }

  @override
  String get fpSelectAll => 'Select all';

  @override
  String get fpNoneMatch => 'No card matches these filters.';

  @override
  String get fgMsgReading => 'Reading your collection…';

  @override
  String get fgMsgCurve => 'Working out the mana curve…';

  @override
  String get fgMsgLands => 'Dealing out lands…';

  @override
  String get fgMsgSynergy => 'Looking for synergies…';

  @override
  String get fgMsgPlan => 'Writing your game plan…';

  @override
  String get fgNeedDbForSets =>
      'I need the card database to list the sets: Settings → download the database.';

  @override
  String fgDbError(String error) {
    return 'Couldn\'t read the card database: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' in those $n sets',
      one: ' in that set',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'I can\'t put together a legal Commander deck$donde: it needs a legendary commander and ~62 DIFFERENT cards inside its colour identity (it\'s singleton), plus enough basics. Try another format, other sets, or grow your collection.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'With the cards in this pool I can\'t finish a $formato deck that meets my rules (enough lands and a healthy curve)$donde. $consejo Rather than hand you a broken deck, I\'d rather tell you.';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return 'With this Style ($estilo) no deck comes out. Try \"Style: auto\" or another tribe.';
  }

  @override
  String get fgOf60 => '60-card';

  @override
  String fgLegalIn(String formato) {
    return 'LEGAL in $formato';
  }

  @override
  String get fgTipMoreSets => 'Try more sets or drop some filters.';

  @override
  String get fgTipMoreCards =>
      'Add more cards — especially in your main colours — or tick \"include cards I don\'t own\".';

  @override
  String get fgPitch =>
      'Complete, playable decks from the cards you already own. Without buying anything.';

  @override
  String get fgTeaserCount => 'cards for your first deck';

  @override
  String get fgTeaserMissing => 'Build a deck with cards I don\'t own';

  @override
  String get fgBasics => 'I have loose basic lands';

  @override
  String get fgBasicsSub =>
      'Almost everyone has basics from starter decks; turn it off to use ONLY the basics in your collection.';

  @override
  String get fgFormat => 'Game format';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 cards · singleton · a legendary commander from your collection · colour identity respected.';

  @override
  String get fgCasualNote =>
      '60 cards, no legality restrictions: anything goes.';

  @override
  String fgFormatNote(String formato) {
    return '60 cards using ONLY your cards that are legal in $formato.';
  }

  @override
  String get fgWhereFrom => 'Where do the cards come from?';

  @override
  String get fgPickSets => 'Pick sets';

  @override
  String get fgChangeSets => 'Change sets';

  @override
  String get fgNeedOneSet =>
      'Pick at least one set: with no filter it\'d be all ~30,000 Magic cards.';

  @override
  String get fgNoSetsNote =>
      'With no sets picked, Forge uses your whole collection.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cards from $n sets, whether you own them or not.',
      one: 'Cards from 1 set, whether you own them or not.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Only your cards from $n sets — not the whole collection.',
      one: 'Only your cards from 1 set — not the whole collection.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'Your collection doesn\'t record each card\'s printing, so filtering by set would leave almost everything out. Re-import your CSV with \"Replace\" and come back.';

  @override
  String get fgIncludeMissing => 'Include cards I don\'t own';

  @override
  String get fgIncludeMissingSub =>
      'Forge stops limiting itself to your collection and uses EVERYTHING printed in those sets; afterwards it tells you how many cards you\'re missing and what they\'d cost.';

  @override
  String get fgYourTaste => 'Your call (optional)';

  @override
  String get fgArchetypeAuto => 'Archetype: auto';

  @override
  String get fgStyle => 'Style';

  @override
  String get fgStyleAuto => 'Style: auto';

  @override
  String get fgTribeElf => 'Elves';

  @override
  String get fgTribeGoblin => 'Goblins';

  @override
  String get fgTribeZombie => 'Zombies';

  @override
  String get fgTribeVampire => 'Vampires';

  @override
  String get fgTribeDragon => 'Dragons';

  @override
  String get fgTribeAngel => 'Angels';

  @override
  String get fgTribeDemon => 'Demons';

  @override
  String get fgTribeDinosaur => 'Dinosaurs';

  @override
  String get fgTribeFaerie => 'Faeries';

  @override
  String get fgTribeMerfolk => 'Merfolk';

  @override
  String get fgTribeHuman => 'Humans';

  @override
  String get fgTribeSpirit => 'Spirits';

  @override
  String get fgTribeSliver => 'Slivers';

  @override
  String get fgTribeWizard => 'Wizards';

  @override
  String get fgTribeKnight => 'Knights';

  @override
  String get fgTribeWarrior => 'Warriors';

  @override
  String get fgTribeSoldier => 'Soldiers';

  @override
  String get fgTribeCat => 'Cats';

  @override
  String get fgTribeDog => 'Dogs';

  @override
  String get fgTribeRat => 'Rats';

  @override
  String get fgTribePirate => 'Pirates';

  @override
  String get fgTribeElemental => 'Elementals';

  @override
  String get fgTribeGiant => 'Giants';

  @override
  String get fgTribeRogue => 'Rogues';

  @override
  String get fgDeepForge => 'Deep forge';

  @override
  String get fgDeepForgeHint =>
      'Before showing you the proposals, it makes them actually play each other first (a bit more waiting).';

  @override
  String get fgPricePerCard => 'Price per card:';

  @override
  String get fgMin => 'min €';

  @override
  String get fgMax => 'max €';

  @override
  String get fgCardYear => 'Card year:';

  @override
  String get fgFrom => 'from';

  @override
  String get fgTo => 'to';

  @override
  String get fgYearNeedsDb =>
      'The year filter needs an up-to-date database: Settings → Download the database again.';

  @override
  String get fgNoColorsNote =>
      'With no colours picked, Forge tries every combination.';

  @override
  String fgColorsNote(String colores) {
    return 'Only $colores decks (and their combinations).';
  }

  @override
  String get fgMissingNote =>
      'This deck may include cards you do NOT own: each proposal says how many you\'re missing and what they\'d cost (Cardmarket price).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge only uses your $n cards. It never invents copies you don\'t have.';
  }

  @override
  String get fgForgeMissing => 'Forge decks (with what I\'m missing)';

  @override
  String get fgForgeMine => 'Forge my decks';

  @override
  String get fgTestMode => 'Test mode: beat a meta deck';

  @override
  String get fgOffline => 'Everything is worked out on your device, offline';

  @override
  String fgForgingWith(int n) {
    return 'You\'re forging with $n cards: this takes a few seconds. The window is still alive.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n decks ready to play',
      one: '1 deck ready to play',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'With cards you don\'t own yet · swipe to compare';

  @override
  String get fgSwipeMine => 'Made only from your cards · swipe to compare';

  @override
  String get fgHaveAll => '✓ You have every card';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'You\'re missing $n cards',
      one: 'You\'re missing 1 card',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'See the full deck';

  @override
  String get fgReforge => 'Forge again';

  @override
  String get fgBackToOptions => 'Back to forge options';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta is at $precio (your target: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 $n cards on your wishlist have dropped to their target price!';
  }

  @override
  String get mkTellMeWhenDrops => 'Tell me when it drops';

  @override
  String get mkTargetPrice => 'Target price';

  @override
  String mkNow(String precio) {
    return 'Now: $precio';
  }

  @override
  String get mkUpdated => '✓ Prices and cards updated';

  @override
  String mkUpdateFailed(String error) {
    return 'Couldn\'t update: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Price history ready: the charts now show the last few months';

  @override
  String mkHistoryFailed(String error) {
    return 'Couldn\'t fetch the history (the one you had is untouched): $error';
  }

  @override
  String get mkHistoryLocal =>
      'Price history: only what ManaForge notes down daily on your machine. Fetch the real last ~90 days from Cardmarket (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Real Cardmarket history from $desde to $hasta, and from there on what ManaForge notes down.';
  }

  @override
  String get mkFetchHistory => 'Fetch history';

  @override
  String get mkCollectionValue => 'What your collection is worth · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n cards';
  }

  @override
  String get mkApproxSuffix => ' · rough value';

  @override
  String mkBulkPrices(String fecha) {
    return 'Cardmarket prices from $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Market with no data: download the database in Collection. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'SETS ($n)';
  }

  @override
  String get mkPrevious => 'Previous';

  @override
  String get mkNext => 'Next';

  @override
  String get mkSearchHint => 'Look up the price of any card…';

  @override
  String get mkRemoveFromWishlist => 'Remove from the wishlist';

  @override
  String get mkAddToWishlist => 'To the wishlist: tell me when it drops';

  @override
  String get mkYourWishlist => 'YOUR WISHLIST';

  @override
  String mkTargetAtMost(String precio) {
    return 'target ≤ $precio';
  }

  @override
  String get mkAtPrice => 'at your price!';

  @override
  String get mkChangeTarget => 'Change the target price';

  @override
  String mkNoPriceIn(String market) {
    return 'no price on $market';
  }

  @override
  String get mkPerUnit => '/ea';

  @override
  String get mkTopCards => 'YOUR MOST VALUABLE CARDS';

  @override
  String get mkImportToSeeValue =>
      'Import your collection to see what it\'s worth.';

  @override
  String mkSetCards(int n) {
    return ' · $n cards';
  }

  @override
  String get wlEmpty =>
      'Find them in Market and tap the bookmark so it tells you when they drop to your price.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '🔔 $n cards on your wishlist are at your target price or below.',
      one: '🔔 1 card on your wishlist is at your target price or below.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'MTGO prices in tix (digital cards)';

  @override
  String get mpNoDataYet => 'No data yet: update the price history in Market';

  @override
  String get mpMtgoNote =>
      'MTGO prices in tix: those are digital cards, no good for valuing your paper collection. Home, folders and achievements stay on Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return '$mercado prices in $moneda. Home, folders and achievements keep valuing in Cardmarket (€): currencies are never converted.';
  }

  @override
  String get mkUpdate => 'Update';

  @override
  String get mkApproxValue =>
      ' · approximate value (re-import with \"Replace\" for per-printing prices)';

  @override
  String get mkExactPrintings => ' · by your exact printings';

  @override
  String mkNowSuffix(String precio) {
    return ' · now $precio';
  }

  @override
  String get wlNothingYet => 'Nothing on your wishlist yet.';

  @override
  String get stDbUpdated => '✓ Database updated';

  @override
  String stUpdateFailed(String error) {
    return 'Couldn\'t update: $error';
  }

  @override
  String get stCardDb => 'Card database';

  @override
  String get stCardDbWhy =>
      'Download it again for new cards, fresh prices and the features that need recent data (like Forge\'s year filter).';

  @override
  String get stDownloadDbAgain => 'Download the database again';

  @override
  String get stAppearance => 'Look';

  @override
  String get stData => 'Data';

  @override
  String get stTheApp => 'The app';

  @override
  String get stCredits =>
      'Card data and images by Scryfall. Magic: The Gathering is owned by Wizards of the Coast; a fan project under their Fan Content Policy.';

  @override
  String get stSuggestions => 'Suggestion box';

  @override
  String get stSuggestionsSub =>
      'An idea or a bug? Tell us on GitHub — there\'s a template and it takes a minute.';

  @override
  String get stDonate => 'Support the project';

  @override
  String get stDonateSub =>
      'The app is free with no ads. If it helps you and you\'d like to buy us a coffee, here\'s how.';

  @override
  String get stEditHome => 'Edit Home';

  @override
  String get stEditHomeSub => 'Pick which sections show and in what order';

  @override
  String get ehLevel => 'Your level';

  @override
  String get ehShortcuts => 'Quick actions';

  @override
  String get ehSummary => 'Collection summary';

  @override
  String get ehRecent => 'Recently viewed';

  @override
  String get ehDecks => 'Your decks';

  @override
  String get ehMeta => 'The meta right now';

  @override
  String get ehNewSets => 'New sets';

  @override
  String get ehGems => 'Your gems';

  @override
  String get ehStatCards => 'cards';

  @override
  String get ehStatDistinct => 'distinct';

  @override
  String get ehStatValue => 'value';

  @override
  String get ehStatDecks => 'decks';

  @override
  String get ehStatAchievements => 'achievements';

  @override
  String get ehHelp =>
      'Drag to reorder and use the switch to pick what you see on Home. A section that\'s on only shows up if it has something to show.';

  @override
  String get ehSection => 'Section';

  @override
  String get bkNoData => 'I can\'t find your data.';

  @override
  String bkSaved(String resumen) {
    return '✓ Backup saved · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'I couldn\'t save it: $error';
  }

  @override
  String get bkFileName => 'ManaForge backup';

  @override
  String bkRestoreFailed(String error) {
    return 'I couldn\'t restore it: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Restored · $resumen. HEADS UP: I couldn\'t save what you had before ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Restored · $resumen. What you had before is saved in the backups folder.';
  }

  @override
  String get bkRestoring => 'Restoring your backup…';

  @override
  String get bkTitle => 'Backup';

  @override
  String get bkWhy =>
      'Your cards, decks, folders and achievements live only on this computer. Save a copy now and then and keep it somewhere else: a drive, the cloud, whatever you like.';

  @override
  String get bkSave => 'Save a backup';

  @override
  String get bkRestoreTitle => 'Restore a backup';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Restoring REPLACES your cards, decks, folders and achievements with the ones in the backup. Choose which, press the button and type $palabra: that way nothing gets restored by accident.';
  }

  @override
  String get bkNoBackups => 'No backups saved on this computer yet.';

  @override
  String get bkWhich => 'Backup to restore';

  @override
  String get bkPickOne => 'Pick a backup';

  @override
  String get bkRestorePicked => 'Restore the chosen backup';

  @override
  String get bkAutoNote =>
      'I save an automatic backup every week (the last five) and another right before each restore.';

  @override
  String get bkFromFile => 'Restore from a file';

  @override
  String get bkConfirmTitle => 'Restore this backup?';

  @override
  String get bkConfirmBody =>
      'This replaces your current collection, decks, folders and achievements with the ones in that backup. Before doing it I save what you have in the backups folder, in case you want to come back.';

  @override
  String bkWillDelete(String cosas) {
    return 'That backup doesn\'t include $cosas: restoring it wipes that.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Type $palabra to carry on:';
  }

  @override
  String get bkAnd => ' and ';

  @override
  String get ehReset => 'Reset';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Backup from $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'Live camera is not available on macOS yet. Use \"Scan from photo\" instead — it works just as well.';

  @override
  String get lsNoCamera => 'I can\'t find any camera.';

  @override
  String get lsCameraGone =>
      'The camera dropped out mid-session. Check the cable and hit Try again.';

  @override
  String get lsFrameCard => 'Line the card up inside the frame';

  @override
  String get lsNoCardThere => 'I don\'t see a card there';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n cards into the collection',
      one: '✓ 1 card into the collection',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', and into \"$carpeta\"';
  }

  @override
  String get lsTitle => 'Live scan';

  @override
  String get lsQuickTip =>
      'Fast: clear cards go in on their own; doubtful ones get flagged for review.';

  @override
  String get lsCarefulTip =>
      'Careful: doubtful ones stop and ask you which card it is.';

  @override
  String get lsQuick => 'Fast';

  @override
  String get lsCareful => 'Careful';

  @override
  String lsThisSession(int n) {
    return '$n this session';
  }

  @override
  String get lsScanPhotoTooltip => 'Scan a single photo';

  @override
  String get lsStartingCamera => 'Waking the camera up…';

  @override
  String get lsCantUseCamera => 'I can\'t use the camera';

  @override
  String get lsCameraUnavailable => 'Camera unavailable.';

  @override
  String get lsScanPhoto => 'Scan a photo';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 same · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Already on the table: $carta · take it away and put it back, or tap \"+1 same\"';
  }

  @override
  String lsSeeing(String carta) {
    return 'Seeing: $carta';
  }

  @override
  String get lsPassACard => 'Hold a card up to the camera…';

  @override
  String lsIsThis(String carta) {
    return 'Is this $carta? I\'m not sure — tap to choose.';
  }

  @override
  String get lsNotThisOne => 'Not this one — change printing';

  @override
  String get lsRetry => 'Try again';

  @override
  String get scBadImage => 'Couldn\'t read that image (is it a valid photo?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'No folder';

  @override
  String scAlsoTo(String carpeta) {
    return 'And also into: $carpeta';
  }

  @override
  String get scLookingForCard => 'Looking for the card in the photo…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Recognising… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cards',
      one: '1 card',
    );
    return '$_temp0 · $copias in total';
  }

  @override
  String scToReview(int n) {
    return '$n to review (tap them)';
  }

  @override
  String scUnknown(int n) {
    return '$n not recognised (tap to pick by hand)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n photos skipped (too big or unreadable)',
      one: '1 photo skipped (too big or unreadable)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'I didn\'t recognise a single card in those photos. Try better light or less glare.';

  @override
  String scAddN(int n) {
    return 'Add $n to the collection';
  }

  @override
  String get scDropPhotos => 'Drop your card photos here';

  @override
  String get scDropExplain =>
      'One or many at a time — and if a photo has SEVERAL cards (an album page, a full table), I pull them all out and put them in one list for you to review and add whichever you want. A phone photo or a scan both work.';

  @override
  String get scPickPhotos => 'Pick photos';

  @override
  String get scMatchHigh => 'strong match';

  @override
  String get scMatchMedium => 'fair match';

  @override
  String get scMatchLow => 'weak match';

  @override
  String get scAddToCollection => 'Add to the collection';

  @override
  String get scSeeOptions => 'Not this one — see options';

  @override
  String get scScanAnother => 'Scan another';

  @override
  String get scNotSure => 'I\'m not sure';

  @override
  String get scWhichIsIt => 'Which one is it?';

  @override
  String get scNoneQuiteFits =>
      'None of them quite fits. Is it one of these? If not, try another photo with better light.';

  @override
  String get scNoEdges =>
      'I couldn\'t see the card\'s edges, so I used the whole image. These are the closest:';

  @override
  String get scCropped =>
      'This is what I cropped. The candidates, by likeness:';

  @override
  String get scDiscard => 'Discard and scan another';

  @override
  String get suCardsName => 'Cards and prices';

  @override
  String get suCardsWhat => 'the full Scryfall catalogue';

  @override
  String get suHistoryName => 'Price history';

  @override
  String get suHistoryWhat => '~90 days of Cardmarket';

  @override
  String get suHashesName => 'Scanner fingerprints';

  @override
  String get suHashesWhat => 'to recognise by photo';

  @override
  String suUpToDate(String fecha) {
    return 'up to date ($fecha)';
  }

  @override
  String get suUpdated => 'updated';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'updated ($fecha)';
  }

  @override
  String get suFailedOffline => 'couldn\'t fetch it (no connection)';

  @override
  String get suKeepingOld => 'keeping the one you had';

  @override
  String get suNeedMissing => 'missing, fetching it';

  @override
  String get suNeedStale => 'there\'s a new one';

  @override
  String get suNeedFresh => 'up to date';

  @override
  String get suAllUpToDate => 'All up to date. Coming in…';

  @override
  String get suUpdatingCards => 'Bringing your cards and prices up to date…';

  @override
  String get suChecking => 'Checking for anything new…';

  @override
  String get suNoDownloadNote =>
      'Whatever is already up to date isn\'t downloaded. Inside the app you can force any update.';

  @override
  String get suEnter => 'Enter';

  @override
  String get suEnterNow => 'Enter now';

  @override
  String icBadFile(String error) {
    return 'Couldn\'t read the file: $error';
  }

  @override
  String get icNotCsv =>
      'That doesn\'t look like a CSV — drop a .csv or .txt file.';

  @override
  String get icTitle => 'Import collection';

  @override
  String get icExplain =>
      'Drag your ManaBox CSV here (Moxfield, Archidekt or any CSV with Name and Quantity columns also work), pick it with the button, or paste its contents by hand:';

  @override
  String get icPickFile => 'Pick a file…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas cards ($copias copies) added to your collection.';
  }

  @override
  String get icReplaceMine => 'Replace my current collection';

  @override
  String get icReplaceWhy =>
      'Turn it on when re-importing your full CSV: it avoids doubling quantities and sharpens the album by printing.';

  @override
  String icImporting(int hechas, int total) {
    return 'Importing $hechas of $total cards…';
  }

  @override
  String get icDropHere => 'Drop your CSV here';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n tokens/emblems ignored (they don\'t go in decks, all good).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Not recognised: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• No purchase price in the CSV: there\'ll be no P&L (ManaBox exports it in the \"Purchase price\" column).';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n copies with a purchase price: you can now see the P&L in Market.';
  }

  @override
  String get icImporting2 => 'Importing…';

  @override
  String get icImport => 'Import';

  @override
  String dkDeleted(String nombre) {
    return 'Deck \"$nombre\" deleted';
  }

  @override
  String get dkUndo => 'UNDO';

  @override
  String dkOpenFailed(String error) {
    return 'Couldn\'t open the deck (is the database downloaded?): $error';
  }

  @override
  String get dkMyDecks => 'My decks';

  @override
  String get dkEmpty =>
      'The decks you save from Forge will live here (save button in the deck detail).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n saved',
      one: '1 saved',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos spells + $tierras lands · saved on $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Delete deck';

  @override
  String get ddSaved => '✓ Deck saved — it\'s in the Decks tab';

  @override
  String get ddReforged => '✓ Deck reforged to your curve — list updated';

  @override
  String get ddSaveToMyDecks => 'Save to My decks';

  @override
  String get ddCopyList => 'Copy list (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ List copied — paste it into Moxfield, Arena or Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos spells + $tierras lands';
  }

  @override
  String get ddHaveAll => '✓ You have every card';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ You\'re missing $n cards from this deck — they stay in the list, they weren\'t deleted',
      one:
          '⚠ You\'re missing 1 card from this deck — it stays in the list, it wasn\'t deleted',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Your game plan';

  @override
  String get ddManaCurve => 'Mana curve';

  @override
  String get ddEditCurve => 'Edit curve';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Drag the bars ↑↓ · $hechizos spells → $tierras lands';
  }

  @override
  String get ddReforgeCurve => 'Reforge with this curve';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras lands · ✦ $hechizos spells · Ø cost $coste';
  }

  @override
  String get ddWhyWorks => 'Why does this deck work?';

  @override
  String ddLands(int n) {
    return 'LANDS ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Deck total: ~$precio €';
  }

  @override
  String get ddCheapestPrice => 'price of the cheapest printing (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n without a known price · cheapest printing (Cardmarket)';
  }

  @override
  String get ddInstants => 'Instants';

  @override
  String get ddTypeCreatures => 'Creatures';

  @override
  String get ddTypeSorceries => 'Sorceries';

  @override
  String get ddTypeEnchantments => 'Enchantments';

  @override
  String get ddTypeArtifacts => 'Artifacts';

  @override
  String get ddTypeOther => 'Other';

  @override
  String get ddOutOfRange => '  (outside the healthy 20-27 range)';

  @override
  String get acRecalcTitle => 'Recalculate achievements?';

  @override
  String get acRecalcBody =>
      'Your cards are checked again and any achievements that no longer hold are removed. Good for fixing ones awarded by mistake; if you\'ve sold cards, you\'ll lose those too.';

  @override
  String get acRecalc => 'Recalculate';

  @override
  String get acAllFine => 'Everything checked out: no achievement was removed.';

  @override
  String acRemovedN(int n) {
    return 'Removed $n achievements that no longer hold.';
  }

  @override
  String get acTitle => 'Achievements';

  @override
  String get acRecalcTooltip => 'Recalculate with my current cards';

  @override
  String get acCertsTooltip => 'Certificates';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos of $total achievements · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Level $nivel · $xp XP to level $siguiente';
  }

  @override
  String get acIMissing => 'I\'m missing';

  @override
  String get acSecret => 'Secret achievement';

  @override
  String get acSecretDesc => 'You\'ll find out only once you earn it.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Earned$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' on $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return 'Level $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'You\'re now $titulo. You\'ve earned $hechos of $total achievements.';
  }

  @override
  String get acOk => 'OK';

  @override
  String get acSeeAchievements => 'See achievements';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 Achievement! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (and $n more)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Set certificates need the card database ($error)';
  }

  @override
  String get ceWhoseName => 'In whose name?';

  @override
  String get ceCollectorName => 'Your collector name';

  @override
  String get ceInNameOf => 'In the name of…';

  @override
  String get ceEmptyWithData =>
      'You haven\'t completed a full set yet. When you finish one in the Album, your certificate will show up here to download.';

  @override
  String get ceEmptyNoData =>
      'Certifying a set needs the exact printing of your cards: re-import your ManaBox CSV (it carries the Scryfall ID).';

  @override
  String get ceNothingSaved => 'Nothing was saved.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Certificate saved to $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'Couldn\'t save it: $error';
  }

  @override
  String get cePickFirstCard => 'Choose the card I started with';

  @override
  String get ceChangeFirstCard => 'Change the card I started with';

  @override
  String get ceDownloadPng => 'Download PNG';

  @override
  String get cdNotFound => 'I can\'t find this card in the database.';

  @override
  String cdLoadFailed(String error) {
    return 'Couldn\'t load the card: $error';
  }

  @override
  String get cdPrev => 'Previous (←)';

  @override
  String get cdNext => 'Next (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Card not found';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return 'You paid $total$divisa for $qty $copias ($unidad each)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'copies',
      one: 'copy',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ You have $n copies in your collection',
      one: '✓ You have 1 copy in your collection',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'You don\'t have this card (yet).';

  @override
  String cdNoPrice(String mercado) {
    return 'No price for this card on $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'VERSIONS ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'no per-printing price on $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return '$mercado prices ($moneda) · normal / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'you have x$n';
  }

  @override
  String get smMythic => 'Mythic';

  @override
  String get smRare => 'Rare';

  @override
  String get smUncommon => 'Uncommon';

  @override
  String get smCommon => 'Common';

  @override
  String smLoadFailed(String error) {
    return 'Couldn\'t load the set: $error';
  }

  @override
  String get smSearchInSet => 'Search in the set…';

  @override
  String get smRarityAll => 'Rarity: all';

  @override
  String get smPriceDown => 'Price ↓';

  @override
  String get smPriceUp => 'Price ↑';

  @override
  String get smNumber => 'Number';

  @override
  String get smOnlyMine => 'Only mine';

  @override
  String smCardsCount(int n) {
    return '$n cards';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: no per-printing price';
  }

  @override
  String smListedValue(String mercado) {
    return 'listed value ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'You paid $pagado · today they\'re worth $hoy';
  }

  @override
  String get pnNoPnl =>
      'No purchase price means no P&L. Import your ManaBox CSV with the \"Purchase price\" column and it shows up here.';

  @override
  String pnOverAll(int n) {
    return 'over the $n copies in your collection';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'over $conprecio of $total copies (the rest have no purchase price recorded)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '$n bought copies have no current price in the database: left out of the count';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'you also paid $importe $moneda, which isn\'t converted';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n copies with no currency in the CSV: assumed $moneda';
  }

  @override
  String get pcTitle => 'Price over time';

  @override
  String get pcNoHistory => 'No price history for this card yet.';

  @override
  String pcTodayPrice(String precio) {
    return 'Today\'s price: $precio €. The chart appears once there are several days.';
  }

  @override
  String get pcExplain =>
      'ManaForge notes down the price of every card you look at or own, day by day. To start with the real last few months from Cardmarket, fetch the history from Market.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return 'min $min € · max $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'Which sets?';

  @override
  String get spSearchHint => 'Search by name or code (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Only mine';

  @override
  String spClearN(int n) {
    return 'Clear the $n';
  }

  @override
  String get spNoneNamed =>
      'No set by that name. Turn off \"Only mine\" to see them all.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n cards';
  }

  @override
  String get spNoFilter => 'No set filter';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Use $n sets',
      one: 'Use 1 set',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'I only look for cards from the $set set. Tap it to change or clear the lock.';
  }

  @override
  String get slLockHint =>
      'Lock a set to scan a box/precon: the scanner only looks inside it and nails the printing.';

  @override
  String slSetIs(String set) {
    return 'Set: $set';
  }

  @override
  String get slSetAll => 'Set: all';

  @override
  String get slLockTitle => 'Lock printing';

  @override
  String get slLockBody =>
      'Type the set code (e.g. AER, MH3, LCI) to scan a whole box: only cards from that set will be searched.';

  @override
  String get slSetCode => 'Set code';

  @override
  String get slClearLock => 'Clear the lock';

  @override
  String get stHintQuick =>
      'Hold cards up: clear ones note themselves here (identical copies stack ×N). Doubtful ones get flagged for review. When you\'re done, you confirm them all.';

  @override
  String get stHintCareful =>
      'Hold cards up: clear ones note themselves; doubtful ones ask which card it is. When you\'re done, you confirm them all.';

  @override
  String stAddN(int n) {
    return 'Add $n to the collection';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return 'Add $n to the collection and to $carpeta';
  }

  @override
  String get stOneLess => 'One fewer';

  @override
  String get stAnotherSame => 'Another one';

  @override
  String get stOnTable => 'on the table';

  @override
  String cdLastData(String fecha) {
    return ' (last data: $fecha)';
  }

  @override
  String get cdLegalities => 'Legalities';

  @override
  String get slLockButton => 'Lock';

  @override
  String get wn030Headline => 'Forge by set, purchase price and version alerts';

  @override
  String get wn030Forge =>
      'Forge: pick which sets the cards come from. And if you turn on \"include cards I don\'t own\", it builds the deck from the whole chosen set and tells you how many you\'re missing and what they cost.';

  @override
  String get wn030Pnl =>
      'Purchase price and P&L: if your ManaBox CSV has \"Purchase price\", Market shows what you paid, what it\'s worth today and the difference. Currencies are never mixed.';

  @override
  String get wn030PhotoFolder =>
      'Scanning from a photo lets you pick a folder too, just like the live scanner.';

  @override
  String get wn030Album =>
      'Album: what you\'re missing from each set, and what it would cost.';

  @override
  String get wn030Background =>
      'Wallpaper: put any image behind it, with an adjustable veil, and choose the card and text colours so everything stays readable on top.';

  @override
  String get wn030Window =>
      'The window opens where you left it, at the size you left it.';

  @override
  String get wn030Achievements =>
      'Achievements are no longer named after the rule but after the moment: \"There goes all my money\", \"A hundred rares and none playable\".';

  @override
  String get wn030Update =>
      'The app tells you when there\'s a new version (it never updates itself) and checks the SHA-256 fingerprint of every database it downloads.';

  @override
  String get wn030Shortcuts =>
      'Keyboard shortcuts: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, and Escape.';

  @override
  String get wn030Linux =>
      'On Linux, an installer puts ManaForge in your application menu with its icon.';

  @override
  String get wn030License =>
      'PolyForm Noncommercial licence: share it and tinker all you like, but it isn\'t for sale.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cards',
      one: '1 card',
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
      other: '$n folders',
      one: '1 folder',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n achievements',
      one: '1 achievement',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'empty backup';

  @override
  String get bkStoreCollection => 'your collection';

  @override
  String get bkStoreFolders => 'your folders';

  @override
  String get bkStoreDecks => 'your decks';

  @override
  String get bkStoreAchievements => 'your achievements';

  @override
  String get bkStoreWishlist => 'your wishlist';

  @override
  String get bkStoreCertificates => 'your certificates';

  @override
  String get bkStoreMarket => 'your preferred market';

  @override
  String get bkStoreRecents => 'the cards you looked at recently';

  @override
  String get bkStoreValueHistory => 'your value history';

  @override
  String get bkStorePriceHistory => 'your price history';

  @override
  String get bkKindAuto => 'automatic';

  @override
  String get bkKindPreRestore => 'before restoring';

  @override
  String get bkKindPreReset => 'before factory reset';

  @override
  String get bkErrFileTooBig =>
      'That file is far too big to be a ManaForge backup.';

  @override
  String get bkErrExpandTooBig =>
      'That backup is far too big once unpacked: it doesn\'t look like a real ManaForge backup.';

  @override
  String get bkErrNotABackup => 'That file is not a ManaForge backup.';

  @override
  String get bkErrNewerVersion =>
      'That backup was made by a newer version of ManaForge. Update the app and try again.';

  @override
  String get bkErrIncomplete =>
      'That backup is incomplete: it doesn\'t carry your data.';

  @override
  String bkErrDamaged(String almacen) {
    return 'That backup is damaged: $almacen can\'t be read.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'I couldn\'t write to the data folder, so I haven\'t touched anything: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'The restore stopped halfway ($escritos of $total files). I have no earlier backup of what was there. Details: $error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return 'The restore stopped halfway ($escritos of $total files). To go back, restore $ruta. Details: $error';
  }

  @override
  String get siImportTooBig => 'That file is far too big to be a card list.';

  @override
  String get siInsecureDownload =>
      'The download ended up at an insecure address and has been cancelled.';

  @override
  String get siRedirectNowhere =>
      'The download redirects nowhere and has been cancelled.';

  @override
  String get siTooManyRedirects =>
      'The download goes round in too many circles and has been cancelled.';

  @override
  String get siDownloadTooBig =>
      'The download is far bigger than it should be and has been cancelled.';

  @override
  String get siBadHash =>
      'What was downloaded doesn\'t match the fingerprint published on GitHub. Nothing has been installed. Try again; if it keeps happening, say so.';

  @override
  String get siBackgroundNotImage =>
      'Pick an image (.jpg, .png or .webp) as your background.';

  @override
  String get siBackgroundTooBig =>
      'That image is too big to use as a background.';

  @override
  String get siScanTooBig => 'That photo is too big to recognise.';

  @override
  String get bgImages => 'Images';

  @override
  String bgImageFailed(String error) {
    return 'I couldn\'t use that image: $error';
  }

  @override
  String get bgLowContrast =>
      'Too close to the card colour: the text will adjust itself so it stays readable.';

  @override
  String get bgChipColor => 'Tab colour';

  @override
  String get bgIconColor => 'Icon colour';

  @override
  String get bgUseThis => 'Use this one';

  @override
  String get bgSaveSwatch => 'Save as swatch';

  @override
  String get bgSwatchTip => 'Saved swatch';

  @override
  String get bgSwatchHint =>
      'Saved swatch — right-click or long-press to delete';

  @override
  String get bgSwatchDeleteTitle => 'Delete this swatch?';

  @override
  String get bgSwatchDeleteBody =>
      'It\'s removed from your saved palette. You can save it again anytime.';

  @override
  String get camGstreamerMissing =>
      'GStreamer isn\'t installed. Install it with:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'Camera $dispositivo gives no image (gst-launch exited with $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'Camera $dispositivo hasn\'t produced a single frame in 6 s.';
  }

  @override
  String get camNoCameras =>
      'I can\'t find any camera (/dev/video*). Is it plugged in? Check with `lsusb` that the system sees it.';

  @override
  String camNoneWorked(String detalle) {
    return 'No camera produced an image:\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Restore';

  @override
  String get fpUnselect => 'Unselect';

  @override
  String get stClear => 'Clear';

  @override
  String get tlRemove => 'Remove';

  @override
  String get tlUnrecognized => 'Not recognised';

  @override
  String get tlNothingAlike =>
      'nothing like it in the database — retake the photo or remove it';

  @override
  String get tlTapToPick => 'tap to pick by hand from the look-alikes';

  @override
  String get tlReview => 'review';

  @override
  String get lsQuantity => 'Quantity';

  @override
  String get scPhotos => 'Photos';

  @override
  String get ftWhichFolder => 'Which folder do you want them in?';

  @override
  String get ftWhichFolderSub =>
      'They go into your collection either way; the folder is just a label to find them again.';

  @override
  String get ftNone => 'None';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => 'New folder…';

  @override
  String get ftNewFolder => 'New folder';

  @override
  String get ftNewFolderHint => 'Shop box, To sell…';

  @override
  String get sgTitle => 'The scanner\'s eye';

  @override
  String get sgWhy =>
      'To recognise cards without internet I need the visual fingerprint database (~12 MB): the signature of every Magic illustration. It downloads once.';

  @override
  String get sgDownload => 'Download fingerprint database';

  @override
  String get cmFullCard => 'See the full card (prices and legality)';

  @override
  String get cmSwipeHint =>
      'drag or use ← → to flip through · tap outside to close';

  @override
  String get cmTapOutHint => 'tap outside to close';

  @override
  String get fcTitle => 'Which card did you start with?';

  @override
  String get fcRemove => 'Remove';

  @override
  String get fcSearchHint => 'Search your collection';

  @override
  String get fcNoMatch => 'I can\'t find any card with that.';

  @override
  String get acNoneWithFilters => 'Nothing here with these filters.';

  @override
  String get acAll => 'All';

  @override
  String get tsTitle => 'Test Mode — beat the meta';

  @override
  String get tsIntro =>
      'Choose which meta deck you want to play against. ManaForge builds decks from YOUR cards, simulates hundreds of games against it and keeps the one that wins most — trying card swaps one by one to sharpen it.';

  @override
  String get tsLoadingMeta => 'Loading the meta…';

  @override
  String get tsLocalPresets => 'Local presets (offline)';

  @override
  String get tsNoDeckToFace =>
      'With your current cards I can\'t build a complete deck to face it. Add more cards and try again.';

  @override
  String tsSimFailed(String error) {
    return 'I couldn\'t simulate: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota of the meta';
  }

  @override
  String get tsSimulating =>
      'Simulating games… (a few seconds; all on your machine)';

  @override
  String tsFindBest(String meta) {
    return 'Find my best deck against $meta';
  }

  @override
  String get tsHonesty =>
      'Being honest: the simulation understands mana colours, mulligans, evasion (flying, trample, deathtouch…), instant-speed removal and counterspells — but not the full text of every card. The percentage is for COMPARING your decks with each other, not an exact prediction.';

  @override
  String tsChampion(String meta) {
    return 'Your champion against $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'estimated win rate · $mazos decks tried · $partidas games per deck';
  }

  @override
  String get tsNoDominant =>
      'No deck in your collection dominates this matchup — this is the one that fights best. Look at its weak spots in the detail.';

  @override
  String get tsSeeDeck => 'See the full deck (and save it)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total achievements · $xp XP to level $nivel';
  }

  @override
  String get hsForgeDecks => 'Forge decks';

  @override
  String get hsTestYourself => '⚔ put yourself to the test';

  @override
  String get bgCustom => 'Custom';

  @override
  String get bgPickCustom => 'Pick a custom colour';

  @override
  String get bgCustomColor => 'Custom colour';

  @override
  String get bgSampleTab => 'Red';

  @override
  String get cfSortRecent => 'Just added';

  @override
  String get cfSortAlpha => 'Name A-Z';

  @override
  String get cfSortCmc => 'Cost';

  @override
  String get cfSortQty => 'Quantity';

  @override
  String get cfSortBy => 'Sort by';

  @override
  String get cfSort => 'Sort';

  @override
  String get cfClear => 'Clear';

  @override
  String get cfCost => 'Cost';

  @override
  String get cfCostAll => 'Cost: all';

  @override
  String cfCostN(String n) {
    return 'Cost $n';
  }

  @override
  String get cfType => 'Type';

  @override
  String get cfTypeAll => 'Type: all';

  @override
  String get cfTypeCreature => 'Creatures';

  @override
  String get cfTypeInstant => 'Instants';

  @override
  String get cfTypeSorcery => 'Sorceries';

  @override
  String get cfTypeArtifact => 'Artifacts';

  @override
  String get cfTypeEnchantment => 'Enchantments';

  @override
  String get cfTypeLand => 'Lands';

  @override
  String get cfPower => 'Power';

  @override
  String get cfPowerAll => 'Power: all';

  @override
  String cfPowerMin(int n) {
    return 'Power ≥ $n';
  }

  @override
  String get cfToughness => 'Toughness';

  @override
  String get cfToughnessAll => 'Toughness: all';

  @override
  String cfToughnessMin(int n) {
    return 'Toughness ≥ $n';
  }

  @override
  String get cfNoDate => 'no date';

  @override
  String get cfToday => 'today';

  @override
  String get cfYesterday => 'yesterday';

  @override
  String cfDaysAgo(int n) {
    return '$n days ago';
  }

  @override
  String get pcWeek => 'Week';

  @override
  String get pcMonth => 'Month';

  @override
  String get pcAll => 'All';

  @override
  String get vpTapCorrect => 'Tap the right card';

  @override
  String get achCopias1 => 'The first of many';

  @override
  String get achCopias10 => 'I was only going to buy one';

  @override
  String get achCopias50 => 'They don\'t fit in one hand any more';

  @override
  String get achCopias100 => 'A hundred and counting';

  @override
  String get achCopias500 => 'The box is getting small';

  @override
  String get achCopias1000 => 'A thousand. And I want them all';

  @override
  String get achCopias5000 => 'This is a warehouse now';

  @override
  String get achCopias10000 => 'Ten thousand, but I can stop whenever';

  @override
  String achCopiasDesc(String n) {
    return 'Have $n cards in your collection.';
  }

  @override
  String get achDistintas25 => 'Now there\'s variety';

  @override
  String get achDistintas100 => 'A hundred different faces';

  @override
  String get achDistintas500 => 'Half a library';

  @override
  String get achDistintas1000 => 'Walking encyclopedia';

  @override
  String get achDistintas2500 => 'I don\'t know them all any more';

  @override
  String get achDistintas5000 => 'The archive';

  @override
  String achDistintasDesc(String n) {
    return 'Have $n DIFFERENT cards (duplicates don\'t count).';
  }

  @override
  String get achPlaysets1 => 'Four of a kind';

  @override
  String get achPlaysets20 => 'Twenty playsets, zero decks';

  @override
  String get achPlaysets1Desc => 'Have 4 copies of the same card.';

  @override
  String get achPlaysets20Desc =>
      'Have 20 different playsets (4 copies of each).';

  @override
  String get achComunes10 => 'The ones nobody wants';

  @override
  String get achComunes50 => 'The usual pile';

  @override
  String get achComunes200 => 'King of the pile';

  @override
  String get achComunes500 => 'A tide of commons';

  @override
  String achComunesDesc(String n) {
    return 'Have $n different common cards.';
  }

  @override
  String get achInfrecuentes10 => 'A step up from common';

  @override
  String get achInfrecuentes50 => 'Fine silver';

  @override
  String get achInfrecuentes200 => 'Uncommon hunter';

  @override
  String get achInfrecuentes500 => 'Silver by the bucket';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Have $n different uncommon cards.';
  }

  @override
  String get achRaras5 => 'That sounds good opening a pack';

  @override
  String get achRaras25 => 'A chest of rares';

  @override
  String get achRaras100 => 'A hundred rares and none playable';

  @override
  String get achRaras300 => 'The vault';

  @override
  String achRarasDesc(String n) {
    return 'Have $n different rare cards.';
  }

  @override
  String get achMiticas1 => 'My first mythic';

  @override
  String get achMiticas10 => 'Ten mythics';

  @override
  String get achMiticas50 => 'Mythic collector';

  @override
  String get achMiticas150 => 'Mythic pantheon';

  @override
  String achMiticasDesc(String n) {
    return 'Have $n different mythic cards.';
  }

  @override
  String get achBlancas25 => 'Law and order';

  @override
  String get achBlancas100 => 'Army of silver';

  @override
  String achBlancasDesc(String n) {
    return 'Have $n different white cards.';
  }

  @override
  String get achAzules25 => 'I can\'t let you do that';

  @override
  String get achAzules100 => 'Ivory tower';

  @override
  String achAzulesDesc(String n) {
    return 'Have $n different blue cards.';
  }

  @override
  String get achNegras25 => 'Dark pact';

  @override
  String get achNegras100 => 'Lord of the crypt';

  @override
  String achNegrasDesc(String n) {
    return 'Have $n different black cards.';
  }

  @override
  String get achRojas25 => 'Burn it all down';

  @override
  String get achRojas100 => 'General blaze';

  @override
  String achRojasDesc(String n) {
    return 'Have $n different red cards.';
  }

  @override
  String get achVerdes25 => 'A sprout';

  @override
  String get achVerdes100 => 'The whole forest';

  @override
  String achVerdesDesc(String n) {
    return 'Have $n different green cards.';
  }

  @override
  String get achIncoloras25 => 'Cold metal';

  @override
  String get achIncoloras100 => 'Eternal forge';

  @override
  String achIncolorasDesc(String n) {
    return 'Have $n different colourless cards.';
  }

  @override
  String get achArcoiris => 'All five colours';

  @override
  String get achArcoirisDesc =>
      'Have at least one card of each of the 5 colours.';

  @override
  String get achMulticolor10 => 'Mixing colours';

  @override
  String get achMulticolor50 => 'Golden alliance';

  @override
  String achMulticolorDesc(String n) {
    return 'Have $n different multicolour cards.';
  }

  @override
  String get achCincocolores => 'All five at once';

  @override
  String get achCincocoloresDesc => 'Have a card with all five colours.';

  @override
  String get achSets1 => 'First set';

  @override
  String get achSets5 => 'Five worlds';

  @override
  String get achSets10 => 'Planeswalker in training';

  @override
  String get achSets25 => 'Globetrotter';

  @override
  String get achSets50 => 'Half the multiverse';

  @override
  String achSetsDesc(String n) {
    return 'Have cards from $n different sets.';
  }

  @override
  String get achSetscompletos1 => 'Not one missing';

  @override
  String get achSetscompletos3 => 'Three full albums';

  @override
  String get achSetscompletos10 => 'Master of the album';

  @override
  String get achSetscompletos1Desc => 'Complete a whole set in the Album.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Complete $n whole sets.';
  }

  @override
  String get achAnyos5 => 'Five years of cardboard';

  @override
  String get achAnyos15 => 'Time machine';

  @override
  String achAnyosDesc(String n) {
    return 'Have cards from $n different release years.';
  }

  @override
  String get achValor10 => 'First euros';

  @override
  String get achValor50 => 'The piggy bank';

  @override
  String get achValor250 => 'There goes my allowance';

  @override
  String get achValor1000 => 'There goes all my money';

  @override
  String get achValor5000 => 'Don\'t tell anyone';

  @override
  String get achValor10000 => 'Worth more than my car';

  @override
  String get achValor25000 => 'A museum collection';

  @override
  String achValorDesc(String n) {
    return 'Get your collection to be worth $n € or more.';
  }

  @override
  String get achJoya20 => 'One of the good ones';

  @override
  String get achJoya100 => 'The jewel of the collection';

  @override
  String get achJoya500 => 'This one never leaves its sleeve';

  @override
  String get achJoya1000 => 'A thousand euros in a single sleeve';

  @override
  String get achJoya2500 => 'The holy grail';

  @override
  String achJoyaDesc(String n) {
    return 'Have a single card worth $n € or more.';
  }

  @override
  String get achFoils1 => 'First shine';

  @override
  String get achFoils10 => 'Sparkles';

  @override
  String get achFoils50 => 'The box shines';

  @override
  String get achFoils200 => 'Nothing matte left here';

  @override
  String get achFoils500 => 'Everything shines';

  @override
  String get achFoils1000 => 'Shine factory';

  @override
  String achFoilsDesc(String n) {
    return 'Have $n foil cards.';
  }

  @override
  String get achFoiljoya10 => 'A good foil';

  @override
  String get achFoiljoya50 => 'An expensive foil';

  @override
  String get achFoiljoya200 => 'A museum foil';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Have a foil worth $n € or more.';
  }

  @override
  String get achFoilvalor50 => 'A cabinet that shines';

  @override
  String get achFoilvalor250 => 'An expensive cabinet';

  @override
  String get achFoilvalor1000 => 'A thousand euros of shine';

  @override
  String get achFoilvalor5000 => 'A museum cabinet';

  @override
  String achFoilvalorDesc(String n) {
    return 'Get all your foils together to be worth $n € or more.';
  }

  @override
  String get achMazos1 => 'First deck';

  @override
  String get achMazos5 => 'Five decks saved';

  @override
  String get achMazos25 => 'The workshop never stops';

  @override
  String achMazosDesc(String n) {
    return 'Save $n decks made with Forge.';
  }

  @override
  String get achMazoscore => 'A tidy deck';

  @override
  String get achMazoscoreDesc => 'Generate a deck scoring 90 or more.';

  @override
  String get achMazocolores3 => 'Three colours';

  @override
  String get achMazocolores5 => 'Playable rainbow';

  @override
  String achMazocoloresDesc(String n) {
    return 'Save a $n-colour deck.';
  }

  @override
  String get achMazomono => 'Nothing mixed in';

  @override
  String get achMazomonoDesc => 'Save a single-colour deck.';

  @override
  String get achMazocommander => 'In command';

  @override
  String get achMazocommanderDesc => 'Save a Commander deck.';

  @override
  String get achEscaneadas1 => 'First scan';

  @override
  String get achEscaneadas50 => 'Quick hands';

  @override
  String get achEscaneadas500 => 'Scanning in bulk';

  @override
  String get achEscaneadas2000 => 'I scan in my sleep';

  @override
  String achEscaneadasDesc(String n) {
    return 'Scan $n cards with the camera or from a photo.';
  }

  @override
  String get achFoto9 => 'A whole page from one photo';

  @override
  String get achFoto20 => 'Twenty in one go';

  @override
  String achFotoDesc(String n) {
    return 'Recognise $n cards in a single photo.';
  }

  @override
  String get achEscaneoperfecto => 'Not one to review';

  @override
  String get achEscaneoperfectoDesc =>
      'Scan a whole page without leaving a single card to review.';

  @override
  String get achDias2 => 'You came back';

  @override
  String get achDias7 => 'A week here';

  @override
  String get achDias30 => 'A month here';

  @override
  String get achDias100 => 'A hundred days here';

  @override
  String achDiasDesc(String n) {
    return 'Use ManaForge on $n different days.';
  }

  @override
  String get achRacha3 => 'Three in a row';

  @override
  String get achRacha7 => 'A perfect week';

  @override
  String get achRacha30 => 'A month without missing one';

  @override
  String achRachaDesc(String n) {
    return 'Come in $n days in a row.';
  }

  @override
  String get achSemanas => 'Four weeks without missing one';

  @override
  String get achSemanasDesc => 'Use ManaForge 4 weeks in a row.';

  @override
  String get achCarpetas1 => 'Order begins';

  @override
  String get achCarpetas5 => 'All sorted';

  @override
  String achCarpetasDesc(String n) {
    return 'Create $n folders.';
  }

  @override
  String get achCarpetagrande => 'Big folder';

  @override
  String get achCarpetagrandeDesc => 'Have a folder with 100 cards or more.';

  @override
  String get achCarpetavalor => 'I\'m not lending this folder';

  @override
  String get achCarpetavalorDesc => 'Have a folder worth 100 € or more.';

  @override
  String get achTierrasbasicas => 'The five basics';

  @override
  String get achTierrasbasicasDesc =>
      'Have all five basic land types (plains, island, swamp, mountain and forest).';

  @override
  String get achFuerza => 'What a beast';

  @override
  String get achFuerzaDesc => 'Have a creature with power 10 or more.';

  @override
  String get achCoste => 'I\'m never casting this';

  @override
  String get achCosteDesc => 'Have a card with converted mana cost 10 or more.';

  @override
  String get achCostecero => 'Free';

  @override
  String get achCosteceroDesc => 'Have a card with cost 0.';

  @override
  String get achTipos => 'A bit of everything';

  @override
  String get achTiposDesc =>
      'Have at least one creature, one instant, one sorcery, one artifact, one enchantment, one land and one planeswalker.';

  @override
  String get achPlaneswalkers => 'Planeswalker company';

  @override
  String get achPlaneswalkersDesc => 'Have 5 different planeswalkers.';

  @override
  String get achNoventas => 'A relic from the 90s';

  @override
  String get achNoventasDesc => 'Have a card from the 1990s.';

  @override
  String get achIdiomas1 => 'I can\'t read this one';

  @override
  String get achIdiomas25 => 'Polyglot collection';

  @override
  String get achIdiomas1Desc => 'Have a card in a language other than English.';

  @override
  String get achIdiomas25Desc => 'Have 25 cards in other languages.';

  @override
  String get achWishlist => 'The list of whims';

  @override
  String get achWishlistDesc => 'Put 20 cards on your wishlist.';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Silver';

  @override
  String get achTierGold => 'Gold';

  @override
  String get achTierMythic => 'Mythic';

  @override
  String get achCatCollection => 'Collection';

  @override
  String get achCatRarity => 'Rarities';

  @override
  String get achCatColor => 'Colours';

  @override
  String get achCatSets => 'Sets';

  @override
  String get achCatValue => 'Value';

  @override
  String get achCatFoils => 'Foils';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Scanner';

  @override
  String get achCatDedication => 'Dedication';

  @override
  String get achCatFolders => 'Folders';

  @override
  String get achCatCuriosities => 'Oddities';

  @override
  String get achRankApprentice => 'Apprentice';

  @override
  String get achRankSummoner => 'Summoner';

  @override
  String get achRankMage => 'Mage';

  @override
  String get achRankArchmage => 'Archmage';

  @override
  String get achRankMaster => 'Master';

  @override
  String get achRankPlaneswalker => 'Planeswalker';

  @override
  String get bkConfirmWord => 'CONFIRM';

  @override
  String get rfTitle => 'Factory reset';

  @override
  String get rfIntro =>
      'Returns the app to a fresh install: no collection, no decks, no downloaded databases.';

  @override
  String get rfButton => 'Erase everything';

  @override
  String get rfConfirmTitle1 => 'Erase all data?';

  @override
  String get rfWillDelete =>
      'This will erase: your collection, decks, folders, achievements, certificates, wishlist, value history, settings and backgrounds, and the downloaded card, price and fingerprint databases.';

  @override
  String get rfBackupFirst =>
      'Before anything is erased, an automatic backup will be saved; you can restore it from Settings → Data.';

  @override
  String rfTypeWord(String palabra) {
    return 'Type $palabra to continue.';
  }

  @override
  String get rfDeleteWord => 'DELETE';

  @override
  String get rfContinueAction => 'Continue';

  @override
  String get rfConfirmTitle2 => 'Last confirmation';

  @override
  String get rfConfirmBody2 =>
      'This erases all your data on this device. The only way back is restoring the backup being saved now.';

  @override
  String get rfEraseAction => 'Erase for good';

  @override
  String get rfWorking => 'Erasing data… don\'t close the app.';

  @override
  String rfBackupFailed(String motivo) {
    return 'The backup could not be saved, so NOTHING was erased. $motivo';
  }

  @override
  String rfPartial(String cosas) {
    return 'Some items could not be erased: $cosas. You can retry from Settings after restarting.';
  }

  @override
  String get rfHalfDone =>
      'The erase was left half done. The app will return to the startup screen; if anything remains, retry the reset.';

  @override
  String dbErrCards(String codigo) {
    return 'The card database couldn\'t be downloaded (HTTP $codigo). Try again in a while.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'The fingerprint database couldn\'t be downloaded (HTTP $codigo). Try again in a while.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'The price history couldn\'t be downloaded (HTTP $codigo). Try again in a while.';
  }

  @override
  String ddCardCount(int n) {
    return '$n cards';
  }

  @override
  String get ddForgedWith => 'Forged with ManaForge';

  @override
  String get fxThemeLifegain => 'lifegain';

  @override
  String get fxThemeSacrifice => 'sacrifice';

  @override
  String get fxThemeSpells => 'spells';

  @override
  String get fxThemeArtifacts => 'artifacts';

  @override
  String get fxThemeCounters => '+1/+1 counters';

  @override
  String get fxThemeTokens => 'swarm';

  @override
  String get fxThemeGraveyard => 'graveyard';

  @override
  String get fxThemeReanimator => 'reanimator';

  @override
  String fxThemeTribal(String tribe) {
    return '$tribe tribal';
  }

  @override
  String get fxThemeGoodstuff => 'the best of your cards';

  @override
  String get fxTagLifegain =>
      'Every life point you gain is damage to them: drain and hold on.';

  @override
  String get fxTagSacrifice =>
      'Your creatures are worth more dead: sacrifice them and collect the toll.';

  @override
  String get fxTagSpells =>
      'Every instant counts: play on their turn and punish.';

  @override
  String get fxTagArtifacts =>
      'Set up your workshop: every artifact makes the others stronger.';

  @override
  String get fxTagCounters =>
      '+1/+1 counters: your creatures grow out of reach.';

  @override
  String get fxTagTokens =>
      'Flood the board with tokens: where they have one, you have five.';

  @override
  String get fxTagGraveyard =>
      'Your graveyard is your second hand: fill it and recycle the best.';

  @override
  String get fxTagAggro =>
      'Come out fast and hit their face: this game should end early.';

  @override
  String get fxTagTempo =>
      'Press early and protect your lead with your spells.';

  @override
  String fxTagMidrange(String tema) {
    return 'Trade your cards well and win the midgame with $tema.';
  }

  @override
  String get fxTagControl =>
      'Hold on, answer everything and finish when the board is yours.';

  @override
  String get fxMidLifegain =>
      'Chain your lifegain with the cards that punish them for it.';

  @override
  String get fxMidSacrifice =>
      'Sacrifice the cheap stuff to draw, drain or grow the rest.';

  @override
  String get fxMidSpells =>
      'Keep mana open: your creatures grow with every spell you cast.';

  @override
  String get fxMidArtifacts =>
      'Deploy cheap artifacts and turn on the ones that count them.';

  @override
  String get fxMidCounters =>
      'Pile counters on one or two creatures and protect them.';

  @override
  String get fxMidTokens =>
      'Make tokens every turn and look for the effects that pump them.';

  @override
  String get fxMidGraveyard =>
      'Mill and discard on purpose: what hits the graveyard comes back.';

  @override
  String get fxEndLifegain =>
      'With your life high, switch to aggro: they can\'t get there any more.';

  @override
  String get fxEndSacrifice =>
      'The value you piled up wins it: every trade is free for you.';

  @override
  String get fxEndSpells =>
      'A couple of spells in one turn and your creatures close it out.';

  @override
  String get fxEndArtifacts =>
      'Your board is worth twice theirs: finish with your payoffs.';

  @override
  String get fxEndCounters =>
      'One huge, protected threat ends the game in two swings.';

  @override
  String get fxEndTokens =>
      'Attack in force: no block holds off your whole army.';

  @override
  String get fxEndGraveyard =>
      'Reuse your best cards: you play with two hands against one.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => 'Play a creature every turn, no exceptions.';

  @override
  String get fxAggroMid => 'Keep attacking; save the burn to clear blockers.';

  @override
  String get fxAggroLate =>
      'Go for it all: this is where you should close the game.';

  @override
  String get fxTempoEarly => 'A cheap threat and open mana whenever you can.';

  @override
  String get fxTempoMid => 'Attack and use your spells on their turn.';

  @override
  String get fxTempoLate =>
      'Protect your creatures and close it in the air or with burn.';

  @override
  String get fxMidrangeEarly =>
      'Develop and don\'t give cards away: good one-for-one trades.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Deploy your $tema engines and stabilise the board.';
  }

  @override
  String get fxMidrangeLate =>
      'Your cards are worth more than theirs: turn that into the game.';

  @override
  String get fxControlEarly => 'A land a turn, and only answer what matters.';

  @override
  String get fxControlMid =>
      'Sweep the board and draw cards: time is on your side.';

  @override
  String get fxControlLate => 'Land one threat and protect it to the end.';

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
    return 'Average cost $coste: by Karsten\'s rule (24 lands at cost 3.0, ±1 for every ±0.5), this deck runs $tierras lands — within the range of a $arquetipo deck. There are $criaturas creatures to hold the board and $interaccion interaction cards for whatever they bring. The theme ($tema) focuses your synergies: the more theme pieces you see, the stronger each one gets.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'That curve leaves $tierras lands: outside the healthy range ($min-$max). Adjust the total number of spells.';
  }

  @override
  String get fxNoCards =>
      'Your collection doesn\'t have enough cards in these colours to fill that curve. Try fewer spells, or different costs.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'That curve (average cost $coste with $tierras lands) doesn\'t fit any healthy profile: a cheap deck wants fewer lands and an expensive one wants more. Bring them closer.';
  }

  @override
  String get fxNoBasics =>
      'There aren\'t enough basic lands in your collection for that curve.';

  @override
  String fxHardRule(String detalle) {
    return 'The curve you asked for breaks a hard rule: $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Cheap creatures and damage to the face: it kills you in 4-5 turns if you can\'t keep up.';

  @override
  String get tsPresetAzorius =>
      'Counterspells, sweepers and card draw: it drags the game out and wins with a couple of finishers.';

  @override
  String get tsPresetGolgari =>
      'One-for-one trades, efficient creatures and black removal: it wins the long game on card quality.';
}
