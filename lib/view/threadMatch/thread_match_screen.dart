import 'dart:async';
import 'dart:io';

import 'package:thredo/widget/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/productDetail/product_reel_screen.dart';
import 'package:thredo/view/threadMatch/cubit/thread_match_cubit.dart';
import 'package:thredo/view/threadMatch/cubit/thread_match_state.dart';
import 'package:thredo/view/threadMatch/widgets/thread_match_capture_tips.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

// ── BLoC wrapper ──────────────────────────────────────────────────────────────

class ThreadMatchScreen extends StatelessWidget {
  const ThreadMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThreadMatchCubit(),
      child: const _ThreadMatchView(),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _ThreadMatchView extends StatefulWidget {
  const _ThreadMatchView();

  @override
  State<_ThreadMatchView> createState() => _ThreadMatchScreenState();
}

class _ThreadMatchScreenState
    extends BaseStatefulWidgetState<_ThreadMatchView> {

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CommonAppBar(
      title: l10n.matchScreenTitle,
      shouldShowBackButton: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<ThreadMatchCubit, ThreadMatchState>(
      builder: (context, state) {
        if (state is! ThreadMatchStateData) return const SizedBox.shrink();
        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, ThreadMatchStateData state) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ThreadMatchCubit>();

    return Container(
      width: screenSize.width,
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Upload zone ──────────────────────────────────────────────────
          _UploadZone(
            state: state,
            l10n: l10n,
            cubit: cubit,
          ),

          // ── Results ──────────────────────────────────────────────────────
          Expanded(
            child: _ResultsArea(state: state, l10n: l10n),
          ),
        ],
      ),
    );
  }
}

// ── Upload zone ───────────────────────────────────────────────────────────────

class _UploadZone extends StatelessWidget {
  const _UploadZone({
    required this.state,
    required this.l10n,
    required this.cubit,
  });

  final ThreadMatchStateData state;
  final AppLocalizations l10n;
  final ThreadMatchCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorF7F7F7,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview / placeholder
          _buildPreview(context),
          if (state.pickedImagePath == null && !state.isScanning) ...[
            heightBox(12.h),
            ThreadMatchCaptureTipsBanner(l10n: l10n),
          ],
          heightBox(12.h),
          // Action buttons
          _buildActionRow(context),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return GestureDetector(
      onTap: state.isScanning
          ? null
          : () => _showPickerSheet(context, cubit, l10n),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 200.h,
        decoration: BoxDecoration(
          color: colorF2F2F2,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: state.pickedImagePath != null ? colorCEAB8D : colorE7E3DA,
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: state.pickedImagePath != null
            ? _buildImagePreview()
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Picked image
        Image.file(
          File(state.pickedImagePath!),
          fit: BoxFit.cover,
        )
            .animate()
            .fadeIn(duration: 300.ms),

        // Scanning shimmer overlay
        if (state.isScanning)
          Shimmer.fromColors(
            baseColor: colorBlack.withValues(alpha: 0.35),
            highlightColor: colorWhite.withValues(alpha: 0.15),
            child: Container(color: colorBlack.withValues(alpha: 0.35)),
          ),

        // Scanning label
        if (state.isScanning)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLoader(
                  size: 28.w,
                  accentColor: colorWhite,
                  trackColor: colorWhite.withValues(alpha: 0.25),
                ),
                heightBox(10.h),
                const _AnimatedScanningMessage(),
              ],
            ),
          ),

        // Change image button
        if (!state.isScanning)
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Builder(
              builder: (ctx) => GestureDetector(
                onTap: () => _showPickerSheet(ctx, cubit, l10n),
                child: Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: colorBlack.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: colorWhite,
                    size: 15.sp,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: const BoxDecoration(
            color: colorE7E3DA,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(13.w),
          child: SvgPicture.asset(
            SVGImages.icMatchProduct,
            colorFilter: const ColorFilter.mode(color09064A, BlendMode.srcIn),
          ),
        ),
        heightBox(12.h),
        TextWidget(
          text: l10n.matchUploadHint,
          textStyle: BaseTextStyle.text600.copyWith(
            fontSize: 14.sp,
            color: color09064A,
          ),
        ),
        heightBox(4.h),
        TextWidget(
          text: l10n.matchUploadSubHint,
          textStyle: BaseTextStyle.text400.copyWith(
            fontSize: 12.sp,
            color: color79747E,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.photo_library_outlined,
            label: l10n.matchPickGallery,
            isDark: false,
            onTap: state.isScanning
                ? null
                : () => _showSourceGuideSheet(context, isCamera: false),
          ),
        ),
        widthBox(12.w),
        Expanded(
          child: _ActionButton(
            icon: Icons.camera_alt_outlined,
            label: l10n.matchPickCamera,
            isDark: true,
            onTap: state.isScanning
                ? null
                : () => _showSourceGuideSheet(context, isCamera: true),
          ),
        ),
      ],
    );
  }

  void _showPickerSheet(
      BuildContext context, ThreadMatchCubit cubit, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorE6E6E6,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              heightBox(16.h),
              TextWidget(
                text: l10n.matchPickSource,
                textStyle: BaseTextStyle.text600.copyWith(
                  fontSize: 16.sp,
                  color: color09064A,
                ),
              ),
              heightBox(16.h),
              ThreadMatchCaptureTipsPanel(l10n: l10n),
              heightBox(20.h),
              Row(
                children: [
                  Expanded(
                    child: _SheetOption(
                      icon: Icons.photo_library_outlined,
                      label: l10n.matchPickGallery,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        cubit.pickFromGallery();
                      },
                    ),
                  ),
                  widthBox(16.w),
                  Expanded(
                    child: _SheetOption(
                      icon: Icons.camera_alt_outlined,
                      label: l10n.matchPickCamera,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        cubit.pickFromCamera();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSourceGuideSheet(BuildContext context, {required bool isCamera}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorE6E6E6,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              heightBox(16.h),
              ThreadMatchCaptureTipsPanel(
                l10n: l10n,
                sourceNote: isCamera
                    ? l10n.matchCaptureTipCameraNote
                    : l10n.matchCaptureTipGalleryNote,
              ),
              heightBox(20.h),
              CommonButton(
                text: isCamera
                    ? l10n.matchCaptureContinueCamera
                    : l10n.matchCaptureContinueGallery,
                onTap: () {
                  Navigator.pop(sheetContext);
                  if (isCamera) {
                    cubit.pickFromCamera();
                  } else {
                    cubit.pickFromGallery();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedScanningMessage extends StatefulWidget {
  const _AnimatedScanningMessage();

  @override
  State<_AnimatedScanningMessage> createState() => _AnimatedScanningMessageState();
}

class _AnimatedScanningMessageState extends State<_AnimatedScanningMessage> {
  final List<String> _messages = [
    "Analyzing thread patterns...",
    "Finding the perfect match...",
    "Comparing color palettes...",
    "Scanning fabric textures...",
    "Searching our catalog...",
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: TextWidget(
        key: ValueKey<int>(_currentIndex),
        text: _messages[_currentIndex],
        textStyle: BaseTextStyle.text500.copyWith(
          fontSize: 14.sp,
          color: colorWhite,
        ),
      ),
    );
  }
}

// ── Results area ──────────────────────────────────────────────────────────────

class _ResultsArea extends StatelessWidget {
  const _ResultsArea({required this.state, required this.l10n});

  final ThreadMatchStateData state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    // Idle — nothing picked yet
    if (!state.hasResult && !state.isScanning && state.pickedImagePath == null) {
      return _buildIdleState();
    }

    // Scanning skeleton
    if (state.isScanning) {
      return _buildScanningSkeletons();
    }

    // Error
    if (state.errorMessage != null && state.products.isEmpty) {
      return _buildErrorState();
    }

    // No matches
    if (state.hasResult && state.products.isEmpty) {
      return _buildNoResultState();
    }

    // Product grid
    return _buildProductGrid(context);
  }

  // ── Idle ──────────────────────────────────────────────────────────────────

  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_search_rounded, size: 52.sp, color: colorE7E3DA)
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          heightBox(14.h),
          TextWidget(
            text: l10n.matchEmptyTitle,
            textStyle: BaseTextStyle.text600.copyWith(
              fontSize: 16.sp,
              color: color09064A,
            ),
          )
              .animate(delay: 80.ms)
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.2, end: 0),
          heightBox(8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: TextWidget(
              text: l10n.matchEmptySubtitle,
              textAlign: TextAlign.center,
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 13.sp,
                color: color79747E,
                height: 1.55,
              ),
            )
                .animate(delay: 140.ms)
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }

  // ── Scanning skeletons ────────────────────────────────────────────────────

  Widget _buildScanningSkeletons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 260.h,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: colorF2F2F2,
          highlightColor: colorWhite,
          child: Container(
            decoration: BoxDecoration(
              color: colorF2F2F2,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 44.sp, color: color79747E),
            heightBox(12.h),
            TextWidget(
              text: state.errorMessage!,
              textAlign: TextAlign.center,
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 13.sp,
                color: color79747E,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── No results ────────────────────────────────────────────────────────────

  Widget _buildNoResultState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 44.sp, color: colorE7E3DA),
          heightBox(12.h),
          TextWidget(
            text: l10n.matchNoResults,
            textStyle: BaseTextStyle.text500.copyWith(
              fontSize: 14.sp,
              color: color79747E,
            ),
          ),
        ],
      ),
    );
  }

  // ── Product grid ──────────────────────────────────────────────────────────

  Widget _buildProductGrid(BuildContext context) {
    final products = state.products;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 10.h),
          child: TextWidget(
            text: l10n.matchResultsTitle(products.length),
            textStyle: BaseTextStyle.text600.copyWith(
              fontSize: 15.sp,
              color: color09064A,
            ),
          ).animate().fadeIn(duration: 300.ms),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              mainAxisExtent: 260.h,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => _ProductCard(
              product: products[index],
              index: index,
              products: products,
            )
                .animate(delay: Duration(milliseconds: 40 * index))
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
          ),
        ),
      ],
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.index,
    required this.products,
  });

  final ProductListData product;
  final int index;
  final List<ProductListData> products;

  @override
  Widget build(BuildContext context) {
    final imageMedia = product.media?.firstWhere(
      (m) =>
          (m.mediaType ?? '').toLowerCase() == 'image' &&
          (m.url ?? '').isNotEmpty,
      orElse: () => Media(url: null),
    );
    final String? imageUrl = imageMedia?.url?.isNotEmpty == true
        ? imageMedia?.url
        : (product.media != null && product.media!.isNotEmpty
            ? product.media!.first.url
            : null);

    return GestureDetector(
      onTap: () => navigate(
        enterPage: ProductReelScreen(
          productList: products,
          initialIndex: index,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorF7F7F7,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13.r),
              child: imageUrl == null || imageUrl.isEmpty
                  ? Container(
                      height: 160.h,
                      width: double.infinity,
                      color: colorE6E6E6,
                    )
                  : AppCachedImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160.h,
                    ),
            ),
            heightBox(12.h),
            TextWidget(
              text: product.company?.name,
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 14.sp,
                color: color79747E,
              ),
            ),
            heightBox(8.h),
            TextWidget(
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              text: product.name,
              textStyle: BaseTextStyle.text600.copyWith(
                fontSize: 14.sp,
                color: color09064A,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? color09064A : colorE7E3DA;
    final fg = isDark ? colorWhite : color09064A;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 46.h,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: fg),
              widthBox(6.w),
              TextWidget(
                text: label,
                textStyle: BaseTextStyle.text600.copyWith(
                  fontSize: 13.sp,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sheet option ──────────────────────────────────────────────────────────────

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: colorF7F7F7,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colorE7E3DA),
        ),
        child: Column(
          children: [
            Icon(icon, size: 26.sp, color: color09064A),
            heightBox(8.h),
            TextWidget(
              text: label,
              textStyle: BaseTextStyle.text500.copyWith(
                fontSize: 13.sp,
                color: color09064A,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
