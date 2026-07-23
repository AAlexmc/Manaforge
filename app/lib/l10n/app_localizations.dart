import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @tabHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get tabHome;

  /// No description provided for @tabCollection.
  ///
  /// In es, this message translates to:
  /// **'Colección'**
  String get tabCollection;

  /// No description provided for @tabAlbum.
  ///
  /// In es, this message translates to:
  /// **'Álbum'**
  String get tabAlbum;

  /// No description provided for @tabDecks.
  ///
  /// In es, this message translates to:
  /// **'Mazos'**
  String get tabDecks;

  /// No description provided for @tabForge.
  ///
  /// In es, this message translates to:
  /// **'Forge'**
  String get tabForge;

  /// No description provided for @tabMarket.
  ///
  /// In es, this message translates to:
  /// **'Mercado'**
  String get tabMarket;

  /// No description provided for @tabSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get tabSettings;

  /// No description provided for @tabScan.
  ///
  /// In es, this message translates to:
  /// **'Escanear'**
  String get tabScan;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsIntro.
  ///
  /// In es, this message translates to:
  /// **'ManaForge es gratis y con el código a la vista (licencia PolyForm Noncommercial: compártela y tócala lo que quieras, pero no se vende). Sin anuncios, sin premium, sin cuentas. Tus cartas son tuyas.'**
  String get settingsIntro;

  /// No description provided for @howItWorks.
  ///
  /// In es, this message translates to:
  /// **'Cómo funciona'**
  String get howItWorks;

  /// No description provided for @howScan.
  ///
  /// In es, this message translates to:
  /// **'Pasa cartas por delante de la webcam o suelta una foto: entran solas a tu colección con su edición exacta.'**
  String get howScan;

  /// No description provided for @howCollection.
  ///
  /// In es, this message translates to:
  /// **'Todo lo que tienes, con buscador, filtros y carpetas (las carpetas son etiquetas: una carta puede estar en varias).'**
  String get howCollection;

  /// No description provided for @howAlbum.
  ///
  /// In es, this message translates to:
  /// **'Una página por expansión, estilo álbum de cromos: lo que tienes a color, lo que falta apagado, con lo que costaría completarlo.'**
  String get howAlbum;

  /// No description provided for @howForge.
  ///
  /// In es, this message translates to:
  /// **'Mazos completos y legales con tus cartas. O con las de una expansión que aún no tienes, diciéndote qué comprar y cuánto cuesta.'**
  String get howForge;

  /// No description provided for @howDecks.
  ///
  /// In es, this message translates to:
  /// **'Los que guardes. Si vendes una carta, el mazo lo dice en vez de fingir que la tienes.'**
  String get howDecks;

  /// No description provided for @howMarket.
  ///
  /// In es, this message translates to:
  /// **'Cuánto vale tu colección, su gráfica, tu lista de deseos con avisos de precio, y — si tu CSV traía precio de compra — cuánto ganas o pierdes.'**
  String get howMarket;

  /// No description provided for @howPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Todo se calcula en tu dispositivo. Lo único que sale a internet son las bases de datos y, si lo dejas puesto, mirar si hay versión nueva.'**
  String get howPrivacy;

  /// No description provided for @shortcuts.
  ///
  /// In es, this message translates to:
  /// **'Atajos de teclado'**
  String get shortcuts;

  /// No description provided for @shortcutTabs.
  ///
  /// In es, this message translates to:
  /// **'Cambiar de pestaña'**
  String get shortcutTabs;

  /// No description provided for @shortcutScan.
  ///
  /// In es, this message translates to:
  /// **'Abrir el escáner'**
  String get shortcutScan;

  /// No description provided for @shortcutSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar en la pestaña en la que estés'**
  String get shortcutSearch;

  /// No description provided for @shortcutSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get shortcutSettings;

  /// No description provided for @shortcutClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar lo que tengas abierto encima'**
  String get shortcutClose;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In es, this message translates to:
  /// **'El del sistema'**
  String get languageSystem;

  /// No description provided for @languagePartial.
  ///
  /// In es, this message translates to:
  /// **'La app se está traduciendo por partes: el armazón ya está en tu idioma y el resto de pantallas siguen en español de momento.'**
  String get languagePartial;

  /// No description provided for @versionTitle.
  ///
  /// In es, this message translates to:
  /// **'Versión de ManaForge'**
  String get versionTitle;

  /// No description provided for @versionYouHave.
  ///
  /// In es, this message translates to:
  /// **'Tienes la {version}.'**
  String versionYouHave(String version);

  /// No description provided for @versionSeeWhatsNew.
  ///
  /// In es, this message translates to:
  /// **'Ver qué trae'**
  String get versionSeeWhatsNew;

  /// No description provided for @versionNotifyMe.
  ///
  /// In es, this message translates to:
  /// **'Avisarme de versiones nuevas'**
  String get versionNotifyMe;

  /// No description provided for @versionNotifyMeWhy.
  ///
  /// In es, this message translates to:
  /// **'Pregunta una vez al día a GitHub qué versión es la última. No descarga ni instala nada.'**
  String get versionNotifyMeWhy;

  /// No description provided for @versionCheckNow.
  ///
  /// In es, this message translates to:
  /// **'Buscar ahora'**
  String get versionCheckNow;

  /// No description provided for @versionUpToDate.
  ///
  /// In es, this message translates to:
  /// **'Estás en la última versión (o GitHub no contesta ahora mismo).'**
  String get versionUpToDate;

  /// No description provided for @versionThereIs.
  ///
  /// In es, this message translates to:
  /// **'Hay ManaForge {version}.'**
  String versionThereIs(String version);

  /// No description provided for @versionGoDownload.
  ///
  /// In es, this message translates to:
  /// **'Ir a la descarga'**
  String get versionGoDownload;

  /// No description provided for @versionNotAuto.
  ///
  /// In es, this message translates to:
  /// **'Tienes la {version}. La app no se actualiza sola: te lleva a la descarga.'**
  String versionNotAuto(String version);

  /// No description provided for @versionNotNow.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get versionNotNow;

  /// No description provided for @versionSee.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get versionSee;

  /// No description provided for @whatsNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Novedades de la {version}'**
  String whatsNewTitle(String version);

  /// No description provided for @whatsNewClose.
  ///
  /// In es, this message translates to:
  /// **'A jugar'**
  String get whatsNewClose;

  /// No description provided for @downloadCopyLink.
  ///
  /// In es, this message translates to:
  /// **'Copiar enlace'**
  String get downloadCopyLink;

  /// No description provided for @downloadClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get downloadClose;

  /// No description provided for @downloadTitle.
  ///
  /// In es, this message translates to:
  /// **'Descargar ManaForge'**
  String get downloadTitle;

  /// No description provided for @backgroundTitle.
  ///
  /// In es, this message translates to:
  /// **'Fondo de pantalla'**
  String get backgroundTitle;

  /// No description provided for @backgroundWhat.
  ///
  /// In es, this message translates to:
  /// **'Pon detrás de la app la imagen que quieras. Wizards publica fondos oficiales de cada colección: bájate el que te guste y elígelo aquí. La app no se los descarga sola — ese arte tiene dueño y repartirlo no le toca.'**
  String get backgroundWhat;

  /// No description provided for @backgroundPick.
  ///
  /// In es, this message translates to:
  /// **'Elegir imagen…'**
  String get backgroundPick;

  /// No description provided for @backgroundChange.
  ///
  /// In es, this message translates to:
  /// **'Cambiar imagen…'**
  String get backgroundChange;

  /// No description provided for @backgroundOfficial.
  ///
  /// In es, this message translates to:
  /// **'Fondos oficiales de Magic'**
  String get backgroundOfficial;

  /// No description provided for @backgroundRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar fondo'**
  String get backgroundRemove;

  /// No description provided for @backgroundDim.
  ///
  /// In es, this message translates to:
  /// **'Cuánto se oscurece (para que se lea el texto)'**
  String get backgroundDim;

  /// No description provided for @backgroundCardColor.
  ///
  /// In es, this message translates to:
  /// **'Color de las tarjetas'**
  String get backgroundCardColor;

  /// No description provided for @backgroundTextColor.
  ///
  /// In es, this message translates to:
  /// **'Color de la letra'**
  String get backgroundTextColor;

  /// No description provided for @backgroundCardOpacity.
  ///
  /// In es, this message translates to:
  /// **'Cuánto tapan las tarjetas al fondo'**
  String get backgroundCardOpacity;

  /// No description provided for @backgroundColorDefault.
  ///
  /// In es, this message translates to:
  /// **'El de siempre'**
  String get backgroundColorDefault;

  /// No description provided for @backgroundPreview.
  ///
  /// In es, this message translates to:
  /// **'Así se ve'**
  String get backgroundPreview;

  /// No description provided for @backgroundNotAnImage.
  ///
  /// In es, this message translates to:
  /// **'Elige una imagen (.jpg, .png o .webp) como fondo.'**
  String get backgroundNotAnImage;

  /// No description provided for @backgroundTooBig.
  ///
  /// In es, this message translates to:
  /// **'Esa imagen es demasiado grande para usarla de fondo.'**
  String get backgroundTooBig;

  /// No description provided for @welcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a la forja. Mete tus cartas como quieras — o prueba Forge antes de meter ninguna.'**
  String get welcomeTitle;

  /// No description provided for @welcomeScan.
  ///
  /// In es, this message translates to:
  /// **'Escanear mis cartas'**
  String get welcomeScan;

  /// No description provided for @welcomeImport.
  ///
  /// In es, this message translates to:
  /// **'Importar CSV (ManaBox)'**
  String get welcomeImport;

  /// No description provided for @welcomeTryForge.
  ///
  /// In es, this message translates to:
  /// **'Probar Forge sin colección'**
  String get welcomeTryForge;

  /// No description provided for @decksEmptyGoForge.
  ///
  /// In es, this message translates to:
  /// **'Ir a Forge'**
  String get decksEmptyGoForge;

  /// No description provided for @yourCollection.
  ///
  /// In es, this message translates to:
  /// **'Tu colección'**
  String get yourCollection;

  /// No description provided for @cardsAndDistinct.
  ///
  /// In es, this message translates to:
  /// **'{copies} cartas · {distinct} distintas'**
  String cardsAndDistinct(int copies, int distinct);

  /// No description provided for @marketArrow.
  ///
  /// In es, this message translates to:
  /// **'Mercado ›'**
  String get marketArrow;

  /// No description provided for @certHeadingSetComplete.
  ///
  /// In es, this message translates to:
  /// **'CERTIFICADO DE COLECCIÓN COMPLETA'**
  String get certHeadingSetComplete;

  /// No description provided for @certSubtitleSetComplete.
  ///
  /// In es, this message translates to:
  /// **'Expansión completa'**
  String get certSubtitleSetComplete;

  /// No description provided for @certHeadingWelcome.
  ///
  /// In es, this message translates to:
  /// **'CERTIFICADO DE BIENVENIDA'**
  String get certHeadingWelcome;

  /// No description provided for @certWelcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido al mundo de Magic'**
  String get certWelcomeTitle;

  /// No description provided for @certSubtitleWelcome.
  ///
  /// In es, this message translates to:
  /// **'Tu primera carta'**
  String get certSubtitleWelcome;

  /// No description provided for @certCards.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 carta} other{{count} cartas}}'**
  String certCards(int count);

  /// No description provided for @certStartedWith.
  ///
  /// In es, this message translates to:
  /// **'Empecé con {name}'**
  String certStartedWith(String name);

  /// No description provided for @certCollectorAnon.
  ///
  /// In es, this message translates to:
  /// **'Coleccionista de ManaForge'**
  String get certCollectorAnon;

  /// No description provided for @certAwardedTo.
  ///
  /// In es, this message translates to:
  /// **'Otorgado a {name}'**
  String certAwardedTo(String name);

  /// No description provided for @certOnDate.
  ///
  /// In es, this message translates to:
  /// **'el {date}'**
  String certOnDate(String date);

  /// No description provided for @certDataBy.
  ///
  /// In es, this message translates to:
  /// **'Datos por Scryfall'**
  String get certDataBy;

  /// No description provided for @onbCollectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu colección'**
  String get onbCollectionTitle;

  /// No description provided for @onbCollectionBody.
  ///
  /// In es, this message translates to:
  /// **'Aquí viven todas tus cartas, en carpetas y por expansiones.'**
  String get onbCollectionBody;

  /// No description provided for @onbScanTitle.
  ///
  /// In es, this message translates to:
  /// **'Escanea cartas'**
  String get onbScanTitle;

  /// No description provided for @onbScanBody.
  ///
  /// In es, this message translates to:
  /// **'Añade cartas nuevas con la cámara o una foto.'**
  String get onbScanBody;

  /// No description provided for @onbForgeTitle.
  ///
  /// In es, this message translates to:
  /// **'Forja mazos'**
  String get onbForgeTitle;

  /// No description provided for @onbForgeBody.
  ///
  /// In es, this message translates to:
  /// **'Genera mazos completos con las cartas que ya tienes.'**
  String get onbForgeBody;

  /// No description provided for @onbDecksTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus mazos'**
  String get onbDecksTitle;

  /// No description provided for @onbDecksBody.
  ///
  /// In es, this message translates to:
  /// **'Los mazos que guardes desde Forge aparecen aquí.'**
  String get onbDecksBody;

  /// No description provided for @onbSkip.
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get onbSkip;

  /// No description provided for @onbNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get onbNext;

  /// No description provided for @onbGotIt.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get onbGotIt;

  /// No description provided for @onbBack.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get onbBack;

  /// No description provided for @tourMenuTitle.
  ///
  /// In es, this message translates to:
  /// **'Guías'**
  String get tourMenuTitle;

  /// No description provided for @tourWelcomeName.
  ///
  /// In es, this message translates to:
  /// **'Vuelta rápida'**
  String get tourWelcomeName;

  /// No description provided for @tourHomeName.
  ///
  /// In es, this message translates to:
  /// **'La pantalla de inicio'**
  String get tourHomeName;

  /// No description provided for @onbEditHomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu inicio'**
  String get onbEditHomeTitle;

  /// No description provided for @onbEditHomeBody.
  ///
  /// In es, this message translates to:
  /// **'Con este botón eliges qué secciones se ven en Inicio y en qué orden.'**
  String get onbEditHomeBody;

  /// No description provided for @onbLangTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get onbLangTitle;

  /// No description provided for @onbLangBody.
  ///
  /// In es, this message translates to:
  /// **'Cambia aquí el idioma de toda la app.'**
  String get onbLangBody;

  /// No description provided for @onbLookTitle.
  ///
  /// In es, this message translates to:
  /// **'Aspecto'**
  String get onbLookTitle;

  /// No description provided for @onbLookBody.
  ///
  /// In es, this message translates to:
  /// **'Pon un fondo de pantalla y elige los colores de las tarjetas, la letra, las pestañas y los iconos.'**
  String get onbLookBody;

  /// No description provided for @tourSettingsName.
  ///
  /// In es, this message translates to:
  /// **'Personalizar la app'**
  String get tourSettingsName;

  /// No description provided for @tourFullName.
  ///
  /// In es, this message translates to:
  /// **'Vuelta completa por la app'**
  String get tourFullName;

  /// No description provided for @tourCollectionName.
  ///
  /// In es, this message translates to:
  /// **'Tu colección y las carpetas'**
  String get tourCollectionName;

  /// No description provided for @tourForgeName.
  ///
  /// In es, this message translates to:
  /// **'Forjar un mazo'**
  String get tourForgeName;

  /// No description provided for @tourMarketName.
  ///
  /// In es, this message translates to:
  /// **'Mercado, wishlist y alertas'**
  String get tourMarketName;

  /// No description provided for @onbAllCardsTitle.
  ///
  /// In es, this message translates to:
  /// **'Todas las cartas'**
  String get onbAllCardsTitle;

  /// No description provided for @onbAllCardsBody.
  ///
  /// In es, this message translates to:
  /// **'Aquí está tu colección entera: buscar, filtrar y ordenar.'**
  String get onbAllCardsBody;

  /// No description provided for @onbFoldersTitle.
  ///
  /// In es, this message translates to:
  /// **'Carpetas'**
  String get onbFoldersTitle;

  /// No description provided for @onbFoldersBody.
  ///
  /// In es, this message translates to:
  /// **'Las carpetas son etiquetas: agrupan lo que quieras y una carta puede estar en varias. Con «Nueva» creas la primera.'**
  String get onbFoldersBody;

  /// No description provided for @onbAlbumMineTitle.
  ///
  /// In es, this message translates to:
  /// **'El álbum por expansiones'**
  String get onbAlbumMineTitle;

  /// No description provided for @onbAlbumMineBody.
  ///
  /// In es, this message translates to:
  /// **'Cada expansión con sus huecos. Con este filtro ves solo las expansiones donde ya tienes cartas.'**
  String get onbAlbumMineBody;

  /// No description provided for @onbForgeBasicsTitle.
  ///
  /// In es, this message translates to:
  /// **'Tierras básicas'**
  String get onbForgeBasicsTitle;

  /// No description provided for @onbForgeBasicsBody.
  ///
  /// In es, this message translates to:
  /// **'Si tienes básicas sueltas por casa, déjalo puesto: Forge contará con ellas. Quítalo para usar solo las de tu colección.'**
  String get onbForgeBasicsBody;

  /// No description provided for @onbForgeSetsTitle.
  ///
  /// In es, this message translates to:
  /// **'Expansiones'**
  String get onbForgeSetsTitle;

  /// No description provided for @onbForgeSetsBody.
  ///
  /// In es, this message translates to:
  /// **'Acota de dónde salen las cartas. Sin elegir ninguna, Forge usa toda tu colección.'**
  String get onbForgeSetsBody;

  /// No description provided for @onbForgeMissingTitle.
  ///
  /// In es, this message translates to:
  /// **'Cartas que no tengo'**
  String get onbForgeMissingTitle;

  /// No description provided for @onbForgeMissingBody.
  ///
  /// In es, this message translates to:
  /// **'Al activarlo, Forge también propone cartas que te faltan y te dice cuántas son y cuánto costarían.'**
  String get onbForgeMissingBody;

  /// No description provided for @onbForgeGoTitle.
  ///
  /// In es, this message translates to:
  /// **'Forjar'**
  String get onbForgeGoTitle;

  /// No description provided for @onbForgeGoBody.
  ///
  /// In es, this message translates to:
  /// **'Este botón hace los mazos. Con muchas expansiones tarda unos segundos.'**
  String get onbForgeGoBody;

  /// No description provided for @onbForgeTestTitle.
  ///
  /// In es, this message translates to:
  /// **'Modo Test'**
  String get onbForgeTestTitle;

  /// No description provided for @onbForgeTestBody.
  ///
  /// In es, this message translates to:
  /// **'Mide tu mazo contra uno del meta y te dice qué le falta para ganarle.'**
  String get onbForgeTestBody;

  /// No description provided for @onbMarketPickTitle.
  ///
  /// In es, this message translates to:
  /// **'Elegir mercado'**
  String get onbMarketPickTitle;

  /// No description provided for @onbMarketPickBody.
  ///
  /// In es, this message translates to:
  /// **'Cardmarket o TCGplayer: cambia el precio de cada carta y su gráfica.'**
  String get onbMarketPickBody;

  /// No description provided for @onbWishlistTitle.
  ///
  /// In es, this message translates to:
  /// **'Wishlist'**
  String get onbWishlistTitle;

  /// No description provided for @onbWishlistBody.
  ///
  /// In es, this message translates to:
  /// **'Las cartas que quieres. El contador se pone verde cuando alguna llega a tu precio.'**
  String get onbWishlistBody;

  /// No description provided for @onbPriceAlertTitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta de precio'**
  String get onbPriceAlertTitle;

  /// No description provided for @onbPriceAlertBody.
  ///
  /// In es, this message translates to:
  /// **'Busca una carta, dale al marcador para meterla en la wishlist y ponle un precio objetivo: la app te avisa cuando baje.'**
  String get onbPriceAlertBody;

  /// No description provided for @tourProgressName.
  ///
  /// In es, this message translates to:
  /// **'Logros y certificados'**
  String get tourProgressName;

  /// No description provided for @onbAchievementsTitle.
  ///
  /// In es, this message translates to:
  /// **'Logros y nivel'**
  String get onbAchievementsTitle;

  /// No description provided for @onbAchievementsBody.
  ///
  /// In es, this message translates to:
  /// **'Tu nivel y lo que llevas ganado. Sube escaneando, ordenando y forjando.'**
  String get onbAchievementsBody;

  /// No description provided for @onbCertificatesTitle.
  ///
  /// In es, this message translates to:
  /// **'Certificados'**
  String get onbCertificatesTitle;

  /// No description provided for @onbCertificatesBody.
  ///
  /// In es, this message translates to:
  /// **'Los hitos gordos salen en un diploma que puedes guardar en PDF o enseñar. Están dentro de Logros.'**
  String get onbCertificatesBody;

  /// No description provided for @onbBackupTitle.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad'**
  String get onbBackupTitle;

  /// No description provided for @onbBackupBody.
  ///
  /// In es, this message translates to:
  /// **'Guarda tu colección, mazos y carpetas en un archivo, y recupéralos si cambias de ordenador. Además se hace una copia sola cada semana.'**
  String get onbBackupBody;

  /// No description provided for @onbTapHere.
  ///
  /// In es, this message translates to:
  /// **'Pulsa aquí para abrir {pantalla}.'**
  String onbTapHere(String pantalla);

  /// No description provided for @onbAchievementsName.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get onbAchievementsName;

  /// No description provided for @onbDataSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get onbDataSectionTitle;

  /// No description provided for @onbDataSectionBody.
  ///
  /// In es, this message translates to:
  /// **'Aquí vive todo lo que la app guarda: la base de cartas y tus copias de seguridad.'**
  String get onbDataSectionBody;

  /// No description provided for @onbCardDbTitle.
  ///
  /// In es, this message translates to:
  /// **'Base de datos de cartas'**
  String get onbCardDbTitle;

  /// No description provided for @onbCardDbBody.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a descargarla para tener cartas nuevas, precios frescos y lo que pide datos recientes, como el filtro por año de Forge.'**
  String get onbCardDbBody;

  /// No description provided for @onbAboutTitle.
  ///
  /// In es, this message translates to:
  /// **'La app'**
  String get onbAboutTitle;

  /// No description provided for @onbAboutBody.
  ///
  /// In es, this message translates to:
  /// **'Qué hace cada pestaña, los atajos de teclado, la versión y la licencia.'**
  String get onbAboutBody;

  /// No description provided for @colStartHere.
  ///
  /// In es, this message translates to:
  /// **'Tu colección empieza aquí'**
  String get colStartHere;

  /// No description provided for @colNeedDb.
  ///
  /// In es, this message translates to:
  /// **'Primero necesito la base de datos con todas las cartas de Magic (se descarga una vez y luego todo funciona sin internet).'**
  String get colNeedDb;

  /// No description provided for @colDownloading.
  ///
  /// In es, this message translates to:
  /// **'Descargando… {pct} %'**
  String colDownloading(String pct);

  /// No description provided for @colDownloadDb.
  ///
  /// In es, this message translates to:
  /// **'Descargar base de datos de cartas'**
  String get colDownloadDb;

  /// No description provided for @colScryfall.
  ///
  /// In es, this message translates to:
  /// **'Datos e imágenes por Scryfall · Sin cuentas, sin pagos: todo queda en tu dispositivo.'**
  String get colScryfall;

  /// No description provided for @colAlbumTooltip.
  ///
  /// In es, this message translates to:
  /// **'Álbum por expansiones'**
  String get colAlbumTooltip;

  /// No description provided for @colImportTooltip.
  ///
  /// In es, this message translates to:
  /// **'Importar CSV de ManaBox'**
  String get colImportTooltip;

  /// No description provided for @colValueLine.
  ///
  /// In es, this message translates to:
  /// **'{copies} cartas · {distinct} distintas{valor}'**
  String colValueLine(int copies, int distinct, String valor);

  /// No description provided for @colAllCards.
  ///
  /// In es, this message translates to:
  /// **'Todas las cartas'**
  String get colAllCards;

  /// No description provided for @colAllCardsSub.
  ///
  /// In es, this message translates to:
  /// **'{distinct} distintas · buscar, filtrar y ordenar'**
  String colAllCardsSub(int distinct);

  /// No description provided for @colFolders.
  ///
  /// In es, this message translates to:
  /// **'Carpetas'**
  String get colFolders;

  /// No description provided for @colNewFolder.
  ///
  /// In es, this message translates to:
  /// **'Nueva'**
  String get colNewFolder;

  /// No description provided for @colNoFolders.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes carpetas. Sirven para agrupar lo que quieras: \"rares de Aetherdrift\", \"para vender\", \"la caja de arriba\"… Una carta puede estar en varias.'**
  String get colNoFolders;

  /// No description provided for @colCreateFirstFolder.
  ///
  /// In es, this message translates to:
  /// **'Crear la primera carpeta'**
  String get colCreateFirstFolder;

  /// No description provided for @colEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Aquí empieza tu colección'**
  String get colEmptyTitle;

  /// No description provided for @colEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Escanea tus cartas con la cámara o importa un CSV de ManaBox. Aparecerán aquí y en el álbum.'**
  String get colEmptyBody;

  /// No description provided for @colImportShort.
  ///
  /// In es, this message translates to:
  /// **'Importar CSV'**
  String get colImportShort;

  /// No description provided for @acForgetTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Ya no tienes {carta}?'**
  String acForgetTitle(String carta);

  /// No description provided for @acForgetBody.
  ///
  /// In es, this message translates to:
  /// **'Sale de tu colección y su hueco del álbum vuelve a estar vacío.'**
  String get acForgetBody;

  /// No description provided for @acForgetFolders.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{También sale de la carpeta en la que está.} other{También sale de las {n} carpetas en las que está.}}'**
  String acForgetFolders(int n);

  /// No description provided for @acForgetDecks.
  ///
  /// In es, this message translates to:
  /// **'Los mazos NO la pierden: se queda en la lista y el mazo te avisa de que te falta.'**
  String get acForgetDecks;

  /// No description provided for @acCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get acCancel;

  /// No description provided for @acForgetConfirm.
  ///
  /// In es, this message translates to:
  /// **'Ya no la tengo'**
  String get acForgetConfirm;

  /// No description provided for @acAddedOn.
  ///
  /// In es, this message translates to:
  /// **'añadida {cuando}'**
  String acAddedOn(String cuando);

  /// No description provided for @acInFolders.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{en 1 carpeta} other{en {n} carpetas}}'**
  String acInFolders(int n);

  /// No description provided for @acSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Busca una carta (español o inglés)…'**
  String get acSearchHint;

  /// No description provided for @acFilteredCount.
  ///
  /// In es, this message translates to:
  /// **'{visibles} de {total} cartas'**
  String acFilteredCount(int visibles, int total);

  /// No description provided for @acMissingFilterData.
  ///
  /// In es, this message translates to:
  /// **' · algunas cartas antiguas no tienen datos de filtro: reimporta tu CSV con \"Sustituir\" activado'**
  String get acMissingFilterData;

  /// No description provided for @acNoneMatch.
  ///
  /// In es, this message translates to:
  /// **'Ninguna carta pasa estos filtros.'**
  String get acNoneMatch;

  /// No description provided for @acEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Busca tu primera carta arriba, o vuelve atrás e importa tu CSV de ManaBox.'**
  String get acEmptyHint;

  /// No description provided for @onbHowItWorksBody.
  ///
  /// In es, this message translates to:
  /// **'El resumen de qué hace cada pestaña y los atajos de teclado. Si te pierdes, empieza por aquí.'**
  String get onbHowItWorksBody;

  /// No description provided for @onbVersionBody.
  ///
  /// In es, this message translates to:
  /// **'Qué versión tienes, qué trae, y si quieres que la app mire una vez al día si hay una nueva. No se actualiza sola.'**
  String get onbVersionBody;

  /// No description provided for @onbScanSetTitle.
  ///
  /// In es, this message translates to:
  /// **'Set: todas'**
  String get onbScanSetTitle;

  /// No description provided for @onbScanSetBody.
  ///
  /// In es, this message translates to:
  /// **'Si estás abriendo sobres de UNA expansión, fíjala aquí: el escáner deja de dudar entre las diez reimpresiones de la misma carta.'**
  String get onbScanSetBody;

  /// No description provided for @onbScanModeTitle.
  ///
  /// In es, this message translates to:
  /// **'Rápido o con cuidado'**
  String get onbScanModeTitle;

  /// No description provided for @onbScanModeBody.
  ///
  /// In es, this message translates to:
  /// **'En «Rápido» las cartas claras entran solas y las dudosas quedan marcadas para revisar. En «Con cuidado» se para y te pregunta cuál es.'**
  String get onbScanModeBody;

  /// No description provided for @onbScanPhotoTitle.
  ///
  /// In es, this message translates to:
  /// **'Escanear una foto'**
  String get onbScanPhotoTitle;

  /// No description provided for @onbScanPhotoBody.
  ///
  /// In es, this message translates to:
  /// **'¿Sin cámara, o con las cartas ya fotografiadas? Aquí sueltas una foto —con varias cartas si quieres— y las saca igual.'**
  String get onbScanPhotoBody;

  /// No description provided for @tourScanName.
  ///
  /// In es, this message translates to:
  /// **'El escáner'**
  String get tourScanName;

  /// No description provided for @albNeedDb.
  ///
  /// In es, this message translates to:
  /// **'El álbum necesita la base de datos de cartas (descárgala en Colección).'**
  String get albNeedDb;

  /// No description provided for @albRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get albRetry;

  /// No description provided for @albApproxMode.
  ///
  /// In es, this message translates to:
  /// **'Álbum en modo aproximado: aún no sé qué EDICIÓN exacta tienes de cada carta. Reimporta tu CSV con \"Sustituir mi colección actual\" activado y el álbum se afinará por ilustraciones.'**
  String get albApproxMode;

  /// No description provided for @albSearchSet.
  ///
  /// In es, this message translates to:
  /// **'Busca una expansión…'**
  String get albSearchSet;

  /// No description provided for @albOnlyMine.
  ///
  /// In es, this message translates to:
  /// **'Con cartas mías'**
  String get albOnlyMine;

  /// No description provided for @albSortProgress.
  ///
  /// In es, this message translates to:
  /// **'Más completadas'**
  String get albSortProgress;

  /// No description provided for @albSortNewest.
  ///
  /// In es, this message translates to:
  /// **'Más nuevas'**
  String get albSortNewest;

  /// No description provided for @albSortOldest.
  ///
  /// In es, this message translates to:
  /// **'Más antiguas'**
  String get albSortOldest;

  /// No description provided for @albSortName.
  ///
  /// In es, this message translates to:
  /// **'Por nombre'**
  String get albSortName;

  /// No description provided for @albYearAll.
  ///
  /// In es, this message translates to:
  /// **'Año: todos'**
  String get albYearAll;

  /// No description provided for @albLetterAll.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get albLetterAll;

  /// No description provided for @albNoSets.
  ///
  /// In es, this message translates to:
  /// **'Ninguna expansión coincide con el filtro.'**
  String get albNoSets;

  /// No description provided for @albSetProgress.
  ///
  /// In es, this message translates to:
  /// **'{owned}/{total} cartas'**
  String albSetProgress(int owned, int total);

  /// No description provided for @albComplete.
  ///
  /// In es, this message translates to:
  /// **' · ✓ ¡completa!'**
  String get albComplete;

  /// No description provided for @albLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pude cargar el set: {error}'**
  String albLoadError(String error);

  /// No description provided for @albSearchIn.
  ///
  /// In es, this message translates to:
  /// **'Buscar en {set}…'**
  String albSearchIn(String set);

  /// No description provided for @albOnlyMissing.
  ///
  /// In es, this message translates to:
  /// **'Solo las que faltan'**
  String get albOnlyMissing;

  /// No description provided for @albWithVariants.
  ///
  /// In es, this message translates to:
  /// **'Con variantes'**
  String get albWithVariants;

  /// No description provided for @albYouHaveItAll.
  ///
  /// In es, this message translates to:
  /// **'✓ Lo tienes entero'**
  String get albYouHaveItAll;

  /// No description provided for @albMissingCount.
  ///
  /// In es, this message translates to:
  /// **'Te faltan {n} · '**
  String albMissingCount(int n);

  /// No description provided for @albWithoutPrice.
  ///
  /// In es, this message translates to:
  /// **' ({n} sin precio)'**
  String albWithoutPrice(int n);

  /// No description provided for @albVisibleOf.
  ///
  /// In es, this message translates to:
  /// **'{visibles} de {total}'**
  String albVisibleOf(int visibles, int total);

  /// No description provided for @albNoCardsNamed.
  ///
  /// In es, this message translates to:
  /// **'Ninguna carta con ese nombre aquí.'**
  String get albNoCardsNamed;

  /// No description provided for @fdNewFolder.
  ///
  /// In es, this message translates to:
  /// **'Nueva carpeta'**
  String get fdNewFolder;

  /// No description provided for @fdEditFolder.
  ///
  /// In es, this message translates to:
  /// **'Editar carpeta'**
  String get fdEditFolder;

  /// No description provided for @fdName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get fdName;

  /// No description provided for @fdNameHint.
  ///
  /// In es, this message translates to:
  /// **'Rares de Aetherdrift, Para vender…'**
  String get fdNameHint;

  /// No description provided for @fdColor.
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get fdColor;

  /// No description provided for @fdIcon.
  ///
  /// In es, this message translates to:
  /// **'Icono'**
  String get fdIcon;

  /// No description provided for @fdCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get fdCreate;

  /// No description provided for @fdSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get fdSave;

  /// No description provided for @fdDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Carpeta'**
  String get fdDefaultName;

  /// No description provided for @fdDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar \"{nombre}\"?'**
  String fdDeleteTitle(String nombre);

  /// No description provided for @fdDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Se borra solo la carpeta: las cartas siguen en tu colección.'**
  String get fdDeleteBody;

  /// No description provided for @fdDelete.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get fdDelete;

  /// No description provided for @fdGone.
  ///
  /// In es, this message translates to:
  /// **'Esta carpeta ya no existe.'**
  String get fdGone;

  /// No description provided for @fdEditTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar nombre, color e icono'**
  String get fdEditTooltip;

  /// No description provided for @fdDeleteTooltip.
  ///
  /// In es, this message translates to:
  /// **'Borrar carpeta'**
  String get fdDeleteTooltip;

  /// No description provided for @fdAddRemove.
  ///
  /// In es, this message translates to:
  /// **'Añadir o quitar'**
  String get fdAddRemove;

  /// No description provided for @fdCounts.
  ///
  /// In es, this message translates to:
  /// **'{distintas} cartas distintas · {copias} copias'**
  String fdCounts(int distintas, int copias);

  /// No description provided for @fdPassFilter.
  ///
  /// In es, this message translates to:
  /// **' · {n} pasan el filtro'**
  String fdPassFilter(int n);

  /// No description provided for @fdRoughValue.
  ///
  /// In es, this message translates to:
  /// **' · valor orientativo'**
  String get fdRoughValue;

  /// No description provided for @fdMissing.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 carta ya no está en tu colección (sigue apuntada por si vuelve).} other{{n} cartas ya no están en tu colección (siguen apuntadas por si vuelven).}}'**
  String fdMissing(int n);

  /// No description provided for @fdRemoveThem.
  ///
  /// In es, this message translates to:
  /// **'Quitarlas'**
  String get fdRemoveThem;

  /// No description provided for @fdNoneMatch.
  ///
  /// In es, this message translates to:
  /// **'Ninguna carta de la carpeta pasa estos filtros.'**
  String get fdNoneMatch;

  /// No description provided for @fdEmpty.
  ///
  /// In es, this message translates to:
  /// **'Carpeta vacía. Dale a \"Añadir o quitar\" y marca las cartas que quieres meter.'**
  String get fdEmpty;

  /// No description provided for @fdCopies.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 copia} other{{n} copias}}'**
  String fdCopies(int n);

  /// No description provided for @fdRemoveFromFolder.
  ///
  /// In es, this message translates to:
  /// **'Quitar de la carpeta'**
  String get fdRemoveFromFolder;

  /// No description provided for @fpPickCards.
  ///
  /// In es, this message translates to:
  /// **'Elige las cartas'**
  String get fpPickCards;

  /// No description provided for @fpSaveCount.
  ///
  /// In es, this message translates to:
  /// **'Guardar ({n})'**
  String fpSaveCount(int n);

  /// No description provided for @fpFilterByName.
  ///
  /// In es, this message translates to:
  /// **'Filtra por nombre…'**
  String get fpFilterByName;

  /// No description provided for @fpVisibleCards.
  ///
  /// In es, this message translates to:
  /// **'{n} cartas a la vista'**
  String fpVisibleCards(int n);

  /// No description provided for @fpSelectAll.
  ///
  /// In es, this message translates to:
  /// **'Marcar todas'**
  String get fpSelectAll;

  /// No description provided for @fpNoneMatch.
  ///
  /// In es, this message translates to:
  /// **'Ninguna carta pasa estos filtros.'**
  String get fpNoneMatch;

  /// No description provided for @fgMsgReading.
  ///
  /// In es, this message translates to:
  /// **'Leyendo tu colección…'**
  String get fgMsgReading;

  /// No description provided for @fgMsgCurve.
  ///
  /// In es, this message translates to:
  /// **'Calculando la curva de maná…'**
  String get fgMsgCurve;

  /// No description provided for @fgMsgLands.
  ///
  /// In es, this message translates to:
  /// **'Repartiendo tierras…'**
  String get fgMsgLands;

  /// No description provided for @fgMsgSynergy.
  ///
  /// In es, this message translates to:
  /// **'Buscando sinergias…'**
  String get fgMsgSynergy;

  /// No description provided for @fgMsgPlan.
  ///
  /// In es, this message translates to:
  /// **'Escribiendo tu plan de juego…'**
  String get fgMsgPlan;

  /// No description provided for @fgNeedDbForSets.
  ///
  /// In es, this message translates to:
  /// **'Necesito la base de cartas para listar las expansiones: Ajustes → descargar la base.'**
  String get fgNeedDbForSets;

  /// No description provided for @fgDbError.
  ///
  /// In es, this message translates to:
  /// **'No pude leer la base de datos de cartas: {error}'**
  String fgDbError(String error);

  /// No description provided for @fgInThoseSets.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{ en esa expansión} other{ en esas {n} expansiones}}'**
  String fgInThoseSets(int n);

  /// No description provided for @fgNoCommander.
  ///
  /// In es, this message translates to:
  /// **'No me sale un Commander legal{donde}: hacen falta un comandante legendario y ~62 cartas DISTINTAS dentro de su identidad (es singleton), más básicas suficientes. Prueba otro formato, otras expansiones o amplía la colección.'**
  String fgNoCommander(String donde);

  /// No description provided for @fgNoDeck.
  ///
  /// In es, this message translates to:
  /// **'Con las cartas de este pool no me sale ningún mazo completo {formato} que cumpla mis reglas (tierras suficientes y curva sana){donde}. {consejo} Antes que darte un mazo defectuoso, prefiero avisarte.'**
  String fgNoDeck(String formato, String donde, String consejo);

  /// No description provided for @fgOf60.
  ///
  /// In es, this message translates to:
  /// **'de 60'**
  String get fgOf60;

  /// No description provided for @fgLegalIn.
  ///
  /// In es, this message translates to:
  /// **'LEGAL en {formato}'**
  String fgLegalIn(String formato);

  /// No description provided for @fgTipMoreSets.
  ///
  /// In es, this message translates to:
  /// **'Prueba con más expansiones o quita filtros.'**
  String get fgTipMoreSets;

  /// No description provided for @fgTipMoreCards.
  ///
  /// In es, this message translates to:
  /// **'Añade más cartas — sobre todo de tus colores principales — o marca \"incluir cartas que no tengo\".'**
  String get fgTipMoreCards;

  /// No description provided for @fgPitch.
  ///
  /// In es, this message translates to:
  /// **'Mazos completos y jugables con las cartas que ya tienes. Sin comprar nada.'**
  String get fgPitch;

  /// No description provided for @fgTeaserCount.
  ///
  /// In es, this message translates to:
  /// **'cartas para tu primer mazo'**
  String get fgTeaserCount;

  /// No description provided for @fgTeaserMissing.
  ///
  /// In es, this message translates to:
  /// **'Hacer un mazo con cartas que no tengo'**
  String get fgTeaserMissing;

  /// No description provided for @fgBasics.
  ///
  /// In es, this message translates to:
  /// **'Cuento con tierras básicas sueltas'**
  String get fgBasics;

  /// No description provided for @fgBasicsSub.
  ///
  /// In es, this message translates to:
  /// **'Casi todo el mundo tiene básicas de mazos de inicio; desactívalo para usar SOLO las básicas de tu colección.'**
  String get fgBasicsSub;

  /// No description provided for @fgFormat.
  ///
  /// In es, this message translates to:
  /// **'Formato de juego'**
  String get fgFormat;

  /// No description provided for @fgCasual60.
  ///
  /// In es, this message translates to:
  /// **'Casual 60'**
  String get fgCasual60;

  /// No description provided for @fgCommanderNote.
  ///
  /// In es, this message translates to:
  /// **'100 cartas · singleton · comandante legendario de tu colección · identidad de color respetada.'**
  String get fgCommanderNote;

  /// No description provided for @fgCasualNote.
  ///
  /// In es, this message translates to:
  /// **'60 cartas, sin restricción de legalidad: todo vale.'**
  String get fgCasualNote;

  /// No description provided for @fgFormatNote.
  ///
  /// In es, this message translates to:
  /// **'60 cartas usando SOLO tus cartas legales en {formato}.'**
  String fgFormatNote(String formato);

  /// No description provided for @fgWhereFrom.
  ///
  /// In es, this message translates to:
  /// **'¿De dónde salen las cartas?'**
  String get fgWhereFrom;

  /// No description provided for @fgPickSets.
  ///
  /// In es, this message translates to:
  /// **'Elegir expansiones'**
  String get fgPickSets;

  /// No description provided for @fgChangeSets.
  ///
  /// In es, this message translates to:
  /// **'Cambiar expansiones'**
  String get fgChangeSets;

  /// No description provided for @fgNeedOneSet.
  ///
  /// In es, this message translates to:
  /// **'Elige al menos una expansión: sin filtro serían las ~30.000 cartas de Magic.'**
  String get fgNeedOneSet;

  /// No description provided for @fgNoSetsNote.
  ///
  /// In es, this message translates to:
  /// **'Sin elegir expansiones, Forge usa toda tu colección.'**
  String get fgNoSetsNote;

  /// No description provided for @fgFromSetsAny.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Cartas de 1 expansión, tengas o no.} other{Cartas de {n} expansiones, tengas o no.}}'**
  String fgFromSetsAny(int n);

  /// No description provided for @fgFromSetsMine.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Solo tus cartas de 1 expansión — no toda la colección.} other{Solo tus cartas de {n} expansiones — no toda la colección.}}'**
  String fgFromSetsMine(int n);

  /// No description provided for @fgNoPrintingData.
  ///
  /// In es, this message translates to:
  /// **'Tu colección no guarda la edición de cada carta, así que filtrar por expansión dejaría fuera casi todo. Reimporta tu CSV con \"Sustituir\" y vuelve.'**
  String get fgNoPrintingData;

  /// No description provided for @fgIncludeMissing.
  ///
  /// In es, this message translates to:
  /// **'Incluir cartas que no tengo'**
  String get fgIncludeMissing;

  /// No description provided for @fgIncludeMissingSub.
  ///
  /// In es, this message translates to:
  /// **'Forge deja de limitarse a tu colección y usa TODO lo impreso en esas expansiones; luego te dice cuántas cartas te faltan y cuánto costarían.'**
  String get fgIncludeMissingSub;

  /// No description provided for @fgYourTaste.
  ///
  /// In es, this message translates to:
  /// **'A tu gusto (opcional)'**
  String get fgYourTaste;

  /// No description provided for @fgArchetypeAuto.
  ///
  /// In es, this message translates to:
  /// **'Arquetipo: auto'**
  String get fgArchetypeAuto;

  /// No description provided for @fgPricePerCard.
  ///
  /// In es, this message translates to:
  /// **'Precio por carta:'**
  String get fgPricePerCard;

  /// No description provided for @fgMin.
  ///
  /// In es, this message translates to:
  /// **'mín €'**
  String get fgMin;

  /// No description provided for @fgMax.
  ///
  /// In es, this message translates to:
  /// **'máx €'**
  String get fgMax;

  /// No description provided for @fgCardYear.
  ///
  /// In es, this message translates to:
  /// **'Año de la carta:'**
  String get fgCardYear;

  /// No description provided for @fgFrom.
  ///
  /// In es, this message translates to:
  /// **'desde'**
  String get fgFrom;

  /// No description provided for @fgTo.
  ///
  /// In es, this message translates to:
  /// **'hasta'**
  String get fgTo;

  /// No description provided for @fgYearNeedsDb.
  ///
  /// In es, this message translates to:
  /// **'El filtro por año necesita la base de datos actualizada: Ajustes → Volver a descargar la base de datos.'**
  String get fgYearNeedsDb;

  /// No description provided for @fgNoColorsNote.
  ///
  /// In es, this message translates to:
  /// **'Sin elegir colores, Forge prueba todas las combinaciones.'**
  String get fgNoColorsNote;

  /// No description provided for @fgColorsNote.
  ///
  /// In es, this message translates to:
  /// **'Solo mazos {colores} (y sus combinaciones).'**
  String fgColorsNote(String colores);

  /// No description provided for @fgMissingNote.
  ///
  /// In es, this message translates to:
  /// **'Este mazo puede llevar cartas que NO tienes: cada propuesta dice cuántas te faltan y lo que costarían (precio de Cardmarket).'**
  String get fgMissingNote;

  /// No description provided for @fgOnlyYoursNote.
  ///
  /// In es, this message translates to:
  /// **'Forge solo usa tus {n} cartas. Nunca inventa copias que no tienes.'**
  String fgOnlyYoursNote(int n);

  /// No description provided for @fgForgeMissing.
  ///
  /// In es, this message translates to:
  /// **'Forjar mazos (con lo que me falte)'**
  String get fgForgeMissing;

  /// No description provided for @fgForgeMine.
  ///
  /// In es, this message translates to:
  /// **'Forjar mis mazos'**
  String get fgForgeMine;

  /// No description provided for @fgTestMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Test: vence a un mazo del meta'**
  String get fgTestMode;

  /// No description provided for @fgOffline.
  ///
  /// In es, this message translates to:
  /// **'Todo se calcula en tu dispositivo, sin internet'**
  String get fgOffline;

  /// No description provided for @fgForgingWith.
  ///
  /// In es, this message translates to:
  /// **'Estás forjando con {n} cartas: esto tarda unos segundos. La ventana sigue viva.'**
  String fgForgingWith(int n);

  /// No description provided for @fgDecksReady.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 mazo listo para jugar} other{{n} mazos listos para jugar}}'**
  String fgDecksReady(int n);

  /// No description provided for @fgSwipeMissing.
  ///
  /// In es, this message translates to:
  /// **'Con cartas que aún no tienes · desliza para comparar'**
  String get fgSwipeMissing;

  /// No description provided for @fgSwipeMine.
  ///
  /// In es, this message translates to:
  /// **'Hechos solo con tus cartas · desliza para comparar'**
  String get fgSwipeMine;

  /// No description provided for @fgHaveAll.
  ///
  /// In es, this message translates to:
  /// **'✓ Tienes todas las cartas'**
  String get fgHaveAll;

  /// No description provided for @fgShortfall.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Te falta 1 carta} other{Te faltan {n} cartas}}'**
  String fgShortfall(int n);

  /// No description provided for @fgSeeDeck.
  ///
  /// In es, this message translates to:
  /// **'Ver mazo completo'**
  String get fgSeeDeck;

  /// No description provided for @fgReforge.
  ///
  /// In es, this message translates to:
  /// **'Reforjar'**
  String get fgReforge;

  /// No description provided for @mkAlertOne.
  ///
  /// In es, this message translates to:
  /// **'🔔 ¡{carta} está a {precio} (tu objetivo: {objetivo})!'**
  String mkAlertOne(String carta, String precio, String objetivo);

  /// No description provided for @mkAlertMany.
  ///
  /// In es, this message translates to:
  /// **'🔔 ¡{n} cartas de tu wishlist han caído a su precio objetivo!'**
  String mkAlertMany(int n);

  /// No description provided for @mkTellMeWhenDrops.
  ///
  /// In es, this message translates to:
  /// **'Avísame cuando baje'**
  String get mkTellMeWhenDrops;

  /// No description provided for @mkTargetPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio objetivo'**
  String get mkTargetPrice;

  /// No description provided for @mkNow.
  ///
  /// In es, this message translates to:
  /// **'Ahora: {precio}'**
  String mkNow(String precio);

  /// No description provided for @mkUpdated.
  ///
  /// In es, this message translates to:
  /// **'✓ Precios y cartas actualizados'**
  String get mkUpdated;

  /// No description provided for @mkUpdateFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude actualizar: {error}'**
  String mkUpdateFailed(String error);

  /// No description provided for @mkHistoryReady.
  ///
  /// In es, this message translates to:
  /// **'✓ Histórico de precios listo: las gráficas ya enseñan los últimos meses'**
  String get mkHistoryReady;

  /// No description provided for @mkHistoryFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude traer el histórico (el que ya tenías sigue intacto): {error}'**
  String mkHistoryFailed(String error);

  /// No description provided for @mkHistoryLocal.
  ///
  /// In es, this message translates to:
  /// **'Histórico de precios: solo el que ManaForge apunta a diario en tu equipo. Tráete los últimos ~90 días reales de Cardmarket (≈4 MB).'**
  String get mkHistoryLocal;

  /// No description provided for @mkHistoryReal.
  ///
  /// In es, this message translates to:
  /// **'Histórico real de Cardmarket del {desde} al {hasta}, y desde ahí lo que apunta ManaForge.'**
  String mkHistoryReal(String desde, String hasta);

  /// No description provided for @mkFetchHistory.
  ///
  /// In es, this message translates to:
  /// **'Traer histórico'**
  String get mkFetchHistory;

  /// No description provided for @mkCollectionValue.
  ///
  /// In es, this message translates to:
  /// **'Valor de tu colección · Cardmarket'**
  String get mkCollectionValue;

  /// No description provided for @mkCardsCount.
  ///
  /// In es, this message translates to:
  /// **'{n} cartas'**
  String mkCardsCount(int n);

  /// No description provided for @mkApproxSuffix.
  ///
  /// In es, this message translates to:
  /// **' · valor orientativo'**
  String get mkApproxSuffix;

  /// No description provided for @mkBulkPrices.
  ///
  /// In es, this message translates to:
  /// **'Precios Cardmarket del {fecha} (Scryfall)'**
  String mkBulkPrices(String fecha);

  /// No description provided for @mkNoData.
  ///
  /// In es, this message translates to:
  /// **'Mercado sin datos: descarga la base de datos en Colección. ({error})'**
  String mkNoData(String error);

  /// No description provided for @mkSetsHeader.
  ///
  /// In es, this message translates to:
  /// **'EXPANSIONES ({n})'**
  String mkSetsHeader(int n);

  /// No description provided for @mkPrevious.
  ///
  /// In es, this message translates to:
  /// **'Anteriores'**
  String get mkPrevious;

  /// No description provided for @mkNext.
  ///
  /// In es, this message translates to:
  /// **'Siguientes'**
  String get mkNext;

  /// No description provided for @mkSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Busca el precio de cualquier carta…'**
  String get mkSearchHint;

  /// No description provided for @mkRemoveFromWishlist.
  ///
  /// In es, this message translates to:
  /// **'Quitar de la wishlist'**
  String get mkRemoveFromWishlist;

  /// No description provided for @mkAddToWishlist.
  ///
  /// In es, this message translates to:
  /// **'A la wishlist: avísame cuando baje'**
  String get mkAddToWishlist;

  /// No description provided for @mkYourWishlist.
  ///
  /// In es, this message translates to:
  /// **'TU WISHLIST'**
  String get mkYourWishlist;

  /// No description provided for @mkTargetAtMost.
  ///
  /// In es, this message translates to:
  /// **'objetivo ≤ {precio}'**
  String mkTargetAtMost(String precio);

  /// No description provided for @mkAtPrice.
  ///
  /// In es, this message translates to:
  /// **'¡a precio!'**
  String get mkAtPrice;

  /// No description provided for @mkChangeTarget.
  ///
  /// In es, this message translates to:
  /// **'Cambiar precio objetivo'**
  String get mkChangeTarget;

  /// No description provided for @mkTopCards.
  ///
  /// In es, this message translates to:
  /// **'TUS CARTAS MÁS VALIOSAS'**
  String get mkTopCards;

  /// No description provided for @mkImportToSeeValue.
  ///
  /// In es, this message translates to:
  /// **'Importa tu colección para ver su valor.'**
  String get mkImportToSeeValue;

  /// No description provided for @mkSetCards.
  ///
  /// In es, this message translates to:
  /// **' · {n} cartas'**
  String mkSetCards(int n);

  /// No description provided for @wlEmpty.
  ///
  /// In es, this message translates to:
  /// **'Búscalas en Mercado y toca el marcador para que te avise cuando bajen a tu precio.'**
  String get wlEmpty;

  /// No description provided for @wlAtPriceCount.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{🔔 1 carta de tu wishlist está a tu precio objetivo o por debajo.} other{🔔 {n} cartas de tu wishlist están a tu precio objetivo o por debajo.}}'**
  String wlAtPriceCount(int n);

  /// No description provided for @mpMtgoTix.
  ///
  /// In es, this message translates to:
  /// **'Precios de MTGO en tix (cartas digitales)'**
  String get mpMtgoTix;

  /// No description provided for @mpNoDataYet.
  ///
  /// In es, this message translates to:
  /// **'Sin datos todavía: actualiza el histórico de precios en Mercado'**
  String get mpNoDataYet;

  /// No description provided for @mpMtgoNote.
  ///
  /// In es, this message translates to:
  /// **'Precios de MTGO en tix: son cartas digitales, no valen para tasar tu colección de papel. Inicio, carpetas y logros siguen en Cardmarket (€).'**
  String get mpMtgoNote;

  /// No description provided for @mpMarketNote.
  ///
  /// In es, this message translates to:
  /// **'Precios de {mercado} en {moneda}. Inicio, carpetas y logros siguen valorando en Cardmarket (€): las divisas no se convierten.'**
  String mpMarketNote(String mercado, String moneda);

  /// No description provided for @mkUpdate.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get mkUpdate;

  /// No description provided for @mkApproxValue.
  ///
  /// In es, this message translates to:
  /// **' · valor aproximado (reimporta con \"Sustituir\" para precios por edición)'**
  String get mkApproxValue;

  /// No description provided for @mkExactPrintings.
  ///
  /// In es, this message translates to:
  /// **' · por tus ediciones exactas'**
  String get mkExactPrintings;

  /// No description provided for @mkNowSuffix.
  ///
  /// In es, this message translates to:
  /// **' · ahora {precio}'**
  String mkNowSuffix(String precio);

  /// No description provided for @wlNothingYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes cartas en la wishlist.'**
  String get wlNothingYet;

  /// No description provided for @stDbUpdated.
  ///
  /// In es, this message translates to:
  /// **'✓ Base de datos actualizada'**
  String get stDbUpdated;

  /// No description provided for @stUpdateFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar: {error}'**
  String stUpdateFailed(String error);

  /// No description provided for @stCardDb.
  ///
  /// In es, this message translates to:
  /// **'Base de datos de cartas'**
  String get stCardDb;

  /// No description provided for @stCardDbWhy.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a descargarla para tener cartas nuevas, precios frescos y las funciones que piden datos recientes (como el filtro por año en Forge).'**
  String get stCardDbWhy;

  /// No description provided for @stDownloadDbAgain.
  ///
  /// In es, this message translates to:
  /// **'Volver a descargar la base de datos'**
  String get stDownloadDbAgain;

  /// No description provided for @stAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get stAppearance;

  /// No description provided for @stData.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get stData;

  /// No description provided for @stTheApp.
  ///
  /// In es, this message translates to:
  /// **'La app'**
  String get stTheApp;

  /// No description provided for @stCredits.
  ///
  /// In es, this message translates to:
  /// **'Datos e imágenes de cartas por Scryfall. Magic: The Gathering es propiedad de Wizards of the Coast; proyecto de fans al amparo de su Fan Content Policy.'**
  String get stCredits;

  /// No description provided for @stEditHome.
  ///
  /// In es, this message translates to:
  /// **'Editar inicio'**
  String get stEditHome;

  /// No description provided for @stEditHomeSub.
  ///
  /// In es, this message translates to:
  /// **'Elige qué secciones se ven y en qué orden'**
  String get stEditHomeSub;

  /// No description provided for @ehLevel.
  ///
  /// In es, this message translates to:
  /// **'Tu nivel'**
  String get ehLevel;

  /// No description provided for @ehShortcuts.
  ///
  /// In es, this message translates to:
  /// **'Accesos rápidos'**
  String get ehShortcuts;

  /// No description provided for @ehSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen de la colección'**
  String get ehSummary;

  /// No description provided for @ehRecent.
  ///
  /// In es, this message translates to:
  /// **'Vistas recientemente'**
  String get ehRecent;

  /// No description provided for @ehDecks.
  ///
  /// In es, this message translates to:
  /// **'Tus mazos'**
  String get ehDecks;

  /// No description provided for @ehMeta.
  ///
  /// In es, this message translates to:
  /// **'El meta ahora'**
  String get ehMeta;

  /// No description provided for @ehNewSets.
  ///
  /// In es, this message translates to:
  /// **'Expansiones nuevas'**
  String get ehNewSets;

  /// No description provided for @ehGems.
  ///
  /// In es, this message translates to:
  /// **'Tus joyas'**
  String get ehGems;

  /// No description provided for @ehHelp.
  ///
  /// In es, this message translates to:
  /// **'Arrastra para ordenar y usa el interruptor para elegir qué ves en Inicio. Una sección encendida solo sale si tiene algo que enseñar.'**
  String get ehHelp;

  /// No description provided for @ehSection.
  ///
  /// In es, this message translates to:
  /// **'Sección'**
  String get ehSection;

  /// No description provided for @bkNoData.
  ///
  /// In es, this message translates to:
  /// **'No encuentro tus datos.'**
  String get bkNoData;

  /// No description provided for @bkSaved.
  ///
  /// In es, this message translates to:
  /// **'✓ Copia guardada · {resumen}'**
  String bkSaved(String resumen);

  /// No description provided for @bkSaveFailed.
  ///
  /// In es, this message translates to:
  /// **'No he podido guardarla: {error}'**
  String bkSaveFailed(String error);

  /// No description provided for @bkFileName.
  ///
  /// In es, this message translates to:
  /// **'Copia de ManaForge'**
  String get bkFileName;

  /// No description provided for @bkRestoreFailed.
  ///
  /// In es, this message translates to:
  /// **'No he podido restaurarla: {error}'**
  String bkRestoreFailed(String error);

  /// No description provided for @bkRestoredNoPrevious.
  ///
  /// In es, this message translates to:
  /// **'✓ Restaurado · {resumen}. OJO: no he podido guardar lo que tenías antes ({error}).'**
  String bkRestoredNoPrevious(String resumen, String error);

  /// No description provided for @bkRestored.
  ///
  /// In es, this message translates to:
  /// **'✓ Restaurado · {resumen}. Lo que tenías antes está guardado en la carpeta backups.'**
  String bkRestored(String resumen);

  /// No description provided for @bkRestoring.
  ///
  /// In es, this message translates to:
  /// **'Restaurando tu copia…'**
  String get bkRestoring;

  /// No description provided for @bkTitle.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad'**
  String get bkTitle;

  /// No description provided for @bkWhy.
  ///
  /// In es, this message translates to:
  /// **'Tus cartas, mazos, carpetas y logros viven solo en este ordenador. Guarda una copia de vez en cuando y déjala en otro sitio: un disco, la nube, lo que quieras.'**
  String get bkWhy;

  /// No description provided for @bkSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar copia'**
  String get bkSave;

  /// No description provided for @bkRestoreTitle.
  ///
  /// In es, this message translates to:
  /// **'Restaurar una copia'**
  String get bkRestoreTitle;

  /// No description provided for @bkRestoreWarning.
  ///
  /// In es, this message translates to:
  /// **'Restaurar REEMPLAZA tus cartas, mazos, carpetas y logros de ahora por los de la copia. Elige cuál, dale al botón y escribe CONFIRMAR: así no se restaura nada sin querer.'**
  String get bkRestoreWarning;

  /// No description provided for @bkNoBackups.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay copias guardadas en este ordenador.'**
  String get bkNoBackups;

  /// No description provided for @bkWhich.
  ///
  /// In es, this message translates to:
  /// **'Copia a restaurar'**
  String get bkWhich;

  /// No description provided for @bkPickOne.
  ///
  /// In es, this message translates to:
  /// **'Elige una copia'**
  String get bkPickOne;

  /// No description provided for @bkRestorePicked.
  ///
  /// In es, this message translates to:
  /// **'Restaurar la copia elegida'**
  String get bkRestorePicked;

  /// No description provided for @bkAutoNote.
  ///
  /// In es, this message translates to:
  /// **'Guardo una copia automática cada semana (las cinco últimas) y otra justo antes de cada restaurar.'**
  String get bkAutoNote;

  /// No description provided for @bkFromFile.
  ///
  /// In es, this message translates to:
  /// **'Restaurar de un archivo'**
  String get bkFromFile;

  /// No description provided for @bkConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Restaurar esta copia?'**
  String get bkConfirmTitle;

  /// No description provided for @bkConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'Esto reemplaza tu colección, mazos, carpetas y logros de ahora por los de esa copia. Antes de hacerlo guardo lo que tienes en la carpeta backups, por si quieres volver.'**
  String get bkConfirmBody;

  /// No description provided for @bkWillDelete.
  ///
  /// In es, this message translates to:
  /// **'Esa copia no trae {cosas}: al restaurarla, eso se borra.'**
  String bkWillDelete(String cosas);

  /// No description provided for @bkTypeToConfirm.
  ///
  /// In es, this message translates to:
  /// **'Escribe {palabra} para poder seguir:'**
  String bkTypeToConfirm(String palabra);

  /// No description provided for @bkAnd.
  ///
  /// In es, this message translates to:
  /// **' y '**
  String get bkAnd;

  /// No description provided for @ehReset.
  ///
  /// In es, this message translates to:
  /// **'Restablecer'**
  String get ehReset;

  /// No description provided for @bkOfDate.
  ///
  /// In es, this message translates to:
  /// **'Copia del {cuando} · {resumen}.'**
  String bkOfDate(String cuando, String resumen);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ja',
        'ko',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
