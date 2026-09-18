import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/utils/app_cache_manager.dart';
import 'package:thredo/utils/media_resize_url.dart';
import 'package:thredo/view/productDetail/widgets/product_detail_image_placeholder.dart';

enum ProductDetailImageMode {
  /// 1200px preview first, then crossfade to original.
  detail,

  /// Original only — AR Match centre-crop at 2.8× needs full resolution.
  arMatch,
}

/// Progressive, blink-free loader for product detail and AR Match images.
class ProductDetailImageLoader extends StatefulWidget {
  const ProductDetailImageLoader({
    super.key,
    required this.imageUrl,
    this.mode = ProductDetailImageMode.detail,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.high,
    this.onImageReady,
  });

  final String imageUrl;
  final ProductDetailImageMode mode;
  final BoxFit fit;
  final Alignment alignment;
  final FilterQuality filterQuality;
  final VoidCallback? onImageReady;

  static Future<void> warmCache(String? imageUrl) async {
    final original = imageUrl?.trim() ?? '';
    if (original.isEmpty) return;

    final cache = AppCacheManager.instance;
    final preview = MediaResizeUrl.resolve(original, AppImageVariant.large);

    try {
      if (preview.isNotEmpty) {
        await cache.downloadFile(preview);
      }
      unawaited(cache.downloadFile(original));
    } catch (_) {}
  }

  static Future<void> precacheInContext(
    BuildContext context,
    String? imageUrl,
  ) async {
    final original = imageUrl?.trim() ?? '';
    if (original.isEmpty || !context.mounted) return;

    final cache = AppCacheManager.instance;
    final preview = MediaResizeUrl.resolve(original, AppImageVariant.large);

    try {
      if (preview.isNotEmpty) {
        await precacheImage(
          CachedNetworkImageProvider(preview, cacheManager: cache),
          context,
        );
      }
      if (context.mounted) {
        unawaited(
          precacheImage(
            CachedNetworkImageProvider(original, cacheManager: cache),
            context,
          ),
        );
      }
    } catch (_) {}
  }

  @override
  State<ProductDetailImageLoader> createState() =>
      _ProductDetailImageLoaderState();
}

class _ProductDetailImageLoaderState extends State<ProductDetailImageLoader> {
  bool _previewVisible = false;
  bool _originalVisible = false;

  @override
  void initState() {
    super.initState();
    unawaited(ProductDetailImageLoader.warmCache(widget.imageUrl));
  }

  @override
  void didUpdateWidget(ProductDetailImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _previewVisible = false;
      _originalVisible = false;
      unawaited(ProductDetailImageLoader.warmCache(widget.imageUrl));
    }
  }

  void _onPreviewReady() {
    if (_previewVisible || !mounted) return;
    setState(() => _previewVisible = true);
  }

  void _onOriginalReady() {
    if (_originalVisible || !mounted) return;
    setState(() => _originalVisible = true);
    widget.onImageReady?.call();
  }

  @override
  Widget build(BuildContext context) {
    final original = widget.imageUrl.trim();
    if (original.isEmpty) return _buildError();

    final showPlaceholder = !_previewVisible && !_originalVisible;

    if (widget.mode == ProductDetailImageMode.arMatch) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (showPlaceholder)
            const ColoredBox(color: Color(0x42000000)),
          _buildNetworkLayer(
            url: original,
            memCacheWidth: null,
            memCacheHeight: null,
            opacity: 1,
            onReady: _onOriginalReady,
            filterQuality: widget.filterQuality,
          ),
        ],
      );
    }

    final preview = MediaResizeUrl.resolve(original, AppImageVariant.large);
    final usePreview = preview.isNotEmpty && preview != original;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (showPlaceholder) const ProductDetailImagePlaceholder(),
        if (usePreview)
          _buildNetworkLayer(
            url: preview,
            memCacheWidth: AppImageVariant.large.width,
            memCacheHeight: AppImageVariant.large.height,
            opacity: _originalVisible ? 0 : 1,
            onReady: _onPreviewReady,
            filterQuality: FilterQuality.medium,
          ),
        _buildNetworkLayer(
          url: original,
          memCacheWidth: null,
          memCacheHeight: null,
          opacity: _originalVisible ? 1 : 0,
          onReady: _onOriginalReady,
          filterQuality: widget.filterQuality,
        ),
      ],
    );
  }

  Widget _buildNetworkLayer({
    required String url,
    required int? memCacheWidth,
    required int? memCacheHeight,
    required double opacity,
    required VoidCallback onReady,
    required FilterQuality filterQuality,
  }) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: CachedNetworkImage(
        imageUrl: url,
        cacheManager: AppCacheManager.instance,
        fit: widget.fit,
        alignment: widget.alignment,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (_, __) => const SizedBox.shrink(),
        errorWidget: (_, __, ___) => const SizedBox.shrink(),
        imageBuilder: (context, imageProvider) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
          return Image(
            image: imageProvider,
            fit: widget.fit,
            alignment: widget.alignment,
            width: double.infinity,
            height: double.infinity,
            filterQuality: filterQuality,
            gaplessPlayback: true,
          );
        },
      ),
    );
  }

  Widget _buildError() {
    return ColoredBox(
      color: colorE6E6E6,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: colorD9D9D9,
          size: 32.sp,
        ),
      ),
    );
  }
}

