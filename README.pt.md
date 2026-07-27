<p align="center">
  <img src="docs/assets/banner.svg" alt="ManaForge — Digitaliza a tua coleção. Forja baralhos com as cartas que já tens." width="100%">
</p>

<p align="center"><a href="README.en.md">🇬🇧 English</a> · <a href="README.md">🇪🇸 Español</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.fr.md">🇫🇷 Français</a> · <a href="README.it.md">🇮🇹 Italiano</a> · <b>🇵🇹 Português</b> · <a href="README.ru.md">🇷🇺 Русский</a> · <a href="README.zh.md">🇨🇳 中文</a> · <a href="README.ja.md">🇯🇵 日本語</a> · <a href="README.ko.md">🇰🇷 한국어</a></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="Base de dados de cartas"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="Licença PolyForm Noncommercial 1.0.0"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="Desktop multiplataforma">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="Grátis para sempre">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">Funcionalidades</a></b> ·
  <b><a href="#download">Download</a></b> ·
  <b><a href="#architecture">Arquitetura</a></b> ·
  <b><a href="#roadmap">Roteiro</a></b> ·
  <b><a href="#contributing">Contribuir</a></b>
</p>

> [!TIP]
> **«Que baralhos posso construir com o que JÁ tenho?»** É a pergunta a que nenhuma app de Magic responde bem — e a única razão de existir do ManaForge. As outras ajudam-te a *catalogar* a tua caixa de cartas; esta transforma-a em baralhos prontos a baralhar.

Todos já passámos por isto: uma caixa cheia de cartas de boosters, baralhos iniciais e gavetas herdadas… e nenhuma ideia do que construir com elas. O ManaForge é feito por jogadores, para jogadores: **grátis, sem anúncios, sem premium, sem contas e com todo o código à vista.**

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge: o gerador de baralhos

Dás-lhe a tua coleção e ele devolve-te **baralhos completos de 60 cartas**, construídos como os construiria um jogador veterano. É assim que ele pensa:

<p align="center">
  <img src="docs/assets/forge-flow.svg" alt="Coleção → Sinergias → Curva de mana → Validador → Baralhos com plano de jogo" width="100%">
</p>

- 🏔️ **Uma curva de mana como deve ser** — terrenos por arquétipo, fontes repartidas por símbolos de cor, curva validada. Nada de baralhos com 15 terrenos.
- 🧬 **Sinergias encontradas** — o Forge lê o texto de regras de cada carta e descobre os teus temas: dreno de vida, sacrifício, artefactos, go-wide, spellslinger, marcadores…
- 🗺️ **Um plano de jogo explicado** — turno a turno, mais um *«Porque é que este baralho funciona?»* expansível para quem quiser a teoria.
- 🤝 **Regras de honra** — nunca usa cartas que não tens, nunca ultrapassa o limite de cópias e, em vez de gerar um baralho defeituoso, explica porquê e sugere uma alternativa.
- 🎯 **Escolhe o teu estilo** — força uma tribo (Elfos, Zombies, Dragões… 24 escolhidas a dedo, mais qualquer subtipo com corpos suficientes) ou um tema mecânico, e o motor obedece. Em Auto, ele encontra o que a tua coleção melhor recompensa.
- ⚔️ **Forja profunda** — antes de aparecerem, os baralhos candidatos jogam centenas de partidas entre si: a ordem final pesa o desempenho real, não só a pontuação no papel.
- 🎲 **Probabilidade a sério** — consistência (compras os teus terrenos a tempo?) e curva jogável calculadas com matemática hipergeométrica; os terrenos não básicos (shocks, checks, fetches) contam pelo que realmente fazem.
- 📤 **Exportação num toque** — copia a lista e cola-a no Moxfield, no MTG Arena ou no Discord do teu grupo.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>A coleção real que deu origem ao ManaForge — o gerador transformou estas cartas (e mais 280) em cinco baralhos jogáveis.</i></sub></p>

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ O que faz hoje

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>Toda a história de Magic<br/>no teu bolso</b><br/><br/>
      <sub>Base de dados de cartas completa (bulk do Scryfall → SQLite) que se reconstrói sozinha todos os meses em CI. Fazes o download uma vez e tudo funciona <b>offline</b>.</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>Pesquisa em<br/>espanhol e inglês</b><br/><br/>
      <sub>«Elfos de Llanowar», «elfos de llanowar» sem acentos ou «Llanowar Elves»: tudo leva à mesma carta. E com a app em espanhol, baralhos e fichas de carta mostram os nomes em espanhol.</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>A tua coleção,<br/>visual e tua</b><br/><br/>
      <sub><b>Digitaliza cartas com a webcam</b> (reconhece a edição exata pela arte), <b>importa o teu CSV</b> de qualquer outra app ou adiciona-as à mão. Tudo fica local: sem contas, sem nuvem obrigatória.</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>Várias propostas num carrossel comparável, vista de detalhe com plano de jogo turno a turno, curva editável que reforja o baralho e um Modo de Teste para o pôr frente a outro.</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>Design cuidado</b><br/><br/>
      <sub>Tema escuro, <b>10 idiomas completos</b>, tours guiados que mostram a app por dentro, iconografia de mana pensada para o daltonismo e microtextos de jogador para jogador.</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>Privacidade de série</b><br/><br/>
      <sub>Sem analytics, sem tracking, sem «cria a tua conta». O scanner reconhece as cartas 100 % no teu dispositivo.</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **No forno:** trocas entre coleções, nomes de carta em mais idiomas e mobile, se a comunidade pedir.

<a id="download"></a>
## 🚀 Faz o download e abre

Vai a [**Releases**](https://github.com/AAlexmc/Manaforge/releases) e descarrega o zip do teu sistema. Sem instalador, sem contas: descompactas e abres.

| Sistema | O que fazer |
|---|---|
| **Windows** | Descompacta e, dentro da pasta `ManaForge`, abre `manaforge.exe`. Na primeira vez, o Windows avisa que não conhece o programa: *Mais informações → Executar mesmo assim* (não está assinado; o código está aqui mesmo para o inspecionares). |
| **macOS** | Descompacta e abre-a uma vez (vai aparecer um aviso); depois vai a *Definições do Sistema → Privacidade e Segurança → Abrir mesmo assim*. (Desde o macOS 15, o clique direito → Abrir já não salta o aviso.) |
| **Linux** | Descompacta e, dentro da pasta `ManaForge`, executa `./manaforge`. Para a teres no menu de aplicações com o seu ícone: `./instalar.sh` (fica tudo em `~/.local`, sem sudo; remove-se com `./instalar.sh --desinstalar`). |

**Verifica o que descarregaste**: cada release publica `SHA256SUMS.txt` com a impressão digital dos três zips. Em Linux ou macOS, `sha256sum -c SHA256SUMS.txt` (ou `shasum -a 256 -c`); no Windows, `Get-FileHash ManaForge-Windows.zip`.

No primeiro arranque, a app descarrega **~36 MB** de dados (cartas e preços do Scryfall, histórico de preços e impressões digitais do scanner) e mostra-te o progresso. A partir daí, funciona offline.

Depois: **importa a tua coleção** a partir de um CSV, **digitaliza** cartas com a webcam ou uma foto, ou vai direto ao **⚒️ Forge** e constrói um baralho a partir de uma coleção dada, mesmo antes de teres uma.

### Preferes compilá-la tu?

```bash
# Flutter, canal stable: https://docs.flutter.dev/get-started/install
# (no Windows é preciso o Visual Studio com "Desktop development with C++")
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # ou -d windows / -d macos
```

Os wrappers nativos de Linux, Windows e macOS e o `pubspec.lock` estão no repo, por isso compila tal e qual nos três.

<a id="architecture"></a>
## 🔧 Como está feito

| Pasta | O que vive lá |
|---|---|
| [`app/`](app) | A app Flutter — uma só base de código para Windows, macOS e Linux (e mobile um dia destes) |
| [`forge_engine/`](forge_engine) | O motor de baralhos em Dart: curva, validador, classificador e gerador |
| [`engine-reference/`](engine-reference) | O mesmo motor em Python: a **referência canónica e testada** do algoritmo |
| [`scripts/`](scripts) | Pipeline de dados: bulk do Scryfall → SQLite, executado só no GitHub Actions |
| [`DesignSystem/`](DesignSystem) | Tokens de design, ícones de mana em SVG e especificações de componentes |
| [`docs/`](docs) | Arquitetura de dados, o algoritmo do Forge e o design do scanner |

Duas decisões definem o projeto. Uma: **o motor existe em duplicado** — Python como especificação executável e testada, Dart como a implementação que vai dentro da app; se divergirem, ganha o Python. Duas: **a base de dados constrói-se sozinha** — um workflow descarrega o bulk do Scryfall todos os meses e publica o SQLite como [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest), que a app descarrega no primeiro arranque.

```bash
cd engine-reference && python3 -m pytest tests/   # testes do algoritmo (canónico)
cd forge_engine && dart test                      # testes do motor da app
cd app && flutter test                            # testes da app
```

<a id="roadmap"></a>
## 🗺️ Roteiro

- [x] **Fase 1 — Fundações**: motor de curva e validador (Python + Dart), sistema de design, CI
- [x] **Fase 2 — Dados**: pipeline bulk do Scryfall → SQLite com release mensal automática
- [x] **Fase 3 — Gerador**: classificação funcional, temas, pontuação e construção greedy
- [x] **Fase 4 — App v0.2**: coleção com pesquisa ES/EN, importador de CSV, Forge com carrossel e plano de jogo
- [x] **Fase 5 — Desktop de primeira**: builds automáticas de Windows/macOS/Linux nas Releases, baralhos guardados, atalhos de teclado e uma janela que se lembra do seu lugar
- [x] **Fase 6 — Acabamentos**: preços e valor da coleção, P&L de compra, legalidades por formato e **10 idiomas completos**
- [x] **Fase 7 — Scanner**: impressões digitais perceptuais geradas em CI + webcam/foto, 100 % no dispositivo ([como funciona por dentro](docs/reconocimiento-cartas.md))
- [x] **Fase 7½ — Forge v2**: manabase probabilística, pontuação por consistência e curva, temas tribais/reanimator, seletor de estilo, forja profunda e nomes de carta em espanhol
- [ ] **Fase 8 — Trocas e comunidade**: trocas entre coleções e o que a [caixa de sugestões](https://github.com/AAlexmc/Manaforge/issues/new/choose) pedir
- [ ] **Fase 9 — Mobile (se a comunidade pedir)**: Android e iOS/TestFlight — o código está pronto; só faltam as contas das lojas

<a id="contributing"></a>
## 🤝 Contribuir

Este projeto quer pertencer à comunidade. Se sabes de Flutter, de visão computacional (o scanner está à tua espera!), de teoria de construção de baralhos — ou se simplesmente jogas e tens ideias — os issues e os PRs estão abertos. O código está comentado em espanhol e a CI avisa-te se algo se partir, antes que alguém se chateie.

### 💡 Caixa de sugestões

Não é preciso saber programar: se tens uma ideia ou encontraste um bug, deixa-a na [caixa de sugestões](https://github.com/AAlexmc/Manaforge/issues/new/choose) — há um modelo para cada coisa e preenche-se num minuto. Também lá chegas a partir da própria app: **Definições → A app**.

<a id="donations"></a>
## 💜 Donativos

O ManaForge é grátis e sem anúncios, e vai continuar assim (a [licença](#license) não permite vendê-lo). Mas se algum dia o Forge te construiu o baralho que ganhou a partida, podes financiar duas causas nobres: o café que mantém a forja acesa e a minha rigorosa investigação de campo, que consiste em abrir *collector boosters* onde nunca — **nunca** — sai nada de jeito. Os dados dizem que a próxima rara cobiçada não vai aparecer; a esperança é a última coisa a ser exilada.

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="Paga-me um café via PayPal">
  </a>
</p>

E se o teu mana estiver todo virado, a melhor forma de apoiar o projeto é usá-lo, contar o que melhorarias na [caixa de sugestões](https://github.com/AAlexmc/Manaforge/issues/new/choose) e dar uma ⭐ ao repo — as estrelas não se descartam no final do turno.

<p align="center"><img src="docs/assets/divider.svg" width="620" alt=""></p>

## 🙏 Créditos e avisos legais

Os dados e as imagens das cartas vêm do [Scryfall](https://scryfall.com), a quem devemos gratidão eterna (e respeito pelos seus [limites de API](https://scryfall.com/docs/api)). Magic: The Gathering, as suas cartas e ilustrações são propriedade da **Wizards of the Coast**. O ManaForge é um projeto de fãs **não oficial** e gratuito ao abrigo da [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy); não é produzido, aprovado nem patrocinado pela Wizards.

<a id="license"></a>
## 📄 Licença

[PolyForm Noncommercial 1.0.0](LICENSE). Em bom português:

- **Podes** usá-la, copiá-la, modificá-la, partilhá-la e publicar as tuas versões, com a única condição de passares a licença junto com o código.
- **Não podes** vendê-la nem usá-la para ganhar dinheiro: nem cobrar pela app ou por uma versão modificada, nem metê-la num produto ou serviço pago, nem usá-la dentro de um negócio para a sua atividade comercial.
- **Podes** usá-la em casa, ou na tua loja de bairro para as tuas próprias cartas… desde que não estejas a vender a app nem a cobrar por ela.

Uso pessoal, estudo, experimentação, projetos de hobby e organizações sem fins lucrativos: força, sem pedir autorização.

Atenção: uma licença com restrição não comercial **não** é «open source» no sentido da OSI. É *source-available*: podes ler o código, mexer-lhe e partilhá-lo, mas não vendê-lo.

<p align="center">
  <sub>Feito com ❤️ e muito mana por jogadores de mesa de cozinha</sub><br/><br/>
  <img src="DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
