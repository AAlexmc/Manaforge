// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabHome => '首页';

  @override
  String get tabCollection => '收藏';

  @override
  String get tabAlbum => '图鉴';

  @override
  String get tabDecks => '套牌';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => '市场';

  @override
  String get tabSettings => '设置';

  @override
  String get tabScan => '扫描';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsIntro =>
      'ManaForge 免费且代码公开（PolyForm Noncommercial 许可：随意分享和修改，但不可出售）。没有广告、没有会员、无需账号。你的卡就是你的。';

  @override
  String get howItWorks => '怎么用';

  @override
  String get howScan => '把卡放到摄像头前，或拖入一张照片：它们会带着准确的版本进入你的收藏。';

  @override
  String get howCollection => '你拥有的一切，带搜索、筛选和文件夹（文件夹是标签：一张卡可以同时在多个里）。';

  @override
  String get howAlbum => '每个系列一页，像贴纸册：有的显示彩色，缺的显示灰色，并算出补齐要花多少钱。';

  @override
  String get howForge => '用你的卡组出完整且合规的套牌。也可以用你还没有的系列，并告诉你要买什么、要花多少。';

  @override
  String get howDecks => '你保存的套牌。如果卖掉了某张卡，套牌会照实说，而不是假装你还有。';

  @override
  String get howMarket => '你的收藏值多少、走势图、带价格提醒的心愿单；如果 CSV 里有买入价，还会显示盈亏。';

  @override
  String get howPrivacy => '一切都在你的设备上计算。会联网的只有数据库下载，以及（如果你开着）检查是否有新版本。';

  @override
  String get shortcuts => '键盘快捷键';

  @override
  String get shortcutTabs => '切换标签页';

  @override
  String get shortcutScan => '打开扫描器';

  @override
  String get shortcutSearch => '在当前标签页搜索';

  @override
  String get shortcutSettings => '设置';

  @override
  String get shortcutClose => '关闭上层打开的内容';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languagePartial => '应用正在分阶段翻译：主体框架已是你的语言，其余界面暂时仍是西班牙语。';

  @override
  String get versionTitle => 'ManaForge 版本';

  @override
  String versionYouHave(String version) {
    return '你使用的是 $version。';
  }

  @override
  String get versionSeeWhatsNew => '看看更新了什么';

  @override
  String get versionNotifyMe => '有新版本时提醒我';

  @override
  String get versionNotifyMeWhy => '每天向 GitHub 查询一次最新版本。不会下载也不会安装任何东西。';

  @override
  String get versionCheckNow => '立即检查';

  @override
  String get versionUpToDate => '已是最新版本（或 GitHub 暂时没有响应）。';

  @override
  String versionThereIs(String version) {
    return 'ManaForge $version 已发布。';
  }

  @override
  String get versionGoDownload => '前往下载';

  @override
  String versionNotAuto(String version) {
    return '你使用的是 $version。应用不会自动更新：它会带你去下载页。';
  }

  @override
  String get versionNotNow => '以后再说';

  @override
  String get versionSee => '查看';

  @override
  String whatsNewTitle(String version) {
    return '$version 的新内容';
  }

  @override
  String get whatsNewClose => '开始玩';

  @override
  String get downloadCopyLink => '复制链接';

  @override
  String get downloadClose => '关闭';

  @override
  String get downloadTitle => '下载 ManaForge';

  @override
  String get backgroundTitle => '背景图';

  @override
  String get backgroundWhat =>
      '把你喜欢的图片放到应用背后。Wizards 会为每个系列发布官方壁纸：下载你喜欢的，然后在这里选择。应用不会替你下载——那些画作有版权方，分发不是它该做的事。';

  @override
  String get backgroundPick => '选择图片…';

  @override
  String get backgroundChange => '更换图片…';

  @override
  String get backgroundOfficial => 'Magic 官方壁纸';

  @override
  String get backgroundRemove => '移除背景';

  @override
  String get backgroundDim => '变暗程度（保证文字可读）';

  @override
  String get backgroundCardColor => '卡片颜色';

  @override
  String get backgroundTextColor => '文字颜色';

  @override
  String get backgroundCardOpacity => '卡片遮挡背景的程度';

  @override
  String get backgroundColorDefault => '默认颜色';

  @override
  String get backgroundPreview => '预览效果';

  @override
  String get backgroundNotAnImage => '请选择图片（.jpg、.png 或 .webp）作为背景。';

  @override
  String get backgroundTooBig => '这张图片太大，不能用作背景。';

  @override
  String get welcomeTitle => '欢迎来到熔炉。用你喜欢的方式导入卡片——或者一张都不加，先试试 Forge。';

  @override
  String get welcomeScan => '扫描我的卡';

  @override
  String get welcomeImport => '导入 CSV（ManaBox）';

  @override
  String get welcomeTryForge => '没有收藏也试试 Forge';

  @override
  String get decksEmptyGoForge => '去 Forge';

  @override
  String get yourCollection => '你的收藏';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies 张 · $distinct 种';
  }

  @override
  String get marketArrow => '市场 ›';

  @override
  String get certHeadingSetComplete => '完整收藏证书';

  @override
  String get certSubtitleSetComplete => '系列已集齐';

  @override
  String get certHeadingWelcome => '欢迎证书';

  @override
  String get certWelcomeTitle => '欢迎来到万智牌的世界';

  @override
  String get certSubtitleWelcome => '你的第一张牌';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 张',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return '我从 $name 开始';
  }

  @override
  String get certCollectorAnon => 'ManaForge 收藏家';

  @override
  String certAwardedTo(String name) {
    return '授予 $name';
  }

  @override
  String certOnDate(String date) {
    return '$date';
  }

  @override
  String get certDataBy => '数据来自 Scryfall';

  @override
  String get onbCollectionTitle => '你的收藏';

  @override
  String get onbCollectionBody => '所有卡牌都在这里，按文件夹和系列整理。';

  @override
  String get onbScanTitle => '扫描卡牌';

  @override
  String get onbScanBody => '用相机或照片添加新卡牌。';

  @override
  String get onbForgeTitle => '构筑套牌';

  @override
  String get onbForgeBody => '用你已有的卡牌生成完整套牌。';

  @override
  String get onbDecksTitle => '你的套牌';

  @override
  String get onbDecksBody => '在 Forge 保存的套牌会显示在这里。';

  @override
  String get onbSkip => '跳过';

  @override
  String get onbNext => '下一步';

  @override
  String get onbGotIt => '知道了';

  @override
  String get onbBack => '上一步';

  @override
  String get tourMenuTitle => '指南';

  @override
  String get tourWelcomeName => '快速导览';

  @override
  String get tourHomeName => '主屏幕';

  @override
  String get onbEditHomeTitle => '自定义主页';

  @override
  String get onbEditHomeBody => '用这个按钮选择主页显示哪些板块以及顺序。';

  @override
  String get onbLangTitle => '语言';

  @override
  String get onbLangBody => '在这里更改整个应用的语言。';

  @override
  String get onbLookTitle => '外观';

  @override
  String get onbLookBody => '设置壁纸并选择卡片、文字、标签和图标的颜色。';

  @override
  String get tourSettingsName => '自定义应用';

  @override
  String get tourFullName => '完整应用导览';

  @override
  String get tourCollectionName => '你的收藏与文件夹';

  @override
  String get tourForgeName => '打造一副套牌';

  @override
  String get tourMarketName => '市场、心愿单与提醒';

  @override
  String get onbAllCardsTitle => '全部卡牌';

  @override
  String get onbAllCardsBody => '你的整个收藏：搜索、筛选和排序。';

  @override
  String get onbFoldersTitle => '文件夹';

  @override
  String get onbFoldersBody => '文件夹就是标签：想怎么分组都行，一张牌可以同时在多个文件夹里。点“新建”创建第一个。';

  @override
  String get onbAlbumMineTitle => '按系列查看的卡册';

  @override
  String get onbAlbumMineBody => '每个系列都有自己的格子。这个筛选只显示你已有卡牌的系列。';

  @override
  String get onbForgeBasicsTitle => '基本地';

  @override
  String get onbForgeBasicsBody => '如果家里有零散的基本地，保持开启，Forge 会算上它们。关掉则只用收藏里的。';

  @override
  String get onbForgeSetsTitle => '系列';

  @override
  String get onbForgeSetsBody => '限定卡牌的来源。不选任何系列时，Forge 会用你的全部收藏。';

  @override
  String get onbForgeMissingTitle => '我没有的卡';

  @override
  String get onbForgeMissingBody => '开启后 Forge 也会推荐你缺的卡，并告诉你缺几张、要花多少钱。';

  @override
  String get onbForgeGoTitle => '开始打造';

  @override
  String get onbForgeGoBody => '这个按钮生成套牌。系列很多时需要几秒钟。';

  @override
  String get onbForgeTestTitle => '测试模式';

  @override
  String get onbForgeTestBody => '让你的套牌对上环境套牌，看看还差什么才能赢。';

  @override
  String get onbMarketPickTitle => '选择市场';

  @override
  String get onbMarketPickBody => 'Cardmarket 或 TCGplayer：会改变每张牌的价格和走势图。';

  @override
  String get onbWishlistTitle => '心愿单';

  @override
  String get onbWishlistBody => '你想要的牌。有牌降到你的目标价时，计数会变绿。';

  @override
  String get onbPriceAlertTitle => '价格提醒';

  @override
  String get onbPriceAlertBody => '搜索一张牌，点书签图标加入心愿单并设定目标价：降价时应用会通知你。';

  @override
  String get tourProgressName => '成就与证书';

  @override
  String get onbAchievementsTitle => '成就与等级';

  @override
  String get onbAchievementsBody => '你的等级和已经拿到的一切。扫描、整理和打造套牌都会让它上升。';

  @override
  String get onbCertificatesTitle => '证书';

  @override
  String get onbCertificatesBody => '重要里程碑会生成一张证书，可以存成 PDF 或拿去炫耀。它们在成就里面。';

  @override
  String get onbBackupTitle => '备份';

  @override
  String get onbBackupBody => '把收藏、套牌和文件夹保存成文件，换电脑时可以恢复。另外每周还会自动备份一次。';

  @override
  String onbTapHere(String pantalla) {
    return '点这里打开$pantalla。';
  }

  @override
  String get onbAchievementsName => '成就';

  @override
  String get onbDataSectionTitle => '数据';

  @override
  String get onbDataSectionBody => '应用保存的东西都在这里：卡牌数据库和你的备份。';

  @override
  String get onbCardDbTitle => '卡牌数据库';

  @override
  String get onbCardDbBody => '重新下载可以获得新卡、最新价格，以及需要新数据的功能，比如 Forge 的年份筛选。';

  @override
  String get onbAboutTitle => '关于应用';

  @override
  String get onbAboutBody => '每个标签页的作用、键盘快捷键、版本和许可证。';

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
