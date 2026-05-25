import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Slip Flow'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get scan;

  /// No description provided for @scanned_slips.
  ///
  /// In en, this message translates to:
  /// **'List scan'**
  String get scanned_slips;

  /// No description provided for @scripslipflowe.
  ///
  /// In en, this message translates to:
  /// **'Application detecting text in images'**
  String get scripslipflowe;

  /// No description provided for @scan_receipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt'**
  String get scan_receipt;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get thai;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light_mode;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark_mode;

  /// No description provided for @system_mode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system_mode;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @no_slips.
  ///
  /// In en, this message translates to:
  /// **'No scanned slips yet'**
  String get no_slips;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @receipt_details.
  ///
  /// In en, this message translates to:
  /// **'Receipt Details'**
  String get receipt_details;

  /// No description provided for @delete_receipt.
  ///
  /// In en, this message translates to:
  /// **'Delete Receipt'**
  String get delete_receipt;

  /// No description provided for @delete_receipt_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this receipt?'**
  String get delete_receipt_confirmation;

  /// No description provided for @no_text.
  ///
  /// In en, this message translates to:
  /// **'(No text)'**
  String get no_text;

  /// No description provided for @scanned_text.
  ///
  /// In en, this message translates to:
  /// **'Scanned Text'**
  String get scanned_text;

  /// No description provided for @receipt_text_hint.
  ///
  /// In en, this message translates to:
  /// **'Receipt text...'**
  String get receipt_text_hint;

  /// No description provided for @saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saved_successfully;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get menu;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @about_app_description.
  ///
  /// In en, this message translates to:
  /// **'Slip Flow is an application for scanning and saving text from receipts, images and documents using advanced OCR technology.'**
  String get about_app_description;

  /// No description provided for @how_to_scan.
  ///
  /// In en, this message translates to:
  /// **'How to Scan'**
  String get how_to_scan;

  /// No description provided for @how_to_scan_description.
  ///
  /// In en, this message translates to:
  /// **'Easily scan your receipts or documents by taking a photo and let the app automatically read the text.'**
  String get how_to_scan_description;

  /// No description provided for @step1_open_scan.
  ///
  /// In en, this message translates to:
  /// **'1. Open the scan page from the home screen'**
  String get step1_open_scan;

  /// No description provided for @step2_capture_receipt.
  ///
  /// In en, this message translates to:
  /// **'2. Capture a photo of your receipt or document'**
  String get step2_capture_receipt;

  /// No description provided for @step3_confirm_text.
  ///
  /// In en, this message translates to:
  /// **'3. Confirm the scanned text and tap save'**
  String get step3_confirm_text;

  /// No description provided for @text_selection.
  ///
  /// In en, this message translates to:
  /// **'Text Selection'**
  String get text_selection;

  /// No description provided for @text_selection_description.
  ///
  /// In en, this message translates to:
  /// **'Select only the portion of text you want to save by tapping the text regions in the image.'**
  String get text_selection_description;

  /// No description provided for @step1_tap_select_icon.
  ///
  /// In en, this message translates to:
  /// **'1. Tap the touch icon (👆) to enter selection mode'**
  String get step1_tap_select_icon;

  /// No description provided for @step2_tap_text_regions.
  ///
  /// In en, this message translates to:
  /// **'2. Tap on the text regions you want to select (green numbers)'**
  String get step2_tap_text_regions;

  /// No description provided for @step3_confirm_selection.
  ///
  /// In en, this message translates to:
  /// **'3. Selected text will appear in the text field below'**
  String get step3_confirm_selection;

  /// No description provided for @how_to_save.
  ///
  /// In en, this message translates to:
  /// **'How to Save'**
  String get how_to_save;

  /// No description provided for @how_to_save_description.
  ///
  /// In en, this message translates to:
  /// **'Save the scanned text for reference and future search.'**
  String get how_to_save_description;

  /// No description provided for @step1_edit_text.
  ///
  /// In en, this message translates to:
  /// **'1. Edit the text in the text field as needed'**
  String get step1_edit_text;

  /// No description provided for @step2_tap_save.
  ///
  /// In en, this message translates to:
  /// **'2. Tap the save button at the bottom'**
  String get step2_tap_save;

  /// No description provided for @step3_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'3. The data will be automatically saved to your list'**
  String get step3_saved_successfully;

  /// No description provided for @how_to_view.
  ///
  /// In en, this message translates to:
  /// **'How to View'**
  String get how_to_view;

  /// No description provided for @how_to_view_description.
  ///
  /// In en, this message translates to:
  /// **'View details of all saved receipts with date and time.'**
  String get how_to_view_description;

  /// No description provided for @step1_go_to_list.
  ///
  /// In en, this message translates to:
  /// **'1. Tap Scanned Slips from the home screen'**
  String get step1_go_to_list;

  /// No description provided for @step2_tap_receipt.
  ///
  /// In en, this message translates to:
  /// **'2. Tap on a receipt to view its details'**
  String get step2_tap_receipt;

  /// No description provided for @step3_view_details.
  ///
  /// In en, this message translates to:
  /// **'3. View the image and saved text'**
  String get step3_view_details;

  /// No description provided for @how_to_delete.
  ///
  /// In en, this message translates to:
  /// **'How to Delete'**
  String get how_to_delete;

  /// No description provided for @how_to_delete_description.
  ///
  /// In en, this message translates to:
  /// **'Remove receipts you no longer need.'**
  String get how_to_delete_description;

  /// No description provided for @step1_long_press_receipt.
  ///
  /// In en, this message translates to:
  /// **'1. Long press on a receipt in the list'**
  String get step1_long_press_receipt;

  /// No description provided for @step2_confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'2. Confirm the deletion when prompted'**
  String get step2_confirm_delete;

  /// No description provided for @tips_and_tricks.
  ///
  /// In en, this message translates to:
  /// **'Tips and Tricks'**
  String get tips_and_tricks;

  /// No description provided for @tips_description.
  ///
  /// In en, this message translates to:
  /// **'Get the best results from scanning by following these tips.'**
  String get tips_description;

  /// No description provided for @tip1_good_lighting.
  ///
  /// In en, this message translates to:
  /// **'💡 Use sufficient lighting to make the text clear'**
  String get tip1_good_lighting;

  /// No description provided for @tip2_clear_image.
  ///
  /// In en, this message translates to:
  /// **'📷 Take photos straight and clearly without blur or shadows'**
  String get tip2_clear_image;

  /// No description provided for @tip3_select_accurate.
  ///
  /// In en, this message translates to:
  /// **'✓ Select text accurately, only the parts you need'**
  String get tip3_select_accurate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
