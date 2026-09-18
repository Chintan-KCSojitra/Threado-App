import 'dart:async';

import 'package:thredo/widget/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/company/company_profile_screen.dart';
import 'package:thredo/view/company/cubit/company_cubit.dart';
import 'package:thredo/widget/edit_text_widget.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/text_widget.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends BaseStatefulWidgetState<CompanyScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  late final CompanyCubit _companyCubit;
  late final PagingController<int, CompanyListData> _pagingController;

  @override
  void initState() {
    super.initState();
    _companyCubit = CompanyCubit();
    _pagingController = PagingController<int, CompanyListData>(
      getNextPageKey: (state) {
        final pages = state.pages;
        if (pages == null || pages.isEmpty) return 1;
        final last = pages.last;
        if (last.length < CompanyCubit.pageSize) return null;
        return pages.fold<int>(1, (total, page) => total + page.length);
      },
      fetchPage: (pageKey) =>
          _companyCubit.fetchCompaniesPage(pageKey: pageKey),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _pagingController.dispose();
    _companyCubit.close();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 380), () {
      _companyCubit.updateSearchText(value);
      _pagingController.refresh();
    });
  }

  void _onRefresh() {
    _companyCubit.updateSearchText(_searchController.text);
    _pagingController.refresh();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _companyCubit,
      child: ColoredBox(
        color: const Color(0xFFFAF9F7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(l10n),
            _buildSearchBar(),
            Expanded(child: _buildList()),
          ],
        ),
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
            text: l10n.navCompany,
            textStyle: BaseTextStyle.text700.copyWith(
              fontSize: 22.sp,
              color: color09064A,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 2.h),
          TextWidget(
            text: 'Discover verified thread suppliers',
            textStyle: BaseTextStyle.text400.copyWith(
              fontSize: 12.sp,
              color: color79747E,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      color: colorWhite,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: TextEditingWidget(
        controller: _searchController,
        hint: 'Search companies…',
        onChanged: _onSearchChanged,
        suffixIconWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(SVGImages.icSearch),
            SizedBox(width: 14.w),
          ],
        ),
      ),
    );
  }

  // ── List ──────────────────────────────────────────────────────────────────

  Widget _buildList() {
    return RefreshIndicator(
      color: colorCEAB8D,
      backgroundColor: colorWhite,
      strokeWidth: 2,
      onRefresh: () async => _onRefresh(),
      child: PagingListener<int, CompanyListData>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          return PagedListView<int, CompanyListData>(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            builderDelegate: PagedChildBuilderDelegate<CompanyListData>(
              itemBuilder: (_, item, index) => _CompanyCard(company: item),
              firstPageProgressIndicatorBuilder: (_) =>
                  _buildSkeletonList(),
              newPageProgressIndicatorBuilder: (_) => Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const AppLoader.small(accentColor: colorCEAB8D),
              ),
              noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(),
              firstPageErrorIndicatorBuilder: (_) => _buildErrorState(),
            ),
          );
        },
      ),
    );
  }

  // ── Skeleton ──────────────────────────────────────────────────────────────

  Widget _buildSkeletonList() {
    return Column(
      children: List.generate(
        6,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _SkeletonCompanyCard(),
        ),
      ),
    );
  }

  // ── Empty / error states ──────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business_outlined, size: 52.sp, color: colorD9D9D9),
            SizedBox(height: 12.h),
            TextWidget(
              text: 'No companies found',
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 14.sp,
                color: color79747E,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48.sp,
              color: colorD9D9D9,
            ),
            SizedBox(height: 12.h),
            TextWidget(
              text: 'Something went wrong',
              textStyle: BaseTextStyle.text400.copyWith(
                fontSize: 14.sp,
                color: color79747E,
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: _onRefresh,
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
}

// ── Company card ──────────────────────────────────────────────────────────────

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.company});

  final CompanyListData company;

  @override
  Widget build(BuildContext context) {
    final logoUrl = (company.logoUrl ?? '').toString().trim();
    final name = (company.name ?? '').trim().isEmpty ? 'Company' : company.name!;

    final location = [company.city, company.state, company.country]
        .whereType<String>()
        .where((v) => v.trim().isNotEmpty)
        .join(', ');

    final rating = company.averageRating ?? 0.0;
    final reviewCount = company.reviewCount ?? 0;
    final hasRating = rating > 0;

    return GestureDetector(
      onTap: () => navigate(
        enterPage: CompanyProfileScreen(
          company: company,
          isCompanyPortalProfile: true,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
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
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            children: [
              // ── Logo ──────────────────────────────────────────────────────
              _buildLogo(logoUrl),
              SizedBox(width: 14.w),

              // ── Info ──────────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    TextWidget(
                      text: name,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      textStyle: BaseTextStyle.text600.copyWith(
                        fontSize: 15.sp,
                        color: color09064A,
                      ),
                    ),

                    // Location
                    if (location.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12.sp,
                            color: color79747E,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: TextWidget(
                              text: location,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                              textStyle: BaseTextStyle.text400.copyWith(
                                fontSize: 11.sp,
                                color: color79747E,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Rating
                    if (hasRating) ...[
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            final filled = i < rating.round();
                            return Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 13.sp,
                              color: filled
                                  ? colorCEAB8D
                                  : colorD9D9D9,
                            );
                          }),
                          SizedBox(width: 5.w),
                          TextWidget(
                            text: rating.toStringAsFixed(1),
                            textStyle: BaseTextStyle.text600.copyWith(
                              fontSize: 11.sp,
                              color: colorCEAB8D,
                            ),
                          ),
                          if (reviewCount > 0) ...[
                            SizedBox(width: 3.w),
                            TextWidget(
                              text: '($reviewCount)',
                              textStyle: BaseTextStyle.text400.copyWith(
                                fontSize: 11.sp,
                                color: color79747E,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ── Arrow ─────────────────────────────────────────────────────
              SizedBox(width: 8.w),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3EF),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: colorCEAB8D,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(String logoUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: logoUrl.isEmpty
          ? Image.asset(
              PNGImages.imgCompany2,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.cover,
            )
          : AppCachedImage(
              imageUrl: logoUrl,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 200),
              showShimmer: true,
              errorAssetPath: PNGImages.imgCompany2,
            ),
    );
  }
}

// ── Skeleton card ─────────────────────────────────────────────────────────────

class _SkeletonCompanyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEEEEEE),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Logo placeholder
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(width: 14.w),
            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 10.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 10.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Arrow placeholder
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
