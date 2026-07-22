// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get tabHome => 'Início';

  @override
  String get tabCollection => 'Coleção';

  @override
  String get tabAlbum => 'Álbum';

  @override
  String get tabDecks => 'Decks';

  @override
  String get tabForge => 'Forge';

  @override
  String get tabMarket => 'Mercado';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get tabScan => 'Escanear';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsIntro =>
      'O ManaForge é grátis e com o código à vista (licença PolyForm Noncommercial: compartilhe e mexa à vontade, só não se vende). Sem anúncios, sem premium, sem contas. Suas cartas são suas.';

  @override
  String get howItWorks => 'Como funciona';

  @override
  String get howScan =>
      'Passe cartas na frente da webcam ou solte uma foto: elas entram na sua coleção com a edição exata.';

  @override
  String get howCollection =>
      'Tudo o que você tem, com busca, filtros e pastas (pastas são etiquetas: uma carta pode estar em várias).';

  @override
  String get howAlbum =>
      'Uma página por coleção, estilo álbum de figurinhas: o que você tem colorido, o que falta apagado, e quanto custaria completar.';

  @override
  String get howForge =>
      'Decks completos e legais com as suas cartas. Ou com as de uma coleção que você ainda não tem, dizendo o que comprar e quanto custa.';

  @override
  String get howDecks =>
      'Os que você salvar. Se vender uma carta, o deck avisa em vez de fingir que você ainda tem.';

  @override
  String get howMarket =>
      'Quanto vale a sua coleção, o gráfico dela, sua lista de desejos com alertas de preço — e, se o CSV trazia preço de compra, quanto você ganha ou perde.';

  @override
  String get howPrivacy =>
      'Tudo é calculado no seu dispositivo. A única coisa que vai para a internet são os bancos de dados e, se você deixar ligado, checar se há versão nova.';

  @override
  String get shortcuts => 'Atalhos de teclado';

  @override
  String get shortcutTabs => 'Trocar de aba';

  @override
  String get shortcutScan => 'Abrir o scanner';

  @override
  String get shortcutSearch => 'Buscar na aba em que você está';

  @override
  String get shortcutSettings => 'Ajustes';

  @override
  String get shortcutClose => 'Fechar o que estiver aberto por cima';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'O do sistema';

  @override
  String get languagePartial =>
      'O app está sendo traduzido por partes: a estrutura já está no seu idioma, o resto das telas continua em espanhol por enquanto.';

  @override
  String get versionTitle => 'Versão do ManaForge';

  @override
  String versionYouHave(String version) {
    return 'Você está na $version.';
  }

  @override
  String get versionSeeWhatsNew => 'Ver o que veio';

  @override
  String get versionNotifyMe => 'Avisar sobre versões novas';

  @override
  String get versionNotifyMeWhy =>
      'Pergunta uma vez por dia ao GitHub qual é a última versão. Não baixa nem instala nada.';

  @override
  String get versionCheckNow => 'Procurar agora';

  @override
  String get versionUpToDate =>
      'Você está na última versão (ou o GitHub não está respondendo agora).';

  @override
  String versionThereIs(String version) {
    return 'Saiu o ManaForge $version.';
  }

  @override
  String get versionGoDownload => 'Ir para o download';

  @override
  String versionNotAuto(String version) {
    return 'Você está na $version. O app não se atualiza sozinho: ele te leva ao download.';
  }

  @override
  String get versionNotNow => 'Agora não';

  @override
  String get versionSee => 'Ver';

  @override
  String whatsNewTitle(String version) {
    return 'Novidades da $version';
  }

  @override
  String get whatsNewClose => 'Bora jogar';

  @override
  String get downloadCopyLink => 'Copiar link';

  @override
  String get downloadClose => 'Fechar';

  @override
  String get downloadTitle => 'Baixar o ManaForge';

  @override
  String get backgroundTitle => 'Papel de parede';

  @override
  String get backgroundWhat =>
      'Coloque atrás do app a imagem que quiser. A Wizards publica papéis de parede oficiais de cada coleção: baixe o que você gostar e escolha aqui. O app não baixa sozinho — essa arte tem dono, e distribuir não cabe a ele.';

  @override
  String get backgroundPick => 'Escolher imagem…';

  @override
  String get backgroundChange => 'Trocar imagem…';

  @override
  String get backgroundOfficial => 'Papéis de parede oficiais de Magic';

  @override
  String get backgroundRemove => 'Tirar o papel de parede';

  @override
  String get backgroundDim =>
      'Quanto escurece (para o texto continuar legível)';

  @override
  String get backgroundCardColor => 'Cor dos cartões';

  @override
  String get backgroundTextColor => 'Cor da letra';

  @override
  String get backgroundCardOpacity => 'O quanto os cartões tapam o fundo';

  @override
  String get backgroundColorDefault => 'A de sempre';

  @override
  String get backgroundPreview => 'Como fica';

  @override
  String get backgroundNotAnImage =>
      'Escolha uma imagem (.jpg, .png ou .webp) como papel de parede.';

  @override
  String get backgroundTooBig =>
      'Essa imagem é grande demais para usar de papel de parede.';

  @override
  String get welcomeTitle =>
      'Bem-vindo à forja. Coloque suas cartas do jeito que preferir — ou teste o Forge antes de colocar qualquer uma.';

  @override
  String get welcomeScan => 'Escanear minhas cartas';

  @override
  String get welcomeImport => 'Importar CSV (ManaBox)';

  @override
  String get welcomeTryForge => 'Testar o Forge sem coleção';

  @override
  String get decksEmptyGoForge => 'Ir para o Forge';

  @override
  String get yourCollection => 'Sua coleção';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies cartas · $distinct diferentes';
  }

  @override
  String get marketArrow => 'Mercado ›';
}
