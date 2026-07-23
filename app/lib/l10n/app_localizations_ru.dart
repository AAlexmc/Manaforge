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
