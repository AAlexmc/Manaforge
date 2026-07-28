<p align="center">
  <img src="../assets/banner.svg" alt="ManaForge — 컬렉션을 스캔하세요. 이미 가진 카드로 덱을 벼려내세요." width="100%">
</p>

<p align="center"><a href="README.en.md">🇬🇧 English</a> · <a href="../../README.md">🇪🇸 Español</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.fr.md">🇫🇷 Français</a> · <a href="README.it.md">🇮🇹 Italiano</a> · <a href="README.pt.md">🇵🇹 Português</a> · <a href="README.ru.md">🇷🇺 Русский</a> · <a href="README.zh.md">🇨🇳 中文</a> · <a href="README.ja.md">🇯🇵 日本語</a> · <b>🇰🇷 한국어</b></p>

<p align="center">
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml"><img src="https://github.com/AAlexmc/Manaforge/actions/workflows/build-card-db.yml/badge.svg" alt="카드 데이터베이스"></a>
  <a href="../../LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial-4FB878?style=flat-square" alt="PolyForm Noncommercial 1.0.0 라이선스"></a>
  <img src="https://img.shields.io/badge/Flutter-Windows%20·%20macOS%20·%20Linux-5A9BD8?style=flat-square&logo=flutter&logoColor=white" alt="크로스 플랫폼 데스크톱">
  <img src="https://img.shields.io/badge/price-0%20%E2%82%AC%20forever-E06A50?style=flat-square" alt="영원히 무료">
</p>

<p align="center">
  <b><a href="#forge">Forge</a></b> ·
  <b><a href="#features">기능</a></b> ·
  <b><a href="#download">다운로드</a></b> ·
  <b><a href="#architecture">아키텍처</a></b> ·
  <b><a href="#roadmap">로드맵</a></b> ·
  <b><a href="#contributing">기여하기</a></b>
</p>

> [!TIP]
> **"지금 이미 가진 카드로 어떤 덱을 만들 수 있을까?"** 어떤 Magic 앱도 제대로 답해 주지 못하는 질문이고, ManaForge가 존재하는 유일한 이유입니다. 다른 앱들은 카드 상자를 *목록으로 정리*하게 도와주지만, 이 앱은 그 상자를 바로 섞어서 돌릴 수 있는 덱으로 바꿔 줍니다.

누구나 겪어 본 일이죠: 부스터에서, 스타터 덱에서, 물려받은 서랍에서 나온 카드가 상자에 한가득… 그런데 뭘 만들어야 할지는 막막한 상황. ManaForge는 플레이어가 플레이어를 위해 만들었습니다: **무료, 광고 없음, 프리미엄 없음, 계정 없음, 그리고 모든 코드 공개.**

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

<a id="forge"></a>
## ⚒️ Forge: 덱 생성기

컬렉션을 건네주면 베테랑 플레이어가 짜는 방식 그대로 **60장 완성 덱**을 돌려줍니다. 머릿속은 이렇게 굴러갑니다:

<p align="center">
  <img src="../assets/forge-flow.svg" alt="컬렉션 → 시너지 → 마나 곡선 → 검증기 → 게임 플랜을 갖춘 덱" width="100%">
</p>

- 🏔️ **제대로 된 마나 곡선** — 아키타입별 대지 수, 색 기호에 따라 배분된 마나 원천, 검증된 곡선. 대지 15장짜리 덱은 여기 없습니다.
- 🧬 **시너지 자동 감지** — Forge는 모든 카드의 룰 텍스트를 읽고 컬렉션의 테마를 찾아냅니다: 생명 흡수, 희생, 마법물체, 물량 공세, 주문 연계, 카운터…
- 🗺️ **게임 플랜까지 설명** — 턴별 플랜에 더해, 이론이 궁금한 사람을 위한 접이식 *"이 덱은 왜 굴러갈까?"* 코너까지.
- 🤝 **명예의 규칙** — 없는 카드는 절대 쓰지 않고, 카드 매수 제한도 절대 넘지 않으며, 망가진 덱을 내놓느니 이유를 설명하고 대안을 제안합니다.
- 🎯 **스타일 선택** — 부족(엘프, 좀비, 드래곤… 엄선된 24종에, 머릿수만 충분하면 어떤 하위 유형이든)이나 메커니즘 테마를 지정하면 엔진이 따릅니다. Auto로 두면 컬렉션이 가장 크게 보답하는 테마를 알아서 찾아냅니다.
- ⚔️ **딥 포지** — 후보 덱들은 공개되기 전에 서로 수백 판을 치릅니다: 최종 순위에는 종이 위 점수만이 아니라 실제 성적이 반영됩니다.
- 🎲 **진짜 확률** — 일관성(대지를 제때 뽑을 수 있나?)과 플레이 가능한 곡선을 초기하분포 수학으로 계산합니다. 비기본 대지(쇼크 랜드, 체크 랜드, 페치 랜드)는 실제 하는 역할 그대로 계산에 들어갑니다.
- 📤 **원터치 내보내기** — 리스트를 복사해서 Moxfield, MTG Arena, 혹은 여러분 플레이 그룹의 Discord에 붙여 넣으세요.

<p align="center">
  <img src="https://cards.scryfall.io/normal/front/4/3/430fcd3e-a70a-4554-9c48-1a1b11d0a95c.jpg" width="19%" alt="Gray Merchant of Asphodel"><img src="https://cards.scryfall.io/normal/front/3/1/3130a342-3c98-4c69-975b-a958ccddfe37.jpg" width="19%" alt="The Mindskinner"><img src="https://cards.scryfall.io/normal/front/d/7/d7c6614c-cc2b-4e5b-9c0d-ce8e4b2d8ea7.jpg" width="19%" alt="Tezzeret, Master of Metal"><img src="https://cards.scryfall.io/normal/front/5/0/50a31dde-29b0-4c6f-b345-ae3c984cd1c7.jpg" width="19%" alt="Fiend Artisan"><img src="https://cards.scryfall.io/normal/front/3/c/3cee9303-9d65-45a2-93d4-ef4aba59141b.jpg" width="19%" alt="Serra Angel">
</p>
<p align="center"><sub><i>ManaForge가 태어난 바로 그 실제 컬렉션 — 생성기는 이 카드들(그리고 280장 더)을 플레이 가능한 덱 다섯 개로 바꿔 놓았습니다.</i></sub></p>

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

<a id="features"></a>
## ✨ 지금 할 수 있는 것

<table>
  <tr>
    <td align="center" width="33%">
      <h3>🗃️</h3><b>Magic의 모든 역사를<br/>주머니 속에</b><br/><br/>
      <sub>매달 CI에서 스스로 다시 빌드되는 완전한 카드 데이터베이스(Scryfall 벌크 → SQLite). 한 번 내려받으면 모든 것이 <b>오프라인</b>으로 동작합니다.</sub>
    </td>
    <td align="center" width="33%">
      <h3>🔍</h3><b>스페인어와 영어로<br/>검색</b><br/><br/>
      <sub>"Elfos de Llanowar", 악센트 없는 "elfos de llanowar", 또는 "Llanowar Elves": 전부 같은 카드로 이어집니다. 앱을 스페인어로 쓰면 덱과 카드 화면에도 스페인어 이름이 표시됩니다.</sub>
    </td>
    <td align="center" width="33%">
      <h3>📦</h3><b>당신의 컬렉션,<br/>눈에 보이게, 온전히 당신 것</b><br/><br/>
      <sub><b>웹캠으로 카드를 스캔</b>하고(일러스트만 보고 정확한 인쇄판까지 알아봅니다), 다른 앱에서 쓰던 <b>CSV를 가져오거나</b>, 손으로 직접 추가하세요. 모든 것은 로컬에 남습니다: 계정도, 강제 클라우드도 없습니다.</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>⚒️</h3><b>Forge</b><br/><br/>
      <sub>비교하기 좋은 캐러셀에 담긴 여러 제안, 턴별 게임 플랜이 붙은 상세 화면, 덱을 다시 벼려 주는 편집 가능한 곡선, 그리고 다른 덱과 맞붙여 보는 테스트 모드.</sub>
    </td>
    <td align="center">
      <h3>🌗</h3><b>세심한 디자인</b><br/><br/>
      <sub>다크 테마, <b>완전 지원 10개 언어</b>, 앱 구석구석을 안내하는 가이드 투어, 색약 친화적인 마나 아이콘, 플레이어끼리 주고받는 말투의 마이크로카피.</sub>
    </td>
    <td align="center">
      <h3>🔐</h3><b>기본값이 프라이버시</b><br/><br/>
      <sub>분석 도구도, 추적도, "계정을 만드세요"도 없습니다. 스캐너는 카드를 100 % 당신의 기기에서 인식합니다.</sub>
    </td>
  </tr>
</table>

> [!NOTE]
> **오븐에서 굽는 중:** 컬렉션 간 트레이드, 더 많은 언어의 카드 이름, 그리고 커뮤니티가 원한다면 모바일까지.

<a id="download"></a>
## 🚀 다운로드해서 열기

[**Releases**](https://github.com/AAlexmc/Manaforge/releases)에 가서 시스템에 맞는 zip을 받으세요. 설치 프로그램도 계정도 없습니다: 압축을 풀고 열면 끝.

| 시스템 | 할 일 |
|---|---|
| **Windows** | 압축을 풀고 `ManaForge` 폴더 안의 `manaforge.exe`를 여세요. 처음에는 Windows가 모르는 프로그램이라고 경고합니다: *추가 정보 → 실행*을 누르세요(서명이 안 되어 있어서 그렇습니다; 코드는 바로 여기 있으니 직접 살펴보세요). |
| **macOS** | 압축을 풀고 한 번 열어 보세요(경고가 뜹니다). 그다음 *시스템 설정 → 개인정보 보호 및 보안 → 그래도 열기*로 가세요. (macOS 15부터는 우클릭 → 열기로 경고를 건너뛸 수 없습니다.) |
| **Linux** | 압축을 풀고 `ManaForge` 폴더 안에서 `./manaforge`를 실행하세요. 앱 메뉴에 아이콘과 함께 등록하려면: `./instalar.sh`(전부 `~/.local`에 들어가고 sudo는 필요 없습니다; 제거는 `./instalar.sh --desinstalar`). |

**받은 파일 검증하기**: 모든 릴리스는 zip 세 개의 지문이 담긴 `SHA256SUMS.txt`를 함께 공개합니다. Linux나 macOS에서는 `sha256sum -c SHA256SUMS.txt`(또는 `shasum -a 256 -c`), Windows에서는 `Get-FileHash ManaForge-Windows.zip`.

처음 실행하면 앱이 **~36 MB**의 데이터(Scryfall 카드와 가격, 가격 히스토리, 스캐너 지문)를 내려받으며 진행 상황을 보여 줍니다. 그다음부터는 오프라인으로 동작합니다.

그다음은: CSV에서 **컬렉션을 가져오거나**, 웹캠이나 사진으로 카드를 **스캔**하거나, 아직 컬렉션이 없어도 곧장 **⚒️ Forge**로 가서 주어진 컬렉션으로 덱을 만들어 보세요.

### 직접 빌드하고 싶다면?

```bash
# Flutter, stable 채널: https://docs.flutter.dev/get-started/install
# (Windows에서는 "C++를 사용한 데스크톱 개발"이 포함된 Visual Studio가 필요합니다)
git clone https://github.com/AAlexmc/Manaforge.git
cd Manaforge/app
flutter run -d linux     # 또는 -d windows / -d macos
```

Linux, Windows, macOS용 네이티브 래퍼와 `pubspec.lock`이 저장소에 들어 있어서, 세 플랫폼 모두 그대로 빌드됩니다.

<a id="architecture"></a>
## 🔧 어떻게 만들어졌나

| 폴더 | 들어 있는 것 |
|---|---|
| [`app/`](../../app) | Flutter 앱 — Windows, macOS, Linux(언젠가는 모바일까지)를 하나의 코드베이스로 |
| [`forge_engine/`](../../forge_engine) | Dart로 짠 덱 엔진: 곡선, 검증기, 분류기, 생성기 |
| [`engine-reference/`](../../engine-reference) | 같은 엔진의 Python판: 알고리즘의 **테스트를 갖춘 정본 레퍼런스** |
| [`scripts/`](../../scripts) | 데이터 파이프라인: Scryfall 벌크 → SQLite, GitHub Actions에서만 실행 |
| [`DesignSystem/`](../../DesignSystem) | 디자인 토큰, SVG 마나 아이콘, 컴포넌트 명세 |
| [`docs/`](../../docs) | 데이터 아키텍처, Forge 알고리즘, 스캐너 설계 |

프로젝트를 규정하는 결정은 두 가지입니다. 하나: **엔진은 두 벌 존재합니다** — Python은 실행 가능한 테스트된 명세이고, Dart는 앱에 실려 나가는 구현입니다; 둘이 어긋나면 Python이 이깁니다. 둘: **데이터베이스는 스스로 빌드됩니다** — 워크플로가 매달 Scryfall 벌크를 내려받아 SQLite를 [release](https://github.com/AAlexmc/Manaforge/releases/tag/card-db-latest)로 공개하고, 앱은 첫 실행 때 그것을 내려받습니다.

```bash
cd engine-reference && python3 -m pytest tests/   # 알고리즘 테스트 (정본)
cd forge_engine && dart test                      # 앱 엔진 테스트
cd app && flutter test                            # 앱 테스트
```

<a id="roadmap"></a>
## 🗺️ 로드맵

- [x] **1단계 — 기반**: 곡선 엔진과 검증기(Python + Dart), 디자인 시스템, CI
- [x] **2단계 — 데이터**: Scryfall 벌크 → SQLite 파이프라인, 매달 자동 릴리스
- [x] **3단계 — 생성기**: 기능 분류, 테마, 점수화, 그리디 구성
- [x] **4단계 — 앱 v0.2**: ES/EN 검색이 되는 컬렉션, CSV 가져오기, 캐러셀과 게임 플랜을 갖춘 Forge
- [x] **5단계 — 데스크톱 일등석**: Releases에 올라가는 자동 Windows/macOS/Linux 빌드, 덱 저장, 키보드 단축키, 제 자리를 기억하는 창
- [x] **6단계 — 마무리 손질**: 가격과 컬렉션 가치, 구매 손익, 포맷별 사용 가능 여부, **완전 지원 10개 언어**
- [x] **7단계 — 스캐너**: CI에서 생성되는 지각 지문 + 웹캠/사진, 100 % 온디바이스 ([내부 동작 원리](../reconocimiento-cartas.md))
- [x] **7½단계 — Forge v2**: 확률 기반 마나베이스, 일관성·곡선 점수, 부족/리애니메이터 테마, 스타일 선택기, 딥 포지, 스페인어 카드 이름
- [ ] **8단계 — 트레이드와 커뮤니티**: 컬렉션 간 카드 교환, 그리고 [제안함](https://github.com/AAlexmc/Manaforge/issues/new/choose)에 들어오는 요청들
- [ ] **9단계 — 모바일 (커뮤니티가 원한다면)**: Android와 iOS/TestFlight — 코드는 준비 완료; 스토어 계정만 없을 뿐

<a id="contributing"></a>
## 🤝 기여하기

이 프로젝트는 커뮤니티의 것이 되고 싶어 합니다. Flutter를 알거나, 컴퓨터 비전을 알거나(스캐너가 기다립니다!), 덱 구축 이론을 알거나 — 아니면 그냥 플레이하다가 아이디어가 떠올랐거나 — 이슈와 PR은 열려 있습니다. 코드 주석은 스페인어로 되어 있고, 뭔가 깨지면 누가 화내기 전에 CI가 먼저 알려 줍니다.

### 💡 제안함

코딩은 필요 없습니다: 아이디어가 있거나 버그를 발견했다면 [제안함](https://github.com/AAlexmc/Manaforge/issues/new/choose)에 남겨 주세요 — 각각 템플릿이 있어서 1분이면 씁니다. 앱 안에서도 갈 수 있습니다: **설정 → 앱**.

<a id="donations"></a>
## 💜 후원

ManaForge는 무료에 광고도 없고, 앞으로도 그럴 겁니다([라이선스](#license)가 판매를 허락하지 않거든요). 그래도 Forge가 벼려 준 덱으로 게임을 이긴 적이 있다면, 두 가지 숭고한 대의를 후원할 수 있습니다: 대장간의 불을 꺼뜨리지 않는 커피, 그리고 뭐가 터진 적이 — **단 한 번도** — 없는 *컬렉터 부스터*를 계속 뜯어 보는 저의 엄정한 현장 연구. 데이터는 다음 대박 레어가 안 나온다고 말하지만, 희망은 맨 마지막에 추방되는 법이니까요.

<p align="center">
  <a href="https://paypal.me/al3payme">
    <img src="https://img.shields.io/badge/Buy_me_a_coffee-PayPal-0070BA?style=for-the-badge&logo=paypal&logoColor=white" alt="PayPal로 커피 한 잔 사 주기">
  </a>
</p>

마나가 전부 탭되어 있다면, 프로젝트를 돕는 가장 좋은 방법은 앱을 쓰고, [제안함](https://github.com/AAlexmc/Manaforge/issues/new/choose)에 개선했으면 하는 점을 알려 주고, 저장소에 ⭐를 달아 주는 겁니다 — 별은 턴 종료에 버려지지 않으니까요.

<p align="center"><img src="../assets/divider.svg" width="620" alt=""></p>

## 🙏 크레딧과 법적 고지

카드 데이터와 이미지는 [Scryfall](https://scryfall.com)에서 옵니다. 그들에게는 영원한 감사(그리고 [API 제한](https://scryfall.com/docs/api)에 대한 존중)를 빚지고 있습니다. Magic: The Gathering과 그 카드 및 일러스트는 **Wizards of the Coast**의 자산입니다. ManaForge는 [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy)에 따른 **비공식** 무료 팬 프로젝트이며, Wizards가 제작하거나 보증하거나 후원하지 않습니다.

<a id="license"></a>
## 📄 라이선스

[PolyForm Noncommercial 1.0.0](../../LICENSE). 쉽게 말하면:

- **할 수 있는 것** — 사용, 복사, 수정, 공유, 자기만의 버전 공개. 코드와 함께 라이선스를 전달한다는 조건 하나만 지키면 됩니다.
- **할 수 없는 것** — 판매하거나 돈벌이에 쓰는 일: 앱이나 수정 버전에 요금을 매기는 것도, 유료 제품이나 서비스에 끼워 넣는 것도, 사업체 안에서 상업 활동에 쓰는 것도 안 됩니다.
- **역시 할 수 있는 것** — 집에서 쓰기, 동네 카드샵에서 자기 카드를 관리하는 데 쓰기… 앱을 팔거나 요금을 받지 않는 한 괜찮습니다.

개인적 사용, 학습, 이것저것 만져 보기, 취미 프로젝트, 비영리 단체: 허락받을 필요 없이 그냥 쓰세요.

참고: 비상업 제한이 붙은 라이선스는 OSI가 말하는 의미의 "오픈 소스"가 **아닙니다**. *소스 공개(source-available)*입니다: 읽고, 고치고, 나눌 수는 있지만 팔 수는 없습니다.

<p align="center">
  <sub>부엌 식탁 플레이어들이 ❤️와 넉넉한 마나로 만들었습니다</sub><br/><br/>
  <img src="../../DesignSystem/ManaIcons/mana-white.svg" width="22" alt="W">
  <img src="../../DesignSystem/ManaIcons/mana-blue.svg" width="22" alt="U">
  <img src="../../DesignSystem/ManaIcons/mana-black.svg" width="22" alt="B">
  <img src="../../DesignSystem/ManaIcons/mana-red.svg" width="22" alt="R">
  <img src="../../DesignSystem/ManaIcons/mana-green.svg" width="22" alt="G">
</p>
