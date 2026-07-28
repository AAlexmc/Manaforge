<p align="center">
  <img src="../assets/banner.svg" alt="ManaForge — コレクションをスキャン。いま持っているカードでデッキを鍛え上げよう。" width="100%">
</p>

<p align="center"><a href="README.en.md">🇬🇧 English</a> · <a href="../../README.md">🇪🇸 Español</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.fr.md">🇫🇷 Français</a> · <a href="README.it.md">🇮🇹 Italiano</a> · <a href="README.pt.md">🇵🇹 Português</a> · <a href="README.ru.md">🇷🇺 Русский</a> · <a href="README.zh.md">🇨🇳 中文</a> · <b>🇯🇵 日本語</b> · <a href="README.ko.md">🇰🇷 한국어</a></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="カードデータベース"></a>
  <a href="../../LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="PolyForm Noncommercial 1.0.0 ライセンス"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="クロスプラットフォームのデスクトップアプリ">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="永久に無料">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">機能</a></b> ·
  <b><a href="#download">ダウンロード</a></b> ·
  <b><a href="#architecture">アーキテクチャ</a></b> ·
  <b><a href="#roadmap">ロードマップ</a></b> ·
  <b><a href="#contributing">コントリビュート</a></b>
</p>

> [!TIP]
> **「いま持っているカードで、どんなデッキが組める？」** どのMagicアプリもまともに答えてくれないこの問いこそ、ManaForgeが存在する唯一の理由です。他のアプリはカードの山を*カタログ化*する手伝いをしてくれるだけ。こちらはその山を、すぐシャッフルできるデッキに変えます。

誰もが通る道です：ブースターや構築済みデッキ、譲り受けた引き出しでいっぱいのカードの山……なのに、何を組めばいいのかさっぱり分からない。ManaForgeはプレイヤーがプレイヤーのために作りました：**無料、広告なし、課金なし、アカウント不要、コードはすべて公開。**

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge：デッキジェネレーター

コレクションを渡すと、ベテランプレイヤーが組むような**60枚の完成デッキ**が返ってきます。頭の中はこうなっています：

<p align="center">
  <img src="../assets/forge-flow.svg" alt="コレクション → シナジー → マナカーブ → バリデーター → ゲームプラン付きデッキ" width="100%">
</p>

- 🏔️ **ちゃんとしたマナカーブ** — アーキタイプごとの土地枚数、色シンボルに応じたマナ源の配分、検証済みのカーブ。土地15枚のデッキとは無縁です。
- 🧬 **シナジーを自動検出** — Forgeは全カードのルールテキストを読み、あなたのテーマを見つけ出します：ライフドレイン、生け贄、アーティファクト、横並べ、スペルスリンガー、カウンター……
- 🗺️ **解説付きゲームプラン** — ターンごとのプランに加え、理屈まで知りたい人のための折りたたみ式*「なぜこのデッキは回るのか？」*も。
- 🤝 **名誉の掟** — 持っていないカードは決して使わず、枚数制限も決して破らない。壊れたデッキを出すくらいなら、理由を説明して代案を提案します。
- 🎯 **スタイルを選べる** — 部族（エルフ、ゾンビ、ドラゴン……厳選24種、それに頭数さえ揃えばどんなサブタイプでも）やメカニズムのテーマを指定すれば、エンジンは従います。Autoなら、コレクションが一番報われるテーマを自動で見つけます。
- ⚔️ **ディープフォージ** — 候補デッキは表示される前に、互いに何百戦も対戦します。最終順位は紙の上のスコアだけでなく、実際の戦績を反映。
- 🎲 **本物の確率** — 安定性（土地を間に合うように引けるか？）とプレイ可能なカーブを超幾何分布の数学で計算。特殊土地（ショックランド、チェックランド、フェッチランド）は、実際の働きどおりにカウントします。
- 📤 **ワンタップでエクスポート** — リストをコピーして、MoxfieldやMTG Arena、仲間のDiscordに貼るだけ。

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>ManaForge誕生のきっかけとなった実際のコレクション — ジェネレーターはこれらのカード（＋280枚）を、遊べるデッキ5つに変えました。</i></sub></p>

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ いまできること

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>Magicの全歴史を<br/>ポケットに</b><br/><br/>
      <sub>完全なカードデータベース（Scryfallバルク → SQLite）を毎月CIで自動再構築。一度ダウンロードすれば、あとはすべて<b>オフライン</b>で動きます。</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>スペイン語と英語で<br/>検索</b><br/><br/>
      <sub>「Elfos de Llanowar」でも、アクセント記号なしの「elfos de llanowar」でも、「Llanowar Elves」でも：すべて同じカードにたどり着きます。アプリをスペイン語にすると、デッキやカード画面もスペイン語名で表示。</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>コレクションを<br/>ビジュアルに、あなたの手元に</b><br/><br/>
      <sub><b>ウェブカメラでカードをスキャン</b>（アートから正確な版まで認識）、他アプリからの<b>CSVインポート</b>、手入力での追加もOK。すべてローカル保存：アカウント不要、クラウド強制なし。</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>比較しやすいカルーセルに並ぶ複数の提案、ターンごとのゲームプラン付き詳細画面、いじるとデッキを鍛え直す編集可能なカーブ、別のデッキと戦わせるテストモード。</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>細部までこだわった<br/>デザイン</b><br/><br/>
      <sub>ダークテーマ、<b>10言語完全対応</b>、アプリの中身を案内するガイドツアー、色覚多様性に配慮したマナアイコン、プレイヤー目線のマイクロコピー。</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>デフォルトで<br/>プライバシー</b><br/><br/>
      <sub>アナリティクスなし、トラッキングなし、「アカウントを作成してください」もなし。スキャナーは100 %あなたのデバイス上でカードを認識します。</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **窯で焼き上げ中：** コレクション間のトレード、さらに多くの言語のカード名、そしてコミュニティの声があればモバイル版。

<a id="download"></a>
## 🚀 ダウンロードして開く

[**Releases**](https://github.com/AAlexmc/Manaforge/releases) から、お使いのシステム用のzipを取ってきてください。インストーラーもアカウントも不要：解凍して開くだけです。

| システム | 手順 |
|---|---|
| **Windows** | 解凍して、`ManaForge` フォルダー内の `manaforge.exe` を開きます。初回はWindowsが「発行元不明」と警告します：*詳細情報 → 実行* で起動（署名はしていません。コードはここに全部あるので、いつでも中身を確認できます）。 |
| **macOS** | 解凍して一度開きます（警告が出ます）。その後 *システム設定 → プライバシーとセキュリティ → このまま開く*。（macOS 15以降、右クリック → 開く では警告を回避できなくなりました。） |
| **Linux** | 解凍して、`ManaForge` フォルダー内で `./manaforge` を実行。アイコン付きでアプリメニューに載せたいときは：`./instalar.sh`（すべて `~/.local` に入り、sudo不要。`./instalar.sh --desinstalar` で削除できます）。 |

**ダウンロードの検証**：各リリースには、3つのzipのハッシュを記した `SHA256SUMS.txt` が付いています。LinuxまたはmacOSでは `sha256sum -c SHA256SUMS.txt`（または `shasum -a 256 -c`）、Windowsでは `Get-FileHash ManaForge-Windows.zip`。

初回起動時にアプリは**約36 MB**のデータ（Scryfallのカードと価格、価格履歴、スキャナー用フィンガープリント）をダウンロードし、進行状況を表示します。それ以降はオフラインで動作します。

その後は：CSVから**コレクションをインポート**、ウェブカメラや写真でカードを**スキャン**、あるいはコレクション登録前でも、直接 **⚒️ Forge** に行って任意のコレクションからデッキを組んでみてください。

### 自分でビルドしたい？

```bash
# Flutter、stableチャンネル: https://docs.flutter.dev/get-started/install
# （Windowsでは「C++によるデスクトップ開発」入りのVisual Studioが必要）
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # または -d windows / -d macos
```

Linux・Windows・macOSのネイティブラッパーと `pubspec.lock` はリポジトリに含まれているので、3プラットフォームともそのままビルドできます。

<a id="architecture"></a>
## 🔧 中身の作り

| フォルダー | 中身 |
|---|---|
| [`app/`](../../app) | Flutterアプリ — Windows・macOS・Linux（いつかはモバイルも）をひとつのコードベースで |
| [`forge_engine/`](../../forge_engine) | Dart製デッキエンジン：カーブ、バリデーター、分類器、ジェネレーター |
| [`engine-reference/`](../../engine-reference) | 同じエンジンのPython版：アルゴリズムの**テスト済み正準リファレンス** |
| [`scripts/`](../../scripts) | データパイプライン：Scryfallバルク → SQLite。GitHub Actions上でのみ実行 |
| [`DesignSystem/`](../../DesignSystem) | デザイントークン、SVGマナアイコン、コンポーネント仕様 |
| [`docs/`](../../docs) | データアーキテクチャ、Forgeのアルゴリズム、スキャナーの設計 |

このプロジェクトを定義する決断がふたつあります。ひとつ：**エンジンは二重に存在する** — Pythonは実行可能でテスト済みの仕様、Dartはアプリに載る実装。食い違ったらPythonが正です。ふたつ：**データベースは自動で組み上がる** — ワークフローが毎月Scryfallバルクをダウンロードし、SQLiteを[release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest)として公開。アプリは初回起動時にそれを取得します。

```bash
cd engine-reference && python3 -m pytest tests/   # アルゴリズムのテスト（正準）
cd forge_engine && dart test                      # アプリ用エンジンのテスト
cd app && flutter test                            # アプリのテスト
```

<a id="roadmap"></a>
## 🗺️ ロードマップ

- [x] **フェーズ1 — 基礎**：カーブエンジンとバリデーター（Python + Dart）、デザインシステム、CI
- [x] **フェーズ2 — データ**：Scryfallバルク → SQLiteパイプライン、毎月の自動リリース付き
- [x] **フェーズ3 — ジェネレーター**：機能分類、テーマ、スコアリング、貪欲法による構築
- [x] **フェーズ4 — アプリ v0.2**：ES/EN検索付きコレクション、CSVインポーター、カルーセルとゲームプラン付きForge
- [x] **フェーズ5 — 一級品のデスクトップ**：ReleasesへのWindows/macOS/Linux自動ビルド、デッキ保存、キーボードショートカット、位置を覚えているウィンドウ
- [x] **フェーズ6 — 仕上げ**：価格とコレクション評価額、購入損益（P&L）、フォーマット別リーガル判定、**10言語完全対応**
- [x] **フェーズ7 — スキャナー**：CIで生成する知覚フィンガープリント＋ウェブカメラ/写真、100 %デバイス上で完結（[内部の仕組み](../reconocimiento-cartas.md)）
- [x] **フェーズ7½ — Forge v2**：確率的マナベース、安定性とカーブのスコア、部族/リアニメイトのテーマ、スタイルセレクター、ディープフォージ、スペイン語カード名
- [ ] **フェーズ8 — トレードとコミュニティ**：コレクション間の交換、それに[目安箱](https://github.com/AAlexmc/Manaforge/issues/new/choose)に届いた要望あれこれ
- [ ] **フェーズ9 — モバイル（コミュニティの声があれば）**：AndroidとiOS/TestFlight — コードは準備済み。足りないのはストアのアカウントだけ

<a id="contributing"></a>
## 🤝 コントリビュート

このプロジェクトはコミュニティのものになりたがっています。Flutterやコンピュータービジョン（スキャナーが待っています！）、デッキ構築理論に詳しい人も — ただ遊んでいてアイデアがある人も — issueとPRはいつでも開いています。コードのコメントはスペイン語で書かれていて、何かが壊れたら誰かが怒り出す前にCIが教えてくれます。

### 💡 目安箱

プログラミングの知識は不要です：アイデアやバグを見つけたら、[目安箱](https://github.com/AAlexmc/Manaforge/issues/new/choose)にどうぞ — 用途別のテンプレートがあって、1分で書けます。アプリ内からもアクセスできます：**設定 → このアプリ**。

<a id="donations"></a>
## 💜 寄付

ManaForgeは無料・広告なしで、この先もずっとそのままです（[ライセンス](#license)が販売を許していません）。それでも、もしForgeの組んだデッキが勝利をもたらしたなら、ふたつの崇高な大義に出資できます：鍛冶場の火を絶やさないためのコーヒー、そして私の厳密なフィールドワーク——*コレクター・ブースター*を剥いては、何も——**本当に何も**——当たらないことを確認し続ける研究です。データは「次の当たりレアも出ない」と告げていますが、希望は最後に追放されるものですから。

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="PayPalでコーヒーをおごる">
  </a>
</p>

マナがタップアウト気味でも大丈夫：いちばんの応援はアプリを使うこと、[目安箱](https://github.com/AAlexmc/Manaforge/issues/new/choose)で改善してほしい点を聞かせること、そしてリポジトリに⭐を付けることです — スターはクリンナップ・ステップに捨てなくていいのです。

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

## 🙏 クレジットと法的事項

カードのデータと画像は[Scryfall](https://scryfall.com)によるものです。彼らには永遠の感謝を（そして[APIリミット](https://scryfall.com/docs/api)への敬意を）。Magic: The Gathering、そのカードとイラストは**Wizards of the Coast**の財産です。ManaForgeは[Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy)に基づく**非公式**の無料ファンプロジェクトであり、Wizardsが制作・承認・後援するものではありません。

<a id="license"></a>
## 📄 ライセンス

[PolyForm Noncommercial 1.0.0](../../LICENSE)。平たく言うと：

- **できること**：使う、コピーする、改変する、共有する、自分のバージョンを公開する。条件はただひとつ、コードと一緒にライセンスも渡すこと。
- **できないこと**：販売したり、お金儲けに使ったりすること。アプリや改変版への課金も、有料の製品・サービスへの同梱も、企業の営利活動の中での利用もダメです。
- **できること**：自宅で使う、行きつけのカードショップで自分のカードのために使う……アプリを売ったり課金したりしない限りOK。

個人利用、学習、いじくり回し、趣味のプロジェクト、非営利団体：許可は要りません、どうぞご自由に。

注意：非商用の制限が付いたライセンスは、OSIの意味での「オープンソース」では**ありません**。これは*ソースアベイラブル*です：読める、いじれる、共有できる。ただし売ることはできません。

<p align="center">
  <sub>キッチンテーブルのプレイヤーたちが ❤️ とたっぷりのマナで作りました</sub><br/><br/>
  <img src="../../DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="../../DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="../../DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="../../DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="../../DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
