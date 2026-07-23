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
