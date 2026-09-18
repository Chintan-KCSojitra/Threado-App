import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/home/cubit/all_product_cubit.dart';
import 'package:thredo/view/home/cubit/all_product_state.dart';
import 'package:thredo/view/productDetail/product_reel_screen.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/edit_text_widget.dart';
import 'package:thredo/widget/product_filter_bottom_sheet.dart';
import 'package:thredo/widget/text_widget.dart';

class AllProductScreen extends StatelessWidget {
  const AllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => AllProductCubit()..init(), child: const _AllProductView());
  }
}

class _AllProductView extends StatefulWidget {
  const _AllProductView();

  @override
  State<_AllProductView> createState() => _AllProductViewState();
}

class _AllProductViewState extends BaseStatefulWidgetState<_AllProductView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 320) {
      context.read<AllProductCubit>().loadMoreProducts();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<AllProductCubit>().searchProducts(value);
    });
  }

  void _openFilterSheet() {
    final cubit = context.read<AllProductCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      backgroundColor: colorWhite,
      barrierColor: colorBlack.withValues(alpha: 0.45),
      builder: (_) => BlocProvider.value(value: cubit, child: const _FilterBottomSheet()),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const CommonAppBar(title: 'All Products', leadingIc: SVGImages.icArrowBack);
  }

  @override
  Widget buildBody(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFAF9F7),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: BlocBuilder<AllProductCubit, AllProductState>(
              builder: (context, state) {
                final filterCount = state is AllProductStateData ? state.activeFilterCount : 0;
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, _) {
                    return TextEditingWidget(
                      controller: _searchController,
                      hint: 'Search products…',
                      textInputAction: TextInputAction.search,
                      onChanged: _onSearchChanged,
                      suffixIconWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _openFilterSheet,
                            child: Badge(
                              isLabelVisible: filterCount > 0,
                              label: Text('$filterCount'),
                              backgroundColor: colorCEAB8D,
                              child: SvgPicture.asset(SVGImages.icFilter, width: 20.w, height: 20.w),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          if (value.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                context.read<AllProductCubit>().searchProducts('');
                              },
                              child: Icon(Icons.close_rounded, size: 20.sp, color: color79747E),
                            ),
                          SizedBox(width: 8.w),
                          SvgPicture.asset(SVGImages.icSearch, width: 20.w, height: 20.w),
                          SizedBox(width: 14.w),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: colorCEAB8D,
              onRefresh: () => context.read<AllProductCubit>().refreshProducts(),
              child: BlocBuilder<AllProductCubit, AllProductState>(
                builder: (context, state) {
                  if (state is! AllProductStateData) return const SizedBox.shrink();
                  final products = state.products;

                  if (state.isInitialLoading && products.isEmpty) {
                    return _buildGridSkeleton();
                  }

                  if (products.isEmpty) {
                    return _buildEmptyState(state);
                  }

                  return CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 1.5,
                          crossAxisSpacing: 1.5,
                          mainAxisExtent: 200.h,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => _ProductTile(product: products[index], index: index, allProducts: products),
                          childCount: products.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 60.h,
                          child: Center(
                            child: state.isLoadingMore
                                ? const AppLoader.small(accentColor: colorCEAB8D)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSkeleton() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        mainAxisExtent: 200.h,
      ),
      itemCount: 12,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFEEEEEE),
        highlightColor: const Color(0xFFF8F8F8),
        child: const ColoredBox(color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(AllProductStateData state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48.sp, color: colorD9D9D9),
          SizedBox(height: 12.h),
          TextWidget(
            text: state.errorMessage ?? 'No products found',
            textStyle: BaseTextStyle.text400.copyWith(fontSize: 14.sp, color: color79747E),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.index, required this.allProducts});
  final ProductListData product;
  final int index;
  final List<ProductListData> allProducts;

  @override
  Widget build(BuildContext context) {
    final imageMedia = product.media?.firstWhere(
      (m) => (m.mediaType ?? '').toLowerCase() == 'image' && (m.url ?? '').isNotEmpty,
      orElse: () => Media(url: null),
    );
    final url = imageMedia?.url ?? (product.media?.isNotEmpty == true ? product.media!.first.url : null);

    return GestureDetector(
      onTap: () => navigate(
        enterPage: ProductReelScreen(productList: allProducts, initialIndex: index),
      ),
      child: Container(
        color: colorF8F8F8,
        child: url == null || url.isEmpty
            ? const ColoredBox(color: colorD9D9D9)
            : AppCachedImage(imageUrl: url, fit: BoxFit.cover, showShimmer: true),
      ),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllProductCubit, AllProductState>(
      builder: (context, state) {
        if (state is! AllProductStateData) return const SizedBox.shrink();
        final cubit = context.read<AllProductCubit>();
        return ProductFilterBottomSheet(
          filterState: state.filterSheetState,
          onRetry: () => cubit.fetchFilters(force: true),
          onReset: cubit.resetFilterSelections,
          onApply: cubit.applyFilters,
          onToggleCompany: cubit.toggleCompanyFilter,
          onToggleColor: cubit.toggleColorFilter,
          onToggleMaterial: cubit.toggleMaterialFilter,
        );
      },
    );
  }
}
