// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'Threado';

  @override
  String get chooseLanguageTitle => 'भाषा निवडा';

  @override
  String get changeLanguageTitle => 'भाषा बदला';

  @override
  String get welcomeToApp => 'थ्रेडोमध्ये आपले स्वागत आहे';

  @override
  String get loginTagline =>
      'आपली शैली धाग्याने सजवा. आपला पुढचा कापड जुळवणी शोधा.';

  @override
  String get tagTrending => 'ट्रेंडिंग';

  @override
  String get tagPremium => 'प्रीमियम';

  @override
  String get tagVerified => 'सत्यापित';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get login => 'लॉग इन';

  @override
  String get loginAcceptTermsPrefix => 'मी सहमत आहे ';

  @override
  String get loginAcceptTermsAnd => ' आणि ';

  @override
  String get loginAcceptTermsRequired =>
      'पुढे जाण्यासाठी अटी व गोपनीयता धोरण स्वीकारा';

  @override
  String get pleaseLoginContinue =>
      'सुरू ठेवण्यासाठी कृपया आपल्या खात्यात लॉग इन करा';

  @override
  String get otpVerificationTitle => 'OTP पडताळणी';

  @override
  String get otpSecureTitle => 'सुरक्षित साइन इन';

  @override
  String otpSentMessage(String phone) {
    return 'आम्ही आपला थ्रेडो पडताळणी कोड येथे पाठवला आहे\n$phone';
  }

  @override
  String get otpDidntReceive => 'कोड मिळाला नाही? ';

  @override
  String get otpResend => 'पुन्हा पाठवा';

  @override
  String get confirm => 'पुष्टी करा';

  @override
  String get welcomeTraders => 'स्वागत आहे, व्यापार्‍यांनो';

  @override
  String get navHome => 'होम';

  @override
  String get navCategories => 'श्रेण्या';

  @override
  String get navCompany => 'कंपनी';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get screenCategory => 'श्रेणी';

  @override
  String get myProfile => 'माझे प्रोफाइल';

  @override
  String get thredoId => 'थ्रेडो ID';

  @override
  String get verifiedBuyer => 'सत्यापित खरेदीदार';

  @override
  String get profileSubtitle => 'आपली धागा सोर्सिंग प्रवास व्यवस्थापित करा';

  @override
  String get statOrders => 'ऑर्डर';

  @override
  String get statSaved => 'जतन केलेले';

  @override
  String get statMatches => 'जुळण्या';

  @override
  String get privacyPolicy => 'गोपनीयता धोरण';

  @override
  String get termsAndConditions => 'अटी आणि शर्ती';

  @override
  String get deleteAccount => 'खाते हटवा';

  @override
  String get delete => 'हटवा';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logoutTitle => 'लॉग आउट?';

  @override
  String get logoutMessage => 'तुम्हाला खरोखर लॉग आउट करायचे आहे का?';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get exitAppTitle => 'अॅप बंद करायचे?';

  @override
  String get exitAppMessage => 'तुम्हाला खरोखर Threado बंद करायचे आहे का?';

  @override
  String get yesExit => 'होय, बंद करा';

  @override
  String get yesLogout => 'होय, लॉग आउट';

  @override
  String get deleteAccountTitle => 'खाते हटवायचे?';

  @override
  String get deleteAccountMessage => 'तुम्हाला खरोखर आपले खाते हटवायचे आहे का?';

  @override
  String get companyProfile => 'कंपनी प्रोफाइल';

  @override
  String get shadeCardPickerTitle => 'शेड कार्ड';

  @override
  String get shadeCardPickerSubtitle =>
      'या कंपनीचे सर्व शेड कार्ड तुलना करा आणि फॅब्रिकशी जुळणारे एक निवडा.';

  @override
  String get shadeCardSelectHint => 'निवडण्यासाठी शेड कार्डवर टॅप करा';

  @override
  String get shadeCardContinue => 'तुलना करा आणि जुळवा';

  @override
  String get addReview => 'पुनरावलोकन जोडा';

  @override
  String get rateCompany => 'या कंपनीला रेट करा';

  @override
  String get yourReview => 'आपले पुनरावलोकन';

  @override
  String get reviewHint => 'धाग्याची गुणवत्ता, वितरण आणि सेवेबद्दल सांगा…';

  @override
  String get submitReview => 'सबमिट करा';

  @override
  String get reviewThanks => 'आपल्या अभिप्रायाबद्दल धन्यवाद!';

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
  String get selectStarRating => 'रेट करण्यासाठी ताऱ्यांवर टॅप करा';

  @override
  String whatsappInquiryMessage(String productName, String companyName) {
    return 'नमस्कार, मला \"$productName\" मध्ये स्वारस्य आहे आणि $companyName सोबत किंमत, किमान ऑर्डर प्रमाण आणि डिलिव्हरी तपशीलांबद्दल चौकशी करायची आहे.';
  }

  @override
  String get navMatch => 'जुळणी';

  @override
  String get matchScreenTitle => 'धागा जुळणी';

  @override
  String get matchScreenSubtitle =>
      'कोणत्याही कापडावर कॅमेरा लावा आणि तत्काळ जुळणारे धागे शोधा';

  @override
  String get matchHowItWorks => 'हे कसे कार्य करते';

  @override
  String get matchStep1 => 'कापडावर कॅमेरा लावा';

  @override
  String get matchStep2 => 'आम्ही रंग आणि पोत स्कॅन करतो';

  @override
  String get matchStep3 => 'जुळणाऱ्या धाग्यांचे परिणाम मिळवा';

  @override
  String get matchOpenCamera => 'कॅमेरा उघडा';

  @override
  String get matchPermissionTitle => 'कॅमेरा प्रवेश आवश्यक आहे';

  @override
  String get matchPermissionMessage =>
      'खऱ्या कापडाशी धाग्याचे रंग जुळवण्यासाठी कॅमेरा प्रवेश द्या.';

  @override
  String get matchOpenSettings => 'सेटिंग उघडा';

  @override
  String get matchPointHint => 'धाग्याचा रंग जुळवण्यासाठी कॅमेरा कापडावर लावा';

  @override
  String get matchThreadMatch => 'धागा जुळणी';

  @override
  String get matchScanning => 'तुमची प्रतिमा स्कॅन होत आहे…';

  @override
  String get matchUploadHint => 'कापडाची प्रतिमा अपलोड करा';

  @override
  String get matchUploadSubHint =>
      'गॅलरी किंवा कॅमेऱ्यातून निवडण्यासाठी टॅप करा';

  @override
  String get matchPickGallery => 'गॅलरी';

  @override
  String get matchPickCamera => 'कॅमेरा';

  @override
  String get matchPickSource => 'प्रतिमा स्रोत निवडा';

  @override
  String get matchCaptureTipsTitle => 'स्पष्ट फॅब्रिक फोटोसाठी टिप्स';

  @override
  String get matchCaptureTipLighting =>
      'तेजस्वी, समान प्रकाश वापरा — नैसर्गिक दिवसाचा प्रकाश सर्वोत्तम';

  @override
  String get matchCaptureTipFocus => 'फॅब्रिक सपाट, स्पष्ट आणि फोकसमध्ये ठेवा';

  @override
  String get matchCaptureTipFrame =>
      'ज्या रंग किंवा पॅटर्नशी जुळवायचे आहे तो फ्रेममध्ये भरा';

  @override
  String get matchCaptureTipAvoid =>
      'सावली, चकाकी, अस्पष्टता आणि गर्दीची पार्श्वभूमी टाळा';

  @override
  String get matchCaptureTipSingle =>
      'अचूक निकालासाठी एकावेळी एक फॅब्रिक भाग कॅप्चर करा';

  @override
  String get matchCaptureTipGalleryNote =>
      'फॅब्रिकचा रंग स्पष्ट दिसणारा स्पष्ट, चांगल्या प्रकाशातील फोटो निवडा';

  @override
  String get matchCaptureTipCameraNote =>
      'फोन स्थिर धरा, फोकससाठी टॅप करा, नंतर कॅप्चर करा';

  @override
  String get matchCaptureContinueGallery => 'गॅलरीतून निवडा';

  @override
  String get matchCaptureContinueCamera => 'कॅमेरा उघडा';

  @override
  String get matchCaptureGotIt => 'समजले, पुढे जा';

  @override
  String get matchEmptyTitle => 'जुळणारे धागे शोधा';

  @override
  String get matchEmptySubtitle =>
      'कोणत्याही कापडाचा फोटो अपलोड करा आणि आम्ही आमच्या कॅटलॉगमधून सर्वात जवळचे धागे जुळवू';

  @override
  String get matchNoResults => 'कोणतेही जुळणारे धागे सापडले नाहीत';

  @override
  String matchResultsTitle(int count) {
    return '$count जुळणारे धागे सापडले';
  }
}
