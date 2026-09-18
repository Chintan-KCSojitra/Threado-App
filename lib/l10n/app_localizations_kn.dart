// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'Threado';

  @override
  String get chooseLanguageTitle => 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get changeLanguageTitle => 'ಭಾಷೆ ಬದಲಾಯಿಸಿ';

  @override
  String get welcomeToApp => 'ಥ್ರೆಡೋಗೆ ಸ್ವಾಗತ';

  @override
  String get loginTagline =>
      'ನಿಮ್ಮ ಶೈಲಿಯನ್ನು ನೂಲಿನಿಂದ ಅಲಂಕರಿಸಿ. ನಿಮ್ಮ ಮುಂದಿನ ಫ್ಯಾಬ್ರಿಕ್ ಹೊಂದಾಣಿಕೆಯನ್ನು ಹುಡುಕಿ.';

  @override
  String get tagTrending => 'ಟ್ರೆಂಡಿಂಗ್';

  @override
  String get tagPremium => 'ಪ್ರೀಮಿಯಂ';

  @override
  String get tagVerified => 'ದೃಢೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get mobileNumber => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get login => 'ಲಾಗಿನ್';

  @override
  String get loginAcceptTermsPrefix => 'ನಾನು ಒಪ್ಪುತ್ತೇನೆ ';

  @override
  String get loginAcceptTermsAnd => ' ಮತ್ತು ';

  @override
  String get loginAcceptTermsRequired =>
      'ಮುಂದುವರಿಯಲು ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತಾ ನೀತಿಯನ್ನು ಸ್ವೀಕರಿಸಿ';

  @override
  String get pleaseLoginContinue =>
      'ಮುಂದುವರಿಸಲು ದಯವಿಟ್ಟು ನಿಮ್ಮ ಖಾತೆಗೆ ಲಾಗಿನ್ ಮಾಡಿ';

  @override
  String get otpVerificationTitle => 'OTP ಪರಿಶೀಲನೆ';

  @override
  String get otpSecureTitle => 'ಸುರಕ್ಷಿತ ಸೈನ್ ಇನ್';

  @override
  String otpSentMessage(String phone) {
    return 'ನಿಮ್ಮ ಥ್ರೆಡೋ ಪರಿಶೀಲನೆ ಕೋಡ್ ಅನ್ನು ಇಲ್ಲಿಗೆ ಕಳುಹಿಸಿದ್ದೇವೆ\n$phone';
  }

  @override
  String get otpDidntReceive => 'ಕೋಡ್ ಬರಲಿಲ್ಲವೇ? ';

  @override
  String get otpResend => 'ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String get confirm => 'ಖಚಿತಪಡಿಸಿ';

  @override
  String get welcomeTraders => 'ಸ್ವಾಗತ, ವ್ಯಾಪಾರಿಗಳೇ';

  @override
  String get navHome => 'ಹೋಮ್';

  @override
  String get navCategories => 'ವರ್ಗಗಳು';

  @override
  String get navCompany => 'ಕಂಪನಿ';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get screenCategory => 'ವರ್ಗ';

  @override
  String get myProfile => 'ನನ್ನ ಪ್ರೊಫೈಲ್';

  @override
  String get thredoId => 'ಥ್ರೆಡೋ ID';

  @override
  String get verifiedBuyer => 'ದೃಢೀಕರಿಸಿದ ಖರೀದಿದಾರ';

  @override
  String get profileSubtitle => 'ನಿಮ್ಮ ನೂಲು ಸೋರ್ಸಿಂಗ್ ಪ್ರಯಾಣವನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get statOrders => 'ಆರ್ಡರ್‌ಗಳು';

  @override
  String get statSaved => 'ಉಳಿಸಿದವು';

  @override
  String get statMatches => 'ಹೊಂದಾಣಿಕೆಗಳು';

  @override
  String get privacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get termsAndConditions => 'ನಿಯಮಗಳು';

  @override
  String get deleteAccount => 'ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get logout => 'ಲಾಗ್ ಔಟ್';

  @override
  String get logoutTitle => 'ಲಾಗ್ ಔಟ್?';

  @override
  String get logoutMessage => 'ನೀವು ಖಚಿತವಾಗಿ ಲಾಗ್ ಔಟ್ ಮಾಡಲು ಬಯಸುವಿರಾ?';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get exitAppTitle => 'ಅಪ್ಲಿಕೇಶನ್ ನಿರ್ಗಮಿಸುವುದೇ?';

  @override
  String get exitAppMessage =>
      'ನೀವು ಖಚಿತವಾಗಿ Threado ನಿಂದ ನಿರ್ಗಮಿಸಲು ಬಯಸುವಿರಾ?';

  @override
  String get yesExit => 'ಹೌದು, ನಿರ್ಗಮಿಸಿ';

  @override
  String get yesLogout => 'ಹೌದು, ಲಾಗ್ ಔಟ್';

  @override
  String get deleteAccountTitle => 'ಖಾತೆ ಅಳಿಸುವುದೇ?';

  @override
  String get deleteAccountMessage =>
      'ನೀವು ಖಚಿತವಾಗಿ ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';

  @override
  String get companyProfile => 'ಕಂಪನಿ ಪ್ರೊಫೈಲ್';

  @override
  String get shadeCardPickerTitle => 'ಶೇಡ್ ಕಾರ್ಡ್';

  @override
  String get shadeCardPickerSubtitle =>
      'ಈ ಕಂಪನಿಯ ಎಲ್ಲಾ ಶೇಡ್ ಕಾರ್ಡ್‌ಗಳನ್ನು ಹೋಲಿಸಿ ಮತ್ತು ಫ್ಯಾಬ್ರಿಕ್‌ಗೆ ಹೊಂದಿಕೆಯಾಗುವ ಒಂದನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get shadeCardSelectHint => 'ಆಯ್ಕೆ ಮಾಡಲು ಶೇಡ್ ಕಾರ್ಡ್ ಮೇಲೆ ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get shadeCardContinue => 'ಹೋಲಿಸಿ ಮತ್ತು ಹೊಂದಿಸಿ';

  @override
  String get addReview => 'ವಿಮರ್ಶೆ ಸೇರಿಸಿ';

  @override
  String get rateCompany => 'ಈ ಕಂಪನಿಯನ್ನು ರೇಟ್ ಮಾಡಿ';

  @override
  String get yourReview => 'ನಿಮ್ಮ ವಿಮರ್ಶೆ';

  @override
  String get reviewHint => 'ನೂಲಿನ ಗುಣಮಟ್ಟ, ವಿತರಣೆ ಮತ್ತು ಸೇವೆಯ ಬಗ್ಗೆ ಹೇಳಿ…';

  @override
  String get submitReview => 'ಸಲ್ಲಿಸಿ';

  @override
  String get reviewThanks => 'ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಗೆ ಧನ್ಯವಾದಗಳು!';

  @override
  String get companyReviews => 'Reviews';

  @override
  String get viewAll => 'View all';

  @override
  String get allReviews => 'All reviews';

  @override
  String get noReviewsYet =>
      'No reviews yet. Be the first to share your experience.';

  @override
  String get selectStarRating => 'ರೇಟ್ ಮಾಡಲು ನಕ್ಷತ್ರಗಳ ಮೇಲೆ ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String whatsappInquiryMessage(String productName, String companyName) {
    return 'ನಮಸ್ಕಾರ, ನನಗೆ \"$productName\" ಬಗ್ಗೆ ಆಸಕ್ತಿ ಇದೆ ಮತ್ತು $companyName ಜೊತೆ ಬೆಲೆ, ಕನಿಷ್ಠ ಆರ್ಡರ್ ಪ್ರಮಾಣ ಮತ್ತು ಡೆಲಿವರಿ ವಿವರಗಳ ಬಗ್ಗೆ ತಿಳಿಯಲು ಬಯಸುತ್ತೇನೆ.';
  }

  @override
  String get navMatch => 'ಹೊಂದಾಣಿಕೆ';

  @override
  String get matchScreenTitle => 'ನೂಲು ಹೊಂದಾಣಿಕೆ';

  @override
  String get matchScreenSubtitle =>
      'ಯಾವುದೇ ಬಟ್ಟೆಯ ಮೇಲೆ ಕ್ಯಾಮೆರಾ ಹಿಡಿದು ತಕ್ಷಣ ಹೊಂದಾಣಿಕೆಯ ನೂಲುಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get matchHowItWorks => 'ಇದು ಹೇಗೆ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ';

  @override
  String get matchStep1 => 'ಬಟ್ಟೆಯ ಮೇಲೆ ಕ್ಯಾಮೆರಾ ಹಿಡಿಯಿರಿ';

  @override
  String get matchStep2 => 'ನಾವು ಬಣ್ಣ ಮತ್ತು ವಿನ್ಯಾಸ ಸ್ಕ್ಯಾನ್ ಮಾಡುತ್ತೇವೆ';

  @override
  String get matchStep3 => 'ಹೊಂದಾಣಿಕೆಯ ನೂಲಿನ ಫಲಿತಾಂಶ ಪಡೆಯಿರಿ';

  @override
  String get matchOpenCamera => 'ಕ್ಯಾಮೆರಾ ತೆರೆಯಿರಿ';

  @override
  String get matchPermissionTitle => 'ಕ್ಯಾಮೆರಾ ಪ್ರವೇಶ ಅಗತ್ಯ';

  @override
  String get matchPermissionMessage =>
      'ನಿಜವಾದ ಬಟ್ಟೆಗೆ ನೂಲಿನ ಬಣ್ಣ ಹೊಂದಿಸಲು ಕ್ಯಾಮೆರಾ ಪ್ರವೇಶ ನೀಡಿ.';

  @override
  String get matchOpenSettings => 'ಸೆಟ್ಟಿಂಗ್ ತೆರೆಯಿರಿ';

  @override
  String get matchPointHint =>
      'ನೂಲಿನ ಬಣ್ಣ ಹೊಂದಿಸಲು ಬಟ್ಟೆಯ ಮೇಲೆ ಕ್ಯಾಮೆರಾ ಹಿಡಿಯಿರಿ';

  @override
  String get matchThreadMatch => 'ನೂಲು ಹೊಂದಾಣಿಕೆ';

  @override
  String get matchScanning => 'ನಿಮ್ಮ ಚಿತ್ರ ಸ್ಕ್ಯಾನ್ ಆಗುತ್ತಿದೆ…';

  @override
  String get matchUploadHint => 'ಬಟ್ಟೆಯ ಚಿತ್ರ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get matchUploadSubHint =>
      'ಗ್ಯಾಲರಿ ಅಥವಾ ಕ್ಯಾಮೆರಾದಿಂದ ಆಯ್ಕೆ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get matchPickGallery => 'ಗ್ಯಾಲರಿ';

  @override
  String get matchPickCamera => 'ಕ್ಯಾಮೆರಾ';

  @override
  String get matchPickSource => 'ಚಿತ್ರ ಮೂಲ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get matchCaptureTipsTitle => 'ಸ್ಪಷ್ಟ ಫ್ಯಾಬ್ರಿಕ್ ಫೋಟೋಗಾಗಿ ಸಲಹೆಗಳು';

  @override
  String get matchCaptureTipLighting =>
      'ಪ್ರಕಾಶಮಾನ, ಸಮಾನ ಬೆಳಕನ್ನು ಬಳಸಿ — ನೈಸರ್ಗಿಕ ಹಗಲು ಬೆಳಕು ಉತ್ತಮ';

  @override
  String get matchCaptureTipFocus =>
      'ಫ್ಯಾಬ್ರಿಕ್ ಸಪಾಟ, ಸ್ಪಷ್ಟ ಮತ್ತು ಫೋಕಸ್‌ನಲ್ಲಿರಲಿ';

  @override
  String get matchCaptureTipFrame =>
      'ನೀವು ಹೊಂದಿಸಲು ಬಯಸುವ ಬಣ್ಣ ಅಥವಾ ಮಾದರಿಯಿಂದ ಫ್ರೇಮ್ ತುಂಬಿಸಿ';

  @override
  String get matchCaptureTipAvoid =>
      'ನೆರಳು, ಮಿಂಚು, ಮಸುಕು ಮತ್ತು ಕೋಲಾಹಲದ ಹಿನ್ನೆಲೆ ತಪ್ಪಿಸಿ';

  @override
  String get matchCaptureTipSingle =>
      'ನಿಖರ ಫಲಿತಾಂಶಕ್ಕಾಗಿ ಒಂದು ಸಮಯದಲ್ಲಿ ಒಂದು ಫ್ಯಾಬ್ರಿಕ್ ಪ್ರದೇಶವನ್ನು ಸೆರೆಹಿಡಿಯಿರಿ';

  @override
  String get matchCaptureTipGalleryNote =>
      'ಫ್ಯಾಬ್ರಿಕ್ ಬಣ್ಣ ಸ್ಪಷ್ಟವಾಗಿ ಕಾಣುವ ಸ್ಪಷ್ಟ, ಉತ್ತಮ ಬೆಳಕಿನ ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get matchCaptureTipCameraNote =>
      'ಫೋನ್ ಸ್ಥಿರವಾಗಿ ಹಿಡಿದು, ಫೋಕಸ್ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ, ನಂತರ ಸೆರೆಹಿಡಿಯಿರಿ';

  @override
  String get matchCaptureContinueGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get matchCaptureContinueCamera => 'ಕ್ಯಾಮೆರಾ ತೆರೆಯಿರಿ';

  @override
  String get matchCaptureGotIt => 'ಅರ್ಥವಾಯಿತು, ಮುಂದುವರಿಸಿ';

  @override
  String get matchEmptyTitle => 'ಹೊಂದಾಣಿಕೆಯ ನೂಲುಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get matchEmptySubtitle =>
      'ಯಾವುದೇ ಬಟ್ಟೆಯ ಫೋಟೋ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ, ನಾವು ನಮ್ಮ ಕ್ಯಾಟಲಾಗ್‌ನಿಂದ ಅತ್ಯಂತ ಹತ್ತಿರದ ನೂಲು ಹೊಂದಾಣಿಕೆಗಳನ್ನು ಹುಡುಕುತ್ತೇವೆ';

  @override
  String get matchNoResults => 'ಯಾವುದೇ ಹೊಂದಾಣಿಕೆಯ ನೂಲುಗಳು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String matchResultsTitle(int count) {
    return '$count ಹೊಂದಾಣಿಕೆಯ ನೂಲುಗಳು ಕಂಡುಬಂದಿವೆ';
  }
}
