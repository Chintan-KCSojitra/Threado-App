import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Threado'**
  String get appName;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguageTitle;

  /// No description provided for @changeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguageTitle;

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Threado'**
  String get welcomeToApp;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Thread your style. Discover your next fabric match.'**
  String get loginTagline;

  /// No description provided for @tagTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get tagTrending;

  /// No description provided for @tagPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get tagPremium;

  /// No description provided for @tagVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get tagVerified;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginAcceptTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get loginAcceptTermsPrefix;

  /// No description provided for @loginAcceptTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get loginAcceptTermsAnd;

  /// No description provided for @loginAcceptTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept Terms & Conditions and Privacy Policy to continue'**
  String get loginAcceptTermsRequired;

  /// No description provided for @pleaseLoginContinue.
  ///
  /// In en, this message translates to:
  /// **'Please login your account to continue'**
  String get pleaseLoginContinue;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP verification'**
  String get otpVerificationTitle;

  /// No description provided for @otpSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure sign in'**
  String get otpSecureTitle;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent your Thredo verification code to\n{phone}'**
  String otpSentMessage(String phone);

  /// No description provided for @otpDidntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get otpDidntReceive;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get otpResend;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @welcomeTraders.
  ///
  /// In en, this message translates to:
  /// **'Welcome, traders'**
  String get welcomeTraders;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get navCompany;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @screenCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get screenCategory;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @thredoId.
  ///
  /// In en, this message translates to:
  /// **'Thredo ID'**
  String get thredoId;

  /// No description provided for @verifiedBuyer.
  ///
  /// In en, this message translates to:
  /// **'Verified buyer'**
  String get verifiedBuyer;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your thread sourcing journey'**
  String get profileSubtitle;

  /// No description provided for @statOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get statOrders;

  /// No description provided for @statSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statSaved;

  /// No description provided for @statMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get statMatches;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit app?'**
  String get exitAppTitle;

  /// No description provided for @exitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit Threado?'**
  String get exitAppMessage;

  /// No description provided for @yesExit.
  ///
  /// In en, this message translates to:
  /// **'Yes, exit'**
  String get yesExit;

  /// No description provided for @yesLogout.
  ///
  /// In en, this message translates to:
  /// **'Yes, logout'**
  String get yesLogout;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountMessage;

  /// No description provided for @companyProfile.
  ///
  /// In en, this message translates to:
  /// **'Company profile'**
  String get companyProfile;

  /// No description provided for @shadeCardPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Shade cards'**
  String get shadeCardPickerTitle;

  /// No description provided for @shadeCardPickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compare all shade cards from this company and select the one you want to match against fabric.'**
  String get shadeCardPickerSubtitle;

  /// No description provided for @shadeCardSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a shade card to start matching'**
  String get shadeCardSelectHint;

  /// No description provided for @shadeCardContinue.
  ///
  /// In en, this message translates to:
  /// **'Compare & match'**
  String get shadeCardContinue;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add review'**
  String get addReview;

  /// No description provided for @rateCompany.
  ///
  /// In en, this message translates to:
  /// **'Rate this company'**
  String get rateCompany;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get yourReview;

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Tell others about thread quality, delivery, and service…'**
  String get reviewHint;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitReview;

  /// No description provided for @reviewThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your review!'**
  String get reviewThanks;

  /// No description provided for @companyReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get companyReviews;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @allReviews.
  ///
  /// In en, this message translates to:
  /// **'All reviews'**
  String get allReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first to share your experience.'**
  String get noReviewsYet;

  /// No description provided for @selectStarRating.
  ///
  /// In en, this message translates to:
  /// **'Please tap the stars to rate'**
  String get selectStarRating;

  /// No description provided for @whatsappInquiryMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I am interested in \"{productName}\" and would like to inquire about pricing, minimum order quantity, and delivery details with {companyName}. \n\nSent via Threado'**
  String whatsappInquiryMessage(String productName, String companyName);

  /// No description provided for @navMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get navMatch;

  /// No description provided for @matchScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Thread Match'**
  String get matchScreenTitle;

  /// No description provided for @matchScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at any fabric to instantly find matching threads'**
  String get matchScreenSubtitle;

  /// No description provided for @matchHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get matchHowItWorks;

  /// No description provided for @matchStep1.
  ///
  /// In en, this message translates to:
  /// **'Point camera at fabric'**
  String get matchStep1;

  /// No description provided for @matchStep2.
  ///
  /// In en, this message translates to:
  /// **'We scan the colour & texture'**
  String get matchStep2;

  /// No description provided for @matchStep3.
  ///
  /// In en, this message translates to:
  /// **'Get matching thread results'**
  String get matchStep3;

  /// No description provided for @matchOpenCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get matchOpenCamera;

  /// No description provided for @matchPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Access Required'**
  String get matchPermissionTitle;

  /// No description provided for @matchPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access to match thread colours against real fabric.'**
  String get matchPermissionMessage;

  /// No description provided for @matchOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get matchOpenSettings;

  /// No description provided for @matchPointHint.
  ///
  /// In en, this message translates to:
  /// **'Point camera at fabric to match thread colour'**
  String get matchPointHint;

  /// No description provided for @matchThreadMatch.
  ///
  /// In en, this message translates to:
  /// **'Thread Match'**
  String get matchThreadMatch;

  /// No description provided for @matchScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning your image…'**
  String get matchScanning;

  /// No description provided for @matchUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Upload a fabric image'**
  String get matchUploadHint;

  /// No description provided for @matchUploadSubHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick from gallery or camera'**
  String get matchUploadSubHint;

  /// No description provided for @matchPickGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get matchPickGallery;

  /// No description provided for @matchPickCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get matchPickCamera;

  /// No description provided for @matchPickSource.
  ///
  /// In en, this message translates to:
  /// **'Choose image source'**
  String get matchPickSource;

  /// No description provided for @matchCaptureTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for a clear fabric photo'**
  String get matchCaptureTipsTitle;

  /// No description provided for @matchCaptureTipLighting.
  ///
  /// In en, this message translates to:
  /// **'Use bright, even lighting — natural daylight works best'**
  String get matchCaptureTipLighting;

  /// No description provided for @matchCaptureTipFocus.
  ///
  /// In en, this message translates to:
  /// **'Keep the fabric flat, sharp, and in focus'**
  String get matchCaptureTipFocus;

  /// No description provided for @matchCaptureTipFrame.
  ///
  /// In en, this message translates to:
  /// **'Fill the frame with the colour or pattern you want to match'**
  String get matchCaptureTipFrame;

  /// No description provided for @matchCaptureTipAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid shadows, glare, blur, and busy backgrounds'**
  String get matchCaptureTipAvoid;

  /// No description provided for @matchCaptureTipSingle.
  ///
  /// In en, this message translates to:
  /// **'Capture one fabric area at a time for accurate results'**
  String get matchCaptureTipSingle;

  /// No description provided for @matchCaptureTipGalleryNote.
  ///
  /// In en, this message translates to:
  /// **'Pick a clear, well-lit photo that shows the fabric colour clearly'**
  String get matchCaptureTipGalleryNote;

  /// No description provided for @matchCaptureTipCameraNote.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone steady, tap to focus, then capture'**
  String get matchCaptureTipCameraNote;

  /// No description provided for @matchCaptureContinueGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get matchCaptureContinueGallery;

  /// No description provided for @matchCaptureContinueCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get matchCaptureContinueCamera;

  /// No description provided for @matchCaptureGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it, continue'**
  String get matchCaptureGotIt;

  /// No description provided for @matchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Find matching threads'**
  String get matchEmptyTitle;

  /// No description provided for @matchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of any fabric and we\'ll find the closest thread matches from our catalogue'**
  String get matchEmptySubtitle;

  /// No description provided for @matchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching threads found'**
  String get matchNoResults;

  /// No description provided for @matchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} matching thread{count, plural, one{} other{s}} found'**
  String matchResultsTitle(int count);
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
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
