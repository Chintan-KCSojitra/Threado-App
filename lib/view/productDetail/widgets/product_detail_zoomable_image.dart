import 'package:flutter/material.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/widget/app_cached_image.dart';

/// Full-screen product image using the original API URL (no resize variant).
class ProductDetailZoomableImage extends StatefulWidget {
  const ProductDetailZoomableImage({
    super.key,
    required this.imageUrl,
    required this.transformationController,
    required this.onZoomChanged,
    this.isActive = true,
  });

  final String imageUrl;
  final TransformationController transformationController;
  final ValueChanged<bool> onZoomChanged;
  final bool isActive;

  @override
  State<ProductDetailZoomableImage> createState() =>
      _ProductDetailZoomableImageState();
}

class _ProductDetailZoomableImageState extends State<ProductDetailZoomableImage>
    with SingleTickerProviderStateMixin {
  static const double _zoomEpsilon = 0.01;
  static const double _doubleTapScale = 2.5;
  static const double _maxScale = 5.0;

  late final AnimationController _zoomAnimationController;
  Animation<Matrix4>? _zoomAnimation;
  TapDownDetails? _doubleTapDown;

  @override
  void initState() {
    super.initState();
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    widget.transformationController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    widget.transformationController.removeListener(_onTransformChanged);
    _zoomAnimationController.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    if (!widget.isActive) return;
    final zoomed =
        widget.transformationController.value.getMaxScaleOnAxis() >
        1.0 + _zoomEpsilon;
    widget.onZoomChanged(zoomed);
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _doubleTapDown = details;
  }

  void _onDoubleTap() {
    final controller = widget.transformationController;
    final zoomed = controller.value.getMaxScaleOnAxis() > 1.0 + _zoomEpsilon;

    Matrix4 endMatrix;
    if (zoomed) {
      endMatrix = Matrix4.identity();
    } else {
      final position = _doubleTapDown?.localPosition ?? Offset.zero;
      final dx = -position.dx * (_doubleTapScale - 1);
      final dy = -position.dy * (_doubleTapScale - 1);
      // ignore: deprecated_member_use
      endMatrix = Matrix4.identity()..translate(dx, dy)..scale(_doubleTapScale);
    }

    _zoomAnimation = Matrix4Tween(
      begin: controller.value,
      end: endMatrix,
    ).animate(
      CurvedAnimation(
        parent: _zoomAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _zoomAnimationController
      ..reset()
      ..forward();

    void listener() {
      if (_zoomAnimation != null) {
        controller.value = _zoomAnimation!.value;
      }
    }

    _zoomAnimationController.removeListener(listener);
    _zoomAnimationController.addListener(listener);
    _zoomAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _zoomAnimationController.removeListener(listener);
        _onTransformChanged();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.imageUrl.trim();
    if (url.isEmpty) {
      return const ColoredBox(
        color: colorBlack,
        child: Center(
          child: Icon(Icons.broken_image_outlined, color: colorWhite),
        ),
      );
    }

    return RepaintBoundary(
      child: GestureDetector(
        onDoubleTapDown: _onDoubleTapDown,
        onDoubleTap: _onDoubleTap,
        child: InteractiveViewer(
          transformationController:
              widget.isActive ? widget.transformationController : null,
          panEnabled: false,
          scaleEnabled: false,
          minScale: 1.0,
          maxScale: _maxScale,
          clipBehavior: Clip.hardEdge,
          boundaryMargin: const EdgeInsets.all(80),
          child: ColoredBox(
            color: colorWhite,
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: AppCachedImage(
                  imageUrl: url,
                  useResize: false,
                  useMemCache: false,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  showShimmer: true,
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
