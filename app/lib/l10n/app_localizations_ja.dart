// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabCollection => 'コレクション';

  @override
  String get tabAlbum => 'アルバム';

  @override
  String get tabDecks => 'デッキ';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'マーケット';

  @override
  String get tabSettings => '設定';

  @override
  String get tabScan => 'スキャン';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsIntro =>
      'ManaForge は無料で、ソースコードも公開されています（PolyForm Noncommercial ライセンス：共有も改変も自由、販売のみ不可）。広告なし、有料版なし、アカウント不要。あなたのカードはあなたのものです。';

  @override
  String get howItWorks => '使い方';

  @override
  String get howScan => 'ウェブカメラにカードをかざすか、写真をドロップするだけ。正確なセット情報付きでコレクションに入ります。';

  @override
  String get howCollection =>
      '所持カードの一覧。検索・絞り込み・フォルダ付き（フォルダはタグです：1枚のカードが複数に入れます）。';

  @override
  String get howAlbum =>
      'セットごとに1ページ、シールアルバムのように。持っているカードはカラー、足りないカードは灰色で、完成にかかる金額も表示します。';

  @override
  String get howForge =>
      '手持ちのカードだけで、完成した合法デッキを組みます。まだ持っていないセットからも組めて、何をいくらで買えばいいか教えます。';

  @override
  String get howDecks => '保存したデッキ。カードを手放すと、持っているふりをせずにその旨を表示します。';

  @override
  String get howMarket =>
      'コレクションの価値と推移グラフ、価格通知付きのほしいものリスト。CSV に購入価格があれば損益も表示します。';

  @override
  String get howPrivacy =>
      '計算はすべて端末内で行います。ネットに出るのはデータベースの取得と、有効にしている場合の新バージョン確認だけです。';

  @override
  String get shortcuts => 'キーボードショートカット';

  @override
  String get shortcutTabs => 'タブを切り替える';

  @override
  String get shortcutScan => 'スキャナーを開く';

  @override
  String get shortcutSearch => '表示中のタブで検索';

  @override
  String get shortcutSettings => '設定';

  @override
  String get shortcutClose => '上に開いているものを閉じる';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システムに合わせる';

  @override
  String get languagePartial =>
      'アプリは段階的に翻訳中です。基本部分はすでにお使いの言語で表示されますが、その他の画面は当面スペイン語のままです。';

  @override
  String get versionTitle => 'ManaForge のバージョン';

  @override
  String versionYouHave(String version) {
    return '現在のバージョンは $version です。';
  }

  @override
  String get versionSeeWhatsNew => '変更点を見る';

  @override
  String get versionNotifyMe => '新しいバージョンを知らせる';

  @override
  String get versionNotifyMeWhy =>
      '1日1回 GitHub に最新バージョンを問い合わせます。ダウンロードもインストールもしません。';

  @override
  String get versionCheckNow => '今すぐ確認';

  @override
  String get versionUpToDate => '最新バージョンです（または GitHub が応答していません）。';

  @override
  String versionThereIs(String version) {
    return 'ManaForge $version が公開されています。';
  }

  @override
  String get versionGoDownload => 'ダウンロードページへ';

  @override
  String versionNotAuto(String version) {
    return '現在は $version です。自動更新はしません。ダウンロードページを開きます。';
  }

  @override
  String get versionNotNow => 'あとで';

  @override
  String get versionSee => '見る';

  @override
  String whatsNewTitle(String version) {
    return '$version の新機能';
  }

  @override
  String get whatsNewClose => 'はじめる';

  @override
  String get downloadCopyLink => 'リンクをコピー';

  @override
  String get downloadClose => '閉じる';

  @override
  String get downloadTitle => 'ManaForge をダウンロード';

  @override
  String get backgroundTitle => '背景画像';

  @override
  String get backgroundWhat =>
      '好きな画像をアプリの背景にできます。Wizards は各セットの公式壁紙を公開しています。好きなものをダウンロードして、ここで選んでください。アプリが勝手に取得することはありません — その絵には権利者がいて、配布はアプリの役目ではありません。';

  @override
  String get backgroundPick => '画像を選ぶ…';

  @override
  String get backgroundChange => '画像を変える…';

  @override
  String get backgroundOfficial => 'Magic 公式壁紙';

  @override
  String get backgroundRemove => '背景を外す';

  @override
  String get backgroundDim => '暗くする度合い（文字が読めるように）';

  @override
  String get backgroundCardColor => 'カードの色';

  @override
  String get backgroundTextColor => '文字の色';

  @override
  String get backgroundCardOpacity => 'カードが壁紙を隠す度合い';

  @override
  String get backgroundColorDefault => '既定の色';

  @override
  String get backgroundPreview => '表示イメージ';

  @override
  String get backgroundNotAnImage => '背景には画像（.jpg、.png、.webp）を選んでください。';

  @override
  String get backgroundTooBig => 'この画像は背景に使うには大きすぎます。';

  @override
  String get welcomeTitle =>
      'forge へようこそ。好きな方法でカードを取り込むか、1枚も入れずに Forge を試してみてください。';

  @override
  String get welcomeScan => 'カードをスキャン';

  @override
  String get welcomeImport => 'CSV を読み込む（ManaBox）';

  @override
  String get welcomeTryForge => 'コレクションなしで Forge を試す';

  @override
  String get decksEmptyGoForge => 'Forge へ';

  @override
  String get yourCollection => 'あなたのコレクション';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies 枚 · $distinct 種類';
  }

  @override
  String get marketArrow => 'マーケット ›';

  @override
  String get certHeadingSetComplete => 'コレクション完成証明書';

  @override
  String get certSubtitleSetComplete => 'セット完成';

  @override
  String get certHeadingWelcome => 'ようこそ証明書';

  @override
  String get certWelcomeTitle => 'Magicの世界へようこそ';

  @override
  String get certSubtitleWelcome => 'はじめの1枚';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count枚',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return '$nameから始めました';
  }

  @override
  String get certCollectorAnon => 'ManaForge コレクター';

  @override
  String certAwardedTo(String name) {
    return '$name に授与';
  }

  @override
  String certOnDate(String date) {
    return '$date';
  }
}
