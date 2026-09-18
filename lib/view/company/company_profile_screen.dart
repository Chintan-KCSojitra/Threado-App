import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/company/company_review_dialog.dart';
import 'package:thredo/view/company/company_reviews_screen.dart';
import 'package:thredo/view/company/cubit/company_cubit.dart';
import 'package:thredo/view/company/shade_cards_gallery_screen.dart';
import 'package:thredo/view/company/widgets/company_review_tile.dart';
import 'package:thredo/view/productDetail/product_reel_screen.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyProfileScreen extends StatefulWidget {
  final CompanyListData company;

  /// When true, shows company-operator tools (e.g. chat).
  final bool isCompanyPortalProfile;

  const CompanyProfileScreen({super.key, required this.company, this.isCompanyPortalProfile = false});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends BaseStatefulWidgetState<CompanyProfileScreen> {
  late final CompanyCubit _companyCubit;
  late final PagingController<int, ProductListData> _pagingController;
  late final ScrollController _scrollController;
  late CompanyListData _company;

  /// Key used to measure the height of the company-details header after layout.
  final GlobalKey _headerKey = GlobalKey();

  /// True once the company details header has scrolled off-screen.
  /// This toggles the pinned compact logo+name header above products.
  bool _showStickyCompanyHeader = false;

  /// Cached pixel offset at which we switch to compact sticky header.
  double _headerHeight = 0;

  @override
  void initState() {
    super.initState();
    _company = widget.company;
    _companyCubit = CompanyCubit();
    _pagingController = PagingController<int, ProductListData>(
      getNextPageKey: (state) {
        final pages = state.pages;
        if (pages == null || pages.isEmpty) return 1;
        final lastPage = pages.last;
        if (lastPage.length < CompanyCubit.pageSize) return null;
        final lastKey = state.keys?.last ?? 1;
        return lastKey <= 0 ? 2 : lastKey + 1;
      },
      fetchPage: (page) =>
          _companyCubit.fetchCompanyProductsPage(companyId: _company.id ?? '', page: page <= 0 ? 1 : page),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    floatingActionButtonLocation = FloatingActionButtonLocation.centerFloat;

    // Measure the header after the first frame so we know the trigger offset.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) _headerHeight = box.size.height;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_headerHeight <= 0) return;
    // Show compact sticky logo+name as we approach the product section,
    // so the transition feels smoother than waiting for full header exit.
    final triggerOffset = (_headerHeight - 72.h).clamp(0, double.infinity);
    final shouldShow = _scrollController.offset >= triggerOffset;
    if (shouldShow != _showStickyCompanyHeader) {
      setState(() => _showStickyCompanyHeader = shouldShow);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pagingController.dispose();
    _companyCubit.close();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CommonAppBar(
      title: AppLocalizations.of(context).companyProfile,
      titleWidget: Padding(
        padding: const EdgeInsets.only(top: 11),
        child: TextWidget(
          text: AppLocalizations.of(context).companyProfile,
          color: colorBlack,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final company = _company;
    final sortedReviews = company.sortedReviews;
    final previewReviews = sortedReviews.take(5).toList();
    final totalReviews = company.reviewCount ?? sortedReviews.length;
    final canAddReview = !company.hasUserReviewed;

    return RefreshIndicator(
      color: colorPrimary,
      onRefresh: _onRefreshProducts,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // ── Company details (scrolls away with the page) ──────────────────
          SliverToBoxAdapter(
            child: Container(
              key: _headerKey,
              color: backgroundColor,
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + name/contact row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyLogo(company.logoUrl),
                      widthBox(16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: (company.name ?? '').trim().isEmpty ? 'Company' : company.name!,
                              textStyle: BaseTextStyle.text600.copyWith(fontSize: 16.sp, color: color09064A),
                            ),
                            if ((company.email ?? '').trim().isNotEmpty) ...[
                              heightBox(4.h),
                              TextWidget(
                                text: company.email!,
                                textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E),
                              ),
                            ],
                            if ((company.phone ?? '').trim().isNotEmpty) ...[
                              heightBox(3.h),
                              TextWidget(
                                text: company.phone!,
                                textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E),
                              ),
                            ],
                            /*heightBox(10.h),
                            GestureDetector(
                              onTap: () {
                                final address = _buildAddress(company);
                                if (address != '-') {
                                  final uri = Uri.parse(
                                    'https://maps.google.com/?q=${Uri.encodeComponent(address)}',
                                  );
                                  launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      size: 14.sp,
                                      color: color79747E,
                                    ),
                                  ),
                                  widthBox(4.w),
                                  Expanded(
                                    child: TextWidget(
                                      text: _buildAddress(company),
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                      textStyle: BaseTextStyle.text500.copyWith(
                                        fontSize: 12.sp,
                                        color: color79747E,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Description
                  if ((company.description ?? '').trim().isNotEmpty) ...[
                    heightBox(14.h),
                    _ExpandableText(
                      text: company.description!.trim(),
                      style: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color09064A, height: 1.5),
                    ),
                  ],
                  heightBox(16.h),
                  _buildReviewsSection(
                    l10n: l10n,
                    company: company,
                    previewReviews: previewReviews,
                    totalReviews: totalReviews,
                    showViewAll: totalReviews > 5,
                  ),
                  if (canAddReview) ...[
                    heightBox(12.h),
                    CommonButton(
                      text: l10n.addReview,
                      width: double.infinity,
                      height: 48.h,
                      borderRadius: 12,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      onTap: () => CompanyReviewDialog.show(
                        context,
                        companyName: company.name ?? 'Company',
                        onSubmit: (rating, reviewText) async {
                          try {
                            final success = await _companyCubit.addCompanyReview(
                              companyId: company.id ?? '',
                              rating: rating,
                              reviewText: reviewText,
                            );
                            if (success && mounted) {
                              setState(() {
                                _company = _company.withSubmittedReview(rating: rating, reviewText: reviewText);
                              });
                            }
                            return success;
                          } catch (e) {
                            return false;
                          }
                        },
                      ),
                    ),
                  ],
                  heightBox(12.h),
                  // Social links row
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      if ((company.address != null && company.address!.isNotEmpty) ||
                          (company.city != null && company.city!.isNotEmpty))
                        _socialIconButton(
                          onTap: () {
                            final query = [
                              company.address,
                              company.city,
                              company.pincode,
                            ].where((e) => e != null && e.isNotEmpty).join(', ');
                            final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(query)}');
                            launchUrl(uri, mode: LaunchMode.externalApplication);
                          },
                          child: SvgPicture.asset(SVGImages.icLocation, width: 20.w),
                        ),
                      if (company.website != null && company.website!.isNotEmpty)
                        _socialIconButton(
                          onTap: () => _openUrl(company.website),
                          child: Icon(Icons.language, size: 20.w, color: color09064A),
                        ),
                      if (company.facebookUrl != null && company.facebookUrl!.isNotEmpty)
                        _socialIconButton(
                          onTap: () => _openUrl(company.facebookUrl),
                          child: SvgPicture.asset(SVGImages.icFacebook, width: 20.w),
                        ),
                      if (company.instagramUrl != null && company.instagramUrl!.isNotEmpty)
                        _socialIconButton(
                          onTap: () => _openUrl(company.instagramUrl),
                          child: Image.asset(PNGImages.imgInstagram, width: 20.w),
                        ),
                      if (company.twitterUrl != null && company.twitterUrl!.isNotEmpty)
                        _socialIconButton(
                          onTap: () => _openUrl(company.twitterUrl),
                          child: Icon(Icons.alternate_email, size: 20.w, color: colorBlack),
                        ),
                      if (company.youtubeUrl != null && company.youtubeUrl!.isNotEmpty)
                        _socialIconButton(
                          onTap: () => _openUrl(company.youtubeUrl),
                          child: Icon(Icons.play_circle_fill, size: 20.w, color: Colors.red),
                        ),
                      if (company.linkedinUrl != null && company.linkedinUrl!.isNotEmpty)
                        _socialIconButton(
                          onTap: () => _openUrl(company.linkedinUrl),
                          child: TextWidget(
                            text: 'in',
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0077b5),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                  heightBox(16.h),
                ],
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: _CompanyStickyHeaderDelegate(
              minExtentValue: _showStickyCompanyHeader ? 72.h : 0,
              maxExtentValue: _showStickyCompanyHeader ? 72.h : 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _showStickyCompanyHeader
                    ? Container(
                        key: const ValueKey('sticky_company_header'),
                        color: backgroundColor,
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: _buildCompanyLogoSmall(company.logoUrl),
                            ),
                            widthBox(12.w),
                            Expanded(
                              child: TextWidget(
                                text: (company.name ?? '').trim().isEmpty ? 'Company' : company.name!,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                                textStyle: BaseTextStyle.text600.copyWith(fontSize: 16.sp, color: color09064A),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('sticky_empty')),
              ),
            ),
          ),

          // ── Product grid ──────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(0.w, 0, 0.w, 20.h),
            sliver: PagingListener<int, ProductListData>(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) {
                final allProducts = _flattenLoadedProducts(state);
                return PagedSliverGrid<int, ProductListData>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    mainAxisExtent: 205.h,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<ProductListData>(
                    itemBuilder: (context, item, index) =>
                        _buildProductTile(item, index: index, allProducts: allProducts),
                    firstPageProgressIndicatorBuilder: (_) => AppLoader.centered(accentColor: colorCEAB8D),
                    newPageProgressIndicatorBuilder: (_) => AppLoader.centered(accentColor: colorCEAB8D),
                    noItemsFoundIndicatorBuilder: (_) => Center(
                      child: TextWidget(
                        text: 'No products found',
                        textStyle: BaseTextStyle.text500.copyWith(fontSize: 13.sp, color: color79747E),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefreshProducts() async {
    _pagingController.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }

  Widget _buildReviewsSection({
    required AppLocalizations l10n,
    required CompanyListData company,
    required List<CompanyReview> previewReviews,
    required num totalReviews,
    required bool showViewAll,
  }) {
    final rating = company.averageRating ?? 0;
    final hasRating = rating > 0 || totalReviews > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextWidget(
                text: l10n.companyReviews,
                textStyle: BaseTextStyle.text600.copyWith(fontSize: 15.sp, color: color09064A),
              ),
            ),
            if (showViewAll)
              GestureDetector(
                onTap: () => navigate(
                  enterPage: CompanyReviewsScreen(companyId: company.id ?? '', companyName: company.name ?? 'Company'),
                ),
                child: TextWidget(
                  text: l10n.viewAll,
                  textStyle: BaseTextStyle.text600.copyWith(fontSize: 13.sp, color: colorCEAB8D),
                ),
              ),
          ],
        ),
        if (hasRating) ...[
          heightBox(8.h),
          Row(
            children: [
              ...List.generate(5, (index) {
                final filled = index < rating.round();
                return Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 16.sp,
                  color: filled ? colorCEAB8D : colorD9D9D9,
                );
              }),
              widthBox(6.w),
              TextWidget(
                text: rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                textStyle: BaseTextStyle.text600.copyWith(fontSize: 13.sp, color: colorCEAB8D),
              ),
              if (totalReviews > 0) ...[
                widthBox(4.w),
                TextWidget(
                  text: '($totalReviews)',
                  textStyle: BaseTextStyle.text400.copyWith(fontSize: 12.sp, color: color79747E),
                ),
              ],
            ],
          ),
        ],
        heightBox(12.h),
        if (previewReviews.isEmpty)
          TextWidget(
            text: l10n.noReviewsYet,
            textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E),
          )
        else
          SizedBox(
            height: 112.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: previewReviews.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 228.w,
                  child: CompanyReviewTile(review: previewReviews[index], compact: true),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCompanyLogo(dynamic logoUrl) {
    final logo = (logoUrl ?? '').toString().trim();
    if (logo.isEmpty) {
      return Image.asset(PNGImages.imgCompany2, height: 62.h, width: 62.w, fit: BoxFit.cover);
    }
    return AppCachedImage(
      imageUrl: logo,
      height: 62.h,
      width: 62.w,
      fit: BoxFit.cover,
      borderRadius: 8.r,
      errorAssetPath: PNGImages.imgCompany2,
    );
  }

  /// Small (32×32) variant used in the AppBar when the header scrolls away.
  Widget _buildCompanyLogoSmall(dynamic logoUrl) {
    final logo = (logoUrl ?? '').toString().trim();
    if (logo.isEmpty) {
      return Image.asset(PNGImages.imgCompany2, height: 32.h, width: 32.w, fit: BoxFit.cover);
    }
    return AppCachedImage(
      imageUrl: logo,
      height: 32.h,
      width: 32.w,
      fit: BoxFit.cover,
      errorAssetPath: PNGImages.imgCompany2,
    );
  }

  Widget _socialIconButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: const BoxDecoration(color: colorF6F6F6, shape: BoxShape.circle),
        padding: EdgeInsets.all(6.w),
        child: FittedBox(fit: BoxFit.contain, child: child),
      ),
    );
  }

  List<ProductListData> _flattenLoadedProducts(PagingState<int, ProductListData> state) {
    final pages = state.pages;
    if (pages == null || pages.isEmpty) return const [];
    return [for (final page in pages) ...page];
  }

  String? _resolveProductImageUrl(ProductListData product) {
    final imageMedia = product.media?.firstWhere(
      (m) => (m.mediaType ?? '').toLowerCase() == 'image' && (m.url ?? '').isNotEmpty,
      orElse: () => Media(url: null),
    );
    if (imageMedia?.url?.isNotEmpty == true) return imageMedia!.url;
    if (product.media?.isNotEmpty == true) return product.media!.first.url;
    return null;
  }

  Widget _buildProductTile(ProductListData item, {required int index, required List<ProductListData> allProducts}) {
    final imageUrl = _resolveProductImageUrl(item);
    return GestureDetector(
      onTap: () => navigate(
        enterPage: ProductReelScreen(productList: allProducts, initialIndex: index),
      ),
      child: imageUrl == null || imageUrl.isEmpty
          ? Container(color: colorE6E6E6)
          : AppCachedImage(
              memCacheWidth: 400,
              memCacheHeight: 400,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
            ),
    );
  }

  Future<void> _openUrl(String? url) async {
    final value = (url ?? '').trim();
    if (value.isEmpty) return;
    final uri = Uri.tryParse(value);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget? buildFloating(BuildContext context) {
    final showShadeCard = _company.shadeCardEnabled == true && (_company.shadeCards?.isNotEmpty ?? false);
    if (!showShadeCard) return null;

    return CommonButton(
      text: AppLocalizations.of(context).shadeCardPickerTitle,
      width: 150.w,
      height: 44.h,
      borderRadius: 22,
      isIcon: true,
      iconWidget: Icon(Icons.palette_outlined, color: colorWhite, size: 20.sp),
      backgroundColor: color09064A,
      textColor: colorWhite,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      onTap: () {
        navigate(
          enterPage: ShadeCardsGalleryScreen(
            companyName: _company.name ?? 'Company',
            shadeCards: _company.shadeCards ?? [],
          ),
        );
      },
    );
  }
}

class _CompanyStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtentValue;
  final double maxExtentValue;
  final Widget child;

  _CompanyStickyHeaderDelegate({required this.minExtentValue, required this.maxExtentValue, required this.child});

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _CompanyStickyHeaderDelegate oldDelegate) {
    return minExtentValue != oldDelegate.minExtentValue ||
        maxExtentValue != oldDelegate.maxExtentValue ||
        child != oldDelegate.child;
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _ExpandableText({required this.text, required this.style});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: widget.style);
        final textPainter = TextPainter(text: textSpan, maxLines: 2, textDirection: Directionality.of(context));
        textPainter.layout(maxWidth: constraints.maxWidth);

        final bool hasOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: widget.text,
              textStyle: widget.style,
              maxLines: _isExpanded ? null : 2,
              textOverflow: _isExpanded ? null : TextOverflow.ellipsis,
            ),
            if (hasOverflow)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: TextWidget(
                    text: _isExpanded ? "Read less" : "Read more",
                    textStyle: widget.style.copyWith(color: colorBlack, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
