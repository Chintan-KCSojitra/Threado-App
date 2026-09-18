import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/utils/app_cache_manager.dart';
import 'package:thredo/utils/media_resize_url.dart';
import 'package:thredo/widget/app_loader.dart';

/// A centralized, reusable wrapper around [CachedNetworkImage].
///
/// All network-image display in the app should go through this widget so that
/// placeholder / error / caching behaviour can be changed in one place.
class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.variant = AppImageVariant.thumb,
    this.useResize = true,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius = 0,
    this.isCircle = false,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration,
    this.placeholder,
    this.errorWidget,
    this.errorAssetPath,
    this.placeholderColor,
    this.showShimmer = false,
    this.useMemCache = true,
    this.progressIndicatorBuilder,
    this.imageBuilder,
  });

  /// Original image URL from the API (resize is applied automatically).
  final String imageUrl;

  /// One of three resize sizes — thumb (300), medium (600), large (1200).
  final AppImageVariant variant;

  /// When false, [imageUrl] is loaded as-is (e.g. already a resize URL).
  final bool useResize;

  /// Optional fixed width / height.
  final double? width;
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Alignment of the image within its bounds.
  final Alignment alignment;

  /// Clip corners with a rounded rectangle when > 0.
  final double borderRadius;

  /// Clip to a circle (takes precedence over [borderRadius]).
  final bool isCircle;

  /// Resize the decoded image in memory to save RAM.
  final int? memCacheWidth;
  final int? memCacheHeight;

  /// Fade-in / fade-out animation durations.
  final Duration fadeInDuration;
  final Duration? fadeOutDuration;

  // ── Custom builders ──────────────────────────────────────────────────────

  /// Fully custom placeholder widget (overrides [showShimmer] & [placeholderColor]).
  final Widget? placeholder;

  /// Fully custom error widget (overrides [errorAssetPath]).
  final Widget? errorWidget;

  /// Asset path to show on error via [Image.asset].
  /// Ignored when [errorWidget] is provided.
  final String? errorAssetPath;

  /// Background colour for the default placeholder container.
  /// Ignored when [placeholder] or [showShimmer] is set.
  final Color? placeholderColor;

  /// Show a shimmer effect as the loading placeholder.
  final bool showShimmer;

  /// Progress indicator builder for download-progress feedback.
  /// When provided, [placeholder] is ignored by [CachedNetworkImage].
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Whether to use the memory resizing logic (defaults to true).
  /// Disable this for zoomable or full-screen images where you need maximum resolution.
  final bool useMemCache;

  /// Full control over the rendered image (receives [ImageProvider]).
  final ImageWidgetBuilder? imageBuilder;

  // ── Build ──────────────────────────────────────────────────────────────────

  String get _loadUrl => useResize
      ? MediaResizeUrl.resolve(imageUrl, variant)
      : imageUrl;

  @override
  Widget build(BuildContext context) {
    final loadUrl = _loadUrl;
    if (loadUrl.isEmpty) {
      return _buildError();
    }

    int? finalMemCacheWidth = memCacheWidth;
    int? finalMemCacheHeight = memCacheHeight;

    if (useMemCache) {
      // Apply sensible default memory limits if none were explicitly provided
      if (finalMemCacheWidth == null && finalMemCacheHeight == null) {
        if (width != null && width != double.infinity) {
          finalMemCacheWidth = (width! * 3).toInt();
        }
        if (height != null && height != double.infinity) {
          finalMemCacheHeight = (height! * 3).toInt();
        }

        // If still null, cap decode size to the resize variant
        // EXCEPTION: For BoxFit.contain, we MUST NOT cap decode size if it causes cropping.
        // We will only cap if useResize is true.
        if (finalMemCacheWidth == null && finalMemCacheHeight == null && useResize) {
          finalMemCacheWidth = variant.width;
          finalMemCacheHeight = variant.height;
        }
      }
    } else {
      finalMemCacheWidth = null;
      finalMemCacheHeight = null;
    }

    Widget image = CachedNetworkImage(
      imageUrl: loadUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      memCacheWidth: finalMemCacheWidth,
      memCacheHeight: finalMemCacheHeight,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      imageBuilder: imageBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      placeholder: progressIndicatorBuilder != null
          ? null
          : (_, __) => _buildPlaceholder(),
      errorWidget: (_, __, ___) => _buildError(),
      cacheManager: AppCacheManager.instance,
    );

    // ── Clipping ──
    if (isCircle) {
      image = ClipOval(child: image);
    } else if (borderRadius > 0) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
    }

    return image;
  }

  // ── Defaults ────────────────────────────────────────────────────────────────

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;

    if (showShimmer) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFFEEEEEE),
        highlightColor: const Color(0xFFF8F8F8),
        child: Container(width: width, height: height, color: Colors.white),
      );
    }

    return ColoredBox(
      color: placeholderColor ?? colorF2F2F2,
      child: AppLoader.centered(
        size: 28,
        accentColor: colorCEAB8D,
      ),
    );
  }

  Widget _buildError() {
    if (errorWidget != null) return errorWidget!;

    if (errorAssetPath != null) {
      return Image.asset(
        errorAssetPath!,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Container(
      width: width,
      height: height,
      color: colorE6E6E6,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colorD9D9D9,
        size: 24.sp,
      ),
    );
  }
}
