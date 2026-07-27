<p align="center">
  <img src="docs/assets/banner.svg" alt="ManaForge — Scansiona la tua collezione. Forgia mazzi con le carte che hai già." width="100%">
</p>

<p align="center"><a href="README.en.md">🇬🇧 English</a> · <a href="README.md">🇪🇸 Español</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.fr.md">🇫🇷 Français</a> · <b>🇮🇹 Italiano</b> · <a href="README.pt.md">🇵🇹 Português</a> · <a href="README.ru.md">🇷🇺 Русский</a> · <a href="README.zh.md">🇨🇳 中文</a> · <a href="README.ja.md">🇯🇵 日本語</a> · <a href="README.ko.md">🇰🇷 한국어</a></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="Database delle carte"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="Licenza PolyForm Noncommercial 1.0.0"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="Desktop multipiattaforma">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="Gratis per sempre">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">Funzionalità</a></b> ·
  <b><a href="#download">Download</a></b> ·
  <b><a href="#architecture">Architettura</a></b> ·
  <b><a href="#roadmap">Roadmap</a></b> ·
  <b><a href="#contributing">Contribuire</a></b>
</p>

> [!TIP]
> **«Quali mazzi posso costruire con quello che possiedo GIÀ?»** È la domanda a cui nessuna app di Magic risponde bene — e l'unico motivo per cui ManaForge esiste. Le altre ti aiutano a *catalogare* la tua scatola di carte; questa te la trasforma in mazzi pronti da mischiare.

Ci siamo passati tutti: una scatola piena di carte uscite da bustine, mazzi introduttivi e cassetti ereditati… e nessuna idea di cosa costruirci. ManaForge è fatta da giocatori, per giocatori: **gratuita, senza pubblicità, senza premium, senza account, e con tutto il codice alla luce del sole.**

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge: il generatore di mazzi

Gli consegni la tua collezione e ti restituisce **mazzi completi da 60 carte**, costruiti come li costruirebbe un giocatore veterano. Ecco come ragiona:

<p align="center">
  <img src="docs/assets/forge-flow.svg" alt="Collezione → Sinergie → Curva di mana → Validatore → Mazzi con piano di gioco" width="100%">
</p>

- 🏔️ **Una curva di mana come si deve** — terre in base all'archetipo, fonti ripartite per simboli di colore, curva validata. Niente mazzi con 15 terre da queste parti.
- 🧬 **Sinergie rilevate** — Forge legge il testo delle regole di ogni carta e trova i tuoi temi: drenaggio di vite, sacrificio, artefatti, go-wide, spellslinger, segnalini…
- 🗺️ **Un piano di gioco spiegato** — turno per turno, più un *«Perché questo mazzo funziona?»* richiudibile per chi vuole la teoria.
- 🤝 **Regole d'onore** — non usa mai carte che non possiedi, non supera mai il limite di copie e, piuttosto che generare un mazzo difettoso, ti spiega il perché e ti propone un'alternativa.
- 🎯 **Scegli il tuo stile** — forza una tribù (Elfi, Zombie, Draghi… 24 curate, più qualsiasi sottotipo con abbastanza creature) o un tema meccanico, e il motore obbedisce. In Auto, rileva quello che la tua collezione ripaga meglio.
- ⚔️ **Forgia profonda** — prima di farsi vedere, i mazzi candidati giocano centinaia di partite tra loro: la classifica finale pesa come rendono davvero, non solo il loro punteggio sulla carta.
- 🎲 **Probabilità vera** — consistenza (peschi le tue terre in tempo?) e curva giocabile calcolate con matematica ipergeometrica; le terre non base (shock, check, fetch) contano per quello che fanno davvero.
- 📤 **Esportazione in un tocco** — copia la lista e incollala su Moxfield, MTG Arena o nel Discord del tuo gruppo.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>La collezione vera da cui è nata ManaForge — il generatore ha trasformato queste carte (e altre 280) in cinque mazzi giocabili.</i></sub></p>

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ Cosa fa oggi

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>Tutta la storia di Magic<br/>in tasca</b><br/><br/>
      <sub>Database completo delle carte (bulk di Scryfall → SQLite) che si ricostruisce da solo ogni mese in CI. Lo scarichi una volta e tutto funziona <b>offline</b>.</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>Ricerca in<br/>spagnolo e inglese</b><br/><br/>
      <sub>«Elfos de Llanowar», «elfos de llanowar» senza accenti o «Llanowar Elves»: portano tutti alla stessa carta. E con l'app in spagnolo, mazzi e schede delle carte mostrano i nomi in spagnolo.</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>La tua collezione,<br/>visuale e tua</b><br/><br/>
      <sub><b>Scansiona le carte con la webcam</b> (riconosce la stampa esatta dall'illustrazione), <b>importa il tuo CSV</b> da qualsiasi altra app o aggiungile a mano. Tutto resta in locale: niente account, niente cloud obbligatorio.</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>Diverse proposte in un carosello confrontabile, una vista di dettaglio con piano di gioco turno per turno, una curva modificabile che riforgia il mazzo e una Modalità Test per metterlo contro un altro.</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>Design curato</b><br/><br/>
      <sub>Tema scuro, <b>10 lingue complete</b>, tour guidati che mostrano l'app da dentro, iconografia del mana leggibile dai daltonici e microtesti da giocatore a giocatore.</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>Privacy di serie</b><br/><br/>
      <sub>Niente analytics, niente tracking, niente «crea il tuo account». Lo scanner riconosce le carte al 100 % sul tuo dispositivo.</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **In forno:** scambi tra collezioni, nomi delle carte in più lingue e mobile se la comunità lo chiede.

<a id="download"></a>
## 🚀 Scaricala e aprila

Vai su [**Releases**](https://github.com/AAlexmc/Manaforge/releases) e prendi lo zip per il tuo sistema. Niente installer, niente account: scompatti e apri.

| Sistema | Cosa fare |
|---|---|
| **Windows** | Scompatta e, dentro la cartella `ManaForge`, apri `manaforge.exe`. La prima volta Windows avviserà che non conosce il programma: *Ulteriori informazioni → Esegui comunque* (non è firmata; il codice è tutto qui, puoi controllarlo). |
| **macOS** | Scompatta e aprila una volta (comparirà un avviso); poi vai su *Impostazioni di Sistema → Privacy e sicurezza → Apri comunque*. (Da macOS 15, clic destro → Apri non aggira più l'avviso.) |
| **Linux** | Scompatta e, dentro la cartella `ManaForge`, esegui `./manaforge`. Per averla nel menu delle applicazioni con la sua icona: `./instalar.sh` (mette tutto in `~/.local`, senza sudo; si rimuove con `./instalar.sh --desinstalar`). |

**Verifica quello che hai scaricato**: ogni release pubblica `SHA256SUMS.txt` con l'impronta dei tre zip. Su Linux o macOS, `sha256sum -c SHA256SUMS.txt` (o `shasum -a 256 -c`); su Windows, `Get-FileHash ManaForge-Windows.zip`.

Al primo avvio l'app scarica **~36 MB** di dati (carte e prezzi di Scryfall, storico dei prezzi e impronte dello scanner) e ti mostra il progresso. Da lì in poi funziona offline.

Poi: **importa la tua collezione** da un CSV, **scansiona** le carte con la webcam o una foto, oppure vai dritto su **⚒️ Forge** e costruisci un mazzo da una collezione data ancora prima di averne una.

### Preferisci compilarla da te?

```bash
# Flutter, canale stable: https://docs.flutter.dev/get-started/install
# (su Windows serve Visual Studio con "Sviluppo di applicazioni desktop con C++")
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # oppure -d windows / -d macos
```

I wrapper nativi per Linux, Windows e macOS più il `pubspec.lock` sono nel repo, quindi si compila così com'è su tutti e tre.

<a id="architecture"></a>
## 🔧 Com'è fatta

| Cartella | Cosa ci vive |
|---|---|
| [`app/`](app) | L'app Flutter — un unico codice per Windows, macOS e Linux (e un giorno mobile) |
| [`forge_engine/`](forge_engine) | Il motore dei mazzi in Dart: curva, validatore, classificatore e generatore |
| [`engine-reference/`](engine-reference) | Lo stesso motore in Python: il **riferimento canonico e testato** dell'algoritmo |
| [`scripts/`](scripts) | Pipeline dei dati: bulk di Scryfall → SQLite, eseguita solo su GitHub Actions |
| [`DesignSystem/`](DesignSystem) | Token di design, icone di mana in SVG e specifiche dei componenti |
| [`docs/`](docs) | Architettura dei dati, l'algoritmo di Forge e il design dello scanner |

Due decisioni definiscono il progetto. Uno: **il motore esiste due volte** — Python come specifica eseguibile e testata, Dart come implementazione che gira nell'app; se divergono, vince Python. Due: **il database si costruisce da solo** — un workflow scarica il bulk di Scryfall ogni mese e pubblica la SQLite come [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest), che l'app scarica al primo avvio.

```bash
cd engine-reference && python3 -m pytest tests/   # test dell'algoritmo (canonico)
cd forge_engine && dart test                      # test del motore dell'app
cd app && flutter test                            # test dell'app
```

<a id="roadmap"></a>
## 🗺️ Roadmap

- [x] **Fase 1 — Fondamenta**: motore di curva e validatore (Python + Dart), design system, CI
- [x] **Fase 2 — Dati**: pipeline bulk Scryfall → SQLite con release mensile automatica
- [x] **Fase 3 — Generatore**: classificazione funzionale, temi, punteggio e costruzione greedy
- [x] **Fase 4 — App v0.2**: collezione con ricerca ES/EN, importatore CSV, Forge con carosello e piano di gioco
- [x] **Fase 5 — Desktop di prima classe**: build automatiche Windows/macOS/Linux nelle Releases, mazzi salvati, scorciatoie da tastiera e una finestra che ricorda il suo posto
- [x] **Fase 6 — Rifiniture**: prezzi e valore della collezione, P&L d'acquisto, legalità per formato e **10 lingue complete**
- [x] **Fase 7 — Scanner**: impronte percettive generate in CI + webcam/foto, 100 % sul dispositivo ([come funziona dentro](docs/reconocimiento-cartas.md))
- [x] **Fase 7½ — Forge v2**: manabase probabilistica, punteggio di consistenza e curva, temi tribali/reanimator, selettore di stile, forgia profonda e nomi delle carte in spagnolo
- [ ] **Fase 8 — Scambi e comunità**: scambi tra collezioni più tutto quello che chiede la [cassetta dei suggerimenti](https://github.com/AAlexmc/Manaforge/issues/new/choose)
- [ ] **Fase 9 — Mobile (se la comunità lo chiede)**: Android e iOS/TestFlight — il codice è pronto; mancano solo gli account degli store

<a id="contributing"></a>
## 🤝 Contribuire

Questo progetto vuole appartenere alla comunità. Se te la cavi con Flutter, con la visione artificiale (lo scanner ti aspetta!), con la teoria di costruzione dei mazzi — o semplicemente giochi e hai idee — issue e PR sono aperti. Il codice è commentato in spagnolo, e la CI ti avviserà se qualcosa si rompe prima che qualcuno se la prenda.

### 💡 Cassetta dei suggerimenti

Non serve saper programmare: se hai un'idea o hai trovato un bug, lasciala nella [cassetta dei suggerimenti](https://github.com/AAlexmc/Manaforge/issues/new/choose) — c'è un template per ciascuna cosa e ci vuole un minuto. Ci arrivi anche dall'app: **Impostazioni → L'app**.

<a id="donations"></a>
## 💜 Donazioni

ManaForge è gratuita e senza pubblicità, e resterà così (la [licenza](#license) non permette di venderla). Ma se Forge ti ha mai forgiato il mazzo che ha vinto la partita, puoi finanziare due nobili cause: il caffè che tiene accesa la forgia, e la mia rigorosa ricerca sul campo, che consiste nell'aprire *collector booster* dove non esce mai — **mai** — niente. I dati dicono che la prossima chase rare non arriverà; la speranza è l'ultima cosa a essere esiliata.

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="Offrimi un caffè via PayPal">
  </a>
</p>

E se il tuo mana è tutto TAPpato, il modo migliore di sostenere il progetto è usarlo, raccontarmi cosa miglioreresti nella [cassetta dei suggerimenti](https://github.com/AAlexmc/Manaforge/issues/new/choose) e lasciare una ⭐ al repo — le stelle non si scartano a fine turno.

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## 🙏 Crediti e note legali

I dati e le immagini delle carte vengono da [Scryfall](https://scryfall.com), a cui dobbiamo eterna gratitudine (e il rispetto dei loro [limiti di API](https://scryfall.com/docs/api)). Magic: The Gathering, le sue carte e le sue illustrazioni sono proprietà di **Wizards of the Coast**. ManaForge è un progetto di fan **non ufficiale** e gratuito ai sensi della [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy); non è prodotto, approvato né sponsorizzato da Wizards.

<a id="license"></a>
## 📄 Licenza

[PolyForm Noncommercial 1.0.0](LICENSE). In parole povere:

- **Puoi** usarla, copiarla, modificarla, condividerla e pubblicare le tue versioni, all'unica condizione di passare la licenza insieme al codice.
- **Non puoi** venderla né usarla per fare soldi: niente far pagare l'app o una versione modificata, niente includerla in un prodotto o servizio a pagamento, niente usarla dentro un'azienda per la sua attività commerciale.
- **Puoi** usarla a casa, o nel tuo negozio di zona per le tue carte… purché tu non stia vendendo l'app né facendo pagare per usarla.

Uso personale, studio, smanettamento, progetti da hobby e no-profit: avanti pure, nessun permesso necessario.

Occhio: una licenza con restrizione non commerciale **non** è «open source» nel senso OSI. È *source-available*: puoi leggerla, ritoccarla e condividerla, ma non venderla.

<p align="center">
  <sub>Fatto con ❤️ e tanto mana da giocatori da tavolo di cucina</sub><br/><br/>
  <img src="DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
