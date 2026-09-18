// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'Threado';

  @override
  String get chooseLanguageTitle => 'భాషను ఎంచుకోండి';

  @override
  String get changeLanguageTitle => 'భాష మార్చండి';

  @override
  String get welcomeToApp => 'థ్రెడోకు స్వాగతం';

  @override
  String get loginTagline =>
      'మీ స్టైల్‌ను దారంతో అలంకరించుకోండి. మీ తదుపరి ఫ్యాబ్రిక్ మ్యాచ్‌ను కనుగొనండి.';

  @override
  String get tagTrending => 'ట్రెండింగ్';

  @override
  String get tagPremium => 'ప్రీమియం';

  @override
  String get tagVerified => 'ధృవీకరించబడింది';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get login => 'లాగిన్';

  @override
  String get loginAcceptTermsPrefix => 'నేను అంగీకరిస్తున్నాను ';

  @override
  String get loginAcceptTermsAnd => ' మరియు ';

  @override
  String get loginAcceptTermsRequired =>
      'కొనసాగించడానికి నిబంధనలు మరియు గోప్యతా విధానాన్ని అంగీకరించండి';

  @override
  String get pleaseLoginContinue =>
      'కొనసాగించడానికి దయచేసి మీ ఖాతాలోకి లాగిన్ అవ్వండి';

  @override
  String get otpVerificationTitle => 'OTP ధృవీకరణ';

  @override
  String get otpSecureTitle => 'సురక్షిత సైన్ ఇన్';

  @override
  String otpSentMessage(String phone) {
    return 'మేము మీ థ్రెడో ధృవీకరణ కోడ్‌ను ఇక్కడ పంపాము\n$phone';
  }

  @override
  String get otpDidntReceive => 'కోడ్ రాలేదా? ';

  @override
  String get otpResend => 'మళ్లీ పంపు';

  @override
  String get confirm => 'నిర్ధారించండి';

  @override
  String get welcomeTraders => 'స్వాగతం, వ్యాపారులారా';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navCategories => 'వర్గాలు';

  @override
  String get navCompany => 'కంపెనీ';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get screenCategory => 'వర్గం';

  @override
  String get myProfile => 'నా ప్రొఫైల్';

  @override
  String get thredoId => 'థ్రెడో ID';

  @override
  String get verifiedBuyer => 'ధృవీకరించబడిన కొనుగోలుదారు';

  @override
  String get profileSubtitle => 'మీ దారం సోర్సింగ్ ప్రయాణాన్ని నిర్వహించండి';

  @override
  String get statOrders => 'ఆర్డర్లు';

  @override
  String get statSaved => 'సేవ్ చేసినవి';

  @override
  String get statMatches => 'మ్యాచ్‌లు';

  @override
  String get privacyPolicy => 'గోప్యతా విధానం';

  @override
  String get termsAndConditions => 'నిబంధనలు';

  @override
  String get deleteAccount => 'ఖాతా తొలగించు';

  @override
  String get delete => 'తొలగించు';

  @override
  String get logout => 'లాగౌట్';

  @override
  String get logoutTitle => 'లాగౌట్?';

  @override
  String get logoutMessage => 'మీరు నిజంగా లాగౌట్ చేయాలనుకుంటున్నారా?';

  @override
  String get cancel => 'రద్దు చేయి';

  @override
  String get exitAppTitle => 'యాప్ నుండి నిష్క్రమించాలా?';

  @override
  String get exitAppMessage =>
      'మీరు ఖచ్చితంగా Threado నుండి నిష్క్రమించాలనుకుంటున్నారా?';

  @override
  String get yesExit => 'అవును, నిష్క్రమించు';

  @override
  String get yesLogout => 'అవును, లాగౌట్';

  @override
  String get deleteAccountTitle => 'ఖాతా తొలగించాలా?';

  @override
  String get deleteAccountMessage =>
      'మీరు నిజంగా మీ ఖాతాను తొలగించాలనుకుంటున్నారా?';

  @override
  String get companyProfile => 'కంపెనీ ప్రొఫైల్';

  @override
  String get shadeCardPickerTitle => 'షేడ్ కార్డులు';

  @override
  String get shadeCardPickerSubtitle =>
      'ఈ కంపెనీ యొక్క అన్ని షేడ్ కార్డులను పోల్చి, ఫాబ్రిక్‌కు సరిపోయేదాన్ని ఎంచుకోండి.';

  @override
  String get shadeCardSelectHint =>
      'ఎంచుకోవడానికి షేడ్ కార్డ్‌పై ట్యాప్ చేయండి';

  @override
  String get shadeCardContinue => 'పోల్చి మ్యాచ్ చేయండి';

  @override
  String get addReview => 'సమీక్ష జోడించు';

  @override
  String get rateCompany => 'ఈ కంపెనీని రేట్ చేయండి';

  @override
  String get yourReview => 'మీ సమీక్ష';

  @override
  String get reviewHint => 'దారం నాణ్యత, డెలివరీ మరియు సేవ గురించి చెప్పండి…';

  @override
  String get submitReview => 'సమర్పించు';

  @override
  String get reviewThanks => 'మీ అభిప్రాయానికి ధన్యవాదాలు!';

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
  String get selectStarRating => 'రేట్ చేయడానికి నక్షత్రాలపై టాప్ చేయండి';

  @override
  String whatsappInquiryMessage(String productName, String companyName) {
    return 'హలో, నాకు \"$productName\" పై ఆసక్తి ఉంది మరియు $companyName తో ధర, కనీస ఆర్డర్ పరిమాణం మరియు డెలివరీ వివరాల గురించి అడగాలనుకుంటున్నాను.';
  }

  @override
  String get navMatch => 'మ్యాచ్';

  @override
  String get matchScreenTitle => 'దారం మ్యాచ్';

  @override
  String get matchScreenSubtitle =>
      'ఏదైనా వస్త్రంపై కెమెరా పెట్టి వెంటనే సరిపోలే దారాలను కనుగొనండి';

  @override
  String get matchHowItWorks => 'ఇది ఎలా పని చేస్తుంది';

  @override
  String get matchStep1 => 'వస్త్రంపై కెమెరా పెట్టండి';

  @override
  String get matchStep2 => 'మేము రంగు మరియు ఆకృతిని స్కాన్ చేస్తాము';

  @override
  String get matchStep3 => 'సరిపోలే దారం ఫలితాలు పొందండి';

  @override
  String get matchOpenCamera => 'కెమెరా తెరవండి';

  @override
  String get matchPermissionTitle => 'కెమెరా యాక్సెస్ అవసరం';

  @override
  String get matchPermissionMessage =>
      'నిజమైన వస్త్రానికి దారం రంగులు సరిపోల్చడానికి కెమెరా యాక్సెస్ అనుమతించండి.';

  @override
  String get matchOpenSettings => 'సెట్టింగ్‌లు తెరవండి';

  @override
  String get matchPointHint =>
      'దారం రంగు సరిపోల్చడానికి వస్త్రంపై కెమెరా పెట్టండి';

  @override
  String get matchThreadMatch => 'దారం మ్యాచ్';

  @override
  String get matchScanning => 'మీ చిత్రం స్కాన్ అవుతోంది…';

  @override
  String get matchUploadHint => 'వస్త్రం చిత్రాన్ని అప్‌లోడ్ చేయండి';

  @override
  String get matchUploadSubHint =>
      'గ్యాలరీ లేదా కెమెరా నుండి ఎంచుకోవడానికి నొక్కండి';

  @override
  String get matchPickGallery => 'గ్యాలరీ';

  @override
  String get matchPickCamera => 'కెమెరా';

  @override
  String get matchPickSource => 'చిత్రం మూలాన్ని ఎంచుకోండి';

  @override
  String get matchCaptureTipsTitle => 'స్పష్టమైన ఫాబ్రిక్ ఫోటో కోసం చిట్కాలు';

  @override
  String get matchCaptureTipLighting =>
      'ప్రకాశవంతమైన, సమాన వెలుతురు ఉపయోగించండి — సహజ పగటి వెలుతురు ఉత్తమం';

  @override
  String get matchCaptureTipFocus =>
      'ఫాబ్రిక్‌ను చదునుగా, స్పష్టంగా మరియు ఫోకస్‌లో ఉంచండి';

  @override
  String get matchCaptureTipFrame =>
      'మ్యాచ్ చేయాలనుకునే రంగు లేదా నమూనాతో ఫ్రేమ్‌ను నింపండి';

  @override
  String get matchCaptureTipAvoid =>
      'నీడలు, మెరుపు, మసక మరియు బిజీ నేపథ్యాన్ని నివారించండి';

  @override
  String get matchCaptureTipSingle =>
      'ఖచ్చితమైన ఫలితాల కోసం ఒక సమయంలో ఒక ఫాబ్రిక్ ప్రాంతాన్ని మాత్రమే క్యాప్చర్ చేయండి';

  @override
  String get matchCaptureTipGalleryNote =>
      'ఫాబ్రిక్ రంగు స్పష్టంగా కనిపించే స్పష్టమైన, మంచి వెలుతురు ఫోటోను ఎంచుకోండి';

  @override
  String get matchCaptureTipCameraNote =>
      'ఫోన్‌ను స్థిరంగా పట్టుకుని, ఫోకస్ చేయడానికి ట్యాప్ చేసి, తర్వాత క్యాప్చర్ చేయండి';

  @override
  String get matchCaptureContinueGallery => 'గ్యాలరీ నుండి ఎంచుకోండి';

  @override
  String get matchCaptureContinueCamera => 'కెమెరా తెరవండి';

  @override
  String get matchCaptureGotIt => 'అర్థమైంది, కొనసాగించండి';

  @override
  String get matchEmptyTitle => 'సరిపోలే దారాలు కనుగొనండి';

  @override
  String get matchEmptySubtitle =>
      'ఏదైనా వస్త్రం ఫోటో అప్‌లోడ్ చేయండి, మేము మా కేటలాగ్ నుండి దగ్గరగా సరిపోలే దారాలు కనుగొంటాము';

  @override
  String get matchNoResults => 'సరిపోలే దారాలు ఏవీ కనుగొనబడలేదు';

  @override
  String matchResultsTitle(int count) {
    return '$count సరిపోలే దారాలు కనుగొనబడ్డాయి';
  }
}
