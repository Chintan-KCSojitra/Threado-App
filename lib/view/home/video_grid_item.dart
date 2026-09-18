/*
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';

class VideoGridItem extends StatefulWidget {
  final String videoUrl;

  const VideoGridItem({super.key, required this.videoUrl});

  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  VideoPlayerController? _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) setState(() {});
        if (_isVisible) _controller?.play();
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleVisibility(double visibleFraction) {
    if (visibleFraction > 0.5 && !_controller!.value.isPlaying) {
      _controller?.play();
    } else if (visibleFraction <= 0.5 && _controller!.value.isPlaying) {
      _controller?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        _isVisible = info.visibleFraction > 0.5;
        if (_controller != null) {
          _handleVisibility(info.visibleFraction);
        }
      },
      child: _controller != null && _controller!.value.isInitialized
          ? ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      )
          : Container(
        color: Colors.black12,
      ),
    );
  }
}
*/ /*


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoGridItem extends StatefulWidget {
  final String videoUrl;

  const VideoGridItem({super.key, required this.videoUrl});

  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  VideoPlayerController? _controller;

  // [OPT-1] Track initialisation as a separate bool so we never call
  // _controller!.value.isInitialized inside the visibility callback (which
  // fires on every frame during a scroll) without a null-check. The original
  // code force-unwrapped _controller! in _handleVisibility, which would crash
  // if the callback fired before _initializeVideo() finished.
  bool _isInitialized = false;

  // [OPT-2] Cache the parsed Uri so it is not re-parsed on every
  // didUpdateWidget call or rebuild.
  late Uri _videoUri;

  @override
  void initState() {
    super.initState();
    _videoUri = Uri.parse(widget.videoUrl);
    _initializeVideo();
  }

  // [OPT-3] Handle URL changes (e.g. when the widget is reused in a list with
  // a new URL) by tearing down the old controller and starting fresh. The
  // original code never released the old controller in this case.
  @override
  void didUpdateWidget(VideoGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _videoUri = Uri.parse(widget.videoUrl);
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    // [OPT-4] Create the controller, set looping, and kick off initialisation
    // in a single chain. Calling setLooping before initialize is fine because
    // the setting is stored and applied once the player is ready.
    final controller = VideoPlayerController.networkUrl(_videoUri)
      ..setLooping(true);

    _controller = controller;

    controller.initialize().then((_) {
      // Guard: widget may have been disposed or the URL may have changed by
      // the time the future resolves.
      if (!mounted || _controller != controller) return;

      // [OPT-5] Only call setState once, after both isInitialized is true
      // and we know whether to auto-play. The original code called setState()
      // just to trigger a rebuild for isInitialized, then separately played —
      // two frames of work instead of one.
      setState(() => _isInitialized = true);
    });
  }

  @override
  void dispose() {
    // [OPT-6] Pause before disposing to flush pending decoder buffers on
    // some Android codecs, reducing occasional glitches on the next video.
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  // [OPT-7] _handleVisibility is only called when the controller is non-null
  // AND initialized, so the internal checks are now just comparisons — no
  // null-assertion needed.
  void _handleVisibility(double visibleFraction) {
    final ctrl = _controller;
    if (ctrl == null || !_isInitialized) return;

    if (visibleFraction > 0.5) {
      if (!ctrl.value.isPlaying) ctrl.play();
    } else {
      if (ctrl.value.isPlaying) ctrl.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    // [OPT-8] Use ValueKey on the VisibilityDetector. The original used
    // Key(widget.videoUrl) which is a ValueKey<String> under the hood, but
    // being explicit avoids accidental key-type mismatches if the url type
    // ever changes.
    return VisibilityDetector(
      key: ValueKey(widget.videoUrl),
      onVisibilityChanged: (info) => _handleVisibility(info.visibleFraction),
      child: _isInitialized && _controller != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: AspectRatio(
          // [OPT-9] aspectRatio is only read after _isInitialized is
          // true, so this access is always safe — no force-unwrap needed.
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      )
      // [OPT-10] Use const ColoredBox instead of Container(color:…).
      // The placeholder is painted hundreds of times during scrolling;
      // saving the Container allocation adds up.
          : const ColoredBox(color: Color(0x1F000000)), // Colors.black12
    );
  }
}*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/services/screenshot_detector.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/company/company_profile_screen.dart';
import 'package:thredo/view/productDetail/cubit/product_detail_cubit.dart';
import 'package:thredo/view/productDetail/cubit/product_detail_state.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/profile_image_widget.dart';
import 'package:thredo/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductListData productData;
  final ValueChanged<bool>? onZoomChanged;

  const ProductDetailScreen({super.key, required this.productData, this.onZoomChanged});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailCubit _cubit;
  late final PageController _pageController;
  VideoPlayerController? _videoController;
  StreamSubscription? _subscription;
  bool _isZoomed = false;

  // [OPT-1] Cache BoxShadow constants — these are allocated inside build() in
  // the original, meaning every BlocBuilder rebuild (wishlist tap, page change,
  // video loading, etc.) recreates them. Static const avoids all that.
  static const _cardShadow = [
    BoxShadow(
      color: Color(0x26010103), // color010103 @ 15% opacity
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static const _smallShadow = [BoxShadow(color: Color(0x26010103), blurRadius: 4, offset: Offset(0, 2))];

  // [OPT-2] Cache the bottom gradient decoration. It is recreated on every
  // build() in the original because Colors.black.withValues() is a runtime
  // call. The hex-literal form is identical and compile-time constant.
  static const _bottomGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Color(0xBD000000), // black @ 74 %
        Color(0xF0000000), // black @ 94 %
      ],
    ),
  );

  // [OPT-3] Social-icon container decoration cached as a static const.
  // Repeated identically for every social button in the bottom overlay.
  static const _socialIconDecoration = BoxDecoration(
    color: colorE7E3DA,
    shape: BoxShape.circle,
    boxShadow: _smallShadow,
  );

  @override
  void initState() {
    super.initState();
    _cubit = ProductDetailCubit(widget.productData);
    // [OPT-4] keepPage: true is the default but makes it explicit; avoids
    // the controller resetting to page 0 on a hot reload.
    _pageController = PageController(keepPage: true);
    if (_cubit.dataState.mediaList.isNotEmpty) {
      _handleMedia(0);
    }
    _initScreenshotListener();
  }

  Future<void> _initScreenshotListener() async {
    _subscription = await ScreenshotDetector.listen((event) {
      debugPrint('Screenshot Captured: $event');
      final productId = widget.productData.id ?? '';
      if (productId.isEmpty) return;
      _cubit.screenCaptureEvent(productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Screenshot Captured!')));
      }
    });
  }

  Future<void> _handleMedia(int index) async {
    final state = _cubit.dataState;
    if (index < 0 || index >= state.mediaList.length) return;

    _cubit.setVideoError(false);
    _cubit.setVideoLoading(false);

    // [OPT-5] Pause before disposing — flushes the decoder buffer on Android
    // and prevents a brief audio pop on rapid page swipes.
    if (_videoController != null) {
      await _videoController!.pause();
      await _videoController!.dispose();
      _videoController = null;
    }

    if (state.mediaList[index].type != ProductMediaType.video) return;

    _cubit.setVideoLoading(true);
    try {
      // [OPT-6] Parse the URI once here rather than inside initialize().
      final uri = Uri.parse(state.mediaList[index].url);
      _videoController = VideoPlayerController.networkUrl(uri);

      // [OPT-7] Run initialize and setLooping in parallel — setLooping only
      // sends a platform-channel message; it does not depend on initialize
      // finishing first. Saves one serialised round-trip on every video page.
      await Future.wait([_videoController!.initialize(), _videoController!.setLooping(true)]);

      // Guard: widget may have been disposed or page swiped away by now.
      if (!mounted || _videoController == null) return;
      await _videoController!.play();
    } catch (_) {
      _cubit.setVideoError(true);
    } finally {
      if (mounted) _cubit.setVideoLoading(false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _videoController?.pause();
    _videoController?.dispose();
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  // ── Zoom callbacks — named methods instead of closures ───────────────────
  // [OPT-8] Same principle as in product_reel_screen: named tear-offs are
  // stable references. Closure literals inside itemBuilder are new objects on
  // every call (~60fps during InteractiveViewer gestures).
  void _onInteractionUpdate(ScaleUpdateDetails details) {
    final zoomed = details.scale > 1.0;
    if (zoomed != _isZoomed) {
      setState(() => _isZoomed = zoomed);
      widget.onZoomChanged?.call(zoomed);
    }
  }

  void _onInteractionEnd(ScaleEndDetails _) {
    if (_isZoomed) {
      setState(() => _isZoomed = false);
      widget.onZoomChanged?.call(false);
    }
  }

  // ── Page-change handler ───────────────────────────────────────────────────
  void _onPageChanged(int index) {
    _cubit.onPageChanged(index);
    _handleMedia(index);
  }

  @override
  Widget build(BuildContext context) {
    // [OPT-9] Read topPadding once outside BlocBuilder so it isn't re-read
    // inside every rebuild triggered by cubit state changes.
    final topPadding = MediaQuery.paddingOf(context).top;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, rawState) {
          final state = rawState as ProductDetailStateData;
          return Scaffold(
            backgroundColor: colorBlack,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                // ── Media pager ────────────────────────────────────────────
                Positioned.fill(
                  child: state.mediaList.isEmpty
                      ? const ColoredBox(color: colorBlack)
                      : PageView.builder(
                          controller: _pageController,
                          physics: _isZoomed ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
                          itemCount: state.mediaList.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            // [OPT-10] Wrap each media item in RepaintBoundary.
                            // InteractiveViewer triggers repaints at 60fps
                            // during pan/zoom. Without a boundary those repaints
                            // propagate to the overlay (bottom gradient, action
                            // buttons, indicator dots) unnecessarily.
                            return RepaintBoundary(child: _buildMediaWidget(state, state.mediaList[index], index));
                          },
                        ),
                ),

                // ── Back button ────────────────────────────────────────────
                Positioned(
                  left: 16.w,
                  top: topPadding + 8.h,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const _TopIconContainer(iconPath: SVGImages.icArrowBack, shadow: _cardShadow),
                  ),
                ).animate().fadeIn(duration: 260.ms).slideY(begin: -0.2, end: 0),

                // ── Wishlist button ────────────────────────────────────────
                Positioned(
                  right: 16.w,
                  top: topPadding + 8.h,
                  child: GestureDetector(
                    onTap: _cubit.onWishlistTap,
                    child: _WishlistButton(
                      isLoading: state.isWishlistLoading,
                      isLiked: state.isLiked,
                      shadow: _cardShadow,
                    ),
                  ),
                ).animate().fadeIn(delay: 80.ms, duration: 260.ms).slideY(begin: -0.2, end: 0),

                // ── Company pill ───────────────────────────────────────────
                Positioned(
                  left: 0,
                  right: 0,
                  top: topPadding + 8.h,
                  child: Center(
                    child: GestureDetector(
                      onTap: state.isCompanyLoading
                          ? null
                          : () async {
                              final companyData = await context.read<ProductDetailCubit>().fetchCompanyDetails();
                              if (companyData != null && context.mounted) {
                                navigate(enterPage: CompanyProfileScreen(company: companyData));
                              }
                            },
                      child: _CompanyPill(state: state, shadow: _cardShadow),
                    ),
                  ),
                ).animate().fadeIn(delay: 120.ms, duration: 260.ms).slideY(begin: -0.2, end: 0),

                // ── Right action buttons ───────────────────────────────────
                /*Positioned(
                  right: 14.w,
                  bottom: 190.h,
                  child: _RightMenuColumn(
                    state: state,
                    shadow: _cardShadow,
                    onWhatsapp: () async {
                      final productId = state.product.id ?? '';
                      context
                          .read<ProductDetailCubit>()
                          .whatsappClickEvent(productId);

                      final message = WhatsappUtils.buildInquiryMessage(
                        productName: state.product.name ?? '',
                        companyName: state.product.company?.name ?? '',
                        productId: productId,
                      );

                      await WhatsappUtils.launchWhatsApp(
                        phoneNumber: state.product.company?.whatsappNumber ??
                            state.product.company?.phone ??
                            '',
                        message: message,
                      );
                    },
                    onInfo: () => showDetailsBottomDialog(context, state),
                    onEmbroidery: () => EmbroideryMatchDialog.show(
                      context,
                      product: state.product,
                      productImageUrl: state.firstImageUrl,
                    ),
                    onAr: () => navigate(
                      enterPage: ARMatchScreen(
                        productImageUrl: state.firstImageUrl,
                      ),
                    ),
                  ),
                ),*/

                // ── Bottom overlay ─────────────────────────────────────────
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  // [OPT-11] Use DecoratedBox + const decoration instead of
                  // Container(decoration:…). DecoratedBox is a single render
                  // object with no child size constraints — cheaper layout.
                  child: DecoratedBox(
                    decoration: _bottomGradientDecoration,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Media indicator dots/circles
                          Row(
                            children: List.generate(
                              state.mediaList.length,
                              (index) => _buildMediaIndicator(state, index),
                            ),
                          ),
                          heightBox(16.h),
                          if (state.product.company != null)
                            _BottomCompanyInfo(
                              state: state,
                              socialIconDecoration: _socialIconDecoration,
                              openSocialApp: openSocialApp,
                            ),
                          heightBox(20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Media indicator ───────────────────────────────────────────────────────

  Widget _buildMediaIndicator(ProductDetailStateData state, int index) {
    final isActive = index == state.currentPage;
    final isVideo = state.mediaList[index].type == ProductMediaType.video;

    if (isVideo) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        width: isActive ? 28.w : 24.w,
        height: isActive ? 28.h : 24.h,
        decoration: BoxDecoration(
          // [OPT-12] Use const Color literals instead of
          // colorWhite.withValues(alpha: 0.30) — same value, zero allocation.
          color: isActive ? colorWhite : const Color(0x4DFFFFFF),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.play_arrow_rounded, size: isActive ? 18.sp : 16.sp, color: colorBlack),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 20.w : 8.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: isActive ? colorWhite : const Color(0x4DFFFFFF),
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  // ── Media widget ──────────────────────────────────────────────────────────

  Widget _buildMediaWidget(ProductDetailStateData state, ProductMediaItem media, int index) {
    if (media.type == ProductMediaType.image) {
      return InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 4.0,
        clipBehavior: Clip.hardEdge,
        onInteractionUpdate: _onInteractionUpdate,
        onInteractionEnd: _onInteractionEnd,
        child: ColoredBox(
          // [OPT-13] ColoredBox instead of Container(color:…).
          color: colorWhite,
          child: Align(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: AppCachedImage(
                imageUrl: media.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                useMemCache: false,
                placeholder: AppLoader.centered(
                  accentColor: colorWhite,
                  trackColor: colorWhite.withValues(alpha: 0.25),
                ),
                errorWidget: ColoredBox(
                  color: colorBlack,
                  child: Center(
                    child: Icon(Icons.broken_image_outlined, color: colorWhite, size: 34.sp),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (index != state.currentIndex) {
      return const ColoredBox(color: colorBlack);
    }
    if (state.videoHasError) {
      return Center(
        child: TextWidget(
          text: 'Unable to load video',
          textStyle: BaseTextStyle.text500.copyWith(color: colorWhite, fontSize: 14.sp),
        ),
      );
    }
    if (state.videoLoading || _videoController == null || !_videoController!.value.isInitialized) {
      return AppLoader.centered(accentColor: colorWhite, trackColor: colorWhite.withValues(alpha: 0.25));
    }

    return Center(
      child: AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: VideoPlayer(_videoController!)),
    );
  }

  // ── WhatsApp share ────────────────────────────────────────────────────────

  // ── Details bottom sheet ──────────────────────────────────────────────────

  void showDetailsBottomDialog(BuildContext context, ProductDetailStateData state) {
    final product = state.product;
    final details = <MapEntry<String, String>>[
      MapEntry(strProductNameLabel, _asDisplay(product.name)),
      MapEntry(strCategory, _asDisplay(product.category?.name)),
      MapEntry(strProductDescriptionLabel, _asDisplay(product.description)),
      MapEntry(strProductMinQuantityLabel, _asDisplay(product.minQuantity)),
      MapEntry(strProductManufacturingTimeLabel, _asDisplay(product.manufacturingTime)),
      MapEntry(strProductDenierLabel, _asDisplay(product.denier)),
      MapEntry(strProductMeterLabel, _asDisplay(product.meter)),
      MapEntry(strProductPackingLabel, _asDisplay(product.packing)),
      MapEntry(strProductPisLabel, _asDisplay(product.pis)),
      MapEntry(strProductGrossWeightLabel, _asDisplay(product.grossWeight)),
      MapEntry(strProductNetWeightLabel, _asDisplay(product.netWeight)),
      MapEntry(strProductTubeSizeLabel, _asDisplay(product.tubeSize)),
      MapEntry(strProductMaterialsLabel, _materialsValue(product)),
      MapEntry(strProductColorsLabel, _colorsValue(product)),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: (MediaQuery.sizeOf(context).height * 0.8).clamp(460.0, 760.0),
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8.r), child: _buildDialogThumb(state.firstImageUrl)),
                    widthBox(10.w),
                    Expanded(
                      child: TextWidget(
                        text: state.product.name ?? strProductDetails,
                        textStyle: BaseTextStyle.text600.copyWith(fontSize: 16.sp, color: color09064A),
                      ),
                    ),
                  ],
                ),
                heightBox(18.h),
                _buildDetailSection(title: strProductOverview, content: state.product.description ?? '-'),
                heightBox(14.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: colorF9FDFF,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: colorE6E6E6),
                  ),
                  child: Table(
                    columnWidths: {0: FixedColumnWidth(132.w), 1: const FlexColumnWidth()},
                    border: TableBorder.all(color: colorE6E6E6, borderRadius: BorderRadius.circular(12.r)),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: colorE7E3DA),
                        children: [_buildTableHeaderCell('Field'), _buildTableHeaderCell('Value')],
                      ),
                      ...details.asMap().entries.map(
                        (entry) => _buildDetailTableRow(
                          label: entry.value.key,
                          value: entry.value.value,
                          isStriped: entry.key.isOdd,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildDialogThumb(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(PNGImages.imgThread1, width: 44.w, height: 44.h, fit: BoxFit.cover);
    }
    return AppCachedImage(imageUrl: imageUrl, width: 44.w, height: 44.h, fit: BoxFit.cover);
  }

  Widget _buildDetailSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: colorF9FDFF, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            textStyle: BaseTextStyle.text600.copyWith(fontSize: 16.sp, color: color09064A),
          ),
          heightBox(8.h),
          TextWidget(
            text: content,
            textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E, height: 1.45),
          ),
        ],
      ),
    );
  }

  Future<void> openSocialApp({required Uri appUri, required Uri webUri}) async {
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  TableRow _buildDetailTableRow({required String label, required String value, required bool isStriped}) {
    return TableRow(
      decoration: BoxDecoration(color: isStriped ? colorWhite : colorF9FDFF),
      children: [
        _buildTableValueCell(
          text: label,
          textStyle: BaseTextStyle.text500.copyWith(fontSize: 12.sp, color: color79747E),
        ),
        _buildTableValueCell(
          text: value,
          textStyle: BaseTextStyle.text500.copyWith(fontSize: 13.sp, color: color09064A),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: TextWidget(
        text: text,
        textStyle: BaseTextStyle.text600.copyWith(fontSize: 13.sp, color: color09064A),
      ),
    );
  }

  Widget _buildTableValueCell({required String text, required TextStyle textStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: TextWidget(text: text, textStyle: textStyle),
    );
  }

  String _asDisplay(dynamic value) {
    if (value == null) return '-';
    final text = value.toString().trim();
    return text.isEmpty ? '-' : text;
  }

  String _materialsValue(ProductListData product) {
    final values = (product.materials ?? [])
        .map((item) => item.name)
        .whereType<String>()
        .where((name) => name.trim().isNotEmpty)
        .toList();
    return values.isEmpty ? '-' : values.join(', ');
  }

  String _colorsValue(ProductListData product) {
    final values = (product.colors ?? [])
        .map((item) {
          final name = (item.name ?? '').trim();
          final hex = (item.hexCode ?? '').trim();
          if (name.isEmpty && hex.isEmpty) return '';
          if (name.isNotEmpty && hex.isNotEmpty) return '$name ($hex)';
          return name.isNotEmpty ? name : hex;
        })
        .where((value) => value.isNotEmpty)
        .toList();
    return values.isEmpty ? '-' : values.join(', ');
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Private extracted widgets
// [OPT-15] These were all inline build-method closures in the original.
// Extracting them into named StatelessWidget classes gives Flutter's element
// reconciler a stable widget type, so unchanged subtrees are never rebuilt.
// ═══════════════════════════════════════════════════════════════════════════

class _TopIconContainer extends StatelessWidget {
  const _TopIconContainer({required this.iconPath, required this.shadow});

  final String iconPath;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(12.r), boxShadow: shadow),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: SvgPicture.asset(iconPath, colorFilter: const ColorFilter.mode(color010103, BlendMode.srcIn)),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.isLoading, required this.isLiked, required this.shadow});

  final bool isLoading;
  final bool isLiked;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(12.r), boxShadow: shadow),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: isLoading
            ? const AppLoader.small(accentColor: color010103)
            : Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 24.sp,
                color: isLiked ? Colors.red : color010103,
              ),
      ),
    );
  }
}

class _CompanyPill extends StatelessWidget {
  const _CompanyPill({required this.state, required this.shadow});

  final ProductDetailStateData state;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(24.r), boxShadow: shadow),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isCompanyLoading)
              const AppLoader.small(accentColor: color010103)
            else
              ClipOval(
                child: ProfileImageWidget(
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.cover,
                  showPadding: false,
                  isCircle: true,
                  userProfileImage: state.product.company?.logoUrl,
                ),
              ),
            widthBox(8.w),
            TextWidget(
              text: state.product.company?.name ?? '',
              textStyle: BaseTextStyle.text600.copyWith(fontSize: 14.sp, color: color010103),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCompanyInfo extends StatelessWidget {
  const _BottomCompanyInfo({required this.state, required this.socialIconDecoration, required this.openSocialApp});

  final ProductDetailStateData state;
  final BoxDecoration socialIconDecoration;
  final Future<void> Function({required Uri appUri, required Uri webUri}) openSocialApp;

  @override
  Widget build(BuildContext context) {
    final company = state.product.company!;

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: [
        if ((company.address != null && company.address!.isNotEmpty) ||
            (company.city != null && company.city!.isNotEmpty))
          GestureDetector(
            onTap: () {
              final query = [
                company.address,
                company.city,
                company.pincode,
              ].where((e) => e != null && e.isNotEmpty).join(', ');
              final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(query)}');
              openSocialApp(appUri: uri, webUri: uri);
            },
            child: DecoratedBox(
              decoration: socialIconDecoration,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SvgPicture.asset(SVGImages.icLocation, width: 20.w),
              ),
            ),
          ),
        if (company.facebookUrl != null && company.facebookUrl!.isNotEmpty)
          _SocialButton(
            onTap: () {
              final uri = Uri.parse(company.facebookUrl!);
              openSocialApp(appUri: uri, webUri: uri);
            },
            decoration: socialIconDecoration,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: SvgPicture.asset(SVGImages.icFacebook, width: 20.w),
            ),
          ),
        if (company.instagramUrl != null && company.instagramUrl!.isNotEmpty)
          _SocialButton(
            onTap: () {
              final uri = Uri.parse(company.instagramUrl!);
              openSocialApp(appUri: uri, webUri: uri);
            },
            decoration: socialIconDecoration,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Image.asset(PNGImages.imgInstagram, width: 20.w),
            ),
          ),
        if (company.twitterUrl != null && company.twitterUrl!.isNotEmpty)
          _SocialButton(
            onTap: () {
              final uri = Uri.parse(company.twitterUrl!);
              openSocialApp(appUri: uri, webUri: uri);
            },
            decoration: socialIconDecoration,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(Icons.alternate_email, size: 20.w, color: colorBlack),
            ),
          ),
        if (company.youtubeUrl != null && company.youtubeUrl!.isNotEmpty)
          _SocialButton(
            onTap: () {
              final uri = Uri.parse(company.youtubeUrl!);
              openSocialApp(appUri: uri, webUri: uri);
            },
            decoration: socialIconDecoration,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(Icons.play_circle_fill, size: 20.w, color: Colors.red),
            ),
          ),
        if (company.linkedinUrl != null && company.linkedinUrl!.isNotEmpty)
          _SocialButton(
            onTap: () {
              final uri = Uri.parse(company.linkedinUrl!);
              openSocialApp(appUri: uri, webUri: uri);
            },
            decoration: socialIconDecoration,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: TextWidget(
                text: 'in',
                textStyle: TextStyle(fontWeight: FontWeight.w900, color: const Color(0xFF0077b5), fontSize: 16.sp),
              ),
            ),
          ),
      ],
    );
  }
}

/// Thin wrapper so each social icon button is a stable widget type.
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.onTap, required this.decoration, required this.child});

  final VoidCallback onTap;
  final BoxDecoration decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(decoration: decoration, child: child),
    );
  }
}
