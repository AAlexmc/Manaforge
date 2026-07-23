// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabCollection => 'Colección';

  @override
  String get tabAlbum => 'Álbum';

  @override
  String get tabDecks => 'Mazos';

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
      'ManaForge es gratis y con el código a la vista (licencia PolyForm Noncommercial: compártela y tócala lo que quieras, pero no se vende). Sin anuncios, sin premium, sin cuentas. Tus cartas son tuyas.';

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get howScan =>
      'Pasa cartas por delante de la webcam o suelta una foto: entran solas a tu colección con su edición exacta.';

  @override
  String get howCollection =>
      'Todo lo que tienes, con buscador, filtros y carpetas (las carpetas son etiquetas: una carta puede estar en varias).';

  @override
  String get howAlbum =>
      'Una página por expansión, estilo álbum de cromos: lo que tienes a color, lo que falta apagado, con lo que costaría completarlo.';

  @override
  String get howForge =>
      'Mazos completos y legales con tus cartas. O con las de una expansión que aún no tienes, diciéndote qué comprar y cuánto cuesta.';

  @override
  String get howDecks =>
      'Los que guardes. Si vendes una carta, el mazo lo dice en vez de fingir que la tienes.';

  @override
  String get howMarket =>
      'Cuánto vale tu colección, su gráfica, tu lista de deseos con avisos de precio, y — si tu CSV traía precio de compra — cuánto ganas o pierdes.';

  @override
  String get howPrivacy =>
      'Todo se calcula en tu dispositivo. Lo único que sale a internet son las bases de datos y, si lo dejas puesto, mirar si hay versión nueva.';

  @override
  String get shortcuts => 'Atajos de teclado';

  @override
  String get shortcutTabs => 'Cambiar de pestaña';

  @override
  String get shortcutScan => 'Abrir el escáner';

  @override
  String get shortcutSearch => 'Buscar en la pestaña en la que estés';

  @override
  String get shortcutSettings => 'Ajustes';

  @override
  String get shortcutClose => 'Cerrar lo que tengas abierto encima';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'El del sistema';

  @override
  String get languagePartial =>
      'La app se está traduciendo por partes: el armazón ya está en tu idioma y el resto de pantallas siguen en español de momento.';

  @override
  String get versionTitle => 'Versión de ManaForge';

  @override
  String versionYouHave(String version) {
    return 'Tienes la $version.';
  }

  @override
  String get versionSeeWhatsNew => 'Ver qué trae';

  @override
  String get versionNotifyMe => 'Avisarme de versiones nuevas';

  @override
  String get versionNotifyMeWhy =>
      'Pregunta una vez al día a GitHub qué versión es la última. No descarga ni instala nada.';

  @override
  String get versionCheckNow => 'Buscar ahora';

  @override
  String get versionUpToDate =>
      'Estás en la última versión (o GitHub no contesta ahora mismo).';

  @override
  String versionThereIs(String version) {
    return 'Hay ManaForge $version.';
  }

  @override
  String get versionGoDownload => 'Ir a la descarga';

  @override
  String versionNotAuto(String version) {
    return 'Tienes la $version. La app no se actualiza sola: te lleva a la descarga.';
  }

  @override
  String get versionNotNow => 'Ahora no';

  @override
  String get versionSee => 'Ver';

  @override
  String whatsNewTitle(String version) {
    return 'Novedades de la $version';
  }

  @override
  String get whatsNewClose => 'A jugar';

  @override
  String get downloadCopyLink => 'Copiar enlace';

  @override
  String get downloadClose => 'Cerrar';

  @override
  String get downloadTitle => 'Descargar ManaForge';

  @override
  String get backgroundTitle => 'Fondo de pantalla';

  @override
  String get backgroundWhat =>
      'Pon detrás de la app la imagen que quieras. Wizards publica fondos oficiales de cada colección: bájate el que te guste y elígelo aquí. La app no se los descarga sola — ese arte tiene dueño y repartirlo no le toca.';

  @override
  String get backgroundPick => 'Elegir imagen…';

  @override
  String get backgroundChange => 'Cambiar imagen…';

  @override
  String get backgroundOfficial => 'Fondos oficiales de Magic';

  @override
  String get backgroundRemove => 'Quitar fondo';

  @override
  String get backgroundDim => 'Cuánto se oscurece (para que se lea el texto)';

  @override
  String get backgroundCardColor => 'Color de las tarjetas';

  @override
  String get backgroundTextColor => 'Color de la letra';

  @override
  String get backgroundCardOpacity => 'Cuánto tapan las tarjetas al fondo';

  @override
  String get backgroundColorDefault => 'El de siempre';

  @override
  String get backgroundPreview => 'Así se ve';

  @override
  String get backgroundNotAnImage =>
      'Elige una imagen (.jpg, .png o .webp) como fondo.';

  @override
  String get backgroundTooBig =>
      'Esa imagen es demasiado grande para usarla de fondo.';

  @override
  String get welcomeTitle =>
      'Bienvenido a la forja. Mete tus cartas como quieras — o prueba Forge antes de meter ninguna.';

  @override
  String get welcomeScan => 'Escanear mis cartas';

  @override
  String get welcomeImport => 'Importar CSV (ManaBox)';

  @override
  String get welcomeTryForge => 'Probar Forge sin colección';

  @override
  String get decksEmptyGoForge => 'Ir a Forge';

  @override
  String get yourCollection => 'Tu colección';

  @override
  String cardsAndDistinct(int copies, int distinct) {
    return '$copies cartas · $distinct distintas';
  }

  @override
  String get marketArrow => 'Mercado ›';

  @override
  String get certHeadingSetComplete => 'CERTIFICADO DE COLECCIÓN COMPLETA';

  @override
  String get certSubtitleSetComplete => 'Expansión completa';

  @override
  String get certHeadingWelcome => 'CERTIFICADO DE BIENVENIDA';

  @override
  String get certWelcomeTitle => 'Bienvenido al mundo de Magic';

  @override
  String get certSubtitleWelcome => 'Tu primera carta';

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
    return 'Empecé con $name';
  }

  @override
  String get certCollectorAnon => 'Coleccionista de ManaForge';

  @override
  String certAwardedTo(String name) {
    return 'Otorgado a $name';
  }

  @override
  String certOnDate(String date) {
    return 'el $date';
  }

  @override
  String get certDataBy => 'Datos por Scryfall';

  @override
  String get onbCollectionTitle => 'Tu colección';

  @override
  String get onbCollectionBody =>
      'Aquí viven todas tus cartas, en carpetas y por expansiones.';

  @override
  String get onbScanTitle => 'Escanea cartas';

  @override
  String get onbScanBody => 'Añade cartas nuevas con la cámara o una foto.';

  @override
  String get onbForgeTitle => 'Forja mazos';

  @override
  String get onbForgeBody =>
      'Genera mazos completos con las cartas que ya tienes.';

  @override
  String get onbDecksTitle => 'Tus mazos';

  @override
  String get onbDecksBody => 'Los mazos que guardes desde Forge aparecen aquí.';

  @override
  String get onbSkip => 'Saltar';

  @override
  String get onbNext => 'Siguiente';

  @override
  String get onbGotIt => 'Entendido';

  @override
  String get onbBack => 'Atrás';

  @override
  String get tourMenuTitle => 'Guías';

  @override
  String get tourWelcomeName => 'Vuelta rápida';

  @override
  String get tourHomeName => 'La pantalla de inicio';

  @override
  String get onbEditHomeTitle => 'Personaliza tu inicio';

  @override
  String get onbEditHomeBody =>
      'Con este botón eliges qué secciones se ven en Inicio y en qué orden.';

  @override
  String get onbLangTitle => 'Idioma';

  @override
  String get onbLangBody => 'Cambia aquí el idioma de toda la app.';

  @override
  String get onbLookTitle => 'Aspecto';

  @override
  String get onbLookBody =>
      'Pon un fondo de pantalla y elige los colores de las tarjetas, la letra, las pestañas y los iconos.';

  @override
  String get tourSettingsName => 'Personalizar la app';

  @override
  String get tourFullName => 'Vuelta completa por la app';

  @override
  String get tourCollectionName => 'Tu colección y las carpetas';

  @override
  String get tourForgeName => 'Forjar un mazo';

  @override
  String get tourMarketName => 'Mercado, wishlist y alertas';

  @override
  String get onbAllCardsTitle => 'Todas las cartas';

  @override
  String get onbAllCardsBody =>
      'Aquí está tu colección entera: buscar, filtrar y ordenar.';

  @override
  String get onbFoldersTitle => 'Carpetas';

  @override
  String get onbFoldersBody =>
      'Las carpetas son etiquetas: agrupan lo que quieras y una carta puede estar en varias. Con «Nueva» creas la primera.';

  @override
  String get onbAlbumMineTitle => 'El álbum por expansiones';

  @override
  String get onbAlbumMineBody =>
      'Cada expansión con sus huecos. Con este filtro ves solo las expansiones donde ya tienes cartas.';

  @override
  String get onbForgeBasicsTitle => 'Tierras básicas';

  @override
  String get onbForgeBasicsBody =>
      'Si tienes básicas sueltas por casa, déjalo puesto: Forge contará con ellas. Quítalo para usar solo las de tu colección.';

  @override
  String get onbForgeSetsTitle => 'Expansiones';

  @override
  String get onbForgeSetsBody =>
      'Acota de dónde salen las cartas. Sin elegir ninguna, Forge usa toda tu colección.';

  @override
  String get onbForgeMissingTitle => 'Cartas que no tengo';

  @override
  String get onbForgeMissingBody =>
      'Al activarlo, Forge también propone cartas que te faltan y te dice cuántas son y cuánto costarían.';

  @override
  String get onbForgeGoTitle => 'Forjar';

  @override
  String get onbForgeGoBody =>
      'Este botón hace los mazos. Con muchas expansiones tarda unos segundos.';

  @override
  String get onbForgeTestTitle => 'Modo Test';

  @override
  String get onbForgeTestBody =>
      'Mide tu mazo contra uno del meta y te dice qué le falta para ganarle.';

  @override
  String get onbMarketPickTitle => 'Elegir mercado';

  @override
  String get onbMarketPickBody =>
      'Cardmarket o TCGplayer: cambia el precio de cada carta y su gráfica.';

  @override
  String get onbWishlistTitle => 'Wishlist';

  @override
  String get onbWishlistBody =>
      'Las cartas que quieres. El contador se pone verde cuando alguna llega a tu precio.';

  @override
  String get onbPriceAlertTitle => 'Alerta de precio';

  @override
  String get onbPriceAlertBody =>
      'Busca una carta, dale al marcador para meterla en la wishlist y ponle un precio objetivo: la app te avisa cuando baje.';

  @override
  String get tourProgressName => 'Logros y certificados';

  @override
  String get onbAchievementsTitle => 'Logros y nivel';

  @override
  String get onbAchievementsBody =>
      'Tu nivel y lo que llevas ganado. Sube escaneando, ordenando y forjando.';

  @override
  String get onbCertificatesTitle => 'Certificados';

  @override
  String get onbCertificatesBody =>
      'Los hitos gordos salen en un diploma que puedes guardar en PDF o enseñar. Están dentro de Logros.';

  @override
  String get onbBackupTitle => 'Copia de seguridad';

  @override
  String get onbBackupBody =>
      'Guarda tu colección, mazos y carpetas en un archivo, y recupéralos si cambias de ordenador. Además se hace una copia sola cada semana.';

  @override
  String onbTapHere(String pantalla) {
    return 'Pulsa aquí para abrir $pantalla.';
  }

  @override
  String get onbAchievementsName => 'Logros';

  @override
  String get onbDataSectionTitle => 'Datos';

  @override
  String get onbDataSectionBody =>
      'Aquí vive todo lo que la app guarda: la base de cartas y tus copias de seguridad.';

  @override
  String get onbCardDbTitle => 'Base de datos de cartas';

  @override
  String get onbCardDbBody =>
      'Vuelve a descargarla para tener cartas nuevas, precios frescos y lo que pide datos recientes, como el filtro por año de Forge.';

  @override
  String get onbAboutTitle => 'La app';

  @override
  String get onbAboutBody =>
      'Qué hace cada pestaña, los atajos de teclado, la versión y la licencia.';

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
}
