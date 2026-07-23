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
  String get onbAchievementsBody => '你的等级，以及扫描、整理和打造套牌获得的徽章。从主页的等级卡片进入。';

  @override
  String get onbCertificatesTitle => '证书';

  @override
  String get onbCertificatesBody => '重要里程碑会生成一张证书，可以存成 PDF 或拿去炫耀。它们在成就里面。';
}
