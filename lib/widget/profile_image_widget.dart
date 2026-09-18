import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../res/image.dart';
import '../utils/media_resize_url.dart';
import '../utils/app_cache_manager.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.width,
    required this.height,
    this.userProfileImage,
    this.isBlur = false,
    this.showPadding = true,
    this.isCircle = true,
    this.borderRadius = 0,
    this.fit,
    this.errorWidget,
    this.padding,
  });

  final double height, width, borderRadius;
  final String? userProfileImage;
  final bool isBlur, showPadding, isCircle;
  final BoxFit? fit;
  final Widget? errorWidget;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(final BuildContext context) {
    final loadUrl = MediaResizeUrl.resolve(
      userProfileImage ?? testUserNetworkImg2,
      AppImageVariant.thumb,
    );
    return CachedNetworkImage(
    memCacheWidth: 300,
    memCacheHeight: 300,
    imageUrl: loadUrl,
    cacheManager: AppCacheManager.instance,
    imageBuilder: (final context, final imageProvider) => Material(
      shadowColor: Colors.black.withValues(alpha: 0.4),
      color: Colors.white,
      borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
      type: isCircle ? MaterialType.circle : MaterialType.button,
      child: Container(
        padding: showPadding ? padding ?? const EdgeInsets.all(10) : null,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
            image: DecorationImage(image: imageProvider, fit: fit ?? BoxFit.fill),
          ),
        ),
      ),
    ),
    placeholder: (final context, final url) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        image: DecorationImage(
          image: const AssetImage(PNGImages.imgUserPlaceHolder),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    ),
    errorWidget: (final context, final url, final error) =>
        errorWidget ??
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
            image: DecorationImage(
              image: const AssetImage(PNGImages.imgUserPlaceHolder),
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
  );
  }
}
