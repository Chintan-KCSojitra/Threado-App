import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/productDetail/ar_match_screen.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

import '../../res/image.dart';
import '../../widget/app_loader.dart';

class ShadeCardsGalleryScreen extends StatelessWidget {
  final String companyName;
  final List<ShadeCards> shadeCards;

  const ShadeCardsGalleryScreen({super.key, required this.companyName, required this.shadeCards});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CommonAppBar(title: l10n.shadeCardPickerTitle, centerTitle: true),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          cacheExtent: 3000,
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: companyName.toUpperCase(),
                      textStyle: BaseTextStyle.text700.copyWith(fontSize: 18.sp, color: const Color(0xFF09064A)),
                    ),
                    heightBox(6.h),
                    TextWidget(
                      text: l10n.shadeCardPickerSubtitle,
                      textStyle: BaseTextStyle.text400.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xFF79747E),
                        height: 1.4,
                      ),
                    ),
                    heightBox(4.h),
                    TextWidget(
                      text: "Tap a shade card to start matching",
                      textStyle: BaseTextStyle.text400.copyWith(fontSize: 14.sp, color: const Color(0xFFCEAB8D)),
                    ),
                  ],
                ),
              ),
            ),

            // Masonry Grid Section: Exactly 3 columns, wrapping natural heights
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 6.h,
                crossAxisSpacing: 6.w,
                itemBuilder: (context, index) {
                  final card = shadeCards[index];
                  final cardName = card.name?.toString() ?? '';
                  final itemWidth = (1.sw - 20.w - 12.w) / 3;

                  return InkWell(
                    onTap: () {
                      navigate(
                        enterPage: ARMatchScreen(productImageUrl: '', selectedShadeCard: card),
                      );
                    },
                    child: AppCachedImage(
                      imageUrl: card.imageUrl ?? '',
                      // Load original high-resolution image to avoid server-side cropping and compression
                      useResize: false,
                      width: itemWidth,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      // Enable memory downscaling to prevent cache thrashing during scroll
                      useMemCache: true,
                      fadeInDuration: Duration.zero,
                      placeholder: _buildShadeCardPlaceholder(cardName),
                      placeholderColor: colorF2F2F2,
                      // Ensure efficient high-quality rendering during scaling
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.medium,
                      ),
                      errorWidget: Image.asset(
                        PNGImages.imgThread1,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    // AppCachedImage(
                    //   imageUrl: card.imageUrl ?? '',
                    //   fit: BoxFit.contain,
                    //   alignment: Alignment.topCenter,
                    //   fadeInDuration: Duration.zero,
                    //   fadeOutDuration: Duration.zero,
                    //   borderRadius: 8.r,
                    //   placeholder: _buildShadeCardPlaceholder(cardName),
                    // ),
                  );
                },
                childCount: shadeCards.length,
              ),
            ),

            SliverToBoxAdapter(child: heightBox(20.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildShadeCardPlaceholder(String label) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AspectRatio ensures a consistent starting height for the loader area
          AspectRatio(
            aspectRatio: 0.75,
            child: Center(
              child: AppLoader(size: 24.sp, accentColor: colorCEAB8D),
            ),
          ),
          if (label.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: TextWidget(
                text: label,
                textAlign: TextAlign.center,
                textStyle: BaseTextStyle.text400.copyWith(fontSize: 10.sp, color: const Color(0xFF79747E)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
