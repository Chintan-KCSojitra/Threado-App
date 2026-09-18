import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/view/productDetail/widgets/product_detail_image_loader.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

class ARMatchScreen extends StatefulWidget {
  final String productImageUrl;

  /// Selected shade card from company profile picker — shown beside camera.
  final ShadeCards? selectedShadeCard;

  const ARMatchScreen({super.key, required this.productImageUrl, this.selectedShadeCard});

  @override
  State<ARMatchScreen> createState() => _ARMatchScreenState();
}

class _ARMatchScreenState extends State<ARMatchScreen> with SingleTickerProviderStateMixin {
  // ── Camera & Media ────────────────────────────────────────────────────────
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _permissionDenied = false;
  bool _isTorchOn = false;

  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  double _currentZoomLevel = 1.0;
  double _baseZoomLevel = 1.0;

  final ImagePicker _picker = ImagePicker();
  String? _pickedImagePath;

  bool get _isCompanyMode => widget.selectedShadeCard != null;

  @override
  void initState() {
    super.initState();
    ProductDetailImageLoader.warmCache(widget.productImageUrl);
    _checkPermission();
  }

  // ── Camera setup ──────────────────────────────────────────────────────────

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initCamera();
    } else {
      if (mounted) setState(() => _permissionDenied = true);
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      final back = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );
      _controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();

      _minZoomLevel = await _controller!.getMinZoomLevel();
      _maxZoomLevel = await _controller!.getMaxZoomLevel();

      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _toggleTorch() async {
    if (_controller == null || !_isCameraInitialized || _pickedImagePath != null) return;
    HapticFeedback.lightImpact();
    final next = !_isTorchOn;
    await _controller!.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    if (mounted) setState(() => _isTorchOn = next);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseZoomLevel = _currentZoomLevel;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_controller == null || !_isCameraInitialized || _pickedImagePath != null) return;

    final newZoomLevel = (_baseZoomLevel * details.scale).clamp(_minZoomLevel, _maxZoomLevel);
    if (newZoomLevel != _currentZoomLevel) {
      _currentZoomLevel = newZoomLevel;
      _controller!.setZoomLevel(_currentZoomLevel);
      setState(() {});
    }
  }

  // ── Media Actions ─────────────────────────────────────────────────────────

  Future<void> _takePhoto() async {
    if (_controller == null || !_isCameraInitialized || _pickedImagePath != null) return;
    try {
      HapticFeedback.mediumImpact();
      final photo = await _controller!.takePicture();
      if (mounted) {
        setState(() => _pickedImagePath = photo.path);
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    HapticFeedback.lightImpact();
    final photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null && mounted) {
      setState(() => _pickedImagePath = photo.path);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isCompanyMode ? _buildCompanyLayout() : _buildProductLayout(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // COMPANY MODE — split layout
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildCompanyLayout() {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black),

        // ── Split row ─────────────────────────────────────────────────────
        Positioned.fill(
          top: topPad + 56.h,
          bottom: bottomPad + 48.h,
          child: Row(
            children: [
              // Left — selected shade card (40% width)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: _buildSelectedShadeCardPanel(),
                ),
              ),

              // Right — camera (60% width)
              Expanded(child: _buildCameraPanel()),
            ],
          ),
        ),

        _buildCompanyTopBar(topPad),
        _buildBottomControls(bottomPad),
      ],
    );
  }

  Widget _buildSelectedShadeCardPanel() {
    final card = widget.selectedShadeCard!;
    final imageUrl = card.imageUrl ?? '';
    final cardName = (card.name?.toString() ?? '').trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextWidget(
                text: cardName.isEmpty ? 'Shade Card' : cardName,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
                textStyle: BaseTextStyle.text600.copyWith(fontSize: 12.sp, color: colorWhite, height: 1.35),
              ),
              heightBox(8.h),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(10.r)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 10.0,
                      constrained: false,
                      boundaryMargin: EdgeInsets.zero,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: availableWidth),
                        child: _buildShadeCardImage(imageUrl: imageUrl, width: availableWidth),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShadeCardImage({required String imageUrl, required double width}) {
    if (imageUrl.isEmpty) {
      return Image.asset(PNGImages.imgThread1, width: width, fit: BoxFit.fitWidth, alignment: Alignment.topCenter);
    }

    return AppCachedImage(
      imageUrl: imageUrl,
      // Load original high-resolution image to avoid server-side cropping and compression
      useResize: false,
      width: width,
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
      // Disable memory downscaling to maintain full detail for the 2.8x zoom
      useMemCache: false,
      fadeInDuration: Duration.zero,
      placeholderColor: colorF2F2F2,
      // Ensure high-quality rendering during scaling
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.high,
      ),
      errorWidget: Image.asset(
        PNGImages.imgThread1,
        width: width,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
      ),
    );
  }

  Widget _buildCameraPanel() {
    if (_pickedImagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 10.0,
          child: Image.file(
            File(_pickedImagePath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    if (_permissionDenied) return _buildPermissionDenied();
    if (!_isCameraInitialized || _controller == null) {
      return Center(
        child: AppLoader.small(accentColor: colorE7E3DA, trackColor: colorE7E3DA.withValues(alpha: 0.3)),
      );
    }
    final previewSize = _controller!.value.previewSize;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: previewSize?.height ?? 9,
              height: previewSize?.width ?? 16,
              child: CameraPreview(_controller!),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyTopBar(double topPad) {
    return Positioned(
      top: topPad + 8.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        children: [
          _pill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: colorWhite, size: 18.sp),
              ),
            ),
          ),
          const Spacer(),
          _pill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: TextWidget(
                text: 'Thread Match',
                textStyle: BaseTextStyle.text600.copyWith(color: colorWhite, fontSize: 13.sp),
              ),
            ),
          ),
          const Spacer(),
          if (_pickedImagePath == null) ...[
            _pill(
              active: _isTorchOn,
              child: GestureDetector(
                onTap: _toggleTorch,
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(
                    _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                    color: _isTorchOn ? colorE7E3DA : colorWhite,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ] else
            widthBox(40.w),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PRODUCT-DETAIL MODE — original full-screen layout (unchanged)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProductLayout() {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final windowSize = MediaQuery.of(context).size.width * 0.72;

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildCamera(),
        _buildVignette(windowSize),
        Center(child: _buildCropWindow(windowSize)),
        _buildTopBar(topPad),
        _buildBottomControls(bottomPad),
      ],
    );
  }

  Widget _buildCamera() {
    if (_pickedImagePath != null) {
      return SizedBox.expand(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 10.0,
          child: Image.file(
            File(_pickedImagePath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    if (_permissionDenied) return _buildPermissionDenied();
    if (!_isCameraInitialized || _controller == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: AppLoader.small(accentColor: colorE7E3DA, trackColor: Color(0x4DE7E3DA)),
        ),
      );
    }
    final previewSize = _controller!.value.previewSize;
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize?.height ?? 9,
            height: previewSize?.width ?? 16,
            child: CameraPreview(_controller!),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied() {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.no_photography_outlined, color: Colors.white38, size: 52.sp),
              SizedBox(height: 20.h),
              TextWidget(
                text: 'Camera Access Required',
                textAlign: TextAlign.center,
                textStyle: BaseTextStyle.text600.copyWith(color: colorWhite, fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              TextWidget(
                text: 'Allow camera access to match thread colours against real fabric.',
                textAlign: TextAlign.center,
                textStyle: BaseTextStyle.text400.copyWith(color: Colors.white54, fontSize: 13.sp, height: 1.5),
              ),
              SizedBox(height: 28.h),
              GestureDetector(
                onTap: openAppSettings,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  decoration: BoxDecoration(color: colorE7E3DA, borderRadius: BorderRadius.circular(14.r)),
                  child: TextWidget(
                    text: 'Open Settings',
                    textStyle: BaseTextStyle.text600.copyWith(color: color09064A, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVignette(double windowSize) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _VignettePainter(windowSize: windowSize),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildCropWindow(double windowSize) {
    return Container(
      width: windowSize,
      height: 100,
      child: ClipRect(child: InteractiveViewer(minScale: 1.0, maxScale: 10.0, child: _buildThreadImage(windowSize))),
    );
  }

  /// Product-detail crop: 2.8× zoom into the centre of the thread image.
  Widget _buildThreadImage(double size) {
    const double zoomFactor = 2.8;
    final double renderSize = size * zoomFactor;
    Widget img;
    if (widget.productImageUrl.isEmpty) {
      img = Image.asset(
        PNGImages.imgThread1,
        width: renderSize,
        height: renderSize,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    } else {
      img = SizedBox(
        width: renderSize,
        height: renderSize,
        child: ProductDetailImageLoader(
          imageUrl: widget.productImageUrl,
          mode: ProductDetailImageMode.arMatch,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
      );
    }
    return ClipRect(
      child: OverflowBox(maxWidth: renderSize, maxHeight: renderSize, alignment: Alignment.center, child: img),
    );
  }

  Widget _buildTopBar(double topPad) {
    return Positioned(
      top: topPad + 8.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        children: [
          _pill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: colorWhite, size: 18.sp),
              ),
            ),
          ),
          const Spacer(),
          _pill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: TextWidget(
                text: 'Thread Match',
                textStyle: BaseTextStyle.text600.copyWith(color: colorWhite, fontSize: 13.sp),
              ),
            ),
          ),
          const Spacer(),
          if (_pickedImagePath == null) ...[
            _pill(
              active: _isTorchOn,
              child: GestureDetector(
                onTap: _toggleTorch,
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(
                    _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                    color: _isTorchOn ? colorE7E3DA : colorWhite,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ] else
            widthBox(40.w),
        ],
      ),
    );
  }

  Widget _buildBottomControls(double bottomPad) {
    return Positioned(
      bottom: bottomPad + 20.h,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomHint(0),
          heightBox(24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gallery Button
              GestureDetector(
                onTap: _pickFromGallery,
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
                  child: Icon(Icons.photo_library_outlined, color: colorWhite, size: 24.sp),
                ),
              ),
              widthBox(28.w),

              // Main Shutter / Reset Button
              GestureDetector(
                onTap: _pickedImagePath != null ? () => setState(() => _pickedImagePath = null) : _takePhoto,
                child: Container(
                  width: 76.w,
                  height: 76.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.w),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      _pickedImagePath != null ? Icons.close_rounded : Icons.camera_alt_rounded,
                      color: color09064A,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),

              // Symmetry spacer
              widthBox(28.w),
              SizedBox(width: 52.w),
            ],
          ),
          heightBox(12.h),
        ],
      ),
    );
  }

  Widget _buildBottomHint(double bottomPad) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, color: colorE7E3DA, size: 13.sp),
            SizedBox(width: 6.w),
            TextWidget(
              text: _pickedImagePath != null
                  ? 'Comparing with selected photo'
                  : 'Point camera at fabric to match thread colour',
              textStyle: BaseTextStyle.text400.copyWith(color: Colors.white70, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _pill({required Widget child, bool active = false}) {
    return Container(
      decoration: BoxDecoration(
        color: active ? colorE7E3DA.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: child,
    );
  }
}

// ── Painters ──────────────────────────────────────────────────────────────────

class _VignettePainter extends CustomPainter {
  const _VignettePainter({required this.windowSize});

  final double windowSize;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = windowSize / 2;
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()..addRect(Rect.fromLTRB(cx - half, cy - half, cx + half, cy + half));
    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, hole),
      Paint()..color = Colors.black.withValues(alpha: 0),
    );
  }

  @override
  bool shouldRepaint(_VignettePainter old) => old.windowSize != windowSize;
}
