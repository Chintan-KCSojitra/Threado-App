import 'package:thredo/app_config.dart';

/// The only three image sizes used across the app.
/// All network images should go through [MediaResizeUrl.resolve].
enum AppImageVariant {
  /// Grids, lists, thumbnails — 300×300
  thumb(300, 300),

  /// Cards, banners, profile — 600×600
  medium(600, 600),

  /// Product detail, zoom, shade cards — 1200×1200
  large(1200, 1200);

  const AppImageVariant(this.width, this.height);

  final int width;
  final int height;
}

/// Builds resize API URLs from original image URLs.
///
/// ```text
/// {baseUrl}user/media/resize?url={ENCODED_ORIGINAL}&w={width}&h={height}
/// ```
class MediaResizeUrl {
  MediaResizeUrl._();

  /// Returns a resize URL for [originalUrl], or the input unchanged when
  /// resize does not apply (empty, local asset, already resized).
  static String resolve(
    String? originalUrl, [
    AppImageVariant variant = AppImageVariant.thumb,
  ]) {
    final url = originalUrl?.trim() ?? '';
    if (url.isEmpty) return '';
    if (!_shouldResize(url)) return url;

    final query = Uri(
      queryParameters: {
        'url': url,
        'w': variant.width.toString(),
        'h': variant.height.toString(),
      },
    ).query;

    return '${ApiConfig.baseUrl}${ApiConfig.mediaResizeEP}?$query';
  }

  static bool _shouldResize(String url) {
    final lower = url.toLowerCase();
    if (!lower.startsWith('http://') && !lower.startsWith('https://')) {
      return false;
    }
    if (lower.contains('/user/media/resize')) return false;
    return true;
  }
}

/// Convenience on API image URL strings.
extension MediaResizeUrlExtension on String {
  String resized([AppImageVariant variant = AppImageVariant.thumb]) =>
      MediaResizeUrl.resolve(this, variant);
}
