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

  @override
  String get lsNoCamera => 'No encuentro ninguna cámara.';

  @override
  String get lsCameraGone =>
      'La cámara se ha desconectado a media sesión. Revisa el cable y dale a Reintentar.';

  @override
  String get lsFrameCard => 'Encuadra la carta dentro del marco';

  @override
  String get lsNoCardThere => 'No veo ninguna carta ahí';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n cartas a la colección',
      one: '✓ 1 carta a la colección',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', y a \"$carpeta\"';
  }

  @override
  String get lsTitle => 'Escanear en vivo';

  @override
  String get lsQuickTip =>
      'Rápido: las cartas claras entran solas; las dudosas, marcadas para revisar.';

  @override
  String get lsCarefulTip =>
      'Con cuidado: las dudosas se paran y te preguntan cuál es.';

  @override
  String get lsQuick => 'Rápido';

  @override
  String get lsCareful => 'Con cuidado';

  @override
  String lsThisSession(int n) {
    return '$n esta sesión';
  }

  @override
  String get lsScanPhotoTooltip => 'Escanear una foto suelta';

  @override
  String get lsStartingCamera => 'Encendiendo la cámara…';

  @override
  String get lsCantUseCamera => 'No puedo usar la cámara';

  @override
  String get lsCameraUnavailable => 'Cámara no disponible.';

  @override
  String get lsScanPhoto => 'Escanear una foto';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 igual · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Ya está en la mesa: $carta · retírala y vuelve a ponerla, o toca \"+1 igual\"';
  }

  @override
  String lsSeeing(String carta) {
    return 'Viendo: $carta';
  }

  @override
  String get lsPassACard => 'Pasa una carta por delante de la cámara…';

  @override
  String lsIsThis(String carta) {
    return '¿Es $carta? No estoy seguro — toca para elegir.';
  }

  @override
  String get lsNotThisOne => 'No es esta — cambiar versión';

  @override
  String get lsRetry => 'Reintentar';

  @override
  String get scBadImage => 'No pude leer esa imagen (¿es una foto válida?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Sin carpeta';

  @override
  String scAlsoTo(String carpeta) {
    return 'Y además a: $carpeta';
  }

  @override
  String get scLookingForCard => 'Buscando la carta en la foto…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Reconociendo… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartas',
      one: '1 carta',
    );
    return '$_temp0 · $copias en total';
  }

  @override
  String scToReview(int n) {
    return '$n para revisar (tócalas)';
  }

  @override
  String scUnknown(int n) {
    return '$n sin reconocer (toca para elegir a mano)';
  }

  @override
  String get scNothingRecognised =>
      'No reconocí ninguna carta en esas fotos. Prueba con mejor luz o menos reflejo.';

  @override
  String scAddN(int n) {
    return 'Añadir $n a la colección';
  }

  @override
  String get scDropPhotos => 'Suelta aquí las fotos de tus cartas';

  @override
  String get scDropExplain =>
      'Una o varias a la vez — y si una foto trae VARIAS cartas (una página del álbum, la mesa llena), las saco todas y las junto en una lista para que revises y añadas las que quieras. Vale foto del móvil o escaneo.';

  @override
  String get scPickPhotos => 'Elegir fotos';

  @override
  String get scMatchHigh => 'coincidencia alta';

  @override
  String get scMatchMedium => 'coincidencia media';

  @override
  String get scMatchLow => 'coincidencia baja';

  @override
  String get scAddToCollection => 'Añadir a la colección';

  @override
  String get scSeeOptions => 'No es esta — ver opciones';

  @override
  String get scScanAnother => 'Escanear otra';

  @override
  String get scNotSure => 'No estoy seguro';

  @override
  String get scWhichIsIt => '¿Cuál es?';

  @override
  String get scNoneQuiteFits =>
      'Ninguna encaja del todo. ¿Es alguna de estas? Si no, prueba otra foto con mejor luz.';

  @override
  String get scNoEdges =>
      'No vi los bordes de la carta, así que he usado la imagen entera. Estos son los parecidos:';

  @override
  String get scCropped =>
      'Esto es lo que he recortado. Los candidatos, por parecido:';

  @override
  String get scDiscard => 'Descartar y escanear otra';
}
