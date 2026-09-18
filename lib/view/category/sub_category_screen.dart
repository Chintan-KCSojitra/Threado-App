import 'dart:async';

import 'package:thredo/widget/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/model/color_list_response.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/materials_list_response.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/category/cubit/sub_category_cubit.dart';
import 'package:thredo/view/category/cubit/sub_category_state.dart';
import 'package:thredo/view/productDetail/product_reel_screen.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/edit_text_widget.dart';
import 'package:thredo/widget/text_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Color _hexToColor(String? hex) {
  if (hex == null || hex.trim().isEmpty) return colorBlack;
  try {
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    if (h.length != 8) return colorBlack;
    return Color(int.parse(h, radix: 16));
  } catch (_) {
    return colorBlack;
  }
}

class SubCategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const SubCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubCategoryCubit(categoryId)..init(),
      child: _SubCategoryView(categoryName: categoryName),
    );
  }
}

class _SubCategoryView extends StatefulWidget {
  final String categoryName;
  const _SubCategoryView({required this.categoryName});

  @override
  State<_SubCategoryView> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends BaseStatefulWidgetState<_SubCategoryView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged(String value) {
    context.read<SubCategoryCubit>().setSearchQuery(value);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<SubCategoryCubit>().executeSearch();
    });
  }

  void _submitSearch() {
    _searchDebounce?.cancel();
    context.read<SubCategoryCubit>().executeSearch();
  }

  void _openFilterSheet(SubCategoryCubit cubit) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: colorWhite,
      barrierColor: colorBlack.withValues(alpha: 0.45),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _FilterBottomSheet(),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final currentExtent = _scrollController.offset;
    if (currentExtent >= (maxExtent - 320)) {
      context.read<SubCategoryCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CommonAppBar(
      title: widget.categoryName,
      leadingIc: SVGImages.icArrowBack,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      mainAxisExtent: 260.h,
    );

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heightBox(20.h),
          BlocBuilder<SubCategoryCubit, SubCategoryState>(
            buildWhen: (prev, next) {
              if (prev is! SubCategoryStateData || next is! SubCategoryStateData) {
                return true;
              }
              return prev.activeFilterCount != next.activeFilterCount;
            },
            builder: (context, state) {
              final filterCount =
                  state is SubCategoryStateData ? state.activeFilterCount : 0;
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextEditingWidget(
                    controller: _searchController,
                    hint: 'Search Product',
                    textInputAction: TextInputAction.search,
                    onChanged: _onSearchChanged,
                    onFieldSubmitted: (_) => _submitSearch(),
                    suffixIconWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _openFilterSheet(
                            context.read<SubCategoryCubit>(),
                          ),
                          child: Badge(
                            isLabelVisible: filterCount > 0,
                            label: Text('$filterCount'),
                            backgroundColor: colorCEAB8D,
                            textColor: color010103,
                            child: SvgPicture.asset(SVGImages.icFilter),
                          ),
                        ),
                        widthBox(16.w),
                        if (value.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              context.read<SubCategoryCubit>().setSearchQuery('');
                              context.read<SubCategoryCubit>().executeSearch();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 20.sp,
                              color: color79747E,
                            ),
                          ),
                        widthBox(8.w),
                        GestureDetector(
                          onTap: _submitSearch,
                          child: SvgPicture.asset(SVGImages.icSearch),
                        ),
                        widthBox(16.w),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          heightBox(20.h),
          Expanded(
            child: RefreshIndicator(
              color: colorPrimary,
              onRefresh: () =>
                  context.read<SubCategoryCubit>().refreshProducts(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  BlocBuilder<SubCategoryCubit, SubCategoryState>(
                    builder: (context, state) {
                      if (state is! SubCategoryStateData) {
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      }
                      final categoryState = state;
                      final products = categoryState.products;

                      if (categoryState.isInitialLoading && products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: AppLoader.centered(accentColor: colorCEAB8D),
                          ),
                        );
                      }

                      if (products.isEmpty) {
                        final emptyText = categoryState.errorMessage ??
                            (categoryState.isSearching ||
                                    categoryState.hasActiveFilters
                                ? 'No products match your search or filters'
                                : 'No products found');
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    categoryState.isSearching ||
                                            categoryState.hasActiveFilters
                                        ? Icons.search_off_rounded
                                        : Icons.inventory_2_outlined,
                                    size: 48.sp,
                                    color: colorD9D9D9,
                                  ),
                                  heightBox(12.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.w),
                                    child: TextWidget(
                                      text: emptyText,
                                      textAlign: TextAlign.center,
                                      textStyle: BaseTextStyle.text500.copyWith(
                                        fontSize: 14.sp,
                                        color: color79747E,
                                      ),
                                    ),
                                  ),
                                  if (categoryState.hasActiveFilters) ...[
                                    heightBox(16.h),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<SubCategoryCubit>()
                                          .resetFilterSelections(),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorE7E3DA,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: TextWidget(
                                          text: 'Clear filters',
                                          textStyle:
                                              BaseTextStyle.text600.copyWith(
                                            fontSize: 13.sp,
                                            color: color010103,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverMainAxisGroup(
                        slivers: [
                          SliverGrid(
                            gridDelegate: gridDelegate,
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final product = products[index];
                                return _buildCategoryItem(
                                  product,
                                  index,
                                  products,
                                );
                              },
                              childCount: products.length,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: true,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              child: Center(
                                child: categoryState.isLoadingMore
                                    ? const AppLoader.small(
                                        accentColor: colorCEAB8D,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(ProductListData product, int index,
      List<ProductListData> products) {
    final imageMedia = product.media?.firstWhere(
          (media) =>
      (media.mediaType ?? '').toLowerCase() == 'image' &&
          (media.url ?? '').isNotEmpty,
      orElse: () => Media(url: null),
    );
    final String? firstMediaUrl = imageMedia?.url?.isNotEmpty == true
        ? imageMedia?.url
        : (product.media != null && product.media!.isNotEmpty
        ? product.media!.first.url
        : null);
    return GestureDetector(
      onTap: () {
        navigate(
          enterPage: ProductReelScreen(
            productList: products,
            initialIndex: index,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: colorF7F7F7, borderRadius: BorderRadius.circular(16.r)),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(13.r),
                child: firstMediaUrl == null || firstMediaUrl.isEmpty
                    ? Container(color: colorE6E6E6)
                    : AppCachedImage(
                  memCacheWidth: 400,
                  memCacheHeight: 400,
                  imageUrl: firstMediaUrl,
                  fit: BoxFit.cover,
                  width: 165.w,
                  height: 160.h,
                ),
            ),
            heightBox(12.h),
            TextWidget(
              text: product.company?.name,
              textStyle: BaseTextStyle.text400.copyWith(
                  fontSize: 14.sp, color: color79747E),
            ),
            heightBox(8.h),
            TextWidget(
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              text: product.name,
              textStyle: BaseTextStyle.text600.copyWith(
                  fontSize: 14.sp, color: color09064A),
            ),
            heightBox(3.h),
          ],
        ),
      ),
    );
  }

}

// ── Filter bottom sheet ───────────────────────────────────────────────────────

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryCubit, SubCategoryState>(
      buildWhen: (prev, next) {
        if (prev is! SubCategoryStateData || next is! SubCategoryStateData) {
          return true;
        }
        return prev.isFiltersLoading != next.isFiltersLoading ||
            prev.filtersLoaded != next.filtersLoaded ||
            prev.filtersLoadError != next.filtersLoadError ||
            prev.companies != next.companies ||
            prev.colors != next.colors ||
            prev.materials != next.materials ||
            prev.selectedCompanyId != next.selectedCompanyId ||
            prev.selectedColorId != next.selectedColorId ||
            prev.selectedMaterialId != next.selectedMaterialId ||
            prev.activeFilterCount != next.activeFilterCount;
      },
      builder: (context, state) {
        if (state is! SubCategoryStateData) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<SubCategoryCubit>();
        final sheetHeight = MediaQuery.sizeOf(context).height * 0.72;

        if (state.isFiltersLoading && !state.filtersLoaded) {
          return SizedBox(
            height: sheetHeight,
            child: const Center(
              child: AppLoader(size: 28, accentColor: colorCEAB8D),
            ),
          );
        }

        if (state.filtersLoadError != null && !state.filtersLoaded) {
          return SizedBox(
            height: sheetHeight,
            child: _FilterErrorView(
              message: state.filtersLoadError!,
              onRetry: () => cubit.fetchFilters(force: true),
            ),
          );
        }

        return RepaintBoundary(
          child: SizedBox(
          height: sheetHeight,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: state.hasActiveFilters
                          ? () {
                              Navigator.pop(context);
                              cubit.resetFilterSelections();
                            }
                          : null,
                      child: TextWidget(
                        text: 'Reset',
                        textStyle: BaseTextStyle.text600.copyWith(
                          fontSize: 14.sp,
                          color: state.hasActiveFilters
                              ? colorCEAB8D
                              : colorD9D9D9,
                        ),
                      ),
                    ),
                    TextWidget(
                      text: state.hasActiveFilters
                          ? 'Filter (${state.activeFilterCount})'
                          : 'Filter',
                      textStyle: BaseTextStyle.text700.copyWith(
                        fontSize: 18.sp,
                        color: color09064A,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 32.sp,
                        width: 32.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.sp),
                          border: Border.all(color: color09064A, width: 1.sp),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: color09064A,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: colorE6E6E6, height: 1.sp),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: color09064A,
                unselectedLabelColor: color79747E,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.sp, color: colorE7E3DA),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Company'),
                  Tab(text: 'Colors'),
                  Tab(text: 'Material'),
                ],
              ),
              heightBox(8.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    _CompanyFilterTab(
                      companies: state.companies,
                      selectedCompanyId: state.selectedCompanyId,
                      cubit: cubit,
                    ),
                    _ColorsFilterTab(
                      colors: state.colors,
                      selectedColorId: state.selectedColorId,
                      cubit: cubit,
                    ),
                    _MaterialFilterTab(
                      materials: state.materials,
                      selectedMaterialId: state.selectedMaterialId,
                      cubit: cubit,
                    ),
                  ],
                ),
              ),
              heightBox(6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CommonButton(
                  text: 'Apply Now',
                  onTap: () {
                    Navigator.pop(context);
                    cubit.applyFilters();
                  },
                ),
              ),
              heightBox(12.h),
            ],
          ),
        ),
        );
      },
    );
  }
}

class _FilterErrorView extends StatelessWidget {
  const _FilterErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: color79747E),
            heightBox(12.h),
            TextWidget(
              text: message,
              textAlign: TextAlign.center,
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 14.sp,
                color: color79747E,
              ),
            ),
            heightBox(16.h),
            CommonButton(text: 'Retry', onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

class _CompanyFilterTab extends StatelessWidget {
  const _CompanyFilterTab({
    required this.companies,
    required this.selectedCompanyId,
    required this.cubit,
  });

  final List<CompanyListData> companies;
  final String? selectedCompanyId;
  final SubCategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const Center(child: Text('No companies available'));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: companies.length,
      separatorBuilder: (_, __) => SizedBox(height: 4.h),
      itemBuilder: (context, index) {
        final company = companies[index];
        final companyId = company.id?.toString();
        final isSelected =
            companyId != null && companyId == selectedCompanyId;

        return GestureDetector(
          onTap: () => cubit.toggleCompanyFilter(companyId),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorE7E3DA.withValues(alpha: 0.35)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: isSelected
                  ? Border.all(color: colorE7E3DA, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(42.sp),
                  child: (company.logoUrl != null &&
                          company.logoUrl.toString().isNotEmpty)
                      ? AppCachedImage(
                          memCacheWidth: 150,
                          memCacheHeight: 150,
                          imageUrl: company.logoUrl.toString(),
                          width: 42.w,
                          height: 42.h,
                          fit: BoxFit.cover,
                          errorAssetPath: PNGImages.imgThread1,
                        )
                      : Image.asset(
                          PNGImages.imgThread1,
                          width: 42.w,
                          height: 42.h,
                          fit: BoxFit.cover,
                        ),
                ),
                widthBox(14.w),
                Expanded(
                  child: TextWidget(
                    text: company.name ?? '',
                    fontSize: 16.sp,
                    color: isSelected ? color09064A : color79747E,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: colorCEAB8D, size: 20.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ColorsFilterTab extends StatelessWidget {
  const _ColorsFilterTab({
    required this.colors,
    required this.selectedColorId,
    required this.cubit,
  });

  final List<ColorListData> colors;
  final String? selectedColorId;
  final SubCategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const Center(child: Text('No colors available'));
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10.sp,
        mainAxisSpacing: 10.sp,
        mainAxisExtent: 56.sp,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final colorData = colors[index];
        final colorId = colorData.id?.toString();
        final isSelected =
            colorId != null && colorId == selectedColorId;
        final parsedColor = _hexToColor(colorData.hexCode?.toString());

        return GestureDetector(
          onTap: () => cubit.toggleColorFilter(colorId),
          child: Container(
            decoration: BoxDecoration(
              color: parsedColor,
              borderRadius: BorderRadius.circular(12.sp),
              border: isSelected
                  ? Border.all(color: colorCEAB8D, width: 3.w)
                  : Border.all(color: colorE6E6E6, width: 1),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: parsedColor.computeLuminance() > 0.5
                        ? colorBlack
                        : colorWhite,
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _MaterialFilterTab extends StatelessWidget {
  const _MaterialFilterTab({
    required this.materials,
    required this.selectedMaterialId,
    required this.cubit,
  });

  final List<MaterialsData> materials;
  final String? selectedMaterialId;
  final SubCategoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) {
      return const Center(child: Text('No materials available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: materials.map((material) {
          final materialId = material.id?.toString();
          final isSelected =
              materialId != null && materialId == selectedMaterialId;

          return FilterChip(
            label: TextWidget(
              text: material.name ?? '',
              fontSize: 14.sp,
              color: isSelected ? colorWhite : color09064A,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? colorCEAB8D : color79747E,
              width: 1.w,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.r),
            ),
            selectedColor: colorCEAB8D,
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => cubit.toggleMaterialFilter(materialId),
          );
        }).toList(),
      ),
    );
  }
}
