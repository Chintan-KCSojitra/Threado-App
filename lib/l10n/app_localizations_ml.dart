// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'Threado';

  @override
  String get chooseLanguageTitle => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get changeLanguageTitle => 'ഭാഷ മാറ്റുക';

  @override
  String get welcomeToApp => 'ത്രെഡോയിലേക്ക് സ്വാഗതം';

  @override
  String get loginTagline =>
      'നിങ്ങളുടെ ശൈലി നൂലുകൊണ്ട് അലങ്കരിക്കുക. അടുത്ത ഫാബ്രിക് പൊരുത്തം കണ്ടെത്തുക.';

  @override
  String get tagTrending => 'ട്രെൻഡിംഗ്';

  @override
  String get tagPremium => 'പ്രീമിയം';

  @override
  String get tagVerified => 'സ്ഥിരീകരിച്ചു';

  @override
  String get mobileNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get login => 'ലോഗിൻ';

  @override
  String get loginAcceptTermsPrefix => 'ഞാൻ അംഗീകരിക്കുന്നു ';

  @override
  String get loginAcceptTermsAnd => ' ഒപ്പം ';

  @override
  String get loginAcceptTermsRequired =>
      'തുടരാൻ നിബന്ധനകളും സ്വകാര്യതാ നയവും സ്വീകരിക്കുക';

  @override
  String get pleaseLoginContinue =>
      'തുടരാൻ ദയവായി നിങ്ങളുടെ അക്കൗണ്ടിൽ ലോഗിൻ ചെയ്യുക';

  @override
  String get otpVerificationTitle => 'OTP സ്ഥിരീകരണം';

  @override
  String get otpSecureTitle => 'സുരക്ഷിത സൈൻ ഇൻ';

  @override
  String otpSentMessage(String phone) {
    return 'നിങ്ങളുടെ ത്രെഡോ സ്ഥിരീകരണ കോഡ് ഞങ്ങൾ ഇവിടെ അയച്ചു\n$phone';
  }

  @override
  String get otpDidntReceive => 'കോഡ് കിട്ടിയില്ലേ? ';

  @override
  String get otpResend => 'വീണ്ടും അയയ്ക്കുക';

  @override
  String get confirm => 'സ്ഥിരീകരിക്കുക';

  @override
  String get welcomeTraders => 'സ്വാഗതം, വ്യാപാരികളേ';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navCategories => 'വിഭാഗങ്ങൾ';

  @override
  String get navCompany => 'കമ്പനി';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String get screenCategory => 'വിഭാഗം';

  @override
  String get myProfile => 'എന്റെ പ്രൊഫൈൽ';

  @override
  String get thredoId => 'ത്രെഡോ ID';

  @override
  String get verifiedBuyer => 'സ്ഥിരീകരിച്ച വാങ്ങുന്നയാൾ';

  @override
  String get profileSubtitle => 'നിങ്ങളുടെ നൂൽ സോഴ്സിംഗ് യാത്ര നിയന്ത്രിക്കുക';

  @override
  String get statOrders => 'ഓർഡറുകൾ';

  @override
  String get statSaved => 'സേവ് ചെയ്തവ';

  @override
  String get statMatches => 'പൊരുത്തങ്ങൾ';

  @override
  String get privacyPolicy => 'സ്വകാര്യതാ നയം';

  @override
  String get termsAndConditions => 'നിബന്ധനകൾ';

  @override
  String get deleteAccount => 'അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get logout => 'ലോഗ് ഔട്ട്';

  @override
  String get logoutTitle => 'ലോഗ് ഔട്ട്?';

  @override
  String get logoutMessage => 'നിങ്ങൾക്ക് തീർച്ചയായും ലോഗ് ഔട്ട് ചെയ്യണോ?';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get exitAppTitle => 'ആപ്പ് പുറത്തുകടക്കണോ?';

  @override
  String get exitAppMessage =>
      'Threado-ൽ നിന്ന് പുറത്തുകടക്കണമെന്ന് തീർച്ചയാണോ?';

  @override
  String get yesExit => 'അതെ, പുറത്തുകടക്കുക';

  @override
  String get yesLogout => 'അതെ, ലോഗ് ഔട്ട്';

  @override
  String get deleteAccountTitle => 'അക്കൗണ്ട് ഇല്ലാതാക്കണോ?';

  @override
  String get deleteAccountMessage =>
      'നിങ്ങൾക്ക് തീർച്ചയായും അക്കൗണ്ട് ഇല്ലാതാക്കണോ?';

  @override
  String get companyProfile => 'കമ്പനി പ്രൊഫൈൽ';

  @override
  String get shadeCardPickerTitle => 'ഷേഡ് കാർഡുകൾ';

  @override
  String get shadeCardPickerSubtitle =>
      'ഈ കമ്പനിയുടെ എല്ലാ ഷേഡ് കാർഡുകളും താരതമ്യം ചെയ്ത് തുണിയുമായി പൊരുത്തപ്പെടുന്ന ഒന്ന് തിരഞ്ഞെടുക്കുക.';

  @override
  String get shadeCardSelectHint =>
      'തിരഞ്ഞെടുക്കാൻ ഒരു ഷേഡ് കാർഡിൽ ടാപ്പ് ചെയ്യുക';

  @override
  String get shadeCardContinue => 'താരതമ്യം ചെയ്ത് പൊരുത്തിക്കുക';

  @override
  String get addReview => 'അവലോകനം ചേർക്കുക';

  @override
  String get rateCompany => 'ഈ കമ്പനി റേറ്റ് ചെയ്യുക';

  @override
  String get yourReview => 'നിങ്ങളുടെ അവലോകനം';

  @override
  String get reviewHint => 'നൂലിന്റെ ഗുണനിലവാരം, ഡെലിവറി, സേവനം എന്നിവ പറയുക…';

  @override
  String get submitReview => 'സമർപ്പിക്കുക';

  @override
  String get reviewThanks => 'നിങ്ങളുടെ പ്രതികരണത്തിന് നന്ദി!';

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
  String get selectStarRating => 'റേറ്റ് ചെയ്യാൻ നക്ഷത്രങ്ങളിൽ ടാപ്പ് ചെയ്യുക';

  @override
  String whatsappInquiryMessage(String productName, String companyName) {
    return 'ഹലോ, എനിക്ക് \"$productName\" ൽ താൽപ്പര്യമുണ്ട്, $companyName ഉമായി വില, കുറഞ്ഞ ഓർഡർ അളവ്, ഡെലിവറി വിശദാംശങ്ങൾ എന്നിവ അന്വേഷിക്കാൻ ആഗ്രഹിക്കുന്നു.';
  }

  @override
  String get navMatch => 'പൊരുത്തം';

  @override
  String get matchScreenTitle => 'നൂൽ പൊരുത്തം';

  @override
  String get matchScreenSubtitle =>
      'ഏതെങ്കിലും തുണിയിൽ ക്യാമറ ചൂണ്ടി ഉടനടി പൊരുത്തമുള്ള നൂലുകൾ കണ്ടെത്തുക';

  @override
  String get matchHowItWorks => 'ഇത് എങ്ങനെ പ്രവർത്തിക്കുന്നു';

  @override
  String get matchStep1 => 'തുണിയിൽ ക്യാമറ ചൂണ്ടുക';

  @override
  String get matchStep2 => 'ഞങ്ങൾ നിറവും ഘടനയും സ്കാൻ ചെയ്യുന്നു';

  @override
  String get matchStep3 => 'പൊരുത്തമുള്ള നൂൽ ഫലങ്ങൾ നേടുക';

  @override
  String get matchOpenCamera => 'ക്യാമറ തുറക്കുക';

  @override
  String get matchPermissionTitle => 'ക്യാമറ ആക്സസ് ആവശ്യമാണ്';

  @override
  String get matchPermissionMessage =>
      'യഥാർത്ഥ തുണിക്ക് നൂൽ നിറങ്ങൾ പൊരുത്തപ്പെടുത്താൻ ക്യാമറ ആക്സസ് അനുവദിക്കുക.';

  @override
  String get matchOpenSettings => 'ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get matchPointHint =>
      'നൂൽ നിറം പൊരുത്തപ്പെടുത്താൻ തുണിയിൽ ക്യാമറ ചൂണ്ടുക';

  @override
  String get matchThreadMatch => 'നൂൽ പൊരുത്തം';

  @override
  String get matchScanning => 'നിങ്ങളുടെ ചിത്രം സ്കാൻ ചെയ്യുന്നു…';

  @override
  String get matchUploadHint => 'തുണിയുടെ ചിത്രം അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get matchUploadSubHint =>
      'ഗ്യാലറി അല്ലെങ്കിൽ ക്യാമറയിൽ നിന്ന് തിരഞ്ഞെടുക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get matchPickGallery => 'ഗ്യാലറി';

  @override
  String get matchPickCamera => 'ക്യാമറ';

  @override
  String get matchPickSource => 'ചിത്രത്തിന്റെ ഉറവിടം തിരഞ്ഞെടുക്കുക';

  @override
  String get matchCaptureTipsTitle =>
      'വ്യക്തമായ ഫാബ്രിക് ഫോട്ടോയ്ക്കുള്ള നുറുങ്ങുകൾ';

  @override
  String get matchCaptureTipLighting =>
      'തെളിച്ചമുള്ള, സമമായ വെളിച്ചം ഉപയോഗിക്കുക — പ്രകൃതിദത്ത പകൽ വെളിച്ചം ഏറ്റവും നല്ലത്';

  @override
  String get matchCaptureTipFocus =>
      'ഫാബ്രിക് പരന്നതും വ്യക്തവും ഫോക്കസിലും വയ്ക്കുക';

  @override
  String get matchCaptureTipFrame =>
      'നിങ്ങൾ പൊരുത്തപ്പെടുത്താൻ ആഗ്രഹിക്കുന്ന നിറം അല്ലെങ്കിൽ പാറ്റേൺ ഫ്രെയിമിൽ നിറയ്ക്കുക';

  @override
  String get matchCaptureTipAvoid =>
      'നിഴൽ, തിളക്കം, മങ്ങൽ, തിരക്കുള്ള പശ്ചാത്തലം ഒഴിവാക്കുക';

  @override
  String get matchCaptureTipSingle =>
      'കൃത്യമായ ഫലത്തിന് ഒരു സമയം ഒരു ഫാബ്രിക് ഭാഗം മാത്രം എടുക്കുക';

  @override
  String get matchCaptureTipGalleryNote =>
      'ഫാബ്രിക് നിറം വ്യക്തമായി കാണുന്ന വ്യക്തവും നല്ല വെളിച്ചമുള്ളതുമായ ഫോട്ടോ തിരഞ്ഞെടുക്കുക';

  @override
  String get matchCaptureTipCameraNote =>
      'ഫോൺ സ്ഥിരമായി പിടിച്ച് ഫോക്കസ് ചെയ്യാൻ ടാപ്പ് ചെയ്ത് പിന്നീട് ക്യാപ്ചർ ചെയ്യുക';

  @override
  String get matchCaptureContinueGallery => 'ഗാലറിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get matchCaptureContinueCamera => 'ക്യാമറ തുറക്കുക';

  @override
  String get matchCaptureGotIt => 'മനസ്സിലായി, തുടരുക';

  @override
  String get matchEmptyTitle => 'പൊരുത്തമുള്ള നൂലുകൾ കണ്ടെത്തുക';

  @override
  String get matchEmptySubtitle =>
      'ഏതെങ്കിലും തുണിയുടെ ഫോട്ടോ അപ്‌ലോഡ് ചെയ്യുക, ഞങ്ങൾ ഞങ്ങളുടെ കാറ്റലോഗിൽ നിന്ന് ഏറ്റവും അടുത്ത നൂൽ പൊരുത്തങ്ങൾ കണ്ടെത്തും';

  @override
  String get matchNoResults => 'പൊരുത്തമുള്ള നൂലുകൾ ഒന്നും കണ്ടെത്തിയില്ല';

  @override
  String matchResultsTitle(int count) {
    return '$count പൊരുത്തമുള്ള നൂലുകൾ കണ്ടെത്തി';
  }
}
