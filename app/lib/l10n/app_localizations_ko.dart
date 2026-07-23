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
  String get languagePartial =>
      '앱은 단계적으로 번역 중입니다. 기본 화면은 이미 선택한 언어로 나오고, 나머지 화면은 당분간 스페인어입니다.';

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
  String get welcomeImport => 'CSV 가져오기(ManaBox)';

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
}
