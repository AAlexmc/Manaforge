<p align="center">
  <img src="docs/assets/banner.svg" alt="ManaForge — 扫描你的收藏，用你已经拥有的牌锻造套牌。" width="100%">
</p>

<p align="center"><a href="README.en.md">🇬🇧 English</a> · <a href="README.md">🇪🇸 Español</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.fr.md">🇫🇷 Français</a> · <a href="README.it.md">🇮🇹 Italiano</a> · <a href="README.pt.md">🇵🇹 Português</a> · <a href="README.ru.md">🇷🇺 Русский</a> · <b>🇨🇳 中文</b> · <a href="README.ja.md">🇯🇵 日本語</a> · <a href="README.ko.md">🇰🇷 한국어</a></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="牌张数据库"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="PolyForm Noncommercial 1.0.0 许可证"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="跨平台桌面应用">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="永久免费">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">功能</a></b> ·
  <b><a href="#download">下载</a></b> ·
  <b><a href="#architecture">架构</a></b> ·
  <b><a href="#roadmap">路线图</a></b> ·
  <b><a href="#contributing">参与贡献</a></b>
</p>

> [!TIP]
> **“用我手里已经有的牌，能组出什么套牌？”** 这是没有一款万智牌应用能答好的问题——也是 ManaForge 存在的唯一理由。别的应用帮你把那箱牌*编目归档*；这一款把它变成洗好就能开打的套牌。

谁都经历过：一箱子来自补充包、新手套牌和亲戚抽屉的牌……却完全不知道能拿它们组什么。ManaForge 由玩家打造、为玩家服务：**免费、无广告、无付费内容、无账号，全部代码公开可查。**

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge：套牌生成器

把收藏交给它，它还你**完整的 60 张套牌**，组法和老玩家如出一辙。它是这样思考的：

<p align="center">
  <img src="docs/assets/forge-flow.svg" alt="收藏 → 协同 → 法术力曲线 → 校验器 → 带对局计划的套牌" width="100%">
</p>

- 🏔️ **像样的法术力曲线** — 地牌数量按原型配置，法术力来源按颜色符号分配，曲线经过校验。这里没有 15 块地的套牌。
- 🧬 **自动侦测协同** — Forge 会读每张牌的规则叙述，找出你的主题：生命吸取、牺牲、神器、铺场、咒语流、指示物……
- 🗺️ **对局计划讲给你听** — 逐回合展开，还附一个可折叠的*“这套牌为什么能赢？”*，留给想钻研理论的人。
- 🤝 **荣誉守则** — 绝不使用你没有的牌，绝不突破同名牌数量上限；与其硬凑一套残缺的套牌，它宁可解释原因并提出替代方案。
- 🎯 **选你的风格** — 指定一个部族（妖精、灵俑、龙……24 个精选部族，外加任何生物数量足够的副类别）或一个机制主题，引擎照办。选 Auto 时，它会自动侦测你的收藏最能兑现的方向。
- ⚔️ **深度锻造** — 候选套牌在亮相之前，要先互相打上数百场对局：最终排名看它们实际的表现，而不只是纸面分数。
- 🎲 **真正的概率** — 稳定性（地牌抓得及时吗？）和可施放曲线用超几何数学计算；非基本地（震地、检地、费地）按其实际功能计入。
- 📤 **一键导出** — 复制牌表，粘贴到 Moxfield、MTG Arena 或牌友群的 Discord。

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>ManaForge 就诞生自这套真实收藏——生成器把这些牌（连同另外 280 张）变成了五套能上桌的套牌。</i></sub></p>

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ 现在就能做什么

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>万智牌的全部历史<br/>装进口袋</b><br/><br/>
      <sub>完整牌张数据库（Scryfall bulk → SQLite），每月在 CI 中自动重建。下载一次，之后一切<b>离线</b>可用。</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>西班牙语和英语<br/>双语搜索</b><br/><br/>
      <sub>“Elfos de Llanowar”、不带重音的 “elfos de llanowar”，还是 “Llanowar Elves”：都指向同一张牌。应用设为西班牙语时，套牌和牌张页面会显示西班牙语牌名。</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>你的收藏，<br/>可视化且归你所有</b><br/><br/>
      <sub><b>用摄像头扫描牌张</b>（凭插画识别出具体印刷版本），从任何其他应用<b>导入 CSV</b>，或手动添加。一切都留在本地：无账号，无强制云端。</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>多套方案放进可对比的轮播，详情页附逐回合对局计划，可编辑的曲线会重新锻造套牌，还有测试模式让它和另一套对打。</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>用心的设计</b><br/><br/>
      <sub>深色主题、<b>10 种完整语言</b>、带你逛遍应用内部的引导之旅、色盲友好的法术力图标，以及玩家对玩家口吻的界面文案。</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>默认隐私</b><br/><br/>
      <sub>没有数据分析，没有追踪，没有“请注册账号”。扫描器 100 % 在你的设备上完成识别。</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **炉子里还烤着：** 收藏之间的牌张交换、更多语言的牌名，以及——如果社区想要——移动版。

<a id="download"></a>
## 🚀 下载即用

前往 [**Releases**](https://github.com/AAlexmc/Manaforge/releases)，下载对应系统的 zip。没有安装程序，没有账号：解压即开。

| 系统 | 怎么做 |
|---|---|
| **Windows** | 解压后，在 `ManaForge` 文件夹里打开 `manaforge.exe`。第一次 Windows 会提示不认识这个程序：*更多信息 → 仍要运行*（应用未签名；代码就在这里，欢迎检查）。 |
| **macOS** | 解压后先打开一次（会弹出警告）；然后前往*系统设置 → 隐私与安全性 → 仍要打开*。（自 macOS 15 起，右键 → 打开已经绕不过这个警告了。） |
| **Linux** | 解压后，在 `ManaForge` 文件夹里运行 `./manaforge`。想让它带图标出现在应用菜单里：`./instalar.sh`（全部装进 `~/.local`，无需 sudo；用 `./instalar.sh --desinstalar` 卸载）。 |

**校验下载内容**：每个 release 都发布 `SHA256SUMS.txt`，含三个 zip 的指纹。Linux 或 macOS 上执行 `sha256sum -c SHA256SUMS.txt`（或 `shasum -a 256 -c`）；Windows 上执行 `Get-FileHash ManaForge-Windows.zip`。

首次启动时，应用会下载 **约 36 MB** 数据（Scryfall 牌张与价格、价格历史和扫描器指纹），并显示进度。之后即可离线使用。

接下来：从 CSV **导入收藏**，用摄像头或照片**扫描**牌张，或者直接进 **⚒️ Forge**——哪怕自己还没有收藏，也可以用一份给定的收藏先锻一套。

### 更想自己编译？

```bash
# Flutter，stable 频道：https://docs.flutter.dev/get-started/install
# （Windows 上需要装有“使用 C++ 的桌面开发”的 Visual Studio）
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # 或 -d windows / -d macos
```

Linux、Windows 和 macOS 的原生外壳连同 `pubspec.lock` 都在仓库里，三个平台开箱即可编译。

<a id="architecture"></a>
## 🔧 它是怎么造的

| 文件夹 | 里面住着什么 |
|---|---|
| [`app/`](app) | Flutter 应用——一套代码通吃 Windows、macOS 和 Linux（说不定哪天还有移动端） |
| [`forge_engine/`](forge_engine) | Dart 版套牌引擎：曲线、校验器、分类器和生成器 |
| [`engine-reference/`](engine-reference) | 同一引擎的 Python 版：算法**经过测试的规范参考** |
| [`scripts/`](scripts) | 数据管线：Scryfall bulk → SQLite，只在 GitHub Actions 上运行 |
| [`DesignSystem/`](DesignSystem) | 设计令牌、SVG 法术力图标和组件规格 |
| [`docs/`](docs) | 数据架构、Forge 算法和扫描器设计 |

两个决定塑造了整个项目。其一：**引擎存在两份** —— Python 是可执行、带测试的规范，Dart 是随应用出货的实现；两者分歧时，以 Python 为准。其二：**数据库自己构建自己** —— 一个 workflow 每月下载 Scryfall bulk，并把 SQLite 发布为 [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest)，应用首次启动时下载它。

```bash
cd engine-reference && python3 -m pytest tests/   # 算法测试（规范）
cd forge_engine && dart test                      # 应用引擎测试
cd app && flutter test                            # 应用测试
```

<a id="roadmap"></a>
## 🗺️ 路线图

- [x] **第 1 阶段 — 地基**：曲线引擎与校验器（Python + Dart）、设计系统、CI
- [x] **第 2 阶段 — 数据**：Scryfall bulk → SQLite 管线，每月自动发布 release
- [x] **第 3 阶段 — 生成器**：功能分类、主题、评分与贪心构建
- [x] **第 4 阶段 — 应用 v0.2**：支持西/英搜索的收藏、CSV 导入器、带轮播和对局计划的 Forge
- [x] **第 5 阶段 — 一流桌面体验**：Releases 中的 Windows/macOS/Linux 自动构建、套牌保存、键盘快捷键和记住自己位置的窗口
- [x] **第 6 阶段 — 打磨收尾**：价格与收藏估值、购入盈亏、各赛制合法性和 **10 种完整语言**
- [x] **第 7 阶段 — 扫描器**：CI 生成的感知指纹 + 摄像头/照片，100 % 本机运行（[内部原理](docs/reconocimiento-cartas.md)）
- [x] **第 7½ 阶段 — Forge v2**：概率化地基、稳定性加曲线评分、部族/复生主题、风格选择器、深度锻造和西班牙语牌名
- [ ] **第 8 阶段 — 交换与社区**：收藏之间的牌张交换，外加[意见箱](https://github.com/AAlexmc/Manaforge/issues/new/choose)里大家想要的一切
- [ ] **第 9 阶段 — 移动端（如果社区想要）**：Android 和 iOS/TestFlight——代码已就绪，只差商店账号

<a id="contributing"></a>
## 🤝 参与贡献

这个项目想属于社区。懂 Flutter、懂计算机视觉（扫描器在等你！）、懂套牌构筑理论——或者你只是玩牌并且有想法——issue 和 PR 都敞开着。代码注释是西班牙语写的，CI 会在有人不开心之前告诉你哪里坏了。

### 💡 意见箱

不需要会写代码：有想法或发现 bug，丢进[意见箱](https://github.com/AAlexmc/Manaforge/issues/new/choose)就行——每种情况都有模板，一分钟填完。也可以从应用内直达：**设置 → 本应用**。

<a id="donations"></a>
## 💜 捐助

ManaForge 免费且无广告，并且会一直如此（[许可证](#license)不允许出售它）。但如果 Forge 曾为你锻出那套赢下对局的套牌，你可以资助两项崇高事业：让熔炉之火不灭的咖啡，以及我严谨的田野调查——内容是拆*珍藏补充包*，然后什么都——**永远**——开不出来。数据表明下一张大热稀有牌不会现身；可希望这东西，总是最后一个被放逐的。

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="通过 PayPal 请我喝杯咖啡">
  </a>
</p>

如果你的法术力已经全横置了，支持项目的最好方式就是使用它、到[意见箱](https://github.com/AAlexmc/Manaforge/issues/new/choose)说说你想改进什么，再给仓库一颗 ⭐——星星不会在回合结束时被弃掉。

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## 🙏 致谢与法律声明

牌张数据与图像来自 [Scryfall](https://scryfall.com)，我们对他们感激不尽（也请尊重他们的 [API 限制](https://scryfall.com/docs/api)）。Magic: The Gathering（万智牌）及其牌张与插画归 **Wizards of the Coast** 所有。ManaForge 是遵循 [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy) 的**非官方**免费粉丝项目；未经 Wizards 制作、认可或赞助。

<a id="license"></a>
## 📄 许可证

[PolyForm Noncommercial 1.0.0](LICENSE)。说人话就是：

- **可以**使用、复制、修改、分享并发布你自己的版本，唯一条件是把许可证随代码一起传递。
- **不可以**出售它或用它赚钱：不能对应用或其修改版收费，不能把它捆进付费产品或服务，也不能在企业里将其用于商业经营。
- **可以**在家使用，也可以在你的本地牌店里管理自己的牌……只要不是卖这个应用或靠它收费。

个人使用、学习、折腾、业余项目和非营利组织：请便，无需许可。

提醒一句：带非商业限制的许可证**不是** OSI 意义上的“开源”。它属于 *source-available*（源码可见）：可以阅读、修改、分享，但不能出售。

<p align="center">
  <sub>由厨房餐桌旁的玩家们用 ❤️ 和大量法术力打造</sub><br/><br/>
  <img src="DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
