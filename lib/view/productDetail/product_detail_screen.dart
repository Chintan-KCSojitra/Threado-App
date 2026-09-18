import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
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
import 'package:thredo/view/productDetail/widgets/product_detail_image_loader.dart';
import 'package:thredo/view/productDetail/widgets/product_detail_zoomable_image.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/profile_image_widget.dart';
import 'package:thredo/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../utils/helper.dart';
import '../../utils/whatsapp_utils.dart';
import 'ar_match_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductListData productData;

  /// Called with [true] when the user zooms in (scale > 1) and [false] when
  /// they return to normal scale. Use this to disable parent scroll views.
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
  final TransformationController _imageTransformController = TransformationController();

  /// Whether the user is currently zoomed in on an image (scale > 1).
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _cubit = ProductDetailCubit(widget.productData);
    _pageController = PageController(initialPage: 0);
    if (_cubit.dataState.mediaList.isNotEmpty) {
      _handleMedia(0);
    }
    _prefetchProductImages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ProductDetailImageLoader.precacheInContext(context, _cubit.dataState.firstImageUrl);
    });
    _initScreenshotListener();
  }

  void _prefetchProductImages() {
    for (final media in _cubit.dataState.mediaList) {
      if (media.type == ProductMediaType.image) {
        ProductDetailImageLoader.warmCache(media.url);
      }
    }
  }

  Future<void> _initScreenshotListener() async {
    _subscription = await ScreenshotDetector.listen((event) {
      debugPrint('Screenshot Captured: $event');
      final productId = widget.productData.id ?? '';
      if (productId.isEmpty) return;
      _logProductEvent(eventType: 'product_screen_shot', productId: productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Screenshot Captured!')));
      }
    });
  }

  /// POST /api/v1/user/events/
  Future<void> _logProductEvent({required String eventType, required String productId}) async {
    if (productId.isEmpty) return;
    try {
      await DioHelper.postData(
        url: ApiConfig.logEventEP,
        isHeader: true,
        data: {'event_type': eventType, 'product_id': productId, 'platform': Platform.isIOS ? 'ios' : 'android'},
      );
    } catch (_) {
      // Ignore analytics errors
    }
  }

  Future<void> _handleMedia(int index) async {
    final state = _cubit.dataState;
    if (index < 0 || index >= state.mediaList.length) return;

    _cubit.setVideoError(false);
    _cubit.setVideoLoading(false);

    if (_videoController != null) {
      await _videoController!.pause();
      await _videoController!.dispose();
      _videoController = null;
    }

    if (state.mediaList[index].type != ProductMediaType.video) return;

    _cubit.setVideoLoading(true);
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(state.mediaList[index].url));
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.play();
    } catch (_) {
      _cubit.setVideoError(true);
    } finally {
      if (mounted) {
        _cubit.setVideoLoading(false);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _videoController?.dispose();
    _imageTransformController.dispose();
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _resetImageZoom() {
    _imageTransformController.value = Matrix4.identity();
    if (_isZoomed) {
      setState(() => _isZoomed = false);
      widget.onZoomChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

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
                Positioned.fill(
                  child: state.mediaList.isEmpty
                      ? Container(color: colorBlack)
                      : PageView.builder(
                          controller: _pageController,
                          // Lock horizontal swiping while image is zoomed in
                          // so the user can pan freely without changing pages.
                          physics: _isZoomed ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
                          itemCount: state.mediaList.length,
                          onPageChanged: (index) {
                            _resetImageZoom();
                            _cubit.onPageChanged(index);
                            _handleMedia(index);
                            final media = state.mediaList[index];
                            if (media.type == ProductMediaType.image) {
                              ProductDetailImageLoader.warmCache(media.url);
                              ProductDetailImageLoader.precacheInContext(context, media.url);
                            }
                          },
                          itemBuilder: (context, index) {
                            return _buildMediaWidget(state, state.mediaList[index], index);
                          },
                        ),
                ),
                Positioned(
                  left: 16.w,
                  top: topPadding + 8.h,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _topIconContainer(SVGImages.icArrowBack),
                  ),
                ).animate().fadeIn(duration: 260.ms).slideY(begin: -0.2, end: 0),
                Positioned(
                  right: 16.w,
                  top: topPadding + 8.h,
                  child: GestureDetector(
                    onTap: _cubit.onWishlistTap,
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: color010103.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: state.isWishlistLoading
                          ? const AppLoader.small(accentColor: color010103)
                          : Icon(
                              state.isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 24.sp,
                              color: state.isLiked ? Colors.red : color010103,
                            ),
                    ),
                  ),
                ).animate().fadeIn(delay: 80.ms, duration: 260.ms).slideY(begin: -0.2, end: 0),
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
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: color010103.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
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
                    ),
                  ),
                ).animate().fadeIn(delay: 120.ms, duration: 260.ms).slideY(begin: -0.2, end: 0),
                Positioned(
                  right: 14.w,
                  bottom: 190.h,
                  child: Column(
                    children: [
                      _buildRightMenuButton(
                        svgPath: SVGImages.icWhatsapp,
                        onTap: () => _handleDirectWhatsappChat(state, context),
                      ),
                      heightBox(16.h),
                      _buildRightMenuButton(
                        iconData: Icons.info_outline_rounded,
                        onTap: () => showDetailsBottomDialog(context, state),
                      ),
                      /*Visibility(visible:false,child: heightBox(16.h)),
                      Visibility(
                        visible: false,
                        child: _buildRightMenuButton(
                          iconData: Icons.image_search_rounded,
                          onTap: () => EmbroideryMatchDialog.show(
                            context,
                            product: state.product,
                            productImageUrl: state.firstImageUrl,
                          ),
                        ),
                      ),*/
                      heightBox(16.h),
                      _buildRightMenuButton(
                        iconData: Icons.view_in_ar_rounded,
                        onTap: () {
                          navigate(enterPage: ARMatchScreen(productImageUrl: state.firstImageUrl));
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.74),
                          Colors.black.withValues(alpha: 0.94),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: List.generate(state.mediaList.length, (index) {
                            final isActive = index == state.currentPage;
                            final isVideo = state.mediaList[index].type == ProductMediaType.video;
                            if (isVideo) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                width: isActive ? 28.w : 24.w,
                                height: isActive ? 28.h : 24.h,
                                decoration: BoxDecoration(
                                  color: isActive ? colorWhite : colorWhite.withValues(alpha: 0.30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: isActive ? 18.sp : 16.sp,
                                  color: colorBlack,
                                ),
                              );
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: isActive ? 20.w : 8.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: isActive ? colorWhite : colorWhite.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            );
                          }),
                        ),
                        heightBox(16.h),
                        if (state.product.company != null)
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: [
                              if ((state.product.company?.address != null &&
                                      state.product.company!.address!.isNotEmpty) ||
                                  (state.product.company?.city != null && state.product.company!.city!.isNotEmpty))
                                GestureDetector(
                                  onTap: () {
                                    final company = state.product.company!;
                                    final query = [
                                      company.address,
                                      company.city,
                                      company.pincode,
                                    ].where((e) => e != null && e.isNotEmpty).join(', ');
                                    final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(query)}');
                                    openSocialApp(appUri: uri, webUri: uri);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: colorE7E3DA,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color010103.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(SVGImages.icLocation, width: 20.w),
                                  ),
                                ),
                              if (state.product.company?.facebookUrl != null &&
                                  state.product.company!.facebookUrl!.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    final uri = Uri.parse(state.product.company!.facebookUrl!);
                                    openSocialApp(appUri: uri, webUri: uri);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: colorE7E3DA,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color010103.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(SVGImages.icFacebook, width: 20.w),
                                  ),
                                ),
                              if (state.product.company?.instagramUrl != null &&
                                  state.product.company!.instagramUrl!.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    final uri = Uri.parse(state.product.company!.instagramUrl!);
                                    openSocialApp(appUri: uri, webUri: uri);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: colorE7E3DA,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color010103.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(PNGImages.imgInstagram, width: 20.w),
                                  ),
                                ),
                              if (state.product.company?.twitterUrl != null &&
                                  state.product.company!.twitterUrl!.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    final uri = Uri.parse(state.product.company!.twitterUrl!);
                                    openSocialApp(appUri: uri, webUri: uri);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: colorE7E3DA,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color010103.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(Icons.alternate_email, size: 20.w, color: colorBlack),
                                  ),
                                ),
                              if (state.product.company?.youtubeUrl != null &&
                                  state.product.company!.youtubeUrl!.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    final uri = Uri.parse(state.product.company!.youtubeUrl!);
                                    openSocialApp(appUri: uri, webUri: uri);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: colorE7E3DA,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color010103.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(Icons.play_circle_fill, size: 20.w, color: Colors.red),
                                  ),
                                ),
                              if (state.product.company?.linkedinUrl != null &&
                                  state.product.company!.linkedinUrl!.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    final uri = Uri.parse(state.product.company!.linkedinUrl!);
                                    openSocialApp(appUri: uri, webUri: uri);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: colorE7E3DA,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: color010103.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextWidget(
                                      text: 'in',
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF0077b5),
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        heightBox(20.h),
                      ],
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

  Widget _topIconContainer(String iconPath) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: color010103.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: SvgPicture.asset(iconPath, colorFilter: const ColorFilter.mode(color010103, BlendMode.srcIn)),
    );
  }

  Widget _buildMediaWidget(ProductDetailStateData state, ProductMediaItem media, int index) {
    if (media.type == ProductMediaType.image) {
      return ProductDetailZoomableImage(
        imageUrl: media.url,
        isActive: index == state.currentIndex,
        transformationController: _imageTransformController,
        onZoomChanged: (zoomed) {
          if (zoomed != _isZoomed) {
            setState(() => _isZoomed = zoomed);
            widget.onZoomChanged?.call(zoomed);
          }
        },
      );
    }

    if (index != state.currentIndex) {
      return Container(color: colorBlack);
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

  Widget _buildRightMenuButton({String? svgPath, IconData? iconData, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: colorE7E3DA,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: color010103.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Center(
          child: svgPath != null
              ? SvgPicture.asset(
                  svgPath,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(color010103, BlendMode.srcIn),
                )
              : Icon(iconData, size: 24.w, color: color010103),
        ),
      ),
    );
  }

  void showDetailsBottomDialog(BuildContext context, ProductDetailStateData state) {
    final product = state.product;
    final details = <MapEntry<String, String>>[
      //MapEntry(strProductIdLabel, _asDisplay(product.id)),
      MapEntry(strProductNameLabel, _asDisplay(product.name)),
      MapEntry(strCategory, _asDisplay(product.category?.name)),
      MapEntry(strProductDescriptionLabel, _asDisplay(product.description)),
      //MapEntry(strProductPriceLabel, _asDisplay(product.price)),
      //MapEntry(strProductStockLabel, _asDisplay(product.stock)),
      MapEntry(strProductMinQuantityLabel, _asDisplay(product.minQuantity)),
      MapEntry(strProductManufacturingTimeLabel, _asDisplay(product.manufacturingTime)),
      MapEntry(strProductDenierLabel, _asDisplay(product.denier)),
      MapEntry(strProductMeterLabel, _asDisplay(product.meter)),
      MapEntry(strProductPackingLabel, _asDisplay(product.packing)),
      MapEntry(strProductPisLabel, _asDisplay(product.pis)),
      MapEntry(strProductGrossWeightLabel, _asDisplay(product.grossWeight)),
      MapEntry(strProductNetWeightLabel, _asDisplay(product.netWeight)),
      MapEntry(strProductTubeSizeLabel, _asDisplay(product.tubeSize)),
      //MapEntry(strProductStockDetailsLabel, _asDisplay(product.stockDetails)),
      //MapEntry(strProductCompanyIdLabel, _asDisplay(product.companyId)),
      //MapEntry(strProductCreatedAtLabel, _asDisplay(product.createdAt)),
      MapEntry(strProductMaterialsLabel, _materialsValue(product)),
      MapEntry(strProductColorsLabel, _colorsValue(product)),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: (MediaQuery.of(context).size.height * 0.8).clamp(460.0, 760.0),
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

  Widget _buildDialogThumb(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(PNGImages.imgThread1, width: 44.w, height: 44.h, fit: BoxFit.cover);
    }
    return AppCachedImage(imageUrl: imageUrl, useResize: false, width: 44.w, height: 44.h, fit: BoxFit.cover);
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

  Future<void> _handleDirectWhatsappChat(ProductDetailStateData state, BuildContext context) async {
    final productId = state.product.id ?? '';

    // 1. Log whatsapp_button_click event
    _logProductEvent(eventType: 'whatsapp_button_click', productId: productId);

    // 2. Read supplier / company WhatsApp number (or phone fallback)
    final rawNumber = state.product.company?.whatsappNumber ?? state.product.company?.phone;

    // 3. Generate pre-filled inquiry message
    final message = WhatsappUtils.buildInquiryMessage(
      productName: state.product.name ?? '',
      companyName: state.product.company?.name ?? '',
      productId: productId,
    );

    // 4. Launch WhatsApp (with image if available)
    final launched = await WhatsappUtils.shareToWhatsAppWithImage(
      phoneNumber: rawNumber ?? '',
      message: message,
      imageUrl: state.firstImageUrl,
    );

    if (launched) {
      _logProductEvent(eventType: 'whatsapp_open_success', productId: productId);
    } else {
      final normalized = WhatsappUtils.normalizePhoneNumber(rawNumber);
      if (normalized.isEmpty) {
        _logProductEvent(eventType: 'invalid_company_number', productId: productId);
        if (context.mounted) {
          showSnackBar(context, 'Supplier WhatsApp number not available.');
        }
      } else {
        _logProductEvent(eventType: 'whatsapp_open_failed', productId: productId);
        if (context.mounted) {
          showSnackBar(context, 'Could not launch WhatsApp.');
        }
      }
    }
  }
}
