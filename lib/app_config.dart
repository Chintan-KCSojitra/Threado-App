enum ThemeType { light, dark }

class AppConfig {
  static const String appName = 'Threado';
  static String defaultLanguage = 'en';

  /// Update to your official support inbox before release.
  static const String supportEmail = 'support@thredo.com';
}

class ApiConfig {
  static const String domain = 'https://api.threadoapp.com';
  static const String deepLinkDomain = 'https://vibely.com.au/';
  static const String baseUrl = '$domain/api/v1/';
  static const String authorizationTokenKey = 'Authorization';
  static const String acceptLanguageKey = 'Accept-Language';
  static const String contentTypeKey = 'Content-Type';
  static const String applicationJsonKey = 'application/json';

  static const String productListEP = 'user/products';
  static const String addToWishListEP = 'user/wishlist/';
  static const String getWishListEP = 'user/wishlist/';
  static const String bannerEP = 'user/banners';

  //Auth
  static const String loginEP = 'auth/login';
  static const String sendOtpEP = 'auth/send-otp';
  static const String verifyOtpEP = 'auth/verify-otp';

  //company
  static const String companyListEP = 'user/companies';
  static const String companyDetailEP = 'user/companies';

  /// GET paginated reviews · POST new review
  static String companyReviewsEP(String companyId) => 'user/companies/$companyId/reviews';

  //Profile
  static const String logoutEP = "user/auth/logout";
  static const String deleteAccountEP = "user/profile/me";

  //Other
  static const String logEventEP = 'user/events';
  static const String colorsEP = 'user/colors/';
  static const String materialsEP = 'user/materials/';

  //Categories
  static const String categoryListEP = 'user/categories';

  //Image List
  static const String imageListEP = 'user/images/list';
  static const String matchThreadEP = 'user/images/match-thread';

  /// Resize proxy: `?url={original}&w=&h=`
  static const String mediaResizeEP = 'user/media/resize';
}
