import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/category_list_response.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/category/sub_category_screen.dart';
import 'package:thredo/view/company/company_profile_screen.dart';
import 'package:thredo/view/home/all_product_screen.dart';
import 'package:thredo/view/home/cubit/home_cubit.dart';
import 'package:thredo/view/home/cubit/home_state.dart';
import 'package:thredo/view/notification/notification_screen.dart';
import 'package:thredo/view/productDetail/product_reel_screen.dart';
import 'package:thredo/view/wishlist/wish_list_screen.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/product_filter_bottom_sheet.dart';
import 'package:thredo/widget/text_widget.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onTabChanged;
  const HomeScreen({super.key, this.onTabChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit()..loadInitialProducts();
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: _HomeView(onTabChanged: widget.onTabChanged),
    );
  }
}

class _HomeView extends StatefulWidget {
  final ValueChanged<int>? onTabChanged;
  const _HomeView({this.onTabChanged});

  @override
  State<_HomeView> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulWidgetState<_HomeView> {
  final PageController _bannerController = PageController(viewportFraction: 0.88, keepPage: true);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _bannerController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _navigateToTab(int tabIndex) {
    if (widget.onTabChanged != null) {
      widget.onTabChanged!(tabIndex);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<HomeCubit>().searchProducts(query);
      }
    });
  }

  void _openFilterBottomSheet(HomeStateData state) {
    final cubit = context.read<HomeCubit>();
    showProductFilterBottomSheet(
      context,
      filterState: state.filterSheetState,
      onRetry: () => cubit.fetchFilters(force: true),
      onReset: () {
        cubit.resetFilterSelections();
        Navigator.pop(context);
      },
      onApply: () {
        cubit.applyFilters();
        Navigator.pop(context);
      },
      onToggleCompany: (id) => cubit.toggleCompanyFilter(id),
      onToggleColor: (id) => cubit.toggleColorFilter(id),
      onToggleMaterial: (id) => cubit.toggleMaterialFilter(id),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: const Color(0xFFFAF9F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderAndSearchBar(l10n),
          Expanded(
            child: RefreshIndicator(
              color: colorCEAB8D,
              backgroundColor: colorWhite,
              strokeWidth: 2,
              onRefresh: () => context.read<HomeCubit>().refreshProducts(),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  _buildQuickActionsRow(),
                  _buildBannerSliver(),
                  _buildCategorySection(),
                  _buildFeaturedCompaniesSection(),
                  _buildThreadMatchPromoBanner(),
                  _buildProductSection(),
                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header & Integrated Search Bar ──────────────────────────────────────────

  Widget _buildHeaderAndSearchBar(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [BoxShadow(color: colorBlack.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: l10n.appName,
                      textStyle: BaseTextStyle.text700.copyWith(
                        fontSize: 22.sp,
                        color: color09064A,
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextWidget(
                      text: l10n.welcomeTraders,
                      textStyle: BaseTextStyle.text400.copyWith(fontSize: 12.sp, color: color79747E),
                    ),
                  ],
                ),
              ),
              _headerIconButton(
                svgPath: SVGImages.icHeartHome,
                onTap: () => navigate(enterPage: const WishListScreen()),
              ),
              SizedBox(width: 8.w),
              _headerIconButton(
                svgPath: SVGImages.icNotificationHome,
                onTap: () => navigate(enterPage: const NotificationScreen()),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (prev, next) {
              final p = prev as HomeStateData;
              final n = next as HomeStateData;
              return p.activeFilterCount != n.activeFilterCount || p.searchQuery != n.searchQuery;
            },
            builder: (context, state) {
              final homeState = state as HomeStateData;
              final activeFilters = homeState.activeFilterCount;

              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3EF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFECEAE6)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            SVGImages.icSearch,
                            width: 18.w,
                            height: 18.w,
                            colorFilter: const ColorFilter.mode(color79747E, BlendMode.srcIn),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: _onSearchChanged,
                              style: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color09064A),
                              decoration: InputDecoration(
                                hintText: 'Search threads, yarns, shade numbers...',
                                hintStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                context.read<HomeCubit>().searchProducts('');
                              },
                              child: Icon(Icons.close_rounded, size: 18.sp, color: color79747E),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => _openFilterBottomSheet(homeState),
                    child: Container(
                      width: 42.h,
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: activeFilters > 0 ? colorCEAB8D : const Color(0xFFF5F3EF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: activeFilters > 0 ? colorCEAB8D : const Color(0xFFECEAE6)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            SVGImages.icFilter,
                            width: 18.w,
                            height: 18.w,
                            colorFilter: ColorFilter.mode(
                              activeFilters > 0 ? colorWhite : color09064A,
                              BlendMode.srcIn,
                            ),
                          ),
                          if (activeFilters > 0)
                            Positioned(
                              top: 6.h,
                              right: 6.w,
                              child: Container(
                                padding: EdgeInsets.all(3.r),
                                decoration: const BoxDecoration(color: color09064A, shape: BoxShape.circle),
                                child: TextWidget(
                                  text: '$activeFilters',
                                  textStyle: BaseTextStyle.text700.copyWith(fontSize: 9.sp, color: colorWhite),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton({required String svgPath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(color: const Color(0xFFF5F3EF), borderRadius: BorderRadius.circular(12.r)),
        child: Center(
          child: SvgPicture.asset(svgPath, width: 20.w, height: 20.w),
        ),
      ),
    );
  }

  // ── Quick Action Shortcuts ──────────────────────────────────────────────────

  Widget _buildQuickActionsRow() {
    final actions = [
      _QuickActionData(
        title: 'Thread Match',
        subtitle: 'AI Color Finder',
        icon: Icons.camera_alt_outlined,
        color: const Color(0xFF09064A),
        onTap: () => _navigateToTab(2), // Tab 2: Thread Match
      ),
      _QuickActionData(
        title: 'Categories',
        subtitle: 'Browse All',
        icon: Icons.grid_view_rounded,
        color: const Color(0xFFCEAB8D),
        onTap: () => _navigateToTab(1), // Tab 1: Category
      ),
      _QuickActionData(
        title: 'Top Mills',
        subtitle: 'Manufacturers',
        icon: Icons.domain_rounded,
        color: const Color(0xFF50BAD7),
        onTap: () => _navigateToTab(3), // Tab 3: Company
      ),
      _QuickActionData(
        title: 'All Products',
        subtitle: 'Catalogue',
        icon: Icons.shopping_bag_outlined,
        color: const Color(0xFF8E44AD),
        onTap: () => navigate(enterPage: const AllProductScreen()),
      ),
      _QuickActionData(
        title: 'Saved Items',
        subtitle: 'Wishlist',
        icon: Icons.favorite_border_rounded,
        color: const Color(0xFFE56A54),
        onTap: () => navigate(enterPage: const WishListScreen()),
      ),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        child: SizedBox(
          height: 64.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: actions.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final item = actions[index];
              return GestureDetector(
                onTap: item.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xFFECEAE6)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(item.icon, size: 20.sp, color: item.color),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: item.title,
                            textStyle: BaseTextStyle.text600.copyWith(fontSize: 12.5.sp, color: color09064A),
                          ),
                          TextWidget(
                            text: item.subtitle,
                            textStyle: BaseTextStyle.text400.copyWith(fontSize: 10.sp, color: color79747E),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Hero Banner Sliver ──────────────────────────────────────────────────────

  Widget _buildBannerSliver() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) => (prev as HomeStateData).banners != (next as HomeStateData).banners,
      builder: (context, state) {
        final homeState = state as HomeStateData;
        final banners = homeState.banners;
        final count = banners.isEmpty ? 1 : banners.length;

        return SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              SizedBox(
                height: 160.h,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: count,
                  itemBuilder: (_, i) => _buildBannerCard(banners.isEmpty ? '' : (banners[i].imageUrl ?? '')),
                ),
              ),
              SizedBox(height: 10.h),
              SmoothPageIndicator(
                controller: _bannerController,
                count: count,
                effect: ExpandingDotsEffect(
                  dotHeight: 5.h,
                  dotWidth: 5.w,
                  expansionFactor: 3,
                  spacing: 4.w,
                  activeDotColor: colorCEAB8D,
                  dotColor: colorD9D9D9,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerCard(String imageUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: imageUrl.isNotEmpty
            ? AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover, errorAssetPath: PNGImages.imgBannerHome)
            : Image.asset(PNGImages.imgBannerHome, fit: BoxFit.cover),
      ),
    );
  }

  // ── Categories Section ──────────────────────────────────────────────────────

  Widget _buildCategorySection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) {
        final p = prev as HomeStateData;
        final n = next as HomeStateData;
        return p.categories != n.categories ||
            p.isCategoriesLoading != n.isCategoriesLoading ||
            p.isInitialLoading != n.isInitialLoading;
      },
      builder: (context, state) {
        final homeState = state as HomeStateData;
        final categories = homeState.categories;
        final isLoading = homeState.isCategoriesLoading || (homeState.isInitialLoading && categories.isEmpty);

        if (categories.isEmpty && !isLoading) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: _CategorySectionWidget(
            categories: categories,
            isLoading: isLoading,
            onTapViewAll: () => _navigateToTab(1), // Tab 1: Category
          ),
        );
      },
    );
  }

  // ── Featured Companies / Partner Mills Row ──────────────────────────────────

  Widget _buildFeaturedCompaniesSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) => (prev as HomeStateData).companies != (next as HomeStateData).companies,
      builder: (context, state) {
        final homeState = state as HomeStateData;
        final companies = homeState.companies;

        if (companies.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(
                title: 'Partner Mills & Brands',
                onTapViewAll: () => _navigateToTab(3), // Tab 3: Company
              ),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: companies.length > 8 ? 8 : companies.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return GestureDetector(
                      onTap: () => navigate(enterPage: CompanyProfileScreen(company: company)),
                      child: Container(
                        width: 86.w,
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: const Color(0xFFECEAE6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: AppCachedImage(
                                imageUrl: company.logoUrl ?? '',
                                width: 44.w,
                                height: 44.w,
                                fit: BoxFit.cover,
                                errorAssetPath: PNGImages.imgCompany1,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            TextWidget(
                              text: company.name ?? '',
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              textStyle: BaseTextStyle.text600.copyWith(fontSize: 11.sp, color: color09064A),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  // ── Thread Match AI Promo Banner ────────────────────────────────────────────

  Widget _buildThreadMatchPromoBanner() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF09064A), Color(0xFF1E1875)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF09064A).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(color: colorCEAB8D.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Icon(Icons.center_focus_strong_rounded, size: 26.sp, color: colorCEAB8D),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Instant Thread & Shade Match',
                      textStyle: BaseTextStyle.text700.copyWith(fontSize: 14.sp, color: colorWhite),
                    ),
                    SizedBox(height: 2.h),
                    TextWidget(
                      text: 'Scan fabric or yarn sample to find exact matching color threads.',
                      textStyle: BaseTextStyle.text400.copyWith(
                        fontSize: 11.sp,
                        color: colorWhite.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _navigateToTab(2), // Tab 2: Thread Match
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(color: colorCEAB8D, borderRadius: BorderRadius.circular(10.r)),
                  child: TextWidget(
                    text: 'Scan Now',
                    textStyle: BaseTextStyle.text700.copyWith(fontSize: 11.5.sp, color: colorWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Products Section ────────────────────────────────────────────────────────

  Widget _buildProductSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) {
        final p = prev as HomeStateData;
        final n = next as HomeStateData;
        return p.products != n.products ||
            p.isInitialLoading != n.isInitialLoading ||
            p.errorMessage != n.errorMessage ||
            p.wishlistedProductIds != n.wishlistedProductIds;
      },
      builder: (context, state) {
        final homeState = state as HomeStateData;
        final products = homeState.products;

        if (products.isEmpty && !homeState.isInitialLoading) {
          if (homeState.errorMessage != null && homeState.errorMessage!.isNotEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 36.sp, color: color79747E),
                    SizedBox(height: 8.h),
                    TextWidget(
                      text: homeState.errorMessage!,
                      textAlign: TextAlign.center,
                      textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () => context.read<HomeCubit>().refreshProducts(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(color: colorCEAB8D, borderRadius: BorderRadius.circular(8.r)),
                        child: TextWidget(
                          text: 'Retry',
                          textStyle: BaseTextStyle.text600.copyWith(fontSize: 12.sp, color: colorWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(
                title: 'Top Products',
                onTapViewAll: () => navigate(enterPage: const AllProductScreen()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: (homeState.isInitialLoading && products.isEmpty)
                    ? _buildProductSkeleton()
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          mainAxisExtent: 175.h,
                        ),
                        itemCount: products.length > 12 ? 12 : products.length,
                        itemBuilder: (context, index) =>
                            _buildRichProductTile(products[index], index, products, homeState.wishlistedProductIds),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRichProductTile(
    ProductListData product,
    int index,
    List<ProductListData> allProducts,
    Set<String> wishlistedIds,
  ) {
    final imageMedia = product.media?.firstWhere(
      (m) => (m.mediaType ?? '').toLowerCase() == 'image' && (m.url ?? '').isNotEmpty,
      orElse: () => Media(url: null),
    );
    final url = imageMedia?.url ?? (product.media?.isNotEmpty == true ? product.media!.first.url : null);
    final title = product.name ?? 'Thread Product';
    final companyName = product.company?.name ?? '';
    final productId = product.id ?? '';
    final isLiked = productId.isNotEmpty && wishlistedIds.contains(productId);

    return GestureDetector(
      onTap: () => navigate(
        enterPage: ProductReelScreen(productList: allProducts, initialIndex: index),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFECEAE6)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: url == null || url.isEmpty
                        ? const ColoredBox(color: colorD9D9D9)
                        : AppCachedImage(imageUrl: url, fit: BoxFit.cover, showShimmer: true),
                  ),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: GestureDetector(
                      onTap: () {
                        if (productId.isNotEmpty) {
                          context.read<HomeCubit>().toggleWishlist(productId);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          color: colorWhite.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 15.sp,
                          color: isLiked ? const Color(0xFFE56A54) : color09064A,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: title,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    textStyle: BaseTextStyle.text600.copyWith(fontSize: 11.5.sp, color: color09064A),
                  ),
                  if (companyName.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    TextWidget(
                      text: companyName,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      textStyle: BaseTextStyle.text400.copyWith(fontSize: 9.5.sp, color: color79747E),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSkeleton() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF8F8F8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          mainAxisExtent: 175.h,
        ),
        itemCount: 9,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onTapViewAll}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: 16.h,
                decoration: BoxDecoration(color: colorCEAB8D, borderRadius: BorderRadius.circular(2.r)),
              ),
              SizedBox(width: 8.w),
              TextWidget(
                text: title,
                textStyle: BaseTextStyle.text600.copyWith(fontSize: 15.sp, color: color09064A),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTapViewAll,
            child: TextWidget(
              text: 'View All',
              textStyle: BaseTextStyle.text600.copyWith(fontSize: 13.sp, color: colorCEAB8D),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Action Model ───────────────────────────────────────────────────────

class _QuickActionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// ── Category Section Widget with ValueNotifier Scroll Indicator ───────────────

class _CategorySectionWidget extends StatefulWidget {
  final List<CategoryData> categories;
  final bool isLoading;
  final VoidCallback onTapViewAll;

  const _CategorySectionWidget({required this.categories, required this.isLoading, required this.onTapViewAll});

  @override
  State<_CategorySectionWidget> createState() => _CategorySectionWidgetState();
}

class _CategorySectionWidgetState extends State<_CategorySectionWidget> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollProgressNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) {
      if (_scrollProgressNotifier.value != 0.0) {
        _scrollProgressNotifier.value = 0.0;
      }
      return;
    }
    final progress = (_scrollController.offset / maxScroll).clamp(0.0, 1.0);
    _scrollProgressNotifier.value = progress;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollProgressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = 154.w;
    final double cardHeight = 70.h;
    final double gridHeight = (cardHeight * 2) + 10.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 16.h,
                    decoration: BoxDecoration(color: colorCEAB8D, borderRadius: BorderRadius.circular(2.r)),
                  ),
                  SizedBox(width: 8.w),
                  TextWidget(
                    text: 'Categories',
                    textStyle: BaseTextStyle.text600.copyWith(fontSize: 15.sp, color: color09064A),
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onTapViewAll,
                child: TextWidget(
                  text: 'View All',
                  textStyle: BaseTextStyle.text600.copyWith(fontSize: 13.sp, color: colorCEAB8D),
                ),
              ),
            ],
          ),
        ),
        widget.isLoading
            ? _buildCategorySkeleton(gridHeight: gridHeight, cardWidth: cardWidth)
            : Column(
                children: [
                  SizedBox(
                    height: gridHeight,
                    child: GridView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.w,
                        crossAxisSpacing: 10.h,
                        mainAxisExtent: cardWidth,
                      ),
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) => _buildCategoryTile(widget.categories[index]),
                    ),
                  ),
                  if (widget.categories.length > 4) ...[SizedBox(height: 12.h), _buildScrollIndicator()],
                ],
              ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    const double trackWidth = 50.0;
    const double thumbWidth = 18.0;
    final double maxThumbOffset = trackWidth - thumbWidth;

    return ValueListenableBuilder<double>(
      valueListenable: _scrollProgressNotifier,
      builder: (context, progress, _) {
        final double currentThumbOffset = maxThumbOffset * progress;
        return Center(
          child: Container(
            width: trackWidth,
            height: 4.h,
            decoration: BoxDecoration(color: const Color(0xFFE5E2DC), borderRadius: BorderRadius.circular(2.r)),
            child: Stack(
              children: [
                Positioned(
                  left: currentThumbOffset,
                  top: 0,
                  bottom: 0,
                  width: thumbWidth,
                  child: Container(
                    decoration: BoxDecoration(color: colorCEAB8D, borderRadius: BorderRadius.circular(2.r)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryTile(CategoryData category) {
    return GestureDetector(
      onTap: () {
        if (category.id != null) {
          navigate(
            enterPage: SubCategoryScreen(categoryId: category.id!, categoryName: category.name ?? ''),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFECEAE6)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: AppCachedImage(
                imageUrl: category.imageUrl ?? '',
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
                errorAssetPath: PNGImages.imgThread1,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextWidget(
                text: category.name ?? '',
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
                textStyle: BaseTextStyle.text600.copyWith(fontSize: 12.sp, color: color09064A, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySkeleton({required double gridHeight, required double cardWidth}) {
    return SizedBox(
      height: gridHeight,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFEEEEEE),
        highlightColor: const Color(0xFFF8F8F8),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.h,
            mainAxisExtent: cardWidth,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ),
    );
  }
}
