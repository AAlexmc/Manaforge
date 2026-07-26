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
  String get onbForgeDeepTitle => 'Forja profunda';

  @override
  String get onbForgeDeepBody =>
      'Antes de enseñarte las propuestas, las hace jugar entre sí de verdad: el orden final pesa cómo rinden, no solo su score estático. Puedes apagarlo si prefieres resultados más rápidos.';

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
  String get acDelete => 'Borrar';

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
  String get onbSuggestionsTitle => 'Buzón de sugerencias';

  @override
  String get onbSuggestionsBody =>
      '¿Se te ocurre algo, o has visto un fallo? Cuéntalo en GitHub: hay plantilla y se rellena en un minuto.';

  @override
  String get onbSupportTitle => 'Apoyar el proyecto';

  @override
  String get onbSupportBody =>
      'La app es gratis y sin anuncios. Si te ha servido, aquí se explica cómo invitarnos a un café.';

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

  @override
  String get fgMsgReading => 'Leyendo tu colección…';

  @override
  String get fgMsgCurve => 'Calculando la curva de maná…';

  @override
  String get fgMsgLands => 'Repartiendo tierras…';

  @override
  String get fgMsgSynergy => 'Buscando sinergias…';

  @override
  String get fgMsgPlan => 'Escribiendo tu plan de juego…';

  @override
  String get fgNeedDbForSets =>
      'Necesito la base de cartas para listar las expansiones: Ajustes → descargar la base.';

  @override
  String fgDbError(String error) {
    return 'No pude leer la base de datos de cartas: $error';
  }

  @override
  String fgInThoseSets(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: ' en esas $n expansiones',
      one: ' en esa expansión',
    );
    return '$_temp0';
  }

  @override
  String fgNoCommander(String donde) {
    return 'No me sale un Commander legal$donde: hacen falta un comandante legendario y ~62 cartas DISTINTAS dentro de su identidad (es singleton), más básicas suficientes. Prueba otro formato, otras expansiones o amplía la colección.';
  }

  @override
  String fgNoDeck(String formato, String donde, String consejo) {
    return 'Con las cartas de este pool no me sale ningún mazo completo $formato que cumpla mis reglas (tierras suficientes y curva sana)$donde. $consejo Antes que darte un mazo defectuoso, prefiero avisarte.';
  }

  @override
  String fgNoDeckStyle(String estilo) {
    return 'Con este Estilo ($estilo) no sale mazo. Prueba «Estilo: auto» u otra tribu.';
  }

  @override
  String get fgOf60 => 'de 60';

  @override
  String fgLegalIn(String formato) {
    return 'LEGAL en $formato';
  }

  @override
  String get fgTipMoreSets => 'Prueba con más expansiones o quita filtros.';

  @override
  String get fgTipMoreCards =>
      'Añade más cartas — sobre todo de tus colores principales — o marca \"incluir cartas que no tengo\".';

  @override
  String get fgPitch =>
      'Mazos completos y jugables con las cartas que ya tienes. Sin comprar nada.';

  @override
  String get fgTeaserCount => 'cartas para tu primer mazo';

  @override
  String get fgTeaserMissing => 'Hacer un mazo con cartas que no tengo';

  @override
  String get fgBasics => 'Cuento con tierras básicas sueltas';

  @override
  String get fgBasicsSub =>
      'Casi todo el mundo tiene básicas de mazos de inicio; desactívalo para usar SOLO las básicas de tu colección.';

  @override
  String get fgFormat => 'Formato de juego';

  @override
  String get fgCasual60 => 'Casual 60';

  @override
  String get fgCommanderNote =>
      '100 cartas · singleton · comandante legendario de tu colección · identidad de color respetada.';

  @override
  String get fgCasualNote =>
      '60 cartas, sin restricción de legalidad: todo vale.';

  @override
  String fgFormatNote(String formato) {
    return '60 cartas usando SOLO tus cartas legales en $formato.';
  }

  @override
  String get fgWhereFrom => '¿De dónde salen las cartas?';

  @override
  String get fgPickSets => 'Elegir expansiones';

  @override
  String get fgChangeSets => 'Cambiar expansiones';

  @override
  String get fgNeedOneSet =>
      'Elige al menos una expansión: sin filtro serían las ~30.000 cartas de Magic.';

  @override
  String get fgNoSetsNote =>
      'Sin elegir expansiones, Forge usa toda tu colección.';

  @override
  String fgFromSetsAny(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cartas de $n expansiones, tengas o no.',
      one: 'Cartas de 1 expansión, tengas o no.',
    );
    return '$_temp0';
  }

  @override
  String fgFromSetsMine(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Solo tus cartas de $n expansiones — no toda la colección.',
      one: 'Solo tus cartas de 1 expansión — no toda la colección.',
    );
    return '$_temp0';
  }

  @override
  String get fgNoPrintingData =>
      'Tu colección no guarda la edición de cada carta, así que filtrar por expansión dejaría fuera casi todo. Reimporta tu CSV con \"Sustituir\" y vuelve.';

  @override
  String get fgIncludeMissing => 'Incluir cartas que no tengo';

  @override
  String get fgIncludeMissingSub =>
      'Forge deja de limitarse a tu colección y usa TODO lo impreso en esas expansiones; luego te dice cuántas cartas te faltan y cuánto costarían.';

  @override
  String get fgYourTaste => 'A tu gusto (opcional)';

  @override
  String get fgArchetypeAuto => 'Arquetipo: auto';

  @override
  String get fgStyle => 'Estilo';

  @override
  String get fgStyleAuto => 'Estilo: auto';

  @override
  String get fgTribeElf => 'Elfos';

  @override
  String get fgTribeGoblin => 'Trasgos';

  @override
  String get fgTribeZombie => 'Zombis';

  @override
  String get fgTribeVampire => 'Vampiros';

  @override
  String get fgTribeDragon => 'Dragones';

  @override
  String get fgTribeAngel => 'Ángeles';

  @override
  String get fgTribeDemon => 'Demonios';

  @override
  String get fgTribeDinosaur => 'Dinosaurios';

  @override
  String get fgTribeFaerie => 'Hadas';

  @override
  String get fgTribeMerfolk => 'Tritones';

  @override
  String get fgTribeHuman => 'Humanos';

  @override
  String get fgTribeSpirit => 'Espíritus';

  @override
  String get fgTribeSliver => 'Astillas';

  @override
  String get fgTribeWizard => 'Magos';

  @override
  String get fgTribeKnight => 'Caballeros';

  @override
  String get fgTribeWarrior => 'Guerreros';

  @override
  String get fgTribeSoldier => 'Soldados';

  @override
  String get fgTribeCat => 'Gatos';

  @override
  String get fgTribeDog => 'Perros';

  @override
  String get fgTribeRat => 'Ratas';

  @override
  String get fgTribePirate => 'Piratas';

  @override
  String get fgTribeElemental => 'Elementales';

  @override
  String get fgTribeGiant => 'Gigantes';

  @override
  String get fgTribeRogue => 'Pícaros';

  @override
  String get fgDeepForge => 'Forja profunda';

  @override
  String get fgDeepForgeHint =>
      'Antes de enseñarte las propuestas, las hace jugar entre sí de verdad (te cuesta un poco más de espera).';

  @override
  String get fgPricePerCard => 'Precio por carta:';

  @override
  String get fgMin => 'mín €';

  @override
  String get fgMax => 'máx €';

  @override
  String get fgCardYear => 'Año de la carta:';

  @override
  String get fgFrom => 'desde';

  @override
  String get fgTo => 'hasta';

  @override
  String get fgYearNeedsDb =>
      'El filtro por año necesita la base de datos actualizada: Ajustes → Volver a descargar la base de datos.';

  @override
  String get fgNoColorsNote =>
      'Sin elegir colores, Forge prueba todas las combinaciones.';

  @override
  String fgColorsNote(String colores) {
    return 'Solo mazos $colores (y sus combinaciones).';
  }

  @override
  String get fgMissingNote =>
      'Este mazo puede llevar cartas que NO tienes: cada propuesta dice cuántas te faltan y lo que costarían (precio de Cardmarket).';

  @override
  String fgOnlyYoursNote(int n) {
    return 'Forge solo usa tus $n cartas. Nunca inventa copias que no tienes.';
  }

  @override
  String get fgForgeMissing => 'Forjar mazos (con lo que me falte)';

  @override
  String get fgForgeMine => 'Forjar mis mazos';

  @override
  String get fgTestMode => 'Modo Test: vence a un mazo del meta';

  @override
  String get fgOffline => 'Todo se calcula en tu dispositivo, sin internet';

  @override
  String fgForgingWith(int n) {
    return 'Estás forjando con $n cartas: esto tarda unos segundos. La ventana sigue viva.';
  }

  @override
  String fgDecksReady(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mazos listos para jugar',
      one: '1 mazo listo para jugar',
    );
    return '$_temp0';
  }

  @override
  String get fgSwipeMissing =>
      'Con cartas que aún no tienes · desliza para comparar';

  @override
  String get fgSwipeMine =>
      'Hechos solo con tus cartas · desliza para comparar';

  @override
  String get fgHaveAll => '✓ Tienes todas las cartas';

  @override
  String fgShortfall(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Te faltan $n cartas',
      one: 'Te falta 1 carta',
    );
    return '$_temp0';
  }

  @override
  String get fgSeeDeck => 'Ver mazo completo';

  @override
  String get fgReforge => 'Reforjar';

  @override
  String mkAlertOne(String carta, String precio, String objetivo) {
    return '🔔 ¡$carta está a $precio (tu objetivo: $objetivo)!';
  }

  @override
  String mkAlertMany(int n) {
    return '🔔 ¡$n cartas de tu wishlist han caído a su precio objetivo!';
  }

  @override
  String get mkTellMeWhenDrops => 'Avísame cuando baje';

  @override
  String get mkTargetPrice => 'Precio objetivo';

  @override
  String mkNow(String precio) {
    return 'Ahora: $precio';
  }

  @override
  String get mkUpdated => '✓ Precios y cartas actualizados';

  @override
  String mkUpdateFailed(String error) {
    return 'No pude actualizar: $error';
  }

  @override
  String get mkHistoryReady =>
      '✓ Histórico de precios listo: las gráficas ya enseñan los últimos meses';

  @override
  String mkHistoryFailed(String error) {
    return 'No pude traer el histórico (el que ya tenías sigue intacto): $error';
  }

  @override
  String get mkHistoryLocal =>
      'Histórico de precios: solo el que ManaForge apunta a diario en tu equipo. Tráete los últimos ~90 días reales de Cardmarket (≈4 MB).';

  @override
  String mkHistoryReal(String desde, String hasta) {
    return 'Histórico real de Cardmarket del $desde al $hasta, y desde ahí lo que apunta ManaForge.';
  }

  @override
  String get mkFetchHistory => 'Traer histórico';

  @override
  String get mkCollectionValue => 'Valor de tu colección · Cardmarket';

  @override
  String mkCardsCount(int n) {
    return '$n cartas';
  }

  @override
  String get mkApproxSuffix => ' · valor orientativo';

  @override
  String mkBulkPrices(String fecha) {
    return 'Precios Cardmarket del $fecha (Scryfall)';
  }

  @override
  String mkNoData(String error) {
    return 'Mercado sin datos: descarga la base de datos en Colección. ($error)';
  }

  @override
  String mkSetsHeader(int n) {
    return 'EXPANSIONES ($n)';
  }

  @override
  String get mkPrevious => 'Anteriores';

  @override
  String get mkNext => 'Siguientes';

  @override
  String get mkSearchHint => 'Busca el precio de cualquier carta…';

  @override
  String get mkRemoveFromWishlist => 'Quitar de la wishlist';

  @override
  String get mkAddToWishlist => 'A la wishlist: avísame cuando baje';

  @override
  String get mkYourWishlist => 'TU WISHLIST';

  @override
  String mkTargetAtMost(String precio) {
    return 'objetivo ≤ $precio';
  }

  @override
  String get mkAtPrice => '¡a precio!';

  @override
  String get mkChangeTarget => 'Cambiar precio objetivo';

  @override
  String mkNoPriceIn(String market) {
    return 'sin precio en $market';
  }

  @override
  String get mkPerUnit => '/ud';

  @override
  String get mkTopCards => 'TUS CARTAS MÁS VALIOSAS';

  @override
  String get mkImportToSeeValue => 'Importa tu colección para ver su valor.';

  @override
  String mkSetCards(int n) {
    return ' · $n cartas';
  }

  @override
  String get wlEmpty =>
      'Búscalas en Mercado y toca el marcador para que te avise cuando bajen a tu precio.';

  @override
  String wlAtPriceCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '🔔 $n cartas de tu wishlist están a tu precio objetivo o por debajo.',
      one: '🔔 1 carta de tu wishlist está a tu precio objetivo o por debajo.',
    );
    return '$_temp0';
  }

  @override
  String get mpMtgoTix => 'Precios de MTGO en tix (cartas digitales)';

  @override
  String get mpNoDataYet =>
      'Sin datos todavía: actualiza el histórico de precios en Mercado';

  @override
  String get mpMtgoNote =>
      'Precios de MTGO en tix: son cartas digitales, no valen para tasar tu colección de papel. Inicio, carpetas y logros siguen en Cardmarket (€).';

  @override
  String mpMarketNote(String mercado, String moneda) {
    return 'Precios de $mercado en $moneda. Inicio, carpetas y logros siguen valorando en Cardmarket (€): las divisas no se convierten.';
  }

  @override
  String get mkUpdate => 'Actualizar';

  @override
  String get mkApproxValue =>
      ' · valor aproximado (reimporta con \"Sustituir\" para precios por edición)';

  @override
  String get mkExactPrintings => ' · por tus ediciones exactas';

  @override
  String mkNowSuffix(String precio) {
    return ' · ahora $precio';
  }

  @override
  String get wlNothingYet => 'Aún no tienes cartas en la wishlist.';

  @override
  String get stDbUpdated => '✓ Base de datos actualizada';

  @override
  String stUpdateFailed(String error) {
    return 'No se pudo actualizar: $error';
  }

  @override
  String get stCardDb => 'Base de datos de cartas';

  @override
  String get stCardDbWhy =>
      'Vuelve a descargarla para tener cartas nuevas, precios frescos y las funciones que piden datos recientes (como el filtro por año en Forge).';

  @override
  String get stDownloadDbAgain => 'Volver a descargar la base de datos';

  @override
  String get stAppearance => 'Apariencia';

  @override
  String get stData => 'Datos';

  @override
  String get stTheApp => 'La app';

  @override
  String get stCredits =>
      'Datos e imágenes de cartas por Scryfall. Magic: The Gathering es propiedad de Wizards of the Coast; proyecto de fans al amparo de su Fan Content Policy.';

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
  String get stEditHome => 'Editar inicio';

  @override
  String get stEditHomeSub => 'Elige qué secciones se ven y en qué orden';

  @override
  String get ehLevel => 'Tu nivel';

  @override
  String get ehShortcuts => 'Accesos rápidos';

  @override
  String get ehSummary => 'Resumen de la colección';

  @override
  String get ehRecent => 'Vistas recientemente';

  @override
  String get ehDecks => 'Tus mazos';

  @override
  String get ehMeta => 'El meta ahora';

  @override
  String get ehNewSets => 'Expansiones nuevas';

  @override
  String get ehGems => 'Tus joyas';

  @override
  String get ehStatCards => 'cartas';

  @override
  String get ehStatDistinct => 'distintas';

  @override
  String get ehStatValue => 'valor';

  @override
  String get ehStatDecks => 'mazos';

  @override
  String get ehStatAchievements => 'logros';

  @override
  String get ehHelp =>
      'Arrastra para ordenar y usa el interruptor para elegir qué ves en Inicio. Una sección encendida solo sale si tiene algo que enseñar.';

  @override
  String get ehSection => 'Sección';

  @override
  String get bkNoData => 'No encuentro tus datos.';

  @override
  String bkSaved(String resumen) {
    return '✓ Copia guardada · $resumen';
  }

  @override
  String bkSaveFailed(String error) {
    return 'No he podido guardarla: $error';
  }

  @override
  String get bkFileName => 'Copia de ManaForge';

  @override
  String bkRestoreFailed(String error) {
    return 'No he podido restaurarla: $error';
  }

  @override
  String bkRestoredNoPrevious(String resumen, String error) {
    return '✓ Restaurado · $resumen. OJO: no he podido guardar lo que tenías antes ($error).';
  }

  @override
  String bkRestored(String resumen) {
    return '✓ Restaurado · $resumen. Lo que tenías antes está guardado en la carpeta backups.';
  }

  @override
  String get bkRestoring => 'Restaurando tu copia…';

  @override
  String get bkTitle => 'Copia de seguridad';

  @override
  String get bkWhy =>
      'Tus cartas, mazos, carpetas y logros viven solo en este ordenador. Guarda una copia de vez en cuando y déjala en otro sitio: un disco, la nube, lo que quieras.';

  @override
  String get bkSave => 'Guardar copia';

  @override
  String get bkRestoreTitle => 'Restaurar una copia';

  @override
  String bkRestoreWarning(String palabra) {
    return 'Restaurar REEMPLAZA tus cartas, mazos, carpetas y logros de ahora por los de la copia. Elige cuál, dale al botón y escribe $palabra: así no se restaura nada sin querer.';
  }

  @override
  String get bkNoBackups => 'Aún no hay copias guardadas en este ordenador.';

  @override
  String get bkWhich => 'Copia a restaurar';

  @override
  String get bkPickOne => 'Elige una copia';

  @override
  String get bkRestorePicked => 'Restaurar la copia elegida';

  @override
  String get bkAutoNote =>
      'Guardo una copia automática cada semana (las cinco últimas) y otra justo antes de cada restaurar.';

  @override
  String get bkFromFile => 'Restaurar de un archivo';

  @override
  String get bkConfirmTitle => '¿Restaurar esta copia?';

  @override
  String get bkConfirmBody =>
      'Esto reemplaza tu colección, mazos, carpetas y logros de ahora por los de esa copia. Antes de hacerlo guardo lo que tienes en la carpeta backups, por si quieres volver.';

  @override
  String bkWillDelete(String cosas) {
    return 'Esa copia no trae $cosas: al restaurarla, eso se borra.';
  }

  @override
  String bkTypeToConfirm(String palabra) {
    return 'Escribe $palabra para poder seguir:';
  }

  @override
  String get bkAnd => ' y ';

  @override
  String get ehReset => 'Restablecer';

  @override
  String bkOfDate(String cuando, String resumen) {
    return 'Copia del $cuando · $resumen.';
  }

  @override
  String get lsMacUsePhoto =>
      'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.';

  @override
  String get lsNoCamera => 'No encuentro ninguna cámara.';

  @override
  String get lsCameraGone =>
      'La cámara se ha desconectado a media sesión. Revisa el cable y dale a Reintentar.';

  @override
  String get lsFrameCard => 'Encuadra la carta dentro del marco';

  @override
  String get lsNoCardThere => 'No veo ninguna carta ahí';

  @override
  String lsAddedToCollection(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ $n cartas a la colección',
      one: '✓ 1 carta a la colección',
    );
    return '$_temp0';
  }

  @override
  String lsAndToFolder(String carpeta) {
    return ', y a \"$carpeta\"';
  }

  @override
  String get lsTitle => 'Escanear en vivo';

  @override
  String get lsQuickTip =>
      'Rápido: las cartas claras entran solas; las dudosas, marcadas para revisar.';

  @override
  String get lsCarefulTip =>
      'Con cuidado: las dudosas se paran y te preguntan cuál es.';

  @override
  String get lsQuick => 'Rápido';

  @override
  String get lsCareful => 'Con cuidado';

  @override
  String lsThisSession(int n) {
    return '$n esta sesión';
  }

  @override
  String get lsScanPhotoTooltip => 'Escanear una foto suelta';

  @override
  String get lsStartingCamera => 'Encendiendo la cámara…';

  @override
  String get lsCantUseCamera => 'No puedo usar la cámara';

  @override
  String get lsCameraUnavailable => 'Cámara no disponible.';

  @override
  String get lsScanPhoto => 'Escanear una foto';

  @override
  String lsPlusOneSame(String carta, int n) {
    return '+1 igual · $carta (×$n)';
  }

  @override
  String lsAlreadyOnTable(String carta) {
    return 'Ya está en la mesa: $carta · retírala y vuelve a ponerla, o toca \"+1 igual\"';
  }

  @override
  String lsSeeing(String carta) {
    return 'Viendo: $carta';
  }

  @override
  String get lsPassACard => 'Pasa una carta por delante de la cámara…';

  @override
  String lsIsThis(String carta) {
    return '¿Es $carta? No estoy seguro — toca para elegir.';
  }

  @override
  String get lsNotThisOne => 'No es esta — cambiar versión';

  @override
  String get lsRetry => 'Reintentar';

  @override
  String get scBadImage => 'No pude leer esa imagen (¿es una foto válida?)';

  @override
  String scAddedOne(String carta, String set, String numero) {
    return '✓ $carta ($set #$numero)';
  }

  @override
  String get scNoFolder => 'Sin carpeta';

  @override
  String scAlsoTo(String carpeta) {
    return 'Y además a: $carpeta';
  }

  @override
  String get scLookingForCard => 'Buscando la carta en la foto…';

  @override
  String scRecognising(int hechas, int total) {
    return 'Reconociendo… $hechas/$total';
  }

  @override
  String scTrayCount(int n, int copias) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartas',
      one: '1 carta',
    );
    return '$_temp0 · $copias en total';
  }

  @override
  String scToReview(int n) {
    return '$n para revisar (tócalas)';
  }

  @override
  String scUnknown(int n) {
    return '$n sin reconocer (toca para elegir a mano)';
  }

  @override
  String scSkipped(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fotos saltadas (demasiado grandes o ilegibles)',
      one: '1 foto saltada (demasiado grande o ilegible)',
    );
    return '$_temp0';
  }

  @override
  String get scNothingRecognised =>
      'No reconocí ninguna carta en esas fotos. Prueba con mejor luz o menos reflejo.';

  @override
  String scAddN(int n) {
    return 'Añadir $n a la colección';
  }

  @override
  String get scDropPhotos => 'Suelta aquí las fotos de tus cartas';

  @override
  String get scDropExplain =>
      'Una o varias a la vez — y si una foto trae VARIAS cartas (una página del álbum, la mesa llena), las saco todas y las junto en una lista para que revises y añadas las que quieras. Vale foto del móvil o escaneo.';

  @override
  String get scPickPhotos => 'Elegir fotos';

  @override
  String get scMatchHigh => 'coincidencia alta';

  @override
  String get scMatchMedium => 'coincidencia media';

  @override
  String get scMatchLow => 'coincidencia baja';

  @override
  String get scAddToCollection => 'Añadir a la colección';

  @override
  String get scSeeOptions => 'No es esta — ver opciones';

  @override
  String get scScanAnother => 'Escanear otra';

  @override
  String get scNotSure => 'No estoy seguro';

  @override
  String get scWhichIsIt => '¿Cuál es?';

  @override
  String get scNoneQuiteFits =>
      'Ninguna encaja del todo. ¿Es alguna de estas? Si no, prueba otra foto con mejor luz.';

  @override
  String get scNoEdges =>
      'No vi los bordes de la carta, así que he usado la imagen entera. Estos son los parecidos:';

  @override
  String get scCropped =>
      'Esto es lo que he recortado. Los candidatos, por parecido:';

  @override
  String get scDiscard => 'Descartar y escanear otra';

  @override
  String get suCardsName => 'Cartas y precios';

  @override
  String get suCardsWhat => 'catálogo completo de Scryfall';

  @override
  String get suHistoryName => 'Histórico de precios';

  @override
  String get suHistoryWhat => '~90 días de Cardmarket';

  @override
  String get suHashesName => 'Huellas del escáner';

  @override
  String get suHashesWhat => 'para reconocer por foto';

  @override
  String suUpToDate(String fecha) {
    return 'al día ($fecha)';
  }

  @override
  String get suUpdated => 'actualizado';

  @override
  String suUpdatedWithDate(String fecha) {
    return 'actualizado ($fecha)';
  }

  @override
  String get suFailedOffline => 'no he podido traerla (sin conexión)';

  @override
  String get suKeepingOld => 'sigo con la que tenías';

  @override
  String get suNeedMissing => 'falta, la traigo';

  @override
  String get suNeedStale => 'hay una nueva';

  @override
  String get suNeedFresh => 'al día';

  @override
  String get suAllUpToDate => 'Todo al día. Entrando…';

  @override
  String get suUpdatingCards => 'Poniendo al día tus cartas y precios…';

  @override
  String get suChecking => 'Comprobando si hay novedades…';

  @override
  String get suNoDownloadNote =>
      'Lo que ya está al día no se descarga. Dentro de la app puedes forzar cualquier actualización.';

  @override
  String get suEnter => 'Entrar';

  @override
  String get suEnterNow => 'Entrar ya';

  @override
  String icBadFile(String error) {
    return 'No pude leer el archivo: $error';
  }

  @override
  String get icNotCsv =>
      'Eso no parece un CSV — suelta un archivo .csv o .txt.';

  @override
  String get icTitle => 'Importar colección';

  @override
  String get icExplain =>
      'Arrastra aquí tu CSV de ManaBox (también vale Moxfield, Archidekt o cualquier CSV con columnas Name y Quantity), elígelo con el botón, o pega su contenido a mano:';

  @override
  String get icPickFile => 'Elegir archivo…';

  @override
  String icImported(int cartas, int copias) {
    return '✓ $cartas cartas ($copias copias) añadidas a tu colección.';
  }

  @override
  String get icReplaceMine => 'Sustituir mi colección actual';

  @override
  String get icReplaceWhy =>
      'Actívalo al reimportar tu CSV completo: evita duplicar cantidades y afina el álbum por ediciones.';

  @override
  String icImporting(int hechas, int total) {
    return 'Importando $hechas de $total cartas…';
  }

  @override
  String get icDropHere => 'Suelta tu CSV aquí';

  @override
  String icTokensIgnored(int n) {
    return '\n• $n tokens/emblemas ignorados (no van en mazos, todo bien).';
  }

  @override
  String icUnrecognized(String lista, String mas) {
    return '\n✗ Sin reconocer: $lista$mas';
  }

  @override
  String get icNoPurchasePrice =>
      '\n• Sin precio de compra en el CSV: no habrá P&L (ManaBox lo exporta en la columna \"Purchase price\").';

  @override
  String icWithPurchasePrice(int n) {
    return '\n• $n copias con precio de compra: ya puedes ver el P&L en Mercado.';
  }

  @override
  String get icImporting2 => 'Importando…';

  @override
  String get icImport => 'Importar';

  @override
  String dkDeleted(String nombre) {
    return 'Mazo \"$nombre\" borrado';
  }

  @override
  String get dkUndo => 'DESHACER';

  @override
  String dkOpenFailed(String error) {
    return 'No pude abrir el mazo (¿está descargada la base de datos?): $error';
  }

  @override
  String get dkMyDecks => 'Mis mazos';

  @override
  String get dkEmpty =>
      'Aquí vivirán los mazos que guardes desde Forge (botón de guardar en el detalle del mazo).';

  @override
  String dkSavedCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n guardados',
      one: '1 guardado',
    );
    return '$_temp0';
  }

  @override
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha) {
    return '$arquetipo · $hechizos hechizos + $tierras tierras · guardado el $fecha';
  }

  @override
  String get dkDeleteTooltip => 'Borrar mazo';

  @override
  String get ddSaved => '✓ Mazo guardado — lo tienes en la pestaña Mazos';

  @override
  String get ddReforged => '✓ Mazo reforjado a tu curva — lista actualizada';

  @override
  String get ddSaveToMyDecks => 'Guardar en Mis mazos';

  @override
  String get ddCopyList => 'Copiar lista (Moxfield/Arena)';

  @override
  String get ddListCopied =>
      '✓ Lista copiada — pégala en Moxfield, Arena o Discord';

  @override
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras) {
    return '$tema · $arquetipo · $hechizos hechizos + $tierras tierras';
  }

  @override
  String get ddHaveAll => '✓ Tienes todas las cartas';

  @override
  String ddMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '⚠ Te faltan $n cartas de este mazo — siguen en la lista, no se han borrado',
      one:
          '⚠ Te falta 1 carta de este mazo — sigue en la lista, no se ha borrado',
    );
    return '$_temp0';
  }

  @override
  String get ddGamePlan => 'Tu plan de juego';

  @override
  String get ddManaCurve => 'Curva de maná';

  @override
  String get ddEditCurve => 'Editar curva';

  @override
  String ddDragBars(int hechizos, int tierras) {
    return 'Arrastra las barras ↑↓ · $hechizos hechizos → $tierras tierras';
  }

  @override
  String get ddReforgeCurve => 'Reforjar con esta curva';

  @override
  String ddCurveSummary(int tierras, int hechizos, String coste) {
    return '⛰ $tierras tierras · ✦ $hechizos hechizos · Ø coste $coste';
  }

  @override
  String get ddWhyWorks => '¿Por qué este mazo funciona?';

  @override
  String ddLands(int n) {
    return 'TIERRAS ($n)';
  }

  @override
  String ddDeckTotal(String precio) {
    return 'Total del mazo: ~$precio €';
  }

  @override
  String get ddCheapestPrice => 'precio de la edición más barata (Cardmarket)';

  @override
  String ddSomeNoPrice(int n) {
    return '$n sin precio conocido · edición más barata (Cardmarket)';
  }

  @override
  String get ddInstants => 'Instantáneos';

  @override
  String get ddTypeCreatures => 'Criaturas';

  @override
  String get ddTypeSorceries => 'Conjuros';

  @override
  String get ddTypeEnchantments => 'Encantamientos';

  @override
  String get ddTypeArtifacts => 'Artefactos';

  @override
  String get ddTypeOther => 'Otros';

  @override
  String get ddOutOfRange => '  (fuera del rango sano 20-27)';

  @override
  String get acRecalcTitle => '¿Recalcular logros?';

  @override
  String get acRecalcBody =>
      'Se vuelven a mirar tus cartas y se quitan los logros que hoy no se cumplan. Sirve para arreglar los que se dieron por error; si has vendido cartas, también perderás esos.';

  @override
  String get acRecalc => 'Recalcular';

  @override
  String get acAllFine => 'Todo cuadraba: no se ha quitado ningún logro.';

  @override
  String acRemovedN(int n) {
    return 'Quitados $n logros que ya no se cumplen.';
  }

  @override
  String get acTitle => 'Logros';

  @override
  String get acRecalcTooltip => 'Recalcular con mis cartas de ahora';

  @override
  String get acCertsTooltip => 'Certificados';

  @override
  String acUnlockedOf(int hechos, int total, int xp) {
    return '$hechos de $total logros · $xp XP';
  }

  @override
  String acLevelLine(int nivel, int xp, int siguiente) {
    return 'Nivel $nivel · faltan $xp XP para el $siguiente';
  }

  @override
  String get acIMissing => 'Me faltan';

  @override
  String get acSecret => 'Logro secreto';

  @override
  String get acSecretDesc => 'Se descubre solo cuando lo consigues.';

  @override
  String acProgressLine(String progreso, String tier, int xp) {
    return '$progreso · $tier · $xp XP';
  }

  @override
  String acDoneLine(String fecha, String tier, int xp) {
    return '✓ Conseguido$fecha · $tier · $xp XP';
  }

  @override
  String acOnDate(String fecha) {
    return ' el $fecha';
  }

  @override
  String acLevelUp(int nivel) {
    return '¡Nivel $nivel!';
  }

  @override
  String acLevelUpBody(String titulo, int hechos, int total) {
    return 'Ya eres $titulo. Llevas $hechos de $total logros.';
  }

  @override
  String get acOk => 'Vale';

  @override
  String get acSeeAchievements => 'Ver logros';

  @override
  String acToast(String titulo, String mas, int xp) {
    return '🏆 ¡Logro! $titulo$mas · +$xp XP';
  }

  @override
  String acAndMore(int n) {
    return ' (y $n más)';
  }

  @override
  String ceNeedDb(String error) {
    return 'Para los de expansión hace falta la base de datos de cartas ($error)';
  }

  @override
  String get ceWhoseName => '¿A nombre de quién?';

  @override
  String get ceCollectorName => 'Tu nombre de coleccionista';

  @override
  String get ceInNameOf => 'A nombre de…';

  @override
  String get ceEmptyWithData =>
      'Todavía no tienes ninguna expansión completa. Cuando completes una entera en el Álbum, aquí saldrá tu certificado para descargar.';

  @override
  String get ceEmptyNoData =>
      'Para certificar una expansión hace falta saber la edición exacta de tus cartas: reimporta tu CSV de ManaBox (trae el Scryfall ID).';

  @override
  String get ceNothingSaved => 'No se guardó nada.';

  @override
  String ceSavedTo(String ruta) {
    return '✓ Certificado guardado en $ruta';
  }

  @override
  String ceSaveFailed(String error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String get cePickFirstCard => 'Elegir la carta con la que empecé';

  @override
  String get ceChangeFirstCard => 'Cambiar la carta con la que empecé';

  @override
  String get ceDownloadPng => 'Descargar PNG';

  @override
  String get cdNotFound => 'No encuentro esta carta en la base de datos.';

  @override
  String cdLoadFailed(String error) {
    return 'No pude cargar la ficha: $error';
  }

  @override
  String get cdPrev => 'Anterior (←)';

  @override
  String get cdNext => 'Siguiente (→)';

  @override
  String cdPosition(int pos, int total) {
    return '$pos / $total';
  }

  @override
  String get cdCardNotFound => 'Carta no encontrada';

  @override
  String cdPaid(
      String total, String divisa, int qty, String copias, String unidad) {
    return 'Pagaste $total$divisa por $qty $copias ($unidad cada una)';
  }

  @override
  String cdCopyWord(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'copias',
      one: 'copia',
    );
    return '$_temp0';
  }

  @override
  String cdYouHave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '✓ Tienes $n copias en tu colección',
      one: '✓ Tienes 1 copia en tu colección',
    );
    return '$_temp0';
  }

  @override
  String get cdNotOwned => 'No tienes esta carta (todavía).';

  @override
  String cdNoPrice(String mercado) {
    return 'Sin precio de esta carta en $mercado.';
  }

  @override
  String cdVersions(int n) {
    return 'VERSIONES ($n)';
  }

  @override
  String cdNoPerPrinting(String mercado) {
    return 'sin precio por edición en $mercado';
  }

  @override
  String cdPricesNormalFoil(String mercado, String moneda) {
    return 'precios $mercado ($moneda) · normal / foil';
  }

  @override
  String cdFoil(String precio) {
    return 'foil $precio';
  }

  @override
  String cdYouHaveX(int n) {
    return 'tienes x$n';
  }

  @override
  String get smMythic => 'Mítica';

  @override
  String get smRare => 'Rara';

  @override
  String get smUncommon => 'Infrecuente';

  @override
  String get smCommon => 'Común';

  @override
  String smLoadFailed(String error) {
    return 'No pude cargar el set: $error';
  }

  @override
  String get smSearchInSet => 'Busca en la expansión…';

  @override
  String get smRarityAll => 'Rareza: todas';

  @override
  String get smPriceDown => 'Precio ↓';

  @override
  String get smPriceUp => 'Precio ↑';

  @override
  String get smNumber => 'Número';

  @override
  String get smOnlyMine => 'Solo las mías';

  @override
  String smCardsCount(int n) {
    return '$n cartas';
  }

  @override
  String smNoPerPrinting(String mercado) {
    return '$mercado: sin precio por edición';
  }

  @override
  String smListedValue(String mercado) {
    return 'valor listado ($mercado): ';
  }

  @override
  String pnPaidVsToday(String pagado, String hoy) {
    return 'Pagaste $pagado · hoy valen $hoy';
  }

  @override
  String get pnNoPnl =>
      'Sin precio de compra no hay P&L. Importa tu CSV de ManaBox con la columna \"Purchase price\" y aparece aquí.';

  @override
  String pnOverAll(int n) {
    return 'sobre las $n copias de tu colección';
  }

  @override
  String pnOverSome(int conprecio, int total) {
    return 'sobre $conprecio de $total copias (las demás no tienen precio de compra apuntado)';
  }

  @override
  String pnNoTodayPrice(int n) {
    return '$n copias compradas no tienen precio de hoy en la base: fuera de la cuenta';
  }

  @override
  String pnOtherCurrency(String importe, String moneda) {
    return 'también pagaste $importe $moneda, que no se convierte';
  }

  @override
  String pnAssumedCurrency(int n, String moneda) {
    return '$n copias sin divisa en el CSV: se suponen $moneda';
  }

  @override
  String get pcTitle => 'Evolución del precio';

  @override
  String get pcNoHistory => 'Todavía sin historial de precio de esta carta.';

  @override
  String pcTodayPrice(String precio) {
    return 'Precio de hoy: $precio €. La gráfica aparece en cuanto haya varios días.';
  }

  @override
  String get pcExplain =>
      'ManaForge apunta el precio de cada carta que miras o tienes, día a día. Para arrancar con los últimos meses reales de Cardmarket, trae el histórico desde Mercado.';

  @override
  String pcRange(String min, String max, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n días',
      one: '1 día',
    );
    return 'mín $min € · máx $max € · $_temp0';
  }

  @override
  String get spWhichSets => '¿De qué expansiones?';

  @override
  String get spSearchHint => 'Buscar por nombre o código (BLB, MH3…)';

  @override
  String get spOnlyMine => 'Solo las mías';

  @override
  String spClearN(int n) {
    return 'Quitar las $n';
  }

  @override
  String get spNoneNamed =>
      'Ninguna expansión con ese nombre. Quita \"Solo las mías\" para ver todas.';

  @override
  String spSetLine(String set, int n) {
    return '$set · $n cartas';
  }

  @override
  String get spNoFilter => 'Sin filtro de expansión';

  @override
  String spUseN(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Usar $n expansiones',
      one: 'Usar 1 expansión',
    );
    return '$_temp0';
  }

  @override
  String slLockedTo(String set) {
    return 'Solo busco cartas del set $set. Tócalo para cambiar o quitar el bloqueo.';
  }

  @override
  String get slLockHint =>
      'Bloquea un set para escanear una caja/precon: el escáner solo buscará dentro de él y clava la edición.';

  @override
  String slSetIs(String set) {
    return 'Set: $set';
  }

  @override
  String get slSetAll => 'Set: todas';

  @override
  String get slLockTitle => 'Bloquear edición';

  @override
  String get slLockBody =>
      'Escribe el código del set (p. ej. AER, MH3, LCI) para escanear una caja entera: solo se buscarán cartas de ese set.';

  @override
  String get slSetCode => 'Código de set';

  @override
  String get slClearLock => 'Quitar bloqueo';

  @override
  String get stHintQuick =>
      'Pasa cartas por delante: las claras se apuntan solas aquí (las copias iguales suman ×N). Las dudosas, marcadas para revisar. Al terminar, confirmas todas.';

  @override
  String get stHintCareful =>
      'Pasa cartas por delante: las claras se apuntan solas; las dudosas te preguntan cuál es. Al terminar, confirmas todas.';

  @override
  String stAddN(int n) {
    return 'Añadir $n a la colección';
  }

  @override
  String stAddNAndFolder(int n, String carpeta) {
    return 'Añadir $n a la colección y a $carpeta';
  }

  @override
  String get stOneLess => 'Una menos';

  @override
  String get stAnotherSame => 'Otra igual';

  @override
  String get stOnTable => 'en mesa';

  @override
  String cdLastData(String fecha) {
    return ' (último dato: $fecha)';
  }

  @override
  String get cdLegalities => 'Legalidades';

  @override
  String get slLockButton => 'Bloquear';

  @override
  String get wn030Headline =>
      'Forge por expansiones, precio de compra y avisos de versión';

  @override
  String get wn030Forge =>
      'Forge: elige de qué expansiones salen las cartas. Y si activas \"incluir cartas que no tengo\", te monta el mazo con toda la colección elegida y te dice cuántas te faltan y cuánto cuestan.';

  @override
  String get wn030Pnl =>
      'Precio de compra y P&L: si tu CSV de ManaBox trae \"Purchase price\", el Mercado te dice lo que pagaste, lo que vale hoy y la diferencia. Las divisas no se mezclan.';

  @override
  String get wn030PhotoFolder =>
      'Escanear por foto también deja elegir carpeta, como el escáner en vivo.';

  @override
  String get wn030Album =>
      'Álbum: lo que te falta de cada expansión, con lo que costaría.';

  @override
  String get wn030Background =>
      'Fondo de pantalla: pon detrás la imagen que quieras, con velo regulable, y elige el color de las tarjetas y de la letra para que encima se siga leyendo.';

  @override
  String get wn030Window =>
      'La ventana se abre donde la dejaste, del tamaño que la dejaste.';

  @override
  String get wn030Achievements =>
      'Los logros ya no se llaman como el criterio, se llaman como el momento: \"Ahí va todo mi dinero\", \"Cien raras y ninguna jugable\".';

  @override
  String get wn030Update =>
      'La app avisa cuando hay versión nueva (no se actualiza sola) y comprueba la huella SHA-256 de las bases que se descarga.';

  @override
  String get wn030Shortcuts =>
      'Atajos de teclado: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, y Escape.';

  @override
  String get wn030Linux =>
      'En Linux, un instalador deja ManaForge en el menú de aplicaciones con su icono.';

  @override
  String get wn030License =>
      'Licencia PolyForm Noncommercial: compártela y tócala lo que quieras, pero no se vende.';

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
      other: '$n mazos',
      one: '1 mazo',
    );
    return '$_temp0';
  }

  @override
  String bkSumFolders(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n carpetas',
      one: '1 carpeta',
    );
    return '$_temp0';
  }

  @override
  String bkSumAchievements(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n logros',
      one: '1 logro',
    );
    return '$_temp0';
  }

  @override
  String get bkSumEmpty => 'copia vacía';

  @override
  String get bkStoreCollection => 'tu colección';

  @override
  String get bkStoreFolders => 'tus carpetas';

  @override
  String get bkStoreDecks => 'tus mazos';

  @override
  String get bkStoreAchievements => 'tus logros';

  @override
  String get bkStoreWishlist => 'tu lista de deseos';

  @override
  String get bkStoreCertificates => 'tus certificados';

  @override
  String get bkStoreMarket => 'tu mercado preferido';

  @override
  String get bkStoreRecents => 'las cartas vistas hace poco';

  @override
  String get bkStoreValueHistory => 'el historial del valor';

  @override
  String get bkStorePriceHistory => 'el historial de precios';

  @override
  String get bkKindAuto => 'automática';

  @override
  String get bkKindPreRestore => 'antes de restaurar';

  @override
  String get bkKindPreReset => 'antes del reset de fábrica';

  @override
  String get bkErrFileTooBig =>
      'Ese fichero es demasiado grande para ser una copia de ManaForge.';

  @override
  String get bkErrExpandTooBig =>
      'Esa copia es demasiado grande al abrirla: no parece una copia de ManaForge de verdad.';

  @override
  String get bkErrNotABackup =>
      'Ese fichero no es una copia de seguridad de ManaForge.';

  @override
  String get bkErrNewerVersion =>
      'Esa copia la hizo una versión más nueva de ManaForge. Actualiza la app y vuelve a intentarlo.';

  @override
  String get bkErrIncomplete => 'Esa copia está incompleta: no trae tus datos.';

  @override
  String bkErrDamaged(String almacen) {
    return 'Esa copia está dañada: $almacen no se puede leer.';
  }

  @override
  String bkErrWriteFailed(String error) {
    return 'No he podido escribir en la carpeta de datos, así que no he tocado nada: $error';
  }

  @override
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error) {
    return 'El restaurar se ha quedado a medias ($escritos de $total ficheros). No tengo copia previa de lo que había. Detalle: $error';
  }

  @override
  String bkErrHalfDonePrevious(
      String escritos, String total, String ruta, String error) {
    return 'El restaurar se ha quedado a medias ($escritos de $total ficheros). Para volver atrás, restaura $ruta. Detalle: $error';
  }

  @override
  String get siImportTooBig =>
      'Ese archivo es demasiado grande para ser una lista de cartas.';

  @override
  String get siInsecureDownload =>
      'La descarga acabó en una dirección insegura y se ha cancelado.';

  @override
  String get siRedirectNowhere =>
      'La descarga redirige a ninguna parte y se ha cancelado.';

  @override
  String get siTooManyRedirects =>
      'La descarga da demasiadas vueltas y se ha cancelado.';

  @override
  String get siDownloadTooBig =>
      'La descarga es mucho más grande de lo que debería y se ha cancelado.';

  @override
  String get siBadHash =>
      'Lo descargado no coincide con la huella publicada en GitHub. No se ha instalado nada. Vuelve a intentarlo; si sigue pasando, avisa.';

  @override
  String get siBackgroundNotImage =>
      'Elige una imagen (.jpg, .png o .webp) como fondo.';

  @override
  String get siBackgroundTooBig =>
      'Esa imagen es demasiado grande para usarla de fondo.';

  @override
  String get siScanTooBig => 'Esa foto es demasiado grande para reconocerla.';

  @override
  String get bgImages => 'Imágenes';

  @override
  String bgImageFailed(String error) {
    return 'No pude usar esa imagen: $error';
  }

  @override
  String get bgLowContrast =>
      'Poca diferencia con la tarjeta: la letra se ajustará sola para que se lea.';

  @override
  String get bgChipColor => 'Color de las pestañas';

  @override
  String get bgIconColor => 'Color de los iconos';

  @override
  String get bgUseThis => 'Usar este';

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
      'GStreamer no está instalado. Instálalo con:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good';

  @override
  String camNoImage(String dispositivo, String codigo, String detalle) {
    return 'La cámara $dispositivo no da imagen (gst-launch salió con $codigo).\n$detalle';
  }

  @override
  String camNoFrames(String dispositivo) {
    return 'La cámara $dispositivo no ha dado ningún frame en 6 s.';
  }

  @override
  String get camNoCameras =>
      'No encuentro ninguna cámara (/dev/video*). ¿Está conectada? Comprueba con `lsusb` que el sistema la ve.';

  @override
  String camNoneWorked(String detalle) {
    return 'Ninguna cámara dio imagen:\n$detalle';
  }

  @override
  String get bkRestoreAction => 'Restaurar';

  @override
  String get fpUnselect => 'Desmarcar';

  @override
  String get stClear => 'Vaciar';

  @override
  String get tlRemove => 'Quitar';

  @override
  String get tlUnrecognized => 'Sin reconocer';

  @override
  String get tlNothingAlike => 'nada parecido en la base — re-foto o quitar';

  @override
  String get tlTapToPick => 'toca para elegir a mano entre parecidas';

  @override
  String get tlReview => 'revisar';

  @override
  String get lsQuantity => 'Cantidad';

  @override
  String get scPhotos => 'Fotos';

  @override
  String get ftWhichFolder => '¿En qué carpeta las quieres?';

  @override
  String get ftWhichFolderSub =>
      'Entran en tu colección igual; la carpeta es solo una etiqueta para encontrarlas luego.';

  @override
  String get ftNone => 'Ninguna';

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
  String get ftNewFolderEllipsis => 'Carpeta nueva…';

  @override
  String get ftNewFolder => 'Carpeta nueva';

  @override
  String get ftNewFolderHint => 'Caja de la tienda, Para vender…';

  @override
  String get sgTitle => 'El ojo del escáner';

  @override
  String get sgWhy =>
      'Para reconocer cartas sin internet necesito la base de huellas visuales (~12 MB): la firma del arte de cada ilustración de Magic. Se descarga una vez.';

  @override
  String get sgDownload => 'Descargar base de huellas';

  @override
  String get cmFullCard => 'Ver ficha completa (precios y legalidad)';

  @override
  String get cmSwipeHint =>
      'arrastra o usa ← → para pasar · toca fuera para cerrar';

  @override
  String get cmTapOutHint => 'toca fuera para cerrar';

  @override
  String get fcTitle => '¿Con qué carta empezaste?';

  @override
  String get fcRemove => 'Quitar';

  @override
  String get fcSearchHint => 'Buscar en tu colección';

  @override
  String get fcNoMatch => 'No encuentro ninguna carta con eso.';

  @override
  String get acNoneWithFilters => 'Nada por aquí con estos filtros.';

  @override
  String get acAll => 'Todos';

  @override
  String get tsTitle => 'Modo Test — vence al meta';

  @override
  String get tsIntro =>
      'Elige contra qué mazo del meta quieres jugar. ManaForge construye mazos con TUS cartas, simula cientos de partidas contra él y se queda con el que más gana — probando además cambios de carta uno a uno para afinarlo.';

  @override
  String get tsLoadingMeta => 'Cargando meta…';

  @override
  String get tsLocalPresets => 'Presets locales (sin conexión)';

  @override
  String get tsNoDeckToFace =>
      'Con las cartas actuales no me sale ningún mazo completo que enfrentar. Añade más cartas y vuelve a intentarlo.';

  @override
  String tsSimFailed(String error) {
    return 'No pude simular: $error';
  }

  @override
  String tsFormatShare(String formato, String cuota) {
    return '$formato · $cuota del meta';
  }

  @override
  String get tsSimulating =>
      'Simulando partidas… (unos segundos; todo en tu equipo)';

  @override
  String tsFindBest(String meta) {
    return 'Buscar mi mejor mazo contra $meta';
  }

  @override
  String get tsHonesty =>
      'Honestidad: la simulación entiende colores de maná, mulligans, evasión (volar, arrollar, toque mortal…), removal instantáneo y contramagia — pero no el texto completo de cada carta. El porcentaje sirve para COMPARAR tus mazos entre sí, no como predicción exacta.';

  @override
  String tsChampion(String meta) {
    return 'Tu campeón contra $meta';
  }

  @override
  String tsWinRateLine(int mazos, int partidas) {
    return 'de victorias estimadas · $mazos mazos probados · $partidas partidas por mazo';
  }

  @override
  String get tsNoDominant =>
      'Ningún mazo de tu colección domina este enfrentamiento — este es el que mejor pelea. Mira sus debilidades en el detalle.';

  @override
  String get tsSeeDeck => 'Ver mazo completo (y guardarlo)';

  @override
  String hsLevelLine(int hechos, int total, int xp, int nivel) {
    return '$hechos/$total logros · $xp XP para el nivel $nivel';
  }

  @override
  String get hsForgeDecks => 'Forjar mazos';

  @override
  String get hsTestYourself => '⚔ ponte a prueba';

  @override
  String get bgCustom => 'A medida';

  @override
  String get bgPickCustom => 'Elegir un color a medida';

  @override
  String get bgCustomColor => 'Color a medida';

  @override
  String get bgSampleTab => 'Rojo';

  @override
  String get cfSortRecent => 'Recién añadidas';

  @override
  String get cfSortAlpha => 'Nombre A-Z';

  @override
  String get cfSortCmc => 'Coste';

  @override
  String get cfSortQty => 'Cantidad';

  @override
  String get cfSortBy => 'Ordenar por';

  @override
  String get cfSort => 'Orden';

  @override
  String get cfClear => 'Limpiar';

  @override
  String get cfCost => 'Coste';

  @override
  String get cfCostAll => 'Coste: todos';

  @override
  String cfCostN(String n) {
    return 'Coste $n';
  }

  @override
  String get cfType => 'Tipo';

  @override
  String get cfTypeAll => 'Tipo: todos';

  @override
  String get cfTypeCreature => 'Criaturas';

  @override
  String get cfTypeInstant => 'Instantáneos';

  @override
  String get cfTypeSorcery => 'Conjuros';

  @override
  String get cfTypeArtifact => 'Artefactos';

  @override
  String get cfTypeEnchantment => 'Encantamientos';

  @override
  String get cfTypeLand => 'Tierras';

  @override
  String get cfPower => 'Ataque';

  @override
  String get cfPowerAll => 'Ataque: todos';

  @override
  String cfPowerMin(int n) {
    return 'Ataque ≥ $n';
  }

  @override
  String get cfToughness => 'Defensa';

  @override
  String get cfToughnessAll => 'Defensa: todos';

  @override
  String cfToughnessMin(int n) {
    return 'Defensa ≥ $n';
  }

  @override
  String get cfNoDate => 'sin fecha';

  @override
  String get cfToday => 'hoy';

  @override
  String get cfYesterday => 'ayer';

  @override
  String cfDaysAgo(int n) {
    return 'hace $n días';
  }

  @override
  String get pcWeek => 'Semana';

  @override
  String get pcMonth => 'Mes';

  @override
  String get pcAll => 'Todo';

  @override
  String get vpTapCorrect => 'Toca la carta correcta';

  @override
  String get achCopias1 => 'La primera de muchas';

  @override
  String get achCopias10 => 'Solo iba a comprar una';

  @override
  String get achCopias50 => 'Ya no caben en la mano';

  @override
  String get achCopias100 => 'Cien y subiendo';

  @override
  String get achCopias500 => 'La caja se queda pequeña';

  @override
  String get achCopias1000 => 'Mil. Y las quiero todas';

  @override
  String get achCopias5000 => 'Esto ya es un almacén';

  @override
  String get achCopias10000 => 'Diez mil, pero yo controlo';

  @override
  String achCopiasDesc(String n) {
    return 'Ten $n cartas en tu colección.';
  }

  @override
  String get achDistintas25 => 'Aquí hay variedad';

  @override
  String get achDistintas100 => 'Cien caras distintas';

  @override
  String get achDistintas500 => 'Media biblioteca';

  @override
  String get achDistintas1000 => 'Enciclopedia andante';

  @override
  String get achDistintas2500 => 'Ya no me las sé todas';

  @override
  String get achDistintas5000 => 'El archivo';

  @override
  String achDistintasDesc(String n) {
    return 'Ten $n cartas DISTINTAS (sin contar repetidas).';
  }

  @override
  String get achPlaysets1 => 'Cuatro iguales';

  @override
  String get achPlaysets20 => 'Veinte playsets, cero mazos';

  @override
  String get achPlaysets1Desc => 'Ten 4 copias de una misma carta.';

  @override
  String get achPlaysets20Desc =>
      'Ten 20 playsets distintos (4 copias de cada uno).';

  @override
  String get achComunes10 => 'Las que nadie quiere';

  @override
  String get achComunes50 => 'El montón de siempre';

  @override
  String get achComunes200 => 'Rey del montón';

  @override
  String get achComunes500 => 'Marea de comunes';

  @override
  String achComunesDesc(String n) {
    return 'Ten $n cartas comunes distintas.';
  }

  @override
  String get achInfrecuentes10 => 'Algo mejor que común';

  @override
  String get achInfrecuentes50 => 'Plata fina';

  @override
  String get achInfrecuentes200 => 'Cazador de infrecuentes';

  @override
  String get achInfrecuentes500 => 'Plata a espuertas';

  @override
  String achInfrecuentesDesc(String n) {
    return 'Ten $n cartas infrecuentes distintas.';
  }

  @override
  String get achRaras5 => 'Suena bien al abrir el sobre';

  @override
  String get achRaras25 => 'Cofre de raras';

  @override
  String get achRaras100 => 'Cien raras y ninguna jugable';

  @override
  String get achRaras300 => 'Cámara acorazada';

  @override
  String achRarasDesc(String n) {
    return 'Ten $n cartas raras distintas.';
  }

  @override
  String get achMiticas1 => 'Mi primera mítica';

  @override
  String get achMiticas10 => 'Diez míticas';

  @override
  String get achMiticas50 => 'Coleccionista mítico';

  @override
  String get achMiticas150 => 'Panteón mítico';

  @override
  String achMiticasDesc(String n) {
    return 'Ten $n cartas míticas distintas.';
  }

  @override
  String get achBlancas25 => 'Orden y concierto';

  @override
  String get achBlancas100 => 'Ejército de plata';

  @override
  String achBlancasDesc(String n) {
    return 'Ten $n cartas blancas distintas.';
  }

  @override
  String get achAzules25 => 'Eso no te lo permito';

  @override
  String get achAzules100 => 'Torre de marfil';

  @override
  String achAzulesDesc(String n) {
    return 'Ten $n cartas azules distintas.';
  }

  @override
  String get achNegras25 => 'Pacto oscuro';

  @override
  String get achNegras100 => 'Señor de la cripta';

  @override
  String achNegrasDesc(String n) {
    return 'Ten $n cartas negras distintas.';
  }

  @override
  String get achRojas25 => 'A quemarlo todo';

  @override
  String get achRojas100 => 'Incendio general';

  @override
  String achRojasDesc(String n) {
    return 'Ten $n cartas rojas distintas.';
  }

  @override
  String get achVerdes25 => 'Un brote';

  @override
  String get achVerdes100 => 'El bosque entero';

  @override
  String achVerdesDesc(String n) {
    return 'Ten $n cartas verdes distintas.';
  }

  @override
  String get achIncoloras25 => 'Metal frío';

  @override
  String get achIncoloras100 => 'Forja eterna';

  @override
  String achIncolorasDesc(String n) {
    return 'Ten $n cartas incoloras distintas.';
  }

  @override
  String get achArcoiris => 'Los cinco colores';

  @override
  String get achArcoirisDesc =>
      'Ten al menos una carta de cada uno de los 5 colores.';

  @override
  String get achMulticolor10 => 'Mezclando colores';

  @override
  String get achMulticolor50 => 'Alianza dorada';

  @override
  String achMulticolorDesc(String n) {
    return 'Ten $n cartas multicolor distintas.';
  }

  @override
  String get achCincocolores => 'Los cinco de golpe';

  @override
  String get achCincocoloresDesc => 'Ten una carta con los cinco colores.';

  @override
  String get achSets1 => 'Primera expansión';

  @override
  String get achSets5 => 'Cinco mundos';

  @override
  String get achSets10 => 'Viajero de planos';

  @override
  String get achSets25 => 'Trotamundos';

  @override
  String get achSets50 => 'Medio multiverso';

  @override
  String achSetsDesc(String n) {
    return 'Ten cartas de $n expansiones distintas.';
  }

  @override
  String get achSetscompletos1 => 'No falta ni una';

  @override
  String get achSetscompletos3 => 'Tres álbumes enteros';

  @override
  String get achSetscompletos10 => 'Maestro del álbum';

  @override
  String get achSetscompletos1Desc =>
      'Completa una expansión entera en el Álbum.';

  @override
  String achSetscompletos3Desc(String n) {
    return 'Completa $n expansiones enteras.';
  }

  @override
  String get achAnyos5 => 'Cinco años de cartón';

  @override
  String get achAnyos15 => 'Máquina del tiempo';

  @override
  String achAnyosDesc(String n) {
    return 'Ten cartas de $n años de salida distintos.';
  }

  @override
  String get achValor10 => 'Primeros euros';

  @override
  String get achValor50 => 'La hucha';

  @override
  String get achValor250 => 'Ahí va la paga';

  @override
  String get achValor1000 => 'Ahí va todo mi dinero';

  @override
  String get achValor5000 => 'No se lo digas a nadie';

  @override
  String get achValor10000 => 'Vale más que mi coche';

  @override
  String get achValor25000 => 'Colección de museo';

  @override
  String achValorDesc(String n) {
    return 'Que tu colección valga $n € o más.';
  }

  @override
  String get achJoya20 => 'Una carta de las buenas';

  @override
  String get achJoya100 => 'La joya de la colección';

  @override
  String get achJoya500 => 'Esta no sale de la funda';

  @override
  String get achJoya1000 => 'Mil euros en una sola funda';

  @override
  String get achJoya2500 => 'El santo grial';

  @override
  String achJoyaDesc(String n) {
    return 'Ten una sola carta que valga $n € o más.';
  }

  @override
  String get achFoils1 => 'Primer brillo';

  @override
  String get achFoils10 => 'Destellos';

  @override
  String get achFoils50 => 'Brilla la caja';

  @override
  String get achFoils200 => 'Aquí ya no hay nada mate';

  @override
  String get achFoils500 => 'Todo brilla';

  @override
  String get achFoils1000 => 'Fábrica de brillos';

  @override
  String achFoilsDesc(String n) {
    return 'Ten $n cartas foil.';
  }

  @override
  String get achFoiljoya10 => 'Foil de las buenas';

  @override
  String get achFoiljoya50 => 'Foil de las caras';

  @override
  String get achFoiljoya200 => 'Foil de museo';

  @override
  String achFoiljoyaDesc(String n) {
    return 'Ten una foil que valga $n € o más.';
  }

  @override
  String get achFoilvalor50 => 'Vitrina que brilla';

  @override
  String get achFoilvalor250 => 'Vitrina cara';

  @override
  String get achFoilvalor1000 => 'Mil euros de brillo';

  @override
  String get achFoilvalor5000 => 'Vitrina de museo';

  @override
  String achFoilvalorDesc(String n) {
    return 'Que todas tus foils juntas valgan $n € o más.';
  }

  @override
  String get achMazos1 => 'Primer mazo';

  @override
  String get achMazos5 => 'Cinco mazos guardados';

  @override
  String get achMazos25 => 'El taller no para';

  @override
  String achMazosDesc(String n) {
    return 'Guarda $n mazos hechos con Forge.';
  }

  @override
  String get achMazoscore => 'Mazo redondo';

  @override
  String get achMazoscoreDesc => 'Genera un mazo con puntuación 90 o más.';

  @override
  String get achMazocolores3 => 'Tricolor';

  @override
  String get achMazocolores5 => 'Arcoíris jugable';

  @override
  String achMazocoloresDesc(String n) {
    return 'Guarda un mazo de $n colores.';
  }

  @override
  String get achMazomono => 'Sin mezclar nada';

  @override
  String get achMazomonoDesc => 'Guarda un mazo de un solo color.';

  @override
  String get achMazocommander => 'Al mando';

  @override
  String get achMazocommanderDesc => 'Guarda un mazo de Commander.';

  @override
  String get achEscaneadas1 => 'Primer escaneo';

  @override
  String get achEscaneadas50 => 'Mano rápida';

  @override
  String get achEscaneadas500 => 'Escáner en serie';

  @override
  String get achEscaneadas2000 => 'Escaneo hasta dormido';

  @override
  String achEscaneadasDesc(String n) {
    return 'Escanea $n cartas con la cámara o por foto.';
  }

  @override
  String get achFoto9 => 'Página entera de una foto';

  @override
  String get achFoto20 => 'Veinte de una tacada';

  @override
  String achFotoDesc(String n) {
    return 'Reconoce $n cartas en una sola foto.';
  }

  @override
  String get achEscaneoperfecto => 'Ni una para revisar';

  @override
  String get achEscaneoperfectoDesc =>
      'Escanea una página entera sin que ninguna carta quede para revisar.';

  @override
  String get achDias2 => 'Has vuelto';

  @override
  String get achDias7 => 'Una semana aquí';

  @override
  String get achDias30 => 'Un mes aquí';

  @override
  String get achDias100 => 'Cien días aquí';

  @override
  String achDiasDesc(String n) {
    return 'Usa ManaForge $n días distintos.';
  }

  @override
  String get achRacha3 => 'Tres seguidos';

  @override
  String get achRacha7 => 'Semana perfecta';

  @override
  String get achRacha30 => 'Mes sin fallar';

  @override
  String achRachaDesc(String n) {
    return 'Entra $n días seguidos.';
  }

  @override
  String get achSemanas => 'Cuatro semanas sin faltar';

  @override
  String get achSemanasDesc => 'Usa ManaForge 4 semanas seguidas.';

  @override
  String get achCarpetas1 => 'Empieza el orden';

  @override
  String get achCarpetas5 => 'Todo clasificado';

  @override
  String achCarpetasDesc(String n) {
    return 'Crea $n carpetas.';
  }

  @override
  String get achCarpetagrande => 'Carpetón';

  @override
  String get achCarpetagrandeDesc => 'Ten una carpeta con 100 cartas o más.';

  @override
  String get achCarpetavalor => 'Esta carpeta no la presto';

  @override
  String get achCarpetavalorDesc => 'Ten una carpeta que valga 100 € o más.';

  @override
  String get achTierrasbasicas => 'Las cinco básicas';

  @override
  String get achTierrasbasicasDesc =>
      'Ten los cinco tipos de tierra básica (llanura, isla, pantano, montaña y bosque).';

  @override
  String get achFuerza => 'Menudo bicho';

  @override
  String get achFuerzaDesc => 'Ten una criatura de fuerza 10 o más.';

  @override
  String get achCoste => 'Esta no la lanzo en la vida';

  @override
  String get achCosteDesc => 'Ten una carta de coste convertido 10 o más.';

  @override
  String get achCostecero => 'Gratis';

  @override
  String get achCosteceroDesc => 'Ten una carta de coste 0.';

  @override
  String get achTipos => 'De todo un poco';

  @override
  String get achTiposDesc =>
      'Ten al menos una criatura, un instantáneo, un conjuro, un artefacto, un encantamiento, una tierra y un planeswalker.';

  @override
  String get achPlaneswalkers => 'Compañía de planeswalkers';

  @override
  String get achPlaneswalkersDesc => 'Ten 5 planeswalkers distintos.';

  @override
  String get achNoventas => 'Reliquia de los 90';

  @override
  String get achNoventasDesc => 'Ten una carta de los años 90.';

  @override
  String get achIdiomas1 => 'Esta no la sé leer';

  @override
  String get achIdiomas25 => 'Colección políglota';

  @override
  String get achIdiomas1Desc => 'Ten una carta en un idioma que no sea inglés.';

  @override
  String get achIdiomas25Desc => 'Ten 25 cartas en otros idiomas.';

  @override
  String get achWishlist => 'La lista de los caprichos';

  @override
  String get achWishlistDesc => 'Apunta 20 cartas en la wishlist.';

  @override
  String get achTierBronze => 'Bronce';

  @override
  String get achTierSilver => 'Plata';

  @override
  String get achTierGold => 'Oro';

  @override
  String get achTierMythic => 'Mítico';

  @override
  String get achCatCollection => 'Colección';

  @override
  String get achCatRarity => 'Rarezas';

  @override
  String get achCatColor => 'Colores';

  @override
  String get achCatSets => 'Expansiones';

  @override
  String get achCatValue => 'Valor';

  @override
  String get achCatFoils => 'Foils';

  @override
  String get achCatForge => 'Forge';

  @override
  String get achCatScanner => 'Escáner';

  @override
  String get achCatDedication => 'Dedicación';

  @override
  String get achCatFolders => 'Carpetas';

  @override
  String get achCatCuriosities => 'Curiosidades';

  @override
  String get achRankApprentice => 'Aprendiz';

  @override
  String get achRankSummoner => 'Invocador';

  @override
  String get achRankMage => 'Mago';

  @override
  String get achRankArchmage => 'Archimago';

  @override
  String get achRankMaster => 'Maestro';

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
    return 'No se pudo descargar la base de cartas (HTTP $codigo). Vuelve a intentarlo dentro de un rato.';
  }

  @override
  String dbErrHashes(String codigo) {
    return 'No se pudo descargar la base de huellas (HTTP $codigo). Vuelve a intentarlo dentro de un rato.';
  }

  @override
  String dbErrPrices(String codigo) {
    return 'No se pudo descargar el histórico de precios (HTTP $codigo). Vuelve a intentarlo dentro de un rato.';
  }

  @override
  String ddCardCount(int n) {
    return '$n cartas';
  }

  @override
  String get ddForgedWith => 'Forjado con ManaForge';

  @override
  String get fxThemeLifegain => 'drenaje de vida';

  @override
  String get fxThemeSacrifice => 'sacrificio';

  @override
  String get fxThemeSpells => 'hechizos';

  @override
  String get fxThemeArtifacts => 'artefactos';

  @override
  String get fxThemeCounters => 'contadores +1/+1';

  @override
  String get fxThemeTokens => 'enjambre';

  @override
  String get fxThemeGraveyard => 'cementerio';

  @override
  String get fxThemeReanimator => 'reanimación';

  @override
  String fxThemeTribal(String tribe) {
    return 'tribu de $tribe';
  }

  @override
  String get fxThemeGoodstuff => 'lo mejor de tus cartas';

  @override
  String get fxTagLifegain =>
      'Cada punto de vida que ganas es daño para ellos: drena y aguanta.';

  @override
  String get fxTagSacrifice =>
      'Tus criaturas valen más muertas: sacrifícalas y cobra el peaje.';

  @override
  String get fxTagSpells =>
      'Cada instantáneo cuenta: juega en el turno del rival y castiga.';

  @override
  String get fxTagArtifacts =>
      'Monta tu taller: cada artefacto hace más fuertes a los demás.';

  @override
  String get fxTagCounters =>
      'Contadores +1/+1: tus criaturas crecen hasta ser inalcanzables.';

  @override
  String get fxTagTokens =>
      'Inunda la mesa de fichas: donde ellos tienen una, tú tienes cinco.';

  @override
  String get fxTagGraveyard =>
      'Tu cementerio es tu segunda mano: llénalo y recicla lo mejor.';

  @override
  String get fxTagAggro =>
      'Sal rápido y pega a la cara: la partida debería acabar pronto.';

  @override
  String get fxTagTempo =>
      'Presiona pronto y protege la ventaja con tus hechizos.';

  @override
  String fxTagMidrange(String tema) {
    return 'Cambia bien tus cartas y gana el medio juego con $tema.';
  }

  @override
  String get fxTagControl =>
      'Aguanta, responde a todo y remata cuando la mesa sea tuya.';

  @override
  String get fxMidLifegain =>
      'Encadena tus fuentes de vida con los que castigan al rival por ello.';

  @override
  String get fxMidSacrifice =>
      'Sacrifica lo barato para robar, drenar o hacer crecer al resto.';

  @override
  String get fxMidSpells =>
      'Guarda maná abierto: tus criaturas crecen con cada hechizo que lanzas.';

  @override
  String get fxMidArtifacts =>
      'Despliega artefactos baratos y activa a los que los cuentan.';

  @override
  String get fxMidCounters =>
      'Apila contadores en una o dos criaturas y protégelas.';

  @override
  String get fxMidTokens =>
      'Genera fichas cada turno y busca los efectos que las hacen mayores.';

  @override
  String get fxMidGraveyard =>
      'Muele y descarta con intención: lo que cae al cementerio vuelve.';

  @override
  String get fxEndLifegain =>
      'Con la vida alta, cambia a modo agresivo: ellos ya no llegan.';

  @override
  String get fxEndSacrifice =>
      'El valor acumulado te da la partida: cada cambio te sale gratis.';

  @override
  String get fxEndSpells =>
      'Un par de hechizos en el mismo turno y tus criaturas cierran.';

  @override
  String get fxEndArtifacts =>
      'Tu mesa vale el doble que la suya: remata con tus payoffs.';

  @override
  String get fxEndCounters =>
      'Una amenaza enorme y protegida acaba la partida en dos golpes.';

  @override
  String get fxEndTokens =>
      'Ataca en masa: ningún bloqueo aguanta a todo tu ejército.';

  @override
  String get fxEndGraveyard =>
      'Reutiliza tus mejores cartas: juegas con dos manos contra una.';

  @override
  String get fxTurns12 => 'T1-T2';

  @override
  String get fxTurns34 => 'T3-T4';

  @override
  String get fxTurns5 => 'T5+';

  @override
  String get fxAggroEarly => 'Juega una criatura cada turno, sin excepción.';

  @override
  String get fxAggroMid =>
      'Sigue atacando; guarda el daño directo para quitar bloqueadores.';

  @override
  String get fxAggroLate => 'Remata con todo: aquí deberías cerrar la partida.';

  @override
  String get fxTempoEarly => 'Amenaza barata y maná abierto cuando puedas.';

  @override
  String get fxTempoMid => 'Ataca y usa tus hechizos en el turno del rival.';

  @override
  String get fxTempoLate =>
      'Protege tus criaturas y cierra por el aire o con daño directo.';

  @override
  String get fxMidrangeEarly =>
      'Desarrolla y no regales cartas: cambios de uno por uno buenos.';

  @override
  String fxMidrangeMid(String tema) {
    return 'Despliega tus motores de $tema y estabiliza la mesa.';
  }

  @override
  String get fxMidrangeLate =>
      'Tus cartas valen más que las suyas: conviértelo en la partida.';

  @override
  String get fxControlEarly =>
      'Tierra al turno y responde solo a lo que importa.';

  @override
  String get fxControlMid =>
      'Limpia la mesa y roba cartas: el tiempo juega para ti.';

  @override
  String get fxControlLate => 'Baja una amenaza y protégela hasta el final.';

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
    return 'Coste medio $coste: por la regla de Karsten (24 tierras a coste 3.0, ±1 por cada ±0.5), este mazo lleva $tierras tierras — dentro del rango de un mazo $arquetipo. Hay $criaturas criaturas para mantener la mesa y $interaccion cartas de interacción para lo que traiga el rival. El tema ($tema) concentra tus sinergias: cuantas más piezas del tema veas, más fuerte es cada una.';
  }

  @override
  String fxNoLandsRange(String tierras, String min, String max) {
    return 'Con esa curva salen $tierras tierras: fuera del rango sano ($min-$max). Ajusta el total de hechizos.';
  }

  @override
  String get fxNoCards =>
      'Tu colección no tiene suficientes cartas de estos colores para llenar esa curva. Prueba con menos hechizos o con otros costes.';

  @override
  String fxNoProfile(String coste, String tierras) {
    return 'Esa curva (coste medio $coste con $tierras tierras) no encaja en ningún perfil sano: un mazo barato quiere menos tierras y uno caro quiere más. Acércalos.';
  }

  @override
  String get fxNoBasics =>
      'No hay tierras básicas suficientes en la colección para esa curva.';

  @override
  String fxHardRule(String detalle) {
    return 'La curva pedida rompe una regla dura: $detalle';
  }

  @override
  String get tsPresetMonoRed =>
      'Criaturas baratas y daño a la cara: te mata en 4-5 turnos si no aguantas el ritmo.';

  @override
  String get tsPresetAzorius =>
      'Contramagia, barreduras y robo: alarga la partida y gana con pocos finalizadores.';

  @override
  String get tsPresetGolgari =>
      'Cambios de uno por uno, criaturas eficientes y removal negro: gana el juego largo por calidad de cartas.';
}
