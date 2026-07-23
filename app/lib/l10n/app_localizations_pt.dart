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
  String get colStartHere => 'Tu colección empieza aquí';

  @override
  String get colNeedDb =>
      'Primero necesito la base de datos con todas las cartas de Magic (se descarga una vez y luego todo funciona sin internet).';

  @override
  String colDownloading(String pct) {
    return 'Descargando… $pct %';
  }

  @override
  String get colDownloadDb => 'Descargar base de datos de cartas';

  @override
  String get colScryfall =>
      'Datos e imágenes por Scryfall · Sin cuentas, sin pagos: todo queda en tu dispositivo.';

  @override
  String get colAlbumTooltip => 'Álbum por expansiones';

  @override
  String get colImportTooltip => 'Importar CSV de ManaBox';

  @override
  String colValueLine(int copies, int distinct, String valor) {
    return '$copies cartas · $distinct distintas$valor';
  }

  @override
  String get colAllCards => 'Todas las cartas';

  @override
  String colAllCardsSub(int distinct) {
    return '$distinct distintas · buscar, filtrar y ordenar';
  }

  @override
  String get colFolders => 'Carpetas';

  @override
  String get colNewFolder => 'Nueva';

  @override
  String get colNoFolders =>
      'Aún no tienes carpetas. Sirven para agrupar lo que quieras: \"rares de Aetherdrift\", \"para vender\", \"la caja de arriba\"… Una carta puede estar en varias.';

  @override
  String get colCreateFirstFolder => 'Crear la primera carpeta';

  @override
  String get colEmptyTitle => 'Aquí empieza tu colección';

  @override
  String get colEmptyBody =>
      'Escanea tus cartas con la cámara o importa un CSV de ManaBox. Aparecerán aquí y en el álbum.';

  @override
  String get colImportShort => 'Importar CSV';

  @override
  String acForgetTitle(String carta) {
    return '¿Ya no tienes $carta?';
  }

  @override
  String get acForgetBody =>
      'Sale de tu colección y su hueco del álbum vuelve a estar vacío.';

  @override
  String acForgetFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'También sale de las $n carpetas en las que está.',
      one: 'También sale de la carpeta en la que está.',
    );
    return '$_temp0';
  }

  @override
  String get acForgetDecks =>
      'Los mazos NO la pierden: se queda en la lista y el mazo te avisa de que te falta.';

  @override
  String get acCancel => 'Cancelar';

  @override
  String get acForgetConfirm => 'Ya no la tengo';

  @override
  String acAddedOn(String cuando) {
    return 'añadida $cuando';
  }

  @override
  String acInFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'en $n carpetas',
      one: 'en 1 carpeta',
    );
    return '$_temp0';
  }

  @override
  String get acSearchHint => 'Busca una carta (español o inglés)…';

  @override
  String acFilteredCount(int visibles, int total) {
    return '$visibles de $total cartas';
  }

  @override
  String get acMissingFilterData =>
      ' · algunas cartas antiguas no tienen datos de filtro: reimporta tu CSV con \"Sustituir\" activado';

  @override
  String get acNoneMatch => 'Ninguna carta pasa estos filtros.';

  @override
  String get acEmptyHint =>
      'Busca tu primera carta arriba, o vuelve atrás e importa tu CSV de ManaBox.';

  @override
  String get onbHowItWorksBody =>
      'El resumen de qué hace cada pestaña y los atajos de teclado. Si te pierdes, empieza por aquí.';

  @override
  String get onbVersionBody =>
      'Qué versión tienes, qué trae, y si quieres que la app mire una vez al día si hay una nueva. No se actualiza sola.';

  @override
  String get onbScanSetTitle => 'Set: todas';

  @override
  String get onbScanSetBody =>
      'Si estás abriendo sobres de UNA expansión, fíjala aquí: el escáner deja de dudar entre las diez reimpresiones de la misma carta.';

  @override
  String get onbScanModeTitle => 'Rápido o con cuidado';

  @override
  String get onbScanModeBody =>
      'En «Rápido» las cartas claras entran solas y las dudosas quedan marcadas para revisar. En «Con cuidado» se para y te pregunta cuál es.';

  @override
  String get onbScanPhotoTitle => 'Escanear una foto';

  @override
  String get onbScanPhotoBody =>
      '¿Sin cámara, o con las cartas ya fotografiadas? Aquí sueltas una foto —con varias cartas si quieres— y las saca igual.';

  @override
  String get tourScanName => 'El escáner';

  @override
  String get albNeedDb =>
      'El álbum necesita la base de datos de cartas (descárgala en Colección).';

  @override
  String get albRetry => 'Reintentar';

  @override
  String get albApproxMode =>
      'Álbum en modo aproximado: aún no sé qué EDICIÓN exacta tienes de cada carta. Reimporta tu CSV con \"Sustituir mi colección actual\" activado y el álbum se afinará por ilustraciones.';

  @override
  String get albSearchSet => 'Busca una expansión…';

  @override
  String get albOnlyMine => 'Con cartas mías';

  @override
  String get albSortProgress => 'Más completadas';

  @override
  String get albSortNewest => 'Más nuevas';

  @override
  String get albSortOldest => 'Más antiguas';

  @override
  String get albSortName => 'Por nombre';

  @override
  String get albYearAll => 'Año: todos';

  @override
  String get albLetterAll => 'Todas';

  @override
  String get albNoSets => 'Ninguna expansión coincide con el filtro.';

  @override
  String albSetProgress(int owned, int total) {
    return '$owned/$total cartas';
  }

  @override
  String get albComplete => ' · ✓ ¡completa!';

  @override
  String albLoadError(String error) {
    return 'No pude cargar el set: $error';
  }

  @override
  String albSearchIn(String set) {
    return 'Buscar en $set…';
  }

  @override
  String get albOnlyMissing => 'Solo las que faltan';

  @override
  String get albWithVariants => 'Con variantes';

  @override
  String get albYouHaveItAll => '✓ Lo tienes entero';

  @override
  String albMissingCount(int n) {
    return 'Te faltan $n · ';
  }

  @override
  String albWithoutPrice(int n) {
    return ' ($n sin precio)';
  }

  @override
  String albVisibleOf(int visibles, int total) {
    return '$visibles de $total';
  }

  @override
  String get albNoCardsNamed => 'Ninguna carta con ese nombre aquí.';

  @override
  String get fdNewFolder => 'Nueva carpeta';

  @override
  String get fdEditFolder => 'Editar carpeta';

  @override
  String get fdName => 'Nombre';

  @override
  String get fdNameHint => 'Rares de Aetherdrift, Para vender…';

  @override
  String get fdColor => 'Color';

  @override
  String get fdIcon => 'Icono';

  @override
  String get fdCreate => 'Crear';

  @override
  String get fdSave => 'Guardar';

  @override
  String get fdDefaultName => 'Carpeta';

  @override
  String fdDeleteTitle(String nombre) {
    return '¿Borrar \"$nombre\"?';
  }

  @override
  String get fdDeleteBody =>
      'Se borra solo la carpeta: las cartas siguen en tu colección.';

  @override
  String get fdDelete => 'Borrar';

  @override
  String get fdGone => 'Esta carpeta ya no existe.';

  @override
  String get fdEditTooltip => 'Editar nombre, color e icono';

  @override
  String get fdDeleteTooltip => 'Borrar carpeta';

  @override
  String get fdAddRemove => 'Añadir o quitar';

  @override
  String fdCounts(int distintas, int copias) {
    return '$distintas cartas distintas · $copias copias';
  }

  @override
  String fdPassFilter(int n) {
    return ' · $n pasan el filtro';
  }

  @override
  String get fdRoughValue => ' · valor orientativo';

  @override
  String fdMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n cartas ya no están en tu colección (siguen apuntadas por si vuelven).',
      one: '1 carta ya no está en tu colección (sigue apuntada por si vuelve).',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveThem => 'Quitarlas';

  @override
  String get fdNoneMatch => 'Ninguna carta de la carpeta pasa estos filtros.';

  @override
  String get fdEmpty =>
      'Carpeta vacía. Dale a \"Añadir o quitar\" y marca las cartas que quieres meter.';

  @override
  String fdCopies(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n copias',
      one: '1 copia',
    );
    return '$_temp0';
  }

  @override
  String get fdRemoveFromFolder => 'Quitar de la carpeta';

  @override
  String get fpPickCards => 'Elige las cartas';

  @override
  String fpSaveCount(int n) {
    return 'Guardar ($n)';
  }

  @override
  String get fpFilterByName => 'Filtra por nombre…';

  @override
  String fpVisibleCards(int n) {
    return '$n cartas a la vista';
  }

  @override
  String get fpSelectAll => 'Marcar todas';

  @override
  String get fpNoneMatch => 'Ninguna carta pasa estos filtros.';
}
