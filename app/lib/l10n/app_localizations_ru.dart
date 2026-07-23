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
  String get languagePartial =>
      'Приложение переводится постепенно: основа уже на вашем языке, остальные экраны пока на испанском.';

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
  String get welcomeImport => 'Импорт CSV (ManaBox)';

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
}
