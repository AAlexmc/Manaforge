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
  String get welcomeImport => 'CSV を読み込む';

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
  String get certHeadingWelcome => '歓迎証明書';

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

  @override
  String get certDataBy => 'データ提供: Scryfall';

  @override
  String get onbCollectionTitle => 'あなたのコレクション';

  @override
  String get onbCollectionBody => 'すべてのカードがここに。フォルダ別・セット別に並びます。';

  @override
  String get onbScanTitle => 'カードをスキャン';

  @override
  String get onbScanBody => 'カメラや写真で新しいカードを追加。';

  @override
  String get onbForgeTitle => 'デッキを組む';

  @override
  String get onbForgeBody => '手持ちのカードだけで完成デッキを生成。';

  @override
  String get onbDecksTitle => 'あなたのデッキ';

  @override
  String get onbDecksBody => 'Forgeで保存したデッキがここに表示されます。';

  @override
  String get onbSkip => 'スキップ';

  @override
  String get onbNext => '次へ';

  @override
  String get onbGotIt => 'OK';

  @override
  String get onbBack => '戻る';

  @override
  String get tourMenuTitle => 'ガイド';

  @override
  String get tourWelcomeName => 'クイックツアー';

  @override
  String get tourHomeName => 'ホーム画面';

  @override
  String get onbEditHomeTitle => 'ホームをカスタマイズ';

  @override
  String get onbEditHomeBody => 'このボタンでホームに表示するセクションと順番を選べます。';

  @override
  String get onbLangTitle => '言語';

  @override
  String get onbLangBody => 'ここでアプリ全体の言語を変えられます。';

  @override
  String get onbLookTitle => '見た目';

  @override
  String get onbLookBody => '壁紙を設定し、カード・文字・タブ・アイコンの色を選べます。';

  @override
  String get tourSettingsName => 'アプリをカスタマイズ';

  @override
  String get tourFullName => 'アプリの全体ツアー';

  @override
  String get tourCollectionName => 'コレクションとフォルダ';

  @override
  String get tourForgeName => 'デッキを鍛える';

  @override
  String get tourMarketName => 'マーケット・ウィッシュリスト・通知';

  @override
  String get onbAllCardsTitle => 'すべてのカード';

  @override
  String get onbAllCardsBody => 'コレクション全体を検索・絞り込み・並べ替えできます。';

  @override
  String get onbFoldersTitle => 'フォルダ';

  @override
  String get onbFoldersBody =>
      'フォルダはタグです。好きなようにまとめられ、1枚のカードが複数に入れます。「新規」で最初の1つを作れます。';

  @override
  String get onbAlbumMineTitle => 'セット別アルバム';

  @override
  String get onbAlbumMineBody => '各セットの枠が並びます。このフィルタで、すでにカードを持っているセットだけを表示します。';

  @override
  String get onbForgeBasicsTitle => '基本土地';

  @override
  String get onbForgeBasicsBody =>
      '手元に基本土地があるならオンのままに。Forge がそれを前提にします。オフならコレクション内のものだけ使います。';

  @override
  String get onbForgeSetsTitle => 'セット';

  @override
  String get onbForgeSetsBody => 'カードの出どころを絞ります。何も選ばなければコレクション全体を使います。';

  @override
  String get onbForgeMissingTitle => '持っていないカード';

  @override
  String get onbForgeMissingBody => 'オンにすると足りないカードも提案し、何枚・いくらかかるかを教えます。';

  @override
  String get onbForgeDeepTitle => 'ディープフォージ';

  @override
  String get onbForgeDeepBody =>
      '候補を見せる前に、実際に対戦させます。最終順位は静的なスコアだけでなく、実際の勝率を重視します。速さを優先するならオフにできます。';

  @override
  String get onbForgeGoTitle => '鍛える';

  @override
  String get onbForgeGoBody => 'このボタンでデッキを作ります。セットが多いと数秒かかります。';

  @override
  String get onbForgeTestTitle => 'テストモード';

  @override
  String get onbForgeTestBody => 'メタデッキと戦わせて、勝つには何が足りないかを見ます。';

  @override
  String get onbMarketPickTitle => 'マーケットを選ぶ';

  @override
  String get onbMarketPickBody => 'Cardmarket か TCGplayer か。各カードの価格とグラフが変わります。';

  @override
  String get onbWishlistTitle => 'ウィッシュリスト';

  @override
  String get onbWishlistBody => '欲しいカードの一覧。目標価格に届くとカウンターが緑になります。';

  @override
  String get onbPriceAlertTitle => '価格アラート';

  @override
  String get onbPriceAlertBody =>
      'カードを検索してしおりアイコンでウィッシュリストに入れ、目標価格を設定すると、下がったときに知らせます。';

  @override
  String get tourProgressName => '実績と証明書';

  @override
  String get onbAchievementsTitle => '実績とレベル';

  @override
  String get onbAchievementsBody => 'あなたのレベルと、これまでに得たもの。スキャン・整理・デッキ作りで上がります。';

  @override
  String get onbCertificatesTitle => '証明書';

  @override
  String get onbCertificatesBody => '大きな節目は賞状になり、PDF で保存したり見せたりできます。実績の中にあります。';

  @override
  String get onbBackupTitle => 'バックアップ';

  @override
  String get onbBackupBody =>
      'コレクション・デッキ・フォルダをファイルに保存し、パソコンを替えても戻せます。さらに毎週、自動でもバックアップされます。';

  @override
  String onbTapHere(String pantalla) {
    return 'ここを押すと$pantallaが開きます。';
  }

  @override
  String get onbAchievementsName => '実績';

  @override
  String get onbDataSectionTitle => 'データ';

  @override
  String get onbDataSectionBody => 'アプリが保存するものはすべてここです。カードのデータベースとバックアップ。';

  @override
  String get onbCardDbTitle => 'カードのデータベース';

  @override
  String get onbCardDbBody =>
      '新しいカード、最新の価格、Forge の年フィルタなど新しいデータが要るものは、ここで再ダウンロードします。';

  @override
  String get onbAboutTitle => 'アプリについて';

  @override
  String get onbAboutBody => '各タブの役割、キーボードショートカット、バージョン、ライセンス。';

  @override
  String get colStartHere => 'あなたのコレクションはここから始まります';

  @override
  String get colNeedDb =>
      'まずはMagicの全カードが入ったデータベースが必要です（一度ダウンロードすれば、あとはインターネットなしで全部動きます）。';

  @override
  String colDownloading(String pct) {
    return 'ダウンロード中… $pct %';
  }

  @override
  String get colDownloadDb => 'カードデータベースをダウンロード';

  @override
  String get colScryfall =>
      'データと画像はScryfall提供 · アカウントも支払いも不要、すべてあなたのデバイスの中だけに残ります。';

  @override
  String get colAlbumTooltip => 'エキスパンション別アルバム';

  @override
  String get colImportTooltip => 'コレクションのCSVをインポート';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies 枚 · $distinct 種類$valor';
  }

  @override
  String get colAllCards => 'すべてのカード';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct 種類 · 検索・絞り込み・並べ替え';
  }

  @override
  String get colFolders => 'フォルダ';

  @override
  String get colNewFolder => '新規';

  @override
  String get colNoFolders =>
      'まだフォルダがありません。好きなようにまとめられます：「Aetherdriftのレア」「売る用」「上の棚の箱」…。1枚のカードを複数のフォルダに入れてもかまいません。';

  @override
  String get colCreateFirstFolder => '最初のフォルダを作る';

  @override
  String get colEmptyTitle => 'ここからコレクションが始まります';

  @override
  String get colEmptyBody =>
      'カメラでカードをスキャンするか、コレクションのCSVをインポートしましょう。こことアルバムに並びます。';

  @override
  String get colImportShort => 'CSVをインポート';

  @override
  String acForgetTitle(String carta) {
    return '$carta はもう持っていませんか？';
  }

  @override
  String get acForgetBody => 'コレクションから外れて、アルバムの枠もまた空になります。';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '入っている $n 個のフォルダからも外れます。',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks => 'デッキからは消えません：リストには残り、足りないことをデッキが教えてくれます。';

  @override
  String get acCancel => 'キャンセル';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => 'もう持っていません';

  @override
  String acAddedOn(String cuando) {
    return '$cuando に追加';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 個のフォルダに',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'カードを検索（スペイン語・英語）…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$total 枚中 $visibles 枚';
  }

  @override
  String get acMissingFilterData =>
      ' · 古いカードには絞り込み用データがないものがあります：「置き換え」をオンにしてCSVを再インポートしてください';

  @override
  String get acNoneMatch => 'この絞り込みに一致するカードはありません。';

  @override
  String get acEmptyHint => '上で最初のカードを検索するか、戻ってコレクションのCSVをインポートしましょう。';

  @override
  String get onbHowItWorksBody => '各タブの役割とキーボードショートカットのまとめです。迷ったら、ここから始めましょう。';

  @override
  String get onbVersionBody =>
      '今のバージョン、その内容、そしてアプリが1日1回新しいバージョンを確認するかどうか。勝手には更新しません。';

  @override
  String get onbSuggestionsTitle => 'ご意見箱';

  @override
  String get onbSuggestionsBody =>
      'アイデアやバグを見つけたら、GitHubで教えてください。テンプレートがあるので1分で書けます。';

  @override
  String get onbSupportTitle => 'プロジェクトを応援する';

  @override
  String get onbSupportBody => 'このアプリは無料で広告もありません。役に立ったなら、コーヒーをおごる方法はこちらです。';

  @override
  String get onbScanSetTitle => 'セット：すべて';

  @override
  String get onbScanSetBody =>
      '1つのエキスパンションのパックを開けているなら、ここで固定しましょう：同じカードの10種類の再録の間でスキャナーが迷わなくなります。';

  @override
  String get onbScanModeTitle => 'スピード優先か、慎重に';

  @override
  String get onbScanModeBody =>
      '「スピード優先」でははっきりしたカードは自動で登録され、あやしいものは確認用にマークされます。「慎重に」では手を止めて、どのカードか尋ねます。';

  @override
  String get onbScanPhotoTitle => '写真をスキャン';

  @override
  String get onbScanPhotoBody =>
      'カメラがない、あるいはもうカードを撮影済み？ここに写真を放り込めば—何枚写っていても—同じように読み取ります。';

  @override
  String get tourScanName => 'スキャナー';

  @override
  String get albNeedDb => 'アルバムにはカードデータベースが必要です（コレクションでダウンロードしてください）。';

  @override
  String get albRetry => 'もう一度';

  @override
  String get albApproxMode =>
      'アルバムはおおまかモードです：各カードのどの版を持っているのかまだ分かりません。「今のコレクションを置き換える」をオンにしてCSVを再インポートすれば、イラストごとにアルバムがくっきりします。';

  @override
  String get albSearchSet => 'エキスパンションを検索…';

  @override
  String get albOnlyMine => '持っているカードあり';

  @override
  String get albSortProgress => '完成度が高い順';

  @override
  String get albSortNewest => '新しい順';

  @override
  String get albSortOldest => '古い順';

  @override
  String get albSortName => '名前順';

  @override
  String get albYearAll => '年：すべて';

  @override
  String get albLetterAll => 'すべて';

  @override
  String get albNoSets => '絞り込みに一致するエキスパンションはありません。';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total 枚';
  }

  @override
  String get albComplete => ' · ✓ コンプリート！';

  @override
  String albLoadError(String error) {
    return 'セットを読み込めませんでした：$error';
  }

  @override
  String albSearchIn(String set) {
    return '$set 内を検索…';
  }

  @override
  String get albOnlyMissing => '足りないものだけ';

  @override
  String get albWithVariants => 'バリエーションを含む';

  @override
  String get albYouHaveItAll => '✓ すべて揃っています';

  @override
  String albMissingCount(int n) {
    return 'あと $n 枚 · ';
  }

  @override
  String albWithoutPrice(int n) {
    return '（$n 枚は価格なし）';
  }

  @override
  String albNoPerPrinting(String market) {
    return '$market no publica precios por edición — elige otro en la pestaña Mercado';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$total 中 $visibles';
  }

  @override
  String get albNoCardsNamed => 'その名前のカードはここにはありません。';

  @override
  String get fdNewFolder => '新しいフォルダ';

  @override
  String get fdEditFolder => 'フォルダを編集';

  @override
  String get fdName => '名前';

  @override
  String get fdNameHint => 'Aetherdriftのレア、売る用…';

  @override
  String get fdColor => '色';

  @override
  String get fdIcon => 'アイコン';

  @override
  String get fdCreate => '作成';

  @override
  String get fdSave => '保存';

  @override
  String get fdDefaultName => 'フォルダ';

  @override
  String fdDeleteTitle(String nombre) {
    return '「$nombre」を削除しますか？';
  }

  @override
  String get fdDeleteBody => '削除されるのはフォルダだけです：カードはコレクションに残ります。';

  @override
  String get fdDelete => '削除';

  @override
  String get fdGone => 'このフォルダはもうありません。';

  @override
  String get fdEditTooltip => '名前・色・アイコンを編集';

  @override
  String get fdDeleteTooltip => 'フォルダを削除';

  @override
  String get fdAddRemove => '追加・削除';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas 種類 · $copias 枚';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n 枚が絞り込みに一致';
  }

  @override
  String get fdRoughValue => ' · おおよその価値';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 枚がもうコレクションにありません（戻ってきたときのためにリストには残しています）。',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => '取り除く';

  @override
  String get fdNoneMatch => 'このフォルダには絞り込みに一致するカードがありません。';

  @override
  String get fdEmpty => '空のフォルダです。「追加・削除」を押して、入れたいカードにチェックを入れましょう。';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n 枚');
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'フォルダから外す';

  @override
  String get fpPickCards => 'カードを選ぶ';

  @override
  String fpSaveCount(int n) {
    return '保存（$n）';
  }

  @override
  String get fpFilterByName => '名前で絞り込み…';

  @override
  String fpVisibleCards(int n) {
    return '$n 枚を表示中';
  }

  @override
  String get fpSelectAll => 'すべて選択';

  @override
  String get fpNoneMatch => 'この絞り込みに一致するカードはありません。';

  @override
  String get fgMsgReading => 'コレクションを読み込み中…';

  @override
  String get fgMsgCurve => 'マナカーブを計算中…';

  @override
  String get fgMsgLands => '土地を配分中…';

  @override
  String get fgMsgSynergy => 'シナジーを探し中…';

  @override
  String get fgMsgPlan => 'ゲームプランを作成中…';

  @override
  String get fgNeedDbForSets =>
      'エキスパンションを一覧するにはカードデータベースが必要です：設定 → データベースをダウンロード。';

  @override
  String fgDbError(String error) {
    return 'カードデータベースを読み込めませんでした：$error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' $n 個のエキスパンション内',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'リーガルなCommanderデッキが組めません$donde：伝説の統率者と、そのカラーアイデンティティ内の約62種類の異なるカード（シングルトンです）、それに十分な基本土地が必要です。別のフォーマットや別のエキスパンションを試すか、コレクションを増やしてみてください。';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'このプールのカードでは、私のルール（十分な土地と健全なカーブ）を満たす完成した $formato デッキが組めません$donde。$consejo 欠陥のあるデッキを渡すくらいなら、お知らせするほうを選びます。';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return 'このスタイル（$estilo）ではデッキが作れません。「スタイル：自動」か別の種族を試してください。';
  }

  @override
  String get fgOf60 => '60枚';

  @override
  String fgLegalIn(String formato) {
    return '$formato でリーガル';
  }

  @override
  String get fgTipMoreSets => 'もっとエキスパンションを試すか、絞り込みを外してみましょう。';

  @override
  String get fgTipMoreCards =>
      'カードをもっと追加するか—特にメインカラーのものを—「持っていないカードも含める」にチェックを入れましょう。';

  @override
  String get fgPitch => '今持っているカードだけで、完成した実戦向けのデッキを。何も買わずに。';

  @override
  String get fgTeaserCount => '最初のデッキ用のカード';

  @override
  String get fgTeaserMissing => '持っていないカードでデッキを組む';

  @override
  String get fgBasics => '手持ちの基本土地があるものとして扱う';

  @override
  String get fgBasicsSub =>
      'ほとんどの人はスターターデッキの基本土地を持っています。コレクションにある基本土地だけを使うにはオフにしてください。';

  @override
  String get fgFormat => 'ゲームフォーマット';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100枚 · シングルトン · コレクション内の伝説の統率者 · カラーアイデンティティを遵守。';

  @override
  String get fgCasualNote => '60枚、リーガリティ制限なし：何でもありです。';

  @override
  String fgFormatNote(String formato) {
    return '$formato でリーガルなあなたのカードだけを使った60枚。';
  }

  @override
  String get fgWhereFrom => 'カードはどこから？';

  @override
  String get fgPickSets => 'エキスパンションを選ぶ';

  @override
  String get fgChangeSets => 'エキスパンションを変更';

  @override
  String get fgNeedOneSet =>
      'エキスパンションを少なくとも1つ選んでください：絞り込まないとMagicの全カード約30,000枚が対象になります。';

  @override
  String get fgNoSetsNote => 'エキスパンションを選ばなければ、Forgeはコレクション全体を使います。';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 個のエキスパンションのカード、持っているかどうかは問わず。',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 個のエキスパンションのあなたのカードだけ—コレクション全体ではありません。',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'コレクションには各カードの版が記録されていないため、エキスパンションで絞り込むとほとんどが外れてしまいます。「置き換え」でCSVを再インポートしてから戻ってきてください。';

  @override
  String get fgIncludeMissing => '持っていないカードも含める';

  @override
  String get fgIncludeMissingSub =>
      'Forgeはコレクションだけに縛られず、それらのエキスパンションで印刷されたすべてを使います。そのあと、何枚足りないか、いくらかかるかを教えてくれます。';

  @override
  String get fgYourTaste => 'お好みで（任意）';

  @override
  String get fgArchetypeAuto => 'アーキタイプ：自動';

  @override
  String get fgStyle => 'スタイル';

  @override
  String get fgStyleAuto => 'スタイル：自動';

  @override
  String get fgTribeElf => 'エルフ';

  @override
  String get fgTribeGoblin => 'ゴブリン';

  @override
  String get fgTribeZombie => 'ゾンビ';

  @override
  String get fgTribeVampire => '吸血鬼';

  @override
  String get fgTribeDragon => 'ドラゴン';

  @override
  String get fgTribeAngel => '天使';

  @override
  String get fgTribeDemon => '悪魔';

  @override
  String get fgTribeDinosaur => '恐竜';

  @override
  String get fgTribeFaerie => '妖精';

  @override
  String get fgTribeMerfolk => 'マーフォーク';

  @override
  String get fgTribeHuman => '人間';

  @override
  String get fgTribeSpirit => 'スピリット';

  @override
  String get fgTribeSliver => 'スリヴァー';

  @override
  String get fgTribeWizard => 'ウィザード';

  @override
  String get fgTribeKnight => '騎士';

  @override
  String get fgTribeWarrior => '戦士';

  @override
  String get fgTribeSoldier => '兵士';

  @override
  String get fgTribeCat => '猫';

  @override
  String get fgTribeDog => '犬';

  @override
  String get fgTribeRat => 'ネズミ';

  @override
  String get fgTribePirate => '海賊';

  @override
  String get fgTribeElemental => 'エレメンタル';

  @override
  String get fgTribeGiant => '巨人';

  @override
  String get fgTribeRogue => 'ならず者';

  @override
  String get fgDeepForge => 'ディープフォージ';

  @override
  String get fgDeepForgeHint => '提案を見せる前に、実際に対戦させて比べます（少し待ち時間が増えます）。';

  @override
  String get fgPricePerCard => '1枚あたりの価格：';

  @override
  String get fgMin => '最小 €';

  @override
  String get fgMax => '最大 €';

  @override
  String get fgCardYear => 'カードの年：';

  @override
  String get fgFrom => 'から';

  @override
  String get fgTo => 'まで';

  @override
  String get fgYearNeedsDb => '年での絞り込みには最新のデータベースが必要です：設定 → データベースを再ダウンロード。';

  @override
  String get fgNoColorsNote => '色を選ばなければ、Forgeはすべての組み合わせを試します。';

  @override
  String fgColorsNote(String colores) {
    return '$colores のデッキ（とその組み合わせ）だけ。';
  }

  @override
  String get fgMissingNote =>
      'このデッキには持っていないカードが入ることがあります：各提案に、何枚足りないか、いくらかかるか（Cardmarketの価格）が表示されます。';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forgeはあなたの $n 枚だけを使います。持っていない分を勝手に作り出すことはありません。';
  }

  @override
  String get fgForgeMissing => 'デッキを鍛造（足りない分も込みで）';

  @override
  String get fgForgeMine => '自分のデッキを鍛造';

  @override
  String get fgTestMode => 'テストモード：メタデッキを倒せ';

  @override
  String get fgOffline => 'すべてあなたのデバイス上で計算、インターネット不要';

  @override
  String fgForgingWith(int n) {
    return '$n 枚で鍛造中です：数秒かかります。ウィンドウは固まっていません。';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 個のデッキがプレイ可能です',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing => 'まだ持っていないカード込み · スワイプで比較';

  @override
  String get fgSwipeMine => 'あなたのカードだけで作成 · スワイプで比較';

  @override
  String get fgHaveAll => '✓ すべてのカードが揃っています';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 枚足りません',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'デッキ全体を見る';

  @override
  String get fgReforge => '鍛え直す';

  @override
  String get fgBackToOptions => 'Volver a elegir cómo forjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta が $precio になりました（目標：$objetivo）！';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 ウィッシュリストの $n 枚が目標価格まで下がりました！';
  }

  @override
  String get mkTellMeWhenDrops => '下がったら知らせて';

  @override
  String get mkTargetPrice => '目標価格';

  @override
  String mkNow(String precio) {
    return '現在：$precio';
  }

  @override
  String get mkUpdated => '✓ 価格とカードを更新しました';

  @override
  String mkUpdateFailed(String error) {
    return '更新できませんでした：$error';
  }

  @override
  String get mkHistoryReady => '✓ 価格履歴の準備ができました：グラフに直近数か月が表示されます';

  @override
  String mkHistoryFailed(String error) {
    return '履歴を取得できませんでした（今までのものはそのまま残っています）：$error';
  }

  @override
  String get mkHistoryLocal =>
      '価格履歴：ManaForgeがこの端末で毎日記録しているものだけです。Cardmarketの実際の直近約90日分（約4 MB）を取り込みましょう。';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return '$desde から $hasta までのCardmarketの実際の履歴、そしてそれ以降はManaForgeが記録した分。';
  }

  @override
  String get mkFetchHistory => '履歴を取り込む';

  @override
  String get mkCollectionValue => 'コレクションの価値 · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n 枚';
  }

  @override
  String get mkApproxSuffix => ' · おおよその価値';

  @override
  String mkBulkPrices(String fecha) {
    return '$fecha 時点のCardmarket価格（Scryfall）';
  }

  @override
  String mkNoData(String error) {
    return 'マーケットにデータがありません：コレクションでデータベースをダウンロードしてください。（$error）';
  }

  @override
  String mkSetsHeader(int n) {
    return 'エキスパンション（$n）';
  }

  @override
  String get mkPrevious => '前へ';

  @override
  String get mkNext => '次へ';

  @override
  String get mkSearchHint => 'どのカードの価格でも検索…';

  @override
  String get mkRemoveFromWishlist => 'ウィッシュリストから外す';

  @override
  String get mkAddToWishlist => 'ウィッシュリストへ：下がったら知らせて';

  @override
  String get mkYourWishlist => 'あなたのウィッシュリスト';

  @override
  String mkTargetAtMost(String precio) {
    return '目標 ≤ $precio';
  }

  @override
  String get mkAtPrice => '目標価格に到達！';

  @override
  String get mkChangeTarget => '目標価格を変更';

  @override
  String mkNoPriceIn(String market) {
    return '$market に価格なし';
  }

  @override
  String get mkPerUnit => '/枚';

  @override
  String get mkTopCards => 'あなたの最も価値のあるカード';

  @override
  String get mkImportToSeeValue => 'コレクションをインポートすると価値が表示されます。';

  @override
  String mkSetCards(int n) {
    return ' · $n 枚';
  }

  @override
  String get wlEmpty => 'マーケットで探して、しおりをタップすれば、目標価格まで下がったときに知らせます。';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '🔔 ウィッシュリストの $n 枚が目標価格以下になっています。',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'MTGOの価格をtixで表示（デジタルカード）';

  @override
  String get mpNoDataYet => 'まだデータがありません：マーケットで価格履歴を更新してください';

  @override
  String get mpMtgoNote =>
      'MTGOの価格はtixです：これはデジタルカードなので、紙のコレクションの評価には使えません。ホーム・フォルダ・実績はCardmarket（€）のままです。';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return '$mercado の価格を $moneda で表示。ホーム・フォルダ・実績は引き続きCardmarket（€）で評価します：通貨は換算しません。';
  }

  @override
  String get mkUpdate => '更新';

  @override
  String get mkApproxValue => ' · おおよその価値（版ごとの価格には「置き換え」で再インポート）';

  @override
  String get mkExactPrintings => ' · あなたの正確な版に基づく';

  @override
  String mkNowSuffix(String precio) {
    return ' · 現在 $precio';
  }

  @override
  String get wlNothingYet => 'まだウィッシュリストにカードがありません。';

  @override
  String get stDbUpdated => '✓ データベースを更新しました';

  @override
  String stUpdateFailed(String error) {
    return '更新できませんでした：$error';
  }

  @override
  String get stCardDb => 'カードデータベース';

  @override
  String get stCardDbWhy =>
      '新しいカード、最新の価格、そして最近のデータを必要とする機能（Forgeの年での絞り込みなど）のために、もう一度ダウンロードしましょう。';

  @override
  String get stDownloadDbAgain => 'データベースを再ダウンロード';

  @override
  String get stAppearance => '外観';

  @override
  String get stData => 'データ';

  @override
  String get stTheApp => 'アプリ';

  @override
  String get stCredits =>
      'カードのデータと画像はScryfall提供。Magic: The GatheringはWizards of the Coastの所有物です。これはそのFan Content Policyに基づくファンプロジェクトです。';

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
  String get stEditHome => 'ホームを編集';

  @override
  String get stEditHomeSub => '表示するセクションとその順番を選べます';

  @override
  String get ehLevel => 'あなたのレベル';

  @override
  String get ehShortcuts => 'クイックアクション';

  @override
  String get ehSummary => 'コレクションの概要';

  @override
  String get ehRecent => '最近見たカード';

  @override
  String get ehDecks => 'あなたのデッキ';

  @override
  String get ehMeta => '今のメタ';

  @override
  String get ehNewSets => '新しいエキスパンション';

  @override
  String get ehGems => 'あなたの逸品';

  @override
  String get ehStatCards => '枚';

  @override
  String get ehStatDistinct => '種類';

  @override
  String get ehStatValue => '価値';

  @override
  String get ehStatDecks => 'デッキ';

  @override
  String get ehStatAchievements => '実績';

  @override
  String get ehHelp =>
      'ドラッグして並べ替え、スイッチでホームに表示するものを選べます。オンにしたセクションは、見せるものがあるときだけ表示されます。';

  @override
  String get ehSection => 'セクション';

  @override
  String get bkNoData => 'データが見つかりません。';

  @override
  String bkSaved(String resumen) {
    return '✓ バックアップを保存しました · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return '保存できませんでした：$error';
  }

  @override
  String get bkFileName => 'ManaForgeのバックアップ';

  @override
  String bkRestoreFailed(String error) {
    return '復元できませんでした：$error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ 復元しました · $resumen。注意：以前のデータを保存できませんでした（$error）。';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ 復元しました · $resumen。以前のデータはbackupsフォルダに保存されています。';
  }

  @override
  String get bkRestoring => 'バックアップを復元中…';

  @override
  String get bkTitle => 'バックアップ';

  @override
  String get bkWhy =>
      'あなたのカード・デッキ・フォルダ・実績は、このコンピュータの中だけにあります。ときどきコピーを保存して、別の場所に置いておきましょう：ドライブでもクラウドでも、お好きなところに。';

  @override
  String get bkSave => 'バックアップを保存';

  @override
  String get bkRestoreTitle => 'バックアップを復元';

  @override
  String bkRestoreWarning(String palabra) {
    return '復元は、今のカード・デッキ・フォルダ・実績をバックアップの内容で置き換えます。どれを使うか選び、ボタンを押して $palabra と入力してください：こうすれば、うっかり復元してしまうことがありません。';
  }

  @override
  String get bkNoBackups => 'このコンピュータにはまだ保存されたバックアップがありません。';

  @override
  String get bkWhich => '復元するバックアップ';

  @override
  String get bkPickOne => 'バックアップを選ぶ';

  @override
  String get bkRestorePicked => '選んだバックアップを復元';

  @override
  String get bkAutoNote => '毎週自動バックアップを保存し（直近5つ）、復元の直前にもう1つ保存します。';

  @override
  String get bkFromFile => 'ファイルから復元';

  @override
  String get bkConfirmTitle => 'このバックアップを復元しますか？';

  @override
  String get bkConfirmBody =>
      'これは、今のコレクション・デッキ・フォルダ・実績をそのバックアップの内容で置き換えます。実行前に、今のデータをbackupsフォルダに保存するので、元に戻したくなっても大丈夫です。';

  @override
  String bkWillDelete(String cosas) {
    return 'そのバックアップには $cosas が含まれていません：復元すると、それは消えます。';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return '続けるには $palabra と入力してください：';
  }

  @override
  String get bkAnd => 'と';

  @override
  String get ehReset => 'リセット';

  @override
  String bkOfDate(String cuando, String resumen) {
    return '$cuando のバックアップ · $resumen。';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'カメラが見つかりません。';

  @override
  String get lsCameraGone => 'セッションの途中でカメラが切断されました。ケーブルを確認して「もう一度」を押してください。';

  @override
  String get lsFrameCard => 'カードを枠の中に収めてください';

  @override
  String get lsNoCardThere => 'そこにはカードが見えません';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n 枚をコレクションに追加',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return '、そして「$carpeta」にも';
  }

  @override
  String get lsTitle => 'ライブスキャン';

  @override
  String get lsQuickTip => 'スピード優先：はっきりしたカードは自動で登録され、あやしいものは確認用にマークされます。';

  @override
  String get lsCarefulTip => '慎重に：あやしいものは手を止めて、どのカードか尋ねます。';

  @override
  String get lsQuick => 'スピード優先';

  @override
  String get lsCareful => '慎重に';

  @override
  String lsThisSession(int n) {
    return '今回のセッション $n 枚';
  }

  @override
  String get lsScanPhotoTooltip => '1枚の写真をスキャン';

  @override
  String get lsStartingCamera => 'カメラを起動中…';

  @override
  String get lsCantUseCamera => 'カメラを使えません';

  @override
  String get lsCameraUnavailable => 'カメラが利用できません。';

  @override
  String get lsScanPhoto => '写真をスキャン';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 同じもの · $carta（×$n）';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'すでにテーブルにあります：$carta · いったんどけて置き直すか、「+1 同じもの」をタップしてください';
  }

  @override
  String lsSeeing(String carta) {
    return '認識中：$carta';
  }

  @override
  String get lsPassACard => 'カメラの前にカードをかざしてください…';

  @override
  String lsIsThis(String carta) {
    return '$carta ですか？確信がありません—タップして選んでください。';
  }

  @override
  String get lsNotThisOne => 'これではない—版を変更';

  @override
  String get lsRetry => 'もう一度';

  @override
  String get scBadImage => 'その画像を読み取れませんでした（有効な写真ですか？）';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta（$set #$numero）';
  }

  @override
  String get scNoFolder => 'フォルダなし';

  @override
  String scAlsoTo(String carpeta) {
    return 'さらに：$carpeta にも';
  }

  @override
  String get scLookingForCard => '写真の中のカードを探し中…';

  @override
  String scRecognising(int hechas, int total) {
    return '認識中… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n 枚');
    return '$_temp0 · 合計 $copias 枚';
  }

  @override
  String scToReview(int n) {
    return '$n 枚は要確認（タップしてください）';
  }

  @override
  String scUnknown(int n) {
    return '$n 枚は認識できず（タップして手動で選んでください）';
  }

  @override
  String scSkipped(int n) {
    return '$n 枚の写真をスキップしました（大きすぎるか読み取れません）';
  }

  @override
  String get scNothingRecognised =>
      'それらの写真ではカードを1枚も認識できませんでした。もっと明るく、反射を減らして試してください。';

  @override
  String scAddN(int n) {
    return '$n 枚をコレクションに追加';
  }

  @override
  String get scDropPhotos => 'ここにカードの写真を放り込んでください';

  @override
  String get scDropExplain =>
      '一度に1枚でも複数でも構いません—1枚の写真に複数のカードが写っていても（アルバムの1ページ、テーブルいっぱいなど）、すべて取り出して1つのリストにまとめるので、確認して好きなものを追加できます。スマホの写真でもスキャンでもOKです。';

  @override
  String get scPickPhotos => '写真を選ぶ';

  @override
  String get scMatchHigh => '一致度：高';

  @override
  String get scMatchMedium => '一致度：中';

  @override
  String get scMatchLow => '一致度：低';

  @override
  String get scAddToCollection => 'コレクションに追加';

  @override
  String get scSeeOptions => 'これではない—候補を見る';

  @override
  String get scScanAnother => '別のをスキャン';

  @override
  String get scNotSure => '確信がありません';

  @override
  String get scWhichIsIt => 'どれですか？';

  @override
  String get scNoneQuiteFits =>
      'どれもぴったりとは合いません。この中にありますか？なければ、もっと明るい写真で試してください。';

  @override
  String get scNoEdges => 'カードの縁が見えなかったので、画像全体を使いました。似ているのはこちらです：';

  @override
  String get scCropped => 'これが切り抜いた部分です。候補を似ている順に：';

  @override
  String get scDiscard => '破棄して別のをスキャン';

  @override
  String get suCardsName => 'カードと価格';

  @override
  String get suCardsWhat => 'Scryfallの全カタログ';

  @override
  String get suHistoryName => '価格履歴';

  @override
  String get suHistoryWhat => 'Cardmarketの約90日分';

  @override
  String get suHashesName => 'スキャナーの指紋データ';

  @override
  String get suHashesWhat => '写真での認識用';

  @override
  String suUpToDate(String fecha) {
    return '最新（$fecha）';
  }

  @override
  String get suUpdated => '更新済み';

  @override
  String suUpdatedWithDate(String fecha) {
    return '更新済み（$fecha）';
  }

  @override
  String get suFailedOffline => '取得できませんでした（オフライン）';

  @override
  String get suKeepingOld => '今までのものを使い続けます';

  @override
  String get suNeedMissing => '不足、取得します';

  @override
  String get suNeedStale => '新しいものがあります';

  @override
  String get suNeedFresh => '最新';

  @override
  String get suAllUpToDate => 'すべて最新です。起動中…';

  @override
  String get suUpdatingCards => 'カードと価格を最新にしています…';

  @override
  String get suChecking => '新着がないか確認中…';

  @override
  String get suNoDownloadNote => 'すでに最新のものはダウンロードしません。アプリ内ならどの更新でも手動で実行できます。';

  @override
  String get suEnter => '入る';

  @override
  String get suEnterNow => '今すぐ入る';

  @override
  String icBadFile(String error) {
    return 'ファイルを読み取れませんでした：$error';
  }

  @override
  String get icNotCsv => 'それはCSVではないようです—.csvか.txtのファイルを放り込んでください。';

  @override
  String get icTitle => 'コレクションをインポート';

  @override
  String get icExplain =>
      'コレクションのCSVをここにドラッグ（Moxfield、Archidekt、あるいはNameとQuantityの列があるCSVならなんでもOK）するか、ボタンで選ぶか、中身を手で貼り付けてください：';

  @override
  String get icPickFile => 'ファイルを選ぶ…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas 種類（$copias 枚）をコレクションに追加しました。';
  }

  @override
  String get icReplaceMine => '今のコレクションを置き換える';

  @override
  String get icReplaceWhy =>
      '完全なCSVを再インポートするときはオンに：数量の二重計上を防ぎ、版ごとにアルバムをくっきりさせます。';

  @override
  String icImporting(int hechas, int total) {
    return '$total 枚中 $hechas 枚をインポート中…';
  }

  @override
  String get icDropHere => 'ここにCSVを放り込んでください';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n 枚のトークン／エンブレムを無視しました（デッキには入りません、問題なし）。';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ 認識できず：$lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• CSVに購入価格がありません：損益（P&L）は表示されません（「Purchase price」列付きで書き出してください）。';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n 枚に購入価格あり：マーケットで損益（P&L）を確認できます。';
  }

  @override
  String get icImporting2 => 'インポート中…';

  @override
  String get icImport => 'インポート';

  @override
  String dkDeleted(String nombre) {
    return 'デッキ「$nombre」を削除しました';
  }

  @override
  String get dkUndo => '元に戻す';

  @override
  String dkOpenFailed(String error) {
    return 'デッキを開けませんでした（データベースはダウンロード済みですか？）：$error';
  }

  @override
  String get dkMyDecks => 'マイデッキ';

  @override
  String get dkEmpty => 'Forgeから保存したデッキがここに並びます（デッキ詳細の保存ボタン）。';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 個保存済み',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · 呪文 $hechizos + 土地 $tierras · $fecha に保存';
  }

  @override
  String get dkDeleteTooltip => 'デッキを削除';

  @override
  String get ddSaved => '✓ デッキを保存しました—「デッキ」タブにあります';

  @override
  String get ddReforged => '✓ あなたのカーブに合わせてデッキを鍛え直しました—リストを更新しました';

  @override
  String get ddSaveToMyDecks => 'マイデッキに保存';

  @override
  String get ddCopyList => 'リストをコピー（Moxfield／Arena）';

  @override
  String get ddListCopied => '✓ リストをコピーしました—Moxfield、Arena、Discordに貼り付けられます';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · 呪文 $hechizos + 土地 $tierras';
  }

  @override
  String get ddHaveAll => '✓ すべてのカードが揃っています';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠ このデッキのカードが $n 枚足りません—リストには残っていて、削除されていません',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'あなたのゲームプラン';

  @override
  String get ddManaCurve => 'マナカーブ';

  @override
  String get ddEditCurve => 'カーブを編集';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'バーを↑↓にドラッグ · 呪文 $hechizos → 土地 $tierras';
  }

  @override
  String get ddReforgeCurve => 'このカーブで鍛え直す';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ 土地 $tierras · ✦ 呪文 $hechizos · Ø コスト $coste';
  }

  @override
  String get ddWhyWorks => 'このデッキが機能する理由は？';

  @override
  String ddLands(int n) {
    return '土地（$n）';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'デッキ合計：約 $precio €';
  }

  @override
  String get ddCheapestPrice => '最も安い版の価格（Cardmarket）';

  @override
  String ddSomeNoPrice(int n) {
    return '$n 枚は価格不明 · 最も安い版（Cardmarket）';
  }

  @override
  String get ddInstants => 'インスタント';

  @override
  String get ddTypeCreatures => 'クリーチャー';

  @override
  String get ddTypeSorceries => 'ソーサリー';

  @override
  String get ddTypeEnchantments => 'エンチャント';

  @override
  String get ddTypeArtifacts => 'アーティファクト';

  @override
  String get ddTypeOther => 'その他';

  @override
  String get ddOutOfRange => '  （健全な範囲20〜27の外）';

  @override
  String get acRecalcTitle => '実績を再計算しますか？';

  @override
  String get acRecalcBody =>
      'カードをもう一度チェックして、今は達成していない実績を取り消します。誤って付与された実績を直すのに便利です。カードを売った場合は、それらの実績も失います。';

  @override
  String get acRecalc => '再計算';

  @override
  String get acAllFine => 'すべて問題ありませんでした：取り消された実績はありません。';

  @override
  String acRemovedN(int n) {
    return '達成しなくなった実績を $n 個取り消しました。';
  }

  @override
  String get acTitle => '実績';

  @override
  String get acRecalcTooltip => '今のカードで再計算';

  @override
  String get acCertsTooltip => '証明書';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '実績 $total 個中 $hechos 個 · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'レベル $nivel · 次のレベル $siguiente まであと $xp XP';
  }

  @override
  String get acIMissing => '未達成';

  @override
  String get acSecret => 'シークレット実績';

  @override
  String get acSecretDesc => '達成して初めて明らかになります。';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ 達成$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return '（$fecha）';
  }

  @override
  String acLevelUp(int nivel) {
    return 'レベル $nivel！';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'あなたはもう $titulo です。実績 $total 個中 $hechos 個を達成。';
  }

  @override
  String get acOk => 'OK';

  @override
  String get acSeeAchievements => '実績を見る';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 実績達成！$titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return '（ほか $n 個）';
  }

  @override
  String ceNeedDb(String error) {
    return 'エキスパンションの証明書にはカードデータベースが必要です（$error）';
  }

  @override
  String get ceWhoseName => '誰の名前で？';

  @override
  String get ceCollectorName => 'あなたのコレクター名';

  @override
  String get ceInNameOf => '名義：…';

  @override
  String get ceEmptyWithData =>
      'まだ1つもエキスパンションをコンプリートしていません。アルバムで丸ごと1つ完成させると、ダウンロードできる証明書がここに出ます。';

  @override
  String get ceEmptyNoData =>
      'エキスパンションを証明するには、あなたのカードの正確な版を知る必要があります：Scryfall ID付きのCSVを再インポートしてください。';

  @override
  String get ceNothingSaved => '何も保存されませんでした。';

  @override
  String ceSavedTo(String ruta) {
    return '✓ 証明書を $ruta に保存しました';
  }

  @override
  String ceSaveFailed(String error) {
    return '保存できませんでした：$error';
  }

  @override
  String get cePickFirstCard => '始めたときのカードを選ぶ';

  @override
  String get ceChangeFirstCard => '始めたときのカードを変更';

  @override
  String get ceDownloadPng => 'PNGをダウンロード';

  @override
  String get cdNotFound => 'このカードがデータベースに見つかりません。';

  @override
  String cdLoadFailed(String error) {
    return 'カード情報を読み込めませんでした：$error';
  }

  @override
  String get cdPrev => '前へ（←）';

  @override
  String get cdNext => '次へ（→）';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'カードが見つかりません';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return '$qty $copias に $total$divisa 支払いました（1枚あたり $unidad）';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '枚');
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ コレクションに $n 枚あります',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'このカードはまだ持っていません。';

  @override
  String cdNoPrice(String mercado) {
    return '$mercado にこのカードの価格がありません。';
  }

  @override
  String cdVersions(int n) {
    return 'バージョン（$n）';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return '$mercado に版ごとの価格がありません';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return '$mercado 価格（$moneda） · 通常 / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return '所持 x$n';
  }

  @override
  String get smMythic => '神話レア';

  @override
  String get smRare => 'レア';

  @override
  String get smUncommon => 'アンコモン';

  @override
  String get smCommon => 'コモン';

  @override
  String smLoadFailed(String error) {
    return 'セットを読み込めませんでした：$error';
  }

  @override
  String get smSearchInSet => 'エキスパンション内を検索…';

  @override
  String get smRarityAll => 'レアリティ：すべて';

  @override
  String get smPriceDown => '価格 ↓';

  @override
  String get smPriceUp => '価格 ↑';

  @override
  String get smNumber => '番号';

  @override
  String get smOnlyMine => '持っているものだけ';

  @override
  String smCardsCount(int n) {
    return '$n 枚';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado：版ごとの価格なし';
  }

  @override
  String smListedValue(String mercado) {
    return '掲載価値（$mercado）：';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return '支払い $pagado · 現在の価値 $hoy';
  }

  @override
  String get pnNoPnl =>
      '購入価格がないと損益（P&L）は出せません。「Purchase price」列付きのCSVをインポートすると、ここに表示されます。';

  @override
  String pnOverAll(int n) {
    return 'コレクションの $n 枚が対象';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return '$total 枚中 $conprecio 枚が対象（残りは購入価格が記録されていません）';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '購入した $n 枚はデータベースに今日の価格がありません：集計対象外';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'さらに $importe $moneda 支払っていますが、これは換算されません';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return 'CSVに通貨がない $n 枚：$moneda と仮定します';
  }

  @override
  String get pcTitle => '価格の推移';

  @override
  String get pcNoHistory => 'このカードの価格履歴はまだありません。';

  @override
  String pcTodayPrice(String precio) {
    return '今日の価格：$precio €。数日分たまると、グラフが表示されます。';
  }

  @override
  String get pcExplain =>
      'ManaForgeは、あなたが見たり持っていたりする各カードの価格を、日ごとに記録します。Cardmarketの実際の直近数か月分から始めるには、マーケットで履歴を取り込んでください。';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n 日');
    return '最小 $min € · 最大 $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'どのエキスパンションから？';

  @override
  String get spSearchHint => '名前かコードで検索（BLB、MH3…）';

  @override
  String get spOnlyMine => '持っているものだけ';

  @override
  String spClearN(int n) {
    return '$n 個を解除';
  }

  @override
  String get spNoneNamed => 'その名前のエキスパンションはありません。「持っているものだけ」をオフにすると、すべて表示されます。';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n 枚';
  }

  @override
  String get spNoFilter => 'エキスパンションの絞り込みなし';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 個のエキスパンションを使う',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return '$set セットのカードだけを探します。タップすると変更またはロック解除できます。';
  }

  @override
  String get slLockHint => '箱やプレコンをスキャンするならセットをロック：スキャナーはその中だけを探し、版をぴたりと当てます。';

  @override
  String slSetIs(String set) {
    return 'セット：$set';
  }

  @override
  String get slSetAll => 'セット：すべて';

  @override
  String get slLockTitle => '版をロック';

  @override
  String get slLockBody =>
      '箱を丸ごとスキャンするには、セットコード（例：AER、MH3、LCI）を入力してください：そのセットのカードだけを探します。';

  @override
  String get slSetCode => 'セットコード';

  @override
  String get slClearLock => 'ロックを解除';

  @override
  String get stHintQuick =>
      'カードをかざしてください：はっきりしたものはここに自動で記録されます（同じカードは×Nでまとまります）。あやしいものは確認用にマークされます。終わったら、まとめて確定します。';

  @override
  String get stHintCareful =>
      'カードをかざしてください：はっきりしたものは自動で記録され、あやしいものはどのカードか尋ねます。終わったら、まとめて確定します。';

  @override
  String stAddN(int n) {
    return '$n 枚をコレクションに追加';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return '$n 枚をコレクションと $carpeta に追加';
  }

  @override
  String get stOneLess => '1枚減らす';

  @override
  String get stAnotherSame => '同じものをもう1枚';

  @override
  String get stOnTable => 'テーブル上';

  @override
  String cdLastData(String fecha) {
    return '（最新データ：$fecha）';
  }

  @override
  String get cdLegalities => 'リーガル';

  @override
  String get slLockButton => 'ロック';

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
  String get wn030Headline => 'エキスパンション別のForge、購入価格、バージョン通知';

  @override
  String get wn030Forge =>
      'Forge：カードをどのエキスパンションから出すか選べます。さらに「持っていないカードも含める」をオンにすると、選んだコレクション全体からデッキを組み、何枚足りないか、いくらかかるかを教えてくれます。';

  @override
  String get wn030Pnl =>
      '購入価格と損益（P&L）：CSVに「Purchase price」があれば、マーケットが支払額・現在の価値・その差を表示します。通貨は混ざりません。';

  @override
  String get wn030PhotoFolder => '写真からのスキャンでも、ライブスキャンと同じようにフォルダを選べます。';

  @override
  String get wn030Album => 'アルバム：各エキスパンションで足りないものと、その費用。';

  @override
  String get wn030Background =>
      '壁紙：好きな画像を背景に置けます。調整できるベール付きで、カードと文字の色を選べるので、上に重ねても読みやすいままです。';

  @override
  String get wn030Window => 'ウィンドウは、閉じたときの位置とサイズで開きます。';

  @override
  String get wn030Achievements =>
      '実績の名前は、条件ではなくその瞬間にちなむようになりました：「有り金が全部飛んでいく」「レア100枚、使えるものゼロ」。';

  @override
  String get wn030Update =>
      'アプリは新しいバージョンが出ると知らせ（勝手には更新しません）、ダウンロードする各データベースのSHA-256の指紋を確認します。';

  @override
  String get wn030Shortcuts =>
      'キーボードショートカット：Ctrl+1…7、Ctrl+E、Ctrl+F、Ctrl+, とEscape。';

  @override
  String get wn030Linux =>
      'Linuxでは、インストーラーがManaForgeをアイコン付きでアプリケーションメニューに登録します。';

  @override
  String get wn030License =>
      'PolyForm Noncommercialライセンス：好きに共有・改変できますが、販売はできません。';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n 枚');
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'デッキ $n 個',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'フォルダ $n 個',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '実績 $n 個',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => '空のバックアップ';

  @override
  String get bkStoreCollection => 'あなたのコレクション';

  @override
  String get bkStoreFolders => 'あなたのフォルダ';

  @override
  String get bkStoreDecks => 'あなたのデッキ';

  @override
  String get bkStoreAchievements => 'あなたの実績';

  @override
  String get bkStoreWishlist => 'あなたのウィッシュリスト';

  @override
  String get bkStoreCertificates => 'あなたの証明書';

  @override
  String get bkStoreMarket => 'あなたの優先マーケット';

  @override
  String get bkStoreRecents => '最近見たカード';

  @override
  String get bkStoreValueHistory => '価値の履歴';

  @override
  String get bkStorePriceHistory => '価格の履歴';

  @override
  String get bkKindAuto => '自動';

  @override
  String get bkKindPreRestore => '復元前';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig => 'そのファイルは、ManaForgeのバックアップにしては大きすぎます。';

  @override
  String get bkErrExpandTooBig =>
      'そのバックアップは展開すると大きすぎます：本物のManaForgeのバックアップではなさそうです。';

  @override
  String get bkErrNotABackup => 'そのファイルはManaForgeのバックアップではありません。';

  @override
  String get bkErrNewerVersion =>
      'そのバックアップは、より新しいバージョンのManaForgeで作られました。アプリを更新して、もう一度お試しください。';

  @override
  String get bkErrIncomplete => 'そのバックアップは不完全です：あなたのデータが入っていません。';

  @override
  String bkErrDamaged(String almacen) {
    return 'そのバックアップは壊れています：$almacen を読み取れません。';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'データフォルダに書き込めなかったので、何も変更していません：$error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return '復元が途中で止まりました（$total 個中 $escritos 個のファイル）。以前あったものの控えがありません。詳細：$error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return '復元が途中で止まりました（$total 個中 $escritos 個のファイル）。元に戻すには $ruta を復元してください。詳細：$error';
  }

  @override
  String get siImportTooBig => 'そのファイルは、カードリストにしては大きすぎます。';

  @override
  String get siInsecureDownload => 'ダウンロードが安全でないアドレスに達したため、中止しました。';

  @override
  String get siRedirectNowhere => 'ダウンロードのリダイレクト先がないため、中止しました。';

  @override
  String get siTooManyRedirects => 'ダウンロードのリダイレクトが多すぎるため、中止しました。';

  @override
  String get siDownloadTooBig => 'ダウンロードが本来よりずっと大きいため、中止しました。';

  @override
  String get siBadHash =>
      'ダウンロードした内容が、GitHubに公開されている指紋と一致しません。何もインストールしていません。もう一度お試しください。それでも続くようなら、お知らせください。';

  @override
  String get siBackgroundNotImage => '背景には画像（.jpg、.png、.webp）を選んでください。';

  @override
  String get siBackgroundTooBig => 'その画像は背景に使うには大きすぎます。';

  @override
  String get siScanTooBig => 'その写真は大きすぎて認識できません。';

  @override
  String get bgImages => '画像';

  @override
  String bgImageFailed(String error) {
    return 'その画像を使えませんでした：$error';
  }

  @override
  String get bgLowContrast => 'カードとの差が小さいです：文字が読めるように自動で調整されます。';

  @override
  String get bgChipColor => 'タブの色';

  @override
  String get bgIconColor => 'アイコンの色';

  @override
  String get bgUseThis => 'これを使う';

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
      'GStreamerがインストールされていません。次でインストールしてください：\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'カメラ $dispositivo が画像を出しません（gst-launchが $codigo で終了）。\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'カメラ $dispositivo が6秒間フレームを1つも出しませんでした。';
  }

  @override
  String get camNoCameras =>
      'カメラ（/dev/video*）が見つかりません。接続されていますか？`lsusb` でシステムが認識しているか確認してください。';

  @override
  String camNoneWorked(String detalle) {
    return 'どのカメラも画像を出しませんでした：\n$detalle';
  }

  @override
  String get bkRestoreAction => '復元';

  @override
  String get fpUnselect => '選択解除';

  @override
  String get stClear => '空にする';

  @override
  String get tlRemove => '取り除く';

  @override
  String get tlUnrecognized => '認識できず';

  @override
  String get tlNothingAlike => 'データベースに似たものなし—撮り直すか取り除く';

  @override
  String get tlTapToPick => 'タップして似ているものから手動で選ぶ';

  @override
  String get tlReview => '要確認';

  @override
  String get lsQuantity => '数量';

  @override
  String get scPhotos => '写真';

  @override
  String get ftWhichFolder => 'どのフォルダに入れますか？';

  @override
  String get ftWhichFolderSub =>
      'どちらにしてもコレクションには入ります。フォルダは、あとで見つけるためのラベルにすぎません。';

  @override
  String get ftNone => 'なし';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n 枚');
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => '新しいフォルダ…';

  @override
  String get ftNewFolder => '新しいフォルダ';

  @override
  String get ftNewFolderHint => 'お店の箱、売る用…';

  @override
  String get sgTitle => 'スキャナーの目';

  @override
  String get sgWhy =>
      'インターネットなしでカードを認識するには、視覚的な指紋データベース（約12 MB）が必要です：Magicの各イラストのアートの署名です。一度だけダウンロードします。';

  @override
  String get sgDownload => '指紋データベースをダウンロード';

  @override
  String get cmFullCard => 'カード詳細を見る（価格とリーガリティ）';

  @override
  String get cmSwipeHint => 'ドラッグか← →でめくる · 外側をタップで閉じる';

  @override
  String get cmTapOutHint => '外側をタップで閉じる';

  @override
  String get fcTitle => 'どのカードから始めましたか？';

  @override
  String get fcRemove => '取り除く';

  @override
  String get fcSearchHint => 'コレクション内を検索';

  @override
  String get fcNoMatch => 'それに合うカードが見つかりません。';

  @override
  String get acNoneWithFilters => 'この絞り込みでは何もありません。';

  @override
  String get acAll => 'すべて';

  @override
  String get tsTitle => 'テストモード—メタを倒せ';

  @override
  String get tsIntro =>
      'どのメタデッキと対戦したいか選んでください。ManaForgeはあなたのカードでデッキを組み、それと数百回対戦をシミュレートして、最も勝つものを選びます—さらにカードの入れ替えを1枚ずつ試して磨き上げます。';

  @override
  String get tsLoadingMeta => 'メタを読み込み中…';

  @override
  String get tsLocalPresets => 'ローカルプリセット（オフライン）';

  @override
  String get tsNoDeckToFace =>
      '今のカードでは、対戦させる完成したデッキが組めません。カードを追加して、もう一度お試しください。';

  @override
  String tsSimFailed(String error) {
    return 'シミュレートできませんでした：$error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · メタの $cuota';
  }

  @override
  String get tsSimulating => '対戦をシミュレート中…（数秒、すべてあなたの端末上で）';

  @override
  String tsFindBest(String meta) {
    return '$meta に対する自分の最強デッキを探す';
  }

  @override
  String get tsHonesty =>
      '正直に言うと：シミュレーションはマナの色、マリガン、回避（飛行、トランプル、接死…）、インスタント除去、打ち消しは理解しますが、各カードの全文までは理解しません。この勝率は、自分のデッキ同士を比較するためのもので、正確な予測ではありません。';

  @override
  String tsChampion(String meta) {
    return '$meta に対するあなたのチャンピオン';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'の推定勝率 · デッキ $mazos 個を試行 · 1デッキあたり $partidas 戦';
  }

  @override
  String get tsNoDominant =>
      'コレクションのどのデッキもこの対戦を圧倒はしません—これが一番よく戦うものです。詳細でその弱点を確認してください。';

  @override
  String get tsSeeDeck => 'デッキ全体を見る（そして保存）';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '実績 $total 個中 $hechos 個 · レベル $nivel まで $xp XP';
  }

  @override
  String get hsForgeDecks => 'デッキを鍛造';

  @override
  String get hsTestYourself => '⚔ 腕試し';

  @override
  String get bgCustom => 'カスタム';

  @override
  String get bgPickCustom => 'カスタム色を選ぶ';

  @override
  String get bgCustomColor => 'カスタム色';

  @override
  String get bgSampleTab => '赤';

  @override
  String get cfSortRecent => '追加した順';

  @override
  String get cfSortAlpha => '名前 A-Z';

  @override
  String get cfSortCmc => 'コスト';

  @override
  String get cfSortQty => '数量';

  @override
  String get cfSortBy => '並べ替え';

  @override
  String get cfSort => '並び順';

  @override
  String get cfClear => 'クリア';

  @override
  String get cfCost => 'コスト';

  @override
  String get cfCostAll => 'コスト：すべて';

  @override
  String cfCostN(String n) {
    return 'コスト $n';
  }

  @override
  String get cfType => 'タイプ';

  @override
  String get cfTypeAll => 'タイプ：すべて';

  @override
  String get cfTypeCreature => 'クリーチャー';

  @override
  String get cfTypeInstant => 'インスタント';

  @override
  String get cfTypeSorcery => 'ソーサリー';

  @override
  String get cfTypeArtifact => 'アーティファクト';

  @override
  String get cfTypeEnchantment => 'エンチャント';

  @override
  String get cfTypeLand => '土地';

  @override
  String get cfPower => 'パワー';

  @override
  String get cfPowerAll => 'パワー：すべて';

  @override
  String cfPowerMin(int n) {
    return 'パワー ≥ $n';
  }

  @override
  String get cfToughness => 'タフネス';

  @override
  String get cfToughnessAll => 'タフネス：すべて';

  @override
  String cfToughnessMin(int n) {
    return 'タフネス ≥ $n';
  }

  @override
  String get cfNoDate => '日付なし';

  @override
  String get cfToday => '今日';

  @override
  String get cfYesterday => '昨日';

  @override
  String cfDaysAgo(int n) {
    return '$n 日前';
  }

  @override
  String get pcWeek => '週';

  @override
  String get pcMonth => '月';

  @override
  String get pcAll => 'すべて';

  @override
  String get vpTapCorrect => '正しいカードをタップ';

  @override
  String get achCopias1 => '最初の1枚、これから山ほど';

  @override
  String get achCopias10 => '1枚だけ買うつもりだった';

  @override
  String get achCopias50 => 'もう片手に収まらない';

  @override
  String get achCopias100 => '100枚、まだ増える';

  @override
  String get achCopias500 => '箱が手狭になってきた';

  @override
  String get achCopias1000 => '1000枚。全部欲しい';

  @override
  String get achCopias5000 => 'もはや倉庫';

  @override
  String get achCopias10000 => '1万枚、でもいつでもやめられる';

  @override
  String achCopiasDesc(String n) {
    return 'コレクションに $n 枚のカードを持つ。';
  }

  @override
  String get achDistintas25 => 'バラエティが出てきた';

  @override
  String get achDistintas100 => '100種類の違う顔ぶれ';

  @override
  String get achDistintas500 => '図書館の半分';

  @override
  String get achDistintas1000 => '歩く百科事典';

  @override
  String get achDistintas2500 => 'もう全部は覚えきれない';

  @override
  String get achDistintas5000 => 'アーカイブ';

  @override
  String achDistintasDesc(String n) {
    return '$n 種類の異なるカードを持つ（重複は数えません）。';
  }

  @override
  String get achPlaysets1 => '同じの4枚そろい';

  @override
  String get achPlaysets20 => 'プレイセット20組、デッキはゼロ';

  @override
  String get achPlaysets1Desc => '同じカードを4枚持つ。';

  @override
  String get achPlaysets20Desc => '20種類のプレイセットを持つ（それぞれ4枚ずつ）。';

  @override
  String get achComunes10 => '誰もいらないやつ';

  @override
  String get achComunes50 => 'いつもの山';

  @override
  String get achComunes200 => '山の王';

  @override
  String get achComunes500 => 'コモンの大波';

  @override
  String achComunesDesc(String n) {
    return '$n 種類のコモンを持つ。';
  }

  @override
  String get achInfrecuentes10 => 'コモンより一段上';

  @override
  String get achInfrecuentes50 => '上質な銀';

  @override
  String get achInfrecuentes200 => 'アンコモンハンター';

  @override
  String get achInfrecuentes500 => '銀をバケツ一杯';

  @override
  String achInfrecuentesDesc(String n) {
    return '$n 種類のアンコモンを持つ。';
  }

  @override
  String get achRaras5 => 'パックを開けて聞こえるいい音';

  @override
  String get achRaras25 => 'レアの宝箱';

  @override
  String get achRaras100 => 'レア100枚、使えるものゼロ';

  @override
  String get achRaras300 => '金庫室';

  @override
  String achRarasDesc(String n) {
    return '$n 種類のレアを持つ。';
  }

  @override
  String get achMiticas1 => '初めての神話レア';

  @override
  String get achMiticas10 => '神話レア10枚';

  @override
  String get achMiticas50 => '神話級コレクター';

  @override
  String get achMiticas150 => '神話の万神殿';

  @override
  String achMiticasDesc(String n) {
    return '$n 種類の神話レアを持つ。';
  }

  @override
  String get achBlancas25 => '秩序と規律';

  @override
  String get achBlancas100 => '白銀の軍勢';

  @override
  String achBlancasDesc(String n) {
    return '$n 種類の白いカードを持つ。';
  }

  @override
  String get achAzules25 => 'それはやらせない';

  @override
  String get achAzules100 => '象牙の塔';

  @override
  String achAzulesDesc(String n) {
    return '$n 種類の青いカードを持つ。';
  }

  @override
  String get achNegras25 => '闇の契約';

  @override
  String get achNegras100 => '地下墓地の主';

  @override
  String achNegrasDesc(String n) {
    return '$n 種類の黒いカードを持つ。';
  }

  @override
  String get achRojas25 => '何もかも焼き尽くせ';

  @override
  String get achRojas100 => '大炎上';

  @override
  String achRojasDesc(String n) {
    return '$n 種類の赤いカードを持つ。';
  }

  @override
  String get achVerdes25 => '芽生え';

  @override
  String get achVerdes100 => '森まるごと';

  @override
  String achVerdesDesc(String n) {
    return '$n 種類の緑のカードを持つ。';
  }

  @override
  String get achIncoloras25 => '冷たい金属';

  @override
  String get achIncoloras100 => '永遠の鍛冶場';

  @override
  String achIncolorasDesc(String n) {
    return '$n 種類の無色のカードを持つ。';
  }

  @override
  String get achArcoiris => '五色そろい踏み';

  @override
  String get achArcoirisDesc => '5色それぞれ、少なくとも1枚ずつ持つ。';

  @override
  String get achMulticolor10 => '色を混ぜて';

  @override
  String get achMulticolor50 => '黄金の同盟';

  @override
  String achMulticolorDesc(String n) {
    return '$n 種類の多色カードを持つ。';
  }

  @override
  String get achCincocolores => '5色いっぺんに';

  @override
  String get achCincocoloresDesc => '5色すべてを持つカードを1枚持つ。';

  @override
  String get achSets1 => '初めてのエキスパンション';

  @override
  String get achSets5 => '5つの世界';

  @override
  String get achSets10 => 'プレインズウォーカー見習い';

  @override
  String get achSets25 => '世界を股にかける';

  @override
  String get achSets50 => '多元宇宙の半分';

  @override
  String achSetsDesc(String n) {
    return '$n 個の異なるエキスパンションのカードを持つ。';
  }

  @override
  String get achSetscompletos1 => '1枚も欠けなし';

  @override
  String get achSetscompletos3 => 'アルバム3冊まるごと';

  @override
  String get achSetscompletos10 => 'アルバムの達人';

  @override
  String get achSetscompletos1Desc => 'アルバムでエキスパンションを丸ごと1つ完成させる。';

  @override
  String achSetscompletos3Desc(String n) {
    return '$n 個のエキスパンションを丸ごと完成させる。';
  }

  @override
  String get achAnyos5 => '厚紙5年分';

  @override
  String get achAnyos15 => 'タイムマシン';

  @override
  String achAnyosDesc(String n) {
    return '$n 種類の異なる発売年のカードを持つ。';
  }

  @override
  String get achValor10 => '初めての数ユーロ';

  @override
  String get achValor50 => '貯金箱';

  @override
  String get achValor250 => '小遣いが飛んでいく';

  @override
  String get achValor1000 => '有り金が全部飛んでいく';

  @override
  String get achValor5000 => '誰にも言わないで';

  @override
  String get achValor10000 => '車より高い';

  @override
  String get achValor25000 => '美術館級のコレクション';

  @override
  String achValorDesc(String n) {
    return 'コレクションの価値が $n € 以上になる。';
  }

  @override
  String get achJoya20 => 'いいやつが1枚';

  @override
  String get achJoya100 => 'コレクションの至宝';

  @override
  String get achJoya500 => 'これはスリーブから出さない';

  @override
  String get achJoya1000 => 'スリーブ1枚に1000ユーロ';

  @override
  String get achJoya2500 => '聖杯';

  @override
  String achJoyaDesc(String n) {
    return '1枚で $n € 以上の価値があるカードを持つ。';
  }

  @override
  String get achFoils1 => '初めての輝き';

  @override
  String get achFoils10 => 'きらめき';

  @override
  String get achFoils50 => '箱が光る';

  @override
  String get achFoils200 => 'つや消しはもう1枚もない';

  @override
  String get achFoils500 => '何もかも輝く';

  @override
  String get achFoils1000 => '輝き工場';

  @override
  String achFoilsDesc(String n) {
    return 'foilカードを $n 枚持つ。';
  }

  @override
  String get achFoiljoya10 => 'いいfoil';

  @override
  String get achFoiljoya50 => 'お高いfoil';

  @override
  String get achFoiljoya200 => '美術館級のfoil';

  @override
  String achFoiljoyaDesc(String n) {
    return '$n € 以上の価値があるfoilを1枚持つ。';
  }

  @override
  String get achFoilvalor50 => '輝くショーケース';

  @override
  String get achFoilvalor250 => 'お高いショーケース';

  @override
  String get achFoilvalor1000 => '1000ユーロ分の輝き';

  @override
  String get achFoilvalor5000 => '美術館級のショーケース';

  @override
  String achFoilvalorDesc(String n) {
    return 'foilの合計価値が $n € 以上になる。';
  }

  @override
  String get achMazos1 => '初めてのデッキ';

  @override
  String get achMazos5 => 'デッキ5個保存';

  @override
  String get achMazos25 => '工房は止まらない';

  @override
  String achMazosDesc(String n) {
    return 'Forgeで作ったデッキを $n 個保存する。';
  }

  @override
  String get achMazoscore => 'そつのないデッキ';

  @override
  String get achMazoscoreDesc => 'スコア90以上のデッキを生成する。';

  @override
  String get achMazocolores3 => '3色';

  @override
  String get achMazocolores5 => '実戦向けの虹';

  @override
  String achMazocoloresDesc(String n) {
    return '$n 色のデッキを保存する。';
  }

  @override
  String get achMazomono => '混ぜもの一切なし';

  @override
  String get achMazomonoDesc => '単色のデッキを保存する。';

  @override
  String get achMazocommander => '指揮を執る';

  @override
  String get achMazocommanderDesc => 'Commanderのデッキを保存する。';

  @override
  String get achEscaneadas1 => '初めてのスキャン';

  @override
  String get achEscaneadas50 => '早業の手さばき';

  @override
  String get achEscaneadas500 => 'まとめてスキャン';

  @override
  String get achEscaneadas2000 => '寝ながらでもスキャン';

  @override
  String achEscaneadasDesc(String n) {
    return 'カメラか写真で $n 枚のカードをスキャンする。';
  }

  @override
  String get achFoto9 => '写真1枚でページまるごと';

  @override
  String get achFoto20 => '一度に20枚';

  @override
  String achFotoDesc(String n) {
    return '1枚の写真で $n 枚のカードを認識する。';
  }

  @override
  String get achEscaneoperfecto => '確認ゼロ枚';

  @override
  String get achEscaneoperfectoDesc => '1ページ丸ごと、1枚も確認送りにせずスキャンする。';

  @override
  String get achDias2 => '戻ってきた';

  @override
  String get achDias7 => 'ここで1週間';

  @override
  String get achDias30 => 'ここで1か月';

  @override
  String get achDias100 => 'ここで100日';

  @override
  String achDiasDesc(String n) {
    return 'ManaForgeを $n 日、別々の日に使う。';
  }

  @override
  String get achRacha3 => '3日連続';

  @override
  String get achRacha7 => '完璧な1週間';

  @override
  String get achRacha30 => '1か月休まず';

  @override
  String achRachaDesc(String n) {
    return '$n 日連続でアクセスする。';
  }

  @override
  String get achSemanas => '4週間、一度も欠かさず';

  @override
  String get achSemanasDesc => 'ManaForgeを4週連続で使う。';

  @override
  String get achCarpetas1 => '整理のはじまり';

  @override
  String get achCarpetas5 => '全部仕分け済み';

  @override
  String achCarpetasDesc(String n) {
    return '$n 個のフォルダを作る。';
  }

  @override
  String get achCarpetagrande => '特大フォルダ';

  @override
  String get achCarpetagrandeDesc => '100枚以上入ったフォルダを持つ。';

  @override
  String get achCarpetavalor => 'このフォルダは貸さない';

  @override
  String get achCarpetavalorDesc => '100 € 以上の価値があるフォルダを持つ。';

  @override
  String get achTierrasbasicas => '基本土地5種そろい';

  @override
  String get achTierrasbasicasDesc => '5種類の基本土地（平地・島・沼・山・森）をすべて持つ。';

  @override
  String get achFuerza => 'とんでもない化け物';

  @override
  String get achFuerzaDesc => 'パワー10以上のクリーチャーを持つ。';

  @override
  String get achCoste => 'こんなの一生唱えない';

  @override
  String get achCosteDesc => '点数で見たマナ・コスト10以上のカードを持つ。';

  @override
  String get achCostecero => 'タダ';

  @override
  String get achCosteceroDesc => 'コスト0のカードを持つ。';

  @override
  String get achTipos => '何でも少しずつ';

  @override
  String get achTiposDesc =>
      'クリーチャー、インスタント、ソーサリー、アーティファクト、エンチャント、土地、プレインズウォーカーを少なくとも1枚ずつ持つ。';

  @override
  String get achPlaneswalkers => 'プレインズウォーカー勢ぞろい';

  @override
  String get achPlaneswalkersDesc => '5種類の異なるプレインズウォーカーを持つ。';

  @override
  String get achNoventas => '90年代の遺物';

  @override
  String get achNoventasDesc => '1990年代のカードを持つ。';

  @override
  String get achIdiomas1 => 'これは読めない';

  @override
  String get achIdiomas25 => '多言語コレクション';

  @override
  String get achIdiomas1Desc => '英語以外の言語のカードを1枚持つ。';

  @override
  String get achIdiomas25Desc => '他言語のカードを25枚持つ。';

  @override
  String get achWishlist => '物欲リスト';

  @override
  String get achWishlistDesc => 'ウィッシュリストに20枚のカードを登録する。';

  @override
  String get achTierBronze => 'ブロンズ';

  @override
  String get achTierSilver => 'シルバー';

  @override
  String get achTierGold => 'ゴールド';

  @override
  String get achTierMythic => 'ミシック';

  @override
  String get achCatCollection => 'コレクション';

  @override
  String get achCatRarity => 'レアリティ';

  @override
  String get achCatColor => '色';

  @override
  String get achCatSets => 'エキスパンション';

  @override
  String get achCatValue => '価値';

  @override
  String get achCatFoils => 'foil';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'スキャナー';

  @override
  String get achCatDedication => 'やり込み';

  @override
  String get achCatFolders => 'フォルダ';

  @override
  String get achCatCuriosities => '変わり種';

  @override
  String get achRankApprentice => '見習い';

  @override
  String get achRankSummoner => '召喚士';

  @override
  String get achRankMage => '魔道士';

  @override
  String get achRankArchmage => '大魔道士';

  @override
  String get achRankMaster => '達人';

  @override
  String get achRankPlaneswalker => 'プレインズウォーカー';

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
    return 'カードデータベースをダウンロードできませんでした（HTTP $codigo）。しばらくしてからもう一度お試しください。';
  }

  @override
  String dbErrHashes(String codigo) {
    return '指紋データベースをダウンロードできませんでした（HTTP $codigo）。しばらくしてからもう一度お試しください。';
  }

  @override
  String dbErrPrices(String codigo) {
    return '価格履歴をダウンロードできませんでした（HTTP $codigo）。しばらくしてからもう一度お試しください。';
  }

  @override
  String ddCardCount(int n) {
    return '$n 枚';
  }

  @override
  String get ddForgedWith => 'ManaForgeで鍛造';

  @override
  String get fxThemeLifegain => 'ライフゲイン';

  @override
  String get fxThemeSacrifice => 'サクリファイス';

  @override
  String get fxThemeSpells => '呪文';

  @override
  String get fxThemeArtifacts => 'アーティファクト';

  @override
  String get fxThemeCounters => '+1/+1カウンター';

  @override
  String get fxThemeTokens => 'スウォーム';

  @override
  String get fxThemeGraveyard => '墓地';

  @override
  String get fxThemeReanimator => 'リアニメイト';

  @override
  String fxThemeTribal(String tribe) {
    return '$tribe部族';
  }

  @override
  String get fxThemeGoodstuff => '選りすぐりの強カード';

  @override
  String get fxTagLifegain => '得たライフ1点1点が相手へのダメージ：吸い取って、耐えしのげ。';

  @override
  String get fxTagSacrifice => 'あなたのクリーチャーは死んでこそ価値がある：生け贄に捧げて、通行料を取り立てろ。';

  @override
  String get fxTagSpells => 'インスタント1枚1枚が効いてくる：相手のターンに動いて、しっかり咎めろ。';

  @override
  String get fxTagArtifacts => '工房を整えろ：アーティファクト1つ1つが、ほかを強くする。';

  @override
  String get fxTagCounters => '+1/+1カウンター：あなたのクリーチャーは手の届かないところまで育つ。';

  @override
  String get fxTagTokens => '盤面をトークンで埋め尽くせ：相手が1体なら、こちらは5体。';

  @override
  String get fxTagGraveyard => '墓地はあなたの第2の手札：どんどん貯めて、いいものを使い回せ。';

  @override
  String get fxTagAggro => '早く出て顔面を殴れ：試合は早々に終わるはず。';

  @override
  String get fxTagTempo => '早めに攻めて、呪文でリードを守れ。';

  @override
  String fxTagMidrange(String tema) {
    return 'うまくカードを交換して、$tema で中盤を制せ。';
  }

  @override
  String get fxTagControl => '耐えて、すべてに対処し、盤面を握ったら仕留めろ。';

  @override
  String get fxMidLifegain => 'ライフ回復源を、それで相手を咎めるカードとつなげろ。';

  @override
  String get fxMidSacrifice => '安いものを生け贄にして、ドロー・ドレイン・残りの強化につなげろ。';

  @override
  String get fxMidSpells => 'マナは構えておけ：呪文を唱えるたびにクリーチャーが育つ。';

  @override
  String get fxMidArtifacts => '軽いアーティファクトを並べて、その数を数えるカードを起動しろ。';

  @override
  String get fxMidCounters => '1〜2体のクリーチャーにカウンターを盛って、守り抜け。';

  @override
  String get fxMidTokens => '毎ターン、トークンを生成して、それを強化する効果を探せ。';

  @override
  String get fxMidGraveyard => '狙って切削・捨て札しろ：墓地に落ちたものは戻ってくる。';

  @override
  String get fxEndLifegain => 'ライフが高いうちに攻めに転じろ：相手はもう届かない。';

  @override
  String get fxEndSacrifice => '積み上げたアドバンテージが試合を決める：どの交換もこちらは実質タダ。';

  @override
  String get fxEndSpells => '同じターンに呪文を2枚、あとはクリーチャーが試合を締める。';

  @override
  String get fxEndArtifacts => 'あなたの盤面は相手の倍の価値：ペイオフで仕留めろ。';

  @override
  String get fxEndCounters => '守られた巨大な脅威が、2回の攻撃で試合を終わらせる。';

  @override
  String get fxEndTokens => '総攻撃を仕掛けろ：どんなブロックも、あなたの全軍は止められない。';

  @override
  String get fxEndGraveyard => '最強のカードを使い回せ：相手の1つの手札に、こちらは2つで戦う。';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => '毎ターン、必ずクリーチャーを1体プレイしろ。';

  @override
  String get fxAggroMid => '攻め続けろ。火力はブロッカー除去用に取っておけ。';

  @override
  String get fxAggroLate => '全力で仕留めろ：ここで試合を締めるべきだ。';

  @override
  String get fxTempoEarly => '軽い脅威を出しつつ、できるときはマナを構えろ。';

  @override
  String get fxTempoMid => '攻めながら、相手のターンに呪文を使え。';

  @override
  String get fxTempoLate => 'クリーチャーを守って、空から、あるいは火力で締めろ。';

  @override
  String get fxMidrangeEarly => '盤面を作り、カードを無駄にするな：1対1の有利な交換を。';

  @override
  String fxMidrangeMid(String tema) {
    return '$tema のエンジンを展開して、盤面を安定させろ。';
  }

  @override
  String get fxMidrangeLate => 'あなたのカードは相手より価値が高い：それを勝ちに変えろ。';

  @override
  String get fxControlEarly => '毎ターン土地を置き、重要なものだけに対処しろ。';

  @override
  String get fxControlMid => '盤面を一掃してカードを引け：時間はあなたの味方。';

  @override
  String get fxControlLate => '脅威を1つ出して、最後まで守り抜け。';

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
    return '平均コスト $coste：カーステンの法則（コスト3.0で土地24枚、±0.5ごとに±1）によれば、このデッキは土地 $tierras 枚—$arquetipo デッキの範囲内です。盤面を支えるクリーチャーが $criaturas 体、相手の動きに対処する干渉カードが $interaccion 枚。テーマ（$tema）があなたのシナジーを集約します：テーマのパーツを見るほど、その1枚1枚が強くなります。';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'そのカーブだと土地は $tierras 枚：健全な範囲（$min-$max）の外です。呪文の合計枚数を調整してください。';
  }

  @override
  String get fxNoCards =>
      'コレクションには、そのカーブを埋めるのに十分なこれらの色のカードがありません。呪文を減らすか、別のコストで試してください。';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'そのカーブ（平均コスト $coste で土地 $tierras 枚）は、どの健全なプロファイルにも当てはまりません：軽いデッキは土地を減らしたがり、重いデッキは増やしたがります。両者を近づけてください。';
  }

  @override
  String get fxNoBasics => 'コレクションには、そのカーブに必要な基本土地が足りません。';

  @override
  String fxHardRule(String detalle) {
    return '指定したカーブは、絶対的なルールを破っています：$detalle';
  }

  @override
  String get tsPresetMonoRed => '軽いクリーチャーと顔面へのダメージ：ペースについていけないと4〜5ターンで負けます。';

  @override
  String get tsPresetAzorius => '打ち消し、全体除去、ドロー：試合を長引かせて、少数のフィニッシャーで勝ちます。';

  @override
  String get tsPresetGolgari => '1対1の交換、効率的なクリーチャー、黒の除去：カードの質で長期戦を制します。';
}
