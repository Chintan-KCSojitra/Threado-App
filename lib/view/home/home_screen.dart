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
import 'package:thredo/view/category/category_screen.dart';
import 'package:thredo/view/category/sub_category_screen.dart';
import 'package:thredo/view/company/company_screen.dart';
import 'package:thredo/view/home/all_product_screen.dart';
import 'package:thredo/view/home/cubit/home_cubit.dart';
import 'package:thredo/view/home/cubit/home_state.dart';
import 'package:thredo/view/notification/notification_screen.dart';
import 'package:thredo/view/productDetail/product_reel_screen.dart';
import 'package:thredo/view/wishlist/wish_list_screen.dart';
import 'package:thredo/widget/app_cached_image.dart';
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

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: const Color(0xFFFAF9F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(l10n),
          Expanded(
            child: RefreshIndicator(
              color: colorCEAB8D,
              backgroundColor: colorWhite,
              strokeWidth: 2,
              onRefresh: () => context.read<HomeCubit>().refreshProducts(),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  _buildBannerSliver(),
                  _buildCategorySection(),
                  _buildCompanyBannerSliver(),
                  _buildProductSection(),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      color: colorWhite,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 16.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: l10n.appName,
                  textStyle: BaseTextStyle.text700.copyWith(fontSize: 22.sp, color: color09064A, letterSpacing: 0.4),
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
          SizedBox(width: 4.w),
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
              SizedBox(height: 16.h),
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
              SizedBox(height: 18.h),
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
        if (categories.isEmpty && !homeState.isCategoriesLoading && !homeState.isInitialLoading) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(
                title: 'Categories',
                onTapViewAll: () {
                  if (widget.onTabChanged != null) {
                    widget.onTabChanged!(1);
                  } else {
                    navigate(enterPage: const CategoryScreen());
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: (homeState.isCategoriesLoading || (homeState.isInitialLoading && categories.isEmpty))
                    ? _buildCategorySkeleton()
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          mainAxisExtent: 80.h,
                        ),
                        itemCount: categories.length > 6 ? 6 : categories.length,
                        itemBuilder: (context, index) => _buildCategoryTile(categories[index]),
                      ),
              ),
              SizedBox(height: 20.h),
            ],
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
          border: Border.all(color: colorE6E6E6),
        ),
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AppCachedImage(
                imageUrl: category.imageUrl ?? '',
                width: 50.w,
                height: 50.w,
                fit: BoxFit.cover,
                errorAssetPath: PNGImages.imgThread1,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextWidget(
                text: category.name ?? '',
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
                textStyle: BaseTextStyle.text600.copyWith(fontSize: 13.sp, color: color09064A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySkeleton() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF8F8F8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          mainAxisExtent: 80.h,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }

  Widget _buildCompanyBannerSliver() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          if (widget.onTabChanged != null) {
            widget.onTabChanged!(3);
          } else {
            navigate(enterPage: const CompanyScreen());
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(PNGImages.companyBanner, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) {
        final p = prev as HomeStateData;
        final n = next as HomeStateData;
        return p.products != n.products || p.isInitialLoading != n.isInitialLoading;
      },
      builder: (context, state) {
        final homeState = state as HomeStateData;
        final products = homeState.products;
        if (products.isEmpty && !homeState.isInitialLoading) return const SliverToBoxAdapter(child: SizedBox.shrink());

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
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
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.w,
                          mainAxisExtent: 150.h,
                        ),
                        itemCount: products.length > 9 ? 9 : products.length,
                        itemBuilder: (context, index) => _buildProductTile(products[index], index, products),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductTile(ProductListData product, int index, List<ProductListData> allProducts) {
    final imageMedia = product.media?.firstWhere(
      (m) => (m.mediaType ?? '').toLowerCase() == 'image' && (m.url ?? '').isNotEmpty,
      orElse: () => Media(url: null),
    );
    final url = imageMedia?.url ?? (product.media?.isNotEmpty == true ? product.media!.first.url : null);

    return GestureDetector(
      onTap: () => navigate(
        enterPage: ProductReelScreen(productList: allProducts, initialIndex: index),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          color: colorF8F8F8,
          child: url == null || url.isEmpty
              ? const ColoredBox(color: colorD9D9D9)
              : AppCachedImage(imageUrl: url, fit: BoxFit.cover, showShimmer: true),
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
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          mainAxisExtent: 150.h,
        ),
        itemCount: 9,
        itemBuilder: (_, __) => Container(
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
