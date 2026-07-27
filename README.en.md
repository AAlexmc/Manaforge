<p align="center">
  <img src="docs/assets/banner.svg" alt="ManaForge — Scan your collection. Forge decks with the cards you already own." width="100%">
</p>

<p align="center"><b>🇬🇧 English</b> · <a href="README.md">🇪🇸 Español</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.fr.md">🇫🇷 Français</a> · <a href="README.it.md">🇮🇹 Italiano</a> · <a href="README.pt.md">🇵🇹 Português</a> · <a href="README.ru.md">🇷🇺 Русский</a> · <a href="README.zh.md">🇨🇳 中文</a> · <a href="README.ja.md">🇯🇵 日本語</a> · <a href="README.ko.md">🇰🇷 한국어</a></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="Card database"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="PolyForm Noncommercial 1.0.0 license"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="Cross-platform desktop">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="Free forever">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">Features</a></b> ·
  <b><a href="#download">Download</a></b> ·
  <b><a href="#architecture">Architecture</a></b> ·
  <b><a href="#roadmap">Roadmap</a></b> ·
  <b><a href="#contributing">Contributing</a></b>
</p>

> [!TIP]
> **"What decks can I build with what I ALREADY own?"** That's the question no Magic app answers well — and the only reason ManaForge exists. The others help you *catalogue* your box of cards; this one turns it into decks ready to shuffle.

We've all been there: a box full of cards from boosters, starter decks and inherited drawers… and no idea what to build with them. ManaForge is made by players, for players: **free, no ads, no premium, no accounts, and with all the code out in the open.**

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge: the deck generator

Hand it your collection and it gives you back **complete 60-card decks**, built the way a veteran player would build them. This is how it thinks:

<p align="center">
  <img src="docs/assets/forge-flow.svg" alt="Collection → Synergies → Mana curve → Validator → Decks with a game plan" width="100%">
</p>

- 🏔️ **A proper mana curve** — lands per archetype, sources split by colour symbols, curve validated. No 15-land decks here.
- 🧬 **Synergies detected** — Forge reads every card's rules text and finds your themes: life drain, sacrifice, artifacts, go-wide, spellslinger, counters…
- 🗺️ **A game plan, explained** — turn by turn, plus a collapsible *"Why does this deck work?"* for anyone who wants the theory.
- 🤝 **Rules of honour** — it never uses cards you don't own, never breaks the copy limit, and rather than generate a broken deck it explains why and suggests an alternative.
- 🎯 **Pick your style** — force a tribe (Elves, Zombies, Dragons… 24 curated ones, plus any subtype with enough bodies) or a mechanical theme, and the engine obeys. On Auto, it detects whichever your collection pays off best.
- ⚔️ **Deep forge** — before being shown, the candidate decks play hundreds of games against each other: the final ranking weighs how they actually perform, not just their score on paper.
- 🎲 **Real probability** — consistency (do you draw your lands on time?) and playable curve computed with hypergeometric maths; non-basic lands (shocks, checks, fetches) count for what they actually do.
- 📤 **One-tap export** — copy the list and paste it into Moxfield, MTG Arena or your playgroup's Discord.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>The real collection ManaForge was born from — the generator turned these cards (and 280 more) into five playable decks.</i></sub></p>

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ What it does today

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>All of Magic's history<br/>in your pocket</b><br/><br/>
      <sub>Complete card database (Scryfall bulk → SQLite) that rebuilds itself every month in CI. Download it once and everything works <b>offline</b>.</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>Search in<br/>Spanish and English</b><br/><br/>
      <sub>"Elfos de Llanowar", "elfos de llanowar" without accents, or "Llanowar Elves": they all lead to the same card. And with the app in Spanish, decks and card views show the Spanish names.</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>Your collection,<br/>visual and yours</b><br/><br/>
      <sub><b>Scan cards with your webcam</b> (it recognises the exact printing by the art), <b>import your CSV</b> from any other app, or add them by hand. Everything stays local: no accounts, no mandatory cloud.</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>Several proposals in a comparable carousel, a detail view with a turn-by-turn game plan, an editable curve that reforges the deck, and a Test Mode to pit it against another.</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>Careful design</b><br/><br/>
      <sub>Dark theme, <b>10 complete languages</b>, guided tours that show the app from the inside, colour-blind-friendly mana iconography and player-to-player microcopy.</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>Privacy by default</b><br/><br/>
      <sub>No analytics, no tracking, no "create your account". The scanner recognises cards 100 % on your device.</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **In the oven:** trades between collections, card names in more languages, and mobile if the community asks for it.

<a id="download"></a>
## 🚀 Download and open it

Go to [**Releases**](https://github.com/AAlexmc/Manaforge/releases) and grab the zip for your system. No installer, no accounts: unzip and open.

| System | What to do |
|---|---|
| **Windows** | Unzip and, inside the `ManaForge` folder, open `manaforge.exe`. The first time, Windows will warn that it doesn't know the program: *More info → Run anyway* (it isn't signed; the code is right here for you to inspect). |
| **macOS** | Unzip and open it once (you'll get a warning); then go to *System Settings → Privacy & Security → Open Anyway*. (Since macOS 15, right-click → Open no longer bypasses the warning.) |
| **Linux** | Unzip and, inside the `ManaForge` folder, run `./manaforge`. To get it in your app menu with its icon: `./instalar.sh` (everything goes to `~/.local`, no sudo; remove it with `./instalar.sh --desinstalar`). |

**Verify what you downloaded**: every release publishes `SHA256SUMS.txt` with the fingerprint of the three zips. On Linux or macOS, `sha256sum -c SHA256SUMS.txt` (or `shasum -a 256 -c`); on Windows, `Get-FileHash ManaForge-Windows.zip`.

On first launch the app downloads **~36 MB** of data (Scryfall cards and prices, price history and scanner fingerprints) and shows you the progress. From then on it works offline.

Then: **import your collection** from a CSV, **scan** cards with the webcam or a photo, or go straight to **⚒️ Forge** and build a deck from a given collection even before you have one.

### Prefer to build it yourself?

```bash
# Flutter, stable channel: https://docs.flutter.dev/get-started/install
# (on Windows you need Visual Studio with "Desktop development with C++")
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # or -d windows / -d macos
```

The native wrappers for Linux, Windows and macOS plus the `pubspec.lock` are in the repo, so it builds as-is on all three.

<a id="architecture"></a>
## 🔧 How it's built

| Folder | What lives there |
|---|---|
| [`app/`](app) | The Flutter app — one codebase for Windows, macOS and Linux (and mobile someday) |
| [`forge_engine/`](forge_engine) | The deck engine in Dart: curve, validator, classifier and generator |
| [`engine-reference/`](engine-reference) | The same engine in Python: the **canonical, tested reference** for the algorithm |
| [`scripts/`](scripts) | Data pipeline: Scryfall bulk → SQLite, run only on GitHub Actions |
| [`DesignSystem/`](DesignSystem) | Design tokens, SVG mana icons and component specs |
| [`docs/`](docs) | Data architecture, the Forge algorithm and the scanner design |

Two decisions define the project. One: **the engine exists twice** — Python as an executable, tested specification, Dart as the implementation that ships in the app; if they diverge, Python wins. Two: **the database builds itself** — a workflow downloads the Scryfall bulk every month and publishes the SQLite as a [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest), which the app downloads on first launch.

```bash
cd engine-reference && python3 -m pytest tests/   # algorithm tests (canonical)
cd forge_engine && dart test                      # app engine tests
cd app && flutter test                            # app tests
```

<a id="roadmap"></a>
## 🗺️ Roadmap

- [x] **Phase 1 — Foundations**: curve engine and validator (Python + Dart), design system, CI
- [x] **Phase 2 — Data**: Scryfall bulk → SQLite pipeline with automatic monthly release
- [x] **Phase 3 — Generator**: functional classification, themes, scoring and greedy construction
- [x] **Phase 4 — App v0.2**: collection with ES/EN search, CSV importer, Forge with carousel and game plan
- [x] **Phase 5 — First-class desktop**: automatic Windows/macOS/Linux builds in Releases, saved decks, keyboard shortcuts and a window that remembers its place
- [x] **Phase 6 — Rounding off**: prices and collection value, purchase P&L, per-format legalities and **10 complete languages**
- [x] **Phase 7 — Scanner**: perceptual fingerprints generated in CI + webcam/photo, 100 % on-device ([how it works inside](docs/reconocimiento-cartas.md))
- [x] **Phase 7½ — Forge v2**: probabilistic manabase, consistency-and-curve score, tribal/reanimator themes, style selector, deep forge and Spanish card names
- [ ] **Phase 8 — Trades and community**: swaps between collections plus whatever the [suggestion box](https://github.com/AAlexmc/Manaforge/issues/new/choose) asks for
- [ ] **Phase 9 — Mobile (if the community asks)**: Android and iOS/TestFlight — the code is ready; only the store accounts are missing

<a id="contributing"></a>
## 🤝 Contributing

This project wants to belong to the community. If you know Flutter, computer vision (the scanner awaits!), deck-building theory — or you simply play and have ideas — issues and PRs are open. The code is commented in Spanish, and CI will warn you if something breaks before anyone gets upset.

### 💡 Suggestion box

No coding required: if you have an idea or found a bug, drop it in the [suggestion box](https://github.com/AAlexmc/Manaforge/issues/new/choose) — there's a template for each and it takes a minute. You can also reach it from inside the app: **Settings → The app**.

<a id="donations"></a>
## 💜 Donations

ManaForge is free and ad-free, and it's going to stay that way (the [license](#license) doesn't allow selling it). But if Forge ever built you the deck that won the game, you can fund two noble causes: the coffee that keeps the forge lit, and my rigorous field research consisting of opening *collector boosters* where nothing — **ever** — hits. The data says the next chase rare isn't coming; hope is the last thing to be exiled.

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="Buy me a coffee via PayPal">
  </a>
</p>

And if your mana is tapped out, the best way to support the project is to use it, tell me what you'd improve in the [suggestion box](https://github.com/AAlexmc/Manaforge/issues/new/choose) and give the repo a ⭐ — stars aren't discarded at end of turn.

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## 🙏 Credits and legal

Card data and imagery come from [Scryfall](https://scryfall.com), to whom we owe eternal gratitude (and respect for their [API limits](https://scryfall.com/docs/api)). Magic: The Gathering, its cards and illustrations are property of **Wizards of the Coast**. ManaForge is an **unofficial**, free fan project under the [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy); it is not produced, endorsed or sponsored by Wizards.

<a id="license"></a>
## 📄 License

[PolyForm Noncommercial 1.0.0](LICENSE). In plain words:

- **You can** use it, copy it, modify it, share it and publish your own versions, on the sole condition of passing the license along with the code.
- **You cannot** sell it or use it to make money: no charging for the app or a modified version, no bundling it into a paid product or service, no using it inside a business for its commercial activity.
- **You can** use it at home, or in your local game store for your own cards… as long as you're not selling the app or charging for it.

Personal use, study, tinkering, hobby projects and non-profits: go ahead, no permission needed.

Heads-up: a license with a non-commercial restriction is **not** "open source" in the OSI sense. It's *source-available*: you can read it, tweak it and share it, but not sell it.

<p align="center">
  <sub>Made with ❤️ and plenty of mana by kitchen-table players</sub><br/><br/>
  <img src="DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
