/// Simple in-memory store that holds the header image URLs fetched on splash.
/// Both LoginScreen and OtpVerificationScreen read from here.
class HeaderImagesStore {
  HeaderImagesStore._();

  static final List<String> _urls = [];

  /// Populated by SplashScreen after the API call succeeds.
  static void setUrls(List<String> urls) {
    _urls
      ..clear()
      ..addAll(urls.where((u) => u.trim().isNotEmpty));
  }

  /// Returns the fetched URLs, or an empty list if not yet loaded.
  static List<String> get urls => List.unmodifiable(_urls);

  static bool get hasData => _urls.isNotEmpty;
}
