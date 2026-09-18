import 'package:thredo/widget/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/category_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/category/cubit/category_cubit.dart';
import 'package:thredo/view/category/cubit/category_state.dart';
import 'package:thredo/view/category/sub_category_screen.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/text_widget.dart';

import '../../res/image.dart';

// ── BLoC wrapper ──────────────────────────────────────────────────────────────

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenWrapperState();
}

class _CategoryScreenWrapperState extends State<CategoryScreen> {
  late final CategoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CategoryCubit()..loadInitialCategories();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const _CategoryView(),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _CategoryView extends StatefulWidget {
  const _CategoryView();

  @override
  State<_CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends BaseStatefulWidgetState<_CategoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final cur = _scrollController.offset;
    if (cur >= max - 200) {
      context.read<CategoryCubit>().loadMoreCategories();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is! CategoryStateData) {
                  return const SizedBox.shrink();
                }
                return _buildContent(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      color: colorWhite,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: l10n.screenCategory,
            textStyle: BaseTextStyle.text700.copyWith(
              fontSize: 22.sp,
              color: color09064A,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 2.h),
          TextWidget(
            text: 'Browse all thread categories',
            textStyle: BaseTextStyle.text400.copyWith(
              fontSize: 12.sp,
              color: color79747E,
            ),
          ),
        ],
      ),
    );
  }

  // ── Content ───────────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, CategoryStateData state) {
    return RefreshIndicator(
      color: colorCEAB8D,
      backgroundColor: colorWhite,
      strokeWidth: 2,
      onRefresh: () => context.read<CategoryCubit>().refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // ── Skeleton / grid ──
          if (state.isInitialLoading && state.categories.isEmpty)
            _buildSkeletonGrid()
          else if (state.categories.isEmpty)
            _buildEmptyState(state)
          else
            _buildGrid(state.categories),

          // ── Load-more footer ──
          SliverToBoxAdapter(
            child: _buildFooter(state.isLoadingMore),
          ),
        ],
      ),
    );
  }

  // ── Skeleton ──────────────────────────────────────────────────────────────

  Widget _buildSkeletonGrid() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      sliver: SliverGrid(
        gridDelegate: _gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (_, __) => _SkeletonCard(),
          childCount: 6,
        ),
      ),
    );
  }

  // ── Empty / error ─────────────────────────────────────────────────────────

  Widget _buildEmptyState(CategoryStateData state) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 52.sp,
              color: colorD9D9D9,
            ),
            SizedBox(height: 12.h),
            TextWidget(
              text: state.errorMessage ?? 'No categories found',
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 14.sp,
                color: color79747E,
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => context.read<CategoryCubit>().refresh(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: colorCEAB8D,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextWidget(
                  text: 'Try Again',
                  textStyle: BaseTextStyle.text600.copyWith(
                    fontSize: 13.sp,
                    color: colorWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Grid ──────────────────────────────────────────────────────────────────

  SliverGridDelegate get _gridDelegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        mainAxisExtent: 210.h,
      );

  Widget _buildGrid(List<CategoryData> categories) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      sliver: SliverGrid(
        gridDelegate: _gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (_, index) => _CategoryCard(
            category: categories[index],
            onTap: () {
              final cat = categories[index];
              if (cat.id != null) {
                navigate(
                  enterPage: SubCategoryScreen(
                    categoryId: cat.id!,
                    categoryName: cat.name ?? 'Category',
                  ),
                );
              }
            },
          ),
          childCount: categories.length,
          addRepaintBoundaries: true,
          addAutomaticKeepAlives: true,
        ),
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter(bool isLoadingMore) {
    return SizedBox(
      height: 52.h,
      child: Center(
        child: isLoadingMore
            ? const AppLoader.small(accentColor: colorCEAB8D)
            : const SizedBox.shrink(),
      ),
    );
  }
}

// ── Category card ─────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final CategoryData category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageUrl ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.r),
                ),
                child: imageUrl.isEmpty
                    ? Image.asset(
                        PNGImages.imgThread1,
                        fit: BoxFit.cover,
                      )
                    : AppCachedImage(
                        imageUrl: imageUrl,
                        fadeInDuration: const Duration(milliseconds: 200),
                        showShimmer: true,
                        errorAssetPath: PNGImages.imgThread1,
                      ),
              ),
            ),

            // Name + arrow
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      text: category.name ?? 'Category',
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      textStyle: BaseTextStyle.text600.copyWith(
                        fontSize: 13.sp,
                        color: color09064A,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3EF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11.sp,
                      color: colorCEAB8D,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton card ─────────────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.r),
                ),
                child: const ColoredBox(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
