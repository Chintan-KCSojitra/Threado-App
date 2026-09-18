// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Threado';

  @override
  String get chooseLanguageTitle => 'Choose language';

  @override
  String get changeLanguageTitle => 'Change language';

  @override
  String get welcomeToApp => 'Welcome to Threado';

  @override
  String get loginTagline =>
      'Thread your style. Discover your next fabric match.';

  @override
  String get tagTrending => 'Trending';

  @override
  String get tagPremium => 'Premium';

  @override
  String get tagVerified => 'Verified';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get login => 'Login';

  @override
  String get loginAcceptTermsPrefix => 'I agree to the ';

  @override
  String get loginAcceptTermsAnd => ' and ';

  @override
  String get loginAcceptTermsRequired =>
      'Please accept Terms & Conditions and Privacy Policy to continue';

  @override
  String get pleaseLoginContinue => 'Please login your account to continue';

  @override
  String get otpVerificationTitle => 'OTP verification';

  @override
  String get otpSecureTitle => 'Secure sign in';

  @override
  String otpSentMessage(String phone) {
    return 'We sent your Thredo verification code to\n$phone';
  }

  @override
  String get otpDidntReceive => 'Didn\'t receive code? ';

  @override
  String get otpResend => 'Resend';

  @override
  String get confirm => 'Confirm';

  @override
  String get welcomeTraders => 'Welcome, traders';

  @override
  String get navHome => 'Home';

  @override
  String get navCategories => 'Categories';

  @override
  String get navCompany => 'Company';

  @override
  String get navProfile => 'Profile';

  @override
  String get screenCategory => 'Category';

  @override
  String get myProfile => 'My profile';

  @override
  String get thredoId => 'Thredo ID';

  @override
  String get verifiedBuyer => 'Verified buyer';

  @override
  String get profileSubtitle => 'Manage your thread sourcing journey';

  @override
  String get statOrders => 'Orders';

  @override
  String get statSaved => 'Saved';

  @override
  String get statMatches => 'Matches';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsAndConditions => 'Terms and conditions';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get delete => 'Delete';

  @override
  String get logout => 'Logout';

  @override
  String get logoutTitle => 'Logout?';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get exitAppTitle => 'Exit app?';

  @override
  String get exitAppMessage => 'Are you sure you want to exit Threado?';

  @override
  String get yesExit => 'Yes, exit';

  @override
  String get yesLogout => 'Yes, logout';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountMessage =>
      'Are you sure you want to delete your account?';

  @override
  String get companyProfile => 'Company profile';

  @override
  String get shadeCardPickerTitle => 'Shade cards';

  @override
  String get shadeCardPickerSubtitle =>
      'Compare all shade cards from this company and select the one you want to match against fabric.';

  @override
  String get shadeCardSelectHint => 'Tap a shade card to start matching';

  @override
  String get shadeCardContinue => 'Compare & match';

  @override
  String get addReview => 'Add review';

  @override
  String get rateCompany => 'Rate this company';

  @override
  String get yourReview => 'Your review';

  @override
  String get reviewHint =>
      'Tell others about thread quality, delivery, and service…';

  @override
  String get submitReview => 'Submit';

  @override
  String get reviewThanks => 'Thanks for your review!';

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
  String get selectStarRating => 'Please tap the stars to rate';

  @override
  String whatsappInquiryMessage(String productName, String companyName) {
    return 'Hello, I am interested in \"$productName\" and would like to inquire about pricing, minimum order quantity, and delivery details with $companyName. \n\nSent via Threado';
  }

  @override
  String get navMatch => 'Match';

  @override
  String get matchScreenTitle => 'Thread Match';

  @override
  String get matchScreenSubtitle =>
      'Point your camera at any fabric to instantly find matching threads';

  @override
  String get matchHowItWorks => 'How it works';

  @override
  String get matchStep1 => 'Point camera at fabric';

  @override
  String get matchStep2 => 'We scan the colour & texture';

  @override
  String get matchStep3 => 'Get matching thread results';

  @override
  String get matchOpenCamera => 'Open Camera';

  @override
  String get matchPermissionTitle => 'Camera Access Required';

  @override
  String get matchPermissionMessage =>
      'Allow camera access to match thread colours against real fabric.';

  @override
  String get matchOpenSettings => 'Open Settings';

  @override
  String get matchPointHint => 'Point camera at fabric to match thread colour';

  @override
  String get matchThreadMatch => 'Thread Match';

  @override
  String get matchScanning => 'Scanning your image…';

  @override
  String get matchUploadHint => 'Upload a fabric image';

  @override
  String get matchUploadSubHint => 'Tap to pick from gallery or camera';

  @override
  String get matchPickGallery => 'Gallery';

  @override
  String get matchPickCamera => 'Camera';

  @override
  String get matchPickSource => 'Choose image source';

  @override
  String get matchCaptureTipsTitle => 'Tips for a clear fabric photo';

  @override
  String get matchCaptureTipLighting =>
      'Use bright, even lighting — natural daylight works best';

  @override
  String get matchCaptureTipFocus =>
      'Keep the fabric flat, sharp, and in focus';

  @override
  String get matchCaptureTipFrame =>
      'Fill the frame with the colour or pattern you want to match';

  @override
  String get matchCaptureTipAvoid =>
      'Avoid shadows, glare, blur, and busy backgrounds';

  @override
  String get matchCaptureTipSingle =>
      'Capture one fabric area at a time for accurate results';

  @override
  String get matchCaptureTipGalleryNote =>
      'Pick a clear, well-lit photo that shows the fabric colour clearly';

  @override
  String get matchCaptureTipCameraNote =>
      'Hold your phone steady, tap to focus, then capture';

  @override
  String get matchCaptureContinueGallery => 'Choose from Gallery';

  @override
  String get matchCaptureContinueCamera => 'Open Camera';

  @override
  String get matchCaptureGotIt => 'Got it, continue';

  @override
  String get matchEmptyTitle => 'Find matching threads';

  @override
  String get matchEmptySubtitle =>
      'Upload a photo of any fabric and we\'ll find the closest thread matches from our catalogue';

  @override
  String get matchNoResults => 'No matching threads found';

  @override
  String matchResultsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count matching thread$_temp0 found';
  }
}
