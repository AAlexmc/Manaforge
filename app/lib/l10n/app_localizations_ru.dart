// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tabHome => 'Главная';

  @override
  String get tabCollection => 'Коллекция';

  @override
  String get tabAlbum => 'Альбом';

  @override
  String get tabDecks => 'Колоды';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'Рынок';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get tabScan => 'Сканировать';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsIntro =>
      'ManaForge бесплатна, и её код открыт (лицензия PolyForm Noncommercial: делитесь и меняйте сколько угодно, но не продавайте). Без рекламы, без премиума, без аккаунтов. Ваши карты — ваши.';

  @override
  String get howItWorks => 'Как это работает';

  @override
  String get howScan =>
      'Поднесите карты к веб-камере или перетащите фото: они попадут в коллекцию с точным изданием.';

  @override
  String get howCollection =>
      'Всё, что у вас есть: поиск, фильтры и папки (папки — это метки: карта может лежать в нескольких).';

  @override
  String get howAlbum =>
      'По странице на выпуск, как альбом наклеек: что есть — в цвете, чего не хватает — блёклым, и во сколько обойдётся собрать.';

  @override
  String get howForge =>
      'Полные и легальные колоды из ваших карт. Или из выпуска, которого у вас ещё нет, — с подсказкой, что купить и почём.';

  @override
  String get howDecks =>
      'Сохранённые колоды. Если продадите карту, колода скажет об этом, а не сделает вид, что карта на месте.';

  @override
  String get howMarket =>
      'Сколько стоит коллекция, её график, список желаний с оповещениями о цене — и, если в CSV была цена покупки, сколько вы заработали или потеряли.';

  @override
  String get howPrivacy =>
      'Все расчёты идут на вашем устройстве. В сеть уходят только базы данных и, если оставите включённым, проверка новой версии.';

  @override
  String get shortcuts => 'Горячие клавиши';

  @override
  String get shortcutTabs => 'Переключить вкладку';

  @override
  String get shortcutScan => 'Открыть сканер';

  @override
  String get shortcutSearch => 'Искать на текущей вкладке';

  @override
  String get shortcutSettings => 'Настройки';

  @override
  String get shortcutClose => 'Закрыть то, что открыто сверху';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get versionTitle => 'Версия ManaForge';

  @override
  String versionYouHave(String version) {
    return 'У вас $version.';
  }

  @override
  String get versionSeeWhatsNew => 'Что нового';

  @override
  String get versionNotifyMe => 'Сообщать о новых версиях';

  @override
  String get versionNotifyMeWhy =>
      'Раз в день спрашивает у GitHub, какая версия последняя. Ничего не скачивает и не устанавливает.';

  @override
  String get versionCheckNow => 'Проверить сейчас';

  @override
  String get versionUpToDate =>
      'У вас последняя версия (или GitHub сейчас не отвечает).';

  @override
  String versionThereIs(String version) {
    return 'Вышла ManaForge $version.';
  }

  @override
  String get versionGoDownload => 'Перейти к загрузке';

  @override
  String versionNotAuto(String version) {
    return 'У вас $version. Приложение не обновляется само: оно откроет страницу загрузки.';
  }

  @override
  String get versionNotNow => 'Не сейчас';

  @override
  String get versionSee => 'Открыть';

  @override
  String whatsNewTitle(String version) {
    return 'Что нового в $version';
  }

  @override
  String get whatsNewClose => 'Играем';

  @override
  String get downloadCopyLink => 'Скопировать ссылку';

  @override
  String get downloadClose => 'Закрыть';

  @override
  String get downloadTitle => 'Скачать ManaForge';

  @override
  String get backgroundTitle => 'Фоновое изображение';

  @override
  String get backgroundWhat =>
      'Поставьте за приложением любую картинку. Wizards публикует официальные обои к каждому выпуску: скачайте понравившиеся и выберите здесь. Приложение не скачивает их само — у этих работ есть правообладатель, и раздавать их — не его дело.';

  @override
  String get backgroundPick => 'Выбрать изображение…';

  @override
  String get backgroundChange => 'Сменить изображение…';

  @override
  String get backgroundOfficial => 'Официальные обои Magic';

  @override
  String get backgroundRemove => 'Убрать фон';

  @override
  String get backgroundDim => 'Насколько затемнять (чтобы текст читался)';

  @override
  String get backgroundCardColor => 'Цвет карточек';

  @override
  String get backgroundTextColor => 'Цвет текста';

  @override
  String get backgroundCardOpacity => 'Насколько карточки закрывают фон';

  @override
  String get backgroundColorDefault => 'Обычный';

  @override
  String get backgroundPreview => 'Как это выглядит';

  @override
  String get backgroundNotAnImage =>
      'Выберите изображение (.jpg, .png или .webp) в качестве фона.';

  @override
  String get backgroundTooBig => 'Это изображение слишком большое для фона.';

  @override
  String get welcomeTitle =>
      'Добро пожаловать в кузницу. Добавьте карты как вам удобно — или попробуйте Forge, ещё не добавив ни одной.';

  @override
  String get welcomeScan => 'Отсканировать карты';

  @override
  String get welcomeImport => 'Импорт CSV';

  @override
  String get welcomeTryForge => 'Попробовать Forge без коллекции';

  @override
  String get decksEmptyGoForge => 'Перейти в Forge';

  @override
  String get yourCollection => 'Ваша коллекция';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies карт · $distinct уникальных';
  }

  @override
  String get marketArrow => 'Рынок ›';

  @override
  String get certHeadingSetComplete => 'СЕРТИФИКАТ О ПОЛНОЙ КОЛЛЕКЦИИ';

  @override
  String get certSubtitleSetComplete => 'Выпуск собран полностью';

  @override
  String get certHeadingWelcome => 'ПРИВЕТСТВЕННЫЙ СЕРТИФИКАТ';

  @override
  String get certWelcomeTitle => 'Добро пожаловать в мир Magic';

  @override
  String get certSubtitleWelcome => 'Твоя первая карта';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count карты',
      many: '$count карт',
      few: '$count карты',
      one: '$count карта',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return 'Я начал с $name';
  }

  @override
  String get certCollectorAnon => 'Коллекционер ManaForge';

  @override
  String certAwardedTo(String name) {
    return 'Вручается $name';
  }

  @override
  String certOnDate(String date) {
    return '$date';
  }

  @override
  String get certDataBy => 'Данные от Scryfall';

  @override
  String get onbCollectionTitle => 'Твоя коллекция';

  @override
  String get onbCollectionBody =>
      'Здесь все твои карты — по папкам и выпускам.';

  @override
  String get onbScanTitle => 'Сканируй карты';

  @override
  String get onbScanBody => 'Добавляй новые карты камерой или по фото.';

  @override
  String get onbForgeTitle => 'Куй колоды';

  @override
  String get onbForgeBody =>
      'Собирай полные колоды из карт, которые у тебя есть.';

  @override
  String get onbDecksTitle => 'Твои колоды';

  @override
  String get onbDecksBody => 'Колоды, сохранённые из Forge, появляются здесь.';

  @override
  String get onbSkip => 'Пропустить';

  @override
  String get onbNext => 'Далее';

  @override
  String get onbGotIt => 'Понятно';

  @override
  String get onbBack => 'Назад';

  @override
  String get tourMenuTitle => 'Гиды';

  @override
  String get tourWelcomeName => 'Быстрый тур';

  @override
  String get tourHomeName => 'Главный экран';

  @override
  String get onbEditHomeTitle => 'Настрой главный экран';

  @override
  String get onbEditHomeBody =>
      'Эта кнопка позволяет выбрать, какие разделы показывать на главном экране и в каком порядке.';

  @override
  String get onbLangTitle => 'Язык';

  @override
  String get onbLangBody => 'Смени здесь язык всего приложения.';

  @override
  String get onbLookTitle => 'Вид';

  @override
  String get onbLookBody =>
      'Поставь обои и выбери цвета карточек, текста, вкладок и значков.';

  @override
  String get tourSettingsName => 'Настроить приложение';

  @override
  String get tourFullName => 'Полный тур по приложению';

  @override
  String get tourCollectionName => 'Твоя коллекция и папки';

  @override
  String get tourForgeName => 'Собрать колоду';

  @override
  String get tourMarketName => 'Рынок, вишлист и оповещения';

  @override
  String get onbAllCardsTitle => 'Все карты';

  @override
  String get onbAllCardsBody =>
      'Вся твоя коллекция: поиск, фильтры и сортировка.';

  @override
  String get onbFoldersTitle => 'Папки';

  @override
  String get onbFoldersBody =>
      'Папки — это метки: группируй как хочешь, карта может быть сразу в нескольких. Кнопка «Новая» создаёт первую.';

  @override
  String get onbAlbumMineTitle => 'Альбом по изданиям';

  @override
  String get onbAlbumMineBody =>
      'Каждое издание со своими ячейками. Этот фильтр показывает только издания, где у тебя уже есть карты.';

  @override
  String get onbForgeBasicsTitle => 'Базовые земли';

  @override
  String get onbForgeBasicsBody =>
      'Если дома есть россыпь базовых земель, оставь включённым: Forge будет на них рассчитывать. Выключи — возьмёт только из коллекции.';

  @override
  String get onbForgeSetsTitle => 'Издания';

  @override
  String get onbForgeSetsBody =>
      'Ограничь, откуда берутся карты. Без выбора Forge использует всю коллекцию.';

  @override
  String get onbForgeMissingTitle => 'Карты, которых нет';

  @override
  String get onbForgeMissingBody =>
      'С этим Forge предлагает и недостающие карты, показывая, сколько их и сколько они стоят.';

  @override
  String get onbForgeDeepTitle => 'Глубокая ковка';

  @override
  String get onbForgeDeepBody =>
      'Перед показом предложений он заставляет их по-настоящему сыграть друг с другом: итоговый порядок учитывает реальные результаты, а не только статичный счёт. Отключи, если хочешь более быстрый результат.';

  @override
  String get onbForgeGoTitle => 'Собрать';

  @override
  String get onbForgeGoBody =>
      'Эта кнопка строит колоды. С большим числом изданий уходит несколько секунд.';

  @override
  String get onbForgeTestTitle => 'Режим теста';

  @override
  String get onbForgeTestBody =>
      'Сравни свою колоду с метовой и узнай, чего ей не хватает для победы.';

  @override
  String get onbMarketPickTitle => 'Выбор рынка';

  @override
  String get onbMarketPickBody =>
      'Cardmarket или TCGplayer: меняет цену каждой карты и её график.';

  @override
  String get onbWishlistTitle => 'Вишлист';

  @override
  String get onbWishlistBody =>
      'Карты, которые ты хочешь. Счётчик зеленеет, когда какая-то доходит до твоей цены.';

  @override
  String get onbPriceAlertTitle => 'Оповещение о цене';

  @override
  String get onbPriceAlertBody =>
      'Найди карту, нажми на закладку, чтобы добавить её в вишлист, и задай целевую цену: приложение сообщит, когда она упадёт.';

  @override
  String get tourProgressName => 'Достижения и сертификаты';

  @override
  String get onbAchievementsTitle => 'Достижения и уровень';

  @override
  String get onbAchievementsBody =>
      'Твой уровень и всё, что уже заработано. Он растёт от сканирования, порядка и сборки колод.';

  @override
  String get onbCertificatesTitle => 'Сертификаты';

  @override
  String get onbCertificatesBody =>
      'За крупные вехи выдаётся диплом: можно сохранить в PDF или показать. Они внутри достижений.';

  @override
  String get onbBackupTitle => 'Резервная копия';

  @override
  String get onbBackupBody =>
      'Сохрани коллекцию, колоды и папки в файл и верни их, если сменишь компьютер. Раз в неделю копия делается сама.';

  @override
  String onbTapHere(String pantalla) {
    return 'Нажми сюда, чтобы открыть: $pantalla.';
  }

  @override
  String get onbAchievementsName => 'Достижения';

  @override
  String get onbDataSectionTitle => 'Данные';

  @override
  String get onbDataSectionBody =>
      'Здесь всё, что приложение хранит: база карт и твои резервные копии.';

  @override
  String get onbCardDbTitle => 'База карт';

  @override
  String get onbCardDbBody =>
      'Скачай её заново ради новых карт, свежих цен и того, что требует свежих данных — например фильтра по году в Forge.';

  @override
  String get onbAboutTitle => 'О приложении';

  @override
  String get onbAboutBody =>
      'Что делает каждая вкладка, горячие клавиши, версия и лицензия.';

  @override
  String get colStartHere => 'Твоя коллекция начинается здесь';

  @override
  String get colNeedDb =>
      'Сначала мне нужна база данных со всеми картами Magic (скачивается один раз, потом всё работает без интернета).';

  @override
  String colDownloading(String pct) {
    return 'Скачиваю… $pct %';
  }

  @override
  String get colDownloadDb => 'Скачать базу данных карт';

  @override
  String get colScryfall =>
      'Данные и картинки от Scryfall · Без аккаунтов, без оплаты: всё остаётся на твоём устройстве.';

  @override
  String get colAlbumTooltip => 'Альбом по сетам';

  @override
  String get colImportTooltip => 'Импорт CSV коллекции';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies карт · $distinct уникальных$valor';
  }

  @override
  String get colAllCards => 'Все карты';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct уникальных · поиск, фильтры и сортировка';
  }

  @override
  String get colFolders => 'Папки';

  @override
  String get colNewFolder => 'Новая';

  @override
  String get colNoFolders =>
      'У тебя пока нет папок. Они группируют что угодно: «редкие из Aetherdrift», «на продажу», «коробка на верхней полке»… Одна карта может лежать в нескольких.';

  @override
  String get colCreateFirstFolder => 'Создать первую папку';

  @override
  String get colEmptyTitle => 'Тут начинается твоя коллекция';

  @override
  String get colEmptyBody =>
      'Отсканируй карты камерой или импортируй CSV своей коллекции. Они появятся здесь и в альбоме.';

  @override
  String get colImportShort => 'Импорт CSV';

  @override
  String acForgetTitle(String carta) {
    return 'У тебя больше нет $carta?';
  }

  @override
  String get acForgetBody =>
      'Она уходит из коллекции, а её место в альбоме снова пустеет.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Ещё она уходит из $n папок, где лежит.',
      many: 'Ещё она уходит из $n папок, где лежит.',
      few: 'Ещё она уходит из $n папок, где лежит.',
      one: 'Ещё она уходит из $n папки, где лежит.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Колоды её НЕ теряют: она остаётся в списке, и колода подскажет, что её не хватает.';

  @override
  String get acCancel => 'Отмена';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => 'Её у меня больше нет';

  @override
  String acAddedOn(String cuando) {
    return 'добавлена $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'в $n папках',
      many: 'в $n папках',
      few: 'в $n папках',
      one: 'в $n папке',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Найди карту (испанский или английский)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles из $total карт';
  }

  @override
  String get acMissingFilterData =>
      ' · у некоторых старых карт нет данных для фильтра: переимпортируй CSV с включённым «Заменить»';

  @override
  String get acNoneMatch => 'Ни одна карта не проходит эти фильтры.';

  @override
  String get acEmptyHint =>
      'Найди первую карту сверху или вернись назад и импортируй CSV своей коллекции.';

  @override
  String get onbHowItWorksBody =>
      'Кратко о том, что делает каждая вкладка, плюс горячие клавиши. Если запутался, начни отсюда.';

  @override
  String get onbVersionBody =>
      'Какая у тебя версия, что в ней есть и хочешь ли, чтобы приложение раз в день проверяло, нет ли новой. Само оно не обновляется.';

  @override
  String get onbSuggestionsTitle => 'Ящик предложений';

  @override
  String get onbSuggestionsBody =>
      'Есть идея или нашёл баг? Расскажи на GitHub: там есть шаблон, и это займёт минуту.';

  @override
  String get onbSupportTitle => 'Поддержать проект';

  @override
  String get onbSupportBody =>
      'Приложение бесплатное и без рекламы. Если оно было полезно, вот как угостить нас кофе.';

  @override
  String get onbScanSetTitle => 'Сет: все';

  @override
  String get onbScanSetBody =>
      'Если вскрываешь бустеры ОДНОГО сета, зафиксируй его здесь: сканер перестанет метаться между десятью переизданиями одной карты.';

  @override
  String get onbScanModeTitle => 'Быстро или аккуратно';

  @override
  String get onbScanModeBody =>
      'В «Быстро» ясные карты добавляются сами, а сомнительные помечаются на проверку. В «Аккуратно» сканер останавливается и спрашивает, какая это карта.';

  @override
  String get onbScanPhotoTitle => 'Отсканировать фото';

  @override
  String get onbScanPhotoBody =>
      'Нет камеры или карты уже сфотографированы? Брось сюда фото — хоть с несколькими картами — и он всё равно их вытащит.';

  @override
  String get tourScanName => 'Сканер';

  @override
  String get albNeedDb =>
      'Альбому нужна база данных карт (скачай её в Коллекции).';

  @override
  String get albRetry => 'Повторить';

  @override
  String get albApproxMode =>
      'Альбом в грубом режиме: я пока не знаю, какое именно ИЗДАНИЕ каждой карты у тебя есть. Переимпортируй CSV с включённым «Заменить мою текущую коллекцию», и альбом уточнится по иллюстрациям.';

  @override
  String get albSearchSet => 'Найди сет…';

  @override
  String get albOnlyMine => 'С моими картами';

  @override
  String get albSortProgress => 'Сначала полные';

  @override
  String get albSortNewest => 'Сначала новые';

  @override
  String get albSortOldest => 'Сначала старые';

  @override
  String get albSortName => 'По названию';

  @override
  String get albYearAll => 'Год: все';

  @override
  String get albLetterAll => 'Все';

  @override
  String get albNoSets => 'Ни один сет не подходит под фильтр.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total карт';
  }

  @override
  String get albComplete => ' · ✓ собран!';

  @override
  String albLoadError(String error) {
    return 'Не удалось загрузить сет: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Искать в $set…';
  }

  @override
  String get albOnlyMissing => 'Только недостающие';

  @override
  String get albWithVariants => 'С вариантами';

  @override
  String get albYouHaveItAll => '✓ Собран полностью';

  @override
  String albMissingCount(int n) {
    return 'Не хватает $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n без цены)';
  }

  @override
  String albNoPerPrinting(String market) {
    return '$market no publica precios por edición — elige otro en la pestaña Mercado';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles из $total';
  }

  @override
  String get albNoCardsNamed => 'Здесь нет карт с таким названием.';

  @override
  String get fdNewFolder => 'Новая папка';

  @override
  String get fdEditFolder => 'Изменить папку';

  @override
  String get fdName => 'Название';

  @override
  String get fdNameHint => 'Редкие из Aetherdrift, На продажу…';

  @override
  String get fdColor => 'Цвет';

  @override
  String get fdIcon => 'Значок';

  @override
  String get fdCreate => 'Создать';

  @override
  String get fdSave => 'Сохранить';

  @override
  String get fdDefaultName => 'Папка';

  @override
  String fdDeleteTitle(String nombre) {
    return 'Удалить «$nombre»?';
  }

  @override
  String get fdDeleteBody =>
      'Удаляется только папка: карты остаются в коллекции.';

  @override
  String get fdDelete => 'Удалить';

  @override
  String get fdGone => 'Этой папки больше нет.';

  @override
  String get fdEditTooltip => 'Изменить название, цвет и значок';

  @override
  String get fdDeleteTooltip => 'Удалить папку';

  @override
  String get fdAddRemove => 'Добавить или убрать';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas уникальных карт · $copias копий';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n проходят фильтр';
  }

  @override
  String get fdRoughValue => ' · примерная стоимость';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n карт уже нет в коллекции (остаются в списке, вдруг вернутся).',
      many: '$n карт уже нет в коллекции (остаются в списке, вдруг вернутся).',
      few: '$n карт уже нет в коллекции (остаются в списке, вдруг вернутся).',
      one: '$n карты уже нет в коллекции (остаётся в списке, вдруг вернётся).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Убрать их';

  @override
  String get fdNoneMatch => 'Ни одна карта из папки не проходит эти фильтры.';

  @override
  String get fdEmpty =>
      'Папка пустая. Нажми «Добавить или убрать» и отметь карты, которые хочешь положить.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n копий',
      many: '$n копий',
      few: '$n копии',
      one: '$n копия',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Убрать из папки';

  @override
  String get fpPickCards => 'Выбери карты';

  @override
  String fpSaveCount(int n) {
    return 'Сохранить ($n)';
  }

  @override
  String get fpFilterByName => 'Фильтр по названию…';

  @override
  String fpVisibleCards(int n) {
    return '$n карт на виду';
  }

  @override
  String get fpSelectAll => 'Выбрать все';

  @override
  String get fpNoneMatch => 'Ни одна карта не проходит эти фильтры.';

  @override
  String get fgMsgReading => 'Читаю твою коллекцию…';

  @override
  String get fgMsgCurve => 'Считаю кривую маны…';

  @override
  String get fgMsgLands => 'Раскладываю земли…';

  @override
  String get fgMsgSynergy => 'Ищу синергии…';

  @override
  String get fgMsgPlan => 'Пишу твой план игры…';

  @override
  String get fgNeedDbForSets =>
      'Чтобы перечислить сеты, нужна база карт: Настройки → скачать базу.';

  @override
  String fgDbError(String error) {
    return 'Не удалось прочитать базу данных карт: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' в $n сетах',
      many: ' в $n сетах',
      few: ' в $n сетах',
      one: ' в $n сете',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'Не выходит легальная колода Commander$donde: нужен легендарный командир и ~62 РАЗНЫЕ карты в его цветовой идентичности (это синглтон), плюс достаточно базовых земель. Попробуй другой формат, другие сеты или расширь коллекцию.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'С картами из этого пула не выходит ни одной полной колоды $formato, которая соблюдает мои правила (достаточно земель и здоровая кривая)$donde. $consejo Лучше предупрежу, чем выдам кривую колоду.';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return 'С этим Стилем ($estilo) колода не получается. Попробуй «Стиль: авто» или другое племя.';
  }

  @override
  String get fgOf60 => 'на 60 карт';

  @override
  String fgLegalIn(String formato) {
    return 'ЛЕГАЛЬНО в $formato';
  }

  @override
  String get fgTipMoreSets => 'Попробуй больше сетов или убери фильтры.';

  @override
  String get fgTipMoreCards =>
      'Добавь больше карт — особенно своих основных цветов — или отметь «включить карты, которых у меня нет».';

  @override
  String get fgPitch =>
      'Полные, играбельные колоды из карт, которые у тебя уже есть. Ничего не покупая.';

  @override
  String get fgTeaserCount => 'карт для твоей первой колоды';

  @override
  String get fgTeaserMissing => 'Собрать колоду из карт, которых у меня нет';

  @override
  String get fgBasics => 'У меня есть россыпь базовых земель';

  @override
  String get fgBasicsSub =>
      'Почти у всех есть базовые из стартовых колод; выключи, чтобы использовать ТОЛЬКО базовые из своей коллекции.';

  @override
  String get fgFormat => 'Формат игры';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 карт · синглтон · легендарный командир из твоей коллекции · цветовая идентичность соблюдена.';

  @override
  String get fgCasualNote =>
      '60 карт, без ограничений по легальности: годится всё.';

  @override
  String fgFormatNote(String formato) {
    return '60 карт ТОЛЬКО из твоих карт, легальных в $formato.';
  }

  @override
  String get fgWhereFrom => 'Откуда берутся карты?';

  @override
  String get fgPickSets => 'Выбрать сеты';

  @override
  String get fgChangeSets => 'Сменить сеты';

  @override
  String get fgNeedOneSet =>
      'Выбери хотя бы один сет: без фильтра это все ~30 000 карт Magic.';

  @override
  String get fgNoSetsNote =>
      'Без выбранных сетов Forge берёт всю твою коллекцию.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Карты из $n сетов, есть они у тебя или нет.',
      many: 'Карты из $n сетов, есть они у тебя или нет.',
      few: 'Карты из $n сетов, есть они у тебя или нет.',
      one: 'Карты из $n сета, есть они у тебя или нет.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Только твои карты из $n сетов — не вся коллекция.',
      many: 'Только твои карты из $n сетов — не вся коллекция.',
      few: 'Только твои карты из $n сетов — не вся коллекция.',
      one: 'Только твои карты из $n сета — не вся коллекция.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'В твоей коллекции не записано издание каждой карты, поэтому фильтр по сету отсёк бы почти всё. Переимпортируй CSV с «Заменить» и возвращайся.';

  @override
  String get fgIncludeMissing => 'Включить карты, которых у меня нет';

  @override
  String get fgIncludeMissingSub =>
      'Forge перестаёт ограничиваться твоей коллекцией и берёт ВСЁ, что напечатано в этих сетах; потом скажет, сколько карт тебе не хватает и сколько они стоят.';

  @override
  String get fgYourTaste => 'На твой вкус (необязательно)';

  @override
  String get fgArchetypeAuto => 'Архетип: авто';

  @override
  String get fgStyle => 'Стиль';

  @override
  String get fgStyleAuto => 'Стиль: авто';

  @override
  String get fgTribeElf => 'Эльфы';

  @override
  String get fgTribeGoblin => 'Гоблины';

  @override
  String get fgTribeZombie => 'Зомби';

  @override
  String get fgTribeVampire => 'Вампиры';

  @override
  String get fgTribeDragon => 'Драконы';

  @override
  String get fgTribeAngel => 'Ангелы';

  @override
  String get fgTribeDemon => 'Демоны';

  @override
  String get fgTribeDinosaur => 'Динозавры';

  @override
  String get fgTribeFaerie => 'Феи';

  @override
  String get fgTribeMerfolk => 'Мерфолки';

  @override
  String get fgTribeHuman => 'Люди';

  @override
  String get fgTribeSpirit => 'Духи';

  @override
  String get fgTribeSliver => 'Сливеры';

  @override
  String get fgTribeWizard => 'Волшебники';

  @override
  String get fgTribeKnight => 'Рыцари';

  @override
  String get fgTribeWarrior => 'Воины';

  @override
  String get fgTribeSoldier => 'Солдаты';

  @override
  String get fgTribeCat => 'Кошки';

  @override
  String get fgTribeDog => 'Собаки';

  @override
  String get fgTribeRat => 'Крысы';

  @override
  String get fgTribePirate => 'Пираты';

  @override
  String get fgTribeElemental => 'Элементали';

  @override
  String get fgTribeGiant => 'Великаны';

  @override
  String get fgTribeRogue => 'Разбойники';

  @override
  String get fgDeepForge => 'Глубокая ковка';

  @override
  String get fgDeepForgeHint =>
      'Перед показом предложений заставляет их реально сыграть друг с другом (займёт чуть больше времени).';

  @override
  String get fgPricePerCard => 'Цена за карту:';

  @override
  String get fgMin => 'мин €';

  @override
  String get fgMax => 'макс €';

  @override
  String get fgCardYear => 'Год карты:';

  @override
  String get fgFrom => 'от';

  @override
  String get fgTo => 'до';

  @override
  String get fgYearNeedsDb =>
      'Фильтру по году нужна свежая база данных: Настройки → Скачать базу заново.';

  @override
  String get fgNoColorsNote =>
      'Без выбранных цветов Forge пробует все комбинации.';

  @override
  String fgColorsNote(String colores) {
    return 'Только колоды $colores (и их комбинации).';
  }

  @override
  String get fgMissingNote =>
      'В этой колоде могут быть карты, которых у тебя НЕТ: каждый вариант говорит, скольких не хватает и сколько они стоят (цена Cardmarket).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge берёт только твои $n карт. Он не выдумывает копии, которых у тебя нет.';
  }

  @override
  String get fgForgeMissing => 'Ковать колоды (с недостающими)';

  @override
  String get fgForgeMine => 'Ковать мои колоды';

  @override
  String get fgTestMode => 'Режим Тест: побей колоду меты';

  @override
  String get fgOffline => 'Всё считается на твоём устройстве, без интернета';

  @override
  String fgForgingWith(int n) {
    return 'Куёшь из $n карт: это займёт несколько секунд. Окно живо.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n колод готовы к игре',
      many: '$n колод готовы к игре',
      few: '$n колоды готовы к игре',
      one: '$n колода готова к игре',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'С картами, которых у тебя ещё нет · листай, чтобы сравнить';

  @override
  String get fgSwipeMine =>
      'Собраны только из твоих карт · листай, чтобы сравнить';

  @override
  String get fgHaveAll => '✓ У тебя есть все карты';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Не хватает $n карт',
      many: 'Не хватает $n карт',
      few: 'Не хватает $n карт',
      one: 'Не хватает $n карты',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Показать всю колоду';

  @override
  String get fgReforge => 'Перековать';

  @override
  String get fgBackToOptions => 'Volver a elegir cómo forjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta стоит $precio (твоя цель: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 $n карт из твоего вишлиста упали до целевой цены!';
  }

  @override
  String get mkTellMeWhenDrops => 'Сообщи, когда подешевеет';

  @override
  String get mkTargetPrice => 'Целевая цена';

  @override
  String mkNow(String precio) {
    return 'Сейчас: $precio';
  }

  @override
  String get mkUpdated => '✓ Цены и карты обновлены';

  @override
  String mkUpdateFailed(String error) {
    return 'Не удалось обновить: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ История цен готова: графики уже показывают последние месяцы';

  @override
  String mkHistoryFailed(String error) {
    return 'Не удалось загрузить историю (та, что была, не тронута): $error';
  }

  @override
  String get mkHistoryLocal =>
      'История цен: только та, что ManaForge ежедневно записывает на твоём компьютере. Загрузи реальные последние ~90 дней с Cardmarket (≈4 МБ).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Реальная история Cardmarket с $desde по $hasta, а дальше — то, что записывает ManaForge.';
  }

  @override
  String get mkFetchHistory => 'Загрузить историю';

  @override
  String get mkCollectionValue => 'Сколько стоит твоя коллекция · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n карт';
  }

  @override
  String get mkApproxSuffix => ' · примерная стоимость';

  @override
  String mkBulkPrices(String fecha) {
    return 'Цены Cardmarket на $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'В Рынке нет данных: скачай базу в Коллекции. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'СЕТЫ ($n)';
  }

  @override
  String get mkPrevious => 'Назад';

  @override
  String get mkNext => 'Дальше';

  @override
  String get mkSearchHint => 'Узнай цену любой карты…';

  @override
  String get mkRemoveFromWishlist => 'Убрать из вишлиста';

  @override
  String get mkAddToWishlist => 'В вишлист: сообщи, когда подешевеет';

  @override
  String get mkYourWishlist => 'ТВОЙ ВИШЛИСТ';

  @override
  String mkTargetAtMost(String precio) {
    return 'цель ≤ $precio';
  }

  @override
  String get mkAtPrice => 'по твоей цене!';

  @override
  String get mkChangeTarget => 'Сменить целевую цену';

  @override
  String mkNoPriceIn(String market) {
    return 'нет цены на $market';
  }

  @override
  String get mkPerUnit => '/шт';

  @override
  String get mkTopCards => 'ТВОИ САМЫЕ ЦЕННЫЕ КАРТЫ';

  @override
  String get mkImportToSeeValue =>
      'Импортируй коллекцию, чтобы увидеть её стоимость.';

  @override
  String mkSetCards(int n) {
    return ' · $n карт';
  }

  @override
  String get wlEmpty =>
      'Ищи их в Рынке и жми на закладку, чтобы получить сигнал, когда они упадут до твоей цены.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '🔔 $n карт из вишлиста по целевой цене или ниже.',
      many: '🔔 $n карт из вишлиста по целевой цене или ниже.',
      few: '🔔 $n карты из вишлиста по целевой цене или ниже.',
      one: '🔔 $n карта из вишлиста по целевой цене или ниже.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'Цены MTGO в tix (цифровые карты)';

  @override
  String get mpNoDataYet => 'Пока нет данных: обнови историю цен в Рынке';

  @override
  String get mpMtgoNote =>
      'Цены MTGO в tix: это цифровые карты, для оценки бумажной коллекции не годятся. Главная, папки и достижения остаются на Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return 'Цены $mercado в $moneda. Главная, папки и достижения по-прежнему считают в Cardmarket (€): валюты не конвертируются.';
  }

  @override
  String get mkUpdate => 'Обновить';

  @override
  String get mkApproxValue =>
      ' · примерная стоимость (переимпортируй с «Заменить» для цен по изданиям)';

  @override
  String get mkExactPrintings => ' · по твоим точным изданиям';

  @override
  String mkNowSuffix(String precio) {
    return ' · сейчас $precio';
  }

  @override
  String get wlNothingYet => 'В вишлисте пока нет карт.';

  @override
  String get stDbUpdated => '✓ База данных обновлена';

  @override
  String stUpdateFailed(String error) {
    return 'Не удалось обновить: $error';
  }

  @override
  String get stCardDb => 'База данных карт';

  @override
  String get stCardDbWhy =>
      'Скачай заново, чтобы получить новые карты, свежие цены и функции, которым нужны недавние данные (например, фильтр по году в Forge).';

  @override
  String get stDownloadDbAgain => 'Скачать базу данных заново';

  @override
  String get stAppearance => 'Вид';

  @override
  String get stData => 'Данные';

  @override
  String get stTheApp => 'Приложение';

  @override
  String get stCredits =>
      'Данные и изображения карт от Scryfall. Magic: The Gathering принадлежит Wizards of the Coast; фанатский проект в рамках их Fan Content Policy.';

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
  String get stEditHome => 'Настроить Главную';

  @override
  String get stEditHomeSub => 'Выбери, какие разделы видны и в каком порядке';

  @override
  String get ehLevel => 'Твой уровень';

  @override
  String get ehShortcuts => 'Быстрые действия';

  @override
  String get ehSummary => 'Сводка по коллекции';

  @override
  String get ehRecent => 'Недавно просмотренные';

  @override
  String get ehDecks => 'Твои колоды';

  @override
  String get ehMeta => 'Мета сейчас';

  @override
  String get ehNewSets => 'Новые сеты';

  @override
  String get ehGems => 'Твои жемчужины';

  @override
  String get ehStatCards => 'карты';

  @override
  String get ehStatDistinct => 'уникальных';

  @override
  String get ehStatValue => 'стоимость';

  @override
  String get ehStatDecks => 'колоды';

  @override
  String get ehStatAchievements => 'достижения';

  @override
  String get ehHelp =>
      'Перетаскивай, чтобы менять порядок, и переключателем выбирай, что видишь на Главной. Включённый раздел появляется, только если ему есть что показать.';

  @override
  String get ehSection => 'Раздел';

  @override
  String get bkNoData => 'Не нахожу твои данные.';

  @override
  String bkSaved(String resumen) {
    return '✓ Копия сохранена · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get bkFileName => 'Копия ManaForge';

  @override
  String bkRestoreFailed(String error) {
    return 'Не удалось восстановить: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Восстановлено · $resumen. ВНИМАНИЕ: не удалось сохранить то, что было раньше ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Восстановлено · $resumen. То, что было раньше, сохранено в папке backups.';
  }

  @override
  String get bkRestoring => 'Восстанавливаю твою копию…';

  @override
  String get bkTitle => 'Резервная копия';

  @override
  String get bkWhy =>
      'Твои карты, колоды, папки и достижения живут только на этом компьютере. Время от времени сохраняй копию и держи её в другом месте: на диске, в облаке, где угодно.';

  @override
  String get bkSave => 'Сохранить копию';

  @override
  String get bkRestoreTitle => 'Восстановить копию';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Восстановление ЗАМЕНЯЕТ твои нынешние карты, колоды, папки и достижения теми, что в копии. Выбери какую, нажми кнопку и введи $palabra: так ничего не восстановится случайно.';
  }

  @override
  String get bkNoBackups => 'На этом компьютере пока нет сохранённых копий.';

  @override
  String get bkWhich => 'Копия для восстановления';

  @override
  String get bkPickOne => 'Выбери копию';

  @override
  String get bkRestorePicked => 'Восстановить выбранную копию';

  @override
  String get bkAutoNote =>
      'Раз в неделю я сохраняю автоматическую копию (последние пять) и ещё одну прямо перед каждым восстановлением.';

  @override
  String get bkFromFile => 'Восстановить из файла';

  @override
  String get bkConfirmTitle => 'Восстановить эту копию?';

  @override
  String get bkConfirmBody =>
      'Это заменит твою нынешнюю коллекцию, колоды, папки и достижения теми, что в этой копии. Перед этим я сохраню то, что есть, в папке backups — на случай, если захочешь вернуться.';

  @override
  String bkWillDelete(String cosas) {
    return 'В этой копии нет $cosas: при восстановлении это сотрётся.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Введи $palabra, чтобы продолжить:';
  }

  @override
  String get bkAnd => ' и ';

  @override
  String get ehReset => 'Сбросить';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Копия от $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'Не нахожу ни одной камеры.';

  @override
  String get lsCameraGone =>
      'Камера отключилась посреди сессии. Проверь кабель и нажми Повторить.';

  @override
  String get lsFrameCard => 'Помести карту в рамку';

  @override
  String get lsNoCardThere => 'Не вижу там карты';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n карт в коллекцию',
      many: '✓ $n карт в коллекцию',
      few: '✓ $n карты в коллекцию',
      one: '✓ $n карта в коллекцию',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', и в «$carpeta»';
  }

  @override
  String get lsTitle => 'Сканировать вживую';

  @override
  String get lsQuickTip =>
      'Быстро: ясные карты добавляются сами; сомнительные помечаются на проверку.';

  @override
  String get lsCarefulTip =>
      'Аккуратно: сомнительные останавливаются и спрашивают, какая это карта.';

  @override
  String get lsQuick => 'Быстро';

  @override
  String get lsCareful => 'Аккуратно';

  @override
  String lsThisSession(int n) {
    return '$n за эту сессию';
  }

  @override
  String get lsScanPhotoTooltip => 'Отсканировать отдельное фото';

  @override
  String get lsStartingCamera => 'Включаю камеру…';

  @override
  String get lsCantUseCamera => 'Не могу использовать камеру';

  @override
  String get lsCameraUnavailable => 'Камера недоступна.';

  @override
  String get lsScanPhoto => 'Отсканировать фото';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 такая же · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Уже на столе: $carta · убери и положи снова или нажми «+1 такая же»';
  }

  @override
  String lsSeeing(String carta) {
    return 'Вижу: $carta';
  }

  @override
  String get lsPassACard => 'Поднеси карту к камере…';

  @override
  String lsIsThis(String carta) {
    return 'Это $carta? Не уверен — нажми, чтобы выбрать.';
  }

  @override
  String get lsNotThisOne => 'Не эта — сменить версию';

  @override
  String get lsRetry => 'Повторить';

  @override
  String get scBadImage =>
      'Не удалось прочитать это изображение (это точно фото?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Без папки';

  @override
  String scAlsoTo(String carpeta) {
    return 'И ещё в: $carpeta';
  }

  @override
  String get scLookingForCard => 'Ищу карту на фото…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Распознаю… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n карт',
      many: '$n карт',
      few: '$n карты',
      one: '$n карта',
    );
    return '$_temp0 · $copias всего';
  }

  @override
  String scToReview(int n) {
    return '$n на проверку (нажми на них)';
  }

  @override
  String scUnknown(int n) {
    return '$n не распознано (нажми, чтобы выбрать вручную)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n фото пропущено (слишком большие или нечитаемые)',
      one: '1 фото пропущено (слишком большое или нечитаемое)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'Не распознал ни одной карты на этих фото. Попробуй лучше свет или меньше бликов.';

  @override
  String scAddN(int n) {
    return 'Добавить $n в коллекцию';
  }

  @override
  String get scDropPhotos => 'Брось сюда фото своих карт';

  @override
  String get scDropExplain =>
      'Одно или несколько сразу — а если на фото НЕСКОЛЬКО карт (страница альбома, полный стол), я вытащу их все и соберу в один список, чтобы ты проверил и добавил, какие захочешь. Подойдёт и фото с телефона, и скан.';

  @override
  String get scPickPhotos => 'Выбрать фото';

  @override
  String get scMatchHigh => 'точное совпадение';

  @override
  String get scMatchMedium => 'среднее совпадение';

  @override
  String get scMatchLow => 'слабое совпадение';

  @override
  String get scAddToCollection => 'Добавить в коллекцию';

  @override
  String get scSeeOptions => 'Не эта — показать варианты';

  @override
  String get scScanAnother => 'Отсканировать ещё';

  @override
  String get scNotSure => 'Не уверен';

  @override
  String get scWhichIsIt => 'Какая это?';

  @override
  String get scNoneQuiteFits =>
      'Ни одна не подходит целиком. Может, одна из этих? Если нет, попробуй другое фото с лучшим светом.';

  @override
  String get scNoEdges =>
      'Я не разглядел края карты, поэтому взял всё изображение. Вот похожие:';

  @override
  String get scCropped => 'Вот что я обрезал. Кандидаты, по схожести:';

  @override
  String get scDiscard => 'Отбросить и отсканировать другую';

  @override
  String get suCardsName => 'Карты и цены';

  @override
  String get suCardsWhat => 'полный каталог Scryfall';

  @override
  String get suHistoryName => 'История цен';

  @override
  String get suHistoryWhat => '~90 дней Cardmarket';

  @override
  String get suHashesName => 'Отпечатки сканера';

  @override
  String get suHashesWhat => 'чтобы распознавать по фото';

  @override
  String suUpToDate(String fecha) {
    return 'актуально ($fecha)';
  }

  @override
  String get suUpdated => 'обновлено';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'обновлено ($fecha)';
  }

  @override
  String get suFailedOffline => 'не удалось загрузить (нет связи)';

  @override
  String get suKeepingOld => 'остаюсь с той, что была';

  @override
  String get suNeedMissing => 'не хватает, загружаю';

  @override
  String get suNeedStale => 'есть новая';

  @override
  String get suNeedFresh => 'актуально';

  @override
  String get suAllUpToDate => 'Всё актуально. Захожу…';

  @override
  String get suUpdatingCards => 'Обновляю твои карты и цены…';

  @override
  String get suChecking => 'Проверяю, нет ли нового…';

  @override
  String get suNoDownloadNote =>
      'То, что уже актуально, не скачивается. Внутри приложения можно принудительно обновить что угодно.';

  @override
  String get suEnter => 'Войти';

  @override
  String get suEnterNow => 'Войти сейчас';

  @override
  String icBadFile(String error) {
    return 'Не удалось прочитать файл: $error';
  }

  @override
  String get icNotCsv => 'Это не похоже на CSV — брось файл .csv или .txt.';

  @override
  String get icTitle => 'Импорт коллекции';

  @override
  String get icExplain =>
      'Перетащи сюда CSV своей коллекции (подойдёт Moxfield, Archidekt или любой CSV со столбцами Name и Quantity), выбери его кнопкой или вставь содержимое вручную:';

  @override
  String get icPickFile => 'Выбрать файл…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas карт ($copias копий) добавлено в твою коллекцию.';
  }

  @override
  String get icReplaceMine => 'Заменить мою текущую коллекцию';

  @override
  String get icReplaceWhy =>
      'Включи при переимпорте полного CSV: это не задвоит количества и уточнит альбом по изданиям.';

  @override
  String icImporting(int hechas, int total) {
    return 'Импортирую $hechas из $total карт…';
  }

  @override
  String get icDropHere => 'Брось сюда свой CSV';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n токенов/эмблем пропущено (в колоды они не идут, всё в порядке).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Не распознано: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• В CSV нет цены покупки: не будет P&L (экспортируй её со столбцом «Purchase price»).';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n копий с ценой покупки: теперь можно смотреть P&L в Рынке.';
  }

  @override
  String get icImporting2 => 'Импортирую…';

  @override
  String get icImport => 'Импорт';

  @override
  String dkDeleted(String nombre) {
    return 'Колода «$nombre» удалена';
  }

  @override
  String get dkUndo => 'ОТМЕНИТЬ';

  @override
  String dkOpenFailed(String error) {
    return 'Не удалось открыть колоду (база данных скачана?): $error';
  }

  @override
  String get dkMyDecks => 'Мои колоды';

  @override
  String get dkEmpty =>
      'Здесь будут жить колоды, которые ты сохранишь из Forge (кнопка сохранения в деталях колоды).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сохранено',
      many: '$n сохранено',
      few: '$n сохранены',
      one: '$n сохранена',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos заклинаний + $tierras земель · сохранена $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Удалить колоду';

  @override
  String get ddSaved => '✓ Колода сохранена — она во вкладке Колоды';

  @override
  String get ddReforged =>
      '✓ Колода перекована под твою кривую — список обновлён';

  @override
  String get ddSaveToMyDecks => 'Сохранить в Мои колоды';

  @override
  String get ddCopyList => 'Скопировать список (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ Список скопирован — вставь в Moxfield, Arena или Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos заклинаний + $tierras земель';
  }

  @override
  String get ddHaveAll => '✓ У тебя есть все карты';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ Не хватает $n карт из этой колоды — они остаются в списке, не удалены',
      many:
          '⚠ Не хватает $n карт из этой колоды — они остаются в списке, не удалены',
      few:
          '⚠ Не хватает $n карт из этой колоды — они остаются в списке, не удалены',
      one:
          '⚠ Не хватает $n карты из этой колоды — она остаётся в списке, не удалена',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Твой план игры';

  @override
  String get ddManaCurve => 'Кривая маны';

  @override
  String get ddEditCurve => 'Изменить кривую';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Тяни столбцы ↑↓ · $hechizos заклинаний → $tierras земель';
  }

  @override
  String get ddReforgeCurve => 'Перековать с этой кривой';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras земель · ✦ $hechizos заклинаний · Ø стоимость $coste';
  }

  @override
  String get ddWhyWorks => 'Почему эта колода работает?';

  @override
  String ddLands(int n) {
    return 'ЗЕМЛИ ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Всего за колоду: ~$precio €';
  }

  @override
  String get ddCheapestPrice => 'цена самого дешёвого издания (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n без известной цены · самое дешёвое издание (Cardmarket)';
  }

  @override
  String get ddInstants => 'Мгновенные заклинания';

  @override
  String get ddTypeCreatures => 'Существа';

  @override
  String get ddTypeSorceries => 'Волшебства';

  @override
  String get ddTypeEnchantments => 'Чары';

  @override
  String get ddTypeArtifacts => 'Артефакты';

  @override
  String get ddTypeOther => 'Прочее';

  @override
  String get ddOutOfRange => '  (вне здорового диапазона 20-27)';

  @override
  String get acRecalcTitle => 'Пересчитать достижения?';

  @override
  String get acRecalcBody =>
      'Твои карты проверяются заново, и достижения, которые сегодня не выполняются, снимаются. Помогает исправить выданные по ошибке; если ты продал карты, потеряешь и их.';

  @override
  String get acRecalc => 'Пересчитать';

  @override
  String get acAllFine => 'Всё сошлось: ни одно достижение не снято.';

  @override
  String acRemovedN(int n) {
    return 'Снято $n достижений, которые больше не выполняются.';
  }

  @override
  String get acTitle => 'Достижения';

  @override
  String get acRecalcTooltip => 'Пересчитать по моим нынешним картам';

  @override
  String get acCertsTooltip => 'Сертификаты';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos из $total достижений · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Уровень $nivel · до $siguiente осталось $xp XP';
  }

  @override
  String get acIMissing => 'Не хватает';

  @override
  String get acSecret => 'Секретное достижение';

  @override
  String get acSecretDesc => 'Откроется, только когда его получишь.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Получено$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return 'Уровень $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'Теперь ты $titulo. У тебя $hechos из $total достижений.';
  }

  @override
  String get acOk => 'Ок';

  @override
  String get acSeeAchievements => 'Показать достижения';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 Достижение! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (и ещё $n)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Для сетовых нужна база данных карт ($error)';
  }

  @override
  String get ceWhoseName => 'На чьё имя?';

  @override
  String get ceCollectorName => 'Твоё имя коллекционера';

  @override
  String get ceInNameOf => 'На имя…';

  @override
  String get ceEmptyWithData =>
      'У тебя пока нет ни одного собранного сета. Когда соберёшь один целиком в Альбоме, здесь появится сертификат для скачивания.';

  @override
  String get ceEmptyNoData =>
      'Чтобы сертифицировать сет, нужно знать точное издание твоих карт: переимпортируй CSV со Scryfall ID.';

  @override
  String get ceNothingSaved => 'Ничего не сохранено.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Сертификат сохранён в $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get cePickFirstCard => 'Выбрать карту, с которой я начал';

  @override
  String get ceChangeFirstCard => 'Сменить карту, с которой я начал';

  @override
  String get ceDownloadPng => 'Скачать PNG';

  @override
  String get cdNotFound => 'Не нахожу эту карту в базе данных.';

  @override
  String cdLoadFailed(String error) {
    return 'Не удалось загрузить карточку: $error';
  }

  @override
  String get cdPrev => 'Назад (←)';

  @override
  String get cdNext => 'Вперёд (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Карта не найдена';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return 'Ты заплатил $total$divisa за $qty $copias (по $unidad за штуку)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'копий',
      many: 'копий',
      few: 'копии',
      one: 'копия',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ У тебя $n копий в коллекции',
      many: '✓ У тебя $n копий в коллекции',
      few: '✓ У тебя $n копии в коллекции',
      one: '✓ У тебя $n копия в коллекции',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'У тебя нет этой карты (пока).';

  @override
  String cdNoPrice(String mercado) {
    return 'Нет цены этой карты на $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'ВЕРСИИ ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'нет цены по изданию на $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return 'цены $mercado ($moneda) · обычная / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'у тебя x$n';
  }

  @override
  String get smMythic => 'Мифическая редкая';

  @override
  String get smRare => 'Редкая';

  @override
  String get smUncommon => 'Необычная';

  @override
  String get smCommon => 'Обычная';

  @override
  String smLoadFailed(String error) {
    return 'Не удалось загрузить сет: $error';
  }

  @override
  String get smSearchInSet => 'Ищи в сете…';

  @override
  String get smRarityAll => 'Редкость: все';

  @override
  String get smPriceDown => 'Цена ↓';

  @override
  String get smPriceUp => 'Цена ↑';

  @override
  String get smNumber => 'Номер';

  @override
  String get smOnlyMine => 'Только мои';

  @override
  String smCardsCount(int n) {
    return '$n карт';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: нет цены по изданию';
  }

  @override
  String smListedValue(String mercado) {
    return 'заявленная стоимость ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'Ты заплатил $pagado · сегодня они стоят $hoy';
  }

  @override
  String get pnNoPnl =>
      'Без цены покупки нет P&L. Импортируй CSV со столбцом «Purchase price», и он появится здесь.';

  @override
  String pnOverAll(int n) {
    return 'по $n копиям из твоей коллекции';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'по $conprecio из $total копий (у остальных не записана цена покупки)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return 'У $n купленных копий нет сегодняшней цены в базе: не в счёт';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'ты также заплатил $importe $moneda, которые не конвертируются';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n копий без валюты в CSV: считаем их $moneda';
  }

  @override
  String get pcTitle => 'Динамика цены';

  @override
  String get pcNoHistory => 'У этой карты пока нет истории цены.';

  @override
  String pcTodayPrice(String precio) {
    return 'Сегодняшняя цена: $precio €. График появится, как только наберётся несколько дней.';
  }

  @override
  String get pcExplain =>
      'ManaForge каждый день записывает цену каждой карты, которую ты смотришь или имеешь. Чтобы начать с реальных последних месяцев Cardmarket, загрузи историю из Рынка.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дней',
      many: '$n дней',
      few: '$n дня',
      one: '$n день',
    );
    return 'мин $min € · макс $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'Из каких сетов?';

  @override
  String get spSearchHint => 'Поиск по названию или коду (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Только мои';

  @override
  String spClearN(int n) {
    return 'Убрать $n';
  }

  @override
  String get spNoneNamed =>
      'Нет сета с таким названием. Убери «Только мои», чтобы увидеть все.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n карт';
  }

  @override
  String get spNoFilter => 'Без фильтра по сету';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Взять $n сетов',
      many: 'Взять $n сетов',
      few: 'Взять $n сета',
      one: 'Взять $n сет',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'Ищу только карты из сета $set. Нажми, чтобы сменить или снять блокировку.';
  }

  @override
  String get slLockHint =>
      'Заблокируй сет, чтобы сканировать коробку/прекон: сканер будет искать только внутри него и точно определит издание.';

  @override
  String slSetIs(String set) {
    return 'Сет: $set';
  }

  @override
  String get slSetAll => 'Сет: все';

  @override
  String get slLockTitle => 'Заблокировать издание';

  @override
  String get slLockBody =>
      'Введи код сета (например, AER, MH3, LCI), чтобы сканировать целую коробку: будут искаться только карты из этого сета.';

  @override
  String get slSetCode => 'Код сета';

  @override
  String get slClearLock => 'Снять блокировку';

  @override
  String get stHintQuick =>
      'Поднеси карты: ясные записываются сюда сами (одинаковые копии суммируются ×N). Сомнительные помечаются на проверку. В конце подтверждаешь все.';

  @override
  String get stHintCareful =>
      'Поднеси карты: ясные записываются сами; сомнительные спрашивают, какая это. В конце подтверждаешь все.';

  @override
  String stAddN(int n) {
    return 'Добавить $n в коллекцию';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return 'Добавить $n в коллекцию и в $carpeta';
  }

  @override
  String get stOneLess => 'На одну меньше';

  @override
  String get stAnotherSame => 'Ещё такую же';

  @override
  String get stOnTable => 'на столе';

  @override
  String cdLastData(String fecha) {
    return ' (последние данные: $fecha)';
  }

  @override
  String get cdLegalities => 'Легальность';

  @override
  String get slLockButton => 'Заблокировать';

  @override
  String get wn031Headline =>
      'Álbum que habla claro, Forge más cómodo y todo más fluido';

  @override
  String get wn031Album =>
      'Álbum: si tu mercado (Card Kingdom, Mana Pool) no publica precio por edición, te lo dice claro en vez de enseñar un \$0.00 mudo.';

  @override
  String get wn031Forge =>
      'Forge: al terminar una forja puedes volver a la selección sin perder lo elegido, y el aviso de mazo borrado dura más y se puede cerrar.';

  @override
  String get wn031Home =>
      'Inicio: el valor total marca ~ cuando hay cartas sin precio, para no vender certeza donde hay estimación.';

  @override
  String get wn031Perf =>
      'Más fluido: álbum, importaciones y búsquedas responden mejor con colecciones grandes.';

  @override
  String get wn030Headline =>
      'Forge по сетам, цена покупки и оповещения о версии';

  @override
  String get wn030Forge =>
      'Forge: выбирай, из каких сетов берутся карты. А если включишь «включить карты, которых у меня нет», он соберёт колоду из всего выбранного набора и скажет, скольких не хватает и сколько они стоят.';

  @override
  String get wn030Pnl =>
      'Цена покупки и P&L: если в твоём CSV есть «Purchase price», Рынок покажет, сколько ты заплатил, сколько это стоит сегодня и разницу. Валюты не смешиваются.';

  @override
  String get wn030PhotoFolder =>
      'Сканирование по фото тоже даёт выбрать папку, как и сканер вживую.';

  @override
  String get wn030Album =>
      'Альбом: чего тебе не хватает в каждом сете и сколько это стоило бы.';

  @override
  String get wn030Background =>
      'Обои: поставь позади любое изображение с регулируемой вуалью и выбери цвет карточек и текста, чтобы поверх всё читалось.';

  @override
  String get wn030Window =>
      'Окно открывается там, где ты его оставил, и того размера, что оставил.';

  @override
  String get wn030Achievements =>
      'Достижения теперь называются не по правилу, а по моменту: «Плакали мои денежки», «Сто редких и ни одной играбельной».';

  @override
  String get wn030Update =>
      'Приложение сообщает о новой версии (само не обновляется) и проверяет отпечаток SHA-256 у скачиваемых баз.';

  @override
  String get wn030Shortcuts =>
      'Горячие клавиши: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, и Escape.';

  @override
  String get wn030Linux =>
      'В Linux установщик добавляет ManaForge в меню приложений вместе со значком.';

  @override
  String get wn030License =>
      'Лицензия PolyForm Noncommercial: делись и ковыряйся сколько хочешь, но продавать нельзя.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n карт',
      many: '$n карт',
      few: '$n карты',
      one: '$n карта',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n колод',
      many: '$n колод',
      few: '$n колоды',
      one: '$n колода',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n папок',
      many: '$n папок',
      few: '$n папки',
      one: '$n папка',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n достижений',
      many: '$n достижений',
      few: '$n достижения',
      one: '$n достижение',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'пустая копия';

  @override
  String get bkStoreCollection => 'твоя коллекция';

  @override
  String get bkStoreFolders => 'твои папки';

  @override
  String get bkStoreDecks => 'твои колоды';

  @override
  String get bkStoreAchievements => 'твои достижения';

  @override
  String get bkStoreWishlist => 'твой вишлист';

  @override
  String get bkStoreCertificates => 'твои сертификаты';

  @override
  String get bkStoreMarket => 'твой любимый рынок';

  @override
  String get bkStoreRecents => 'недавно просмотренные карты';

  @override
  String get bkStoreValueHistory => 'история стоимости';

  @override
  String get bkStorePriceHistory => 'история цен';

  @override
  String get bkKindAuto => 'автоматическая';

  @override
  String get bkKindPreRestore => 'перед восстановлением';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig => 'Этот файл слишком велик для копии ManaForge.';

  @override
  String get bkErrExpandTooBig =>
      'Эта копия слишком велика при распаковке: не похоже на настоящую копию ManaForge.';

  @override
  String get bkErrNotABackup => 'Этот файл — не резервная копия ManaForge.';

  @override
  String get bkErrNewerVersion =>
      'Эту копию сделала более новая версия ManaForge. Обнови приложение и попробуй снова.';

  @override
  String get bkErrIncomplete => 'Эта копия неполная: в ней нет твоих данных.';

  @override
  String bkErrDamaged(String almacen) {
    return 'Эта копия повреждена: $almacen не читается.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'Не удалось записать в папку данных, поэтому я ничего не тронул: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'Восстановление остановилось на полпути ($escritos из $total файлов). Прежней копии того, что было, у меня нет. Подробности: $error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return 'Восстановление остановилось на полпути ($escritos из $total файлов). Чтобы вернуться назад, восстанови $ruta. Подробности: $error';
  }

  @override
  String get siImportTooBig => 'Этот файл слишком велик для списка карт.';

  @override
  String get siInsecureDownload =>
      'Загрузка привела на небезопасный адрес и была отменена.';

  @override
  String get siRedirectNowhere =>
      'Загрузка перенаправляет в никуда и была отменена.';

  @override
  String get siTooManyRedirects =>
      'Загрузка слишком много раз перенаправляется и была отменена.';

  @override
  String get siDownloadTooBig =>
      'Загрузка намного больше, чем должна быть, и была отменена.';

  @override
  String get siBadHash =>
      'Скачанное не совпадает с отпечатком, опубликованным на GitHub. Ничего не установлено. Попробуй снова; если повторяется, дай знать.';

  @override
  String get siBackgroundNotImage =>
      'Выбери изображение (.jpg, .png или .webp) в качестве фона.';

  @override
  String get siBackgroundTooBig =>
      'Это изображение слишком большое, чтобы ставить его фоном.';

  @override
  String get siScanTooBig => 'Это фото слишком большое, чтобы его распознать.';

  @override
  String get bgImages => 'Изображения';

  @override
  String bgImageFailed(String error) {
    return 'Не удалось использовать это изображение: $error';
  }

  @override
  String get bgLowContrast =>
      'Мало отличий от карточки: текст сам подстроится, чтобы читался.';

  @override
  String get bgChipColor => 'Цвет вкладок';

  @override
  String get bgIconColor => 'Цвет значков';

  @override
  String get bgUseThis => 'Использовать этот';

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
      'GStreamer не установлен. Установи его командой:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'Камера $dispositivo не даёт изображения (gst-launch завершился с $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'Камера $dispositivo не дала ни одного кадра за 6 с.';
  }

  @override
  String get camNoCameras =>
      'Не нахожу ни одной камеры (/dev/video*). Она подключена? Проверь через `lsusb`, что система её видит.';

  @override
  String camNoneWorked(String detalle) {
    return 'Ни одна камера не дала изображения:\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Восстановить';

  @override
  String get fpUnselect => 'Снять отметку';

  @override
  String get stClear => 'Очистить';

  @override
  String get tlRemove => 'Убрать';

  @override
  String get tlUnrecognized => 'Не распознано';

  @override
  String get tlNothingAlike => 'ничего похожего в базе — переснять или убрать';

  @override
  String get tlTapToPick => 'нажми, чтобы выбрать вручную из похожих';

  @override
  String get tlReview => 'проверить';

  @override
  String get lsQuantity => 'Количество';

  @override
  String get scPhotos => 'Фото';

  @override
  String get ftWhichFolder => 'В какую папку их положить?';

  @override
  String get ftWhichFolderSub =>
      'В коллекцию они попадут в любом случае; папка — просто ярлык, чтобы потом их найти.';

  @override
  String get ftNone => 'Никакая';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n карт',
      many: '$n карт',
      few: '$n карты',
      one: '$n карта',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => 'Новая папка…';

  @override
  String get ftNewFolder => 'Новая папка';

  @override
  String get ftNewFolderHint => 'Магазинная коробка, На продажу…';

  @override
  String get sgTitle => 'Глаз сканера';

  @override
  String get sgWhy =>
      'Чтобы распознавать карты без интернета, мне нужна база визуальных отпечатков (~12 МБ): подпись арта каждой иллюстрации Magic. Скачивается один раз.';

  @override
  String get sgDownload => 'Скачать базу отпечатков';

  @override
  String get cmFullCard => 'Открыть полную карточку (цены и легальность)';

  @override
  String get cmSwipeHint =>
      'листай или используй ← →, чтобы перелистывать · нажми снаружи, чтобы закрыть';

  @override
  String get cmTapOutHint => 'нажми снаружи, чтобы закрыть';

  @override
  String get fcTitle => 'С какой карты ты начал?';

  @override
  String get fcRemove => 'Убрать';

  @override
  String get fcSearchHint => 'Искать в твоей коллекции';

  @override
  String get fcNoMatch => 'Не нахожу ни одной карты по этому.';

  @override
  String get acNoneWithFilters => 'Здесь ничего нет с этими фильтрами.';

  @override
  String get acAll => 'Все';

  @override
  String get tsTitle => 'Режим Тест — побей мету';

  @override
  String get tsIntro =>
      'Выбери, против какой колоды меты хочешь играть. ManaForge собирает колоды из ТВОИХ карт, прогоняет сотни партий против неё и оставляет ту, что побеждает чаще всего, — попутно подбирая замены карт по одной, чтобы её отточить.';

  @override
  String get tsLoadingMeta => 'Загружаю мету…';

  @override
  String get tsLocalPresets => 'Локальные пресеты (без связи)';

  @override
  String get tsNoDeckToFace =>
      'С нынешними картами не выходит ни одной полной колоды для боя. Добавь больше карт и попробуй снова.';

  @override
  String tsSimFailed(String error) {
    return 'Не удалось смоделировать: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota меты';
  }

  @override
  String get tsSimulating =>
      'Моделирую партии… (несколько секунд; всё на твоём компьютере)';

  @override
  String tsFindBest(String meta) {
    return 'Найти мою лучшую колоду против $meta';
  }

  @override
  String get tsHonesty =>
      'Честно: симуляция понимает цвета маны, мулиганы, уклонение (полёт, пробивной удар, смертельное касание…), мгновенный ремувал и контрзаклинания — но не полный текст каждой карты. Процент нужен, чтобы СРАВНИВАТЬ твои колоды между собой, а не как точный прогноз.';

  @override
  String tsChampion(String meta) {
    return 'Твой чемпион против $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'оценочный процент побед · $mazos колод проверено · $partidas партий на колоду';
  }

  @override
  String get tsNoDominant =>
      'Ни одна колода из твоей коллекции не доминирует в этом матчапе — вот та, что бьётся лучше всех. Смотри её слабые места в деталях.';

  @override
  String get tsSeeDeck => 'Показать всю колоду (и сохранить)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total достижений · $xp XP до уровня $nivel';
  }

  @override
  String get hsForgeDecks => 'Ковать колоды';

  @override
  String get hsTestYourself => '⚔ проверь себя';

  @override
  String get bgCustom => 'Свой';

  @override
  String get bgPickCustom => 'Выбрать свой цвет';

  @override
  String get bgCustomColor => 'Свой цвет';

  @override
  String get bgSampleTab => 'Красный';

  @override
  String get cfSortRecent => 'Недавно добавленные';

  @override
  String get cfSortAlpha => 'Название А-Я';

  @override
  String get cfSortCmc => 'Стоимость';

  @override
  String get cfSortQty => 'Количество';

  @override
  String get cfSortBy => 'Сортировать по';

  @override
  String get cfSort => 'Сортировка';

  @override
  String get cfClear => 'Сбросить';

  @override
  String get cfCost => 'Стоимость';

  @override
  String get cfCostAll => 'Стоимость: все';

  @override
  String cfCostN(String n) {
    return 'Стоимость $n';
  }

  @override
  String get cfType => 'Тип';

  @override
  String get cfTypeAll => 'Тип: все';

  @override
  String get cfTypeCreature => 'Существа';

  @override
  String get cfTypeInstant => 'Мгновенные заклинания';

  @override
  String get cfTypeSorcery => 'Волшебства';

  @override
  String get cfTypeArtifact => 'Артефакты';

  @override
  String get cfTypeEnchantment => 'Чары';

  @override
  String get cfTypeLand => 'Земли';

  @override
  String get cfPower => 'Сила';

  @override
  String get cfPowerAll => 'Сила: все';

  @override
  String cfPowerMin(int n) {
    return 'Сила ≥ $n';
  }

  @override
  String get cfToughness => 'Выносливость';

  @override
  String get cfToughnessAll => 'Выносливость: все';

  @override
  String cfToughnessMin(int n) {
    return 'Выносливость ≥ $n';
  }

  @override
  String get cfNoDate => 'без даты';

  @override
  String get cfToday => 'сегодня';

  @override
  String get cfYesterday => 'вчера';

  @override
  String cfDaysAgo(int n) {
    return '$n дней назад';
  }

  @override
  String get pcWeek => 'Неделя';

  @override
  String get pcMonth => 'Месяц';

  @override
  String get pcAll => 'Всё';

  @override
  String get vpTapCorrect => 'Нажми на верную карту';

  @override
  String get achCopias1 => 'Первая из многих';

  @override
  String get achCopias10 => 'Хотел купить всего одну';

  @override
  String get achCopias50 => 'В руку уже не помещаются';

  @override
  String get achCopias100 => 'Сотня и растёт';

  @override
  String get achCopias500 => 'Коробка уже маловата';

  @override
  String get achCopias1000 => 'Тысяча. И хочу все';

  @override
  String get achCopias5000 => 'Это уже склад';

  @override
  String get achCopias10000 => 'Десять тысяч, но я не завишу';

  @override
  String achCopiasDesc(String n) {
    return 'Собери $n карт в коллекции.';
  }

  @override
  String get achDistintas25 => 'Пошло разнообразие';

  @override
  String get achDistintas100 => 'Сто разных лиц';

  @override
  String get achDistintas500 => 'Полбиблиотеки';

  @override
  String get achDistintas1000 => 'Ходячая энциклопедия';

  @override
  String get achDistintas2500 => 'Уже не всех помню';

  @override
  String get achDistintas5000 => 'Архив';

  @override
  String achDistintasDesc(String n) {
    return 'Собери $n РАЗНЫХ карт (без учёта повторов).';
  }

  @override
  String get achPlaysets1 => 'Каре';

  @override
  String get achPlaysets20 => 'Двадцать плейсетов, ноль колод';

  @override
  String get achPlaysets1Desc => 'Собери 4 копии одной карты.';

  @override
  String get achPlaysets20Desc =>
      'Собери 20 разных плейсетов (по 4 копии каждого).';

  @override
  String get achComunes10 => 'Те, что никому не нужны';

  @override
  String get achComunes50 => 'Всё та же куча';

  @override
  String get achComunes200 => 'Король кучи';

  @override
  String get achComunes500 => 'Море обычных';

  @override
  String achComunesDesc(String n) {
    return 'Собери $n разных обычных карт.';
  }

  @override
  String get achInfrecuentes10 => 'На ступеньку выше обычных';

  @override
  String get achInfrecuentes50 => 'Чистое серебро';

  @override
  String get achInfrecuentes200 => 'Охотник за необычными';

  @override
  String get achInfrecuentes500 => 'Серебро вёдрами';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Собери $n разных необычных карт.';
  }

  @override
  String get achRaras5 => 'Приятный хруст бустера';

  @override
  String get achRaras25 => 'Сундук редких';

  @override
  String get achRaras100 => 'Сто редких и ни одной играбельной';

  @override
  String get achRaras300 => 'Бронехранилище';

  @override
  String achRarasDesc(String n) {
    return 'Собери $n разных редких карт.';
  }

  @override
  String get achMiticas1 => 'Моя первая мифическая';

  @override
  String get achMiticas10 => 'Десять мифических';

  @override
  String get achMiticas50 => 'Мифический коллекционер';

  @override
  String get achMiticas150 => 'Мифический пантеон';

  @override
  String achMiticasDesc(String n) {
    return 'Собери $n разных мифических карт.';
  }

  @override
  String get achBlancas25 => 'Закон и порядок';

  @override
  String get achBlancas100 => 'Серебряное войско';

  @override
  String achBlancasDesc(String n) {
    return 'Собери $n разных белых карт.';
  }

  @override
  String get achAzules25 => 'Вот этого я не позволю';

  @override
  String get achAzules100 => 'Башня из слоновой кости';

  @override
  String achAzulesDesc(String n) {
    return 'Собери $n разных синих карт.';
  }

  @override
  String get achNegras25 => 'Тёмный договор';

  @override
  String get achNegras100 => 'Владыка склепа';

  @override
  String achNegrasDesc(String n) {
    return 'Собери $n разных чёрных карт.';
  }

  @override
  String get achRojas25 => 'Сжечь всё дотла';

  @override
  String get achRojas100 => 'Всеобщий пожар';

  @override
  String achRojasDesc(String n) {
    return 'Собери $n разных красных карт.';
  }

  @override
  String get achVerdes25 => 'Росток';

  @override
  String get achVerdes100 => 'Целый лес';

  @override
  String achVerdesDesc(String n) {
    return 'Собери $n разных зелёных карт.';
  }

  @override
  String get achIncoloras25 => 'Холодный металл';

  @override
  String get achIncoloras100 => 'Вечная кузница';

  @override
  String achIncolorasDesc(String n) {
    return 'Собери $n разных бесцветных карт.';
  }

  @override
  String get achArcoiris => 'Все пять цветов';

  @override
  String get achArcoirisDesc =>
      'Имей хотя бы по одной карте каждого из 5 цветов.';

  @override
  String get achMulticolor10 => 'Смешиваю цвета';

  @override
  String get achMulticolor50 => 'Золотой союз';

  @override
  String achMulticolorDesc(String n) {
    return 'Собери $n разных многоцветных карт.';
  }

  @override
  String get achCincocolores => 'Все пять разом';

  @override
  String get achCincocoloresDesc => 'Имей одну карту со всеми пятью цветами.';

  @override
  String get achSets1 => 'Первый сет';

  @override
  String get achSets5 => 'Пять миров';

  @override
  String get achSets10 => 'Странник по мирам';

  @override
  String get achSets25 => 'Объездил весь свет';

  @override
  String get achSets50 => 'Полмультивселенной';

  @override
  String achSetsDesc(String n) {
    return 'Имей карты из $n разных сетов.';
  }

  @override
  String get achSetscompletos1 => 'Всё до единой';

  @override
  String get achSetscompletos3 => 'Три полных альбома';

  @override
  String get achSetscompletos10 => 'Мастер альбома';

  @override
  String get achSetscompletos1Desc => 'Собери один сет целиком в Альбоме.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Собери $n сетов целиком.';
  }

  @override
  String get achAnyos5 => 'Пять лет картона';

  @override
  String get achAnyos15 => 'Машина времени';

  @override
  String achAnyosDesc(String n) {
    return 'Имей карты из $n разных годов выпуска.';
  }

  @override
  String get achValor10 => 'Первые евро';

  @override
  String get achValor50 => 'Копилка';

  @override
  String get achValor250 => 'Прощай, карманные';

  @override
  String get achValor1000 => 'Плакали мои денежки';

  @override
  String get achValor5000 => 'Только никому не говори';

  @override
  String get achValor10000 => 'Дороже моей машины';

  @override
  String get achValor25000 => 'Музейная коллекция';

  @override
  String achValorDesc(String n) {
    return 'Доведи стоимость коллекции до $n € или больше.';
  }

  @override
  String get achJoya20 => 'Одна из хороших';

  @override
  String get achJoya100 => 'Жемчужина коллекции';

  @override
  String get achJoya500 => 'Эта из протектора не вылезает';

  @override
  String get achJoya1000 => 'Тысяча евро в одном протекторе';

  @override
  String get achJoya2500 => 'Святой Грааль';

  @override
  String achJoyaDesc(String n) {
    return 'Имей одну карту стоимостью $n € или больше.';
  }

  @override
  String get achFoils1 => 'Первый блеск';

  @override
  String get achFoils10 => 'Блёстки';

  @override
  String get achFoils50 => 'Коробка блестит';

  @override
  String get achFoils200 => 'Матовых тут не осталось';

  @override
  String get achFoils500 => 'Всё блестит';

  @override
  String get achFoils1000 => 'Фабрика блеска';

  @override
  String achFoilsDesc(String n) {
    return 'Собери $n карт foil.';
  }

  @override
  String get achFoiljoya10 => 'Хорошая foil';

  @override
  String get achFoiljoya50 => 'Дорогая foil';

  @override
  String get achFoiljoya200 => 'Музейная foil';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Имей foil стоимостью $n € или больше.';
  }

  @override
  String get achFoilvalor50 => 'Блестящая витрина';

  @override
  String get achFoilvalor250 => 'Дорогая витрина';

  @override
  String get achFoilvalor1000 => 'Тысяча евро блеска';

  @override
  String get achFoilvalor5000 => 'Музейная витрина';

  @override
  String achFoilvalorDesc(String n) {
    return 'Доведи суммарную стоимость всех твоих foil до $n € или больше.';
  }

  @override
  String get achMazos1 => 'Первая колода';

  @override
  String get achMazos5 => 'Пять колод сохранено';

  @override
  String get achMazos25 => 'Мастерская не спит';

  @override
  String achMazosDesc(String n) {
    return 'Сохрани $n колод, собранных в Forge.';
  }

  @override
  String get achMazoscore => 'Колода что надо';

  @override
  String get achMazoscoreDesc => 'Сгенерируй колоду с оценкой 90 или выше.';

  @override
  String get achMazocolores3 => 'Трёхцветка';

  @override
  String get achMazocolores5 => 'Играбельная радуга';

  @override
  String achMazocoloresDesc(String n) {
    return 'Сохрани колоду из $n цветов.';
  }

  @override
  String get achMazomono => 'Без примесей';

  @override
  String get achMazomonoDesc => 'Сохрани одноцветную колоду.';

  @override
  String get achMazocommander => 'У руля';

  @override
  String get achMazocommanderDesc => 'Сохрани колоду Commander.';

  @override
  String get achEscaneadas1 => 'Первый скан';

  @override
  String get achEscaneadas50 => 'Быстрые руки';

  @override
  String get achEscaneadas500 => 'Сканирую пачками';

  @override
  String get achEscaneadas2000 => 'Сканирую во сне';

  @override
  String achEscaneadasDesc(String n) {
    return 'Отсканируй $n карт камерой или по фото.';
  }

  @override
  String get achFoto9 => 'Целая страница с одного фото';

  @override
  String get achFoto20 => 'Двадцать за один раз';

  @override
  String achFotoDesc(String n) {
    return 'Распознай $n карт на одном фото.';
  }

  @override
  String get achEscaneoperfecto => 'Ни одной на проверку';

  @override
  String get achEscaneoperfectoDesc =>
      'Отсканируй целую страницу так, чтобы ни одна карта не осталась на проверку.';

  @override
  String get achDias2 => 'Ты вернулся';

  @override
  String get achDias7 => 'Неделю здесь';

  @override
  String get achDias30 => 'Месяц здесь';

  @override
  String get achDias100 => 'Сто дней здесь';

  @override
  String achDiasDesc(String n) {
    return 'Пользуйся ManaForge $n разных дней.';
  }

  @override
  String get achRacha3 => 'Три подряд';

  @override
  String get achRacha7 => 'Идеальная неделя';

  @override
  String get achRacha30 => 'Месяц без пропусков';

  @override
  String achRachaDesc(String n) {
    return 'Заходи $n дней подряд.';
  }

  @override
  String get achSemanas => 'Четыре недели без пропусков';

  @override
  String get achSemanasDesc => 'Пользуйся ManaForge 4 недели подряд.';

  @override
  String get achCarpetas1 => 'Начало порядка';

  @override
  String get achCarpetas5 => 'Всё разложено по полочкам';

  @override
  String achCarpetasDesc(String n) {
    return 'Создай $n папок.';
  }

  @override
  String get achCarpetagrande => 'Папища';

  @override
  String get achCarpetagrandeDesc => 'Имей папку со 100 картами или больше.';

  @override
  String get achCarpetavalor => 'Эту папку не дам';

  @override
  String get achCarpetavalorDesc => 'Имей папку стоимостью 100 € или больше.';

  @override
  String get achTierrasbasicas => 'Пять базовых';

  @override
  String get achTierrasbasicasDesc =>
      'Имей все пять типов базовых земель (Равнина, Остров, Болото, Гора и Лес).';

  @override
  String get achFuerza => 'Ну и зверюга';

  @override
  String get achFuerzaDesc => 'Имей существо с силой 10 или больше.';

  @override
  String get achCoste => 'Это я в жизни не разыграю';

  @override
  String get achCosteDesc =>
      'Имей карту с конвертированной мана-стоимостью 10 или больше.';

  @override
  String get achCostecero => 'Бесплатно';

  @override
  String get achCosteceroDesc => 'Имей карту со стоимостью 0.';

  @override
  String get achTipos => 'Всего понемногу';

  @override
  String get achTiposDesc =>
      'Имей хотя бы одно существо, одно мгновенное заклинание, одно волшебство, один артефакт, одни чары, одну землю и одного планесвокера.';

  @override
  String get achPlaneswalkers => 'Компания планесвокеров';

  @override
  String get achPlaneswalkersDesc => 'Имей 5 разных планесвокеров.';

  @override
  String get achNoventas => 'Реликвия 90-х';

  @override
  String get achNoventasDesc => 'Имей карту из 90-х годов.';

  @override
  String get achIdiomas1 => 'Эту я не прочту';

  @override
  String get achIdiomas25 => 'Полиглот-коллекция';

  @override
  String get achIdiomas1Desc => 'Имей карту на языке, отличном от английского.';

  @override
  String get achIdiomas25Desc => 'Имей 25 карт на других языках.';

  @override
  String get achWishlist => 'Список хотелок';

  @override
  String get achWishlistDesc => 'Добавь 20 карт в вишлист.';

  @override
  String get achTierBronze => 'Бронза';

  @override
  String get achTierSilver => 'Серебро';

  @override
  String get achTierGold => 'Золото';

  @override
  String get achTierMythic => 'Мифический';

  @override
  String get achCatCollection => 'Коллекция';

  @override
  String get achCatRarity => 'Редкости';

  @override
  String get achCatColor => 'Цвета';

  @override
  String get achCatSets => 'Сеты';

  @override
  String get achCatValue => 'Стоимость';

  @override
  String get achCatFoils => 'Foils';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Сканер';

  @override
  String get achCatDedication => 'Преданность';

  @override
  String get achCatFolders => 'Папки';

  @override
  String get achCatCuriosities => 'Диковинки';

  @override
  String get achRankApprentice => 'Ученик';

  @override
  String get achRankSummoner => 'Призыватель';

  @override
  String get achRankMage => 'Маг';

  @override
  String get achRankArchmage => 'Архимаг';

  @override
  String get achRankMaster => 'Мастер';

  @override
  String get achRankPlaneswalker => 'Планесвокер';

  @override
  String get bkConfirmWord => 'ПОДТВЕРДИТЬ';

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
    return 'Не удалось скачать базу карт (HTTP $codigo). Попробуй ещё раз чуть позже.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'Не удалось скачать базу отпечатков (HTTP $codigo). Попробуй ещё раз чуть позже.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'Не удалось скачать историю цен (HTTP $codigo). Попробуй ещё раз чуть позже.';
  }

  @override
  String ddCardCount(int n) {
    return '$n карт';
  }

  @override
  String get ddForgedWith => 'Выковано в ManaForge';

  @override
  String get fxThemeLifegain => 'набор жизней';

  @override
  String get fxThemeSacrifice => 'жертвы';

  @override
  String get fxThemeSpells => 'заклинания';

  @override
  String get fxThemeArtifacts => 'артефакты';

  @override
  String get fxThemeCounters => 'счётчики +1/+1';

  @override
  String get fxThemeTokens => 'рой';

  @override
  String get fxThemeGraveyard => 'кладбище';

  @override
  String get fxThemeReanimator => 'оживление';

  @override
  String fxThemeTribal(String tribe) {
    return 'трайбл $tribe';
  }

  @override
  String get fxThemeGoodstuff => 'лучшее из твоих карт';

  @override
  String get fxTagLifegain =>
      'Каждая набранная жизнь — урон для них: дренируй и держись.';

  @override
  String get fxTagSacrifice =>
      'Твои существа ценнее мёртвыми: жертвуй ими и собирай дань.';

  @override
  String get fxTagSpells =>
      'Каждое мгновенное заклинание в счёт: играй в ход соперника и наказывай.';

  @override
  String get fxTagArtifacts =>
      'Собери свою мастерскую: каждый артефакт усиливает остальные.';

  @override
  String get fxTagCounters =>
      'Счётчики +1/+1: твои существа растут, пока их не достанешь.';

  @override
  String get fxTagTokens => 'Затопи стол фишками: где у них одна, у тебя пять.';

  @override
  String get fxTagGraveyard =>
      'Твоё кладбище — вторая рука: наполняй его и переиспользуй лучшее.';

  @override
  String get fxTagAggro =>
      'Выходи быстро и бей по лицу: партия должна закончиться рано.';

  @override
  String get fxTagTempo =>
      'Дави рано и защищай преимущество своими заклинаниями.';

  @override
  String fxTagMidrange(String tema) {
    return 'Разменивай карты с выгодой и выигрывай середину игры за счёт $tema.';
  }

  @override
  String get fxTagControl =>
      'Держись, отвечай на всё и добивай, когда стол станет твоим.';

  @override
  String get fxMidLifegain =>
      'Свяжи свои источники жизни с теми, кто наказывает соперника за это.';

  @override
  String get fxMidSacrifice =>
      'Жертвуй дешёвым, чтобы брать карты, дренировать или растить остальных.';

  @override
  String get fxMidSpells =>
      'Держи ману открытой: твои существа растут с каждым заклинанием.';

  @override
  String get fxMidArtifacts =>
      'Выкладывай дешёвые артефакты и включай тех, кто их считает.';

  @override
  String get fxMidCounters =>
      'Накапливай счётчики на одном-двух существах и защищай их.';

  @override
  String get fxMidTokens =>
      'Создавай фишки каждый ход и ищи эффекты, которые их усиливают.';

  @override
  String get fxMidGraveyard =>
      'Мели и сбрасывай с умыслом: то, что попало на кладбище, вернётся.';

  @override
  String get fxEndLifegain =>
      'С высоким запасом жизней переходи в агрессию: им уже не догнать.';

  @override
  String get fxEndSacrifice =>
      'Накопленное преимущество приносит партию: каждый размен тебе бесплатен.';

  @override
  String get fxEndSpells =>
      'Пара заклинаний в один ход — и твои существа закрывают игру.';

  @override
  String get fxEndArtifacts =>
      'Твой стол вдвое ценнее ихнего: добивай своими наградными картами.';

  @override
  String get fxEndCounters =>
      'Одна огромная защищённая угроза завершает партию в два удара.';

  @override
  String get fxEndTokens =>
      'Атакуй всей толпой: никакой блок не сдержит всю твою армию.';

  @override
  String get fxEndGraveyard =>
      'Переиспользуй лучшие карты: играешь двумя руками против одной.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => 'Играй по существу каждый ход, без исключений.';

  @override
  String get fxAggroMid =>
      'Продолжай атаковать; береги прямой урон, чтобы убирать блокеров.';

  @override
  String get fxAggroLate =>
      'Добивай всем, чем есть: здесь пора закрывать партию.';

  @override
  String get fxTempoEarly => 'Дешёвая угроза и открытая мана, когда можешь.';

  @override
  String get fxTempoMid => 'Атакуй и используй заклинания в ход соперника.';

  @override
  String get fxTempoLate =>
      'Защищай существ и закрывай по воздуху или прямым уроном.';

  @override
  String get fxMidrangeEarly =>
      'Развивайся и не раздавай карты даром: выгодные размены один в один.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Разверни свои движки $tema и стабилизируй стол.';
  }

  @override
  String get fxMidrangeLate => 'Твои карты ценнее их: обрати это в победу.';

  @override
  String get fxControlEarly => 'Земля в ход и отвечай только на важное.';

  @override
  String get fxControlMid => 'Чисти стол и бери карты: время играет на тебя.';

  @override
  String get fxControlLate => 'Выложи одну угрозу и защищай её до конца.';

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
    return 'Средняя стоимость $coste: по правилу Карстена (24 земли при стоимости 3.0, ±1 на каждые ±0.5) в этой колоде $tierras земель — в пределах диапазона для колоды $arquetipo. Есть $criaturas существ, чтобы держать стол, и $interaccion карт взаимодействия на всё, что принесёт соперник. Тема ($tema) фокусирует твои синергии: чем больше частей темы ты видишь, тем сильнее каждая.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'С такой кривой выходит $tierras земель: вне здорового диапазона ($min-$max). Подкрути общее число заклинаний.';
  }

  @override
  String get fxNoCards =>
      'В твоей коллекции не хватает карт этих цветов, чтобы заполнить такую кривую. Попробуй меньше заклинаний или другие стоимости.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'Такая кривая (средняя стоимость $coste при $tierras землях) не подходит ни под один здоровый профиль: дешёвой колоде нужно меньше земель, дорогой — больше. Сблизь их.';
  }

  @override
  String get fxNoBasics =>
      'В коллекции не хватает базовых земель для такой кривой.';

  @override
  String fxHardRule(String detalle) {
    return 'Запрошенная кривая нарушает жёсткое правило: $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Дешёвые существа и урон по лицу: убьёт за 4-5 ходов, если не выдержишь темп.';

  @override
  String get tsPresetAzorius =>
      'Контрзаклинания, зачистки стола и добор: затягивает партию и выигрывает парой финишеров.';

  @override
  String get tsPresetGolgari =>
      'Размены один в один, эффективные существа и чёрный ремувал: выигрывает долгую игру за счёт качества карт.';
}
