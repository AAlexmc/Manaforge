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
    Locale('zh'),
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

  /// No description provided for @onbForgeDeepTitle.
  ///
  /// In es, this message translates to:
  /// **'Forja profunda'**
  String get onbForgeDeepTitle;

  /// No description provided for @onbForgeDeepBody.
  ///
  /// In es, this message translates to:
  /// **'Antes de enseñarte las propuestas, las hace jugar entre sí de verdad: el orden final pesa cómo rinden, no solo su score estático. Puedes apagarlo si prefieres resultados más rápidos.'**
  String get onbForgeDeepBody;

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

  /// No description provided for @acDelete.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get acDelete;

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

  /// No description provided for @onbSuggestionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Buzón de sugerencias'**
  String get onbSuggestionsTitle;

  /// No description provided for @onbSuggestionsBody.
  ///
  /// In es, this message translates to:
  /// **'¿Se te ocurre algo, o has visto un fallo? Cuéntalo en GitHub: hay plantilla y se rellena en un minuto.'**
  String get onbSuggestionsBody;

  /// No description provided for @onbSupportTitle.
  ///
  /// In es, this message translates to:
  /// **'Apoyar el proyecto'**
  String get onbSupportTitle;

  /// No description provided for @onbSupportBody.
  ///
  /// In es, this message translates to:
  /// **'La app es gratis y sin anuncios. Si te ha servido, aquí se explica cómo invitarnos a un café.'**
  String get onbSupportBody;

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

  /// No description provided for @albMarketNoToday.
  ///
  /// In es, this message translates to:
  /// **'{market} no publica precios por edición — cambia de mercado para verlos'**
  String albMarketNoToday(String market);

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

  /// No description provided for @fgNoDeckStyle.
  ///
  /// In es, this message translates to:
  /// **'Con este Estilo ({estilo}) no sale mazo. Prueba «Estilo: auto» u otra tribu.'**
  String fgNoDeckStyle(String estilo);

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

  /// No description provided for @fgStyle.
  ///
  /// In es, this message translates to:
  /// **'Estilo'**
  String get fgStyle;

  /// No description provided for @fgStyleAuto.
  ///
  /// In es, this message translates to:
  /// **'Estilo: auto'**
  String get fgStyleAuto;

  /// No description provided for @fgTribeElf.
  ///
  /// In es, this message translates to:
  /// **'Elfos'**
  String get fgTribeElf;

  /// No description provided for @fgTribeGoblin.
  ///
  /// In es, this message translates to:
  /// **'Trasgos'**
  String get fgTribeGoblin;

  /// No description provided for @fgTribeZombie.
  ///
  /// In es, this message translates to:
  /// **'Zombis'**
  String get fgTribeZombie;

  /// No description provided for @fgTribeVampire.
  ///
  /// In es, this message translates to:
  /// **'Vampiros'**
  String get fgTribeVampire;

  /// No description provided for @fgTribeDragon.
  ///
  /// In es, this message translates to:
  /// **'Dragones'**
  String get fgTribeDragon;

  /// No description provided for @fgTribeAngel.
  ///
  /// In es, this message translates to:
  /// **'Ángeles'**
  String get fgTribeAngel;

  /// No description provided for @fgTribeDemon.
  ///
  /// In es, this message translates to:
  /// **'Demonios'**
  String get fgTribeDemon;

  /// No description provided for @fgTribeDinosaur.
  ///
  /// In es, this message translates to:
  /// **'Dinosaurios'**
  String get fgTribeDinosaur;

  /// No description provided for @fgTribeFaerie.
  ///
  /// In es, this message translates to:
  /// **'Hadas'**
  String get fgTribeFaerie;

  /// No description provided for @fgTribeMerfolk.
  ///
  /// In es, this message translates to:
  /// **'Tritones'**
  String get fgTribeMerfolk;

  /// No description provided for @fgTribeHuman.
  ///
  /// In es, this message translates to:
  /// **'Humanos'**
  String get fgTribeHuman;

  /// No description provided for @fgTribeSpirit.
  ///
  /// In es, this message translates to:
  /// **'Espíritus'**
  String get fgTribeSpirit;

  /// No description provided for @fgTribeSliver.
  ///
  /// In es, this message translates to:
  /// **'Astillas'**
  String get fgTribeSliver;

  /// No description provided for @fgTribeWizard.
  ///
  /// In es, this message translates to:
  /// **'Magos'**
  String get fgTribeWizard;

  /// No description provided for @fgTribeKnight.
  ///
  /// In es, this message translates to:
  /// **'Caballeros'**
  String get fgTribeKnight;

  /// No description provided for @fgTribeWarrior.
  ///
  /// In es, this message translates to:
  /// **'Guerreros'**
  String get fgTribeWarrior;

  /// No description provided for @fgTribeSoldier.
  ///
  /// In es, this message translates to:
  /// **'Soldados'**
  String get fgTribeSoldier;

  /// No description provided for @fgTribeCat.
  ///
  /// In es, this message translates to:
  /// **'Gatos'**
  String get fgTribeCat;

  /// No description provided for @fgTribeDog.
  ///
  /// In es, this message translates to:
  /// **'Perros'**
  String get fgTribeDog;

  /// No description provided for @fgTribeRat.
  ///
  /// In es, this message translates to:
  /// **'Ratas'**
  String get fgTribeRat;

  /// No description provided for @fgTribePirate.
  ///
  /// In es, this message translates to:
  /// **'Piratas'**
  String get fgTribePirate;

  /// No description provided for @fgTribeElemental.
  ///
  /// In es, this message translates to:
  /// **'Elementales'**
  String get fgTribeElemental;

  /// No description provided for @fgTribeGiant.
  ///
  /// In es, this message translates to:
  /// **'Gigantes'**
  String get fgTribeGiant;

  /// No description provided for @fgTribeRogue.
  ///
  /// In es, this message translates to:
  /// **'Pícaros'**
  String get fgTribeRogue;

  /// No description provided for @fgDeepForge.
  ///
  /// In es, this message translates to:
  /// **'Forja profunda'**
  String get fgDeepForge;

  /// No description provided for @fgDeepForgeHint.
  ///
  /// In es, this message translates to:
  /// **'Antes de enseñarte las propuestas, las hace jugar entre sí de verdad (te cuesta un poco más de espera).'**
  String get fgDeepForgeHint;

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

  /// No description provided for @fgBackToOptions.
  ///
  /// In es, this message translates to:
  /// **'Volver a elegir cómo forjar'**
  String get fgBackToOptions;

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

  /// No description provided for @mkNoPriceIn.
  ///
  /// In es, this message translates to:
  /// **'sin precio en {market}'**
  String mkNoPriceIn(String market);

  /// No description provided for @mkPerUnit.
  ///
  /// In es, this message translates to:
  /// **'/ud'**
  String get mkPerUnit;

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

  /// No description provided for @stSuggestions.
  ///
  /// In es, this message translates to:
  /// **'Buzón de sugerencias'**
  String get stSuggestions;

  /// No description provided for @stSuggestionsSub.
  ///
  /// In es, this message translates to:
  /// **'¿Una idea o un fallo? Cuéntalo en GitHub — hay plantilla y se rellena en un minuto.'**
  String get stSuggestionsSub;

  /// No description provided for @stDonate.
  ///
  /// In es, this message translates to:
  /// **'Apoyar el proyecto'**
  String get stDonate;

  /// No description provided for @stDonateSub.
  ///
  /// In es, this message translates to:
  /// **'La app es gratis y sin anuncios. Si te sirve y quieres invitar a un café, aquí se explica cómo.'**
  String get stDonateSub;

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

  /// No description provided for @ehStatCards.
  ///
  /// In es, this message translates to:
  /// **'cartas'**
  String get ehStatCards;

  /// No description provided for @ehStatDistinct.
  ///
  /// In es, this message translates to:
  /// **'distintas'**
  String get ehStatDistinct;

  /// No description provided for @ehStatValue.
  ///
  /// In es, this message translates to:
  /// **'valor'**
  String get ehStatValue;

  /// No description provided for @ehStatDecks.
  ///
  /// In es, this message translates to:
  /// **'mazos'**
  String get ehStatDecks;

  /// No description provided for @ehStatAchievements.
  ///
  /// In es, this message translates to:
  /// **'logros'**
  String get ehStatAchievements;

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
  /// **'Restaurar REEMPLAZA tus cartas, mazos, carpetas y logros de ahora por los de la copia. Elige cuál, dale al botón y escribe {palabra}: así no se restaura nada sin querer.'**
  String bkRestoreWarning(String palabra);

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

  /// No description provided for @lsMacUsePhoto.
  ///
  /// In es, this message translates to:
  /// **'La cámara en vivo aún no está disponible en macOS. Usa «Escanear desde foto»: funciona igual de bien.'**
  String get lsMacUsePhoto;

  /// No description provided for @lsNoCamera.
  ///
  /// In es, this message translates to:
  /// **'No encuentro ninguna cámara.'**
  String get lsNoCamera;

  /// No description provided for @lsCameraGone.
  ///
  /// In es, this message translates to:
  /// **'La cámara se ha desconectado a media sesión. Revisa el cable y dale a Reintentar.'**
  String get lsCameraGone;

  /// No description provided for @lsFrameCard.
  ///
  /// In es, this message translates to:
  /// **'Encuadra la carta dentro del marco'**
  String get lsFrameCard;

  /// No description provided for @lsNoCardThere.
  ///
  /// In es, this message translates to:
  /// **'No veo ninguna carta ahí'**
  String get lsNoCardThere;

  /// No description provided for @lsAddedToCollection.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{✓ 1 carta a la colección} other{✓ {n} cartas a la colección}}'**
  String lsAddedToCollection(int n);

  /// No description provided for @lsAndToFolder.
  ///
  /// In es, this message translates to:
  /// **', y a \"{carpeta}\"'**
  String lsAndToFolder(String carpeta);

  /// No description provided for @lsTitle.
  ///
  /// In es, this message translates to:
  /// **'Escanear en vivo'**
  String get lsTitle;

  /// No description provided for @lsQuickTip.
  ///
  /// In es, this message translates to:
  /// **'Rápido: las cartas claras entran solas; las dudosas, marcadas para revisar.'**
  String get lsQuickTip;

  /// No description provided for @lsCarefulTip.
  ///
  /// In es, this message translates to:
  /// **'Con cuidado: las dudosas se paran y te preguntan cuál es.'**
  String get lsCarefulTip;

  /// No description provided for @lsQuick.
  ///
  /// In es, this message translates to:
  /// **'Rápido'**
  String get lsQuick;

  /// No description provided for @lsCareful.
  ///
  /// In es, this message translates to:
  /// **'Con cuidado'**
  String get lsCareful;

  /// No description provided for @lsThisSession.
  ///
  /// In es, this message translates to:
  /// **'{n} esta sesión'**
  String lsThisSession(int n);

  /// No description provided for @lsScanPhotoTooltip.
  ///
  /// In es, this message translates to:
  /// **'Escanear una foto suelta'**
  String get lsScanPhotoTooltip;

  /// No description provided for @lsStartingCamera.
  ///
  /// In es, this message translates to:
  /// **'Encendiendo la cámara…'**
  String get lsStartingCamera;

  /// No description provided for @lsCantUseCamera.
  ///
  /// In es, this message translates to:
  /// **'No puedo usar la cámara'**
  String get lsCantUseCamera;

  /// No description provided for @lsCameraUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Cámara no disponible.'**
  String get lsCameraUnavailable;

  /// No description provided for @lsScanPhoto.
  ///
  /// In es, this message translates to:
  /// **'Escanear una foto'**
  String get lsScanPhoto;

  /// No description provided for @lsPlusOneSame.
  ///
  /// In es, this message translates to:
  /// **'+1 igual · {carta} (×{n})'**
  String lsPlusOneSame(String carta, int n);

  /// No description provided for @lsAlreadyOnTable.
  ///
  /// In es, this message translates to:
  /// **'Ya está en la mesa: {carta} · retírala y vuelve a ponerla, o toca \"+1 igual\"'**
  String lsAlreadyOnTable(String carta);

  /// No description provided for @lsSeeing.
  ///
  /// In es, this message translates to:
  /// **'Viendo: {carta}'**
  String lsSeeing(String carta);

  /// No description provided for @lsPassACard.
  ///
  /// In es, this message translates to:
  /// **'Pasa una carta por delante de la cámara…'**
  String get lsPassACard;

  /// No description provided for @lsIsThis.
  ///
  /// In es, this message translates to:
  /// **'¿Es {carta}? No estoy seguro — toca para elegir.'**
  String lsIsThis(String carta);

  /// No description provided for @lsNotThisOne.
  ///
  /// In es, this message translates to:
  /// **'No es esta — cambiar versión'**
  String get lsNotThisOne;

  /// No description provided for @lsRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get lsRetry;

  /// No description provided for @scBadImage.
  ///
  /// In es, this message translates to:
  /// **'No pude leer esa imagen (¿es una foto válida?)'**
  String get scBadImage;

  /// No description provided for @scAddedOne.
  ///
  /// In es, this message translates to:
  /// **'✓ {carta} ({set} #{numero})'**
  String scAddedOne(String carta, String set, String numero);

  /// No description provided for @scNoFolder.
  ///
  /// In es, this message translates to:
  /// **'Sin carpeta'**
  String get scNoFolder;

  /// No description provided for @scAlsoTo.
  ///
  /// In es, this message translates to:
  /// **'Y además a: {carpeta}'**
  String scAlsoTo(String carpeta);

  /// No description provided for @scLookingForCard.
  ///
  /// In es, this message translates to:
  /// **'Buscando la carta en la foto…'**
  String get scLookingForCard;

  /// No description provided for @scRecognising.
  ///
  /// In es, this message translates to:
  /// **'Reconociendo… {hechas}/{total}'**
  String scRecognising(int hechas, int total);

  /// No description provided for @scTrayCount.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 carta}other{{n} cartas}} · {copias} en total'**
  String scTrayCount(int n, int copias);

  /// No description provided for @scToReview.
  ///
  /// In es, this message translates to:
  /// **'{n} para revisar (tócalas)'**
  String scToReview(int n);

  /// No description provided for @scUnknown.
  ///
  /// In es, this message translates to:
  /// **'{n} sin reconocer (toca para elegir a mano)'**
  String scUnknown(int n);

  /// No description provided for @scSkipped.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 foto saltada (demasiado grande o ilegible)}other{{n} fotos saltadas (demasiado grandes o ilegibles)}}'**
  String scSkipped(int n);

  /// No description provided for @scNothingRecognised.
  ///
  /// In es, this message translates to:
  /// **'No reconocí ninguna carta en esas fotos. Prueba con mejor luz o menos reflejo.'**
  String get scNothingRecognised;

  /// No description provided for @scAddN.
  ///
  /// In es, this message translates to:
  /// **'Añadir {n} a la colección'**
  String scAddN(int n);

  /// No description provided for @scDropPhotos.
  ///
  /// In es, this message translates to:
  /// **'Suelta aquí las fotos de tus cartas'**
  String get scDropPhotos;

  /// No description provided for @scDropExplain.
  ///
  /// In es, this message translates to:
  /// **'Una o varias a la vez — y si una foto trae VARIAS cartas (una página del álbum, la mesa llena), las saco todas y las junto en una lista para que revises y añadas las que quieras. Vale foto del móvil o escaneo.'**
  String get scDropExplain;

  /// No description provided for @scPickPhotos.
  ///
  /// In es, this message translates to:
  /// **'Elegir fotos'**
  String get scPickPhotos;

  /// No description provided for @scMatchHigh.
  ///
  /// In es, this message translates to:
  /// **'coincidencia alta'**
  String get scMatchHigh;

  /// No description provided for @scMatchMedium.
  ///
  /// In es, this message translates to:
  /// **'coincidencia media'**
  String get scMatchMedium;

  /// No description provided for @scMatchLow.
  ///
  /// In es, this message translates to:
  /// **'coincidencia baja'**
  String get scMatchLow;

  /// No description provided for @scAddToCollection.
  ///
  /// In es, this message translates to:
  /// **'Añadir a la colección'**
  String get scAddToCollection;

  /// No description provided for @scSeeOptions.
  ///
  /// In es, this message translates to:
  /// **'No es esta — ver opciones'**
  String get scSeeOptions;

  /// No description provided for @scScanAnother.
  ///
  /// In es, this message translates to:
  /// **'Escanear otra'**
  String get scScanAnother;

  /// No description provided for @scNotSure.
  ///
  /// In es, this message translates to:
  /// **'No estoy seguro'**
  String get scNotSure;

  /// No description provided for @scWhichIsIt.
  ///
  /// In es, this message translates to:
  /// **'¿Cuál es?'**
  String get scWhichIsIt;

  /// No description provided for @scNoneQuiteFits.
  ///
  /// In es, this message translates to:
  /// **'Ninguna encaja del todo. ¿Es alguna de estas? Si no, prueba otra foto con mejor luz.'**
  String get scNoneQuiteFits;

  /// No description provided for @scNoEdges.
  ///
  /// In es, this message translates to:
  /// **'No vi los bordes de la carta, así que he usado la imagen entera. Estos son los parecidos:'**
  String get scNoEdges;

  /// No description provided for @scCropped.
  ///
  /// In es, this message translates to:
  /// **'Esto es lo que he recortado. Los candidatos, por parecido:'**
  String get scCropped;

  /// No description provided for @scDiscard.
  ///
  /// In es, this message translates to:
  /// **'Descartar y escanear otra'**
  String get scDiscard;

  /// No description provided for @suCardsName.
  ///
  /// In es, this message translates to:
  /// **'Cartas y precios'**
  String get suCardsName;

  /// No description provided for @suCardsWhat.
  ///
  /// In es, this message translates to:
  /// **'catálogo completo de Scryfall'**
  String get suCardsWhat;

  /// No description provided for @suHistoryName.
  ///
  /// In es, this message translates to:
  /// **'Histórico de precios'**
  String get suHistoryName;

  /// No description provided for @suHistoryWhat.
  ///
  /// In es, this message translates to:
  /// **'~90 días de Cardmarket'**
  String get suHistoryWhat;

  /// No description provided for @suHashesName.
  ///
  /// In es, this message translates to:
  /// **'Huellas del escáner'**
  String get suHashesName;

  /// No description provided for @suHashesWhat.
  ///
  /// In es, this message translates to:
  /// **'para reconocer por foto'**
  String get suHashesWhat;

  /// No description provided for @suUpToDate.
  ///
  /// In es, this message translates to:
  /// **'al día ({fecha})'**
  String suUpToDate(String fecha);

  /// No description provided for @suUpdated.
  ///
  /// In es, this message translates to:
  /// **'actualizado'**
  String get suUpdated;

  /// No description provided for @suUpdatedWithDate.
  ///
  /// In es, this message translates to:
  /// **'actualizado ({fecha})'**
  String suUpdatedWithDate(String fecha);

  /// No description provided for @suFailedOffline.
  ///
  /// In es, this message translates to:
  /// **'no he podido traerla (sin conexión)'**
  String get suFailedOffline;

  /// No description provided for @suKeepingOld.
  ///
  /// In es, this message translates to:
  /// **'sigo con la que tenías'**
  String get suKeepingOld;

  /// No description provided for @suNeedMissing.
  ///
  /// In es, this message translates to:
  /// **'falta, la traigo'**
  String get suNeedMissing;

  /// No description provided for @suNeedStale.
  ///
  /// In es, this message translates to:
  /// **'hay una nueva'**
  String get suNeedStale;

  /// No description provided for @suNeedFresh.
  ///
  /// In es, this message translates to:
  /// **'al día'**
  String get suNeedFresh;

  /// No description provided for @suAllUpToDate.
  ///
  /// In es, this message translates to:
  /// **'Todo al día. Entrando…'**
  String get suAllUpToDate;

  /// No description provided for @suUpdatingCards.
  ///
  /// In es, this message translates to:
  /// **'Poniendo al día tus cartas y precios…'**
  String get suUpdatingCards;

  /// No description provided for @suChecking.
  ///
  /// In es, this message translates to:
  /// **'Comprobando si hay novedades…'**
  String get suChecking;

  /// No description provided for @suNoDownloadNote.
  ///
  /// In es, this message translates to:
  /// **'Lo que ya está al día no se descarga. Dentro de la app puedes forzar cualquier actualización.'**
  String get suNoDownloadNote;

  /// No description provided for @suEnter.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get suEnter;

  /// No description provided for @suEnterNow.
  ///
  /// In es, this message translates to:
  /// **'Entrar ya'**
  String get suEnterNow;

  /// No description provided for @icBadFile.
  ///
  /// In es, this message translates to:
  /// **'No pude leer el archivo: {error}'**
  String icBadFile(String error);

  /// No description provided for @icNotCsv.
  ///
  /// In es, this message translates to:
  /// **'Eso no parece un CSV — suelta un archivo .csv o .txt.'**
  String get icNotCsv;

  /// No description provided for @icTitle.
  ///
  /// In es, this message translates to:
  /// **'Importar colección'**
  String get icTitle;

  /// No description provided for @icExplain.
  ///
  /// In es, this message translates to:
  /// **'Arrastra aquí tu CSV de ManaBox (también vale Moxfield, Archidekt o cualquier CSV con columnas Name y Quantity), elígelo con el botón, o pega su contenido a mano:'**
  String get icExplain;

  /// No description provided for @icPickFile.
  ///
  /// In es, this message translates to:
  /// **'Elegir archivo…'**
  String get icPickFile;

  /// No description provided for @icImported.
  ///
  /// In es, this message translates to:
  /// **'✓ {cartas} cartas ({copias} copias) añadidas a tu colección.'**
  String icImported(int cartas, int copias);

  /// No description provided for @icReplaceMine.
  ///
  /// In es, this message translates to:
  /// **'Sustituir mi colección actual'**
  String get icReplaceMine;

  /// No description provided for @icReplaceWhy.
  ///
  /// In es, this message translates to:
  /// **'Actívalo al reimportar tu CSV completo: evita duplicar cantidades y afina el álbum por ediciones.'**
  String get icReplaceWhy;

  /// No description provided for @icImporting.
  ///
  /// In es, this message translates to:
  /// **'Importando {hechas} de {total} cartas…'**
  String icImporting(int hechas, int total);

  /// No description provided for @icDropHere.
  ///
  /// In es, this message translates to:
  /// **'Suelta tu CSV aquí'**
  String get icDropHere;

  /// No description provided for @icTokensIgnored.
  ///
  /// In es, this message translates to:
  /// **'\n• {n} tokens/emblemas ignorados (no van en mazos, todo bien).'**
  String icTokensIgnored(int n);

  /// No description provided for @icUnrecognized.
  ///
  /// In es, this message translates to:
  /// **'\n✗ Sin reconocer: {lista}{mas}'**
  String icUnrecognized(String lista, String mas);

  /// No description provided for @icNoPurchasePrice.
  ///
  /// In es, this message translates to:
  /// **'\n• Sin precio de compra en el CSV: no habrá P&L (ManaBox lo exporta en la columna \"Purchase price\").'**
  String get icNoPurchasePrice;

  /// No description provided for @icWithPurchasePrice.
  ///
  /// In es, this message translates to:
  /// **'\n• {n} copias con precio de compra: ya puedes ver el P&L en Mercado.'**
  String icWithPurchasePrice(int n);

  /// No description provided for @icImporting2.
  ///
  /// In es, this message translates to:
  /// **'Importando…'**
  String get icImporting2;

  /// No description provided for @icImport.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get icImport;

  /// No description provided for @dkDeleted.
  ///
  /// In es, this message translates to:
  /// **'Mazo \"{nombre}\" borrado'**
  String dkDeleted(String nombre);

  /// No description provided for @dkUndo.
  ///
  /// In es, this message translates to:
  /// **'DESHACER'**
  String get dkUndo;

  /// No description provided for @dkOpenFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude abrir el mazo (¿está descargada la base de datos?): {error}'**
  String dkOpenFailed(String error);

  /// No description provided for @dkMyDecks.
  ///
  /// In es, this message translates to:
  /// **'Mis mazos'**
  String get dkMyDecks;

  /// No description provided for @dkEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aquí vivirán los mazos que guardes desde Forge (botón de guardar en el detalle del mazo).'**
  String get dkEmpty;

  /// No description provided for @dkSavedCount.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 guardado} other{{n} guardados}}'**
  String dkSavedCount(int n);

  /// No description provided for @dkSubtitle.
  ///
  /// In es, this message translates to:
  /// **'{arquetipo} · {hechizos} hechizos + {tierras} tierras · guardado el {fecha}'**
  String dkSubtitle(String arquetipo, int hechizos, int tierras, String fecha);

  /// No description provided for @dkDeleteTooltip.
  ///
  /// In es, this message translates to:
  /// **'Borrar mazo'**
  String get dkDeleteTooltip;

  /// No description provided for @ddSaved.
  ///
  /// In es, this message translates to:
  /// **'✓ Mazo guardado — lo tienes en la pestaña Mazos'**
  String get ddSaved;

  /// No description provided for @ddReforged.
  ///
  /// In es, this message translates to:
  /// **'✓ Mazo reforjado a tu curva — lista actualizada'**
  String get ddReforged;

  /// No description provided for @ddSaveToMyDecks.
  ///
  /// In es, this message translates to:
  /// **'Guardar en Mis mazos'**
  String get ddSaveToMyDecks;

  /// No description provided for @ddCopyList.
  ///
  /// In es, this message translates to:
  /// **'Copiar lista (Moxfield/Arena)'**
  String get ddCopyList;

  /// No description provided for @ddListCopied.
  ///
  /// In es, this message translates to:
  /// **'✓ Lista copiada — pégala en Moxfield, Arena o Discord'**
  String get ddListCopied;

  /// No description provided for @ddHeaderSub.
  ///
  /// In es, this message translates to:
  /// **'{tema} · {arquetipo} · {hechizos} hechizos + {tierras} tierras'**
  String ddHeaderSub(String tema, String arquetipo, int hechizos, int tierras);

  /// No description provided for @ddHaveAll.
  ///
  /// In es, this message translates to:
  /// **'✓ Tienes todas las cartas'**
  String get ddHaveAll;

  /// No description provided for @ddMissing.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{⚠ Te falta 1 carta de este mazo — sigue en la lista, no se ha borrado} other{⚠ Te faltan {n} cartas de este mazo — siguen en la lista, no se han borrado}}'**
  String ddMissing(int n);

  /// No description provided for @ddGamePlan.
  ///
  /// In es, this message translates to:
  /// **'Tu plan de juego'**
  String get ddGamePlan;

  /// No description provided for @ddManaCurve.
  ///
  /// In es, this message translates to:
  /// **'Curva de maná'**
  String get ddManaCurve;

  /// No description provided for @ddEditCurve.
  ///
  /// In es, this message translates to:
  /// **'Editar curva'**
  String get ddEditCurve;

  /// No description provided for @ddDragBars.
  ///
  /// In es, this message translates to:
  /// **'Arrastra las barras ↑↓ · {hechizos} hechizos → {tierras} tierras'**
  String ddDragBars(int hechizos, int tierras);

  /// No description provided for @ddReforgeCurve.
  ///
  /// In es, this message translates to:
  /// **'Reforjar con esta curva'**
  String get ddReforgeCurve;

  /// No description provided for @ddCurveSummary.
  ///
  /// In es, this message translates to:
  /// **'⛰ {tierras} tierras · ✦ {hechizos} hechizos · Ø coste {coste}'**
  String ddCurveSummary(int tierras, int hechizos, String coste);

  /// No description provided for @ddWhyWorks.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué este mazo funciona?'**
  String get ddWhyWorks;

  /// No description provided for @ddLands.
  ///
  /// In es, this message translates to:
  /// **'TIERRAS ({n})'**
  String ddLands(int n);

  /// No description provided for @ddDeckTotal.
  ///
  /// In es, this message translates to:
  /// **'Total del mazo: ~{precio} €'**
  String ddDeckTotal(String precio);

  /// No description provided for @ddCheapestPrice.
  ///
  /// In es, this message translates to:
  /// **'precio de la edición más barata (Cardmarket)'**
  String get ddCheapestPrice;

  /// No description provided for @ddSomeNoPrice.
  ///
  /// In es, this message translates to:
  /// **'{n} sin precio conocido · edición más barata (Cardmarket)'**
  String ddSomeNoPrice(int n);

  /// No description provided for @ddInstants.
  ///
  /// In es, this message translates to:
  /// **'Instantáneos'**
  String get ddInstants;

  /// No description provided for @ddTypeCreatures.
  ///
  /// In es, this message translates to:
  /// **'Criaturas'**
  String get ddTypeCreatures;

  /// No description provided for @ddTypeSorceries.
  ///
  /// In es, this message translates to:
  /// **'Conjuros'**
  String get ddTypeSorceries;

  /// No description provided for @ddTypeEnchantments.
  ///
  /// In es, this message translates to:
  /// **'Encantamientos'**
  String get ddTypeEnchantments;

  /// No description provided for @ddTypeArtifacts.
  ///
  /// In es, this message translates to:
  /// **'Artefactos'**
  String get ddTypeArtifacts;

  /// No description provided for @ddTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get ddTypeOther;

  /// No description provided for @ddOutOfRange.
  ///
  /// In es, this message translates to:
  /// **'  (fuera del rango sano 20-27)'**
  String get ddOutOfRange;

  /// No description provided for @acRecalcTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Recalcular logros?'**
  String get acRecalcTitle;

  /// No description provided for @acRecalcBody.
  ///
  /// In es, this message translates to:
  /// **'Se vuelven a mirar tus cartas y se quitan los logros que hoy no se cumplan. Sirve para arreglar los que se dieron por error; si has vendido cartas, también perderás esos.'**
  String get acRecalcBody;

  /// No description provided for @acRecalc.
  ///
  /// In es, this message translates to:
  /// **'Recalcular'**
  String get acRecalc;

  /// No description provided for @acAllFine.
  ///
  /// In es, this message translates to:
  /// **'Todo cuadraba: no se ha quitado ningún logro.'**
  String get acAllFine;

  /// No description provided for @acRemovedN.
  ///
  /// In es, this message translates to:
  /// **'Quitados {n} logros que ya no se cumplen.'**
  String acRemovedN(int n);

  /// No description provided for @acTitle.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get acTitle;

  /// No description provided for @acRecalcTooltip.
  ///
  /// In es, this message translates to:
  /// **'Recalcular con mis cartas de ahora'**
  String get acRecalcTooltip;

  /// No description provided for @acCertsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Certificados'**
  String get acCertsTooltip;

  /// No description provided for @acUnlockedOf.
  ///
  /// In es, this message translates to:
  /// **'{hechos} de {total} logros · {xp} XP'**
  String acUnlockedOf(int hechos, int total, int xp);

  /// No description provided for @acLevelLine.
  ///
  /// In es, this message translates to:
  /// **'Nivel {nivel} · faltan {xp} XP para el {siguiente}'**
  String acLevelLine(int nivel, int xp, int siguiente);

  /// No description provided for @acIMissing.
  ///
  /// In es, this message translates to:
  /// **'Me faltan'**
  String get acIMissing;

  /// No description provided for @acSecret.
  ///
  /// In es, this message translates to:
  /// **'Logro secreto'**
  String get acSecret;

  /// No description provided for @acSecretDesc.
  ///
  /// In es, this message translates to:
  /// **'Se descubre solo cuando lo consigues.'**
  String get acSecretDesc;

  /// No description provided for @acProgressLine.
  ///
  /// In es, this message translates to:
  /// **'{progreso} · {tier} · {xp} XP'**
  String acProgressLine(String progreso, String tier, int xp);

  /// No description provided for @acDoneLine.
  ///
  /// In es, this message translates to:
  /// **'✓ Conseguido{fecha} · {tier} · {xp} XP'**
  String acDoneLine(String fecha, String tier, int xp);

  /// No description provided for @acOnDate.
  ///
  /// In es, this message translates to:
  /// **' el {fecha}'**
  String acOnDate(String fecha);

  /// No description provided for @acLevelUp.
  ///
  /// In es, this message translates to:
  /// **'¡Nivel {nivel}!'**
  String acLevelUp(int nivel);

  /// No description provided for @acLevelUpBody.
  ///
  /// In es, this message translates to:
  /// **'Ya eres {titulo}. Llevas {hechos} de {total} logros.'**
  String acLevelUpBody(String titulo, int hechos, int total);

  /// No description provided for @acOk.
  ///
  /// In es, this message translates to:
  /// **'Vale'**
  String get acOk;

  /// No description provided for @acSeeAchievements.
  ///
  /// In es, this message translates to:
  /// **'Ver logros'**
  String get acSeeAchievements;

  /// No description provided for @acToast.
  ///
  /// In es, this message translates to:
  /// **'🏆 ¡Logro! {titulo}{mas} · +{xp} XP'**
  String acToast(String titulo, String mas, int xp);

  /// No description provided for @acAndMore.
  ///
  /// In es, this message translates to:
  /// **' (y {n} más)'**
  String acAndMore(int n);

  /// No description provided for @ceNeedDb.
  ///
  /// In es, this message translates to:
  /// **'Para los de expansión hace falta la base de datos de cartas ({error})'**
  String ceNeedDb(String error);

  /// No description provided for @ceWhoseName.
  ///
  /// In es, this message translates to:
  /// **'¿A nombre de quién?'**
  String get ceWhoseName;

  /// No description provided for @ceCollectorName.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre de coleccionista'**
  String get ceCollectorName;

  /// No description provided for @ceInNameOf.
  ///
  /// In es, this message translates to:
  /// **'A nombre de…'**
  String get ceInNameOf;

  /// No description provided for @ceEmptyWithData.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes ninguna expansión completa. Cuando completes una entera en el Álbum, aquí saldrá tu certificado para descargar.'**
  String get ceEmptyWithData;

  /// No description provided for @ceEmptyNoData.
  ///
  /// In es, this message translates to:
  /// **'Para certificar una expansión hace falta saber la edición exacta de tus cartas: reimporta tu CSV de ManaBox (trae el Scryfall ID).'**
  String get ceEmptyNoData;

  /// No description provided for @ceNothingSaved.
  ///
  /// In es, this message translates to:
  /// **'No se guardó nada.'**
  String get ceNothingSaved;

  /// No description provided for @ceSavedTo.
  ///
  /// In es, this message translates to:
  /// **'✓ Certificado guardado en {ruta}'**
  String ceSavedTo(String ruta);

  /// No description provided for @ceSaveFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar: {error}'**
  String ceSaveFailed(String error);

  /// No description provided for @cePickFirstCard.
  ///
  /// In es, this message translates to:
  /// **'Elegir la carta con la que empecé'**
  String get cePickFirstCard;

  /// No description provided for @ceChangeFirstCard.
  ///
  /// In es, this message translates to:
  /// **'Cambiar la carta con la que empecé'**
  String get ceChangeFirstCard;

  /// No description provided for @ceDownloadPng.
  ///
  /// In es, this message translates to:
  /// **'Descargar PNG'**
  String get ceDownloadPng;

  /// No description provided for @cdNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encuentro esta carta en la base de datos.'**
  String get cdNotFound;

  /// No description provided for @cdLoadFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude cargar la ficha: {error}'**
  String cdLoadFailed(String error);

  /// No description provided for @cdPrev.
  ///
  /// In es, this message translates to:
  /// **'Anterior (←)'**
  String get cdPrev;

  /// No description provided for @cdNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente (→)'**
  String get cdNext;

  /// No description provided for @cdPosition.
  ///
  /// In es, this message translates to:
  /// **'{pos} / {total}'**
  String cdPosition(int pos, int total);

  /// No description provided for @cdCardNotFound.
  ///
  /// In es, this message translates to:
  /// **'Carta no encontrada'**
  String get cdCardNotFound;

  /// No description provided for @cdPaid.
  ///
  /// In es, this message translates to:
  /// **'Pagaste {total}{divisa} por {qty} {copias} ({unidad} cada una)'**
  String cdPaid(
    String total,
    String divisa,
    int qty,
    String copias,
    String unidad,
  );

  /// No description provided for @cdCopyWord.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{copia}other{copias}}'**
  String cdCopyWord(int n);

  /// No description provided for @cdYouHave.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{✓ Tienes 1 copia en tu colección}other{✓ Tienes {n} copias en tu colección}}'**
  String cdYouHave(int n);

  /// No description provided for @cdNotOwned.
  ///
  /// In es, this message translates to:
  /// **'No tienes esta carta (todavía).'**
  String get cdNotOwned;

  /// No description provided for @cdNoPrice.
  ///
  /// In es, this message translates to:
  /// **'Sin precio de esta carta en {mercado}.'**
  String cdNoPrice(String mercado);

  /// No description provided for @cdVersions.
  ///
  /// In es, this message translates to:
  /// **'VERSIONES ({n})'**
  String cdVersions(int n);

  /// No description provided for @cdNoPerPrinting.
  ///
  /// In es, this message translates to:
  /// **'sin precio por edición en {mercado}'**
  String cdNoPerPrinting(String mercado);

  /// No description provided for @cdPricesNormalFoil.
  ///
  /// In es, this message translates to:
  /// **'precios {mercado} ({moneda}) · normal / foil'**
  String cdPricesNormalFoil(String mercado, String moneda);

  /// No description provided for @cdFoil.
  ///
  /// In es, this message translates to:
  /// **'foil {precio}'**
  String cdFoil(String precio);

  /// No description provided for @cdYouHaveX.
  ///
  /// In es, this message translates to:
  /// **'tienes x{n}'**
  String cdYouHaveX(int n);

  /// No description provided for @smMythic.
  ///
  /// In es, this message translates to:
  /// **'Mítica'**
  String get smMythic;

  /// No description provided for @smRare.
  ///
  /// In es, this message translates to:
  /// **'Rara'**
  String get smRare;

  /// No description provided for @smUncommon.
  ///
  /// In es, this message translates to:
  /// **'Infrecuente'**
  String get smUncommon;

  /// No description provided for @smCommon.
  ///
  /// In es, this message translates to:
  /// **'Común'**
  String get smCommon;

  /// No description provided for @smLoadFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude cargar el set: {error}'**
  String smLoadFailed(String error);

  /// No description provided for @smSearchInSet.
  ///
  /// In es, this message translates to:
  /// **'Busca en la expansión…'**
  String get smSearchInSet;

  /// No description provided for @smRarityAll.
  ///
  /// In es, this message translates to:
  /// **'Rareza: todas'**
  String get smRarityAll;

  /// No description provided for @smPriceDown.
  ///
  /// In es, this message translates to:
  /// **'Precio ↓'**
  String get smPriceDown;

  /// No description provided for @smPriceUp.
  ///
  /// In es, this message translates to:
  /// **'Precio ↑'**
  String get smPriceUp;

  /// No description provided for @smNumber.
  ///
  /// In es, this message translates to:
  /// **'Número'**
  String get smNumber;

  /// No description provided for @smOnlyMine.
  ///
  /// In es, this message translates to:
  /// **'Solo las mías'**
  String get smOnlyMine;

  /// No description provided for @smCardsCount.
  ///
  /// In es, this message translates to:
  /// **'{n} cartas'**
  String smCardsCount(int n);

  /// No description provided for @smNoPerPrinting.
  ///
  /// In es, this message translates to:
  /// **'{mercado}: sin precio por edición'**
  String smNoPerPrinting(String mercado);

  /// No description provided for @smListedValue.
  ///
  /// In es, this message translates to:
  /// **'valor listado ({mercado}): '**
  String smListedValue(String mercado);

  /// No description provided for @pnPaidVsToday.
  ///
  /// In es, this message translates to:
  /// **'Pagaste {pagado} · hoy valen {hoy}'**
  String pnPaidVsToday(String pagado, String hoy);

  /// No description provided for @pnNoPnl.
  ///
  /// In es, this message translates to:
  /// **'Sin precio de compra no hay P&L. Importa tu CSV de ManaBox con la columna \"Purchase price\" y aparece aquí.'**
  String get pnNoPnl;

  /// No description provided for @pnOverAll.
  ///
  /// In es, this message translates to:
  /// **'sobre las {n} copias de tu colección'**
  String pnOverAll(int n);

  /// No description provided for @pnOverSome.
  ///
  /// In es, this message translates to:
  /// **'sobre {conprecio} de {total} copias (las demás no tienen precio de compra apuntado)'**
  String pnOverSome(int conprecio, int total);

  /// No description provided for @pnNoTodayPrice.
  ///
  /// In es, this message translates to:
  /// **'{n} copias compradas no tienen precio de hoy en la base: fuera de la cuenta'**
  String pnNoTodayPrice(int n);

  /// No description provided for @pnOtherCurrency.
  ///
  /// In es, this message translates to:
  /// **'también pagaste {importe} {moneda}, que no se convierte'**
  String pnOtherCurrency(String importe, String moneda);

  /// No description provided for @pnAssumedCurrency.
  ///
  /// In es, this message translates to:
  /// **'{n} copias sin divisa en el CSV: se suponen {moneda}'**
  String pnAssumedCurrency(int n, String moneda);

  /// No description provided for @pcTitle.
  ///
  /// In es, this message translates to:
  /// **'Evolución del precio'**
  String get pcTitle;

  /// No description provided for @pcNoHistory.
  ///
  /// In es, this message translates to:
  /// **'Todavía sin historial de precio de esta carta.'**
  String get pcNoHistory;

  /// No description provided for @pcTodayPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio de hoy: {precio} €. La gráfica aparece en cuanto haya varios días.'**
  String pcTodayPrice(String precio);

  /// No description provided for @pcExplain.
  ///
  /// In es, this message translates to:
  /// **'ManaForge apunta el precio de cada carta que miras o tienes, día a día. Para arrancar con los últimos meses reales de Cardmarket, trae el histórico desde Mercado.'**
  String get pcExplain;

  /// No description provided for @pcRange.
  ///
  /// In es, this message translates to:
  /// **'mín {min} € · máx {max} € · {n, plural, =1{1 día}other{{n} días}}'**
  String pcRange(String min, String max, int n);

  /// No description provided for @spWhichSets.
  ///
  /// In es, this message translates to:
  /// **'¿De qué expansiones?'**
  String get spWhichSets;

  /// No description provided for @spSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o código (BLB, MH3…)'**
  String get spSearchHint;

  /// No description provided for @spOnlyMine.
  ///
  /// In es, this message translates to:
  /// **'Solo las mías'**
  String get spOnlyMine;

  /// No description provided for @spClearN.
  ///
  /// In es, this message translates to:
  /// **'Quitar las {n}'**
  String spClearN(int n);

  /// No description provided for @spNoneNamed.
  ///
  /// In es, this message translates to:
  /// **'Ninguna expansión con ese nombre. Quita \"Solo las mías\" para ver todas.'**
  String get spNoneNamed;

  /// No description provided for @spSetLine.
  ///
  /// In es, this message translates to:
  /// **'{set} · {n} cartas'**
  String spSetLine(String set, int n);

  /// No description provided for @spNoFilter.
  ///
  /// In es, this message translates to:
  /// **'Sin filtro de expansión'**
  String get spNoFilter;

  /// No description provided for @spUseN.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Usar 1 expansión}other{Usar {n} expansiones}}'**
  String spUseN(int n);

  /// No description provided for @slLockedTo.
  ///
  /// In es, this message translates to:
  /// **'Solo busco cartas del set {set}. Tócalo para cambiar o quitar el bloqueo.'**
  String slLockedTo(String set);

  /// No description provided for @slLockHint.
  ///
  /// In es, this message translates to:
  /// **'Bloquea un set para escanear una caja/precon: el escáner solo buscará dentro de él y clava la edición.'**
  String get slLockHint;

  /// No description provided for @slSetIs.
  ///
  /// In es, this message translates to:
  /// **'Set: {set}'**
  String slSetIs(String set);

  /// No description provided for @slSetAll.
  ///
  /// In es, this message translates to:
  /// **'Set: todas'**
  String get slSetAll;

  /// No description provided for @slLockTitle.
  ///
  /// In es, this message translates to:
  /// **'Bloquear edición'**
  String get slLockTitle;

  /// No description provided for @slLockBody.
  ///
  /// In es, this message translates to:
  /// **'Escribe el código del set (p. ej. AER, MH3, LCI) para escanear una caja entera: solo se buscarán cartas de ese set.'**
  String get slLockBody;

  /// No description provided for @slSetCode.
  ///
  /// In es, this message translates to:
  /// **'Código de set'**
  String get slSetCode;

  /// No description provided for @slClearLock.
  ///
  /// In es, this message translates to:
  /// **'Quitar bloqueo'**
  String get slClearLock;

  /// No description provided for @stHintQuick.
  ///
  /// In es, this message translates to:
  /// **'Pasa cartas por delante: las claras se apuntan solas aquí (las copias iguales suman ×N). Las dudosas, marcadas para revisar. Al terminar, confirmas todas.'**
  String get stHintQuick;

  /// No description provided for @stHintCareful.
  ///
  /// In es, this message translates to:
  /// **'Pasa cartas por delante: las claras se apuntan solas; las dudosas te preguntan cuál es. Al terminar, confirmas todas.'**
  String get stHintCareful;

  /// No description provided for @stAddN.
  ///
  /// In es, this message translates to:
  /// **'Añadir {n} a la colección'**
  String stAddN(int n);

  /// No description provided for @stAddNAndFolder.
  ///
  /// In es, this message translates to:
  /// **'Añadir {n} a la colección y a {carpeta}'**
  String stAddNAndFolder(int n, String carpeta);

  /// No description provided for @stOneLess.
  ///
  /// In es, this message translates to:
  /// **'Una menos'**
  String get stOneLess;

  /// No description provided for @stAnotherSame.
  ///
  /// In es, this message translates to:
  /// **'Otra igual'**
  String get stAnotherSame;

  /// No description provided for @stOnTable.
  ///
  /// In es, this message translates to:
  /// **'en mesa'**
  String get stOnTable;

  /// No description provided for @cdLastData.
  ///
  /// In es, this message translates to:
  /// **' (último dato: {fecha})'**
  String cdLastData(String fecha);

  /// No description provided for @cdLegalities.
  ///
  /// In es, this message translates to:
  /// **'Legalidades'**
  String get cdLegalities;

  /// No description provided for @slLockButton.
  ///
  /// In es, this message translates to:
  /// **'Bloquear'**
  String get slLockButton;

  /// No description provided for @wn030Headline.
  ///
  /// In es, this message translates to:
  /// **'Forge por expansiones, precio de compra y avisos de versión'**
  String get wn030Headline;

  /// No description provided for @wn030Forge.
  ///
  /// In es, this message translates to:
  /// **'Forge: elige de qué expansiones salen las cartas. Y si activas \"incluir cartas que no tengo\", te monta el mazo con toda la colección elegida y te dice cuántas te faltan y cuánto cuestan.'**
  String get wn030Forge;

  /// No description provided for @wn030Pnl.
  ///
  /// In es, this message translates to:
  /// **'Precio de compra y P&L: si tu CSV de ManaBox trae \"Purchase price\", el Mercado te dice lo que pagaste, lo que vale hoy y la diferencia. Las divisas no se mezclan.'**
  String get wn030Pnl;

  /// No description provided for @wn030PhotoFolder.
  ///
  /// In es, this message translates to:
  /// **'Escanear por foto también deja elegir carpeta, como el escáner en vivo.'**
  String get wn030PhotoFolder;

  /// No description provided for @wn030Album.
  ///
  /// In es, this message translates to:
  /// **'Álbum: lo que te falta de cada expansión, con lo que costaría.'**
  String get wn030Album;

  /// No description provided for @wn030Background.
  ///
  /// In es, this message translates to:
  /// **'Fondo de pantalla: pon detrás la imagen que quieras, con velo regulable, y elige el color de las tarjetas y de la letra para que encima se siga leyendo.'**
  String get wn030Background;

  /// No description provided for @wn030Window.
  ///
  /// In es, this message translates to:
  /// **'La ventana se abre donde la dejaste, del tamaño que la dejaste.'**
  String get wn030Window;

  /// No description provided for @wn030Achievements.
  ///
  /// In es, this message translates to:
  /// **'Los logros ya no se llaman como el criterio, se llaman como el momento: \"Ahí va todo mi dinero\", \"Cien raras y ninguna jugable\".'**
  String get wn030Achievements;

  /// No description provided for @wn030Update.
  ///
  /// In es, this message translates to:
  /// **'La app avisa cuando hay versión nueva (no se actualiza sola) y comprueba la huella SHA-256 de las bases que se descarga.'**
  String get wn030Update;

  /// No description provided for @wn030Shortcuts.
  ///
  /// In es, this message translates to:
  /// **'Atajos de teclado: Ctrl+1…7, Ctrl+E, Ctrl+F, Ctrl+, y Escape.'**
  String get wn030Shortcuts;

  /// No description provided for @wn030Linux.
  ///
  /// In es, this message translates to:
  /// **'En Linux, un instalador deja ManaForge en el menú de aplicaciones con su icono.'**
  String get wn030Linux;

  /// No description provided for @wn030License.
  ///
  /// In es, this message translates to:
  /// **'Licencia PolyForm Noncommercial: compártela y tócala lo que quieras, pero no se vende.'**
  String get wn030License;

  /// No description provided for @bkSumCards.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 carta} other{{n} cartas}}'**
  String bkSumCards(int n);

  /// No description provided for @bkSumDecks.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 mazo} other{{n} mazos}}'**
  String bkSumDecks(int n);

  /// No description provided for @bkSumFolders.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 carpeta} other{{n} carpetas}}'**
  String bkSumFolders(int n);

  /// No description provided for @bkSumAchievements.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 logro} other{{n} logros}}'**
  String bkSumAchievements(int n);

  /// No description provided for @bkSumEmpty.
  ///
  /// In es, this message translates to:
  /// **'copia vacía'**
  String get bkSumEmpty;

  /// No description provided for @bkStoreCollection.
  ///
  /// In es, this message translates to:
  /// **'tu colección'**
  String get bkStoreCollection;

  /// No description provided for @bkStoreFolders.
  ///
  /// In es, this message translates to:
  /// **'tus carpetas'**
  String get bkStoreFolders;

  /// No description provided for @bkStoreDecks.
  ///
  /// In es, this message translates to:
  /// **'tus mazos'**
  String get bkStoreDecks;

  /// No description provided for @bkStoreAchievements.
  ///
  /// In es, this message translates to:
  /// **'tus logros'**
  String get bkStoreAchievements;

  /// No description provided for @bkStoreWishlist.
  ///
  /// In es, this message translates to:
  /// **'tu lista de deseos'**
  String get bkStoreWishlist;

  /// No description provided for @bkStoreCertificates.
  ///
  /// In es, this message translates to:
  /// **'tus certificados'**
  String get bkStoreCertificates;

  /// No description provided for @bkStoreMarket.
  ///
  /// In es, this message translates to:
  /// **'tu mercado preferido'**
  String get bkStoreMarket;

  /// No description provided for @bkStoreRecents.
  ///
  /// In es, this message translates to:
  /// **'las cartas vistas hace poco'**
  String get bkStoreRecents;

  /// No description provided for @bkStoreValueHistory.
  ///
  /// In es, this message translates to:
  /// **'el historial del valor'**
  String get bkStoreValueHistory;

  /// No description provided for @bkStorePriceHistory.
  ///
  /// In es, this message translates to:
  /// **'el historial de precios'**
  String get bkStorePriceHistory;

  /// No description provided for @bkKindAuto.
  ///
  /// In es, this message translates to:
  /// **'automática'**
  String get bkKindAuto;

  /// No description provided for @bkKindPreRestore.
  ///
  /// In es, this message translates to:
  /// **'antes de restaurar'**
  String get bkKindPreRestore;

  /// No description provided for @bkKindPreReset.
  ///
  /// In es, this message translates to:
  /// **'antes del reset de fábrica'**
  String get bkKindPreReset;

  /// No description provided for @bkErrFileTooBig.
  ///
  /// In es, this message translates to:
  /// **'Ese fichero es demasiado grande para ser una copia de ManaForge.'**
  String get bkErrFileTooBig;

  /// No description provided for @bkErrExpandTooBig.
  ///
  /// In es, this message translates to:
  /// **'Esa copia es demasiado grande al abrirla: no parece una copia de ManaForge de verdad.'**
  String get bkErrExpandTooBig;

  /// No description provided for @bkErrNotABackup.
  ///
  /// In es, this message translates to:
  /// **'Ese fichero no es una copia de seguridad de ManaForge.'**
  String get bkErrNotABackup;

  /// No description provided for @bkErrNewerVersion.
  ///
  /// In es, this message translates to:
  /// **'Esa copia la hizo una versión más nueva de ManaForge. Actualiza la app y vuelve a intentarlo.'**
  String get bkErrNewerVersion;

  /// No description provided for @bkErrIncomplete.
  ///
  /// In es, this message translates to:
  /// **'Esa copia está incompleta: no trae tus datos.'**
  String get bkErrIncomplete;

  /// No description provided for @bkErrDamaged.
  ///
  /// In es, this message translates to:
  /// **'Esa copia está dañada: {almacen} no se puede leer.'**
  String bkErrDamaged(String almacen);

  /// No description provided for @bkErrWriteFailed.
  ///
  /// In es, this message translates to:
  /// **'No he podido escribir en la carpeta de datos, así que no he tocado nada: {error}'**
  String bkErrWriteFailed(String error);

  /// No description provided for @bkErrHalfDoneNoPrevious.
  ///
  /// In es, this message translates to:
  /// **'El restaurar se ha quedado a medias ({escritos} de {total} ficheros). No tengo copia previa de lo que había. Detalle: {error}'**
  String bkErrHalfDoneNoPrevious(String escritos, String total, String error);

  /// No description provided for @bkErrHalfDonePrevious.
  ///
  /// In es, this message translates to:
  /// **'El restaurar se ha quedado a medias ({escritos} de {total} ficheros). Para volver atrás, restaura {ruta}. Detalle: {error}'**
  String bkErrHalfDonePrevious(
    String escritos,
    String total,
    String ruta,
    String error,
  );

  /// No description provided for @siImportTooBig.
  ///
  /// In es, this message translates to:
  /// **'Ese archivo es demasiado grande para ser una lista de cartas.'**
  String get siImportTooBig;

  /// No description provided for @siInsecureDownload.
  ///
  /// In es, this message translates to:
  /// **'La descarga acabó en una dirección insegura y se ha cancelado.'**
  String get siInsecureDownload;

  /// No description provided for @siRedirectNowhere.
  ///
  /// In es, this message translates to:
  /// **'La descarga redirige a ninguna parte y se ha cancelado.'**
  String get siRedirectNowhere;

  /// No description provided for @siTooManyRedirects.
  ///
  /// In es, this message translates to:
  /// **'La descarga da demasiadas vueltas y se ha cancelado.'**
  String get siTooManyRedirects;

  /// No description provided for @siDownloadTooBig.
  ///
  /// In es, this message translates to:
  /// **'La descarga es mucho más grande de lo que debería y se ha cancelado.'**
  String get siDownloadTooBig;

  /// No description provided for @siBadHash.
  ///
  /// In es, this message translates to:
  /// **'Lo descargado no coincide con la huella publicada en GitHub. No se ha instalado nada. Vuelve a intentarlo; si sigue pasando, avisa.'**
  String get siBadHash;

  /// No description provided for @siBackgroundNotImage.
  ///
  /// In es, this message translates to:
  /// **'Elige una imagen (.jpg, .png o .webp) como fondo.'**
  String get siBackgroundNotImage;

  /// No description provided for @siBackgroundTooBig.
  ///
  /// In es, this message translates to:
  /// **'Esa imagen es demasiado grande para usarla de fondo.'**
  String get siBackgroundTooBig;

  /// No description provided for @siScanTooBig.
  ///
  /// In es, this message translates to:
  /// **'Esa foto es demasiado grande para reconocerla.'**
  String get siScanTooBig;

  /// No description provided for @bgImages.
  ///
  /// In es, this message translates to:
  /// **'Imágenes'**
  String get bgImages;

  /// No description provided for @bgImageFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude usar esa imagen: {error}'**
  String bgImageFailed(String error);

  /// No description provided for @bgLowContrast.
  ///
  /// In es, this message translates to:
  /// **'Poca diferencia con la tarjeta: la letra se ajustará sola para que se lea.'**
  String get bgLowContrast;

  /// No description provided for @bgChipColor.
  ///
  /// In es, this message translates to:
  /// **'Color de las pestañas'**
  String get bgChipColor;

  /// No description provided for @bgIconColor.
  ///
  /// In es, this message translates to:
  /// **'Color de los iconos'**
  String get bgIconColor;

  /// No description provided for @bgUseThis.
  ///
  /// In es, this message translates to:
  /// **'Usar este'**
  String get bgUseThis;

  /// No description provided for @bgSaveSwatch.
  ///
  /// In es, this message translates to:
  /// **'Guardar como muestra'**
  String get bgSaveSwatch;

  /// No description provided for @bgSwatchTip.
  ///
  /// In es, this message translates to:
  /// **'Muestra guardada'**
  String get bgSwatchTip;

  /// No description provided for @bgSwatchHint.
  ///
  /// In es, this message translates to:
  /// **'Muestra guardada — bórrala con clic derecho o manteniendo pulsado'**
  String get bgSwatchHint;

  /// No description provided for @bgSwatchDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar esta muestra?'**
  String get bgSwatchDeleteTitle;

  /// No description provided for @bgSwatchDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Se quita de tu paleta guardada. Puedes volver a guardarla cuando quieras.'**
  String get bgSwatchDeleteBody;

  /// No description provided for @camGstreamerMissing.
  ///
  /// In es, this message translates to:
  /// **'GStreamer no está instalado. Instálalo con:\nsudo apt install gstreamer1.0-tools gstreamer1.0-plugins-good'**
  String get camGstreamerMissing;

  /// No description provided for @camNoImage.
  ///
  /// In es, this message translates to:
  /// **'La cámara {dispositivo} no da imagen (gst-launch salió con {codigo}).\n{detalle}'**
  String camNoImage(String dispositivo, String codigo, String detalle);

  /// No description provided for @camNoFrames.
  ///
  /// In es, this message translates to:
  /// **'La cámara {dispositivo} no ha dado ningún frame en 6 s.'**
  String camNoFrames(String dispositivo);

  /// No description provided for @camNoCameras.
  ///
  /// In es, this message translates to:
  /// **'No encuentro ninguna cámara (/dev/video*). ¿Está conectada? Comprueba con `lsusb` que el sistema la ve.'**
  String get camNoCameras;

  /// No description provided for @camNoneWorked.
  ///
  /// In es, this message translates to:
  /// **'Ninguna cámara dio imagen:\n{detalle}'**
  String camNoneWorked(String detalle);

  /// No description provided for @bkRestoreAction.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get bkRestoreAction;

  /// No description provided for @fpUnselect.
  ///
  /// In es, this message translates to:
  /// **'Desmarcar'**
  String get fpUnselect;

  /// No description provided for @stClear.
  ///
  /// In es, this message translates to:
  /// **'Vaciar'**
  String get stClear;

  /// No description provided for @tlRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get tlRemove;

  /// No description provided for @tlUnrecognized.
  ///
  /// In es, this message translates to:
  /// **'Sin reconocer'**
  String get tlUnrecognized;

  /// No description provided for @tlNothingAlike.
  ///
  /// In es, this message translates to:
  /// **'nada parecido en la base — re-foto o quitar'**
  String get tlNothingAlike;

  /// No description provided for @tlTapToPick.
  ///
  /// In es, this message translates to:
  /// **'toca para elegir a mano entre parecidas'**
  String get tlTapToPick;

  /// No description provided for @tlReview.
  ///
  /// In es, this message translates to:
  /// **'revisar'**
  String get tlReview;

  /// No description provided for @lsQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get lsQuantity;

  /// No description provided for @scPhotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos'**
  String get scPhotos;

  /// No description provided for @ftWhichFolder.
  ///
  /// In es, this message translates to:
  /// **'¿En qué carpeta las quieres?'**
  String get ftWhichFolder;

  /// No description provided for @ftWhichFolderSub.
  ///
  /// In es, this message translates to:
  /// **'Entran en tu colección igual; la carpeta es solo una etiqueta para encontrarlas luego.'**
  String get ftWhichFolderSub;

  /// No description provided for @ftNone.
  ///
  /// In es, this message translates to:
  /// **'Ninguna'**
  String get ftNone;

  /// No description provided for @ftCards.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 carta} other{{n} cartas}}'**
  String ftCards(int n);

  /// No description provided for @ftNewFolderEllipsis.
  ///
  /// In es, this message translates to:
  /// **'Carpeta nueva…'**
  String get ftNewFolderEllipsis;

  /// No description provided for @ftNewFolder.
  ///
  /// In es, this message translates to:
  /// **'Carpeta nueva'**
  String get ftNewFolder;

  /// No description provided for @ftNewFolderHint.
  ///
  /// In es, this message translates to:
  /// **'Caja de la tienda, Para vender…'**
  String get ftNewFolderHint;

  /// No description provided for @sgTitle.
  ///
  /// In es, this message translates to:
  /// **'El ojo del escáner'**
  String get sgTitle;

  /// No description provided for @sgWhy.
  ///
  /// In es, this message translates to:
  /// **'Para reconocer cartas sin internet necesito la base de huellas visuales (~12 MB): la firma del arte de cada ilustración de Magic. Se descarga una vez.'**
  String get sgWhy;

  /// No description provided for @sgDownload.
  ///
  /// In es, this message translates to:
  /// **'Descargar base de huellas'**
  String get sgDownload;

  /// No description provided for @cmFullCard.
  ///
  /// In es, this message translates to:
  /// **'Ver ficha completa (precios y legalidad)'**
  String get cmFullCard;

  /// No description provided for @cmSwipeHint.
  ///
  /// In es, this message translates to:
  /// **'arrastra o usa ← → para pasar · toca fuera para cerrar'**
  String get cmSwipeHint;

  /// No description provided for @cmTapOutHint.
  ///
  /// In es, this message translates to:
  /// **'toca fuera para cerrar'**
  String get cmTapOutHint;

  /// No description provided for @fcTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Con qué carta empezaste?'**
  String get fcTitle;

  /// No description provided for @fcRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get fcRemove;

  /// No description provided for @fcSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar en tu colección'**
  String get fcSearchHint;

  /// No description provided for @fcNoMatch.
  ///
  /// In es, this message translates to:
  /// **'No encuentro ninguna carta con eso.'**
  String get fcNoMatch;

  /// No description provided for @acNoneWithFilters.
  ///
  /// In es, this message translates to:
  /// **'Nada por aquí con estos filtros.'**
  String get acNoneWithFilters;

  /// No description provided for @acAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get acAll;

  /// No description provided for @tsTitle.
  ///
  /// In es, this message translates to:
  /// **'Modo Test — vence al meta'**
  String get tsTitle;

  /// No description provided for @tsIntro.
  ///
  /// In es, this message translates to:
  /// **'Elige contra qué mazo del meta quieres jugar. ManaForge construye mazos con TUS cartas, simula cientos de partidas contra él y se queda con el que más gana — probando además cambios de carta uno a uno para afinarlo.'**
  String get tsIntro;

  /// No description provided for @tsLoadingMeta.
  ///
  /// In es, this message translates to:
  /// **'Cargando meta…'**
  String get tsLoadingMeta;

  /// No description provided for @tsLocalPresets.
  ///
  /// In es, this message translates to:
  /// **'Presets locales (sin conexión)'**
  String get tsLocalPresets;

  /// No description provided for @tsNoDeckToFace.
  ///
  /// In es, this message translates to:
  /// **'Con las cartas actuales no me sale ningún mazo completo que enfrentar. Añade más cartas y vuelve a intentarlo.'**
  String get tsNoDeckToFace;

  /// No description provided for @tsSimFailed.
  ///
  /// In es, this message translates to:
  /// **'No pude simular: {error}'**
  String tsSimFailed(String error);

  /// No description provided for @tsFormatShare.
  ///
  /// In es, this message translates to:
  /// **'{formato} · {cuota} del meta'**
  String tsFormatShare(String formato, String cuota);

  /// No description provided for @tsSimulating.
  ///
  /// In es, this message translates to:
  /// **'Simulando partidas… (unos segundos; todo en tu equipo)'**
  String get tsSimulating;

  /// No description provided for @tsFindBest.
  ///
  /// In es, this message translates to:
  /// **'Buscar mi mejor mazo contra {meta}'**
  String tsFindBest(String meta);

  /// No description provided for @tsHonesty.
  ///
  /// In es, this message translates to:
  /// **'Honestidad: la simulación entiende colores de maná, mulligans, evasión (volar, arrollar, toque mortal…), removal instantáneo y contramagia — pero no el texto completo de cada carta. El porcentaje sirve para COMPARAR tus mazos entre sí, no como predicción exacta.'**
  String get tsHonesty;

  /// No description provided for @tsChampion.
  ///
  /// In es, this message translates to:
  /// **'Tu campeón contra {meta}'**
  String tsChampion(String meta);

  /// No description provided for @tsWinRateLine.
  ///
  /// In es, this message translates to:
  /// **'de victorias estimadas · {mazos} mazos probados · {partidas} partidas por mazo'**
  String tsWinRateLine(int mazos, int partidas);

  /// No description provided for @tsNoDominant.
  ///
  /// In es, this message translates to:
  /// **'Ningún mazo de tu colección domina este enfrentamiento — este es el que mejor pelea. Mira sus debilidades en el detalle.'**
  String get tsNoDominant;

  /// No description provided for @tsSeeDeck.
  ///
  /// In es, this message translates to:
  /// **'Ver mazo completo (y guardarlo)'**
  String get tsSeeDeck;

  /// No description provided for @hsLevelLine.
  ///
  /// In es, this message translates to:
  /// **'{hechos}/{total} logros · {xp} XP para el nivel {nivel}'**
  String hsLevelLine(int hechos, int total, int xp, int nivel);

  /// No description provided for @hsForgeDecks.
  ///
  /// In es, this message translates to:
  /// **'Forjar mazos'**
  String get hsForgeDecks;

  /// No description provided for @hsTestYourself.
  ///
  /// In es, this message translates to:
  /// **'⚔ ponte a prueba'**
  String get hsTestYourself;

  /// No description provided for @bgCustom.
  ///
  /// In es, this message translates to:
  /// **'A medida'**
  String get bgCustom;

  /// No description provided for @bgPickCustom.
  ///
  /// In es, this message translates to:
  /// **'Elegir un color a medida'**
  String get bgPickCustom;

  /// No description provided for @bgCustomColor.
  ///
  /// In es, this message translates to:
  /// **'Color a medida'**
  String get bgCustomColor;

  /// No description provided for @bgSampleTab.
  ///
  /// In es, this message translates to:
  /// **'Rojo'**
  String get bgSampleTab;

  /// No description provided for @cfSortRecent.
  ///
  /// In es, this message translates to:
  /// **'Recién añadidas'**
  String get cfSortRecent;

  /// No description provided for @cfSortAlpha.
  ///
  /// In es, this message translates to:
  /// **'Nombre A-Z'**
  String get cfSortAlpha;

  /// No description provided for @cfSortCmc.
  ///
  /// In es, this message translates to:
  /// **'Coste'**
  String get cfSortCmc;

  /// No description provided for @cfSortQty.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get cfSortQty;

  /// No description provided for @cfSortBy.
  ///
  /// In es, this message translates to:
  /// **'Ordenar por'**
  String get cfSortBy;

  /// No description provided for @cfSort.
  ///
  /// In es, this message translates to:
  /// **'Orden'**
  String get cfSort;

  /// No description provided for @cfClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get cfClear;

  /// No description provided for @cfCost.
  ///
  /// In es, this message translates to:
  /// **'Coste'**
  String get cfCost;

  /// No description provided for @cfCostAll.
  ///
  /// In es, this message translates to:
  /// **'Coste: todos'**
  String get cfCostAll;

  /// No description provided for @cfCostN.
  ///
  /// In es, this message translates to:
  /// **'Coste {n}'**
  String cfCostN(String n);

  /// No description provided for @cfType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get cfType;

  /// No description provided for @cfTypeAll.
  ///
  /// In es, this message translates to:
  /// **'Tipo: todos'**
  String get cfTypeAll;

  /// No description provided for @cfTypeCreature.
  ///
  /// In es, this message translates to:
  /// **'Criaturas'**
  String get cfTypeCreature;

  /// No description provided for @cfTypeInstant.
  ///
  /// In es, this message translates to:
  /// **'Instantáneos'**
  String get cfTypeInstant;

  /// No description provided for @cfTypeSorcery.
  ///
  /// In es, this message translates to:
  /// **'Conjuros'**
  String get cfTypeSorcery;

  /// No description provided for @cfTypeArtifact.
  ///
  /// In es, this message translates to:
  /// **'Artefactos'**
  String get cfTypeArtifact;

  /// No description provided for @cfTypeEnchantment.
  ///
  /// In es, this message translates to:
  /// **'Encantamientos'**
  String get cfTypeEnchantment;

  /// No description provided for @cfTypeLand.
  ///
  /// In es, this message translates to:
  /// **'Tierras'**
  String get cfTypeLand;

  /// No description provided for @cfPower.
  ///
  /// In es, this message translates to:
  /// **'Ataque'**
  String get cfPower;

  /// No description provided for @cfPowerAll.
  ///
  /// In es, this message translates to:
  /// **'Ataque: todos'**
  String get cfPowerAll;

  /// No description provided for @cfPowerMin.
  ///
  /// In es, this message translates to:
  /// **'Ataque ≥ {n}'**
  String cfPowerMin(int n);

  /// No description provided for @cfToughness.
  ///
  /// In es, this message translates to:
  /// **'Defensa'**
  String get cfToughness;

  /// No description provided for @cfToughnessAll.
  ///
  /// In es, this message translates to:
  /// **'Defensa: todos'**
  String get cfToughnessAll;

  /// No description provided for @cfToughnessMin.
  ///
  /// In es, this message translates to:
  /// **'Defensa ≥ {n}'**
  String cfToughnessMin(int n);

  /// No description provided for @cfNoDate.
  ///
  /// In es, this message translates to:
  /// **'sin fecha'**
  String get cfNoDate;

  /// No description provided for @cfToday.
  ///
  /// In es, this message translates to:
  /// **'hoy'**
  String get cfToday;

  /// No description provided for @cfYesterday.
  ///
  /// In es, this message translates to:
  /// **'ayer'**
  String get cfYesterday;

  /// No description provided for @cfDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {n} días'**
  String cfDaysAgo(int n);

  /// No description provided for @pcWeek.
  ///
  /// In es, this message translates to:
  /// **'Semana'**
  String get pcWeek;

  /// No description provided for @pcMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get pcMonth;

  /// No description provided for @pcAll.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get pcAll;

  /// No description provided for @vpTapCorrect.
  ///
  /// In es, this message translates to:
  /// **'Toca la carta correcta'**
  String get vpTapCorrect;

  /// No description provided for @achCopias1.
  ///
  /// In es, this message translates to:
  /// **'La primera de muchas'**
  String get achCopias1;

  /// No description provided for @achCopias10.
  ///
  /// In es, this message translates to:
  /// **'Solo iba a comprar una'**
  String get achCopias10;

  /// No description provided for @achCopias50.
  ///
  /// In es, this message translates to:
  /// **'Ya no caben en la mano'**
  String get achCopias50;

  /// No description provided for @achCopias100.
  ///
  /// In es, this message translates to:
  /// **'Cien y subiendo'**
  String get achCopias100;

  /// No description provided for @achCopias500.
  ///
  /// In es, this message translates to:
  /// **'La caja se queda pequeña'**
  String get achCopias500;

  /// No description provided for @achCopias1000.
  ///
  /// In es, this message translates to:
  /// **'Mil. Y las quiero todas'**
  String get achCopias1000;

  /// No description provided for @achCopias5000.
  ///
  /// In es, this message translates to:
  /// **'Esto ya es un almacén'**
  String get achCopias5000;

  /// No description provided for @achCopias10000.
  ///
  /// In es, this message translates to:
  /// **'Diez mil, pero yo controlo'**
  String get achCopias10000;

  /// No description provided for @achCopiasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas en tu colección.'**
  String achCopiasDesc(String n);

  /// No description provided for @achDistintas25.
  ///
  /// In es, this message translates to:
  /// **'Aquí hay variedad'**
  String get achDistintas25;

  /// No description provided for @achDistintas100.
  ///
  /// In es, this message translates to:
  /// **'Cien caras distintas'**
  String get achDistintas100;

  /// No description provided for @achDistintas500.
  ///
  /// In es, this message translates to:
  /// **'Media biblioteca'**
  String get achDistintas500;

  /// No description provided for @achDistintas1000.
  ///
  /// In es, this message translates to:
  /// **'Enciclopedia andante'**
  String get achDistintas1000;

  /// No description provided for @achDistintas2500.
  ///
  /// In es, this message translates to:
  /// **'Ya no me las sé todas'**
  String get achDistintas2500;

  /// No description provided for @achDistintas5000.
  ///
  /// In es, this message translates to:
  /// **'El archivo'**
  String get achDistintas5000;

  /// No description provided for @achDistintasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas DISTINTAS (sin contar repetidas).'**
  String achDistintasDesc(String n);

  /// No description provided for @achPlaysets1.
  ///
  /// In es, this message translates to:
  /// **'Cuatro iguales'**
  String get achPlaysets1;

  /// No description provided for @achPlaysets20.
  ///
  /// In es, this message translates to:
  /// **'Veinte playsets, cero mazos'**
  String get achPlaysets20;

  /// No description provided for @achPlaysets1Desc.
  ///
  /// In es, this message translates to:
  /// **'Ten 4 copias de una misma carta.'**
  String get achPlaysets1Desc;

  /// No description provided for @achPlaysets20Desc.
  ///
  /// In es, this message translates to:
  /// **'Ten 20 playsets distintos (4 copias de cada uno).'**
  String get achPlaysets20Desc;

  /// No description provided for @achComunes10.
  ///
  /// In es, this message translates to:
  /// **'Las que nadie quiere'**
  String get achComunes10;

  /// No description provided for @achComunes50.
  ///
  /// In es, this message translates to:
  /// **'El montón de siempre'**
  String get achComunes50;

  /// No description provided for @achComunes200.
  ///
  /// In es, this message translates to:
  /// **'Rey del montón'**
  String get achComunes200;

  /// No description provided for @achComunes500.
  ///
  /// In es, this message translates to:
  /// **'Marea de comunes'**
  String get achComunes500;

  /// No description provided for @achComunesDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas comunes distintas.'**
  String achComunesDesc(String n);

  /// No description provided for @achInfrecuentes10.
  ///
  /// In es, this message translates to:
  /// **'Algo mejor que común'**
  String get achInfrecuentes10;

  /// No description provided for @achInfrecuentes50.
  ///
  /// In es, this message translates to:
  /// **'Plata fina'**
  String get achInfrecuentes50;

  /// No description provided for @achInfrecuentes200.
  ///
  /// In es, this message translates to:
  /// **'Cazador de infrecuentes'**
  String get achInfrecuentes200;

  /// No description provided for @achInfrecuentes500.
  ///
  /// In es, this message translates to:
  /// **'Plata a espuertas'**
  String get achInfrecuentes500;

  /// No description provided for @achInfrecuentesDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas infrecuentes distintas.'**
  String achInfrecuentesDesc(String n);

  /// No description provided for @achRaras5.
  ///
  /// In es, this message translates to:
  /// **'Suena bien al abrir el sobre'**
  String get achRaras5;

  /// No description provided for @achRaras25.
  ///
  /// In es, this message translates to:
  /// **'Cofre de raras'**
  String get achRaras25;

  /// No description provided for @achRaras100.
  ///
  /// In es, this message translates to:
  /// **'Cien raras y ninguna jugable'**
  String get achRaras100;

  /// No description provided for @achRaras300.
  ///
  /// In es, this message translates to:
  /// **'Cámara acorazada'**
  String get achRaras300;

  /// No description provided for @achRarasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas raras distintas.'**
  String achRarasDesc(String n);

  /// No description provided for @achMiticas1.
  ///
  /// In es, this message translates to:
  /// **'Mi primera mítica'**
  String get achMiticas1;

  /// No description provided for @achMiticas10.
  ///
  /// In es, this message translates to:
  /// **'Diez míticas'**
  String get achMiticas10;

  /// No description provided for @achMiticas50.
  ///
  /// In es, this message translates to:
  /// **'Coleccionista mítico'**
  String get achMiticas50;

  /// No description provided for @achMiticas150.
  ///
  /// In es, this message translates to:
  /// **'Panteón mítico'**
  String get achMiticas150;

  /// No description provided for @achMiticasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas míticas distintas.'**
  String achMiticasDesc(String n);

  /// No description provided for @achBlancas25.
  ///
  /// In es, this message translates to:
  /// **'Orden y concierto'**
  String get achBlancas25;

  /// No description provided for @achBlancas100.
  ///
  /// In es, this message translates to:
  /// **'Ejército de plata'**
  String get achBlancas100;

  /// No description provided for @achBlancasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas blancas distintas.'**
  String achBlancasDesc(String n);

  /// No description provided for @achAzules25.
  ///
  /// In es, this message translates to:
  /// **'Eso no te lo permito'**
  String get achAzules25;

  /// No description provided for @achAzules100.
  ///
  /// In es, this message translates to:
  /// **'Torre de marfil'**
  String get achAzules100;

  /// No description provided for @achAzulesDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas azules distintas.'**
  String achAzulesDesc(String n);

  /// No description provided for @achNegras25.
  ///
  /// In es, this message translates to:
  /// **'Pacto oscuro'**
  String get achNegras25;

  /// No description provided for @achNegras100.
  ///
  /// In es, this message translates to:
  /// **'Señor de la cripta'**
  String get achNegras100;

  /// No description provided for @achNegrasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas negras distintas.'**
  String achNegrasDesc(String n);

  /// No description provided for @achRojas25.
  ///
  /// In es, this message translates to:
  /// **'A quemarlo todo'**
  String get achRojas25;

  /// No description provided for @achRojas100.
  ///
  /// In es, this message translates to:
  /// **'Incendio general'**
  String get achRojas100;

  /// No description provided for @achRojasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas rojas distintas.'**
  String achRojasDesc(String n);

  /// No description provided for @achVerdes25.
  ///
  /// In es, this message translates to:
  /// **'Un brote'**
  String get achVerdes25;

  /// No description provided for @achVerdes100.
  ///
  /// In es, this message translates to:
  /// **'El bosque entero'**
  String get achVerdes100;

  /// No description provided for @achVerdesDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas verdes distintas.'**
  String achVerdesDesc(String n);

  /// No description provided for @achIncoloras25.
  ///
  /// In es, this message translates to:
  /// **'Metal frío'**
  String get achIncoloras25;

  /// No description provided for @achIncoloras100.
  ///
  /// In es, this message translates to:
  /// **'Forja eterna'**
  String get achIncoloras100;

  /// No description provided for @achIncolorasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas incoloras distintas.'**
  String achIncolorasDesc(String n);

  /// No description provided for @achArcoiris.
  ///
  /// In es, this message translates to:
  /// **'Los cinco colores'**
  String get achArcoiris;

  /// No description provided for @achArcoirisDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten al menos una carta de cada uno de los 5 colores.'**
  String get achArcoirisDesc;

  /// No description provided for @achMulticolor10.
  ///
  /// In es, this message translates to:
  /// **'Mezclando colores'**
  String get achMulticolor10;

  /// No description provided for @achMulticolor50.
  ///
  /// In es, this message translates to:
  /// **'Alianza dorada'**
  String get achMulticolor50;

  /// No description provided for @achMulticolorDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas multicolor distintas.'**
  String achMulticolorDesc(String n);

  /// No description provided for @achCincocolores.
  ///
  /// In es, this message translates to:
  /// **'Los cinco de golpe'**
  String get achCincocolores;

  /// No description provided for @achCincocoloresDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carta con los cinco colores.'**
  String get achCincocoloresDesc;

  /// No description provided for @achSets1.
  ///
  /// In es, this message translates to:
  /// **'Primera expansión'**
  String get achSets1;

  /// No description provided for @achSets5.
  ///
  /// In es, this message translates to:
  /// **'Cinco mundos'**
  String get achSets5;

  /// No description provided for @achSets10.
  ///
  /// In es, this message translates to:
  /// **'Viajero de planos'**
  String get achSets10;

  /// No description provided for @achSets25.
  ///
  /// In es, this message translates to:
  /// **'Trotamundos'**
  String get achSets25;

  /// No description provided for @achSets50.
  ///
  /// In es, this message translates to:
  /// **'Medio multiverso'**
  String get achSets50;

  /// No description provided for @achSetsDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten cartas de {n} expansiones distintas.'**
  String achSetsDesc(String n);

  /// No description provided for @achSetscompletos1.
  ///
  /// In es, this message translates to:
  /// **'No falta ni una'**
  String get achSetscompletos1;

  /// No description provided for @achSetscompletos3.
  ///
  /// In es, this message translates to:
  /// **'Tres álbumes enteros'**
  String get achSetscompletos3;

  /// No description provided for @achSetscompletos10.
  ///
  /// In es, this message translates to:
  /// **'Maestro del álbum'**
  String get achSetscompletos10;

  /// No description provided for @achSetscompletos1Desc.
  ///
  /// In es, this message translates to:
  /// **'Completa una expansión entera en el Álbum.'**
  String get achSetscompletos1Desc;

  /// No description provided for @achSetscompletos3Desc.
  ///
  /// In es, this message translates to:
  /// **'Completa {n} expansiones enteras.'**
  String achSetscompletos3Desc(String n);

  /// No description provided for @achAnyos5.
  ///
  /// In es, this message translates to:
  /// **'Cinco años de cartón'**
  String get achAnyos5;

  /// No description provided for @achAnyos15.
  ///
  /// In es, this message translates to:
  /// **'Máquina del tiempo'**
  String get achAnyos15;

  /// No description provided for @achAnyosDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten cartas de {n} años de salida distintos.'**
  String achAnyosDesc(String n);

  /// No description provided for @achValor10.
  ///
  /// In es, this message translates to:
  /// **'Primeros euros'**
  String get achValor10;

  /// No description provided for @achValor50.
  ///
  /// In es, this message translates to:
  /// **'La hucha'**
  String get achValor50;

  /// No description provided for @achValor250.
  ///
  /// In es, this message translates to:
  /// **'Ahí va la paga'**
  String get achValor250;

  /// No description provided for @achValor1000.
  ///
  /// In es, this message translates to:
  /// **'Ahí va todo mi dinero'**
  String get achValor1000;

  /// No description provided for @achValor5000.
  ///
  /// In es, this message translates to:
  /// **'No se lo digas a nadie'**
  String get achValor5000;

  /// No description provided for @achValor10000.
  ///
  /// In es, this message translates to:
  /// **'Vale más que mi coche'**
  String get achValor10000;

  /// No description provided for @achValor25000.
  ///
  /// In es, this message translates to:
  /// **'Colección de museo'**
  String get achValor25000;

  /// No description provided for @achValorDesc.
  ///
  /// In es, this message translates to:
  /// **'Que tu colección valga {n} € o más.'**
  String achValorDesc(String n);

  /// No description provided for @achJoya20.
  ///
  /// In es, this message translates to:
  /// **'Una carta de las buenas'**
  String get achJoya20;

  /// No description provided for @achJoya100.
  ///
  /// In es, this message translates to:
  /// **'La joya de la colección'**
  String get achJoya100;

  /// No description provided for @achJoya500.
  ///
  /// In es, this message translates to:
  /// **'Esta no sale de la funda'**
  String get achJoya500;

  /// No description provided for @achJoya1000.
  ///
  /// In es, this message translates to:
  /// **'Mil euros en una sola funda'**
  String get achJoya1000;

  /// No description provided for @achJoya2500.
  ///
  /// In es, this message translates to:
  /// **'El santo grial'**
  String get achJoya2500;

  /// No description provided for @achJoyaDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una sola carta que valga {n} € o más.'**
  String achJoyaDesc(String n);

  /// No description provided for @achFoils1.
  ///
  /// In es, this message translates to:
  /// **'Primer brillo'**
  String get achFoils1;

  /// No description provided for @achFoils10.
  ///
  /// In es, this message translates to:
  /// **'Destellos'**
  String get achFoils10;

  /// No description provided for @achFoils50.
  ///
  /// In es, this message translates to:
  /// **'Brilla la caja'**
  String get achFoils50;

  /// No description provided for @achFoils200.
  ///
  /// In es, this message translates to:
  /// **'Aquí ya no hay nada mate'**
  String get achFoils200;

  /// No description provided for @achFoils500.
  ///
  /// In es, this message translates to:
  /// **'Todo brilla'**
  String get achFoils500;

  /// No description provided for @achFoils1000.
  ///
  /// In es, this message translates to:
  /// **'Fábrica de brillos'**
  String get achFoils1000;

  /// No description provided for @achFoilsDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten {n} cartas foil.'**
  String achFoilsDesc(String n);

  /// No description provided for @achFoiljoya10.
  ///
  /// In es, this message translates to:
  /// **'Foil de las buenas'**
  String get achFoiljoya10;

  /// No description provided for @achFoiljoya50.
  ///
  /// In es, this message translates to:
  /// **'Foil de las caras'**
  String get achFoiljoya50;

  /// No description provided for @achFoiljoya200.
  ///
  /// In es, this message translates to:
  /// **'Foil de museo'**
  String get achFoiljoya200;

  /// No description provided for @achFoiljoyaDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una foil que valga {n} € o más.'**
  String achFoiljoyaDesc(String n);

  /// No description provided for @achFoilvalor50.
  ///
  /// In es, this message translates to:
  /// **'Vitrina que brilla'**
  String get achFoilvalor50;

  /// No description provided for @achFoilvalor250.
  ///
  /// In es, this message translates to:
  /// **'Vitrina cara'**
  String get achFoilvalor250;

  /// No description provided for @achFoilvalor1000.
  ///
  /// In es, this message translates to:
  /// **'Mil euros de brillo'**
  String get achFoilvalor1000;

  /// No description provided for @achFoilvalor5000.
  ///
  /// In es, this message translates to:
  /// **'Vitrina de museo'**
  String get achFoilvalor5000;

  /// No description provided for @achFoilvalorDesc.
  ///
  /// In es, this message translates to:
  /// **'Que todas tus foils juntas valgan {n} € o más.'**
  String achFoilvalorDesc(String n);

  /// No description provided for @achMazos1.
  ///
  /// In es, this message translates to:
  /// **'Primer mazo'**
  String get achMazos1;

  /// No description provided for @achMazos5.
  ///
  /// In es, this message translates to:
  /// **'Cinco mazos guardados'**
  String get achMazos5;

  /// No description provided for @achMazos25.
  ///
  /// In es, this message translates to:
  /// **'El taller no para'**
  String get achMazos25;

  /// No description provided for @achMazosDesc.
  ///
  /// In es, this message translates to:
  /// **'Guarda {n} mazos hechos con Forge.'**
  String achMazosDesc(String n);

  /// No description provided for @achMazoscore.
  ///
  /// In es, this message translates to:
  /// **'Mazo redondo'**
  String get achMazoscore;

  /// No description provided for @achMazoscoreDesc.
  ///
  /// In es, this message translates to:
  /// **'Genera un mazo con puntuación 90 o más.'**
  String get achMazoscoreDesc;

  /// No description provided for @achMazocolores3.
  ///
  /// In es, this message translates to:
  /// **'Tricolor'**
  String get achMazocolores3;

  /// No description provided for @achMazocolores5.
  ///
  /// In es, this message translates to:
  /// **'Arcoíris jugable'**
  String get achMazocolores5;

  /// No description provided for @achMazocoloresDesc.
  ///
  /// In es, this message translates to:
  /// **'Guarda un mazo de {n} colores.'**
  String achMazocoloresDesc(String n);

  /// No description provided for @achMazomono.
  ///
  /// In es, this message translates to:
  /// **'Sin mezclar nada'**
  String get achMazomono;

  /// No description provided for @achMazomonoDesc.
  ///
  /// In es, this message translates to:
  /// **'Guarda un mazo de un solo color.'**
  String get achMazomonoDesc;

  /// No description provided for @achMazocommander.
  ///
  /// In es, this message translates to:
  /// **'Al mando'**
  String get achMazocommander;

  /// No description provided for @achMazocommanderDesc.
  ///
  /// In es, this message translates to:
  /// **'Guarda un mazo de Commander.'**
  String get achMazocommanderDesc;

  /// No description provided for @achEscaneadas1.
  ///
  /// In es, this message translates to:
  /// **'Primer escaneo'**
  String get achEscaneadas1;

  /// No description provided for @achEscaneadas50.
  ///
  /// In es, this message translates to:
  /// **'Mano rápida'**
  String get achEscaneadas50;

  /// No description provided for @achEscaneadas500.
  ///
  /// In es, this message translates to:
  /// **'Escáner en serie'**
  String get achEscaneadas500;

  /// No description provided for @achEscaneadas2000.
  ///
  /// In es, this message translates to:
  /// **'Escaneo hasta dormido'**
  String get achEscaneadas2000;

  /// No description provided for @achEscaneadasDesc.
  ///
  /// In es, this message translates to:
  /// **'Escanea {n} cartas con la cámara o por foto.'**
  String achEscaneadasDesc(String n);

  /// No description provided for @achFoto9.
  ///
  /// In es, this message translates to:
  /// **'Página entera de una foto'**
  String get achFoto9;

  /// No description provided for @achFoto20.
  ///
  /// In es, this message translates to:
  /// **'Veinte de una tacada'**
  String get achFoto20;

  /// No description provided for @achFotoDesc.
  ///
  /// In es, this message translates to:
  /// **'Reconoce {n} cartas en una sola foto.'**
  String achFotoDesc(String n);

  /// No description provided for @achEscaneoperfecto.
  ///
  /// In es, this message translates to:
  /// **'Ni una para revisar'**
  String get achEscaneoperfecto;

  /// No description provided for @achEscaneoperfectoDesc.
  ///
  /// In es, this message translates to:
  /// **'Escanea una página entera sin que ninguna carta quede para revisar.'**
  String get achEscaneoperfectoDesc;

  /// No description provided for @achDias2.
  ///
  /// In es, this message translates to:
  /// **'Has vuelto'**
  String get achDias2;

  /// No description provided for @achDias7.
  ///
  /// In es, this message translates to:
  /// **'Una semana aquí'**
  String get achDias7;

  /// No description provided for @achDias30.
  ///
  /// In es, this message translates to:
  /// **'Un mes aquí'**
  String get achDias30;

  /// No description provided for @achDias100.
  ///
  /// In es, this message translates to:
  /// **'Cien días aquí'**
  String get achDias100;

  /// No description provided for @achDiasDesc.
  ///
  /// In es, this message translates to:
  /// **'Usa ManaForge {n} días distintos.'**
  String achDiasDesc(String n);

  /// No description provided for @achRacha3.
  ///
  /// In es, this message translates to:
  /// **'Tres seguidos'**
  String get achRacha3;

  /// No description provided for @achRacha7.
  ///
  /// In es, this message translates to:
  /// **'Semana perfecta'**
  String get achRacha7;

  /// No description provided for @achRacha30.
  ///
  /// In es, this message translates to:
  /// **'Mes sin fallar'**
  String get achRacha30;

  /// No description provided for @achRachaDesc.
  ///
  /// In es, this message translates to:
  /// **'Entra {n} días seguidos.'**
  String achRachaDesc(String n);

  /// No description provided for @achSemanas.
  ///
  /// In es, this message translates to:
  /// **'Cuatro semanas sin faltar'**
  String get achSemanas;

  /// No description provided for @achSemanasDesc.
  ///
  /// In es, this message translates to:
  /// **'Usa ManaForge 4 semanas seguidas.'**
  String get achSemanasDesc;

  /// No description provided for @achCarpetas1.
  ///
  /// In es, this message translates to:
  /// **'Empieza el orden'**
  String get achCarpetas1;

  /// No description provided for @achCarpetas5.
  ///
  /// In es, this message translates to:
  /// **'Todo clasificado'**
  String get achCarpetas5;

  /// No description provided for @achCarpetasDesc.
  ///
  /// In es, this message translates to:
  /// **'Crea {n} carpetas.'**
  String achCarpetasDesc(String n);

  /// No description provided for @achCarpetagrande.
  ///
  /// In es, this message translates to:
  /// **'Carpetón'**
  String get achCarpetagrande;

  /// No description provided for @achCarpetagrandeDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carpeta con 100 cartas o más.'**
  String get achCarpetagrandeDesc;

  /// No description provided for @achCarpetavalor.
  ///
  /// In es, this message translates to:
  /// **'Esta carpeta no la presto'**
  String get achCarpetavalor;

  /// No description provided for @achCarpetavalorDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carpeta que valga 100 € o más.'**
  String get achCarpetavalorDesc;

  /// No description provided for @achTierrasbasicas.
  ///
  /// In es, this message translates to:
  /// **'Las cinco básicas'**
  String get achTierrasbasicas;

  /// No description provided for @achTierrasbasicasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten los cinco tipos de tierra básica (llanura, isla, pantano, montaña y bosque).'**
  String get achTierrasbasicasDesc;

  /// No description provided for @achFuerza.
  ///
  /// In es, this message translates to:
  /// **'Menudo bicho'**
  String get achFuerza;

  /// No description provided for @achFuerzaDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una criatura de fuerza 10 o más.'**
  String get achFuerzaDesc;

  /// No description provided for @achCoste.
  ///
  /// In es, this message translates to:
  /// **'Esta no la lanzo en la vida'**
  String get achCoste;

  /// No description provided for @achCosteDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carta de coste convertido 10 o más.'**
  String get achCosteDesc;

  /// No description provided for @achCostecero.
  ///
  /// In es, this message translates to:
  /// **'Gratis'**
  String get achCostecero;

  /// No description provided for @achCosteceroDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carta de coste 0.'**
  String get achCosteceroDesc;

  /// No description provided for @achTipos.
  ///
  /// In es, this message translates to:
  /// **'De todo un poco'**
  String get achTipos;

  /// No description provided for @achTiposDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten al menos una criatura, un instantáneo, un conjuro, un artefacto, un encantamiento, una tierra y un planeswalker.'**
  String get achTiposDesc;

  /// No description provided for @achPlaneswalkers.
  ///
  /// In es, this message translates to:
  /// **'Compañía de planeswalkers'**
  String get achPlaneswalkers;

  /// No description provided for @achPlaneswalkersDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten 5 planeswalkers distintos.'**
  String get achPlaneswalkersDesc;

  /// No description provided for @achNoventas.
  ///
  /// In es, this message translates to:
  /// **'Reliquia de los 90'**
  String get achNoventas;

  /// No description provided for @achNoventasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carta de los años 90.'**
  String get achNoventasDesc;

  /// No description provided for @achIdiomas1.
  ///
  /// In es, this message translates to:
  /// **'Esta no la sé leer'**
  String get achIdiomas1;

  /// No description provided for @achIdiomas25.
  ///
  /// In es, this message translates to:
  /// **'Colección políglota'**
  String get achIdiomas25;

  /// No description provided for @achIdiomas1Desc.
  ///
  /// In es, this message translates to:
  /// **'Ten una carta en un idioma que no sea inglés.'**
  String get achIdiomas1Desc;

  /// No description provided for @achIdiomas25Desc.
  ///
  /// In es, this message translates to:
  /// **'Ten 25 cartas en otros idiomas.'**
  String get achIdiomas25Desc;

  /// No description provided for @achWishlist.
  ///
  /// In es, this message translates to:
  /// **'La lista de los caprichos'**
  String get achWishlist;

  /// No description provided for @achWishlistDesc.
  ///
  /// In es, this message translates to:
  /// **'Apunta 20 cartas en la wishlist.'**
  String get achWishlistDesc;

  /// No description provided for @achTierBronze.
  ///
  /// In es, this message translates to:
  /// **'Bronce'**
  String get achTierBronze;

  /// No description provided for @achTierSilver.
  ///
  /// In es, this message translates to:
  /// **'Plata'**
  String get achTierSilver;

  /// No description provided for @achTierGold.
  ///
  /// In es, this message translates to:
  /// **'Oro'**
  String get achTierGold;

  /// No description provided for @achTierMythic.
  ///
  /// In es, this message translates to:
  /// **'Mítico'**
  String get achTierMythic;

  /// No description provided for @achCatCollection.
  ///
  /// In es, this message translates to:
  /// **'Colección'**
  String get achCatCollection;

  /// No description provided for @achCatRarity.
  ///
  /// In es, this message translates to:
  /// **'Rarezas'**
  String get achCatRarity;

  /// No description provided for @achCatColor.
  ///
  /// In es, this message translates to:
  /// **'Colores'**
  String get achCatColor;

  /// No description provided for @achCatSets.
  ///
  /// In es, this message translates to:
  /// **'Expansiones'**
  String get achCatSets;

  /// No description provided for @achCatValue.
  ///
  /// In es, this message translates to:
  /// **'Valor'**
  String get achCatValue;

  /// No description provided for @achCatFoils.
  ///
  /// In es, this message translates to:
  /// **'Foils'**
  String get achCatFoils;

  /// No description provided for @achCatForge.
  ///
  /// In es, this message translates to:
  /// **'Forge'**
  String get achCatForge;

  /// No description provided for @achCatScanner.
  ///
  /// In es, this message translates to:
  /// **'Escáner'**
  String get achCatScanner;

  /// No description provided for @achCatDedication.
  ///
  /// In es, this message translates to:
  /// **'Dedicación'**
  String get achCatDedication;

  /// No description provided for @achCatFolders.
  ///
  /// In es, this message translates to:
  /// **'Carpetas'**
  String get achCatFolders;

  /// No description provided for @achCatCuriosities.
  ///
  /// In es, this message translates to:
  /// **'Curiosidades'**
  String get achCatCuriosities;

  /// No description provided for @achRankApprentice.
  ///
  /// In es, this message translates to:
  /// **'Aprendiz'**
  String get achRankApprentice;

  /// No description provided for @achRankSummoner.
  ///
  /// In es, this message translates to:
  /// **'Invocador'**
  String get achRankSummoner;

  /// No description provided for @achRankMage.
  ///
  /// In es, this message translates to:
  /// **'Mago'**
  String get achRankMage;

  /// No description provided for @achRankArchmage.
  ///
  /// In es, this message translates to:
  /// **'Archimago'**
  String get achRankArchmage;

  /// No description provided for @achRankMaster.
  ///
  /// In es, this message translates to:
  /// **'Maestro'**
  String get achRankMaster;

  /// No description provided for @achRankPlaneswalker.
  ///
  /// In es, this message translates to:
  /// **'Planeswalker'**
  String get achRankPlaneswalker;

  /// No description provided for @bkConfirmWord.
  ///
  /// In es, this message translates to:
  /// **'CONFIRMAR'**
  String get bkConfirmWord;

  /// No description provided for @rfTitle.
  ///
  /// In es, this message translates to:
  /// **'Reset de fábrica'**
  String get rfTitle;

  /// No description provided for @rfIntro.
  ///
  /// In es, this message translates to:
  /// **'Deja la app como recién instalada: sin colección, sin mazos y sin bases descargadas.'**
  String get rfIntro;

  /// No description provided for @rfButton.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo'**
  String get rfButton;

  /// No description provided for @rfConfirmTitle1.
  ///
  /// In es, this message translates to:
  /// **'¿Borrar todos los datos?'**
  String get rfConfirmTitle1;

  /// No description provided for @rfWillDelete.
  ///
  /// In es, this message translates to:
  /// **'Se borrarán: la colección, los mazos, las carpetas, los logros, los certificados, la lista de deseos, el historial de valor, los ajustes y fondos, y las bases descargadas de cartas, precios y huellas.'**
  String get rfWillDelete;

  /// No description provided for @rfBackupFirst.
  ///
  /// In es, this message translates to:
  /// **'Antes de borrar nada se guardará una copia de seguridad automática; podrás restaurarla desde Ajustes → Datos.'**
  String get rfBackupFirst;

  /// No description provided for @rfTypeWord.
  ///
  /// In es, this message translates to:
  /// **'Escribe {palabra} para continuar.'**
  String rfTypeWord(String palabra);

  /// No description provided for @rfDeleteWord.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR'**
  String get rfDeleteWord;

  /// No description provided for @rfContinueAction.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get rfContinueAction;

  /// No description provided for @rfConfirmTitle2.
  ///
  /// In es, this message translates to:
  /// **'Última confirmación'**
  String get rfConfirmTitle2;

  /// No description provided for @rfConfirmBody2.
  ///
  /// In es, this message translates to:
  /// **'Esto borra todos tus datos de este equipo. Solo podrás volver atrás restaurando la copia que se guarda ahora.'**
  String get rfConfirmBody2;

  /// No description provided for @rfEraseAction.
  ///
  /// In es, this message translates to:
  /// **'Borrar definitivamente'**
  String get rfEraseAction;

  /// No description provided for @rfWorking.
  ///
  /// In es, this message translates to:
  /// **'Borrando los datos… no cierres la app.'**
  String get rfWorking;

  /// No description provided for @rfBackupFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la copia previa, así que NO se ha borrado nada. {motivo}'**
  String rfBackupFailed(String motivo);

  /// No description provided for @rfPartial.
  ///
  /// In es, this message translates to:
  /// **'No se pudo borrar todo. Queda: {cosas}. Puedes reintentarlo desde Ajustes tras reiniciar.'**
  String rfPartial(String cosas);

  /// No description provided for @rfHalfDone.
  ///
  /// In es, this message translates to:
  /// **'El borrado se quedó a medias. La app volverá a la pantalla de arranque; si algo sigue ahí, reintenta el reset.'**
  String get rfHalfDone;

  /// No description provided for @dbErrCards.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar la base de cartas (HTTP {codigo}). Vuelve a intentarlo dentro de un rato.'**
  String dbErrCards(String codigo);

  /// No description provided for @dbErrHashes.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar la base de huellas (HTTP {codigo}). Vuelve a intentarlo dentro de un rato.'**
  String dbErrHashes(String codigo);

  /// No description provided for @dbErrPrices.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar el histórico de precios (HTTP {codigo}). Vuelve a intentarlo dentro de un rato.'**
  String dbErrPrices(String codigo);

  /// No description provided for @ddCardCount.
  ///
  /// In es, this message translates to:
  /// **'{n} cartas'**
  String ddCardCount(int n);

  /// No description provided for @ddForgedWith.
  ///
  /// In es, this message translates to:
  /// **'Forjado con ManaForge'**
  String get ddForgedWith;

  /// No description provided for @fxThemeLifegain.
  ///
  /// In es, this message translates to:
  /// **'drenaje de vida'**
  String get fxThemeLifegain;

  /// No description provided for @fxThemeSacrifice.
  ///
  /// In es, this message translates to:
  /// **'sacrificio'**
  String get fxThemeSacrifice;

  /// No description provided for @fxThemeSpells.
  ///
  /// In es, this message translates to:
  /// **'hechizos'**
  String get fxThemeSpells;

  /// No description provided for @fxThemeArtifacts.
  ///
  /// In es, this message translates to:
  /// **'artefactos'**
  String get fxThemeArtifacts;

  /// No description provided for @fxThemeCounters.
  ///
  /// In es, this message translates to:
  /// **'contadores +1/+1'**
  String get fxThemeCounters;

  /// No description provided for @fxThemeTokens.
  ///
  /// In es, this message translates to:
  /// **'enjambre'**
  String get fxThemeTokens;

  /// No description provided for @fxThemeGraveyard.
  ///
  /// In es, this message translates to:
  /// **'cementerio'**
  String get fxThemeGraveyard;

  /// No description provided for @fxThemeReanimator.
  ///
  /// In es, this message translates to:
  /// **'reanimación'**
  String get fxThemeReanimator;

  /// No description provided for @fxThemeTribal.
  ///
  /// In es, this message translates to:
  /// **'tribu de {tribe}'**
  String fxThemeTribal(String tribe);

  /// No description provided for @fxThemeGoodstuff.
  ///
  /// In es, this message translates to:
  /// **'lo mejor de tus cartas'**
  String get fxThemeGoodstuff;

  /// No description provided for @fxTagLifegain.
  ///
  /// In es, this message translates to:
  /// **'Cada punto de vida que ganas es daño para ellos: drena y aguanta.'**
  String get fxTagLifegain;

  /// No description provided for @fxTagSacrifice.
  ///
  /// In es, this message translates to:
  /// **'Tus criaturas valen más muertas: sacrifícalas y cobra el peaje.'**
  String get fxTagSacrifice;

  /// No description provided for @fxTagSpells.
  ///
  /// In es, this message translates to:
  /// **'Cada instantáneo cuenta: juega en el turno del rival y castiga.'**
  String get fxTagSpells;

  /// No description provided for @fxTagArtifacts.
  ///
  /// In es, this message translates to:
  /// **'Monta tu taller: cada artefacto hace más fuertes a los demás.'**
  String get fxTagArtifacts;

  /// No description provided for @fxTagCounters.
  ///
  /// In es, this message translates to:
  /// **'Contadores +1/+1: tus criaturas crecen hasta ser inalcanzables.'**
  String get fxTagCounters;

  /// No description provided for @fxTagTokens.
  ///
  /// In es, this message translates to:
  /// **'Inunda la mesa de fichas: donde ellos tienen una, tú tienes cinco.'**
  String get fxTagTokens;

  /// No description provided for @fxTagGraveyard.
  ///
  /// In es, this message translates to:
  /// **'Tu cementerio es tu segunda mano: llénalo y recicla lo mejor.'**
  String get fxTagGraveyard;

  /// No description provided for @fxTagAggro.
  ///
  /// In es, this message translates to:
  /// **'Sal rápido y pega a la cara: la partida debería acabar pronto.'**
  String get fxTagAggro;

  /// No description provided for @fxTagTempo.
  ///
  /// In es, this message translates to:
  /// **'Presiona pronto y protege la ventaja con tus hechizos.'**
  String get fxTagTempo;

  /// No description provided for @fxTagMidrange.
  ///
  /// In es, this message translates to:
  /// **'Cambia bien tus cartas y gana el medio juego con {tema}.'**
  String fxTagMidrange(String tema);

  /// No description provided for @fxTagControl.
  ///
  /// In es, this message translates to:
  /// **'Aguanta, responde a todo y remata cuando la mesa sea tuya.'**
  String get fxTagControl;

  /// No description provided for @fxMidLifegain.
  ///
  /// In es, this message translates to:
  /// **'Encadena tus fuentes de vida con los que castigan al rival por ello.'**
  String get fxMidLifegain;

  /// No description provided for @fxMidSacrifice.
  ///
  /// In es, this message translates to:
  /// **'Sacrifica lo barato para robar, drenar o hacer crecer al resto.'**
  String get fxMidSacrifice;

  /// No description provided for @fxMidSpells.
  ///
  /// In es, this message translates to:
  /// **'Guarda maná abierto: tus criaturas crecen con cada hechizo que lanzas.'**
  String get fxMidSpells;

  /// No description provided for @fxMidArtifacts.
  ///
  /// In es, this message translates to:
  /// **'Despliega artefactos baratos y activa a los que los cuentan.'**
  String get fxMidArtifacts;

  /// No description provided for @fxMidCounters.
  ///
  /// In es, this message translates to:
  /// **'Apila contadores en una o dos criaturas y protégelas.'**
  String get fxMidCounters;

  /// No description provided for @fxMidTokens.
  ///
  /// In es, this message translates to:
  /// **'Genera fichas cada turno y busca los efectos que las hacen mayores.'**
  String get fxMidTokens;

  /// No description provided for @fxMidGraveyard.
  ///
  /// In es, this message translates to:
  /// **'Muele y descarta con intención: lo que cae al cementerio vuelve.'**
  String get fxMidGraveyard;

  /// No description provided for @fxEndLifegain.
  ///
  /// In es, this message translates to:
  /// **'Con la vida alta, cambia a modo agresivo: ellos ya no llegan.'**
  String get fxEndLifegain;

  /// No description provided for @fxEndSacrifice.
  ///
  /// In es, this message translates to:
  /// **'El valor acumulado te da la partida: cada cambio te sale gratis.'**
  String get fxEndSacrifice;

  /// No description provided for @fxEndSpells.
  ///
  /// In es, this message translates to:
  /// **'Un par de hechizos en el mismo turno y tus criaturas cierran.'**
  String get fxEndSpells;

  /// No description provided for @fxEndArtifacts.
  ///
  /// In es, this message translates to:
  /// **'Tu mesa vale el doble que la suya: remata con tus payoffs.'**
  String get fxEndArtifacts;

  /// No description provided for @fxEndCounters.
  ///
  /// In es, this message translates to:
  /// **'Una amenaza enorme y protegida acaba la partida en dos golpes.'**
  String get fxEndCounters;

  /// No description provided for @fxEndTokens.
  ///
  /// In es, this message translates to:
  /// **'Ataca en masa: ningún bloqueo aguanta a todo tu ejército.'**
  String get fxEndTokens;

  /// No description provided for @fxEndGraveyard.
  ///
  /// In es, this message translates to:
  /// **'Reutiliza tus mejores cartas: juegas con dos manos contra una.'**
  String get fxEndGraveyard;

  /// No description provided for @fxTurns12.
  ///
  /// In es, this message translates to:
  /// **'T1-T2'**
  String get fxTurns12;

  /// No description provided for @fxTurns34.
  ///
  /// In es, this message translates to:
  /// **'T3-T4'**
  String get fxTurns34;

  /// No description provided for @fxTurns5.
  ///
  /// In es, this message translates to:
  /// **'T5+'**
  String get fxTurns5;

  /// No description provided for @fxAggroEarly.
  ///
  /// In es, this message translates to:
  /// **'Juega una criatura cada turno, sin excepción.'**
  String get fxAggroEarly;

  /// No description provided for @fxAggroMid.
  ///
  /// In es, this message translates to:
  /// **'Sigue atacando; guarda el daño directo para quitar bloqueadores.'**
  String get fxAggroMid;

  /// No description provided for @fxAggroLate.
  ///
  /// In es, this message translates to:
  /// **'Remata con todo: aquí deberías cerrar la partida.'**
  String get fxAggroLate;

  /// No description provided for @fxTempoEarly.
  ///
  /// In es, this message translates to:
  /// **'Amenaza barata y maná abierto cuando puedas.'**
  String get fxTempoEarly;

  /// No description provided for @fxTempoMid.
  ///
  /// In es, this message translates to:
  /// **'Ataca y usa tus hechizos en el turno del rival.'**
  String get fxTempoMid;

  /// No description provided for @fxTempoLate.
  ///
  /// In es, this message translates to:
  /// **'Protege tus criaturas y cierra por el aire o con daño directo.'**
  String get fxTempoLate;

  /// No description provided for @fxMidrangeEarly.
  ///
  /// In es, this message translates to:
  /// **'Desarrolla y no regales cartas: cambios de uno por uno buenos.'**
  String get fxMidrangeEarly;

  /// No description provided for @fxMidrangeMid.
  ///
  /// In es, this message translates to:
  /// **'Despliega tus motores de {tema} y estabiliza la mesa.'**
  String fxMidrangeMid(String tema);

  /// No description provided for @fxMidrangeLate.
  ///
  /// In es, this message translates to:
  /// **'Tus cartas valen más que las suyas: conviértelo en la partida.'**
  String get fxMidrangeLate;

  /// No description provided for @fxControlEarly.
  ///
  /// In es, this message translates to:
  /// **'Tierra al turno y responde solo a lo que importa.'**
  String get fxControlEarly;

  /// No description provided for @fxControlMid.
  ///
  /// In es, this message translates to:
  /// **'Limpia la mesa y roba cartas: el tiempo juega para ti.'**
  String get fxControlMid;

  /// No description provided for @fxControlLate.
  ///
  /// In es, this message translates to:
  /// **'Baja una amenaza y protégela hasta el final.'**
  String get fxControlLate;

  /// No description provided for @fxArchetypeAggro.
  ///
  /// In es, this message translates to:
  /// **'aggro'**
  String get fxArchetypeAggro;

  /// No description provided for @fxArchetypeTempo.
  ///
  /// In es, this message translates to:
  /// **'tempo'**
  String get fxArchetypeTempo;

  /// No description provided for @fxArchetypeMidrange.
  ///
  /// In es, this message translates to:
  /// **'midrange'**
  String get fxArchetypeMidrange;

  /// No description provided for @fxArchetypeControl.
  ///
  /// In es, this message translates to:
  /// **'control'**
  String get fxArchetypeControl;

  /// No description provided for @fxWhyItWorks.
  ///
  /// In es, this message translates to:
  /// **'Coste medio {coste}: por la regla de Karsten (24 tierras a coste 3.0, ±1 por cada ±0.5), este mazo lleva {tierras} tierras — dentro del rango de un mazo {arquetipo}. Hay {criaturas} criaturas para mantener la mesa y {interaccion} cartas de interacción para lo que traiga el rival. El tema ({tema}) concentra tus sinergias: cuantas más piezas del tema veas, más fuerte es cada una.'**
  String fxWhyItWorks(
    String coste,
    String tierras,
    String arquetipo,
    int criaturas,
    int interaccion,
    String tema,
  );

  /// No description provided for @fxNoLandsRange.
  ///
  /// In es, this message translates to:
  /// **'Con esa curva salen {tierras} tierras: fuera del rango sano ({min}-{max}). Ajusta el total de hechizos.'**
  String fxNoLandsRange(String tierras, String min, String max);

  /// No description provided for @fxNoCards.
  ///
  /// In es, this message translates to:
  /// **'Tu colección no tiene suficientes cartas de estos colores para llenar esa curva. Prueba con menos hechizos o con otros costes.'**
  String get fxNoCards;

  /// No description provided for @fxNoProfile.
  ///
  /// In es, this message translates to:
  /// **'Esa curva (coste medio {coste} con {tierras} tierras) no encaja en ningún perfil sano: un mazo barato quiere menos tierras y uno caro quiere más. Acércalos.'**
  String fxNoProfile(String coste, String tierras);

  /// No description provided for @fxNoBasics.
  ///
  /// In es, this message translates to:
  /// **'No hay tierras básicas suficientes en la colección para esa curva.'**
  String get fxNoBasics;

  /// No description provided for @fxHardRule.
  ///
  /// In es, this message translates to:
  /// **'La curva pedida rompe una regla dura: {detalle}'**
  String fxHardRule(String detalle);

  /// No description provided for @tsPresetMonoRed.
  ///
  /// In es, this message translates to:
  /// **'Criaturas baratas y daño a la cara: te mata en 4-5 turnos si no aguantas el ritmo.'**
  String get tsPresetMonoRed;

  /// No description provided for @tsPresetAzorius.
  ///
  /// In es, this message translates to:
  /// **'Contramagia, barreduras y robo: alarga la partida y gana con pocos finalizadores.'**
  String get tsPresetAzorius;

  /// No description provided for @tsPresetGolgari.
  ///
  /// In es, this message translates to:
  /// **'Cambios de uno por uno, criaturas eficientes y removal negro: gana el juego largo por calidad de cartas.'**
  String get tsPresetGolgari;
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
    'zh',
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
    'that was used.',
  );
}
