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
}
