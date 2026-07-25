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

  @override
  String get certHeadingSetComplete => 'CERTIFICADO DE COLEÇÃO COMPLETA';

  @override
  String get certSubtitleSetComplete => 'Coleção completa';

  @override
  String get certHeadingWelcome => 'CERTIFICADO DE BOAS-VINDAS';

  @override
  String get certWelcomeTitle => 'Bem-vindo ao mundo de Magic';

  @override
  String get certSubtitleWelcome => 'Sua primeira carta';

  @override
  String certCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartas',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String certStartedWith(String name) {
    return 'Comecei com $name';
  }

  @override
  String get certCollectorAnon => 'Colecionador ManaForge';

  @override
  String certAwardedTo(String name) {
    return 'Concedido a $name';
  }

  @override
  String certOnDate(String date) {
    return 'em $date';
  }

  @override
  String get certDataBy => 'Dados por Scryfall';

  @override
  String get onbCollectionTitle => 'Sua coleção';

  @override
  String get onbCollectionBody =>
      'Todas as suas cartas ficam aqui, em pastas e por coleção.';

  @override
  String get onbScanTitle => 'Escanear cartas';

  @override
  String get onbScanBody => 'Adicione cartas novas com a câmera ou uma foto.';

  @override
  String get onbForgeTitle => 'Forjar decks';

  @override
  String get onbForgeBody =>
      'Monte decks completos com as cartas que você já tem.';

  @override
  String get onbDecksTitle => 'Seus decks';

  @override
  String get onbDecksBody => 'Os decks salvos no Forge aparecem aqui.';

  @override
  String get onbSkip => 'Pular';

  @override
  String get onbNext => 'Próximo';

  @override
  String get onbGotIt => 'Entendi';

  @override
  String get onbBack => 'Voltar';

  @override
  String get tourMenuTitle => 'Guias';

  @override
  String get tourWelcomeName => 'Tour rápido';

  @override
  String get tourHomeName => 'A tela inicial';

  @override
  String get onbEditHomeTitle => 'Personalize seu início';

  @override
  String get onbEditHomeBody =>
      'Este botão permite escolher quais seções aparecem no início e em que ordem.';

  @override
  String get onbLangTitle => 'Idioma';

  @override
  String get onbLangBody => 'Mude aqui o idioma de todo o app.';

  @override
  String get onbLookTitle => 'Aparência';

  @override
  String get onbLookBody =>
      'Coloque um papel de parede e escolha as cores de cartas, texto, abas e ícones.';

  @override
  String get tourSettingsName => 'Personalizar o app';

  @override
  String get tourFullName => 'Volta completa pela app';

  @override
  String get tourCollectionName => 'A tua coleção e as pastas';

  @override
  String get tourForgeName => 'Forjar um baralho';

  @override
  String get tourMarketName => 'Mercado, wishlist e alertas';

  @override
  String get onbAllCardsTitle => 'Todas as cartas';

  @override
  String get onbAllCardsBody =>
      'Toda a tua coleção: procurar, filtrar e ordenar.';

  @override
  String get onbFoldersTitle => 'Pastas';

  @override
  String get onbFoldersBody =>
      'As pastas são etiquetas: agrupam o que quiseres e uma carta pode estar em várias. Com «Nova» crias a primeira.';

  @override
  String get onbAlbumMineTitle => 'O álbum por expansões';

  @override
  String get onbAlbumMineBody =>
      'Cada expansão com os seus espaços. Este filtro mostra só as expansões onde já tens cartas.';

  @override
  String get onbForgeBasicsTitle => 'Terrenos básicos';

  @override
  String get onbForgeBasicsBody =>
      'Se tens básicos soltos por casa, deixa ligado: o Forge conta com eles. Desliga para usar só os da tua coleção.';

  @override
  String get onbForgeSetsTitle => 'Expansões';

  @override
  String get onbForgeSetsBody =>
      'Limita de onde saem as cartas. Sem escolher nenhuma, o Forge usa toda a coleção.';

  @override
  String get onbForgeMissingTitle => 'Cartas que não tenho';

  @override
  String get onbForgeMissingBody =>
      'Ao ativar, o Forge também propõe cartas que te faltam e diz quantas são e quanto custariam.';

  @override
  String get onbForgeGoTitle => 'Forjar';

  @override
  String get onbForgeGoBody =>
      'Este botão faz os baralhos. Com muitas expansões demora alguns segundos.';

  @override
  String get onbForgeTestTitle => 'Modo Teste';

  @override
  String get onbForgeTestBody =>
      'Mede o teu baralho contra um do meta e vê o que lhe falta para ganhar.';

  @override
  String get onbMarketPickTitle => 'Escolher mercado';

  @override
  String get onbMarketPickBody =>
      'Cardmarket ou TCGplayer: muda o preço de cada carta e o seu gráfico.';

  @override
  String get onbWishlistTitle => 'Wishlist';

  @override
  String get onbWishlistBody =>
      'As cartas que queres. O contador fica verde quando alguma chega ao teu preço.';

  @override
  String get onbPriceAlertTitle => 'Alerta de preço';

  @override
  String get onbPriceAlertBody =>
      'Procura uma carta, toca no marcador para a pôr na wishlist e define um preço-alvo: a app avisa-te quando descer.';

  @override
  String get tourProgressName => 'Conquistas e certificados';

  @override
  String get onbAchievementsTitle => 'Conquistas e nível';

  @override
  String get onbAchievementsBody =>
      'O teu nível e tudo o que já ganhaste. Sobe a digitalizar, a arrumar e a forjar.';

  @override
  String get onbCertificatesTitle => 'Certificados';

  @override
  String get onbCertificatesBody =>
      'Os marcos grandes viram um diploma que podes guardar em PDF ou mostrar. Estão dentro das Conquistas.';

  @override
  String get onbBackupTitle => 'Cópia de segurança';

  @override
  String get onbBackupBody =>
      'Guarda a tua coleção, baralhos e pastas num ficheiro e recupera-os se mudares de computador. Há também uma cópia automática todas as semanas.';

  @override
  String onbTapHere(String pantalla) {
    return 'Toca aqui para abrir $pantalla.';
  }

  @override
  String get onbAchievementsName => 'Conquistas';

  @override
  String get onbDataSectionTitle => 'Dados';

  @override
  String get onbDataSectionBody =>
      'Aqui vive tudo o que a app guarda: a base de cartas e as tuas cópias de segurança.';

  @override
  String get onbCardDbTitle => 'Base de dados de cartas';

  @override
  String get onbCardDbBody =>
      'Volta a descarregá-la para teres cartas novas, preços frescos e o que precisa de dados recentes, como o filtro por ano do Forge.';

  @override
  String get onbAboutTitle => 'A app';

  @override
  String get onbAboutBody =>
      'O que faz cada separador, os atalhos de teclado, a versão e a licença.';

  @override
  String get colStartHere => 'Sua coleção começa aqui';

  @override
  String get colNeedDb =>
      'Primeiro preciso do banco de dados com todas as cartas de Magic (ele baixa uma vez e depois tudo funciona sem internet).';

  @override
  String colDownloading(String pct) {
    return 'Baixando… $pct %';
  }

  @override
  String get colDownloadDb => 'Baixar o banco de dados de cartas';

  @override
  String get colScryfall =>
      'Dados e imagens por Scryfall · Sem contas, sem pagamentos: tudo fica no seu dispositivo.';

  @override
  String get colAlbumTooltip => 'Álbum por expansões';

  @override
  String get colImportTooltip => 'Importar CSV do ManaBox';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies cartas · $distinct diferentes$valor';
  }

  @override
  String get colAllCards => 'Todas as cartas';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct diferentes · buscar, filtrar e ordenar';
  }

  @override
  String get colFolders => 'Pastas';

  @override
  String get colNewFolder => 'Nova';

  @override
  String get colNoFolders =>
      'Você ainda não tem pastas. Elas servem para agrupar o que você quiser: \"raras de Aetherdrift\", \"para vender\", \"a caixa lá de cima\"… Uma carta pode estar em várias.';

  @override
  String get colCreateFirstFolder => 'Criar a primeira pasta';

  @override
  String get colEmptyTitle => 'É aqui que começa sua coleção';

  @override
  String get colEmptyBody =>
      'Escaneie suas cartas com a câmera ou importe um CSV do ManaBox. Elas vão aparecer aqui e no álbum.';

  @override
  String get colImportShort => 'Importar CSV';

  @override
  String acForgetTitle(String carta) {
    return 'Não tem mais $carta?';
  }

  @override
  String get acForgetBody =>
      'Ela sai da sua coleção e o espaço dela no álbum fica vazio de novo.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Também sai das $n pastas em que está.',
      one: 'Também sai da pasta em que está.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Os decks NÃO a perdem: ela continua na lista e o deck avisa que está faltando.';

  @override
  String get acCancel => 'Cancelar';

  @override
  String get acDelete => 'Borrar';

  @override
  String get acForgetConfirm => 'Não tenho mais';

  @override
  String acAddedOn(String cuando) {
    return 'adicionada $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'em $n pastas',
      one: 'em 1 pasta',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Busque uma carta (espanhol ou inglês)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles de $total cartas';
  }

  @override
  String get acMissingFilterData =>
      ' · algumas cartas antigas não têm dados de filtro: reimporte seu CSV com \"Substituir\" ativado';

  @override
  String get acNoneMatch => 'Nenhuma carta passa por esses filtros.';

  @override
  String get acEmptyHint =>
      'Busque sua primeira carta aí em cima, ou volte e importe seu CSV do ManaBox.';

  @override
  String get onbHowItWorksBody =>
      'O resumo do que cada aba faz e os atalhos de teclado. Se você se perder, comece por aqui.';

  @override
  String get onbVersionBody =>
      'Qual versão você tem, o que ela traz, e se você quer que o app dê uma olhada uma vez por dia se tem versão nova. Ele nunca se atualiza sozinho.';

  @override
  String get onbScanSetTitle => 'Set: todos';

  @override
  String get onbScanSetBody =>
      'Se você está abrindo boosters de UMA expansão, fixe ela aqui: o escâner para de ficar em dúvida entre as dez reimpressões da mesma carta.';

  @override
  String get onbScanModeTitle => 'Rápido ou com calma';

  @override
  String get onbScanModeBody =>
      'No \"Rápido\", as cartas claras entram sozinhas e as duvidosas ficam marcadas para revisar. No \"Com calma\", ele para e pergunta qual é.';

  @override
  String get onbScanPhotoTitle => 'Escanear uma foto';

  @override
  String get onbScanPhotoBody =>
      'Sem câmera, ou com as cartas já fotografadas? Aqui você solta uma foto — com várias cartas, se quiser — e ele tira todas do mesmo jeito.';

  @override
  String get tourScanName => 'O escâner';

  @override
  String get albNeedDb =>
      'O álbum precisa do banco de dados de cartas (baixe em Coleção).';

  @override
  String get albRetry => 'Tentar de novo';

  @override
  String get albApproxMode =>
      'Álbum em modo aproximado: ainda não sei qual EDIÇÃO exata você tem de cada carta. Reimporte seu CSV com \"Substituir minha coleção atual\" ativado e o álbum vai afinar pelas ilustrações.';

  @override
  String get albSearchSet => 'Busque uma expansão…';

  @override
  String get albOnlyMine => 'Com cartas minhas';

  @override
  String get albSortProgress => 'Mais completas';

  @override
  String get albSortNewest => 'Mais novas';

  @override
  String get albSortOldest => 'Mais antigas';

  @override
  String get albSortName => 'Por nome';

  @override
  String get albYearAll => 'Ano: todos';

  @override
  String get albLetterAll => 'Todas';

  @override
  String get albNoSets => 'Nenhuma expansão bate com o filtro.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total cartas';
  }

  @override
  String get albComplete => ' · ✓ completa!';

  @override
  String albLoadError(String error) {
    return 'Não consegui carregar o set: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Buscar em $set…';
  }

  @override
  String get albOnlyMissing => 'Só as que faltam';

  @override
  String get albWithVariants => 'Com variantes';

  @override
  String get albYouHaveItAll => '✓ Você tem tudo';

  @override
  String albMissingCount(int n) {
    return 'Faltam $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n sem preço)';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles de $total';
  }

  @override
  String get albNoCardsNamed => 'Nenhuma carta com esse nome aqui.';

  @override
  String get fdNewFolder => 'Nova pasta';

  @override
  String get fdEditFolder => 'Editar pasta';

  @override
  String get fdName => 'Nome';

  @override
  String get fdNameHint => 'Raras de Aetherdrift, Para vender…';

  @override
  String get fdColor => 'Cor';

  @override
  String get fdIcon => 'Ícone';

  @override
  String get fdCreate => 'Criar';

  @override
  String get fdSave => 'Salvar';

  @override
  String get fdDefaultName => 'Pasta';

  @override
  String fdDeleteTitle(String nombre) {
    return 'Apagar \"$nombre\"?';
  }

  @override
  String get fdDeleteBody =>
      'Some só a pasta: as cartas continuam na sua coleção.';

  @override
  String get fdDelete => 'Apagar';

  @override
  String get fdGone => 'Essa pasta não existe mais.';

  @override
  String get fdEditTooltip => 'Editar nome, cor e ícone';

  @override
  String get fdDeleteTooltip => 'Apagar pasta';

  @override
  String get fdAddRemove => 'Adicionar ou tirar';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas cartas diferentes · $copias cópias';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n passam pelo filtro';
  }

  @override
  String get fdRoughValue => ' · valor aproximado';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n cartas não estão mais na sua coleção (continuam anotadas, vai que elas voltam).',
      one:
          '1 carta não está mais na sua coleção (continua anotada, vai que ela volta).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Tirar essas';

  @override
  String get fdNoneMatch => 'Nenhuma carta da pasta passa por esses filtros.';

  @override
  String get fdEmpty =>
      'Pasta vazia. Toque em \"Adicionar ou tirar\" e marque as cartas que você quer colocar nela.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cópias',
      one: '1 cópia',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Tirar da pasta';

  @override
  String get fpPickCards => 'Escolha as cartas';

  @override
  String fpSaveCount(int n) {
    return 'Salvar ($n)';
  }

  @override
  String get fpFilterByName => 'Filtre por nome…';

  @override
  String fpVisibleCards(int n) {
    return '$n cartas à vista';
  }

  @override
  String get fpSelectAll => 'Marcar todas';

  @override
  String get fpNoneMatch => 'Nenhuma carta passa por esses filtros.';

  @override
  String get fgMsgReading => 'Lendo sua coleção…';

  @override
  String get fgMsgCurve => 'Calculando a curva de mana…';

  @override
  String get fgMsgLands => 'Distribuindo os terrenos…';

  @override
  String get fgMsgSynergy => 'Procurando sinergias…';

  @override
  String get fgMsgPlan => 'Escrevendo seu plano de jogo…';

  @override
  String get fgNeedDbForSets =>
      'Preciso do banco de cartas para listar as expansões: Configurações → baixar o banco.';

  @override
  String fgDbError(String error) {
    return 'Não consegui ler o banco de dados de cartas: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' nessas $n expansões',
      one: ' nessa expansão',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'Não sai um Commander legal$donde: precisa de um comandante lendário e ~62 cartas DIFERENTES dentro da identidade de cor dele (é singleton), mais básicos suficientes. Tente outro formato, outras expansões ou aumente a coleção.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'Com as cartas desse pool não sai nenhum deck completo $formato que cumpra minhas regras (terrenos suficientes e curva saudável)$donde. $consejo Antes de te dar um deck defeituoso, prefiro te avisar.';
  }

  @override
  String get fgOf60 => 'de 60';

  @override
  String fgLegalIn(String formato) {
    return 'LEGAL em $formato';
  }

  @override
  String get fgTipMoreSets =>
      'Tente com mais expansões ou tire alguns filtros.';

  @override
  String get fgTipMoreCards =>
      'Adicione mais cartas — principalmente das suas cores principais — ou marque \"incluir cartas que não tenho\".';

  @override
  String get fgPitch =>
      'Decks completos e jogáveis com as cartas que você já tem. Sem comprar nada.';

  @override
  String get fgTeaserCount => 'cartas para o seu primeiro deck';

  @override
  String get fgTeaserMissing => 'Fazer um deck com cartas que não tenho';

  @override
  String get fgBasics => 'Conto com terrenos básicos avulsos';

  @override
  String get fgBasicsSub =>
      'Quase todo mundo tem básicos de decks iniciais; desative para usar SÓ os básicos da sua coleção.';

  @override
  String get fgFormat => 'Formato de jogo';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 cartas · singleton · comandante lendário da sua coleção · identidade de cor respeitada.';

  @override
  String get fgCasualNote =>
      '60 cartas, sem restrição de legalidade: vale tudo.';

  @override
  String fgFormatNote(String formato) {
    return '60 cartas usando SÓ suas cartas legais em $formato.';
  }

  @override
  String get fgWhereFrom => 'De onde saem as cartas?';

  @override
  String get fgPickSets => 'Escolher expansões';

  @override
  String get fgChangeSets => 'Trocar expansões';

  @override
  String get fgNeedOneSet =>
      'Escolha pelo menos uma expansão: sem filtro seriam as ~30.000 cartas de Magic.';

  @override
  String get fgNoSetsNote =>
      'Sem escolher expansões, o Forge usa a sua coleção inteira.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cartas de $n expansões, tendo você ou não.',
      one: 'Cartas de 1 expansão, tendo você ou não.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Só as suas cartas de $n expansões — não a coleção toda.',
      one: 'Só as suas cartas de 1 expansão — não a coleção toda.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'Sua coleção não guarda a edição de cada carta, então filtrar por expansão deixaria quase tudo de fora. Reimporte seu CSV com \"Substituir\" e volte aqui.';

  @override
  String get fgIncludeMissing => 'Incluir cartas que não tenho';

  @override
  String get fgIncludeMissingSub =>
      'O Forge deixa de se limitar à sua coleção e usa TUDO que foi impresso nessas expansões; depois ele te diz quantas cartas faltam e quanto custariam.';

  @override
  String get fgYourTaste => 'Do seu jeito (opcional)';

  @override
  String get fgArchetypeAuto => 'Arquétipo: auto';

  @override
  String get fgPricePerCard => 'Preço por carta:';

  @override
  String get fgMin => 'mín €';

  @override
  String get fgMax => 'máx €';

  @override
  String get fgCardYear => 'Ano da carta:';

  @override
  String get fgFrom => 'de';

  @override
  String get fgTo => 'até';

  @override
  String get fgYearNeedsDb =>
      'O filtro por ano precisa do banco de dados atualizado: Configurações → Baixar o banco de dados de novo.';

  @override
  String get fgNoColorsNote =>
      'Sem escolher cores, o Forge testa todas as combinações.';

  @override
  String fgColorsNote(String colores) {
    return 'Só decks $colores (e suas combinações).';
  }

  @override
  String get fgMissingNote =>
      'Esse deck pode levar cartas que você NÃO tem: cada proposta diz quantas faltam e quanto custariam (preço do Cardmarket).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'O Forge só usa as suas $n cartas. Ele nunca inventa cópias que você não tem.';
  }

  @override
  String get fgForgeMissing => 'Forjar decks (com o que faltar)';

  @override
  String get fgForgeMine => 'Forjar meus decks';

  @override
  String get fgTestMode => 'Modo Teste: vença um deck do meta';

  @override
  String get fgOffline => 'Tudo é calculado no seu dispositivo, sem internet';

  @override
  String fgForgingWith(int n) {
    return 'Você está forjando com $n cartas: isso leva alguns segundos. A janela continua viva.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n decks prontos para jogar',
      one: '1 deck pronto para jogar',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'Com cartas que você ainda não tem · deslize para comparar';

  @override
  String get fgSwipeMine =>
      'Feitos só com as suas cartas · deslize para comparar';

  @override
  String get fgHaveAll => '✓ Você tem todas as cartas';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Faltam $n cartas',
      one: 'Falta 1 carta',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Ver o deck completo';

  @override
  String get fgReforge => 'Forjar de novo';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 $carta está a $precio (seu alvo: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 $n cartas da sua wishlist caíram para o preço alvo!';
  }

  @override
  String get mkTellMeWhenDrops => 'Me avise quando baixar';

  @override
  String get mkTargetPrice => 'Preço alvo';

  @override
  String mkNow(String precio) {
    return 'Agora: $precio';
  }

  @override
  String get mkUpdated => '✓ Preços e cartas atualizados';

  @override
  String mkUpdateFailed(String error) {
    return 'Não consegui atualizar: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Histórico de preços pronto: os gráficos já mostram os últimos meses';

  @override
  String mkHistoryFailed(String error) {
    return 'Não consegui trazer o histórico (o que você já tinha continua intacto): $error';
  }

  @override
  String get mkHistoryLocal =>
      'Histórico de preços: só o que o ManaForge anota todo dia na sua máquina. Traga os últimos ~90 dias reais do Cardmarket (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Histórico real do Cardmarket de $desde a $hasta, e daí em diante o que o ManaForge for anotando.';
  }

  @override
  String get mkFetchHistory => 'Trazer histórico';

  @override
  String get mkCollectionValue => 'Quanto vale a sua coleção · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n cartas';
  }

  @override
  String get mkApproxSuffix => ' · valor aproximado';

  @override
  String mkBulkPrices(String fecha) {
    return 'Preços do Cardmarket de $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Mercado sem dados: baixe o banco de dados em Coleção. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'EXPANSÕES ($n)';
  }

  @override
  String get mkPrevious => 'Anteriores';

  @override
  String get mkNext => 'Próximas';

  @override
  String get mkSearchHint => 'Busque o preço de qualquer carta…';

  @override
  String get mkRemoveFromWishlist => 'Tirar da wishlist';

  @override
  String get mkAddToWishlist => 'Pra wishlist: me avise quando baixar';

  @override
  String get mkYourWishlist => 'SUA WISHLIST';

  @override
  String mkTargetAtMost(String precio) {
    return 'alvo ≤ $precio';
  }

  @override
  String get mkAtPrice => 'no seu preço!';

  @override
  String get mkChangeTarget => 'Mudar o preço alvo';

  @override
  String mkNoPriceIn(String market) {
    return 'sem preço em $market';
  }

  @override
  String get mkPerUnit => '/ud';

  @override
  String get mkTopCards => 'SUAS CARTAS MAIS VALIOSAS';

  @override
  String get mkImportToSeeValue =>
      'Importe sua coleção para ver quanto ela vale.';

  @override
  String mkSetCards(int n) {
    return ' · $n cartas';
  }

  @override
  String get wlEmpty =>
      'Procure elas no Mercado e toque no marcador para o app te avisar quando baixarem para o seu preço.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '🔔 $n cartas da sua wishlist estão no seu preço alvo ou abaixo dele.',
      one: '🔔 1 carta da sua wishlist está no seu preço alvo ou abaixo dele.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'Preços do MTGO em tix (cartas digitais)';

  @override
  String get mpNoDataYet =>
      'Sem dados ainda: atualize o histórico de preços no Mercado';

  @override
  String get mpMtgoNote =>
      'Preços do MTGO em tix: são cartas digitais, não servem para avaliar sua coleção de papel. Início, pastas e conquistas continuam no Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return 'Preços do $mercado em $moneda. Início, pastas e conquistas continuam avaliando pelo Cardmarket (€): as moedas nunca são convertidas.';
  }

  @override
  String get mkUpdate => 'Atualizar';

  @override
  String get mkApproxValue =>
      ' · valor aproximado (reimporte com \"Substituir\" para preços por edição)';

  @override
  String get mkExactPrintings => ' · pelas suas edições exatas';

  @override
  String mkNowSuffix(String precio) {
    return ' · agora $precio';
  }

  @override
  String get wlNothingYet => 'Nada na sua wishlist ainda.';

  @override
  String get stDbUpdated => '✓ Banco de dados atualizado';

  @override
  String stUpdateFailed(String error) {
    return 'Não foi possível atualizar: $error';
  }

  @override
  String get stCardDb => 'Banco de dados de cartas';

  @override
  String get stCardDbWhy =>
      'Baixe de novo para ter cartas novas, preços frescos e as funções que precisam de dados recentes (como o filtro por ano do Forge).';

  @override
  String get stDownloadDbAgain => 'Baixar o banco de dados de novo';

  @override
  String get stAppearance => 'Aparência';

  @override
  String get stData => 'Dados';

  @override
  String get stTheApp => 'O app';

  @override
  String get stCredits =>
      'Dados e imagens das cartas por Scryfall. Magic: The Gathering é propriedade da Wizards of the Coast; projeto de fãs sob a Fan Content Policy deles.';

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
  String get stEditHome => 'Editar o Início';

  @override
  String get stEditHomeSub => 'Escolha quais seções aparecem e em que ordem';

  @override
  String get ehLevel => 'Seu nível';

  @override
  String get ehShortcuts => 'Atalhos';

  @override
  String get ehSummary => 'Resumo da coleção';

  @override
  String get ehRecent => 'Vistas recentemente';

  @override
  String get ehDecks => 'Seus decks';

  @override
  String get ehMeta => 'O meta agora';

  @override
  String get ehNewSets => 'Expansões novas';

  @override
  String get ehGems => 'Suas joias';

  @override
  String get ehStatCards => 'cartas';

  @override
  String get ehStatDistinct => 'diferentes';

  @override
  String get ehStatValue => 'valor';

  @override
  String get ehStatDecks => 'decks';

  @override
  String get ehStatAchievements => 'conquistas';

  @override
  String get ehHelp =>
      'Arraste para ordenar e use a chavinha para escolher o que você vê no Início. Uma seção ligada só aparece se tiver algo para mostrar.';

  @override
  String get ehSection => 'Seção';

  @override
  String get bkNoData => 'Não encontro seus dados.';

  @override
  String bkSaved(String resumen) {
    return '✓ Cópia salva · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'Não consegui salvar: $error';
  }

  @override
  String get bkFileName => 'Cópia do ManaForge';

  @override
  String bkRestoreFailed(String error) {
    return 'Não consegui restaurar: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Restaurado · $resumen. ATENÇÃO: não consegui salvar o que você tinha antes ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Restaurado · $resumen. O que você tinha antes está salvo na pasta backups.';
  }

  @override
  String get bkRestoring => 'Restaurando sua cópia…';

  @override
  String get bkTitle => 'Cópia de segurança';

  @override
  String get bkWhy =>
      'Suas cartas, decks, pastas e conquistas vivem só neste computador. Salve uma cópia de vez em quando e deixe ela em outro lugar: um HD, a nuvem, o que você quiser.';

  @override
  String get bkSave => 'Salvar cópia';

  @override
  String get bkRestoreTitle => 'Restaurar uma cópia';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Restaurar SUBSTITUI suas cartas, decks, pastas e conquistas de agora pelas da cópia. Escolha qual, aperte o botão e escreva $palabra: assim nada é restaurado sem querer.';
  }

  @override
  String get bkNoBackups => 'Ainda não há cópias salvas neste computador.';

  @override
  String get bkWhich => 'Cópia a restaurar';

  @override
  String get bkPickOne => 'Escolha uma cópia';

  @override
  String get bkRestorePicked => 'Restaurar a cópia escolhida';

  @override
  String get bkAutoNote =>
      'Salvo uma cópia automática toda semana (as cinco últimas) e outra logo antes de cada restauração.';

  @override
  String get bkFromFile => 'Restaurar de um arquivo';

  @override
  String get bkConfirmTitle => 'Restaurar esta cópia?';

  @override
  String get bkConfirmBody =>
      'Isso substitui sua coleção, decks, pastas e conquistas de agora pelos dessa cópia. Antes de fazer isso, salvo o que você tem na pasta backups, caso você queira voltar.';

  @override
  String bkWillDelete(String cosas) {
    return 'Essa cópia não traz $cosas: ao restaurar, isso é apagado.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Escreva $palabra para poder seguir:';
  }

  @override
  String get bkAnd => ' e ';

  @override
  String get ehReset => 'Restaurar padrão';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Cópia de $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'Não encontro nenhuma câmera.';

  @override
  String get lsCameraGone =>
      'A câmera se desconectou no meio da sessão. Confira o cabo e toque em Tentar de novo.';

  @override
  String get lsFrameCard => 'Encaixe a carta dentro da moldura';

  @override
  String get lsNoCardThere => 'Não vejo carta nenhuma aí';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n cartas para a coleção',
      one: '✓ 1 carta para a coleção',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', e para \"$carpeta\"';
  }

  @override
  String get lsTitle => 'Escanear ao vivo';

  @override
  String get lsQuickTip =>
      'Rápido: as cartas claras entram sozinhas; as duvidosas ficam marcadas para revisar.';

  @override
  String get lsCarefulTip =>
      'Com calma: as duvidosas param e perguntam qual carta é.';

  @override
  String get lsQuick => 'Rápido';

  @override
  String get lsCareful => 'Com calma';

  @override
  String lsThisSession(int n) {
    return '$n nesta sessão';
  }

  @override
  String get lsScanPhotoTooltip => 'Escanear uma foto avulsa';

  @override
  String get lsStartingCamera => 'Acordando a câmera…';

  @override
  String get lsCantUseCamera => 'Não consigo usar a câmera';

  @override
  String get lsCameraUnavailable => 'Câmera indisponível.';

  @override
  String get lsScanPhoto => 'Escanear uma foto';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 igual · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Já está na mesa: $carta · tire e ponha de novo, ou toque em \"+1 igual\"';
  }

  @override
  String lsSeeing(String carta) {
    return 'Vendo: $carta';
  }

  @override
  String get lsPassACard => 'Passe uma carta na frente da câmera…';

  @override
  String lsIsThis(String carta) {
    return 'É $carta? Não tenho certeza — toque para escolher.';
  }

  @override
  String get lsNotThisOne => 'Não é essa — trocar de edição';

  @override
  String get lsRetry => 'Tentar de novo';

  @override
  String get scBadImage => 'Não consegui ler essa imagem (é uma foto válida?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Sem pasta';

  @override
  String scAlsoTo(String carpeta) {
    return 'E também para: $carpeta';
  }

  @override
  String get scLookingForCard => 'Procurando a carta na foto…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Reconhecendo… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartas',
      one: '1 carta',
    );
    return '$_temp0 · $copias no total';
  }

  @override
  String scToReview(int n) {
    return '$n para revisar (toque nelas)';
  }

  @override
  String scUnknown(int n) {
    return '$n sem reconhecer (toque para escolher na mão)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fotos ignoradas (grandes demais ou ilegíveis)',
      one: '1 foto ignorada (grande demais ou ilegível)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'Não reconheci nenhuma carta nessas fotos. Tente com luz melhor ou menos reflexo.';

  @override
  String scAddN(int n) {
    return 'Adicionar $n à coleção';
  }

  @override
  String get scDropPhotos => 'Solte aqui as fotos das suas cartas';

  @override
  String get scDropExplain =>
      'Uma ou várias de uma vez — e se uma foto trouxer VÁRIAS cartas (uma página do álbum, a mesa cheia), eu tiro todas e junto numa lista para você revisar e adicionar as que quiser. Vale foto de celular ou digitalização.';

  @override
  String get scPickPhotos => 'Escolher fotos';

  @override
  String get scMatchHigh => 'combinação alta';

  @override
  String get scMatchMedium => 'combinação média';

  @override
  String get scMatchLow => 'combinação baixa';

  @override
  String get scAddToCollection => 'Adicionar à coleção';

  @override
  String get scSeeOptions => 'Não é essa — ver opções';

  @override
  String get scScanAnother => 'Escanear outra';

  @override
  String get scNotSure => 'Não tenho certeza';

  @override
  String get scWhichIsIt => 'Qual é?';

  @override
  String get scNoneQuiteFits =>
      'Nenhuma encaixa direito. É alguma dessas? Se não, tente outra foto com luz melhor.';

  @override
  String get scNoEdges =>
      'Não vi as bordas da carta, então usei a imagem inteira. Estas são as parecidas:';

  @override
  String get scCropped =>
      'Isto foi o que eu recortei. As candidatas, por semelhança:';

  @override
  String get scDiscard => 'Descartar e escanear outra';

  @override
  String get suCardsName => 'Cartas e preços';

  @override
  String get suCardsWhat => 'catálogo completo do Scryfall';

  @override
  String get suHistoryName => 'Histórico de preços';

  @override
  String get suHistoryWhat => '~90 dias do Cardmarket';

  @override
  String get suHashesName => 'Digitais do escâner';

  @override
  String get suHashesWhat => 'para reconhecer por foto';

  @override
  String suUpToDate(String fecha) {
    return 'em dia ($fecha)';
  }

  @override
  String get suUpdated => 'atualizado';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'atualizado ($fecha)';
  }

  @override
  String get suFailedOffline => 'não consegui trazer (sem conexão)';

  @override
  String get suKeepingOld => 'sigo com a que você tinha';

  @override
  String get suNeedMissing => 'falta, estou trazendo';

  @override
  String get suNeedStale => 'tem uma nova';

  @override
  String get suNeedFresh => 'em dia';

  @override
  String get suAllUpToDate => 'Tudo em dia. Entrando…';

  @override
  String get suUpdatingCards => 'Deixando suas cartas e preços em dia…';

  @override
  String get suChecking => 'Vendo se tem novidade…';

  @override
  String get suNoDownloadNote =>
      'O que já está em dia não é baixado. Dentro do app você pode forçar qualquer atualização.';

  @override
  String get suEnter => 'Entrar';

  @override
  String get suEnterNow => 'Entrar já';

  @override
  String icBadFile(String error) {
    return 'Não consegui ler o arquivo: $error';
  }

  @override
  String get icNotCsv =>
      'Isso não parece um CSV — solte um arquivo .csv ou .txt.';

  @override
  String get icTitle => 'Importar coleção';

  @override
  String get icExplain =>
      'Arraste aqui seu CSV do ManaBox (também vale Moxfield, Archidekt ou qualquer CSV com as colunas Name e Quantity), escolha ele pelo botão, ou cole o conteúdo na mão:';

  @override
  String get icPickFile => 'Escolher arquivo…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas cartas ($copias cópias) adicionadas à sua coleção.';
  }

  @override
  String get icReplaceMine => 'Substituir minha coleção atual';

  @override
  String get icReplaceWhy =>
      'Ative ao reimportar seu CSV completo: evita duplicar quantidades e afina o álbum por edições.';

  @override
  String icImporting(int hechas, int total) {
    return 'Importando $hechas de $total cartas…';
  }

  @override
  String get icDropHere => 'Solte seu CSV aqui';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n fichas/emblemas ignorados (não vão em decks, tudo certo).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Sem reconhecer: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• Sem preço de compra no CSV: não vai ter P&L (o ManaBox exporta isso na coluna \"Purchase price\").';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n cópias com preço de compra: já dá para ver o P&L no Mercado.';
  }

  @override
  String get icImporting2 => 'Importando…';

  @override
  String get icImport => 'Importar';

  @override
  String dkDeleted(String nombre) {
    return 'Deck \"$nombre\" apagado';
  }

  @override
  String get dkUndo => 'DESFAZER';

  @override
  String dkOpenFailed(String error) {
    return 'Não consegui abrir o deck (o banco de dados está baixado?): $error';
  }

  @override
  String get dkMyDecks => 'Meus decks';

  @override
  String get dkEmpty =>
      'Aqui vão morar os decks que você salvar pelo Forge (botão de salvar no detalhe do deck).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n salvos',
      one: '1 salvo',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos mágicas + $tierras terrenos · salvo em $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Apagar deck';

  @override
  String get ddSaved => '✓ Deck salvo — ele está na aba Decks';

  @override
  String get ddReforged => '✓ Deck reforjado na sua curva — lista atualizada';

  @override
  String get ddSaveToMyDecks => 'Salvar em Meus decks';

  @override
  String get ddCopyList => 'Copiar lista (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ Lista copiada — cole no Moxfield, no Arena ou no Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos mágicas + $tierras terrenos';
  }

  @override
  String get ddHaveAll => '✓ Você tem todas as cartas';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ Faltam $n cartas desse deck — elas continuam na lista, não foram apagadas',
      one:
          '⚠ Falta 1 carta desse deck — ela continua na lista, não foi apagada',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Seu plano de jogo';

  @override
  String get ddManaCurve => 'Curva de mana';

  @override
  String get ddEditCurve => 'Editar a curva';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Arraste as barras ↑↓ · $hechizos mágicas → $tierras terrenos';
  }

  @override
  String get ddReforgeCurve => 'Reforjar com esta curva';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras terrenos · ✦ $hechizos mágicas · Ø custo $coste';
  }

  @override
  String get ddWhyWorks => 'Por que este deck funciona?';

  @override
  String ddLands(int n) {
    return 'TERRENOS ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Total do deck: ~$precio €';
  }

  @override
  String get ddCheapestPrice => 'preço da edição mais barata (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n sem preço conhecido · edição mais barata (Cardmarket)';
  }

  @override
  String get ddInstants => 'Mágicas Instantâneas';

  @override
  String get ddTypeCreatures => 'Criaturas';

  @override
  String get ddTypeSorceries => 'Feitiços';

  @override
  String get ddTypeEnchantments => 'Encantamentos';

  @override
  String get ddTypeArtifacts => 'Artefatos';

  @override
  String get ddTypeOther => 'Outros';

  @override
  String get ddOutOfRange => '  (fora da faixa saudável 20-27)';

  @override
  String get acRecalcTitle => 'Recalcular as conquistas?';

  @override
  String get acRecalcBody =>
      'Suas cartas são conferidas de novo e as conquistas que hoje não se cumprem são tiradas. Serve para arrumar as que saíram por engano; se você vendeu cartas, também vai perder essas.';

  @override
  String get acRecalc => 'Recalcular';

  @override
  String get acAllFine => 'Estava tudo certo: nenhuma conquista foi tirada.';

  @override
  String acRemovedN(int n) {
    return 'Tiradas $n conquistas que não se cumprem mais.';
  }

  @override
  String get acTitle => 'Conquistas';

  @override
  String get acRecalcTooltip => 'Recalcular com as minhas cartas de agora';

  @override
  String get acCertsTooltip => 'Certificados';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos de $total conquistas · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Nível $nivel · faltam $xp XP para o $siguiente';
  }

  @override
  String get acIMissing => 'Que me faltam';

  @override
  String get acSecret => 'Conquista secreta';

  @override
  String get acSecretDesc => 'Só se descobre quando você consegue.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Conquistado$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' em $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return 'Nível $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'Agora você é $titulo. Já são $hechos de $total conquistas.';
  }

  @override
  String get acOk => 'Beleza';

  @override
  String get acSeeAchievements => 'Ver conquistas';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 Conquista! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (e mais $n)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Os de expansão precisam do banco de dados de cartas ($error)';
  }

  @override
  String get ceWhoseName => 'Em nome de quem?';

  @override
  String get ceCollectorName => 'Seu nome de colecionador';

  @override
  String get ceInNameOf => 'Em nome de…';

  @override
  String get ceEmptyWithData =>
      'Você ainda não tem nenhuma expansão completa. Quando completar uma inteira no Álbum, seu certificado vai aparecer aqui para baixar.';

  @override
  String get ceEmptyNoData =>
      'Para certificar uma expansão é preciso saber a edição exata das suas cartas: reimporte seu CSV do ManaBox (ele traz o Scryfall ID).';

  @override
  String get ceNothingSaved => 'Nada foi salvo.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Certificado salvo em $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'Não foi possível salvar: $error';
  }

  @override
  String get cePickFirstCard => 'Escolher a carta com que eu comecei';

  @override
  String get ceChangeFirstCard => 'Trocar a carta com que eu comecei';

  @override
  String get ceDownloadPng => 'Baixar PNG';

  @override
  String get cdNotFound => 'Não encontro esta carta no banco de dados.';

  @override
  String cdLoadFailed(String error) {
    return 'Não consegui carregar a ficha: $error';
  }

  @override
  String get cdPrev => 'Anterior (←)';

  @override
  String get cdNext => 'Próxima (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Carta não encontrada';

  @override
  String cdPaid(
      String total, String divisa, int qty, String copias, String unidad) {
    return 'Você pagou $total$divisa por $qty $copias ($unidad cada uma)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'cópias',
      one: 'cópia',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ Você tem $n cópias na sua coleção',
      one: '✓ Você tem 1 cópia na sua coleção',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'Você não tem esta carta (ainda).';

  @override
  String cdNoPrice(String mercado) {
    return 'Sem preço desta carta no $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'VERSÕES ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'sem preço por edição no $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return 'preços $mercado ($moneda) · normal / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'você tem x$n';
  }

  @override
  String get smMythic => 'Mítica';

  @override
  String get smRare => 'Rara';

  @override
  String get smUncommon => 'Incomum';

  @override
  String get smCommon => 'Comum';

  @override
  String smLoadFailed(String error) {
    return 'Não consegui carregar o set: $error';
  }

  @override
  String get smSearchInSet => 'Busque na expansão…';

  @override
  String get smRarityAll => 'Raridade: todas';

  @override
  String get smPriceDown => 'Preço ↓';

  @override
  String get smPriceUp => 'Preço ↑';

  @override
  String get smNumber => 'Número';

  @override
  String get smOnlyMine => 'Só as minhas';

  @override
  String smCardsCount(int n) {
    return '$n cartas';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: sem preço por edição';
  }

  @override
  String smListedValue(String mercado) {
    return 'valor listado ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'Você pagou $pagado · hoje valem $hoy';
  }

  @override
  String get pnNoPnl =>
      'Sem preço de compra não tem P&L. Importe seu CSV do ManaBox com a coluna \"Purchase price\" e ele aparece aqui.';

  @override
  String pnOverAll(int n) {
    return 'sobre as $n cópias da sua coleção';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'sobre $conprecio de $total cópias (as outras não têm preço de compra anotado)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '$n cópias compradas não têm preço de hoje no banco: ficam fora da conta';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'você também pagou $importe $moneda, que não é convertido';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n cópias sem moeda no CSV: presumo que seja $moneda';
  }

  @override
  String get pcTitle => 'Evolução do preço';

  @override
  String get pcNoHistory => 'Ainda sem histórico de preço desta carta.';

  @override
  String pcTodayPrice(String precio) {
    return 'Preço de hoje: $precio €. O gráfico aparece assim que houver vários dias.';
  }

  @override
  String get pcExplain =>
      'O ManaForge anota o preço de cada carta que você olha ou tem, dia após dia. Para começar já com os últimos meses reais do Cardmarket, traga o histórico pelo Mercado.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dias',
      one: '1 dia',
    );
    return 'mín $min € · máx $max € · $_temp0';
  }

  @override
  String get spWhichSets => 'De quais expansões?';

  @override
  String get spSearchHint => 'Buscar por nome ou código (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Só as minhas';

  @override
  String spClearN(int n) {
    return 'Tirar as $n';
  }

  @override
  String get spNoneNamed =>
      'Nenhuma expansão com esse nome. Desligue \"Só as minhas\" para ver todas.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n cartas';
  }

  @override
  String get spNoFilter => 'Sem filtro de expansão';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Usar $n expansões',
      one: 'Usar 1 expansão',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'Só procuro cartas do set $set. Toque nele para trocar ou tirar o bloqueio.';
  }

  @override
  String get slLockHint =>
      'Bloqueie um set para escanear uma caixa/precon: o escâner só procura dentro dele e crava a edição.';

  @override
  String slSetIs(String set) {
    return 'Set: $set';
  }

  @override
  String get slSetAll => 'Set: todos';

  @override
  String get slLockTitle => 'Bloquear edição';

  @override
  String get slLockBody =>
      'Escreva o código do set (por ex. AER, MH3, LCI) para escanear uma caixa inteira: só serão procuradas cartas desse set.';

  @override
  String get slSetCode => 'Código do set';

  @override
  String get slClearLock => 'Tirar o bloqueio';

  @override
  String get stHintQuick =>
      'Passe as cartas na frente: as claras se anotam sozinhas aqui (as cópias iguais somam ×N). As duvidosas ficam marcadas para revisar. No fim, você confirma todas.';

  @override
  String get stHintCareful =>
      'Passe as cartas na frente: as claras se anotam sozinhas; as duvidosas perguntam qual é. No fim, você confirma todas.';

  @override
  String stAddN(int n) {
    return 'Adicionar $n à coleção';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return 'Adicionar $n à coleção e a $carpeta';
  }

  @override
  String get stOneLess => 'Uma a menos';

  @override
  String get stAnotherSame => 'Outra igual';

  @override
  String get stOnTable => 'na mesa';

  @override
  String cdLastData(String fecha) {
    return ' (último dado: $fecha)';
  }

  @override
  String get cdLegalities => 'Legalidades';

  @override
  String get slLockButton => 'Bloquear';

  @override
  String get wn030Headline =>
      'Forge por expansões, preço de compra e avisos de versão';

  @override
  String get wn030Forge =>
      'Forge: escolha de quais expansões saem as cartas. E se você ativar \"incluir cartas que não tenho\", ele monta o deck com toda a coleção escolhida e diz quantas cartas faltam e quanto custam.';

  @override
  String get wn030Pnl =>
      'Preço de compra e P&L: se o seu CSV do ManaBox trouxer \"Purchase price\", o Mercado mostra quanto você pagou, quanto vale hoje e a diferença. As moedas nunca se misturam.';

  @override
  String get wn030PhotoFolder =>
      'Escanear por foto agora também deixa escolher a pasta, igual ao escâner ao vivo.';

  @override
  String get wn030Album =>
      'Álbum: o que falta em cada expansão, com quanto custaria.';

  @override
  String get wn030Background =>
      'Papel de parede: ponha atrás a imagem que quiser, com véu regulável, e escolha a cor dos cartões e da letra para que tudo continue legível por cima.';

  @override
  String get wn030Window =>
      'A janela abre onde você deixou, do tamanho que você deixou.';

  @override
  String get wn030Achievements =>
      'As conquistas não se chamam mais como o critério, se chamam como o momento: \"Lá vai todo o meu dinheiro\", \"Cem raras e nenhuma jogável\".';

  @override
  String get wn030Update =>
      'O app avisa quando sai versão nova (ele nunca se atualiza sozinho) e confere a impressão digital SHA-256 dos bancos que baixa.';

  @override
  String get wn030Shortcuts =>
      'Atalhos de teclado: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, e Escape.';

  @override
  String get wn030Linux =>
      'No Linux, um instalador deixa o ManaForge no menu de aplicativos com o ícone dele.';

  @override
  String get wn030License =>
      'Licença PolyForm Noncommercial: compartilhe e mexa nela à vontade, mas ela não se vende.';

  @override
  String bkSumCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartas',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String bkSumDecks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n decks',
      one: '1 deck',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pastas',
      one: '1 pasta',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n conquistas',
      one: '1 conquista',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'cópia vazia';

  @override
  String get bkStoreCollection => 'sua coleção';

  @override
  String get bkStoreFolders => 'suas pastas';

  @override
  String get bkStoreDecks => 'seus decks';

  @override
  String get bkStoreAchievements => 'suas conquistas';

  @override
  String get bkStoreWishlist => 'sua lista de desejos';

  @override
  String get bkStoreCertificates => 'seus certificados';

  @override
  String get bkStoreMarket => 'seu mercado preferido';

  @override
  String get bkStoreRecents => 'as cartas vistas há pouco';

  @override
  String get bkStoreValueHistory => 'o histórico do valor';

  @override
  String get bkStorePriceHistory => 'o histórico de preços';

  @override
  String get bkKindAuto => 'automática';

  @override
  String get bkKindPreRestore => 'antes de restaurar';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig =>
      'Esse arquivo é grande demais para ser uma cópia do ManaForge.';

  @override
  String get bkErrExpandTooBig =>
      'Essa cópia fica grande demais ao ser aberta: não parece uma cópia de verdade do ManaForge.';

  @override
  String get bkErrNotABackup =>
      'Esse arquivo não é uma cópia de segurança do ManaForge.';

  @override
  String get bkErrNewerVersion =>
      'Essa cópia foi feita por uma versão mais nova do ManaForge. Atualize o app e tente de novo.';

  @override
  String get bkErrIncomplete =>
      'Essa cópia está incompleta: não traz os seus dados.';

  @override
  String bkErrDamaged(String almacen) {
    return 'Essa cópia está danificada: $almacen não dá para ler.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'Não consegui escrever na pasta de dados, então não mexi em nada: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'A restauração ficou pela metade ($escritos de $total arquivos). Não tenho cópia anterior do que havia. Detalhe: $error';
  }

  @override
  String bkErrHalfDonePrevious(
      String escritos, String total, String ruta, String error) {
    return 'A restauração ficou pela metade ($escritos de $total arquivos). Para voltar atrás, restaure $ruta. Detalhe: $error';
  }

  @override
  String get siImportTooBig =>
      'Esse arquivo é grande demais para ser uma lista de cartas.';

  @override
  String get siInsecureDownload =>
      'O download acabou em um endereço inseguro e foi cancelado.';

  @override
  String get siRedirectNowhere =>
      'O download redireciona para lugar nenhum e foi cancelado.';

  @override
  String get siTooManyRedirects =>
      'O download dá voltas demais e foi cancelado.';

  @override
  String get siDownloadTooBig =>
      'O download é muito maior do que deveria e foi cancelado.';

  @override
  String get siBadHash =>
      'O que foi baixado não bate com a impressão digital publicada no GitHub. Nada foi instalado. Tente de novo; se continuar acontecendo, avise.';

  @override
  String get siBackgroundNotImage =>
      'Escolha uma imagem (.jpg, .png ou .webp) como fundo.';

  @override
  String get siBackgroundTooBig =>
      'Essa imagem é grande demais para usar de fundo.';

  @override
  String get siScanTooBig => 'Essa foto é grande demais para reconhecer.';

  @override
  String get bgImages => 'Imagens';

  @override
  String bgImageFailed(String error) {
    return 'Não consegui usar essa imagem: $error';
  }

  @override
  String get bgLowContrast =>
      'Pouca diferença para o cartão: a letra vai se ajustar sozinha para continuar legível.';

  @override
  String get bgChipColor => 'Cor das abas';

  @override
  String get bgIconColor => 'Cor dos ícones';

  @override
  String get bgUseThis => 'Usar esta';

  @override
  String get bgSaveSwatch => 'Guardar como muestra';

  @override
  String get bgSwatchTip => 'Muestra guardada';

  @override
  String get bgSwatchDeleteTitle => '¿Borrar esta muestra?';

  @override
  String get bgSwatchDeleteBody =>
      'Se quita de tu paleta guardada. Puedes volver a guardarla cuando quieras.';

  @override
  String get camGstreamerMissing =>
      'O GStreamer não está instalado. Instale com:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'A câmera $dispositivo não dá imagem (gst-launch saiu com $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'A câmera $dispositivo não deu nenhum frame em 6 s.';
  }

  @override
  String get camNoCameras =>
      'Não encontro nenhuma câmera (/dev/video*). Ela está conectada? Confira com `lsusb` se o sistema enxerga ela.';

  @override
  String camNoneWorked(String detalle) {
    return 'Nenhuma câmera deu imagem:\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Restaurar';

  @override
  String get fpUnselect => 'Desmarcar';

  @override
  String get stClear => 'Esvaziar';

  @override
  String get tlRemove => 'Tirar';

  @override
  String get tlUnrecognized => 'Sem reconhecer';

  @override
  String get tlNothingAlike =>
      'nada parecido no banco — refaça a foto ou tire ela';

  @override
  String get tlTapToPick => 'toque para escolher na mão entre as parecidas';

  @override
  String get tlReview => 'rever';

  @override
  String get lsQuantity => 'Quantidade';

  @override
  String get scPhotos => 'Fotos';

  @override
  String get ftWhichFolder => 'Em qual pasta você quer elas?';

  @override
  String get ftWhichFolderSub =>
      'Elas entram na sua coleção de qualquer jeito; a pasta é só uma etiqueta para achar elas depois.';

  @override
  String get ftNone => 'Nenhuma';

  @override
  String ftCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartas',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String get ftNewFolderEllipsis => 'Pasta nova…';

  @override
  String get ftNewFolder => 'Pasta nova';

  @override
  String get ftNewFolderHint => 'Caixa da loja, Para vender…';

  @override
  String get sgTitle => 'O olho do escâner';

  @override
  String get sgWhy =>
      'Para reconhecer cartas sem internet eu preciso do banco de impressões digitais visuais (~12 MB): a assinatura da arte de cada ilustração de Magic. Ele baixa uma vez só.';

  @override
  String get sgDownload => 'Baixar o banco de impressões digitais';

  @override
  String get cmFullCard => 'Ver a ficha completa (preços e legalidade)';

  @override
  String get cmSwipeHint =>
      'arraste ou use ← → para passar · toque fora para fechar';

  @override
  String get cmTapOutHint => 'toque fora para fechar';

  @override
  String get fcTitle => 'Com que carta você começou?';

  @override
  String get fcRemove => 'Tirar';

  @override
  String get fcSearchHint => 'Buscar na sua coleção';

  @override
  String get fcNoMatch => 'Não encontro nenhuma carta com isso.';

  @override
  String get acNoneWithFilters => 'Nada por aqui com esses filtros.';

  @override
  String get acAll => 'Todas';

  @override
  String get tsTitle => 'Modo Teste — vença o meta';

  @override
  String get tsIntro =>
      'Escolha contra qual deck do meta você quer jogar. O ManaForge monta decks com as SUAS cartas, simula centenas de partidas contra ele e fica com o que mais ganha — testando ainda trocas de carta uma a uma para afinar.';

  @override
  String get tsLoadingMeta => 'Carregando o meta…';

  @override
  String get tsLocalPresets => 'Presets locais (sem conexão)';

  @override
  String get tsNoDeckToFace =>
      'Com as cartas de agora não sai nenhum deck completo para enfrentar. Adicione mais cartas e tente de novo.';

  @override
  String tsSimFailed(String error) {
    return 'Não consegui simular: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota do meta';
  }

  @override
  String get tsSimulating =>
      'Simulando partidas… (alguns segundos; tudo na sua máquina)';

  @override
  String tsFindBest(String meta) {
    return 'Buscar meu melhor deck contra $meta';
  }

  @override
  String get tsHonesty =>
      'Sendo honesto: a simulação entende cores de mana, mulligans, evasão (voar, atropelar, toque mortífero…), remoção instantânea e contramágicas — mas não o texto completo de cada carta. A porcentagem serve para COMPARAR seus decks entre si, não como previsão exata.';

  @override
  String tsChampion(String meta) {
    return 'Seu campeão contra $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'de vitórias estimadas · $mazos decks testados · $partidas partidas por deck';
  }

  @override
  String get tsNoDominant =>
      'Nenhum deck da sua coleção domina esse confronto — este é o que briga melhor. Veja os pontos fracos dele no detalhe.';

  @override
  String get tsSeeDeck => 'Ver o deck completo (e salvar)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total conquistas · $xp XP para o nível $nivel';
  }

  @override
  String get hsForgeDecks => 'Forjar decks';

  @override
  String get hsTestYourself => '⚔ se ponha à prova';

  @override
  String get bgCustom => 'Sob medida';

  @override
  String get bgPickCustom => 'Escolher uma cor sob medida';

  @override
  String get bgCustomColor => 'Cor sob medida';

  @override
  String get bgSampleTab => 'Vermelho';

  @override
  String get cfSortRecent => 'Recém-adicionadas';

  @override
  String get cfSortAlpha => 'Nome A-Z';

  @override
  String get cfSortCmc => 'Custo';

  @override
  String get cfSortQty => 'Quantidade';

  @override
  String get cfSortBy => 'Ordenar por';

  @override
  String get cfSort => 'Ordem';

  @override
  String get cfClear => 'Limpar';

  @override
  String get cfCost => 'Custo';

  @override
  String get cfCostAll => 'Custo: todos';

  @override
  String cfCostN(String n) {
    return 'Custo $n';
  }

  @override
  String get cfType => 'Tipo';

  @override
  String get cfTypeAll => 'Tipo: todos';

  @override
  String get cfTypeCreature => 'Criaturas';

  @override
  String get cfTypeInstant => 'Mágicas Instantâneas';

  @override
  String get cfTypeSorcery => 'Feitiços';

  @override
  String get cfTypeArtifact => 'Artefatos';

  @override
  String get cfTypeEnchantment => 'Encantamentos';

  @override
  String get cfTypeLand => 'Terrenos';

  @override
  String get cfPower => 'Poder';

  @override
  String get cfPowerAll => 'Poder: todos';

  @override
  String cfPowerMin(int n) {
    return 'Poder ≥ $n';
  }

  @override
  String get cfToughness => 'Resistência';

  @override
  String get cfToughnessAll => 'Resistência: todas';

  @override
  String cfToughnessMin(int n) {
    return 'Resistência ≥ $n';
  }

  @override
  String get cfNoDate => 'sem data';

  @override
  String get cfToday => 'hoje';

  @override
  String get cfYesterday => 'ontem';

  @override
  String cfDaysAgo(int n) {
    return '$n dias atrás';
  }

  @override
  String get pcWeek => 'Semana';

  @override
  String get pcMonth => 'Mês';

  @override
  String get pcAll => 'Tudo';

  @override
  String get vpTapCorrect => 'Toque na carta certa';

  @override
  String get achCopias1 => 'A primeira de muitas';

  @override
  String get achCopias10 => 'Eu ia comprar só uma';

  @override
  String get achCopias50 => 'Já não cabem na mão';

  @override
  String get achCopias100 => 'Cem e subindo';

  @override
  String get achCopias500 => 'A caixa ficou pequena';

  @override
  String get achCopias1000 => 'Mil. E eu quero todas';

  @override
  String get achCopias5000 => 'Isso já virou depósito';

  @override
  String get achCopias10000 => 'Dez mil, mas eu paro quando quiser';

  @override
  String achCopiasDesc(String n) {
    return 'Tenha $n cartas na sua coleção.';
  }

  @override
  String get achDistintas25 => 'Aqui tem variedade';

  @override
  String get achDistintas100 => 'Cem rostos diferentes';

  @override
  String get achDistintas500 => 'Meia biblioteca';

  @override
  String get achDistintas1000 => 'Enciclopédia ambulante';

  @override
  String get achDistintas2500 => 'Já não sei todas de cor';

  @override
  String get achDistintas5000 => 'O arquivo';

  @override
  String achDistintasDesc(String n) {
    return 'Tenha $n cartas DIFERENTES (repetidas não contam).';
  }

  @override
  String get achPlaysets1 => 'Quatro iguais';

  @override
  String get achPlaysets20 => 'Vinte playsets, zero decks';

  @override
  String get achPlaysets1Desc => 'Tenha 4 cópias de uma mesma carta.';

  @override
  String get achPlaysets20Desc =>
      'Tenha 20 playsets diferentes (4 cópias de cada um).';

  @override
  String get achComunes10 => 'As que ninguém quer';

  @override
  String get achComunes50 => 'O monte de sempre';

  @override
  String get achComunes200 => 'Rei do monte';

  @override
  String get achComunes500 => 'Maré de comuns';

  @override
  String achComunesDesc(String n) {
    return 'Tenha $n cartas comuns diferentes.';
  }

  @override
  String get achInfrecuentes10 => 'Um degrau acima da comum';

  @override
  String get achInfrecuentes50 => 'Prata fina';

  @override
  String get achInfrecuentes200 => 'Caçador de incomuns';

  @override
  String get achInfrecuentes500 => 'Prata aos montes';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Tenha $n cartas incomuns diferentes.';
  }

  @override
  String get achRaras5 => 'Boa, veio rara no booster';

  @override
  String get achRaras25 => 'Um cofre de raras';

  @override
  String get achRaras100 => 'Cem raras e nenhuma jogável';

  @override
  String get achRaras300 => 'Câmara-forte';

  @override
  String achRarasDesc(String n) {
    return 'Tenha $n cartas raras diferentes.';
  }

  @override
  String get achMiticas1 => 'Minha primeira mítica';

  @override
  String get achMiticas10 => 'Dez míticas';

  @override
  String get achMiticas50 => 'Colecionador mítico';

  @override
  String get achMiticas150 => 'Panteão mítico';

  @override
  String achMiticasDesc(String n) {
    return 'Tenha $n cartas raras míticas diferentes.';
  }

  @override
  String get achBlancas25 => 'Ordem e disciplina';

  @override
  String get achBlancas100 => 'Exército de prata';

  @override
  String achBlancasDesc(String n) {
    return 'Tenha $n cartas brancas diferentes.';
  }

  @override
  String get achAzules25 => 'Isso eu não deixo';

  @override
  String get achAzules100 => 'Torre de marfim';

  @override
  String achAzulesDesc(String n) {
    return 'Tenha $n cartas azuis diferentes.';
  }

  @override
  String get achNegras25 => 'Pacto sombrio';

  @override
  String get achNegras100 => 'Senhor da cripta';

  @override
  String achNegrasDesc(String n) {
    return 'Tenha $n cartas pretas diferentes.';
  }

  @override
  String get achRojas25 => 'Vamos queimar tudo';

  @override
  String get achRojas100 => 'Incêndio geral';

  @override
  String achRojasDesc(String n) {
    return 'Tenha $n cartas vermelhas diferentes.';
  }

  @override
  String get achVerdes25 => 'Um broto';

  @override
  String get achVerdes100 => 'A floresta inteira';

  @override
  String achVerdesDesc(String n) {
    return 'Tenha $n cartas verdes diferentes.';
  }

  @override
  String get achIncoloras25 => 'Metal frio';

  @override
  String get achIncoloras100 => 'Forja eterna';

  @override
  String achIncolorasDesc(String n) {
    return 'Tenha $n cartas incolores diferentes.';
  }

  @override
  String get achArcoiris => 'As cinco cores';

  @override
  String get achArcoirisDesc =>
      'Tenha pelo menos uma carta de cada uma das 5 cores.';

  @override
  String get achMulticolor10 => 'Misturando as cores';

  @override
  String get achMulticolor50 => 'Aliança dourada';

  @override
  String achMulticolorDesc(String n) {
    return 'Tenha $n cartas multicoloridas diferentes.';
  }

  @override
  String get achCincocolores => 'As cinco de uma vez';

  @override
  String get achCincocoloresDesc => 'Tenha uma carta com as cinco cores.';

  @override
  String get achSets1 => 'Primeira expansão';

  @override
  String get achSets5 => 'Cinco mundos';

  @override
  String get achSets10 => 'Planeswalker em treinamento';

  @override
  String get achSets25 => 'Roda-mundo';

  @override
  String get achSets50 => 'Meio multiverso';

  @override
  String achSetsDesc(String n) {
    return 'Tenha cartas de $n expansões diferentes.';
  }

  @override
  String get achSetscompletos1 => 'Não falta nenhuma';

  @override
  String get achSetscompletos3 => 'Três álbuns inteiros';

  @override
  String get achSetscompletos10 => 'Mestre do álbum';

  @override
  String get achSetscompletos1Desc => 'Complete uma expansão inteira no Álbum.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Complete $n expansões inteiras.';
  }

  @override
  String get achAnyos5 => 'Cinco anos de papelão';

  @override
  String get achAnyos15 => 'Máquina do tempo';

  @override
  String achAnyosDesc(String n) {
    return 'Tenha cartas de $n anos de lançamento diferentes.';
  }

  @override
  String get achValor10 => 'Primeiros euros';

  @override
  String get achValor50 => 'O cofrinho';

  @override
  String get achValor250 => 'Lá se foi a mesada';

  @override
  String get achValor1000 => 'Lá vai todo o meu dinheiro';

  @override
  String get achValor5000 => 'Não conta pra ninguém';

  @override
  String get achValor10000 => 'Vale mais que o meu carro';

  @override
  String get achValor25000 => 'Coleção de museu';

  @override
  String achValorDesc(String n) {
    return 'Faça a sua coleção valer $n € ou mais.';
  }

  @override
  String get achJoya20 => 'Uma carta das boas';

  @override
  String get achJoya100 => 'A joia da coleção';

  @override
  String get achJoya500 => 'Essa não sai do sleeve';

  @override
  String get achJoya1000 => 'Mil euros em um sleeve só';

  @override
  String get achJoya2500 => 'O santo graal';

  @override
  String achJoyaDesc(String n) {
    return 'Tenha uma única carta que valha $n € ou mais.';
  }

  @override
  String get achFoils1 => 'Primeiro brilho';

  @override
  String get achFoils10 => 'Reluzindo';

  @override
  String get achFoils50 => 'A caixa brilha';

  @override
  String get achFoils200 => 'Aqui não sobrou nada fosco';

  @override
  String get achFoils500 => 'Tudo brilha';

  @override
  String get achFoils1000 => 'Fábrica de brilho';

  @override
  String achFoilsDesc(String n) {
    return 'Tenha $n cartas foil.';
  }

  @override
  String get achFoiljoya10 => 'Uma foil das boas';

  @override
  String get achFoiljoya50 => 'Uma foil das caras';

  @override
  String get achFoiljoya200 => 'Uma foil de museu';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Tenha uma foil que valha $n € ou mais.';
  }

  @override
  String get achFoilvalor50 => 'Vitrine que brilha';

  @override
  String get achFoilvalor250 => 'Vitrine cara';

  @override
  String get achFoilvalor1000 => 'Mil euros de brilho';

  @override
  String get achFoilvalor5000 => 'Vitrine de museu';

  @override
  String achFoilvalorDesc(String n) {
    return 'Faça todas as suas foils juntas valerem $n € ou mais.';
  }

  @override
  String get achMazos1 => 'Primeiro deck';

  @override
  String get achMazos5 => 'Cinco decks salvos';

  @override
  String get achMazos25 => 'A oficina não para';

  @override
  String achMazosDesc(String n) {
    return 'Salve $n decks feitos com o Forge.';
  }

  @override
  String get achMazoscore => 'Deck redondinho';

  @override
  String get achMazoscoreDesc => 'Gere um deck com pontuação 90 ou mais.';

  @override
  String get achMazocolores3 => 'Tricolor';

  @override
  String get achMazocolores5 => 'Arco-íris jogável';

  @override
  String achMazocoloresDesc(String n) {
    return 'Salve um deck de $n cores.';
  }

  @override
  String get achMazomono => 'Sem misturar nada';

  @override
  String get achMazomonoDesc => 'Salve um deck de uma cor só.';

  @override
  String get achMazocommander => 'No comando';

  @override
  String get achMazocommanderDesc => 'Salve um deck de Commander.';

  @override
  String get achEscaneadas1 => 'Primeiro escaneamento';

  @override
  String get achEscaneadas50 => 'Mão rápida';

  @override
  String get achEscaneadas500 => 'Escaneando em série';

  @override
  String get achEscaneadas2000 => 'Escaneio até dormindo';

  @override
  String achEscaneadasDesc(String n) {
    return 'Escaneie $n cartas com a câmera ou por foto.';
  }

  @override
  String get achFoto9 => 'Uma página inteira numa foto só';

  @override
  String get achFoto20 => 'Vinte de uma tacada';

  @override
  String achFotoDesc(String n) {
    return 'Reconheça $n cartas em uma única foto.';
  }

  @override
  String get achEscaneoperfecto => 'Nenhuma para revisar';

  @override
  String get achEscaneoperfectoDesc =>
      'Escaneie uma página inteira sem deixar nenhuma carta para revisar.';

  @override
  String get achDias2 => 'Você voltou';

  @override
  String get achDias7 => 'Uma semana por aqui';

  @override
  String get achDias30 => 'Um mês por aqui';

  @override
  String get achDias100 => 'Cem dias por aqui';

  @override
  String achDiasDesc(String n) {
    return 'Use o ManaForge em $n dias diferentes.';
  }

  @override
  String get achRacha3 => 'Três seguidos';

  @override
  String get achRacha7 => 'Semana perfeita';

  @override
  String get achRacha30 => 'Um mês sem falhar';

  @override
  String achRachaDesc(String n) {
    return 'Entre $n dias seguidos.';
  }

  @override
  String get achSemanas => 'Quatro semanas sem faltar';

  @override
  String get achSemanasDesc => 'Use o ManaForge 4 semanas seguidas.';

  @override
  String get achCarpetas1 => 'Começou a organização';

  @override
  String get achCarpetas5 => 'Tudo classificado';

  @override
  String achCarpetasDesc(String n) {
    return 'Crie $n pastas.';
  }

  @override
  String get achCarpetagrande => 'Pastona';

  @override
  String get achCarpetagrandeDesc => 'Tenha uma pasta com 100 cartas ou mais.';

  @override
  String get achCarpetavalor => 'Essa pasta eu não empresto';

  @override
  String get achCarpetavalorDesc => 'Tenha uma pasta que valha 100 € ou mais.';

  @override
  String get achTierrasbasicas => 'Os cinco básicos';

  @override
  String get achTierrasbasicasDesc =>
      'Tenha os cinco tipos de terreno básico (Planície, Ilha, Pântano, Montanha e Floresta).';

  @override
  String get achFuerza => 'Que bicho grande';

  @override
  String get achFuerzaDesc => 'Tenha uma criatura com poder 10 ou mais.';

  @override
  String get achCoste => 'Essa eu nunca vou conjurar';

  @override
  String get achCosteDesc =>
      'Tenha uma carta com custo de mana convertido 10 ou mais.';

  @override
  String get achCostecero => 'De graça';

  @override
  String get achCosteceroDesc => 'Tenha uma carta de custo 0.';

  @override
  String get achTipos => 'Um pouco de tudo';

  @override
  String get achTiposDesc =>
      'Tenha pelo menos uma criatura, uma mágica instantânea, um feitiço, um artefato, um encantamento, um terreno e um planeswalker.';

  @override
  String get achPlaneswalkers => 'Companhia de planeswalkers';

  @override
  String get achPlaneswalkersDesc => 'Tenha 5 planeswalkers diferentes.';

  @override
  String get achNoventas => 'Relíquia dos anos 90';

  @override
  String get achNoventasDesc => 'Tenha uma carta dos anos 90.';

  @override
  String get achIdiomas1 => 'Essa eu não sei ler';

  @override
  String get achIdiomas25 => 'Coleção poliglota';

  @override
  String get achIdiomas1Desc =>
      'Tenha uma carta em um idioma que não seja o inglês.';

  @override
  String get achIdiomas25Desc => 'Tenha 25 cartas em outros idiomas.';

  @override
  String get achWishlist => 'A lista dos caprichos';

  @override
  String get achWishlistDesc => 'Anote 20 cartas na wishlist.';

  @override
  String get achTierBronze => 'Bronze';

  @override
  String get achTierSilver => 'Prata';

  @override
  String get achTierGold => 'Ouro';

  @override
  String get achTierMythic => 'Mítico';

  @override
  String get achCatCollection => 'Coleção';

  @override
  String get achCatRarity => 'Raridades';

  @override
  String get achCatColor => 'Cores';

  @override
  String get achCatSets => 'Expansões';

  @override
  String get achCatValue => 'Valor';

  @override
  String get achCatFoils => 'Foils';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Escâner';

  @override
  String get achCatDedication => 'Dedicação';

  @override
  String get achCatFolders => 'Pastas';

  @override
  String get achCatCuriosities => 'Curiosidades';

  @override
  String get achRankApprentice => 'Aprendiz';

  @override
  String get achRankSummoner => 'Invocador';

  @override
  String get achRankMage => 'Mago';

  @override
  String get achRankArchmage => 'Arquimago';

  @override
  String get achRankMaster => 'Mestre';

  @override
  String get achRankPlaneswalker => 'Planeswalker';

  @override
  String get bkConfirmWord => 'CONFIRMAR';

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
    return 'Não foi possível baixar o banco de cartas (HTTP $codigo). Tente de novo daqui a pouco.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'Não foi possível baixar o banco de impressões digitais (HTTP $codigo). Tente de novo daqui a pouco.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'Não foi possível baixar o histórico de preços (HTTP $codigo). Tente de novo daqui a pouco.';
  }

  @override
  String ddCardCount(int n) {
    return '$n cartas';
  }

  @override
  String get ddForgedWith => 'Forjado com ManaForge';

  @override
  String get fxThemeLifegain => 'dreno de vida';

  @override
  String get fxThemeSacrifice => 'sacrifício';

  @override
  String get fxThemeSpells => 'mágicas';

  @override
  String get fxThemeArtifacts => 'artefatos';

  @override
  String get fxThemeCounters => 'marcadores +1/+1';

  @override
  String get fxThemeTokens => 'enxame';

  @override
  String get fxThemeGraveyard => 'cemitério';

  @override
  String get fxThemeGoodstuff => 'o melhor das suas cartas';

  @override
  String get fxTagLifegain =>
      'Cada ponto de vida que você ganha é dano pra eles: drene e aguente.';

  @override
  String get fxTagSacrifice =>
      'Suas criaturas valem mais mortas: sacrifique e cobre o pedágio.';

  @override
  String get fxTagSpells =>
      'Cada mágica instantânea conta: jogue no turno do adversário e castigue.';

  @override
  String get fxTagArtifacts =>
      'Monte a sua oficina: cada artefato deixa os outros mais fortes.';

  @override
  String get fxTagCounters =>
      'Marcadores +1/+1: suas criaturas crescem até ninguém alcançar.';

  @override
  String get fxTagTokens =>
      'Inunde a mesa de fichas: onde eles têm uma, você tem cinco.';

  @override
  String get fxTagGraveyard =>
      'Seu cemitério é a sua segunda mão: encha ele e recicle o melhor.';

  @override
  String get fxTagAggro =>
      'Saia rápido e bata na cara: essa partida tem que acabar cedo.';

  @override
  String get fxTagTempo =>
      'Pressione cedo e proteja a vantagem com as suas mágicas.';

  @override
  String fxTagMidrange(String tema) {
    return 'Troque bem as suas cartas e ganhe o meio de jogo com $tema.';
  }

  @override
  String get fxTagControl =>
      'Aguente, responda a tudo e finalize quando a mesa for sua.';

  @override
  String get fxMidLifegain =>
      'Encadeie suas fontes de vida com as cartas que castigam o adversário por isso.';

  @override
  String get fxMidSacrifice =>
      'Sacrifique o que é barato para comprar, drenar ou fazer o resto crescer.';

  @override
  String get fxMidSpells =>
      'Deixe mana aberto: suas criaturas crescem a cada mágica que você conjura.';

  @override
  String get fxMidArtifacts =>
      'Baixe artefatos baratos e ligue os que contam artefatos.';

  @override
  String get fxMidCounters =>
      'Empilhe marcadores em uma ou duas criaturas e proteja elas.';

  @override
  String get fxMidTokens =>
      'Gere fichas todo turno e procure os efeitos que deixam elas maiores.';

  @override
  String get fxMidGraveyard =>
      'Moa e descarte de propósito: o que cai no cemitério volta.';

  @override
  String get fxEndLifegain =>
      'Com a vida alta, vire para o modo agressivo: eles não chegam mais lá.';

  @override
  String get fxEndSacrifice =>
      'O valor acumulado te dá a partida: cada troca sai de graça pra você.';

  @override
  String get fxEndSpells =>
      'Duas mágicas no mesmo turno e suas criaturas fecham o jogo.';

  @override
  String get fxEndArtifacts =>
      'Sua mesa vale o dobro da deles: finalize com os seus payoffs.';

  @override
  String get fxEndCounters =>
      'Uma ameaça enorme e protegida acaba a partida em dois ataques.';

  @override
  String get fxEndTokens =>
      'Ataque em massa: nenhum bloqueio segura o seu exército inteiro.';

  @override
  String get fxEndGraveyard =>
      'Reutilize suas melhores cartas: você joga com duas mãos contra uma.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => 'Jogue uma criatura por turno, sem exceção.';

  @override
  String get fxAggroMid =>
      'Continue atacando; guarde o dano direto para tirar bloqueadores.';

  @override
  String get fxAggroLate => 'Vá com tudo: é aqui que você fecha a partida.';

  @override
  String get fxTempoEarly => 'Ameaça barata e mana aberto sempre que der.';

  @override
  String get fxTempoMid => 'Ataque e use suas mágicas no turno do adversário.';

  @override
  String get fxTempoLate =>
      'Proteja suas criaturas e feche pelo ar ou no dano direto.';

  @override
  String get fxMidrangeEarly =>
      'Desenvolva e não dê cartas de graça: trocas de um por um bem feitas.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Baixe seus motores de $tema e estabilize a mesa.';
  }

  @override
  String get fxMidrangeLate =>
      'Suas cartas valem mais que as deles: transforme isso na partida.';

  @override
  String get fxControlEarly =>
      'Um terreno por turno e responda só ao que importa.';

  @override
  String get fxControlMid =>
      'Limpe a mesa e compre cartas: o tempo joga a seu favor.';

  @override
  String get fxControlLate => 'Baixe uma ameaça e proteja ela até o fim.';

  @override
  String get fxArchetypeAggro => 'aggro';

  @override
  String get fxArchetypeTempo => 'tempo';

  @override
  String get fxArchetypeMidrange => 'midrange';

  @override
  String get fxArchetypeControl => 'control';

  @override
  String fxWhyItWorks(String coste, String tierras, String arquetipo,
      int criaturas, int interaccion, String tema) {
    return 'Custo médio $coste: pela regra de Karsten (24 terrenos com custo 3.0, ±1 a cada ±0.5), este deck leva $tierras terrenos — dentro da faixa de um deck $arquetipo. Tem $criaturas criaturas para segurar a mesa e $interaccion cartas de interação para o que o adversário trouxer. O tema ($tema) concentra as suas sinergias: quanto mais peças do tema você vir, mais forte fica cada uma.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'Com essa curva saem $tierras terrenos: fora da faixa saudável ($min-$max). Ajuste o total de mágicas.';
  }

  @override
  String get fxNoCards =>
      'Sua coleção não tem cartas suficientes dessas cores para preencher essa curva. Tente com menos mágicas ou com outros custos.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'Essa curva (custo médio $coste com $tierras terrenos) não encaixa em nenhum perfil saudável: um deck barato quer menos terrenos e um caro quer mais. Aproxime os dois.';
  }

  @override
  String get fxNoBasics =>
      'Não há terrenos básicos suficientes na coleção para essa curva.';

  @override
  String fxHardRule(String detalle) {
    return 'A curva pedida quebra uma regra dura: $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Criaturas baratas e dano na cara: te mata em 4-5 turnos se você não segurar o ritmo.';

  @override
  String get tsPresetAzorius =>
      'Contramágicas, varreduras e compra de cartas: alonga a partida e ganha com poucos finalizadores.';

  @override
  String get tsPresetGolgari =>
      'Trocas de um por um, criaturas eficientes e removal preto: ganha o jogo longo na qualidade das cartas.';
}
