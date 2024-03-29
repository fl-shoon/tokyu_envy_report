import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_ja.dart';

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ja'),
    Locale('en')
  ];

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @visitors_basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic information of visitors'**
  String get visitors_basic_info;

  /// No description provided for @report_screen.
  ///
  /// In en, this message translates to:
  /// **'Report screen'**
  String get report_screen;

  /// No description provided for @today_visitors.
  ///
  /// In en, this message translates to:
  /// **'Today\'s visitors'**
  String get today_visitors;

  /// No description provided for @last_month_visitors.
  ///
  /// In en, this message translates to:
  /// **'Last month\'s visitors'**
  String get last_month_visitors;

  /// No description provided for @viewing_area.
  ///
  /// In en, this message translates to:
  /// **'Viewing the area'**
  String get viewing_area;

  /// No description provided for @under_negotiation.
  ///
  /// In en, this message translates to:
  /// **'Under negotiation'**
  String get under_negotiation;

  /// No description provided for @reservations_today.
  ///
  /// In en, this message translates to:
  /// **'Today\'s reservations'**
  String get reservations_today;

  /// No description provided for @reservations_left.
  ///
  /// In en, this message translates to:
  /// **'Reservations left'**
  String get reservations_left;

  /// No description provided for @monthly_visitors.
  ///
  /// In en, this message translates to:
  /// **'Monthly visitors「Year @」'**
  String get monthly_visitors;

  /// No description provided for @first_time_visitors.
  ///
  /// In en, this message translates to:
  /// **'First-time'**
  String get first_time_visitors;

  /// No description provided for @non_first_time_visitors.
  ///
  /// In en, this message translates to:
  /// **'Non-first-time'**
  String get non_first_time_visitors;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get count;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get subject;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return L10nEn();
    case 'ja': return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
