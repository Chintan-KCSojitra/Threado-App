// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Threado';

  @override
  String get chooseLanguageTitle => 'भाषा चुनें';

  @override
  String get changeLanguageTitle => 'भाषा बदलें';

  @override
  String get welcomeToApp => 'थ्रेडो में आपका स्वागत है';

  @override
  String get loginTagline =>
      'अपनी स्टाइल को धागे से सजाएं। अपना अगला कपड़ा मैच खोजें।';

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
  String get loginAcceptTermsPrefix => 'मैं सहमत हूं ';

  @override
  String get loginAcceptTermsAnd => ' और ';

  @override
  String get loginAcceptTermsRequired =>
      'जारी रखने के लिए नियम और शर्तें तथा गोपनीयता नीति स्वीकार करें';

  @override
  String get pleaseLoginContinue =>
      'जारी रखने के लिए कृपया अपने खाते में लॉग इन करें';

  @override
  String get otpVerificationTitle => 'ओटीपी सत्यापन';

  @override
  String get otpSecureTitle => 'सुरक्षित साइन इन';

  @override
  String otpSentMessage(String phone) {
    return 'हमने आपका थ्रेडो सत्यापन कोड यहाँ भेजा है\n$phone';
  }

  @override
  String get otpDidntReceive => 'कोड नहीं मिला? ';

  @override
  String get otpResend => 'पुनः भेजें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get welcomeTraders => 'स्वागत है, व्यापारियों';

  @override
  String get navHome => 'होम';

  @override
  String get navCategories => 'श्रेणियाँ';

  @override
  String get navCompany => 'कंपनी';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get screenCategory => 'श्रेणी';

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get thredoId => 'थ्रेडो आईडी';

  @override
  String get verifiedBuyer => 'सत्यापित खरीदार';

  @override
  String get profileSubtitle => 'अपनी धागा सोर्सिंग यात्रा प्रबंधित करें';

  @override
  String get statOrders => 'ऑर्डर';

  @override
  String get statSaved => 'सहेजे गए';

  @override
  String get statMatches => 'मैच';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get deleteAccount => 'खाता हटाएँ';

  @override
  String get delete => 'हटाएँ';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logoutTitle => 'लॉग आउट?';

  @override
  String get logoutMessage => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get exitAppTitle => 'ऐप बंद करें?';

  @override
  String get exitAppMessage => 'क्या आप वाकई Threado बंद करना चाहते हैं?';

  @override
  String get yesExit => 'हाँ, बंद करें';

  @override
  String get yesLogout => 'हाँ, लॉग आउट';

  @override
  String get deleteAccountTitle => 'खाता हटाएँ?';

  @override
  String get deleteAccountMessage => 'क्या आप वाकई अपना खाता हटाना चाहते हैं?';

  @override
  String get companyProfile => 'कंपनी प्रोफ़ाइल';

  @override
  String get shadeCardPickerTitle => 'शेड कार्ड';

  @override
  String get shadeCardPickerSubtitle =>
      'इस कंपनी के सभी शेड कार्ड की तुलना करें और फैब्रिक से मिलाने के लिए एक चुनें।';

  @override
  String get shadeCardSelectHint => 'चुनने के लिए शेड कार्ड पर टैप करें';

  @override
  String get shadeCardContinue => 'तुलना करें और मिलाएं';

  @override
  String get addReview => 'समीक्षा जोड़ें';

  @override
  String get rateCompany => 'इस कंपनी को रेट करें';

  @override
  String get yourReview => 'आपकी समीक्षा';

  @override
  String get reviewHint =>
      'धागे की गुणवत्ता, डिलीवरी और सेवा के बारे में बताएँ…';

  @override
  String get submitReview => 'जमा करें';

  @override
  String get reviewThanks => 'आपकी प्रतिक्रिया के लिए धन्यवाद!';

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
  String get selectStarRating => 'रेट करने के लिए सितारों पर टैप करें';

  @override
  String whatsappInquiryMessage(String productName, String companyName) {
    return 'नमस्ते, मुझे \"$productName\" में रुचि है और मैं $companyName से मूल्य, न्यूनतम ऑर्डर मात्रा और डिलीवरी विवरण के बारे में जानकारी लेना चाहता/चाहती हूँ।';
  }

  @override
  String get navMatch => 'मैच';

  @override
  String get matchScreenTitle => 'धागा मैच';

  @override
  String get matchScreenSubtitle =>
      'किसी भी कपड़े पर कैमरा लगाएं और तुरंत मिलते-जुलते धागे खोजें';

  @override
  String get matchHowItWorks => 'यह कैसे काम करता है';

  @override
  String get matchStep1 => 'कपड़े पर कैमरा लगाएं';

  @override
  String get matchStep2 => 'हम रंग और बनावट स्कैन करते हैं';

  @override
  String get matchStep3 => 'मिलते-जुलते धागे के परिणाम पाएं';

  @override
  String get matchOpenCamera => 'कैमरा खोलें';

  @override
  String get matchPermissionTitle => 'कैमरा एक्सेस आवश्यक है';

  @override
  String get matchPermissionMessage =>
      'असली कपड़े से धागे के रंग मिलाने के लिए कैमरा एक्सेस दें।';

  @override
  String get matchOpenSettings => 'सेटिंग खोलें';

  @override
  String get matchPointHint => 'धागे का रंग मिलाने के लिए कैमरा कपड़े पर लगाएं';

  @override
  String get matchThreadMatch => 'धागा मैच';

  @override
  String get matchScanning => 'आपकी छवि स्कैन हो रही है…';

  @override
  String get matchUploadHint => 'कपड़े की छवि अपलोड करें';

  @override
  String get matchUploadSubHint => 'गैलरी या कैमरे से चुनने के लिए टैप करें';

  @override
  String get matchPickGallery => 'गैलरी';

  @override
  String get matchPickCamera => 'कैमरा';

  @override
  String get matchPickSource => 'छवि स्रोत चुनें';

  @override
  String get matchCaptureTipsTitle => 'स्पष्ट फ़ैब्रिक फ़ोटो के लिए सुझाव';

  @override
  String get matchCaptureTipLighting =>
      'चमकदार, समान रोशनी का उपयोग करें — प्राकृतिक दिन की रोशनी सबसे अच्छी है';

  @override
  String get matchCaptureTipFocus =>
      'फ़ैब्रिक को सपाट, स्पष्ट और फ़ोकस में रखें';

  @override
  String get matchCaptureTipFrame =>
      'फ़्रेम को उस रंग या पैटर्न से भरें जिसे आप मैच करना चाहते हैं';

  @override
  String get matchCaptureTipAvoid =>
      'छाया, चमक, धुंधलापन और व्यस्त पृष्ठभूमि से बचें';

  @override
  String get matchCaptureTipSingle =>
      'सटीक परिणाम के लिए एक समय में एक फ़ैब्रिक क्षेत्र कैप्चर करें';

  @override
  String get matchCaptureTipGalleryNote =>
      'एक स्पष्ट, अच्छी रोशनी वाली फ़ोटो चुनें जिसमें फ़ैब्रिक का रंग साफ़ दिखे';

  @override
  String get matchCaptureTipCameraNote =>
      'फ़ोन को स्थिर रखें, फ़ोकस के लिए टैप करें, फिर कैप्चर करें';

  @override
  String get matchCaptureContinueGallery => 'गैलरी से चुनें';

  @override
  String get matchCaptureContinueCamera => 'कैमरा खोलें';

  @override
  String get matchCaptureGotIt => 'समझ गया, जारी रखें';

  @override
  String get matchEmptyTitle => 'मिलते-जुलते धागे खोजें';

  @override
  String get matchEmptySubtitle =>
      'किसी भी कपड़े की फोटो अपलोड करें और हम हमारे कैटलॉग से सबसे करीबी धागे के मैच खोजेंगे';

  @override
  String get matchNoResults => 'कोई मिलते-जुलते धागे नहीं मिले';

  @override
  String matchResultsTitle(int count) {
    return '$count मिलते-जुलते धागे मिले';
  }
}
