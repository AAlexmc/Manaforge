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
  String get onbForgeDeepTitle => '深度锻造';

  @override
  String get onbForgeDeepBody =>
      '在给你看提案之前，它会让它们真正互相对战：最终排序看的是实际表现，不只是静态分数。想要更快的结果可以关掉它。';

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
  String get colStartHere => '你的收藏从这里开始';

  @override
  String get colNeedDb => '我先得有包含所有 Magic 卡牌的数据库（只需下载一次，之后全程离线也能用）。';

  @override
  String colDownloading(String pct) {
    return '下载中… $pct %';
  }

  @override
  String get colDownloadDb => '下载卡牌数据库';

  @override
  String get colScryfall => '数据和图片来自 Scryfall · 无需账号，无需付费：一切都留在你的设备上。';

  @override
  String get colAlbumTooltip => '按系列查看的卡册';

  @override
  String get colImportTooltip => '导入 ManaBox 的 CSV';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies 张卡 · $distinct 张不同$valor';
  }

  @override
  String get colAllCards => '全部卡牌';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct 张不同 · 搜索、筛选和排序';
  }

  @override
  String get colFolders => '文件夹';

  @override
  String get colNewFolder => '新建';

  @override
  String get colNoFolders =>
      '你还没有文件夹。它们能把任何你想归类的东西分组：“Aetherdrift 的稀有卡”、“待出售”、“最上面那盒”…… 同一张卡可以同时放进好几个文件夹。';

  @override
  String get colCreateFirstFolder => '创建第一个文件夹';

  @override
  String get colEmptyTitle => '你的收藏就从这里起步';

  @override
  String get colEmptyBody => '用摄像头扫描你的卡牌，或导入 ManaBox 的 CSV。它们会出现在这里和卡册里。';

  @override
  String get colImportShort => '导入 CSV';

  @override
  String acForgetTitle(String carta) {
    return '不再拥有 $carta 了？';
  }

  @override
  String get acForgetBody => '它会从你的收藏中移除，卡册里对应的位置也会重新空出来。';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '它也会从所在的 $n 个文件夹中移除。',
      one: '它也会从所在的那个文件夹中移除。',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks => '牌组不会丢掉它：它仍留在清单里，牌组会提醒你缺这张。';

  @override
  String get acCancel => '取消';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => '我不再有它了';

  @override
  String acAddedOn(String cuando) {
    return '$cuando 添加';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '在 $n 个文件夹里',
      one: '在 1 个文件夹里',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => '搜索卡牌（西班牙语或英语）…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$total 张卡中的 $visibles 张';
  }

  @override
  String get acMissingFilterData => ' · 部分旧卡没有筛选数据：重新导入你的 CSV，并勾选“替换”。';

  @override
  String get acNoneMatch => '没有卡牌符合这些筛选条件。';

  @override
  String get acEmptyHint => '在上方搜索你的第一张卡，或返回导入 ManaBox 的 CSV。';

  @override
  String get onbHowItWorksBody => '各个标签页的功能一览，以及键盘快捷键。要是迷路了，就从这里开始。';

  @override
  String get onbVersionBody =>
      '你用的是哪个版本、带来了什么，以及要不要让 App 每天检查一次有没有新版本。它不会自己更新。';

  @override
  String get onbSuggestionsTitle => '意见箱';

  @override
  String get onbSuggestionsBody => '有想法，或者发现了问题？去 GitHub 告诉我们，有模板，一分钟就填好。';

  @override
  String get onbSupportTitle => '支持这个项目';

  @override
  String get onbSupportBody => '这款应用免费且没有广告。如果对你有帮助，这里是请我们喝杯咖啡的方法。';

  @override
  String get onbScanSetTitle => '系列：全部';

  @override
  String get onbScanSetBody =>
      '如果你正在拆某一个系列的补充包，就在这里锁定它：扫描器就不会在同一张卡的十个重印版本之间来回犹豫了。';

  @override
  String get onbScanModeTitle => '快速还是仔细';

  @override
  String get onbScanModeBody =>
      '在“快速”模式下，清晰的卡自动入库，拿不准的会被标记出来待复核。在“仔细”模式下，遇到拿不准的会停下来问你是哪张。';

  @override
  String get onbScanPhotoTitle => '扫描一张照片';

  @override
  String get onbScanPhotoBody =>
      '没有摄像头，或者卡牌已经拍好了？在这里丢进一张照片——里面有好几张卡也行——照样能认出来。';

  @override
  String get tourScanName => '扫描器';

  @override
  String get albNeedDb => '卡册需要卡牌数据库（去“收藏”里下载）。';

  @override
  String get albRetry => '重试';

  @override
  String get albApproxMode =>
      '卡册处于近似模式：我还不知道你每张卡具体是哪个版本。重新导入你的 CSV 并勾选“替换我当前的收藏”，卡册就会按插画精确显示。';

  @override
  String get albSearchSet => '搜索一个系列…';

  @override
  String get albOnlyMine => '含我的卡';

  @override
  String get albSortProgress => '完成度最高';

  @override
  String get albSortNewest => '最新';

  @override
  String get albSortOldest => '最旧';

  @override
  String get albSortName => '按名称';

  @override
  String get albYearAll => '年份：全部';

  @override
  String get albLetterAll => '全部';

  @override
  String get albNoSets => '没有系列符合筛选条件。';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total 张卡';
  }

  @override
  String get albComplete => ' · ✓ 已集齐！';

  @override
  String albLoadError(String error) {
    return '无法加载该系列：$error';
  }

  @override
  String albSearchIn(String set) {
    return '在 $set 中搜索…';
  }

  @override
  String get albOnlyMissing => '只看缺的';

  @override
  String get albWithVariants => '含变体';

  @override
  String get albYouHaveItAll => '✓ 你已集齐';

  @override
  String albMissingCount(int n) {
    return '还差 $n 张 · ';
  }

  @override
  String albWithoutPrice(int n) {
    return '（$n 张无价格）';
  }

  @override
  String albMarketNoToday(String market) {
    return '$market no publica precios por edición — cambia de mercado para verlos';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$total 张中的 $visibles 张';
  }

  @override
  String get albNoCardsNamed => '这里没有叫这个名字的卡。';

  @override
  String get fdNewFolder => '新建文件夹';

  @override
  String get fdEditFolder => '编辑文件夹';

  @override
  String get fdName => '名称';

  @override
  String get fdNameHint => 'Aetherdrift 的稀有卡、待出售…';

  @override
  String get fdColor => '颜色';

  @override
  String get fdIcon => '图标';

  @override
  String get fdCreate => '创建';

  @override
  String get fdSave => '保存';

  @override
  String get fdDefaultName => '文件夹';

  @override
  String fdDeleteTitle(String nombre) {
    return '删除“$nombre”？';
  }

  @override
  String get fdDeleteBody => '只删除文件夹本身：卡牌仍留在你的收藏里。';

  @override
  String get fdDelete => '删除';

  @override
  String get fdGone => '这个文件夹已经不存在了。';

  @override
  String get fdEditTooltip => '编辑名称、颜色和图标';

  @override
  String get fdDeleteTooltip => '删除文件夹';

  @override
  String get fdAddRemove => '添加或移除';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas 张不同的卡 · $copias 张';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n 张通过筛选';
  }

  @override
  String get fdRoughValue => ' · 参考价值';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '有 $n 张卡已不在你的收藏里（仍记着，以防它们回来）。',
      one: '有 1 张卡已不在你的收藏里（仍记着，以防它回来）。',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => '移除它们';

  @override
  String get fdNoneMatch => '文件夹里没有卡牌符合这些筛选条件。';

  @override
  String get fdEmpty => '空文件夹。点“添加或移除”，勾选你想放进来的卡。';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 张',
      one: '1 张',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => '从文件夹移除';

  @override
  String get fpPickCards => '选择卡牌';

  @override
  String fpSaveCount(int n) {
    return '保存（$n）';
  }

  @override
  String get fpFilterByName => '按名称筛选…';

  @override
  String fpVisibleCards(int n) {
    return '显示 $n 张卡';
  }

  @override
  String get fpSelectAll => '全选';

  @override
  String get fpNoneMatch => '没有卡牌符合这些筛选条件。';

  @override
  String get fgMsgReading => '正在读取你的收藏…';

  @override
  String get fgMsgCurve => '正在计算法术力曲线…';

  @override
  String get fgMsgLands => '正在分配地…';

  @override
  String get fgMsgSynergy => '正在寻找协同…';

  @override
  String get fgMsgPlan => '正在写你的战术方案…';

  @override
  String get fgNeedDbForSets => '我需要卡牌数据库才能列出各系列：设置 → 下载数据库。';

  @override
  String fgDbError(String error) {
    return '无法读取卡牌数据库：$error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' 在那 $n 个系列里',
      one: ' 在那个系列里',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return '我没法凑出一副合法的 Commander$donde：需要一位传奇指挥官，加上其颜色标识内约 62 张不同的卡（单张制），外加足够的基本地。换个赛制、换些系列，或者扩充收藏试试。';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return '用这个卡池里的卡，我凑不出任何一副符合我规则（地够、曲线健康）的完整 $formato 牌组$donde。$consejo 与其给你一副有缺陷的牌组，我宁愿先告诉你。';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return '用这个风格（$estilo）做不出牌组。试试“风格：自动”或另一个族群。';
  }

  @override
  String get fgOf60 => '/ 60';

  @override
  String fgLegalIn(String formato) {
    return '在 $formato 中合法';
  }

  @override
  String get fgTipMoreSets => '试试增加系列，或去掉筛选条件。';

  @override
  String get fgTipMoreCards => '多加些卡——尤其是你主色的卡——或者勾选“包含我没有的卡”。';

  @override
  String get fgPitch => '用你已有的卡，组出完整、能打的牌组。不用买任何东西。';

  @override
  String get fgTeaserCount => '张卡可组你的第一副牌组';

  @override
  String get fgTeaserMissing => '用我没有的卡也组一副';

  @override
  String get fgBasics => '假定我有零散的基本地';

  @override
  String get fgBasicsSub => '几乎每个人都有初学者套牌里的基本地；关掉它就只用你收藏中的基本地。';

  @override
  String get fgFormat => '游戏赛制';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote => '100 张卡 · 单张制 · 用你收藏里的传奇指挥官 · 遵守颜色标识。';

  @override
  String get fgCasualNote => '60 张卡，不限合法性：什么都能用。';

  @override
  String fgFormatNote(String formato) {
    return '60 张卡，只用你在 $formato 中合法的卡。';
  }

  @override
  String get fgWhereFrom => '卡从哪儿来？';

  @override
  String get fgPickSets => '选择系列';

  @override
  String get fgChangeSets => '更换系列';

  @override
  String get fgNeedOneSet => '至少选一个系列：不筛选的话就是 Magic 全部约 30,000 张卡。';

  @override
  String get fgNoSetsNote => '不选系列时，Forge 会用你的全部收藏。';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 个系列的卡，不管你有没有。',
      one: '1 个系列的卡，不管你有没有。',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '只用你在 $n 个系列里的卡——不是整个收藏。',
      one: '只用你在 1 个系列里的卡——不是整个收藏。',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      '你的收藏没有记录每张卡的版本，所以按系列筛选几乎会把所有卡都排除掉。重新导入你的 CSV 并勾选“替换”，再回来。';

  @override
  String get fgIncludeMissing => '包含我没有的卡';

  @override
  String get fgIncludeMissingSub =>
      'Forge 不再局限于你的收藏，而是用这些系列印过的所有卡；之后会告诉你缺多少张、要花多少钱。';

  @override
  String get fgYourTaste => '按你的喜好（可选）';

  @override
  String get fgArchetypeAuto => '原型：自动';

  @override
  String get fgStyle => '风格';

  @override
  String get fgStyleAuto => '风格：自动';

  @override
  String get fgTribeElf => '精灵';

  @override
  String get fgTribeGoblin => '地精';

  @override
  String get fgTribeZombie => '僵尸';

  @override
  String get fgTribeVampire => '吸血鬼';

  @override
  String get fgTribeDragon => '龙';

  @override
  String get fgTribeAngel => '天使';

  @override
  String get fgTribeDemon => '恶魔';

  @override
  String get fgTribeDinosaur => '恐龙';

  @override
  String get fgTribeFaerie => '小仙灵';

  @override
  String get fgTribeMerfolk => '人鱼';

  @override
  String get fgTribeHuman => '人类';

  @override
  String get fgTribeSpirit => '灵魂';

  @override
  String get fgTribeSliver => '裂片妖';

  @override
  String get fgTribeWizard => '巫师';

  @override
  String get fgTribeKnight => '骑士';

  @override
  String get fgTribeWarrior => '战士';

  @override
  String get fgTribeSoldier => '士兵';

  @override
  String get fgTribeCat => '猫';

  @override
  String get fgTribeDog => '狗';

  @override
  String get fgTribeRat => '老鼠';

  @override
  String get fgTribePirate => '海盗';

  @override
  String get fgTribeElemental => '元素兽';

  @override
  String get fgTribeGiant => '巨人';

  @override
  String get fgTribeRogue => '盗贼';

  @override
  String get fgDeepForge => '深度锻造';

  @override
  String get fgDeepForgeHint => '在展示方案之前，先让它们真正互相对战一番（会多等一会儿）。';

  @override
  String get fgPricePerCard => '每张卡价格：';

  @override
  String get fgMin => '最低 €';

  @override
  String get fgMax => '最高 €';

  @override
  String get fgCardYear => '卡牌年份：';

  @override
  String get fgFrom => '从';

  @override
  String get fgTo => '到';

  @override
  String get fgYearNeedsDb => '按年份筛选需要最新的数据库：设置 → 重新下载数据库。';

  @override
  String get fgNoColorsNote => '不选颜色时，Forge 会尝试所有组合。';

  @override
  String fgColorsNote(String colores) {
    return '只组 $colores 的牌组（及其组合）。';
  }

  @override
  String get fgMissingNote =>
      '这副牌组可能含有你没有的卡：每个方案都会说明你缺多少张、要花多少钱（Cardmarket 价格）。';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge 只用你的 $n 张卡。绝不会凭空造出你没有的卡。';
  }

  @override
  String get fgForgeMissing => '铸造牌组（连我缺的一起）';

  @override
  String get fgForgeMine => '铸造我的牌组';

  @override
  String get fgTestMode => '测试模式：击败一副环境热门牌组';

  @override
  String get fgOffline => '全部在你的设备上计算，无需联网';

  @override
  String fgForgingWith(int n) {
    return '你正在用 $n 张卡铸造：这要花几秒钟。窗口没有卡住。';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 副牌组已可上场',
      one: '1 副牌组已可上场',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing => '含你还没有的卡 · 滑动对比';

  @override
  String get fgSwipeMine => '只用你的卡组成 · 滑动对比';

  @override
  String get fgHaveAll => '✓ 你拥有全部卡牌';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '你还差 $n 张卡',
      one: '你还差 1 张卡',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => '查看完整牌组';

  @override
  String get fgReforge => '重铸';

  @override
  String get fgBackToOptions => 'Volver a elegir cómo forjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta 现在 $precio（你的目标价：$objetivo）！';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 你心愿单里有 $n 张卡已跌到目标价！';
  }

  @override
  String get mkTellMeWhenDrops => '降价时通知我';

  @override
  String get mkTargetPrice => '目标价';

  @override
  String mkNow(String precio) {
    return '现在：$precio';
  }

  @override
  String get mkUpdated => '✓ 价格和卡牌已更新';

  @override
  String mkUpdateFailed(String error) {
    return '无法更新：$error';
  }

  @override
  String get mkHistoryReady => '✓ 价格历史已就绪：图表现在能显示最近几个月了';

  @override
  String mkHistoryFailed(String error) {
    return '无法获取历史数据（你原有的仍然完好）：$error';
  }

  @override
  String get mkHistoryLocal =>
      '价格历史：目前只有 ManaForge 每天在你设备上记录的那部分。把 Cardmarket 最近约 90 天的真实数据拉下来（≈4 MB）。';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return '从 $desde 到 $hasta 的 Cardmarket 真实历史，之后就是 ManaForge 自己记录的。';
  }

  @override
  String get mkFetchHistory => '获取历史数据';

  @override
  String get mkCollectionValue => '你收藏的价值 · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n 张卡';
  }

  @override
  String get mkApproxSuffix => ' · 参考价值';

  @override
  String mkBulkPrices(String fecha) {
    return '$fecha 的 Cardmarket 价格（Scryfall）';
  }

  @override
  String mkNoData(String error) {
    return '市场暂无数据：去“收藏”里下载数据库。（$error）';
  }

  @override
  String mkSetsHeader(int n) {
    return '系列（$n）';
  }

  @override
  String get mkPrevious => '上一批';

  @override
  String get mkNext => '下一批';

  @override
  String get mkSearchHint => '查任意卡牌的价格…';

  @override
  String get mkRemoveFromWishlist => '从心愿单移除';

  @override
  String get mkAddToWishlist => '加入心愿单：降价时通知我';

  @override
  String get mkYourWishlist => '你的心愿单';

  @override
  String mkTargetAtMost(String precio) {
    return '目标 ≤ $precio';
  }

  @override
  String get mkAtPrice => '已到价！';

  @override
  String get mkChangeTarget => '修改目标价';

  @override
  String mkNoPriceIn(String market) {
    return '$market 无价格';
  }

  @override
  String get mkPerUnit => '/张';

  @override
  String get mkTopCards => '你最值钱的卡';

  @override
  String get mkImportToSeeValue => '导入你的收藏来查看它的价值。';

  @override
  String mkSetCards(int n) {
    return ' · $n 张卡';
  }

  @override
  String get wlEmpty => '去“市场”里搜索它们，点一下书签，降到你的价位时就会通知你。';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '🔔 你心愿单里有 $n 张卡已到或低于目标价。',
      one: '🔔 你心愿单里有 1 张卡已到或低于目标价。',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'MTGO 的 tix 价格（数字卡牌）';

  @override
  String get mpNoDataYet => '暂无数据：去“市场”更新价格历史';

  @override
  String get mpMtgoNote =>
      'MTGO 的 tix 价格：这是数字卡牌，不能用来给你的实体收藏估价。首页、文件夹和成就仍以 Cardmarket（€）计价。';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return '$mercado 以 $moneda 计的价格。首页、文件夹和成就仍以 Cardmarket（€）估价：货币不做换算。';
  }

  @override
  String get mkUpdate => '更新';

  @override
  String get mkApproxValue => ' · 近似价值（重新导入时勾选“替换”以获得按版本的价格）';

  @override
  String get mkExactPrintings => ' · 按你的确切版本';

  @override
  String mkNowSuffix(String precio) {
    return ' · 现在 $precio';
  }

  @override
  String get wlNothingYet => '你的心愿单里还没有卡。';

  @override
  String get stDbUpdated => '✓ 数据库已更新';

  @override
  String stUpdateFailed(String error) {
    return '无法更新：$error';
  }

  @override
  String get stCardDb => '卡牌数据库';

  @override
  String get stCardDbWhy => '重新下载它，就能拿到新卡、新价格，以及那些需要最新数据的功能（比如 Forge 里的按年份筛选）。';

  @override
  String get stDownloadDbAgain => '重新下载数据库';

  @override
  String get stAppearance => '外观';

  @override
  String get stData => '数据';

  @override
  String get stTheApp => 'App';

  @override
  String get stCredits =>
      '卡牌数据和图片来自 Scryfall。Magic: The Gathering 归 Wizards of the Coast 所有；本项目是依据其粉丝内容政策（Fan Content Policy）制作的粉丝项目。';

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
  String get stEditHome => '编辑首页';

  @override
  String get stEditHomeSub => '选择显示哪些板块以及顺序';

  @override
  String get ehLevel => '你的等级';

  @override
  String get ehShortcuts => '快捷入口';

  @override
  String get ehSummary => '收藏概览';

  @override
  String get ehRecent => '最近查看';

  @override
  String get ehDecks => '你的牌组';

  @override
  String get ehMeta => '当前环境';

  @override
  String get ehNewSets => '新系列';

  @override
  String get ehGems => '你的珍藏';

  @override
  String get ehStatCards => '张';

  @override
  String get ehStatDistinct => '张不同';

  @override
  String get ehStatValue => '价值';

  @override
  String get ehStatDecks => '套牌';

  @override
  String get ehStatAchievements => '成就';

  @override
  String get ehHelp => '拖动可排序，用开关选择首页显示什么。开启的板块只有在有内容可显示时才会出现。';

  @override
  String get ehSection => '板块';

  @override
  String get bkNoData => '找不到你的数据。';

  @override
  String bkSaved(String resumen) {
    return '✓ 备份已保存 · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return '无法保存：$error';
  }

  @override
  String get bkFileName => 'ManaForge 备份';

  @override
  String bkRestoreFailed(String error) {
    return '无法恢复：$error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ 已恢复 · $resumen。注意：我没能保存你之前的数据（$error）。';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ 已恢复 · $resumen。你之前的数据已保存在 backups 文件夹里。';
  }

  @override
  String get bkRestoring => '正在恢复你的备份…';

  @override
  String get bkTitle => '备份';

  @override
  String get bkWhy => '你的卡牌、牌组、文件夹和成就只存在这台电脑上。时不时保存一份备份，放到别处：硬盘、云端，随你。';

  @override
  String get bkSave => '保存备份';

  @override
  String get bkRestoreTitle => '恢复一份备份';

  @override
  String bkRestoreWarning(String palabra) {
    return '恢复会用备份里的数据替换你现在的卡牌、牌组、文件夹和成就。选好一份，点按钮，然后输入 $palabra：这样就不会误恢复。';
  }

  @override
  String get bkNoBackups => '这台电脑上还没有保存过备份。';

  @override
  String get bkWhich => '要恢复的备份';

  @override
  String get bkPickOne => '选择一份备份';

  @override
  String get bkRestorePicked => '恢复所选备份';

  @override
  String get bkAutoNote => '我每周自动保存一份备份（保留最近五份），并在每次恢复前再存一份。';

  @override
  String get bkFromFile => '从文件恢复';

  @override
  String get bkConfirmTitle => '恢复这份备份？';

  @override
  String get bkConfirmBody =>
      '这会用那份备份替换你现在的收藏、牌组、文件夹和成就。动手之前，我会先把你现有的数据存进 backups 文件夹，以便你反悔。';

  @override
  String bkWillDelete(String cosas) {
    return '那份备份里没有 $cosas：恢复后，这些会被删除。';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return '输入 $palabra 才能继续：';
  }

  @override
  String get bkAnd => ' 和 ';

  @override
  String get ehReset => '重置';

  @override
  String bkOfDate(String cuando, String resumen) {
    return '$cuando 的备份 · $resumen。';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => '找不到任何摄像头。';

  @override
  String get lsCameraGone => '摄像头在扫描中途断开了。检查一下线缆，然后点重试。';

  @override
  String get lsFrameCard => '把卡牌放进取景框里';

  @override
  String get lsNoCardThere => '那里没看到卡牌';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n 张卡已入收藏',
      one: '✓ 1 张卡已入收藏',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return '，并加入“$carpeta”';
  }

  @override
  String get lsTitle => '实时扫描';

  @override
  String get lsQuickTip => '快速：清晰的卡自动入库；拿不准的会被标记待复核。';

  @override
  String get lsCarefulTip => '仔细：拿不准的会停下来问你是哪张。';

  @override
  String get lsQuick => '快速';

  @override
  String get lsCareful => '仔细';

  @override
  String lsThisSession(int n) {
    return '本次 $n 张';
  }

  @override
  String get lsScanPhotoTooltip => '扫描单张照片';

  @override
  String get lsStartingCamera => '正在开启摄像头…';

  @override
  String get lsCantUseCamera => '无法使用摄像头';

  @override
  String get lsCameraUnavailable => '摄像头不可用。';

  @override
  String get lsScanPhoto => '扫描一张照片';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 张相同 · $carta（×$n）';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return '已经在桌上了：$carta · 把它拿开再放回，或点“+1 张相同”';
  }

  @override
  String lsSeeing(String carta) {
    return '正在识别：$carta';
  }

  @override
  String get lsPassACard => '把一张卡放到摄像头前…';

  @override
  String lsIsThis(String carta) {
    return '是 $carta 吗？我不太确定——点一下来选择。';
  }

  @override
  String get lsNotThisOne => '不是这张——更换版本';

  @override
  String get lsRetry => '重试';

  @override
  String get scBadImage => '无法读取这张图片（它是有效照片吗？）';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta（$set #$numero）';
  }

  @override
  String get scNoFolder => '不放文件夹';

  @override
  String scAlsoTo(String carpeta) {
    return '并额外加入：$carpeta';
  }

  @override
  String get scLookingForCard => '正在照片里寻找卡牌…';

  @override
  String scRecognising(int hechas, int total) {
    return '识别中… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 张卡',
      one: '1 张卡',
    );
    return '$_temp0 · 共 $copias 张';
  }

  @override
  String scToReview(int n) {
    return '$n 张待复核（点一下）';
  }

  @override
  String scUnknown(int n) {
    return '$n 张未识别（点一下手动选择）';
  }

  @override
  String scSkipped(int n) {
    return '已跳过 $n 张照片（太大或无法读取）';
  }

  @override
  String get scNothingRecognised => '这些照片里我一张卡都没认出来。换个更好的光线，或减少反光试试。';

  @override
  String scAddN(int n) {
    return '把 $n 张加入收藏';
  }

  @override
  String get scDropPhotos => '把你的卡牌照片拖到这里';

  @override
  String get scDropExplain =>
      '一次一张或多张——如果一张照片里有好几张卡（卡册的一页、摆满的桌面），我会把它们全部认出来，汇成一份清单，供你复核并挑选要加入的。手机照片或扫描件都行。';

  @override
  String get scPickPhotos => '选择照片';

  @override
  String get scMatchHigh => '匹配度高';

  @override
  String get scMatchMedium => '匹配度中';

  @override
  String get scMatchLow => '匹配度低';

  @override
  String get scAddToCollection => '加入收藏';

  @override
  String get scSeeOptions => '不是这张——查看选项';

  @override
  String get scScanAnother => '扫描下一张';

  @override
  String get scNotSure => '我不太确定';

  @override
  String get scWhichIsIt => '是哪一张？';

  @override
  String get scNoneQuiteFits => '没有一张完全对得上。是这几张里的某张吗？如果不是，换张光线更好的照片试试。';

  @override
  String get scNoEdges => '我没看清卡牌的边缘，所以用了整张图片。以下是相近的候选：';

  @override
  String get scCropped => '这是我裁剪出的部分。候选项按相似度排列：';

  @override
  String get scDiscard => '丢弃并扫描下一张';

  @override
  String get suCardsName => '卡牌与价格';

  @override
  String get suCardsWhat => 'Scryfall 完整目录';

  @override
  String get suHistoryName => '价格历史';

  @override
  String get suHistoryWhat => 'Cardmarket 约 90 天';

  @override
  String get suHashesName => '扫描指纹库';

  @override
  String get suHashesWhat => '用于照片识别';

  @override
  String suUpToDate(String fecha) {
    return '最新（$fecha）';
  }

  @override
  String get suUpdated => '已更新';

  @override
  String suUpdatedWithDate(String fecha) {
    return '已更新（$fecha）';
  }

  @override
  String get suFailedOffline => '没能获取（无网络连接）';

  @override
  String get suKeepingOld => '继续用你原有的';

  @override
  String get suNeedMissing => '缺失，正在获取';

  @override
  String get suNeedStale => '有新版本';

  @override
  String get suNeedFresh => '最新';

  @override
  String get suAllUpToDate => '全部最新。正在进入…';

  @override
  String get suUpdatingCards => '正在更新你的卡牌和价格…';

  @override
  String get suChecking => '正在检查有没有更新…';

  @override
  String get suNoDownloadNote => '已经是最新的就不会下载。在 App 里你可以强制执行任意更新。';

  @override
  String get suEnter => '进入';

  @override
  String get suEnterNow => '立即进入';

  @override
  String icBadFile(String error) {
    return '无法读取文件：$error';
  }

  @override
  String get icNotCsv => '这看起来不是 CSV——请拖入 .csv 或 .txt 文件。';

  @override
  String get icTitle => '导入收藏';

  @override
  String get icExplain =>
      '把你的 ManaBox CSV 拖到这里（Moxfield、Archidekt，或任何带 Name 和 Quantity 列的 CSV 也行），用按钮选择它，或手动粘贴内容：';

  @override
  String get icPickFile => '选择文件…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas 张卡（$copias 张）已加入你的收藏。';
  }

  @override
  String get icReplaceMine => '替换我当前的收藏';

  @override
  String get icReplaceWhy => '重新导入完整 CSV 时勾选它：避免数量翻倍，并让卡册按版本精确显示。';

  @override
  String icImporting(int hechas, int total) {
    return '正在导入 $total 张卡中的 $hechas 张…';
  }

  @override
  String get icDropHere => '把你的 CSV 拖到这里';

  @override
  String icTokensIgnored(int n) {
    return '\n• 已忽略 $n 个衍生物/纹章（它们不进牌组，没关系）。';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ 未识别：$lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• CSV 里没有购入价：不会有盈亏（ManaBox 会把它导出在“Purchase price”列）。';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n 张带购入价：现在可以在“市场”里看盈亏了。';
  }

  @override
  String get icImporting2 => '正在导入…';

  @override
  String get icImport => '导入';

  @override
  String dkDeleted(String nombre) {
    return '牌组“$nombre”已删除';
  }

  @override
  String get dkUndo => '撤销';

  @override
  String dkOpenFailed(String error) {
    return '无法打开牌组（数据库下载了吗？）：$error';
  }

  @override
  String get dkMyDecks => '我的牌组';

  @override
  String get dkEmpty => '你从 Forge 保存的牌组会出现在这里（在牌组详情页里点保存按钮）。';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '已保存 $n 副',
      one: '已保存 1 副',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos 张法术 + $tierras 张地 · 保存于 $fecha';
  }

  @override
  String get dkDeleteTooltip => '删除牌组';

  @override
  String get ddSaved => '✓ 牌组已保存——在“牌组”标签页里能找到';

  @override
  String get ddReforged => '✓ 牌组已按你的曲线重铸——清单已更新';

  @override
  String get ddSaveToMyDecks => '保存到我的牌组';

  @override
  String get ddCopyList => '复制清单（Moxfield/Arena）';

  @override
  String get ddListCopied => '✓ 清单已复制——粘贴到 Moxfield、Arena 或 Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos 张法术 + $tierras 张地';
  }

  @override
  String get ddHaveAll => '✓ 你拥有全部卡牌';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠ 这副牌组你还差 $n 张卡——它们仍在清单里，没有被删除',
      one: '⚠ 这副牌组你还差 1 张卡——它仍在清单里，没有被删除',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => '你的战术方案';

  @override
  String get ddManaCurve => '法术力曲线';

  @override
  String get ddEditCurve => '编辑曲线';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return '上下拖动柱状条 ↑↓ · $hechizos 张法术 → $tierras 张地';
  }

  @override
  String get ddReforgeCurve => '按这条曲线重铸';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras 张地 · ✦ $hechizos 张法术 · Ø 费用 $coste';
  }

  @override
  String get ddWhyWorks => '这副牌组为什么行得通？';

  @override
  String ddLands(int n) {
    return '地（$n）';
  }

  @override
  String ddDeckTotal(String precio) {
    return '牌组总价：约 $precio €';
  }

  @override
  String get ddCheapestPrice => '最便宜版本的价格（Cardmarket）';

  @override
  String ddSomeNoPrice(int n) {
    return '$n 张无已知价格 · 最便宜版本（Cardmarket）';
  }

  @override
  String get ddInstants => '瞬间';

  @override
  String get ddTypeCreatures => '生物';

  @override
  String get ddTypeSorceries => '法术';

  @override
  String get ddTypeEnchantments => '结界';

  @override
  String get ddTypeArtifacts => '神器';

  @override
  String get ddTypeOther => '其他';

  @override
  String get ddOutOfRange => '  （超出健康区间 20-27）';

  @override
  String get acRecalcTitle => '重新计算成就？';

  @override
  String get acRecalcBody =>
      '会重新检查你的卡牌，并移除如今已不满足条件的成就。可以用来修正那些误发的成就；如果你卖过卡，那些成就也会一并失去。';

  @override
  String get acRecalc => '重新计算';

  @override
  String get acAllFine => '一切都对得上：没有移除任何成就。';

  @override
  String acRemovedN(int n) {
    return '已移除 $n 个不再满足条件的成就。';
  }

  @override
  String get acTitle => '成就';

  @override
  String get acRecalcTooltip => '用我现在的卡牌重新计算';

  @override
  String get acCertsTooltip => '证书';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$total 个成就中已达成 $hechos 个 · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return '$nivel 级 · 还差 $xp XP 升到 $siguiente';
  }

  @override
  String get acIMissing => '我还缺';

  @override
  String get acSecret => '隐藏成就';

  @override
  String get acSecretDesc => '只有达成时才会揭晓。';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ 已达成$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' 于 $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return '$nivel 级达成！';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return '你现在是$titulo了。你已达成 $total 个成就中的 $hechos 个。';
  }

  @override
  String get acOk => '好';

  @override
  String get acSeeAchievements => '查看成就';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 成就达成！$titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return '（还有 $n 个）';
  }

  @override
  String ceNeedDb(String error) {
    return '系列相关的证书需要卡牌数据库（$error）';
  }

  @override
  String get ceWhoseName => '署谁的名？';

  @override
  String get ceCollectorName => '你的收藏者名字';

  @override
  String get ceInNameOf => '署名给…';

  @override
  String get ceEmptyWithData => '你还没有集齐任何一个完整系列。当你在卡册里集齐一整个系列时，这里就会出现可下载的证书。';

  @override
  String get ceEmptyNoData =>
      '要给一个系列发证书，得知道你卡牌的确切版本：重新导入你的 ManaBox CSV（它带有 Scryfall ID）。';

  @override
  String get ceNothingSaved => '什么都没保存。';

  @override
  String ceSavedTo(String ruta) {
    return '✓ 证书已保存到 $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return '无法保存：$error';
  }

  @override
  String get cePickFirstCard => '选择我入坑的第一张卡';

  @override
  String get ceChangeFirstCard => '更换我入坑的第一张卡';

  @override
  String get ceDownloadPng => '下载 PNG';

  @override
  String get cdNotFound => '在数据库里找不到这张卡。';

  @override
  String cdLoadFailed(String error) {
    return '无法加载卡牌详情：$error';
  }

  @override
  String get cdPrev => '上一张 (←)';

  @override
  String get cdNext => '下一张 (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => '未找到卡牌';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return '你为 $qty $copias 付了 $total$divisa（每张 $unidad）';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '张',
      one: '张',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ 你的收藏里有 $n 张',
      one: '✓ 你的收藏里有 1 张',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => '你还没有这张卡（暂时）。';

  @override
  String cdNoPrice(String mercado) {
    return '$mercado 上没有这张卡的价格。';
  }

  @override
  String cdVersions(int n) {
    return '版本（$n）';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return '$mercado 上没有按版本的价格';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return '$mercado 价格（$moneda） · 普通 / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return '你有 x$n';
  }

  @override
  String get smMythic => '秘稀';

  @override
  String get smRare => '稀有';

  @override
  String get smUncommon => '非普通';

  @override
  String get smCommon => '普通';

  @override
  String smLoadFailed(String error) {
    return '无法加载该系列：$error';
  }

  @override
  String get smSearchInSet => '在系列中搜索…';

  @override
  String get smRarityAll => '稀有度：全部';

  @override
  String get smPriceDown => '价格 ↓';

  @override
  String get smPriceUp => '价格 ↑';

  @override
  String get smNumber => '编号';

  @override
  String get smOnlyMine => '只看我的';

  @override
  String smCardsCount(int n) {
    return '$n 张卡';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado：没有按版本的价格';
  }

  @override
  String smListedValue(String mercado) {
    return '标示价值（$mercado）：  ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return '你付了 $pagado · 如今价值 $hoy';
  }

  @override
  String get pnNoPnl =>
      '没有购入价就没有盈亏。导入带“Purchase price”列的 ManaBox CSV，它就会出现在这里。';

  @override
  String pnOverAll(int n) {
    return '基于你收藏中的 $n 张';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return '基于 $total 张中的 $conprecio 张（其余没有记录购入价）';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '有 $n 张已购入的卡在数据库里没有今日价格：不计入统计';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return '你还付了 $importe $moneda，这部分不做换算';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '有 $n 张在 CSV 里没有货币：按 $moneda 计';
  }

  @override
  String get pcTitle => '价格走势';

  @override
  String get pcNoHistory => '这张卡还没有价格历史。';

  @override
  String pcTodayPrice(String precio) {
    return '今日价格：$precio €。等积累了几天的数据，图表就会出现。';
  }

  @override
  String get pcExplain =>
      'ManaForge 会逐日记录你查看或拥有的每张卡的价格。想以 Cardmarket 最近几个月的真实数据开个头，就去“市场”拉取历史。';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 天',
      one: '1 天',
    );
    return '最低 $min € · 最高 $max € · $_temp0';
  }

  @override
  String get spWhichSets => '从哪些系列？';

  @override
  String get spSearchHint => '按名称或代码搜索（BLB、MH3…）';

  @override
  String get spOnlyMine => '只看我的';

  @override
  String spClearN(int n) {
    return '清除这 $n 个';
  }

  @override
  String get spNoneNamed => '没有叫这个名字的系列。取消“只看我的”来查看全部。';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n 张卡';
  }

  @override
  String get spNoFilter => '不按系列筛选';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '使用 $n 个系列',
      one: '使用 1 个系列',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return '我只在系列 $set 里找卡。点一下可更换或解除锁定。';
  }

  @override
  String get slLockHint => '锁定一个系列来扫描一整盒/预组：扫描器只在其中查找，并精确锁定版本。';

  @override
  String slSetIs(String set) {
    return '系列：$set';
  }

  @override
  String get slSetAll => '系列：全部';

  @override
  String get slLockTitle => '锁定版本';

  @override
  String get slLockBody => '输入系列代码（例如 AER、MH3、LCI）来扫描一整盒：只会查找该系列的卡。';

  @override
  String get slSetCode => '系列代码';

  @override
  String get slClearLock => '解除锁定';

  @override
  String get stHintQuick =>
      '把卡从摄像头前划过：清晰的会自动记在这里（相同的会累加 ×N）。拿不准的会被标记待复核。完事后，一次性确认全部。';

  @override
  String get stHintCareful => '把卡从摄像头前划过：清晰的会自动记下；拿不准的会问你是哪张。完事后，一次性确认全部。';

  @override
  String stAddN(int n) {
    return '把 $n 张加入收藏';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return '把 $n 张加入收藏并加入 $carpeta';
  }

  @override
  String get stOneLess => '减一张';

  @override
  String get stAnotherSame => '再来一张相同';

  @override
  String get stOnTable => '在桌上';

  @override
  String cdLastData(String fecha) {
    return '（最新数据：$fecha）';
  }

  @override
  String get cdLegalities => '赛制合法性';

  @override
  String get slLockButton => '锁定';

  @override
  String get wn030Headline => '按系列使用 Forge、购入价，以及版本更新提醒';

  @override
  String get wn030Forge =>
      'Forge：选择卡从哪些系列出。如果你打开“包含我没有的卡”，它会用所选的全部卡组来搭牌，并告诉你缺多少张、要花多少钱。';

  @override
  String get wn030Pnl =>
      '购入价与盈亏：如果你的 ManaBox CSV 带有“Purchase price”，“市场”会告诉你付了多少、如今值多少，以及差额。货币不会混算。';

  @override
  String get wn030PhotoFolder => '照片扫描现在也能选文件夹，跟实时扫描一样。';

  @override
  String get wn030Album => '卡册：每个系列你还缺什么，以及补齐要花多少钱。';

  @override
  String get wn030Background =>
      '壁纸：背景可以放你喜欢的任意图片，蒙版浓淡可调，还能选卡片和文字的颜色，让内容在上面依然清晰。';

  @override
  String get wn030Window => '窗口会在你上次关闭的位置、以上次的大小打开。';

  @override
  String get wn030Achievements =>
      '成就不再以达成条件命名，而是以那个瞬间命名：“钱都砸进去了”、“一百张稀有，没一张能打”。';

  @override
  String get wn030Update => '有新版本时 App 会提醒（但不会自己更新），并会校验它下载的数据库的 SHA-256 指纹。';

  @override
  String get wn030Shortcuts => '键盘快捷键：Ctrl+1…7、Ctrl+E、Ctrl+F、Ctrl+, 和 Escape。';

  @override
  String get wn030Linux => '在 Linux 上，安装程序会把 ManaForge 连同图标放进应用菜单。';

  @override
  String get wn030License => 'PolyForm Noncommercial 许可证：随你分享、随你折腾，但不得出售。';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 张卡',
      one: '1 张卡',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 副牌组',
      one: '1 副牌组',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 个文件夹',
      one: '1 个文件夹',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 个成就',
      one: '1 个成就',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => '空备份';

  @override
  String get bkStoreCollection => '你的收藏';

  @override
  String get bkStoreFolders => '你的文件夹';

  @override
  String get bkStoreDecks => '你的牌组';

  @override
  String get bkStoreAchievements => '你的成就';

  @override
  String get bkStoreWishlist => '你的心愿单';

  @override
  String get bkStoreCertificates => '你的证书';

  @override
  String get bkStoreMarket => '你偏好的市场';

  @override
  String get bkStoreRecents => '最近查看过的卡';

  @override
  String get bkStoreValueHistory => '价值历史';

  @override
  String get bkStorePriceHistory => '价格历史';

  @override
  String get bkKindAuto => '自动';

  @override
  String get bkKindPreRestore => '恢复前';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig => '这个文件太大了，不像是 ManaForge 的备份。';

  @override
  String get bkErrExpandTooBig => '这份备份解开后太大了：看起来不是真正的 ManaForge 备份。';

  @override
  String get bkErrNotABackup => '这个文件不是 ManaForge 的备份。';

  @override
  String get bkErrNewerVersion => '这份备份是更新版的 ManaForge 做的。请先升级 App 再重试。';

  @override
  String get bkErrIncomplete => '这份备份不完整：里面没有你的数据。';

  @override
  String bkErrDamaged(String almacen) {
    return '这份备份已损坏：无法读取 $almacen。';
  }

  @override
  String bkErrWriteFailed(String error) {
    return '我无法写入数据文件夹，所以什么都没动：$error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return '恢复只进行了一半（$total 个文件里写了 $escritos 个）。我没有此前数据的备份。详情：$error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return '恢复只进行了一半（$total 个文件里写了 $escritos 个）。要退回去，请恢复 $ruta。详情：$error';
  }

  @override
  String get siImportTooBig => '这个文件太大了，不像是卡牌清单。';

  @override
  String get siInsecureDownload => '下载指向了一个不安全的地址，已取消。';

  @override
  String get siRedirectNowhere => '下载重定向到了空地址，已取消。';

  @override
  String get siTooManyRedirects => '下载重定向次数过多，已取消。';

  @override
  String get siDownloadTooBig => '下载的体积远超应有大小，已取消。';

  @override
  String get siBadHash => '下载的内容与 GitHub 上公布的指纹不符。什么都没安装。再试一次；如果一直这样，请反馈。';

  @override
  String get siBackgroundNotImage => '请选一张图片（.jpg、.png 或 .webp）作为背景。';

  @override
  String get siBackgroundTooBig => '这张图片太大了，没法用作背景。';

  @override
  String get siScanTooBig => '这张照片太大了，没法识别。';

  @override
  String get bgImages => '图片';

  @override
  String bgImageFailed(String error) {
    return '无法使用这张图片：$error';
  }

  @override
  String get bgLowContrast => '与卡片的对比太弱：文字会自动调整以保证可读。';

  @override
  String get bgChipColor => '标签颜色';

  @override
  String get bgIconColor => '图标颜色';

  @override
  String get bgUseThis => '用这个';

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
      'GStreamer 没有安装。用这个命令安装：\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return '摄像头 $dispositivo 没有画面（gst-launch 退出码 $codigo）。\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return '摄像头 $dispositivo 在 6 秒内没有输出任何一帧。';
  }

  @override
  String get camNoCameras => '找不到任何摄像头（/dev/video*）。它连接好了吗？用 `lsusb` 确认系统能看到它。';

  @override
  String camNoneWorked(String detalle) {
    return '没有任何摄像头能出画面：\n$detalle';
  }

  @override
  String get bkRestoreAction => '恢复';

  @override
  String get fpUnselect => '取消选择';

  @override
  String get stClear => '清空';

  @override
  String get tlRemove => '移除';

  @override
  String get tlUnrecognized => '未识别';

  @override
  String get tlNothingAlike => '数据库里没有相近的——重拍或移除';

  @override
  String get tlTapToPick => '点一下在相近项里手动选择';

  @override
  String get tlReview => '待确认';

  @override
  String get lsQuantity => '数量';

  @override
  String get scPhotos => '照片';

  @override
  String get ftWhichFolder => '你想把它们放进哪个文件夹？';

  @override
  String get ftWhichFolderSub => '它们照样会进你的收藏；文件夹只是个标签，方便你以后找到它们。';

  @override
  String get ftNone => '无';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 张卡',
      one: '1 张卡',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => '新建文件夹…';

  @override
  String get ftNewFolder => '新建文件夹';

  @override
  String get ftNewFolderHint => '店里那盒、待出售…';

  @override
  String get sgTitle => '扫描器之眼';

  @override
  String get sgWhy => '要在没有网络时识别卡牌，我需要视觉指纹库（约 12 MB）：Magic 每张插画的画面特征。只需下载一次。';

  @override
  String get sgDownload => '下载指纹库';

  @override
  String get cmFullCard => '查看完整卡牌详情（价格与合法性）';

  @override
  String get cmSwipeHint => '拖动或用 ← → 翻页 · 点外部关闭';

  @override
  String get cmTapOutHint => '点外部关闭';

  @override
  String get fcTitle => '你是从哪张卡入坑的？';

  @override
  String get fcRemove => '移除';

  @override
  String get fcSearchHint => '在你的收藏里搜索';

  @override
  String get fcNoMatch => '找不到符合的卡。';

  @override
  String get acNoneWithFilters => '在这些筛选条件下这里什么都没有。';

  @override
  String get acAll => '全部';

  @override
  String get tsTitle => '测试模式——击败环境';

  @override
  String get tsIntro =>
      '选一副你想对抗的环境热门牌组。ManaForge 会用你的卡搭出牌组，对它模拟数百局对局，留下胜率最高的那副——并逐张试换卡牌来微调它。';

  @override
  String get tsLoadingMeta => '正在加载环境…';

  @override
  String get tsLocalPresets => '本地预设（离线）';

  @override
  String get tsNoDeckToFace => '用现有的卡我搭不出任何一副完整的牌组来对抗。多加些卡再试。';

  @override
  String tsSimFailed(String error) {
    return '无法模拟：$error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · 占环境 $cuota';
  }

  @override
  String get tsSimulating => '正在模拟对局…（几秒钟；全部在你的设备上进行）';

  @override
  String tsFindBest(String meta) {
    return '找出我对抗 $meta 的最佳牌组';
  }

  @override
  String get tsHonesty =>
      '老实说：模拟能理解法术力颜色、调度、闪避（飞行、践踏、死触…）、瞬间去除和反击——但不理解每张卡的完整规则文字。这个百分比是用来在你自己的牌组之间做比较的，不是精确预测。';

  @override
  String tsChampion(String meta) {
    return '你对抗 $meta 的冠军牌组';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return '预估胜率 · 试了 $mazos 副牌组 · 每副 $partidas 局';
  }

  @override
  String get tsNoDominant => '你收藏里没有哪副牌组能碾压这个对局——这是打得最好的一副。在详情里看看它的弱点。';

  @override
  String get tsSeeDeck => '查看完整牌组（并保存）';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total 个成就 · 距 $nivel 级还差 $xp XP';
  }

  @override
  String get hsForgeDecks => '铸造牌组';

  @override
  String get hsTestYourself => '⚔ 检验自己';

  @override
  String get bgCustom => '自定义';

  @override
  String get bgPickCustom => '选择自定义颜色';

  @override
  String get bgCustomColor => '自定义颜色';

  @override
  String get bgSampleTab => '红色';

  @override
  String get cfSortRecent => '最近添加';

  @override
  String get cfSortAlpha => '名称 A-Z';

  @override
  String get cfSortCmc => '费用';

  @override
  String get cfSortQty => '数量';

  @override
  String get cfSortBy => '排序方式';

  @override
  String get cfSort => '排序';

  @override
  String get cfClear => '清除';

  @override
  String get cfCost => '费用';

  @override
  String get cfCostAll => '费用：全部';

  @override
  String cfCostN(String n) {
    return '费用 $n';
  }

  @override
  String get cfType => '类别';

  @override
  String get cfTypeAll => '类别：全部';

  @override
  String get cfTypeCreature => '生物';

  @override
  String get cfTypeInstant => '瞬间';

  @override
  String get cfTypeSorcery => '法术';

  @override
  String get cfTypeArtifact => '神器';

  @override
  String get cfTypeEnchantment => '结界';

  @override
  String get cfTypeLand => '地';

  @override
  String get cfPower => '力量';

  @override
  String get cfPowerAll => '力量：全部';

  @override
  String cfPowerMin(int n) {
    return '力量 ≥ $n';
  }

  @override
  String get cfToughness => '防御力';

  @override
  String get cfToughnessAll => '防御力：全部';

  @override
  String cfToughnessMin(int n) {
    return '防御力 ≥ $n';
  }

  @override
  String get cfNoDate => '无日期';

  @override
  String get cfToday => '今天';

  @override
  String get cfYesterday => '昨天';

  @override
  String cfDaysAgo(int n) {
    return '$n 天前';
  }

  @override
  String get pcWeek => '周';

  @override
  String get pcMonth => '月';

  @override
  String get pcAll => '全部';

  @override
  String get vpTapCorrect => '点一下正确的那张卡';

  @override
  String get achCopias1 => '万里长征第一张';

  @override
  String get achCopias10 => '本来只想买一张';

  @override
  String get achCopias50 => '一手都抓不下了';

  @override
  String get achCopias100 => '一百张，还在涨';

  @override
  String get achCopias500 => '盒子不够装了';

  @override
  String get achCopias1000 => '一千张，还想要更多';

  @override
  String get achCopias5000 => '这已经是个仓库了';

  @override
  String get achCopias10000 => '一万张，但我拿捏得住';

  @override
  String achCopiasDesc(String n) {
    return '收藏里拥有 $n 张卡。';
  }

  @override
  String get achDistintas25 => '花样开始多了';

  @override
  String get achDistintas100 => '一百张不重样';

  @override
  String get achDistintas500 => '半座图书馆';

  @override
  String get achDistintas1000 => '行走的百科全书';

  @override
  String get achDistintas2500 => '我已经记不全了';

  @override
  String get achDistintas5000 => '活体档案库';

  @override
  String achDistintasDesc(String n) {
    return '拥有 $n 张不同的卡（不算重复的）。';
  }

  @override
  String get achPlaysets1 => '四张一套';

  @override
  String get achPlaysets20 => '二十套齐活，一副牌组没有';

  @override
  String get achPlaysets1Desc => '拥有同一张卡的 4 张。';

  @override
  String get achPlaysets20Desc => '拥有 20 套不同的四张组（每套 4 张）。';

  @override
  String get achComunes10 => '没人稀罕的那些';

  @override
  String get achComunes50 => '老一堆的常客';

  @override
  String get achComunes200 => '杂牌堆之王';

  @override
  String get achComunes500 => '普通卡的海洋';

  @override
  String achComunesDesc(String n) {
    return '拥有 $n 张不同的普通卡。';
  }

  @override
  String get achInfrecuentes10 => '比普通稍强一点';

  @override
  String get achInfrecuentes50 => '上好的银子';

  @override
  String get achInfrecuentes200 => '非普通猎手';

  @override
  String get achInfrecuentes500 => '银子成堆';

  @override
  String achInfrecuentesDesc(String n) {
    return '拥有 $n 张不同的非普通卡。';
  }

  @override
  String get achRaras5 => '拆包时的好声音';

  @override
  String get achRaras25 => '稀有卡宝箱';

  @override
  String get achRaras100 => '一百张稀有，没一张能打';

  @override
  String get achRaras300 => '稀有卡金库';

  @override
  String achRarasDesc(String n) {
    return '拥有 $n 张不同的稀有卡。';
  }

  @override
  String get achMiticas1 => '我的第一张秘稀';

  @override
  String get achMiticas10 => '十张秘稀';

  @override
  String get achMiticas50 => '秘稀收藏家';

  @override
  String get achMiticas150 => '秘稀万神殿';

  @override
  String achMiticasDesc(String n) {
    return '拥有 $n 张不同的秘稀卡。';
  }

  @override
  String get achBlancas25 => '秩序井然';

  @override
  String get achBlancas100 => '白银军团';

  @override
  String achBlancasDesc(String n) {
    return '拥有 $n 张不同的白色卡。';
  }

  @override
  String get achAzules25 => '这个可不许你过';

  @override
  String get achAzules100 => '象牙塔';

  @override
  String achAzulesDesc(String n) {
    return '拥有 $n 张不同的蓝色卡。';
  }

  @override
  String get achNegras25 => '黑暗契约';

  @override
  String get achNegras100 => '墓穴之主';

  @override
  String achNegrasDesc(String n) {
    return '拥有 $n 张不同的黑色卡。';
  }

  @override
  String get achRojas25 => '烧个精光';

  @override
  String get achRojas100 => '全面大火';

  @override
  String achRojasDesc(String n) {
    return '拥有 $n 张不同的红色卡。';
  }

  @override
  String get achVerdes25 => '冒了个芽';

  @override
  String get achVerdes100 => '整片森林';

  @override
  String achVerdesDesc(String n) {
    return '拥有 $n 张不同的绿色卡。';
  }

  @override
  String get achIncoloras25 => '冷冰冰的金属';

  @override
  String get achIncoloras100 => '永恒熔炉';

  @override
  String achIncolorasDesc(String n) {
    return '拥有 $n 张不同的无色卡。';
  }

  @override
  String get achArcoiris => '五色齐聚';

  @override
  String get achArcoirisDesc => '五种颜色每种至少拥有一张卡。';

  @override
  String get achMulticolor10 => '开始调色了';

  @override
  String get achMulticolor50 => '黄金同盟';

  @override
  String achMulticolorDesc(String n) {
    return '拥有 $n 张不同的多色卡。';
  }

  @override
  String get achCincocolores => '五色于一身';

  @override
  String get achCincocoloresDesc => '拥有一张同时具备五种颜色的卡。';

  @override
  String get achSets1 => '第一个系列';

  @override
  String get achSets5 => '五个世界';

  @override
  String get achSets10 => '位面旅人';

  @override
  String get achSets25 => '环球浪人';

  @override
  String get achSets50 => '半个多元宇宙';

  @override
  String achSetsDesc(String n) {
    return '拥有来自 $n 个不同系列的卡。';
  }

  @override
  String get achSetscompletos1 => '一张不缺';

  @override
  String get achSetscompletos3 => '三本卡册全满';

  @override
  String get achSetscompletos10 => '卡册大师';

  @override
  String get achSetscompletos1Desc => '在卡册里集齐一整个系列。';

  @override
  String achSetscompletos3Desc(String n) {
    return '集齐 $n 个完整系列。';
  }

  @override
  String get achAnyos5 => '五年的卡片光阴';

  @override
  String get achAnyos15 => '时光机';

  @override
  String achAnyosDesc(String n) {
    return '拥有来自 $n 个不同发行年份的卡。';
  }

  @override
  String get achValor10 => '第一笔欧元';

  @override
  String get achValor50 => '小猪存钱罐';

  @override
  String get achValor250 => '工资就这么没了';

  @override
  String get achValor1000 => '钱都砸进去了';

  @override
  String get achValor5000 => '别跟任何人说';

  @override
  String get achValor10000 => '比我的车还值钱';

  @override
  String get achValor25000 => '博物馆级收藏';

  @override
  String achValorDesc(String n) {
    return '让你的收藏价值达到 $n € 或以上。';
  }

  @override
  String get achJoya20 => '一张好货';

  @override
  String get achJoya100 => '收藏里的明珠';

  @override
  String get achJoya500 => '这张绝不脱套';

  @override
  String get achJoya1000 => '一张套里的一千欧';

  @override
  String get achJoya2500 => '圣杯到手';

  @override
  String achJoyaDesc(String n) {
    return '拥有单张价值达 $n € 或以上的卡。';
  }

  @override
  String get achFoils1 => '第一道闪光';

  @override
  String get achFoils10 => '闪闪发亮';

  @override
  String get achFoils50 => '整盒都在发光';

  @override
  String get achFoils200 => '这里再没有不亮的了';

  @override
  String get achFoils500 => '全员发光';

  @override
  String get achFoils1000 => '闪光制造厂';

  @override
  String achFoilsDesc(String n) {
    return '拥有 $n 张 foil 卡。';
  }

  @override
  String get achFoiljoya10 => '闪的是好货';

  @override
  String get achFoiljoya50 => '闪的是贵货';

  @override
  String get achFoiljoya200 => '博物馆级 foil';

  @override
  String achFoiljoyaDesc(String n) {
    return '拥有一张价值达 $n € 或以上的 foil 卡。';
  }

  @override
  String get achFoilvalor50 => '会发光的展柜';

  @override
  String get achFoilvalor250 => '昂贵的展柜';

  @override
  String get achFoilvalor1000 => '一千欧的闪光';

  @override
  String get achFoilvalor5000 => '博物馆级展柜';

  @override
  String achFoilvalorDesc(String n) {
    return '让你所有 foil 卡加起来价值达 $n € 或以上。';
  }

  @override
  String get achMazos1 => '第一副牌组';

  @override
  String get achMazos5 => '存了五副牌组';

  @override
  String get achMazos25 => '作坊连轴转';

  @override
  String achMazosDesc(String n) {
    return '保存 $n 副用 Forge 做的牌组。';
  }

  @override
  String get achMazoscore => '完美牌组';

  @override
  String get achMazoscoreDesc => '生成一副评分 90 或以上的牌组。';

  @override
  String get achMazocolores3 => '三色牌组';

  @override
  String get achMazocolores5 => '能打的彩虹';

  @override
  String achMazocoloresDesc(String n) {
    return '保存一副 $n 色牌组。';
  }

  @override
  String get achMazomono => '纯色不掺';

  @override
  String get achMazomonoDesc => '保存一副单色牌组。';

  @override
  String get achMazocommander => '指挥官上任';

  @override
  String get achMazocommanderDesc => '保存一副 Commander 牌组。';

  @override
  String get achEscaneadas1 => '第一次扫描';

  @override
  String get achEscaneadas50 => '手速惊人';

  @override
  String get achEscaneadas500 => '流水线扫描';

  @override
  String get achEscaneadas2000 => '闭着眼都能扫';

  @override
  String achEscaneadasDesc(String n) {
    return '用摄像头或照片扫描 $n 张卡。';
  }

  @override
  String get achFoto9 => '一拍整整一页';

  @override
  String get achFoto20 => '一次拿下二十张';

  @override
  String achFotoDesc(String n) {
    return '在一张照片里识别 $n 张卡。';
  }

  @override
  String get achEscaneoperfecto => '一张都不用复核';

  @override
  String get achEscaneoperfectoDesc => '扫描一整页，没有一张卡需要复核。';

  @override
  String get achDias2 => '你又回来了';

  @override
  String get achDias7 => '来了一周';

  @override
  String get achDias30 => '来了一个月';

  @override
  String get achDias100 => '来了一百天';

  @override
  String achDiasDesc(String n) {
    return '在 $n 个不同的日子里使用 ManaForge。';
  }

  @override
  String get achRacha3 => '连来三天';

  @override
  String get achRacha7 => '完美一周';

  @override
  String get achRacha30 => '整月不断卡';

  @override
  String achRachaDesc(String n) {
    return '连续 $n 天进入。';
  }

  @override
  String get achSemanas => '四周从不缺席';

  @override
  String get achSemanasDesc => '连续 4 周使用 ManaForge。';

  @override
  String get achCarpetas1 => '开始收拾了';

  @override
  String get achCarpetas5 => '全部归类完毕';

  @override
  String achCarpetasDesc(String n) {
    return '创建 $n 个文件夹。';
  }

  @override
  String get achCarpetagrande => '超大文件夹';

  @override
  String get achCarpetagrandeDesc => '拥有一个含 100 张卡或以上的文件夹。';

  @override
  String get achCarpetavalor => '这个文件夹概不外借';

  @override
  String get achCarpetavalorDesc => '拥有一个价值 100 € 或以上的文件夹。';

  @override
  String get achTierrasbasicas => '五种基本地';

  @override
  String get achTierrasbasicasDesc => '拥有全部五种基本地（平原、海岛、沼泽、山脉和树林）。';

  @override
  String get achFuerza => '好大一只怪';

  @override
  String get achFuerzaDesc => '拥有一个力量 10 或以上的生物。';

  @override
  String get achCoste => '这辈子都别想施放';

  @override
  String get achCosteDesc => '拥有一张总法术力费用 10 或以上的卡。';

  @override
  String get achCostecero => '白嫖';

  @override
  String get achCosteceroDesc => '拥有一张费用为 0 的卡。';

  @override
  String get achTipos => '样样都来点';

  @override
  String get achTiposDesc => '至少各拥有一张生物、瞬间、法术、神器、结界、地和鹏洛客。';

  @override
  String get achPlaneswalkers => '鹏洛客小队';

  @override
  String get achPlaneswalkersDesc => '拥有 5 个不同的鹏洛客。';

  @override
  String get achNoventas => '九十年代的遗物';

  @override
  String get achNoventasDesc => '拥有一张九十年代的卡。';

  @override
  String get achIdiomas1 => '这张我看不懂';

  @override
  String get achIdiomas25 => '多语种收藏';

  @override
  String get achIdiomas1Desc => '拥有一张非英语的卡。';

  @override
  String get achIdiomas25Desc => '拥有 25 张其他语言的卡。';

  @override
  String get achWishlist => '任性心愿单';

  @override
  String get achWishlistDesc => '在心愿单里记下 20 张卡。';

  @override
  String get achTierBronze => '青铜';

  @override
  String get achTierSilver => '白银';

  @override
  String get achTierGold => '黄金';

  @override
  String get achTierMythic => '秘稀';

  @override
  String get achCatCollection => '收藏';

  @override
  String get achCatRarity => '稀有度';

  @override
  String get achCatColor => '颜色';

  @override
  String get achCatSets => '系列';

  @override
  String get achCatValue => '价值';

  @override
  String get achCatFoils => 'Foil';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => '扫描器';

  @override
  String get achCatDedication => '投入';

  @override
  String get achCatFolders => '文件夹';

  @override
  String get achCatCuriosities => '趣味';

  @override
  String get achRankApprentice => '学徒';

  @override
  String get achRankSummoner => '咒法师';

  @override
  String get achRankMage => '法师';

  @override
  String get achRankArchmage => '大法师';

  @override
  String get achRankMaster => '宗师';

  @override
  String get achRankPlaneswalker => '鹏洛客';

  @override
  String get bkConfirmWord => 'CONFIRM';

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
    return '无法下载卡牌数据库（HTTP $codigo）。过一会儿再试。';
  }

  @override
  String dbErrHashes(String codigo) {
    return '无法下载指纹库（HTTP $codigo）。过一会儿再试。';
  }

  @override
  String dbErrPrices(String codigo) {
    return '无法下载价格历史（HTTP $codigo）。过一会儿再试。';
  }

  @override
  String ddCardCount(int n) {
    return '$n 张卡';
  }

  @override
  String get ddForgedWith => '用 ManaForge 铸造';

  @override
  String get fxThemeLifegain => '生命汲取';

  @override
  String get fxThemeSacrifice => '牺牲';

  @override
  String get fxThemeSpells => '咒语';

  @override
  String get fxThemeArtifacts => '神器';

  @override
  String get fxThemeCounters => '+1/+1 指示物';

  @override
  String get fxThemeTokens => '衍生物大军';

  @override
  String get fxThemeGraveyard => '坟场';

  @override
  String get fxThemeReanimator => '复生';

  @override
  String fxThemeTribal(String tribe) {
    return '$tribe部落';
  }

  @override
  String get fxThemeGoodstuff => '精华好牌';

  @override
  String get fxTagLifegain => '你回的每点生命都是对手的伤害：汲取、扛住。';

  @override
  String get fxTagSacrifice => '你的生物死了更值钱：牺牲它们，收取过路费。';

  @override
  String get fxTagSpells => '每个瞬间都算数：在对手回合出手，狠狠惩罚。';

  @override
  String get fxTagArtifacts => '搭起你的作坊：每个神器都让其他神器更强。';

  @override
  String get fxTagCounters => '+1/+1 指示物：让你的生物一路长到无人能挡。';

  @override
  String get fxTagTokens => '用衍生物淹没战场：他们有一个，你有五个。';

  @override
  String get fxTagGraveyard => '坟场就是你的第二只手：填满它，回收最好的牌。';

  @override
  String get fxTagAggro => '抢开局、直接打脸：这局该速战速决。';

  @override
  String get fxTagTempo => '早早施压，用你的咒语守住优势。';

  @override
  String fxTagMidrange(String tema) {
    return '打好每一次换牌，靠 $tema 赢下中局。';
  }

  @override
  String get fxTagControl => '扛住，见招拆招，等战场归你再收尾。';

  @override
  String get fxMidLifegain => '把你的回血来源和那些借此惩罚对手的牌串起来。';

  @override
  String get fxMidSacrifice => '牺牲廉价单位来抽牌、汲取，或让其余生物长大。';

  @override
  String get fxMidSpells => '留着法术力：你每施放一个咒语，生物就会长大。';

  @override
  String get fxMidArtifacts => '铺开廉价神器，激活那些数神器的牌。';

  @override
  String get fxMidCounters => '把指示物堆到一两个生物上，然后保护它们。';

  @override
  String get fxMidTokens => '每回合产出衍生物，再找能让它们变强的效果。';

  @override
  String get fxMidGraveyard => '有目的地磨牌、弃牌：落进坟场的东西还会回来。';

  @override
  String get fxEndLifegain => '生命值一高，就切进攻模式：他们已经追不上了。';

  @override
  String get fxEndSacrifice => '攒下的价值帮你赢下这局：每次换牌你都不亏。';

  @override
  String get fxEndSpells => '同一回合甩出两三个咒语，你的生物就能收尾。';

  @override
  String get fxEndArtifacts => '你的战场价值是对手的两倍：用你的收益牌收尾。';

  @override
  String get fxEndCounters => '一个又大又受保护的威胁，两下就能结束战斗。';

  @override
  String get fxEndTokens => '全军压上：没有哪道防线挡得住你整支大军。';

  @override
  String get fxEndGraveyard => '反复利用你最好的牌：你等于用两只手打对手一只手。';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => '每回合都下一个生物，绝不例外。';

  @override
  String get fxAggroMid => '继续进攻；留着直伤去清掉阻挡者。';

  @override
  String get fxAggroLate => '倾巢收尾：到这儿你就该结束战斗了。';

  @override
  String get fxTempoEarly => '下个廉价威胁，能留法术力就留着。';

  @override
  String get fxTempoMid => '进攻，并在对手回合施放你的咒语。';

  @override
  String get fxTempoLate => '保护好生物，靠飞行或直伤收尾。';

  @override
  String get fxMidrangeEarly => '稳步铺场，别白送牌：做好一换一。';

  @override
  String fxMidrangeMid(String tema) {
    return '铺开你的 $tema 引擎，稳住战场。';
  }

  @override
  String get fxMidrangeLate => '你的牌比对手的更值：把这点转化成胜局。';

  @override
  String get fxControlEarly => '每回合按时下地，只回应真正要紧的东西。';

  @override
  String get fxControlMid => '清场、抽牌：时间站在你这边。';

  @override
  String get fxControlLate => '下一个威胁，护着它到最后。';

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
    return '平均费用 $coste：按 Karsten 法则（费用 3.0 时 24 张地，每 ±0.5 增减 ±1 张），这副牌组带 $tierras 张地——正落在一副 $arquetipo 牌组的区间里。有 $criaturas 个生物守住战场，还有 $interaccion 张互动牌应对对手打出的东西。主题（$tema）把你的协同聚拢在一起：主题的部件见得越多，每一件就越强。';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return '按这条曲线会得到 $tierras 张地：超出了健康区间（$min-$max）。调整一下法术总数。';
  }

  @override
  String get fxNoCards => '你的收藏里这些颜色的卡不够填满这条曲线。试试减少法术，或换些费用。';

  @override
  String fxNoProfile(String coste, String tierras) {
    return '这条曲线（平均费用 $coste、$tierras 张地）不符合任何健康配置：便宜的牌组要更少的地，昂贵的要更多。把两者靠拢一些。';
  }

  @override
  String get fxNoBasics => '收藏里没有足够的基本地来支撑这条曲线。';

  @override
  String fxHardRule(String detalle) {
    return '你要求的曲线违反了一条硬规则：$detalle';
  }

  @override
  String get tsPresetMonoRed => '廉价生物加直击面部的伤害：跟不上节奏的话，4-5 回合就把你打死。';

  @override
  String get tsPresetAzorius => '反击、扫场加抽牌：拖长对局，用寥寥几张终结牌取胜。';

  @override
  String get tsPresetGolgari => '一换一、高效生物加黑色去除：靠牌张质量赢下长局。';
}
