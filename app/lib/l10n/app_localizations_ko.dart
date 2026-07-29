// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabHome => '홈';

  @override
  String get tabCollection => '컬렉션';

  @override
  String get tabAlbum => '앨범';

  @override
  String get tabDecks => '덱';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => '마켓';

  @override
  String get tabSettings => '설정';

  @override
  String get tabScan => '스캔';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsIntro =>
      'ManaForge는 무료이고 코드도 공개되어 있습니다(PolyForm Noncommercial 라이선스: 공유와 수정은 자유, 판매만 불가). 광고 없음, 프리미엄 없음, 계정 없음. 당신의 카드는 당신의 것입니다.';

  @override
  String get howItWorks => '사용법';

  @override
  String get howScan => '웹캠 앞에 카드를 대거나 사진을 끌어다 놓으면, 정확한 판본으로 컬렉션에 들어갑니다.';

  @override
  String get howCollection =>
      '가진 카드 전부. 검색, 필터, 폴더 제공(폴더는 태그입니다: 한 카드가 여러 폴더에 들어갈 수 있습니다).';

  @override
  String get howAlbum =>
      '세트마다 한 페이지, 스티커 앨범처럼. 가진 카드는 컬러로, 없는 카드는 흐리게, 완성 비용까지 보여줍니다.';

  @override
  String get howForge =>
      '가진 카드만으로 완성된 합법 덱을 만듭니다. 아직 없는 세트로도 만들 수 있고, 무엇을 얼마에 사야 하는지 알려줍니다.';

  @override
  String get howDecks => '저장한 덱들. 카드를 팔면 가진 척하지 않고 사실대로 알려줍니다.';

  @override
  String get howMarket =>
      '컬렉션의 가치와 추이 그래프, 가격 알림이 있는 위시리스트. CSV에 구매가가 있으면 손익도 보여줍니다.';

  @override
  String get howPrivacy =>
      '모든 계산은 기기 안에서 이루어집니다. 인터넷으로 나가는 것은 데이터베이스 내려받기와, 켜 두었다면 새 버전 확인뿐입니다.';

  @override
  String get shortcuts => '키보드 단축키';

  @override
  String get shortcutTabs => '탭 전환';

  @override
  String get shortcutScan => '스캐너 열기';

  @override
  String get shortcutSearch => '현재 탭에서 검색';

  @override
  String get shortcutSettings => '설정';

  @override
  String get shortcutClose => '위에 열린 화면 닫기';

  @override
  String get language => '언어';

  @override
  String get languageSystem => '시스템 설정 따르기';

  @override
  String get versionTitle => 'ManaForge 버전';

  @override
  String versionYouHave(String version) {
    return '현재 $version 버전입니다.';
  }

  @override
  String get versionSeeWhatsNew => '무엇이 바뀌었는지 보기';

  @override
  String get versionNotifyMe => '새 버전 알려주기';

  @override
  String get versionNotifyMeWhy =>
      '하루에 한 번 GitHub에 최신 버전을 확인합니다. 내려받거나 설치하지 않습니다.';

  @override
  String get versionCheckNow => '지금 확인';

  @override
  String get versionUpToDate => '최신 버전입니다(또는 GitHub가 지금 응답하지 않습니다).';

  @override
  String versionThereIs(String version) {
    return 'ManaForge $version이(가) 나왔습니다.';
  }

  @override
  String get versionGoDownload => '내려받기로 이동';

  @override
  String versionNotAuto(String version) {
    return '현재 $version 버전입니다. 앱은 스스로 업데이트하지 않고, 내려받기 페이지로 안내합니다.';
  }

  @override
  String get versionNotNow => '나중에';

  @override
  String get versionSee => '보기';

  @override
  String whatsNewTitle(String version) {
    return '$version의 새로운 점';
  }

  @override
  String get whatsNewClose => '시작하기';

  @override
  String get downloadCopyLink => '링크 복사';

  @override
  String get downloadClose => '닫기';

  @override
  String get downloadTitle => 'ManaForge 내려받기';

  @override
  String get backgroundTitle => '배경 이미지';

  @override
  String get backgroundWhat =>
      '원하는 이미지를 앱 배경으로 둘 수 있습니다. Wizards는 세트마다 공식 배경화면을 공개합니다. 마음에 드는 것을 내려받아 여기서 고르세요. 앱이 대신 내려받지는 않습니다 — 그 그림에는 주인이 있고, 배포는 앱이 할 일이 아닙니다.';

  @override
  String get backgroundPick => '이미지 고르기…';

  @override
  String get backgroundChange => '이미지 바꾸기…';

  @override
  String get backgroundOfficial => 'Magic 공식 배경화면';

  @override
  String get backgroundRemove => '배경 없애기';

  @override
  String get backgroundDim => '어둡게 하는 정도(글자가 읽히도록)';

  @override
  String get backgroundCardColor => '카드 색';

  @override
  String get backgroundTextColor => '글자 색';

  @override
  String get backgroundCardOpacity => '카드가 배경을 가리는 정도';

  @override
  String get backgroundColorDefault => '기본 색';

  @override
  String get backgroundPreview => '미리 보기';

  @override
  String get backgroundNotAnImage => '배경으로 쓸 이미지(.jpg, .png, .webp)를 고르세요.';

  @override
  String get backgroundTooBig => '이 이미지는 배경으로 쓰기에 너무 큽니다.';

  @override
  String get welcomeTitle =>
      'forge에 오신 걸 환영합니다. 원하는 방식으로 카드를 넣거나, 한 장도 없이 Forge를 먼저 써 보세요.';

  @override
  String get welcomeScan => '내 카드 스캔';

  @override
  String get welcomeImport => 'CSV 가져오기';

  @override
  String get welcomeTryForge => '컬렉션 없이 Forge 써보기';

  @override
  String get decksEmptyGoForge => 'Forge로 가기';

  @override
  String get yourCollection => '내 컬렉션';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies장 · $distinct종';
  }

  @override
  String get marketArrow => '마켓 ›';

  @override
  String get certHeadingSetComplete => '컬렉션 완성 증명서';

  @override
  String get certSubtitleSetComplete => '세트 완성';

  @override
  String get certHeadingWelcome => '환영 증명서';

  @override
  String get certWelcomeTitle => 'Magic의 세계에 오신 것을 환영합니다';

  @override
  String get certSubtitleWelcome => '당신의 첫 카드';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count장',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return '$name(으)로 시작했습니다';
  }

  @override
  String get certCollectorAnon => 'ManaForge 컬렉터';

  @override
  String certAwardedTo(String name) {
    return '$name에게 수여';
  }

  @override
  String certOnDate(String date) {
    return '$date';
  }

  @override
  String get certDataBy => '데이터 제공: Scryfall';

  @override
  String get onbCollectionTitle => '내 컬렉션';

  @override
  String get onbCollectionBody => '모든 카드가 여기 있어요. 폴더별·세트별로 정리돼요.';

  @override
  String get onbScanTitle => '카드 스캔';

  @override
  String get onbScanBody => '카메라나 사진으로 새 카드를 추가하세요.';

  @override
  String get onbForgeTitle => '덱 만들기';

  @override
  String get onbForgeBody => '가진 카드만으로 완성된 덱을 생성해요.';

  @override
  String get onbDecksTitle => '내 덱';

  @override
  String get onbDecksBody => 'Forge에서 저장한 덱이 여기에 나와요.';

  @override
  String get onbSkip => '건너뛰기';

  @override
  String get onbNext => '다음';

  @override
  String get onbGotIt => '확인';

  @override
  String get onbBack => '뒤로';

  @override
  String get tourMenuTitle => '가이드';

  @override
  String get tourWelcomeName => '빠른 둘러보기';

  @override
  String get tourHomeName => '홈 화면';

  @override
  String get onbEditHomeTitle => '홈 화면 맞춤';

  @override
  String get onbEditHomeBody => '이 버튼으로 홈에 표시할 섹션과 순서를 고를 수 있어요.';

  @override
  String get onbLangTitle => '언어';

  @override
  String get onbLangBody => '여기서 앱 전체 언어를 바꿔요.';

  @override
  String get onbLookTitle => '모양';

  @override
  String get onbLookBody => '배경을 설정하고 카드·글자·탭·아이콘 색을 골라요.';

  @override
  String get tourSettingsName => '앱 맞춤 설정';

  @override
  String get tourFullName => '앱 전체 둘러보기';

  @override
  String get tourCollectionName => '내 컬렉션과 폴더';

  @override
  String get tourForgeName => '덱 만들기';

  @override
  String get tourMarketName => '마켓, 위시리스트, 알림';

  @override
  String get onbAllCardsTitle => '모든 카드';

  @override
  String get onbAllCardsBody => '컬렉션 전체를 검색하고 필터링하고 정렬합니다.';

  @override
  String get onbFoldersTitle => '폴더';

  @override
  String get onbFoldersBody =>
      '폴더는 태그입니다. 원하는 대로 묶을 수 있고 한 카드가 여러 폴더에 들어갈 수 있습니다. \'새로\'로 첫 폴더를 만듭니다.';

  @override
  String get onbAlbumMineTitle => '세트별 앨범';

  @override
  String get onbAlbumMineBody => '세트마다 빈칸이 있습니다. 이 필터는 이미 카드를 가진 세트만 보여 줍니다.';

  @override
  String get onbForgeBasicsTitle => '기본 대지';

  @override
  String get onbForgeBasicsBody =>
      '집에 낱장 기본 대지가 있다면 켜 두세요. Forge가 그것까지 계산합니다. 끄면 컬렉션에 있는 것만 씁니다.';

  @override
  String get onbForgeSetsTitle => '세트';

  @override
  String get onbForgeSetsBody => '카드가 어디서 나올지 좁힙니다. 아무것도 고르지 않으면 컬렉션 전체를 씁니다.';

  @override
  String get onbForgeMissingTitle => '없는 카드';

  @override
  String get onbForgeMissingBody => '켜면 없는 카드까지 제안하고, 몇 장이 필요한지와 비용을 알려 줍니다.';

  @override
  String get onbForgeDeepTitle => '딥 포지';

  @override
  String get onbForgeDeepBody =>
      '제안을 보여주기 전에 실제로 서로 대결시킵니다. 최종 순위는 정적 점수뿐 아니라 실제 성적을 반영합니다. 더 빠른 결과를 원하면 꺼도 됩니다.';

  @override
  String get onbForgeGoTitle => '만들기';

  @override
  String get onbForgeGoBody => '이 버튼이 덱을 만듭니다. 세트가 많으면 몇 초 걸립니다.';

  @override
  String get onbForgeTestTitle => '테스트 모드';

  @override
  String get onbForgeTestBody => '메타 덱과 붙여 보고 이기려면 무엇이 부족한지 확인합니다.';

  @override
  String get onbMarketPickTitle => '마켓 선택';

  @override
  String get onbMarketPickBody => 'Cardmarket 또는 TCGplayer. 카드 가격과 그래프가 바뀝니다.';

  @override
  String get onbWishlistTitle => '위시리스트';

  @override
  String get onbWishlistBody => '원하는 카드 목록. 목표 가격에 닿으면 카운터가 초록색이 됩니다.';

  @override
  String get onbPriceAlertTitle => '가격 알림';

  @override
  String get onbPriceAlertBody =>
      '카드를 검색해 북마크로 위시리스트에 넣고 목표 가격을 정하면, 가격이 내려갈 때 알려 줍니다.';

  @override
  String get tourProgressName => '업적과 인증서';

  @override
  String get onbAchievementsTitle => '업적과 레벨';

  @override
  String get onbAchievementsBody => '내 레벨과 지금까지 얻은 것들. 스캔하고 정리하고 덱을 만들면 올라갑니다.';

  @override
  String get onbCertificatesTitle => '인증서';

  @override
  String get onbCertificatesBody =>
      '큰 이정표는 상장으로 나옵니다. PDF로 저장하거나 자랑할 수 있고, 업적 안에 있습니다.';

  @override
  String get onbBackupTitle => '백업';

  @override
  String get onbBackupBody =>
      '컬렉션, 덱, 폴더를 파일로 저장하고 컴퓨터를 바꿔도 되살릴 수 있습니다. 매주 자동 백업도 됩니다.';

  @override
  String onbTapHere(String pantalla) {
    return '여기를 누르면 $pantalla이(가) 열립니다.';
  }

  @override
  String get onbAchievementsName => '업적';

  @override
  String get onbDataSectionTitle => '데이터';

  @override
  String get onbDataSectionBody => '앱이 저장하는 것은 모두 여기에 있습니다. 카드 데이터베이스와 백업.';

  @override
  String get onbCardDbTitle => '카드 데이터베이스';

  @override
  String get onbCardDbBody =>
      '새 카드와 최신 가격, Forge의 연도 필터처럼 최신 데이터가 필요한 기능을 위해 다시 내려받습니다.';

  @override
  String get onbAboutTitle => '앱 정보';

  @override
  String get onbAboutBody => '각 탭이 하는 일, 키보드 단축키, 버전과 라이선스.';

  @override
  String get colStartHere => '컬렉션은 여기서 시작해요';

  @override
  String get colNeedDb =>
      '먼저 Magic 카드 전체 데이터베이스가 필요해요 (한 번만 받으면 그다음부터는 인터넷 없이도 다 돌아가요).';

  @override
  String colDownloading(String pct) {
    return '내려받는 중… $pct %';
  }

  @override
  String get colDownloadDb => '카드 데이터베이스 내려받기';

  @override
  String get colScryfall =>
      '데이터와 이미지는 Scryfall 제공 · 계정도 결제도 없이, 전부 기기 안에만 남아요.';

  @override
  String get colAlbumTooltip => '세트별 앨범';

  @override
  String get colImportTooltip => '컬렉션 CSV 가져오기';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '카드 $copies장 · 서로 다른 $distinct종$valor';
  }

  @override
  String get colAllCards => '카드 전체';

  @override
  String colAllCardsSub(int distinct) {
    return '서로 다른 $distinct종 · 검색, 필터, 정렬';
  }

  @override
  String get colFolders => '폴더';

  @override
  String get colNewFolder => '새로';

  @override
  String get colNoFolders =>
      '아직 폴더가 없어요. 원하는 대로 묶어두는 용도예요: “Aetherdrift 레어”, “팔 것”, “맨 위 상자”… 카드 하나가 여러 폴더에 들어갈 수도 있어요.';

  @override
  String get colCreateFirstFolder => '첫 폴더 만들기';

  @override
  String get colEmptyTitle => '여기서 컬렉션이 시작돼요';

  @override
  String get colEmptyBody => '카메라로 카드를 스캔하거나 컬렉션 CSV를 가져오세요. 여기와 앨범에 나타나요.';

  @override
  String get colImportShort => 'CSV 가져오기';

  @override
  String acForgetTitle(String carta) {
    return '$carta, 이제 없나요?';
  }

  @override
  String get acForgetBody => '컬렉션에서 빠지고, 앨범의 그 자리도 다시 비어요.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '들어 있던 폴더 $n개에서도 빠져요.',
      one: '들어 있던 폴더에서도 빠져요.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks => '덱은 이 카드를 잃지 않아요: 목록에는 남고, 덱이 부족하다고 알려줘요.';

  @override
  String get acCancel => '취소';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => '이제 없어요';

  @override
  String acAddedOn(String cuando) {
    return '$cuando 추가';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '폴더 $n개에',
      one: '폴더 1개에',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => '카드 검색 (스페인어 또는 영어)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '카드 $total장 중 $visibles장';
  }

  @override
  String get acMissingFilterData =>
      ' · 오래된 카드 일부는 필터 데이터가 없어요: “대체”를 켜고 CSV를 다시 가져오세요';

  @override
  String get acNoneMatch => '이 필터를 통과하는 카드가 없어요.';

  @override
  String get acEmptyHint => '위에서 첫 카드를 검색하거나, 뒤로 가서 컬렉션 CSV를 가져오세요.';

  @override
  String get onbHowItWorksBody => '각 탭이 뭘 하는지와 단축키 요약. 길을 잃으면 여기서 시작하세요.';

  @override
  String get onbVersionBody =>
      '지금 버전이 뭔지, 뭐가 들었는지, 그리고 새 버전이 있는지 하루 한 번 확인할지 여부. 저절로 업데이트되진 않아요.';

  @override
  String get onbSuggestionsTitle => '제안함';

  @override
  String get onbSuggestionsBody =>
      '아이디어가 있거나 버그를 발견했나요? GitHub에 알려주세요. 양식이 있어서 1분이면 됩니다.';

  @override
  String get onbSupportTitle => '프로젝트 후원하기';

  @override
  String get onbSupportBody =>
      '이 앱은 무료이고 광고도 없습니다. 도움이 되셨다면, 커피 한 잔 후원하는 방법은 여기 있습니다.';

  @override
  String get onbScanSetTitle => '세트: 전체';

  @override
  String get onbScanSetBody =>
      '한 세트 부스터만 뜯는 중이면 여기 고정하세요: 스캐너가 같은 카드의 열 가지 재판본 사이에서 헤매지 않아요.';

  @override
  String get onbScanModeTitle => '빠르게 또는 꼼꼼하게';

  @override
  String get onbScanModeBody =>
      '「빠르게」에서는 확실한 카드는 알아서 들어가고 애매한 건 검토용으로 표시돼요. 「꼼꼼하게」에서는 멈춰서 어느 카드인지 물어봐요.';

  @override
  String get onbScanPhotoTitle => '사진 스캔하기';

  @override
  String get onbScanPhotoBody =>
      '카메라가 없거나 카드를 이미 찍어뒀나요? 여기에 사진을 놓으면 —원하면 여러 장이라도— 똑같이 다 뽑아내요.';

  @override
  String get tourScanName => '스캐너';

  @override
  String get albNeedDb => '앨범에는 카드 데이터베이스가 필요해요 (컬렉션에서 내려받으세요).';

  @override
  String get albRetry => '다시 시도';

  @override
  String get albApproxMode =>
      '앨범이 대략 모드예요: 각 카드의 정확한 에디션을 아직 몰라요. “현재 컬렉션 대체”를 켜고 CSV를 다시 가져오면 앨범이 일러스트 단위로 정밀해져요.';

  @override
  String get albSearchSet => '세트 검색…';

  @override
  String get albOnlyMine => '내 카드 있는 것만';

  @override
  String get albSortProgress => '완성도순';

  @override
  String get albSortNewest => '최신순';

  @override
  String get albSortOldest => '오래된순';

  @override
  String get albSortName => '이름순';

  @override
  String get albYearAll => '연도: 전체';

  @override
  String get albLetterAll => '전체';

  @override
  String get albNoSets => '필터에 맞는 세트가 없어요.';

  @override
  String albSetProgress(int owned, int total) {
    return '카드 $owned/$total';
  }

  @override
  String get albComplete => ' · ✓ 완성!';

  @override
  String albLoadError(String error) {
    return '세트를 불러오지 못했어요: $error';
  }

  @override
  String albSearchIn(String set) {
    return '$set에서 검색…';
  }

  @override
  String get albOnlyMissing => '빠진 것만';

  @override
  String get albWithVariants => '변형 포함';

  @override
  String get albYouHaveItAll => '✓ 전부 모았어요';

  @override
  String albMissingCount(int n) {
    return '$n장 부족 · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n장 가격 없음)';
  }

  @override
  String albNoPerPrinting(String market) {
    return '$market no publica precios por edición — elige otro en la pestaña Mercado';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$total 중 $visibles';
  }

  @override
  String get albNoCardsNamed => '그 이름의 카드는 여기 없어요.';

  @override
  String get fdNewFolder => '새 폴더';

  @override
  String get fdEditFolder => '폴더 편집';

  @override
  String get fdName => '이름';

  @override
  String get fdNameHint => 'Aetherdrift 레어, 팔 것…';

  @override
  String get fdColor => '색';

  @override
  String get fdIcon => '아이콘';

  @override
  String get fdCreate => '만들기';

  @override
  String get fdSave => '저장';

  @override
  String get fdDefaultName => '폴더';

  @override
  String fdDeleteTitle(String nombre) {
    return '“$nombre” 삭제할까요?';
  }

  @override
  String get fdDeleteBody => '폴더만 지워져요: 카드는 컬렉션에 그대로 남아요.';

  @override
  String get fdDelete => '삭제';

  @override
  String get fdGone => '이 폴더는 이제 없어요.';

  @override
  String get fdEditTooltip => '이름, 색, 아이콘 편집';

  @override
  String get fdDeleteTooltip => '폴더 삭제';

  @override
  String get fdAddRemove => '추가/제거';

  @override
  String fdCounts(int distintas, int copias) {
    return '서로 다른 카드 $distintas종 · $copias장';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n장이 필터 통과';
  }

  @override
  String get fdRoughValue => ' · 대략적인 가치';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '카드 $n장이 컬렉션에서 빠졌어요 (돌아올 때를 대비해 계속 기록해 둬요).',
      one: '카드 1장이 컬렉션에서 빠졌어요 (돌아올 때를 대비해 계속 기록해 둬요).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => '빼기';

  @override
  String get fdNoneMatch => '이 필터를 통과하는 카드가 폴더에 없어요.';

  @override
  String get fdEmpty => '빈 폴더예요. “추가/제거”를 눌러 넣고 싶은 카드를 선택하세요.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n장',
      one: '1장',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => '폴더에서 빼기';

  @override
  String get fpPickCards => '카드 선택';

  @override
  String fpSaveCount(int n) {
    return '저장 ($n)';
  }

  @override
  String get fpFilterByName => '이름으로 필터…';

  @override
  String fpVisibleCards(int n) {
    return '표시된 카드 $n장';
  }

  @override
  String get fpSelectAll => '전체 선택';

  @override
  String get fpNoneMatch => '이 필터를 통과하는 카드가 없어요.';

  @override
  String get fgMsgReading => '컬렉션을 읽는 중…';

  @override
  String get fgMsgCurve => '마나 커브를 계산하는 중…';

  @override
  String get fgMsgLands => '대지를 배분하는 중…';

  @override
  String get fgMsgSynergy => '시너지를 찾는 중…';

  @override
  String get fgMsgPlan => '게임 플랜을 짜는 중…';

  @override
  String get fgNeedDbForSets => '세트를 나열하려면 카드 데이터베이스가 필요해요: 설정 → 데이터베이스 내려받기.';

  @override
  String fgDbError(String error) {
    return '카드 데이터베이스를 읽지 못했어요: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' 그 $n개 세트에서',
      one: ' 그 세트에서',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return '합법적인 Commander 덱이 안 나와요$donde: 전설적 커맨더 하나와 색 정체성 안의 서로 다른 카드 약 62종(싱글턴이니까), 그리고 충분한 기본 대지가 필요해요. 다른 포맷이나 다른 세트를 시도하거나 컬렉션을 늘려보세요.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return '이 풀의 카드로는 제 규칙(충분한 대지와 건강한 커브)을 만족하는 완성된 $formato 덱이 안 나와요$donde. $consejo 엉성한 덱을 드리느니 미리 알려드릴게요.';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return '이 스타일($estilo)로는 덱이 나오지 않아요. \"스타일: 자동\" 또는 다른 종족을 시도해 보세요.';
  }

  @override
  String get fgOf60 => '/ 60';

  @override
  String fgLegalIn(String formato) {
    return '$formato에서 합법';
  }

  @override
  String get fgTipMoreSets => '세트를 더 넣거나 필터를 빼보세요.';

  @override
  String get fgTipMoreCards => '카드를 더 추가하거나 — 특히 주력 색으로 — “없는 카드 포함”을 선택하세요.';

  @override
  String get fgPitch => '이미 가진 카드로 완성된, 바로 쓸 수 있는 덱. 아무것도 안 사도 돼요.';

  @override
  String get fgTeaserCount => '첫 덱을 위한 카드';

  @override
  String get fgTeaserMissing => '없는 카드로 덱 만들기';

  @override
  String get fgBasics => '낱장 기본 대지가 있다고 가정';

  @override
  String get fgBasicsSub =>
      '거의 다들 스타터 덱 기본 대지를 갖고 있죠; 컬렉션에 있는 기본 대지만 쓰려면 꺼두세요.';

  @override
  String get fgFormat => '게임 포맷';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote => '카드 100장 · 싱글턴 · 컬렉션 속 전설적 커맨더 · 색 정체성 준수.';

  @override
  String get fgCasualNote => '카드 60장, 합법성 제한 없음: 뭐든 OK.';

  @override
  String fgFormatNote(String formato) {
    return '$formato에서 합법인 네 카드만 써서 60장.';
  }

  @override
  String get fgWhereFrom => '카드는 어디서 가져오나요?';

  @override
  String get fgPickSets => '세트 선택';

  @override
  String get fgChangeSets => '세트 변경';

  @override
  String get fgNeedOneSet => '세트를 하나 이상 고르세요: 필터가 없으면 Magic 카드 약 3만 장 전부가 돼요.';

  @override
  String get fgNoSetsNote => '세트를 안 고르면 Forge는 컬렉션 전체를 써요.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '세트 $n개의 카드, 갖고 있든 없든.',
      one: '세트 1개의 카드, 갖고 있든 없든.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '세트 $n개의 네 카드만 — 컬렉션 전체가 아니라.',
      one: '세트 1개의 네 카드만 — 컬렉션 전체가 아니라.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      '컬렉션이 각 카드의 에디션을 저장하지 않아서, 세트로 필터하면 거의 다 빠져요. “대체”를 켜고 CSV를 다시 가져온 뒤 돌아오세요.';

  @override
  String get fgIncludeMissing => '없는 카드 포함';

  @override
  String get fgIncludeMissingSub =>
      'Forge가 컬렉션에만 머물지 않고 그 세트에 인쇄된 모든 카드를 써요; 그다음 몇 장이 부족하고 얼마인지 알려줘요.';

  @override
  String get fgYourTaste => '취향대로 (선택)';

  @override
  String get fgArchetypeAuto => '아키타입: 자동';

  @override
  String get fgStyle => '스타일';

  @override
  String get fgStyleAuto => '스타일: 자동';

  @override
  String get fgTribeElf => '엘프';

  @override
  String get fgTribeGoblin => '고블린';

  @override
  String get fgTribeZombie => '좀비';

  @override
  String get fgTribeVampire => '흡혈귀';

  @override
  String get fgTribeDragon => '드래곤';

  @override
  String get fgTribeAngel => '천사';

  @override
  String get fgTribeDemon => '악마';

  @override
  String get fgTribeDinosaur => '공룡';

  @override
  String get fgTribeFaerie => '요정';

  @override
  String get fgTribeMerfolk => '인어';

  @override
  String get fgTribeHuman => '인간';

  @override
  String get fgTribeSpirit => '정령';

  @override
  String get fgTribeSliver => '슬리버';

  @override
  String get fgTribeWizard => '마법사';

  @override
  String get fgTribeKnight => '기사';

  @override
  String get fgTribeWarrior => '전사';

  @override
  String get fgTribeSoldier => '병사';

  @override
  String get fgTribeCat => '고양이';

  @override
  String get fgTribeDog => '개';

  @override
  String get fgTribeRat => '쥐';

  @override
  String get fgTribePirate => '해적';

  @override
  String get fgTribeElemental => '정령체';

  @override
  String get fgTribeGiant => '거인';

  @override
  String get fgTribeRogue => '도적';

  @override
  String get fgDeepForge => '딥 포지';

  @override
  String get fgDeepForgeHint => '제안을 보여주기 전에 실제로 서로 대결시켜 봅니다 (조금 더 기다려야 해요).';

  @override
  String get fgPricePerCard => '카드당 가격:';

  @override
  String get fgMin => '최소 €';

  @override
  String get fgMax => '최대 €';

  @override
  String get fgCardYear => '카드 출시 연도:';

  @override
  String get fgFrom => '부터';

  @override
  String get fgTo => '까지';

  @override
  String get fgYearNeedsDb => '연도 필터에는 최신 데이터베이스가 필요해요: 설정 → 데이터베이스 다시 내려받기.';

  @override
  String get fgNoColorsNote => '색을 안 고르면 Forge가 모든 조합을 시도해요.';

  @override
  String fgColorsNote(String colores) {
    return '$colores 덱만 (그 조합 포함).';
  }

  @override
  String get fgMissingNote =>
      '이 덱에는 없는 카드가 들어갈 수 있어요: 각 제안이 몇 장 부족하고 얼마인지 알려줘요 (Cardmarket 가격).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge는 네 카드 $n장만 써요. 없는 카드를 지어내지 않아요.';
  }

  @override
  String get fgForgeMissing => '덱 벼리기 (부족한 카드 포함)';

  @override
  String get fgForgeMine => '내 덱 벼리기';

  @override
  String get fgTestMode => '테스트 모드: 메타 덱을 이겨보기';

  @override
  String get fgOffline => '모든 계산은 기기 안에서, 인터넷 없이';

  @override
  String fgForgingWith(int n) {
    return '카드 $n장으로 벼리는 중: 몇 초 걸려요. 창은 멀쩡히 살아 있어요.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '바로 쓸 수 있는 덱 $n개',
      one: '바로 쓸 수 있는 덱 1개',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing => '아직 없는 카드 포함 · 밀어서 비교';

  @override
  String get fgSwipeMine => '네 카드만으로 완성 · 밀어서 비교';

  @override
  String get fgHaveAll => '✓ 카드가 다 있어요';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '카드 $n장 부족',
      one: '카드 1장 부족',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => '덱 전체 보기';

  @override
  String get fgReforge => '다시 벼리기';

  @override
  String get fgBackToOptions => 'Volver a elegir cómo forjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta이(가) $precio예요 (목표가: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 위시리스트 카드 $n장이 목표가까지 떨어졌어요!';
  }

  @override
  String get mkTellMeWhenDrops => '내려가면 알려주기';

  @override
  String get mkTargetPrice => '목표가';

  @override
  String mkNow(String precio) {
    return '현재: $precio';
  }

  @override
  String get mkUpdated => '✓ 가격과 카드 업데이트됨';

  @override
  String mkUpdateFailed(String error) {
    return '업데이트하지 못했어요: $error';
  }

  @override
  String get mkHistoryReady => '✓ 가격 이력 준비됨: 그래프에 최근 몇 달이 나와요';

  @override
  String mkHistoryFailed(String error) {
    return '이력을 가져오지 못했어요 (기존 이력은 그대로예요): $error';
  }

  @override
  String get mkHistoryLocal =>
      '가격 이력: ManaForge가 네 기기에서 매일 적어둔 것만 있어요. Cardmarket의 실제 최근 약 90일치를 가져오세요 (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return '$desde부터 $hasta까지 Cardmarket 실제 이력, 그 이후로는 ManaForge가 적은 것.';
  }

  @override
  String get mkFetchHistory => '이력 가져오기';

  @override
  String get mkCollectionValue => '컬렉션 가치 · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '카드 $n장';
  }

  @override
  String get mkApproxSuffix => ' · 대략적인 가치';

  @override
  String mkBulkPrices(String fecha) {
    return '$fecha 기준 Cardmarket 가격 (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return '마켓 데이터 없음: 컬렉션에서 데이터베이스를 내려받으세요. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return '세트 ($n)';
  }

  @override
  String get mkPrevious => '이전';

  @override
  String get mkNext => '다음';

  @override
  String get mkSearchHint => '아무 카드나 가격 검색…';

  @override
  String get mkRemoveFromWishlist => '위시리스트에서 빼기';

  @override
  String get mkAddToWishlist => '위시리스트에 추가: 내려가면 알려주기';

  @override
  String get mkYourWishlist => '내 위시리스트';

  @override
  String mkTargetAtMost(String precio) {
    return '목표 ≤ $precio';
  }

  @override
  String get mkAtPrice => '목표가 도달!';

  @override
  String get mkChangeTarget => '목표가 변경';

  @override
  String mkNoPriceIn(String market) {
    return '$market 가격 없음';
  }

  @override
  String get mkPerUnit => '/장';

  @override
  String get mkTopCards => '가장 값나가는 카드';

  @override
  String get mkImportToSeeValue => '가치를 보려면 컬렉션을 가져오세요.';

  @override
  String mkSetCards(int n) {
    return ' · 카드 $n장';
  }

  @override
  String get wlEmpty => '마켓에서 검색한 뒤 북마크를 눌러, 목표가까지 내려가면 알림받으세요.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '🔔 위시리스트 카드 $n장이 목표가 이하예요.',
      one: '🔔 위시리스트 카드 1장이 목표가 이하예요.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'MTGO 가격, 단위 tix (디지털 카드)';

  @override
  String get mpNoDataYet => '아직 데이터 없음: 마켓에서 가격 이력을 업데이트하세요';

  @override
  String get mpMtgoNote =>
      'MTGO 가격은 tix 단위: 디지털 카드라 종이 컬렉션 가치 산정엔 못 써요. 홈, 폴더, 업적은 계속 Cardmarket (€) 기준이에요.';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return '$mercado 가격, 단위 $moneda. 홈, 폴더, 업적은 계속 Cardmarket (€)로 평가해요: 통화는 변환되지 않아요.';
  }

  @override
  String get mkUpdate => '업데이트';

  @override
  String get mkApproxValue => ' · 대략적인 가치 (에디션별 가격을 원하면 “대체”로 다시 가져오세요)';

  @override
  String get mkExactPrintings => ' · 네 정확한 에디션 기준';

  @override
  String mkNowSuffix(String precio) {
    return ' · 현재 $precio';
  }

  @override
  String get wlNothingYet => '아직 위시리스트에 카드가 없어요.';

  @override
  String get stDbUpdated => '✓ 데이터베이스 업데이트됨';

  @override
  String stUpdateFailed(String error) {
    return '업데이트하지 못했어요: $error';
  }

  @override
  String get stCardDb => '카드 데이터베이스';

  @override
  String get stCardDbWhy =>
      '새 카드, 최신 가격, 그리고 최신 데이터가 필요한 기능(Forge의 연도 필터 같은)을 쓰려면 다시 내려받으세요.';

  @override
  String get stDownloadDbAgain => '데이터베이스 다시 내려받기';

  @override
  String get stAppearance => '외관';

  @override
  String get stData => '데이터';

  @override
  String get stTheApp => '앱 정보';

  @override
  String get stCredits =>
      '카드 데이터와 이미지는 Scryfall 제공. Magic: The Gathering은 Wizards of the Coast 소유이며, 이 앱은 Fan Content Policy에 따른 팬 프로젝트예요.';

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
  String get stEditHome => '홈 편집';

  @override
  String get stEditHomeSub => '어떤 섹션을 어떤 순서로 볼지 고르세요';

  @override
  String get ehLevel => '내 레벨';

  @override
  String get ehShortcuts => '바로가기';

  @override
  String get ehSummary => '컬렉션 요약';

  @override
  String get ehRecent => '최근 본 카드';

  @override
  String get ehDecks => '내 덱';

  @override
  String get ehMeta => '지금 메타';

  @override
  String get ehNewSets => '새 세트';

  @override
  String get ehGems => '내 보물';

  @override
  String get ehStatCards => '장';

  @override
  String get ehStatDistinct => '종';

  @override
  String get ehStatValue => '가치';

  @override
  String get ehStatDecks => '덱';

  @override
  String get ehStatAchievements => '업적';

  @override
  String get ehHelp =>
      '드래그로 순서를 바꾸고 스위치로 홈에 뭘 볼지 고르세요. 켜둔 섹션도 보여줄 게 있을 때만 나타나요.';

  @override
  String get ehSection => '섹션';

  @override
  String get bkNoData => '데이터를 찾지 못했어요.';

  @override
  String bkSaved(String resumen) {
    return '✓ 백업 저장됨 · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return '저장하지 못했어요: $error';
  }

  @override
  String get bkFileName => 'ManaForge 백업';

  @override
  String bkRestoreFailed(String error) {
    return '복원하지 못했어요: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ 복원됨 · $resumen. 주의: 이전 데이터를 저장하지 못했어요 ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ 복원됨 · $resumen. 이전 데이터는 backups 폴더에 저장돼 있어요.';
  }

  @override
  String get bkRestoring => '백업을 복원하는 중…';

  @override
  String get bkTitle => '백업';

  @override
  String get bkWhy =>
      '네 카드, 덱, 폴더, 업적은 이 컴퓨터에만 있어요. 가끔 백업을 만들어 다른 곳에 두세요: 외장 디스크, 클라우드, 뭐든요.';

  @override
  String get bkSave => '백업 저장';

  @override
  String get bkRestoreTitle => '백업 복원';

  @override
  String bkRestoreWarning(String palabra) {
    return '복원하면 지금의 카드, 덱, 폴더, 업적이 백업 것으로 대체돼요. 어느 백업인지 고르고 버튼을 누른 뒤 $palabra을(를) 입력하세요: 실수로 복원되는 일이 없게요.';
  }

  @override
  String get bkNoBackups => '이 컴퓨터에 저장된 백업이 아직 없어요.';

  @override
  String get bkWhich => '복원할 백업';

  @override
  String get bkPickOne => '백업 하나 고르기';

  @override
  String get bkRestorePicked => '고른 백업 복원';

  @override
  String get bkAutoNote => '매주 자동 백업을 하나씩 만들고(최근 다섯 개 보관), 복원 직전에도 하나 만들어요.';

  @override
  String get bkFromFile => '파일에서 복원';

  @override
  String get bkConfirmTitle => '이 백업을 복원할까요?';

  @override
  String get bkConfirmBody =>
      '지금의 컬렉션, 덱, 폴더, 업적이 그 백업 것으로 대체돼요. 그 전에 지금 데이터를 backups 폴더에 저장해 둘게요, 되돌리고 싶을 때를 위해.';

  @override
  String bkWillDelete(String cosas) {
    return '그 백업에는 $cosas이(가) 없어요: 복원하면 그건 지워져요.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return '계속하려면 $palabra을(를) 입력하세요:';
  }

  @override
  String get bkAnd => ' 및 ';

  @override
  String get ehReset => '초기화';

  @override
  String bkOfDate(String cuando, String resumen) {
    return '$cuando 백업 · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => '카메라를 찾지 못했어요.';

  @override
  String get lsCameraGone => '세션 중에 카메라 연결이 끊겼어요. 케이블을 확인하고 다시 시도를 누르세요.';

  @override
  String get lsFrameCard => '카드를 틀 안에 맞추세요';

  @override
  String get lsNoCardThere => '거기 카드가 안 보여요';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ 컬렉션에 카드 $n장',
      one: '✓ 컬렉션에 카드 1장',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', 그리고 “$carpeta”에';
  }

  @override
  String get lsTitle => '실시간 스캔';

  @override
  String get lsQuickTip => '빠르게: 확실한 카드는 알아서 들어가고, 애매한 건 검토용으로 표시돼요.';

  @override
  String get lsCarefulTip => '꼼꼼하게: 애매한 카드는 멈춰서 어느 것인지 물어봐요.';

  @override
  String get lsQuick => '빠르게';

  @override
  String get lsCareful => '꼼꼼하게';

  @override
  String lsThisSession(int n) {
    return '이번 세션 $n장';
  }

  @override
  String get lsScanPhotoTooltip => '사진 한 장 스캔하기';

  @override
  String get lsStartingCamera => '카메라를 켜는 중…';

  @override
  String get lsCantUseCamera => '카메라를 쓸 수 없어요';

  @override
  String get lsCameraUnavailable => '카메라를 사용할 수 없어요.';

  @override
  String get lsScanPhoto => '사진 스캔하기';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 같은 카드 · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return '이미 테이블에 있어요: $carta · 치웠다가 다시 놓거나 “+1 같은 카드”를 누르세요';
  }

  @override
  String lsSeeing(String carta) {
    return '인식 중: $carta';
  }

  @override
  String get lsPassACard => '카메라 앞으로 카드를 지나가게 하세요…';

  @override
  String lsIsThis(String carta) {
    return '$carta인가요? 확실치 않아요 — 눌러서 고르세요.';
  }

  @override
  String get lsNotThisOne => '이거 아니에요 — 버전 바꾸기';

  @override
  String get lsRetry => '다시 시도';

  @override
  String get scBadImage => '그 이미지를 읽지 못했어요 (제대로 된 사진인가요?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => '폴더 없음';

  @override
  String scAlsoTo(String carpeta) {
    return '추가로: $carpeta에';
  }

  @override
  String get scLookingForCard => '사진 속 카드를 찾는 중…';

  @override
  String scRecognising(int hechas, int total) {
    return '인식 중… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '카드 $n종',
      one: '카드 1종',
    );
    return '$_temp0 · 총 $copias장';
  }

  @override
  String scToReview(int n) {
    return '검토할 $n장 (누르세요)';
  }

  @override
  String scUnknown(int n) {
    return '인식 안 된 $n장 (눌러서 직접 고르기)';
  }

  @override
  String scSkipped(int n) {
    return '$n장의 사진을 건너뛰었어요 (너무 크거나 읽을 수 없어요)';
  }

  @override
  String get scNothingRecognised =>
      '그 사진들에서 카드를 하나도 인식하지 못했어요. 조명을 밝게 하거나 반사를 줄여보세요.';

  @override
  String scAddN(int n) {
    return '컬렉션에 $n장 추가';
  }

  @override
  String get scDropPhotos => '여기에 카드 사진을 놓으세요';

  @override
  String get scDropExplain =>
      '한 장이든 여러 장이든 한꺼번에 — 사진 한 장에 카드가 여러 장(앨범 한 페이지, 가득한 테이블) 있어도 전부 뽑아서 목록으로 모아드려요. 검토하고 원하는 것만 추가하세요. 휴대폰 사진이나 스캔 다 돼요.';

  @override
  String get scPickPhotos => '사진 고르기';

  @override
  String get scMatchHigh => '일치도 높음';

  @override
  String get scMatchMedium => '일치도 보통';

  @override
  String get scMatchLow => '일치도 낮음';

  @override
  String get scAddToCollection => '컬렉션에 추가';

  @override
  String get scSeeOptions => '이거 아니에요 — 후보 보기';

  @override
  String get scScanAnother => '다른 카드 스캔';

  @override
  String get scNotSure => '확실치 않아요';

  @override
  String get scWhichIsIt => '어느 카드인가요?';

  @override
  String get scNoneQuiteFits =>
      '딱 맞는 게 없어요. 이 중에 있나요? 없으면 조명을 밝게 해서 다른 사진을 찍어보세요.';

  @override
  String get scNoEdges => '카드 테두리를 못 봐서 이미지 전체를 썼어요. 비슷한 후보는 이거예요:';

  @override
  String get scCropped => '이렇게 잘라냈어요. 비슷한 순으로 후보:';

  @override
  String get scDiscard => '버리고 다른 카드 스캔';

  @override
  String get suCardsName => '카드와 가격';

  @override
  String get suCardsWhat => 'Scryfall 전체 카탈로그';

  @override
  String get suHistoryName => '가격 이력';

  @override
  String get suHistoryWhat => 'Cardmarket 약 90일치';

  @override
  String get suHashesName => '스캐너 지문';

  @override
  String get suHashesWhat => '사진 인식용';

  @override
  String suUpToDate(String fecha) {
    return '최신 ($fecha)';
  }

  @override
  String get suUpdated => '업데이트됨';

  @override
  String suUpdatedWithDate(String fecha) {
    return '업데이트됨 ($fecha)';
  }

  @override
  String get suFailedOffline => '가져오지 못했어요 (오프라인)';

  @override
  String get suKeepingOld => '기존 것을 계속 써요';

  @override
  String get suNeedMissing => '없어서 가져올게요';

  @override
  String get suNeedStale => '새 버전 있음';

  @override
  String get suNeedFresh => '최신';

  @override
  String get suAllUpToDate => '전부 최신이에요. 들어가는 중…';

  @override
  String get suUpdatingCards => '카드와 가격을 최신으로 맞추는 중…';

  @override
  String get suChecking => '새 소식이 있는지 확인하는 중…';

  @override
  String get suNoDownloadNote =>
      '이미 최신인 건 내려받지 않아요. 앱 안에서 어떤 업데이트든 강제로 실행할 수 있어요.';

  @override
  String get suEnter => '들어가기';

  @override
  String get suEnterNow => '지금 들어가기';

  @override
  String icBadFile(String error) {
    return '파일을 읽지 못했어요: $error';
  }

  @override
  String get icNotCsv => 'CSV처럼 안 보여요 — .csv나 .txt 파일을 놓으세요.';

  @override
  String get icTitle => '컬렉션 가져오기';

  @override
  String get icExplain =>
      '컬렉션 CSV를 여기로 드래그하거나(Moxfield, Archidekt, 또는 Name과 Quantity 열이 있는 아무 CSV도 돼요), 버튼으로 고르거나, 내용을 직접 붙여넣으세요:';

  @override
  String get icPickFile => '파일 고르기…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ 카드 $cartas종 ($copias장)을 컬렉션에 추가했어요.';
  }

  @override
  String get icReplaceMine => '현재 컬렉션 대체';

  @override
  String get icReplaceWhy =>
      '전체 CSV를 다시 가져올 때 켜세요: 수량 중복을 막고 앨범을 에디션 단위로 정밀하게 해줘요.';

  @override
  String icImporting(int hechas, int total) {
    return '카드 $total장 중 $hechas장 가져오는 중…';
  }

  @override
  String get icDropHere => 'CSV를 여기에 놓으세요';

  @override
  String icTokensIgnored(int n) {
    return '\n• 토큰/엠블럼 $n개 무시됨 (덱에 안 들어가요, 문제없어요).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ 인식 안 됨: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• CSV에 구매가가 없어요: P&L은 안 나와요 (“Purchase price” 열을 포함해 내보내세요).';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• 구매가가 있는 $n장: 이제 마켓에서 P&L을 볼 수 있어요.';
  }

  @override
  String get icImporting2 => '가져오는 중…';

  @override
  String get icImport => '가져오기';

  @override
  String dkDeleted(String nombre) {
    return '덱 “$nombre” 삭제됨';
  }

  @override
  String get dkUndo => '실행 취소';

  @override
  String dkOpenFailed(String error) {
    return '덱을 열지 못했어요 (데이터베이스를 내려받았나요?): $error';
  }

  @override
  String get dkMyDecks => '내 덱';

  @override
  String get dkEmpty => 'Forge에서 저장한 덱이 여기 모여요 (덱 상세 화면의 저장 버튼).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n개 저장됨',
      one: '1개 저장됨',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · 주문 $hechizos장 + 대지 $tierras장 · $fecha 저장';
  }

  @override
  String get dkDeleteTooltip => '덱 삭제';

  @override
  String get ddSaved => '✓ 덱 저장됨 — 덱 탭에 있어요';

  @override
  String get ddReforged => '✓ 네 커브에 맞춰 덱을 다시 벼렸어요 — 목록 업데이트됨';

  @override
  String get ddSaveToMyDecks => '내 덱에 저장';

  @override
  String get ddCopyList => '목록 복사 (Moxfield/Arena)';

  @override
  String get ddListCopied => '✓ 목록 복사됨 — Moxfield, Arena, Discord에 붙여넣으세요';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · 주문 $hechizos장 + 대지 $tierras장';
  }

  @override
  String get ddHaveAll => '✓ 카드가 다 있어요';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '⚠ 이 덱에서 카드 $n장이 부족해요 — 목록에는 남아 있어요, 지워지지 않았어요',
      one: '⚠ 이 덱에서 카드 1장이 부족해요 — 목록에는 남아 있어요, 지워지지 않았어요',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => '게임 플랜';

  @override
  String get ddManaCurve => '마나 커브';

  @override
  String get ddEditCurve => '커브 편집';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return '막대를 위아래로 드래그 ↑↓ · 주문 $hechizos장 → 대지 $tierras장';
  }

  @override
  String get ddReforgeCurve => '이 커브로 다시 벼리기';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ 대지 $tierras장 · ✦ 주문 $hechizos장 · 평균 비용 $coste';
  }

  @override
  String get ddWhyWorks => '이 덱이 왜 잘 돌아가나요?';

  @override
  String ddLands(int n) {
    return '대지 ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return '덱 총액: 약 $precio €';
  }

  @override
  String get ddCheapestPrice => '가장 싼 에디션 가격 (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n장 가격 미상 · 가장 싼 에디션 (Cardmarket)';
  }

  @override
  String get ddInstants => '순간마법';

  @override
  String get ddTypeCreatures => '생물';

  @override
  String get ddTypeSorceries => '집중마법';

  @override
  String get ddTypeEnchantments => '부여마법';

  @override
  String get ddTypeArtifacts => '마법물체';

  @override
  String get ddTypeOther => '기타';

  @override
  String get ddOutOfRange => '  (건강 범위 20-27 벗어남)';

  @override
  String get acRecalcTitle => '업적을 다시 계산할까요?';

  @override
  String get acRecalcBody =>
      '카드를 다시 살펴서 지금 조건에 안 맞는 업적을 빼요. 잘못 준 업적을 바로잡는 용도예요; 카드를 팔았다면 그 업적도 잃어요.';

  @override
  String get acRecalc => '다시 계산';

  @override
  String get acAllFine => '다 맞았어요: 빠진 업적이 없어요.';

  @override
  String acRemovedN(int n) {
    return '더는 충족 안 되는 업적 $n개를 뺐어요.';
  }

  @override
  String get acTitle => '업적';

  @override
  String get acRecalcTooltip => '지금 카드로 다시 계산';

  @override
  String get acCertsTooltip => '인증서';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '업적 $total개 중 $hechos개 · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return '레벨 $nivel · $siguiente까지 $xp XP 남음';
  }

  @override
  String get acIMissing => '부족한 것';

  @override
  String get acSecret => '숨겨진 업적';

  @override
  String get acSecretDesc => '달성해야 정체가 드러나요.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ 달성$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return '레벨 $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return '이제 $titulo예요. 업적 $total개 중 $hechos개 달성.';
  }

  @override
  String get acOk => '확인';

  @override
  String get acSeeAchievements => '업적 보기';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 업적 달성! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (외 $n개)';
  }

  @override
  String ceNeedDb(String error) {
    return '세트 관련은 카드 데이터베이스가 필요해요 ($error)';
  }

  @override
  String get ceWhoseName => '누구 앞으로 할까요?';

  @override
  String get ceCollectorName => '수집가 이름';

  @override
  String get ceInNameOf => '누구 앞으로…';

  @override
  String get ceEmptyWithData =>
      '아직 완성한 세트가 없어요. 앨범에서 한 세트를 통째로 완성하면, 여기에 내려받을 인증서가 나와요.';

  @override
  String get ceEmptyNoData =>
      '세트를 인증하려면 카드의 정확한 에디션을 알아야 해요: Scryfall ID가 들어 있는 CSV를 다시 가져오세요.';

  @override
  String get ceNothingSaved => '아무것도 저장되지 않았어요.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ 인증서를 $ruta에 저장했어요';
  }

  @override
  String ceSaveFailed(String error) {
    return '저장하지 못했어요: $error';
  }

  @override
  String get cePickFirstCard => '처음 시작한 카드 고르기';

  @override
  String get ceChangeFirstCard => '처음 시작한 카드 바꾸기';

  @override
  String get ceDownloadPng => 'PNG 내려받기';

  @override
  String get cdNotFound => '이 카드를 데이터베이스에서 찾지 못했어요.';

  @override
  String cdLoadFailed(String error) {
    return '카드 정보를 불러오지 못했어요: $error';
  }

  @override
  String get cdPrev => '이전 (←)';

  @override
  String get cdNext => '다음 (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => '카드를 찾을 수 없어요';

  @override
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  ) {
    return '$qty $copias에 $total$divisa 지불 (장당 $unidad)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '장',
      one: '장',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ 컬렉션에 $n장 있어요',
      one: '✓ 컬렉션에 1장 있어요',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => '이 카드는 (아직) 없어요.';

  @override
  String cdNoPrice(String mercado) {
    return '$mercado에 이 카드 가격이 없어요.';
  }

  @override
  String cdVersions(int n) {
    return '버전 ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return '$mercado에 에디션별 가격 없음';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return '$mercado 가격 ($moneda) · 일반 / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'x$n 보유';
  }

  @override
  String get smMythic => '신화레어';

  @override
  String get smRare => '레어';

  @override
  String get smUncommon => '비일반';

  @override
  String get smCommon => '일반';

  @override
  String smLoadFailed(String error) {
    return '세트를 불러오지 못했어요: $error';
  }

  @override
  String get smSearchInSet => '세트에서 검색…';

  @override
  String get smRarityAll => '희귀도: 전체';

  @override
  String get smPriceDown => '가격 ↓';

  @override
  String get smPriceUp => '가격 ↑';

  @override
  String get smNumber => '번호';

  @override
  String get smOnlyMine => '내 것만';

  @override
  String smCardsCount(int n) {
    return '카드 $n장';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: 에디션별 가격 없음';
  }

  @override
  String smListedValue(String mercado) {
    return '표시 가치 ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return '지불액 $pagado · 현재 가치 $hoy';
  }

  @override
  String get pnNoPnl =>
      '구매가가 없으면 P&L도 없어요. “Purchase price” 열이 있는 CSV를 가져오면 여기 나와요.';

  @override
  String pnOverAll(int n) {
    return '컬렉션의 $n장 기준';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return '$total장 중 $conprecio장 기준 (나머지는 구매가가 적혀 있지 않아요)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '구매한 $n장은 데이터베이스에 오늘 가격이 없어요: 계산에서 제외';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return '$importe $moneda도 지불했는데, 이건 변환되지 않아요';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return 'CSV에 통화가 없는 $n장: $moneda로 가정해요';
  }

  @override
  String get pcTitle => '가격 추이';

  @override
  String get pcNoHistory => '이 카드의 가격 이력이 아직 없어요.';

  @override
  String pcTodayPrice(String precio) {
    return '오늘 가격: $precio €. 며칠분이 쌓이면 그래프가 나와요.';
  }

  @override
  String get pcExplain =>
      'ManaForge는 네가 보거나 가진 카드의 가격을 날마다 적어둬요. Cardmarket의 실제 최근 몇 달로 시작하려면 마켓에서 이력을 가져오세요.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n일',
      one: '1일',
    );
    return '최소 $min € · 최대 $max € · $_temp0';
  }

  @override
  String get spWhichSets => '어떤 세트에서?';

  @override
  String get spSearchHint => '이름이나 코드로 검색 (BLB, MH3…)';

  @override
  String get spOnlyMine => '내 것만';

  @override
  String spClearN(int n) {
    return '$n개 해제';
  }

  @override
  String get spNoneNamed => '그 이름의 세트가 없어요. 전부 보려면 “내 것만”을 끄세요.';

  @override
  String spSetLine(String set, int n) {
    return '$set · 카드 $n장';
  }

  @override
  String get spNoFilter => '세트 필터 없음';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '세트 $n개 사용',
      one: '세트 1개 사용',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return '$set 세트 카드만 찾고 있어요. 눌러서 잠금을 바꾸거나 풀 수 있어요.';
  }

  @override
  String get slLockHint =>
      '박스/프리컨을 스캔할 땐 세트를 잠그세요: 스캐너가 그 안에서만 찾고 에디션을 정확히 잡아요.';

  @override
  String slSetIs(String set) {
    return '세트: $set';
  }

  @override
  String get slSetAll => '세트: 전체';

  @override
  String get slLockTitle => '에디션 잠금';

  @override
  String get slLockBody =>
      '세트 코드(예: AER, MH3, LCI)를 입력하면 박스 전체를 스캔해요: 그 세트 카드만 찾아요.';

  @override
  String get slSetCode => '세트 코드';

  @override
  String get slClearLock => '잠금 해제';

  @override
  String get stHintQuick =>
      '카드를 앞으로 지나가게 하세요: 확실한 건 여기 알아서 기록돼요 (같은 카드는 ×N으로 합산). 애매한 건 검토용으로 표시돼요. 끝나면 전부 확정하세요.';

  @override
  String get stHintCareful =>
      '카드를 앞으로 지나가게 하세요: 확실한 건 알아서 기록되고, 애매한 건 어느 카드인지 물어봐요. 끝나면 전부 확정하세요.';

  @override
  String stAddN(int n) {
    return '컬렉션에 $n장 추가';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return '컬렉션과 $carpeta에 $n장 추가';
  }

  @override
  String get stOneLess => '하나 빼기';

  @override
  String get stAnotherSame => '같은 걸로 하나 더';

  @override
  String get stOnTable => '테이블에';

  @override
  String cdLastData(String fecha) {
    return ' (마지막 데이터: $fecha)';
  }

  @override
  String get cdLegalities => '포맷 적법성';

  @override
  String get slLockButton => '잠그기';

  @override
  String get wn032Headline => 'Textos más claros';

  @override
  String get wn032Import =>
      'Importar tu colección: los textos de la importación de CSV ahora son claros y neutros en los 10 idiomas.';

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
  String get wn030Headline => '세트별 Forge, 구매가, 버전 알림';

  @override
  String get wn030Forge =>
      'Forge: 카드가 어느 세트에서 나올지 고르세요. 그리고 “없는 카드 포함”을 켜면, 고른 세트 전체로 덱을 짜주고 몇 장이 부족하고 얼마인지 알려줘요.';

  @override
  String get wn030Pnl =>
      '구매가와 P&L: CSV에 “Purchase price”가 있으면, 마켓이 지불액, 현재 가치, 차액을 알려줘요. 통화는 섞이지 않아요.';

  @override
  String get wn030PhotoFolder => '사진 스캔도 실시간 스캐너처럼 폴더를 고를 수 있어요.';

  @override
  String get wn030Album => '앨범: 각 세트에서 뭐가 부족한지, 그리고 얼마일지.';

  @override
  String get wn030Background =>
      '배경화면: 원하는 이미지를 뒤에 깔고, 가릴 정도를 조절하고, 카드와 글자 색을 골라 그 위에서도 잘 읽히게 하세요.';

  @override
  String get wn030Window => '창은 마지막에 둔 자리에, 마지막 크기로 열려요.';

  @override
  String get wn030Achievements =>
      '업적 이름이 이제 조건이 아니라 그 순간을 담아요: “내 돈 다 나간다”, “레어 백 장, 쓸 만한 건 하나도”.';

  @override
  String get wn030Update =>
      '앱은 새 버전이 있으면 알려주고(저절로 업데이트되진 않아요), 내려받는 데이터베이스의 SHA-256 지문을 확인해요.';

  @override
  String get wn030Shortcuts =>
      '단축키: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, 그리고 Escape.';

  @override
  String get wn030Linux => 'Linux에서는 설치 프로그램이 ManaForge를 아이콘과 함께 앱 메뉴에 넣어줘요.';

  @override
  String get wn030License =>
      'PolyForm Noncommercial 라이선스: 마음껏 공유하고 손대도 되지만, 팔 순 없어요.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '카드 $n장',
      one: '카드 1장',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '덱 $n개',
      one: '덱 1개',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '폴더 $n개',
      one: '폴더 1개',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '업적 $n개',
      one: '업적 1개',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => '빈 백업';

  @override
  String get bkStoreCollection => '네 컬렉션';

  @override
  String get bkStoreFolders => '네 폴더';

  @override
  String get bkStoreDecks => '네 덱';

  @override
  String get bkStoreAchievements => '네 업적';

  @override
  String get bkStoreWishlist => '네 위시리스트';

  @override
  String get bkStoreCertificates => '네 인증서';

  @override
  String get bkStoreMarket => '선호 마켓';

  @override
  String get bkStoreRecents => '최근 본 카드';

  @override
  String get bkStoreValueHistory => '가치 이력';

  @override
  String get bkStorePriceHistory => '가격 이력';

  @override
  String get bkKindAuto => '자동';

  @override
  String get bkKindPreRestore => '복원 직전';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig => '그 파일은 ManaForge 백업이라기엔 너무 커요.';

  @override
  String get bkErrExpandTooBig => '그 백업은 열어보니 너무 커요: 진짜 ManaForge 백업 같지 않아요.';

  @override
  String get bkErrNotABackup => '그 파일은 ManaForge 백업이 아니에요.';

  @override
  String get bkErrNewerVersion =>
      '그 백업은 더 새 버전의 ManaForge가 만든 거예요. 앱을 업데이트하고 다시 시도하세요.';

  @override
  String get bkErrIncomplete => '그 백업은 불완전해요: 데이터가 안 들어 있어요.';

  @override
  String bkErrDamaged(String almacen) {
    return '그 백업은 손상됐어요: $almacen을(를) 읽을 수 없어요.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return '데이터 폴더에 쓰지 못해서 아무것도 건드리지 않았어요: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return '복원이 도중에 멈췄어요 (파일 $total개 중 $escritos개). 이전 데이터의 백업이 없어요. 자세히: $error';
  }

  @override
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  ) {
    return '복원이 도중에 멈췄어요 (파일 $total개 중 $escritos개). 되돌리려면 $ruta을(를) 복원하세요. 자세히: $error';
  }

  @override
  String get siImportTooBig => '그 파일은 카드 목록이라기엔 너무 커요.';

  @override
  String get siInsecureDownload => '내려받기가 안전하지 않은 주소로 이어져 취소됐어요.';

  @override
  String get siRedirectNowhere => '내려받기가 아무 데도 아닌 곳으로 리디렉트돼 취소됐어요.';

  @override
  String get siTooManyRedirects => '내려받기가 리디렉트를 너무 많이 돌아 취소됐어요.';

  @override
  String get siDownloadTooBig => '내려받기가 예상보다 훨씬 커서 취소됐어요.';

  @override
  String get siBadHash =>
      '내려받은 게 GitHub에 게시된 지문과 일치하지 않아요. 아무것도 설치하지 않았어요. 다시 시도해보고, 계속 이러면 알려주세요.';

  @override
  String get siBackgroundNotImage => '배경으로 이미지(.jpg, .png, .webp)를 고르세요.';

  @override
  String get siBackgroundTooBig => '그 이미지는 배경으로 쓰기엔 너무 커요.';

  @override
  String get siScanTooBig => '그 사진은 너무 커서 인식할 수 없어요.';

  @override
  String get bgImages => '이미지';

  @override
  String bgImageFailed(String error) {
    return '그 이미지를 쓰지 못했어요: $error';
  }

  @override
  String get bgLowContrast => '카드와 차이가 별로 없어요: 잘 읽히도록 글자가 알아서 조정돼요.';

  @override
  String get bgChipColor => '탭 색';

  @override
  String get bgIconColor => '아이콘 색';

  @override
  String get bgUseThis => '이걸로 쓰기';

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
      'GStreamer가 설치돼 있지 않아요. 이렇게 설치하세요:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return '카메라 $dispositivo에서 영상이 안 나와요 (gst-launch가 $codigo로 종료).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return '카메라 $dispositivo가 6초 동안 프레임을 하나도 주지 않았어요.';
  }

  @override
  String get camNoCameras =>
      '카메라(/dev/video*)를 찾지 못했어요. 연결돼 있나요? `lsusb`로 시스템이 인식하는지 확인하세요.';

  @override
  String camNoneWorked(String detalle) {
    return '어떤 카메라도 영상을 주지 않았어요:\n$detalle';
  }

  @override
  String get bkRestoreAction => '복원';

  @override
  String get fpUnselect => '선택 해제';

  @override
  String get stClear => '비우기';

  @override
  String get tlRemove => '빼기';

  @override
  String get tlUnrecognized => '인식 안 됨';

  @override
  String get tlNothingAlike => '데이터베이스에 비슷한 게 없어요 — 다시 찍거나 빼세요';

  @override
  String get tlTapToPick => '눌러서 비슷한 것 중 직접 고르기';

  @override
  String get tlReview => '확인 필요';

  @override
  String get lsQuantity => '수량';

  @override
  String get scPhotos => '사진';

  @override
  String get ftWhichFolder => '어느 폴더에 넣을까요?';

  @override
  String get ftWhichFolderSub => '어차피 컬렉션에는 들어가요; 폴더는 나중에 찾기 쉬우라는 꼬리표일 뿐이에요.';

  @override
  String get ftNone => '없음';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '카드 $n장',
      one: '카드 1장',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => '새 폴더…';

  @override
  String get ftNewFolder => '새 폴더';

  @override
  String get ftNewFolderHint => '가게 박스, 팔 것…';

  @override
  String get sgTitle => '스캐너의 눈';

  @override
  String get sgWhy =>
      '인터넷 없이 카드를 인식하려면 시각 지문 데이터베이스(~12 MB)가 필요해요: Magic 일러스트마다의 아트 서명이죠. 한 번만 내려받아요.';

  @override
  String get sgDownload => '지문 데이터베이스 내려받기';

  @override
  String get cmFullCard => '카드 전체 정보 보기 (가격과 합법성)';

  @override
  String get cmSwipeHint => '밀거나 ← →로 넘기기 · 바깥을 누르면 닫힘';

  @override
  String get cmTapOutHint => '바깥을 누르면 닫힘';

  @override
  String get fcTitle => '어떤 카드로 시작했나요?';

  @override
  String get fcRemove => '빼기';

  @override
  String get fcSearchHint => '컬렉션에서 검색';

  @override
  String get fcNoMatch => '그런 카드를 찾지 못했어요.';

  @override
  String get acNoneWithFilters => '이 필터로는 여기 아무것도 없어요.';

  @override
  String get acAll => '전체';

  @override
  String get tsTitle => '테스트 모드 — 메타를 이겨보기';

  @override
  String get tsIntro =>
      '어떤 메타 덱을 상대할지 고르세요. ManaForge가 네 카드로 덱을 짜고, 그 상대로 수백 판을 시뮬레이션해서 가장 많이 이기는 덱을 골라줘요 — 카드를 하나씩 바꿔가며 다듬기도 하고요.';

  @override
  String get tsLoadingMeta => '메타 불러오는 중…';

  @override
  String get tsLocalPresets => '로컬 프리셋 (오프라인)';

  @override
  String get tsNoDeckToFace => '지금 카드로는 맞붙일 완성된 덱이 안 나와요. 카드를 더 추가하고 다시 시도하세요.';

  @override
  String tsSimFailed(String error) {
    return '시뮬레이션하지 못했어요: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · 메타 점유율 $cuota';
  }

  @override
  String get tsSimulating => '대전 시뮬레이션 중… (몇 초; 전부 네 기기에서)';

  @override
  String tsFindBest(String meta) {
    return '$meta 상대로 최고의 내 덱 찾기';
  }

  @override
  String get tsHonesty =>
      '솔직히 말하면: 시뮬레이션은 마나 색, 멀리건, 회피 능력(비행, 돌진, 치명타…), 순간마법 제거, 카운터마법은 이해하지만, 카드마다의 전체 텍스트는 몰라요. 이 퍼센트는 네 덱끼리 비교하는 용도지, 정확한 예측은 아니에요.';

  @override
  String tsChampion(String meta) {
    return '$meta 상대 네 챔피언';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return '추정 승률 · 덱 $mazos개 테스트 · 덱당 $partidas판';
  }

  @override
  String get tsNoDominant =>
      '이 매치업을 압도하는 덱은 컬렉션에 없어요 — 이게 그나마 가장 잘 싸워요. 상세에서 약점을 확인하세요.';

  @override
  String get tsSeeDeck => '덱 전체 보기 (그리고 저장)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '업적 $hechos/$total · 레벨 $nivel까지 $xp XP';
  }

  @override
  String get hsForgeDecks => '덱 벼리기';

  @override
  String get hsTestYourself => '⚔ 실력 시험하기';

  @override
  String get bgCustom => '직접 지정';

  @override
  String get bgPickCustom => '원하는 색 직접 고르기';

  @override
  String get bgCustomColor => '직접 지정한 색';

  @override
  String get bgSampleTab => '빨강';

  @override
  String get cfSortRecent => '최근 추가순';

  @override
  String get cfSortAlpha => '이름 A-Z';

  @override
  String get cfSortCmc => '비용';

  @override
  String get cfSortQty => '수량';

  @override
  String get cfSortBy => '정렬 기준';

  @override
  String get cfSort => '정렬';

  @override
  String get cfClear => '지우기';

  @override
  String get cfCost => '비용';

  @override
  String get cfCostAll => '비용: 전체';

  @override
  String cfCostN(String n) {
    return '비용 $n';
  }

  @override
  String get cfType => '유형';

  @override
  String get cfTypeAll => '유형: 전체';

  @override
  String get cfTypeCreature => '생물';

  @override
  String get cfTypeInstant => '순간마법';

  @override
  String get cfTypeSorcery => '집중마법';

  @override
  String get cfTypeArtifact => '마법물체';

  @override
  String get cfTypeEnchantment => '부여마법';

  @override
  String get cfTypeLand => '대지';

  @override
  String get cfPower => '공격력';

  @override
  String get cfPowerAll => '공격력: 전체';

  @override
  String cfPowerMin(int n) {
    return '공격력 ≥ $n';
  }

  @override
  String get cfToughness => '방어력';

  @override
  String get cfToughnessAll => '방어력: 전체';

  @override
  String cfToughnessMin(int n) {
    return '방어력 ≥ $n';
  }

  @override
  String get cfNoDate => '날짜 없음';

  @override
  String get cfToday => '오늘';

  @override
  String get cfYesterday => '어제';

  @override
  String cfDaysAgo(int n) {
    return '$n일 전';
  }

  @override
  String get pcWeek => '주간';

  @override
  String get pcMonth => '월간';

  @override
  String get pcAll => '전체';

  @override
  String get vpTapCorrect => '올바른 카드를 누르세요';

  @override
  String get achCopias1 => '이제 시작일 뿐';

  @override
  String get achCopias10 => '한 장만 사려 했는데';

  @override
  String get achCopias50 => '손에 다 안 잡혀요';

  @override
  String get achCopias100 => '백 장, 계속 오르는 중';

  @override
  String get achCopias500 => '상자가 작아졌어요';

  @override
  String get achCopias1000 => '천 장. 근데 다 갖고 싶어요';

  @override
  String get achCopias5000 => '이건 이제 창고예요';

  @override
  String get achCopias10000 => '만 장, 근데 난 멀쩡해요';

  @override
  String achCopiasDesc(String n) {
    return '컬렉션에 카드 $n장을 모으세요.';
  }

  @override
  String get achDistintas25 => '제법 다양해졌네요';

  @override
  String get achDistintas100 => '서로 다른 백 얼굴';

  @override
  String get achDistintas500 => '도서관 반쯤';

  @override
  String get achDistintas1000 => '걸어다니는 백과사전';

  @override
  String get achDistintas2500 => '이제 다는 못 외워요';

  @override
  String get achDistintas5000 => '완전 자료보관소';

  @override
  String achDistintasDesc(String n) {
    return '서로 다른 카드 $n종을 모으세요 (중복 제외).';
  }

  @override
  String get achPlaysets1 => '똑같은 넉 장';

  @override
  String get achPlaysets20 => '플레이셋 스무 벌, 덱은 영';

  @override
  String get achPlaysets1Desc => '같은 카드를 4장 모으세요.';

  @override
  String get achPlaysets20Desc => '서로 다른 플레이셋 20개를 모으세요 (각각 4장씩).';

  @override
  String get achComunes10 => '아무도 안 원하는 것들';

  @override
  String get achComunes50 => '늘 있는 그 무더기';

  @override
  String get achComunes200 => '무더기의 왕';

  @override
  String get achComunes500 => '일반 카드 밀물';

  @override
  String achComunesDesc(String n) {
    return '서로 다른 일반 카드 $n종을 모으세요.';
  }

  @override
  String get achInfrecuentes10 => '일반보단 좀 낫네요';

  @override
  String get achInfrecuentes50 => '고운 은빛';

  @override
  String get achInfrecuentes200 => '비일반 사냥꾼';

  @override
  String get achInfrecuentes500 => '은빛이 넘쳐나요';

  @override
  String achInfrecuentesDesc(String n) {
    return '서로 다른 비일반 카드 $n종을 모으세요.';
  }

  @override
  String get achRaras5 => '부스터 뜯을 맛 나네요';

  @override
  String get achRaras25 => '레어 보물상자';

  @override
  String get achRaras100 => '레어 백 장, 쓸 만한 건 하나도';

  @override
  String get achRaras300 => '레어 금고';

  @override
  String achRarasDesc(String n) {
    return '서로 다른 레어 카드 $n종을 모으세요.';
  }

  @override
  String get achMiticas1 => '첫 신화레어';

  @override
  String get achMiticas10 => '신화레어 열 장';

  @override
  String get achMiticas50 => '신화급 수집가';

  @override
  String get achMiticas150 => '신화의 전당';

  @override
  String achMiticasDesc(String n) {
    return '서로 다른 신화레어 카드 $n종을 모으세요.';
  }

  @override
  String get achBlancas25 => '질서와 조화';

  @override
  String get achBlancas100 => '은빛 군대';

  @override
  String achBlancasDesc(String n) {
    return '서로 다른 백색 카드 $n종을 모으세요.';
  }

  @override
  String get achAzules25 => '그건 안 되죠';

  @override
  String get achAzules100 => '상아탑';

  @override
  String achAzulesDesc(String n) {
    return '서로 다른 청색 카드 $n종을 모으세요.';
  }

  @override
  String get achNegras25 => '어둠의 계약';

  @override
  String get achNegras100 => '무덤의 군주';

  @override
  String achNegrasDesc(String n) {
    return '서로 다른 흑색 카드 $n종을 모으세요.';
  }

  @override
  String get achRojas25 => '다 태워버려';

  @override
  String get achRojas100 => '전면 화재';

  @override
  String achRojasDesc(String n) {
    return '서로 다른 적색 카드 $n종을 모으세요.';
  }

  @override
  String get achVerdes25 => '새싹 하나';

  @override
  String get achVerdes100 => '숲 전체';

  @override
  String achVerdesDesc(String n) {
    return '서로 다른 녹색 카드 $n종을 모으세요.';
  }

  @override
  String get achIncoloras25 => '차가운 금속';

  @override
  String get achIncoloras100 => '영원한 대장간';

  @override
  String achIncolorasDesc(String n) {
    return '서로 다른 무색 카드 $n종을 모으세요.';
  }

  @override
  String get achArcoiris => '다섯 색 전부';

  @override
  String get achArcoirisDesc => '5색 각각의 카드를 최소 한 장씩 모으세요.';

  @override
  String get achMulticolor10 => '색을 섞는 중';

  @override
  String get achMulticolor50 => '황금 동맹';

  @override
  String achMulticolorDesc(String n) {
    return '서로 다른 다색 카드 $n종을 모으세요.';
  }

  @override
  String get achCincocolores => '한 장에 다섯 색';

  @override
  String get achCincocoloresDesc => '다섯 색을 모두 지닌 카드를 한 장 모으세요.';

  @override
  String get achSets1 => '첫 세트';

  @override
  String get achSets5 => '다섯 세계';

  @override
  String get achSets10 => '차원 여행자';

  @override
  String get achSets25 => '세계 방랑자';

  @override
  String get achSets50 => '멀티버스 절반';

  @override
  String achSetsDesc(String n) {
    return '서로 다른 세트 $n개의 카드를 모으세요.';
  }

  @override
  String get achSetscompletos1 => '한 장도 안 빠졌어요';

  @override
  String get achSetscompletos3 => '앨범 세 권 통째로';

  @override
  String get achSetscompletos10 => '앨범의 달인';

  @override
  String get achSetscompletos1Desc => '앨범에서 한 세트를 통째로 완성하세요.';

  @override
  String achSetscompletos3Desc(String n) {
    return '세트 $n개를 통째로 완성하세요.';
  }

  @override
  String get achAnyos5 => '카드로 보낸 5년';

  @override
  String get achAnyos15 => '타임머신';

  @override
  String achAnyosDesc(String n) {
    return '서로 다른 출시 연도 $n개의 카드를 모으세요.';
  }

  @override
  String get achValor10 => '첫 몇 유로';

  @override
  String get achValor50 => '돼지 저금통';

  @override
  String get achValor250 => '월급이 날아가네';

  @override
  String get achValor1000 => '내 돈 다 나간다';

  @override
  String get achValor5000 => '아무한테도 말하지 마세요';

  @override
  String get achValor10000 => '내 차보다 비싸요';

  @override
  String get achValor25000 => '박물관급 컬렉션';

  @override
  String achValorDesc(String n) {
    return '컬렉션 가치가 $n € 이상이 되게 하세요.';
  }

  @override
  String get achJoya20 => '쓸만한 카드 한 장';

  @override
  String get achJoya100 => '컬렉션의 보석';

  @override
  String get achJoya500 => '이건 슬리브 밖으로 안 나와요';

  @override
  String get achJoya1000 => '슬리브 한 장에 천 유로';

  @override
  String get achJoya2500 => '성배';

  @override
  String achJoyaDesc(String n) {
    return '한 장이 $n € 이상인 카드를 가지세요.';
  }

  @override
  String get achFoils1 => '첫 반짝임';

  @override
  String get achFoils10 => '반짝반짝';

  @override
  String get achFoils50 => '상자가 빛나요';

  @override
  String get achFoils200 => '무광은 이제 하나도 없어요';

  @override
  String get achFoils500 => '죄다 반짝여요';

  @override
  String get achFoils1000 => '반짝이 공장';

  @override
  String achFoilsDesc(String n) {
    return 'foil 카드 $n장을 모으세요.';
  }

  @override
  String get achFoiljoya10 => '쓸만한 foil';

  @override
  String get achFoiljoya50 => '값나가는 foil';

  @override
  String get achFoiljoya200 => '박물관급 foil';

  @override
  String achFoiljoyaDesc(String n) {
    return '한 장이 $n € 이상인 foil을 가지세요.';
  }

  @override
  String get achFoilvalor50 => '반짝이는 진열장';

  @override
  String get achFoilvalor250 => '값비싼 진열장';

  @override
  String get achFoilvalor1000 => '천 유로어치 반짝임';

  @override
  String get achFoilvalor5000 => '박물관 진열장';

  @override
  String achFoilvalorDesc(String n) {
    return 'foil을 다 합친 가치가 $n € 이상이 되게 하세요.';
  }

  @override
  String get achMazos1 => '첫 덱';

  @override
  String get achMazos5 => '저장한 덱 다섯 개';

  @override
  String get achMazos25 => '공방이 쉴 틈이 없네요';

  @override
  String achMazosDesc(String n) {
    return 'Forge로 만든 덱 $n개를 저장하세요.';
  }

  @override
  String get achMazoscore => '완벽한 한 벌';

  @override
  String get achMazoscoreDesc => '점수 90 이상인 덱을 만드세요.';

  @override
  String get achMazocolores3 => '삼색';

  @override
  String get achMazocolores5 => '쓸 수 있는 무지개';

  @override
  String achMazocoloresDesc(String n) {
    return '$n색 덱을 저장하세요.';
  }

  @override
  String get achMazomono => '섞지 않고 순수하게';

  @override
  String get achMazomonoDesc => '단색 덱을 저장하세요.';

  @override
  String get achMazocommander => '지휘봉을 잡다';

  @override
  String get achMazocommanderDesc => 'Commander 덱을 저장하세요.';

  @override
  String get achEscaneadas1 => '첫 스캔';

  @override
  String get achEscaneadas50 => '빠른 손놀림';

  @override
  String get achEscaneadas500 => '연쇄 스캐너';

  @override
  String get achEscaneadas2000 => '자면서도 스캔';

  @override
  String achEscaneadasDesc(String n) {
    return '카메라나 사진으로 카드 $n장을 스캔하세요.';
  }

  @override
  String get achFoto9 => '사진 한 장에 앨범 한 페이지';

  @override
  String get achFoto20 => '한 방에 스무 장';

  @override
  String achFotoDesc(String n) {
    return '사진 한 장에서 카드 $n장을 인식하세요.';
  }

  @override
  String get achEscaneoperfecto => '검토할 게 한 장도 없어요';

  @override
  String get achEscaneoperfectoDesc => '카드 하나도 검토용으로 남기지 않고 한 페이지를 통째로 스캔하세요.';

  @override
  String get achDias2 => '돌아오셨네요';

  @override
  String get achDias7 => '여기서 일주일';

  @override
  String get achDias30 => '여기서 한 달';

  @override
  String get achDias100 => '여기서 백 일';

  @override
  String achDiasDesc(String n) {
    return '서로 다른 $n일 동안 ManaForge를 쓰세요.';
  }

  @override
  String get achRacha3 => '사흘 연속';

  @override
  String get achRacha7 => '완벽한 한 주';

  @override
  String get achRacha30 => '빠짐없이 한 달';

  @override
  String achRachaDesc(String n) {
    return '$n일 연속으로 접속하세요.';
  }

  @override
  String get achSemanas => '네 주 내내 개근';

  @override
  String get achSemanasDesc => 'ManaForge를 4주 연속 쓰세요.';

  @override
  String get achCarpetas1 => '정리 시작';

  @override
  String get achCarpetas5 => '전부 분류 완료';

  @override
  String achCarpetasDesc(String n) {
    return '폴더 $n개를 만드세요.';
  }

  @override
  String get achCarpetagrande => '왕폴더';

  @override
  String get achCarpetagrandeDesc => '카드 100장 이상인 폴더를 하나 만드세요.';

  @override
  String get achCarpetavalor => '이 폴더는 안 빌려줘요';

  @override
  String get achCarpetavalorDesc => '가치가 100 € 이상인 폴더를 하나 만드세요.';

  @override
  String get achTierrasbasicas => '기본 대지 다섯';

  @override
  String get achTierrasbasicasDesc => '다섯 가지 기본 대지를 모두 모으세요 (평지, 섬, 늪, 산, 숲).';

  @override
  String get achFuerza => '덩치 좀 보소';

  @override
  String get achFuerzaDesc => '공격력 10 이상인 생물을 가지세요.';

  @override
  String get achCoste => '이건 평생 못 내겠네';

  @override
  String get achCosteDesc => '전환마나비용 10 이상인 카드를 가지세요.';

  @override
  String get achCostecero => '공짜';

  @override
  String get achCosteceroDesc => '마나비용 0인 카드를 가지세요.';

  @override
  String get achTipos => '골고루 조금씩';

  @override
  String get achTiposDesc =>
      '생물, 순간마법, 집중마법, 마법물체, 부여마법, 대지, 플레인즈워커를 각각 최소 하나씩 가지세요.';

  @override
  String get achPlaneswalkers => '플레인즈워커 군단';

  @override
  String get achPlaneswalkersDesc => '서로 다른 플레인즈워커 5명을 가지세요.';

  @override
  String get achNoventas => '90년대 유물';

  @override
  String get achNoventasDesc => '90년대에 나온 카드를 가지세요.';

  @override
  String get achIdiomas1 => '이건 못 읽겠어요';

  @override
  String get achIdiomas25 => '다국어 컬렉션';

  @override
  String get achIdiomas1Desc => '영어가 아닌 언어의 카드를 하나 가지세요.';

  @override
  String get achIdiomas25Desc => '다른 언어의 카드 25장을 가지세요.';

  @override
  String get achWishlist => '탐나는 것들 목록';

  @override
  String get achWishlistDesc => '위시리스트에 카드 20장을 적어두세요.';

  @override
  String get achTierBronze => '브론즈';

  @override
  String get achTierSilver => '실버';

  @override
  String get achTierGold => '골드';

  @override
  String get achTierMythic => '미틱';

  @override
  String get achCatCollection => '컬렉션';

  @override
  String get achCatRarity => '희귀도';

  @override
  String get achCatColor => '색';

  @override
  String get achCatSets => '세트';

  @override
  String get achCatValue => '가치';

  @override
  String get achCatFoils => 'Foil';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => '스캐너';

  @override
  String get achCatDedication => '꾸준함';

  @override
  String get achCatFolders => '폴더';

  @override
  String get achCatCuriosities => '이것저것';

  @override
  String get achRankApprentice => '견습생';

  @override
  String get achRankSummoner => '소환사';

  @override
  String get achRankMage => '마법사';

  @override
  String get achRankArchmage => '대마법사';

  @override
  String get achRankMaster => '명인';

  @override
  String get achRankPlaneswalker => '플레인즈워커';

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
    return '카드 데이터베이스를 내려받지 못했어요 (HTTP $codigo). 잠시 뒤에 다시 시도하세요.';
  }

  @override
  String dbErrHashes(String codigo) {
    return '지문 데이터베이스를 내려받지 못했어요 (HTTP $codigo). 잠시 뒤에 다시 시도하세요.';
  }

  @override
  String dbErrPrices(String codigo) {
    return '가격 이력을 내려받지 못했어요 (HTTP $codigo). 잠시 뒤에 다시 시도하세요.';
  }

  @override
  String ddCardCount(int n) {
    return '카드 $n장';
  }

  @override
  String get ddForgedWith => 'ManaForge로 벼림';

  @override
  String get fxThemeLifegain => '생명력 흡수';

  @override
  String get fxThemeSacrifice => '희생';

  @override
  String get fxThemeSpells => '주문';

  @override
  String get fxThemeArtifacts => '마법물체';

  @override
  String get fxThemeCounters => '+1/+1 카운터';

  @override
  String get fxThemeTokens => '물량';

  @override
  String get fxThemeGraveyard => '무덤';

  @override
  String get fxThemeReanimator => '리애니메이트';

  @override
  String fxThemeTribal(String tribe) {
    return '$tribe 부족';
  }

  @override
  String get fxThemeGoodstuff => '정예 카드';

  @override
  String get fxTagLifegain => '네가 얻는 생명력 1점이 상대에겐 피해예요: 흡수하고 버텨요.';

  @override
  String get fxTagSacrifice => '네 생물은 죽어서 더 값져요: 희생시키고 그 대가를 챙겨요.';

  @override
  String get fxTagSpells => '순간마법 하나하나가 중요해요: 상대 턴에 플레이하고 응징해요.';

  @override
  String get fxTagArtifacts => '네 공방을 차려요: 마법물체 하나하나가 나머지를 더 강하게 해줘요.';

  @override
  String get fxTagCounters => '+1/+1 카운터: 네 생물이 손댈 수 없을 만큼 커져요.';

  @override
  String get fxTagTokens => '토큰으로 판을 채워요: 상대가 하나일 때 너는 다섯이에요.';

  @override
  String get fxTagGraveyard => '무덤은 네 두 번째 손패예요: 채우고 알짜를 재활용해요.';

  @override
  String get fxTagAggro => '빠르게 나가서 얼굴을 때려요: 게임은 금방 끝나야 해요.';

  @override
  String get fxTagTempo => '일찍 압박하고 주문으로 우위를 지켜요.';

  @override
  String fxTagMidrange(String tema) {
    return '카드를 잘 맞바꾸고 $tema(으)로 중반을 잡아요.';
  }

  @override
  String get fxTagControl => '버티고, 뭐든 받아치고, 판이 네 것이 되면 끝내요.';

  @override
  String get fxMidLifegain => '생명력 원천을, 그걸로 상대를 응징하는 카드와 엮어요.';

  @override
  String get fxMidSacrifice => '싼 걸 희생시켜 카드를 뽑고, 흡수하고, 나머지를 키워요.';

  @override
  String get fxMidSpells => '마나를 열어둬요: 주문을 낼 때마다 네 생물이 자라요.';

  @override
  String get fxMidArtifacts => '싼 마법물체를 펼치고, 그 수를 세는 카드를 활성화해요.';

  @override
  String get fxMidCounters => '생물 한둘에 카운터를 쌓고 지켜요.';

  @override
  String get fxMidTokens => '매 턴 토큰을 만들고, 그것들을 키우는 효과를 노려요.';

  @override
  String get fxMidGraveyard => '의도적으로 갈고 버려요: 무덤에 떨어진 건 다시 돌아와요.';

  @override
  String get fxEndLifegain => '생명력이 높아지면 공격 모드로 전환해요: 상대는 이제 못 따라와요.';

  @override
  String get fxEndSacrifice => '쌓인 이득이 게임을 가져다줘요: 맞바꿈이 다 공짜예요.';

  @override
  String get fxEndSpells => '한 턴에 주문 두어 개면 네 생물이 게임을 끝내요.';

  @override
  String get fxEndArtifacts => '네 판이 상대의 두 배 값어치예요: 보상 카드로 끝내요.';

  @override
  String get fxEndCounters => '거대하고 보호받는 위협 하나면 두 방에 게임이 끝나요.';

  @override
  String get fxEndTokens => '물량으로 공격해요: 어떤 방어도 네 군대 전체를 못 막아요.';

  @override
  String get fxEndGraveyard => '최고의 카드를 재활용해요: 상대는 한 손, 너는 두 손으로 싸워요.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => '매 턴 생물 하나씩, 예외 없이.';

  @override
  String get fxAggroMid => '계속 공격해요; 직접 피해는 방어자를 치우는 데 아껴둬요.';

  @override
  String get fxAggroLate => '모든 걸 쏟아 끝내요: 여기서 게임을 마무리해야 해요.';

  @override
  String get fxTempoEarly => '싼 위협, 그리고 가능하면 마나는 열어둬요.';

  @override
  String get fxTempoMid => '공격하고, 주문은 상대 턴에 써요.';

  @override
  String get fxTempoLate => '생물을 지키고, 공중이나 직접 피해로 끝내요.';

  @override
  String get fxMidrangeEarly => '판을 키우고 카드를 공짜로 내주지 마세요: 일대일 맞바꿈을 잘하세요.';

  @override
  String fxMidrangeMid(String tema) {
    return '$tema 엔진을 펼치고 판을 안정시켜요.';
  }

  @override
  String get fxMidrangeLate => '네 카드가 상대 것보다 값져요: 그걸 승리로 바꿔요.';

  @override
  String get fxControlEarly => '매 턴 대지를 놓고, 중요한 것에만 대응해요.';

  @override
  String get fxControlMid => '판을 쓸어버리고 카드를 뽑아요: 시간은 네 편이에요.';

  @override
  String get fxControlLate => '위협 하나를 내려놓고 끝까지 지켜요.';

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
    return '평균 비용 $coste: Karsten 규칙(비용 3.0에 대지 24장, ±0.5마다 ±1장)에 따라 이 덱은 대지 $tierras장을 써요 — $arquetipo 덱의 범위 안이죠. 판을 유지할 생물 $criaturas마리와, 상대가 뭘 들고 오든 대응할 상호작용 카드 $interaccion장이 있어요. 테마($tema)가 시너지를 한데 모아요: 테마 조각을 많이 볼수록 하나하나가 더 세져요.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return '그 커브면 대지 $tierras장이 나와요: 건강 범위($min-$max)를 벗어나요. 주문 총량을 조정하세요.';
  }

  @override
  String get fxNoCards =>
      '그 커브를 채울 만큼 이 색 카드가 컬렉션에 부족해요. 주문을 줄이거나 다른 비용으로 시도하세요.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return '그 커브(평균 비용 $coste에 대지 $tierras장)는 건강한 어떤 유형에도 안 맞아요: 싼 덱은 대지가 적어야 하고 비싼 덱은 더 많아야 해요. 서로 맞춰가세요.';
  }

  @override
  String get fxNoBasics => '그 커브에 쓸 기본 대지가 컬렉션에 부족해요.';

  @override
  String fxHardRule(String detalle) {
    return '요청한 커브가 엄격한 규칙을 어겨요: $detalle';
  }

  @override
  String get tsPresetMonoRed => '싼 생물과 얼굴에 꽂는 피해: 리듬을 못 버티면 4-5턴 만에 죽어요.';

  @override
  String get tsPresetAzorius => '카운터마법, 전체 제거, 드로우: 게임을 길게 끌고 소수의 피니셔로 이겨요.';

  @override
  String get tsPresetGolgari => '일대일 맞바꿈, 효율적인 생물, 흑색 제거: 카드 품질로 장기전을 이겨요.';
}
