<p align="center">
  <img src="../assets/banner.svg" alt="ManaForge — Scanne deine Sammlung. Schmiede Decks aus den Karten, die du schon besitzt." width="100%">
</p>

<p align="center"><a href="README.en.md">🇬🇧 English</a> · <a href="../../README.md">🇪🇸 Español</a> · <b>🇩🇪 Deutsch</b> · <a href="README.fr.md">🇫🇷 Français</a> · <a href="README.it.md">🇮🇹 Italiano</a> · <a href="README.pt.md">🇵🇹 Português</a> · <a href="README.ru.md">🇷🇺 Русский</a> · <a href="README.zh.md">🇨🇳 中文</a> · <a href="README.ja.md">🇯🇵 日本語</a> · <a href="README.ko.md">🇰🇷 한국어</a></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="Kartendatenbank"></a>
  <a href="../../LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="Lizenz PolyForm Noncommercial 1.0.0"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="Plattformübergreifender Desktop">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="Für immer kostenlos">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">Features</a></b> ·
  <b><a href="#download">Download</a></b> ·
  <b><a href="#architecture">Architektur</a></b> ·
  <b><a href="#roadmap">Roadmap</a></b> ·
  <b><a href="#contributing">Mitmachen</a></b>
</p>

> [!TIP]
> **„Welche Decks kann ich mit dem bauen, was ich SCHON besitze?“** Das ist die Frage, die keine Magic-App gut beantwortet — und der einzige Grund, warum es ManaForge gibt. Die anderen helfen dir, deine Kartenkiste zu *katalogisieren*; diese hier macht daraus Decks, die bereit zum Mischen sind.

Wir kennen es alle: eine Kiste voller Karten aus Boostern, Einsteigerdecks und geerbten Schubladen … und keine Ahnung, was man daraus bauen soll. ManaForge ist von Spielern für Spieler gemacht: **kostenlos, ohne Werbung, ohne Premium, ohne Konten und mit komplett offenem Code.**

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge: der Deck-Generator

Gib ihm deine Sammlung und du bekommst **komplette 60-Karten-Decks** zurück — gebaut, wie ein erfahrener Spieler sie bauen würde. So denkt es:

<p align="center">
  <img src="../assets/forge-flow.svg" alt="Sammlung → Synergien → Manakurve → Validator → Decks mit Spielplan" width="100%">
</p>

- 🏔️ **Eine saubere Manakurve** — Länder passend zum Archetyp, Quellen nach Farbsymbolen verteilt, Kurve validiert. Keine 15-Länder-Decks hier.
- 🧬 **Synergien erkannt** — Forge liest den Regeltext jeder Karte und findet deine Themen: Lebensentzug, Opfern, Artefakte, Go-wide, Spellslinger, Marken …
- 🗺️ **Ein Spielplan, erklärt** — Zug für Zug, plus ein ausklappbares *„Warum funktioniert dieses Deck?“* für alle, die die Theorie dahinter wollen.
- 🤝 **Ehrenkodex** — es benutzt nie Karten, die du nicht besitzt, überschreitet nie das Kopienlimit, und statt ein kaputtes Deck zu generieren, erklärt es dir warum und schlägt eine Alternative vor.
- 🎯 **Wähl deinen Stil** — erzwinge einen Stamm (Elfen, Zombies, Drachen … 24 kuratierte, plus jeden Untertyp mit genug Kreaturen) oder ein mechanisches Thema, und die Engine gehorcht. Auf Auto erkennt sie, was deine Sammlung am besten hergibt.
- ⚔️ **Tiefenschmiede** — bevor sie dir gezeigt werden, spielen die Deck-Kandidaten Hunderte Partien gegeneinander: Die endgültige Rangfolge gewichtet, wie sie wirklich performen, nicht nur ihre Punktzahl auf dem Papier.
- 🎲 **Echte Wahrscheinlichkeit** — Konsistenz (ziehst du deine Länder rechtzeitig?) und spielbare Kurve, berechnet mit hypergeometrischer Mathematik; Nichtstandardländer (Shocklands, Checklands, Fetchlands) zählen für das, was sie wirklich leisten.
- 📤 **Export mit einem Tipp** — kopiere die Liste und füge sie in Moxfield, MTG Arena oder den Discord deiner Spielgruppe ein.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>Die echte Sammlung, aus der ManaForge geboren wurde — der Generator machte aus diesen Karten (und 280 weiteren) fünf spielbare Decks.</i></sub></p>

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ Was es heute kann

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>Die ganze Geschichte von Magic<br/>in deiner Tasche</b><br/><br/>
      <sub>Komplette Kartendatenbank (Scryfall-Bulk → SQLite), die sich jeden Monat in der CI selbst neu baut. Einmal herunterladen, und alles funktioniert <b>offline</b>.</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>Suche auf<br/>Spanisch und Englisch</b><br/><br/>
      <sub>„Elfos de Llanowar“, „elfos de llanowar“ ohne Akzente oder „Llanowar Elves“: Alle führen zur selben Karte. Und mit der App auf Spanisch zeigen Decks und Kartenansichten die spanischen Namen.</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>Deine Sammlung,<br/>visuell und ganz deine</b><br/><br/>
      <sub><b>Scanne Karten mit deiner Webcam</b> (sie erkennt den genauen Druck am Artwork), <b>importiere dein CSV</b> aus jeder anderen App oder füge sie von Hand hinzu. Alles bleibt lokal: keine Konten, keine Cloud-Pflicht.</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>Mehrere Vorschläge in einem vergleichbaren Karussell, eine Detailansicht mit Spielplan Zug für Zug, eine editierbare Kurve, die das Deck neu schmiedet, und ein Testmodus, um es gegen ein anderes antreten zu lassen.</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>Design mit Liebe</b><br/><br/>
      <sub>Dunkles Theme, <b>10 vollständige Sprachen</b>, geführte Touren, die die App von innen zeigen, farbenblind-freundliche Mana-Ikonografie und Microcopy von Spieler zu Spieler.</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>Privatsphäre ab Werk</b><br/><br/>
      <sub>Keine Analytics, kein Tracking, kein „Erstell dein Konto“. Der Scanner erkennt Karten zu 100 % auf deinem Gerät.</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **Im Ofen:** Trades zwischen Sammlungen, Kartennamen in weiteren Sprachen und Mobile, wenn die Community danach fragt.

<a id="download"></a>
## 🚀 Herunterladen und loslegen

Geh zu [**Releases**](https://github.com/AAlexmc/Manaforge/releases) und schnapp dir das Zip für dein System. Kein Installer, keine Konten: entpacken und öffnen.

| System | Was zu tun ist |
|---|---|
| **Windows** | Entpacke das Zip und öffne im Ordner `ManaForge` die Datei `manaforge.exe`. Beim ersten Mal warnt Windows, dass es das Programm nicht kennt: *Weitere Informationen → Trotzdem ausführen* (es ist nicht signiert; der Code liegt genau hier, damit du ihn prüfen kannst). |
| **macOS** | Entpacke das Zip und öffne die App einmal (du bekommst eine Warnung); geh danach zu *Systemeinstellungen → Datenschutz & Sicherheit → Dennoch öffnen*. (Seit macOS 15 umgeht Rechtsklick → Öffnen die Warnung nicht mehr.) |
| **Linux** | Entpacke das Zip und führe im Ordner `ManaForge` `./manaforge` aus. Damit sie mit Icon im App-Menü auftaucht: `./instalar.sh` (alles landet in `~/.local`, kein sudo; entfernen mit `./instalar.sh --desinstalar`). |

**Prüfe, was du heruntergeladen hast**: Jedes Release veröffentlicht `SHA256SUMS.txt` mit dem Fingerabdruck der drei Zips. Unter Linux oder macOS: `sha256sum -c SHA256SUMS.txt` (oder `shasum -a 256 -c`); unter Windows: `Get-FileHash ManaForge-Windows.zip`.

Beim ersten Start lädt die App **~36 MB** Daten herunter (Scryfall-Karten und -Preise, Preishistorie und Scanner-Fingerabdrücke) und zeigt dir den Fortschritt. Ab dann funktioniert sie offline.

Danach: **importiere deine Sammlung** aus einem CSV, **scanne** Karten mit der Webcam oder einem Foto, oder geh direkt zu **⚒️ Forge** und baue ein Deck aus einer gegebenen Sammlung, noch bevor du selbst eine hast.

### Lieber selbst kompilieren?

```bash
# Flutter, Stable-Channel: https://docs.flutter.dev/get-started/install
# (unter Windows brauchst du Visual Studio mit „Desktopentwicklung mit C++“)
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # oder -d windows / -d macos
```

Die nativen Wrapper für Linux, Windows und macOS sowie die `pubspec.lock` liegen im Repo, also baut es auf allen dreien ohne weiteres Zutun.

<a id="architecture"></a>
## 🔧 Wie es gebaut ist

| Ordner | Was dort lebt |
|---|---|
| [`app/`](../../app) | Die Flutter-App — eine Codebasis für Windows, macOS und Linux (und irgendwann Mobile) |
| [`forge_engine/`](../../forge_engine) | Die Deck-Engine in Dart: Kurve, Validator, Klassifikator und Generator |
| [`engine-reference/`](../../engine-reference) | Dieselbe Engine in Python: die **kanonische, getestete Referenz** des Algorithmus |
| [`scripts/`](../../scripts) | Daten-Pipeline: Scryfall-Bulk → SQLite, läuft nur auf GitHub Actions |
| [`DesignSystem/`](../../DesignSystem) | Design-Tokens, SVG-Mana-Icons und Komponenten-Spezifikationen |
| [`docs/`](../../docs) | Datenarchitektur, der Forge-Algorithmus und das Scanner-Design |

Zwei Entscheidungen definieren das Projekt. Erstens: **Die Engine existiert doppelt** — Python als ausführbare, getestete Spezifikation, Dart als Implementierung, die in der App ausgeliefert wird; wenn sie auseinanderlaufen, gewinnt Python. Zweitens: **Die Datenbank baut sich selbst** — ein Workflow lädt jeden Monat den Scryfall-Bulk herunter und veröffentlicht die SQLite als [Release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest), die die App beim ersten Start herunterlädt.

```bash
cd engine-reference && python3 -m pytest tests/   # Algorithmus-Tests (kanonisch)
cd forge_engine && dart test                      # Tests der App-Engine
cd app && flutter test                            # App-Tests
```

<a id="roadmap"></a>
## 🗺️ Roadmap

- [x] **Phase 1 — Fundament**: Kurven-Engine und Validator (Python + Dart), Designsystem, CI
- [x] **Phase 2 — Daten**: Scryfall-Bulk → SQLite-Pipeline mit automatischem monatlichem Release
- [x] **Phase 3 — Generator**: funktionale Klassifikation, Themen, Scoring und Greedy-Konstruktion
- [x] **Phase 4 — App v0.2**: Sammlung mit ES/EN-Suche, CSV-Importer, Forge mit Karussell und Spielplan
- [x] **Phase 5 — Desktop erster Klasse**: automatische Windows/macOS/Linux-Builds in den Releases, gespeicherte Decks, Tastaturkürzel und ein Fenster, das sich seinen Platz merkt
- [x] **Phase 6 — Abrunden**: Preise und Sammlungswert, Kauf-P&L, Legalität pro Format und **10 vollständige Sprachen**
- [x] **Phase 7 — Scanner**: perzeptuelle Fingerabdrücke aus der CI + Webcam/Foto, 100 % auf dem Gerät ([wie es von innen funktioniert](../reconocimiento-cartas.md))
- [x] **Phase 7½ — Forge v2**: probabilistische Manabasis, Score aus Konsistenz und Kurve, Stammes-/Reanimator-Themen, Stil-Auswahl, Tiefenschmiede und spanische Kartennamen
- [ ] **Phase 8 — Trades und Community**: Tausch zwischen Sammlungen plus alles, was der [Vorschlagskasten](https://github.com/AAlexmc/Manaforge/issues/new/choose) verlangt
- [ ] **Phase 9 — Mobile (wenn die Community fragt)**: Android und iOS/TestFlight — der Code ist bereit; nur die Store-Konten fehlen

<a id="contributing"></a>
## 🤝 Mitmachen

Dieses Projekt will der Community gehören. Wenn du dich mit Flutter auskennst, mit Computer Vision (der Scanner wartet auf dich!), mit Deckbau-Theorie — oder einfach spielst und Ideen hast — Issues und PRs sind offen. Der Code ist auf Spanisch kommentiert, und die CI warnt dich, wenn etwas kaputtgeht, bevor sich jemand ärgert.

### 💡 Vorschlagskasten

Programmieren ist nicht nötig: Wenn du eine Idee hast oder einen Fehler gefunden hast, wirf sie in den [Vorschlagskasten](https://github.com/AAlexmc/Manaforge/issues/new/choose) — es gibt für beides eine Vorlage, und es dauert eine Minute. Du erreichst ihn auch aus der App heraus: **Einstellungen → Die App**.

<a id="donations"></a>
## 💜 Spenden

ManaForge ist kostenlos und werbefrei, und das bleibt auch so (die [Lizenz](#license) erlaubt den Verkauf nicht). Aber wenn Forge dir jemals das Deck geschmiedet hat, das die Partie gewonnen hat, kannst du zwei edle Zwecke finanzieren: den Kaffee, der die Schmiede am Glühen hält, und meine rigorose Feldforschung, die darin besteht, *Collector Booster* zu öffnen, in denen niemals — **niemals** — etwas drin ist. Die Daten sagen, die nächste Chase-Rare kommt nicht; die Hoffnung wird als Letztes ins Exil geschickt.

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="Spendier mir einen Kaffee via PayPal">
  </a>
</p>

Und wenn dein Mana gerade komplett getappt ist: Die beste Art, das Projekt zu unterstützen, ist es zu benutzen, mir im [Vorschlagskasten](https://github.com/AAlexmc/Manaforge/issues/new/choose) zu erzählen, was du verbessern würdest, und dem Repo einen ⭐ zu geben — Sterne werden am Ende des Zuges nicht abgeworfen.

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

## 🙏 Credits und Rechtliches

Kartendaten und -bilder stammen von [Scryfall](https://scryfall.com), denen wir ewige Dankbarkeit schulden (und Respekt vor ihren [API-Limits](https://scryfall.com/docs/api)). Magic: The Gathering, seine Karten und Illustrationen sind Eigentum von **Wizards of the Coast**. ManaForge ist ein **inoffizielles**, kostenloses Fan-Projekt im Rahmen der [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy); es wird nicht von Wizards produziert, unterstützt oder gesponsert.

<a id="license"></a>
## 📄 Lizenz

[PolyForm Noncommercial 1.0.0](../../LICENSE). Auf gut Deutsch:

- **Du darfst** sie benutzen, kopieren, verändern, teilen und deine eigenen Versionen veröffentlichen — unter der einzigen Bedingung, die Lizenz zusammen mit dem Code weiterzugeben.
- **Du darfst nicht** damit Geld verdienen: kein Geld für die App oder eine modifizierte Version verlangen, sie nicht in ein kostenpflichtiges Produkt oder einen Dienst packen, sie nicht in einem Unternehmen für dessen kommerzielle Tätigkeit einsetzen.
- **Du darfst** sie zu Hause benutzen, oder im Laden um die Ecke für deine eigenen Karten … solange du die App nicht verkaufst und kein Geld dafür verlangst.

Privater Gebrauch, Studium, Basteln, Hobbyprojekte und gemeinnützige Organisationen: nur zu, keine Erlaubnis nötig.

Achtung: Eine Lizenz mit nichtkommerzieller Einschränkung ist **nicht** „Open Source“ im Sinne der OSI. Sie ist *source-available*: Du kannst den Code lesen, anpassen und teilen, aber nicht verkaufen.

<p align="center">
  <sub>Gemacht mit ❤️ und jeder Menge Mana von Küchentisch-Spielern</sub><br/><br/>
  <img src="../../DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="../../DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="../../DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="../../DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="../../DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
